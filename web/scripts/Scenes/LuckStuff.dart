import "dart:html";
import "../SBURBSim.dart";


class LuckStuff extends Scene{
	@override
	List<Player> playerList = <Player>[];  //what players are already in the medium when i trigger?
	List<Roll> rolls = [];	//luck can be good or it can be bad.
	num minLowValue = -15;
	num minHighValue = 15;
	num landLevelNeeded = 12;
	num numberTriggers = 0; //can't just spam this.

	


	LuckStuff(Session session): super(session);

	@override
	bool trigger(List<Player> playerList){
		if(session.mutator.rapsAndLuckDisabled) return false;
		this.rolls = [];//reset
		if(this.numberTriggers > 10){
		//	//session.logger.info("too much luck events in " + this.session.session_id);
			return false;
		}
		//what the hell roue of doom's corpse. corpses aren't part of the player list!
		for(Player player in session.getReadOnlyAvailablePlayers()){
			double rollValueLow = player.rollForLuck(Stats.MIN_LUCK);  //separate it out so that EITHER you are good at avoiding bad shit OR you are good at getting good shit.
			double rollValueHigh = player.rollForLuck(Stats.MAX_LUCK);
			//can have two luck events in same turn, whatever. fuck this complicated code, what was i even thinking???
			if(player.canHelp()) { //can't spam luck stuff without playing the game.
				if (rollValueHigh > this.minHighValue) {
					//alert("High  roll of: " + rollValueHigh);
					this.rolls.add(new Roll(player, rollValueHigh));
				}

				if (rollValueLow < this.minLowValue) {
					//alert("Low  roll of: " + rollValueLow);
					this.rolls.add(new Roll(player, rollValueLow));
				}
			}
		}
		return this.rolls.length > 0;
	}

