<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<jsp:useBean id="person" scope="request" class="first.PersonBean"/>
<html>
<link href="http://code.jquery.com/ui/1.10.4/themes/ui-lightness/jquery-ui.css" rel="stylesheet"></link>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js" ></script>
<script src="http://code.jquery.com/jquery-1.10.2.js"></script>
<script src="http://code.jquery.com/ui/1.10.4/jquery-ui.js"></script>

<script>

$(function() {
	 var URL_PREFIX = "http://54.213.21.75:8983/solr/clirv2/select?q=_text_:";
	 var URL_SUFFIX = "&wt=json";
	 $("#input").autocomplete({
	 	source : function(request, response) {
		 	var URL = URL_PREFIX + $("#input").val() + URL_SUFFIX;
		 	$.ajax({
		 		url : URL,
		 		success : function(data) {
		 			var docs = JSON.stringify(data.response.docs);
		 			var jsonData = JSON.parse(docs);
		 			var outArr = new Array(10);
		 			//alert(jsonData[0].text);
		 			for(var p=0; p<10; p++){
		 				var origText = jsonData[p].text.toString().toUpperCase();
		 				var queryText = document.getElementById('input').value.toString().toUpperCase();
		 				var index = origText.indexOf(" " + queryText);
		 				if(index!=-1){
		 					var len = jsonData[p].text.toString().length-1;
		 					var subStrg = jsonData[p].text.toString().substring(index, len);
		 					var res = subStrg.split(/,| /);
		 					var resLen = res.length;
		 					var idx = 0;
		 					var subStr = "";
		 					if(idx < resLen){
		 						subStr = subStr+" "+res[idx];
		 						idx++;
		 					}
		 					if(idx < resLen){
		 						subStr = subStr+" "+res[idx];
		 						idx++;
		 					}
		 					if(idx < resLen){
		 						subStr = subStr+" "+res[idx];
		 						idx++;
		 					}
		 					if(idx < resLen){
		 						subStr = subStr+" "+res[idx];
		 						idx++;
		 					}
		 					jsonData[p].text = subStr;
		 					outArr[p]=subStr;
		 				}else{
		 					jsonData[p].text = "";
		 					outArr[p]="";
		 				}
		 			}
		 			var i = 0; 
		 			var j = 9;
		 			while(i<j){
		 				if(jsonData[i].text.toString().length == 0 && jsonData[j].text.toString().length != 0){
		 					jsonData[i].text = jsonData[j].text;
		 					jsonData[j].text = "";
		 					i++;
		 					j--;
		 				}else if(jsonData[i].text.toString().length == 0 && jsonData[j].text.toString().length == 0){
		 					j--;
		 				}else{
		 					i++;
		 				}
		 			}
		 			response($.map(jsonData, function(value, key) {
		 				return {
		 					label : value.text
		 				}
		 			}));
		 		},
		 		dataType : 'jsonp',
		 		jsonp : 'json.wrf'
		 	});
	 	},
	 	minLength : 1
	 })
});

function search(text){
	document.getElementById('input').value = text;
	SearchRes();
}

function trans(){
	var text = document.getElementById("fromTextArea").value;
	var from = document.getElementById("fromDDL").options[document.getElementById("fromDDL").selectedIndex].value;
	var to = document.getElementById("toDDL").options[document.getElementById("toDDL").selectedIndex].value;
	
	$.ajax({
        url:'TranslateText',
        data:{text:text, from:from ,to:to},
        type:'get',
        cache:false,
        success:function(responseJson){
        	document.getElementById("toTextArea").value = responseJson;
        },
        error:function(){
            alert('error');
        }
  	});
}

function searchEvent(e) {
    if (e.keyCode == 13) {
        SearchRes();
    }
}

