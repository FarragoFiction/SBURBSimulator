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
    if(this.tier ==3) this.baseValue = 1000;//gods, man

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

	this.getCasters = function(owner, allies){
		//first check to see if all aspects are included in the allies array.
		var casters = [owner];
		var aspects = [];
		var living = findLivingPlayers(allies); //dead men use no fraymotifs. (for now)
		for(var i = 1; i<this.aspects.length; i++){ //skip the first aspect, because that's owner.
			var a = this.aspects[i];
			var p = getRandomElementFromArray(findAllAspectPlayers(allies, a))//ANY player that matches my aspect can do this.
			if(p) casters.push(p); //don't add 'undefined' to this array like a dunkass.
		}
		return casters;  //eventually do smarter things, like only allow to cast buff hp if heals are needed or anybody is dead.
	}

  this.processFlavorText = function(owner, casters, allies, enemy, enemies, revives){
      if(!this.flavorText){
         this.flavorText = this.proceduralFlavorText();
      }
      var phrase = "The CASTERS use FRAYMOTIF. ";//shitty example.
      if(casters.length == 1) phrase = "The CASTERS uses FRAYMOTIF. "
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
    if(statName == "power") return ["strength","power","might"]
    if(statName == "hp") return ["plants","health","vines", "gardens", "stones"]
    if(statName == "RELATIONSHIPS") return ["chains","friendship bracelets","shipping grids", "connections", "hearts", "pulse", "bindings", "rainbows", "care bare stares"]
    if(statName == "mobility") return ["wind","speed","hedgehogs", "whirlwinds", "gales", "hurricanes"]
    if(statName == "sanity") return ["calmness","velvet pillows","sanity", "ripples", "glass", "fuzz"]
    if(statName == "freeWill") return ["electricity","will","open doors"]
    if(statName == "maxLuck") return ["dice","luck","light"]
    if(statName == "minLuck") return ["dice","luck","light"]
    if(statName == "alchemy") return ["inspiration","creativeness","grist", "perfectly generic objects"]
  }

  this.badStatWords = function(statName){
    if(statName == "power") return ["weakness","powerlessness","despair"]
    if(statName == "hp") return ["fragility","rotting plants","disease", "bones", "skulls", "tombstones", "ash", "toxin"]
    if(statName == "RELATIONSHIPS") return ["aggression","broken chains","empty friends lists"]
    if(statName == "mobility") return ["laziness","sloths","pillows", "locks", "weights"]
    if(statName == "sanity") return ["harshwimsies","clowns","fractals", "madness", "tentacles", "rain"]
    if(statName == "freeWill") return ["acceptance","gullibility","closed doors", "gears", "clocks", "prophecy", "static"]
    if(statName == "maxLuck") return ["misfortune","blank books","broken mirrors"]
    if(statName == "minLuck") return ["misfortune","blank books","broken mirrors"]
    if(statName == "alchemy") return ["failure","writer's blocks","monotony"]
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

  this.replaceKeyWordsForFlavorTextBase = function(phrase,){
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
    return ["aura","cloak","shield", "armor", "robe"]
  }

  this.getAlliesWords= function(){
      return ["cloud","mist","fog"]
  }

  this.getEnemyWords = function(){
      return ["lance","spike","laser", "hammer", "shard", "ball", "meteor"]
  }

  this.getEnemiesWords = function(){
      return ["explosion","blast","miasma", "matrix", "deluge", "cascade", "wave", "fleet"]
  }

  this.getDamageWords = function(){
        return ["painful","acidic","sharp", "harmful", "beautiful pony", "fist"];
  }

  this.getDebuffWords = function(){
        return ["draining","malicious", "distracting", "degrading"];
  }

  this.getHealingWords = function(){
    return ["healing","restorative","restful"];
  }

  this.getBuffWords = function(){
    return ["soothing","supportive","friendly", "fortifying", "protecting", "warding", "defensive"];
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

  this.createFraymotifForPlayerDenizen = function(player, name){
    var denizen = player.denizen;
    var f = new Fraymotif([], name + "'s Song", 2); //CAN I have an aspectless fraymotif?
    f.flavorText = " A haunting refrain begins to play. It is the one Desolation plays to keep its instrument in tune. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. "
    //statName, target, damageInsteadOfBuff, flavorText
    var plus = player.getOnlyPositiveAspectAssociatedStats() //buff self and heal
    for(var i = 0; i<plus.length; i++){
      f.effects.push(new FraymotifEffect(plus[i].name,0,true));
      f.effects.push(new FraymotifEffect(plus[i].name,0,false));
    }
    var minus = player.getOnlyNegativeAspectAssociatedStats() //debuff enemy, and damage.
    for(var i = 0; i<minus.length; i++){
      f.effects.push(new FraymotifEffect(minus[i].name,2,true));
      f.effects.push(new FraymotifEffect(minus[i].name,2,false));
    }
    player.denizen.fraymotifs.push(f);
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
      var names = ["Gale", "Feather", "Breathless","Jetstream", "Hurricane", "Tornado"," Kansas", "Breath", "Breeze", "Twister", "Storm", "Wild", "Inhale", "Windy", "Skylark", "Fugue", "Pneumatic", "Wheeze", "Forward", "Vertical", "Whirlwind", "Jetstream"];
      return getRandomElementFromArray(names)
  }

  this.getRandomRageName = function(){
      var names = ["Rage", "Barbaric", "Impossible", "Juggalo","Horrorcore" ,"Madness", "Carnival", "Mirthful", "Screaming", "Berserk", "MoThErFuCkInG", "War", "Haze", "Murder", "Furioso", "Aggressive", "ATBasher", "Violent", "Unbound", "Purple", "Unholy", "Hateful", "Fearful", "Inconceivable", "Impossible"];
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
      var names = ["Undefined", "Void","Disappearification","Pumpkin", "Nothing", "Emptiness", "Invisible", "Dark", "Hole", "Solo", "Silent", "Alone", "Night", "Null", "[Censored]", "[???]", "Vacuous", "Abyss", "Noir", "Blank", "Tenebrous", "Antithesis", "404"];
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

  this.getFraymotifName = function(players, tier){
    var name = "";
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

  //classes is between 0 and aspects.length. each aspect is paired with a class.
  //should there be no class to pair with, random effect based on aspect
  //otherwise, effect is based on both class and aspect
  this.makeFraymotif = function(players,tier){ //asumming first player in that array is the owner of the framotif later on.
    var name = this.getFraymotifName(players, tier);
  	var aspects = [];
  	for(var i = 0; i<players.length; i++){
  		aspects.push(players[i].aspect); //allow fraymotifs tht are things like time/time. doomed time clones need love.
  	}
    name += " ( Tier " + tier + " )"
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
		this.statName = getRandomElementFromArray(player.getOnlyPositiveAspectAssociatedStats()).name; //TODO if I know it's a debuff, maybe debuff the things that are negative for me?
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
