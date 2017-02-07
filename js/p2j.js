/**
* p2j.js - Converts a PDF to a JSON file
* Author: Nigel Ticknor
* Usage: node p2j file.pdf
* Output: file.pdf.json
**/

//check required arguments
if(process.argv[2]==undefined)
{
	console.log("Error: You must supply an argument");
	process.exit(1);
}

//set up dependencies
let fs = require('fs'), PDFParser = require("pdf2json");
let pdfParser = new PDFParser();

//global variables
var file = "./"+process.argv[2];

//PDF processing
pdfParser.on("pdfParser_dataError", errData => console.error(errData.parserError) );
pdfParser.on("pdfParser_dataReady", pdfData => {
	fs.writeFile("./"+file+'.json', JSON.stringify(pdfData));
});

//start process
pdfParser.loadPDF("./"+file);