if(process.argv[2]==undefined)
{
	console.log("Error: You must supply an argument");
	process.exit(1);
}

var moment = require('moment');
var states =  require( 'datasets-us-states-abbr-names' );
states['DC'] = 'Washington D.C.';
states['US'] = 'United States';

var file = "./"+process.argv[2];

let fs = require('fs'),
	PDFParser = require("pdf2json");

let pdfParser = new PDFParser();

pdfParser.on("pdfParser_dataError", errData => console.error(errData.parserError) );
pdfParser.on("pdfParser_dataReady", pdfData => {
	processJSON(pdfData);
});

console.log("starting parse");

pdfParser.loadPDF(file);

//processJSON(JSON.parse(fs.readFileSync('./ITRCBreachReport2015.json', 'utf8')));



function processJSON(obj)
{
	var cats = ['Business','Medical/Healthcare','Government/Military','Educational','Banking/Credit/Financial'];
	var types = ['Paper Data','Electronic'];
	console.log("starting conversion");
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
			else if(idF&&types.includes(s)) //if(s=='Electronic'||s=='Paper Data')
			{ //Type
				tob.type = s;
			}
			else if(idF&&cats.includes(s))//if(Math.abs(e.Texts[i].x-18)<5&&yvals.includes(nTP(e.Texts[i].x,0))) //if(s=='Business'||s=='Medical/Healthcare'||s=='Government/Military'||s=='Banking/Credit/Financial')
			{ //Category
				tob.cat = s;
			}
			else if(idF&&s.includes(' - ')&&(s.includes('Yes')||s.includes('No')))
			{ //RR
				tob.exp = s;
				repNum= i+1;
				//if(s.includes('Unknown'))
				//{
				//	repNum = i+3;
				//}
			}
			else if(idF&&i==repNum)
			{ //Number
				s = s.replace(/,/g,'');
				if(!isNaN(s))
				tob.rep = s;
				rF=true;
			}
			if(idF&&tob.name.length>0&&tob.type.length>0&&tob.type.length>0&&tob.exp.length>0&&rF)
			{
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
	console.log('extracted '+obs.length+' objects');
	obs.forEach(function(e,i,a){
		var delim='~';
		str+= e.id+delim+e.name+delim+e.state+delim+e.date+delim+e.type+delim+e.cat+delim+e.exp+delim+e.rep+'\r\n';
	});
	fs.writeFile(file+'.txt',str);
}

function nTP(num,p)
{
	return Math.trunc(num*Math.pow(10,p))/Math.pow(10,p);//parseFloat(num.toString().match(/^-?\d+(?:\.\d{0,p})?/)[0])
}