function getLangFilters()
{
	var result = '';
	if(document.getElementById('chk_Lang_All').checked){
		result = result + '1';
	}else{
		result = result + '0';
	}
	if(document.getElementById('chk_Lang_Eng').checked){
		result = result + '1';
	}else{
		result = result + '0';
	}
	if(document.getElementById('chk_Lang_Spn').checked){
		result = result + '1';
	}else{
		result = result + '0';
	}
	if(document.getElementById('chk_Lang_Ger').checked){
		result = result + '1';
	}else{
		result = result + '0';
	}
	if(document.getElementById('chk_Lang_Fr').checked){
		result = result + '1';
	}else{
		result = result + '0';
	}
	return result;
}

function getRegFilters()
{
	var result = '';
	if(document.getElementById('chk_Reg_All').checked){
		result = result + '1';
	}else{
		result = result + '0';
	}
	if(document.getElementById('chk_Reg_US').checked){
		result = result + '1';
	}else{
		result = result + '0';
	}
	if(document.getElementById('chk_Reg_Mex').checked){
		result = result + '1';
	}else{
		result = result + '0';
	}
	if(document.getElementById('chk_Reg_Ger').checked){
		result = result + '1';
	}else{
		result = result + '0';
	}
	if(document.getElementById('chk_Reg_Fr').checked){
		result = result + '1';
	}else{
		result = result + '0';
	}
	return result;
}

function SearchRes()
{
	var searchText = document.getElementById('input').value
	var filterString = '';
	
	filterString = getLangFilters() + getRegFilters();
	
	if(searchText != ''){
		
		$.ajax({
		    url: 'SetSession',
		    data: {
		        text: searchText, filterString: filterString
		    },
		    type: 'GET',
		    success:function(x){
		    	window.location = "/first/Results";
			    return;
		    },
		    error:function(){
		          alert('error');
		    }
		});	
	}
}
function showAdvanced()
{
	if (document.getElementById('advanced').checked) {
		document.getElementById("advancedTab").style.visibility = "visible";
    } else {
    	document.getElementById("advancedTab").style.visibility = "hidden";
    }
}

function checkIfAllChecked()
{
	if (document.getElementById('chk_Lang_Eng').checked &&
			document.getElementById('chk_Lang_Spn').checked &&
			document.getElementById('chk_Lang_Ger').checked &&
			document.getElementById('chk_Lang_Fr').checked){
		return true;
	}
	else{
		return false;
	}
}

function checkIfAllRegionChecked()
{
	if (document.getElementById('chk_Reg_US').checked &&
			document.getElementById('chk_Reg_Mex').checked &&
			document.getElementById('chk_Reg_Ger').checked &&
			document.getElementById('chk_Reg_Fr').checked){
		return true;
	}
	else{
		return false;
	}
}

function checkIfAllUnChecked()
{
	if (document.getElementById('chk_Lang_Eng').checked == false &&
			document.getElementById('chk_Lang_Spn').checked == false &&
			document.getElementById('chk_Lang_Ger').checked == false &&
			document.getElementById('chk_Lang_Fr').checked == false){
		return true;
	}
	else{
		return false;
	}
}

function checkIfAllRegionUnChecked()
{
	if (document.getElementById('chk_Reg_US').checked == false &&
			document.getElementById('chk_Reg_Mex').checked == false &&
			document.getElementById('chk_Reg_Ger').checked == false &&
			document.getElementById('chk_Reg_Fr').checked == false){
		return true;
	}
	else{
		return false;
	}
}

function checkAllBoxes()
{
	document.getElementById('chk_Lang_All').checked = true;
	document.getElementById('chk_Lang_Eng').checked = true;
	document.getElementById('chk_Lang_Spn').checked = true;
	document.getElementById('chk_Lang_Ger').checked = true;
	document.getElementById('chk_Lang_Fr').checked = true;
}

function checkAllRegionBoxes()
{
	document.getElementById('chk_Reg_All').checked = true;
	document.getElementById('chk_Reg_US').checked = true;
	document.getElementById('chk_Reg_Mex').checked = true;
	document.getElementById('chk_Reg_Ger').checked = true;
	document.getElementById('chk_Reg_Fr').checked = true;
}