	@override
	void renderContent(Element div){
		this.numberTriggers ++;
		//String ret = "<img src = 'images/fortune_event.png'/><Br>";  //maybe display image for this event, like not canvas, just image. Single image for event.
		String ret = "";
        appendHtml(div,"<br> <img src = 'images/sceneIcons/luck_icon.png'>");
		for(num i = 0; i<this.rolls.length; i++){
			Roll roll = this.rolls[i];
			session.removeAvailablePlayer(roll.player);
			String s = this.processRoll(roll,div) + "<br><Br>";
			ret += s;
		}
        appendHtml(div,"" + ret);
	}
	String roll60(Roll roll){
		////session.logger.info("roll60 in " + this.session.session_id);
		if(roll.player.land == null || (roll.player.aspect != Aspects.SPACE && roll.player.landLevel >= this.landLevelNeeded)){  //not lucky to get land level when you don't need it.
			return this.roll65(roll);
		}
		String ret = "The " + roll.player.htmlTitle() + " was just wandering around on " + roll.player.shortLand()+ " when they suddenly tripped over a huge treasure chest! When opened, it revealed a modest hoard of grist. It will be easier to complete their land quests now.";
		roll.player.increaseLandLevel();
		this.session.stats.goodLuckEvent = true;
		return ret;
	}
	String roll65(Roll roll){
		////session.logger.info("roll65 in " + this.session.session_id);
		String land = "some random planet";
		if(roll.player.land != null){
			land = roll.player.shortLand();
		}
		Fraymotif f = roll.player.getNewFraymotif(null);
		String ret = "The " + roll.player.htmlTitle() + " was just wandering around on " + land + " when they suddenly tripped over a huge treasure chest! When opened, it revealed a modest cache of boonbucks. They will finally be able to afford that fraymotif, "+f.name + ", they have had their eye on! ";
		//roll.player.increasePower();
		this.session.stats.goodLuckEvent = true;
		return ret;
	}
	String roll40(Roll roll){
		if(roll.player.land == null){
			return ""; //you've had enough bad luck. just...go rest or something.
		}
		////session.logger.info("roll40 in " + this.session.session_id);
		String ret = "The " + roll.player.htmlTitle() + " was just wandering around on " + roll.player.shortLand()+ " when they suddenly tripped over a huge bee hive. The angry bees immediately ravage the country side, pestering local consorts.";
		roll.player.increaseLandLevel(-1.0);
		this.session.stats.badLuckEvent = true;
		return ret;
	}
	String roll35(Roll roll){
		//session.logger.info("unlucky trigger event: " + this.session.session_id.toString());
		List<String> items = ["sopor slime", "candy", "apple juice", "alcohol", "cat nip","chocolate", "orange soda", "blanket","hat","lucky coin", "magic 8 ball"];
		String ret = "The " + roll.player.htmlTitle() + " has lost their " + rand.pickFrom(items) + ". Sure, it seems stupid to you or me but... it was one of the few things left holding their sanity together. They are enraged.";
		roll.player.addStat(Stats.SANITY, -1000);
		this.session.stats.badLuckEvent = true;
		return ret;
	}
	String roll70(Roll roll){
		////session.logger.info("roll70 in " + this.session.session_id);
		Player friend = rand.pickFrom(roll.player.getFriendsFromList(findLivingPlayers(this.session.players)));
		if(friend == null){
			return this.roll65(roll); //backup result.
		}
		String ret = "The " + roll.player.htmlTitle() + " was fucking around on the internet and accidentally sent the " + friend.htmlTitle() + " a message meant for someone else. Luckily, they seem flattered instead of offended. ";
		friend.getRelationshipWith(roll.player).increase();
		friend.getRelationshipWith(roll.player).increase();
		friend.getRelationshipWith(roll.player).increase();
		this.session.stats.goodLuckEvent = true;
		return ret;
	}
	String roll30(Roll roll){
		////session.logger.info("roll30 in " + this.session.session_id);
		Player friend = rand.pickFrom(roll.player.getFriendsFromList(findLivingPlayers(this.session.players)));
		if(friend == null){
			return this.roll65(roll); //backup result.
		}
		String ret = "The " + roll.player.htmlTitle() + " was fucking around on the internet and accidentally sent the " + friend.htmlTitle() + " a message meant for someone else. They will never live this down. The " + friend.htmlTitleBasic() + " seems pretty offended, too.";
		friend.getRelationshipWith(roll.player).decrease();
		friend.getRelationshipWith(roll.player).decrease();
		friend.getRelationshipWith(roll.player).decrease();
		this.session.stats.badLuckEvent = true;
		return ret;
	}
	String roll25(Roll roll){
		//session.logger.info("unluck grim dark: " + this.session.session_id.toString());
		List<String> items = ["magic cue ball", "grimoire", "original VHS tape of Mac and Me", "fluthlu doll", "dream catcher","squiddles plush", "Dr Seuss Book", "commemorative Plaque from a World Event That Never Happened","SCP-093"];
		String ret = "The " + roll.player.htmlTitle() + " has had a momentary lapse of judgement and alchemized a weapon with the " + rand.pickFrom(items) + " they just found. Any sane adventurer would cast these instruments of the occult into the FURTHEST RING and forget they ever existed. Instead, the " + roll.player.htmlTitleBasic() + " equips them. This is a phenomenally bad idea. ";
		roll.player.corruptionLevelOther += 666; //will only increase corruption by one level, but in style
		roll.player.addStat(Stats.POWER, 50);  //it IS a weapon, points out aspiringWatcher
		this.session.stats.badLuckEvent = true;
		return ret;
	}
	String roll80(Roll roll){
		////session.logger.info("roll80 in " + this.session.session_id);
		if(roll.player.land == null || (roll.player.aspect != Aspects.SPACE && roll.player.landLevel >= this.landLevelNeeded)){  //not lucky to get land level when you don't need it.
			return this.roll85(roll);
		}
		String ret = "The " + roll.player.htmlTitle() + " tripped right through a glitched section of wall, only to find a single imp. 'Shh.' the imp says, handing over a frankly obscene bucket of grist, 'It's a secret to everybody.' The " + roll.player.htmlTitle() + " agrees that it would be ideal if it was a secret even to themselves, and prays for amnesia.  Like hell are they gonna leave behind the grist, though. Land quests don't solve themselves. " ;
		roll.player.increaseLandLevel(2.0);
		this.session.stats.goodLuckEvent = true;
		return ret;
	}
	String roll85(Roll roll){
		////session.logger.info("roll85 in " + this.session.session_id);
		String land = "some random planet";
		if(roll.player.land != null){
			land = roll.player.shortLand();
		}
		String ret = "The " + roll.player.htmlTitle() + " was just wandering around on " + land + " when they see a GOLD IMP. Those things are worth a ton of experience points, if you can manage to even damage them. Holy shit, did the " + roll.player.htmlTitle() + " just ONE SHOT them!? ";
		roll.player.increasePower();
		roll.player.increasePower();
		roll.player.leveledTheHellUp = true;
		roll.player.level_index +=2;
		this.session.stats.goodLuckEvent = true;
		return ret;
	}
	String roll20(Roll roll){
		////session.logger.info("roll20 in " + this.session.session_id);
		if(roll.player.land == null){
			return ""; //you've had enough bad luck. just...go rest or something.
		}
		String ret = "The " + roll.player.htmlTitle() + " tripped right through a glitched section of wall, only to find a single consort. 'Shh.' the imp says, handing over a frankly obscene bucket of...something, 'It's a secret to everybody.' The " + roll.player.htmlTitleBasic() + " agrees that it would be ideal if it was a secret even to themselves, and prays for amnesia.  They can't quite bring themselves to go near their consorts for a little while aftewards. " ;
		roll.player.increaseLandLevel(-2.0);
		this.session.stats.badLuckEvent = true;
		return ret;
	}
	String roll90(Roll roll){
		////session.logger.info("roll90 in " + this.session.session_id);
		String ret = "Holy shit, the " + roll.player.htmlTitle() + " just found a METAL PUMPKIN. Those things are worth a LOT of experience points! And they totally managed to explode it before it never existed in the first place! Score! Talk about luuuuuuuucky!" ;
		roll.player.increasePower();
		roll.player.increasePower();
		roll.player.increasePower();
		roll.player.leveledTheHellUp = true;
		roll.player.level_index +=3;
		this.session.stats.goodLuckEvent = true;
		return ret;
	}
	String roll95(Roll roll){
		////session.logger.info("roll95 in " + this.session.session_id);
		if(roll.player.land == null || (roll.player.aspect != Aspects.SPACE && roll.player.landLevel >= this.landLevelNeeded)){  //not lucky to get land level when you don't need it.
			return this.roll90(roll);
		}
		String ret = "Through a frankly preposterous level of Scooby-Doo shenanigans, the  " + roll.player.htmlTitle() + " trips into a wall, which depresses a panel, which launches a catapult, which throws impudent fruit at a nearby Ogre, which wakes him up, which makes him wander away, which frees the local consorts from his tyranny, who then celebrate an end to their famine by eating the fruit.  All of which causes, like, a third of the main quest of "  + roll.player.shortLand() + " to be completed. ";
		if(roll.player.aspect == Aspects.SPACE){
			ret += "Wait. What the HELL!? Is that last Frog!? Just sitting there? Right in front of the " + roll.player.htmlTitle() + "!? No time shenanigans or prophecies or god damned Choices!? It's just...there. Well. Damn. That'll make the frog breeding WAY easier.";
		}
		roll.player.increaseLandLevel(3.0);
		this.session.stats.goodLuckEvent = true;

		return ret;
	}
	String roll10(Roll roll){
		////session.logger.info("roll10 in " + this.session.session_id);
		if(roll.player.land == null){
			return "The " + roll.player.htmlTitle() + " gets a bad feeling, like maybe their land back in their home session just got damaged. But...it's not like they can ever go back, right? Who cares."; //you've had enough bad luck. just...go rest or something.
		}
		String ret = "Through a frankly preposterous level of Scooby-Doo shenanigans, the  " + roll.player.htmlTitle() + " trips into a wall, which depresses a panel, which launches a flaming rock via catapult, which crashes into a local consort village. Which immediately catches on fire, which makes them be refugees, which makes them immigrate to a new area, which disrupts the stability of the entire goddamned planet.  All of which causes, like, a third of the main quest of "  + roll.player.shortLand() + " to be fucked up. ";
		roll.player.increaseLandLevel(-4.0);
		this.session.stats.badLuckEvent = true;
		return ret;
	}
	String roll100(Roll roll, Element div){
		////session.logger.info("roll100 in " + this.session.session_id + " roll is: " + roll.value);

		this.session.stats.goodLuckEvent = true; // moved to top because at the bottom it's dead code -PL

		if(roll.player.godDestiny && !roll.player.godTier && (roll.player.dreamSelf || roll.player.isDreamSelf)){
			String ret = " What the HELL!? The " + roll.player.htmlTitle() + " managed to somehow lose to REGULAR FUCKING ENEMIES!? Is that even POSSIBLE!? This is BULLSHIT. Wait. What's going on? How did they end up on their " ;
			if(!roll.player.isDreamSelf){
				ret += "QUEST BED!? Their body glows, and rises Skaiaward. "+"On ${roll.player.moon}, their dream self takes over and gets a sweet new outfit to boot.  ";
				this.session.stats.questBed = true;
				ret += roll.player.makeDead("luckily on their Quest Bed");
			}else{
				ret += "SACRIFICIAL SLAB!? They glow and ascend to the God Tiers with a sweet new outfit.";
				this.session.stats.sacrificialSlab = true;
				//roll.player.makeDead("luckily on their Sacrificial Slab") doesn't make a ghost 'cause the corpse itself revives'
			}
			Fraymotif f = this.session.fraymotifCreator.makeFraymotif(rand, [roll.player], 3);//first god tier fraymotif
			roll.player.fraymotifs.add(f);
			ret += " They learn " + f.name + ". " ;
			roll.player.makeGodTier();

			this.session.stats.luckyGodTier = true;
			this.session.stats.godTier = true;
			String divID = (div.id) + "_luckGodBS${roll.player.id}";
			String canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth.toString() + "' height="+canvasHeight.toString() + "'>  </canvas>";
			appendHtml(div, ret);
			appendHtml(div, canvasHTML);
			CanvasElement canvas = querySelector("#canvas"+ divID);
			Drawing.drawGetTiger(canvas, [roll.player]); //only draw revivial if it actually happened.
			return "";
		}else{
			if(!roll.player.godDestiny && roll.player.dreamSelf && !roll.player.godTier ){
				////session.logger.info("destined for greatness from reroll of luck in " + this.session.session_id + " roll is: " + roll.value);
				roll.player.godDestiny = true;
				return "Huh, the " + roll.player.htmlTitle() + " suddenly feels as if they are destined for greatness. ";
			}else{
				return this.roll90(roll);
			}
		}

	}
	String roll0(Roll roll, Element div){
		////session.logger.info("roll0 in " + this.session.session_id + " roll is: " + roll.value + " player min luck was: " + roll.player.minLuck + " and max luck was: " + roll.player.maxLuck);
		if(roll.player.godDestiny && !roll.player.godTier && roll.player.dreamSelf){
			roll.player.godDestiny = false;
			String ret = "Huh, the " + roll.player.htmlTitle() + " suddenly feels a creeping sense of doom, as if they are no longer destined for greatness. ";
			////session.logger.info("no longer destined for greatness from reroll of luck in " + this.session.session_id + " roll is: " + roll.value);
			return ret;
		}
		String ret = "What the HELL!? The " + roll.player.htmlTitle() + " managed to somehow lose to REGULAR FUCKING ENEMIES!? Is that even POSSIBLE!? This is BULLSHIT. How unlucky do you even need to BE!? They are DEAD.";
		ret += roll.player.makeDead("from a Bad Break.");
		appendHtml(div, ret);

		String divID = (div.id) + "_badLuckDeath${roll.player.id}";
		String canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth.toString() + "' height="+canvasHeight.toString() + "'>  </canvas>";
		appendHtml(div, canvasHTML);
		CanvasElement canvas = querySelector("#canvas"+ divID);

		CanvasElement pSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
		Drawing.drawSprite(pSpriteBuffer,roll.player);

		Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,0,0);
		this.session.stats.badLuckEvent = true;
		this.session.stats.badBreakDeath = true;
		return "";

	}
	String processRoll(Roll roll, Element div){
		num amount = 5;
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
			throw("NO this is NOT RIGHT, LUCK EVENT BROKEN");
			//return "What the hell, mate? roll was: " + roll.value + " and needed to be not between  " + this.minLowValue + " and " + this.minHighValue;
		} 



	}


}



class Roll {
	Roll(this.player, this.value) {}

	Player player;
	num value;
}
