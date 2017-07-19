part of SBURBSim;
//most of these are just so I can say "is this a type of npc" and not any real functionality
//might be the wrong way to do this. can refactor later. they will have more functionality as time goes on, tho.

class NPC extends GameEntity {
  NPC(String name, num id, Session session) : super(name, id, session);
}

//carapaces are the only things that can be crowned and have it give anything but fraymotifs.
class Carapace extends NPC {
  Carapace(String name, num id, Session session) : super(name, id, session);
}

class Underling extends NPC {
  Underling(String name, num id, Session session) : super(name, id, session);
}

//naknaknaknaknaknak my comments are talking to me!
class Consort extends NPC {
  Consort(String name, num id, Session session) : super(name, id, session);
}

//denizens are spawned with innate knowledge of a personal fraymotif.
//TODO eventually put this logic here instead of in player, and have mechanism for
//creating a denizen live here in a static method.
class Denizen extends NPC {
  Denizen(String name, num id, Session session) : super(name, id, session);
}

class DenizenMinion extends NPC {
  DenizenMinion(String name, num id, Session session)
      : super(name, id, session);
}

class PotentialSprite extends NPC {
  String helpPhrase = "provides the requisite amount of gigglesnort hideytalk to be juuuust barely helpful. ";
  num helpfulness = 0;
  bool armless = false;
  bool disaster = false;
  bool illegal = false; //maybe AR won't help players with ILLEGAL sprites?
  PotentialSprite(String name, num id, Session session): super(name, id, session);
}

//eventually guardians/lusii will DEFINITELY behave different
class Lusus extends PotentialSprite {
  Lusus(String name, num id, Session session) : super(name, id, session);
}



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																												 //
//																												 //
//		AND NOW IT'S TIME TO MAKE A SHIT TON OF GAME ENTITITES TO POSSIBLY SHOVE INTO SPRITES		             //
//																												 //
//																												 //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
sooooo...things that go in sprites are gameEntities. Just like jack/Queen/King. And Denizens. Keep. Keep thinking about this.
*/

//make a fuck ton of sprites here. don't need to reinit for sessions because these entitites are never used directly. instead, stuck into a sprite that player has,
//or into ring/scepter.
//an objects stats are zero unless otherwise stated.
//don't bother allocating memory for objects, just leave in array.

//seperate 'cause of witches and bad luck and good luck
//DinceJof -  you prototype your kernel sprite with the ashes of your ancestor. They used to be a SBURB player like you, until they took a scratch to the timeline.

