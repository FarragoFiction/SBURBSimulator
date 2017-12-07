import "../SBURBSim.dart";

//http://www.rhymezone.com/r/rhyme.cgi?Word=back&typeofrhyme=perfect&org1=syl&org2=l&org3=y;
//if this seems like it will work, move to random tables. based on recursiveSlacker's idea.
List<String> comedyInterestNouns = ["joke","clown","fun", "folk", "bloke","quack","flashback","piece of cake","shell game","skunk","debunk", "grump", "first-rate","mandate", "card trick","card you pick"];
List<String> comedyInterestVerbs = ["joke", "frown", "stun", "soak", "choke", "scrunch", "wisecrack","smack","attack","crack","emergency break","flunk","jump", "copulate","syncopate"];

List<String> athleticInterestNouns = ["heavyweight","teammate","lightweight","deadweight","sun","lunch","crown","brown", "clown","yolk","seasick","smalltalk","hella drunk","punk","drunk","yardstick","pregame","postgame"];
List<String> athleticInterestVerbs = ["run","punch", "down", "drown", "soak", "won","block","sunk","spelunk","aim","maim","tame", "castrate", "asphyxiate","suffocate","strangulate","decontaminate","dictate"];

List<String> musicInterestNouns = ["trait","songbook","wack","hook","feedback","flashback","soundtrack","punk","drunk","flashback","megalomaniac","Jack","sack","quack","asscrack","throwback","huge mistake","piece of cake","flake","mistake","game","video game"];
List<String> musicInterestVerbs = ["mitigate","hook","fame","attack","backtrack","hijack","clack","funk","wisecrack","throwback","horseback","ransack","take","wake","headache","shake","croak","choke","maim","tame"];

List<String> cultureInterestNouns = ["songbook","hook","feedback","flashback","soundtrack","punk","drunk", "mistake","huge mistake", "headache","ache"];
List<String> cultureInterestVerbs = ["hook","fame","attack","backtrack","hijack","clack","funk", "wake", "take", "brake"];

List<String> writingInterestNouns = ["rook","reference book","textbook","guidebook","book","hook","swill","quill","daffodil","flashback","megalomaniac","Jack","sack","quack","asscrack","throwback","huge mistake","piece of cake","flake","mistake","game","video game"];
List<String> writingInterestVerbs = ["gobbledygook","shook","look","will","thrill","kill","chill","fire drill","ill","wisecrack","throwback","hoseseback","ransack","take","wake","headache","shake","croak","choke","maim","tame"];

List<String> popCultureInterestNouns = ["flashback","wack","megalomaniac","Jack","sack","quack","asscrack","throwback","huge mistake","piece of cake","flake","mistake","game","video game"];
List<String> popCultureInterestVerbs = ["wisecrack","throwback","hoseseback","ransack","take","wake","headache","shake","croak","choke","maim","tame"];

List<String> technologyInterestNouns = ["hack","jock","gridlock","solid-state", "subordinate","inmate", "teammate","deadlock","laughingstock", "hot", "bot", "knot", "robot", "thought", "brobot"];
List<String> technologyInterestVerbs = ["calculate", "accumulate", "concentrate","regurgitate","simulate", "hijack","atack","terminate","propogate","hack","smack","block", "trot", "shot", "plot", "forgot", "rot"];

List<String> socialInterestNouns = ["teammate", "inmate", "late", "first-rate","punk","drunk","shame","heartbreak","mistake","fake","grump","dump","lump","ocelot","hot", "moderate"];
List<String> socialInterestVerbs = ["mitigate", "renovate", "accommodate","blame","fame","brandname","quake","shake","fake","jump","rot","caught", "moderate","plait"];

List<String> romanticInterestNouns = ["heartbreak","heartache","fake","snake","flake","crock","punk","drunk","hunk","junk","fun","dick", "hot"];
List<String> romanticInterestVerbs = ["heartbreak","sweet talk","talk","walk","stun","fun","sick","click","trick","lick", "caught"];


