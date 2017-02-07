if(process.argv[2]==undefined)
{
	console.log("Error: You must supply an argument");
	process.exit(1);
}

var file = "./"+process.argv[2];


let fs = require('fs'),
	PDFParser = require("pdf2json");

let pdfParser = new PDFParser();

pdfParser.on("pdfParser_dataError", errData => console.error(errData.parserError) );
pdfParser.on("pdfParser_dataReady", pdfData => {
	fs.writeFile("./"+file+'.json', JSON.stringify(pdfData));
});

pdfParser.loadPDF("./"+file);