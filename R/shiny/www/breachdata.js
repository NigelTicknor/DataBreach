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

//go to analyzation
function goBox(num)
{
	$('.treeview-menu').children()[num].childNodes[1].click();
}

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

//loads a person into the bio template
function loadPerson(person)
{
	var name = document.getElementById('box_'+person).getAttribute('d_name');
	var desc = document.getElementById('box_'+person).getAttribute('d_desc');
	$.ajax({
    url : "c_person.html",
    success : function(result){
        $('#box_'+person)[0].innerHTML = result.replace('data_name',name).replace('data_desc',desc).replace('data_img','c_'+person+'.png');
		document.getElementById('box_'+person).removeAttribute('d_name');
		document.getElementById('box_'+person).removeAttribute('d_desc');
    }
});
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
modal = document.getElementById('MyModal');

//disable sidebar button (not currently enabled because it's needed for mobile)
//document.getElementsByClassName('sidebar-toggle')[0].style.display='none';

//load report
$('#reportDiv').load('https://docs.google.com/document/d/1Twq_NtLSTymzafhQMt6konRXWtMzbnUBAlLIPPQGKuM/pub?embedded=true');

//load code
$('#codeDiv').load('SourceCode.html');

//load the bios
loadPerson('nigel');
loadPerson('paul');
loadPerson('shaun');
loadPerson('eli');

//load the analysis
$('#fullanal_cat').load('anal_cat.txt')
$('#fullanal_line').load('anal_line.txt')





//set page title
$('.sidebar-menu')[0].onclick=function(){
	setTimeout(function(){
		document.title = $('.active')[1].title;
	},100);
};
document.title = $('.active')[1].title;

console.log( "Page ready" );
});