List<String> academicInterestNouns = ["trait", "same", "brain", "teammate","reference book","book","guidebook","reference book","lunatic","dipstick","brick","jock","laughingstock","quack","junk","monk", "yaught", "watt", "clot", "thought"];
List<String> academicInterestVerbs = ["trick", "calculate","look","took","shook","small talk","squawk","block","backtrack","yack","attack","crack","smack", "debunk", "forgot", "plot", "watt", "swat", "knot", "concentrate", "contemplate", "nauseate", "navigate", "overstate", "aim","simulate", "debate","checkmate", "abate", "germinate", "obfuscate", "pontificate","potassium dichromate", "prognosticate"];

List<String> domesticInterestNouns = ["cake", "teammate", "prognosticate", "lightweight", "deadweight", "piece of cake","cupcake","snake","mistake","huge mistake","flake","crock","cock","peacock","laughingstock","shell", "brandname"];
List<String> domesticInterestVerbs = ["communicate", "renovate","activate", "decorate", "nauseate", "contemplate", "overstate", "germinate", "bake","shake","wake","heartbreak","small talk","gawk","squawk","block","shellgame","maim","tame","aim", "plait"];

List<String> terribleInterestNouns = ["pill","retrobate","suicide pill","shill","swill","landfill","molehill","standstill","plush rump","hunk rump","rump","chump","snake", "asscrack", "inmate", "degenerate","trait","freight","subordinate","deadweight","teammate","shipmate", "rebate"];
List<String> terribleInterestVerbs = ["kill", "copulate","ill","drill","grill","dick","lick","trick","bump","hump","subjugate","hug bump","take","wake","payback", "assassinate","eviscerate","depopulate","terminate","checkmate","titillate","mutilate", "penetrate", "segregate","desecrate","immolate","mandate","dictate","exacerbate","accumulate"];

List<String> fantasyInterestNouns = ["fake","fakey-fake","lake","game","fame","brandname"];
List<String> fantasyInterestVerbs = ["ache","make","quake","shake","game","shame","maim","tame"];

List<String> justiceInterestNouns = ["crook","hook","same","game","suicide pill","fire drill","bunch","gun","son","hunch"];
List<String> justiceInterestVerbs = ["took","shook","look","kill","ill","aim","blame","hunch","punch","stun"];



//http://www.rhymezone.com/r/rhyme.cgi?Word=sun&typeofrhyme=perfect&org1=syl&org2=l&org3=y;
//most common rhyming sounds are things like "ack", "ake", "ame", "ill", "uck", "ock", "unk", "ump", "ice", "unk"
//gotta give the trolls with 8 quirks love.
List<String> wordsRhymeLate = ["late", "eight", "ate", "wait", "weight", "bait", "date","fate","freight","gate","gait","mate","plate","plait","straight","trait","abate","abate","birthddate","castrate","checkmate","create","dictate","debate","donate","first-rate","flowrate","rate","inmate","mandate","locate","ornate","rebate","shipmate","teammate","activate","actuate","communicate","callibrate",
//holy shit,t here's still more????????
	"bitrate","calculate","retrobate","concentrate","copulate","contemplate","decorate","desecrate","germinate","heavyweight","lightweight","immolate","instigate","liquidate",
	"mitigate","obfuscate,","mitigate","moderate","mutilate","nauseate","navigate","overstate","penetrate","propagate","renovate","segregate","simulate","solid-state","subjugate","strangulate","suffocate","syncopate","terminate","titillate",
	"accommodate","accumulate","assassinate","assimilate","asphyxiate","deadweight","degenerate","depopulate","exacerbate","eviscerate","pontificate","prognosticate","regurgitate","subordinate","resuscitate","decontaminate","potassium dichromate "];

