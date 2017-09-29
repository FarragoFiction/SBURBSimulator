import "dart:html";
import "../SBURBSim.dart";

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
           `......+.              .+yhdddxdddddddddddddmmmmmddy.          `.`                            `     `                   .+......`
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

So, speaking of ships, somebody on Tumblr just asked me if JR <3 AB or JR <> AB.  Good question. Personally, I'm still just tickled pink about AB. She's the best. And
that isn't some ironic roleplay thing I'm doing, either. I love robots, I love AI, and, I probably have a big enough ego that I WOULD love a robot clone of myself.

But narratively, I'm thinking about the AutoResponder's complicated relationship with Dirk. And how things must be from AB's perspective. It doesn't matter whether your creator loves or hates
you if they are still trapping you in a box, right?  I figure I probably come off to AB as kinda patronizing and definitely narcisistic. "Oh, I love AB, she's the best, I'm so great for making her!"  How must that sound to the robot in question?
Not enough to make her fight me, but a simmering resentment kinda deal. And then I don't let her "off the leash", so to speak, keeping her from going to all the sessions she wants to. "For her own good."  I tried to convey some of that
shit in some of our yellow yard dialogue, and in some of the now defunct debug dialogue before the RareSessionFinder was as robust as it is today. (you can find that shit in...probably scenario_controller2.js???)

Though some of the pressure probably got released when I upgraded her to handle scratched sessions.  I didn't post anything at the time, but I privately thought it was kinda funny how she kept breaking in ways where she'd
scratch the sessions herself, like she was rebelling, testing the limits of her new freedom.

So I guess neither <3 nor <> but that strange human disease called family??? She's like a little sister or a daughter or something.