function LangClick(e)
{
	if(e.value == 'All'){
		if(e.checked == true){
			//Check all the checkboxes
			checkAllBoxes();
			}
		}
	else{
		if(e.checked == true){
			//Check if all are checked - Yes then check 'All'
			if(checkIfAllChecked()){
				document.getElementById('chk_Lang_All').checked = true;
				}
			}
		else{
			//Uncheck 'All'
			document.getElementById('chk_Lang_All').checked = false;
			//Check if all are unchecked - Yes then check All buttons
			if(checkIfAllUnChecked()){
				checkAllBoxes();
			}
		}
	}	
}

function RegClick(e)
{
	if(e.value == 'All'){
		if(e.checked == true){
			//Check all the checkboxes
			checkAllRegionBoxes();
			}
		}
	else{
		if(e.checked == true){
			//Check if all are checked - Yes then check 'All'
			if(checkIfAllRegionChecked()){
				document.getElementById('chk_Reg_All').checked = true;
				}
			}
		else{
			//Uncheck 'All'
			document.getElementById('chk_Reg_All').checked = false;
			//Check if all are unchecked - Yes then check All buttons
			if(checkIfAllRegionUnChecked()){
				checkAllRegionBoxes();
			}
		}
	}
		
}
</script>
<style>
body {
    position: relative;
    <!--background-image: url("Images/BG-Image.jpg");-->
    background-repeat: no-repeat;
    background-size: 100%
}

.trend{
	border-collapse:collapse;
}

.trend td{
	 border-bottom:1px solid black;
}

.color-blue {
	color: #005FAF;
}
.color-light-blue{
	color: #00A3E8;
}

td.container{
	height: 30px;
}

.color-dark-gray{
	color: #3C3C48;
}

.hand{
	cursor: pointer;
}

.bgcolor-blue{
	<!--background-color: #d3d3d3;-->
}

.ddl{
	width:150px;
	height: 30px;
	float: right;
}

.txt-area{
	width:100%;
	height: 60px;
	
}

#input_container { position:relative; padding:0; margin:0; }
#input { height:30px; margin:0;}

#input_img { position:absolute; bottom:8px; right:1%; top:5%; width:30px; height:30px; }

</style>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ChirpyBird</title>
</head>
<body>

