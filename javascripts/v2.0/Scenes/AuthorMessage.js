function AuthorMessage(){
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
		var player2 = this.player;  //author gets pestered
		var player1 = player2.getBestFriendFromList(players);
		if(player2 == null){
			player2 = player2.getWorstEnemyFromList(players);
			
		}
		
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
		var chatText = chatLine(player1Start, player1,"So, I hear you have grimdark stuff going on now?");
		chatText += chatLine(player2Start, player2,"I don't care.");
		chatText += chatLine(player1Start, player1,"Yeah, just like that! Your font is all shitty and hard to read.");
		chatText += chatLine(player1Start, player1,"And you have no sense of humor.");
		chatText += chatLine(player1Start, player1,"And you aren't using your quirks.");
		chatText += chatLine(player1Start, player1,"And you have that grimdark miasma around you. And your skin is even darker than a troll's. ");
		chatText += chatLine(player2Start, player2,"If it doesn't effect how the simulation works, why would I care?");
		chatText += chatLine(player1Start, player1,"Well, being grimdark erases your relationships, right? It matters to the simulation if you care enough about someone to help them.");
		chatText += chatLine(player2Start, player2,"Why did I go to the trouble to add relationships to this? They don't matter.");
		chatText += chatLine(player1Start, player1,"Geez, grimdark players really are boring. Hopefully you'll die soon and clear that up. Death fixes everything. Well, I mean, unless it's permanent.");

		//TODO change text based on p1 and p2 relationships.  and vice versa. p1 is all flirty, p2 is a dick. yeeeessss.....
		//var spriteBuffer = getBufferCanvas(document.getElementById("canvas_template"));
		drawChat(document.getElementById("canvas"+ (div.attr("id"))), player1, player2, chatText, repeatTime);
	}
	
	//i is so you know entry order
	this.renderContent = function(div){
		var narration = "<br>And now, a message from me. jadedResearcher."
		div.append(narration);
		this.chat(div);
	}
	
	this.content = function(div,i){
		var narration = "<br>And now, a message from me. jadedResearcher. Wait. You're not in 2.0 mode. Nevermind."
		div.append(narration);
	}
}
