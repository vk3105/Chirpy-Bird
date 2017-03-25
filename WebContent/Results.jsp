<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js" ></script>
<link href="http://code.jquery.com/ui/1.10.4/themes/ui-lightness/jquery-ui.css" rel="stylesheet"></link>
<script src="http://code.jquery.com/jquery-1.10.2.js"></script>
<script src="http://code.jquery.com/ui/1.10.4/jquery-ui.js"></script>

<script>
var page = 1;

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

$( document ).ready(function() {
    var queryString = '<%= request.getSession().getAttribute("QueryString") %>';
    var FilterString = '<%= request.getSession().getAttribute("FilterString") %>';
    
    document.getElementById('input').value = queryString
    
    if(FilterString.charAt(0) == '0'){
    	document.getElementById('chk_Lang_All').checked = false;
    }
    if(FilterString.charAt(1) == '0'){
    	document.getElementById('chk_Lang_Eng').checked = false;
    }
    if(FilterString.charAt(2) == '0'){
    	document.getElementById('chk_Lang_Spn').checked = false;
    }
    if(FilterString.charAt(3) == '0'){
    	document.getElementById('chk_Lang_Ger').checked = false;
    }
    if(FilterString.charAt(4) == '0'){
    	document.getElementById('chk_Lang_Fr').checked = false;
    }
    
    if(FilterString.charAt(5) == '0'){
    	document.getElementById('chk_Reg_All').checked = false;
    }
    if(FilterString.charAt(6) == '0'){
    	document.getElementById('chk_Reg_US').checked = false;
    }
    if(FilterString.charAt(7) == '0'){
    	document.getElementById('chk_Reg_Mex').checked = false;
    }
    if(FilterString.charAt(8) == '0'){
    	document.getElementById('chk_Reg_Ger').checked = false;
    }
    if(FilterString.charAt(9) == '0'){
    	document.getElementById('chk_Reg_Fr').checked = false;
    }
 
    populateResults('1');
});

function search(text){
	document.getElementById('input').value = text;
	populateResults('1');
}

function trans(){
	var text = document.getElementById("fromTextArea").value;
	var from = document.getElementById("fromDDL").options[document.getElementById("fromDDL").selectedIndex].value;
	var to = document.getElementById("toDDL").options[document.getElementById("toDDL").selectedIndex].value;
	
	var output = translateText(text,from,to);
	document.getElementById("toTextArea").value = output;
	
}

function deleteTweet(code){
	var id = document.getElementById('id'+code.toString()).innerHTML;
	var queryURL = "http://54.213.21.75:8983/solr/clirv2/update?stream.body=<delete><query>id:"+id+"</query></delete>&commit=true"
	$.get(queryURL);
	alert("This tweet has been removed.\nThank you for helping us remove inappropriate content.");
}

function IndiTrans(code, lang)
{
	if(lang == 'English'){
			lang = 'en';
		}
	if(lang == 'Spanish'){
			lang = 'es';
		}
	if(lang == 'German'){
			lang = 'de';
		}
	if(lang == 'French'){
				lang = 'fr';
		}
	var text = document.getElementById('text'+code.toString()).innerHTML;
	var from = document.getElementById('lang'+code.toString()).innerHTML;
	var to = lang
	
	var tweetText = translateText(text,from,to);
	
	document.getElementById('text'+code.toString()).style.display = "none";
	document.getElementById('transtext'+code.toString()).innerHTML = tweetText;
	
}
		
function translateText(text,from,to)
{
	var res;
	$.ajax({
        url:'TranslateText',
        data:{text:text, from:from ,to:to},
        type:'get',
        cache:false,
        async: false,
        success:function(responseJson){
        	res = responseJson;
        },
        error:function(){
            res = ':( :( Unable to translate due to unrecognizable symbols :( :(';
        }
  	});
	
	return res;
}

function showMore(code)
{
	if(document.getElementById("showMore"+code.toString()).innerHTML == "Show More"){
		document.getElementById("more"+code.toString()).style.display = "block";
		document.getElementById("showMore"+code.toString()).innerHTML = "Show Less";
	}else{
		document.getElementById("more"+code.toString()).style.display = "none";
		document.getElementById("showMore"+code.toString()).innerHTML = "Show More";
		document.getElementById('trans'+code.toString()).style.display = "none";
		document.getElementById('text'+code.toString()).style.display = "block";
		document.getElementById('transtext'+code.toString()).innerHTML = "";
	}
}

function GoHome()
{
	window.location = "/first/Home";
}

function searchEvent(e) {
    if (e.keyCode == 13) {
    	populateResults('1');
    }
}

