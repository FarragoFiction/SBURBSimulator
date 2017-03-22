//have list of me-generated news posts, and maybe let the AuthorBot say some shit too.
//have a route for her to get a random session to parse.
//make her all arrogant and bragging about how many sessions she's parsing.
//why are AIs so awesome?
//i'm on left, she's on right.

//TODO add thought bubble about jack to dialogue
window.onload = function() {
		writeNewspost("3/22/17", "This is just a test.This is just a test.This is just a test.This is just a test.This is just a test.This is just a test.This is just a test.This is just a test.This is just a test.This is just a test.")
		writeNewspost("3/22/17", "This is just a test.")
		writeNewspost("3/22/17", "This is just a test.")
		writeRoboNewspost("3/22/17", "This is just a robo test.")
		writeRoboNewspost("3/22/17", "This is just a robo test.")
		writeRoboNewspost("3/22/17", "This is just a robo test.")
}

function writeNewspost(date, text){
		var str = "<hr> ";
		str += "<b>" + date + ":</b>";
		str += text;
		$("#newsposts").append(str);
}

//have her say something random, or analyze a session and comment on how it relates to the
//news post or something.
function writeRoboNewspost(date, text){
	var str = "<hr> ";
	str += "<b>" + date + ":</b>";
	str += text;
	$("#robo_newsposts").append(str);
}
