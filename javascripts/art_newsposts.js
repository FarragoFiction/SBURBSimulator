
//TODO add thought bubble about jack to dialogue
window.onload = function() {
		newsposts();
}

function newsposts(){
	writeNewspost("3/23/17", "This is just a test")
	writeNewspost("3/23/17", "This is just a test")
	writeNewspost("3/23/17", "This is just a test")
	writeNewspost("3/23/17", "This is just a test")
	writeNewspost("3/23/17", "This is just a test")

}



function getRandomElementFromArrayNoSeed(array){
	var min = 0;
	var max = array.length-1;
	var i = Math.floor(Math.random() * (max - min + 1)) + min;
	return array[i];
}



function writeNewspost(date, text){
		var str = "<div id = ''" + date + "human'><hr> ";
		str += "<b>" + date + ":</b> ";
		str += text+ "</div>";
		$("#artist_newsposts").append(str);
}
