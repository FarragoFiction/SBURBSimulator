//little bobby tables

function getRandomElementFromArray(array){
	var min = 0;
	var max = array.length-1;
	var i = Math.floor(Math.random() * (max - min + 1)) + min;
	return array[i];
}

function getDenizenFromAspect(aspect){
	if(aspect == "Space"){
		return space_denizen;
	}else if(aspect == "Time"){
		return time_denizen;
	}else if(aspect == "Breath"){
		return breath_denizen;
	}else if(aspect == "Doom"){
		return doom_denizen;
	}else if(aspect == "Blood"){
		return blood_denizen;
	}else if(aspect == "Heart"){
		return heart_denizen;
	}else if(aspect == "Mind"){
		return mind_denizen;
	}else if(aspect == "Light"){
		return light_denizen;
	}else if(aspect == "Void"){
		return void_denizen;
	}else if(aspect == "Rage"){
		return rage_denizen;
	}else if(aspect == "Hope"){
		return hope_denizen;
	}else if(aspect == "Life"){
		return life_denizen;
	}
	return "ERROR 404: Denizen Not Found"
}

function getRandomLandFromAspect(aspect){
	var first_arr = [];
	if(aspect == "Space"){
		first_arr = space_land_titles;
	}else if(aspect == "Time"){
		first_arr = time_land_titles;
	}else if(aspect == "Breath"){
		first_arr = breath_land_titles;
	}else if(aspect == "Doom"){
		first_arr = doom_land_titles;
	}else if(aspect == "Blood"){
		first_arr = blood_land_titles;
	}else if(aspect == "Heart"){
		first_arr = heart_land_titles;
	}else if(aspect == "Mind"){
		first_arr = mind_land_titles;
	}else if(aspect == "Light"){
		first_arr = light_land_titles;
	}else if(aspect == "Void"){
		first_arr = void_land_titles;
	}else if(aspect == "Rage"){
		first_arr = rage_land_titles;
	}else if(aspect == "Hope"){
		first_arr = hope_land_titles;
	}else if(aspect == "Life"){
		first_arr = life_land_titles;
	}
	var tmp = randomFromTwoArrays(first_arr, free_land_titles);
	return "Land of " + tmp[0] + " and " + tmp[1];
}

function getRandomChatHandle(class_name, aspect){
	var first_arr = [];
	if(aspect == "Space"){
		first_arr = space_handles;
	}else if(aspect == "Time"){
		first_arr = time_handles;
	}else if(aspect == "Breath"){
		first_arr = breath_handles;
	}else if(aspect == "Doom"){
		first_arr = doom_handles;
	}else if(aspect == "Blood"){
		first_arr = blood_handles;
	}else if(aspect == "Heart"){
		first_arr = heart_handles;
	}else if(aspect == "Mind"){
		first_arr = mind_handles;
	}else if(aspect == "Light"){
		first_arr = light_handles;
	}else if(aspect == "Void"){
		first_arr = void_handles;
	}else if(aspect == "Rage"){
		first_arr = rage_handles;
	}else if(aspect == "Hope"){
		first_arr = hope_handles;
	}else if(aspect == "Life"){
		first_arr = life_handles;
	}
	
	var second_arr = [];
	if(class_name == "Maid"){
		second_arr = maid_handles;
	}else if(class_name == "Page"){
		second_arr = page_handles;
	}else if(class_name == "Mage"){
		second_arr = mage_handles;
	}else if(class_name == "Knight"){
		second_arr = knight_handles;
	}else if(class_name == "Rogue"){
		second_arr = rogue_handles;
	}else if(class_name == "Sylph"){
		second_arr = sylph_handles;
	}else if(class_name == "Seer"){
		second_arr = seer_handles;
	}else if(class_name == "Thief"){
		second_arr = thief_handles;
	}else if(class_name == "Heir"){
		second_arr = heir_handles;
	}else if(class_name == "Bard"){
		second_arr = bard_handles;
	}else if(class_name == "Prince"){
		second_arr = prince_handles;
	}else if(class_name == "Witch"){
		second_arr = witch_handles;
	}
	var tmp =  randomFromTwoArraysOrdered(second_arr, first_arr);
	return tmp[0]  + tmp[1];
}

