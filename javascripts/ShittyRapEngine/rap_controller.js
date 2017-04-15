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
		$("#used_words_player1").html("Player1 Rhymes: " + player1Rhymes)
		$("#used_words_player2").html("Player2 Rhymes: " + player2Rhymes)
}

function rap(playerNum, interest){
	Math.seed =  getRandomSeed();

	$("#topic").html("Topic: " + interest);
	$("#used_words_player1").html("Player1 Rhymes: " + player1Rhymes)
	$("#used_words_player2").html("Player2 Rhymes: " + player2Rhymes)

	var chosenRapTemplate = getRandomElementFromArray(rapTemplates);
	var firstWord = chosenRapTemplate.findWordBasedOnPart1AndInterest(interest)
	var firstWord = tryToUseRhyme(firstWord, playerNum);
	var secondWord = chosenRapTemplate.findWordBasedOnPart2AndInterestAndPart1Word(interest, firstWord)
	var secondWord = tryToUseRhyme(secondWord, playerNum);


	if(firstWord && secondWord && firstWord != secondWord){
		var str = chosenRapTemplate.part1 + firstWord + chosenRapTemplate.part2 + secondWord +"."
		if(playerNum==1){
				rapper1Line(str);
				rap(1,interest); //keep going till you can't
				return;
		}else{
				rapper2Line(str);
				rap(2,interest); //keep going till you can't.
				return;
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

function tryToUseRhyme(rhyme, playerNum){
		var usedRhymes = player1Rhymes;
		if(playerNum == 2){
			usedRhymes = player2Rhymes;
		}
		if(usedRhymes.indexOf(rhyme) == -1){
			usedRhymes.push(rhyme)
			return rhyme;
		}
		//the rhyme is not fresh.
		return null;
}
//red text
function rapper1Line(line){
	$("#rap").append("<font color='red'>"+line+"</font><br>")
}

//blue text
function rapper2Line(line){
	$("#rap").append("<font color='blue'>"+line+"</font><br>")
}
