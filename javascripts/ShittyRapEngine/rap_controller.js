//stay fresh, don't repeat rhymes.

var player1Score = 0;
var player2Score = 0;

//would be so dope to rap about what's happened in the session.
//could read session summary?
//worry about this LATER, and definitely not in this stand alone page.
//for now, rap about your own interests.
window.onload = function() {
		//Math.seed = 612;
		var player1 = randomPlayerWithClaspect(new Session(83475), "Witch", "Time" )
		player1.chatHandle = "squareWave"
		player1.quirk = randomTrollSim(player1);
		var player2 =  randomPlayerWithClaspect(new Session(83475), "Mage", "Space" )//why was it so hard to not type 'ace of space'???
		player2.chatHandle = "sawTooth"
		player2.quirk = randomHumanSim(player2);
		//player2.interest1 = "Programming"
		//player2.interest2 = "Writing"
		rap(1,player1);
		rap(2,player2);
		rap(1,player1);
		rap(2,player2);
		rap(1,player1);
		rap(2,player2);
		$("#score").html("Player1: " + player1Score + " Player2: " + player2Score)

}

function rap(playerNum, player){
	//Math.seed =  getRandomSeed();

	//console.log("Rapping about: " + interest)

	var chosenRapTemplate = getRandomElementFromArray(rapTemplates);

	var raps = chosenRapTemplate.getRapLineForPlayer(player);
	var str = raps[0];
	var firstWord = raps[1];
	var secondWord = raps[2];
	if(playerNum==1){
			rapper1Line(str);
	}else{
			rapper2Line(str);
	}

	if(firstWord && secondWord && firstWord != secondWord){
		if(playerNum==1){
				player1Score ++;
				rap(1,player); //keep going till you can't
				return;
		}else{
				player2Score ++;
				rap(2,player); //keep going till you can't.
				return;
		}
	}else{
		//give up
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