function getRandomLevelFromAspect(aspect){
	//console.log("looking for level from aspect");
	var first_arr = [];
	if(aspect == "Space"){
		first_arr = space_levels;
	}else if(aspect == "Time"){
		first_arr = time_levels;
	}else if(aspect == "Breath"){
		first_arr = breath_levels;
	}else if(aspect == "Doom"){
		first_arr = doom_levels;
	}else if(aspect == "Blood"){
		first_arr = blood_levels;
	}else if(aspect == "Heart"){
		first_arr = heart_levels;
	}else if(aspect == "Mind"){
		first_arr = mind_levels;
	}else if(aspect == "Light"){
		first_arr = light_levels;
	}else if(aspect == "Void"){
		first_arr = void_levels;
	}else if(aspect == "Rage"){
		first_arr = rage_levels;
	}else if(aspect == "Hope"){
		first_arr = hope_levels;
	}else if(aspect == "Life"){
		first_arr = life_levels;
	}
	return getRandomElementFromArray(first_arr);
}

function getRandomLevelFromClass(class_name){
	//console.log("looking for level from class");
	var first_arr = [];
	if(class_name == "Maid"){
		first_arr = maid_levels;
	}else if(class_name == "Page"){
		first_arr = page_levels;
	}else if(class_name == "Mage"){
		first_arr = mage_levels;
	}else if(class_name == "Knight"){
		first_arr = knight_levels;
	}else if(class_name == "Rogue"){
		first_arr = rogue_levels;
	}else if(class_name == "Sylph"){
		first_arr = sylph_levels;
	}else if(class_name == "Seer"){
		first_arr = seer_levels;
	}else if(class_name == "Thief"){
		first_arr = thief_levels;
	}else if(class_name == "Heir"){
		first_arr = heir_levels;
	}else if(class_name == "Bard"){
		first_arr = bard_levels;
	}else if(class_name == "Prince"){
		first_arr = prince_levels;
	}else if(class_name == "Witch"){
		first_arr = witch_levels;
	}
	return getRandomElementFromArray(first_arr);
}

function getRandomQuestFromAspect(aspect){
	//console.log("looking for level from aspect");
	var first_arr = [];
	if(aspect == "Space"){
		first_arr = space_quests;
	}else if(aspect == "Time"){
		first_arr = time_quests;
	}else if(aspect == "Breath"){
		first_arr = breath_quests;
	}else if(aspect == "Doom"){
		first_arr = doom_quests;
	}else if(aspect == "Blood"){
		first_arr = blood_quests;
	}else if(aspect == "Heart"){
		first_arr = heart_quests;
	}else if(aspect == "Mind"){
		first_arr = mind_quests;
	}else if(aspect == "Light"){
		first_arr = light_quests;
	}else if(aspect == "Void"){
		first_arr = void_quests;
	}else if(aspect == "Rage"){
		first_arr = rage_quests;
	}else if(aspect == "Hope"){
		first_arr = hope_quests;
	}else if(aspect == "Life"){
		first_arr = life_quests;
	}
	return getRandomElementFromArray(first_arr);
}



/**
 * Returns a random integer between min (inclusive) and max (inclusive)
 * Using Math.round() will give you a non-uniform distribution!
 */
function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

function getRandomQuestFromClass(class_name){
	//console.log("looking for level from class");
	var first_arr = [];
	if(class_name == "Maid"){
		first_arr = maid_quests;
	}else if(class_name == "Page"){
		first_arr = page_quests;
	}else if(class_name == "Mage"){
		first_arr = mage_quests;
	}else if(class_name == "Knight"){
		first_arr = knight_quests;
	}else if(class_name == "Rogue"){
		first_arr = rogue_quests;
	}else if(class_name == "Sylph"){
		first_arr = sylph_quests;
	}else if(class_name == "Seer"){
		first_arr = seer_quests;
	}else if(class_name == "Thief"){
		first_arr = thief_quests;
	}else if(class_name == "Heir"){
		first_arr = heir_quests;
	}else if(class_name == "Bard"){
		first_arr = bard_quests;
	}else if(class_name == "Prince"){
		first_arr = prince_quests;
	}else if(class_name == "Witch"){
		first_arr = witch_quests;
	}
	return getRandomElementFromArray(first_arr);
}