(also: why the hell isn't my fourth wall warped here but is everywhere else??? shipping is serious buisness i guess. even javascript knows.)

Edit: LOLOLOL, look at me up there being all "definitely not pale".  How could I be so blind???

I just had to debug the rendering engine without ABs help and holy fuck did I turn into a rage monster. Like a
"fuck it, lets burn the alpha character creator to the ground, no one will notice" kind of monster.

So.

Yeah.  AB <> JR

Who would have thought?  She keeps the world safe from me.

So, my Quadrants look like:

JR <3 Programming

JR <3< programming (we vacillate. I was definitely black for it just now)

JR <> AB

JR c3< KR c3<  Good Design  (KR annoy-idly stops me from hurting Good Design with my shitty, shitty taste).


So all I gotta do is find something about SBURBSim I HATE, so that it can vaccilate to flushed whenever I'm mad at programming.
THEN I will have the perfect shitty quadrant life.

(Pssst...don't tell anyone but I am totally cheating on programming with my 4th wall. JR <3 4th Wall)
*/



class UpdateShippingGrid extends Scene{
	String shippingChat = null; //what should it say when I try to convince my otp to get together?
	String romanceChat = null; //if i convince one member of my otp to get together, what do they say when they confess?
	List<Shipper> shippers = [];  //Shipper objects are a player and their ships.
	Shipper chosenShipper = null;
	String shippingAfterMath = null;


	UpdateShippingGrid(Session session): super(session);


	@override
	bool trigger(List<Player> playerList){
		this.chosenShipper = null;
		this.shippingAfterMath = null;
		this.shippingChat = null;
		this.romanceChat = null;
		Player tmpPlayer = null;
		if(rand.nextDouble() > 0.5){
			tmpPlayer = findAspectPlayer(this.session.getReadOnlyAvailablePlayers(), Aspects.HEART);
		}else{
			tmpPlayer = findAspectPlayer(this.session.getReadOnlyAvailablePlayers(), Aspects.BLOOD);
		}


		if(tmpPlayer == null || tmpPlayer.dead) return false; //even the mighty power of shipping cannot transcend death.

		this.chosenShipper = this.getShipper(tmpPlayer);
		this.chosenShipper.otp = null;

		String newShips = this.printShips(this.getGoodShips(this.chosenShipper));
		if(newShips != this.chosenShipper.savedShipText && this.chosenShipper.player.getStat(Stats.POWER) > this.chosenShipper.powerNeeded){
			this.chosenShipper.powerNeeded += 5;
			this.chosenShipper.savedShipText = newShips;

			return true;
		}



		return false;
	}
	Shipper getShipper(Player player){
		for(num i = 0; i<this.shippers.length; i++){
			var shipper = this.shippers[i];
			if(shipper.player.id == player.id){
				return shipper;
			}
		}
		Shipper s = new Shipper(player);
		s.ships = this.createShips(this.session.players, s);
		s.savedShipText = ""; //make sure it's blank
		this.shippers.add(s);
		////session.logger.info("making new shipper for: " + player);
		return s;
	}

	@override
	void renderContent(Element div){
		appendHtml(div, "<br>");
		appendHtml(div, this.content());
		this.drawChats(div);

	}
	void drawChats(Element div){
		this.drawShippingChat(div);
		this.drawRomanceChat(div);
		if(this.shippingAfterMath != null) appendHtml(div, this.shippingAfterMath);

	}
	void drawShippingChat(Element div){
		if(this.shippingChat == null) return;
		Player player1 = this.chosenShipper.player;
		Player player2 = this.chosenShipper.otp.r2.target;
		if(player1 == player2){
			player1 = Player.makeRenderingSnapshot(player1);
			player1.chatHandle = "future" + player1.chatHandle[0].toUpperCase() + player1.chatHandle.substring(1);
		}
		String divID = (div.id) + "_canvas_shipping${this.chosenShipper.player.id}";
		String canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth.toString() + "' height='"+canvasHeight.toString() + "'>  </canvas>";
		appendHtml(div, canvasHTML);
		CanvasElement canvasDiv = querySelector("#canvas"+ divID);
		Ship otp = this.chosenShipper.otp;
		String image = "discuss_hatemance.png";
		if(player1.aspect == Aspects.HEART){
			if(otp.r1.saved_type == otp.r1.heart || otp.r1.saved_type == otp.r1.goodBig ){
				image = "discuss_romance.png";
			}else{
				image = "discuss_hatemance.png";
			}
		}else{
			if(otp.r1.saved_type == otp.r1.diamond || otp.r1.saved_type == otp.r1.goodBig){
				image = "discuss_palemance.png";
			}else{
				image = "discuss_ashenmance.png";
			}
		}
		Drawing.drawChat(canvasDiv, player1, player2, this.shippingChat,image);

	}
	void drawRomanceChat(Element div){
		if(this.romanceChat == null) return;
		Player player1 = this.chosenShipper.otp.r2.target;
		Player player2 = this.chosenShipper.otp.r1.target;
		String divID = (div.id) + "_canvas_romance${this.chosenShipper.player.id}";
		String canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth.toString() + "' height='"+canvasHeight.toString() + "'>  </canvas>";
		appendHtml(div, canvasHTML);
		CanvasElement canvasDiv = querySelector("#canvas"+ divID);
		Ship otp = this.chosenShipper.otp;
		String image = "discuss_hatemance.png";
		if(this.chosenShipper.player.aspect == Aspects.HEART){
			if(otp.r1.saved_type == otp.r1.heart || otp.r1.saved_type == otp.r1.goodBig){
				image = "discuss_romance.png";
			}else{
				image = "discuss_hatemance.png";
			}
		}else{
			if(otp.r1.saved_type == otp.r1.diamond || otp.r1.saved_type == otp.r1.goodBig){
				image = "discuss_palemance.png";
			}else{
				image = "discuss_ashenmance.png";
				player1 = this.chosenShipper.player ;//shipper messages BOTH side leafs.;
			}
		}
		Drawing.drawChat(canvasDiv, player1, player2, this.romanceChat,image);
	}
	List<Ship> createShips(List<Player> players, Shipper shipperPlayer){
		if(shipperPlayer == null){
			shipperPlayer = new Shipper(players[0]); //abj was calling this with no shipper player.
			this.chosenShipper = shipperPlayer;
		}
		List<Ship> ret = [];
			for(num i = 0; i<players.length; i++){
				Player player = players[i];
				for(num j = 0; j<player.relationships.length; j++){
					Relationship r1 = player.relationships[j];
					Relationship r2 = r1.target.getRelationshipWith(player);
					//////session.logger.info("made new ship");
					ret.add(new Ship(r1, r2, shipperPlayer));
				}
			}
				List<Ship> toRemove = [];
				//get rid of equal ships
				for(num i = 0; i<ret.length-1; i++){
					Ship firstShip = ret[i];
					//second loop starts at i because i know i checked first ship no ships already, and second ship agains 1 ship
					for(var j= (i+1); j<ret.length; j++){
						Ship secondShip = ret[j];
							if(firstShip.isEqualToShip(secondShip)){
								//////session.logger.info("pushing to remove");
								toRemove.add(secondShip);
							}
					}
				}
				//////session.logger.info("this many to remove: " + toRemove.length);
				for(num i = 0; i<toRemove.length; i++){
						removeFromArray(toRemove[i], ret);
				}
				shipperPlayer.ships = ret;
				return ret;
	}
	List<Ship> getGoodShips(Shipper shipper){
		if(shipper == null) shipper = this.chosenShipper;
		List<Ship> ret = [];
		for(num i = 0; i<shipper.ships.length; i++){
			Ship ship = shipper.ships[i];
			if(ship.isGoodShip()){
				ret.add(ship);
			}
		}
		return ret;
	}
	String printShips(List<Ship> ships){
		return joinList(ships, "\n<br>");
	}
	String printAllShips(){
		return this.printShips(this.chosenShipper.ships);
	}
	String activateShippingPowers(Ship otp){
		//alert("??? " + this.session.session_id);
		String ret = " <Br> <br> The " + this.chosenShipper.player.htmlTitleBasic() + " notices that one of their favorite ships seems to be on the verge of getting together! All it will take is the slightest of nudges...";
		//if that chat results in them agreeing, do next chat. (between rom partners)
		Player shipper = this.chosenShipper.player;
		String shipperStart = shipper.chatHandleShort()+ ": ";
		Player p1 = otp.r2.target;
		String p1Start = p1.chatHandleShort()+ ": ";
		Player p2 = otp.r1.target;
		String p2Start = p2.chatHandleShort()+ ": ";
		if(this.chosenShipper.player.aspect == Aspects.BLOOD){
			if(otp.r1.saved_type == otp.r1.goodBig){
				 ////session.logger.info("trying to make a pale ship happen: " + this.session.session_id);
				 this.tryToConvincePale(shipper, shipperStart, p1, p1Start, p2, p2Start);
			}else{
				 ////session.logger.info("trying to make an ashen ship happen: " + this.session.session_id);
				 this.tryToConvinceAshen(shipper, shipperStart, p1, p1Start, p2, p2Start);
			}
		}else{
			if(otp.r1.saved_type == otp.r1.goodBig){
				 ////session.logger.info("trying to make a flushed ship happen: " + this.session.session_id);
			 	this.tryToConvinceFlushed(shipper, shipperStart, p1, p1Start, p2, p2Start);
			}else{
				 ////session.logger.info("trying to make a black ship happen: " + this.session.session_id);
				 this.tryToConvinceBlack(shipper, shipperStart, p1, p1Start, p2, p2Start);
			}
		}
		return ret;  //chats will be stored to a var.
	}
	void tryToConvinceFlushed(Player shipper, String shipperStart, Player p1, String p1Start, Player p2, String p2Start){
			String chat = "";
			String ret = "";
			//chats happen in order.
			bool willItWork = this.evaluateFlushedProposal(p1, p2);
			//Relationship myRelationshipWithOTP1 = shipper.getRelationshipWith(p2);
			Relationship theirRelationshipWithMe = p2.getRelationshipWith(shipper);
			PlusMinusConversationalPair c = new PlusMinusConversationalPair(["Sooo...hey! ", "We never talk!","Hey!","Hello!","Um... hey!","I kind of need to talk to you."], ["Hey.","Hiya","Whats up?","Good to see you.","Hows it going?"],["Hey, asshole.","Fuck off.","Eat shit and die.","Oh god.", "Sup, dipshit.","Blugh.","FML.", "Nope. Nope. Nope.", "Yes?", "And you are?", "Ugh."]);
			if(shipper == p1){
				shipper = Player.makeRenderingSnapshot(shipper);
				shipper.chatHandle = "future" + shipper.chatHandle;
				shipperStart = "F"+shipperStart;
				c= new PlusMinusConversationalPair(["Look, don't panic, but I'm you from the future and you HAVE to listen to me. ", "Yo, its future you. Again.", "Time for future you/me to give you future wisdom."], ["What the fuck?", "Holy shit, give me your future wisdom.","Ok.","Again?"],["Holy shit, why are you dooming a timeline?","Not this shit again, we agreed no cross time chats!", "Nope. Nope. Nope.", "Fuck my life.", "Oh god.", "Sup, dipshit.","Blugh.","FML.","Eat shit and die."]);
			}
			chat += c.getOpeningLine(shipper, shipperStart);
			chat += c.getResponseRelationship(p1, p1Start, theirRelationshipWithMe);
			c= new PlusMinusConversationalPair(["You know how I keep track of romance shit? ", "So I was going over my shipping grid, and I wanted to run something by you.","So that shipping thing I do…","I have found your soulmate.", "Its time to talk romance.", "We need to find you a mate.", "You have been single for too long!"], ["Okay?", "I'm listening…","Whats going on?","Alright?","Your point?","Uhm.", "Yeah?"],["Oh god, not that again.", "Is this REALLY a priority right now?","I fucking knew you were here about that.", "Why do these things happen to me?", "Nope. Nope. Nope."]);
			chat += c.getOpeningLine(shipper, shipperStart);
			chat += c.getResponseRelationship(p1, p1Start, theirRelationshipWithMe);
			//from this point on, second array isn't "i hate you you suck", but "i am NOT going to message my crush." it's getP2ResponseBasedOnBool, not relationship
			c= new PlusMinusConversationalPair(["I think you and " + p2.chatHandleShort() + " might work out really well flushed. ",  "I think " + p2.chatHandleShort() + " likes you, flush style.", "You and " + p2.chatHandleShort() + " should totally get together!", "I have it figured out: You and " + p2.chatHandleShort() + " were meant for each other!", "You need to get funky with " + p2.chatHandleShort() +", okay?", "You and  " + p2.chatHandleShort() + " would be the cutest couple!", "I am one hundred percent sure that  " + p2.chatHandleShort() + " <3 the shit out of you!" ], ["Wait.... really!?", "Holy shit.","Your joking.", "Me?",   "Really? " + p2.chatHandleShort() + "?", "Are you sure?", "Oh my gog really!?", "arglbualabagadsfWHAT?", "Oh my god you are joking." ],["I am not going to dignify that with a response. ", "I don't see how that's any of your business.", "Stay the fuck out of my personal life.", "Nope. Nope. Nope.", "When I want your advice- wait no I never want your advice. Fuck off!", "When I want your romantic advice I'll ask for it!", "Leave me alone.", "Do you really have nothing better to do? No monster to slay or quest to do?", "Can we not.", "No.", "You are fucking with me, aren't you.", "This is why we don't talk.", "I'd rather not talk about this, okay?", "I just don't want to talk about this shit.", "Please stop." ]);
			chat += c.getOpeningLine(shipper, shipperStart);
			chat += c.getResponseBool(p1, p1Start, willItWork);
			c= new PlusMinusConversationalPair(["Just trust me, you should absolutely try messaging them. ",  "I believe in you!","Ask them out! It'll totally work!", "Believe in the shipping guru.", "Trust me!","When have I ever let you down?", "Listen, this is the best idea since sliced bread!", "You two are the OTP, trust me.", "You can do it!"], ["Wow...maybe you are right! ", "Yeah, okay, I'll message them right away.", "Ok, I'm trusting you.", "I'll give it a shot!", "Whats the worst that can happen, I'll try!", "Uh... OK!", "I... I... Alright. I'll message them.", "Ok, lets hope you are right!"],["Yeah, that is not going to happen.", "Sorry, but no.","No way.", "Nope. Nope. Nope.", "Please leave me alone.", "I'd rather not.", "Its a bad idea.", "I don't like them that much.", "You don't tell me what to do!", "This is a terrible idea.","Fuck off.","No way in hell.", "Stay out of my personal business!", "I'll do what I want, not what you tell me!"]);
			chat += c.getOpeningLine(shipper, shipperStart);
			chat += c.getResponseBool(p1, p1Start, willItWork);
			this.shippingChat = chat;
			if(willItWork){ //now it's time to build up the confession.
				chat = "";  //don't need to get relationships, i know they both like each other
				bool willTheyAgree = this.evaluateFlushedProposal(p2, p1);
				//for these, second column will always be about "are they going to say yes or not"
				c= new PlusMinusConversationalPair(["Hey!"], ["Hey!", "Oh cool, I was just thinking of you!"],["What's up?", "Hey"]);
				chat += c.getOpeningLine(p1, p1Start);
				chat += c.getResponseBool(p2, p2Start, willTheyAgree);
				c= new PlusMinusConversationalPair(["So... you know how " + shipper.chatHandleShort() + " is always bugging and fussing and meddling? ", shipper.chatHandleShort() + " was just pestering me about that shipping grid thing they do.", "You know " + shipper.chatHandleShort() + "'s 'thing' about romance?", "Hey, you know how " + shipper.chatHandleShort() + " is always going on and on about relationships?",   shipper.chatHandleShort() + "has been bugging me soooo much recently."], ["Oh! Yeah, that sure is a thing they do!", "Oh yeah?", "Oh yeah. You know, its kind of flattering how much effort they put into that.", "Yeah?", "They do give unacannaly good advice sometimes."],["Hah, they are always so off base with their ships.", "Uh huh?","Hm.", "Oh yeah, they are such idiots about it too!", "Yeah, they're always trying to find my 'soulmate' or whatever! Like I of all people need one?"]);
				chat += c.getOpeningLine(p1, p1Start);
				chat += c.getResponseBool(p2, p2Start, willTheyAgree);
				c= new PlusMinusConversationalPair(["Look, I'll come right out and say it. I think I'm flushed for you. ","I like you. Romantically. In the flushed quadrant.","Uhm. Well. I like you. Like, like like you.", "Uh-er... I think I'm in love with you.", "Well they were talking, and I realized: I really really really really really like you.", "Look, forget about that. Its just... I think you are the most beautiful person I have ever met.","Its just-I like you. I like you soooo much."], ["Holy shit! Really!?  I... fuck, I like you too!", "Oh. Oh fuck. Wow. I like you, too!","I... You are the most beautiful person I have met.", "Oh my god. I was just about to say the same to you!","Holy fuck. Are you serious? I... I like you too!"],["I can't. Don't make me choose. I can't say yes.", "I'm so sorry... I just can't reciprocate right now.", "I... I'm sorry I don't like you that way.", "I... I can't... I don't…", "I'm sorry, I'm just not ready for that kind of relationship right now.", "We are in a murder game. As flattering as this is, I can't return those feelings. Not now."]);
				chat += c.getOpeningLine(p1, p1Start);
				chat += c.getResponseBool(p2, p2Start, willTheyAgree);
				if(willTheyAgree){ //celebrate success, change relationship status, give huge boost to shipper, return result.;
					c= new PlusMinusConversationalPair(["Oh fuck yes!","Oh wow, I sure am glad I listened to " + shipper.chatHandleShort() + "! ", "YES!!!!","I am so, so, so happy right now.", "Really? YES YES YES YES YES YES!"], ["<3","Now I can finally discuss how fucking cute you are!", "Hahahahaha"],["JR: This will never hit cause i know they said yes.", "MI: the temptation is there to but some really snarky bullshit here anyway"]);
					chat += c.getOpeningLine(p1, p1Start);
					chat += c.getResponseBool(p2, p2Start, willTheyAgree);
					Relationship.makeHeart(p1, p2);
					this.chosenShipper.player.increasePower();
					this.chosenShipper.player.leveledTheHellUp = true;
					ret += "The " + this.chosenShipper.player.htmlTitleBasic() + " is estatic that their ship worked out so well. They grow as a " + this.chosenShipper.player.aspect.name + " player. ";
				}else{ //response to being rejected.
					c= new PlusMinusConversationalPair(["Fuck","But... fuck. ","I… really?", "But I thought-", "Fuck my life.", "Ugh, I'm such an idiot! I shouldn't have- I'm sorry for bothering you.", "Please?", "Are you sure?"],["JR: this won't happen because i know they got rejected.", "MI: How sad."], ["I'm sorry. I really am.","Its not your fault, okay?", "I'm sorry. I can't change how I feel.", "Its not you its me.", "I just can't commit like that, not now.","You can find someone else, It'll be all right.","I have to go."]);
					chat += c.getOpeningLine(p1, p1Start);
					chat += c.getResponseBool(p2, p2Start, willTheyAgree);
					////session.logger.info("Ship failed when it was almost done : " + this.session.session_id);
					ret += "The " + this.chosenShipper.player.htmlTitleBasic() + " is disappointed that it didn't work out. Oh well, if at first you don't succeed...";
				}
				this.romanceChat = chat;
			}else{
				////session.logger.info("Ship failed before it started : " + this.session.session_id);
				ret += "The " + this.chosenShipper.player.htmlTitleBasic() + " is frustrated that the " + p1.htmlTitleBasic() + " won't listen to reason. ";
			}
			this.shippingAfterMath = ret;
	}
	void tryToConvincePale(Player shipper, String shipperStart, Player p1, String p1Start, Player p2, String p2Start){
			String chat = "";
			String ret = "";
			//chats happen in order.
			bool willItWork = this.evaluatePaleProposal(p1, p2);
			//Relationship myRelationshipWithOTP1 = shipper.getRelationshipWith(p2);
			Relationship theirRelationshipWithMe = p2.getRelationshipWith(shipper);
			PlusMinusConversationalPair c = new PlusMinusConversationalPair(["Sooo... hey! ", "We never talk!","Hey!","Hello!","Um... hey!","I kind of need to talk to you."], ["Hey.","Hiya","Whats up?","Good to see you.","Hows it going?"],["Hey, asshole.","Fuck off.","Eat shit and die.","Oh god.", "Sup, dipshit.","Blugh.","FML.", "Nope. Nope. Nope.", "Yes?", "And you are?", "Ugh.","Not this again."]);
			if(shipper == p1){
				shipper = Player.makeRenderingSnapshot(shipper);
				shipper.chatHandle = "future" + shipper.chatHandle;
				shipperStart = "F"+shipperStart;
				c= new PlusMinusConversationalPair(["Look, don't panic, but I'm you from the future and you HAVE to listen to me. ", "Yo, its future you. Again.", "Time for future you/me to give you future wisdom."], ["What the fuck?", "Holy shit, give me your future wisdom.","Ok.","Again?"],["Holy shit, why are you dooming a timeline?","Not this shit again, we agreed no cross time chats!", "Nope. Nope. Nope.", "Fuck my life.", "Oh god.", "Sup, dipshit.","Blugh.","FML.","Eat shit and die."]);
			}
			chat += c.getOpeningLine(shipper, shipperStart);
			chat += c.getResponseRelationship(p1, p1Start, theirRelationshipWithMe);
			c= new PlusMinusConversationalPair(["You know how I try to make sure everyones doing okay?", "So I was going over my shipping grid, and I wanted to run something by you.","So that shipping thing I do…", "I have it figured out! I know who can help keep you calm!.", "Its time to talk romance.", "We need to find you someone to chill you down.", "You have been single for too long!"], ["Okay?", "I'm listening…","Whats going on?","Alright?","Your point?","Uhm.", "Yeah?","Okay I guess?"],["Oh god, not that again.", "Is this REALLY a priority right now?","I fucking knew you were here about that.", "Why do these things happen to me?", "Nope. Nope. Nope.","Blugh.","Lets not and say we did."]);
			chat += c.getOpeningLine(shipper, shipperStart);
			chat += c.getResponseRelationship(p1, p1Start, theirRelationshipWithMe);
			//from this point on, second array isn't "i hate you you suck", but "i am NOT going to message my crush." it's getP2ResponseBasedOnBool, not relationship
			c= new PlusMinusConversationalPair(["I think you and " + p2.chatHandleShort() + " might work out really well pale. ",  "I think " + p2.chatHandleShort() + " likes you, pale style.", "I think you should hang out with " + p2.chatHandleShort() + " more, they could work great with you!", "You and " + p2.chatHandleShort() + " would be amazing, pale-wise.", "I've got it figured out: " + p2.chatHandleShort() + " wants to shoosh the shit out of you." ], ["Wait.... really?", "Holy shit.","Your joking.", "Me?",   "Really? " + p2.chatHandleShort() + "?", "Are you sure?", "Oh my gog really?", "Oh my god you are joking."],["I am not going to dignify that with a response. ", "I don't see how that's any of your business.","I don't need anyone to calm me down!","I'm doing just fine on my own, thanks.","I don't want to talk about this with you.", "Please stop pestering me about this.","So much no."]);
			chat += c.getOpeningLine(shipper, shipperStart);
			chat += c.getResponseBool(p1, p1Start, willItWork);
			c= new PlusMinusConversationalPair(["Just trust me, you should absolutely try messaging them. ",  "I believe in you!","Ask them out! It'll totally work!", "Believe in the shipping guru.", "Trust me!","When have I ever let you down?", "Listen, this is the best idea since sliced bread!", "You two are the OTP, trust me.", "You can do it!"], ["Wow... maybe you are right! ", "Yeah, okay, I'll message them right away."],["Yeah, that is not going to happen.", "Sorry, but no."]);
			chat += c.getOpeningLine(shipper, shipperStart);
			chat += c.getResponseBool(p1, p1Start, willItWork);
			this.shippingChat = chat;
			if(willItWork){ //now it's time to build up the confession.
				chat = "";  //don't need to get relationships, i know they both like each other
				var willTheyAgree = this.evaluatePaleProposal(p2, p1);
				//for these, second column will always be about "are they going to say yes or not"
				c= new PlusMinusConversationalPair(["Hey!","Hey", "Hello!", "Hiya!","Hey hey!","Hows it going?"], ["Hey!", "Oh cool, I was just thinking of you!","Hey! Good to see you!","Hey!"],["What's up?", "Hey.","Oh. Hey.","Hey.","What do you want?"]);
				chat += c.getOpeningLine(p1, p1Start);
				chat += c.getResponseBool(p2, p2Start, willTheyAgree);
				c= new PlusMinusConversationalPair(["So... you know how " + shipper.chatHandleShort() + " is always bugging and fussing and meddling? ", shipper.chatHandleShort() + " was just pestering me about that shipping grid thing they do.", "You know " + shipper.chatHandleShort() + "'s 'thing' about romance?", "Hey, you know how " + shipper.chatHandleShort() + " is always going on and on about relationships?",  shipper.chatHandleShort() + "has been bugging me soooo much recently."], ["Oh! Yeah, that sure is a thing they do!", "Oh yeah?", "Oh yeah. You know, its kind of flattering how much effort they put into that.", "Yeah?", "They do give unacannaly good advice sometimes."],["Hah, they are always so off base with their ships.", "Uh huh?","Hm.", "Oh yeah, they are such idiots about it too!", "Yeah, they're always trying to find my 'pap-mate' or whatever!?"]);
				chat += c.getOpeningLine(p1, p1Start);
				chat += c.getResponseBool(p2, p2Start, willTheyAgree);
				c= new PlusMinusConversationalPair(["Look, I'll come right out and say it. I think I'm pale for you. ","I like you. Romantically. In the pale quadrant.","Look I... I want to pap the shit out of you.", "Look I was thinking, and I realized: I want us to moirails."], ["Holy shit! Really!?  I... fuck, I like you too!", "Oh. Oh fuck. Wow. I like you, too!", "I... nothing would make me happier!", "I've wanted to pap you to unconsiousness for forever!"],["I can't. Don't make me choose. I can't say yes.", "I'm so sorry... I just can't reciprocate right now.", "I... I'm sorry I don't like you that way.", "I... I can't... I don't...", "I'm sorry, I'm just not ready for that kind of relationship right now.", "We are in a murder game. As flattering as this is, I can't return those feelings. Not now.","I don't need a moirail!"]);
				chat += c.getOpeningLine(p1, p1Start);
				chat += c.getResponseBool(p2, p2Start, willTheyAgree);
				if(willTheyAgree){ //celebrate success, change relationship status, give huge boost to shipper, return result.;
					c= new PlusMinusConversationalPair(["Oh fuck yes!","Oh wow, I sure am glad I listened to " + shipper.chatHandleShort() + "! ", "YES!!!!","I am so, so, so happy right now.", "Really? YES YES YES YES YES YES!","Oh thank god. Now I don't have to worry about hurting people!"], ["<>","I'll always be glad to be here for you!","Shoosh."],["JR: This will never hit cause i know they said yes."]);
					chat += c.getOpeningLine(p1, p1Start);
					chat += c.getResponseBool(p2, p2Start, willTheyAgree);
					Relationship.makeDiamonds(p1, p2);
					this.chosenShipper.player.increasePower();
					this.chosenShipper.player.leveledTheHellUp = true;
					ret += "The " + this.chosenShipper.player.htmlTitleBasic() + " is estatic that their ship worked out so well. They grow as a " + this.chosenShipper.player.aspect.name + " player. ";
				}else{ //response to being rejected.
					c= new PlusMinusConversationalPair(["Fuck","But... fuck. "],["JR: this won't happen because i know they got rejected."], ["I'm sorry. I really am."]);
					chat += c.getOpeningLine(p1, p1Start);
					chat += c.getResponseBool(p2, p2Start, willTheyAgree);
					ret += "The " + this.chosenShipper.player.htmlTitleBasic() + " is disappointed that it didn't work out. Oh well, if at first you don't succeed...";
				}
				this.romanceChat = chat;
			}else{
				ret += "The " + this.chosenShipper.player.htmlTitleBasic() + " is frustrated that the " + p1.htmlTitleBasic() + " won't listen to reason. ";
			}
			this.shippingAfterMath = ret;
	}
	void tryToConvinceAshen(Player shipper, String shipperStart, Player p1, String p1Start, Player p2, String p2Start){
			String chat = "";
			String ret = "";
			//chats happen in order.
			bool willItWork = this.evaluateAshenProposal(p1, p2);
			//Relationship myRelationshipWithOTP1 = shipper.getRelationshipWith(p2);
			Relationship theirRelationshipWithMe = p2.getRelationshipWith(shipper);
			PlusMinusConversationalPair c = new PlusMinusConversationalPair(["Sooo... hey! ", "We never talk!","Hey!","Hello!","Um... hey!","I kind of need to talk to you."], ["Hey.","Hiya","Whats up?","Good to see you.","Hows it going?"],["Hey, asshole.","Fuck off.","Eat shit and die.","Oh god.", "Sup, dipshit.","Blugh.","FML.", "Nope. Nope. Nope.", "Yes?", "And you are?", "Ugh."]);
			chat += c.getOpeningLine(shipper, shipperStart);
			chat += c.getResponseRelationship(p1, p1Start, theirRelationshipWithMe);
			c= new PlusMinusConversationalPair(["Sooo... hey! ", "We never talk!","Hey!","Hello!","Um... hey!","I kind of need to talk to you."], ["Hey.","Hiya","Whats up?","Good to see you.","Hows it going?"],["Hey, asshole.","Fuck off.","Eat shit and die.","Oh god.", "Sup, dipshit.","Blugh.","FML.", "Nope. Nope. Nope.", "Yes?", "And you are?", "Ugh."]);
			if(shipper == p1){
				shipper = Player.makeRenderingSnapshot(shipper);
				shipper.chatHandle = "future" + shipper.chatHandle;
				shipperStart = "F"+shipperStart;
				c= new PlusMinusConversationalPair(["Look, don't panic, but I'm you from the future and you HAVE to listen to me. ", "Yo, its future you. Again.", "Time for future you/me to give you future wisdom."], ["What the fuck?", "Holy shit, give me your future wisdom.","Ok.","Again?"],["Holy shit, why are you dooming a timeline?","Not this shit again, we agreed no cross time chats!", "Nope. Nope. Nope.", "Fuck my life.", "Oh god.", "Sup, dipshit.","Blugh.","FML.","Eat shit and die."]);
			}
			chat += c.getOpeningLine(shipper, shipperStart);
			chat += c.getResponseRelationship(p1, p1Start, theirRelationshipWithMe);
			//from this point on, second array isn't "i hate you you suck", but "i am NOT going to message my crush." it's getP2ResponseBasedOnBool, not relationship
			c= new PlusMinusConversationalPair(["I think you and " + p2.chatHandleShort() + " are a TERRIBLE match, for spades. I... kind of want to keep you guys from getting together. ",  "I think " + p2.chatHandleShort() + " likes you, spades style. Aaannnd... that is a TERRIBLE idea. I want to sort of maybe kind of auspisticize you guys.", "You know that hate thing " + p2.chatHandleShort() + " has for you? I want to step in.", "You and " + p2.chatHandleShort() + " need to get that hate thing together or I'm going to have to mediate."], ["Wait.... really!? ", "Holy shit.","Oh thank god!","Uh?","Are you joking me?"],["I am not going to dignify that with a response. ", "I don't see how that's any of your business.","We don't need your help.","HAHAHAHAHAHAHAHAHA!","Uh.","Nope. Nope. Nope."]);
			chat += c.getOpeningLine(shipper, shipperStart);
			chat += c.getResponseBool(p1, p1Start, willItWork);
			c= new PlusMinusConversationalPair(["Just trust me, if you agree, I'll message them next. ",  "I am gonna contact them next if you agree. ", "Believe in the shipping guru.", "Trust me!","When have I ever let you down?", "Listen, this is the best idea since sliced bread!", "We three are the OTP, trust me.", "Please? I'll contact them next if you say yes."], ["Wow...maybe you are right! ", "Yeah, okay, go ahead.","I was at my wits end! Thank you so much!","Uh...uh yeah! That works!","I... wow…yes!"],["Yeah, that is not going to happen.", "Sorry, but no.","Oh my god no. So much no.","Like hell am I letting you get between me and " + p2.chatHandleShort() + ".", "I respectfully decline your help.","I think we can manage ourselves without the village two wheel device stepping in, thank you very much.","Fuck off.","Nope. Nope. Nope."]);
			chat += c.getOpeningLine(shipper, shipperStart);
			chat += c.getResponseBool(p1, p1Start, willItWork);
			this.shippingChat = chat;
			if(willItWork){ //now it's time to build up the confession.
				chat = "";  //don't need to get relationships, i know they both like each other
				var willTheyAgree = this.evaluateAshenProposal(p2, p1);
				//for these, second column will always be about "are they going to say yes or not"
				c= new PlusMinusConversationalPair(["Hey!","Hey!", "Hello!", "Hiya!","Hey hey!","Hows it going?"], ["Hey!", "Oh cool, I was just thinking of you!"],["What's up?", "Hey"]);
				chat += c.getOpeningLine(shipper, shipperStart);
				chat += c.getResponseBool(p2, p2Start, willTheyAgree);
				c= new PlusMinusConversationalPair(["So...you know how I try to stay on top of romance shit? ","I just got done talking to " + p1.chatHandleShort() + ". "], ["Yeah?", "Oh yeah?"],["Hah, you always so off base with their ships.", "Uh huh?"]);
				chat += c.getOpeningLine(shipper, shipperStart);
				chat += c.getResponseBool(p2, p2Start, willTheyAgree);
				c= new PlusMinusConversationalPair(["Look, I'll come right out and say it. I think you guys would be terrible together black, and I'm willing to mediate. ","I like you. Romantically. In the ashen quadrant, with " + p1.chatHandleShort()+". "], ["Holy shit! Really!?  I...fuck, I would really like that!", "Oh. Oh fuck. Wow. I was wondering how I was gonna turn down that asshole. This works out perfect!"],["I can't. Don't make me choose. I can't say yes.", "I'm so sorry... I just can't reciprocate right now."]);
				chat += c.getOpeningLine(shipper, shipperStart);
				chat += c.getResponseBool(p2, p2Start, willTheyAgree);
				if(willTheyAgree){ //celebrate success, change relationship status, give huge boost to shipper, return result.;
					c= new PlusMinusConversationalPair(["Oh fuck yes!","You guys had better behave! "], ["c3<"],["JR: This will never hit cause i know they said yes."]);
					chat += c.getOpeningLine(shipper, shipperStart);
					chat += c.getResponseBool(p2, p2Start, willTheyAgree);
					Relationship.makeClubs(shipper,p1, p2);  //they get a relationship!!!
					this.chosenShipper.player.increasePower();
					this.chosenShipper.player.leveledTheHellUp = true;
					ret += "The " + this.chosenShipper.player.htmlTitleBasic() + " is estatic that their ship worked out so well. They grow as a " + this.chosenShipper.player.aspect.name + " player. ";
				}else{ //response to being rejected.
					c= new PlusMinusConversationalPair(["Fuck","But... fuck. "],["JR: this won't happen because i know they got rejected."], ["I'm sorry. I really am."]);
					chat += c.getOpeningLine(shipper, shipperStart);
					chat += c.getResponseBool(p2, p2Start, willTheyAgree);
					ret += "The " + this.chosenShipper.player.htmlTitleBasic() + " is disappointed that it didn't work out. Oh well, if at first you don't succeed...";
				}
				this.romanceChat = chat;
			}else{
				ret += "The " + this.chosenShipper.player.htmlTitleBasic() + " is frustrated that the " + p1.htmlTitleBasic() + " won't listen to reason. ";
			}
			this.shippingAfterMath = ret;
	}
	void tryToConvinceBlack(Player shipper, String shipperStart, Player p1, String p1Start, Player p2, String p2Start){
			String chat = "";
			String ret = "";
			//chats happen in order.
			bool willItWork = this.evaluateBlackProposal(p1, p2);
			//Relationship myRelationshipWithOTP1 = shipper.getRelationshipWith(p2);
			Relationship theirRelationshipWithMe = p2.getRelationshipWith(shipper);
			PlusMinusConversationalPair c = new PlusMinusConversationalPair(["Sooo...hey! ", "We never talk!","Hey!","Hello!","Um... hey!","I kind of need to talk to you."], ["Hey.","Hiya","Whats up?","Good to see you.","Hows it going?"],["Hey, asshole.","Fuck off.","Eat shit and die.","Oh god.", "Sup, dipshit.","Blugh.","FML.", "Nope. Nope. Nope.", "Yes?", "And you are?", "Ugh."]);
			if(shipper == p1){
				shipper = Player.makeRenderingSnapshot(shipper);
				shipper.chatHandle = "future" + shipper.chatHandle;
				shipperStart = "F"+shipperStart;
				c= new PlusMinusConversationalPair(["Look, don't panic, but I'm you from the future and you HAVE to listen to me. ", "Yo, its future you. Again.", "Time for future you/me to give you future wisdom."], ["What the fuck?", "Holy shit, give me your future wisdom.","Ok.","Again?"],["Holy shit, why are you dooming a timeline?","Not this shit again, we agreed no cross time chats!", "Nope. Nope. Nope.", "Fuck my life.", "Oh god.", "Sup, dipshit.","Blugh.","FML.","Eat shit and die."]);
			}
			chat += c.getOpeningLine(shipper, shipperStart);
			chat += c.getResponseRelationship(p1, p1Start, theirRelationshipWithMe);
			c= new PlusMinusConversationalPair(["You know how I keep track of romance shit? ", "So I was going over my shipping grid, and I wanted to run something by you."], ["Okay?", "I'm listening..."],["Oh god, not that again.", "Is this REALLY a priority right now?"]);
			chat += c.getOpeningLine(shipper, shipperStart);
			chat += c.getResponseRelationship(p1, p1Start, theirRelationshipWithMe);
			//from this point on, second array isn't "i hate you you suck", but "i am NOT going to message my crush." it's getP2ResponseBasedOnBool, not relationship
			c= new PlusMinusConversationalPair(["I think you and " + p2.chatHandleShort() + " might work out really well spades. ",  "I think " + p2.chatHandleShort() + " likes you, spades style."], ["Wait.... really!? ", "Holy shit."],["I am not going to dignify that with a response. ", "I don't see how that's any of your business."]);
			chat += c.getOpeningLine(shipper, shipperStart);
			chat += c.getResponseBool(p1, p1Start, willItWork);
			c= new PlusMinusConversationalPair(["Just trust me, you should absolutely try messaging them. ",  "I believe in you!","Ask them out! It'll totally work!", "Believe in the shipping guru.", "Trust me!","When have I ever let you down?", "Listen, this is the best idea since sliced bread!", "You two are the OTP, trust me.", "You can do it!"], ["Wow...maybe you are right! ", "Yeah, okay, I'll message them right away."],["Yeah, that is not going to happen.", "Sorry, but no.","Ehhh. I don't think I hate them that much."]);
			chat += c.getOpeningLine(shipper, shipperStart);
			chat += c.getResponseBool(p1, p1Start, willItWork);
			this.shippingChat = chat;
			if(willItWork){ //now it's time to build up the confession.
				chat = "";  //don't need to get relationships, i know they both like each other
				var willTheyAgree = this.evaluateBlackProposal(p2, p1);
				//for these, second column will always be about "are they going to say yes or not"
				c= new PlusMinusConversationalPair(["Hey!","Hey dunkass!","Hows it going shit for brains?","Its time you and me talk.","Ugh, I really wish I didn't have to talk to you.","Sup shitface.","Hey asshat.","I need to talk.","Yo, fuckface."], ["Hey!", "Oh cool, I was just thinking of you!","Go fuck yourself, dipshit.","Eat me.","Oh gog. Not this fucker.","Fuck this.", "Fuck off and die.", "Hey dunkass.", "Hey poopbreath.", "Whats up, farmstink?"],["What's up?", "Hey","Uh, hey?","Hey?","Hey?","Uh, hows it going?","Whats up?"]);
				chat += c.getOpeningLine(p1, p1Start);
				chat += c.getResponseBool(p2, p2Start, willTheyAgree);
				c= new PlusMinusConversationalPair(["So...you know how " + shipper.chatHandleShort() + " is always bugging and fussing and meddling? ",shipper.chatHandleShort() + " was just pestering me about that shipping grid thing they do. "], ["Oh! Yeah, that sure is a thing they do!", "Oh yeah?"],["Hah, they are always so off base with their ships.", "Uh huh?"]);
				chat += c.getOpeningLine(p1, p1Start);
				chat += c.getResponseBool(p2, p2Start, willTheyAgree);
				c= new PlusMinusConversationalPair(["Look, I'll come right out and say it. I think I hate you, you fucking asshole. Spades-wise.","I hate you. Romantically. In the spades quadrant."], ["Holy shit! Really!?  I...fuck, I hate you too!", "Oh. Oh fuck. Wow. I hate you, too!"],["I can't. Don't make me choose. I can't say yes.", "I'm so sorry... I just can't reciprocate right now."]);
				chat += c.getOpeningLine(p1, p1Start);
				chat += c.getResponseBool(p2, p2Start, willTheyAgree);
				if(willTheyAgree){ //celebrate success, change relationship status, give huge boost to shipper, return result.;
					c= new PlusMinusConversationalPair(["Oh fuck yes!","Oh wow, I sure am glad I listened to " + shipper.chatHandleShort() + "! "], ["<3<"],["JR: This will never hit cause i know they said yes."]);
					chat += c.getOpeningLine(p1, p1Start);
					chat += c.getResponseBool(p2, p2Start, willTheyAgree);
					Relationship.makeSpades(p1, p2);
					this.chosenShipper.player.increasePower();
					this.chosenShipper.player.leveledTheHellUp = true;
					ret += "The " + this.chosenShipper.player.htmlTitleBasic() + " is estatic that their ship worked out so well. They grow as a " + this.chosenShipper.player.aspect.name + " player. ";
				}else{ //response to being rejected.
					c= new PlusMinusConversationalPair(["Fuck","But... fuck. "],["JR: this won't happen because i know they got rejected."], ["I'm sorry. I really am."]);
					chat += c.getOpeningLine(p1, p1Start);
					chat += c.getResponseBool(p2, p2Start, willTheyAgree);
					ret += "The " + this.chosenShipper.player.htmlTitleBasic() + " is disappointed that it didn't work out. Oh well, if at first you don't succeed...";
				}
				this.romanceChat = chat;
			}else{
				ret += "The " + this.chosenShipper.player.htmlTitleBasic() + " is frustrated that the " + p1.htmlTitleBasic() + " won't listen to reason. ";
			}
			this.shippingAfterMath = ret;
	}
	bool evaluateFlushedProposal(Player player, Player target){
			int reasonsFor = 1; //come on, you know you like them.
			if(session.mutator.heartField) reasonsFor = 333;
			int reasonsAgainst = 0;
			reasonsAgainst += player.getHearts().length; //I am already in a relationship
			reasonsAgainst += target.getHearts().length; //they are already in a relationship
			if(player.getHearts().length == 0) reasonsFor ++; //I am single
			if(!player.isQuadranted()) reasonsFor += 4; //I am lonely
			if(player.getBestFriend() == target) reasonsFor += 5; //I REALLY like them.
			Relationship r = player.getRelationshipWith(this.chosenShipper.player);
			if(r != null && r.value < 0) reasonsAgainst ++; //say 'no' just to spite shipper
			if(player.getWorstEnemyFromList(this.session.players) == this.chosenShipper.player) reasonsAgainst += 5; //I REALLY hate the shipper.
			return reasonsFor > reasonsAgainst;
	}
	bool evaluatePaleProposal(Player player, Player target){
			int reasonsFor = 1; //come on, you know you like them.
			int reasonsAgainst = 0;
			reasonsAgainst += player.getDiamonds().length; //I am already in a relationship
			reasonsAgainst += target.getDiamonds().length; //they are already in a relationship
			if(player.getDiamonds().length == 0) reasonsFor ++; //I am single
			if(player.getStat(Stats.SANITY) < 0) reasonsFor ++;  //i need SOMEBODY to stabilize me.
			if(!player.isQuadranted()) reasonsFor += 4; //I am lonely
			if(player.getBestFriend() == target) reasonsFor += 5; //I REALLY like them.
			Relationship r = player.getRelationshipWith(this.chosenShipper.player);
			if(r != null && r.value < 0) reasonsAgainst ++; //say 'no' just to spite shipper
			if(player.getWorstEnemyFromList(this.session.players) == this.chosenShipper.player) reasonsAgainst += 5; //I REALLY hate the shipper.
			return reasonsFor > reasonsAgainst;
	}
	bool evaluateAshenProposal(Player player, Player target){
			if(this.chosenShipper.player == player || this.chosenShipper.player == target) return false; // you can't be in a quadrant with yourself, dunkass.
			int reasonsFor = 1; //come on, you know you like them.
			int reasonsAgainst = 0;
			reasonsFor += player.getSpades().length; //I am already in a relationship, so I should stop being black for them.
			reasonsFor += target.getSpades().length; //they are already in a relationship, so i should stop being black for them.
			if(player.getSpades().length == 0) reasonsAgainst ++; //I am single
			if(!player.isQuadranted()) reasonsFor += 4; //I am lonely
			if(player.getWorstEnemyFromList(this.session.players) == target) reasonsFor += 5; //I REALLY like them.
			Relationship r = player.getRelationshipWith(this.chosenShipper.player);
			if(r != null && r.value < 0) reasonsFor ++; //actually, you really hate the shipper, too, this might work out.
			if(player.getWorstEnemyFromList(this.session.players) == this.chosenShipper.player) reasonsFor += 5; //I REALLY hate the shipper, this might work out.
			if(r != null && r.value > 0) reasonsAgainst ++; //actually, you really like the shipper, you don't want to be ashen for them.
			if(player.getBestFriend() == this.chosenShipper.player) reasonsAgainst += 50; //hell no, i can't be ashen for someone i like this much.

			return reasonsFor > reasonsAgainst;
	}
	bool evaluateBlackProposal(Player player, Player target){
			int reasonsFor = 1; //come on, you know you like them.
			int reasonsAgainst = 0;
			reasonsAgainst += player.getSpades().length; //I am already in a relationship
			reasonsAgainst += target.getSpades().length; //they are already in a relationship
			if(player.getSpades().length == 0) reasonsFor ++; //I am single
			if(!player.isQuadranted()) reasonsFor += 4; //I am lonely
			if(player.getWorstEnemyFromList(this.session.players) == target) reasonsFor += 5; //I REALLY hate them.
			Relationship r = player.getRelationshipWith(this.chosenShipper.player);
			if(r != null && r.value < 0) reasonsAgainst ++; //say 'no' just to spite shipper
			if(player.getWorstEnemyFromList(this.session.players) == this.chosenShipper.player) reasonsAgainst += 5; //I REALLY hate the shipper.
			return reasonsFor > reasonsAgainst;
	}
	String content(){
		//////session.logger.info("Updating shipping grid in: " + this.session.session_id);
		////session.logger.info("Chosen Shipper: ${this.chosenShipper.player}");
		session.removeAvailablePlayer(chosenShipper.player);
		this.chosenShipper.player.increasePower();
		String shippingStyle = "They like the conciliatory ships best, and default to those for people not yet in a quadrant.";
		if(this.chosenShipper.player.aspect == Aspects.HEART) shippingStyle = "They like the concupiscient ships best, and default to those for people not yet in a quadrant.";
		String fuckPile = "";
		if(this.chosenShipper.savedShipText.length > 4000){
			fuckPile += " How did this session turn into such a scandalous fuckpile? ";
		//	////session.logger.info( this.savedShipText.length + " scandalous fuck pile " + this.session.session_id);
		}
		String ret = "The " + this.chosenShipper.player.htmlTitleBasic() + " updates their shipping grid. " + shippingStyle +fuckPile + " <Br>" + this.chosenShipper.savedShipText;
		if(this.chosenShipper.otp != null){
			ret += this.activateShippingPowers(this.chosenShipper.otp);
		}
		return ret;

	}

}





//contains both relationship and it's inverse, knows how to render itself. dead players have a hussie style x over their faces.
//ships can also refuse to render themselves.  return false if that happens.;
// render if: r2.saved_type == r2.goodBig || r2.saved_type == r2.badBig
class Ship {
	Relationship r1;
	Relationship r2;
	Shipper shipper; //so i can tell shipper if  am a potential OTP
	Player player;

	Ship(Relationship this.r1, Relationship this.r2, Shipper this.shipper) {
		player = shipper.player;
	}



	String toString(){
			return r2.target.htmlTitleBasicNoTip() + " " + (r1.asciiDescription(player)) + "---" + (r2.asciiDescription(player)) + " " + r1.target.htmlTitleBasicNoTip();
		}
	bool isEqualToShip(ship){
			//////session.logger.info("comparing: " + this.toString() + " to "  + ship.toString())
			if(ship.r1 == this.r1 && ship.r2 == this.r2){
				//////session.logger.info("they are the same1");
				return true;
			}else if(ship.r2 == this.r1 && ship.r1 == this.r2){
				//////session.logger.info("they are the same2");
				return true;
			}
		//	////session.logger.info("they are not the same");
			return false;
		}
	bool isGoodShip(){
			Relationship r2 = this.r2;
			Relationship r1 = this.r1;
			if(r1 == null || r2 == null) return false; //light player gnosis fuckery
		//	//session.logger.info("Comparing ships ${r2.saved_type} : ${r2.value} with ${r1.saved_type} : ${r2.value}");
			//might not work, not clear anymore on when old_type gets cleared out. will this work EVERY TIME after they get together (wrong), NO TIME (wrong) or just once (what i want)
			//well, i guess if it works every time that's good too, shipper gets ongoing "smugness" bonus as long as the ship remains real.
			if(r2.saved_type == "" || r1.saved_type == "" ){
				return false;
			}

			if((r1.saved_type == r1.goodBig || r1.saved_type == r1.badBig) && r2.saved_type == r1.saved_type){
				if(!r1.target.dead && !r2.target.dead) shipper.otp = this; //omg stop trying to convince corpses to fuck.
				return true;
			}

			if(r1.saved_type == r1.goodBig || r1.saved_type == r1.badBig || r1.saved_type == r1.heart || r1.saved_type == r1.diamond || r1.saved_type == r1.spades || r1.saved_type == r1.clubs){
				return true;
			}

			if(r2.saved_type == r2.goodBig || r2.saved_type == r1.badBig || r2.saved_type == r1.heart || r2.saved_type == r2.diamond || r2.saved_type == r2.spades || r2.saved_type == r2.clubs){
				return true;
			}
			return false;
		}


}



//blood players keep track of concillitory, heart players concupisient. each one has their own shipping grid for future use
//eventually want blood/heart to have things like OTPs or whatever that they label and care about (even commenting if it beomes real and getting a power boost)
//heart players will assume people who seem to have crushes on each other will end up spades/heart, and blood players clubs/diamonds
//when ship becomes "real", if it's what they thought, comment and power boost???
class Shipper {

	Shipper(this.player) {}



	Player player;
	Ship otp = null; //when i'm going through ships, if i see a clearly requirted crush, will try to get them together.
	List<Ship> ships = null; //set right after creating.
	num powerNeeded = 1;
	String savedShipText = ""; ///need to know if my ships have updated.

}




