
//would be so dope to rap about what's happened in the session.
//could read session summary?
//worry about this LATER, and definitely not in this stand alone page.
//for now, rap about your own interests.
window.onload = function() {
		rap(1);
		rap(2);
		rap(1);
}

function rap(playerNum){
	Math.seed =  getRandomSeed(); 
	var interest =  getRandomElementFromArray(["Pranks","Swimming"]);
	var chosenRapTemplate = getRandomElementFromArray(rapTemplates);
	var firstWord = chosenRapTemplate.findWordBasedOnPart1AndInterest(interest)
	var secondWord = chosenRapTemplate.findWordBasedOnPart2AndInterestAndPart1Word(interest, firstWord)
	var str = chosenRapTemplate.part1 + firstWord + chosenRapTemplate.part2 + secondWord
	if(playerNum==1){
		rapper1Line(str);
	}else{
		rapper2Line(str);
	}
	//TODO, KEEP GOING UNTIL HIT MAX LINES OR NO RHYME (HEY, THAT RHYMED)
}

//red text
function rapper1Line(line){
	$("#rap").append("<font color='red'>"+line+"</font><br>")
}

//blue text
function rapper2Line(line){
	$("#rap").append("<font color='blue'>"+line+"</font><br>")
}
