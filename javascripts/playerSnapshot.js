//keeps track of information the sprite needs to render itself
//allows player to go ahead and change while their snapshot remains the same
//even with asynchronous rendering.
//renderer calls this, not any individual scenes.
function PlayerSnapshot(){
	this.dead = null;
	this.isTroll = null
	this.godTier = null;
	this.class_name = null;
	this.aspect = null;
	this.isDreamSelf = null;
	this.hair = null;
	this.bloodColor = null;
	this.grimDark = null;
	this.murderMode = null;
	this.hairColor = null;
	this.moon = null;
	this.chatHandle = null;
	this.leftHorn = null;
	this.rightHorn = null;
	this.quirk = null;

	this.chatHandleShort = function(){
		return this.chatHandle.match(/\b(\w)|[A-Z]/g).join('').toUpperCase();
	}

	this.chatHandleShortCheckDup = function(otherHandle){
		var tmp= this.chatHandle.match(/\b(\w)|[A-Z]/g).join('').toUpperCase();
		if(tmp == otherHandle){
			tmp = tmp + "2";
		}
		return tmp;
	}

}
