/*
stat effects from a fraymotif are temporary. wear off after battle.
so, players, player snapshots AND gameEntities will have to have an array of applied fraymotifs.
and their getPower, getHP etc stats must use these.
at start AND end of battle (can't be too careful), wipe applied fraymotifs
*/
function Fraymotif(aspects, name,tier, flavorText){
    this.aspects = aspects; //expect to be an array
    this.name = name;
    this.tier = tier;
    this.usable = true; //when used in a fight, switches to false. IMPORTANT: fights should turn it back on when over.
    //flavor text acts as a template, with ENEMIES and CASTERS and ALLIES and ENEMY being replaced.
    //you don't call flavor text directly, instead expecting the use of the fraymotif to return something
    //based on it.
    //make sure ENEMY is the same for all effects, dunkass.
    this.flavorText = flavorText;  //will generate it procedurally if not set, otherwise things like sprites will have it hand made.
    this.used = false; //when start fight, set to false. set to true when used. once per fight
  	this.effects = [];  //each effect is a target, a revive, a statName
  	this.baseValue = 50 * this.tier;
    if(this.tier >=3) this.baseValue = 1000 * this.tier-2;//so a tier 3 is 1000 * 3 -2, or....1000.  But..maybe there is a way to make them even more op???

    this.toString  = function(){
      return this.name;
    }

	this.addEffectsForPlayers = function(players){
		for(var i = 0; i<players.length; i++){
			var effect = new FraymotifEffect();
			effect.setEffectForPlayer(players[i]);
			this.effects.push(effect);
		}
	}

	this.getCastersNoOwner = function(players){
	    var casters = [];
        for(var i = 0; i<this.aspects.length; i++){ //skip the first aspect, because that's owner.
            var a = this.aspects[i];
            var p = getRandomElementFromArray(findAllAspectPlayers(players, a))//ANY player that matches my aspect can do this.
            if(p) casters.push(p); //don't add 'undefined' to this array like a dunkass.
        }
        return casters;  //eventually do smarter things, like only allow to cast buff hp if heals are needed or anybody is dead.

	}

	this.getCasters = function(owner, allies){
		//first check to see if all aspects are included in the allies array.
		var casters = [owner];
		var aspects = [];
		var living = findLivingPlayers(allies); //dead men use no fraymotifs. (for now)
		for(var i = 1; i<this.aspects.length; i++){ //skip the first aspect, because that's owner.
			var a = this.aspects[i];
			var p = getRandomElementFromArray(findAllAspectPlayers(living, a))//ANY player that matches my aspect can do this.
			if(p) casters.push(p); //don't add 'undefined' to this array like a dunkass.
		}
		return casters;  //eventually do smarter things, like only allow to cast buff hp if heals are needed or anybody is dead.
	}

  this.processFlavorText = function(owner, casters, allies, enemy, enemies, revives){
      if(!this.flavorText){
         this.flavorText = this.proceduralFlavorText();
      }
      var phrase = "The CASTERS use FRAYMOTIF. ";//shitty example.
      if(casters.length == 1) phrase = "The CASTERS uses FRAYMOTIF. It damages the ENEMY. "
      phrase += this.flavorText + revives;
      return this.replaceKeyWords(phrase, owner, casters, allies,  enemy, enemies);
  }

  this.proceduralFlavorText = function(){
    var base = this.superCondenseEffectsText();
    return base;
  }

  this.superCondenseEffectsText = function(){
    var effectTypes = {};  //hash coded by effectType damage0 vs damage1 vs buff0. first element is template
    for(var i = 0; i<4; i++){
      effectTypes["damage"+i] = []
      effectTypes["buff"+i] = []
    }
    for(var i = 0; i<this.effects.length; i++){
      var e = this.effects[i];
      if(e.damageInsteadOfBuff){
        if(effectTypes["damage"+ e.target].length == 0)   effectTypes["damage"+ e.target].push(e.toStringSimple())
        //no repeats
        if( effectTypes["damage"+ e.target].indexOf(e.statName) == -1) effectTypes["damage"+ e.target].push(e.statName)
      }else{
        if(effectTypes["buff"+ e.target].length == 0)   effectTypes["buff"+ e.target].push(e.toStringSimple())
        //no repeats
        if( effectTypes["buff"+ e.target].indexOf(e.statName) == -1) effectTypes["buff"+ e.target].push(e.statName)
      }
    }

    //now i have a hash of all effect types and the stats i'm applying to them.
    var retArray = [];
    for(var i = 0; i<4; i++){
      var stats = [];

      if(effectTypes["damage"+i].length > 0){
        stats = effectTypes["damage"+i]
        var template = stats[0];
        stats.removeFromArray(template);
        for(var j = 0; j<stats.length; j++){
          stats[j] = this.getStatWord(stats[j], i); //i is who the target is, j is the stat.
        }
        retArray.push(template.replace(new RegExp("STAT","g"), [stats.slice(0, -1).join(', '), stats.slice(-1)[0]].join(stats.length < 2 ? '' : ' and ')))
      }
      if(effectTypes["buff"+i].length > 0){
        stats = effectTypes["buff"+i]
        var template = stats[0];
        stats.removeFromArray(template);
        for(var j = 0; j<stats.length; j++){
          stats[j] = this.getStatWord(stats[j], i); //i is who the target is, j is the stat.
        }
        retArray.push(template.replace(new RegExp("STAT","g"), [stats.slice(0, -1).join(', '), stats.slice(-1)[0]].join(stats.length < 2 ? '' : ' and ')))
      }

    }
    var almostDone= [retArray.slice(0, -1).join(', '), retArray.slice(-1)[0]].join(retArray.length < 2 ? '' : ' and ')
    almostDone = almostDone.charAt(0).toUpperCase() + almostDone.slice(1) + "."; //sentence it.
    return this.replaceKeyWordsForFlavorTextBase(almostDone);

  }

  this.getStatWord = function(stat, target){
    var bad = true;
    if(target == 0 || target == 1 ) bad = false;
    if(!bad){
       return getRandomElementFromArray(this.goodStatWords(stat))
    }else{
       return getRandomElementFromArray(this.badStatWords(stat))
    }
  }


  this.goodStatWords = function(statName){
    if(statName == "MANGRIT") return ["mangrit","strength","power","might","fire","pure energy","STRENGTH"]
    if(statName == "hp") return ["plants","health","vines", "gardens", "stones","earth","life","moss","fruit","growth"]
    if(statName == "RELATIONSHIPS") return ["chains","friendship bracelets","shipping grids", "connections", "hearts", "pulse", "bindings", "rainbows", "care bare stares", "mirrors"]
    if(statName == "mobility") return ["wind","speed","hedgehogs", "whirlwinds", "gales", "hurricanes","thunder","storms","momentum", "feathers"]
    if(statName == "sanity") return ["calmness","sanity", "ripples", "glass", "fuzz","water","stillness","totally real magic"]
//,"velvet pillows"
    if(statName == "freeWill") return ["electricity","will", "open doors", "possibility", "quantum physics" ,"lightning","sparks","chaos", "broken gears"]
    if(statName == "maxLuck") return ["dice","luck","light","playing cards", "suns","absolute bullshit","card suits", "hope"]
    if(statName == "minLuck") return ["dice","luck","light","playing cards", "suns","absolute bullshit","card suits"]
    if(statName == "alchemy") return ["inspiration","creativeness","grist", "perfectly generic objects","hammers","swords","weapons", "creativity","mist", "engines", "metals"]
  }

  this.badStatWords = function(statName){
    if(statName == "MANGRIT") return ["weakness","powerlessness","despair","wretchedness","misery"]
    if(statName == "hp") return ["fragility","rotting plants","disease", "bones", "skulls", "tombstones", "ash", "toxin","mold", "viruses"]
    if(statName == "RELATIONSHIPS") return ["aggression","broken chains","empty friends lists","sand","loneliness"]
    if(statName == "mobility") return ["laziness", "locks", "weights","manacles","quicksand","gravitons","gravity","ice"]
//"pillows", "sloths",
    if(statName == "sanity") return ["harshwimsies","clowns","fractals", "madness", "tentacles", "rain", "screams", "terror", "nightmares", "mIrAcLeS", "rage","impossible angles","teeth"]
    if(statName == "freeWill") return ["acceptance","gullibility","closed doors", "gears", "clocks", "prophecy", "static","skian clouds"]
    if(statName == "maxLuck") return ["misfortune","blank books","broken mirrors","hexes", "doom", "8ad 8reaks", "disaster", "black cats"]
    if(statName == "minLuck") return ["misfortune","blank books","broken mirrors","hexes", "doom", "8ad 8reaks", "disaster", "black cats"]
    if(statName == "alchemy") return ["failure","writer's blocks","monotony","broken objects","object shards","nails","splinters"]
  }


  //if i have multiple effects that do similar things, condense them.
  this.condenseEffectsText = function(){
        /*
          If two effects both DAMAGE an ENEMY, then I want to generate text where it lists the types of damage.
          “Damages an Enemy based on how WILLFUL, STRONG, CALM, and FAST, the casters are compared to their enemy.”
        */
        //8 main types of effects, damage/buff and 0-4
        var effectTypes = {};  //hash coded by effectType damage0 vs damage1 vs buff0. first element is template
        for(var i = 0; i<4; i++){
          effectTypes["damage"+i] = []
          effectTypes["buff"+i] = []
        }
        for(var i = 0; i<this.effects.length; i++){
          var e = this.effects[i];
          if(e.damageInsteadOfBuff){
            if(effectTypes["damage"+ e.target].length == 0)   effectTypes["damage"+ e.target].push(e.toString())
            //no repeats
            if( effectTypes["damage"+ e.target].indexOf(e.statName) == -1) effectTypes["damage"+ e.target].push(e.statName)
          }else{
            if(effectTypes["buff"+ e.target].length == 0)   effectTypes["buff"+ e.target].push(e.toString())
            if( effectTypes["buff"+ e.target].indexOf(e.statName) == -1) effectTypes["buff"+ e.target].push(e.statName)
          }
        }
        //now i have a hash of all effect types and the stats i'm applying to them.
        var retArray = [];
        for(var i = 0; i<4; i++){
          var stats = [];
          if(effectTypes["damage"+i].length > 0){
            stats = effectTypes["damage"+i]
            var template = stats[0];
            stats.removeFromArray(template);
            retArray.push(template.replace(new RegExp("STAT","g"), [stats.slice(0, -1).join(', '), stats.slice(-1)[0]].join(stats.length < 2 ? '' : ' and ')))
          }
          if(effectTypes["buff"+i].length > 0){
            stats = effectTypes["buff"+i]
            var template = stats[0];
            stats.removeFromArray(template);
            retArray.push(template.replace(new RegExp("STAT","g"), [stats.slice(0, -1).join(', '), stats.slice(-1)[0]].join(stats.length < 2 ? '' : ' and ')));
          }
        }
        return [retArray.slice(0, -1).join(', '), retArray.slice(-1)[0]].join(retArray.length < 2 ? '' : ' and ')

  }

  this.replaceKeyWordsForFlavorTextBase = function(phrase){
    phrase = phrase.replace(new RegExp("damages","g"), getRandomElementFromArray(this.getDamageWords()));
    phrase = phrase.replace(new RegExp("debuffs","g"), getRandomElementFromArray(this.getDebuffWords()));
    phrase = phrase.replace(new RegExp("heals","g"), getRandomElementFromArray(this.getHealingWords()));
    phrase = phrase.replace(new RegExp("buffs","g"), getRandomElementFromArray(this.getBuffWords()));
    phrase = phrase.replace(new RegExp("SELF","g"), getRandomElementFromArray(this.getSelfWords()));
    phrase = phrase.replace(new RegExp("EBLUH","g"), getRandomElementFromArray(this.getEnemyWords()));
    phrase = phrase.replace(new RegExp("FRIENDSBLUH","g"), getRandomElementFromArray(this.getAlliesWords()));
    phrase = phrase.replace(new RegExp("ESBLUHS","g"), getRandomElementFromArray(this.getEnemiesWords()));
    return phrase;
  }

  this.replaceKeyWords = function(phrase, owner, casters, allies, enemy, enemies){
    //ret= ret.replace(new RegExp(this.lettersToReplace[i][0], "g"),replace);
    phrase = phrase.replace(new RegExp("OWNER","g"), owner.htmlTitleHP())
    phrase = phrase.replace(new RegExp("CASTERS","g"), getPlayersTitlesBasic(casters))
    phrase = phrase.replace(new RegExp("ALLIES","g"), getPlayersTitlesBasic(allies))
    phrase = phrase.replace(new RegExp("ENEMY","g"), enemy.htmlTitleHP())
    phrase = phrase.replace(new RegExp("ENEMIES","g"), getPlayersTitlesBasic(enemies))
    phrase = phrase.replace(new RegExp("FRAYMOTIF","g"), this.name)




    return phrase
  }

  this.getSelfWords=function(){
    return ["aura", "cloak", "shield", "armor", "robe", "orbit", "suit", "aegis"]
  }

  this.getAlliesWords= function(){
      return ["cloud", "mist", "fog", "ward", "wall", "blockade", "matrix"]
  }

  this.getEnemyWords = function(){
      return ["lance","spike","laser", "hammer", "shard", "ball", "meteor", "fist","beautiful pony", "cube", "bolt"]
  }

  this.getEnemiesWords = function(){
      return ["explosion","blast","miasma", "matrix", "deluge", "cascade", "wave", "fleet", "illusion"]
  }

  this.getDamageWords = function(){
        return ["painful","acidic","sharp", "harmful", "violent", "murderous", "destructive", "explosive"];
  }

  this.getDebuffWords = function(){
        return ["draining","malicious", "distracting", "degrading", "debuffing", "cursed", "vampiric"];
  }

  this.getHealingWords = function(){
    return ["healing","restorative","restful","rejuvenating","reinforcing"];
  }

  this.getBuffWords = function(){
    return ["soothing","supportive","friendly", "fortifying", "protective", "warding", "defensive","blessed"];
  }

  this.canCast = function(owner, allies, enemies){
    if(!this.usable) return false; //once per fight.
    if(this.aspects.length == 0) return true; //no associated aspect means anyone can cast
    var casters = this.getCasters(owner, allies);
    return (casters.length == this.aspects.length)
  }

  this.makeCastersUnavailable = function(casters){
    for(var i = 0; i<casters.length; i++){
      casters[i].usedFraymotifThisTurn = true;
    }
  }


	//allies is NOT just who is helping to cast the fraymotif. it is everyone.
	this.useFraymotif = function(owner, allies, enemies){
    if(!this.canCast(owner, allies, enemies)) return;
		var casters = this.getCasters(owner, allies);
    this.makeCastersUnavailable(casters);
    //Hope Rides Alone
    if(owner.aspect == "Hope" && allies.length == 1 && Math.seededRandom() > 0.85){
        enemies[0].buffs.push(new Buff("currentHP", -9999)) //they REALLY believed in this attack.
        var jakeisms = ["GADZOOKS!","BOY HOWDY!","TALLY HO!","BY GUM"];
        console.log("Hope Rides Alone in session: "  + owner.session.session_id)
        var scream =  getFontColorFromAspect(owner.aspect) + getRandomElementFromArray(jakeisms) + "</font>"
        return " [HOPE RIDES ALONE] is activated. " + owner.htmlTitle() +  " starts screaming. <br><br><span class = 'jake'> " + scream + " </span>  <Br><Br> Holy fucking SHIT, that is WAY MORE DAMAGE then is needed. Jesus christ. Someone nerf that Hope player already!"
    }
    var dead = findDeadPlayers(allies);
		//console.log(casters);
    //ALL effects that target a single enemy target the SAME enemy.
    var enemy = getRandomElementFromArray(enemies);
		for(var i = 0; i<this.effects.length; i++){
			//effect knows how to apply itself. pass it baseValue.
			this.effects[i].applyEffect(owner, allies, casters,  enemy, enemies, this.baseValue);
		}
    var revives = "";
    if(dead.length > findDeadPlayers(allies).length){
      revives = " Also, the " + getPlayersTitlesBasic(dead) + " being dead is no longer a thing. ";
    }
    enemy.currentHP += -1 * owner.getStat("power"); //also, do at LEAST as much as a regular attack, dunkass.
    return this.processFlavorText(owner, casters,allies, enemy, enemies, revives);
	}
}



