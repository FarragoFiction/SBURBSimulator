
function Fraymotif(aspects, name,tier){
    this.aspects = aspects; //expect to be an array
    this.name = name;
    this.tier = tier;

    this.toString  = function(){
      return this.name;
    }
}


//no global functions any more. bad pastJR.
function FraymotifCreator(session){
  this.session = session;


  this.getRandomBreathName = function(){
      var names = ["Gale", "Hurricane", "Tornado"," Kansas", "Breath", "Breeze", "Twister", "Storm", "Capriccio", "Wild", "Inhale", "Leggiadro", "Windy", "Skylark", "Pneumatic", "Wheeze", "Forward", "Vertical", "Whirlwind", "Jetstream"];
      return getRandomElementFromArray(names)
  }

  this.getRandomNameForAspect = function(aspect){
    console.log(aspect);
    if(aspect == "Breath"){
      return this.getRandomBreathName();
    }
  }

  //a tier1 fraymotif of 1 aspect has exactly 1 name. otherwise, 1 name per aspect.
  //tier 2 has 2 names, or number of aspects
  //tier 3 has 3 names, or number of aspects.
  this.makeFraymotif = function(aspects,tier){
    var name = "";
    if(aspects.length == 1){
      for(var i = 0; i < tier; i++){
        name += this.getRandomNameForAspect(aspects[0]) + " ";
      }
    }else{
      for(var i = 0; i<aspects.length; i++){
        name += this.getRandomNameForAspect(aspects[i]) + " ";
      }
    }
    return new Fraymotif(aspects, name, tier);
  }
}