var disastor_objects = [
  new PotentialSprite(
      "First Guardian", 0, null) //also a custom fraymotif.
    ..disaster = true
    ..setStatsHash(
        {"hp": 1000, "currentHP": 1000, "mobility": 500, "power": 250})
    ..helpPhrase =
        "is fairly helpful with the teleporting and all, but when it speaks- Wow. No. That is not ok. "
    ..fraymotifs.add(new Fraymotif([], "Atomic Teleport Spam", 3)
      ..effects.add(new FraymotifEffect("mobility", 0, false))
      ..effects.add(new FraymotifEffect("mobility", 2, true))
      ..flavorText =
          " The OWNER shimers with radioactive stars, and then teleports behind the ENEMY, sneak-attacking them. "),
  new PotentialSprite("Horror Terror", 0, null) //vast glub
    ..setStatsHash({"hp": 500, "currentHP": 500, "freeWill": 250, "power": 150})
    ..disaster = true
    ..helpPhrase =
        "... Oh god. What is going on. Why does just listening to it make your ears bleed!? "
    ..fraymotifs.add(new Fraymotif([], "Vast Glub", 3)
      ..effects.add(new FraymotifEffect("freeWill", 3, true))
      ..flavorText =
          " A galaxy spanning glub damages everyone. The only hope of survival is to spread the damage across so many enemies that everyone only takes a manageable amount. "),
  new PotentialSprite(
      "Speaker of the Furthest Ring", 0, null) //vast glub
    ..disaster = true
    ..setStatsHash(
        {"hp": 1000, "currentHP": 1000, "freeWill": 250, "power": 250})
    ..helpPhrase =
        "whispers madness humankind was not meant to know. Its words are painful, hateful, yet… tempting. It speaks of flames and void, screams and gods. "
    ..fraymotifs.add(new Fraymotif([], "Vast Glub", 3)
      ..effects.add(new FraymotifEffect("freeWill", 3, true))
      ..flavorText =
          " A galaxy spanning glub damages everyone. The only hope of survival is to spread the damage across so many enemies that everyone only takes a manageable amount. "),
  new PotentialSprite(
      "Clown", 0, null) //custom fraymotif: can' keep down the clown (heal).
    ..disaster = true
    ..setStatsHash({
      "hp": 1000,
      "currentHP": 1000,
      "minLuck": -250,
      "maxLuck": 250,
      "power": 100
    })
    ..helpfulness = -1
    ..helpPhrase = "goes hehehehehehehehehehehehehehehehehehehehehehehehehehe. "
    ..fraymotifs.add(new Fraymotif([], "Can't Keep Down The Clown", 3)
      ..effects.add(new FraymotifEffect("sanity", 0, false))
      ..effects.add(new FraymotifEffect("sanity", 0, true))
      ..flavorText =
          " You are pretty sure it is impossible for Clwons to die. "),
  new PotentialSprite("Puppet", 0, null)
    ..disaster = true
    ..setStatsHash({
      "hp": 500,
      "currentHP": 500,
      "freeWill": 250,
      "mobility": 250,
      "minLuck": -250,
      "maxLuck": 250,
      "sanity": 250,
      "power": 100
    })
    ..helpPhrase =
        "is the most unhelpful piece of shit in the world. Oh my god, just once. Please, just shut up. "
    ..helpfulness = -1
    ..fraymotifs.add(new Fraymotif([], "Hee Hee Hee Hoo!", 3)
      ..effects.add(new FraymotifEffect("sanity", 3, false))
      ..effects.add(new FraymotifEffect("sanity", 3, true))
      ..flavorText = " Oh god! Shut up! Just once! Please shut up! "),
  new PotentialSprite("Xenomorph", 0, null) //custom fraymotif: acid blood
    ..disaster = true
    ..setStatsHash({"hp": 500, "currentHP": 500, "mobility": 250, "power": 100})
    ..fraymotifs.add(new Fraymotif([], "Spawning", 3)
      ..effects.add(new FraymotifEffect("alchemy", 3, true))
      ..flavorText =
          " Oh god. Where are all those baby monsters coming from. They are everywhere! Fuck! How are they so good at biting??? "),
  new PotentialSprite(
      "Deadpool", 0, null) //TODO: eventually dead pool gives you one gnosis rank
    ..disaster = true
    ..setStatsHash({
      "hp": 500,
      "currentHP": 500,
      "mobility": 250,
      "minLuck": -250,
      "maxLuck": 250,
      "power": 100
    })
    ..helpfulness = 1
    ..helpPhrase =
        "demonstrates that when it comes to providing fourth wall breaking advice to getting through quests and killing baddies, he is pretty much the best there is. "
    ..fraymotifs.add(new Fraymotif([], "Degenerate Regeneration", 3)
      ..effects.add(new FraymotifEffect("hp", 0, true))
      ..flavorText =
          " Hey there, Observer! Want to see a neat trick? POW! Grew my own head back. Pretty cool, huh? (Now if only JR would let me spam this or make it be castable even while dead, THEN we'd be cooking with petrol) "),
  new PotentialSprite(
      "Dragon", 0, null) //custom fraymotif: mighty breath.
    ..disaster = true
    ..setStatsHash({"hp": 500, "currentHP": 500, "power": 100})
    ..helpPhrase = "breathes fire and offers condescending, yet useful advice. "
    ..fraymotifs.add(new Fraymotif([], "Mighty Fire Breath", 3)
      ..effects.add(new FraymotifEffect("power", 3, true))
      ..flavorText =
          " With a mighty breath, OWNER spits all the fires, sick and otherwise."),
  new PotentialSprite("Teacher", 0, null)
    ..disaster = true
    ..setStatsHash({"hp": 500, "currentHP": 500, "power": 100})
    ..helpfulness = -1
    ..helpPhrase =
        "dials the sprites natural tendency towards witholding information to have you 'figure it out yourself' up to eleven. "
    ..fraymotifs.add(new Fraymotif([], "Lecture", 3)
      ..effects.add(new FraymotifEffect("freeWill", 3, false))
      ..effects.add(new FraymotifEffect("sanity", 3, false))
      ..flavorText =
          " OWNER begins a 3 part lecture on why you should probably just give up. It is hypnotic in it's ceaselessness."),
  new PotentialSprite("Fiduspawn", 0, null)
    ..disaster = true
    ..setStatsHash({"hp": 500, "currentHP": 500, "power": 100})
    ..fraymotifs.add(new Fraymotif([], "Spawning", 3)
      ..effects.add(new FraymotifEffect("alchemy", 3, true))
      ..flavorText =
          " Oh god. Where are all those baby monsters coming from. They are everywhere! Fuck! How are they so good at biting??? "),
  new PotentialSprite("Doll", 0, null)
    ..disaster = true
    ..setStatsHash({"hp":500,"currentHP": 500, "power": 100})
    ..helpfulness = -1
    ..helpPhrase =
        "stares creepily. It never moves when you're watching it. It's basically the worst, and that's all there is to say on that topic. "
    ..fraymotifs.add(new Fraymotif([], "Disconcerting Ogle", 3)
      ..effects.add(new FraymotifEffect("sanity", 3, false))
      ..effects.add(new FraymotifEffect("sanity", 0, true))
      ..flavorText =
          " OWNER is staring at ENEMY. It makes you uncomfortable, the way they are just standing there. And watching.  "),
  new PotentialSprite("Zombie", 0, null)
    ..disaster = true
    ..setStatsHash({"hp":500,"currentHP": 500, "power": 100})
    ..fraymotifs.add(new Fraymotif([], "Rise From The Grave", 3)
      ..effects.add(new FraymotifEffect("hp", 0, true))
      ..flavorText =
          " You thought the OWNER was pretty hurt, but instead they are just getting going. "),
  new PotentialSprite("Demon", 0, null)
    ..disaster = true
    ..setStatsHash({"hp":500,"currentHP": 500,"freeWill": 250, "power": 250})
    ..fraymotifs.add(new Fraymotif([], "Claw Claw MotherFuckers", 3)
      ..effects.add(new FraymotifEffect("power", 2, true))
      ..effects.add(new FraymotifEffect("power", 2, true))
      ..flavorText = " The OWNER slashes at the ENEMY twice. "),
  new PotentialSprite("Monster", 0, null)
    ..disaster = true
    ..setStatsHash({"hp":500,"currentHP": 500,"sanity":-250, "maxLuck": 250, "power": 100})
    ..fraymotifs.add(new Fraymotif([], "Claw Claw MotherFuckers", 3)
      ..effects.add(new FraymotifEffect("power", 2, true))
      ..effects.add(new FraymotifEffect("power", 2, true))
      ..flavorText = " The OWNER slashes at the ENEMY twice. "),
  new PotentialSprite("Vampire", 0, null)
    ..disaster = true
    ..setStatsHash({"hp":500,"currentHP": 500, "mobility":250, "power": 100})
    ..fraymotifs.add(new Fraymotif([], "I Vant to Drink Your Blood", 3)
      ..effects.add(new FraymotifEffect("hp", 2, true))
      ..effects.add(new FraymotifEffect("hp", 0, true)) //damage you, heal self.
      ..flavorText = " The OWNER drains HP from the ENEMY. "),
  new PotentialSprite("Pumpkin", 0, null)
    ..disaster = true
    ..setStatsHash({"hp":500,"currentHP": 500, "mobility":5000, "minLuck":-250, "maxLuck": 5000, "power": 100})
    ..helpPhrase =
        "was kind of helpful, and then kind of didn’t exist. Please don’t think too hard about it, the simulation is barely handling a pumpkin sprite as is. "
    ..fraymotifs.add(new Fraymotif([], "What Pumpkin???", 3)
      ..effects.add(new FraymotifEffect("mobility", 2, false))
      ..effects.add(new FraymotifEffect("mobility", 3, true))
      ..flavorText =
          " Everyone tries to hit the OWNER until suddenly they have never been there at all, causing attacks to miss so catastrophically they backfire. "),
  new PotentialSprite("Werewolf", 0, null)
    ..disaster = true
    ..setStatsHash({"hp":500,"currentHP": 500, "sanity":-250, "power": 100})
    ..fraymotifs.add(new Fraymotif([], "Grim Bark Slash Attack", 3)
      ..effects.add(new FraymotifEffect("power", 2, true))
      ..effects.add(new FraymotifEffect("power", 2, true))
      ..flavorText =
          " The OWNER slashes at the ENEMY twice. While being a werewolf. "),
  new PotentialSprite("Monkey", 0, null) //just, fuck monkeys in general.
    ..disaster = true
    ..helpfulness = -1
    ..setStatsHash({"hp":5,"currentHP": 5, "mobility":5000, "minLuck":-5000, "maxLuck": -5000, "power": 100})
    ..helpPhrase = "actively inteferes with quests. Just. Fuck monkeys. "
    ..fraymotifs.add(new Fraymotif([], "Monkey Business", 3)
      ..effects.add(new FraymotifEffect("mobility", 0, false))
      ..effects.add(new FraymotifEffect("mobility", 2, true))
      ..flavorText =
          " The OWNER uses their monkey like fastness to attack the ENEMY just way too fucking many times. "),
];

