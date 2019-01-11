#===================================================================================================INPUT xCONTROL MODULE
@CLASS
xcontrols

@OPTIONS
static
partial

### <summary>
### Pstprocess method
### </summary>
### <param name=""></param>
### <returns>
### nothing
### </returns>
@postprocess[]
	this is postprocess method

#===================================================================================================CREATE BUTTON
@xcreate_button[hData]
	^switch[$hData.type]{
		^case[submit]{^case_submit[$hData]}
		^case[DEFAULT]{^case_button[$hData]}
	}

#===================================================================================================BUILD SIMPLE BUTTON
@case_button[hData]
	<script>
  		^$(function() {
    			^$( "#${hData.id}" ).button()^;
  		})^;
  	</script>
	<td colspan="2"><input
		type="button"
		id="$hData.id"
		value="$hData.value" 
		class="$hJquery_ui_style.[$hData.type] $hData.classes"
		$hData.properties
	 />
	</td>
#===================================================================================================BUILD SUBMIT
@case_submit[hData;hRet]
	<script>
		^$(function() {
   			^$( "#${hData.id}" ).button()^;
 
		})^;
	</script>
#	<td></td>
	<td>
		<input type="submit" id="$hData.id" value="$hData.value" 

		class="submit $hJquery_ui_style.[$hData.type] $hData.classes"

		$hData.properties
	 />
	</td>
	^sql[$CS]{
		SELECT * FROM T as test
		WHERE t > 1
		GRANT EXECUTE ON [dbo].[test] TO TestRole
	}
	^create_button[]
#===================================================================================================CREATE BUTTON
### <summary>
### Method summary
### Method summary continues
### </summary>
### <param name="hData">hData parameter</param>
### <param name="hData2">hData parameter2</param>
### <remarks>Test remarks</remarks>
### <returns>
### Method returns
### </returns>
@create_button[hData]
	^switch[$hData.type]{
		^case[submit]{^case_submit[$hData]}
		^case[DEFAULT]{^case_button[$hData]}
	}

### <summary>
### Method summary
### </summary>
### <param name="hData">hData</param>
### <returns>
### Method returns
### </returns>
@__create_button[hData]
	^switch[$hData.type]{
		^case[submit]{^case_submit[$hData]}
		^case[DEFAULT]{^case_button[$hData]}
	}

### <summary>
### Auto method
### </summary>
### <param name="hData">hData</param>
### <returns>
### Method returns
### </returns>
@auto[hData]
	^switch[$hData.type]{
		^case[submit]{^case_submit[$hData]}
		^case[DEFAULT]{^case_button[$hData]}
	}
