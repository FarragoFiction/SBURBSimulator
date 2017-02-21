
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
	arr = [];
	arr.push(["ing","in"]);
	arr.push(["have to","hafta"]);
	arr.push(["Have to","Hafta"]);
	arr.push(["want to","wanna"]);
	arr.push(["going to","gonna"]);
	arr.push(["Want to","wanna"]);
	arr.push(["Going to","gonna"]);
	arr.push(["I'm","I am"]);
	arr.push(["You're","you are"]);
	arr.push(["We're","we are"]);
	arr.push(["Don't","do not"]);
	arr.push(["Won't","will not"]);
	arr.push(["Didn't","did not"]);
	arr.push(["Can't","can't"]);
	arr.push(["We'll","We will"]);
	arr.push(["you're","you are"]);
	arr.push(["we're","we are"]);
	arr.push(["don't","do not"]);
	arr.push(["won't","will not"]);
	arr.push(["didn't","did not"]);
	arr.push(["can't","can not"]);
	arr.push(["ro","bro"]);
	arr.push(["Ro","Bro"]);
	arr.push(["the","teh"]);
	arr.push(["aren't","aint"]);
	arr.push(["Aren't","Aint"]);
	arr.push(["ie","ei"]);
	arr.push(["though","tho"]);
	arr.push(["you","u"]);
	arr.push(["right", "rite"]);
	return getRandomElementFromArray(arr);
}

//% to cross or x.  8 for b.  69 for oo.  o+ for o 
function getOneRandomReplaceArray(){
	arr = [["x","%"],["X","%"],["s","z"],["w","vv"],["w","v"],["v","w"],["!","~"],["N","|\\/"]];
	arr.push(["M","|\\/|"]);
	arr.push(["W","\\/\\/"]);
	arr.push(["H",")("]);
	arr.push(["H","|-|"]);
	arr.push(["oo","69"]);
	arr.push(["OO","69"]);
	arr.push(["o","o+"]);
	arr.push(["plus","+"]);
	arr.push(["happy",":)"]);
	arr.push(["sad",":("]);
	arr.push(["love","<3"]);
	arr.push(["loo","100"]);
	arr.push(["dog","cat"]);
	arr.push(["s","th"]);
	arr.push(["s","c"]);
	arr.push(["c","s"]);

	if(Math.random() > .5){
		return getRandomElementFromArray(arr);
	}
	
	return getOneNormalReplaceArray(); //if i get here, just do a normal one.
}