List<String> wordsRhymehot = ["hot", "bot", "knot", "caught", "robot", "thought", "clot","shot","plot","forgot","yaught","rot","watt","squat","trot","swat","brobot","ocelot","naught","shot"];
List<String> wordsRhymeTown = ["town", "down", "frown", "clown", "brown", "crown", "drown","noun"];
List<String> wordsRhymeJoke = ["bloke","broke","croak","choke","folk","oak","smoke","soak","woke","yolk","yoke","coke", "spoke"];
List<String> wordsRhymeSun = ["bun","fun","gun","son","hun","none","nun","stun","spun","shun","run","won"];
List<String> wordsRhymePunch = ["brunch","punch","lunch","bunch","crunch","hunch","munch","scrunch"];
List<String> wordsRhymeJack = ["jack", "hack","Jack", "black","sack","clack","crack","knack","quack" ,"wack","snack","smack","yack","attack","backtrack","hijack" ,"flashback","feedback","payback","soundtrack","wisecrack","throwback" ,"hunchback","horseback","ransack","asscrack","fallback","carjack","megalomaniac"];
List<String> wordsRhymeFake = ["fake","fakey-fake","ache","bake","brake","break","cake","flake","lake","make","quake","shake","snake","wake","take","awake","cupcake","headache","heartache","heartbreak","mistake","piece of cake","emergency break","huge mistake"];
List<String> wordsRhymeGame = ["game", "brain", "same","name","aim","blame","fame","lame","maim","tame","shellgame","shame","video game","pregame","postgame","brandname"];
List<String> wordsRhymeKill = ["ill","kill","chill","drill","grill","shill","quill","will","thrill","swill","anthill","foothill","downhill","landfill","molehill","standstill","treadmill","daffodil","fire drill","pill","sleeping pill","suicide pill"];
List<String> wordsRhymeSick = ["sick","slick","Billious Slick","brick","click","dick","lick","quick","thick","trick","homesick","dipstick","picnic","yardstick","seasick","lunatic","","","",""];
List<String> wordsRhymeBlock = ["block","cock","hawk","gawk","crock","jock","squawk","talk","walk","bedrock","deadlock","gridlock","hemlock","peacock","small talk","sweet talk","laughingstock"];
List<String> wordsRhymeJunk = ["hunk","junk","flunk","drunk","monk","skunk","sunk","debunk","spelunk","punk","funk","hella drunk"];
List<String> wordsRhymeRump = ["rump","plush rump","hunk rump","chump","bump","hug bump","grump","hump","jump","slump","dump","lump"];
List<String> wordsRhymeCrook = ["crook","nook", "cook", "rook","took","look","shook","hook","guidebook","book","songbook","sketchbook", "textbook", "comic book", "gobbledygook", "reference book"];

enum RapPart {
	NOUN,
	VERB
}