//no global functions any more. bad pastJR.
function FraymotifCreator(){
    //some types of fraymotifs, that are otherwise procedurally generated, should have stupid pun names. they are kept here.
    this.premadeFraymotifNames = [];
  this.createFraymotifForPlayerDenizen = function(player, name){
    var denizen = player.denizen;
    var f = new Fraymotif([], name + "'s " + this.getDenizenFraymotifNameFromAspect(player.aspect), 2); //CAN I have an aspectless fraymotif?
    f.flavorText = this.getDenizenFraymotifDescriptionForAspect(player.aspect);

    //statName, target, damageInsteadOfBuff, flavorText
    var plus = player.associatedStats //buff self and heal. used to be only positive, but that gave witches/sylphs/princes/bards the shaft
    for(var i = 0; i<plus.length; i++){
      f.effects.push(new FraymotifEffect(plus[i].name,0,true));
      f.effects.push(new FraymotifEffect(plus[i].name,0,false));
    }
    var minus = player.associatedStats //debuff enemy, and damage. used to be only negative, but that gave witches/sylphs/princes/bards the shaft
    for(var i = 0; i<minus.length; i++){
      f.effects.push(new FraymotifEffect(minus[i].name,2,true));
      f.effects.push(new FraymotifEffect(minus[i].name,2,false));
    }
    player.denizen.fraymotifs.push(f);
  }

  this.getDenizenFraymotifNameFromAspect = function(aspect){
      var ret = "";
      if(aspect == "Blood"){
          ret = "Ballad " //a song passed over generations in an oral history
      }else if(aspect == "Mind"){
        ret = "Fugue"  //a musical core that is altered and changed and interwoven with itself. Also, a mental state of confusion and loss of identity  (alternate selves that made different choices)
      }else if(aspect == "Rage"){
         ret = " Aria" // a musical piece full of emotion
      }else if(aspect == "Void"){
         ret = "Silence" //
      }else if(aspect == "Time"){
         ret = "Canon" //a musical piece in which a section is repeated (but unchanged) at different times, layered until it's unreconizable  (stable time loops)
      }else if(aspect == "Heart"){
        ret = "Leitmotif" //a musical theme representing a particular character
      }else if(aspect == "Breath"){
        ret = "Refrain"
      }else if(aspect == "Light"){
        ret = "Opera" //lol, cuz light players never shut up
      }else if(aspect == "Space"){
        ret = "Sonata" //a composition for a soloist.  Space players are stuck doing something different from everyone,
      }else if(aspect == "Hope"){
        ret = "Etude" //a musical exercise designed to improve the performer
      }else if(aspect == "Life"){
        ret = "Lament" //passionate expression of grief. so much life has been lost to SBURB.
      }else if(aspect == "Doom"){
        ret = "Dirge" //a song for the dead
      }else{
        ret = "Song"
      }
      return ret;
  }

  this.getDenizenFraymotifDescriptionForAspect = function(aspect){
      var ret = "";
      if(aspect == "Blood"){
          ret = " A sour note is produced. It's the one Agitation plays to make its audience squirm. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. "
      }else if(aspect == "Mind"){
        ret = " A fractured chord is prepared. It is the one Regret plays to make insomnia reign. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. "
      }else if(aspect == "Rage"){
         ret = " A hsirvprmt xslri begins to tryyvi. It is the one Madness plays gl pvvk rgh rmhgifnvmg rm gfmv. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And yes, The OWNER know you're watching them. "
      }else if(aspect == "Void"){
         ret = " A yawning silence rings out. It is the NULL Reality sings to keep the worlds on their dance. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. "
      }else if(aspect == "Time"){
         ret = "  A sun skips on a groove its tracing 'round the earth, the one-two beat Despair plays to turn cause and effect meaningless. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is/was/will be to say on the matter. "
      }else if(aspect == "Heart"){
        ret = " A chord begins to echo. It is the one Damnation will play at their brith. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. "
      }else if(aspect == "Breath"){
        ret = " A haunting refrain begins to play. It is the one Desolation plays to keep its instrument in tune. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. "
      }else if(aspect == "Light"){
        ret = " A beautiful opera begins to be performed. It starts to really pick up around Act 4. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. "
      }else if(aspect == "Space"){
        ret = " An echoing note is plucked. It is the one Isolation plays to chart the depths of reality. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. "
      }else if(aspect == "Hope"){
        ret = " A resounding hootenanny begins to play. It is the one Irony performs to remember the past. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. "
      }else if(aspect == "Life"){
        ret = " A plucked note echos in the stillness. It is the one Desire plays to summon it's audience. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. "
      }else if(aspect == "Doom"){
        ret = " A slow dirge begins to play. It is the one Death plays to keep in practice. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. "
      }else{
        ret = " A haunting refrain begins to play. It is the one Desolation plays to keep its instrument in tune. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. "
      }

      return ret;
  }

  this.getUsableFraymotifs = function(owner, allies, enemies){
    var fraymotifs = owner.fraymotifs;
    var ret = [];
    for(var i = 0; i<fraymotifs.length; i++){
      if(fraymotifs[i].canCast(owner, allies, enemies)) ret.push(fraymotifs[i]);
    }
    //console.log("Found: " + ret.length + " usable fraymotifs for " + owner)
    return ret;
  }

  this.getRandomBreathName = function(){
      var names = ["Gale", "Wiznado", "Feather", "Lifting", "Breathless","Jetstream", "Hurricane", "Tornado"," Kansas", "Breath", "Breeze", "Twister", "Storm", "Wild", "Inhale", "Windy", "Skylark", "Fugue", "Pneumatic", "Wheeze", "Forward", "Vertical", "Whirlwind", "Jetstream"];
      return getRandomElementFromArray(names)
  }

  this.getRandomRageName = function(){
      var names = ["Rage", "Barbaric", "Impossible", "Tantrum", "Juggalo","Horrorcore" ,"Madness", "Carnival", "Mirthful", "Screaming", "Berserk", "MoThErFuCkInG", "War", "Haze", "Murder", "Furioso", "Aggressive", "ATBasher", "Violent", "Unbound", "Purple", "Unholy", "Hateful", "Fearful", "Inconceivable", "Impossible"];
      return getRandomElementFromArray(names)
  }

  this.getRandomLifeName = function(){
      var names = ["Life" ,"Pastoral", "Green", "Relief", "Healing", "Plant", "Vitality", "Growing", "Garden", "Multiplying", "Rising", "Survival", "Phoenix", "Respawn", "Mangrit", "Animato", "Gaia", "Increasing", "Overgrowth", "Jungle", "Harvest", "Lazarus"];
      return getRandomElementFromArray(names)
  }

  this.getRandomHopeName = function(){
      var names = ["Hope","Fake", "Belief", "Bullshit", "Determination", "Burn", "Stubborn", "Religion", "Will", "Hero", "Undying", "Dream", "Sepulchritude", "Prophet", "Apocryphal"];
      return getRandomElementFromArray(names)
  }

  this.getRandomVoidName = function(){
      var randBonus = "<span class = 'void'>" + getRandomElementFromArray(interests) +  "</span>"
      var names = ["Undefined", "untitled.mp4", "Void","Disappearification","Pumpkin", "Nothing", "Emptiness", "Invisible", "Dark", "Hole", "Solo", "Silent", "Alone", "Night", "Null", "[Censored]", "[???]", "Vacuous", "Abyss", "Noir", "Blank", "Tenebrous", "Antithesis", "404"];
      return getRandomElementFromArray(names)+ randBonus;
  }

  this.getRandomLightName = function(){
      var names = ["Lucky", "Light", "Knowledge", "Blinding", "Brilliant", "Break", "Blazing", "Glow", "Flare", "Gamble", "Omnifold", "Apollo", "Helios", "Scintillating", "Horseshoe", "Leggiero", "Star", "Kindle", "Gambit", "Blaze"];
      return getRandomElementFromArray(names)
  }

  this.getRandomMindName = function(){
      var names = ["Mind", "Modulation", "Shock", "Awe", "Coin", "Judgement", "Mind", "Decision", "Spark", "Path", "Trial", "Variations", "Thunder", "Logical", "Telekinetic", "Brainiac", "Hysteria", "Deciso", "Thesis", "Imagination",  "Psycho", "Control", "Execution", "Bolt"];
      return getRandomElementFromArray(names)
  }

  this.getRandomHeartName = function(){
      var names = ["Heart","Soul", "Jazz", "Blues", "Spirit", "Splintering", "Clone", "Self", "Havoc", "Noble", "Animus", "Astral", "Shatter", "Breakdown", "Ethereal", "Beat", "Pulchritude"];
      return getRandomElementFromArray(names)
  }

  this.getRandomBloodName = function(){
      var names = ["Blood", "Trigger","Chain", "Flow", "Charge", "Awakening", "Ichorial", "Friendship", "Trusting", "Clotting", "Union", "Bleeding", "Team", "Transfusion", "Pulse", "Sanguine", "Positive", "Negative", "Cruor", "Vim", "Chorus", "Iron", "Ichorial", "Fever", "Heat"];
      return getRandomElementFromArray(names)
  }

  this.getRandomDoomName = function(){
      var names = ["Dark", "Broken", "Meteoric", "Diseased","Fate", "Doomed", "Inevitable", "Doom", "End", "Final", "Dead", "Ruin", "Rot", "Coffin", "Apocalypse", "Morendo", "Smorzando", "~Ath", "Armistyx", "Grave", "Corpse", "Ashen", "Reaper", "Diseased", "Armageddon", "Cursed"];
      return getRandomElementFromArray(names)
  }

  this.getRandomTimeName = function(){
      var names = ["Time","Paradox", "Chrono", "Moment", "Foregone", "Reset", "Endless", "Temporal", "Shenanigans", "Clock", "Tick-Tock", "Spinning", "Repeat", "Rhythm", "Redshift",  "Epoch", "Beatdown", "Slow", "Remix", "Clockwork", "Lock", "Eternal"];
      return getRandomElementFromArray(names)
  }

  this.getRandomSpaceName = function(){
      var names = ["Canon","Space","Frogs", "Location", "Spatial", "Universe", "Infinite", "Spiral", "Physics", "Star", "Galaxy", "Nuclear", "Atomic", "Nucleus", "Horizon", "Event", "CROAK", "Spatium", "Squiddle", "Engine", "Meteor", "Gravity", "Crush"];
      return getRandomElementFromArray(names)
  }

  this.getRandomNameForAspect = function(aspect){
    var ret = "";
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
    if(ret == "") ret = "Null";
    return getFontColorFromAspect(aspect) + ret + "</font>"
  }

  this.getRandomMusicWord = function(aspect){ //takes in an aspect for color
    var names = ["Fortississimo", "Leitmotif", "Liberetto", "Sarabande", "Serenade", "Anthem", "Crescendo", "Vivace", "Encore", "Vivante", "Allegretto", "Fugue", "Choir", "Nobilmente", "Hymn", "Eroico", "Chant", "Mysterioso", "Diminuendo", "Perdendo", "Staccato", "Allegro", "Caloroso", "Nocturne"];
    names = names.concat(["Cadenza", "Cadence", "Waltz", "Concerto", "Finale", "Requiem", "Coda", "Dirge", "Battaglia", "Leggiadro", "Capriccio", "Presto", "Largo", "Accelerando", "Polytempo", "Overture", "Reprise", "Orchestra"])

    var ret = getRandomElementFromArray(names);
    if(Math.seededRandom() > 0.5){
      return "<span style='color:" + getColorFromAspect(aspect) + "'>" + ret.toLowerCase()+"</span>";  //tacked onto existin word
    }else{
      return " " + ret; //extra word
    }
  }

  //if the creator's list of fraymotifs is empty, create it.
  //return null with 50% chance. (don't want EVERY tier 2 light fraymotif to be called the same thing)
  //look through array of premade fraymotifs and see if players can cast the fraymotif.
  //if they can, return name of fraymotif.
  this.tryToGetPreMadeName = function(players){
    if(Math.seededRandom() > 0.5) return; //just use the procedural name.

    if(this.premadeFraymotifNames.length == 0) this.initializePremadeNames();
    for(var i = 0; i<this.premadeFraymotifNames.length; i++){
        var f = this.premadeFraymotifNames[i];
        var casters = f.getCastersNoOwner(players);
        if (casters.length == f.aspects.length) return f.name;
    }
    return null;
  }

  this.initializePremadeNames = function(){
    this.premadeFraymotifNames = [];
    this.premadeFraymotifNames.push(new Fraymotif(["Light", "Mind"], "Blinded By The Light",1, ""))
		this.premadeFraymotifNames.push(new Fraymotif(["Light", "Heart"], "Total Eclipse of the Heart",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Breath", "Time"], "Stop, Hammertime",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Breath", "Hope"], "Wings of Freedom",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Doom", "Hope"], "Happy Ending",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Space", "Time"], "Adagio Redshift",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Life", "Time"], "Time Heals All Wounds",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Heart", "Doom"], "Madrigal Melancholia",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Space", "Time", "Breath", "Light"], "Canon in HS Major",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Life", "Void", "Heart", "Hope"], "Canon in HS Minor",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Doom", "Time"], "Another One Bites The Dust",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Hope", "Time"], "Maybe Someday",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Mind", "Space"], "Mind Over Matter",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Space", "Life"], "Extraterrestrial Ensemble",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Life", "Time"], "Lifetime Special",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Space", "Breath"], "Air on a Cosmic String",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Breath", "Void"], "Rhapsody in Blue",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Mind", "Breath"], "Brainstorm",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Space", "Void"], "Spaced Out",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Hope", "Light"], "Look On The Bright Side",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Light", "Void"], "Lights Out",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Hope", "Void"], "Lost Hope",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Light", "Hope"], "Grandiose Illuminations",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Hope", "Void"], "Lost Hope",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Rage", "Light", "Heart"], "Flipping the Light Fantastic",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Heart", "Void"], "Hotel California",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Hope", "Heart"], "Feel Good",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Heart", "Void", "Space"], "Heart's Not In It",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Mind", "Breath"], "Freedom of Thought",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Doom", "Rage"], "Brick in The Wall",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Blood", "Doom", "Life"], "Ancestral Awakening",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Doom", "Time"], "You're Gonna Have a Bad Time",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Doom", "Hope"], "I Hope You Die",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Rage", "Breath"], "Free Rage Chicken",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Time", "Rage"], "Gears of War",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Breath", "Void"], "You Suck",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Light", "Breath"], "Apollo's Chariot",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Space", "Hope"], "Planck Fandango",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Breath", "Life"], "Emancipation Proclamation",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Space", "Void"], "Glass Half Empty",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Blood", "Hope", "Mind"], "It's Raining Zen (Hallelujah)",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Light", "Space"], "She Blinded Me With Science",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Time", "Life", "Blood"], "Never Gonna Let You Down",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Doom", "Breath"], "Bad Breath",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Rage", "Blood"], "Opposites Attract",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Life", "Doom", "Heart", "Space"], "Life and Death and Love and Birth",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Breath", "Doom"], "Freedom is Slavery",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Breath", "Time", "Space"], "Alternate Universe",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Void", "Life"], "Tangle Buddies",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Breath", "Hope"], "Let's Pierce the Heavens",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Void", "Time"], "Volatile Times",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Space", "Void"], "Mom's Spaghettification",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Rage", "Doom", "Light"], "Kill the Light",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Doom", "Light"], "Deadly Laser",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Blood", "Mind","Breath", "Light","Space", "Void","Time", "Heart","Hope", "Life","Doom"], "Just...Fuck That Guy",1, "")) ///lol, no gamzee
    this.premadeFraymotifNames.push(new Fraymotif(["Life", "Doom"], "Grim Fandango",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Mind", "Time", "Doom"], "Timeline Evisceration",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Heart", "Blood"], "Shipping Grades",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Void", "Space", "Rage"], "In Space, No One Can Hear You Scream",1, ""))
    this.premadeFraymotifNames.push(new Fraymotif(["Hope", "Time"], "Hope For The Future",1, ""))

  }

  this.getFraymotifName = function(players, tier){
    var name = this.tryToGetPreMadeName(players);
    if(name){
        //console.log("Using a premade procedural fraymotif name: " + name + " " + players[0].session.session_id)
        return name; //premade is good enough here. let the called function handle randomness.
    }else{
        name = "";
    }
    var indexOfMusic = players.length-1;  //used to be random now always at end.
    if(players.length == 1){
      indexOfMusic = getRandomInt(0,tier-1);
      for(var i = 0; i < tier; i++){
        var musicWord = "";
        if(i == indexOfMusic) musicWord = this.getRandomMusicWord(players[0].aspect);
        name += this.getRandomNameForAspect(players[0].aspect) + musicWord +" ";
      }
    }else{

      for(var i = 0; i<players.length; i++){
        var musicWord = "";
        if(i == indexOfMusic) musicWord = this.getRandomMusicWord(players[i].aspect);
        name += this.getRandomNameForAspect(players[i].aspect) + musicWord +  " ";
      }
    }
    //console.log("player length: "+ players.length + " tier: " + tier + " Name: " + name)
    return name;
  }

  this.makeFraymotifForPlayerWithFriends = function(player, helper, tier){
    //if helper, helper is guaranteed to be part of fraymotif.
    var players_involved = [player];
    if(helper) players_involved.push(helper);
    for(var i = 0; i<player.session.players.length; i++){
      var rand = Math.seededRandom();
      var p = player.session.players[i];
      var needed = 0.8
      if(p.aspect == "Light" || p.aspect == "Blood") needed = 0.6; //light players have to be in the spot light, and blood players just wanna help.
      if(rand > needed && players_involved .indexOf(p) == -1){
        players_involved .push(p); //MATH% chance of adding each additional player
      }
    }
    //console.log("Made: " + players_involved .length + " player fraymotif in session: " + player.session)
    return this.makeFraymotif(players_involved , tier);
  }

  this.findFraymotifNamed = function(fraymotifs, name){
    for(var i = 0; i<fraymotifs.length; i++){
        if(fraymotifs[i].name == name) return fraymotifs[i];
    }
    return null;
  }

  //classes is between 0 and aspects.length. each aspect is paired with a class.
  //should there be no class to pair with, random effect based on aspect
  //otherwise, effect is based on both class and aspect
  this.makeFraymotif = function(players,tier){ //asumming first player in that array is the owner of the framotif later on.
    if(players.length == 1 && players[0].class_name == "Waste" && tier == 3){
        //check to see if we are upgrading rocks fall.
        var f = this.findFraymotifNamed(players[0].fraymotifs, "Rocks Fall, Everyone Dies")
        if(f && f.tier < 10){
            f.tier = 99;
            f.baseValue = 9999;
            f.name += " (True Form)"
            f.flavorText = "Incredibly huge meteors rain down from above. What the hell??? Didn't this used to suck?  Hax! I call hax!";
            return f;
        }
    }

    var name = this.getFraymotifName(players, tier);
  	var aspects = [];
  	for(var i = 0; i<players.length; i++){
  		aspects.push(players[i].aspect); //allow fraymotifs tht are things like time/time. doomed time clones need love.
  	}
    name += " (Tier " + tier + ")"
   var f= new Fraymotif(aspects, name, tier);
   f.addEffectsForPlayers(players);
  	return f;
    }
}


    //effects are frozen at creation, basically.  if this fraymotif is created by a Bard of Breath in a session with a Prince of Time,
    //who then dies, and then a combo session results in an Heir of Time being able to use it with the Bard of Breath, then it'll still have the prince effect.
