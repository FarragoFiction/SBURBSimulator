
//if this seems like it will work, move to random tables. based on recursiveSlacker's idea.
var comedyInterestNouns = ["joke","clown","fun", "folk", "bloke"];
var comedyInterestVerbs = ["joke", "frown", "stun", "soak", "choke", "scrunch"];

var athleticInterestNouns = ["sun","lunch","crown","yolk"];
var athleticInterestVerbs = ["run","punch", "down", "drown", "soak", "won"];
//http://www.rhymezone.com/r/rhyme.cgi?Word=sun&typeofrhyme=perfect&org1=syl&org2=l&org3=y
var wordsRhymeTown = ["town", "down", "frown", "clown", "brown", "crown", "drown","noun"];
var wordsRhymeJoke = ["bloke","broke","croak","choke","folk","oak","smoke","soak","woke","yolk","yoke","coke", "spoke"];

var wordsRhymeSun = ["bun","fun","gun","son","hun","none","nun","stun","spun","shun","run","won"];
var wordsRhymePunch = ["brunch","punch","lunch","bunch","crunch","hunch","munch","scrunch"];


var noun = "noun";
var verb = "verb";
var rapTemplates = [new RapTemplate("Yo, you must be some kind of ",noun, " sitting there like you think you can ", verb) ];
rapTemplates.push(new RapTemplate("Your ass is grass, you ain't got that ",noun, " you have the worst skills that i ever did ", verb) );


//would be so dope to rap about what's happened in the session.
//could read session summary?
//worry about this LATER, and definitely not in this stand alone page.
window.onload = function() {
		rapper1Line("Hello World")
		rapper2Line("Goodbye World");
		//and it don't stop till a rhyme isn't found. points on how many lines you manage. then opponent turn. they try to rhyme their first rhyme with your last.
}

//red text
function rapper1Line(line){
	$("#rap").append("<font color='red'>"+line+"</font><br>")
}

//blue text
function rapper2Line(line){
	$("#rap").append("<font color='blue'>"+line+"</font><br>")
}


function RapTemplate(part1, p1Type, part2, p2Type){
	this.part1 = part1;
	this.part1Type = p1Type;
	this.part2 = part2
	this.part2Type = p2Type;

	this.findWordBasedOnPart1AndInterest = function(interest){
		var wordTypeArray = this.matchInterestToWordTypeArray(interest);
		if(wordTypeArray){
				return getRandomElementFromArray(wordTypeArray);
		}
		return null;
	}

	this.matchInterestToWordTypeArray = function(interest){
		var ret = null;
		if(comedy_interests.indexOf(interest) != -1 && this.part1Type == noun){
				ret = comedyInterestNouns;
		}else if(comedy_interests.indexOf(interest) != -1 && this.part1Type == verb){
			ret = comedyInterestVerbs;
		}else if(athletic_interests.indexOf(interest) != -1 && this.part1Type == noun){
			ret = athleticInterestNouns;
		}else if(athletic_interests.indexOf(interest) != -1 && this.part1Type == verb){
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
		console.log("Rhyme Array: ")
		console.log(rhyme_array)
		//once I know that, see if I can find one of the rhyming words in the interest verb/noun list.
		var wordTypeArray =  this.matchInterestToWordTypeArray(interest);
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
