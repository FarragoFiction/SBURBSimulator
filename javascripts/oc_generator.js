var players = [];

window.onload = function() {
	makeAspectDropDown();
	makeClassDropDown();
    reroll();
}
function reroll(){
	makePlayers();
	describe();
 	drawSpriteAll();
	setTimeout(function(){ drawSpriteAll(); }, 1000);  //images aren't always loaded by the time i try to draw them the first time.
}

function drawSpriteAll(){
  for(var i = 0; i<players.length; i++){
	  makeBG("canvas"+(i+1))
      drawSprite("canvas"+(i+1), players[i]);
	  writeToCanvas('canvas'+(i+1), players[i]);
  }
}

function makeBG(canvasId){
	var c = document.getElementById(canvasId);
	var ctx = c.getContext("2d");

	var grd = ctx.createLinearGradient(0, 0, 170, 0);
	grd.addColorStop(0, "#fefefe");
	grd.addColorStop(1, "#f1f1f1");

	ctx.fillStyle = grd;
	ctx.fillRect(0, 0, c.width, c.height);
}

function writeToCanvas(canvasId, player){
	var space_between_lines = 25;
	var left_margin = 10;
	var start = 350;
	var current = 350;
	var canvas = document.getElementById(canvasId);
	var ctx = canvas.getContext("2d");
	//title
    ctx.font = "30px Times New Roman"
	ctx.fillStyle = getColorFromAspect(player.aspect)
	ctx.fillText(player.title(),canvas.width/3,current);

	//interests
	ctx.font = "18px Times New Roman"
	ctx.fillStyle = "#000000"
	ctx.fillText("Interests: " + player.interests,left_margin,current + space_between_lines*2);

	ctx.fillText("Guardian: " + player.lusus,left_margin,current + space_between_lines*3);

	ctx.fillText("Land: " + player.land,left_margin,current + space_between_lines*4);

	ctx.fillText("Moon: " + player.moon,left_margin,current + space_between_lines*5);

	ctx.fillText("Quirk: " + player.quirk.rawStringExplanation(),left_margin,current + space_between_lines*6);
	

}

function describe(){
	for(var i = 0; i<players.length; i++){
		//decideTroll(players[i]);
		var intro = "<canvas id='canvas" + (i+1) +"' width='400' height='800'>  </canvas>";
		
		//want to move all this into the canvas.
		intro += "<h1> " + players[i].htmlTitle() +" </h1>"
		intro += "<ul>"
		intro += "<li> Land: " + players[i].land
		intro += "<li> Species: "
		if(players[i].isTroll){
			intro += "Troll"
		}else{
			intro += "Human"
		}
		intro += "<li>Blood Color:"
		intro += "<font color= '" + players[i].bloodColor + "'> "
		intro +=  players[i].bloodColor + "</font>"
		if(players[i].isTroll && players[i].aspect == "Blood"){
			intro += " (Blood Player Default)";
		}
		if(players[i].bloodColor == "#610061"){
			intro += " (Seadweller) ";
		}else if(players[i].bloodColor == "#99004d"){
			intro += " (Heiress) ";
		}
		intro += "<li> Guardian: " + players[i].lusus

		intro += "<li> Moon: " +players[i].moon

		var i1 = getRandomElementFromArray(interests);
		var i2 = getRandomElementFromArray(interests);
		//var i2 = i1
		intro += "<Li> Defining Interests: " +i1 + " and " + i2;
		if(i1 == i2){
			intro += " (That wasn't a glitch. They are simply the best there is at " +i1 + ".)"
		}
		intro += "<Li>  Quirk: " + players[i].quirk.stringExplanation() +"</li>";
		intro += "Sample: "
		if(players[i].isTroll){
			intro += "<font color= '" + players[i].bloodColor + "'> "
		}else{
			intro += getFontColorFromAspect(players[i].aspect)
		}
		intro += players[i].quirk.translate(" The quick brown fox (named Lacy) jumped over the lazy dog (named Barkey) over 1234567890 times for reasons. It sure was exciting! I wonder why he did that? Was he going to be late? I wonder....I guess we'll just have to wait and see.");
		intro += " <br><br> <div id = 'gibberish" +i+"'>"
		//randomParagraph("#gibberish"+i, players[i]);
		intro += "</div></font>"

		intro += "</ul>"
		$("#player"+(i+1)).html(intro);
	}
}

function decideHemoCaste(player){
	if(player.aspect != "Blood"){  //sorry karkat
		player.bloodColor = getRandomElementFromArray(bloodColors);
	}
}

function decideLusus(player){
	if(player.bloodColor == "#610061" || player.bloodColor == "#99004d" || players.bloodColor == "#631db4" ){
		player.lusus = getRandomElementFromArray(seaLususTypes);
	}else{
		player.lusus = getRandomElementFromArray(landlususTypes);
	}


}

function randomParagraph(div, player){
	var url = "http://www.randomtext.me/api/gibberish/";
		$.get( url, function( data ) {
			//alert(data.text_out);
			$( div ).html( player.quirk.translate(data.text_out) );
		});
}

function decideTroll(player){
	if(Math.random() > .5){
		player.isTroll = true;
		decideHemoCaste(player);
		decideLusus(player);
		player.quirk = randomTrollQuirk();
	}else{
		player.quirk = randomHumanQuirk();
	}
}

function makeAspectDropDown(){
	available_aspects = nonrequired_aspects.slice(0); //required_aspects
    available_aspects = available_aspects.concat(required_aspects.slice(0));
	var html = '<select name="aspect">'
  	html += '<option value="Any" selected = "selected">Any</option>'
	for(var i = 0; i< available_aspects.length; i++){
		html += '<option value="' + available_aspects[i] + '" >' + available_aspects[i]+'</option>'
	}
	html += '</select>'
	$("#aspectList").append(html);
}

function makeClassDropDown(){
	available_classes = classes.slice(0); //re-init available classes. make deep copy
	var html = '<select name="className">'
  	html += '<option value="Any" selected = "selected">Any</option>'
	for(var i = 0; i< available_classes.length; i++){
		html += '<option value="' + available_classes[i] +'">' + available_classes[i]+'</option>'
	}
	html += '</select>'
	$("#classList").append(html);
}


function makePlayers(){
	players = [];
	
	if($('[name="className"] option:selected').val() == "Any"){
		available_classes = classes.slice(0); //re-init available classes. make deep copy
	}else{
		available_classes = [$('[name="className"] option:selected').val()];	
	}

	if($('[name="aspect"] option:selected').val() == "Any"){
		available_aspects = nonrequired_aspects.slice(0); //required_aspects
   		available_aspects = available_aspects.concat(required_aspects.slice(0));
	}else{
		available_aspects = [$('[name="aspect"] option:selected').val()];	
	}

	
	
	
	var numPlayers = 3;

	for(var i = 0; i<numPlayers; i++){
		p = (randomPlayerWithoutRemoving());
		decideTroll(p);
		players.push(p);
	}
 // players[0].class_name = "Page" //for testing

}
