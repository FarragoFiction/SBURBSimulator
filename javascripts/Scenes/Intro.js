function Intro(){
	this.canRepeat = false;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.player = null;
	this.trigger = function(playerList, player){
		this.playerList = playerList;
		this.player = player;
		return true; //this should never be in the main array. call manually.
	}

	//TODO consider making this a method in handleSprites, so ALL scenes can get at it.
	//make a pesterchum skin and stick text into it. How much can I fit?
	//describe what land is like "It's full of...Peace", get word that isn't 'Land', 'of' or 'and'.
	this.chat = function(div){
		var repeatTime = 1000;
		var canvasHTML = "<br><canvas id='canvas" + (div.attr("id")) +"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		//first, find/make pesterchum skin. Want it to be no more than 300 tall for now.
		//then, have some text I want to render to it.
		//filter through quirks, and render.  (you can splurge and make more quirks here, future me)
		//does it fit in screen? If it doesn't, what should i do? scroll bars? make pesterchum taller?
		//do what homestuck does and put some text in image but rest in pesterlog?
		//when trolls happen, should they use trollian?
		var player1 = this.player;
		var player2 = player1.getBestFriendFromList(players);
		if(player2 == null){
			player2 = player1.getWorstEnemyFromList(players);

		}
		if(player2 == null){
			return; //give up, forever alone.

		}

		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.

		var chatText = player1Start+ player1.quirk.translate("Hey, I'm in the medium!\n");
		chatText += player2Start + player2.quirk.translate("Good, what's it like?\n");
		chatText += player1Start + player1.quirk.translate("It's the " + player1.land +"\n");
		chatText += player1Start + player1.quirk.translate("So, like, full of <TODO PARSE ONE WORD OF LAND>\n");
		chatText += player2Start + player2.quirk.translate("lol\n");
		chatText += player2Start + player2.quirk.translate("<Mention prototyping. Don't forget to change dialog based on relationships> <or classpect?><light players could be all 'oh, so you're an x player?'>\n");
    chatText += player1Start + player1.quirk.translate("Yes. Or no. I'm not sure. I don't know. \n");
		//TODO change text based on p1 and p2 relationships.  and vice versa. p1 is all flirty, p2 is a dick. yeeeessss.....
		//var spriteBuffer = getBufferCanvas(document.getElementById("canvas_template"));
		setTimeout(function(){
			drawChat(document.getElementById("canvas"+ (div.attr("id"))), player1, player2, chatText, repeatTime);
		}, repeatTime*1.2);  //images aren't always loaded by the time i try to draw them the first time.
	}

	//i is so you know entry order
	this.renderContent = function(div,i){
		var narration = "<br>The " + this.player.htmlTitle() + " enters the game " + indexToWords(i) + ". ";
		if(this.player.leader){
			narration += "They are definitely the leader.";
		}
		if(this.player.godDestiny){
			narration += " They appear to be destined for greatness. ";
		}
		narration += " They boggle vacantly at the " + this.player.land + ". ";

		for(var j = 0; j<this.player.relationships.length; j++){
			var r = this.player.relationships[j];
			if(r.type() != "Friends" && r.type() != "Rivals"){
				narration += "They are " + r.description() + ". ";
			}
		}
		
		kingStrength = kingStrength + 20;
		if(!queenUncrowned && queenStrength > 0){
			queenStrength = queenStrength + 10;
		}
		if(disastor_prototypings.indexOf(this.player.kernel_sprite) != -1) {
			kingStrength = kingStrength + 200;
			if(!queenUncrowned && queenStrength > 0){
				queenStrength = queenStrength + 100;
			}
			narration += " A " + this.player.kernel_sprite + " fell into their kernel sprite just before entering. ";
			narration += " It's a good thing none of their actions here will have serious longterm consequences. ";
		}else if(fortune_prototypings.indexOf(this.player.kernel_sprite) != -1){
			narration += " Prototyping with the " + this.player.kernel_sprite + " just before entering the Medium would prove to be critical for later success. "
		}else{
			narration += " They managed to prototype their kernel with a " + this.player.kernel_sprite + ". ";
		}
		
		div.append(narration);
		this.chat(div);
	}

	this.content = function(div, i){
		var ret = " TODO: Figure out what a non 2.0 version of the Intro scene would look like. "
		div.append(ret);
	}
}
