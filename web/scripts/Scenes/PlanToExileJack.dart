import "dart:html";
import "../SBURBSim.dart";


class PlanToExileJack extends Scene {

	var planner = null;	//a player has to be not busy to be your friend right now.
  bool canRepeat = false;
	PlanToExileJack(Session session): super(session, false);

	@override
	bool trigger(playerList){
		this.playerList = playerList;
		this.findSympatheticPlayer();
		////session.logger.info("Planner: " + this.planner + " jack hp: " + this.session.jack.getStat(Stats.CURRENT_HEALTH) + " jack crowned: " + this.session.jack.crowned );
		return this.planner != null && 	this.session.npcHandler.jack.getStat(Stats.CURRENT_HEALTH) > 0 && !this.session.npcHandler.jack.dead  && 	this.session.npcHandler.jack.crowned == null && !this.session.npcHandler.jack.exiled;
	}
	void findSympatheticPlayer(){
		var living = findLivingPlayers(this.session.getReadOnlyAvailablePlayers());
		this.planner =  findAspectPlayer(living, Aspects.MIND);
		if(this.planner == null){
			this.planner =  findAspectPlayer(living, Aspects.DOOM);
		}else if(this.planner == null){
			this.planner =  findAspectPlayer(living, Aspects.LIGHT);
		}else if(this.planner == null){
			this.planner =  findClassPlayer(living, SBURBClassManager.SEER);
		}
	}
	dynamic grimChat2(div, player1, player2){
		var player1Start = player1.chatHandleShort()+ ": ";
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		String chatText = "";
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);

		chatText += Scene.chatLine(player1Start, player1,Relationship.getRelationshipFlavorGreeting(r1, r2, player1, player2));
		chatText += Scene.chatLine(player1Start, player1,"So, new plan. Jack is WAY too stabby, we need to exile him.");
		if(this.smart(player2)){
				chatText += Scene.chatLine(player2Start, player2,"Agreed.");
		}else{
			chatText += Scene.chatLine(player2Start, player2,"I don't see how this helps us beat the game.");
			chatText += Scene.chatLine(player1Start, player1,"Look, if we're constantly being stabbed, then we're not exactly climbing our echeladders, right?");
			chatText += Scene.chatLine(player1Start, player1,"Just trust me, we can focus on the game once the stabs stop.");
		}
		chatText += Scene.chatLine(player1Start, player1,"We'll keep up the ruse of exiling the Black Queen.");
		chatText += Scene.chatLine(player1Start, player1,"But also 'accidentally' take out Jack's allies at the same time.");
		chatText += Scene.chatLine(player1Start, player1,"Then, we exile Jack.");
		chatText += Scene.chatLine(player2Start, player2,"Fine.");

