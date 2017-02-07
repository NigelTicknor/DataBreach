console.log('DataBreach Script Loaded');
function calcMapH()
{
	if(document.getElementById('plot_maps')!=undefined){
		var map = document.getElementById('plot_maps').childNodes[0];
		if(map!=undefined){
			tv = map.width/1.5;
			if(tv>600)tv=600;
			map.height=tv;
		}
	}
}
window.onresize = function(){setTimeout(calcMapH,1000)};

//resize map after 1s
setTimeout(calcMapH,1000)

//zoom a simplegraph
function clickBox(wb)
{
	var box = document.getElementById('box_'+wb);
	if(box!=undefined)
	{
		imgsrc = document.getElementById('box_'+wb).childNodes[1].childNodes[0].src;
		var tu = document.getElementById('modimg');
		ti.setAttribute('src',imgsrc);
		ti.style.width='80%';
		ti.style.height='80%';
		ti.style.marginLeft='-'+Math.floor(ti.width)+'px';
		ti.style.marginTop='-'+Math.floor(ti.height)+'px';
		modal.style.display = "block";
		modal.onclick=function(){
			modal.style.display = "none";
			modal.onclick='';
		};
	}
}

$(function() {
//modal setup
m = document.createElement('div');
m.id='MyModal';
m.setAttribute('class','modal');
ti = document.createElement('img');
ti.id = 'modimg';
ti.setAttribute('class','modal-content');
m.appendChild(ti);
document.body.appendChild(m)
    console.log( "ready!" );
modal = document.getElementById('MyModal');

//disable sidebar button
document.getElementsByClassName('sidebar-toggle')[0].style.display='none';

//load report
$('#reportDiv').load('DataBreachesFinalPaper.html');
});