//have list of me-generated news posts, and maybe let the AuthorBot say some shit too.
//have a route for her to get a random session to parse.
//make her all arrogant and bragging about how many sessions she's parsing.
//why are AIs so awesome?
//i'm on left, she's on right.
window.onload = function() {
		writeNewspost("3/22/17", "This is just a test.")
}

function writeNewspost(date, text){
		var str = "<hr> ";
		str += "<b>" + date + ":</b>";
		str += text;
		$("#newsposts").append(str);
}