function randomFromTwoArrays(arr1, arr2){
	if(Math.random() > .5){
		return [getRandomElementFromArray(arr2), getRandomElementFromArray(arr1)];
	}else{
		return [getRandomElementFromArray(arr1), getRandomElementFromArray(arr2)];
	}
}

function randomFromTwoArraysOrdered(arr1, arr2){
	return [getRandomElementFromArray(arr1), getRandomElementFromArray(arr2)];
}

function indexToWords(i){
	var words = ["first","second","third","fourth","fifth","sixth","seventh","eighth","ninth","tenth","eleventh","twelfth",];
	return words[i];
}

function debug(str){
	$("#debug").append("<br>" + str);
}

function shuffle(array) {
  var currentIndex = array.length, temporaryValue, randomIndex;

  // While there remain elements to shuffle...
  while (0 !== currentIndex) {

    // Pick a remaining element...
    randomIndex = Math.floor(Math.random() * currentIndex);
    currentIndex -= 1;

    // And swap it with the current element.
    temporaryValue = array[currentIndex];
    array[currentIndex] = array[randomIndex];
    array[randomIndex] = temporaryValue;
  }

  return array;
}

function removeFromArray(item, array){
	var index = array.indexOf(item);
	if (index > -1) {
		array.splice(index, 1);
	}
}

var moons = ["Prospit", "Derse"];
var classes = ["Maid","Page","Mage","Knight","Rogue","Sylph","Seer","Thief","Heir","Bard","Prince","Witch"];
//when a class is used, remove from below list.
var available_classes = ["Maid","Page","Mage","Knight","Rogue","Sylph","Seer","Thief","Heir","Bard","Prince","Witch"];
var two_person_classes = ["Lord","Muse"];
var required_aspects = ["Space", "Time"];
var nonrequired_aspects = ["Breath","Doom","Blood","Heart","Mind","Light","Void","Rage","Hope","Life"];
var available_aspects = ["Breath","Doom","Blood","Heart","Mind","Light","Void","Rage","Hope","Life"];

//TODO eventually implent null land titles, like Mounds and Xenon.
var space_land_titles = ["Frogs"];
var time_land_titles = ["Quartz", "Clockwork", "Gears", "Melody"];
var breath_land_titles = ["Wind", "Breeze", "Zephyr"];
var doom_land_titles = ["Fire", "Death", "Prophecy"];
var blood_land_titles = ["Pulse","Bonds", "Clots"];
var heart_land_titles = ["Little Cubes", "Dolls","Selfies"];
var mind_land_titles = ["Thought", "Rationality", "Decisions"];
var light_land_titles = ["Treasure","Light","Knowledge"];
var void_land_titles = ["Silence","Nothing","Void"];
var rage_land_titles = ["Mirth","Whimsy","Madness"];
var hope_land_titles = ["Angels","Hope","Belief"];
var life_land_titles = ["Dew","Spring","Beginnings"];

var free_land_titles = ["Heat","Sand","Brains","Haze","Tea","Flow","Maps","Caves","Tents","Wrath","Rays","Glass"];
free_land_titles = free_land_titles.concat(["Shade","Frost","Rain","Fog","Trees","Flowers","Books","Technology","Ice","Water","Rocks"]);
free_land_titles = free_land_titles.concat(["Forests","Grass","Tundra","Thunder","Storms","Peace","Food","Shoes","Weasels","Deserts","Dessert"]);
free_land_titles = free_land_titles.concat(["Suburbs","Cities","Neighborhoods","Isolation","Schools","Farms","Annoyance","Hunger","Cake","Lies","Ruse"]);



