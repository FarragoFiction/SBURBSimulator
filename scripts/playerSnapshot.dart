

//keeps track of information the sprite needs to render itself
//allows player to go ahead and change while their snapshot remains the same
//even with asynchronous rendering.
//renderer calls this, not any individual scenes.
//consider not using this anymore for doomed time clones, instead use gameentity?
class PlayerSnapshot {
	var session = null;
	var trickster = null;
	var spriteCanvasID = null;
	var sbahj = null;
	var hair = null;
	bool usedFraymotifThisTurn = false;
	List<dynamic> buffs = []; //only used in strifes, array of BuffStats (from fraymotifs and eventually weapons)
	var baby = null;
	var robot = null;
	List<dynamic> fraymotifs = [];
	num hp = 0;
	num currentHP = 0;
	num minLuck = 0;
	num maxLuck = 0;
	num freeWill = 0;
	num mobility = 0;
	var causeOfDrain = null; //ghosts can't double die without LE, but can be drained by certain things. drained ghosts aren't going to help you again during your session.
	var id = null;
	var baby_stuck = null;
	var ectoBiologicalSource = null;
	var class_name = null;
	var doomed = null;
	var guardian = null;
	var number_confessions = null;
	var number_times_confessed_to = null;
	var influenceSymbol = null;
	var aspect = null;
	bool ghost = false; //only afer life sets this.
	var land = null;
	var interest1 = null;
	var interest2 = null;
	var chatHandle = null;
	var kernel_sprite = null;
	List<dynamic> relationships = [];
	var moon = null;
	var power = null;
	var leveledTheHellUp = null;
	var mylevels = null;
	var level_index = null;
	var godTier = null;
	var victimBlood = null;
	var hairColor = null;
	var dreamSelf = null;
	var isTroll = null;
	var bloodColor = null;
	var leftHorn = null;
	var rightHorn = null;
	var lusus = null;
	var quirk = null;
	var dead = null;
	num sanity = 0; //eventually replace triggerLevel with this (it's polarity is opposite triggerLevel)
	num alchemy = 0; //mostly unused until we get to the Alchemy update.
	var godDestiny = null;
	var canGodTierRevive = null;
	var isDreamSelf = null;
	var murderMode = null;
	var leftMurderMode = null;
	var grimDark = null;
	var leader = null;
	var landLevel = null;
	var denizenFaced = null;
	var denizenDefeated = null;
	var causeOfDeath = null;
	var doomedTimeClones = null;	


	PlayerSnapshot(this.) {}


