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
		
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShort()+ ":";
		var chatText = player1Start+ player1.quirk.translate("This is just a test.");
		chatText += player2Start + player2.quirk.translate("I can believe it. It's pretty shitty.");
		debug("fix chat initials code. only getting first cause no space separation");
		//var spriteBuffer = getBufferCanvas(document.getElementById("canvas_template"));
		drawChat(document.getElementById("canvas"+ (div.attr("id"))), player1, player2, chatText, repeatTime);
	}
	
	//i is so you know entry order
	this.content = function(div,i){
		debug("need to handle dialog next")
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
		div.append(narration);
		this.chat(div);
	}
}
