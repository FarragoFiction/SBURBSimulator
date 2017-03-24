
//TODO add thought bubble about jack to dialogue
window.onload = function() {
		newsposts();
}

function newsposts(){
	writeNewspost("3/23/17", "There are currently 35 hairstyles. For stupid reasons related to my perfectionism, fixing up the hair sprites takes longer than any other sprite part, even the clothes. The few that are finished to my satisfaction are loaded into the <a href='http://purplefrog.com/~jenny/SburbStoryExperimental/newsposts.html'>Experimental</a> branch. Making the images for this page has nothing to do with the delay on those, shut up.")
	writeNewspost("3/23/17", "Why did I spend several hours drawing blank-faced babies in MS Paint?<p><img src='images/Bodies/baby.png'><p>BEACAUSE BABY LEGS DON'T WORK THAT WAY, HUSSIE.<p>ahem.<p>Anyway, I want to show off my baby sprites at full size, so you can marvel at their little toes and stupid fingers.<p><img src='images/Bodies/baby1.png'><br><img src='images/Bodies/baby2.png'><br><img src='images/Bodies/baby3.png'>")
	writeNewspost("3/23/17", "Cool, I get my own page!")

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
