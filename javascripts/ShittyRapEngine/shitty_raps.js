//http://www.rhymezone.com/r/rhyme.cgi?Word=back&typeofrhyme=perfect&org1=syl&org2=l&org3=y
//if this seems like it will work, move to random tables. based on recursiveSlacker's idea.
var comedyInterestNouns = ["joke","clown","fun", "folk", "bloke","quack","flashback","piece of cake","shell game","skunk","debunk", "grump"];
var comedyInterestVerbs = ["joke", "frown", "stun", "soak", "choke", "scrunch", "wisecrack","smack","attack","crack","emergency break","flunk","jump"];

var athleticInterestNouns = ["sun","lunch","crown","brown", "clown","yolk","seasick","smalltalk","hella drunk","punk","drunk","yardstick","pregame","postgame"];
var athleticInterestVerbs = ["run","punch", "down", "drown", "soak", "won","block","sunk","spelunk","aim","maim","tame"];

var musicInterestNouns = ["songbook","hook","feedback","flashback","soundtrack","punk","drunk","flashback","megalomaniac","Jack","sack","quack","asscrack","throwback","huge mistake","piece of cake","flake","mistake","game","video game"];
var musicInterestVerbs = ["hook","fame","attack","backtrack","hijack","clack","funk","wisecrack","throwback","horseback","ransack","take","wake","headache","shake","croak","choke","maim","taim"];

var cultureInterestNouns = ["songbook","hook","feedback","flashback","soundtrack","punk","drunk", "mistake","huge mistake", "headache","ache"];
var cultureInterestVerbs = ["hook","fame","attack","backtrack","hijack","clack","funk", "wake", "take", "brake"];

var writingInterestNouns = ["rook","reference book","textbook","guidebook","book","hook","swill","quill","daffodil","flashback","megalomaniac","Jack","sack","quack","asscrack","throwback","huge mistake","piece of cake","flake","mistake","game","video game"];
var writingInterestVerbs = ["gobbledygook","shook","look","will","thrill","kill","chill","fire drill","ill","wisecrack","throwback","hoseseback","ransack","take","wake","headache","shake","croak","choke","maim","taim"];

var popCultureInterestNouns = ["flashback","megalomaniac","Jack","sack","quack","asscrack","throwback","huge mistake","piece of cake","flake","mistake","game","video game"];
var popCultureInterestVerbs = ["wisecrack","throwback","hoseseback","ransack","take","wake","headache","shake","croak","choke","maim","taim"];

var technologyInterestNouns = ["hack","jock","gridlock","deadlock","laughingstock", "hot", "bot", "knot", "robot", "thought", "brobot"];
var technologyInterestVerbs = ["hijack","atack","hack","smack","block", "trot", "shot", "plot", "forgot", "rot"];

var socialInterestNouns = ["punk","drunk","shame","heartbreak","mistake","fake","grump","dump","lump","ocelot","hot"];
var socialInterestVerbs = ["blame","fame","brandname","quake","shake","fake","jump","rot","caught"];

var romanticInterestNouns = ["heartbreak","heartache","fake","snake","flake","crock","punk","drunk","hunk","junk","fun","dick", "hot"];
var romanticInterestVerbs = ["heartbreak","sweet talk","talk","walk","stun","fun","sick","click","trick","lick", "caught"];


var academicInterestNouns = ["reference book","book","guidebook","reference book","lunatic","dipstick","brick","jock","laughingstock","quack","junk","monk", "yaught", "watt", "clot", "thought"];
var academicInterestVerbs = ["trick","look","took","shook","small talk","squawk","block","backtrack","yack","attack","crack","smack", "debunk", "forgot", "plot", "watt", "swat", "knot"];

var domesticInterestNouns = ["cake","piece of cake","cupcake","snake","mistake","huge mistake","flake","crock","cock","peacock","laughingstock","shell", "brandname"];
var domesticInterestVerbs = ["bake","shake","wake","heartbreak","small talk","gawk","squawk","block","shellgame","maim","tame","aim"];

var terribleInterestNouns = ["pill","suicide pill","shill","swill","landfill","molehill","standstill","plush rump","hunk rump","rump","chump","snake", "asscrack"];
var terribleInterestVerbs = ["kill","ill","drill","grill","dick","lick","trick","bump","hump","hug bump","take","wake","payback"];

