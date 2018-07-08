#utf-8 / абв
#test
#======================#
# jQuery 	1.11.1 #
# JjQueryUi 	1.11.2 #
#======================#

# 2014-10-02
#	+ параметр для init $.form_target - путь куда после insert/update сделать refresh
# 2014-12-19
#	+ автоматическая генерация полей базы для передаваемых скрытых полей


#=======================================================================================================================xCONTROLS MAIN UNIT
#===============================================================================supported controls and features
#$tControls:
#group		type		name	id	label		value		properties	classes		sql	required	bounds	file_type	file_ext	signature_checker_path	readonly
#
#person		-		+	+	-		-		-		-		-	-		-	-		-		-			+
#address	-		+	+	-		-		-		-		-	-		-	-		-		-			+
#textarea	-		+	+	+		+-		+-		+-		-	+-		-	-		-		-			+
#input		text/textarea	+	+	+		+-		+-		+-		-	+-		-	-		-		-			+
#input		button		+	+	-		+		+-		+-		-	-		-	-		-		-			+
#submit		-		+	+	-		+		+-		+-		-	-		-	-		-		-			+
#hr		-		-	-	-		-		-		-		-	-		-	-		-		-			+
#br		-		-	-	-		-		-		-		-	-		-	-		-		-			+
#radio		-		+	+	name~+{^#09}  	default~+{^#09}	-		-		+-	+-		-	-		-		-			+
#select		-		+	+	name~+{^#09} 	default~+{^#09}	-		+		+-	+-		-	-		-		-			+
#checkbox	-		+	+	+		+		+-		-		-	+-		-	-		-		-			+
#text		-		-	-	+		-		-		-		-	-		-	-		-		-			+
#inn		-		+	+	+		+-		+-		+-		-	+-		-	-		-		-			+
#ogrn		-		+	+	+		+-		+-		+-		-	+-		-	-		-		-			+
#tn_ved		-		+	+	+		+-		+-		+-		-	+-		-	-		-		-			+
#int		-		+	+	+		+-		+-		+-		-	+-		+-	-		-		-			+
#float		-		+	+	+		+-		+-		+-		-	+-		+-	-		-		-			+
#file		-		+	+	+		+-		+-		-		-	+-		-	+		+		-			+
#signed_xml	-		+	+	-		-		-		-		-	-		-	-		-		+			+


#	$hParsed_data
#		$.group[$tControls.group]
#		$.type[$tControls.type]
#		$.name[$tControls.name]
#		$.id[$tControls.id]
#		$.label[$tControls.label]
#		$.value[$tControls.value]
#		$.properties[$tControls.properties]
#		$.classes[$tControls.classes]
#		$.sql_query[^taint[sql][$tControls.sql_query]
#		$.required[$tControls.required]
#		$.bounds[$tControls.bounds]
#		$.file_type[$tControls.file_type]
#		$.file_ext[$tControls.file_ext]
#		$.form_id[$sForm_id]
#=======================================================================================================================
@CLASS
xcontrols

@OPTIONS
static
partial

@auto[filespec]

# gleb
#E:/home/vhosts/gsen/corp/www//req-p/xc/p/xcontrols_main.p
#	^filespec.save[./xc]
#E:/home/vhosts/gsen/corp/www/
#	^request:document-root.save[./dr]
	$sSystem_lib_path[^filespec.mid(^request:document-root.length[])]

	$sSystem_lib_path[^file:dirname[$sSystem_lib_path]]
#/req-p/xc/p

	$sSystem_lib_path[^sSystem_lib_path.mid(0;^sSystem_lib_path.length[]-1)]
#/req-p/xc/

	$sSystem_js_modules_path[${sSystem_lib_path}js/xcontrols_modules/]
#/req-p/xc/js/xcontrols_modules

	$jquery_path[${sSystem_lib_path}../xc_js/${MAIN:XC_JQUERY_CURRDIR}/]
#/req-p/xc-js/jquery-1.11.1/jquery-1.11.1.js

	$jquery_ui_path[${sSystem_lib_path}../xc_js/${MAIN:XC_JQUERY_UI_CURRDIR}/]
#/req-p/xc-js/jquery-ui-1.11.2/jquery-ui-1.11.2.js

	$jquery_styles_path[${sSystem_lib_path}../xc_style/${MAIN:XC_UI_CURRDIR}/xcontrols_ui/]
#/req-p/xc-style/ui-1/xcontrols_ui/

	$jquery_mousewheel_path[${sSystem_lib_path}../xc_js/${MAIN:XC_JQUERY_MOUSEWHEEL_CURRDIR}/]
#/req-p/xc-js/jquery-mousewheel-3.1.13/

	$jquery_fancybox_path[${sSystem_lib_path}../xc_js/${MAIN:XC_JQUERY_FANCYBOX_CURRDIR}/]
#/req-p/xc-js/fancybox-2.1.5/


#=====================xcontrols dedicated log
	$xcLogName[xc_log.txt]
	$xcProjectsTable[.projects]
	$xcLogPath[${sSystem_lib_path}log/${xcLogName}]
#=====================module parts use:
	^use[xcontrols_errors.p]
	^use[xcontrols_database.p]
	^use[xcontrols_serialization.p]
	^use[xcontrols_view.p]
	^use[xcontrols_search.p]
	^use[scroller.p]
# 	^use[xcontrols_macros.p]
#	^use[xcontrols_xml.p]
# 	^use[xcontrols_instructions.p]
	^use[${sSystem_lib_path}ver.p]

	^if(def $MAIN:TGM && $MAIN:TGM){
		^use[debug.p]
	}
#======================================

	$now[^date::now[]]

	$sConstructor_xml_name[form.xml]
	$sFlag_filename[form.flag]
	$sArchive_db_postfix[_archive]
	$sArchivePostfix[$sArchive_db_postfix]
	$sSerial_prefix[xcontrols_]