	dynamic chatHandleShort(){
		return this.chatHandle.match(new RegExp(r"""\b(\w)|[A-Z]""", multiLine:true)).join('').toUpperCase();
	}
	dynamic allStats(){
		return ["power","hp","RELATIONSHIPS","mobility","sanity","freeWill","maxLuck","minLuck","alchemy"];
	}
	dynamic toDataBytesX(){
        var builder = new ByteBuilder();
        var j = this.toJSON();
        if(j.class_name <= 15 && j.aspect <= 15){ //if NEITHER have need of extension, just return size zero;
            builder.appendExpGolomb(0) //for length
            return encodeURIComponent(builder.data).replace(new RegExp(r"""#""", multiLine:true), '%23').replace(new RegExp(r"""&""", multiLine:true), '%26');
        }
        builder.appendExpGolomb(2) //for length
        builder.appendByte(j.class_name);
        builder.appendByte(j.aspect);
        return encodeURIComponent(builder.data).replace(new RegExp(r"""#""", multiLine:true), '%23').replace(new RegExp(r"""&""", multiLine:true), '%26');
    }
	void readInExtensionsString(reader){
        print("reading in extension string");
        //just inverse of encoding process.
        var numFeatures = reader.readExpGolomb(); //assume features are in set order. and that if a given feature is variable it is ALWAYS variable.
        if(numFeatures > 0)  this.class_name = intToClassName(reader.readByte());
        if(numFeatures > 1) this.aspect = intToAspect(reader.readByte());
        //as i add more things, add more lines. ALWAYS in same order, but not all features all the time.
    }
	dynamic toDataStrings(includeChatHandle){
		String ch = "";
		if(includeChatHandle) ch = sanitizeString(this.chatHandle);
		String ret = ""+sanitizeString(this.causeOfDrain) + ","+sanitizeString(this.causeOfDeath) + "," + sanitizeString(this.interest1) + "," + sanitizeString(this.interest2) + "," + sanitizeString(ch);
		return ret;
	}
	void makeAlive(){
		if(this.dead == false) return; //don't do all this.
		this.dead = false;
		this.currentHP = this.hp;
	}
	void modifyAssociatedStat(modValue, stat){
		//modValue * stat.multiplier.
		if(stat.name == "RELATIONSHIPS"){
			for(num i = 0; i<this.relationships.length; i++){
				this.relationships[i].value += modValue * stat.multiplier;
			}
		}else{
			this[stat.name] += modValue * stat.multiplier;
		}
	}
	dynamic toDataBytes(){
		var json = this.toJSON(); //<-- gets me data in pre-compressed format.
		var buffer = new ArrayBuffer(11);
		String ret = ""; //gonna return as a string of chars.;
		var uint8View = new Uint8Array(buffer);
		uint8View[0] = json.hairColor >> 16 ;//hair color is 12 bits. chop off 4 on right side, they will be in buffer[1];
		uint8View[1] = json.hairColor >> 8;
		uint8View[2] = json.hairColor >> 0;
		uint8View[3] = (json.class_name << 4) + json.aspect  ;//when I do fanon classes + aspect, use this same scheme, but have binary for "is fanon", so I know 1 isn't page, but waste (or whatever);
		uint8View[4] = (json.victimBlood << 4) + json.bloodColor;
		uint8View[5] = (json.interest1Category <<4) + json.interest2Category;
		uint8View[6] = (json.grimDark << 5) + (json.isTroll << 4) + (json.isDreamSelf << 3) + (json.godTier << 2) + (json.murderMode <<1) + (json.leftMurderMode) ;//shit load of single bit variables.;
		uint8View[7] = (json.robot << 7) + (json.moon << 6) + (json.dead << 5) + (json.godDestiny <<4) + (json.favoriteNumber);
		uint8View[8] = json.leftHorn;
		uint8View[9] = json.rightHorn;
		uint8View[10] = json.hair;
		//print(uint8View);
		for(num i = 0; i<uint8View.length; i++){
			ret += String.fromCharCode(uint8View[i]);
		}
		return encodeURIComponent(ret).replace(new RegExp(r"""#""", multiLine:true), '%23').replace(new RegExp(r"""&""", multiLine:true), '%26');
	}
	dynamic toJSON(){
		var json = {aspect: aspectToInt(this.aspect), class_name: classNameToInt(this.class_name), favoriteNumber: this.quirk.favoriteNumber, hair: this.hair,  hairColor: hexColorToInt(this.hairColor), isTroll: this.isTroll ? 1 : 0, bloodColor: bloodColorToInt(this.bloodColor), leftHorn: this.leftHorn, rightHorn: this.rightHorn, interest1Category: interestCategoryToInt(this.interest1Category), interest2Category: interestCategoryToInt(this.interest2Category), interest1: this.interest1, interest2: this.interest2, robot: this.robot ? 1 : 0, moon:this.moon ? 1 : 0,causeOfDrain: this.causeOfDrain,victimBlood: bloodColorToInt(this.victimBlood), godTier: this.godTier ? 1 : 0, isDreamSelf:this.isDreamSelf ? 1 : 0, murderMode:this.murderMode ? 1 : 0, leftMurderMode:this.leftMurderMode ? 1 : 0,grimDark:this.grimDark, causeOfDeath: this.causeOfDeath, dead: this.dead ? 1 : 0, godDestiny: this.godDestiny ? 1 : 0 };
		return json;
	}
	dynamic toString(){
		return (this.class_name+this.aspect).replace(new RegExp(r"""'""", multiLine:true), '');; //no spaces, no quotes for 's corpse'.
	}
	dynamic titleBasic(){
		String ret = "";
		if(this.doomed) ret += "Doomed ";
		ret+= this.class_name + " of " + this.aspect;
		return ret;
	}
	void flipOut(reason){
		this.flippingOutOverDeadPlayer = null;
		this.flipOutReason = reason;
	}
	void htmlTitleHP(){
		return getFontColorFromAspect(this.aspect) + this.title() + " (" + Math.round(this.getStat("currentHP")) +"hp, " + Math.round(this.getStat("power")) + " power)</font>";
	}
	bool renderable(){
		return true;
	}
	void htmlTitleBasic(){
			return getFontColorFromAspect(this.aspect) + this.titleBasic() + "</font>";
	}
	dynamic getChatFontColor(){
		if(this.isTroll){
			return this.bloodColor;
		}else{
			return getColorFromAspect(this.aspect);
		}
	}
	void makeDead(causeOfDeath){
		//print("there shouldu be a doomed time clone ghost in the afterlife: " + this.session.session_id);
		this.dead = true;
		this.causeOfDeath = causeOfDeath;
		this.session.afterLife.addGhost(makeRenderingSnapshot(this));
	}
	dynamic chatHandleShortCheckDup(otherHandle){
		var tmp= this.chatHandle.match(new RegExp(r"""\b(\w)|[A-Z]""", multiLine:true)).join('').toUpperCase();
		if(tmp == otherHandle){
			tmp = tmp + "2";
		}
		return tmp;
	}
	void htmlTitle(){
		return getFontColorFromAspect(this.aspect) + this.title() + "</font>";
	}
	dynamic title(){
		String ret = "";
		if(this.doomed){
			ret += "Doomed ";
		}


		if(this.murderMode){
			ret += "Murder Mode ";
		}

		if(this.grimDark){
			ret += "Grim Dark ";
		}

		if(this.godTier){
			ret+= "God Tier ";
		}else if(this.isDreamSelf){
			ret+= "Dream ";
		}
		ret+= this.class_name + " of " + this.aspect;
		if(this.dead){
			ret += "'s Corpse";
		}
		return ret;
	}
	void changeGrimDark(){
		//stubb
	}
	dynamic rollForLuck(stat){
    		if(!stat){
    		    return getRandomInt(this.getStat("minLuck"), this.getStat("maxLuck"));
    		}else{
    		    //don't care if it's min or max, just compare it to zero.
    		    return getRandomInt(0, this.getStat(stat));
    		}

    }
	void interactionEffect(player){
			//none
	}
	void boostAllRelationshipsWithMeBy(amount){

	}
	void boostAllRelationshipsBy(amount){

	}
	void resetFraymotifs(){
		for(num i = 0; i<this.fraymotifs.length; i++){
			this.fraymotifs[i].usable = true;
		}
	}
	dynamic getStat(statName){
		num ret = 0;
		if(statName != "RELATIONSHIPS"){ //relationships, why you so cray cray???
			ret += this[statName];
		}else{
			for(num i = 0; i<this.relationships.length; i++){
				ret += this.relationships[i].value;s
			}
		}
		//if(this.buffs.length > 0) alert("buffs!!!");
		for(num i = 0; i<this.buffs.length; i++){
			var b = this.buffs[i];
			if(b.name == statName) ret += b.value;
		}
		return ret;
	}
	void increasePower(){
		//stub for boss fights for doomed time clones. they can't level up. they are doomed.
	}
	void getRelationshipWith(){
		//stub for boss fights where an asshole absconds.
	}
	List<dynamic> getFriendsFromList(){
		return [];
	}
	List<dynamic> getHearts(){
		return [];
	}
	List<dynamic> getDiamonds(){
		return [];
	}
	dynamic getTotalBuffForStat(statName){
    	    num ret = 0;
    	    for(num i = 0; i<this.buffs.length; i++){
    	        var b = this.buffs[i];
    	        if(b.name == statName) ret += b.value;
    	    }
    	    return ret;
    	}
	void humanWordForBuffNamed(statName){
            if(statName == "MANGRIT") return "powerful";
            if(statName == "hp") return "sturdy";
            if(statName == "RELATIONSHIPS") return "friendly";
            if(statName == "mobility") return "fast";
            if(statName == "sanity") return "calm";
            if(statName == "freeWill") return "willful";
            if(statName == "maxLuck") return "lucky";
            if(statName == "minLuck") return "lucky";
            if(statName == "alchemy") return "creative";
    	}
	dynamic describeBuffs(){
    	    List<dynamic> ret = [];
    	    var allStats = this.allStats();
    	    for(num i = 0; i<allStats.length; i++){
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
class MiniSnapShot {
	var relationships = player.relationships;
	var murderMode = player.murderMode;
	var grimDark = player.grimDark;
	var isTroll = player.isTroll;
	var class_name = player.class_name;
	var aspect = player.aspect;	


	MiniSnapShot(this.player) {}


	void restoreState(player){
		player.relationships = this.relationships;
		player.murderMode = this.murderMode;
		player.grimDark = this.grimDark;
		player.isTroll = this.isTroll;
		player.class_name = this.class_name;
		player.aspect = this.aspect;
		player.stateBackup = null; //no longer need to keep track of old state.
	}

}




dynamic makeRenderingSnapshot(player){
	var ret = new PlayerSnapshot();
	ret.fraymotifs = player.fraymotifs.slice(0);//omg, make a copy you dunkass, or time players get the OP fraymotifs of their doomed clones;
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
	ret.isTroll = player.isTroll;
	ret.godTier = player.godTier;
	ret.class_name = player.class_name;
	ret.aspect = player.aspect;
	ret.isDreamSelf = player.isDreamSelf;
	ret.hair = player.hair;
	ret.bloodColor = player.bloodColor;
	ret.hairColor = player.hairColor;
	ret.moon = player.moon;
	ret.chatHandle = player.chatHandle;
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
dynamic makeDoomedSnapshot(timePlayer){
	var timeClone = makeRenderingSnapshot(timePlayer);
	timeClone.dead = false;
	timeClone.currentHP = timeClone.hp;
	timeClone.doomed = true;
	//from a different timeline, things went differently.
	var rand = seededRandom();
	timeClone.power = seededRandom() * 80+10;
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
		var f = new Fraymotif([],  Zalgo.generate("The Broodfester Tongues"), 3);
		f.effects.push(new FraymotifEffect("power",3,true));
		f.effects.push(new FraymotifEffect("power",0,false));
		f.flavorText = " They are stubborn throes. ";
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
