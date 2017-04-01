//keeps track of information the sprite needs to render itself
//allows player to go ahead and change while their snapshot remains the same
//even with asynchronous rendering.
//renderer calls this, not any individual scenes.
function PlayerSnapshot(){
	this.baby = null;
	this.ectoBiologicalSource = null;
	this.class_name = null;null
	this.guardian = null;
	this.number_confessions = null;
	this.number_times_confessed_to = null;
	this.wasteInfluenced = null;
	this.aspect = null;
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

}
