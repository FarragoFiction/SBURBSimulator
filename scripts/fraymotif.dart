part of SBURBSim;

/*
stat effects from a fraymotif are temporary. wear off after battle.
so, players, player snapshots AND gameEntities will have to have an array of applied fraymotifs.
and their getPower, getHP etc stats must use these.
at start AND end of battle (can't be too careful), wipe applied fraymotifs
*/
class Fraymotif {
	var aspects; //expect to be an array
	String name;
    int tier;
	bool usable = true; //when used in a fight, switches to false. IMPORTANT: fights should turn it back on when over.
    //flavor text acts as a template, with ENEMIES and CASTERS and ALLIES and ENEMY being replaced.
    //you don't call flavor text directly, instead expecting the use of the fraymotif to return something;
    //based on it.
    //make sure ENEMY is the same for all effects, dunkass.
    String flavorText;  //will generate it procedurally if not set, otherwise things like sprites will have it hand made.
	bool used = false; //when start fight, set to false. set to true when used. once per fight
	List<dynamic> effects = [];  //each effect is a target, a revive, a statName
	num baseValue;


	Fraymotif(this.aspects, this.name, this.tier, [this.flavorText=""]) {
		this.baseValue = 50 * this.tier;
		if(this.tier >=3)
			this.baseValue = 1000 * this.tier-2;//so a tier 3 is 1000 * 3 -2, or....1000.  But..maybe there is a way to make them even more op???
	}