var prototypings = ["Cow","Bird","Bug","Grandma","Dad","Mom","Cat","Dog","Pigeon","Octopus","Nick Cage","Fish","Kitten"];
prototypings = prototypings.concat(["Worm","Doll","Pony","Horse","Bear","Goat","Rat","Sheep","Crab","Spider","Raccoon"]);
prototypings = prototypings.concat(["Crow","Chicken","Duck","Sparrow","Dove","Goose","Turkey","Kangaroo","Lawyer","Doctor"]);
prototypings = prototypings.concat(["Ladybug","Butterfly","Fly","Mosquito","Centipede","Praying Mantis","Dragonfly","Ant"]);
prototypings = prototypings.concat(["Bull","Llama","Ox","Bison","Elephant","Giraffe","Sloth","Engineer","Construction Worker"]);
prototypings = prototypings.concat(["Mouse","Gerbil","Hamster","Sugar Glider","Rabbit","Guinea Pig","Chinchilla","Pomeranian"]);
prototypings = prototypings.concat(["Opossum","Penguin","Koala","Walrus","Dachshund","Ocelot","Tiger","Lion", "Cougar"]);
prototypings = prototypings.concat(["Stoner","Student","Librarian","Teacher","Jockey","Butler","Rapper","Poet", "Astronaut", "Cowboy"]);

var disastor_prototypings = ["First Guardian", "Horror Terror", "Dragon", "Alien", "Teacher", "Clown"];
disastor_prototypings = disastor_prototypings.concat(["Zombie","Demon","Monster","Vampire","Pumpkin","Werewolf","Puppet",]);
var fortune_prototypings = ["Frog","Lizard", "Salamander", "Iguana", "Crocodile", "Turtle", "Snake"];


var space_levels = ["GREENTIKE", "ALIEN URCHIN", "FROG-WRANGLER"];
var time_levels = ["MARQUIS MCFLY", "JUNIOR CLOCK BLOCKER", "DEAD KID COLLECTOR"];
var breath_levels = ["BOY SKYLARK", "SODAJERK'S CONFIDANTE", "MAN SKYLARK"];
var doom_levels = ["APOCALYPSE HOW", "REVELATION RUMBLER", "PESSIMISM PILGRIM"];
var blood_levels = ["FRIEND HOARDER YOUTH","HEMOGOBLIN", "SOCIALIST BUTTERFLY"];
var heart_levels = ["SHARKBAIT HEARTHROB", "FEDORA FLEDGLING","PENCILWART PHYLACTERY"];
var mind_levels = ["NIPPER-CADET", "COIN-FLIPPER CONFIDANTE", "TWO-FACED BUCKAROO"];
var light_levels = ["SHOWOFF SQUIRT","JUNGLEGYM SWASHBUCKLER","SUPERSTITIOUS SCURRYWART"];
var void_levels = ["KNOW-NOTHING ANKLEBITER","INKY BLACK SORROWMASTER","FISTICUFFSAFICTIONADO"];
var rage_levels = ["MOPPET OF MADNESS","FLEDGLING HATTER","RAGAMUFFIN REVELER"];
var hope_levels = ["GADABOUT PIPSQUEAK","BELIVER EXTRAORDINAIRE","DOCTOR FEELGOOD"];
var life_levels = ["BRUISE BUSTER","LODESTAR LIFER","BREACHES HEALER"];

var maid_levels = ["SCURRYWART SERVANT", "SAUCY PILGRIM", "MADE OF SUCCESS"];
var page_levels = ["APPRENTICE ANKLEBITER", "JOURNEYING JUNIOR", "OUTFOXED BY SIMPLE UTENSILS...BUCKAROO"];
var mage_levels = ["WIZARDING TIKE", "THE SORCERER'S SCURRYWART", "FAMILIAR FRAYMOTTIFICTIONADO"];
var knight_levels = ["QUESTING QUESTANT", "LADABOUT LANCELOT", "SIR SCULLDODGER"];
var rogue_levels = ["KNEEHIGH ROBINHOOD","DASHING DARTABOUT", "COMMUNIST COMMANDER"];
var sylph_levels = ["SERENE SCALLYWAG", "MYSTICAL RUGMUFFIN","FAE FLEDGLING"];
var thief_levels = ["RUMPUS RUINER", "HAMBURGLER YOUTH", "PRISONBAIT"];
var heir_levels = ["UNREAL HEIR","HEIR CONDITIONER","EXTRAORDINHEIR"];
var bard_levels = ["SKAIA'S TOP IDOL","POPSTAR BOPPER","SONGSCUFFER"];
var prince_levels = ["PRINCE HARMING","ROYAL RUMBLER","DIGIT PRINCE"];
var witch_levels = ["WESTWORD WORRYBITER","BUBBLETROUBLER","EYE OF GRINCH"];
var seer_levels = ["SEEING iDOG","PIPSQUEAK PROGNOSTICATOR","SCAMPERVIEWER 5000"];