List<RapTemplate> rapTemplates = [
	new RapTemplate("you must be some kind of ",RapPart.NOUN, " sitting there like you think you can ", RapPart.VERB), 
	new RapTemplate("your ass is grass, you ain't got that ",RapPart.NOUN, " you have the worst skills that i ever did ", RapPart.VERB),
	new RapTemplate("i got that  ",RapPart.NOUN, " you have no ", RapPart.NOUN),
	new RapTemplate("I am da best at ",RapPart.VERB, " you aint even tried to ", RapPart.VERB),
	new RapTemplate("all day sittin and chillin and ",RapPart.VERB, " like some kind of ", RapPart.NOUN),
	new RapTemplate("bitches think I'm ",RapPart.NOUN, " and you all sitting there like you can't ", RapPart.VERB),
	new RapTemplate("I do an acrobatic pirouette off the ",RapPart.NOUN, " while you struggle to even ", RapPart.VERB),
	new RapTemplate("you're all up in my ",RapPart.NOUN, " like you think it's ", RapPart.NOUN),
	new RapTemplate("I'm officially the canidate for having some ",RapPart.NOUN, " but you dropped out the race in disgrace for  ", RapPart.NOUN),
	new RapTemplate("you know I got the ",RapPart.NOUN, " all up and ", RapPart.VERB),
	new RapTemplate("bustin old school ",RapPart.NOUN, " like I can't even ", RapPart.VERB),
	new RapTemplate("all day I'm ",RapPart.VERB, " but you can't even ", RapPart.VERB),
	new RapTemplate("should i count all the reasons you're ",RapPart.NOUN, " fuck, i got better things to ", RapPart.VERB),
	new RapTemplate("it's too bad my rhymes are so  ",RapPart.NOUN, " but I can't even stop to ", RapPart.VERB),
	
	//just read through and it don't stop (mirror: http://anditd0ntstop.tumblr.com) for more template inspiration.
	new RapTemplate("you're getting served so hard it's like you're a ",RapPart.NOUN, " and I'm your very own butler making sure to ", RapPart.VERB),
	new RapTemplate("why don't you polish my  ",RapPart.NOUN, " it's the closest you'll ever get to ", RapPart.VERB),
	new RapTemplate("I'll beat your ass and then if I'm  ",RapPart.VERB, " I'll even take the time to lock you in a ", RapPart.NOUN),
	new RapTemplate("when you see me you start feeling your ",RapPart.NOUN, " but I can't blame you, you just a ", RapPart.NOUN),
	new RapTemplate("you think i'm ",RapPart.VERB, " just because i sit here rapping with a  ", RapPart.NOUN),
	new RapTemplate("my raps are so good you know they ain't  ",RapPart.NOUN, " if you don't respect you must be a ", RapPart.NOUN),
	new RapTemplate("I'm the rap king of  ",RapPart.NOUN, " and you ain't fit to ", RapPart.VERB),
	new RapTemplate("my flow is chicken fried ",RapPart.NOUN, " and you think you can ", RapPart.VERB),
	new RapTemplate("you're  ",RapPart.NOUN, " but you think you're ", RapPart.NOUN),
	new RapTemplate("why you think you belong in that sweetest of ",RapPart.NOUN, " when you aint even fit to lick my ", RapPart.NOUN),
	
	new RapTemplate("your heads all  ",RapPart.VERB, " like you got a bad ", RapPart.NOUN),
	new RapTemplate("everybody already thinks you're a ",RapPart.NOUN, " gotta say you ain't doing anything to ", RapPart.VERB),
	new RapTemplate("your rhymes are so  ",RapPart.NOUN, " that even my Guardian could do better ", RapPart.VERB),
	new RapTemplate("as I turn up the heat you turn up the  ",RapPart.NOUN, " but how that gonna save you when you can't even ", RapPart.VERB),
	new RapTemplate("this shit is such a flagrant  ",RapPart.VERB, " you really think you fooling the ", RapPart.NOUN),
	new RapTemplate("you're just a wealth of ",RapPart.NOUN, " and I'm fixin to inherit ", RapPart.NOUN),
	new RapTemplate("your tiny little  ",RapPart.NOUN, " doesn't even seem to ", RapPart.VERB),
	new RapTemplate("I got beats and rhymes that never been ",RapPart.VERB, " how you think you can ", RapPart.VERB),
	new RapTemplate("I think you might actually be a ",RapPart.NOUN, " cause how else do you explain why you think you can ", RapPart.VERB),
	
	//bop de boop lets rhyme"
	new RapTemplate("if you can't prove you are not a ",RapPart.NOUN, " then the proof is there that you are nothing but a ",RapPart.NOUN ),
	new RapTemplate("if my rhymes are ",RapPart.NOUN," its nothing but me knowing how to ",RapPart.VERB),
	new RapTemplate("it is not my fault you are such a ",RapPart.NOUN,", thats what happens when you just can't ",RapPart.VERB),
	new RapTemplate("don't even " ,RapPart.VERB," kid, we all know you are a ",RapPart.NOUN),
	new RapTemplate("now I am the best fucking ",RapPart.NOUN," that ever did ",RapPart.VERB),
	new RapTemplate("it is time to ",RapPart.VERB,", so you best fucking ",RapPart.VERB),
	new RapTemplate("because the truth is that I am a ",RapPart.NOUN," and you are a ",RapPart.NOUN),
	new RapTemplate("learn your place, if you can't ",RapPart.VERB," you are not a ",RapPart.NOUN),
];


//would be so dope to rap about what's happened in the session.
//could read session summary?
//worry about this LATER, and definitely not in this stand alone page.
//instead of just your interests, can use THEIR interests to diss them.  "Yo, you ain't nothing but a piece of cake, a shake and bake."

class RapTemplate {
	String part1;
	RapPart part1Type;
	String part2;
	RapPart part2Type;


	RapTemplate(String this.part1, RapPart this.part1Type, String this.part2, RapPart this.part2Type) {}