var fantasyInterestNouns = ["fake","fakey-fake","lake","game","fame","brandname"];
var fantasyInterestVerbs = ["ache","make","quake","shake","game","shame","maim","tame"];

var justiceInterestNouns = ["crook","hook","same","game","suicide pill","fire drill","bunch","gun","son","hunch"];
var justiceInterestVerbs = ["took","shook","look","kill","ill","aim","blame","hunch","punch","stun"];



//http://www.rhymezone.com/r/rhyme.cgi?Word=sun&typeofrhyme=perfect&org1=syl&org2=l&org3=y
//most common rhyming sounds are things like "ack", "ake", "ame", "ill", "uck", "ock", "unk", "ump", "ice", "unk"
var wordsRhymehot = ["hot", "bot", "knot", "caught", "robot", "thought", "clot","shot","plot","forgot","yaught","rot","watt","squat","trot","swat","brobot","ocelot"];
var wordsRhymeTown = ["town", "down", "frown", "clown", "brown", "crown", "drown","noun"];
var wordsRhymeJoke = ["bloke","broke","croak","choke","folk","oak","smoke","soak","woke","yolk","yoke","coke", "spoke"];
var wordsRhymeSun = ["bun","fun","gun","son","hun","none","nun","stun","spun","shun","run","won"];
var wordsRhymePunch = ["brunch","punch","lunch","bunch","crunch","hunch","munch","scrunch"];
var wordsRhymeJack = ["jack", "hack","Jack", "black","sack","clack","crack","knack","quack" ,"snack","smack","yack","attack","backtrack","hijack" ,"flashback","feedback","payback","soundtrack","wisecrack","throwback" ,"hunchback","horseback","ransack","asscrack","fallback","carjack","megalomaniac"];
var wordsRhymeFake = ["fake","fakey-fake","ache","bake","brake","break","cake","flake","lake","make","quake","shake","snake","wake","take","awake","cupcake","headache","heartache","heartbreak","mistake","piece of cake","emergency break","huge mistake"];
var wordsRhymeGame = ["game", "name","aim","blame","fame","lame","maim","tame","shellgame","shame","video game","pregame","postgame","brandname"];
var wordsRhymeKill = ["ill","kill","chill","drill","grill","shill","quill","will","thrill","swill","anthill","foothill","downhill","landfill","molehill","standstill","treadmill","daffodil","fire drill","pill","sleeping pill","suicide pill"];
var wordsRhymeSick = ["sick","slick","Billious Slick","brick","click","dick","lick","quick","thick","trick","homesick","dipstick","picnic","yardstick","seasick","lunatic","","","",""];
var wordsRhymeBlock = ["block","cock","hawk","gawk","crock","jock","squawk","talk","walk","bedrock","deadlock","gridlock","hemlock","peacock","small talk","sweet talk","laughingstock"];
var wordsRhymeJunk = ["hunk","junk","flunk","drunk","monk","skunk","sunk","debunk","spelunk","punk","funk","hella drunk"];
var wordsRhymeRump = ["rump","plush rump","hunk rump","chump","bump","hug bump","grump","hump","jump","slump","dump","lump"];
var wordsRhymeCrook = ["crook","nook", "cook", "rook","took","look","shook","hook","guidebook","book","songbook","sketchbook", "textbook", "comic book", "gobbledygook", "reference book"]

var noun = "noun";
var verb = "verb";
var rapTemplates = [new RapTemplate("you must be some kind of ",noun, " sitting there like you think you can ", verb) ];
rapTemplates.push(new RapTemplate("your ass is grass, you ain't got that ",noun, " you have the worst skills that i ever did ", verb) );
rapTemplates.push(new RapTemplate("i got that  ",noun, " you have no ", noun) );
rapTemplates.push(new RapTemplate("I am da best at ",verb, " you aint even tried to ", verb) );
rapTemplates.push(new RapTemplate("all day sittin and chillin and ",verb, " like some kind of ", noun) );
rapTemplates.push(new RapTemplate("bitches think I'm ",noun, " and you all sitting there like you can't ", verb) );
rapTemplates.push(new RapTemplate("I do an acrobatic pirouette off the ",noun, " while you struggle to even ", verb) );
rapTemplates.push(new RapTemplate("you're all up in my ",noun, " like you think it's ", noun) );
rapTemplates.push(new RapTemplate("I'm officially the canidate for having some ",noun, " but you dropped out the race in disgrace for  ", noun) );
rapTemplates.push(new RapTemplate("you know I got the ",noun, " all up and ", verb) );
rapTemplates.push(new RapTemplate("bustin old school ",noun, " like I can't even ", verb) );
rapTemplates.push(new RapTemplate("all day I'm ",verb, " but you can't even ", verb) );
rapTemplates.push(new RapTemplate("should i count all the reasons you're ",noun, " fuck, i got better things to ", verb) );
rapTemplates.push(new RapTemplate("it's too bad my rhymes are so  ",noun, " but I can't even stop ", verb) );