function FraymotifEffect(statName, target, damageInsteadOfBuff, flavorText){
	this.statName = statName;  //hp heals current hp AND revives the player.
	this.target = target; //self, allies or enemy or enemies, 0, 1, 2, 3
	this.damageInsteadOfBuff = damageInsteadOfBuff; // statName can either be applied towards damaging someone or buffing someone.  (damaging self or allies is "healing", buffing enemies is applied in the negative direction.)
	this.s = 0;  //convineience methods cause i don't think js has enums but am too lazy to confirm.
	this.a = 1;
	this.e = 2;
	this.e2 = 3;

	this.setEffectForPlayer = function(player){
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
		if(player.associatedStats.length > 0){
		    this.statName = getRandomElementFromArray(player.associatedStats).name;
		}else{
		    this.statName = "MANGRIT"
		}

	}

	//preliminary design detailed here: https://docs.google.com/spreadsheets/d/1kam2FnKJiek6DidDpQdSnR3Wl9-vk1oZBa0pPpxlJk4/edit#gid=0
	//knights protect themselves and hurt the enemy
	this.knightEffects = function(){
		return [new FraymotifEffect("",this.s,true),new FraymotifEffect("",this.e,true),new FraymotifEffect("",this.e2,true),new FraymotifEffect("",this.s,false),new FraymotifEffect("",this.e,false) ];
	}

  //seers guide everyone to victory
  this.seerEffects = function(){
		return [new FraymotifEffect("",this.a,true),new FraymotifEffect("",this.s,false),new FraymotifEffect("",this.e,false),new FraymotifEffect("",this.e2,false),new FraymotifEffect("",this.a,false) ];
	}

  //bards are lol random.
  this.bardEffects = function(){
    var ret = [new FraymotifEffect("",this.s,false),new FraymotifEffect("",this.e,false),new FraymotifEffect("",this.e2,false),new FraymotifEffect("",this.a,false) ];
    ret = ret.concat(ret = [new FraymotifEffect("",this.s,true),new FraymotifEffect("",this.e,true),new FraymotifEffect("",this.e2,true),new FraymotifEffect("",this.a,true) ]);
    return ret;
  }

  //their aspect protects them
  this.heirEffects = function(){
		return [new FraymotifEffect("",this.s,true),new FraymotifEffect("",this.e2,true),new FraymotifEffect("",this.s,false) ];
	}

  //maids balance offense and defense???
  this.maidEffects = function(){
		return [new FraymotifEffect("",this.e2,true),new FraymotifEffect("",this.e,false),new FraymotifEffect("",this.a,false) ];
	}

  //debuff enemies, buff party, attack enemy
  this.rogueEffects = function(){
		return [new FraymotifEffect("",this.e,true),new FraymotifEffect("",this.a,false),new FraymotifEffect("",this.e,false)];
	}

  //pure support, heal allies, buff allies
  this.pageEffects = function(){
    return [new FraymotifEffect("",this.a,true),new FraymotifEffect("",this.a,false)];
  }

  //debuff enemy, buff self, damage enemy
  this.thiefEffects = function(){
    return [new FraymotifEffect("",this.e,true),new FraymotifEffect("",this.s,false),new FraymotifEffect("",this.e,false)];
  }

  //heals allies, buffs self and allies
  this.sylphEffects = function(){
    return [new FraymotifEffect("",this.e,true),new FraymotifEffect("",this.a,false),new FraymotifEffect("",this.e,false)];
  }

  //destruction
  this.princeEffects = function(){
    return [new FraymotifEffect("",this.e,true),new FraymotifEffect("",this.e2,true),new FraymotifEffect("",this.e2,false)];
  }

  //heal self, hurt enemy, debuff enemies
  this.witchEffects = function(){
    return [new FraymotifEffect("",this.e,true),new FraymotifEffect("",this.s,true),new FraymotifEffect("",this.e2,false)];
  }

  //debuff enemies heal allies
  this.mageEffects = function(){
    return [new FraymotifEffect("",this.a,true),new FraymotifEffect("",this.s,true),new FraymotifEffect("",this.e2,false),new FraymotifEffect("",this.e,false)];
  }



	this.applyEffect = function(owner,allies, casters,  enemy, enemies, baseValue){
		var strifeValue = this.processEffectValue(casters, enemies);
		var effectValue = baseValue;
		if(strifeValue < baseValue) effectValue = baseValue;
		if(strifeValue > baseValue && strifeValue < (2 * baseValue)) effectValue = 2 *baseValue;
		if(strifeValue > (2* baseValue)) effectValue = 3 *baseValue;

		//now, i need to USE this effect value.  is it doing "damage" or "buffing"?
		if(this.target == this.e || this.target == this.e2) effectValue = effectValue * -1;  //do negative things to the enemy.
		var targetArr = this.chooseTargetArr(owner, allies, casters, enemy, enemies);
    //console.log(["target chosen: ", targetArr])
		if(this.damageInsteadOfBuff){
      //console.log("applying damage: " + targetArr.length)
			this.applyDamage(targetArr, effectValue);
		}else{
      //console.log("applying buff")
			this.applyBuff(targetArr, effectValue);
		}
	}

	this.chooseTargetArr = function(owner, allies, casters, enemy, enemies){
		//console.log(["potential targets: ",owner, allies, casters, enemies]);
		if(this.target == this.s) return [owner];
		if(this.target == this.a) return allies;
		if(this.target == this.e) return [enemy]; //all effects target same enemy.
		if(this.target == this.e2) return enemies;
	}

	//targetArr is always an array, even if only 1 thing inside of it.
	this.applyDamage = function(targetArr, effectValue){
		var e = effectValue/targetArr.length;  //more potent when a single target.
    //console.log(["applying damage", effectValue, targetArr.length, e])
		for(var i = 0; i<targetArr.length; i++){
			var t = targetArr[i];
			t.makeAlive();
            t.buffs.push(new Buff("currentHP", e)) //don't mod directly anymore
		}
	}

	this.applyBuff = function(targetArr, effectValue){
		var e = effectValue/targetArr.length; //more potent when a single target.
		for(var i = 0; i<targetArr.length; i++){
			var t = targetArr[i];
			if(this.statName != "RELATIONSHIPS"){
				//t[this.statName] += e;
        t.buffs.push(new Buff(this.statName, e)) //don't mod directly anymore
			}else{
				for(var j = 0; j<t.relationships.length; j++){
					//t.relationships[j].value += e;
          t.buffs.push(new Buff(this.statName, e))
				}
			}
		}
	}

	this.processEffectValue = function(casters, enemies){
		var ret = 0;
		for(var i = 0; i<casters.length; i++ ){
			var tmp = casters[i];
				ret += tmp.getStat(this.statName)
		}

		for(var i = 0; i< enemies.length; i++ ){
			var tmp = enemies[i];
			ret += tmp.getStat(this.statName)
		}
		return ret;
	}

  this.toStringSimple = function(){
    var ret = "";
    if(this.damageInsteadOfBuff && this.target < 2){
			 ret += "a heals"
		}else if (this.damageInsteadOfBuff && this.target >= 2){
			ret += "a damages"
		}else if(!this.damageInsteadOfBuff && this.target < 2){
			ret += "a buffs"
		}else if(!this.damageInsteadOfBuff && this.target >= 2){
			ret += "a debuffs"
		}

		if(this.target == 0){
			ret += " SELF"
		}else if(this.target ==1){
			ret += " FRIENDSBLUH"
		}else if(this.target ==2){
			ret += " EBLUH"
		}else if(this.target ==3){
			ret += " ESBLUHS"
		}

		ret += " of STAT "

    if(this.target == 0){
      ret += " envelopes the OWNER"
    }else if(this.target ==1){
      ret += " surrounds the allies"
    }else if(this.target ==2){
      ret += " pierces the ENEMY"
    }else if(this.target ==3){
      ret += " surrounds all enemies"
    }
		return ret;
  }

	this.toString = function(){
		var ret = "";
		if(this.damageInsteadOfBuff && this.target < 2){
			 ret += " heals"
		}else if (this.damageInsteadOfBuff && this.target >= 2){
			ret += " damages"
		}else if(!this.damageInsteadOfBuff && this.target < 2){
			ret += " buffs"
		}else if(!this.damageInsteadOfBuff && this.target >= 2){
			ret += " debuffs"
		}

		if(this.target == 0){
			ret += " self"
		}else if(this.target ==1){
			ret += " allies"
		}else if(this.target ==2){
			ret += " an enemy"
		}else if(this.target ==3){
			ret += " all enemies"
		}
    var stat = "STAT"
		ret += " based on how " + stat + " the casters are compared to their enemy"
		return ret;
	}
}
