//stay fresh, don't repeat rhymes.
var player1Rhymes = [];
var player2Rhymes = [];

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
	var interest =  getRandomElementFromArray(["Pranks","Swimming"]); //TODO make work for all interest categories.
	var chosenRapTemplate = getRandomElementFromArray(rapTemplates);
	var firstWord = chosenRapTemplate.findWordBasedOnPart1AndInterest(interest)
	var secondWord = chosenRapTemplate.findWordBasedOnPart2AndInterestAndPart1Word(interest, firstWord)

	if(firstWord && secondWord && firstWord != secondWord){
		var str = chosenRapTemplate.part1 + firstWord + chosenRapTemplate.part2 + secondWord
		if(playerNum==1){
			if(player1Rhymes.indexOf(firstWord) == -1 && player1Rhymes.indexOf(secondWord) == -1) {
				player1Rhymes.push(firstWord);
				player1Rhymes.push(secondWord);
				rapper1Line(str);
				rap(1); //keep going till you can't
			}else{
				rapper1Line(str + " Uh. Wait. Um...")
			}
		}else{
			if(player1Rhymes.indexOf(firstWord) == -1 && player1Rhymes.indexOf(secondWord) == -1) {
				player2Rhymes.push(firstWord);
				player2Rhymes.push(secondWord);
				rapper2Line(str);
				rap(2); //keep going till you can't.
			}else{
				rapper2Line(str + "Uh. Wait. Um...");
			}
		}
	}


	//TODO, KEEP GOING UNTIL HIT MAX LINES OR NO RHYME (HEY, THAT RHYMED)
	//give up if either word is null or if they match.
}

//red text
function rapper1Line(line){
	$("#rap").append("<font color='red'>"+line+"</font><br>")
}

//blue text
function rapper2Line(line){
	$("#rap").append("<font color='blue'>"+line+"</font><br>")
}
