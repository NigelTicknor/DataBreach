/**
* ScrapePDF.js - Scrapes data from an IRTC PDF
* Author: Nigel Ticknor
* Usage: node ScrapePDF file.pdf
* Output: file.pdf.txt
**/

//check required arguments
if(process.argv[2]==undefined)
{
	console.log("Error: You must supply an argument");
	process.exit(1);
}

//set up dependencies
var moment = require('moment');
var states =  require( 'datasets-us-states-abbr-names' );
states['DC'] = 'Washington D.C.';
states['US'] = 'United States';
let fs = require('fs'), PDFParser = require("pdf2json");
let pdfParser = new PDFParser();

//global variables
var file = "./"+process.argv[2];

//PDF processing
pdfParser.on("pdfParser_dataError", errData => console.error(errData.parserError) );
pdfParser.on("pdfParser_dataReady", pdfData => {
	console.log('Parsing complete!');
	processJSON(pdfData);
});

//start process
console.log("Staring Parse...");
pdfParser.loadPDF(file);

//process function
function processJSON(obj)
{
	console.log("Starting Scrape...");
	var cats = ['Business','Medical/Healthcare','Government/Military','Educational','Banking/Credit/Financial'];
	var types = ['Paper Data','Electronic'];
	var obs = [];
	var yvals = [6, 15, 23, 30, 37];
	var str='';
	obj.formImage.Pages.forEach(function(e){
		var tob = {id:'',name:'',state:'--',date:'NA',type:'',cat:'',exp:'',rep:'NA'};
		var l = e.Texts.length;
		var idF = false,sF=false,rF=false;;
		var repNum = -1,getRR=-1;
		for(var i=0;i<l;i++){
			var s = decodeURIComponent(e.Texts[i].R[0].T);
			if(s.includes('ITRC')&&!s.includes('Breach ID')&&s.length<20) //ID
			{ //ID
				idF = true;
				tob.id = s.replace('--','-'); //single case
			}
			else if (idF&&!sF&&s.length>2&&!sF&&!moment(s, "M/DD/YYYY", true).isValid())
			{ //Name
				tob.name+=s;
			}
			else if(idF&&s.length==2&&isNaN(s)&&states[s])
			{ //State
				tob.state = s;
				sF=true;
				if(!states[s])
				console.log(s+': '+tob.id+' '+tob.name);
			}
			else if(idF&&moment(s, "M/DD/YYYY", true).isValid())
			{ //Date
				tob.date = s;
				sF=true;
			}
			else if(idF&&types.includes(s))
			{ //Type
				tob.type = s;
			}
			else if(idF&&cats.includes(s))
			{ //Category
				tob.cat = s;
			}
			else if(idF&&s.includes(' - ')&&(s.includes('Yes')||s.includes('No')))
			{ //RR
				tob.exp = s;
				repNum= i+1;
			}
			else if(idF&&i==repNum)
			{ //Number
				s = s.replace(/,/g,'');
				if(!isNaN(s))
				tob.rep = s;
				rF=true;
			}
			if(idF&&tob.name.length>0&&tob.type.length>0&&tob.type.length>0&&tob.exp.length>0&&rF)
			{ //Finish observation
				obs.push(tob);
				tob = null;
				tob = {id:'',name:'',state:'--',date:'NA',type:'',cat:'',exp:'',rep:'NA'};
				repNum=-1;
				getRR=-1;
				idF=false;
				sF=false;
				rF=false;
			}
		}
	});
	console.log('Conversion Complete: Extracted '+obs.length+' objects.');
	obs.forEach(function(e,i,a){
		var delim='~';
		str+= e.id+delim+e.name+delim+e.state+delim+e.date+delim+e.type+delim+e.cat+delim+e.exp+delim+e.rep+'\r\n';
	});
	fs.writeFile(file+'.txt',str);
}

//Number to p decimals
function nTP(num,p)
{
	return Math.trunc(num*Math.pow(10,p))/Math.pow(10,p);
}