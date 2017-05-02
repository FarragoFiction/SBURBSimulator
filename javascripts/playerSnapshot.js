//keeps track of information the sprite needs to render itself
//allows player to go ahead and change while their snapshot remains the same
//even with asynchronous rendering.
//renderer calls this, not any individual scenes.
//consider not using this anymore for doomed time clones, instead use gameentity?
function PlayerSnapshot(){
	this.session = null;
	this.trickster = null;
	this.sbahj = null;
	this.baby = null;
	this.robot = null;
	this.hp = 0;
	this.currentHP = 0;
	this.minLuck = 0;
	this.maxLuck = 0;
	this.freeWill = 0;
	this.mobility = 0;
	this.causeOfDrain = null; //ghosts can't double die without LE, but can be drained by certain things. drained ghosts aren't going to help you again during your session.
	this.id = null;
	this.baby_stuck = null;
	this.ectoBiologicalSource = null;
	this.class_name = null;
	this.doomed = null;
	this.guardian = null;
	this.number_confessions = null;
	this.number_times_confessed_to = null;
	this.influenceSymbol = null;
	this.aspect = null;
	this.ghost = false; //only afer life sets this.
	this.land = null;
	this.interest1 = null
	this.interest2 = null
	this.chatHandle = null;
	this.kernel_sprite = null;
	this.relationships = null
	this.moon = null;
	this.power =null
	this.leveledTheHellUp = null;
	this.mylevels = null
	this.level_index = null
	this.godTier = null;
	this.victimBlood = null;
	this.hairColor = null
	this.dreamSelf = null;
	this.isTroll = null
	this.bloodColor = null
	this.leftHorn =  null;
	this.rightHorn = null;
	this.lusus = null
	this.quirk = null;
	this.dead = null;
	this.godDestiny = null;
	this.canGodTierRevive = null;
	this.isDreamSelf = null;
	this.triggerLevel = null;
	this.murderMode = null;
	this.leftMurderMode = null;
	this.grimDark = null;
	this.leader = null;
	this.landLevel = null;
	this.denizenFaced = null;
	this.denizenDefeated = null;
	this.causeOfDeath = null;
	this.doomedTimeClones = null;

	this.chatHandleShort = function(){
		return this.chatHandle.match(/\b(\w)|[A-Z]/g).join('').toUpperCase();
	}

	this.titleBasic = function(){
		var ret = "";

		ret+= this.class_name + " of " + this.aspect;
		return ret;
	}

	this.htmlTitleHP = function(){
		return getFontColorFromAspect(this.aspect) + this.title() + " (" + Math.round(this.currentHP) + " hp, " + this.power + " power)</font>"
	}

	this.htmlTitleBasic = function(){
			return getFontColorFromAspect(this.aspect) + this.titleBasic() + "</font>"
	}

	this.getChatFontColor = function(){
		if(this.isTroll){
			return this.bloodColor;
		}else{
			return getColorFromAspect(this.aspect);
		}
	}

	//doomed time clones aren't ghosts yet.
	this.makeDead = function(causeOfDeath){
		this.dead = true;
		this.causeOfDeath = causeOfDeath;
		this.session.afterLife.addGhost(makeRenderingSnapshot(this));
	}

	this.chatHandleShortCheckDup = function(otherHandle){
		var tmp= this.chatHandle.match(/\b(\w)|[A-Z]/g).join('').toUpperCase();
		if(tmp == otherHandle){
			tmp = tmp + "2";
		}
		return tmp;
	}

	this.htmlTitle = function(){
		return getFontColorFromAspect(this.aspect) + this.title() + "</font>"
	}

		this.title = function(){
		var ret = "";
		if(this.doomed){
			ret += "Doomed "
		}


		if(this.murderMode){
			ret += "Murder Mode ";
		}

		if(this.grimDark){
			ret += "Grim Dark ";
		}

		if(this.godTier){
			ret+= "God Tier "
		}else if(this.isDreamSelf){
			ret+= "Dream ";
		}
		ret+= this.class_name + " of " + this.aspect;
		if(this.dead){
			ret += "'s Corpse"
		}
		return ret;
	}

	this.rollForLuck = function(){
		return getRandomInt(this.minLuck, this.maxLuck);
	}

	this.interactionEffect = function(player){
			//none
	}


	//bulshit stubs that game entities will have be different if crowned. players can't be crowned tho (or can they??? no. they can't.)
	this.getMobility = function(){
		return this.mobility;
	}

	this.getMaxLuck = function(){
		return this.maxLuck;
	}

	this.getMinLuck = function(){
		return this.minLuck;
	}
	this.getFreeWill = function(){
		return this.freeWill;
	}

	this.getHP= function(){
		return this.currentHP;
	}
	this.getPower = function(){
		return this.power;
	}

	this.triggerLevel = function(){
		return this.triggerLevel;
	}

	this.increasePower = function(){
		//stub for boss fights for doomed time clones. they can't level up. they are doomed.
	}




}


//so players can be restored after being mind/whatever controled.
function MiniSnapShot(player){
	this.relationships = player.relationships;
	this.murderMode = player.murderMode;
	this.grimDark = player.grimDark;
	this.isTroll = player.isTroll;
	this.class_name = player.class_name;
	this.aspect = player.aspect;

	this.restoreState = function(player){
		player.relationships = this.relationships;
		player.murderMode = this.murderMode;
		player.grimDark = this.grimDark;
		player.isTroll = this.isTroll;
		player.class_name = this.class_name
		player.aspect = this.aspect;
		player.stateBackup = null; //no longer need to keep track of old state.
	}
}
