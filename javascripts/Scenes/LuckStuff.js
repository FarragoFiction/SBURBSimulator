function LuckStuff(session){
	this.session = session;
	this.canRepeat = true;	
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.rolls = [];
	//luck can be good or it can be bad.
	this.minLowValue = 40;
	this.minHighValue = 60;
	this.landLevelNeeded = 12;

	this.trigger = function(playerList){
		this.rolls = [];//reset
		for(var i = 0; i<this.playerList; i++){
			var player = this.playerList[i];
			var rollValue = rollForLuck();
			if(rollValue >= this.minHighValue || rollValue <= this.minLowValue){
				this.rolls.push(new Roll(player, value));
			}
		}
		return this.rolls.length > 0
	}
	
	this.renderContent = function(div){
		div.append("<br>"+this.content());
	}
	
	this.roll60 = function(roll){
		console.log("roll60 in " + this.session.session_id)
		if(roll.player.aspect != "Space" && roll.player.landLevel >= this.landLevelNeeded){  //not lucky to get land level when you don't need it.
			return this.roll65(roll);
		}
		var ret = "The " + roll.player.htmlTitleBasic() + " was just wandering around on " + roll.player.shortLand()+ " when they suddenly tripped over a huge treasure chest! When opened, it revealed a modest hoarde of grist. It will be easier to complete their land quests now.";
		roll.player.landLevel ++;
		return ret;
	}
	
	this.roll65 = function(roll){
		console.log("roll65 in " + this.session.session_id)
		var ret = "The " + roll.player.htmlTitleBasic() + " was just wandering around on " + roll.player.shortLand() + " when they suddenly tripped over a huge treasure chest! When opened, it revealed a modest cache of boonbucks. They will finally be able to afford that framotiff they have had their eye on!";
		roll.player.increasePower();
		return ret;
	}
	//decreasing power is not a thing. so only land level?
	this.roll40 = function(roll){
		console.log("roll40 in " + this.session.session_id)
		var ret = "The " + roll.player.htmlTitleBasic() + " was just wandering around on " + roll.player.shortLand()+ " when they suddenly tripped over a huge bee hive. The angry bees immediately ravage the country side, pestering local consorts.";
		roll.player.landLevel += -1
		return ret;
	}
	

	this.roll70 = function(roll){
		console.log("roll70 in " + this.session.session_id)
		var friend = randomElementFromArray(roll.player.getFriendsFromList());
		if(!friend){
			return this.roll65(roll); //backup result.
		}
		var ret = "The " + roll.player.htmlTitleBasic() + " was fucking around on the internet and accidentally sent the " + friend.htmlTitleBasic() + " a message meant for someone else. Luckily, they seem flattered instead of offended. ";
		player.getRelationshipWith(friend).increase();
		return ret;
	}
	
	this.roll30(){
		console.log("roll30 in " + this.session.session_id)
		var friend = randomElementFromArray(roll.player.getFriendsFromList());
		if(!friend){
			return this.roll65(roll); //backup result.
		}
		var ret = "The " + roll.player.htmlTitleBasic() + " was fucking around on the internet and accidentally sent the " + friend.htmlTitleBasic() + " a message meant for someone else. They will never live this down. The " + friend.htmlTitleBasic() + " seems pretty offended, too.";
		player.getRelationshipWith(friend).decrease();
		return ret;
	}
	
	this.roll80 = function(roll){
		console.log("roll80 in " + this.session.session_id)
		if(roll.player.aspect != "Space" && roll.player.landLevel >= this.landLevelNeeded){  //not lucky to get land level when you don't need it.
			return this.roll85(roll);
		}
		var ret = "The " + roll.player.htmlTitleBasic() + " tripped right through a glitched section of wall, only to find a single imp. 'Shh.' the imp says, handing over a frankly obscene bucket of grist, 'It's a secret to everybody.' The " + roll.player.htmlTitleBasic() + " agrees that it would be ideal if it was a secret even to themselves, and prays for amnesia.  Like hell are they gonna leave behind the grist, though. Land quests don't solve themselves. " ;
		roll.player.landLevel ++;
		roll.player.landLevel ++;
		return ret;
	}
	
	this.roll85 = function(roll){
		console.log("roll85 in " + this.session.session_id)
		var ret = "The " + roll.player.htmlTitleBasic() + " was just wandering around on " + roll.player.shortLand() + " they see a GOLD IMP. Those things are worth a ton of experience points, if you can manage to even damage them. Holy shit, did the " + roll.player.htmlTtielBasic() + " just ONE SHOT them!? ";
		roll.player.increasePower();
		roll.player.increasePower();
		this.leader.leveledTheHellUp = true;
		this.leader.level_index +=2;
		return ret;
	}
	
	this.roll20 = function(roll){
		console.log("roll20 in " + this.session.session_id)

		var ret = "The " + roll.player.htmlTitleBasic() + " tripped right through a glitched section of wall, only to find a single consort. 'Shh.' the imp says, handing over a frankly obscene bucket of...something, 'It's a secret to everybody.' The " + roll.player.htmlTitleBasic() + " agrees that it would be ideal if it was a secret even to themselves, and prays for amnesia.  They can't quite bring themselves to go near their consorts for a little while aftewards. " ;
		roll.player.landLevel += -2
		return ret;
	}
	
	this.roll90 = function(roll){
		console.log("roll90 in " + this.session.session_id)
		var ret = "Holy shit, the " + roll.player.htmlTitleBasic() + " just found a METAL PUMPKIN. Those things are worth a LOT of experience points! And they totally managed to explode it before it never existed in the first place! Score! Talk about luuuuuuuucky!" ;
		roll.player.increasePower();
		roll.player.increasePower();
		roll.player.increasePower();
		this.leader.leveledTheHellUp = true;
		this.leader.level_index +=3;
		return ret;
	}
	
	this.roll95 = function(roll){
		console.log("roll95 in " + this.session.session_id)
		if(roll.player.aspect != "Space" && roll.player.landLevel >= this.landLevelNeeded){  //not lucky to get land level when you don't need it.
			return this.roll90(roll);
		}
		var ret = "Through a frankly preposterous level of Scooby-Doo shenanigans, the  " + roll.player.htmlTitleBasic() + " trips into a wall, which depresses a panel, which launches a catapult, which throws impudent fruit at a nearby Ogre, which wakes him up, which makes him wander away, which frees the local consorts from his tyranny, who then celebrate an end to their famine by eating the fruit.  All of which causes, like, a third of the main quest of "  + roll.player.shortLand() + " to be completed. ";
		if(roll.player.aspect == "Space"){
			ret += "Wait. What the HELL!? Is that last Frog!? Just sitting there? Right in front of the " + roll.player.htmlTitleBasic() + "No time shenanigans or prophecies or god damned Choices!? It's just...there. Well. Damn. That'll make the frog breeding WAY easier.";
		}
		roll.player.landLevel ++;
		roll.player.landLevel ++;
		roll.player.landLevel ++;
		
		return ret;
	}
	
	this.roll10 = function(roll){
		console.log("roll10 in " + this.session.session_id)
		var ret = "Through a frankly preposterous level of Scooby-Doo shenanigans, the  " + roll.player.htmlTitleBasic() + " trips into a wall, which depresses a panel, which launches a flaming rock via catapult, which crashes into a local consort village. Which immediately catches on fire, which makes them be refugees, which makes them immegrate to a new area, which disrupts the stability of the entire goddamned planet.  All of which causes, like, a third of the main quest of "  + roll.player.shortLand() + " to be fucked up. ";
		if(roll.player.aspect == "Space"){
			ret += "Wait. What the HELL!? Is that last Frog!? Just sitting there? Right in front of the " + roll.player.htmlTitleBasic() + "No time shenanigans or prophecies or god damned Choices!? It's just...there. Well. Damn. That'll make the frog breeding WAY easier.";
		}
		roll.player.landLevel += -4;		
		return ret;
	}
	
	this.roll100 = function(roll){
		console.log("roll100 in " + this.session.session_id);
		if(roll.player.godDestiny && !roll.player.godTier){
			var ret = "What the HELL!? The " + roll.player.htmlTitleBasic() + " managed to somehow lose to REGULAR FUCKING ENEMIES!? Is that even POSSIBLE!? This is BULLSHIT. Wait. What's going on? How did they end up on their " ;
			if(roll.player.dreamSelf){
				ret += "QUEST BED!? Their body glows, and rises Skaiaward. "+"On " + p.moon + ", their dream self takes over and gets a sweet new outfit to boot.  ";
			}else{
				ret += "SACRIFICIAL SLAB!? They glow and ascend to the God Tiers with a sweet new outfit."
			}		
			
			return ret;
		}else{
			return this.roll90(roll);
		}
		
	}
	
	this.roll0 = function(roll){
		console.log("roll0 in " + this.session.session_id);
		var ret = "What the HELL!? The " + roll.player.htmlTitleBasic() + " managed to somehow lose to REGULAR FUCKING ENEMIES!? Is that even POSSIBLE!? This is BULLSHIT. How unlucky do you even need to BE!?"
		return ret;
		player.dead = true;
	}
	
	
	
	this.processRoll(roll){
		if(roll.value >= 60 && roll.value < 65){
			return this.roll60(roll);
		}else if(roll.value >= 65 && roll.value < 70){
			return this.roll65(roll);
		}else if(roll.value >= 70 && roll.value < 80){
			return this.roll70(roll);
		}else if(roll.value >= 80 && roll.value < 85){
			return this.roll80(roll);
		}else if(roll.value >= 85 && roll.value < 90){
			return this.roll85(roll);
		}else if(roll.value > 30 && roll.value <= 40){
			return this.roll40(roll);
		}else if(roll.value > 20 && roll.value <= 30){
			return this.roll30(roll);
		}else if(roll.value > 10 && roll.value <= 20){
			return this.roll20(roll);
		}else if(roll.value > 0 && roll.value <= 10){
			return this.roll10(roll);
		}else if(roll.value > 10 && roll.value <= 0){
			return this.roll0(roll);
		}



	}
	
	this.content = function(){
		var ret = "";
		removeFromArray(this.player, this.session.availablePlayers);
		for(var i = 0; i<this.rolls.length; i++){
			var roll = this.rolls[i];
			removeFromArray(roll.player, this.session.availablePlayers);
			ret += this.processRoll(roll);
		}
		
		return ret;
	}
}

function Rolls(player, rollValue){
	this.player = player;
	this.value = value;
}