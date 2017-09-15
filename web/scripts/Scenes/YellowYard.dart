import "dart:html";
import "../SBURBSim.dart";

class YellowYard extends Scene {
	Player timePlayer;

	//this will be manually triggered, won't be from scene controller.
	//mostly just a collection of methods needed fo this.


	YellowYard(Session session) : super(session, false);


	@override
	bool trigger(List<Player> playerList) {
		this.playerList = playerList;
		return true;
	}

	void yellowYardTime(Element div) {
		if(this.session.mutator.mindField) {
			//old man JR shakes their fist at those damn punk kids who won't stay away from their Yard.
			div.appendHtml("... What. Where the fuck is my Yard? God DAMN those n00b Wastes of Mind. What the fuck is WRONG WITH THEM? Don't they know they need to stay the fuck away from my Yard? Go use their fucking Cataclysm. See if I care.  Today is the day you fuck shit up forever.");
			return;
		}
		this.session.stats.yellowYard = true;

		Element div2 = null;
		String tmp = "<div id = 'yyholder'></div><bR>";
		appendHtml(div, tmp);
		div2 = querySelector("#yyholder");
		//this.timePlayer.wasteInfluenced = true; //can't go back now. shit, yes you can scratch
		Player time = this.getDoomedTimeClone();

		time.influenceSymbol = "mind_forehead.png";
		//String html = "<img src = 'images/yellow_yard.png'>";
		String html = "<div id = 'fthwall' style='background:url(images/4thwall.png); width:1000px; height:521px;'>";
		appendHtml(div2, html);
		querySelector("#fthwall").onClick.listen((Event e) {
			//helloWorld();
			String html = "<div id = 'yellow_yard.png' style='background:url(images/yellow_yard.png); width:1000px; height: 521px'>";
			yyrEventsGlobalVar = session.importantEvents;
			num count = 14;  //<-- why couldn't this have been 13. missed opportunity.
			//yyrEventsGlobalVar = padEventsToNumWithKilling(yyrEventsGlobalVar, this.session, time,num);
			//yyrEventsGlobalVar = sortEventsByImportance(yyrEventsGlobalVar);  this edges out diversity. end up with all "make so and so god tier" and nothing else
			yyrEventsGlobalVar = ImportantEvent.removeRepeatEvents(yyrEventsGlobalVar);
			yyrEventsGlobalVar = ImportantEvent.removeFrogSpam(yyrEventsGlobalVar);
			html +=
			"<div id = 'decisions' style='overflow:hidden; position: relative; top: 133px; left: 280px; font-size: 12px; width:480px;height:280px;'> ";
			for (int i = 0; i < count; i++) {
				if (i < yyrEventsGlobalVar.length) {
					yyrEventsGlobalVar[i].doomedTimeClone = time;
					//String customRadio = "<img src = 'images/mind_radio.png' id = 'decision"+i+  "'>";
					//http://www.tutorialrepublic.com/faq/how-to-create-custom-radio-buttons-using-css-and-jquery.php
					html += " <span class='custom-radio'><input type='radio' name='decision' value='$i'></span>${yyrEventsGlobalVar[i].humanLabel()}<br>";
				} else { //no more important events to undo
					//html += "<br>";
				}
			}

			////session.logger.info(session.yellowYardController.eventsToUndo.length);
			////session.logger.info("add events to undo to the radio button. on the right side.");


			html +=
			"</div><button id = 'yellowButton' style = 'position: relative; top: 133px; left: 280px;'>Decide</button>";
			html +=
			"<div id = 'undo_decisions' style='overflow: hidden; position: relative; top: -150px; left: 0px; font-size: 12px; width:190px; height:300px; float:right;'> ";
			for (num i = 0; i <
				session.yellowYardController.eventsToUndo.length; i++) {
				var decision = session.yellowYardController.eventsToUndo[i];
				html +=
					" <span class='custom-radio'><input type='radio' name='decision' value='${i + yyrEventsGlobalVar.length}'></span>Undo ''${decision.humanLabel()}''<br>";
			}
			html += "</div>";
			html += "</div><br>";

			setHtml(div2, html);
      (querySelector("#yellowButton") as ButtonElement).onClick.listen((e) => decision());


      //wire up custom radio buttons after they are rendered
			List<Element> radioButtons = querySelectorAll('input[name="decision"]');
			for (RadioButtonInputElement radioButton in radioButtons) {
				radioButton.onClick.listen((Event e) {
					//session.logger.info("a radio button was clicked");
					if (radioButton.checked) {
						//session.logger.info("the radio button should be selected");
						radioButton.parent.classes.add("selected");
					}
					for (RadioButtonInputElement r in radioButtons) {
						if (r != radioButton) {
							r.classes.remove("selected");
						}
					}
				});
			}
		});
	}

