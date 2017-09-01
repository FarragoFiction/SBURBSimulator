import '../SBURBSim.dart';
import "dart:html";

//stay fresh, don't repeat rhymes.

num player1Score = 0;
num player2Score = 0;

//would be so dope to rap about what's happened in the session.
//could read session summary?
//worry about this LATER, and definitely not in this stand alone page.
//for now, rap about your own interests.
main() {
		//Math.seed = 612;
		Session session = new Session(83475);
		var player1 = randomPlayerWithClaspect(session, SBURBClassManager.WITCH, Aspects.TIME );
		player1.chatHandle = "squareWave";
		player1.quirk = randomTrollSim(session.rand, player1);
		var player2 = randomPlayerWithClaspect(session, SBURBClassManager.WITCH, Aspects.SPACE );//why was it so hard to not type 'ace of space'???;
		player2.chatHandle = "sawTooth";
		player2.quirk = randomHumanSim(session.rand, player2);
		//player2.interest1 = "Programming";
		//player2.interest2 = "Writing";
		rap(1,player1);
		rap(2,player2);
		rap(1,player1);
		rap(2,player2);
		rap(1,player1);
		rap(2,player2);
		setHtml(querySelector("#score"), "Player1: $player1Score Player2: $player2Score");

}

void rap(playerNum, Player player){
	//Math.seed =  getRandomSeed();

	////print("Rapping about: " + interest);

	var chosenRapTemplate = player.session.rand.pickFrom(rapTemplates);

	var raps = chosenRapTemplate.getRapLineForPlayer(player);
	var str = raps[0];
	var firstWord = raps[1];
	var secondWord = raps[2];
	if(playerNum==1){
			rapper1Line(str);
	}else{
			rapper2Line(str);
	}

	if(firstWord != null && secondWord != null && firstWord != secondWord){
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
void rapper1Line(line){
	querySelector("#rap").appendHtml("<font color='red'>"+line+"</font><br>",treeSanitizer: NodeTreeSanitizer.trusted);
}



//blue text
void rapper2Line(line){
	querySelector("#rap").appendHtml("<font color='blue'>"+line+"</font><br>",treeSanitizer: NodeTreeSanitizer.trusted);
}
