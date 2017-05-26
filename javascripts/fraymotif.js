
function Fraymotif(aspects, name,tier){
    this.aspects = aspects; //expect to be an array
    this.name = name;
    this.tier = tier;
    this.used = false; //when start fight, set to false. set to true when used. once per fight

    this.toString  = function(){
      return this.name;
    }
}


//no global functions any more. bad pastJR.
function FraymotifCreator(session){
  this.session = session;


  this.getRandomBreathName = function(){
      var names = ["Gale","Breathless","Jetstream", "Hurricane", "Tornado"," Kansas", "Breath", "Breeze", "Twister", "Storm", "Wild", "Inhale", "Windy", "Skylark", "Pneumatic", "Wheeze", "Forward", "Vertical", "Whirlwind", "Jetstream"];
      return getRandomElementFromArray(names)
  }

  this.getRandomRageName = function(){
      var names = ["Rage", "Impossible", "Juggalo","Horrorcore" ,"Madness", "Carnival", "Mirthful", "Screaming", "Berserk", "MoThErFuCkInG", "War", "Haze", "Murder", "Furioso", "Aggressive", "ATBasher", "Violent", "Unbound", "Purple", "Unholy", "Hateful", "Fearful", "Inconceivable", "Impossible"];
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
      var names = ["Void","Pumpkin", "Nothing", "Emptiness", "Invisible", "Dark", "Hole", "Solo", "Silent", "Alone", "Night", "Null", "[Censored]", "[???]", "Vacuous", "Abyss", "Noir", "Blank", "Tenebrous", "Antithesis", "404"];
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
      var names = ["Dark", "Diseased","Fate", "Doomed", "Inevitable", "Doom", "End", "Final", "Dead", "Ruin", "Rot", "Coffin", "Apocalypse", "Morendo", "Smorzando", "~Ath", "Armistyx", "Grave", "Corpse", "Ashen", "Reaper", "Diseased", "Armageddon", "Cursed"];
      return getRandomElementFromArray(names)
  }

  this.getRandomTimeName = function(){
      var names = ["Time","Paradox", "Temporal", "Shenanigans", "Clock", "Tick-Tock", "Spinning", "Repeat", "Rhythm", "Redshift",  "Epoch", "Beatdown", "Slow", "Remix", "Clockwork", "Lock", "Eternal"];
      return getRandomElementFromArray(names)
  }

  this.getRandomSpaceName = function(){
      var names = ["Canon","Space","Frogs", "Location", "Spatial", "Universe", "Infinite", "Spiral", "Physics", "Star", "Galaxy", "Nuclear", "Atomic", "Nucleus", "Horizon", "Event", "CROAK", "Spatium", "Squiddle", "Engine", "Meteor", "Gravity", "Crush"];
      return getRandomElementFromArray(names)
  }

  this.getRandomNameForAspect = function(aspect){
    console.log(aspect);
    if(aspect == "Blood") return this.getRandomBloodName();
    if(aspect == "Mind") return this.getRandomMindName();
    if(aspect == "Rage") return this.getRandomRageName();
    if(aspect == "Time") return this.getRandomTimeName();
    if(aspect == "Void") return this.getRandomVoidName();
    if(aspect == "Heart") return this.getRandomHeartName();
    if(aspect == "Breath") return this.getRandomBreathName();
    if(aspect == "Light") return this.getRandomLightName();
    if(aspect == "Space") return this.getRandomSpaceName();
    if(aspect == "Hope") return this.getRandomHopeName();
    if(aspect == "Life") return this.getRandomLifeName();
    if(aspect == "Doom") return this.getRandomDoomName();
  }

  this.getRandomMusicWord = function(){
    var names = ["Fortississimo", "Crescendo", "Vivace", "Encore", "Vivante", "Allegretto", "Fugue", "Choir", "Nobilmente", "Hymn", "Eroico", "Chant", "Mysterioso", "Diminuendo", "Perdendo", "Staccato", "Allegro", "Caloroso", "Nocturne"];
    names = names.concat(["Cadenza", "Cadence". "Waltz", "Concerto", "Finale", "Requiem", "Coda", "Dirge", "Battaglia", "Leggiadro", "Capriccio", "Presto", "Largo", "Accelerando", "Polytempo", "Overture", "Reprise", "Orchestra"])

    var ret = getRandomElementFromArray(names);
    if(Math.seededRandom() > 0.5){
      return ret.toLowerCase();  //tacked onto existin word
    }else{
      return " " + ret; //extra word
    }
  }

  //a tier1 fraymotif of 1 aspect has exactly 1 name. otherwise, 1 name per aspect.
  //tier 2 has 2 names, or number of aspects
  //tier 3 has 3 names, or number of aspects.
  this.makeFraymotif = function(aspects,tier){
    var name = "";
    var indexOfMusic = getRandomInt(0,aspects.length-1);
    if(aspects.length == 1){
      indexOfMusic = getRandomInt(0,tier-1);
      for(var i = 0; i < tier; i++){
        var musicWord = "";
        if(i == indexOfMusic) musicWord = this.getRandomMusicWord();
        name += this.getRandomNameForAspect(aspects[0]) + musicWord +" ";
      }
    }else{

      for(var i = 0; i<aspects.length; i++){
        var musicWord = "";
        if(i == indexOfMusic) musicWord = this.getRandomMusicWord();
        name += this.getRandomNameForAspect(aspects[i]) + musicWord +  " ";
      }
    }
    return new Fraymotif(aspects, name, tier);
  }
}