var space_quests = ["messing with a variety of frogs that were previously paradox cloned"];
space_quests.push("paradox cloning a variety of frogs, after making a serious note to mess with them later");
space_quests.push("combining paradox slime from multiple frogs together to make paradox offspring");
space_quests.push("listening to the ridiculously similar croaks of cloned frogs to figure out where their flaws are");
var time_quests = ["manipulating the local stock exchange through a series of cunningly disguised time doubles"];
time_quests.push("stopping a variety of disasters from happening before even the first player enters the medium");
time_quests.push("cheating at obstacle course time trials to get a finishing value of exactly 0.0 seconds");
time_quests.push("restoring a legendary piece of shit weapon to its pre-destroyed state");
var breath_quests = ["putting out fires in consort villages through serendepitious gales of wind"];
breath_quests.push("delivering mail through a complicated series of pneumatic tubes");
breath_quests.push("paragliding through increasingly elaborate obstacle courses to become the champion (it is you)");
var doom_quests = ["calculating the exact moment a planet quake will destroy a consort village with enough time remaining to perform evacuation"];
doom_quests.push("setting up increasingly complex Rube Goldberg machines to defeat all enemies in a dungeon at once");
doom_quests.push("obnoxiously memorizing the rules of a minigame, and then blatantly  abusing them to achieve an otherwise impossible victory");
var blood_quests = ["uniting warring consort nations against a common enemy"];
blood_quests.push("organizing 5 bickering consorts long enough to transverse a dungeon with any degree of competence");
blood_quests.push("learning the true meaning of this human disease called friendship");
var heart_quests = ["providing a matchmaking service for the local consorts (ships guaranteed)"];
heart_quests.push("doing battle with shadow clones that are eventually defeated when you accept them as a part of you");
heart_quests.push("correctly picking out which item represents them out of a vault of a thousand bullshit shitty stuffed animals");
var mind_quests = ["manipulating the local consorts into providing dungeon clearing services"];
mind_quests.push("presiding over increasingly hard consort court cases, punishing the guilty and pardoning the innocent");
mind_quests.push("pulling pranks as a minigame, with bonus points awared for pranks performed on those who 'had it coming'");
var light_quests = ["winning at increasingly unfair gambling challenges"];
light_quests.push("researching way too much lore and minutia to win at trivia contests");
light_quests.push("explaining how to play a mini game to particularly stupid consorts until they finally get it");
var void_quests = ["destroying and/or censoring embarassing consort records"];
void_quests.push("definitely doing quests, just...not where we can see them");
void_quests.push("playing a hilariously fun boxing minigame");
var rage_quests = ["fighting hoards upon hoards of enemies in increasingly unfair odds until defeating them all in a beserk rage"];
rage_quests.push("figuring out increasingly illogical puzzles until lateral thinking becomes second nature");
rage_quests.push("dealing with the most annoying dungeon challenges ever, each more irritating and aneurysm inducing than the last");
var hope_quests = ["performing bullshit acts of faith, like walking across invisible bridges"];
hope_quests.push("becoming the savior of the local consorts, through fullfillment of various oddly specific prophecies");
hope_quests.push("brainstorming a variety of ways the local consorts can solve their challenges");
var life_quests = ["coaxing the fallow farms of the local consorts into becoming fertile"];
life_quests.push("healing a seemingly endless parade of stricken consorts");
life_quests.push("finding and rescuing consort children trapped in a burning building");


