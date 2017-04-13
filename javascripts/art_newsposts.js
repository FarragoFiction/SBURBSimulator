
//TODO add thought bubble about jack to dialogue
window.onload = function() {
	//http://stackoverflow.com/questions/8748426/scroll-background-image-untill-the-end-not-further
	$( window ).scroll( function(){
	  var ypos = $( window ).scrollTop(); //pixels the site is scrolled down
	  var visible = $( window ).height(); //visible pixels
	  const img_height = 1500; //replace with height of your image
	  var max_scroll = img_height - visible; //number of pixels of the image not visible at bottom
	//change position of background-image as long as there is something not visible at the bottom
	if ( max_scroll > ypos) {
		 $("body").css("background-position", "center -" + ypos + "px");
	  } else {
		$("body").css("background-position", "center -" + max_scroll + "px");
	  }
});
		newsposts();
}

function newsposts(){
	writeNewspost("4/13/17","Happy 413! I tried to finish out the hair for all the dancestors, but.... Kurloz. Seriously. His hair is too big to fit on the canvas. For NO REASON. He's not the Grand Highblood yet! I threw it out and made new hair that better reflects his talksprite. Anyway, I should be able to finish the rest soon. Did you know there are more than 50 hairstyles in the system already? Sheesh.");
	writeNewspost("4/5/17", " Ugh tvros your hair is so ugly<Br>ur head's not even round<Br>look at this bullshit:  <Br> <img src = 'images/tavroshead.png'>")
	writeNewspost("4/4/17", " Muahahaha! Finally I have finished updating all of the existing sprites for hair and I can start adding new ones.")
	writeNewspost("3/31/17", "Spent today chasing down visual bugs and eating them like a hungry baby dragon. Also banging my face against a scaling issue on the babies that was probably my fault in the first place. I standardized the size of all the rest of the images, but not the babies. Because I'm an idiot.<Br><Br>PS: Hyperrealistic grimdark flames are the best idea I've ever had.")
	writeNewspost("3/28/17", "Here's some proper Dream jammies for all you ungrateful bastards on Reddit.")
	writeNewspost("3/28/17", "Finished fixing up another handful of the worst hairstyles! jR figured out how to get the corrections working in the main branch as well, so you should all be able to see them.")
	writeNewspost("3/27/17", "Death by stabs now includes a knife in the corpse, courtesy of the <a href='http://www.mspaintadventures.com/?s=6&p=002228'>Midnight Crew</a>.");
	writeNewspost("3/23/17", 'There are currently 35 hairstyles. For stupid reasons related to my perfectionism, fixing up the hair sprites takes longer than any other sprite part, even the clothes. The few that are finished to my satisfaction are loaded into the <a href="http://purplefrog.com/~jenny/SburbStoryExperimental/newsposts.html">Experimental</a> branch. Making the images for this page has nothing to do with the delay on those, shut up."')
	writeNewspost("3/23/17", "Why did I spend several hours drawing blank-faced babies in MS Paint?<p><img src='images/Bodies/baby.png'><p>BECAUSE BABY LEGS DON'T WORK THAT WAY, HUSSIE.<p>ahem.<p>Anyway, I want to show off my baby sprites at full size, so you can marvel at their little toes and stupid fingers.<p><img src='images/Bodies/baby1.png'><br><img src='images/Bodies/baby2.png'><br><img src='images/Bodies/baby3.png'>")
	writeNewspost("3/23/17", "Cool, I get my own page!")
	$("#artist_newsposts").append("<Br><Br><br><Br>");

}



function getRandomElementFromArrayNoSeed(array){
	var min = 0;
	var max = array.length-1;
	var i = Math.floor(Math.random() * (max - min + 1)) + min;
	return array[i];
}



function writeNewspost(date, text){
		var str = "<div id = '" + date + "human'><hr> ";
		str += "<b>" + date + ":</b> ";
		str += text+ "</div>";
		$("#artist_newsposts").append(str);
}