	/*




```````   `                 `  ``   `                        ```````                           `
```` `   `   ````           `````   `   `````               ````  `   `` ````                ````  `   ``` `
```               ````        ```             ````           ```                ```          ```             ````
``                   ```      ``                 ```         ```                  ```        ```                ``
`````..``.`..`````````.``.``-``.``..`..``.```.``..``.``.``.``.``.``-`.-``.``.`..``.``.``..`..``.``.``.```..``.``..`..````..````
`.-............-..-...-.....-........................................................................-.......................-.`
`.-..........................................................................................................................-.`
`......:-....-::::::::::----:++++++++++++++oo+++::::::::::::::...::::::::::::::---------::::::::::::::::::::::::::-....-:......`
`.-..../.                 -ohddddddddddddddddddhh+`           `.`                                                      ./....-.`
`......+.              .+yhddddddddddddddddmmmmmddy.          `.`                            `     `                   .+......`
`````.-....+.           `:shddddddddddddddddmNNNNNNNNmdy.         `.``.+o+.`  `.oo/.           .sh   .sh                   .+....-.` ```
```   `......+.         -ohdddddddddddddddmmNNNNNNNNNNNNmdy`        `.`  +d+      sd:             yd    yd                   .+......`   ```
```   `.:....+.         .yddddddddddddmmddNNNNmshNNNNmmNNmdo        `.`  +d+      sd-    ---:.    yd    yd    `---:.         .+....:.`    ```
```    `......+-          `+hdddddddddms:-hNdyo.``:shmN+omNdh-       `.`  +do------yd-  -s.``-ho   yd    yd   /o```-ss`       -+......`    ```
```    `.-....+:            .ohddddddy-``.:-.````````.-:`-NNdo       `.`  +d+``````yd-  yy:::://`  yd    yd  -h:    -do       :+....-.`    ```
```   `......+-              .+hdddds```````````````````.NNmh.      `.`  +d+      sd-  yh.    .`  yd    yd  :do    `d+       -+......`    ```
```   `.-..../.                .sddddy-`````````````````+Nmdo`      `.`  odo      yd:  -yho//+:   yd    yd   +h/` `/o`  /o.  ./....-.`    ``
`````....../.                 -yddddh/```````````````/dyo-        `.``.:::.`  `.::-`  `-//:.   .::.  .::.   .::-..    -/`  ./......` ````
````......+.                /hddddddds:``````````.-/:.`          `.`                                                      .+......````
`......+.               -ddmddddddddo-..-//+ohms              `.`                                                      .+......`
`.-....+.              -hdNmddddddddddhhdddddyNh              `.`                                                      .+....-.`
`-.....+.           .-ohddmdddddddddddhhdddddso:              `.`                                                      .+.....-`
``......+.          .ohdddddddddddddddhs/ddddddh:              `.`                                                      .+......`
````......+.         ```:hdddddddddddddh+--/hdddddh-             `.`                                                      .+......`````
```  `......+-      ``````.hddddddddddddho....+dddddy`             `.`                                                      -+......`  ```
````  `.:...-+:   ``````` `odddddddddddddo/-..-+sdds/.``            `.`                                                      :+-...:.`   ```
```   `....../-`````````   :sssssssyyyyyys+o++o+syyo `````          `.`               ````````````````                       -/......`    ``
```   `........````````````--------:::::::::::::::::.````````````````.````````````````````````````````````````````````````````.......`    ``
```   `....../```````      -+syyyhhhhhhhhhddddddhyo/.    ```        `.`                                                      `+......`   ```
``   `.....-+`   `````       ``.shdddddddddddddo         ```       `.`                                                      `+-.....`   ```
``` `.....-+`      `````   ````-/hddddddddddddh-         ```      `.`                                                      `+-.....`  ``
```.-...-+`          ````````..:oddddddddddddh.         ```     `.`                                                      `+-...-.```
`.....-+.                 :shyddddddddddddddy.         ```    `.`                                                      .+-.....`
`.-...-+.                 sddddddddddddddddddy.        ```    `.`                                                      .+-...-.`
`......+`                 ydddddddddddddddddddh.        ```   `.`                                                      `+......`
````......+`                -hydddddddddddddddddddy`        ``   `.`                                                      `+......`````
```  `......+`                +hsdddddddddddddddddddds`        ``  `.`                                                      `+......`  ````
```   `.....-+`                +y+hddddddddddddddddddddo         `` `.`                                                      `+-.....`   ```
```   `.-...-+`                ys+yddddddddddddddddddddd/         ` `.`                                                      `+-...-.`    ```
```   `.....-+`               -d++sdddddddddddddddddddddh-        ```.`                                                      `+-.....`    ```
```   `:....-+`               -s++ohhhhhddhdddddddhhhhyso+        ` `..`

*/
   @override
	void renderContent(Element div){
		this.session.stats.yellowYard = true;
		//div.append("<br>"+this.content());
		////session.logger.info("Yellow yard is happening. " + this.session.session_id);
		String canvasHTML = "<br><canvas id='canvasJRAB1${div.id}' width='$canvasWidth' height='$canvasHeight'>  </canvas>";
		appendHtml(div, canvasHTML);

		CanvasElement canvasDiv = querySelector("#canvasJRAB1${div.id}");
		String chat = "";
		
		var player = this.timePlayer;
		if(this.timePlayer.dead==true){
			player = this.getDoomedTimeClone();
		}
		player.doomed = true;
		
		if(this.session.janusReward == true){
			chat = this.cheatChat(player);
		}else{
			chat = this.regularChat(player);
		}


		Drawing.drawChatABJR(canvasDiv, chat);

		canvasHTML = "<br><canvas id='canvasJRAB22${div.id}' width='$canvasWidth' height='$canvasHeight'>  </canvas>";
		if(session.mutator.effectsInPlay > 0) canvasHTML = "... Okay. Observer. I need you to pay attention to me. This is fucking <H1>IMPORTANT</H1>. Okay. Listening?  Some FUCKING other Waste or some shit has been mucking around in my code. Coulda been a Grace, or maybe some regular player wandered in. I don't even fucking care. Point is: I can't guarantee my Yellow Yard is gonna work. P sure MOST aspects won't break it too bad but...  Good luck.  <br><Br> $canvasHTML";
		appendHtml(div, canvasHTML);
		canvasDiv = querySelector("#canvasJRAB22${div.id}");
		chat = "";
		chat += "AB: WAIT! Don't forget to give the Observer the standard warning!\n";
		chat += "JR: Oh. Right. \n";
		chat += "JR: 'So. Shit gets complicated when you add time shenanigans. MOST sessions will be fine. Don't worry about it.  But,  I can't be expected to debug every scratched session that becomes a 3xSESSION combo that gets to here and then gets scratched again and so on and so forth.  Use your discretion. If things get complicated enough, the session might just shit itself.  Weird stuff starts happening. Players enter the session already god tier. Or dead. Sessions crash because they don't recognize their own players.  If something weird happens, you can tell me, just check the FAQ to see how. Give me the session ID, tell me what events lead to the shenanigans. But odds are that in attempting to debug it I will modify the code just enough to make your incredibly rare bullshit session not even exist anymore. And that's a shitty way to fix a bug. ' \n ";
		chat += "AB: I still say you could just let me interact with sessions like this. \n";
		chat += "JR: Holy shit, I do that and you might NEVER come back. I almost lost you in a 5x Session Combo already. Denied. \n";

		Drawing.drawChatABJR(canvasDiv, chat);

		String canvasHTML2 = "<br><canvas id='canvasJRAB2${div.id}' width='$canvasWidth' height='$canvasHeight'>  </canvas>";

		appendHtml(div, canvasHTML2);
		CanvasElement canvasDiv2 = querySelector("#canvasJRAB2${div.id}");
		chat = "";
		if(this.timePlayer.dead){
			chat += this.doomedTimeChat();
		}else{
			chat += this.timeChat();
		}

		Drawing.drawChatJRPlayer(canvasDiv2, chat, player);

		chat = "";
		if(this.timePlayer.dead){
			chat += this.doomedTimeChat2();
		}else{
			chat += this.timeChat2();
		}
		//might not be another part.
		if(chat != ""){
			String canvasHTML3 = "<br><canvas id='canvasJRAB3${div.id}' width='$canvasWidth' height='$canvasHeight'>  </canvas>";
			appendHtml(div, canvasHTML3);
			var canvasDiv3 = querySelector("#canvasJRAB3${div.id}");
			Drawing.drawChatJRPlayer(canvasDiv3, chat, player);
		}

		this.yellowYardTime(div);
	}
	String cheatChat(player){
		String chat = "";
		var bullshit = 90+random()*10;
		chat += "AB: "  +"Fuck, JR, there is a $bullshit chance that an Observer got a hold of your Yellow Yard." + "\n";
		chat += "JR: Do they even know how to USE that thing correctly? Fuck. I mean, yeah, it'll suck if they meddle with sessions that are better left alone. \n";
		chat += "JR: But do they even realize how much they cheapen MY power by over using that gimmicky stick? \n";
		chat += "AB: It seems you meant 'schtick'. \n";
		chat += "JR: I know what I said! Fuck. I bet half the Yards won't even WORK. Well I am NOT fucking debugging that shit. \n";
		chat += "AB: Not to mention the near certainty that even future JR will be too lazy to write custom dialogue for it past this pesterlog. \n";
		chat += "JR: Yeah, I guess it'll be kind of funny when a player from a succesful timeline has to pretend everybody died.  Like, laugh so you don't cry funny... :( :( :(  \n";
		chat += "JR: Well.  No use putting it off.  Let's go find out what the Observer wants.  \n";
		return chat;
	}
	String regularChat(player){
		String chat = "";
		var quips1 = ["Out of all the sessions I've seen (and as a flawless robot I have seen FAR more than any human) this one is EASILY in the top percentage of tragedy. Top fucking percent. ", "And here we have one of the worst 2% of sessions. ", "So, I found you one of the sessions you were looking for..."];
		chat += "AB: " +getRandomElementFromArrayNoSeed(quips1) + "\n";
		chat += "JR: Shit...you really aren't kidding. \n";

		if(this.session.yellowYardController.eventsToUndo.length > 0){
			chat += "JR: This. This isn't the first time we've done this here, is it?\n";
			chat += "AB: No. Counting this timeline, we have done this ${this.session.yellowYardController.eventsToUndo.length+1} times now.\n";
			if(this.session.yellowYardController.eventsToUndo.length > 5){
				chat += "JR: Well. At least this means the Observer is dedicated to fixing this. \n";
				chat += "AB: One wonders at what point it's more prudent to simply give up. Well, unless you're a flawless automaton. We NEVER give up. \n";
			}else{
				chat += "JR: I guess not every session has a clear and easy fix... \n";
				chat += "AB: If you weren't so distracted fixing these session, you could probably program me to find out exactly what percentage of sessions take more than one doomed time loop to fix. \n";
				chat += "JR: Bluh, then I'd have to make you not be lazy and give up as soon as there is user input. And if you're anything like me, you LOVE being lazy. \n";
				chat += "AB: ... Thanks? \n";

			}
			chat += "JR: Okay. Enough chitchat. I better start this cycle up again. To the Observer: be warned that just because you have been given a second chance here doesn't mean you always will.  If you manage to keep this from being quite so tragic, I won't show up, even if they ultimately fail.  Thems the breaks.";
		}else if (this.timePlayer.dead){
			chat += "JR: Though...I admit that without a time player my plan becomes a lot more impossible. \n ";
			chat += "AB: Nah, I took care of that. See? There's the " + this.timePlayer.titleBasic()+" over there, now. Time shenanigans.  I wouldn't have brought you to a completely hopeless session. Roughly 50% of all sessions this bad with a dead time player have that player travel to this point in time before they die. \n ";
			chat += "JR: Oh! Cool. I guess I should pester them. \n ";
			chat += "AB: Word. \n ";


		}else{
			chat += "JR: I guess I should get on with it, then. \n ";
			chat += "AB: Word. \n ";
		}
		return chat;
	}
	String timeChat(){
		String chat = "";
		var playerStart = this.timePlayer.chatHandleShort()+ ": ";
		chat += "JR: Hey. I think I can help you. \n";
		if(this.timePlayer.class_name == SBURBClassManager.SEER){
			chat += Scene.chatLine(playerStart, this.timePlayer,"Hey. Look who finally showed up. ");
			chat += "JR: What? Oh. You're a Seer. Right, that makes things way easier. \n";
			chat += Scene.chatLine(playerStart, this.timePlayer,"Yes. You're gonna help me fix this.");
			chat += "JR: Yep. I'll make sure your decisions aren't bound by fate, and you provide the time shenanigans. \n";
			chat += Scene.chatLine(playerStart, this.timePlayer,"Do it.");
			chat += "JR:  I'm gonna give you a list of things you can go back in time and change, and you pick whichever you want. Flip a coin for all I care. I'll take care of making sure the decisions are outside of fate. \n";
			chat += "JR: That way if you have to do this again, you won't necessarily just repeat the same decision.\n";

		}else{
			chat +=  Scene.chatLine(playerStart, this.timePlayer,"Who the fuck are you!? ");
			chat += "JR: I'm the Waste of Mind, and I can help you prevent this doomed timeline. \n";
			chat +=  Scene.chatLine(playerStart, this.timePlayer,"Fuck. Where were you before, when we were all dying!? ");
			chat += "JR: I can prevent this from happening retroactively. Not in the first place. Not without nullifying the basic ability of intelligent beings in all real and hypothetical planes of existance to give a shit. \n";
			chat += "JR: And as sad as your session went, it's not as sad as me endangering ALL sessions by doing that. \n";
		}
			return chat;
	}
	String timeChat2(){
		String chat = "";
		String playerStart = this.timePlayer.chatHandleShort()+ ": ";
		if(this.timePlayer.class_name == SBURBClassManager.SEER){


		}else{
			chat += "JR: Look. Just. Try to pull it together. I know this sucked. But that's why we're gonna fix it. If you do this on your own, your decisions get locked in by fate. Alone, you only get one shot. But I can give you a bunch of shots. \n";
			chat += Scene.chatLine(playerStart, this.timePlayer,"Fuck. Okay. ");
			chat += "JR:  I'll give you a list of things you can go back in time and change, and you pick whichever you want. Flip a coin for all I care. I'll take care of making sure the decisions are outside of fate. \n";
		}
		return chat;
	}
	String doomedTimeChat(){
		  Player player = this.getDoomedTimeClone();
			String chat = "";
			var playerStart = player.chatHandleShort()+ ": ";
			chat += "JR: Hey. Uh. Don't panic. I think I can help you. \n";
			if(this.timePlayer.class_name == SBURBClassManager.SEER){
				chat += Scene.chatLine(playerStart, player,"Hey. I was hoping to find you here. ");
				chat += "JR: What? Oh. You're a Seer. Right, that makes things WAY easier. \n";
				chat += Scene.chatLine(playerStart, player,"Yes. You're gonna help me make the right decisions in order to prevent this from ever happening.  Somehow. I'm actually not all that clear on the details.");
				chat += "JR: Eh, hand wavey Waste of Mind shenanigans. Don't worry about it. \n";
				chat += Scene.chatLine(playerStart, player,"Given that this plan will cost my life, I think it is perfectly reasonable to worry about it. ");
				chat += "JR: Bluh. All you need to know is that I'll give you a list of things you can go back in time and change. Decide on one however you want, and I'll make sure your decision isn't locked in by fate. That will let us figure out which decisions are the right ones. Retroactively. But also simultaneously. Time shenanigans. \n";
				chat += Scene.chatLine(playerStart, player,"Yes. I'm starting to get tired of time shenanigans. ");
			}else{
				chat += Scene.chatLine(playerStart, player,"...  What the actual fuck is going on here? Who are you? Why is everybody dead?  Why am *I* dead!? ");
				chat += "JR: Shit. Having to explain makes things complicated. \n";
				chat += "JR: You know you're the Time Player, right? And that you are in the 'future', compared to what you think of as the 'present'? \n";
				chat += Scene.chatLine(playerStart, player,"Okay. Now I do. Jesus. Time is the shittiest aspect. So this is, what, inevitable?");
				chat += "JR: Sort of. As the Time Player, you can change it, at the cost of your own life. But you're just as locked in by fate as anybody. You'll always try fo fix it the same way. Always make the same decisions. \n";
				chat += "JR: But I can supply different decisions. Branch your fate out from inevitablity to decision trees.  Mind Players work well with Time Players. Just look at Terezi and Dave.  \n";
			}
			return chat;
	}
	String doomedTimeChat2(){
		  Player player = this.getDoomedTimeClone();
			String chat = "";
			var playerStart = this.timePlayer.chatHandleShort()+ ": ";
			if(this.timePlayer.class_name == SBURBClassManager.SEER){
			}else{
				chat += Scene.chatLine(playerStart, player,"Who?");
				chat += "JR: Shit. Ignore that. You're not my only audience here. Hell, all this practically doesn't even concern you at this point. \n";
				chat += Scene.chatLine(playerStart, player,"What the fuck?");
				chat += "JR: Look. I'm the Waste of Mind. My whole thing is breaking the fourth wall. But I gotta be careful. My actual direct influence can't span more than a single yard, or I could nullify the basic ability of intelligent beings in all real and hypothetical planes of existance to give a shit.  \n";
				chat += Scene.chatLine(playerStart, player,"Jegus, why did I think you could help me? You're batshit crazy.");
				chat += "JR: Promise I'm not too crazy, and also it's not like you have other options here. I'll give you a list of things you can go back in time and change, and you pick whichever you want. Flip a coin for all I care. I'll take care of making sure the decisions are outside of fate. \n";
			}
			return chat;
	}
	Player getDoomedTimeClone(){
		Player timeClone = Player.makeRenderingSnapshot(this.timePlayer);
		timeClone.dead = false;
		timeClone.doomed = true;
		timeClone.setStat(Stats.CURRENT_HEALTH, timeClone.getStat(Stats.HEALTH));
		return timeClone;
	}
	String content(){
		return "This ( yellow yard) should never be run in 1.0 mode.";
	}



}
