
//if this seems like it will work, move to random tables. based on recursiveSlacker's idea.
var comedyInterestNouns = ["joke","clown","fun", "folk", "bloke"];
var comedyInterestVerbs = ["joke", "frown", "stun", "soak", "choke", "scrunch"];

var athleticInterestNouns = ["sun","lunch","crown","yolk"];
var athleticInterestVerbs = ["run","punch", "down", "drown", "soak", "won"];
//http://www.rhymezone.com/r/rhyme.cgi?Word=sun&typeofrhyme=perfect&org1=syl&org2=l&org3=y
var wordsRhymeTown = ["town", "down", "frown", "clown", "brown", "crown", "drown","noun"];
var wordsRhymeJoke = ["bloke","broke","croak","choke","folk","oak","smoke","soak","woke","yolk","yoke","coke", "spoke"];

var wordsRhymeSun = ["bun","fun","gun","son","hun","none","nun","stun","spun","shun","run","won"];
var wordsRhymePunch = ["brunch","punch","lunch","bunch","crunch","hunch","munch","scrunch"];


//would be so dope to rap about what's happened in the session.
//could read session summary?
//worry about this LATER, and definitely not in this stand alone page.
window.onload = function() {
		rapper1Line("Hello World")
		rapper2Line("Goodbye World");
		//and it don't stop till a rhyme isn't found. points on how many lines you manage. then opponent turn. they try to rhyme their first rhyme with your last.
}

//red text
function rapper1Line(line){
	$("#rap").append("<font color='red'>"+line+"</font><br>")
}

//blue text
function rapper2Line(line){
	$("#rap").append("<font color='blue'>"+line+"</font><br>")
}