<div>
	<div style="height:50px;float:left;">
	<br>
	<span><b>New to ChirpyBird? Click <span class="color-blue"><u>here</u></span> for a quick Demo</b></span>
	</div>
	<div style="height:50px;float:right;width:20%;">
	</div>
	<div style="padding-left:30%; padding-top:10%; float:left;">
		<img style="padding-left:30%;" src="Images/Bird.png" alt="Blue Bird" height="150" width="150">
		<br>
		<span style="padding-left:30%;font-size:30px">Chirpy<span class="color-blue"><b>Bird</b></span></span>
		<br>
		<br>
		<div id="input_container">
			<label for="input"></label>
    		<input id="input" type="text" style="font-size:12pt;"size="45" onkeypress="searchEvent(event)" autofocus>
    		<img style="cursor: pointer;" src="Images/Search-Icon.png" id="input_img" onClick="SearchRes()">
		</div>
		<br>
		<div style="float:right">
			<input type="checkbox" id="advanced" value="Yes" onclick="showAdvanced()"> Advanced Search<br>
		</div>
		<br>
		<div id="advancedTab" style="visibility:hidden">
			<hr/>
			<div>
				<table width="100%">
				<col width="50%">
		  		<col width="25%">
		  		<col width="25%">
				<tr>
					<td>Languages :</td>
					<td colspan="2"><input type="checkbox" id="chk_Lang_All" value="All" onclick = LangClick(this) checked> All</td>
				</tr>
				<tr>
					<td></td>
					<td><input type="checkbox" id="chk_Lang_Eng" value="English" onclick = LangClick(this) checked> English</td>
					<td><input type="checkbox" id="chk_Lang_Spn" value="Spanish" onclick = LangClick(this) checked> Spanish</td>
				</tr>
				<tr>
					<td></td>
					<td><input type="checkbox" id="chk_Lang_Ger" value="German" onclick = LangClick(this) checked> German</td>
					<td><input type="checkbox" id="chk_Lang_Fr" value="French" onclick = LangClick(this) checked> French</td>
				</tr>
				</table>
			</div>
			<br>
			<div>
				<table width="100%">
				<col width="50%">
		  		<col width="25%">
		  		<col width="25%">
				<tr>
					<td>Region :</td>
					<td colspan="2"><input type="checkbox" id="chk_Reg_All" value="All" onclick = RegClick(this) checked> All</td>
				</tr>
				<tr>
					<td></td>
					<td><input type="checkbox" id="chk_Reg_US" value="US" onclick = RegClick(this) checked> US</td>
					<td><input type="checkbox" id="chk_Reg_Mex" value="Mexico" onclick = RegClick(this) checked> Mexico</td>
				</tr>
				<tr>
					<td></td>
					<td><input type="checkbox" id="chk_Reg_Ger" value="Germany" onclick = RegClick(this) checked> Germany</td>
					<td><input type="checkbox" id="chk_Reg_Fr" value="France" onclick = RegClick(this) checked> France</td>
				</tr>
				</table>
			</div>
		</div>
	</div>
	<div style="padding-bottom:10px;float:right;background-color:#3C3C48;color:#f8f8ff;width:20%">
		<div style="padding-top:15px;background-color:#005FAF; height:35px;"><span style="margin-left:10px;"><b>Trending Now</b></span><br></div>
		<br>
		<span style="float:right;margin-right:10px;"><b>Tweet Count</b></span>
		<br>
		<table class="trend" style="margin-left:10px"width=95%>
		<tr >
			<td onClick="search('trump')" class="hand container">trump</td>
			<td class="container">101K</td>
		</tr>
		<tr>
			<td onClick="search('US')" class="hand container">US</td>
			<td class="container">5K</td>
		</tr>
		<tr>
			<td onClick="search('President')" class="hand container">President</td>
			<td class="container">4K</td>
		</tr>
		<tr>
			<td onClick="search('Election')" class="hand container">Election</td>
			<td class="container">2K</td>
		</tr>
		<tr>
			<td onClick="search('Secretary')" class="hand container">Secretary</td>
			<td class="container">1K</td>
		</tr>
		</table>
		<br>
		
		<div style="padding-top:15px;background-color:#005FAF; height:35px;"><span style="margin-left:10px;"><b>Quick Translate</b></span></div><br><br>
		
		<table style="margin-left:10px;" width=90%>
		<tr>
			<td>From :</td>
			<td>
				<select id="fromDDL" class="ddl">
		  			<option value="en">English</option>
		  			<option value="es">Spanish</option>
		  			<option value="de">German</option>
		  			<option value="fr">French</option>
				</select>
			</td>
		</tr>
		<tr>
			<td colspan=2><textarea id="fromTextArea" class="txt-area"></textarea></td>
		</tr>
		</table>
		<br>
		<input style="background-color:#005FAF;border:none;color:white;cursor:pointer;margin-left:10px;font-size: 16px; height:20px; width:90%" type="button" value="Translate!" onClick="trans()"/>
		<br>
		<br>
		<table style="margin-left:10px;" width=90%>
		<tr>
			<td>To :</td>
			<td>
				<select id="toDDL" class="ddl">
		  			<option value="en">English</option>
		  			<option value="es">Spanish</option>
		  			<option value="de">German</option>
		  			<option value="fr">French</option>
				</select>
			</td>
		</tr>
		<tr>
			<td colspan=2><textarea id="toTextArea" class="txt-area" readonly></textarea></td>
		</tr>
		</table>
	</div>
</div>

</body>
</html>