var maid_quests = ["doing the consorts' menial errands, like delivering an item to a dude standing RIGHT FUCKING THERE"];
maid_quests.push("repairing various ways the session has been broken");
maid_quests.push("protecting various consorts with game powers");
var page_quests = ["going on various quests of self discovery and confidence building"];
page_quests.push("partnering with a local consort hero to do great deeds and slay evil foes");
page_quests.push("learning to deal with disapointment after dungeon after dungeon proves to have all the enemies, and none of the treasure");
var mage_quests = ["performing increasingly complex alchemy for demanding, moody consorts"];
mage_quests.push("learning to silence their Mage Senses long enough to not go insane");
mage_quests.push("learning to just let go and let things happen");
var knight_quests = ["protecting the local consorts from a fearsome foe"];
knight_quests.push("protecting the session from various ways it can go shithive maggots");
knight_quests.push("questing to collect the 7 bullshit orbs of supreme bullshit and deliver them to the consort leader");
var rogue_quests = ["robbing various tombs and imp settlements to give to impovished consorts"];
rogue_quests.push("stealing a priceless artifact in order to fund consort orphanages");
rogue_quests.push("planning an elaborate heist to steal priceless grist from a boss ogre in order to alchemize shoes for orphans");
var sylph_quests = ["restoring a consort city to its former glory"];
sylph_quests.push("preserving the legacy of a doomed people");
sylph_quests.push("providing psychological counsling to homeless consorts");
var thief_quests = ["robbing various enemy imps and ogres to obtain vast riches"];
thief_quests.push("planning an elaborate heist that relies on several hard-to-predict factors going absolutely perfectly");
thief_quests.push("torrenting vast amounts of grist from the other players");
var heir_quests = ["retrieving a sword from a stone"];
heir_quests.push("completing increasingly unlikely challenges through serendepitious coincidences");
heir_quests.push("inheriting and running a succesful, yet complex company");
var bard_quests = ["allowing events to transpire such that various quests complete themselves"];
bard_quests.push("baiting various enemies into traps for an easy victory");
bard_quests.push("watching as their manipulations result in consorts rising up to defeat imps");
var prince_quests = ["destroying enemies thoroughly"];
prince_quests.push("riding in at the last minute to defeat the local consorts hated enemies");
prince_quests.push("learning to grow as a person, despite the holes in their personality");
var seer_quests = ["making the various bullshit rules of SBURB part of their personal mythos"];
seer_quests.push("collaborating with the exiled future carapacians to manipulate Prospit and Derse according to how its supposed to go");
seer_quests.push("suddenly understanding everything, and casting sincere doubt at the laughable insinuation that they ever didn't");
var witch_quests = ["performing elaborate punch card alchemy through the use of a novelty witch's cauldron"];
witch_quests.push("deciding which way to go in a series of way-too-long mazes");
witch_quests.push("solving puzzles in ways that completely defy expectations");



var space_denizen = "Echidna";
var time_denizen = "Hephaestus";
var breath_denizen = "Typheus";
var doom_denizen = "Cassandra";//
var blood_denizen = "Hestia";//
var heart_denizen = "Aphrodite";//
var mind_denizen = "Janus";//
var light_denizen = "Cetus";
var void_denizen = "Nix";
var hope_denizen = "Abraxus";
var life_denizen = "Hemera";
var rage_denizen = "Bacchus";//


/*
this.goodMild = "Friends";
	this.goodBig = "Totally In Love";
	this.badMild = "Rivals";
	this.badBig = "Enemies";
	*/
var goodMildDesc = ["a pretty good kid", "nice enough", "merely tolerable", "just friendly"];
var goodBigDesc = ["the most fascinating human left", "distractingly pretty", "really hot"];
var bigMildDesc = ["kind of a jerk", "sort of an asshole", "only sort of irritating", "just a little annoying"];
var bigBadDesc = ["just the smelliest bag of assholes", "the most infuriating asshole around", "most likely to fuck everyone over", "dangerous"];


var democracyTasks = ["WV gives talks to a random carapacian boy, demanding he support democracy."," WV gathers followers using techniques learned from reading a book on carapacian etiquette. "];
democracyTasks.push(" WV demonstrates tactical knowledge to Dersites, convincing them they can win against the King. ");
democracyTasks.push(" WV gives rousing speeches to Prospitians, emphasizing that they share the same goal. ");
democracyTasks.push(" WV gives rousing speeches to Dersites, listing every crime the King and Queen have commited against their own people. ");
democracyTasks.push(" WV debates Dersite beliefs, asking if they REALLY want to die in the Reckoning rather than go live in a new Universe (loathesome though frogs may be). ");