	dynamic toString(){
      return this.name;
    }
	void addEffectsForPlayers(players){
		for(num i = 0; i<players.length; i++){
			var effect = new FraymotifEffect(null, null, null);
			effect.setEffectForPlayer(players[i]);
			this.effects.add(effect);
		}
	}
	dynamic getCastersNoOwner(players){
	    List<dynamic> casters = [];
        for(num i = 0; i<this.aspects.length; i++){ //skip the first aspect, because that's owner.
            var a = this.aspects[i];
            var p = getRandomElementFromArray(findAllAspectPlayers(players, a));//ANY player that matches my aspect can do this.;
            if(p != null) casters.add(p); //don't add 'undefined' to this array like a dunkass.
        }
        return casters;  //eventually do smarter things, like only allow to cast buff hp if heals are needed or anybody is dead.

	}
	dynamic getCasters(owner, allies){
		//first check to see if all aspects are included in the allies array.
		var casters = [owner];
		//List<dynamic> aspects = [];
		var living = findLivingPlayers(allies); //dead men use no fraymotifs. (for now)
		for(num i = 1; i<this.aspects.length; i++){ //skip the first aspect, because that's owner.
			var a = this.aspects[i];
			var p = getRandomElementFromArray(findAllAspectPlayers(living, a));//ANY player that matches my aspect can do this.;
			if(p != null) casters.add(p); //don't add 'undefined' to this array like a dunkass.
		}
		return casters;  //eventually do smarter things, like only allow to cast buff hp if heals are needed or anybody is dead.
	}
	dynamic processFlavorText(owner, casters, allies, enemy, enemies, revives){
      if(this.flavorText == null || this.flavorText.length == 0){
         this.flavorText = this.proceduralFlavorText();
      }
      String phrase = "The CASTERS use FRAYMOTIF. ";//shitty example.
      if(casters.length == 1) phrase = "The CASTERS uses FRAYMOTIF. It damages the ENEMY. ";
      phrase += this.flavorText + revives;
      return this.replaceKeyWords(phrase, owner, casters, allies,  enemy, enemies);
  }
	dynamic proceduralFlavorText(){
    var base = this.superCondenseEffectsText();
    return base;
  }
	dynamic superCondenseEffectsText(){
    var effectTypes = {};  //hash coded by effectType damage0 vs damage1 vs buff0. first element is template
    for(int i = 0; i<4; i++){
      effectTypes["damage$i"] = [];
      effectTypes["buff$i"] = [];
    }
    for(num i = 0; i<this.effects.length; i++){
      var e = this.effects[i];
      if(e.damageInsteadOfBuff){
        if(effectTypes["damage"+ e.target].length == 0)   effectTypes["damage"+ e.target].add(e.toStringSimple());
        //no repeats
        if( effectTypes["damage"+ e.target].indexOf(e.statName) == -1) effectTypes["damage"+ e.target].add(e.statName);
      }else{
        if(effectTypes["buff"+ e.target].length == 0)   effectTypes["buff"+ e.target].add(e.toStringSimple());
        //no repeats
        if( effectTypes["buff"+ e.target].indexOf(e.statName) == -1) effectTypes["buff"+ e.target].add(e.statName);
      }
    }

    //now i have a hash of all effect types and the stats i'm applying to them.
    List<dynamic> retArray = [];
    for(int i = 0; i<4; i++){
      List<dynamic> stats = [];

      if(effectTypes["damage$i"].length > 0){
        stats = effectTypes["damage$i"];
        var template = stats[0];
        stats.remove(template);
        for(num j = 0; j<stats.length; j++){
          stats[j] = this.getStatWord(stats[j], i); //i is who the target is, j is the stat.
        }
        retArray.add(template.replace("STAT", [stats.sublist(0, -1).join(', '), stats.sublist(-1)[0]].join(stats.length < 2 ? '' : ' and ')));
      }
      if(effectTypes["buff$i"].length > 0){
        stats = effectTypes["buff$i"];
        var template = stats[0];
        stats.remove(template);
        for(num j = 0; j<stats.length; j++){
          stats[j] = this.getStatWord(stats[j], i); //i is who the target is, j is the stat.
        }
        retArray.add(template.replace("STAT", [stats.sublist(0, -1).join(', '), stats.sublist(-1)[0]].join(stats.length < 2 ? '' : ' and ')));
      }

    }
    String almostDone= [retArray.sublist(0, -1).join(', '), retArray.sublist(-1)[0]].join(retArray.length < 2 ? '' : ' and ');
    almostDone = almostDone[0].toUpperCase() + almostDone.substring(1) + "."; //sentence it.
    return this.replaceKeyWordsForFlavorTextBase(almostDone);

  }
	String getStatWord(stat, target){
    bool bad = true;
    if(target == 0 || target == 1 ) bad = false;
    if(!bad){
       return getRandomElementFromArray(this.goodStatWords(stat));
    }else{
       return getRandomElementFromArray(this.badStatWords(stat));
    }
  }
	List<String> goodStatWords(statName){
    if(statName == "MANGRIT") return ["mangrit","strength","power","might","fire","pure energy","STRENGTH"];
    if(statName == "hp") return ["plants","health","vines", "gardens", "stones","earth","life","moss","fruit","growth"];
    if(statName == "RELATIONSHIPS") return ["chains","friendship bracelets","shipping grids", "connections", "hearts", "pulse", "bindings", "rainbows", "care bare stares", "mirrors"];
    if(statName == "mobility") return ["wind","speed","hedgehogs", "whirlwinds", "gales", "hurricanes","thunder","storms","momentum", "feathers"];
    if(statName == "sanity") return ["calmness","sanity", "ripples", "glass", "fuzz","water","stillness","totally real magic"];
//,"velvet pillows"
    if(statName == "freeWill") return ["electricity","will", "open doors", "possibility", "quantum physics" ,"lightning","sparks","chaos", "broken gears"];
    if(statName == "maxLuck") return ["dice","luck","light","playing cards", "suns","absolute bullshit","card suits", "hope"];
    if(statName == "minLuck") return ["dice","luck","light","playing cards", "suns","absolute bullshit","card suits"];
    if(statName == "alchemy") return ["inspiration","creativeness","grist", "perfectly generic objects","hammers","swords","weapons", "creativity","mist", "engines", "metals"];

    return null;
  }
	List<String> badStatWords(statName){
    if(statName == "MANGRIT") return ["weakness","powerlessness","despair","wretchedness","misery"];
    if(statName == "hp") return ["fragility","rotting plants","disease", "bones", "skulls", "tombstones", "ash", "toxin","mold", "viruses"];
    if(statName == "RELATIONSHIPS") return ["aggression","broken chains","empty friends lists","sand","loneliness"];
    if(statName == "mobility") return ["laziness", "locks", "weights","manacles","quicksand","gravitons","gravity","ice"];
//"pillows", "sloths",
    if(statName == "sanity") return ["harshwimsies","clowns","fractals", "madness", "tentacles", "rain", "screams", "terror", "nightmares", "mIrAcLeS", "rage","impossible angles","teeth"];
    if(statName == "freeWill") return ["acceptance","gullibility","closed doors", "gears", "clocks", "prophecy", "static","skian clouds"];
    if(statName == "maxLuck") return ["misfortune","blank books","broken mirrors","hexes", "doom", "8ad 8reaks", "disaster", "black cats"];
    if(statName == "minLuck") return ["misfortune","blank books","broken mirrors","hexes", "doom", "8ad 8reaks", "disaster", "black cats"];
    if(statName == "alchemy") return ["failure","writer's blocks","monotony","broken objects","object shards","nails","splinters"];

    return null;
  }
	String condenseEffectsText(){
        /*
          If two effects both DAMAGE an ENEMY, then I want to generate text where it lists the types of damage.
          “Damages an Enemy based on how WILLFUL, STRONG, CALM, and FAST, the casters are compared to their enemy.”
        */
        //8 main types of effects, damage/buff and 0-4
        var effectTypes = {};  //hash coded by effectType damage0 vs damage1 vs buff0. first element is template
        for(int i = 0; i<4; i++){
          effectTypes["damage$i"] = [];
          effectTypes["buff$i"] = [];
        }
        for(num i = 0; i<this.effects.length; i++){
          var e = this.effects[i];
          if(e.damageInsteadOfBuff){
            if(effectTypes["damage"+ e.target].length == 0)   effectTypes["damage"+ e.target].add(e.toString());
            //no repeats
            if( effectTypes["damage"+ e.target].indexOf(e.statName) == -1) effectTypes["damage"+ e.target].add(e.statName);
          }else{
            if(effectTypes["buff"+ e.target].length == 0)   effectTypes["buff"+ e.target].add(e.toString());
            if( effectTypes["buff"+ e.target].indexOf(e.statName) == -1) effectTypes["buff"+ e.target].add(e.statName);
          }
        }
        //now i have a hash of all effect types and the stats i'm applying to them.
        List<dynamic> retArray = [];
        for(int i = 0; i<4; i++){
          List<dynamic> stats = [];
          if(effectTypes["damage$i"].length > 0){
            stats = effectTypes["damage$i"];
            var template = stats[0];
            stats.remove(template);
            retArray.add(template.replace("STAT", [stats.sublist(0, -1).join(', '), stats.sublist(-1)[0]].join(stats.length < 2 ? '' : ' and ')));
          }
          if(effectTypes["buff$i"].length > 0){
            stats = effectTypes["buff$i"];
            var template = stats[0];
            stats.remove(template);
            retArray.add(template.replace("STAT", [stats.sublist(0, -1).join(', '), stats.sublist(-1)[0]].join(stats.length < 2 ? '' : ' and ')));
          }
        }
        return [retArray.sublist(0, -1).join(', '), retArray.sublist(-1)[0]].join(retArray.length < 2 ? '' : ' and ');

  }
	dynamic replaceKeyWordsForFlavorTextBase(phrase, ){
    phrase = phrase.replaceAll("damages", getRandomElementFromArray(this.getDamageWords()));
    phrase = phrase.replaceAll("debuffs", getRandomElementFromArray(this.getDebuffWords()));
    phrase = phrase.replaceAll("heals", getRandomElementFromArray(this.getHealingWords()));
    phrase = phrase.replaceAll("buffs", getRandomElementFromArray(this.getBuffWords()));
    phrase = phrase.replaceAll("SELF", getRandomElementFromArray(this.getSelfWords()));
    phrase = phrase.replaceAll("EBLUH", getRandomElementFromArray(this.getEnemyWords()));
    phrase = phrase.replaceAll("FRIENDSBLUH", getRandomElementFromArray(this.getAlliesWords()));
    phrase = phrase.replaceAll("ESBLUHS", getRandomElementFromArray(this.getEnemiesWords()));
    return phrase;
  }
	void replaceKeyWords(phrase, owner, casters, allies, enemy, enemies){
    //ret= ret.replace(new RegExp(this.lettersToReplace[i][0], "g"),replace);
    phrase = phrase.replaceAll("OWNER", owner.htmlTitleHP());
    phrase = phrase.replaceAll("CASTERS", getPlayersTitlesBasic(casters));
    phrase = phrase.replaceAll("ALLIES", getPlayersTitlesBasic(allies));
    phrase = phrase.replaceAll("ENEMY", enemy.htmlTitleHP());
    phrase = phrase.replaceAll("ENEMIES", getPlayersTitlesBasic(enemies));
    phrase = phrase.replaceAll("FRAYMOTIF", this.name);

    return phrase;
  }
	List<String> getSelfWords(){
    return ["aura", "cloak", "shield", "armor", "robe", "orbit", "suit", "aegis"];
  }
	List<String> getAlliesWords(){
      return ["cloud", "mist", "fog", "ward", "wall", "blockade", "matrix"];
  }
	List<String> getEnemyWords(){
      return ["lance","spike","laser", "hammer", "shard", "ball", "meteor", "fist","beautiful pony", "cube", "bolt"];
  }
	List<String> getEnemiesWords(){
      return ["explosion","blast","miasma", "matrix", "deluge", "cascade", "wave", "fleet", "illusion"];
  }
	List<String> getDamageWords(){
        return ["painful","acidic","sharp", "harmful", "violent", "murderous", "destructive", "explosive"];
  }
	List<String> getDebuffWords(){
        return ["draining","malicious", "distracting", "degrading", "debuffing", "cursed", "vampiric"];
  }
	List<String> getHealingWords(){
    return ["healing","restorative","restful","rejuvenating","reinforcing"];
  }
	List<String> getBuffWords(){
    return ["soothing","supportive","friendly", "fortifying", "protective", "warding", "defensive","blessed"];
  }
	bool canCast(owner, allies, enemies){
    if(!this.usable) return false; //once per fight.
    if(this.aspects.length == 0) return true; //no associated aspect means anyone can cast
    var casters = this.getCasters(owner, allies);
    return (casters.length == this.aspects.length);
  }
	void makeCastersUnavailable(casters){
    for(num i = 0; i<casters.length; i++){
      casters[i].usedFraymotifThisTurn = true;
    }
  }
	dynamic useFraymotif(owner, List<GameEntity> allies, GameEntity enemy, List<GameEntity> enemies){
    if(!this.canCast(owner, allies, enemies)) return "";
		var casters = this.getCasters(owner, allies);
    this.makeCastersUnavailable(casters);
    var living = findLivingPlayers(allies);
    //Hope Rides Alone
    if(owner.aspect == "Hope" && living.length == 1 && seededRandom() > 0.85){
        enemies[0].buffs.add(new Buff("currentHP", -9999)); //they REALLY believed in this attack.
        var jakeisms = ["GADZOOKS!","BOY HOWDY!","TALLY HO!","BY GUM"];
        print("Hope Rides Alone in session: "  + owner.session.session_id);
        var scream = getFontColorFromAspect(owner.aspect) + getRandomElementFromArray(jakeisms) + "</font>";
        return " [HOPE RIDES ALONE] is activated. " + owner.htmlTitle() +  " starts screaming. <br><br><span class = 'jake'> " + scream + " </span>  <Br><Br> Holy fucking SHIT, that is WAY MORE DAMAGE then is needed. Jesus christ. Someone nerf that Hope player already!";
    }
    var dead = findDeadPlayers(allies);
		//print(casters);
    //ALL effects that target a single enemy target the SAME enemy.
		for(num i = 0; i<this.effects.length; i++){
			//effect knows how to apply itself. pass it baseValue.
			this.effects[i].applyEffect(owner, allies, casters,  enemy, enemies, this.baseValue);
		}
    String revives = "";
    if(dead.length > findDeadPlayers(allies).length){
      revives = " Also, the " + getPlayersTitlesBasic(dead) + " being dead is no longer a thing. ";
    }
    enemy.addStat("currentHP", -1 * owner.getStat("power")); //also, do at LEAST as much as a regular attack, dunkass.
    return this.processFlavorText(owner, casters,allies, enemy, enemies, revives);
	}

}