function getTranslatedText(text,lang)
{
	var result;
	
	var filteredLang = document.getElementById("translateAllDDL").options[document.getElementById("translateAllDDL").selectedIndex].value;
	
	if(filteredLang=='def' || filteredLang==lang){
		result = text;
	}
	else{
		result = translateText(text,lang,filteredLang)
	}
	
	return result;
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

function populateResults(code)
{
	var AllTweets=0;
	var EngTweets=0;
	var SpnTweets=0;
	var GerTweets=0;
	var FraTweets=0;
	var EngTweetsPer=0;
	var SpnTweetsPer=0;
	var GerTweetsPer=0;
	var FraTweetsPer=0;
	
	var AllTweets_Reg=0;
	var USTweets_Reg=0;
	var MexTweets_Reg=0;
	var GerTweets_Reg=0;
	var FraTweets_Reg=0;
	var USTweetsPer_Reg=0;
	var MexTweetsPer_Reg=0;
	var GerTweetsPer_Reg=0;
	var FraTweetsPer_Reg=0;
	
	document.getElementById("Loading").style.display = "block";
	document.getElementById("navigation").style.display = "none";
	document.getElementById("noResults").style.display = "none";
	
	//Close all the divs
	for(var k=1;k<11;k++){
		document.getElementById("result"+k.toString()).style.display = "none";
		document.getElementById("more"+k.toString()).style.display = "none";
		document.getElementById('trans'+k.toString()).style.display = "none";
		document.getElementById("showMore"+k.toString()).innerHTML = "Show More";
		document.getElementById('text'+k.toString()).style.display = "block";
		document.getElementById('transtext'+k.toString()).innerHTML = "";
	}
	
	if(code=='next'){
		page = page + 1;
	}
	else if(code=='prev'){
		page = page - 1;
	}
	else if(code == 'all'){
		page = 1;
	}
	else{
		page = parseInt(code)
	}
	
	document.getElementById('from').innerHTML = (page-1).toString() + "1";
	document.getElementById('to').innerHTML = (page).toString() + "0";
	
	for(var j=1;j<11;j++){
		document.getElementById("page"+j.toString()).style.color = "#005FAF";
	}
	
	document.getElementById("page"+page.toString()).style.color = "#111111";
	
	if(page==1){
		document.getElementById("prev").style.visibility = "hidden";
	}
	else{
		document.getElementById("prev").style.visibility = "visible";
	}
	if(page==10){
		document.getElementById("next").style.visibility = "hidden";
	}
	else{
		document.getElementById("next").style.visibility = "visible";
	}
	
	var query = document.getElementById('input').value
	var langFilter = getLangFilters();
	var regFilter = getRegFilters();
	$.ajax({
        url:'GetTweets',
        data:{queryString:query, langFilter:langFilter, regFilter:regFilter},
        type:'get',
        cache:false,
        success:function(responseJson){
        	var i = 1;
        	var iter = 1;
   	     	$.each(responseJson, function(index, tweet) {    // Iterate over the JSON array.
   	     		if(iter > ((page-1)*10) && i < 11){
   	     			 document.getElementById("result"+i.toString()).style.display = "block";
		   			 
		   			 var tweetText = getTranslatedText(tweet.text.toString(),tweet.language)
		   			 document.getElementById('text'+i.toString()).innerHTML = tweetText;
		   			 
		   			 var spanUserName = document.getElementById('username'+i.toString());
		   			 while( spanUserName.firstChild ) {
		   				 spanUserName.removeChild( spanUserName.firstChild );
		   			 }
		   			 spanUserName.appendChild(document.createTextNode(tweet.userName.toString()));
		   			 
		   			 var spanHandler = document.getElementById('handler'+i.toString());
		   			 while( spanHandler.firstChild ) {
		   				 spanHandler.removeChild( spanHandler.firstChild );
		   			 }
		   			 spanHandler.appendChild(document.createTextNode(tweet.userHandle.toString()));
		   			
		   			document.getElementById('id'+i.toString()).innerHTML = tweet.rank;
		   			var lang;
		   			if(tweet.language == 'en'){
	   	     			lang = 'English';
	   	     		}
	   	     		if(tweet.language == 'es'){
	   	     			lang = 'Spanish';
		     		}
	   	     		if(tweet.language == 'de'){
	   	     			lang = 'German';
	     			}
	   	  			if(tweet.language == 'fr'){
	   	  				lang = 'French';
	  				}
	   	  			
		   			document.getElementById('lang'+i.toString()).innerHTML = lang;
		   			document.getElementById('reg'+i.toString()).innerHTML = tweet.region;
		   			document.getElementById('tDate'+i.toString()).innerHTML = tweet.date;
		   			 
		   			i = i + 1;
   	     		}
   	     		if(tweet.language == 'en'){
   	     			EngTweets = EngTweets + 1;
   	     		}
   	     		if(tweet.language == 'es'){
   	     			SpnTweets = SpnTweets + 1;
	     		}
   	     		if(tweet.language == 'de'){
   	     			GerTweets = GerTweets + 1;
     			}
   	  			if(tweet.language == 'fr'){
   	  				FraTweets = FraTweets + 1;
  				}
   	  			
   	  			if(tweet.region != null){
   	  			if(tweet.region.startsWith('Pacific Time') ||
   	  				tweet.region.startsWith('Arizona') ||
   	  				tweet.region.startsWith('Mexico City') ||
   	  				tweet.region.startsWith('Eastern Time')){
	     			USTweets_Reg = USTweets_Reg + 1;
	     		}
	     		if(tweet.region.startsWith('Beijing') ||
	     				tweet.region.startsWith('Paris') ||
	     				tweet.region.startsWith('Brussels') ||
	     				tweet.region.startsWith('Casablanca') ||
	     				tweet.region.startsWith('Belgrade') ||
	     				tweet.region.startsWith('Ljubljana ') ||
	     				tweet.region.startsWith('London') ||
	     				tweet.region.startsWith('Amsterdam') ||
	     				tweet.region.startsWith('Greenland') ||
	     				tweet.region.startsWith('Hawaii ') ||
	     				tweet.region.startsWith('UTC') ||
	     				tweet.region.startsWith('Europe')){
	     			FraTweets_Reg = FraTweets_Reg + 1;
     			}
	     		if(tweet.region.startsWith('Bern') ||
	     				tweet.region.startsWith('Athens') ||
	     				tweet.region.startsWith('Berlin') ||
	     				tweet.region.startsWith('Brussels') ||
	     				tweet.region.startsWith('Stockholm') ||
	     				tweet.region.startsWith('Copenhagen') ||
	     				tweet.region.startsWith('Vienna ') ||
	     				tweet.region.startsWith('Tallinn') ||
	     				tweet.region.startsWith('Brasilia')){
	     			GerTweets_Reg = GerTweets_Reg + 1;
 				}
	  			if(tweet.region.startsWith('Bogota') ||
	  					tweet.region.startsWith('Lima') ||
	  					tweet.region.startsWith('Madrid') ||
	  					tweet.region.startsWith('Moscow ') ||
	  					tweet.region.startsWith('Quito') ||
	  					tweet.region.startsWith('Buenos') ||
	  					tweet.region.startsWith('Aires') ||
	  					tweet.region.startsWith('La Paz') ||
	  					tweet.region.startsWith('Georgetown') ||
	  					tweet.region.startsWith('Santiago') ||
	  					tweet.region.startsWith('Quito') ||
	  					tweet.region.startsWith('Jerusalem') ||
	  					tweet.region.startsWith('Moscow') ||
	  					tweet.region.startsWith('Lisbon')){
	  				
	  				MexTweets_Reg = MexTweets_Reg + 1;
				}
   	  			}
	   	        iter = iter +1;
   	        });
   	  	document.getElementById('total').innerHTML = (iter-1).toString();
   	  	if(iter-1 == 100){
   	  	document.getElementById('total').innerHTML = 'top '+ (iter-1).toString();
   	  	}
   	 	AllTweets = iter-1;
   	 	
   	 	EngTweetsPer = Math.floor((EngTweets/AllTweets)*100);
	 	SpnTweetsPer = Math.floor((SpnTweets/AllTweets)*100);
	 	GerTweetsPer = Math.floor((GerTweets/AllTweets)*100);
	 	FraTweetsPer = Math.floor((FraTweets/AllTweets)*100);
	 	
	 	USTweetsPer_Reg = Math.floor((USTweets_Reg/AllTweets)*100);
	 	MexTweetsPer_Reg = Math.floor((MexTweets_Reg/AllTweets)*100);
	 	GerTweetsPer_Reg = Math.floor((GerTweets_Reg/AllTweets)*100);
	 	FraTweetsPer_Reg = Math.floor((FraTweets_Reg/AllTweets)*100);
 	
	 	document.getElementById('EngBar').style.width = EngTweetsPer.toString() + '%';
	 	document.getElementById('SpnBar').style.width = SpnTweetsPer.toString() + '%';
	 	document.getElementById('GerBar').style.width = GerTweetsPer.toString() + '%';
	 	document.getElementById('FraBar').style.width = FraTweetsPer.toString() + '%';
	 	
	 	document.getElementById('USBar_Reg').style.width = USTweetsPer_Reg.toString() + '%';
	 	document.getElementById('MexBar_Reg').style.width = MexTweetsPer_Reg.toString() + '%';
	 	document.getElementById('GerBar_Reg').style.width = GerTweetsPer_Reg.toString() + '%';
	 	document.getElementById('FraBar_Reg').style.width = FraTweetsPer_Reg.toString() + '%';
	 	
	 	document.getElementById('Lang_All_Count').innerHTML = AllTweets.toString();
	 	document.getElementById('Lang_Eng_Count').innerHTML = EngTweets.toString();
	 	document.getElementById('Lang_Spn_Count').innerHTML = SpnTweets.toString();
	 	document.getElementById('Lang_Ger_Count').innerHTML = GerTweets.toString();
	 	document.getElementById('Lang_Fra_Count').innerHTML = FraTweets.toString();
	 	
	 	document.getElementById('Reg_All_Count').innerHTML = AllTweets.toString();
	 	document.getElementById('Reg_US_Count').innerHTML = USTweets_Reg.toString();
	 	document.getElementById('Reg_Mex_Count').innerHTML = MexTweets_Reg.toString();
	 	document.getElementById('Reg_Ger_Count').innerHTML = GerTweets_Reg.toString();
	 	document.getElementById('Reg_Fra_Count').innerHTML = FraTweets_Reg.toString();
	 	
	 	document.getElementById("Loading").style.display = "none";
	 	
	 	if(AllTweets == 0){
	 		document.getElementById("noResults").style.display = "block";	
	 	}else{
	 		document.getElementById("noResults").style.display = "none";
	 		document.getElementById("navigation").style.display = "block";
	 	}
        },
        error:function(){
          alert('error');
        }
	});
	window.scrollTo(0,0);
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

function LangOptions(code)
{
	document.getElementById('trans'+code).style.display = "block";
}

</script>
<style>
body {
    position: relative;
}
.trend{
	border-collapse:collapse;
}

.navigation{
	color: #005FAF;
	font-size: 30px;
	text-decoration: bold underline;
}

.tweet-title{
	color: #005FAF;
	float:right;
}

.show-more{
	font-size:13px;
	color: #005FAF;
	text-decoration: underline;
	cursor: pointer;
}

.hand{
	cursor: pointer;
}

.more-info{
	font-size:13px;
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

.bgcolor-blue{
	<!--background-color: #d3d3d3;-->
}

.ddl{
	width:150px;
	height: 30px;
	float: right;
}

.ddl-centre{
	width:150px;
	height: 30px;
	float: middle;
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
<title>ChirpyBird-Results</title>
</head>
<body>
<div>
	<div style="height:50px;float:left;width:80%;">
		<div style="float:left;margin-left:5%;cursor: pointer;" onClick="GoHome()">
			<span style="font-size:30px">&nbsp;&nbsp;Chirpy<span class="color-blue"><b>Bird</b>&nbsp;&nbsp;</span></span>
		</div>
		<div style="float:left;margin-left:10px;">
		<img style="cursor: pointer;" src="Images/Bird.png" alt="Blue Bird" height="40" width="40" onClick="GoHome()"/>
		</div>
		<div style="float:left;margin-left:5px;" id="input_container">
			<label for="input"></label>
    		<input id="input" type="text" style="font-size:12pt;"size="85" onkeypress="searchEvent(event)" autofocus/>
    		<img style="cursor: pointer;" src="Images/Search-Icon.png" id="input_img" onClick="populateResults('all')">
		</div>
	</div>
	<div style="height:50px;float:right;width:19%;">
	</div>
	<div style="float:left;padding-bottom:10px; width:20%;background-color:#3C3C48;color:#f8f8ff;">
		<div style="padding-top:15px;background-color:#005FAF; height:35px;">
			<span style="margin-left:10px;"><b>Filters</b></span>
			<br>
		</div>
		<br>
		<span style="margin-left:10px;">Translate all results to :</span><br><br>
		<select id="translateAllDDL" style="margin-left:20px;" class="ddl-centre">
			<option value="def">Default</option>
		  	<option value="en">English</option>
		  	<option value="es">Spanish</option>
		  	<option value="de">German</option>
		  	<option value="fr">French</option>
		</select><br><br>
		<hr style="border: 1px dotted black">
		<span style="margin-left:10px;">Languages :</span><br><br>
		<div style="margin-left:20px;">
		<table width=90%>
			<col width="60%">
		  	<col width="40%">
			<tr>
				<td><input type="checkbox" id="chk_Lang_All" value="All" onclick = LangClick(this) checked> All (<label id='Lang_All_Count'></label>)</td>
				<td><div style="background-color:#005FAF;color:gray;height:15px; width: 100%;"></div></td>
			</tr>
			<tr>
				<td><input type="checkbox" id="chk_Lang_Eng" value="English" onclick = LangClick(this) checked> English (<label id='Lang_Eng_Count'></label>)</td>
				<td><div id = "EngBar" style="background-color:#005FAF;height:15px; width: 0%;"></div></td>
			</tr>
			<tr>
				<td><input type="checkbox" id="chk_Lang_Spn" value="Spanish" onclick = LangClick(this) checked> Spanish (<label id='Lang_Spn_Count'></label>)</td>
				<td><div id = "SpnBar" style="background-color:#005FAF;height:15px; width: 0%;"></div></td>
			</tr>
			<tr>
				<td><input type="checkbox" id="chk_Lang_Ger" value="German" onclick = LangClick(this) checked> German (<label id='Lang_Ger_Count'></label>)</td>
				<td><div id = "GerBar" style="background-color:#005FAF;height:15px; width: 0%;"></div></td>
			</tr>
			<tr>
				<td><input type="checkbox" id="chk_Lang_Fr" value="French" onclick = LangClick(this) checked> French (<label id='Lang_Fra_Count'></label>)</td>
				<td><div id = "FraBar" style="background-color:#005FAF;height:15px; width: 0%;"></div></td>
			</tr>
		</table>
		</div><br>
		<hr style="border: 1px dotted black">
		<span style="margin-left:10px;">Region :</span><br><br>
		<div style="margin-left:20px;">
		<table width=90%>
			<col width="60%">
		  	<col width="40%">
			<tr>
				<td><input type="checkbox" id="chk_Reg_All" value="All" onclick = RegClick(this) checked> All (<label id='Reg_All_Count'></label>)</td>
				<td><div style="background-color:#005FAF;color:gray;height:15px; width: 100%;"></div></td>
			</tr>
			<tr>
				<td><input type="checkbox" id="chk_Reg_US" value="US" onclick = RegClick(this) checked> US (<label id='Reg_US_Count'></label>)</td>
				<td><div id = "USBar_Reg" style="background-color:#005FAF;height:15px; width: 0%;"></div></td>
			</tr>
			<tr>
				<td><input type="checkbox" id="chk_Reg_Mex" value="Mexico" onclick = RegClick(this) checked> Spn,S.A. (<label id='Reg_Mex_Count'></label>)</td>
				<td><div id = "MexBar_Reg" style="background-color:#005FAF;height:15px; width: 0%;"></div></td>
			</tr>
			<tr>
				<td><input type="checkbox" id="chk_Reg_Ger" value="Germany" onclick = RegClick(this) checked> Germany (<label id='Reg_Ger_Count'></label>)</td>
				<td><div id = "GerBar_Reg" style="background-color:#005FAF;height:15px; width: 0%;"></div></td>
			</tr>
			<tr>
				<td><input type="checkbox" id="chk_Reg_Fr" value="France" onclick = RegClick(this) checked> France  (<label id='Reg_Fra_Count'></label>)</td>
				<td><div id = "FraBar_Reg" style="background-color:#005FAF;height:15px; width: 0%;"></div></td>
			</tr>
		</table>
		</div><br>
		<hr style="border: 1px dotted black">
		<!-- <span style="margin-left:10px;">Date :</span><br><br>
		<input style="margin-left:20px;" type = "text" size = 10 placeholder = "mm/dd/yy" /> to <input type = "text" size = 10 placeholder = "mm/dd/yy" />
		<br><br><hr style="border: 1px dotted black"> -->
		<input style="background-color:#005FAF;border:none;color:white;cursor:pointer;margin-left:20px;font-size: 16px;width:80%;" type="button" onCLick="populateResults('1')" value="Apply!"/>
		<br><br><img style="margin-left:20px" id='Trump' src="Images/trump.gif" alt="Loading.." height="220" width="220"/>
	</div>
	
	<div style="float:left; width:57%; padding-left:20px;padding-right:10px;">
	<span style="color:gray">Showing <label id="from"></label>-<label id="to"></label> of <label id="total"></label> results</span><br><br>
		<div id="result1">
			<label id="text1"></label>
			<label id="transtext1"></label><br>
			<span class="tweet-title">-<span id="username1"></span> (<span id="handler1"></span>)</span><br>
			<label id="showMore1" class="show-more" onClick="showMore('1')">Show More</label><br>
			<div id="more1" class="more-info" style="display:none;">
				<br>
				<table width=90%>
					<tr>
						<td>
						Language : <label id='lang1'></label> 
						<span id='translate1' onClick="LangOptions('1')" class="hand color-blue">(Translate)</span>
						<span class="color-blue" style="display:none;" id='trans1'>
						<b>Choose</b>: 
						<label class="hand" onClick="IndiTrans('1','en')"><u>English</u></label>, 
						<label class="hand" onClick="IndiTrans('1','es')"><u>Spanish</u></label>, 
						<label class="hand" onClick="IndiTrans('1','de')"><u>German</u></label>, 
						<label class="hand" onClick="IndiTrans('1','fr')"><u>French</u></label>
						</span>
						</td>
						<td>Region : <label id='reg1'></label></td>
					</tr>
					<tr>
						<td>Tweet Date : <label id='tDate1'></label></td>
						<td><span onClick="deleteTweet('1')" class="hand color-blue">Flag as Inappropriate<label id='id1' hidden></label></span></td>
					</tr>
				</table>
			</div><br><hr><br>
		</div>
		<div id="result2">
			<label id="text2"></label>
			<label id="transtext2"></label><br>
			<span class="tweet-title">-<span id="username2"></span> (<span id="handler2"></span>)</span><br>
			<label id="showMore2" class="show-more" onClick="showMore('2')">Show More</label><br>
			<div id="more2" class="more-info" style="display:none;">
				<br>
				<table width=90%>
					<tr>
						<td>
						Language : <label id='lang2'></label> 
						<span id='translate2' onClick="LangOptions('2')" class="hand color-blue">(Translate)</span>
						<span class="color-blue" style="display:none;" id='trans2'>
						<b>Choose</b>: 
						<label class="hand" onClick="IndiTrans('2','en')"><u>English</u></label>, 
						<label class="hand" onClick="IndiTrans('2','es')"><u>Spanish</u></label>, 
						<label class="hand" onClick="IndiTrans('2','de')"><u>German</u></label>, 
						<label class="hand" onClick="IndiTrans('2','fr')"><u>French</u></label>
						</span>
						</td>
						<td>Region : <label id='reg2'></label></td>
					</tr>
					<tr>
						<td>Tweet Date : <label id='tDate2'></label></td>
						<td><span onClick="deleteTweet('2')" class="hand color-blue">Flag as Inappropriate<label id='id2' hidden></label></span></td>
					</tr>
				</table>
			</div><br><hr><br>
		</div>
		<div  id="result3">
			<label id="text3"></label>
			<label id="transtext3"></label><br>
			<span class="tweet-title">-<span id="username3"></span> (<span id="handler3"></span>)</span><br>
			<label id="showMore3" class="show-more" onClick="showMore('3')">Show More</label><br>
			<div id="more3" class="more-info" style="display:none;">
				<br>
				<table width=90%>
					<tr>
						<td>
						Language : <label id='lang3'></label> 
						<span id='translate3' onClick="LangOptions('3')" class="hand color-blue">(Translate)</span>
						<span class="color-blue" style="display:none;" id='trans3'>
						<b>Choose</b>: 
						<label class="hand" onClick="IndiTrans('3','en')"><u>English</u></label>, 
						<label class="hand" onClick="IndiTrans('3','es')"><u>Spanish</u></label>, 
						<label class="hand" onClick="IndiTrans('3','de')"><u>German</u></label>, 
						<label class="hand" onClick="IndiTrans('3','fr')"><u>French</u></label>
						</span>
						</td>
						<td>Region : <label id='reg3'></label></td>
					</tr>
					<tr>
						<td>Tweet Date : <label id='tDate3'></label></td>
						<td><span onClick="deleteTweet('3')" class="hand color-blue">Flag as Inappropriate<label id='id3' hidden></label></span></td>
					</tr>
				</table>
			</div><br><hr><br>
		</div>
		<div id="result4">
			<label id="text4"></label>
			<label id="transtext4"></label><br>
			<span class="tweet-title">-<span id="username4"></span> (<span id="handler4"></span>)</span><br>
			<label id="showMore4" class="show-more" onClick="showMore('4')">Show More</label><br>
			<div  id="more4" class="more-info" style="display:none;">
				<br>
				<table width=90%>
					<tr>
						<td>
						Language : <label id='lang4'></label> 
						<span id='translate4' onClick="LangOptions('4')" class="hand color-blue">(Translate)</span>
						<span class="color-blue" style="display:none;" id='trans4'>
						<b>Choose</b>: 
						<label class="hand" onClick="IndiTrans('4','en')"><u>English</u></label>, 
						<label class="hand" onClick="IndiTrans('4','es')"><u>Spanish</u></label>, 
						<label class="hand" onClick="IndiTrans('4','de')"><u>German</u></label>, 
						<label class="hand" onClick="IndiTrans('4','fr')"><u>French</u></label>
						</span>
						</td>
						<td>Region : <label id='reg4'></label></td>
					</tr>
					<tr>
						<td>Tweet Date : <label id='tDate4'></label></td>
						<td><span onClick="deleteTweet('4')" class="hand color-blue">Flag as Inappropriate<label id='id4' hidden></label></span></td>
					</tr>
				</table>
			</div><br><hr><br>
		</div><img id='Loading' style="display:none;padding-left:45%;" src="Images/Loading.gif" alt="Loading.." height="50" width="50"/>
		<div id="result5">
			<label id="text5"></label>
			<label id="transtext5"></label><br>
			<span class="tweet-title">-<span id="username5"></span> (<span id="handler5"></span>)</span><br>
			<label id="showMore5" class="show-more" onClick="showMore('5')">Show More</label><br>
			<div id="more5" class="more-info" style="display:none;">
				<br>
				<table width=90%>
					<tr>
						<td>
						Language : <label id='lang5'></label> 
						<span id='translate5' onClick="LangOptions('5')" class="hand color-blue">(Translate)</span>
						<span class="color-blue" style="display:none;" id='trans5'>
						<b>Choose</b>: 
						<label class="hand" onClick="IndiTrans('5','en')"><u>English</u></label>, 
						<label class="hand" onClick="IndiTrans('5','es')"><u>Spanish</u></label>, 
						<label class="hand" onClick="IndiTrans('5','de')"><u>German</u></label>, 
						<label class="hand" onClick="IndiTrans('5','fr')"><u>French</u></label>
						</span>
						</td>
						<td>Region : <label id='reg5'></label></td>
					</tr>
					<tr>
						<td>Tweet Date : <label id='tDate5'></label></td>
						<td><span onClick="deleteTweet('5')" class="hand color-blue">Flag as Inappropriate<label id='id5' hidden></label></span></td>
					</tr>
				</table>
			</div><br><hr><br>
		</div>
		<div id="result6">
			<label id="text6"></label>
			<label id="transtext6"></label><br>
			<span class="tweet-title">-<span id="username6"></span> (<span id="handler6"></span>)</span><br>
			<label id="showMore6" class="show-more" onClick="showMore('6')">Show More</label><br>
			<div id="more6" class="more-info" style="display:none;">
				<br>
				<table width=90%>
					<tr>
						<td>
						Language : <label id='lang6'></label> 
						<span id='translate6' onClick="LangOptions('6')" class="hand color-blue">(Translate)</span>
						<span class="color-blue" style="display:none;" id='trans6'>
						<b>Choose</b>: 
						<label class="hand" onClick="IndiTrans('6','en')"><u>English</u></label>, 
						<label class="hand" onClick="IndiTrans('6','es')"><u>Spanish</u></label>, 
						<label class="hand" onClick="IndiTrans('6','de')"><u>German</u></label>, 
						<label class="hand" onClick="IndiTrans('6','fr')"><u>French</u></label>
						</span>
						</td>
						<td>Region : <label id='reg6'></label></td>
					</tr>
					<tr>
						<td>Tweet Date : <label id='tDate6'></label></td>
						<td><span onClick="deleteTweet('6')" class="hand color-blue">Flag as Inappropriate<label id='id6' hidden></label></span></td>
					</tr>
				</table>
			</div><br><hr><br>
		</div>
		<div id="result7">
			<label id="text7"></label>
			<label id="transtext7"></label><br>
			<span class="tweet-title">-<span id="username7"></span> (<span id="handler7"></span>)</span><br>
			<label id="showMore7" class="show-more" onClick="showMore('7')">Show More</label><br>
			<div  id="more7" class="more-info" style="display:none;">
				<br>
				<table width=90%>
					<tr>
						<td>
						Language : <label id='lang7'></label> 
						<span id='translate7' onClick="LangOptions('7')" class="hand color-blue">(Translate)</span>
						<span class="color-blue" style="display:none;" id='trans7'>
						<b>Choose</b>: 
						<label class="hand" onClick="IndiTrans('7','en')"><u>English</u></label>, 
						<label class="hand" onClick="IndiTrans('7','es')"><u>Spanish</u></label>, 
						<label class="hand" onClick="IndiTrans('7','de')"><u>German</u></label>, 
						<label class="hand" onClick="IndiTrans('7','fr')"><u>French</u></label>
						</span>
						</td>
						<td>Region : <label id='reg7'></label></td>
					</tr>
					<tr>
						<td>Tweet Date : <label id='tDate7'></label></td>
						<td><span onClick="deleteTweet('7')" class="hand color-blue">Flag as Inappropriate<label id='id7' hidden></label></span></td>
					</tr>
				</table>
			</div><br><hr><br>
		</div>
		<div id="result8">
			<label id="text8"></label>
			<label id="transtext8"></label><br>
			<span class="tweet-title">-<span id="username8"></span> (<span id="handler8"></span>)</span><br>
			<label id="showMore8" class="show-more" onClick="showMore('8')">Show More</label><br>
			<div  id="more8" class="more-info" style="display:none;">
				<br>
				<table width=90%>
					<tr>
						<td>
						Language : <label id='lang8'></label> 
						<span id='translate8' onClick="LangOptions('8')" class="hand color-blue">(Translate)</span>
						<span class="color-blue" style="display:none;" id='trans8'>
						<b>Choose</b>: 
						<label class="hand" onClick="IndiTrans('8','en')"><u>English</u></label>, 
						<label class="hand" onClick="IndiTrans('8','es')"><u>Spanish</u></label>, 
						<label class="hand" onClick="IndiTrans('8','de')"><u>German</u></label>, 
						<label class="hand" onClick="IndiTrans('8','fr')"><u>French</u></label>
						</span>
						</td>
						<td>Region : <label id='reg8'></label></td>
					</tr>
					<tr>
						<td>Tweet Date : <label id='tDate8'></label></td>
						<td><span onClick="deleteTweet('8')" class="hand color-blue">Flag as Inappropriate<label id='id8' hidden></label></span></td>
					</tr>
				</table>
			</div><br><hr><br>
		</div>
		<div id="result9">
			<label id="text9"></label>
			<label id="transtext9"></label><br>
			<span class="tweet-title">-<span id="username9"></span> (<span id="handler9"></span>)</span><br>
			<label id="showMore9" class="show-more" onClick="showMore('9')">Show More</label><br>
			<div id="more9" class="more-info" style="display:none;">
				<br>
				<table width=90%>
					<tr>
						<td>
						Language : <label id='lang9'></label> 
						<span id='translate9' onClick="LangOptions('9')" class="hand color-blue">(Translate)</span>
						<span class="color-blue" style="display:none;" id='trans9'>
						<b>Choose</b>: 
						<label class="hand" onClick="IndiTrans('9','en')"><u>English</u></label>, 
						<label class="hand" onClick="IndiTrans('9','es')"><u>Spanish</u></label>, 
						<label class="hand" onClick="IndiTrans('9','de')"><u>German</u></label>, 
						<label class="hand" onClick="IndiTrans('9','fr')"><u>French</u></label>
						</span>
						</td>
						<td>Region : <label id='reg9'></label></td>
					</tr>
					<tr>
						<td>Tweet Date : <label id='tDate9'></label></td>
						<td><span onClick="deleteTweet('9')" class="hand color-blue">Flag as Inappropriate<label id='id9' hidden></label></span></td>
					</tr>
				</table>
			</div><br><hr><br>
		</div>
		<div id="result10">
			<label id="text10"></label>
			<label id="transtext10"></label><br>
			<span class="tweet-title">-<span id="username10"></span> (<span id="handler10"></span>)</span><br>
			<label id="showMore10" class="show-more" onClick="showMore('10')">Show More</label><br>
			<div id="more10" class="more-info" style="display:none;">
				<br>
				<table width=90%>
					<tr>
						<td>
						Language : <label id='lang10'></label> 
						<span id='translate10' onClick="LangOptions('10')" class="hand color-blue">(Translate)</span>
						<span class="color-blue" style="display:none;" id='trans10'>
						<b>Choose</b>: 
						<label class="hand" onClick="IndiTrans('10','en')"><u>English</u></label>, 
						<label class="hand" onClick="IndiTrans('10','es')"><u>Spanish</u></label>, 
						<label class="hand" onClick="IndiTrans('10','de')"><u>German</u></label>, 
						<label class="hand" onClick="IndiTrans('10','fr')"><u>French</u></label>
						</span>
						</td>
						<td>Region : <label id='reg10'></label></td>
					</tr>
					<tr>
						<td>Tweet Date : <label id='tDate10'></label></td>
						<td><span onClick="deleteTweet('10')" class="hand color-blue">Flag as Inappropriate<label id='id10' hidden></label></span></td>
					</tr>
				</table>
			</div><br><hr><br>
		</div>
		<div id="navigation" class="navigation">
			<div id="prev" style="float:left;cursor: pointer;" onClick="populateResults('prev')">
				<div style="float:left">
					<img src="Images/previous.png" alt="Prev" height="40" width="40">
				</div>
				<div style="float:right">
					&nbsp;Previous
				</div>
			</div>
			<div style="padding-left:10%; float:left;cursor: pointer;">
				<span id = "page1" onClick="populateResults('1')">1</span>&nbsp;
				<span id = "page2" onClick="populateResults('2')">2</span>&nbsp;
				<span id = "page3" onClick="populateResults('3')">3</span>&nbsp;
				<span id = "page4" onClick="populateResults('4')">4</span>&nbsp;
				<span id = "page5" onClick="populateResults('5')">5</span>&nbsp;
				<span id = "page6" onClick="populateResults('6')">6</span>&nbsp;
				<span id = "page7" onClick="populateResults('7')">7</span>&nbsp;
				<span id = "page8" onClick="populateResults('8')">8</span>&nbsp;
				<span id = "page9" onClick="populateResults('9')">9</span>&nbsp;
				<span id = "page10" onClick="populateResults('10')">10</span>&nbsp;
			</div>
			<div id="next" style="float:right;cursor: pointer;" onClick="populateResults('next')">
				<div style="float:left">
					Next&nbsp;
				</div>
				<div style="float:right">
					<img src="Images/next.png" alt="Next" height="40" width="40">
				</div>
			</div><br><br><hr>
		</div>
		<div id="noResults" style="display:none">
		Sorry! No results found! Please modify the query/filter and try again!
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
<span id = "ResultCount" hidden></span>
</body>
</html>