var democracySuperTasks = [" WV flips the fuck out and starts distributing free TAB soda to anyone who joins his army. "];
democracySuperTasks.push(" WV grabs a random Player and uses them as a prop during a speech, triggering the frothing devotion of the local consorts. ");
democracySuperTasks.push("");

var mayorDistractionTasks = [" WV is distracted eating green objects rather than recruiting for his army. "];
mayorDistractionTasks.push( " WV is distracted planning the civil infrastructure of a city, rather than recruiting for his army.");
mayorDistractionTasks.push(" WV is distracted fantasizing about how great of a mayor he will be. ");
mayorDistractionTasks.push(" WV accidentally tried to recruit carapacians already part of his army. Stupid stupid stupid! ");


var bloodColors = ["#A10000","#a25203","#a1a100","#658200","#416600","#078446","#008282","#004182","#0021cb","#631db4","#610061","#99004d"];

var landlususTypes = ["Hoofbeast","Meow Beast","Bark Beast","Nut Creature ","Gobblefiend","Bicyclops","Centaur","Fairy Bull"];
landlususTypes = landlususTypes.concat(["Slither Beast","Wiggle Beast","Honkbird","Dig Beast","Cholerbear","Antler Beast","Dragon","Ram Beast","Crab","Spider","Thief Beast"]);
landlususTypes = landlususTypes.concat(["March Bug","Nibble Vermin","Woolbeast", "Hop Beast", "Stink Creature", "Speed Beast", "Jump Creature", "Fight Beast", "Claw Beast", "Tooth Beast", "Armorbeast"]);


var seaLususTypes = ["Slither Beast", "Electric Beast", "Whale", "Sky Horse", "Sea Meow Beast", "Sea Hoofbeast", "Cuttlefish", "Horror Terror", "Swim Beast", "Sea Goat", "Tooth Beast", "Light Beast"]
seaLususTypes = seaLususTypes.concat(["Dive Beast", "Honkbird", "Sea Bear", "Sea Armorbeast"]);

var interests = ["Fine Art", "Rap", "Literature", "Pranks", "Music", "Video Games", "Movies", "Television", "Books", "Social Media", "Relationships", "Comedy"]
interests = interests.concat(["Aliens", "Dance", "Social Justice", "Romance", "Money", "Knowledge", "Justice", "Animals", "Equality", "Knitting", "Drawing"]);
interests = interests.concat(["Conspiracies", "Fitness", "Sports", "Leadership", "Violence", "Death", "Peace", "Humans", "Trolls", "Science Fiction", "Fantasy"]);
interests = interests.concat(["Faeries", "Elves", "Vampires", "Undead", "Racism", "Programming", "Hacking", "Writing", "Status", "Fan Art", "Fan Fiction"]);
interests = interests.concat(["Gardening", "Geneology", "Crochet", "Scrapbooking", "Action Movies", "Superheroes", "Supervillains", "Robots", "Detectives", "Graffiti", "Girls", "Boys"]);
interests = interests.concat(["Cooking", "Baking", "Astronomy", "Science", "Animal Training", "Physics", "Biology", "Chemistry", "Hoarding", "Yoga", "Meditation", "Animal Fights"]);
interests = interests.concat(["Online Trolling", "Religion", "Cultural Appropriation", "Artificial Intelligence", "Babies", "Pets", "Musicals", "Documentaries", "Mysteries", "Insults", "Painting", "Revolution"]);
interests = interests.concat(["Role Playing", "Fashion", "Politics", "Geography", "Cartography", "Tabletop Roleplaying", "Online Roleplaying", "Live Action Roleplaying", "Model Trains", "Molecular Gastronomy", "Boxing", "Ninjas"]);
interests = interests.concat(["Typography", "Movie Making", "Script Writing", "Song Writing", "Theater", "Track and Field", "Swimming"]);

var prefixes = ["8=D",">->","//", "tumut",")","><>","(", "$", "?", "=begin", "=end"]
prefixes = prefixes.concat(["<3","<3<","<>","c3<","{","}","[","]","'",".",",","~","!","~","^","&","#","@","%","*"]);