//no global functions any more. bad pastJR.
class FraymotifCreator {
    //some types of fraymotifs, that are otherwise procedurally generated, should have stupid pun names. they are kept here.
 List<dynamic> premadeFraymotifNames = [];  


	FraymotifCreator() {}


	void createFraymotifForPlayerDenizen(player, name){
    //var denizen = player.denizen;
    var f = new Fraymotif([], name + "'s " + this.getDenizenFraymotifNameFromAspect(player.aspect), 2); //CAN I have an aspectless fraymotif?
    f.flavorText = this.getDenizenFraymotifDescriptionForAspect(player.aspect);

    //statName, target, damageInsteadOfBuff, flavorText
    var plus = player.associatedStats ;//buff self and heal. used to be only positive, but that gave witches/sylphs/princes/bards the shaft;
    for(num i = 0; i<plus.length; i++){
      f.effects.add(new FraymotifEffect(plus[i].name,0,true));
      f.effects.add(new FraymotifEffect(plus[i].name,0,false));
    }
    var minus = player.associatedStats ;//debuff enemy, and damage. used to be only negative, but that gave witches/sylphs/princes/bards the shaft;
    for(num i = 0; i<minus.length; i++){
      f.effects.add(new FraymotifEffect(minus[i].name,2,true));
      f.effects.add(new FraymotifEffect(minus[i].name,2,false));
    }
    player.denizen.fraymotifs.add(f);
  }
	dynamic getDenizenFraymotifNameFromAspect(aspect){
      String ret = "";
      if(aspect == "Blood"){
          ret = "Ballad " ;//a song passed over generations in an oral history;
      }else if(aspect == "Mind"){
        ret = "Fugue"  ;//a musical core that is altered and changed and interwoven with itself. Also, a mental state of confusion and loss of identity  (alternate selves that made different choices);
      }else if(aspect == "Rage"){
         ret = " Aria" ;// a musical piece full of emotion;
      }else if(aspect == "Void"){
         ret = "Silence" ;//;
      }else if(aspect == "Time"){
         ret = "Canon" ;//a musical piece in which a section is repeated (but unchanged) at different times, layered until it's unreconizable  (stable time loops);
      }else if(aspect == "Heart"){
        ret = "Leitmotif" ;//a musical theme representing a particular character;
      }else if(aspect == "Breath"){
        ret = "Refrain";
      }else if(aspect == "Light"){
        ret = "Opera" ;//lol, cuz light players never shut up;
      }else if(aspect == "Space"){
        ret = "Sonata" ;//a composition for a soloist.  Space players are stuck doing something different from everyone,;
      }else if(aspect == "Hope"){
        ret = "Etude" ;//a musical exercise designed to improve the performer;
      }else if(aspect == "Life"){
        ret = "Lament" ;//passionate expression of grief. so much life has been lost to SBURB.;
      }else if(aspect == "Doom"){
        ret = "Dirge" ;//a song for the dead;
      }else{
        ret = "Song";
      }
      return ret;
  }
	dynamic getDenizenFraymotifDescriptionForAspect(aspect){
      String ret = "";
      if(aspect == "Blood"){
          ret = " A sour note is produced. It's the one Agitation plays to make its audience squirm. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";
      }else if(aspect == "Mind"){
        ret = " A fractured chord is prepared. It is the one Regret plays to make insomnia reign. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";
      }else if(aspect == "Rage"){
         ret = " A hsirvprmt xslri begins to tryyvi. It is the one Madness plays gl pvvk rgh rmhgifnvmg rm gfmv. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And yes, The OWNER know you're watching them. ";
      }else if(aspect == "Void"){
         ret = " A yawning silence rings out. It is the NULL Reality sings to keep the worlds on their dance. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";
      }else if(aspect == "Time"){
         ret = "  A sun skips on a groove its tracing 'round the earth, the one-two beat Despair plays to turn cause and effect meaningless. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is/was/will be to say on the matter. ";
      }else if(aspect == "Heart"){
        ret = " A chord begins to echo. It is the one Damnation will play at their brith. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";
      }else if(aspect == "Breath"){
        ret = " A haunting refrain begins to play. It is the one Desolation plays to keep its instrument in tune. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";
      }else if(aspect == "Light"){
        ret = " A beautiful opera begins to be performed. It starts to really pick up around Act 4. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";
      }else if(aspect == "Space"){
        ret = " An echoing note is plucked. It is the one Isolation plays to chart the depths of reality. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";
      }else if(aspect == "Hope"){
        ret = " A resounding hootenanny begins to play. It is the one Irony performs to remember the past. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";
      }else if(aspect == "Life"){
        ret = " A plucked note echos in the stillness. It is the one Desire plays to summon it's audience. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";
      }else if(aspect == "Doom"){
        ret = " A slow dirge begins to play. It is the one Death plays to keep in practice. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";
      }else{
        ret = " A haunting refrain begins to play. It is the one Desolation plays to keep its instrument in tune. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";
      }

      return ret;
  }
	List<Fraymotif> getUsableFraymotifs(owner, allies, enemies){
    var fraymotifs = owner.fraymotifs;
    List<dynamic> ret = [];
    for(num i = 0; i<fraymotifs.length; i++){
      if(fraymotifs[i].canCast(owner, allies, enemies)) ret.add(fraymotifs[i]);
    }
    //print("Found: " + ret.length + " usable fraymotifs for " + owner);
    return ret;
  }
	String getRandomBreathName(){
      var names = ["Gale", "Wiznado", "Feather", "Lifting", "Breathless","Jetstream", "Hurricane", "Tornado"," Kansas", "Breath", "Breeze", "Twister", "Storm", "Wild", "Inhale", "Windy", "Skylark", "Fugue", "Pneumatic", "Wheeze", "Forward", "Vertical", "Whirlwind", "Jetstream"];
      return getRandomElementFromArray(names);
  }
 String getRandomRageName(){
      var names = ["Rage", "Barbaric", "Impossible", "Tantrum", "Juggalo","Horrorcore" ,"Madness", "Carnival", "Mirthful", "Screaming", "Berserk", "MoThErFuCkInG", "War", "Haze", "Murder", "Furioso", "Aggressive", "ATBasher", "Violent", "Unbound", "Purple", "Unholy", "Hateful", "Fearful", "Inconceivable", "Impossible"];
      return getRandomElementFromArray(names);
  }
 String getRandomLifeName(){
      var names = ["Life" ,"Pastoral", "Green", "Relief", "Healing", "Plant", "Vitality", "Growing", "Garden", "Multiplying", "Rising", "Survival", "Phoenix", "Respawn", "Mangrit", "Animato", "Gaia", "Increasing", "Overgrowth", "Jungle", "Harvest", "Lazarus"];
      return getRandomElementFromArray(names);
  }
 String getRandomHopeName(){
      var names = ["Hope","Fake", "Belief", "Bullshit", "Determination", "Burn", "Stubborn", "Religion", "Will", "Hero", "Undying", "Dream", "Sepulchritude", "Prophet", "Apocryphal"];
      return getRandomElementFromArray(names);
  }
 String getRandomVoidName(){
      String randBonus = "<span class ;= 'void'>" + getRandomElementFromArray(interests) +  "</span>";
      var names = ["Undefined", "untitled.mp4", "Void","Disappearification","Pumpkin", "Nothing", "Emptiness", "Invisible", "Dark", "Hole", "Solo", "Silent", "Alone", "Night", "Null", "[Censored]", "[???]", "Vacuous", "Abyss", "Noir", "Blank", "Tenebrous", "Antithesis", "404"];
      return getRandomElementFromArray(names)+ randBonus;
  }
 String getRandomLightName(){
      var names = ["Lucky", "Light", "Knowledge", "Blinding", "Brilliant", "Break", "Blazing", "Glow", "Flare", "Gamble", "Omnifold", "Apollo", "Helios", "Scintillating", "Horseshoe", "Leggiero", "Star", "Kindle", "Gambit", "Blaze"];
      return getRandomElementFromArray(names);
  }
 String getRandomMindName(){
      var names = ["Mind", "Modulation", "Shock", "Awe", "Coin", "Judgement", "Mind", "Decision", "Spark", "Path", "Trial", "Variations", "Thunder", "Logical", "Telekinetic", "Brainiac", "Hysteria", "Deciso", "Thesis", "Imagination",  "Psycho", "Control", "Execution", "Bolt"];
      return getRandomElementFromArray(names);
  }
 String getRandomHeartName(){
      var names = ["Heart","Soul", "Jazz", "Blues", "Spirit", "Splintering", "Clone", "Self", "Havoc", "Noble", "Animus", "Astral", "Shatter", "Breakdown", "Ethereal", "Beat", "Pulchritude"];
      return getRandomElementFromArray(names);
  }
 String getRandomBloodName(){
      var names = ["Blood", "Trigger","Chain", "Flow", "Charge", "Awakening", "Ichorial", "Friendship", "Trusting", "Clotting", "Union", "Bleeding", "Team", "Transfusion", "Pulse", "Sanguine", "Positive", "Negative", "Cruor", "Vim", "Chorus", "Iron", "Ichorial", "Fever", "Heat"];
      return getRandomElementFromArray(names);
  }
 String getRandomDoomName(){
      var names = ["Dark", "Broken", "Meteoric", "Diseased","Fate", "Doomed", "Inevitable", "Doom", "End", "Final", "Dead", "Ruin", "Rot", "Coffin", "Apocalypse", "Morendo", "Smorzando", "~Ath", "Armistyx", "Grave", "Corpse", "Ashen", "Reaper", "Diseased", "Armageddon", "Cursed"];
      return getRandomElementFromArray(names);
  }
 String getRandomTimeName(){
      var names = ["Time","Paradox", "Chrono", "Moment", "Foregone", "Reset", "Endless", "Temporal", "Shenanigans", "Clock", "Tick-Tock", "Spinning", "Repeat", "Rhythm", "Redshift",  "Epoch", "Beatdown", "Slow", "Remix", "Clockwork", "Lock", "Eternal"];
      return getRandomElementFromArray(names);
  }
 String getRandomSpaceName(){
      var names = ["Canon","Space","Frogs", "Location", "Spatial", "Universe", "Infinite", "Spiral", "Physics", "Star", "Galaxy", "Nuclear", "Atomic", "Nucleus", "Horizon", "Event", "CROAK", "Spatium", "Squiddle", "Engine", "Meteor", "Gravity", "Crush"];
      return getRandomElementFromArray(names);
  }
 String getRandomNameForAspect(aspect){
    String ret = "";
    if(aspect == "Blood") ret = this.getRandomBloodName();
    if(aspect == "Mind") ret = this.getRandomMindName();
    if(aspect == "Rage") ret =  this.getRandomRageName();
    if(aspect == "Time") ret =  this.getRandomTimeName();
    if(aspect == "Void") ret =  this.getRandomVoidName();
    if(aspect == "Heart") ret =  this.getRandomHeartName();
    if(aspect == "Breath") ret =  this.getRandomBreathName();
    if(aspect == "Light") ret =  this.getRandomLightName();
    if(aspect == "Space") ret =  this.getRandomSpaceName();
    if(aspect == "Hope") ret =  this.getRandomHopeName();
    if(aspect == "Life") ret =  this.getRandomLifeName();
    if(aspect == "Doom") ret =  this.getRandomDoomName();
    return getFontColorFromAspect(aspect) + ret + "</font>";
  }
	String getRandomMusicWord(aspect){ //takes in an aspect for color
    List<String> names = ["Fortississimo", "Leitmotif", "Liberetto", "Sarabande", "Serenade", "Anthem", "Crescendo", "Vivace", "Encore", "Vivante", "Allegretto", "Fugue", "Choir", "Nobilmente", "Hymn", "Eroico", "Chant", "Mysterioso", "Diminuendo", "Perdendo", "Staccato", "Allegro", "Caloroso", "Nocturne"];
    names.addAll(["Cadenza", "Cadence", "Waltz", "Concerto", "Finale", "Requiem", "Coda", "Dirge", "Battaglia", "Leggiadro", "Capriccio", "Presto", "Largo", "Accelerando", "Polytempo", "Overture", "Reprise", "Orchestra"]);

    var ret = getRandomElementFromArray(names);
    if(seededRandom() > 0.5){
      return "<span style='color:" + getColorFromAspect(aspect) + "'>" + ret.toLowerCase()+"</span>";  //tacked onto existin word
    }else{
      return " " + ret; //extra word
    }
  }
	dynamic tryToGetPreMadeName(players){
    if(seededRandom() > 0.5) return null; //just use the procedural name.

    if(this.premadeFraymotifNames.length == 0) this.initializePremadeNames();
    for(num i = 0; i<this.premadeFraymotifNames.length; i++){
        var f = this.premadeFraymotifNames[i];
        var casters = f.getCastersNoOwner(players);
        if (casters.length == f.aspects.length) return f.name;
    }
    return null;
  }
	void initializePremadeNames(){
    this.premadeFraymotifNames = [];
    this.premadeFraymotifNames.add(new Fraymotif(["Light", "Mind"], "Blinded By The Light",1, ""));
		this.premadeFraymotifNames.add(new Fraymotif(["Light", "Heart"], "Total Eclipse of the Heart",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Breath", "Time"], "Stop, Hammertime",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Breath", "Hope"], "Wings of Freedom",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Doom", "Hope"], "Happy Ending",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Space", "Time"], "Adagio Redshift",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Life", "Time"], "Time Heals All Wounds",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Heart", "Doom"], "Madrigal Melancholia",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Space", "Time", "Breath", "Light"], "Canon in HS Major",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Life", "Void", "Heart", "Hope"], "Canon in HS Minor",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Doom", "Time"], "Another One Bites The Dust",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Hope", "Time"], "Maybe Someday",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Mind", "Space"], "Mind Over Matter",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Space", "Life"], "Extraterrestrial Ensemble",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Life", "Time"], "Lifetime Special",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Space", "Breath"], "Air on a Cosmic String",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Breath", "Void"], "Rhapsody in Blue",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Mind", "Breath"], "Brainstorm",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Space", "Void"], "Spaced Out",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Hope", "Light"], "Look On The Bright Side",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Light", "Void"], "Lights Out",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Hope", "Void"], "Lost Hope",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Light", "Hope"], "Grandiose Illuminations",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Hope", "Void"], "Lost Hope",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Rage", "Light", "Heart"], "Flipping the Light Fantastic",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Heart", "Void"], "Hotel California",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Hope", "Heart"], "Feel Good",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Heart", "Void", "Space"], "Heart's Not In It",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Mind", "Breath"], "Freedom of Thought",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Doom", "Rage"], "Brick in The Wall",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Blood", "Doom", "Life"], "Ancestral Awakening",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Doom", "Time"], "You're Gonna Have a Bad Time",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Doom", "Hope"], "I Hope You Die",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Rage", "Breath"], "Free Rage Chicken",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Time", "Rage"], "Gears of War",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Breath", "Void"], "You Suck",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Light", "Breath"], "Apollo's Chariot",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Space", "Hope"], "Planck Fandango",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Breath", "Life"], "Emancipation Proclamation",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Space", "Void"], "Glass Half Empty",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Blood", "Hope", "Mind"], "It's Raining Zen (Hallelujah)",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Light", "Space"], "She Blinded Me With Science",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Time", "Life", "Blood"], "Never Gonna Let You Down",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Doom", "Breath"], "Bad Breath",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Rage", "Blood"], "Opposites Attract",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Life", "Doom", "Heart", "Space"], "Life and Death and Love and Birth",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Breath", "Doom"], "Freedom is Slavery",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Breath", "Time", "Space"], "Alternate Universe",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Void", "Life"], "Tangle Buddies",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Breath", "Hope"], "Let's Pierce the Heavens",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Void", "Time"], "Volatile Times",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Space", "Void"], "Mom's Spaghettification",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Rage", "Doom", "Light"], "Kill the Light",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Doom", "Light"], "Deadly Laser",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Blood", "Mind","Breath", "Light","Space", "Void","Time", "Heart","Hope", "Life","Doom"], "Just...Fuck That Guy",1, "")); ///lol, no gamzee
    this.premadeFraymotifNames.add(new Fraymotif(["Life", "Doom"], "Grim Fandango",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Mind", "Time", "Doom"], "Timeline Evisceration",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Heart", "Blood"], "Shipping Grades",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Void", "Space", "Rage"], "In Space, No One Can Hear You Scream",1, ""));
    this.premadeFraymotifNames.add(new Fraymotif(["Hope", "Time"], "Hope For The Future",1, ""));

  }
	dynamic getFraymotifName(players, tier){
    var name = this.tryToGetPreMadeName(players);
    if(name){
        //print("Using a premade procedural fraymotif name: " + name + " " + players[0].session.session_id);
        return name; //premade is good enough here. let the called function handle randomness.
    }else{
        name = "";
    }
    var indexOfMusic = players.length-1;  //used to be random now always at end.
    if(players.length == 1){
      indexOfMusic = getRandomInt(0,tier-1);
      for(int i = 0; i<tier; i++){
        String musicWord = "";
        if(i == indexOfMusic) musicWord = this.getRandomMusicWord(players[0].aspect);
        name += this.getRandomNameForAspect(players[0].aspect) + musicWord +" ";
      }
    }else{

      for(num i = 0; i<players.length; i++){
        String musicWord = "";
        if(i == indexOfMusic) musicWord = this.getRandomMusicWord(players[i].aspect);
        name += this.getRandomNameForAspect(players[i].aspect) + musicWord +  " ";
      }
    }
    //print("player length: "+ players.length + " tier: " + tier + " Name: " + name);
    return name;
  }
	dynamic makeFraymotifForPlayerWithFriends(player, helper, tier){
    //if helper, helper is guaranteed to be part of fraymotif.
    var players_involved = [player];
    if(helper) players_involved.add(helper);
    for(num i = 0; i<player.session.players.length; i++){
      var rand = seededRandom();
      var p = player.session.players[i];
      num needed = 0.8;
      if(p.aspect == "Light" || p.aspect == "Blood") needed = 0.6; //light players have to be in the spot light, and blood players just wanna help.
      if(rand > needed && players_involved .indexOf(p) == -1){
        players_involved .add(p); //MATH% chance of adding each additional player
      }
    }
    //print("Made: " + players_involved .length + " player fraymotif in session: " + player.session);
    return this.makeFraymotif(players_involved , tier);
  }
	dynamic findFraymotifNamed(fraymotifs, name){
    for(num i = 0; i<fraymotifs.length; i++){
        if(fraymotifs[i].name == name) return fraymotifs[i];
    }
    return null;
  }
	dynamic makeFraymotif(players, tier){ //asumming first player in that array is the owner of the framotif later on.
    if(players.length == 1 && players[0].class_name == "Waste" && tier == 3){
        //check to see if we are upgrading rocks fall.
        var f = this.findFraymotifNamed(players[0].fraymotifs, "Rocks Fall, Everyone Dies");
        if(f && f.tier < 10){
            f.tier = 99;
            f.baseValue = 9999;
            f.name += " (True Form)";
            f.flavorText = "Incredibly huge meteors rain down from above. What the hell??? Didn't this used to suck?  Hax! I call hax!";
            return f;
        }
    }

    var name = this.getFraymotifName(players, tier);
  	List<dynamic> aspects = [];
  	for(num i = 0; i<players.length; i++){
  		aspects.add(players[i].aspect); //allow fraymotifs tht are things like time/time. doomed time clones need love.
  	}
    name += " (Tier " + tier + ")";
   var f= new Fraymotif(aspects, name, tier);
   f.addEffectsForPlayers(players);
  	return f;
    }

}




    //effects are frozen at creation, basically.  if this fraymotif is created by a Bard of Breath in a session with a Prince of Time,
    //who then dies, and then a combo session results in an Heir of Time being able to use it with the Bard of Breath, then it'll still have the prince effect.
