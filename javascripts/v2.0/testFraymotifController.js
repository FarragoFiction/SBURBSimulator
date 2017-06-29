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
		var fraymotif = globalFraymotifCreator.makeFraymotif(shuffle(players), tier.val());
		$("#fraymotifs").append("<br><Br>" + fraymotif +"<button id = 'fm" + fraymotifSandBoxes.length+ "'>Prepare Test</button>");
		
		var fmsb = new FraymotifSandBox(fraymotif, players)
		$("#fm"+fraymotifSandBoxes.length).click(function(){
			fraymotifClicked(fmsb)
		});
		fraymotifSandBoxes.push(fmsb);
}

function fraymotifClicked(fs){
	console.log(fs)
	//TODO display list of players and their stats
	//TODO display Dummy of Dummy game entity and it's stats.
	var html = "";	
	for(var i = 0; i< fs.players.length; i++){
		var p = fs.players[i];
		html += "<div class = 'playerStat'>"
		html += "<hr>"+p.htmlTitle() + "<hr>" + getStatsForPlayer(p);
		html += "</div>"
	}
	$("#playerStats").html(html);
}

function getStatsForPlayer(player){
	var ret = "";
	var allStats = player.allStats();
	console.log(allStats)

	for(var i = 0; i<allStats.length; i++){
		var stat = allStats[i];
		ret += "<div class='statHolder'><div class='statName'>"+stat+ ":</div><div class = 'statValue'>"
		if(stat != "RELATIONSHIPS"){
			ret += player[stat];
		}else{
			var tmp = 0;
			for(var j = 0; j<player.relationships.length; j++){
				tmp += player.relationships[j].value
			}
			ret += tmp;
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
}