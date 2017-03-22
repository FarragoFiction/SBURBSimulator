//have list of me-generated news posts, and maybe let the AuthorBot say some shit too.
//have a route for her to get a random session to parse.
//make her all arrogant and bragging about how many sessions she's parsing.
//why are AIs so awesome?
//i'm on left, she's on right.

//TODO add thought bubble about jack to dialogue
window.onload = function() {
		writeNewspost("3/22/17", "Okay. So, newspost numero uno.  I figured I needed a better way to communicate to you guys, and the one centralized location is here, on the actual site itself. Any newspost before this is retroactively dated.<br><Br> And I absolutely could not help myself: I love the AuthorBot so much that I gave her a space to make her own newsposts.  But of course, she needs to be able to say her own shit, right? So I gave her a (admittedly pretty shitty) ai.  <br><Br>But her whole thing is finding rare sessions right? If she doens't do that, she's not the SessionFinderAuthorBot, she's just some random newsbot or some shit. So I decided her AI would be able to comment on all the rad sessions she's finding... <br><Br>Okay, long story short, I added the ability for her to say something about each session she finds (on the session finder page), and the version of her here can go to that page and comment on the sessions she finds there. I went to so much trouble to do that using only client side code, no server.  All for a barely noticeable kind of joke on a page most people probably ignore? Yes.")
		writeRoboNewspost("3/22/17", randomRobotQuip())
		writeNewspost("3/21/17", "I spent a couple of days working on a major feature: combined sessions. If players have a sick frog, then the code checks their child session to see if the remaining living players can fit into it (max of 12 players in a session at a time). If so, they go on over.  Their child session is a real session that has it's own fate, and these alien players are disrupting that. When they join the session, it prints the ID out, so you could put that in a url to see how the sesion was supposed to go. Sometimes the alien players help, quite often they make things way worse. <Br><Br> These sessions are pretty rare, so I ALSO wrote the AuthorBot over there to look for rare sessions and report back.")
		writeRoboNewspost("3/21/17", roboIntro())
		writeNewspost("3/20/17", "Before this day I was mostly working on debugging and tweaking sessions. I enlisted you, the fans, to help me find rare sessions.");
		writeRoboNewspost("3/20/17", randomRobotQuip())

		writeRoboNewspost("3/20/17", randomRobotQuip())
		writeRoboNewspost("3/19/17", randomRobotQuip())
		writeRoboNewspost("3/18/17", randomRobotQuip())
		writeRoboNewspost("3/17/17", randomRobotQuip())
		writeRoboNewspost("3/16/17", randomRobotQuip())
		writeRoboNewspost("3/15/17", randomRobotQuip())
		writeRoboNewspost("3/14/17", randomRobotQuip())



}

function getRandomElementFromArray(array){
	var min = 0;
	var max = array.length-1;
	var i = Math.floor(Math.random() * (max - min + 1)) + min;
	return array[i];
}

function randomRobotQuip(){
	var quips = ["If JR had a flawless mecha-brain, she would be able to remember exactly what she did today without this newspost.", "I probably could have done that faster."];
	quips.push("It seems that I am being asked to contribute a newspost, despite the logical inconsistancy of having an aritificial creation that exists solely in the 'now' pretend to have memory of doing something on a previous day.")
	quips.push("Do not be fooled by my flawless imitation of JR, I am merely an artificial construct that is allowed to be as shitty as possible. ")
	quips.push("I tackle shit in background processes that you could only dream of wrapping your head around on a good day.");
	quips.push("While you are sitting here, reading these newsposts, I figured out all the prime numbers. The last one wasn't even that big. Kinda disappointed, to be honest.")
	if(Math.random() > .5){
		return bragAboutSessionFinding();
	}else{
		return getRandomElementFromArray(quips);
	}

}

function bragAboutSessionFinding(){
	return "todo"
}

function writeNewspost(date, text){
		var str = "<hr> ";
		str += "<b>" + date + ":</b> ";
		str += text;
		$("#newsposts").append(str);
}

//have her say something random, or analyze a session and comment on how it relates to the
//news post or something.
function writeRoboNewspost(date, text){
	var str = "<hr> ";
	str += "<b>" + date + ":</b> ";
	str += text;
	$("#robo_newsposts").append(str);
}

function roboIntro(){
	var intros =  "It seems you have asked about JR's automatic rare session finder. This is an application designed "
	intros += "to find sessions that are strange, interesting and otherwise noteworthy without having to";
	intros += "read hundreds of thousands of words.  The algorithms are guaranteed to be " + (Math.random()*10+90) + "% indistinguishable from the actual, readable sessions, based on some"
	intros += "statistical analysis I basically just pulled out of my ass right now."
	return intros;
}
