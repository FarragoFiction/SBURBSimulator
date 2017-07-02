var globalFraymotifCreator = new FraymotifCreator(null);
loadNavbar();
var curSessionGlobalVar;
var fraymotifSandBoxes = [];

function makeFraymotif(){
		curSessionGlobalVar = new Session(Math.seed);
		var tier = $('[name="tier"] option:selected');
		var aspects = [];
		$('#aspects :selected').each(function(i, selected){
			aspects.push($(selected).text());
		});
		//in real sim, won't be shuffled, first player will be first element
		var players = createPlayersFromAspects(aspects);
		curSessionGlobalVar.players = players;
		initPlayerRelationships(players);
		var fraymotif = globalFraymotifCreator.makeFraymotif(shuffle(players), tier.val());
		$("#fraymotifs").append("<br><Br>" + fraymotif +"<button id = 'fm" + fraymotifSandBoxes.length+ "'>Prepare Test</button>");

		var fmsb = new FraymotifSandBox(fraymotif, players)
		$("#fm"+fraymotifSandBoxes.length).click(function(){
			fraymotifClicked(fmsb)
		});
		fraymotifSandBoxes.push(fmsb);
}

function initPlayerRelationships(players){
	for(var j = 0; j<players.length; j++){
			var p = players[j];
			p.generateRelationships(players);
	}

	decideInitialQuadrants(players);
}

function fraymotifClicked(fs){
	//TODO display list of players and their stats
	//TODO display Dummy of Dummy game entity and it's stats.
	var html = "TODO: list fraymotif flavor text and actual effects here. Confirm they are based on participants aspect associatedStats<br>";
	$("#playerStats").html(html);
	drawStats(fs);

}

function drawStats(fs, flavorText){
	var html = "";
	html += drawFraymotif(fs, flavorText);
	html += "<hr>"+fs.dummy.htmlTitleHP()+ "<hr><br>" +getStatsForPlayer(fs.dummy);
	for(var i = 0; i< fs.players.length; i++){
		var p = fs.players[i];
		html += "<div class = 'playerStat'>"
		html += "<hr>"+p.htmlTitleHP() + p.bloodColor+"<hr><button id = 'player"+fs.players[i].id+"'>+ PlayerPower</button>"
		html += "<hr>" + p.associatedStats.join("<br>") +"<hr>"
 		html += getStatsForPlayer(p);
		html += "</div>"
	}
	$("#playerStats").html(html);

	for(var i = 0; i< fs.players.length; i++){
		var p = fs.players[i];
		wirePlayer(p,fs);
	}

	$("#testFraymotif").click(function(){
		var flavorText = fs.fraymotif.useFraymotif(fs.players[0], fs.players, [fs.dummy]);
		drawStats(fs, flavorText);
	});
}


function drawFraymotif(fs,flavorText){
	var html = "<div class = 'fraymotifStat'>"
	html += "<hr>" +fs.fraymotif.name+ "<Br><button id = 'testFraymotif'>Use Fraymotif</button> </hr>"
	if(flavorText) html += "<hr>"+flavorText + "</hr><Br><br>"
	html += "<br>"+ fs.fraymotif.condenseEffectsText();
	html += "</div><Br>"
	return html;
}


function wirePlayer(p,fs){
	$("#player"+p.id).click(function(){
			p.increasePower();
			drawStats(fs);
	});
}


function getStatsForPlayer(player){
	var ret = "";
	var allStats = player.allStats();
//	console.log(allStats)

	for(var i = 0; i<allStats.length; i++){
		var stat = allStats[i];
		ret += "<div class='statHolder'><div class='statName'>"+stat+ ":</div><div class = 'statValue'>"
		if(stat != "RELATIONSHIPS"){
			ret += Math.round(player[stat]);
			if(player[stat] != player.getStat(stat)) ret += "(" + player.getStat(stat) + " with buffs/debuffs)"
		}else{
			var tmp = 0;
			for(var j = 0; j<player.relationships.length; j++){
			//	console.log(player.relationships[j])
				tmp +=Math.round(player.relationships[j].value)

			}
			ret += tmp;
			if(tmp != player.getStat(stat)) ret += "(" + player.getStat(stat) + " with buffs/debuffs)"
		}
		ret += "</div></div>"
	}
	return ret
}

function createPlayersFromAspects(aspects){
	console.log(aspects);
	var ret = [];
	available_classes = classes; //allow all classes again for next fraymotif.
	available_aspects = all_aspects;
	for(var i = 0; i< aspects.length; i++){
		ret.push(getPlayerForAspect(aspects[i]));
	}
	return ret;
}

function getPlayerForAspect(aspect){
	var ret = randomPlayerWithClaspect(curSessionGlobalVar,getRandomElementFromArray(available_classes),aspect)
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


function FraymotifSandBox(fraymotif, players){
	this.fraymotif = fraymotif;
	this.players = players;
	this.dummy = new GameEntity(null, "Dummy",null)
	//minLuck, maxLuck, hp, mobility, sanity, freeWill, power, abscondable, canAbscond, framotifs
	this.dummy.setStats(0,10,100,10,10,10,100,false, false, [],1000);
}