//not as extreme as a troll quirk, but...
var conversational_quirks = [["like", "liek"],["ing","in"],["have to","hafta"], ["want to","wanna"],["going to","gonna"], ["i'm","i am"],["you're","you are"],["we're","we are"],["Don't","do not"]];
conversational_quirks = conversational_quirks.concat([["Won't","will not"],["Didn't","did not"],["Can't","can't"],["We'll","We will"],["the","teh"],["aren't","aint"],["ie","ei"],["though","tho"],["you","u"],["right","rite"]]);

var very_quirks = [["very","adequately"],["very","really"],["very","super"],["very", "amazingly"],["very","hella"],["very","extremely"],["very","absolutely"],["very","mega"],["very ","extra"],["very","ultra"],["very","hecka"],["very","totes"]];

var good_quirks = [["good,agreeable"],["good", "marvelous"],["good", "ace"],["good", "wonderful"],["good","sweet"],["good","dope"],["good","awesome"],["good","great"],["good","amazing"],["good","perfect"],["good","amazing"],["good","super good"],["good","acceptable"]];
var lol_quirks = [["lol","haha"],["lol","ehehe"],["lol","heh"],["lol","omg lol"],["lol","rofl"],["lol","funny"],["lol",""],["lol","hee"],["lol","lawl"],["lol","roflcopter"],["lol","..."],["lol","bwahah"],["lol","*giggle*"]];
var greeting_quirks = [["hey", "hi"],["hey", "hello"],["hey", "greetings"],["hey", "yo"],["hey", "sup"]];
var dude_quirks = [["dude","guy"],["dude","man"],["dude","you"],["dude","friend"],["dude","asshole"],["dude","fella"],["dude","bro"]];
var curse_quirks = [["fuck", "shit"],["fuck", "cocks"],["fuck", "nope"],["fuck", "goddammit"],["fuck", "damn it"],["fuck", "..."],["fuck", "...great."]];
console.log("TODO figure out how to make conversational quirks ignore case");




var maid_handles = ["meandering","motley","musing","mischievous","macabre", "maiden"];
var page_handles = ["passionate","patient","peaceful","perfect","perceptive"];
var mage_handles = ["magnificent","managerial","major","majestic","mannerly"];
var knight_handles = ["keen","knightly","kooky","kindred","kinetic"];
var rogue_handles = ["rouge","radical","retrobate","roguish","retroactive"];
var sylph_handles = ["surly","sour","sweet","stylish","soaring", "serene"];
var thief_handles = ["talented","terrible","talkative","tenacious","tried"];
var heir_handles = ["honorable","humble","hot","horrific","hardened"];
var bard_handles = ["benign","blissful","boisterous","bonkers","broken"];
var prince_handles = ["precocious","priceless","proficient","prominent","proper"];
var witch_handles = ["wondering","wonderful","wacky","withering","worldly"];
var seer_handles = ["sightly","sanctimonious","sarcastic","sassy","scintillating","synergistic"];

var space_handles = ["Salamander","Salientia","Spacer","Scientist","Synergy"];
var time_handles = ["Teetotaler","Traveler","Tailor","Taster","Target", "Teacher", "Therapist"];
var breath_handles = ["Biologist","Backpacker","Babysitter","Baker","Balooner"];
var doom_handles = ["Dancer","Dean","Decorator","Deliverer","Director"];
var blood_handles = ["Buyer","Butler","Butcher","Barber","Bowler"];
var heart_handles = ["Heart","Hacker","Harbinger","Handler","Helper", "Historian", "Hobbyist"];
var mind_handles = ["Machine","Magician","Magistrate","Mechanic","Mediator", "Messenger"];
var light_handles = ["Laborer","Launderer","Layabout","Legend","Lawyer", "Lifeguard"];
var void_handles = ["Vagrant","Vegetarian","Veterinarian","Vigilante","Virtuoso"];
var rage_handles = ["Raconteur","Reveler","Reader","Reporter","Racketeer"];
var hope_handles = ["Honcho","Humorist","Horse","Haberdasher","Hooligan"];
var life_handles = ["Leader","Lecturer","Liason","Loyalist","Lyricist"];

var human_hair_colors = ["#68410a","#000000","#f3f28d","#cf6338","#feffd7","#fff3bd","#724107","#382207","#ff5a00","#3f1904","#ffd46d","#473200","#91683c"];