//fortune
var fortune_objects = [
  new PotentialSprite("Frog", 0,null)
    ..illegal = true
    ..setStatsHash({"mobility":100, "power": 10})
    ..helpPhrase =
        "provides the requisite amount of gigglesnort  hideytalk to be fairly useful, AND the underlings seem to go after it first! Bonus! ",
  new PotentialSprite("Lizard",0, null)
    ..setStatsHash({"power": 20})
    ..illegal = true
    ..helpPhrase =
        "provides the requisite amount of gigglesnort  hideytalk to be fairly useful, AND the underlings seem to go after it first! Bonus! ",
  new PotentialSprite("Salamander",0, null)
    ..illegal = true
    ..setStatsHash({"hp":500,"currentHP": 500, "power": 20})
    ..helpPhrase =
        "provides the requisite amount of gigglesnort  hideytalk to be fairly useful, AND the underlings seem to go after it first! Bonus! ",
  new PotentialSprite("Iguana",0, null)
    ..illegal = true
    ..helpPhrase =
        "provides the requisite amount of gigglesnort  hideytalk to be fairly useful, AND the underlings seem to go after it first! Bonus! ",
  new PotentialSprite("Crocodile",0, null)
    ..illegal = true
    ..setStatsHash("power": 50})
    ..helpPhrase =
        "provides the requisite amount of gigglesnort  hideytalk to be fairly useful, AND the underlings seem to go after it first! Bonus! ",
  new PotentialSprite("Turtle",0, null)
    ..illegal = true
    ..setStatsHash({"mobility":-100, "power": 20})
    ..helpPhrase =
        "provides the requisite amount of gigglesnort  hideytalk to be fairly useful, AND the underlings seem to go after it first! Bonus! ",
  new PotentialSprite("Alligator", 0,null)
    ..setStatsHash({"hp":500,"currentHP": 500, "mobility":100, "power": 50})
    ..illegal = true
    ..helpPhrase =
        "provides the requisite amount of gigglesnort  hideytalk to be fairly useful, AND the underlings seem to go after it first! Bonus! ",
  new PotentialSprite("Snake",0, null) //poison fraymotif
    ..power = 50
    ..armless = true
    ..setStatsHash({"hp":500,"currentHP": 500, "mobility":100, "power": 10})
    ..illegal = true
    ..helpPhrase =
        "providessss the requisssssite amount of gigglessssssnort hideytalk to be jusssssst barely helpful. AND the underlings seem to go after it first! Bonus! ",
  new PotentialSprite("Axolotl", 0,null) //apparently real ones are good at regeneration?
    ..power = 20
    ..hp = 50
    ..currentHP = 50
    ..illegal = true
    ..helpPhrase =
        "provides the requisite amount of gigglesnort  hideytalk to be fairly useful, AND the underlings seem to go after it first! Bonus! ",
  new PotentialSprite("Newt",0, null)
    ..power = 20
    ..illegal = true
    ..helpPhrase =
        "provides the requisite amount of gigglesnort  hideytalk to be fairly useful, AND the underlings seem to go after it first! Bonus! ",
];