		return chatText;
	}
	dynamic grimChat1(div, player1, player2){
			var player1Start = player1.chatHandleShort()+ ": ";
			var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
			String chatText = "";

			chatText += Scene.chatLine(player1Start, player1,"In order to beat the game quicker, we will now be exiling Jack.");

			if(this.smart(player2)){
				chatText += Scene.chatLine(player2Start, player2,"Makes sense. How will we pull it off without getting stabbed?");
				chatText += Scene.chatLine(player1Start, player1,"We will continue working with Jack to exile the Black Queen.");
				chatText += Scene.chatLine(player1Start, player1,"While also exiling Jack's allies and weakening him in other ways. With deniability.");
				chatText += Scene.chatLine(player2Start, player2,"Here's hoping it works.");
			}else{
				chatText += Scene.chatLine(player2Start, player2,"What!? No way! He's our ALLY!");
				chatText += Scene.chatLine(player1Start, player1,"You are a fool. His betrayal is inevitable.");
				chatText += Scene.chatLine(player2Start, player2,"Okay. MAYBE he's a little stabby.  But that's part of his charm!");
				chatText += Scene.chatLine(player2Start, player2,"Also, he is way too terrifying to backstab.");
				chatText += Scene.chatLine(player1Start, player1,"Ideally, he will never suspect our treachery.");
				chatText += Scene.chatLine(player1Start, player1,"We will continue working with Jack to exile the Black Queen.");
				chatText += Scene.chatLine(player1Start, player1,"While also exiling Jack's allies and weakening him in other ways. With deniability.");
				chatText += Scene.chatLine(player2Start, player2,"Fuck.");
			}

			return chatText;

		}
	dynamic grimChatBoth(div, player1, player2){
		var player1Start = player1.chatHandleShort()+ ": ";
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		String chatText = "";

		chatText += Scene.chatLine(player1Start, player1,"In order to beat the game quicker, we will now be exiling Jack.");

		if(this.smart(player2)){
			chatText += Scene.chatLine(player2Start, player2,"Agreed.");
			chatText += Scene.chatLine(player1Start, player1,"We will continue working with Jack to exile the Black Queen.");
			chatText += Scene.chatLine(player1Start, player1,"While also exiling Jack's allies and weakening him in other ways. With deniability.");
			chatText += Scene.chatLine(player2Start, player2,"Fine.");
		}else{
			chatText += Scene.chatLine(player2Start, player2,"I don't see how this helps us beat the game.");
			chatText += Scene.chatLine(player1Start, player1,"You are a fool. His betrayal is inevitable.");
			chatText += Scene.chatLine(player2Start, player2,"It might not become relevant until we have left the Medium.");
			chatText += Scene.chatLine(player1Start, player1,"I want nothing to risk our Ascension.");
			chatText += Scene.chatLine(player2Start, player2,"Betraying Jack is a risk of its own.");
			chatText += Scene.chatLine(player1Start, player1,"Ideally, he will never suspect our treachery.");
			chatText += Scene.chatLine(player1Start, player1,"We will continue working with Jack to exile the Black Queen.");
			chatText += Scene.chatLine(player1Start, player1,"While also exiling Jack's allies and weakening him in other ways. With deniability.");
			chatText += Scene.chatLine(player2Start, player2,"I will hold you accountable should this fail.");
		}



		return chatText;
	}
	dynamic normalConvo(div, player1, player2){
		var player1Start = player1.chatHandleShort()+ ": ";
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);
		String chatText = "";

		chatText += Scene.chatLine(player1Start, player1,Relationship.getRelationshipFlavorGreeting(r1, r2, player1, player2));
		chatText += Scene.chatLine(player2Start, player2,Relationship.getRelationshipFlavorGreeting(r2, r1, player2, player1));
		chatText += Scene.chatLine(player1Start, player1,"So, new plan. Jack is WAY too stabby, we need to exile him.");
		if(this.smart(player2)){
			chatText += Scene.chatLine(player2Start, player2,"Makes sense. How will we pull it off without getting stabbed?");
			chatText += Scene.chatLine(player1Start, player1,"We keep up the ruse of exiling the Black Queen.");
			chatText += Scene.chatLine(player1Start, player1,"But also 'accidentally' take out Jack's allies at the same time.");
			chatText += Scene.chatLine(player1Start, player1,"Then, we exile Jack.");
			chatText += Scene.chatLine(player2Start, player2,"Here's hoping it works.");
		}else{
			chatText += Scene.chatLine(player2Start, player2,"What!? No way! He's our ALLY!");
			chatText += Scene.chatLine(player1Start, player1,"What part of 'stabby' isn't getting through to you?");
			chatText += Scene.chatLine(player1Start, player1,"You can't spell 'backstab' without 'stab'. We have to backstab him first.");
			chatText += Scene.chatLine(player2Start, player2,"But you said it yourself: He's the BEST at stabs!");
			chatText += Scene.chatLine(player1Start, player1,"And that's why we're going to plan this. We'll take out his allies.");
			chatText += Scene.chatLine(player1Start, player1,"And exile him before he knows anything is going on.");
			chatText += Scene.chatLine(player2Start, player2,"I want it on the official record that this is a bad idea.");
			chatText += Scene.chatLine(player1Start, player1,"Yes.");
		}

		return chatText;
	}
	void chatWithFriend(Element div, Player player1, Player player2){
		num repeatTime = 1000;
		var divID = (div.id) + "_${player1.id}";
		String canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth.toString() + "' height="+canvasHeight.toString() + "'>  </canvas>";
		appendHtml(div,canvasHTML);
		//different format for canvas code
		var canvasDiv = querySelector("#canvas"+ divID);


		String chatText = "";
		if(player1.grimDark  > 1 && player2.grimDark  > 1){
			chatText += this.grimChatBoth(div,player1, player2);
		}else if(player1.grimDark  > 1){
			chatText += this.grimChat1(div,player1, player2);
		}else if(player2.grimDark  > 1){
			chatText += this.grimChat2(div,player1, player2);
		}else{
			chatText += this.normalConvo(div,player1, player2);
		}

		Drawing.drawChat(canvasDiv,player1, player2, chatText,"discuss_jack.png");
	}
	bool smart(Player player){
		return ((player.aspect == Aspects.LIGHT || player.class_name == SBURBClassManager.SEER) ||(player.aspect == Aspects.DOOM || player.aspect == Aspects.MIND));
	}

	@override
	void renderContent(Element div){
		this.session.stats.plannedToExileJack = true;
		if(this.planner == null){
			return;
		}
		this.planner.increasePower();
		session.removeAvailablePlayer(planner);
		this.session.available_scenes.insert(0, new prepareToExileJack(this.session));
		this.session.available_scenes.insert(0, new ExileJack(this.session));
		this.session.available_scenes.insert(0, new ExileQueen(this.session));  //make it top priority, so unshift, don't push
		Player player1 = this.planner;
		Player player2 = getLeader(findLivingPlayers(	this.session.players));
		if(player2 != null && player2 != player1){
			//player tells leader what happened.
			this.chatWithFriend(div,player1, player2);
		}else if(player2 == player1){
			//leader gossips with friends
			player2 = player1.getBestFriendFromList(findLivingPlayers(	this.session.players));
			if(player2 == null){
				appendHtml(div,this.content());
				return;
			}else{
				this.chatWithFriend(div,player1, player2);
			}
		}else{
			//we get a narration
			appendHtml(div,this.content());
		}
	}
	String content(){
		if(!this.planner){
			return "";//this should theoretically never happen
		}
		this.planner.increasePower();
		session.removeAvailablePlayer(planner);
		this.session.available_scenes.insert(0, new prepareToExileJack(this.session));
		this.session.available_scenes.insert(0, new ExileJack(this.session));
		String ret = " The " + this.planner.htmlTitle() + " is getting a bad feeling about Jack Noir. ";
		ret += " Even though he is their ally, he has stabbed players on multiple occasions, for example. ";
		ret += "There's only so many 'accidents' a single Desite can reasonably have. ";
		ret += "A plan is pulled together.  If a Queen can be exiled, why not a Jack as well? ";
		ret += " Of course, it wouldn't do to tip Jack off to the change of allegiance. You may as well continue to weaken the Queen while you're at it. ";
		return ret;
	}

}