class FraymotifEffect {
	var statName;  //hp heals current hp AND revives the player.
	var target; //self, allies or enemy or enemies, 0, 1, 2, 3
	var damageInsteadOfBuff; // statName can either be applied towards damaging someone or buffing someone.  (damaging self or allies is "healing", buffing enemies is applied in the negative direction.)
	num s = 0;  //convineience methods cause i don't think js has enums but am too lazy to confirm.
	num a = 1;
	num e = 2;
	num e2 = 3;	
	
	String flavorText = ""; // ? is this even used


	FraymotifEffect(this.statName, this.target, this.damageInsteadOfBuff, [this.flavorText  =""]) {}


	void setEffectForPlayer(player){
		var effect = new FraymotifEffect("",this.e, true); //default to just damaging the enemy.
		if(player.class_name == "Knight") effect = getRandomElementFromArray(this.knightEffects());
		if(player.class_name == "Seer") effect = getRandomElementFromArray(this.seerEffects());
		if(player.class_name == "Bard") effect = getRandomElementFromArray(this.bardEffects());
		if(player.class_name == "Heir") effect = getRandomElementFromArray(this.heirEffects());
		if(player.class_name == "Maid") effect = getRandomElementFromArray(this.maidEffects());
		if(player.class_name == "Rogue") effect = getRandomElementFromArray(this.rogueEffects());
		if(player.class_name == "Page") effect = getRandomElementFromArray(this.pageEffects());
		if(player.class_name == "Thief") effect = getRandomElementFromArray(this.thiefEffects());
		if(player.class_name == "Sylph") effect = getRandomElementFromArray(this.sylphEffects());
		if(player.class_name == "Prince") effect = getRandomElementFromArray(this.princeEffects());
		if(player.class_name == "Witch") effect = getRandomElementFromArray(this.witchEffects());
		if(player.class_name == "Mage") effect = getRandomElementFromArray(this.mageEffects());
		this.target = effect.target;
		this.damageInsteadOfBuff = effect.damageInsteadOfBuff;
		this.statName = getRandomElementFromArray(player.associatedStats).name;
	}
	dynamic knightEffects(){
		return [new FraymotifEffect("",this.s,true),new FraymotifEffect("",this.e,true),new FraymotifEffect("",this.e2,true),new FraymotifEffect("",this.s,false),new FraymotifEffect("",this.e,false) ];
	}
	dynamic seerEffects(){
		return [new FraymotifEffect("",this.a,true),new FraymotifEffect("",this.s,false),new FraymotifEffect("",this.e,false),new FraymotifEffect("",this.e2,false),new FraymotifEffect("",this.a,false) ];
	}
	dynamic bardEffects(){
    var ret = [new FraymotifEffect("",this.s,false),new FraymotifEffect("",this.e,false),new FraymotifEffect("",this.e2,false),new FraymotifEffect("",this.a,false) ];
    ret.addAll([new FraymotifEffect("",this.s,true),new FraymotifEffect("",this.e,true),new FraymotifEffect("",this.e2,true),new FraymotifEffect("",this.a,true) ]);
    return ret;
  }
	dynamic heirEffects(){
		return [new FraymotifEffect("",this.s,true),new FraymotifEffect("",this.e2,true),new FraymotifEffect("",this.s,false) ];
	}
	dynamic maidEffects(){
		return [new FraymotifEffect("",this.e2,true),new FraymotifEffect("",this.e,false),new FraymotifEffect("",this.a,false) ];
	}
	dynamic rogueEffects(){
		return [new FraymotifEffect("",this.e,true),new FraymotifEffect("",this.a,false),new FraymotifEffect("",this.e,false)];
	}
	dynamic pageEffects(){
    return [new FraymotifEffect("",this.a,true),new FraymotifEffect("",this.a,false)];
  }
	dynamic thiefEffects(){
    return [new FraymotifEffect("",this.e,true),new FraymotifEffect("",this.s,false),new FraymotifEffect("",this.e,false)];
  }
	dynamic sylphEffects(){
    return [new FraymotifEffect("",this.e,true),new FraymotifEffect("",this.a,false),new FraymotifEffect("",this.e,false)];
  }
	dynamic princeEffects(){
    return [new FraymotifEffect("",this.e,true),new FraymotifEffect("",this.e2,true),new FraymotifEffect("",this.e2,false)];
  }
	dynamic witchEffects(){
    return [new FraymotifEffect("",this.e,true),new FraymotifEffect("",this.s,true),new FraymotifEffect("",this.e2,false)];
  }
	dynamic mageEffects(){
    return [new FraymotifEffect("",this.a,true),new FraymotifEffect("",this.s,true),new FraymotifEffect("",this.e2,false),new FraymotifEffect("",this.e,false)];
  }
	void applyEffect(owner, allies, casters, enemy, enemies, baseValue){
		var strifeValue = this.processEffectValue(casters, enemies);
		var effectValue = baseValue;
		if(strifeValue < baseValue) effectValue = baseValue;
		if(strifeValue > baseValue && strifeValue < (2 * baseValue)) effectValue = 2 *baseValue;
		if(strifeValue > (2* baseValue)) effectValue = 3 *baseValue;

		//now, i need to USE this effect value.  is it doing "damage" or "buffing"?
		if(this.target == this.e || this.target == this.e2) effectValue = effectValue * -1;  //do negative things to the enemy.
		var targetArr = this.chooseTargetArr(owner, allies, casters, enemy, enemies);
    //print(["target chosen: ", targetArr]);
		if(this.damageInsteadOfBuff){
      //print("applying damage: " + targetArr.length);
			this.applyDamage(targetArr, effectValue);
		}else{
      //print("applying buff");
			this.applyBuff(targetArr, effectValue);
		}
	}
	dynamic chooseTargetArr(owner, allies, casters, enemy, enemies){
		//print(["potential targets: ",owner, allies, casters, enemies]);
		if(this.target == this.s) return [owner];
		if(this.target == this.a) return allies;
		if(this.target == this.e) return [enemy]; //all effects target same enemy.
		if(this.target == this.e2) return enemies;
		return null;
	}
	void applyDamage(targetArr, effectValue){
		var e = effectValue/targetArr.length;  //more potent when a single target.
    //print(["applying damage", effectValue, targetArr.length, e]);
		for(num i = 0; i<targetArr.length; i++){
			var t = targetArr[i];
			t.makeAlive();
            t.buffs.add(new Buff("currentHP", e)); //don't mod directly anymore
		}
	}
	void applyBuff(targetArr, effectValue){
		var e = effectValue/targetArr.length; //more potent when a single target.
		for(num i = 0; i<targetArr.length; i++){
			var t = targetArr[i];
			if(this.statName != "RELATIONSHIPS"){
				//t[this.statName] += e;
        t.buffs.add(new Buff(this.statName, e)); //don't mod directly anymore
			}else{
				for(num j = 0; j<t.relationships.length; j++){
					//t.relationships[j].value += e;
          t.buffs.add(new Buff(this.statName, e));
				}
			}
		}
	}
	dynamic processEffectValue(casters, enemies){
		num ret = 0;
		for(num i = 0; i<casters.length; i++ ){
			var tmp = casters[i];
				ret += tmp.getStat(this.statName);
		}

		for(num i = 0; i< enemies.length; i++ ){
			var tmp = enemies[i];
			ret += tmp.getStat(this.statName);
		}
		return ret;
	}
	dynamic toStringSimple(){
    String ret = "";
    if(this.damageInsteadOfBuff && this.target < 2){
			 ret += "a heals";
		}else if (this.damageInsteadOfBuff && this.target >= 2){
			ret += "a damages";
		}else if(!this.damageInsteadOfBuff && this.target < 2){
			ret += "a buffs";
		}else if(!this.damageInsteadOfBuff && this.target >= 2){
			ret += "a debuffs";
		}

		if(this.target == 0){
			ret += " SELF";
		}else if(this.target ==1){
			ret += " FRIENDSBLUH";
		}else if(this.target ==2){
			ret += " EBLUH";
		}else if(this.target ==3){
			ret += " ESBLUHS";
		}

		ret += " of STAT ";

    if(this.target == 0){
      ret += " envelopes the OWNER";
    }else if(this.target ==1){
      ret += " surrounds the allies";
    }else if(this.target ==2){
      ret += " pierces the ENEMY";
    }else if(this.target ==3){
      ret += " surrounds all enemies";
    }
		return ret;
  }
	dynamic toString(){
		String ret = "";
		if(this.damageInsteadOfBuff && this.target < 2){
			 ret += " heals";
		}else if (this.damageInsteadOfBuff && this.target >= 2){
			ret += " damages";
		}else if(!this.damageInsteadOfBuff && this.target < 2){
			ret += " buffs";
		}else if(!this.damageInsteadOfBuff && this.target >= 2){
			ret += " debuffs";
		}

		if(this.target == 0){
			ret += " self";
		}else if(this.target ==1){
			ret += " allies";
		}else if(this.target ==2){
			ret += " an enemy";
		}else if(this.target ==3){
			ret += " all enemies";
		}
    String stat = "STAT";
		ret += " based on how " + stat + " the casters are compared to their enemy";
		return ret;
	}

}