//////////////////////lusii are a little stronger in general
List<dynamic> lusus_objects = [
  new Lusus(null, "Hoofbeast", null)
    ..power = 30
    ..lusus = true,
  new Lusus(null, "Meow Beast", null)
    ..power = 30
    ..lusus = true
    ..minLuck = 20
    ..maxLuck = 20
    ..helpPhrase =
        "is kind of helpful? Maybe? You can't tell if it loves their player or hates them. ",
  new Lusus(null, "Bark Beast", null)
    ..power = 40
    ..lusus = true
    ..helpPhrase =
        "alternates between loud, insistent barks and long, eloquent monologues on the deeper meaning behind each and every fragment of the game. ",
  new Lusus(null, "Nut Creature", null)
    ..power = 30
    ..mobility = 30
    ..lusus = true,
  new Lusus(null, "Gobblefiend", null)
    ..power = 50 //turkeys are honestly terrifying.
    ..lusus = true
    ..helpfulness = -1
    ..helpPhrase =
        "is the most unhelpful piece of shit in the world. Oh my god, just once. Please, just shut up. ",
  new Lusus(null, "Bicyclops", null) //laser fraymotif?
    ..power = 30
    ..lusus = true,
  new Lusus(null, "Centaur", null)
    ..power = 50
    ..sanity = 50 //lusii in the butler genus simply are unflappable.
    ..lusus = true,
  new Lusus(null, "Fairy Bull", null)
    ..power = 1 //kinda useless. like a small dog or something.
    ..lusus = true,
  new Lusus(null, "Slither Beast", null)
    ..power = 30
    ..lusus = true
    ..armless = true,
  new Lusus(null, "Wiggle Beast", null)
    ..power = 30
    ..lusus = true,
  new Lusus(null, "Honkbird", null)
    ..power = 30
    ..lusus = true,
  new Lusus(null, "Dig Beast", null)
    ..power = 30
    ..lusus = true,
  new Lusus(null, "Cholerbear", null)
    ..power = 50
    ..lusus = true,
  new Lusus(null, "Antler Beast", null)
    ..power = 30
    ..mobility = 30
    ..lusus = true,
  new Lusus(null, "Ram Beast", null)
    ..power = 30
    ..lusus = true,
  new Lusus(null, "Crab", null)
    ..power = 30
    ..lusus = true,
  new Lusus(null, "Spider", null)
    ..power = 30
    ..lusus = true,
  new Lusus(null, "Thief Beast", null)
    ..power = 30
    ..lusus = true,
  new Lusus(null, "March Bug", null)
    ..power = 30
    ..lusus = true,
  new Lusus(null, "Nibble Vermin", null)
    ..power = 30
    ..lusus = true,
  new Lusus(null, "Woolbeast", null)
    ..power = 30
    ..lusus = true,
  new Lusus(null, "Hop Beast", null)
    ..power = 30
    ..maxLuck = 30
    ..lusus = true,
  new Lusus(null, "Stink Creature", null)
    ..power = 30
    ..lusus = true,
  new Lusus(null, "Speed Beast", null)
    ..power = 30
    ..mobility = 50
    ..lusus = true,
  new Lusus(null, "Jump Creature", null)
    ..power = 30
    ..lusus = true,
  new Lusus(null, "Fight Beast", null)
    ..power = 50
    ..lusus = true,
  new Lusus(null, "Claw Beast", null)
    ..power = 50
    ..lusus = true,
  new Lusus(null, "Tooth Beast", null)
    ..power = 50
    ..lusus = true,
  new Lusus(null, "Armor Beast", null)
    ..power = 30
    ..currentHP = 100
    ..hp = 100
    ..lusus = true,
  new Lusus(null, "Trap Beast", null)
    ..power = 30
    ..lusus = true,
];

