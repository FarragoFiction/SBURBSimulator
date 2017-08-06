//import "SBURBSim.dart";

// Wait... why am I even doing this? -PL

/***class AuthorMessage extends Scene {
	bool canRepeat = false;

	var player = null;	


	AuthorMessage(Session session) : super(session) {}


	bool trigger(playerList, player){
		this.playerList = playerList;
		this.player = player;
		return true; //this should never be in the main array. call manually.
	}
	void chat(div){
		num repeatTime = 1000;
		String canvasHTML = "<br><canvas id='canvas" + (div.id) +"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		//first, find/make pesterchum skin. Want it to be no more than 300 tall for now.
		//then, have some text I want to render to it.
		//filter through quirks, and render.  (you can splurge and make more quirks here, future me)
		//does it fit in screen? If it doesn't, what should i do? scroll bars? make pesterchum taller?
		//do what homestuck does and put some text in image but rest in pesterlog?
		//when trolls happen, should they use trollian?
		var player1 = this.player;  //author gets pestered
		var player2 = player1.getBestFriendFromList(players);
		if(player2 == null){
			player2 = player1.getWorstEnemyFromList(players);

		}

		var player1Start = player1.chatHandleShort()+ ": ";
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
		var chatText = player1Start +"Holy shit!!!\n";
		chatText += chatLine(player2Start, player2,"What is it?");
		chatText += player1Start + "SBURB Sim 2.0 is finally ready to be released to the public!!!\n";
		chatText += chatLine(player2Start, player2,"Holy shit!");
	  chatText += player1Start +"It probably won't work in EVERY browser, it uses pretty modern features.\n";
		chatText += chatLine(player2Start, player2,"That freaking sucks. ");
		chatText += player1Start +"Yep. But that's what you sacrifice to get good image processing.\n";
		chatText += player1Start +"Oh! But there's an about page where you can learn how to see if it will work for you, and how to contact me if it doesn't.\n";
		chatText += player1Start +"Spoiler alert: If the OC Generator worked for you, this should too. Unless there are bugs.\n";
		chatText += chatLine(player2Start, player2,"Heh, there's probably a TON of bugs. ");
		chatText += player1Start +"I squashed the ones I ran into, at least. Besides corpse's confessing undying love all ironic style.\n";
		chatText += chatLine(player2Start, player2,"What is it with you and corpse bugs? ");
		//TODO change text based on p1 and p2 relationships.  and vice versa. p1 is all flirty, p2 is a dick. yeeeessss.....
		//var spriteBuffer = getBufferCanvas(querySelector("#canvas_template"));
		drawChat(querySelector("#canvas"+ (div.id)), player1, player2, chatText, repeatTime);
	}
	void renderContent(Element div){
		String narration = "<br>And now, a message from me. jadedResearcher.";
		div.append(narration);
		this.chat(div);
	}
	void content(div, i){
		String narration = "<br>And now, a message from me. jadedResearcher. Wait. You're not in 2.0 mode. Nevermind.";
		div.append(narration);
	}

}
***/