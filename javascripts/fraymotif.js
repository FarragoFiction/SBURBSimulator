/*
stat effects from a fraymotif are temporary. wear off after battle.
so, players, player snapshots AND gameEntities will have to have an array of applied fraymotifs.
and their getPower, getHP etc stats must use these.
at start AND end of battle (can't be too careful), wipe applied fraymotifs
*/
function Fraymotif(aspects, name,tier){
    this.aspects = aspects; //expect to be an array
    this.name = name;
    this.tier = tier;
    this.used = false; //when start fight, set to false. set to true when used. once per fight
	this.effects = [];  //each effect is a target, a revive, a statName
	this.baseDamage = 50 * this.tier;
	if(this.tier == 3) this.baseDamage = 1000;


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
	
	this.conditionsMet = function(allies, enemies){
		//first check to see if all aspects are included in the allies array.
		for(var i = 0; i<this.aspects.length; i++){
			
		}
		return false;  //eventually do smarter things, like only allow to cast buff hp if heals are needed or anybody is dead.
	}
	
	//allies is NOT just who is helping to cast the fraymotif. it is everyone.
	this.useFraymotif = function(allies, enemies){
		console.log("TODO: calculate  damage by all statName values for all involved users - all involved enemies ")
		//if only targeting one ally or one enemy, how do you pick? if ally best friend, if enemy, strongest enemy? (if hp boost, instead pick ally with lowest hp (or dead)).
		/*
			base damage * 1, 2, or 3 for each stat. 
			
			for each stat, sum the values of the stat for allies, and subtract the values for the stat for the enemies.
			if final value < baseDamage, damage = baseDaamge.  if final > base < 2Base, damage = 2base;  if final > 2base, damage = 3base;
			
			STATNAME is always used, btw.  Either it is directly the thing being buffed or debuffed, or if damage it is what is used for damage calc.
			This DOES mean that buffing hp is the same thing as damage/healing. whatever.
			
			
		*/
		
		console.log("TODO: also don't forget that some fraymotifs should have triggers (but think most shouldn't now). don't try to heal or revive if it's not needed, dunkass.")
	}
}


//no global functions any more. bad pastJR.
function FraymotifCreator(session){
  this.session = session;


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
      var names = ["Void","Disappearification","Pumpkin", "Nothing", "Emptiness", "Invisible", "Dark", "Hole", "Solo", "Silent", "Alone", "Night", "Null", "[Censored]", "[???]", "Vacuous", "Abyss", "Noir", "Blank", "Tenebrous", "Antithesis", "404"];
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
      var names = ["Blood", "Chain", "Flow", "Charge", "Awakening", "Ichorial", "Friendship", "Trusting", "Clotting", "Union", "Bleeding", "Team", "Transfusion", "Pulse", "Sanguine", "Positive", "Negative", "Cruor", "Vim", "Chorus", "Iron", "Ichorial", "Fever", "Heat"];
      return getRandomElementFromArray(names)
  }

  this.getRandomDoomName = function(){
      var names = ["Dark", "Broken", "Meteoric", "Diseased","Fate", "Doomed", "Inevitable", "Doom", "End", "Final", "Dead", "Ruin", "Rot", "Coffin", "Apocalypse", "Morendo", "Smorzando", "~Ath", "Armistyx", "Grave", "Corpse", "Ashen", "Reaper", "Diseased", "Armageddon", "Cursed"];
      return getRandomElementFromArray(names)
  }

  this.getRandomTimeName = function(){
      var names = ["Time","Paradox", "Moment", "Foregone", "Reset", "Endless", "Temporal", "Shenanigans", "Clock", "Tick-Tock", "Spinning", "Repeat", "Rhythm", "Redshift",  "Epoch", "Beatdown", "Slow", "Remix", "Clockwork", "Lock", "Eternal"];
      return getRandomElementFromArray(names)
  }

  this.getRandomSpaceName = function(){
      var names = ["Canon","Space","Frogs", "Location", "Spatial", "Universe", "Infinite", "Spiral", "Physics", "Star", "Galaxy", "Nuclear", "Atomic", "Nucleus", "Horizon", "Event", "CROAK", "Spatium", "Squiddle", "Engine", "Meteor", "Gravity", "Crush"];
      return getRandomElementFromArray(names)
  }

  this.getRandomNameForAspect = function(aspect){
    console.log(aspect);
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
        if(i == indexOfMusic) musicWord = this.getRandomMusicWord(players[i].aspect);
        name += this.getRandomNameForAspect(players[0].aspect) + musicWord +" ";
      }
    }else{

      for(var i = 0; i<players.length; i++){
        var musicWord = "";
        if(i == indexOfMusic) musicWord = this.getRandomMusicWord(players[i].aspect);
        name += this.getRandomNameForAspect(players[i].aspect) + musicWord +  " ";
      }
    }
    return name;
  }

  //classes is between 0 and aspects.length. each aspect is paired with a class.
  //should there be no class to pair with, random effect based on aspect
  //otherwise, effect is based on both class and aspect
  this.makeFraymotif = function(players,tier){
    var name = this.getFraymotifName(players, tier);
	var aspects = [];
	for(var i = 0; i<players.length; i++){
		if(aspects.indexOf(players[i].aspect) == -1) aspects.push(players[i].aspect); //if multiple of the same aspect is included here, just ignore. 
	}
    var f= new Fraymotif(aspects, name, tier);
	f.addEffectsForPlayers(players);
	return f;
  }
}


    //effects are frozen at creation, basically.  if this fraymotif is created by a Bard of Breath in a session with a Prince of Time,
    //who then dies, and then a combo session results in an Heir of Time being able to use it with the Bard of Breath, then it'll still have the prince effect.
function FraymotifEffect(statName, target, damageInsteadOfBuff){
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
		this.target = effect.target;
		this.damageInsteadOfBuff = effect.damageInsteadOfBuff;
		this.statName = getRandomElementFromArray(player.getOnlyPositiveAspectAssociatedStats()).name;
	}
	
	//preliminary design detailed here: https://docs.google.com/spreadsheets/d/1kam2FnKJiek6DidDpQdSnR3Wl9-vk1oZBa0pPpxlJk4/edit#gid=0
	//knights protect themselves and hurt the enemy
	this.knightEffects = function(){
		return [new FraymotifEffect("",this.s,true),new FraymotifEffect("",this.e,true),new FraymotifEffect("",this.e2,true),new FraymotifEffect("",this.s,false),new FraymotifEffect("",this.e,false) ];
	}
	
	this.toString = function(){
		var ret = "";
		if(this.damageInsteadOfBuff && this.target < 2){
			 ret += " Heals"
		}else if (this.damageInsteadOfBuff && this.target >= 2){
			ret += " Damages"
		}else if(!this.damageInsteadOfBuff && this.target < 2){
			ret += " Buffs"
		}else if(!this.damageInsteadOfBuff && this.target >= 2){
			ret += " Debuffs"
		}
		
		if(this.target == 0){
			ret += " Self"
		}else if(this.target ==1){
			ret += " Allies"
		}else if(this.target ==2){
			ret += " An Enemy"
		}else if(this.target ==3){
			ret += " All Enemies"
		}
		
		ret += " Based On " + this.statName
		return ret;
	}
}