////////////////////////sea lusii

List<dynamic> sea_lusus_objects = [
  new Lusus(null, "Zap Beast", null) //zap fraymotif
    ..power = 50
    ..lusus = true,
  new Lusus(null, "Sea Slither Beast", null)
    ..power = 30
    ..lusus = true
    ..armless = true,
  new Lusus(null, "Electric Beast", null) //zap fraymotif
    ..power = 50
    ..lusus = true
    ..armless = true,
  new Lusus(null, "Whale", null)
    ..power = 30
    ..currentHP = 50
    ..hp = 50
    ..lusus = true
    ..armless = true,
  new Lusus(null, "Sky Horse", null)
    ..power = 30
    ..mobility = 20
    ..lusus = true,
  new Lusus(null, "Sea Meow Beast", null)
    ..power = 30
    ..lusus = true
    ..minLuck = -20
    ..maxLuck = 20,
  new Lusus(null, "Sea Hoofbeast", null)
    ..power = 30
    ..lusus = true,
  new Lusus(null, "Cuttlefish", null)
    ..power = 30
    ..lusus = true,
  new Lusus(null, "Swim Beast", null)
    ..power = 30
    ..lusus = true,
  new Lusus(null, "Sea Goat", null)
    ..power = 30
    ..lusus = true
    ..minLuck = 30
    ..maxLuck = 20,
  new Lusus(null, "Light Beast", null)
    ..power = 30
    ..lusus = true,
  new Lusus(null, "Dive Beast", null)
    ..power = 30
    ..lusus = true,
  new Lusus(null, "Honkbird", null)
    ..power = 30
    ..lusus = true,
  new Lusus(null, "Sea Bear", null)
    ..power = 30
    ..lusus = true,
  new Lusus(null, "Sea Armorbeast", null)
    ..power = 30
    ..lusus = true
    ..currentHP = 50
    ..hp = 50,
];

