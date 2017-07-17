//keeps track of information the sprite needs to render itself
//allows player to go ahead and change while their snapshot remains the same
//even with asynchronous rendering.
//renderer calls this, not any individual scenes.
//consider not using this anymore for doomed time clones, instead use gameentity?
function PlayerSnapshot(){
	this.session = null;
	this.trickster = null;
	this.spriteCanvasID = null;
	this.sbahj = null;
	this.hair = null;
	this.usedFraymotifThisTurn = false;
	this.buffs = []; //only used in strifes, array of BuffStats (from fraymotifs and eventually weapons)
	this.baby = null;
	this.robot = null;
	this.fraymotifs = [];
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
	this.relationships = []
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
	this.sanity = 0; //eventually replace triggerLevel with this (it's polarity is opposite triggerLevel)
	this.alchemy = 0; //mostly unused until we get to the Alchemy update.
	this.godDestiny = null;
	this.canGodTierRevive = null;
	this.isDreamSelf = null;
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

	this.allStats = function(){
		return ["power","hp","RELATIONSHIPS","mobility","sanity","freeWill","maxLuck","minLuck","alchemy"];
	}

	//for now, only type is 1, which is class + aspect.
    this.toDataBytesX = function(){
        var builder = new ByteBuilder();
        var j = this.toJSON();
        if(j.class_name <= 15 && j.aspect <= 15){ //if NEITHER have need of extension, just return size zero
            builder.appendExpGolomb(0) //for length
            return encodeURIComponent(builder.toBuffer()).replace(/#/g, '%23').replace(/&/g, '%26');
        }
        builder.appendExpGolomb(2) //for length
        builder.appendByte(j.class_name);
        builder.appendByte(j.aspect);
        return encodeURIComponent(byteArrayToString(builder.toBuffer())).replace(/#/g, '%23').replace(/&/g, '%26');
    }

    //values for extension string should overwrite existing values.
    //takes in a reader because it acts as a stream, not a byte array
    //read will read "next thing", all player has to do is know how to handle self.
    this.readInExtensionsString = function(reader){
        console.log("reading in extension string")
        //just inverse of encoding process.
        var numFeatures = reader.readExpGolomb(); //assume features are in set order. and that if a given feature is variable it is ALWAYS variable.
        if(numFeatures > 0)  this.class_name = intToClassName(reader.readByte());
        if(numFeatures > 1) this.aspect = intToAspect(reader.readByte());
        //as i add more things, add more lines. ALWAYS in same order, but not all features all the time.
    }

	this.toDataStrings = function(includeChatHandle){
		var ch = "";
		if(includeChatHandle) ch = sanitizeString(this.chatHandle);
		var ret = ""+sanitizeString(this.causeOfDrain) + ","+sanitizeString(this.causeOfDeath) + "," + sanitizeString(this.interest1) + "," + sanitizeString(this.interest2) + "," + sanitizeString(ch)
		return ret;
	}

	this.makeAlive  = function(){
		if(this.dead == false) return; //don't do all this.
		this.dead = false;
		this.currentHP = this.hp;
	}

	this.modifyAssociatedStat = function(modValue, stat){
		//modValue * stat.multiplier.
		if(stat.name == "RELATIONSHIPS"){
			for(var i = 0; i<this.relationships.length; i++){
				this.relationships[i].value += modValue * stat.multiplier;
			}
		}else{
			this[stat.name] += modValue * stat.multiplier;
		}
	}


	/*
		3 bytes: (12 bits) hairColor
		1 byte: class/asspect
		1 byte victimBlood, bloodColor
		1 byte interest1Category, interest2Category
		1 byte griDark,isTroll, isDreamSelf, isGodTier, murderMode, leftMurderMode
		1 byte extra binaries, like robotMode,moon, dead, godTierDestiny, (4 bits) favoriteNumber
		1 byte  leftHorn
		1byte  rightHorn
		1byte hair

		I am the l337est asshole in the world
	*/
	this.toDataBytes = function(){
		var json = this.toJSON(); //<-- gets me data in pre-compressed format.
		var buffer = new ArrayBuffer(11);
		var ret = ""; //gonna return as a string of chars.
		var uint8View = new Uint8Array(buffer);
		uint8View[0] = json.hairColor >> 16 //hair color is 12 bits. chop off 4 on right side, they will be in buffer[1]
		uint8View[1] = json.hairColor >> 8
		uint8View[2] = json.hairColor >> 0
		uint8View[3] = (json.class_name << 4) + json.aspect  //when I do fanon classes + aspect, use this same scheme, but have binary for "is fanon", so I know 1 isn't page, but waste (or whatever)
		uint8View[4] = (json.victimBlood << 4) + json.bloodColor
		uint8View[5] = (json.interest1Category <<4) + json.interest2Category
		uint8View[6] = (json.grimDark << 5) + (json.isTroll << 4) + (json.isDreamSelf << 3) + (json.godTier << 2) + (json.murderMode <<1) + (json.leftMurderMode) //shit load of single bit variables.
		uint8View[7] = (json.robot << 7) + (json.moon << 6) + (json.dead << 5) + (json.godDestiny <<4) + (json.favoriteNumber)
		uint8View[8] = json.leftHorn
		uint8View[9] = json.rightHorn
		uint8View[10] = json.hair
		//console.log(uint8View);
		for(var i = 0; i<uint8View.length; i++){
			ret += String.fromCharCode(uint8View[i]);
		}
		return encodeURIComponent(ret).replace(/#/g, '%23').replace(/&/g, '%26');
	}


	//initial step before binary compression
	this.toJSON = function(){
		var json = {aspect: aspectToInt(this.aspect), class_name: classNameToInt(this.class_name), favoriteNumber: this.quirk.favoriteNumber, hair: this.hair,  hairColor: hexColorToInt(this.hairColor), isTroll: this.isTroll ? 1 : 0, bloodColor: bloodColorToInt(this.bloodColor), leftHorn: this.leftHorn, rightHorn: this.rightHorn, interest1Category: interestCategoryToInt(this.interest1Category), interest2Category: interestCategoryToInt(this.interest2Category), interest1: this.interest1, interest2: this.interest2, robot: this.robot ? 1 : 0, moon:this.moon ? 1 : 0,causeOfDrain: this.causeOfDrain,victimBlood: bloodColorToInt(this.victimBlood), godTier: this.godTier ? 1 : 0, isDreamSelf:this.isDreamSelf ? 1 : 0, murderMode:this.murderMode ? 1 : 0, leftMurderMode:this.leftMurderMode ? 1 : 0,grimDark:this.grimDark, causeOfDeath: this.causeOfDeath, dead: this.dead ? 1 : 0, godDestiny: this.godDestiny ? 1 : 0 };
		return json;
	}

	this.toString = function(){
		return (this.class_name+this.aspect).replace(/'/g, '');; //no spaces, no quotes for 's corpse'.
	}

	this.titleBasic = function(){
		var ret = "";
		if(this.doomed) ret += "Doomed "
		ret+= this.class_name + " of " + this.aspect;
		return ret;
	}

	this.flipOut = function(reason){
		this.flippingOutOverDeadPlayer = null;
		this.flipOutReason = reason;
	}

	this.htmlTitleHP = function(){
		return getFontColorFromAspect(this.aspect) + this.title() + " (" + Math.round(this.getStat("currentHP")) +"hp, " + Math.round(this.getStat("power")) + " power)</font>"
	}

	this.renderable = function(){
		return true;
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
		//console.log("there shouldu be a doomed time clone ghost in the afterlife: " + this.session.session_id)
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

	this.changeGrimDark = function(){
		//stubb
	}

	this.rollForLuck = function(stat){
    		if(!stat){
    		    return getRandomInt(this.getStat("minLuck"), this.getStat("maxLuck"));
    		}else{
    		    //don't care if it's min or max, just compare it to zero.
    		    return getRandomInt(0, this.getStat(stat));
    		}

    }

	this.interactionEffect = function(player){
			//none
	}

	//stub
	this.boostAllRelationshipsWithMeBy = function(amount){

	};

	this.boostAllRelationshipsBy = function(amount){

	};

	this.resetFraymotifs = function(){
		for(var i = 0; i<this.fraymotifs.length; i++){
			this.fraymotifs[i].usable = true;
		}
	}


	//remember that hp and currentHP are different things.
	this.getStat = function(statName){
		var ret =  0;
		if(statName != "RELATIONSHIPS"){ //relationships, why you so cray cray???
			ret += this[statName]
		}else{
			for(var i = 0; i<this.relationships.length; i++){
				ret += this.relationships[i].value;s
			}
		}
		//if(this.buffs.length > 0) alert("buffs!!!")
		for(var i = 0; i<this.buffs.length; i++){
			var b = this.buffs[i];
			if(b.name == statName) ret += b.value;
		}
		return ret;
	}


	this.increasePower = function(){
		//stub for boss fights for doomed time clones. they can't level up. they are doomed.
	}

	this.getRelationshipWith = function(){
		//stub for boss fights where an asshole absconds.
	}

	this.getFriendsFromList = function(){
		return [];
	}

	this.getHearts = function(){
		return [];
	}
	this.getDiamonds = function(){
		return [];
	}

		//checks array of buffs, and adds up all buffs that effect a given stat.
    	//useful so combat can now how to describe status.
    	this.getTotalBuffForStat = function(statName){
    	    var ret = 0;
    	    for(var i = 0; i<this.buffs.length; i++){
    	        var b = this.buffs[i];
    	        if(b.name == statName) ret += b.value;
    	    }
    	    return ret;
    	}

    	this.humanWordForBuffNamed = function(statName){
            if(statName == "MANGRIT") return "powerful"
            if(statName == "hp") return "sturdy"
            if(statName == "RELATIONSHIPS") return "friendly"
            if(statName == "mobility") return "fast"
            if(statName == "sanity") return "calm"
            if(statName == "freeWill") return "willful"
            if(statName == "maxLuck") return "lucky"
            if(statName == "minLuck") return "lucky"
            if(statName == "alchemy") return "creative"
    	}

    	//used for strifes.
    	this.describeBuffs = function(){
    	    var ret = [];
    	    var allStats = this.allStats();
    	    for(var i = 0; i<allStats.length; i++){
    	        var b = this.getTotalBuffForStat(allStats[i]);
    	        //only say nothing if equal to zero
    	        if(b>0) ret.push("more "+this.humanWordForBuffNamed(allStats[i]));
    	        if(b<0) ret.push("less " + this.humanWordForBuffNamed(allStats[i]));
    	    }
    	    if(ret.length == 0) return "";
    	    return this.htmlTitleHP() + " is feeling " + turnArrayIntoHumanSentence(ret) + " than normal. ";
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


function makeRenderingSnapshot(player){
	var ret = new PlayerSnapshot();
	ret.fraymotifs = player.fraymotifs.slice(0)//omg, make a copy you dunkass, or time players get the OP fraymotifs of their doomed clones;
	ret.robot = player.robot;
	ret.spriteCanvasID = player.spriteCanvasID;
  ret.currentHP = player.currentHP;
	ret.doomed = player.doomed;
	ret.ghost = player.ghost;
	ret.causeOfDrain = player.causeOfDrain;
	ret.session = player.session;
	ret.id = player.id;
	ret.trickster = player.trickster;
	ret.baby_stuck = player.baby_stuck;
	ret.sbahj = player.sbahj;
	ret.influenceSymbol = player.influenceSymbol;
	ret.grimDark = player.grimDark;
	ret.victimBlood = player.victimBlood;
	ret.murderMode = player.murderMode;
    ret.leftMurderMode = player.leftMurderMode; //scars
	ret.dead = player.dead;
	ret.isTroll = player.isTroll
	ret.godTier = player.godTier;
	ret.class_name = player.class_name;
	ret.aspect = player.aspect;
	ret.isDreamSelf = player.isDreamSelf;
	ret.hair = player.hair;
	ret.bloodColor = player.bloodColor;
	ret.hairColor = player.hairColor;
	ret.moon = player.moon;
	ret.chatHandle = player.chatHandle
	ret.leftHorn = player.leftHorn;
	ret.rightHorn = player.rightHorn;
	ret.quirk = player.quirk;
	ret.baby = player.baby;
	ret.causeOfDeath = player.causeOfDeath;
	ret.hp = player.hp;
	ret.minLuck = player.minLuck;
	ret.maxLuck = player.maxLuck;
	ret.freeWill = player.freeWill;
  ret.power = player.power;
  ret.interest1 = player.interest1;
  ret.interest2 = player.interest2;
	ret.mobility = player.mobility;
	return ret;
}


//taken out of SaveDoomedTimeLine this
function makeDoomedSnapshot(timePlayer){
	var timeClone = makeRenderingSnapshot(timePlayer);
	timeClone.dead = false;
	timeClone.currentHP = timeClone.hp
	timeClone.doomed = true;
	//from a different timeline, things went differently.
	var rand = Math.seededRandom();
	timeClone.power = Math.seededRandom() * 80+10;
	if(rand > 0.9){
		timeClone.robot = true;
		timeClone.hairColor = getRandomGreyColor();
	}else if(rand>.8){
		timeClone.godTier = !timeClone.godTier;
		if(timeClone.godTier){
			 timeClone.power = 200; //act like a god, damn it.
		 }
	}else if(rand>.6){
		timeClone.isDreamSelf = !timeClone.isDreamSelf;
	}else if(rand>.4){
		timeClone.grimDark = getRandomInt(0,4);
		timeClone.power += 50 * timeClone.grimDark;
	}else if(rand>.2){
		timeClone.murderMode = !timeClone.murderMode;
	}

	if(timeClone.grimDark > 3){
		var f = new Fraymotif([],  Zalgo.generate("The Broodfester Tongues"), 3)
		f.effects.push(new FraymotifEffect("power",3,true));
		f.effects.push(new FraymotifEffect("power",0,false));
		f.flavorText = " They are stubborn throes. "
		timeClone.fraymotifs.push(f);
	}

	if(timeClone.godTier){
		f = curSessionGlobalVar.fraymotifCreator.makeFraymotif([timePlayer], 3);//first god tier fraymotif
		timeClone.fraymotifs.push(f);
	}

	if(timeClone.power > 50){
		f = curSessionGlobalVar.fraymotifCreator.makeFraymotif([timePlayer], 2);//probably beat denizen at least
		timeClone.fraymotifs.push(f);
	}

	f = curSessionGlobalVar.fraymotifCreator.makeFraymotif([timePlayer], 1);//at least did first quest
	timeClone.fraymotifs.push(f);

	return timeClone;
}