#	$textarea_default_style[constructor_textarea]
	$hJquery_ui_style[
		$.text[ui-widget ui-widget-content ui-corner-all]
		$.date[ui-widget ui-widget-content ui-corner-all]
		$.date_null[ui-widget ui-widget-content ui-corner-all]
		$.inn[ui-widget ui-widget-content ui-corner-all]
		$.ogrn[ui-widget ui-widget-content ui-corner-all]
		$.tnved[ui-widget ui-widget-content ui-corner-all]
		$.password[ui-widget ui-widget-content ui-corner-all]
		$.textarea[ui-widget-content ui-corner-all]
		$.select[ui-widget ui-widget-content ui-corner-all]
		$.float[ui-widget ui-widget-content ui-corner-all]
		$.int[ui-widget ui-widget-content ui-corner-all]
		$.int_null[ui-widget ui-widget-content ui-corner-all]
		$.file[ui-widget ui-widget-content ui-corner-all]
# 		$.xfile[ui-widget ui-widget-content ui-corner-all]
	]
	$group_input_size(50)

	$tSystem_fieldnames[^table::create{name
uuid
db_table_name
}]
	$tSystem_symbols[^table::create{symbol
||
~
|@|
%PARSER^{
%MACRO^{
#		убрано, т.к. может мешать "самопальным" макро-командам:		^}%
}]
	$tValueless_groups[^table::create{group
hr
br
text
button
submit
button_close
button_clear
}]
	$tAllowMultyControls[^table::create{control
xfile
}]

	$sRefrence_db_name[kw]
	$tLoadedJsModules[^table::create{module}]
	$sStaticFormName[form_static.htm]
	$sJavascriptErrorField[xcvar__javascript_error]
#============= спорная функция, т.к. загрузки xml увеличивает в 2 раза
# может подумать о глобальном объекте, xdoc -- а правила будут такие -- если объект отсутствует - то идект загрузка xml, а если есть -- то работа с ним
# тогда какую первую функцию дернут та и загрузит xml

#=========================================================================LOG EVERY PROJECT USING THIS FRAMEWORK VERSION
@reportSelf[][tProjects]
	^if(-f "${sSystem_lib_path}${xcProjectsTable}"){
		$tProjects[^table::load[${sSystem_lib_path}${xcProjectsTable}]]
		^if(!^tProjects.locate[project;$sProject_nick]){
			^tProjects.append[$sProject_nick]
			^tProjects.save[${sSystem_lib_path}${xcProjectsTable}]
		}
	}{
		$tProjects[^table::create{project}]
		^tProjects.append[$sProject_nick]
		^tProjects.save[${sSystem_lib_path}${xcProjectsTable}]
	}

#===================================================================================================LOG ANY EXCEPTIONS
@exLog[type;xcMessage;exception][sLogEntry;sEntry]
	$sLogEntry[Unknown error.]
	^switch[$type]{
		^case[sql]{
			$sLogEntry[SQL error. Query: $xcMessage]
		}
		^case[file]{
			$sLogEntry[File I/O error. Operation: $xcMessage]
		}
		^case[js]{
			$sLogEntry[JS error. Data: $xcMessage]
		}
	}
	$sEntry[
^now.sql-string[]. $sLogEntry
	Original message: "$exception.comment"
]
	^sEntry.save[append;$xcLogPath]

#===================================================================================================GET TABLE NAME MAIN
@get_table_name[sProject_nick][xdConstructor;nlDb_info]

	$xdConstructor[^xdoc::load[${sXml_folder_path}${sProject_nick}/${sConstructor_xml_name}]]

	$nlDb_info[^xdConstructor.select[.//form/database]]

	$result[^nlDb_info.0.selectString[string(child::table_name)]]

#===================================================================================================INIT
@form_init[hArgs][k;v]
	$hDataStorages[^hash::create[]]

	$sModules_path[$hArgs.system_class_xml_path]
#gleb
	^if(!def $sModules_path){$sModules_path[${sSystem_lib_path}p/xcontrols_modules/]}

#	признак, что хотим визуально отлаживать xml для формы:
	$bDebugXml(^if($hArgs.is_debug_form_xml){1}{0})
#/gleb
	$sXml_folder_path[$hArgs.user_xml_folder_path]

	$sUser_xcontrols_files[$hArgs.user_xcontrols_files_folder_path]
	$sFormTarget[$hArgs.form_target]
	$sProject_nick[$hArgs.project_nick]
	$bSave_compiled_xml($hArgs.is_save_xml)
#=======new data storages format implementation
	$sBinary_path[]
	^if($hArgs.binary_path is string){
		$hDataStorages.default[$hArgs.binary_path]
		$sBinary_path[$hArgs.binary_path]
	}
	^if($hArgs.binary_path is hash){
		^hArgs.binary_path.foreach[k;v]{
			$hDataStorages.$k[$v]
		}
	}

	$sTemp_path[$hArgs.temp_path]
	$sShow_form_document[$hArgs.uri_show_form]
	$sSave_data_document[$hArgs.uri_save_data]
	$bInitfile_enabled($hArgs.enable_initfile)

	$isStaticForm($hArgs.is_static_form)

	$BP[$hArgs.BP]
	^if(!def $BP){
		$BP[/]
	}

	$bErr_redirect(true)

	^if(!def $sTemp_path){
		$sTemp_path[/temp/]
	}

	^if(!def $sSave_data_document){
		$sSave_data_document[store.html]
	}

#=======means no redirect
	^if(!def $sShow_form_document){
		$bErr_redirect(false)
	}

	^if(!def $isStaticForm){
		$isStaticForm(false)
	}{
#======= for static form with is_static_form(true)
		$sStaticFormPath[${sXml_folder_path}${sProject_nick}/${sStaticFormName}]
	}

	$hTableCharset[^hash::create[
		$.charset[utf8]
		$.collate[utf8_unicode_ci]
	]]

	^if(def $hArgs.table_charset){
		$hTableCharset[^hash::create[$hArgs.table_charset]]
	}

#===================================================================================================HEADER GENERATION
@header[hArgs][sBase_path;sStyle_path;sJqui_theme;ver;sNoCache]
	$ver[^getVersion[]]

	$sNoCache[?ver=${ver}]
	^if($hArgs is hash){
		$sBase_path[$hArgs.BP]
		$sJqui_theme[$hArgs.theme]
	}{
		$sBase_path[$sSystem_lib_path]
		$sJqui_theme[smoothness]
	}

	^if($hArgs.BP eq ""){
#gleb
#		$sBase_path[/]
		$sBase_path[$sSystem_lib_path]
#/gleb
	}
	^if($hArgs.theme eq ""){
		$sJqui_theme[smoothness]
	}

	$isScroller(false)
	^if($hArgs.scroller == 1){
		$isScroller(true)
	}
	$sStyle_path[${sBase_path}style/xcontrols_ui/]

	$tThemes[^file:list[$sStyle_path]]

	^if(!^tThemes.locate[name;$sJqui_theme]){
		$sJqui_theme[smoothness]
	}

<!-----------------------------------------------------------------------------------------STYLES-->
		<link rel="stylesheet" href="${jquery_styles_path}${sJqui_theme}/jquery-ui.css" type="text/css"/>
		<link rel="stylesheet" href="${sBase_path}style/style.css${sNoCache}" type="text/css">
		<link rel="stylesheet" href="${sBase_path}style/media.css${sNoCache}" type="text/css">
<!------------------------------------------------------------------------------JQUERY INIT LOCAL-->
		<script src="${jquery_path}jquery.min.js"></script>
		<script src="${jquery_ui_path}datepicker_locale/datepicker-ru.js"></script>
		<script src="${jquery_ui_path}jquery-ui.min.js"></script>
		<script src="${jquery_ui_path}jquery-ui-extentions.js${sNoCache}"></script>
		<script src="${sBase_path}js/detect.min.js${sNoCache}"></script>
		<script src="${sBase_path}js/addclear.js${sNoCache}"></script>
		<script src="${sBase_path}js/xc.js${sNoCache}"></script>

	^if($hArgs.scroller == 1){
		<link rel="stylesheet" href="${sBase_path}style/scroller.css${sNoCache}" type="text/css">
		<script src="${sBase_path}js/scroller.js${sNoCache}"></script>
	}

	^if($hArgs.print == 1){
		<script src="${sBase_path}js/noprint.js${sNoCache}"></script>
	}

	$isFloatingHeader(0)
	^if($hArgs.floating_header == 1){
		$isFloatingHeader(1)
		<link rel="stylesheet" href="${sBase_path}style/floating_header.css${sNoCache}" type="text/css">
		<script src="${sBase_path}js/floating_header.js${sNoCache}"></script>
	}

	^if($hArgs.foto == 1){
		<link rel="stylesheet" type="text/css" href="${jquery_fancybox_path}jquery.fancybox.css?v=2.1.5" media="screen" />
		<style>

#			патч стандартного fancybox css - т.к. на нашем corp проекте при hover картинка исчезала

			#fancybox-loading, .fancybox-close, .fancybox-prev span, .fancybox-next span {
				background-image: url('${jquery_fancybox_path}fancybox_sprite.png') !important
			}

#			лечим от максовой "подсветки" всех ссылок
			a.fancybox-close:hover,
			a.fancybox-prev:hover,
			a.fancybox-next:hover {
				background-color: transparent !important
			}

#			для того, чтобы в IE8 было видно границу окна просмотра - а то в IE8 - оч плохо смотреть (там нет теней)
			.fancybox-skin {
				border:	1px #667 solid !important
			}
		</style>

		<script src="${jquery_mousewheel_path}jquery.mousewheel.min.js"></script>
		<script src="${jquery_fancybox_path}jquery.fancybox.pack.js?v=2.1.5"></script>

		<script src="${sBase_path}js/foto_fancybox.js${sNoCache}"></script>
	}

<!------------------------------------------------------------------------------------INIT SCRIPT-->

		<script type="text/javascript">

			local_lib_init()^;

	^if($hArgs.scroller == 1){
			scroller_handler()^;
	}

	^if($hArgs.foto == 1){
			foto_fancybox_init()^;
	}

		</script>

#===================================================================================================EMPTY TEMP FOLDER
@empty_temp[period;i][tTemp;f;dtCreate;now;now_sql]
	$now[^date::now[]]

	^if((def $period) && (def $i) && (($period eq "day")||($period eq "month")||($period eq "year"))){
		^now.roll[$period](^eval(0 - ${i}))
	}{
		^now.roll[day](-1)
	}

	^if(-d "${sTemp_path}"){
		$tTemp[^file:list[$sTemp_path]]
		^tTemp.menu{
			$f[^file::load[text;${sTemp_path}$tTemp.name]]
			$dtCreate[$f.cdate]
			^if($dtCreate < $now){
				^file:delete[${sTemp_path}$tTemp.name]
			}

		}
	}
#===================================================================================================PRINT SIZEOF
@printSizeof[raw_size][iFile_size_mb]

	$iFile_size_mb(^eval($raw_size / (1024*1024)))

	^if($iFile_size_mb >= 1024){

		^if(^eval($iFile_size_mb /1024) > 1024){
			$result[^eval($iFile_size_mb / 1024 / 1024)[%0.f] ТБайт]
		}{

			$result[^eval($iFile_size_mb / 1024)[%0.f] ГБайт]
		}
	}

	^if($iFile_size_mb >= 1 && $iFile_size_mb < 1024){
		$result[^iFile_size_mb.format[%.0f] МБайт]
	}

	^if($iFile_size_mb < 1 ){
		^if($iFile_size_mb <= 0.0009){
			$result[^eval($iFile_size_mb * 1024 * 1024)[%.0f] Байт]
		}{
			$result[^eval($iFile_size_mb * 1024)[%.0f] кБайт]
		}
	}
#===================================================================================================NODE LIST TO STRING
@NlToHash[nlInput][hOutput;sBuf;sOutput;id;value;sLabels;sValues;sProp]
	$sLabels[]
	$sValues[]

	^nlInput.foreach[id;value]{
		$sLabels[${sLabels}|@|^value.selectString[string(label)]]
		$sValues[${sValues}|@|^value.selectString[string(value)]]
	}
	$hOutput[
		$.labels[^sLabels.trim[left;|@|]]
		$.values[^sValues.trim[left;|@|]]
	]
	$result[$hOutput]

#===================================================================================================DEBUG STOP & RET VALUE
@ret[var]
	^if(def $MAIN:TGM && $MAIN:TGM){
		^use[debug.p]
		^dstop[$var]
	}
#========test function for PARSER: macros
@inc[val]
	$result[^eval($val + 1)]
#===================================================================================================REPLACE TABS BY SPACES
@untab[data]
	$result[^data.match[\s+][g][ ]]
#===================================================================================================EXECUTE MACROS
@ExecuteMacros[macro][sMacro_func;sMacro_args;sMacro_namespace;sRoll;dtNow;iRoll;tArgs;sNow_sql;tMacro_func;tMacro_arg;sMacro_arg]
	$sMacro_namespace[$macro.1]
	$sMacro_body[$macro.2]

	^switch[$sMacro_namespace]{
		^case[PARSER]{
			^if(^sMacro_body.pos[%MACRO{] != -1){
				$sMacro_body[^sMacro_body.match[%(MACRO){(.+)}%][mg]{^ExecuteMacros[$match]}]
			}
			$result[^process{^taint[as-is][$sMacro_body]}]
		}
		^case[MACRO]{

			^if(^sMacro_body.pos[%MACRO{] != -1){
				$sMacro_body[^sMacro_body.match[%(MACRO){(.+)}%][mg]{^ExecuteMacros[$match]}]
			}

#			$tMacro_func[^sMacro_body.match[(.+)\((.+)\)][]]
			$tMacro_func[^sMacro_body.match[^^([^^\(]+)\((.+)\)^$][]]
#^dstop[$tMacro_func]
			$sMacro_func[$tMacro_func.1]
			$sMacro_args[$tMacro_func.2]

			^switch[$tMacro_func.1]{
				^case[now]{
					$tArgs[^sMacro_args.split[,;lh]]

					^if(^tArgs.count[cells] > 1){
						^try{
							$sRoll[^^eval($tArgs.1)]
							$iRoll(^process{$sRoll})
						}{
							$exception.handled(true)
							$iRoll($tArgs.1)
						}
						$dtNow[^date::create($now + $iRoll)]
					}{
						$dtNow[^date::now[]]
					}
					$result[^dtNow.sql-string[$tArgs.0]]
				}
				^case[test]{
					$result[$sMacro_args]
				}
				^case[number]{
					^switch[$sMacro_args]{
#===============================================works only with view.xml
						^case[current_row]{
							^if(def $form:xcpage){
								$result[^eval($iViewCurrentRow + ^eval($RPP*($form:xcpage - 1)))]
							}{
								$result[$iViewCurrentRow]
							}
						}
						^case[page_row]{
							$result[$iViewCurrentRow]
						}
						^case[total_rows]{
							$result[$iViewTotalRows]
						}
#===============================================works only with view.xml
					}
				}
				^case[form]{
					^if($sMacro_args ne ""){
						$result[$form:[$sMacro_args]]
					}
				}
				^case[sql]{
					^if($sMacro_args ne ""){
						^connect[$MAIN:CS]{

							$result[^string:sql{
								^taint[as-is][$sMacro_args]
							}]
						}
					}
				}
			}
		}
	}
#===================================================================================================CONSUME XML DOCUMENT
@consumeXml[text;path;isReadonly][tMatches;sTag;tPrefix;tFile;sPrefix;sFile;tSubst;sFilepath;bNoFile;sContent;isRo]
	$tMatches[^text.match[(<include_xml>.+<\/include_xml>)][sUg]]

	$tSubst[^table::create{from	to}]
	^if(!def $path){
		$path[${sXml_folder_path}${sProject_nick}]
	}{
		$path[^file:dirname[$path]]
	}
	^tMatches.menu{
		$sTag[$tMatches.1]
		$isRo(false)
		^if(^sTag.match[<readonly\/>][sU] || def $isReadonly){
			$isRo(true)
		}
		$tPrefix[^sTag.match[<prefix>(.+)<\/prefix>][sU]]
		$tFile[^sTag.match[<file>(.+)<\/file>][sU]]

		$sPrefix[^tPrefix.1.trim[]]
		$sFile[^tFile.1.trim[]]

		^if(def $sPrefix || $sPrefix ne ""){
			$sPrefix[${sPrefix}_]
		}{
			$sPrefix[]
		}

		$bNoFile(false)
		^try{
			$sFilepath[${path}/${sFile}]
#			$path[${sXml_folder_path}${sProject_nick}/${sFile}]
#			$sFilepath[${sXml_folder_path}${sProject_nick}/${sFile}]
			$f[^file::load[text;$sFilepath]]
		}{
			$exception.handled(true)
			$bNoFile(true)
			^ErrorList_main[CRASH_INCLUDE_FILE_NOT_FOUND]
		}
		^if(!$bNoFile){
			$sContent[^f.text.match[(<!--.+-->)][isUg][]]
			^if($isRo){
				$sContent[^sContent.match[<control_name>(.+)<\/control_name>][sUg]{<control_name>${sPrefix}$match.1</control_name><readonly/>}]
			}{
				$sContent[^sContent.match[<control_name>(.+)<\/control_name>][sUg]{<control_name>${sPrefix}$match.1</control_name>}]
			}
			^tSubst.append[$tMatches.1	$sContent]
		}
	}
	$text[^text.replace[$tSubst]]
	^while(^text.match[(<include_xml>.+<\/include_xml>)][sUg]){
		$text[^consumeXml[$text;$sFilepath;^if($isRo){true}]]
	}
	$result[$text]
#============================================================================================EXECUTE SYMBOL SUBSTITUTION
@ExecuteSubst[sDoc][sNewDoc;sReShy;sReHtml;sReEntity]
	$sNewDoc[$sDoc]
	$sReShy[(?<=[а-яA-Z-])(\|)(?=[а-яA-Z])]
	$sReHtml[~([A-Za-z\/]+)~]
# 	$sReEntity[%([A-Z]+)^;{0,1}%]
	$sReEntity[%([A-Z]+|#[0-9]+)^;{0,1}%]

	$sNewDoc[^sNewDoc.match[$sReShy][gU]{&amp^;shy^;}]
	$sNewDoc[^sNewDoc.match[$sReHtml][gU]{&lt^;$match.1&gt^;}]
	$sNewDoc[^sNewDoc.match[$sReEntity][gU]{&amp^;^match.1.lower[]^;}]

	$result[$sNewDoc]
#================================================================================================PREPROCESS XML DOCUMENT
@preprocess[fDocument][sDocument;match]

#================================================================remove comments
	$sDocument[$fDocument.text]

	$sDocument[^sDocument.match[(<!--.+-->)][isUg][]]
#================================================================consume files
	$sDocument[^consumeXml[$sDocument]]

# ====== TODO NEW PARSER & MACRO CONCEPT
# 	$sDocument[^sDocument.match[>([^^<]+%(PARSER|MACRO)[^^<]+)<\/][g]{^XtractMacros[$match]}]
#========================================================search & execute macros
	$sDocument[^sDocument.match[%(PARSER|MACRO){(.+)}%][mg]{^ExecuteMacros[$match]}]
#=========================================================search & execute subst
	$sDocument[^ExecuteSubst[$sDocument]]
#================================================================remove tab & CRLF
	$sDocument[^sDocument.match[\s+][g][ ]]

	$result[$sDocument]

#===================================================================================================GET TABLENAME
# для совместимости с функцией, добавленной major 30.08.2015 и по сути делающей то же самое
#@GetTablename[][xdConstructor;sConstructor_xml_path;nlDb_info;sTable_name]
@GetTablename[]
	$result[^get_table_name[$sProject_nick]]

#	$sConstructor_xml_path[${sXml_folder_path}${sProject_nick}/]
#	$xdConstructor[^xdoc::load[${sConstructor_xml_path}${sConstructor_xml_name}]]
#	$nlDb_info[^xdConstructor.select[.//form/database]]
#	$sTable_name[^nlDb_info.0.selectString[string(child::table_name)]]
#	$result[$sTable_name]

#===================================================================================================PARSE CONFIG XML
@parse_XML[sForm_id;sRecursive][nlAllowMulty;sControlMulty;sControlAllowMulty;sControlDataStorage;sTable;sControl_sublabel_show_on;sControl_sublabel;nlReadonly;sReadonly;nlInitfile;sInitfile;sFile_ext;sFile_type;sBounds;sBound_min;sBound_max;sBound_type;sBound_message;bound_id;bound_value;nlBounds;sProcessed;fDocument;tMacro_match;sMacro_command;sMacro_arg;sTest;sRequired;nlRequired;sControl_sql;nlControl_list;nlControl_inner;xdConstructor;hOptions_list;sOptions_list;nlControl_list;tControls;isMultiple;sControl_group;sControl_type;sControl_name;sControl_id;sControl_label;sOptions_list;hControl_values_list;sControl_values_list;hControl_props_list;sControl_props_list;hOptions;sControl_default_value;sSignatureCheckerPath]
#==============================XML,определяющие сложные классы (2 итерация),
#===========================================передаются с именем и расширением

	^if(def $sRecursive){
		$fDocument[^file::load[text;${sModules_path}${sForm_id}]]
	}{
		$fDocument[^file::load[text;${sXml_folder_path}${sProject_nick}/${sConstructor_xml_name}]]
	}
#============================создание XDOC на основе
#====================результата работы препроцессора
	$xdConstructor[^xdoc::create{^taint[as-is][^preprocess[$fDocument]]}]
	^if($bSave_compiled_xml && (!def $sRecursive)){
		^xdConstructor.save[${sXml_folder_path}${sProject_nick}/compiled_${sConstructor_xml_name}]
	}
 	$sTable[^xdConstructor.selectString[string(.//form/database/table_name)]]

	$nlControl_list[^xdConstructor.select[.//form/control]]
	$tControls[^table::create{xc_tablename	group	type	name	id	label	sublabel	sublabel_show_on	value	properties	classes	sql_query	required	initfile	bounds	file_type	file_ext	signature_checker_path	readonly	data_storage	multy	allow_multy}]

	^nlControl_list.foreach[id;value]{

		$sTest[^value.selectString[string()]]

		^tSystem_symbols.menu{
			^if(^sTest.pos[$tSystem_symbols.symbol] ne -1){
				^throw[system.symbol;$sTest;xControls module -> System reserved symbol used! Check form.xml]
			}
		}

		$isMultiple(false)
#===============================================================================xpath
		$sControl_group[^value.selectString[string(child::control_group)]]
		$sControl_group[^sControl_group.trim[]]

		$sControl_type[^value.selectString[string(child::control_type)]]
		$sControl_type[^sControl_type.trim[]]
# ==============multy count. possible : true,1,n,none
		$sControlMulty[^value.selectString[string(child::control_group/@multy)]]
		$sControlMulty[^sControlMulty.trim[]]

		$sControl_name[^value.selectString[string(child::control_name)]]
		$sControl_name[^sControl_name.trim[]]

		^if(^tSystem_fieldnames.locate[name;$sControl_name]){
			^throw[system.fieldname;$sControl_name;xControls module -> System reserved fieldname used! Check form.xml]
		}

		$sControl_id[^value.selectString[string(child::control_id)]]
		$sControl_id[^sControl_id.trim[]]
#====================================================================if no id tag - create my own ID
		^if(!def $sControl_id){
			$sControl_id[${sControl_name}_^math:uid64[]]
		}

		$sControl_label[^value.selectString[string(child::control_label)]]
		$sControl_label[^sControl_label.trim[]]

		$sControl_sublabel[^value.selectString[string(child::control_sublabel)]]
		$sControl_sublabel[^sControl_sublabel.trim[]]

#		$sControl_sublabel_show_on[print]
		$sControl_sublabel_show_on[]
		$sControl_sublabel_show_on[^value.selectString[string(child::control_sublabel/@media)]]

		$nlOptions[^value.select[control_options/child::*]]

		^if(def $nlOptions){
			$isMultiple(true)

			$hOptions[^NlToHash[$nlOptions]]
			$sOptions_list[$hOptions.labels]

			$sControl_default_value[^value.selectString[string(child::control_default_value)]]
			$sControl_default_value[^sControl_default_value.trim[]]

			$sControl_values_list[${sControl_default_value}~${hOptions.values}]

			$sControl_props_list[^value.selectString[string(child::control_properties)]]
			$sControl_props_list[^sControl_props_list.trim[]]

		}{
			$sControl_label[^value.selectString[string(child::control_label)]]
			$sControl_label[^sControl_label.trim[]]

			$sControl_values_list[^value.selectString[string(child::control_default_value)]]
			$sControl_values_list[^sControl_values_list.trim[]]

			$sControl_props_list[^value.selectString[string(child::control_properties)]]
			$sControl_props_list[^sControl_props_list.trim[]]
		}

#		$sControl_label[^sControl_label.match[\t+][g][]]
#		т.к. в препроцессоре уже все лишнее удалили
#		$sControl_label[^sControl_label.replace[^#09; ]]

		$sControl_classes[^value.selectString[string(control_classes)]]
		$sControl_classes[^sControl_classes.trim[]]

		$sControl_sql[^value.selectString[string(control_sql)]]
		$sControl_sql[^sControl_sql.trim[]]

#===============================================================================required
		$sRequired[]
		$nlRequired[^value.select[required]]

		^if(def $nlRequired){
			$sRequired[data-required="true"]
		}
#=======================================================================allow control multiplication
		$sControlAllowMulty[]
		$nlAllowMulty[^value.select[allow_multy]]

		^if(def $nlAllowMulty){
			^if(^tAllowMultyControls.locate[control;$sControl_group]){
				$sControlAllowMulty[data-allow_multy="true"]
			}{
				^throw[system.unallowed_multy;$sControl_group;xControls xml -> "allow_multy" node for this goup is invalid! Check form.xml]
			}
		}
#===============================================================================readonly

		$sReadonly[]
		$nlReadonly[^value.select[readonly]]
		^if(def $nlReadonly){
# 			причина данного присвоения ниже - данные передаются в таблицу, преобразуясь в строку
			$sReadonly[readonly]
		}

#===============================================================================initfile
		$nlInitfile[^value.select[accept_initfile]]
		^if(def $nlInitfile){
			$sInitfile[allow]
		}{
			$sInitfile[]
		}
#==============================================================================file field processing
		$sFile_type[^value.selectString[normalize-space(file_type)]]
		$sFile_type[^sFile_type.trim[]]

		$sFile_ext[^value.selectString[normalize-space(file_ext)]]
		$sFile_ext[^sFile_ext.trim[]]

		$sFile_type[^sFile_type.replace[\s;]]
		$sFile_ext[^sFile_ext.replace[\s;]]
#========================================================================sign xml control processing
		$sSignatureCheckerPath[^value.selectString[string(child::signature_checker_path)]]
		$sSignatureCheckerPath[^sSignatureCheckerPath.trim[]]
#==================================================================================bounds processing
		$nlBounds[^value.select[bounds]]
		$sBounds[]
		^nlBounds.foreach[bound_id;bound_value]{
			$sBound_min[^bound_value.selectString[string(@min)]]
			$sBound_min[^sBound_min.trim[]]

			$sBound_max[^bound_value.selectString[string(@max)]]
			$sBound_max[^sBound_max.trim[]]

			$sBound_type[^bound_value.selectString[string(@type)]]
			$sBound_type[^sBound_type.trim[]]

			$sBound_message[^bound_value.selectString[string(@message)]]
			$sBound_message[^sBound_message.trim[]]

			$sBounds[$sBounds data-bound_${bound_id}_max="${sBound_max}" data-bound_${bound_id}_min="${sBound_min}" data-bound_${bound_id}_type="${sBound_type}" data-bound_${bound_id}_message="${sBound_message}"]
		}
#==================================================================================data storage node
		$sControlDataStorage[]
		$sControlDataStorage[^value.selectString[string(child::data_storage)]]
		$sControlDataStorage[^sControlDataStorage.trim[]]

		^if(def $sControlDataStorage){
			^if(!^hDataStorages.contains[$sControlDataStorage]){
# 				no such data storage
				^if(^hDataStorages.contains[default]){
# 					default present
					$sControlDataStorage[$hDataStorages.default]
				}{
# 					no default either
					^throw[system.unknown_data_storage;$sControl_name;xControls control definition -> No such data_storage "$sControlDataStorage" defined in init method. No "default" data storage either. Check ^^form_init[]]
				}

			}{
# 				data sorage found
				$sControlDataStorage[$hDataStorages.$sControlDataStorage]
			}
		}{
			^if(!^hDataStorages.contains[default]){
# 				no default data storage specified
# 				^throw[system.no_default_data_storage;$sControl_name;xControls init error -> No "default" data storage path specified in ^^form:init[] method.]
			}{
# 				default data storage found
				$sControlDataStorage[$hDataStorages.default]
			}
		}
#=============================================================================control table creation
		^if($isMultiple){
# 			means control has multiple options to coose from
			$sControl[$sTable	^sControl_group.replace[^#09; ]	^sControl_type.replace[^#09; ]	^sControl_name.replace[^#09; ]	^sControl_id.replace[^#09; ]	${sControl_label}||${sControl_sublabel}~${sOptions_list}		$sControl_sublabel_show_on	^sControl_values_list.replace[^#09; ]	^sControl_props_list.replace[^#09; ]	^sControl_classes.replace[^#09; ]	^sControl_sql.replace[^#09; ]	^sRequired.replace[^#09; ]	^sInitfile.replace[^#09; ]					$sReadonly	$sControlDataStorage	$sControlMulty	$sControlAllowMulty]
		}{
# 			means control don't have multiple options to coose from
			$sControl[$sTable	^sControl_group.replace[^#09; ]	^sControl_type.replace[^#09; ]	^sControl_name.replace[^#09; ]	^sControl_id.replace[^#09; ]	${sControl_label}	${sControl_sublabel}	$sControl_sublabel_show_on	^sControl_values_list.replace[^#09; ]	^sControl_props_list.replace[^#09; ]	^sControl_classes.replace[^#09; ]	^sControl_sql.replace[^#09; ]	^sRequired.replace[^#09; ]	^sInitfile.replace[^#09; ]	^sBounds.replace[^#09; ]	^sFile_type.replace[^#09; ]	^sFile_ext.replace[^#09; ]	^sSignatureCheckerPath.replace[^#09; ]	$sReadonly	$sControlDataStorage	$sControlMulty	$sControlAllowMulty]
		}
		^tControls.append[$sControl]
	}
#^dstop[$tControls]
	$result[$tControls]
#================================================================================================ADD JS MODULE REFERENCE
@includeJs[sJsName][tJsModules;sNoCache]
	^if(!^tLoadedJsModules.locate[module;${sJsName}.js]){
		$tJsModules[^file:list[$sSystem_js_modules_path;\.js^$]]

		^if(^tJsModules.locate[name;${sJsName}.js]){
			$sNoCache[?ver=^getVersion[]]
			<script src="${sSystem_js_modules_path}${sJsName}.js"></script>
			<script type="text/javascript">
				${sJsName}_init()^;
			</script>
			^tLoadedJsModules.append[${sJsName}.js]
		}
	}
@includeExternalJs[sJsName][tJsModules;sNoCache]
	^if(!^tLoadedJsModules.locate[module;${sJsName}.js]){

		$tJsModules[^file:list[${sUser_xcontrols_files}controls_js/;\.js^$]]

		^if(^tJsModules.locate[name;${sJsName}.js]){
			$sNoCache[?ver=^getVersion[]]
			<script src="${sUser_xcontrols_files}controls_js/${sJsName}.js"></script>
			<script type="text/javascript">
				${sJsName}_init()^;
			</script>
			^tLoadedJsModules.append[${sJsName}.js]
		}
	}
@getFormMethod[sProject_nick][sMethod;xd]
	$xd[^xdoc::load[${sXml_folder_path}${sProject_nick}/${sConstructor_xml_name}]]
	$sMethod[^xd.selectString[string(.//form/@method)]]
	^if(!def $sMethod){
 		$sMethod[POST]
 	}
 	$result[$sMethod]
#===================================================================================================CREATE FORM ENTRY POINT
@create_form[sForm_id;hHidden_fields;hInit][sValue;tControls;sFields;hInitFile;fk;fv;sFileInit;value;field_name;hData;k;v;iErrCnt;hErr;hAnalysedError;formCompiled;sForm;fForm;isStatic]
#====================================^^^^^-initial values hash
#====================================for @edit_form function
	<div class="xcontrols_div" style="display:none^;">
	^if(def $form:initfile){
		$hInitFile[^ParseInitfile[$form:initfile]]
	}
	^if($bInitfile_enabled && $hInitFile is hash){
		^if(^hInitFile.contains[err]){
			^initfile[$hInitFile.err]
			$hInit[]
		}{
			^initfile[]
			$hInit[$hInitFile]
		}
	}
	^if($bInitfile_enabled && !($hInitFile is hash)){
		^initfile[]
	}
	$sForm[]
	$isStatic(false)
	^if($isStaticForm){
		^if(-f "$sStaticFormPath"){
			$fForm[^file::load[text;$sStaticFormPath]]
			$sForm[^taint[as-is][$fForm.text]]
			$isStatic(true)
		}
	}
	^if(!$isStatic){
		$sForm[
			<form method="^getFormMethod[$sForm_id]" action="${sSave_data_document}" class="xform" enctype="multipart/form-data">
#========================================if error detected
				^if(def $form:failed_id){

					$hData[^deserialize[$form:failed_id]]

					^if(def $hData.fields.uuid){
# 						means we are deserializing form from edit
						$tControls[^parse_XML[$sForm_id]]
						$sFields[]
						^tControls.menu{
							^if($tControls.readonly eq "true"){
								^if(! ^hData.fields.contains[$tControls.name]){
									$sValue[]
									^connect[$MAIN:CS]{
										$sValue[^string:sql{
											SELECT
												`$tControls.name`
											FROM
												`$tControls.xc_tablename`
											WHERE
												`uuid`='$hData.fields.uuid'
										}]
									}
									$hData.fields.[$tControls.name][$sValue]
								}

							}

						}
					}

					^if($hData.err.cnt_err > 0){
						$hErr[$hData.err.hErr]
						$iErrCnt($hData.err.cnt_err)
						<div class="alert">
							<h4>Отправка формы отменена. Обнаружены ошибки.</h4>
							<table cellpadding="10">
								^hErr.foreach[k;v]{
									$hAnalysedError[^AnalyseError[$sForm_id;$v]]
									<tr>
# 										if javascript error from client side
										^if($hAnalysedError.fieldname eq $sJavascriptErrorField){
											<td class="align_right"></td>
										}{
											<td class="align_right">Ошибка в поле "$hAnalysedError.fieldname" - </td>
										}
										<td>$hAnalysedError.message</td>
									</tr>
								}
							</table>
							<hr>
						</div>
					}
#^ret[$hData.fields]
					^xcontrols:create_controls[$sForm_id;;;$hData.fields]
				}{
					^if($hInit is hash){
						^xcontrols:create_controls[$sForm_id;;;$hInit]
					}{
						^xcontrols:create_controls[$sForm_id]
					}
				}

				^if($hHidden_fields is hash){
					^hHidden_fields.foreach[field_name;value]{
						<input type="hidden" name="$field_name" value="$value" />
					}
				}
				<input type="hidden" id="$sJavascriptErrorField" name="$sJavascriptErrorField" value="1" />
			</form>
		</div>
		<noscript>
			<p class='alert'>
			JavaScript в браузере выключен. Для отображения формы ввода информации необходимо, чтобы JavaScript был включен.
			<br><br>
			В случае возникновения затруднений с включением JavaScript обратитесь к системному администратору.
			</p>
		</noscript>
		]
		^if($isStaticForm){
			^sForm.save[$sStaticFormPath]
		}
	}
	$sForm
#===================================================================================================PRINT LABEL & SUBLABEL
@printLabel[hData][sControl_sublabell;sClass;d]
$result[
	<td class="align_right">
		^printLabel_content[$hData]
	</td>
]

@printLabel_content[hData][sControl_sublabell;sClass;d]
		$sControl_sublabel[$hData.sublabel]

		^if($sControl_sublabel ne ""){

			$sClass[<span class="]
			$d(true)
			^switch[$hData.sublabel_show_on]{
				^case[screen;noprint]{
					$d(false)
					$sClass[${sClass}noprint">]
				}
				^case[print;noscreen]{
					$d(false)
					$sClass[${sClass}noscreen">]
				}
				^case[DEFAULT]{

				}
			}

			^if($d){
				$sControl_sublabel[<br><small>$sControl_sublabel</small>]
			}{
				$sControl_sublabel[${sClass}<br><small>$sControl_sublabel</small></span>]
			}
		}
		$result[
			${hData.label}${sControl_sublabel}
			^if($bDebugXml){
				<br>
				<span style='background:#cfa'>
					^if($hData.value is hash){
						^hData.value.foreach[k;v]{
							${hData.group} : $k
						}[<br>]
					}{
						${hData.group} : $hData.name
					}
				</span>
			}
		]

#===================================================================================================CREATE CONTROLS ENTRY POINT
@create_controls[sForm_id;sPrefix_name;sCustom_class;hInit][hParsed_data;sForm_xml_path;sControl;tControls;bIsExternal]
#====================================================^^^^^-initial values hash
#====================================================for @edit_form function
	^if(^sForm_id.right(4) eq '.xml'){
		$tControls[^parse_XML[$sForm_id;recursive]]
	}{
		$tControls[^parse_XML[$sForm_id]]
	}
#=means that it's not a recursevely created
#===========second-level control
	^if(!def $sPrefix_name){


#		<style>
#			table.xcontrols_main_table tr:first-child td:first-child^{
#				background-color : red^;
#				width : 33%^;
#			^}
#		</style>


		<table cellpadding="10" class="xcontrols_main_table">
	}

#============================================list available js modules
	^tControls.menu{
		$hParsed_data[
			$.group[$tControls.group]
			$.type[$tControls.type]
			$.name[$tControls.name]
			$.id[$tControls.id]
			$.label[$tControls.label]
			$.sublabel[$tControls.sublabel]
			$.sublabel_show_on[$tControls.sublabel_show_on]
			$.value[$tControls.value]
			$.defaultValue[$tControls.value]
			$.properties[$tControls.properties]
			$.classes[$tControls.classes]
			$.sql_query[^taint[sql][$tControls.sql_query]]
			$.required[$tControls.required]
			$.bounds[$tControls.bounds]
			$.file_type[$tControls.file_type]
			$.file_ext[$tControls.file_ext]
			$.form_id[$sForm_id]
			$.readonly[$tControls.readonly]

#		для мульти селекта / gl
			$.multy[$tControls.multy]
#		для файлов / gl
			$.allowMulty[$tControls.allow_multy]

			$.dataStorage[$tControls.data_storage]
		]
		$sControl[$tControls.group]

# 		this module is external
		$bIsExternal(false)
		^if(-f "${sSystem_lib_path}p/xcontrols_modules/${sControl}.p"){
# 			means system control use
			^use[${sSystem_lib_path}p/xcontrols_modules/${sControl}.p]
		}{
# 			means external user control use
			^if(-f "${sUser_xcontrols_files}/controls_p/${sControl}.p"){
				^use[${sUser_xcontrols_files}/controls_p/${sControl}.p]
				$bIsExternal(true)
			}{
# 				means there is no such file
				^throw[system.unknown_module;$sControl;xControls module -> No such module in core components or in user defined files folder "${sUser_xcontrols_files}/controls_p/"! Check form.xml]
			}
		}

		^if(def $sPrefix_name){
			$hParsed_data.name[${sPrefix_name}_$hParsed_data.name]
			$hParsed_data.classes[${sCustom_class} ${hParsed_data.classes}]
		}
#=======================if initial hash had been passed
		^if(def $hInit){

#===============================if not hr br text
			^if(!^tValueless_groups.locate[group;$hParsed_data.group]){
				$hParsed_data.value[^xcontrols:edit_preprocess_$sControl[$hInit;$hParsed_data]]
			}

		}

		<tr>
 			^try{
				^if($bIsExternal){
					^includeExternalJs[$hParsed_data.group]
				}{
					^includeJs[$hParsed_data.group]
				}
				^xcontrols:create_$sControl[$hParsed_data]
 			}{
#  				$exception.handled(true)
 			}
		</tr>
	}

	^if(!def $sPrefix_name){
		</table>
	}

#===================================================================================================EDIT FORM FUNCTION
@edit_form[sForm_id;sEntry_uuid][fake;hMsg;sGroup;tFieldnames;hHidden_fields;nlDb_info;tDb_fields;tControls;sDb_fields;xdConstructor;sTable_name;hEdit_values]

	$tControls[^parse_XML[$sProject_nick]]

	$xdConstructor[^xdoc::load[${sXml_folder_path}${sForm_id}/${sConstructor_xml_name}]]
	$nlDb_info[^xdConstructor.select[.//form/database]]
	$sTable_name[^nlDb_info.0.selectString[string(child::table_name)]]

	$fake[^check_db[]]

	^tControls.menu{
		^if(!def $tControls.name || ^tValueless_groups.locate[group;$tControls.group]){
			^continue[]
		}

		^use[xcontrols_modules/${tControls.group}.p]
		$sGroup[$tControls.group]
		$tFieldnames[^xcontrols:fieldnames_table_$sGroup[$tControls.name]]
		^if(^tFieldnames.count[] > 1){
			^tFieldnames.menu{
				$sDb_fields[$sDb_fields,`${tFieldnames.fieldname}`]
			}
		}{
			$sDb_fields[$sDb_fields,`$tControls.name`]
		}
	}

	$sDb_fields[`uuid`$sDb_fields]

	^connect[$MAIN:CS]{
		$tDb_fields[^table::sql{
			SELECT $sDb_fields
				FROM `$sTable_name`
			WHERE `uuid` = '$sEntry_uuid'
		}]
	}

#=======if no such entry in DB
	^if(def $tDb_fields){
		$hEdit_values[^tDb_fields.hash[uuid]]
		$hEdit_values[$hEdit_values.[$sEntry_uuid]]

		$hHidden_fields[
			$.uuid[$hEdit_values.uuid]
		]

		^create_form[$sForm_id;$hHidden_fields;$hEdit_values]
	}{
		^ErrorList_main[CRASH_EDIT_ENTRY]
	}
#===================================================================================================GET FIELD INFO
@get_info[uuid;fieldname][tControls;sGroup;hRet;sTablename]

	^if(def $fieldname){
		$tControls[^parse_XML[$sProject_nick]]
		$sGroup[]

		^if(^tControls.locate[name;$fieldname]){
			$sGroup[$tControls.group]
		}{
			^ErrorList_main[CRASH_UNKNOWN_FIELD_INFO]
		}
		^use[xcontrols_modules/${sGroup}.p]
		$result[^get_info_$sGroup[^GetTablename[];$uuid;$fieldname]]
	}{
		^ErrorList_main[CRASH_UNKNOWN_FIELD_INFO]
	}
#===================================================================================================PRINT FIELD INFO
@print_info[uuid;fieldname;separator][hInfo;k;v;i;f;sRet]
	$hInfo[^get_info[$uuid;$fieldname]]
	^if($hInfo is hash){
		$result[
		<ul>
			^if($hInfo.files is hash){
				<li>
				^hInfo.files.foreach[i;f]{
					<ul>
						<li><b>Файл ^eval(^eval($i)+1)</b></li>
					^hInfo._label.foreach[k;v]{
						<li>${v}${separator}${f.$k}</li>
					}
					</ul>
				}
				</li>
			}{
				^hInfo._label.foreach[k;v]{
					<li>${v}${separator}${hInfo.$k}</li>
				}
			}

		</ul>
		]
	}
#===================================================================================================GENERATE INITFILE TEMPLATE
@generate_initfile_template[sForm_id;sSavePath;sFilename][fDocument;xdConstructor;nlControl_list;sHeader;id;value;sBody;sEOF;sTempalte]
	$fDocument[^file::load[text;${sXml_folder_path}${sProject_nick}/${sConstructor_xml_name}]]
	$xdConstructor[^xdoc::create{^taint[as-is][^preprocess[$fDocument]]}]
	$nlControl_list[^xdConstructor.select[.//form/control[accept_initfile]]]

	$sHeader[<?xml version="1.0" encoding="UTF-8"?>
<document>
	<form>]

	$sEOF[	</form>
</document>]

	$sBody[]

	^nlControl_list.foreach[id;value]{
		$sControlName[^value.selectString[string(child::control_name)]]
		$sBody[$sBody
		<control>
			<control_name>$sControlName</control_name>
			<control_default_value></control_default_value>
		</control>
]
	}
	$sTemplate[${sHeader}${sBody}${sEOF}]
	^if(!def $sSavePath){
		$sSavePath[$sTemp_path]
	}
	^if(!def $sFilename){
		$sFilename[initfile_template]
	}
	^sTemplate.save[${sSavePath}${sFilename}.xml]
#===================================================================================================UPLOAD INIT FILE FORM
@initfile[hError][fname;f;isLoaded;isError]
	$isLoaded(false)
	$isError(false)
	^if(def $form:initfile){
		$isLoaded(true)
		$fname[$form:initfile.name]
	}
	^if($hError is hash){
		$isError(true)
		$sErrorText[$hError.message]
	}
	<script>
  		^$(function() {
    			^$( "#initfile_submit" ).button()^;
  		})^;
  	</script>
	<form method="POST" class="xform_initfile" enctype="multipart/form-data">
		<div>
			<table cellpadding="10">
				<tr>
					<td class="align_right">Загрузка файла инициализации<br><small>Допустимое расширение: xml</small></td>
					<td><input type="file" id="initfile_field" name="initfile" class="$hJquery_ui_style.text" maxlength="250" size="100" /></td>
					<td><input type="submit" id="initfile_submit" class="initfile_submit" value="Загрузить"/></td>
					^if($isLoaded && !$isError){
						<td>Загружены данные из файла : $fname</td>
					}
					^if($isLoaded && $isError){
						<td>$sErrorText</td>
					}
				</tr>
			</table>
		</div>
	</form>
	<hr>
#===================================================================================================UPLOAD INIT FILE FORM
@ParseInitfile[initfile][xdConstructor;tControls;nlControlList;sControlName;sControlDefaultValue]

	$hRet[^hash::create[]]
	^if(^initfile.name.match[^^.+\.xml^$]){
		$fInitfile[^file::create[$initfile;$.mode[text]]]
		^if(def $fInitfile.text){
			$tControls[^parse_XML[$sProject_nick]]

			$xdConstructor[^xdoc::create[$fInitfile]]
			$nlControlList[^xdConstructor.select[.//form/control]]

			^nlControlList.foreach[id;value]{
				$sControlName[^value.selectString[string(child::control_name)]]
				$sControlDefaultValue[^value.selectString[string(child::control_default_value)]]
				^if(^tControls.locate[name;$sControlName]){
					^if($tControls.initfile eq "allow"){
						$hRet.[$sControlName][$sControlDefaultValue]
					}
				}{
					$hRet.err[^hash::create[]]
					$hRet.err[
						$.message[Ошибка в поле "$sControlName" : ^ErrorList_main[UNKNOWN_INITFILE_FIELD]]
					]
				}
			}

			^tControls.menu{
				^if(^hRet.contains[$tControls.name] || !def $tControls.name){^continue[]}
				$hRet.[$tControls.name][$tControls.value]
			}
		}

	}{
		$hRet.err[^hash::create[]]
		$hRet.err[
			$.message[Ошибка файла $initfile.name : ^ErrorList_main[INVALID_INITFILE_FORMAT]]
		]
	}

	$result[$hRet]
#===================================================================================================CHECK CONTROL DATA
@check_data[][hRet;hErr;tControls]
^rem{
$h[
   $.cnt_err(2)
   $.hErr[
      $.1[
         $.err_fieldname[file_test]
         $.message[FILE VALUE TYPE OR EXTENSION MISMATCH]
         $.err_module[FILE.TYPE_MISMATCH]
         $.err_main[MAIN.INVALID_VALUE]
      ]
      $.2[
         $.err_fieldname[file_test_2]
         $.message[FILE VALUE TYPE OR EXTENSION MISMATCH]
         $.err_module[FILE.TYPE_MISMATCH]
         $.err_main[MAIN.INVALID_VALUE]
      ]
   ]
   $.failed_id[B795CD36-126A-4E29-AE11-407C79C6D91A]
]
}
	$hRet[^hash::create[]]
	$hRet.cnt_err(0)
	$hRet.hErr[^hash::create[]]
	$hRet.failed_id[^math:uuid[]]

	$tControls[^parse_XML[$sProject_nick]]

	^tControls.menu{
		$sControl[$tControls.group]
		^if(!def $tControls.name || ^tValueless_groups.locate[group;$tControls.group]){
			^continue[]
		}

		^use[xcontrols_modules/${tControls.group}.p]
		^switch[$tControls.group]{
			^case[signed_xml]{
				$sgnChecker[$tControls.signature_checker_path]
				^xcontrols:check_$sControl[$tControls.name;$form:fields;$sgnChecker;$hRet]
			}
			^case[DEFAULT]{}
		}

	}

	^if($hRet.cnt_err == 0 && $bErr_redirect){
		$response:refresh[
			$.value(0)
			$.url[$sFormTarget]
		]
	}{
		$result[$hRet]
	}



#===================================================================================================GLEB STRANGE METHODS

#	это тут из-за того что в двух локальных контролах они используются -- нужно думать как эти методы назхвать
#	итогово, а так же как использовать везде


@xc_classname[nick_control;nick_input]
$result[xc_${nick_control}^if(def $nick_input){_${nick_input}}]

@xc_inputname[name;nick_input]
$result[${name}^if(def $nick_input){_${nick_input}}]

@xc_idname[id;nick_input]
$result[${id}^if(def $nick_input){_${nick_input}}]

@xc_is_field_readonly[hData]
^if(def $hData.readonly){
	$result(true)
}{
	$result(false)
}

#===================================================================================================/GLEB STRANGE METHODS