//regular
List<dynamic> prototyping_objects = [
  new PotentialSprite(null, "Buggy As Fuck Retro Game", null)
    ..power = 20
    ..corrupted = true //no stats, just corrupted. maybe a fraymotif later.
    ..helpPhrase =
        "provides painful, painful sound file malfunctions, why is this even a thing? ",

  new PotentialSprite(null, "Robot", null)
    ..hp = 100
    ..currentHP = 100
    ..helpfulness = 1
    ..helpPhrase =
        "is <b>more</b> useful than another player. How could a mere human measure up to the awesome logical capabilities of a machine? "
    ..freeWill = 100
    ..power = 100,

  new PotentialSprite(null, "Golfer", null)
    ..power = 20
    ..helpfulness = 1
    ..minLuck = 20
    ..maxLuck = 20
    ..helpPhrase =
        "provides surprisingly helpful advice, even if they do insist on calling all enemies ‘bogeys’. ",

  new PotentialSprite(null, "Dutton", null)
    ..hp = 10
    ..currentHP = 10
    ..power = 10
    ..helpfulness = 1
    ..helpPhrase = "provides transcendent wisdom. "
    ..freeWill = 50
    ..mobility = 50
    ..minLuck = 50
    ..maxLuck = 50
    ..fraymotifs.add(new Fraymotif([], "Duttobliteration", 2)
      ..effects.add(new FraymotifEffect("freeWill", 2, true))
      ..flavorText =
          " The ENEMY is obliterated. Probably. A watermark of Charles Dutton appears, stage right. "),

  new PotentialSprite(null, "Game Bro", null)
    ..power = 20
    ..helpfulness = 1
    ..helpPhrase =
        "provides rad as fuck tips and tricks for beating SBURB and getting mad snacks, yo. 5 out of 5 hats. ",

//in joke, lol, google always reports that sessions are crashed. google is a horror terror (see tumblr)
  new PotentialSprite(null, "Google", null)
    ..power = 20
    ..helpfulness = 1
    ..corrupted = true
    ..helpPhrase =
        "sure knows a lot about everything, but why does it only seem to return results about crashing SBURB?",

  new PotentialSprite(null, "Game Grl", null)
    ..power = 20
    ..helpfulness = 1
    ..helpPhrase =
        "provides rad as fuck tips and tricks for beating SBURB and getting mad snacks, yo, but, like, while also being a GIRL? *record scratch*  5 out of 5 lady hats. ",

  new PotentialSprite(null, "Paperclip", null)
    ..power = 20
    ..helpfulness = -1
    ..helpPhrase =
        "says: 'It looks like you're trying to play a cosmic game where you breed frogs to create a universe. Would you like me to'-No. 'Would you like me to'-No! 'It looks like you're'-shut up!!! This is not helpful.",

  new PotentialSprite(null, "WebComicCreator", null)
    ..power = 20
    ..helpfulness = -1
    ..helpPhrase =
        "refuses to explain anything about SBURB to you, prefering to let you speculate wildly while cackling to himself."
    ..fraymotifs.add(new Fraymotif([], "Kill ALL The Characters", 2)
      ..effects.add(new FraymotifEffect("freeWill", 3, true))
      ..flavorText =
          " All enemies are obliterated. Probably. A watermark of Andrew Hussie appears, stage right. "),

  new PotentialSprite(null, "KidRock", null)
    ..power = 20
    ..helpfulness = -1
    ..helpPhrase =
        "does absolutly nothing but sing repetitive, late 90's rock to you."
    ..fraymotifs.add(new Fraymotif([], "BANG DA DANG DIGGY DIGGY", 2)
      ..effects.add(
          new FraymotifEffect("power", 3, true)) //buffs party and hurts enemies
      ..effects.add(new FraymotifEffect("power", 1, false))
      ..flavorText =
          " OWNER plays a 90s hit classic, and you can't help but tap your feet. Somehow, this doesn't feel like the true version of this attack."),

  new PotentialSprite(null, "Sleuth", null)
    ..power = 20
    ..helpfulness = -1
    ..helpPhrase =
        "suggests the player just input a password to skip all their land's weird puzzle shit. This is not actually a thing you can do."
    ..fraymotifs.add(new Fraymotif([], "Sepulchritude", 2)
      ..effects.add(new FraymotifEffect("RELATIONSHIPS", 1, true))
      ..flavorText =
          " The OWNER decides not to bring that noise just yet. They just heal the party instead. ")
    ..fraymotifs.add(new Fraymotif([], "Sepulchritude", 2)
      ..effects.add(new FraymotifEffect("RELATIONSHIPS", 1, true))
      ..flavorText =
          " THE OWNER just don't have the offensive gravitas for that attack. They just heal the party instead. ")
    ..fraymotifs.add(new Fraymotif([], "Sepulchritude", 2)
      ..effects.add(new FraymotifEffect("RELATIONSHIPS", 3, true))
      ..flavorText =
          " The OWNER finally fucking unleashes their Ultimate Attack. The resplendent light of divine PULCHRITUDE consumes all enemies. ")
    ..fraymotifs.add(new Fraymotif([], "Sepulchritude", 2)
      ..effects.add(new FraymotifEffect("RELATIONSHIPS", 1, true))
      ..flavorText =
          " No, not yet! The OWNER refuses to use Sepulchritude. They just heal the party instead. "),

  new PotentialSprite(null, "Nick Cage", null)
    ..power = 20
    ..helpfulness = 1
    ..helpPhrase =
        "demonstrates that when it comes to solving bullshit riddles to get National *cough* I mean SBURBian treasure, he is simply the best there is. ",

  new PotentialSprite(null, "Praying Mantis", null)
    ..power = 20
    ..maxLuck = 20,

  new PotentialSprite(null, "Shitty Comic Character", null)
    ..power = 20
    ..mobility = 50
    ..helpfulness = -1
    ..helpPhrase =
        " is the STAR. It is them. You don't think they have ever once attempted to even talk about the game. How HIGH did you have to BE to prototype this glitchy piece of shit? "
    ..fraymotifs.add(new Fraymotif(
        [], "FUCK IM FALLING DOWN ALL THESE STAIRS", 3)
      ..effects
          .add(new FraymotifEffect("mobility", 1, false)) //buff to mobility bro
      ..flavorText = " It keeps hapening. ")
    ..fraymotifs
        .add(new Fraymotif([], "FUCK IM FALLING DOWN ALL THESE STAIRS", 3)
      ..effects.add(new FraymotifEffect("mobility", 1, false))
      ..flavorText = " I warned you about stairs bro!!! ")
    ..fraymotifs
        .add(new Fraymotif([], "FUCK IM FALLING DOWN ALL THESE STAIRS", 3)
      ..effects.add(new FraymotifEffect("mobility", 1, false))
      ..flavorText = " I told you dog! "),

  new PotentialSprite(null, "Doctor", null) //healing fraymotif
    ..power = 20
    ..helpfulness = 1
    ..helpPhrase =
        "is pretty much as useful as another player. No cagey riddles, just straight answers on how to finish the quests. ",

  new PotentialSprite(null, "Gerbil", null)
    ..power = 20
    ..helpfulness = 1
    ..helpPhrase =
        "remains physically adorable and mentally idiotic. Gigglysnort hideytalk ahoy. ",

  new PotentialSprite(null, "Chinchilla", null)
    ..power = 20
    ..helpfulness = 1
    ..helpPhrase =
        "remains physically adorable and mentally idiotic. Gigglysnort hideytalk ahoy. ",

  new PotentialSprite(null, "Rabbit", null)
    ..power = 20
    ..maxLuck = 100
    ..helpPhrase =
        "remains physically adorable and mentally idiotic. Gigglysnort hideytalk ahoy. ",

  new PotentialSprite(null, "Tissue", null)
    ..helpfulness = -1
    ..helpPhrase = "is useless in every possible way. ",

  new PotentialSprite(null, "Librarian", null)
    ..power = 20
    ..helpfulness = 1
    ..helpPhrase =
        "Is pretty much as useful as another player. No cagey riddles, just straight answers on where the book on how to finish the quest is, and could you please keep it down? ",

  new PotentialSprite(null, "Pit Bull", null)..power = 50,

  new PotentialSprite(null, "Butler", null)
    ..power = 50 //he will serve you like a man on butler island
    ..helpfulness = 1
    ..helpPhrase =
        "is serving their player like a dude on butlersprite island. "
    ..sanity = 50,

  new PotentialSprite(null, "Sloth", null)
    ..power = 20
    ..mobility = -50
    ..helpPhrase = "provides. Slow. But. Useful. Advice.",

  new PotentialSprite(null, "Cowboy", null)
    ..power = 20
    ..helpfulness = 1
    ..helpPhrase =
        "provides useful advice, even if they do insist on calling literally everyone 'pardner.' ",

  new PotentialSprite(null, "Pomeranian", null)
    ..power =
    1 //pomeranians aren't actually very good at fights.  (trust me, i know)
    ..helpfulness = -1
    ..helpPhrase =
        "unhelpfully insists that every rock is probably a boss fight (it isn’t). ",

  new PotentialSprite(null, "Chihuahua", null)
    ..power =
    1 //i'm extrapolating here, but I imagine Chihuahua's aren't very good at fights, either.
    ..helpfulness = -1
    ..helpPhrase =
        "unhelpfully insists that every rock is probably a boss fight (it isn’t). ",

  new PotentialSprite(null, "Pony", null)
    ..power = 20
    ..helpfulness = -1
    ..sanity =
    -1000 //ponyPals taught me that ponys are just flipping their shit, like, 100% of the time.
    ..helpPhrase =
        "is constantly flipping their fucking shit instead of being useful in any way shape or form, as ponies are known for. ",

  new PotentialSprite(null, "Horse", null)
    ..power = 20
    ..helpfulness = -1
    ..sanity = -100 //probably flip out less than ponys???
    ..helpPhrase =
        "is constantly flipping their fucking shit instead of being useful in any way shape or form, as horses are known for. ",

  new PotentialSprite(null, "Internet Troll",
      null) //needs to have a fraymotif called "u mad, bro" and "butt hurt"
    ..power = 20
    ..helpfulness = -1
    ..sanity = 1000
    ..helpPhrase = "actively does its best to hinder their efforts. ",

  new PotentialSprite(null, "Mosquito", null)
    ..power = 20
    ..helpfulness = -1
    ..helpPhrase =
        "is a complete dick, buzzing and fussing and biting. What's its deal? ",

  new PotentialSprite(null, "Fly", null)
    ..power = 20
    ..helpfulness = -1
    ..helpPhrase =
        "is a complete dick, buzzing and fussing and biting. What's its deal? ",

  new PotentialSprite(null, "Cow", null)
    ..power = 30, //cows kill more people a year than sharks.

  new PotentialSprite(null, "Bird", null)
    ..power = 20
    ..mobility = 20
    ..helpPhrase =
        "provides sort of helpful advice when not grabbing random objects to make nests. ",

  new PotentialSprite(null, "Bug", null)
    ..power = 20
    ..helpPhrase =
        "provides the requisite amount of buzzybuz zuzytalk to be juuuust barely helpful. ",

  new PotentialSprite(null, "Llama", null)..power = 20,

  new PotentialSprite(null, "Penguin", null)..power = 20,

  new PotentialSprite(null, "Husky", null)
    ..power = 30
    ..helpPhrase =
        "alternates between loud, insistent barks and long, eloquent monologues on the deeper meaning behind each and every fragment of the game. ",

  new PotentialSprite(null, "Cat", null)
    ..power = 20
    ..minLuck = -20
    ..maxLuck = 20
    ..helpPhrase =
        "Is kind of helpful? Maybe? You can't tell if it loves their player or hates them. ",

  new PotentialSprite(null, "Dog", null)
    ..power = 30
    ..helpPhrase =
        "alternates between loud, insistent barks and long, eloquent monologues on the deeper meaning behind each and every fragment of the game. ",

  new PotentialSprite(null, "Pigeon", null)
    ..power =
    0.5 //pigeons are not famous for their combat prowess. I bet even a pomeranian could beat one up.
    ..freeWill = -40,

  new PotentialSprite(null, "Octopus", null)
    ..power = 20
    ..mobility = 80, //so many legs! more legs is more faster!!!

  new PotentialSprite(null, "Fish", null)
    ..power = 20
    ..armless = true,

  new PotentialSprite(null, "Kitten", null)
    ..power = 20
    ..helpPhrase =
        "is kind of helpful? Maybe? You can't tell if it loves their player or hates them. ",

  new PotentialSprite(null, "Worm", null)
    ..power = 20
    ..armless = true,

  new PotentialSprite(null, "Bear", null)..power = 50,

  new PotentialSprite(null, "Goat", null)..power = 20,

  new PotentialSprite(null, "Rat", null)..power = 20,

  new PotentialSprite(null, "Raccoon", null)
    ..power = 20
    ..helpfulness = 1
    ..helpPhrase =
        "demonstrates that SBURB basically hides quest items in the same places humans would throw away their garbage. ",

  new PotentialSprite(null, "Crow", null)
    ..power = 20
    ..freeWill =
    20 //have you ever tried to convince a crow not to do something? not gonna happen.
    ..helpPhrase =
        "provides sort of helpful advice when not grabbing random objects to make nests. ",

  new PotentialSprite(null, "Chicken", null)
    ..power = 20
    ..freeWill =
    -20, //mike the headless chicken has convinced me that chickens don't really need brains. god that takes me back.

  new PotentialSprite(null, "Duck", null)..power = 20,

  new PotentialSprite(null, "Sparrow", null)..power = 20,

  new PotentialSprite(null, "Fancy Santa", null)
    ..power = 20
    ..helpfulness = -1
    ..helpPhrase = "goes hohohohohohohohoho. ",

  new PotentialSprite(null, "Politician", null)
    ..power = 20
    ..helpfulness = -1
    ..helpPhrase =
        "offers a blueprint for an ECONONY that works for everyone. That would've been more useful before the earth was destroyed.... ",

  new PotentialSprite(null, "Tiger", null)
    ..power = 50
    ..helpPhrase =
        "Provides just enough pants-shitingly terrifying growly-roar meow talk to be useful. ",

  new PotentialSprite(null, "Sugar Glider", null)
    ..power = 20
    ..helpPhrase =
        "remains physically adorable and mentally idiotic. Gigglysnort hideytalk ahoy. ",

  new PotentialSprite(null, "Rapper", null)
    ..power = 20
    ..helpfulness = 1
    ..helpPhrase =
        "provides surprisingly helpful advice, even if it does insist on some frankly antiquated slang and rhymes. I mean, civilization is dead, there isn’t exactly a police left to fuck. ",

  new PotentialSprite(null, "Kangaroo", null)
    ..power = 30
    ..mobility = 30,

  new PotentialSprite(null, "Stoner", null)
    ..power = 42.0 //blaze it
    ..minLuck = -42.0
    ..maxLuck = 42.0
    ..helpfulness = 1
    ..helpPhrase =
        "is pretty much as useful as another player, assuming that player was higher then a fucking kite. ",
]
  ..addAll(disastor_objects)
  ..addAll(fortune_objects)
  ..addAll(lusus_objects)
  ..addAll(
      sea_lusus_objects); //yes, a human absolutely could prototype some troll's lusus. that is a thing that is true.
