
function Quirk(){
	this.lettersToReplace = [] //array of two element arrays. ["e", "3"], ["two",2] would be two examples. e replaced by 3 and two replaced by 2
	this.punctuation = 0; //0 = none, 1 = ends of sentences, 2 = perfect punctuation 3= excessive punctuation
	this.spelling = 0;  //0 = bad typos (think roxy), 1 = some typos, 2 = perfect spelling
	this.prefix = ""; //what do you put at the start of a line?
	this.suffix = ""; //what do you put at the end of a line?
	this.capitalization = 0;  //0 == none, 4 = alternating, 5= inverted, 3 = begining of every word, 1 = normal, 2 = ALL 
	this.favoriteNumber = getRandomInt(0,10);
	
	//take an input string and quirkify it.
	this.translate = function(input){
		var ret = input;
		ret = this.handleCapitilization(ret);
		ret = this.handleReplacements(ret);
		ret = this.handlePunctuation(ret);
		ret = this.handlePrefix(ret);  //even if troll speaks in lowercase, 8=D needs to be as is.
		ret = this.handleSuffix(ret);
		return ret;
	}

	this.rawStringExplanation = function(){
		var ret = "\n * Capitalization: ";
		
		if(this.capitalization==0){
			ret += " all lower case "
		}else if(this.capitalization==4){
			ret += " alternating "
		}else if(this.capitalization==5){
			ret += " inverted "
		}else if(this.capitalization==3){
			ret += " begining of every word "
		}else if(this.capitalization==1){
			ret += " normal "
		}else if(this.capitalization==2){
			ret += " all caps "
		}
		
		ret += "\n * Punctuation: "
		if(this.punctuation==0){
			ret += " no punctuation "
		}else if(this.punctuation==1){
			ret += " ends of sentences "
		}else if(this.punctuation==2){
			ret += " perfect punctuation "
		}else if(this.punctuation==3){
			ret += " excessive punctuation "
		}	

		if(this.prefix != ""){
			ret += "\n *  Prefix: " + this.prefix;
		}
		
		if(this.suffix != ""){
			ret += "\n *  Suffix: " + this.suffix;
		}
		
		ret += "\n * Favorite Number: " + this.favoriteNumber;
		
		if(this.lettersToReplace.length > 0){
			ret += " \n * Replaces: "
		}
		for(var i = 0; i<this.lettersToReplace.length; i++){
			//$("#debug").append(i);
			ret += "\n \t " + this.lettersToReplace[i][0] + " with " + this.lettersToReplace[i][1];
		}

		
		return ret;
	}
	
	this.stringExplanation = function(){
		var ret = "<br>Capitalization: ";
		
		if(this.capitalization==0){
			ret += " all lower case "
		}else if(this.capitalization==4){
			ret += " alternating "
		}else if(this.capitalization==5){
			ret += " inverted "
		}else if(this.capitalization==3){
			ret += " begining of every word "
		}else if(this.capitalization==1){
			ret += " normal "
		}else if(this.capitalization==2){
			ret += " all caps "
		}
		
		ret += "<Br> Punctuation: "
		if(this.punctuation==0){
			ret += " no punctuation "
		}else if(this.punctuation==1){
			ret += " ends of sentences "
		}else if(this.punctuation==2){
			ret += " perfect punctuation "
		}else if(this.punctuation==3){
			ret += " excessive punctuation "
		}	

		if(this.prefix != ""){
			ret += "<br> Prefix: " + this.prefix;
		}
		
		if(this.suffix != ""){
			ret += "<br> Suffix: " + this.suffix;
		}
		
		ret += "<br> Favorite Number: " + this.favoriteNumber;
		
		if(this.lettersToReplace.length > 0){
			ret += " <br>Replaces: "
		}
		for(var i = 0; i<this.lettersToReplace.length; i++){
			//$("#debug").append(i);
			ret += "<br>&nbsp&nbsp&nbsp&nbsp " + this.lettersToReplace[i][0] + " with " + this.lettersToReplace[i][1];
		}
		return ret;
	}
	
	this.handlePrefix = function(input){
		return this.prefix + " " + input;
	}
	
	this.handleSuffix=function(input){
		return input + " " + this.suffix;
	}
	
	this.handleReplacements = function(input){
		var ret = input;
		for(var i = 0; i<this.lettersToReplace.length; i++){
			//$("#debug").append("Replacing: " +this.lettersToReplace[i][0] );
			ret= ret.replace(new RegExp(this.lettersToReplace[i][0], 'g'),this.lettersToReplace[i][1]);
		}
		return ret;
	}
	
	this.handlePunctuation = function(input){
		var ret = input;
		if(this.punctuation==0){
			var punctuationless = ret.replace(/[.?,\/#!;:{}=\-_`~()]/g,"");
			ret = punctuationless.replace(/\s{2,}/g," ");
		}else if(this.punctuation==1){
			var punctuationless = ret.replace(/[,\/#;:{}=\-_`~()]/g,"");
			ret = punctuationless.replace(/\s{2,}/g," ");
		}else if(this.punctuation==2){
			ret = input;
		}else if(this.punctuation==3){
			ret = multiplyCharacter(ret,"!", this.favoriteNumber);
			ret = multiplyCharacter(ret,"?", this.favoriteNumber);
		}	
		return ret;
	}
	

	
	this.handleCapitilization = function (input){
		var ret = input;
		if(this.capitalization==0){
			ret = ret.toLowerCase();
		}else if(this.capitalization==4){
			for(var i = 0; i<input.length; i++){
				if(i%2 == 0){
					ret = replaceStringAt(ret, i, ret[i].toLowerCase());
				}else{
					ret = replaceStringAt(ret, i, ret[i].toUpperCase());
				}
			}
		}else if(this.capitalization==5){
			for(var i = 0; i<input.length; i++){
				if(ret[i] == ret[i].toUpperCase()){
					ret = replaceStringAt(ret, i, ret[i].toLowerCase());
				}else{
					ret = replaceStringAt(ret, i, ret[i].toUpperCase());
				}
			}
		}else if(this.capitalization==3){
			ret = ret.replace(/\b\w/g, l => l.toUpperCase());
		}else if(this.capitalization==1){
			ret = input; //no change
		}else if(this.capitalization==2){
			ret = ret.toUpperCase();
		}
		return ret;
	}
	

}

function replaceStringAt(str, index, character){
	return str.substr(0, index) + character + str.substr(index+character.length);
}

function multiplyCharacter(str, character, times){
		//$("#debug").append("<Br>Going to multiply: " + character + " this many times: " + times)
		var tmp = "";
		for(var i = 0; i<times; i++){
			tmp += character;
		}
		return str.replace(character, tmp);
}

function randomHumanQuirk(){
	var ret = new Quirk();
	ret.capitalization = getRandomInt(0,2);
	ret.punctuation = getRandomInt(0,3);
	var roomLeft = getRandomInt(0,6) - ret.lettersToReplace.length;
	if(roomLeft < 0) roomLeft = 0;
	for(var i = 0; i< roomLeft; i++){
		ret.lettersToReplace.push(getOneNormalReplaceArray());
	}
	//$("#debug").append("Human letters to replace: " + ret.lettersToReplace.length);
	return ret;
}

//troll quirks are more extreme
function randomTrollQuirk(){
	var ret = new Quirk();
	ret.capitalization = getRandomInt(0,5);
	ret.punctuation = getRandomInt(0,3);
	if(Math.random() > .5){
		ret.prefix = getRandomElementFromArray(prefixes);
		if(ret.prefix.length == 1){
			ret.prefix = multiplyCharacter(ret.prefix, ret.prefix[0], ret.favoriteNumber);
		}
	}
	if(Math.random() > .5){
		if(ret.prefix != "" && Math.random()>.7){ //mostly just repeat your prefix
			ret.suffix = ret.prefix;
		}else{
			ret.suffix = getRandomElementFromArray(prefixes);
		}
		
		if(ret.suffix.length == 1){
			ret.suffix  = multiplyCharacter(ret.suffix, ret.suffix[0], ret.favoriteNumber);
		}
	}
	
	if(ret.favoriteNumber == 1){
		if(Math.random()>.5) ret.lettersToReplace.push(["I","1"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["i","1"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["l","1"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["L","1"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["won","1"]);
	}else if(ret.favoriteNumber == 2){
		if(Math.random()>.5) ret.lettersToReplace.push(["S","2"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["s","2"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["Z","2"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["z","2"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["too","2"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["to","2"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["two","2"]);
	}else if(ret.favoriteNumber == 3){
		if(Math.random()>.5) ret.lettersToReplace.push(["E","3"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["e","3"]);
	}else if(ret.favoriteNumber == 4){
		if(Math.random()>.5) ret.lettersToReplace.push(["A","4"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["a","4"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["for","4"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["four","4"]);
	}else if(ret.favoriteNumber == 5){
		if(Math.random()>.5) ret.lettersToReplace.push(["S","5"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["s","5"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["Z","5"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["z","5"]);
	}else if(ret.favoriteNumber == 6){
		if(Math.random()>.5) ret.lettersToReplace.push(["G","6"]);
	}else if(ret.favoriteNumber == 7){
		if(Math.random()>.5) ret.lettersToReplace.push(["T","7"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["t","7"]);
	}else if(ret.favoriteNumber == 8){
		if(Math.random()>.5) ret.lettersToReplace.push(["ate","8"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["eight","8"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["EIGHT","8"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["B","8"]);
	}else if(ret.favoriteNumber == 9){
		if(Math.random()>.5) ret.lettersToReplace.push(["g","9"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["nine","9"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["NINE","9"]);
	}else if(ret.favoriteNumber == 10){
		if(Math.random()>.5) ret.lettersToReplace.push(["ten","10"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["TEN","10"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["lo","10"]);
	}else if(ret.favoriteNumber == 11){
		if(Math.random()>.5) ret.lettersToReplace.push(["ll","11"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["II","11"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["ii","11"]);
	}else if(ret.favoriteNumber == 12){
		if(Math.random()>.5) ret.lettersToReplace.push(["is","12"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["IS","12"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["iz","12"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["IZ","12"]);
	}else if(ret.favoriteNumber == 0){
		if(Math.random()>.5) ret.lettersToReplace.push(["o","0"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["O","0"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["oh","0"]);
		if(Math.random()>.5) ret.lettersToReplace.push(["OH","0"]);
	}
	var roomLeft = getRandomInt(0,6) - ret.lettersToReplace.length;
	if(roomLeft < 0) roomLeft = 0;
	for(var i = 0; i< roomLeft; i++){
		ret.lettersToReplace.push(getOneRandomReplaceArray());
	}
	
	return ret;
}

function getOneNormalReplaceArray(){
	if(Math.random()>.9) return["ing","in"];
	if(Math.random()>.9) return["have to","hafta"];
	if(Math.random()>.9) return["Have to","Hafta"];
	if(Math.random()>.9) return["want to","wanna"];
	if(Math.random()>.9) return["going to","gonna"];
	if(Math.random()>.9) return["Want to","wanna"];
	if(Math.random()>.9) return["Going to","gonna"];
	if(Math.random()>.9) return["I'm","I am"];
	if(Math.random()>.9) return["You're","you are"];
	if(Math.random()>.9) return["We're","we are"];
	if(Math.random()>.9) return["Don't","do not"];
	if(Math.random()>.9) return["Won't","will not"];
	if(Math.random()>.9) return["Didn't","did not"];
	if(Math.random()>.9) return["Can't","can't"];
	if(Math.random()>.9) return["We'll","We will"];
	if(Math.random()>.9) return["you're","you are"];
	if(Math.random()>.9) return["we're","we are"];
	if(Math.random()>.9) return["don't","do not"];
	if(Math.random()>.9) return["won't","will not"];
	if(Math.random()>.9) return["didn't","did not"];
	if(Math.random()>.9) return["can't","can not"];
	if(Math.random()>.9) return["ro","bro"];
	if(Math.random()>.9) return["Ro","Bro"];
	if(Math.random()>.9) return["aren't","aint"];
	if(Math.random()>.9) return["Aren't","Aint"];
	return ["hackers","haxorz"];
}

//% to cross or x.  8 for b.  69 for oo.  o+ for o 
function getOneRandomReplaceArray(){
	if(Math.random()>.9) return["x","%"];
	if(Math.random()>.9) return["X","%"];
	if(Math.random()>.9) return["ing","in"];
	if(Math.random()>.9) return["s","z"];
	if(Math.random()>.9) return["w","vv"];
	if(Math.random()>.9) return["w","v"];
	if(Math.random()>.9) return["v","w"];
	if(Math.random()>.9) return["!","~"];
	if(Math.random()>.9) return["N","|\\/"];
	if(Math.random()>.9) return["M","|\\/|"];
	if(Math.random()>.9) return["W","\\/\\/"];
	if(Math.random()>.9) return["H",")("];
	if(Math.random()>.9) return["H","|-|"];
	if(Math.random()>.9) return["oo","69"];
	if(Math.random()>.9) return["OO","69"];
	if(Math.random()>.9) return["o","o+"];
	if(Math.random()>.9) return["plus","+"];
	if(Math.random()>.9) return["happy",":)"];
	if(Math.random()>.9) return["sad",":("];
	if(Math.random()>.9) return["love","<3"];
	if(Math.random()>.9) return["loo","100"];
	if(Math.random()>.9) return["dog","cat"];
	
	return getOneNormalReplaceArray(); //if i get here, just do a normal one.
}
