
/* TODO fix l8r
var globalFraymotifCreator = new FraymotifCreator(null);
loadNavbar();
var curSessionGlobalVar;
List<dynamic> fraymotifSandBoxes = [];

void makeFraymotif(){
		curSessionGlobalVar = new Session(Math.seed);
		var tier = querySelector('[name="tier"] option:selected');
		List<dynamic> aspects = [];
		querySelector('#aspects :selected').each((i, selected){
			aspects.add(querySelector(selected).text());
		});
		//in real sim, won't be shuffled, first player will be first element
		var players = createPlayersFromAspects(aspects);
		curSessionGlobalVar.players = players;
		initPlayerRelationships(players);
		var fraymotif = globalFraymotifCreator.makeFraymotif(shuffle(players), tier.val());
		querySelector("#fraymotifs").append("<br><Br>" + fraymotif +"<button id = 'fm" + fraymotifSandBoxes.length+ "'>Prepare Test</button>");

		var fmsb = new FraymotifSandBox(fraymotif, players);
		querySelector("#fm"+fraymotifSandBoxes.length).click((){
			fraymotifClicked(fmsb);
		});
		fraymotifSandBoxes.add(fmsb);
}



void initPlayerRelationships(players){
	for(num j = 0; j<players.length; j++){
			var p = players[j];
			p.generateRelationships(players);
	}

	decideInitialQuadrants(players);
}



void fraymotifClicked(fs){
	//TODO display list of players and their stats
	//TODO display Dummy of Dummy game entity and it's stats.
	String html = "TODO: list fraymotif flavor text and actual effects here. Confirm they are based on participants aspect associatedStats<br>";
	querySelector("#playerStats").html(html);
	drawStats(fs);

}



void drawStats(fs, flavorText){
	String html = "";
	html += drawFraymotif(fs, flavorText);
	html += "<hr>"+fs.dummy.htmlTitleHP()+ "<hr><br>" +getStatsForPlayer(fs.dummy);
	for(num i = 0; i< fs.players.length; i++){
		var p = fs.players[i];
		html += "<div class = 'playerStat'>"
		html += "<hr>"+p.htmlTitleHP() + p.bloodColor+"<hr><button id = 'player"+fs.players[i].id+"'>+ PlayerPower</button>"
		html += "<hr>" + p.associatedStats.join("<br>") +"<hr>";
 		html += getStatsForPlayer(p);
		html += "</div>";
	}
	querySelector("#playerStats").html(html);

	for(num i = 0; i< fs.players.length; i++){
		var p = fs.players[i];
		wirePlayer(p,fs);
	}

	querySelector("#testFraymotif").click((){
		var flavorText = fs.fraymotif.useFraymotif(fs.players[0], fs.players, [fs.dummy]);
		drawStats(fs, flavorText);
	});
}




dynamic drawFraymotif(fs, flavorText){
	String html = "<div class = 'fraymotifStat'>";
	html += "<hr>" +fs.fraymotif.name+ "<Br><button id = 'testFraymotif'>Use Fraymotif</button> </hr>"
	if(flavorText) html += "<hr>"+flavorText + "</hr><Br><br>";
	html += "<br>"+ fs.fraymotif.condenseEffectsText();
	html += "</div><Br>";
	return html;
}




void wirePlayer(p, fs){
	querySelector("#player"+p.id).click((){
			p.increasePower();
			drawStats(fs);
	});
}




void getStatsForPlayer(player){
	String ret = "";
	var allStats = player.allStats();
//	//print(allStats);

	for(num i = 0; i<allStats.length; i++){
		var stat = allStats[i];
		ret += "<div class='statHolder'><div class='statName'>"+stat+ ":</div><div class = 'statValue'>"
		if(stat != Stats.RELATIONSHIPS){
			ret += Math.round(player[stat]);
			if(player[stat] != player.getStat(stat)) ret += "(" + player.getStat(stat) + " with buffs/debuffs)";
		}else{
			num tmp = 0;
			for(num j = 0; j<player.relationships.length; j++){
			//	//print(player.relationships[j]);
				tmp +=Math.round(player.relationships[j].value);

			}
			ret += tmp;
			if(tmp != player.getStat(stat)) ret += "(" + player.getStat(stat) + " with buffs/debuffs)";
		}
		ret += "</div></div>";
	}
	return ret;
}



dynamic createPlayersFromAspects(aspects){
	//print(aspects);
	List<dynamic> ret = [];
	available_classes = classes; //allow all classes again for next fraymotif.
	available_aspects = all_aspects;
	for(num i = 0; i< aspects.length; i++){
		ret.add(getPlayerForAspect(aspects[i]));
	}
	return ret;
}



dynamic getPlayerForAspect(aspect){
	var ret = randomPlayerWithClaspect(curSessionGlobalVar,getRandomElementFromArray(available_classes),aspect);
	return ret;
}



function shuffle(array) {
	  var currentIndex = array.length, temporaryValue, randomIndex;

	  // While there remain elements to shuffle...
	  while (0 !== currentIndex) {

		// Pick a remaining element...
		randomIndex = Math.floor(Math.random() * currentIndex);
		currentIndex -= 1;

		// And swap it with the current element.
		temporaryValue = array[currentIndex];
		array[currentIndex] = array[randomIndex];
		array[randomIndex] = temporaryValue;
	}

return array;
}


class FraymotifSandBox {

	FraymotifSandBox(this.fraymotif, this.players) {}



	var fraymotif;
	var players;	var dummy = new GameEntity(null, "Dummy",null);	//minLuck, maxLuck, hp, mobility, sanity, freeWill, power, abscondable, canAbscond, framotifs
	this.dummy.setStats(0,10,100,10,10,10,100,false, false, [],1000);
}

*/