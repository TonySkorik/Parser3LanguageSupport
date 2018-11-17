#utf8 абв

# const_<API|CORP|MOD - uppercase>_<nick - lowercase>_<Name_const_set - copitalize case>

@postprocess[]
fsd

@qqq[]
константа пока всегда строка, даже если число внутри

2 типа констант - solid / enum

solid
	путь к директории с unismev
	$const:uni.UNISMEVPATH
	или
	$const:uni.UNISMEVPATH.value

enum
	набор констант состояния	
	$const:smev_request.Type_conformity.ERROR
	$const:smev_request.Type_conformity.OK

	или

	$const:smev_request.Type_conformity.ERROR.value

у константы:

value	значение			$const:uni.UNISMEVPATH		$const:smev_request.Type_conformity.ERROR

name	имя константы			UNISMEVPATH			ERROR
type	"тип" константы							Type_conformity
ns	"неймспейс"			uni				smev_request

is_solid				1				0
is_enum					0				1

label	краткое наименование		Путь Unismev			Отказ в приёме
info	описание			Содержит путь к Unismev.Exe	Отказ в приеме документов из-за ошибок в документах



#===========================================

@CLASS
const_MOD_rpn_opeka3_Type_conformity

@OPTIONS
locals
static

@USE
../system/hash_strict.p

#-------------------------------------------

@auto[]

$self.__db_name[smev_request]

#-------------------------------------------

@__get_ConstTableName[ns;type]
$result[const_^ns.lower[]^if($type ne ''){_^type.lower[]}]

#-------------------------------------------

#@GET[]
# общий GET по идее доджэен возвращать список всех кодов ошибок

#-------------------------------------------

@__init[]

$sDt_update[^string:sql{
	SELECT
		dt_update
	FROM
		`$self.NICK`.`$self.CLASS_NAME`
	ORDER BY
		dt_update DESC
	LIMIT
		1
}]

$is_need_init(1)

#^if($self.get_LastDtUpdate is junction){
	^if(	
		(^self.get_LastDtUpdate[] ne '')
		&&
		(^date::create[^self.get_LastDtUpdate[]] >= ^date::create[$sDt_update])
	){
		$is_need_init(0)
	}
#}

^if($is_need_init){
	$sParserCode[]

	$sParserCode[${sParserCode}#-------------------------------------------]
	$sParserCode[${sParserCode}^#0A]
	$sParserCode[${sParserCode}^#0A]

	$sParserCode[${sParserCode}^@get_LastDtUpdate^[^]]						$sParserCode[${sParserCode}^#0A]
	$sParserCode[${sParserCode}^$result^[$sDt_update^]]						$sParserCode[${sParserCode}^#0A]
	$sParserCode[${sParserCode}^#0A]
	$sParserCode[${sParserCode}^#0A]

	$tType_conformity[^table::sql{
		SELECT
			value
			,name
			,label
			,info
		FROM
			`smev_request`.`$self.CLASS_NAME`
		ORDER BY
			orderby, name
	}]

	$sParserCodeAllValue[]

	^tType_conformity.menu{
		$sParserCodeAllValue[${sParserCodeAllValue}^#09^$.$tType_conformity.name^[$tType_conformity.value^]^#0A]

		$sParserCode[${sParserCode}^@GET_$tType_conformity.name^[^]]						$sParserCode[${sParserCode}^#0A]
		$sParserCode[${sParserCode}^$result^[^^hash_strict::create^[]						$sParserCode[${sParserCode}^#0A]
		$sParserCode[${sParserCode}^#09^$.value^[$tType_conformity.value^]]					$sParserCode[${sParserCode}^#0A]
		$sParserCode[${sParserCode}^#09^$.name^[^apply-taint[parser-code][$tType_conformity.name]^]]		$sParserCode[${sParserCode}^#0A]
		$sParserCode[${sParserCode}^#09^$.label^[^apply-taint[parser-code][$tType_conformity.label]^]]		$sParserCode[${sParserCode}^#0A]
		$sParserCode[${sParserCode}^#09^$.info^[^apply-taint[parser-code][$tType_conformity.info]^]]		$sParserCode[${sParserCode}^#0A]
		$sParserCode[${sParserCode}^]^[readonly^]^]]								$sParserCode[${sParserCode}^#0A]
		$sParserCode[${sParserCode}^#0A]
		$sParserCode[${sParserCode}^#0A]
	}

	$sParserCode[${sParserCode}#-------------------------------------------]
	$sParserCode[${sParserCode}^#0A]
	$sParserCode[${sParserCode}^#0A]

	$sParserCode[${sParserCode}^@get_NameValuePair^[^]^#0A^$result^[^#0A$sParserCodeAllValue^]]
	$sParserCode[${sParserCode}^#0A]
	$sParserCode[${sParserCode}^#0A]

	$sParserCode[${sParserCode}#-------------------------------------------]
	$sParserCode[${sParserCode}^#0A]
	$sParserCode[${sParserCode}^#0A]


	^ds[$sParserCode]
}{
	$s[Module: ^self.get_LastDtUpdate[] and DB: $sDt_update => skip init]
	^ds[$s]
}

#-------------------------------------------

@check_value[v0]
$is_found(0)

$hPair[^self.get_NameValuePair[]]
^hPair.foreach[k;v]{
	^if($v0 eq $v){
		$is_found(1)
		^break[]
	}
}
$result[$is_found]


#-------------------------------------------

#@GET_NAME[]
#$result[^hash_strict::create[
##	$.name[NAME]
#	$.label[Решение по запросу]
#	$.info[]
#][readonly]]

#-------------------------------------------

@SET_DEFAULT[k;v]
^throw[$self.CLASS_NAME;^$${self.CLASS_NAME}:$k;All class properties are read-only]

@GET_DEFAULT[k]
^throw[$self.CLASS_NAME;^$${self.CLASS_NAME}:$k;Class property not found]

#-------------------------------------------

@get_LastDtUpdate[]
$result[2018-11-11 05:25:06]


@GET_YES[]
$result[^hash_strict::create[
	$.value[YES]
	$.name[YES]
	$.label[Соответствует]
	$.info[]
][readonly]]


@GET_NO[]
$result[^hash_strict::create[
	$.value[NO]
	$.name[NO]
	$.label[НЕ соответствует]
	$.info[]
][readonly]]


@GET_UNKNOWN[]
$result[^hash_strict::create[
	$.value[UNKNOWN]
	$.name[UNKNOWN]
	$.label[Отсутствует жилое помещение или неверно указан адрес]
	$.info[]
][readonly]]


@GET_ACCESSDENIED[]
$result[^hash_strict::create[
	$.value[ACCESSDENIED]
	$.name[ACCESSDENIED]
	$.label[Адрес верный, но нет доступа в помещение]
	$.info[]
][readonly]]


@GET_ERROR[]
$result[^hash_strict::create[
	$.value[ERROR]
	$.name[ERROR]
	$.label[Ошибка в запросе]
	$.info[]
][readonly]]


#-------------------------------------------

@get_NameValuePair[]
$result[
$.YES[YES]
$.NO[NO]
$.UNKNOWN[UNKNOWN]
$.ACCESSDENIED[ACCESSDENIED]
$.ERROR[ERROR]
]

#-------------------------------------------