	List<String> getRapLineForPlayer(Player player){
			Interest interest = player.session.rand.pickFrom(<Interest>[player.interest1, player.interest2]);
			String firstWord = this.findWordBasedOnPart1AndInterest(player.session.rand, interest);
			String secondWord = null;
		  firstWord = tryToUseRhyme(firstWord, player);
			if(firstWord == null){
				//second shot for first word
				firstWord = this.findWordBasedOnPart1AndInterest(player.session.rand, interest);
			  firstWord = tryToUseRhyme(firstWord, player);
			}
			////print("first word final is: " + firstWord);
			if(firstWord != null){
			  secondWord = this.findWordBasedOnPart2AndInterestAndPart1Word(player.session.rand, interest, firstWord);
				////print("second word is: " + secondWord);
			  secondWord = tryToUseRhyme(secondWord, player);
				if(secondWord == null){
					//second shot for first word
					secondWord = this.findWordBasedOnPart2AndInterestAndPart1Word(player.session.rand, interest, firstWord);
					////print("second word2 is: " + secondWord);
				  secondWord = tryToUseRhyme(secondWord, player);
				}
		}
			////print("second word final is: " + secondWord);
			String str = "";
			str += rapInterjection(player.session.rand) + ", " + this.part1;
			if(firstWord != null){
					str += firstWord;
					str += this.part2;
					if(secondWord != null){
						str += secondWord + ".";
					}else{
						str += rapMistake(player.session.rand);
					}
			}else{
				str += rapMistake(player.session.rand);
			}
			return [player.chatHandleShort()+ ": "+player.quirk.translate(str), firstWord, secondWord];
	}
	String findWordBasedOnPart1AndInterest(Random rand, Interest interest){
		List<String> wordTypeArray = this.matchInterestToWordTypeArray(interest, this.part1Type);
		if(wordTypeArray != null){
				return rand.pickFrom(wordTypeArray);
		}
		return null;
	}
	List<String> matchInterestToWordTypeArray(Interest interest, RapPart type){
		List<String> ret = null;
		if(interest.category == InterestManager.COMEDY && type == RapPart.NOUN){
				ret = comedyInterestNouns;
		}else if(interest.category == InterestManager.COMEDY && type == RapPart.VERB){
			ret = comedyInterestVerbs;
		}else if(interest.category == InterestManager.ATHLETIC && type == RapPart.NOUN){
			ret = athleticInterestNouns;
		}else if(interest.category == InterestManager.ATHLETIC && type == RapPart.VERB){
			ret = athleticInterestVerbs;
		}else if(interest.category == InterestManager.MUSIC && type == RapPart.NOUN){
			ret = musicInterestNouns;
		}else if(interest.category == InterestManager.MUSIC && type == RapPart.VERB){
			ret = musicInterestVerbs;
		}else if(interest.category == InterestManager.WRITING && type == RapPart.NOUN){
			ret = writingInterestNouns;
		}else if(interest.category == InterestManager.WRITING && type == RapPart.VERB){
			ret = writingInterestVerbs;
		}else if(interest.category == InterestManager.POPCULTURE && type == RapPart.NOUN){
			ret = popCultureInterestNouns;
		}else if(interest.category == InterestManager.POPCULTURE && type == RapPart.VERB){
			ret = popCultureInterestVerbs;
		}else if(interest.category == InterestManager.TECHNOLOGY && type == RapPart.NOUN){
			ret = technologyInterestNouns;
		}else if(interest.category == InterestManager.TECHNOLOGY && type == RapPart.VERB){
			ret = technologyInterestVerbs;
		}else if(interest.category == InterestManager.SOCIAL && type == RapPart.NOUN){
			ret = socialInterestNouns;
		}else if(interest.category == InterestManager.SOCIAL && type == RapPart.VERB){
			ret = socialInterestVerbs;
		}else if(interest.category == InterestManager.ROMANTIC && type == RapPart.NOUN){
			ret = romanticInterestNouns;
		}else if(interest.category == InterestManager.ROMANTIC && type == RapPart.VERB){
			ret = romanticInterestVerbs;
		}else if(interest.category == InterestManager.ACADEMIC && type == RapPart.NOUN){
			ret = academicInterestNouns;
		}else if(interest.category == InterestManager.ACADEMIC && type == RapPart.VERB){
			ret = academicInterestVerbs;
		}else if(interest.category == InterestManager.DOMESTIC&& type == RapPart.NOUN){
			ret = domesticInterestNouns;
		}else if(interest.category == InterestManager.DOMESTIC && type == RapPart.VERB){
			ret = domesticInterestVerbs;
		}else if(interest.category == InterestManager.TERRIBLE && type == RapPart.NOUN){
			ret = terribleInterestNouns;
		}else if(interest.category == InterestManager.TERRIBLE && type == RapPart.VERB){
			ret = terribleInterestVerbs;
		}else if(interest.category == InterestManager.FANTASY && type == RapPart.NOUN){
			ret = fantasyInterestNouns;
		}else if(interest.category == InterestManager.FANTASY && type == RapPart.VERB){
			ret = fantasyInterestVerbs;
		}else if(interest.category == InterestManager.JUSTICE && type == RapPart.NOUN){
			ret = justiceInterestNouns;
		}else if(interest.category == InterestManager.JUSTICE && type == RapPart.VERB){
			ret = justiceInterestVerbs;
		}else if(interest.category == InterestManager.CULTURE && type == RapPart.NOUN){
			ret = cultureInterestNouns;
		}else if(interest.category == InterestManager.CULTURE && type == RapPart.VERB){
			ret = cultureInterestVerbs;
		}
		return ret;
	}
	List<String> matchWordWithRhymeArray(word){
		//List<String> ret = null;
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
		}else if(wordsRhymeLate.indexOf(word) != -1){
			return wordsRhymeLate;
		}
		return null;
	}

	dynamic findWordBasedOnPart2AndInterestAndPart1Word(Random rand, Interest interest, String word){
		//first, I need to know which set of rhyming words the word falls in.
		List<String> rhyme_array = this.matchWordWithRhymeArray(word);
		//once I know that, see if I can find one of the rhyming words in the interest verb/noun list.
		List<String> wordTypeArray = this.matchInterestToWordTypeArray(interest, this.part2Type);
		var results = null;
		if(rhyme_array != null){
			results = intersection(rhyme_array, wordTypeArray);
		}
		if(results == null){
			return null;
		}
		removeFromArray(word, results); //don't even try to rhyme with yourself.
		////print("trying to rhyme: " + word + " found: " + results);
		if(results != null && results.length > 0){
			return rand.pickFrom(results);
		}
		return null;

	}


}



