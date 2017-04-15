//stay fresh, don't repeat rhymes.
var player1Rhymes = [];
var player2Rhymes = [];

//would be so dope to rap about what's happened in the session.
//could read session summary?
//worry about this LATER, and definitely not in this stand alone page.
//for now, rap about your own interests.
window.onload = function() {
		var interest =  getRandomElementFromArray(interests);
		rap(1,interest);
		rap(2,interest);
		rap(1,interest);
}

function rap(playerNum, interest){
	Math.seed =  getRandomSeed();

	$("#topic").html("Topic: " + interest);
	var chosenRapTemplate = getRandomElementFromArray(rapTemplates);
	var firstWord = chosenRapTemplate.findWordBasedOnPart1AndInterest(interest)
	var secondWord = chosenRapTemplate.findWordBasedOnPart2AndInterestAndPart1Word(interest, firstWord)

	if(firstWord && secondWord && firstWord != secondWord){
		var str = chosenRapTemplate.part1 + firstWord + chosenRapTemplate.part2 + secondWord +"."
		if(playerNum==1){
			if(player1Rhymes.indexOf(firstWord) == -1 && player1Rhymes.indexOf(secondWord) == -1) {
				player1Rhymes.push(firstWord);
				player1Rhymes.push(secondWord);
				rapper1Line(str);
				rap(1,interest); //keep going till you can't
				return;
			}else{
				rapper1Line(str + " Uh. Wait. Um...")
				return;
			}
		}else{
			if(player2Rhymes.indexOf(firstWord) == -1 && player2Rhymes.indexOf(secondWord) == -1) {
				player2Rhymes.push(firstWord);
				player2Rhymes.push(secondWord);
				rapper2Line(str);
				rap(2,interest); //keep going till you can't.
				return;
			}else{
				rapper2Line(str + " Uh. Wait. Um...");
				return;
			}
		}

	}else{
		if(playerNum==1){
				rapper1Line("Um. Shit.");
		}else{
			rapper2Line("Um. Shit.");
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
