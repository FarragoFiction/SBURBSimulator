//not being used anymore since yellow yard is implemented.
function ForeshadowYellowYard(session){
	this.session=session;
	this.canRepeat = false;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.timePlayer;
	//this will be manually triggered, won't be from scene controller.
	//mostly just a collection of methods needed fo this.
	this.trigger = function(playerList){
		this.playerList = playerList;
		return true;
	}

	this.renderContent = function(div){
		//div.append("<br>"+this.content());
		console.log("Yellow yard foreshadowing. " + this.session.session_id)
		var canvasHTML = "<br><canvas id='canvasJRAB" + (div.attr("id")) +"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);

		var canvasDiv = document.getElementById("canvasJRAB"+  (div.attr("id")));
		var chat = "";
		chat += "AB: Out of all the sessions I've seen (and as a flawless robot I have seen FAR more than any human) this one is EASILY in the top percentage of tragedy. Top fucking percent. \n";
		chat += "JR: Shit...you really aren't kidding. \n";
		var quips1 = ["So, you're gonna do something about it, right?", "And that would be why I brought it to your attention.", "Fix this."];
		chat += "AB: " + getRandomElementFromArrayNoSeed(quips1)+"\n" ;
		chat += "JR: Yeah, it is absolutely my intent to make this session (and ones like it) go better. But I'm just not high enough level, yet. I'm working on it. \n "
		var quips2 = ["What do you have planned?", "Yeah?", "Good."];
		chat += "AB: " + getRandomElementFromArrayNoSeed(quips2)+"\n";
		chat += "JR: Hell, I don't even know if what I'm planning will be POSSIBLE, much less how much work it'll be. And it's weird, cause part of me wants to fix this as fast as possible, but, like, the logical part of my brain knows that even if I take a million years to fix this, from the point of view of this session it will happen instantly. More than instantly. In fact, this conversation will never happen and instead it will just be...well, my mysterious plan I refuse to talk about.\n";
		chat += "JR: Although I am not entirely without the time pressure. What was it hussie said?  If I'm not careful I could 'nullify the basic ability of intelligent beings in all real and hypothetical planes of existance to give a shit'. Yeah. I got to get this done before that happens. \n "
		drawChatABJR(canvasDiv, chat);
		chat = "";
		if(this.timePlayer.dead){
			var canvasHTML2 = "<br><canvas id='canvasJRAB2" + (div.attr("id")) +"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
			div.append(canvasHTML2);

			var canvasDiv2 = document.getElementById("canvasJRAB2"+  (div.attr("id")));
			console.log("time player is dead.")
			chat += "JR: Though...I admit that without a time player my plan becomes a lot more impossible. \n "
			chat += "AB: Nah, I took care of that. See? There's the " + this.timePlayer.titleBasic()+" over there, now. Time shenanigans.  I wouldn't have brought you to a completely hopeless session.  \n "
			chat += "JR: Oh! Cool. I guess that if we don't interfere they will boggle vacantly at how badly things went and then try to change things on their own. Like, in the regular session. And become a doomed time clone. Or, I guess if they try not to change things, they'll be in a stable time loop they know ends like this. Man. Being a time player sucks. \n "
			chat += "AB: Word. \n "
			drawChatABJR(canvasDiv2, chat);
		}else{
			console.log("time player is alive.")
		}

	}

	this.content = function(){
		return "This (foreshadow yellow yard) should never be run in 1.0 mode."
	}


}