dynamic tryToUseRhyme(rhyme, player){
		var usedRhymes = player.sickRhymes;

		if(usedRhymes.indexOf(rhyme) == -1){
			usedRhymes.add(rhyme);
			return rhyme;
		}
		//the rhyme is not fresh.
		return null;
}



//http://stackoverflow.com/questions/1885557/simplest-code-for-array-intersection-in-javascript
//really was a good idea on recursiveSlacker's part.
/*function intersection (a, b) {
  var seen = a.reduce((h, k) {;
    h[k] = true;
    return h;
  }, {});

  return b.filter((k) {;
    var exists = seen[k];
    delete seen[k];
    return exists;
  });
}*/

List<T> intersection<T>(List<T> a, List<T> b) => a.where((T item) => b.contains(item)).toList();

String rapMistake(Random rand) {
	var mistakes = ["...umm...,", "...fuck", "...fuck, can we start over? ", "...pretend I just finished that, okay?", "er...Shit.", "errr...", "ummm...shit.", "...fucking hell.", "what the hell, I know I had a rhyme for this...", "...okay, should I just...like, give up here?","and gog fucking damn it", "...fuuuuuuuuuuuuuuuuuu","... fuck my life"];
	return rand.pickFrom(mistakes);
}



dynamic rapInterjection(Random rand){
	var interjections = ["Yo", "Friend","Trust", "Represent", "Respect", "Word", "Dawg", "Dog", "Bro", "Sup", "Okay", "What", "Yeah", "Aight", "Yeah Dog", "Fo, Shizzle", "Hey", "Boo yeah", "Break it down", "Fuck", "Shit", "Peace", "True that", "Double True", "Word up", "My homey", "Homey", "You knows it", "Listen up","Back the fuck up","3,2,1"];
	return rand.pickFrom(interjections);
}






List<dynamic> getRapForPlayer(Player player, String returnString, num score) {
	if(player.session.mutator.rapsAndLuckDisabled) return ["Guess you don't appreciate raps. Asshole. ",-13];
	var chosenRapTemplate = player.session.rand.pickFrom(rapTemplates);
	var raps = chosenRapTemplate.getRapLineForPlayer(player);
	var str = raps[0];
	var firstWord = raps[1];
	var secondWord = raps[2];
	returnString += str + " \n";

	if(firstWord != null && secondWord != null && firstWord != secondWord){
				score ++;
				//dont rap forever, like you can on rap.html
				if(score<5) return getRapForPlayer(player, returnString, score); //keep going till you can't
	}else{
		//give up
	}
	return [returnString, score];
}
