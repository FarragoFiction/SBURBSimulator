/*TOOD fix

var session = new Session();
List<dynamic> players = [];
bool simulationMode = false;
var dataURLs = {};
window.onload = () {
	loadNavbar();
	loadFuckingEverything("oc");
	makeAspectDropDown();
	makeClassDropDown();
	makeSpeciesDropDown();
	makeColorDropDown();
	 querySelector('#godTier').attr('checked','checked');

	 querySelector('#godTier').change(() {
		 for(num i = 0; i<players.length; i++){
			 players[i].godTier = !players[i].godTier;
		 }
		 drawSpriteAll();
	 });
//  reroll();
}
void reroll(){
	//;
	makePlayers();
	//describe();
 	drawSpriteAll();


}



void renderDownloadURLs(){
	var keys = Object.keys(dataURLs);
	for(num i = 0; i<keys.length; i++){
		querySelector("#"+keys[i]+"url").html("<a href = '" +dataURLs[keys[i]] + "'  target='_blank'> Download Character</a><br>" );
	}
	//drawSpriteAll();
}



void drawSpriteAll(){
	for(num i = 0; i<players.length; i++){
	  makeBG(querySelector("#canvas"+(i+1)));
      drawSpriteFromScratch(querySelector("#canvas"+(i+1)), players[i],1000);
	  writeToCanvas(querySelector("#canvas"+(i+1)), players[i]);
	  //makeWriteDataURL("canvas"+(i+1) )//for writing data.  too early to do it here, might not see full render
	}

	setTimeout((){
		//drawSpriteAll(); //drawing sprites the first time will handle this.
		for(num i = 0; i<players.length; i++){
			makeWriteDataURL("canvas"+(i+1) )//for writing data.
	}
		renderDownloadURLs();
	}, 1000);  //images aren't always loaded by the time i try to draw them the first time.

}



void makeWriteDataURL(canvasId){
	canvas = querySelector("#${canvasId}");
	dataURLs[canvasId] = canvas.toDataURL();
}


void makeBG(c){
	//var c = querySelector("#${canvasId}");
	var ctx = c.getContext("2d");

	var grd = ctx.createLinearGradient(0, 0, 170, 0);
	grd.addColorStop(0, "#fefeff");
	grd.addColorStop(1, "#f1f1ff");

	ctx.fillStyle = grd;
	ctx.fillRect(0, 0, c.width, c.height);
}



void writeToCanvas(canvas, player, canvasId){
	num space_between_lines = 25;
	num left_margin = 10;
	num line_height = 18;
	num start = 350;
	num current = 350;
	var ctx = canvas.getContext("2d");
	//title
    ctx.font = "40px Times New Roman";
	ctx.fillStyle = getColorFromAspect(player.aspect);
	ctx.fillText(player.titleBasic(),left_margin*2,current);

	//interests
	ctx.font = "18px Times New Roman";
	ctx.fillStyle = "#000000";
	var interests = player.interest1 + " and " + player.interest2;
	ctx.fillText("Interests: " + interests,left_margin,current + space_between_lines*2);

	ctx.fillText("Chat Handle: " + player.chatHandle,left_margin,current + space_between_lines*3);

	ctx.fillText("Guardian: " + player.lusus,left_margin,current + space_between_lines*4);

	ctx.fillText("Land: " + player.land,left_margin,current + space_between_lines*5);

	ctx.fillText("Moon: " + player.moon,left_margin,current + space_between_lines*6);

	//TODO need to handle new line myself.  font is 18 px tall. work with that. each new line adds to the count (which is now 6)
	//ctx.fillText("Quirk: " + player.quirk.rawStringExplanation(),left_margin,current + space_between_lines*6);
	var text2 = player.quirk.translate(" The quick brown fox (named Lacy) jumped over the lazy dog (named Barkey) over 1234567890 times for reasons. It sure was exciting! I wonder why he did that? Was he going to be late? I wonder... I guess we'll just have to wait and see.");
	var color2 = player.getChatFontColor();

	fillTextMultiLine(canvas, "Quirk: " + player.quirk.rawStringExplanation() + "\n \n Sample: \n", text2, color2, left_margin, current + space_between_lines*7);


      // set canvasImg image src to dataURL
      // so it can be saved as an image
}





//deprecated in favor of pure canvas
void describe(){
	for(num i = 0; i<players.length; i++){
		//decideTroll(players[i]);
		String intro = "<canvas id='canvas" + (i+1) +"' width='400' height='800'>  </canvas>";

		//want to move all this into the canvas.
		intro += "<h1> " + players[i].htmlTitle() +" </h1>";
		intro += "<ul>";
		intro += "<li> Land: " + players[i].land;
		intro += "<li> Species: ";
		if(players[i].isTroll){
			intro += "Troll";
		}else{
			intro += "Human";
		}
		intro += "<li>Blood Color:";
		intro += "<font color= '" + players[i].bloodColor + "'> "
		intro +=  players[i].bloodColor + "</font>";
		if(players[i].isTroll && players[i].aspect == "Blood"){
			intro += " (Blood Player Default)";
		}
		if(players[i].bloodColor == "#610061"){
			intro += " (Seadweller) ";
		}else if(players[i].bloodColor == "#99004d"){
			intro += " (Heiress) ";
		}
		intro += "<li> Guardian: " + players[i].lusus;

		intro += "<li> Moon: " +players[i].moon;

		var i1 = players[i].interest1;
		var i2 = players[i].interest2;
		//var i2 = i1;
		intro += "<Li> Defining Interests: " +i1 + " and " + i2;
		if(i1 == i2){
			intro += " (That wasn't a glitch. They are simply the best there is at " +i1 + ".)";
		}
		intro += "<Li>  Quirk: " + players[i].quirk.stringExplanation() +"</li>";
		intro += "Sample: ";
		if(players[i].isTroll){
			intro += "<font color= '" + players[i].bloodColor + "'> "
		}else{
			intro += players[i].aspect.fontTag();
		}
		intro += players[i].quirk.translate(" The quick brown fox (named Lacy) jumped over the lazy dog (named Barkey) over 1234567890 times for reasons. It sure was exciting! I wonder why he did that? Was he going to be late? I wonder....I guess we'll just have to wait and see.");
		intro += " <br><br> <div id = 'gibberish" +i+"'>"
		//randomParagraph("#gibberish"+i, players[i]);
		intro += "</div></font>";

		intro += "</ul>";
		querySelector("#player"+(i+1)).html(intro);
	}
}



void decideHemoCaste(player){
	if(player.aspect != "Blood"){  //sorry karkat
		if(querySelector('[name="color"] option:selected').val() == "Any"){
			player.bloodColor = rand.pickFrom(bloodColors);
		}else{
			//do i want blood color to be a drop down, too? can make bg the blood color?
			player.bloodColor = querySelector('[name="color"] option:selected').val();
		}


	}
}





void randomParagraph(div, player){
	String url = "http:;//www.randomtext.me/api/gibberish/";
		$.get( url, ( data ) {
			//alert(data.text_out);
			querySelector( div ).html( player.quirk.translate(data.text_out) );
		});
}



void decideTroll(player){
	if(querySelector('[name="species"] option:selected').val() == "Any" && rand.nextDouble() > .5 ){
		player.isTroll = true;
		decideHemoCaste(player);
		player.decideLusus();
		player.hairColor = "#000000";
		player.quirk = randomTrollQuirk(player);
	}else if(querySelector('[name="species"] option:selected').val() == "Troll"){
		player.isTroll = true;
		decideHemoCaste(player);
		player.decideLusus(player);
		player.hairColor = "#000000";
		player.quirk = randomTrollQuirk(player);
	}else{
		player.isTroll = false;
		player.bloodColor = "#ffffff";
		player.hairColor = rand.pickFrom(human_hair_colors);
		player.quirk = randomHumanQuirk(player);
	}
}



void makeColorDropDown(){
	String html = '<select name="color">';
  	html += '<option value="Any" selected = "selected">Any</option>';
	for(num i = 0; i< bloodColors.length; i++){
		html += '<option  style="background:'+bloodColors[i]+'"" value="' + bloodColors[i] + '" >' + bloodColors[i]+'</option>';
	}
	html += '</select>';
	querySelector("#colorList").append(html);
}



void makeAspectDropDown(){
	available_aspects = nonrequired_aspects.slice(0); //required_aspects
    available_aspects = available_aspects.concat(required_aspects.slice(0));
	String html = '<select name="aspect">';
  	html += '<option value="Any" selected = "selected">Any</option>';
	for(num i = 0; i< available_aspects.length; i++){
		html += '<option value="' + available_aspects[i] + '" >' + available_aspects[i]+'</option>'
	}
	html += '</select>';
	querySelector("#aspectList").append(html);
}



void makeSpeciesDropDown(){
	String html = '<select name="species">';
  html += '<option value="Any" selected = "selected">Any</option>';
	html += '<option value="Human">Human</option>'
	html += '<option value="Troll" >Troll</option>'
	html += '</select>';
	querySelector("#speciesList").append(html);
}




void makeClassDropDown(){
	available_classes = classes.slice(0); //re-init available classes. make deep copy
	String html = '<select name="className">';
  	html += '<option value="Any" selected = "selected">Any</option>';
	for(num i = 0; i< available_classes.length; i++){
		html += '<option value="' + available_classes[i] +'">' + available_classes[i]+'</option>'
	}
	html += '</select>';
	querySelector("#classList").append(html);
}




void makePlayers(){
	players = [];

	if(querySelector('[name="className"] option:selected').val() == "Any"){
		available_classes = classes.slice(0); //re-init available classes. make deep copy
	}else{
		available_classes = [querySelector('[name="className"] option:selected').val()];
	}

	if(querySelector('[name="aspect"] option:selected').val() == "Any"){
		available_aspects = nonrequired_aspects.slice(0); //required_aspects
   	available_aspects = available_aspects.concat(required_aspects.slice(0));
	}else{
		available_aspects = [querySelector('[name="aspect"] option:selected').val()];
	}


	num numPlayers = 4;

	for(int i = 0; i<numPlayers; i++){
		p = (randomPlayerWithoutRemoving(session));
		if( querySelector('#godTier').attr('checked')=='checked'){
			p.godTier = true;
		}else{
			p.godTier = false;
		}

		decideTroll(p);
		players.add(p);
	}
 // players[0].class_name = "Page" ;//for testing;

}
*/