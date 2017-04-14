//http://www.rhymezone.com/r/rhyme.cgi?Word=back&typeofrhyme=perfect&org1=syl&org2=l&org3=y
//if this seems like it will work, move to random tables. based on recursiveSlacker's idea.
var comedyInterestNouns = ["joke","clown","fun", "folk", "bloke"];
var comedyInterestVerbs = ["joke", "frown", "stun", "soak", "choke", "scrunch", "wisecrack"];

var athleticInterestNouns = ["sun","lunch","crown","yolk"];
var athleticInterestVerbs = ["run","punch", "down", "drown", "soak", "won"];
//http://www.rhymezone.com/r/rhyme.cgi?Word=sun&typeofrhyme=perfect&org1=syl&org2=l&org3=y

//most common rhyming sounds are things like "ack", "ake", "ame", "ill", "uck", "ock", "unk", "ump", "ice", "unk"
var wordsRhymeTown = ["town", "down", "frown", "clown", "brown", "crown", "drown","noun"];
var wordsRhymeJoke = ["bloke","broke","croak","choke","folk","oak","smoke","soak","woke","yolk","yoke","coke", "spoke"];
var wordsRhymeSun = ["bun","fun","gun","son","hun","none","nun","stun","spun","shun","run","won"];
var wordsRhymePunch = ["brunch","punch","lunch","bunch","crunch","hunch","munch","scrunch"];
//var wordsRhymeJack = ["jack", "black","sack","clack","crack","knack","quack" "snack","smack","yack","attack","backtrack","hijack" "flashback","feedback","payback","soundtrack","wisecrack","throwback" ,"hunchback","horseback","ransack","asscrack","fallback","carjack"];

var noun = "noun";
var verb = "verb";
var rapTemplates = [new RapTemplate("Yo, you must be some kind of ",noun, " sitting there like you think you can ", verb) ];
rapTemplates.push(new RapTemplate("Your ass is grass, you ain't got that ",noun, " you have the worst skills that i ever did ", verb) );
rapTemplates.push(new RapTemplate("I got that  ",noun, " you have no ", noun) );
rapTemplates.push(new RapTemplate("You think you're a ",noun, " but you can't even ", verb) );



//would be so dope to rap about what's happened in the session.
//could read session summary?
//worry about this LATER, and definitely not in this stand alone page.

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
		console.log(this.part1Type);
		if(comedy_interests.indexOf(interest) != -1 && type == noun){
				ret = comedyInterestNouns;
		}else if(comedy_interests.indexOf(interest) != -1 && type == verb){
			ret = comedyInterestVerbs;
		}else if(athletic_interests.indexOf(interest) != -1 && type == noun){
			ret = athleticInterestNouns;
		}else if(athletic_interests.indexOf(interest) != -1 && type == verb){
			ret = athleticInterestVerbs;
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
