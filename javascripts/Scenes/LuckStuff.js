function LuckStuff(session){
	this.session = session;
	this.canRepeat = true;	
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.rolls = [];
	//luck can be good or it can be bad.
	this.minLowValue = 40;
	this.minHighValue = 60;

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
		var ret = "The " + roll.player.htmlTitleBasic() + " was just wandering around on " + roll.player.shortLand()+ " when they suddenly tripped over a huge treasure chest! When opened, it revealed a modest hoarde of grist. It will be easier to complete their land quests now.";
		roll.player.landLevel ++;
		return ret;
	}
	
	this.roll65 = function(roll){
		var ret = "The " + roll.player.htmlTitleBasic() + " was just wandering around on " + roll.player.shortLand() + " when they suddenly tripped over a huge treasure chest! When opened, it revealed a modest cache of boonbucks. They will finally be able to afford that framotiff they have had their eye on!";
		roll.player.increasePower();
		return ret;
	}
	
	this.roll70 = function(roll){
		var friend = randomElementFromArray(roll.player.getFriendsFromList());
		if(!friend){
			return this.roll65(roll); //backup result.
		}
		var ret = "The " + roll.player.htmlTitleBasic() + " was fucking around on the internet and accidentally sent the " + friend.htmlTitleBasic() + " a message meant for someone else. Luckily, they seem flattered instead of offended. ";
		player.getRelationshipWith(friend).increase();
		return ret;
	}
	
	this.roll80 = function(roll){
		var ret = "The " + roll.player.htmlTitleBasic() + " tripped right through a glitched section of wall, only to find a single imp. 'Shh.' the imp says, handing over a frankly obscene bucket of grist, 'It's a secret to everybody.' The " + roll.player.htmlTitleBasic() + " agrees that it would be ideal if it was a secret even to themselves, and prays for amnesia.  Like hell are they gonna leave behind the grist, though. Land quests don't solve themselves. " ;
		roll.player.landLevel ++;
		roll.player.landLevel ++;
		return ret;
	}
	
	this.roll85 = function(roll){
		var ret = "The " + roll.player.htmlTitleBasic() + " was just wandering around on " + roll.player.shortLand() + " when they suddenly tripped over a huge treasure chest! When opened, it revealed a HUGE cache of boonbucks. They will finally be able to afford that epic framotiff they have had their eye on!";
		roll.player.increasePower();
		roll.player.increasePower();
		return ret;
	}
	
	this.roll90 = function(roll){
		var ret = "Holy shit, the " + roll.player.htmlTitleBasic() + " just found a METAL IMP. Those things are worth a LOT of experience points! And they totally one-shot killed it! Score! Talk about luuuuuuuucky!" ;
		roll.player.increasePower();
		roll.player.increasePower();
		roll.player.increasePower();
		return ret;
	}
	
	this.roll95 = function(roll){
		var ret = "Through a frankly preposterous level of Scooby-Doo shenanigans, the  " + roll.player.htmlTitleBasic() + " trips into a wall, which depresses a panel, which launches a catapult, which throws impudent fruit at a nearby Ogre, which wakes him up, which makes him wander away, which frees the local consorts from his tyranny, who then celebrate an end to their famine by eating the fruit.  All of which causes, like, a third of the main quest of "  + roll.player.shortLand() + " to be completed. ";
		if(roll.player.aspect == "Space"){
			ret += "Wait. What the HELL!? Is that last Frog!? Just sitting there? Right in front of the " + roll.player.htmlTitleBasic() + "No time shenanigans or prophecies or god damned Choices!? It's just...there. Well. Damn. That'll make the frog breeding WAY easier.";
		}
		roll.player.landLevel ++;
		roll.player.landLevel ++;
		roll.player.landLevel ++;
		return ret;
	}
	
	
	
	this.processRoll(roll){
		if(roll.value >= 60 && roll.value < 65){
			return this.roll60(roll);
		}else if(roll.value >= 65 && roll.value < 70){
			return this.roll60(roll);
		}else if(roll.value >= 70 && roll.value < 80){
			return this.roll60(roll);
		}else if(roll.value >= 80 && roll.value < 85){
			return this.roll60(roll);
		}else if(roll.value >= 85 && roll.value < 90){
			return this.roll60(roll);
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