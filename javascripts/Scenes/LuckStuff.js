function LuckStuff(session){
	this.session = session;
	this.canRepeat = true;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.rolls = [];
	//luck can be good or it can be bad.
	this.minLowValue = -100;
	this.minHighValue = 200;
	this.landLevelNeeded = 12;
	this.numberTriggers = 0; //can't just spam this.

	this.trigger = function(playerList){
		this.rolls = [];//reset
		if(this.numberTriggers > 10){
		//	console.log("too much luck events in " + this.session.session_id)
			return false;
		}
		//what the hell roue of doom's corpse. corpses aren't part of the player list!
		for(var i = 0; i<this.session.availablePlayers.length; i++){
			var player = this.session.availablePlayers[i];
			var rollValueLow = player.rollForLuck("minLuck");  //separate it out so that EITHER you are good at avoiding bad shit OR you are good at getting good shit.
			var rollValueHigh = player.rollForLuck("maxLuck");
			//can have two luck events in same turn, whatever. fuck this complicated code, what was i even thinking???
			if(rollValueHigh > this.minHighValue){
				//alert("High  roll of: " + rollValueHigh);
				this.rolls.push(new Roll(player, rollValueHigh));
			}
			
			if(rollValueLow < this.minLowValue){
				//alert("Low  roll of: " + rollValueLow);
				this.rolls.push(new Roll(player, rollValueLow));
			}
		}
		return this.rolls.length > 0
	}

	this.renderContent = function(div){
		this.numberTriggers ++;
		//var ret = "<img src = 'images/fortune_event.png'/><Br>";  //maybe display image for this event, like not canvas, just image. Single image for event.
		var ret = "";
		div.append("<br> <img src = 'images/sceneIcons/luck_icon.png'>");
		for(var i = 0; i<this.rolls.length; i++){
			var roll = this.rolls[i];
			removeFromArray(roll.player, this.session.availablePlayers);
			var s = this.processRoll(roll,div) + "<br><Br>";
			ret += s;
		}
		div.append("" + ret)
	}

	this.roll60 = function(roll){
		//console.log("roll60 in " + this.session.session_id)
		if(!roll.player.land || (roll.player.aspect != "Space" && roll.player.landLevel >= this.landLevelNeeded)){  //not lucky to get land level when you don't need it.
			return this.roll65(roll);
		}
		var ret = "The " + roll.player.htmlTitle() + " was just wandering around on " + roll.player.shortLand()+ " when they suddenly tripped over a huge treasure chest! When opened, it revealed a modest hoarde of grist. It will be easier to complete their land quests now.";
		roll.player.landLevel ++;
		this.session.goodLuckEvent = true;
		return ret;
	}

	this.roll65 = function(roll){
		//console.log("roll65 in " + this.session.session_id)
		var land = "some random planet"
		if(roll.player.land){
			land = roll.player.shortLand();
		}
		var f = roll.player.getNewFraymotif();
		var ret = "The " + roll.player.htmlTitle() + " was just wandering around on " + land + " when they suddenly tripped over a huge treasure chest! When opened, it revealed a modest cache of boonbucks. They will finally be able to afford that fraymotiff, "+f.name + ", they have had their eye on! ";
		//roll.player.increasePower();
		this.session.goodLuckEvent = true;
		return ret;
	}
	//decreasing power is not a thing. so only land level?
	this.roll40 = function(roll){
		if(!roll.player.land){
			return; //you've had enough bad luck. just...go rest or something.
		}
		//console.log("roll40 in " + this.session.session_id)
		var ret = "The " + roll.player.htmlTitle() + " was just wandering around on " + roll.player.shortLand()+ " when they suddenly tripped over a huge bee hive. The angry bees immediately ravage the country side, pestering local consorts.";
		roll.player.landLevel += -1
		this.session.badLuckEvent = true;
		return ret;
	}

	this.roll35 = function(roll){
		console.log("unlucky trigger event: " + this.session.session_id)
		var items = ["soper slime", "candy", "apple juice", "alcohol", "cat nip","chocolate", "orange soda", "blanket","hat","lucky coin", "magic 8 ball"];
		var ret = "The " + roll.player.htmlTitle() + " has lost their " + getRandomElementFromArray(items) + ". Sure, it seems stupid to you or me but... it was one of the few things left holding their sanity together. They are enraged."
		roll.player.sanity += -1000;
		this.session.badLuckEvent = true;
		return ret;
	}


	this.roll70 = function(roll){
		//console.log("roll70 in " + this.session.session_id)
		var friend = getRandomElementFromArray(roll.player.getFriendsFromList(findLivingPlayers(this.session.players)));
		if(!friend){
			return this.roll65(roll); //backup result.
		}
		var ret = "The " + roll.player.htmlTitle() + " was fucking around on the internet and accidentally sent the " + friend.htmlTitle() + " a message meant for someone else. Luckily, they seem flattered instead of offended. ";
		friend.getRelationshipWith(roll.player).increase();
		friend.getRelationshipWith(roll.player).increase();
		friend.getRelationshipWith(roll.player).increase();
		this.session.goodLuckEvent = true;
		return ret;
	}

	this.roll30 = function(roll){
		//console.log("roll30 in " + this.session.session_id)
		var friend = getRandomElementFromArray(roll.player.getFriendsFromList(findLivingPlayers(this.session.players)));
		if(!friend){
			return this.roll65(roll); //backup result.
		}
		var ret = "The " + roll.player.htmlTitle() + " was fucking around on the internet and accidentally sent the " + friend.htmlTitle() + " a message meant for someone else. They will never live this down. The " + friend.htmlTitleBasic() + " seems pretty offended, too.";
		friend.getRelationshipWith(roll.player).decrease();
		friend.getRelationshipWith(roll.player).decrease();
		friend.getRelationshipWith(roll.player).decrease();
		this.session.badLuckEvent = true;
		return ret;
	}

	this.roll25 = function(roll){
		console.log("unluck grim dark: " + this.session.session_id)
		var items = ["magic cue ball", "grimoire", "original VHS tape of Mac and Me", "fluthlu doll", "dream catcher","squiddles plush", "Dr Seuss Book", "commemorative Plaque from a World Event That Never Happened","SCP-093"];
		var ret = "The " + roll.player.htmlTitle() + " has had a momentary lapse of judgement and alchemized a weapon with the " + getRandomElementFromArray(items) + " they just found. Any sane adventurer would cast these instruments of the occult into the FURTHEST RING and forget they ever existed. Instead, the " + roll.player.htmlTitleBasic() + " equips them. This is a phenomenally bad idea. "
		roll.player.corruptionLevelOther += 666; //will only increase corruption by one level, but in style
		roll.player.power += 50;  //it IS a weapon, points out aspiringWatcher
		this.session.badLuckEvent = true;
		return ret;
	}

	this.roll80 = function(roll){
		//console.log("roll80 in " + this.session.session_id)
		if(!roll.player.land || (roll.player.aspect != "Space" && roll.player.landLevel >= this.landLevelNeeded)){  //not lucky to get land level when you don't need it.
			return this.roll85(roll);
		}
		var ret = "The " + roll.player.htmlTitle() + " tripped right through a glitched section of wall, only to find a single imp. 'Shh.' the imp says, handing over a frankly obscene bucket of grist, 'It's a secret to everybody.' The " + roll.player.htmlTitle() + " agrees that it would be ideal if it was a secret even to themselves, and prays for amnesia.  Like hell are they gonna leave behind the grist, though. Land quests don't solve themselves. " ;
		roll.player.landLevel ++;
		roll.player.landLevel ++;
		this.session.goodLuckEvent = true;
		return ret;
	}

	this.roll85 = function(roll){
		//console.log("roll85 in " + this.session.session_id)
		var land = "some random planet"
		if(roll.player.land){
			land = roll.player.shortLand();
		}
		var ret = "The " + roll.player.htmlTitle() + " was just wandering around on " + land + " when they see a GOLD IMP. Those things are worth a ton of experience points, if you can manage to even damage them. Holy shit, did the " + roll.player.htmlTitle() + " just ONE SHOT them!? ";
		roll.player.increasePower();
		roll.player.increasePower();
		roll.player.leveledTheHellUp = true;
		roll.player.level_index +=2;
		this.session.goodLuckEvent = true;
		return ret;
	}

	this.roll20 = function(roll){
		//console.log("roll20 in " + this.session.session_id)
		if(!roll.player.land){
			return; //you've had enough bad luck. just...go rest or something.
		}
		var ret = "The " + roll.player.htmlTitle() + " tripped right through a glitched section of wall, only to find a single consort. 'Shh.' the imp says, handing over a frankly obscene bucket of...something, 'It's a secret to everybody.' The " + roll.player.htmlTitleBasic() + " agrees that it would be ideal if it was a secret even to themselves, and prays for amnesia.  They can't quite bring themselves to go near their consorts for a little while aftewards. " ;
		roll.player.landLevel += -2
		this.session.badLuckEvent = true;
		return ret;
	}

	this.roll90 = function(roll){
		//console.log("roll90 in " + this.session.session_id)
		var ret = "Holy shit, the " + roll.player.htmlTitle() + " just found a METAL PUMPKIN. Those things are worth a LOT of experience points! And they totally managed to explode it before it never existed in the first place! Score! Talk about luuuuuuuucky!" ;
		roll.player.increasePower();
		roll.player.increasePower();
		roll.player.increasePower();
		roll.player.leveledTheHellUp = true;
		roll.player.level_index +=3;
		this.session.goodLuckEvent = true;
		return ret;
	}

	this.roll95 = function(roll){
		//console.log("roll95 in " + this.session.session_id)
		if(!roll.player.land || (roll.player.aspect != "Space" && roll.player.landLevel >= this.landLevelNeeded)){  //not lucky to get land level when you don't need it.
			return this.roll90(roll);
		}
		var ret = "Through a frankly preposterous level of Scooby-Doo shenanigans, the  " + roll.player.htmlTitle() + " trips into a wall, which depresses a panel, which launches a catapult, which throws impudent fruit at a nearby Ogre, which wakes him up, which makes him wander away, which frees the local consorts from his tyranny, who then celebrate an end to their famine by eating the fruit.  All of which causes, like, a third of the main quest of "  + roll.player.shortLand() + " to be completed. ";
		if(roll.player.aspect == "Space"){
			ret += "Wait. What the HELL!? Is that last Frog!? Just sitting there? Right in front of the " + roll.player.htmlTitle() + "!? No time shenanigans or prophecies or god damned Choices!? It's just...there. Well. Damn. That'll make the frog breeding WAY easier.";
		}
		roll.player.landLevel ++;
		roll.player.landLevel ++;
		roll.player.landLevel ++;
		this.session.goodLuckEvent = true;

		return ret;
	}

	this.roll10 = function(roll){
		//console.log("roll10 in " + this.session.session_id)
		if(!roll.player.land){
			return "The " + roll.player.htmlTitle() + " gets a bad feeling, like maybe their land back in their home session just got damaged. But...it's not like they can ever go back, right? Who cares."; //you've had enough bad luck. just...go rest or something.
		}
		var ret = "Through a frankly preposterous level of Scooby-Doo shenanigans, the  " + roll.player.htmlTitle() + " trips into a wall, which depresses a panel, which launches a flaming rock via catapult, which crashes into a local consort village. Which immediately catches on fire, which makes them be refugees, which makes them immegrate to a new area, which disrupts the stability of the entire goddamned planet.  All of which causes, like, a third of the main quest of "  + roll.player.shortLand() + " to be fucked up. ";
		roll.player.landLevel += -4;
		this.session.badLuckEvent = true;
		return ret;
	}

	this.roll100 = function(roll,div){
		//console.log("roll100 in " + this.session.session_id + " roll is: " + roll.value);

		if(roll.player.godDestiny && !roll.player.godTier && (roll.player.dreamSelf || roll.player.isDreamSelf)){
			var ret = " What the HELL!? The " + roll.player.htmlTitle() + " managed to somehow lose to REGULAR FUCKING ENEMIES!? Is that even POSSIBLE!? This is BULLSHIT. Wait. What's going on? How did they end up on their " ;
			if(!roll.player.isDreamSelf){
				ret += "QUEST BED!? Their body glows, and rises Skaiaward. "+"On " + roll.player.moon + ", their dream self takes over and gets a sweet new outfit to boot.  ";
				this.session.questBed = true;
				roll.player.makeDead("luckily on their Quest Bed")
			}else{
				ret += "SACRIFICIAL SLAB!? They glow and ascend to the God Tiers with a sweet new outfit."
				this.session.sacrificialSlab = true;
				//roll.player.makeDead("luckily on their Sacrificial Slab") doesn't make a ghost 'cause the corpse itself revives'
			}
			var f = this.session.fraymotifCreator.makeFraymotif([roll.player], 3);//first god tier fraymotif
			roll.player.fraymotifs.push(f);
			ret += " They learn " + f.name + ". " ;
			roll.player.makeGodTier();

			this.session.luckyGodTier = true;
			this.session.godTier = true;
			var divID = (div.attr("id")) + "_luckGodBS" + roll.player.chatHandle;
			var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
			div.append(ret);
			div.append(canvasHTML);
			var canvas = document.getElementById("canvas"+ divID);
			drawGetTiger(canvas, [roll.player],repeatTime) //only draw revivial if it actually happened.
			return "";
		}else{
			if(!roll.player.godDestiny && roll.player.dreamSelf && !roll.player.godTier ){
				//console.log("destined for greatness from reroll of luck in " + this.session.session_id + " roll is: " + roll.value);
				roll.player.godDestiny = true;
				return "Huh, the " + roll.player.htmlTitle() + " suddenly feels as if they are destined for greatness. ";
			}else{
				return this.roll90(roll);
			}
		}
		this.session.goodLuckEvent = true;

	}

	this.roll0 = function(roll,div){
		//console.log("roll0 in " + this.session.session_id + " roll is: " + roll.value + " player min luck was: " + roll.player.minLuck + " and max luck was: " + roll.player.maxLuck);
		if(roll.player.godDestiny && !roll.player.godTier && roll.player.dreamSelf){
			roll.player.godDestiny = false;
			var ret = "Huh, the " + roll.player.htmlTitle() + " suddenly feels a creeping sense of doom, as if they are no longer destined for greatness. ";
			//console.log("no longer destined for greatness from reroll of luck in " + this.session.session_id + " roll is: " + roll.value);
			return ret;
		}
		var ret = "What the HELL!? The " + roll.player.htmlTitle() + " managed to somehow lose to REGULAR FUCKING ENEMIES!? Is that even POSSIBLE!? This is BULLSHIT. How unlucky do you even need to BE!? They are DEAD."
		roll.player.makeDead("from a Bad Break.");
		div.append(ret);

		var divID = (div.attr("id")) + "_badLuckDeath" + roll.player.chatHandle;
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		var canvas = document.getElementById("canvas"+ divID);

		var pSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
		drawSprite(pSpriteBuffer,roll.player)

		copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,0,0)
		this.session.badLuckEvent = true;
		this.session.badBreakDeath = true;
		return "";

	}


	//5 good things that can happen, 5 bad things can happen
	this.processRoll = function(roll,div){
		var amount = 5;
		if(roll.value >= this.minHighValue && roll.value < this.minHighValue + amount){
			return this.roll60(roll);
		}else if(roll.value >= this.minHighValue + amount && roll.value < this.minHighValue + (amount*2)){
			return this.roll65(roll);
		}else if(roll.value >= this.minHighValue + (amount*2) && roll.value < this.minHighValue + (amount*3)){
			return this.roll70(roll);
		}else if(roll.value >= this.minHighValue + (amount*3) && roll.value < this.minHighValue + (amount*4)){
			return this.roll80(roll);
		}else if(roll.value >= this.minHighValue + (amount*4) && roll.value < this.minHighValue + (amount*2)){
			return this.roll85(roll);
		}else if(roll.value >= this.minHighValue + (amount*4) && roll.value < this.minHighValue + (amount*2)){
			return this.roll90(roll);
		}else if(roll.value >= this.minHighValue + (amount*4) && roll.value < this.minHighValue + (amount*2)){
			return this.roll95(roll);
		}else if(roll.value >= this.minHighValue + (amount*15)){
			return this.roll100(roll,div);
		}else if(roll.value > this.minLowValue - amount && roll.value <= this.minLowValue){
			return this.roll40(roll);
		}else if(roll.value > this.minLowValue - (amount*2) && roll.value <= this.minLowValue - amount){
			return this.roll30(roll);
		}else if(roll.value > this.minLowValue - (amount*3) && roll.value <= this.minLowValue - amount*2){
			return this.roll35(roll);
		}else if(roll.value > this.minLowValue - (amount*4) && roll.value <= this.minLowValue - amount*3){
			return this.roll25(roll);
		}else if(roll.value > this.minLowValue - (amount*5) && roll.value <= this.minLowValue - (amount*4)){
			return this.roll20(roll);
		}else if(roll.value > this.minLowValue - (amount*6) && roll.value <= this.minLowValue - (amount*5)){
			return this.roll10(roll);
		}else if(roll.value <= this.minLowValue - (amount*20)){
			return this.roll0(roll,div);
		}else if(roll.value < this.minLowValue){ //if I got here, i fell in the crack left where the old death value used to be
			return this.roll10(roll);  //used to be enough for a roll 0, but not anymore.
		}else if(roll.value > this. minHighValue){//if i got here, i fell in the crack left where the old godtier value used to be.
			return this.roll95(roll);
		}else{
			alert("NO this is NOT RIGHT, LUCK EVENT BROKEN")
			return "What the hell, mate? roll was: " + roll.value + " and needed to be not between  " + this.minLowValue + " and " + this.minHighValue;
		} 



	}

	this.content = function(div){
		return "1.0 is basically dead now, thems the breaks."
	}
}

function Roll(player, rollValue){
	this.player = player;
	this.value = rollValue;
}
