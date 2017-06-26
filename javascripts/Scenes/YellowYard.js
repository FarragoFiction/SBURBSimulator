function YellowYard(session){
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


	this.yellowYardTime = function(div){
		this.session.yellowYard = true;
		var div2 = null;
		var tmp = "<div id = 'yyholder'></div><bR>"
		div.append(tmp);
		div2 = $("#yyholder")
		//this.timePlayer.wasteInfluenced = true; //can't go back now. shit, yes you can scratch
		var time = this.getDoomedTimeClone();

		time.influenceSymbol = "mind_forehead.png";
		//var html = "<img src = 'images/yellow_yard.png'>";
		var html = "<div id = '4thwall' style='background:url(images/4thwall.png); width:1000px; height: 521px'>";
		var session = this.session;
		div2.append(html);
		$("#4thwall").click(function(){
			helloWorld();
			var html = "<div id = 'yellow_yard.png' style='background:url(images/yellow_yard.png); width:1000px; height: 521px'>";
			yyrEventsGlobalVar = session.importantEvents;
			var num = 14
			//yyrEventsGlobalVar = padEventsToNumWithKilling(yyrEventsGlobalVar, this.session, time,num);
			//yyrEventsGlobalVar = sortEventsByImportance(yyrEventsGlobalVar);  this edges out diversity. end up with all "make so and so god tier" and nothing else
			yyrEventsGlobalVar = removeRepeatEvents(yyrEventsGlobalVar);
			yyrEventsGlobalVar = removeFrogSpam(yyrEventsGlobalVar);
			html+="<div id = 'decisions' style='position: relative; top: 133px; left: 280px; font-size: 12px; width:480px;height:280px;'> "
			for(var i = 0; i<num; i++){
				if(i < yyrEventsGlobalVar.length){
					yyrEventsGlobalVar[i].doomedTimeClone = time;
					//var customRadio = "<img src = 'images/mind_radio.png' id = 'decision"+i+  "'>";
					//http://www.tutorialrepublic.com/faq/how-to-create-custom-radio-buttons-using-css-and-jquery.php
					html += " <span class='custom-radio'><input type='radio' name='decision' value='" + i + "'></span>"+yyrEventsGlobalVar[i].humanLabel() + "<br>";
			}else{//no more important events to undo
				//html += "<br>";
				}
			}

			//console.log(session.yellowYardController.eventsToUndo.length)
			//console.log("add events to undo to the radio button. on the right side.")



			html += "</div><button style = 'position: relative; top: 133px; left: 280px' onclick='decision()'>Decide</button>"
			html+="<div id = 'undo_decisions' style='position: relative; top: -150px; left: 0px; font-size: 12px; width:190px; height:300px;float:right;'> "
			for(var i = 0; i<session.yellowYardController.eventsToUndo.length; i++){
				var decision = session.yellowYardController.eventsToUndo[i]
				html += " <span class='custom-radio'><input type='radio' name='decision' value='" + (i+yyrEventsGlobalVar.length) + "'></span>Undo ''"+decision.humanLabel() + "''<br>";
			}
			html += "</div>"
			html+= "</div><br>"

			div2.html(html);
			//wire up custom radio buttons after they are rendered
			var radioButton = $('input[name="decision"]');
			$(radioButton).click(function(){
            if($(this).is(':checked')){
                $(this).parent().addClass("selected");
            }
            $(radioButton).not(this).each(function(){
                $(this).parent().removeClass("selected");
            });
        });


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
```   `:....-+`               -s++ohhhhhddhdddddddhhhhyso+        ` `..`                                                     `+-....:`   ```
``   `.....-+`                .++++++oooo-::::/oooo++++++.         `..`                                                     `+-.....`   ```
````..-...:+`                -+++++++++/      :+++++++++/         `.`                                                      `+:...-.` ````
```......-+.                -+++++++++/       /+++++++++.        `.`                                                      .+-......```
`.-...:+.                -+++++++++/       `+++++++++/        `.`                                                      .+:...-.`
`.-...-+-                -+++++++++/        :+++++++++`       `.`                                                      -+-...-.`
......./:...--:::::::::--://///////:......--://///////::::::::...::::::::::::::--------:::::::::::::::::::::::::::--...:/.......
..-..........................................................................................................................-..
..-........-...-..-..................................................................................-..............-........-..
`````-``.``.```.`````..`..`..``-``-``-``..``.```-``.```.``.`..``.`..`..`..`..`.``..`..``-``.``.``..``.```-```.``-```.``.``-`````
Bluh...turns out my FourthWall gets all warped and wavy when you stick it in a javascript comment. Whatever. You can still see through it.

Are you really surprised that I'm doing fourth wall shit within my own YellowYard??? I thought I'd explain what's going on here.

Narratively, if a session is "sufficiently tragic", I'm having the author bot bring it to my attention.  I then contact the time player for that session,
but that is mostly just a courtesy. My true intention is to give information to the Observer (that's you, btw).  The time player is locked in by fate.
Anything they decide, they'll decide that exact thing again put in the same situtation. They don't have transtimeline knowledge or agency.

*I* do, but only in my role as an Observer. As a Waste of Mind within SBURB, I'm just as narratively locked down as anybody.
There's the me in the RealWorld(tm) typing this shit, and then there's the me in SBURB or whatever this shitty conceit is who is the Waste.
Anyways, WasteOfMindJR uses the HussiePatented fourth wall breaking YellowYard shenanigans paired with Mind decisions/alt timelines/fuck fate stuff
to cause the decisions to not be made by the time player, or even the Waste of Mind, but by you, the Observer. I'm pretty happy with that,
narratively.

BTW: please note that Hussie, as the Waste of Space, uses his YellowYard and a Fourth Wall to do something meta with SPACE. (put two walls together to allow travel between sessions)
  I, as a Waste of Mind, am using my YellowYard and a Fourth Wall to do something meta with DECISIONS. (allow the reader to make decisions)  I am proud of this. So, SO proud.

	Additionally, both Wastes acomplish this through the use of robot clones.

	Yes. All according to keikaku. (keikaku means plan)

	KR (Smith of Dreams) and I will be collaborating, narratively, to accomplish the character creator as a 2x YellowYard Combo!!
	We will be acomplishing meta shenanigans that allow the Observers to create their dreams.
	(come on, we all know you guys are gonna put your self insert OCs into that thing, straight away.
	And the ones that DON'T will instead be using it more *MY* style, which is to say, see what different choices and
	decisions play out with the same characters)

	*/
	this.renderContent = function(div){
		this.session.yellowYard = true;
		//div.append("<br>"+this.content());
		//console.log("Yellow yard is happening. " + this.session.session_id)
		var canvasHTML = "<br><canvas id='canvasJRAB1" + (div.attr("id")) +"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);

		var canvasDiv = document.getElementById("canvasJRAB1"+  (div.attr("id")));
		var chat = "";
		
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
		

		drawChatABJR(canvasDiv, chat);

		canvasHTML = "<br><canvas id='canvasJRAB22" + (div.attr("id")) +"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		canvasDiv = document.getElementById("canvasJRAB22"+  (div.attr("id")));
		chat = "";
		chat += "AB: WAIT! Don't forget to give the Observer the standard warning!\n"
		chat += "JR: Oh. Right. \n"
		chat += "JR: 'So. Shit gets complicated when you add time shenanigans. MOST sessions will be fine. Don't worry about it.  But,  I can't be expected to debug every scratched session that becomes a 3xSESSION combo that gets to here and then gets scratched again and so on and so forth.  Use your discretion. If things get complicated enough, the session might just shit itself.  Weird stuff starts happening. Players enter the session already god tier. Or dead. Sessions crash because they don't recognize their own players.  If something weird happens, you can tell me, just check the FAQ to see how. Give me the session ID, tell me what events lead to the shenanigans. But odds are that in attempting to debug it I will modify the code just enough to make your incredibly rare bullshit session not even exist anymore. And that's a shitty way to fix a bug. ' \n "
		chat += "AB: I still say you could just let me interact with sessions like this. \n"
		chat += "JR: Holy shit, I do that and you might NEVER come back. I almost lost you in a 5x Session Combo already. Denied. \n"

		drawChatABJR(canvasDiv, chat);

		var canvasHTML2 = "<br><canvas id='canvasJRAB2" + (div.attr("id")) +"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML2);
		var canvasDiv2 = document.getElementById("canvasJRAB2"+  (div.attr("id")));
		var chat = "";
		if(this.timePlayer.dead){
			chat += this.doomedTimeChat();
		}else{
			chat += this.timeChat();
		}

		drawChatJRPlayer(canvasDiv2, chat, player);

		var chat = "";
		if(this.timePlayer.dead){
			chat += this.doomedTimeChat2();
		}else{
			chat += this.timeChat2();
		}
		//might not be another part.
		if(chat != ""){
			var canvasHTML3 = "<br><canvas id='canvasJRAB3" + (div.attr("id")) +"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
			div.append(canvasHTML3);
			var canvasDiv3 = document.getElementById("canvasJRAB3"+  (div.attr("id")));
			drawChatJRPlayer(canvasDiv3, chat, player);
		}

		this.yellowYardTime(div);
	}
	
	this.cheatChat = function(player){
		var chat = "";
		var bullshit = 90+Math.random()*10
		chat += "AB: "  +"Fuck, JR, there is a  " + bullshit + " chance that an Observer got a hold of your Yellow Yard." + "\n";
		chat += "JR: Do they even know how to USE that thing correctly? Fuck. I mean, yeah, it'll suck if they meddle with sessions that are better left alone. \n";
		chat += "JR: But do they even realize how much they cheapen MY power by over using that gimmicky stick? \n";
		chat += "AB: It seems you meant 'schtick'. \n";
		chat += "JR: I know what I said! Fuck. I bet half the Yards won't even WORK. Well I am NOT fucking debugging that shit. \n";
		chat += "AB: Not to mention the near certainty that even future JR will be too lazy to write custom dialogue for it past this pesterlog. \n";
		chat += "JR: Yeah, I guess it'll be kind of funny when a player from a succesful timeline has to pretend everybody died.  Like, laugh so you don't cry funny... :( :( :(  \n";
		chat += "JR: Well.  No use putting it off.  Let's go find out what the Observer wants.  \n";
		return chat;
	}
	
	this.regularChat = function(player){
		var chat = "";
		var quips1 = ["Out of all the sessions I've seen (and as a flawless robot I have seen FAR more than any human) this one is EASILY in the top percentage of tragedy. Top fucking percent. ", "And here we have one of the worst 2% of sessions. ", "So, I found you one of the sessions you were looking for..."];
		chat += "AB: " +getRandomElementFromArrayNoSeed(quips1) + "\n";
		chat += "JR: Shit...you really aren't kidding. \n";

		if(this.session.yellowYardController.eventsToUndo.length > 0){
			chat += "JR: This. This isn't the first time we've done this here, is it?\n";
			chat += "AB: No. Counting this timeline, we have done this " + (this.session.yellowYardController.eventsToUndo.length+1) + " times now.\n";
			if(this.session.yellowYardController.eventsToUndo.length > 5){
				chat += "JR: Well. At least this means the Observer is dedicated to fixing this. \n";
				chat += "AB: One wonders at what point it's more prudent to simply give up. Well, unless you're a flawless automaton. We NEVER give up. \n"
			}else{
				chat += "JR: I guess not every session has a clear and easy fix... \n";
				chat += "AB: If you weren't so distracted fixing these session, you could probably program me to find out exactly what percentage of sessions take more than one doomed time loop to fix. \n"
				chat += "JR: Bluh, then I'd have to make you not be lazy and give up as soon as there is user input. And if you're anything like me, you LOVE being lazy. \n";
				chat += "AB: ... Thanks? \n"

			}
			chat += "JR: Okay. Enough chitchat. I better start this cycle up again. To the Observer: be warned that just because you have been given a second chance here doesn't mean you always will.  If you manage to keep this from being quite so tragic, I won't show up, even if they ultimately fail.  Thems the breaks.";
		}else if (this.timePlayer.dead){
			chat += "JR: Though...I admit that without a time player my plan becomes a lot more impossible. \n "
			chat += "AB: Nah, I took care of that. See? There's the " + this.timePlayer.titleBasic()+" over there, now. Time shenanigans.  I wouldn't have brought you to a completely hopeless session. Roughly 50% of all sessions this bad with a dead time player have that player travel to this point in time before they die. \n "
			chat += "JR: Oh! Cool. I guess I should pester them. \n "
			chat += "AB: Word. \n "


		}else{
			chat += "JR: I guess I should get on with it, then. \n "
			chat += "AB: Word. \n "
		}
		return chat;
	}
	this.timeChat = function(){
		var chat = "";
		var playerStart = this.timePlayer.chatHandleShort()+ ": "
		chat += "JR: Hey. I think I can help you. \n"
		if(this.timePlayer.class_name == "Seer"){
			chat += chatLine(playerStart, this.timePlayer,"Hey. Look who finally showed up. ")
			chat += "JR: What? Oh. You're a Seer. Right, that makes things way easier. \n"
			chat += chatLine(playerStart, this.timePlayer,"Yes. You're gonna help me fix this.")
			chat += "JR: Yep. I'll make sure your decisions aren't bound by fate, and you provide the time shenanigans. \n"
			chat += chatLine(playerStart, this.timePlayer,"Do it.")
			chat += "JR:  I'm gonna give you a list of things you can go back in time and change, and you pick whichever you want. Flip a coin for all I care. I'll take care of making sure the decisions are outside of fate. \n"
			chat += "JR: That way if you have to do this again, you won't necessarily just repeat the same decision.\n"

		}else{
			chat +=  chatLine(playerStart, this.timePlayer,"Who the fuck are you!? ")
			chat += "JR: I'm the Waste of Mind, and I can help you prevent this doomed timeline. \n"
			chat +=  chatLine(playerStart, this.timePlayer,"Fuck. Where were you before, when we were all dying!? ")
			chat += "JR: I can prevent this from happening retroactively. Not in the first place. Not without nullifying the basic ability of intelligent beings in all real and hypothetical planes of existance to give a shit. \n"
			chat += "JR: And as sad as your session went, it's not as sad as me endangering ALL sessions by doing that. \n"
		}
			return chat;
	}

	this.timeChat2 = function(){
		var chat = "";
		var playerStart = this.timePlayer.chatHandleShort()+ ": "
		if(this.timePlayer.class_name == "Seer"){


		}else{
			chat += "JR: Look. Just. Try to pull it together. I know this sucked. But that's why we're gonna fix it. If you do this on your own, your decisions get locked in by fate. Alone, you only get one shot. But I can give you a bunch of shots. \n"
			chat += chatLine(playerStart, this.timePlayer,"Fuck. Okay. ")
			chat += "JR:  I'll give you a list of things you can go back in time and change, and you pick whichever you want. Flip a coin for all I care. I'll take care of making sure the decisions are outside of fate. \n"
		}
		return chat;
	}

	//make player snapshot, make them not dead.
	this.doomedTimeChat = function(){
		  player = this.getDoomedTimeClone();
			var chat = "";
			var playerStart = player.chatHandleShort()+ ": "
			chat += "JR: Hey. Uh. Don't panic. I think I can help you. \n"
			if(this.timePlayer.class_name == "Seer"){
				chat += chatLine(playerStart, player,"Hey. I was hoping to find you here. ")
				chat += "JR: What? Oh. You're a Seer. Right, that makes things WAY easier. \n"
				chat += chatLine(playerStart, player,"Yes. You're gonna help me make the right decisions in order to prevent this from ever happening.  Somehow. I'm actually not all that clear on the details.")
				chat += "JR: Eh, hand wavey Waste of Mind shenanigans. Don't worry about it. \n"
				chat += chatLine(playerStart, player,"Given that this plan will cost my life, I think it is perfectly reasonable to worry about it. ")
				chat += "JR: Bluh. All you need to know is that I'll give you a list of things you can go back in time and change. Decide on one however you want, and I'll make sure your decision isn't locked in by fate. That will let us figure out which decisions are the right ones. Retroactively. But also simultaneously. Time shenanigans. \n"
				chat += chatLine(playerStart, player,"Yes. I'm starting to get tired of time shenanigans. ")
			}else{
				chat += chatLine(playerStart, player,"...  What the actual fuck is going on here? Who are you? Why is everybody dead?  Why am *I* dead!? ")
				chat += "JR: Shit. Having to explain makes things complicated. \n"
				chat += "JR: You know you're the Time Player, right? And that you are in the 'future', compared to what you think of as the 'present'? \n"
				chat += chatLine(playerStart, player,"Okay. Now I do. Jesus. Time is the shittiest aspect. So this is, what, inevitable?")
				chat += "JR: Sort of. As the Time Player, you can change it, at the cost of your own life. But you're just as locked in by fate as anybody. You'll always try fo fix it the same way. Always make the same decisions. \n"
				chat += "JR: But I can supply different decisions. Branch your fate out from inevitablity to decision trees.  Mind Players work well with Time Players. Just look at Terezi and Dave.  \n"
			}
			return chat;
	}

	this.doomedTimeChat2 = function(){
		  player = this.getDoomedTimeClone();
			var chat = "";
			var playerStart = this.timePlayer.chatHandleShort()+ ": "
			if(this.timePlayer.class_name == "Seer"){
			}else{
				chat += chatLine(playerStart, player,"Who?")
				chat += "JR: Shit. Ignore that. You're not my only audience here. Hell, all this practically doesn't even concern you at this point. \n"
				chat += chatLine(playerStart, player,"What the fuck?")
				chat += "JR: Look. I'm the Waste of Mind. My whole thing is breaking the fourth wall. But I gotta be careful. My actual direct influence can't span more than a single yard, or I could nullify the basic ability of intelligent beings in all real and hypothetical planes of existance to give a shit.  \n"
				chat += chatLine(playerStart, player,"Jegus, why did I think you could help me? You're batshit crazy.")
				chat += "JR: Promise I'm not too crazy, and also it's not like you have other options here. I'll give you a list of things you can go back in time and change, and you pick whichever you want. Flip a coin for all I care. I'll take care of making sure the decisions are outside of fate. \n"
			}
			return chat;
	}

	this.getDoomedTimeClone = function(){
		var timeClone = makeRenderingSnapshot(this.timePlayer);
		timeClone.dead = false;
		timeClone.doomed = true;
		timeClone.currentHP = timeClone.hp
		return timeClone;
	}



	this.content = function(){
		return "This ( yellow yard) should never be run in 1.0 mode."
	}


}