//would be so dope to rap about what's happened in the session.
//could read session summary?
//worry about this LATER, and definitely not in this stand alone page.
//instead of just your interests, can use THEIR interests to diss them.  "Yo, you ain't nothing but a piece of cake, a shake and bake."

function RapTemplate(part1, p1Type, part2, p2Type){
	this.part1 = part1;
	this.part1Type = p1Type;
	this.part2 = part2
	this.part2Type = p2Type;

	this.findWordBasedOnPart1AndInterest = function(interest){
		var wordTypeArray = this.matchInterestToWordTypeArray(interest, this.part1Type);
		if(wordTypeArray){
				return getRandomElementFromArray(wordTypeArray);
		}
		return null;
	}
	//grove is interests, and it don't stop. but also like the shitty gamzeetavros rap, each participant is just rapping about their OWN interests
	//and part of why it's so shitty is no common theme.
	this.matchInterestToWordTypeArray = function(interest,type){
		var ret = null;
		if(comedy_interests.indexOf(interest) != -1 && type == noun){
				ret = comedyInterestNouns;
		}else if(comedy_interests.indexOf(interest) != -1 && type == verb){
			ret = comedyInterestVerbs;
		}else if(athletic_interests.indexOf(interest) != -1 && type == noun){
			ret = athleticInterestNouns;
		}else if(athletic_interests.indexOf(interest) != -1 && type == verb){
			ret = athleticInterestVerbs;
		}else if(music_interests.indexOf(interest) != -1 && type == noun){
			ret = musicInterestNouns;
		}else if(music_interests.indexOf(interest) != -1 && type == verb){
			ret = musicInterestVerbs;
		}else if(writing_interests.indexOf(interest) != -1 && type == noun){
			ret = writingInterestNouns;
		}else if(writing_interests.indexOf(interest) != -1 && type == verb){
			ret = writingInterestVerbs;
		}else if(pop_culture_interests.indexOf(interest) != -1 && type == noun){
			ret = popCultureInterestNouns;
		}else if(pop_culture_interests.indexOf(interest) != -1 && type == verb){
			ret = popCultureInterestVerbs;
		}else if(technology_interests.indexOf(interest) != -1 && type == noun){
			ret = technologyInterestNouns;
		}else if(technology_interests.indexOf(interest) != -1 && type == verb){
			ret = technologyInterestVerbs;
		}else if(social_interests.indexOf(interest) != -1 && type == noun){
			ret = socialInterestNouns;
		}else if(social_interests.indexOf(interest) != -1 && type == verb){
			ret = socialInterestVerbs;
		}else if(romantic_interests.indexOf(interest) != -1 && type == noun){
			ret = romanticInterestNouns;
		}else if(romantic_interests.indexOf(interest) != -1 && type == verb){
			ret = romanticInterestVerbs;
		}else if(academic_interests.indexOf(interest) != -1 && type == noun){
			ret = academicInterestNouns;
		}else if(academic_interests.indexOf(interest) != -1 && type == verb){
			ret = academicInterestVerbs;
		}else if(domestic_interests.indexOf(interest) != -1 && type == noun){
			ret = domesticInterestNouns;
		}else if(domestic_interests.indexOf(interest) != -1 && type == verb){
			ret = domesticInterestVerbs;
		}else if(terrible_interests.indexOf(interest) != -1 && type == noun){
			ret = terribleInterestNouns;
		}else if(terrible_interests.indexOf(interest) != -1 && type == verb){
			ret = terribleInterestVerbs;
		}else if(fantasy_interests.indexOf(interest) != -1 && type == noun){
			ret = fantasyInterestNouns;
		}else if(fantasy_interests.indexOf(interest) != -1 && type == verb){
			ret = fantasyInterestVerbs;
		}else if(justice_interests.indexOf(interest) != -1 && type == noun){
			ret = justiceInterestNouns;
		}else if(justice_interests.indexOf(interest) != -1 && type == verb){
			ret = justiceInterestVerbs;
		}else if(culture_interests.indexOf(interest) != -1 && type == noun){
			ret = cultureInterestNouns;
		}else if(culture_interests.indexOf(interest) != -1 && type == verb){
			ret = cultureInterestVerbs;
		}
		return ret;
	}

	this.matchWordWithRhymeArray = function(word){
		var ret = null;
		if(wordsRhymeTown.indexOf(word) != -1){
			return wordsRhymeTown;
		}else if(wordsRhymeJoke.indexOf(word) != -1){
			return wordsRhymeJoke;
		}else if(wordsRhymeSun.indexOf(word) != -1){
			return wordsRhymeSun;
		}else if(wordsRhymePunch.indexOf(word) != -1){
			return wordsRhymePunch;
		}else if(wordsRhymeJack.indexOf(word) != -1){
			return wordsRhymeJack;
		}else if(wordsRhymeFake.indexOf(word) != -1){
			return wordsRhymeFake;
		}else if(wordsRhymeGame.indexOf(word) != -1){
			return wordsRhymeGame;
		}else if(wordsRhymeKill.indexOf(word) != -1){
			return wordsRhymeKill;
		}else if(wordsRhymeSick.indexOf(word) != -1){
			return wordsRhymeSick;
		}else if(wordsRhymeBlock.indexOf(word) != -1){
			return wordsRhymeBlock;
		}else if(wordsRhymeJunk.indexOf(word) != -1){
			return wordsRhymeJunk;
		}else if(wordsRhymeRump.indexOf(word) != -1){
			return wordsRhymeRump;
		}else if(wordsRhymeCrook.indexOf(word) != -1){
			return wordsRhymeCrook;
		}else if(wordsRhymehot.indexOf(word) != -1){
			return wordsRhymehot;
		}

	}

	this.findWordBasedOnPart2AndInterestAndPart1Word = function(interest,word){
		//first, I need to know which set of rhyming words the word falls in.
		var rhyme_array = this.matchWordWithRhymeArray(word);
		//once I know that, see if I can find one of the rhyming words in the interest verb/noun list.
		var wordTypeArray =  this.matchInterestToWordTypeArray(interest, this.part2Type);
		if(rhyme_array){
			var results = intersection(rhyme_array, wordTypeArray);
		}
		if(!results){
			return null;
		}
		removeFromArray(word, results); //don't even try to rhyme with yourself.
		//console.log("trying to rhyme: " + word + " found: " + results)
		if(results && results.length > 0){
			return getRandomElementFromArray(results);
		}
		return null;

	}

}


//http://stackoverflow.com/questions/1885557/simplest-code-for-array-intersection-in-javascript
//really was a good idea on recursiveSlacker's part.
function intersection (a, b) {
  var seen = a.reduce(function (h, k) {
    h[k] = true;
    return h;
  }, {});

  return b.filter(function (k) {
    var exists = seen[k];
    delete seen[k];
    return exists;
  });
}

function rapMistake(){
	var mistakes = ["...umm...,", "...fuck", "...fuck, can we start over? ", "...pretend I just finished that, okay?", "er...Shit.", "errr...", "ummm...shit.", "...fucking hell.", "what the hell, I know I had a rhyme for this...", "...okay, should I just...like, give up here?"];
	return getRandomElementFromArray(mistakes);

}

function rapInterjection(){
	var interjections = ["Yo", "Trust", "Represent", "Respect", "Word", "Dawg", "Dog", "Bro", "Sup", "Okay", "What", "Yeah", "Aight", "Yeah Dog", "Fo, Shizzle", "Hey", "Boo yeah", "Break it down", "Fuck", "Shit", "Peace", "True that", "Double True", "Word up", "My homey", "Homey", "You knows it"];
	return getRandomElementFromArray(interjections);
}
