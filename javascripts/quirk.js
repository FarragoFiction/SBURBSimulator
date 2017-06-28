
function Quirk(){
    this.lettersToReplace = []; //array of two element arrays. ["e", "3"], ["two",2] would be two examples. e replaced by 3 and two replaced by 2
    this.lettersToReplaceIgnoreCase = [];
    this.punctuation = 0; //0 = none, 1 = ends of sentences, 2 = perfect punctuation 3= excessive punctuation
    this.prefix = ""; //what do you put at the start of a line?
    this.suffix = ""; //what do you put at the end of a line?
    //if in murdermode, rerandomize capitalization quirk.
    this.capitalization = 0;  //0 == none, 4 = alternating, 5= inverted, 3 = begining of every word, 1 = normal, 2 = ALL
    this.favoriteNumber = getRandomInt(0,12);
    //this.favoriteNumber = 8;
    //4 and 6 and 12 has green not change, 7 has SOME green not change
    //take an input string and quirkify it.
    this.translate = function(input){
        var ret = input;
        ret = this.handleCapitilization(ret); //i originally had this line commented out. Why? It caused some quirks to not work (like replacing "E" with 3, but the sentence wasn't allCAPS yet)
        ret = this.handlePunctuation(ret);  //don't want to accidentally murder smileys
        ret = this.handleReplacements(ret);
        ret = this.handleReplacementsIgnoreCase(ret);
        ret = this.handleCapitilization(ret);//do it a second time 'cause ignore case made it's replacements all lower case
        if(this.capitalization == 5){
            ret = this.handleCapitilization(ret);//do it a third time cause now it's normal
        }

        ret = this.handlePrefix(ret);  //even if troll speaks in lowercase, 8=D needs to be as is.
        ret = this.handleSuffix(ret);
        return ret;
    }

    this.toJSON = function(){
        return {favoriteNumber: this.favoriteNumber}
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

    //amazingly, this will make even LESS sense than damara's usual bullshit
    this.randomJapaneseBullshit = function(){
      var japaneseBullshit = "私はあなたの歯の間に私の乳首を感じるようにしたい"
      return japaneseBullshit[Math.floor(Math.random() * japaneseBullshit.length)]; //true random
    }

    this.replaceEverythingWithRandomJapanese = function(input){
      var words = input.split(" ");
      for(var i = 0; i<words.length; i++){
        words[i] = this.randomJapaneseBullshit();
      }
      return words.join(" ");
    }

    this.handleReplacements = function(input){
        var ret = input;
        for(var i = 0; i<this.lettersToReplace.length; i++){
            //$("#debug").append("Replacing: " +this.lettersToReplace[i][0] );
            var replace = this.lettersToReplace[i][1] ;
            if(replace == "私"){
              ret = this.replaceEverythingWithRandomJapanese(ret);
            }
            ret= ret.replace(new RegExp(this.lettersToReplace[i][0], "g"),replace);
        }
        return ret;
    }

    this.handleReplacementsIgnoreCase = function(input){
        var ret = input;
        for(var i = 0; i<this.lettersToReplaceIgnoreCase.length; i++){
            //$("#debug").append("Replacing: " +this.lettersToReplaceIgnoreCase[i][0] );
            //console.log("Replacing: " +this.lettersToReplaceIgnoreCase[i][0] )
            //g makes it replace all, i makes it ignore case
            var replace = this.lettersToReplaceIgnoreCase[i][1] ;
            if(replace == "私"){
              ret = this.replaceEverythingWithRandomJapanese(ret);
            }
            ret= ret.replace(new RegExp(this.lettersToReplaceIgnoreCase[i][0], "ig"),replace);
        }
        return ret;
    }


    this.handlePunctuation = function(input){
        var ret = input;
        if(this.punctuation==0){
            var punctuationless = ret.replace(/[.?,\/#!;{}=\-_`~]/g,"");
            ret = punctuationless.replace(/\s{2,}/g," ");
        }else if(this.punctuation==1){
            var punctuationless = ret.replace(/[,\/#;{}=\-_`~]/g,"");
            ret = punctuationless.replace(/\s{2,}/g," ");
        }else if(this.punctuation==2){
            ret = input;
        }else if(this.punctuation==3){
            ret = multiplyCharacter(ret,"!", this.favoriteNumber);
            ret = multiplyCharacter(ret,"?", this.favoriteNumber);
        }
        return ret;
    }

	//higher up on the hemospectrum you are, less likely you are to use these sorts of words.
	this.lowBloodVocabulary = function(player){
		//Troll words: year, month, refrigerator, bathtub, ears, heart, brain,rap,nose,mouth,bed,tea,worm,beans,tree,legs,eyes, gold star,born,toilet,foot,spine,vampire,tits,baby,
		//red blood adds all of these, mid blood adds half, and eridan or above adds none.
		//which ones you add are random.
		var words = [["\\byear\\b","sweep"],["SBURB","SGRUB"],["\\bmonth\\b","perigee"],["\\brefrigerator\\b","\\bthermal hull\\b"],["\\bbathtub\\b","ablution trap"],["\\bears\\b","hear ducts "],["\\bheart\\b","pump biscuit"],["\\bbrain\\b","sponge"],["\\brap\\b","slam poetry"],["\\bnose\\b","sniffnode"],["\\bmouth\\b","squawk gaper"],["\\bbed\\b", "cocoon"],["\\btea\\b","scalding leaf fluid"],["\\bworm", "dirt noodle"],["\\bbean","fart nibblet"],["\\btree\\b","frond nub"],["\\bleg\\b","frond"],["\\bgold star\\b","glitter biscuit"],["\\bborn\\b","hatched"],["\\btoilet\\b","load gaper"],["\\bfoot\\b","prong"],["\\bspine\\b","posture pole"],["vampire","rainbow drinker"],["\\btits\\b","rumble spheres"],["\\bbaby\\b","wiggler"],["eye","gander bulb"]]

		var odds = 15 - bloodColors.indexOf(player.bloodColor);   //15 is max odds, 0 is min odds.  after all, even meenah used some low blood words, right?
		for(var i = 0; i<words.length; i++){
			if(Math.seededRandom()*15 < odds ){
				this.lettersToReplaceIgnoreCase.push(words[i]);
			}
		}
	}

    this.makeTrollQuirk = function(player){
      //console.log("generting troll quirk with favorite number: " + this.favoriteNumber)
      this.capitalization = getRandomInt(0,5);
      this.punctuation = getRandomInt(0,5);
      this.lettersToReplace = [];
      this.lettersToReplaceIgnoreCase = [];
      if(this.capitalization == 2 && Math.seededRandom() >.2){ //seriously, less all caps.
          this.capitalization = getRandomInt(0,1);
      }

      if(Math.seededRandom() > .95){
          this.prefix = getRandomElementFromArray(prefixes);
          if(this.prefix.length == 1 && this.favoriteNumber < 8){
              this.prefix = multiplyCharacter(this.prefix, this.prefix[0], this.favoriteNumber);
          }
      }
      if(Math.seededRandom() > .95){
          if(this.prefix != "" && Math.seededRandom()>.7){ //mostly just repeat your prefix
              this.suffix = this.prefix;
          }else{
              this.suffix = getRandomElementFromArray(prefixes);
          }

          if(this.suffix.length == 1 && this.favoriteNumber < 8){
              this.suffix  = multiplyCharacter(this.suffix, this.suffix[0], this.favoriteNumber);
          }
      }
      //have at least 3 fish puns.
      if(player.bloodColor == "#99004d" || player.bloodColor == "#610061"){
          for(var i = 0; i< 3; i++){
              this.lettersToReplaceIgnoreCase.push(getOneRandomFishArray());
          }
      }
      var roomLeft = 0;
      //most people spell things, fine, other people have random problems
      if(Math.seededRandom() > 0.50){
          var roomLeft = getRandomInt(0,10);
      }
      if(roomLeft < 0) roomLeft = 0;


      for(var i = 0; i< roomLeft; i++){
          this.lettersToReplaceIgnoreCase.push(getOneRandomReplaceArray());
          if(player.bloodColor == "#99004d" || player.bloodColor == "#610061"){
              this.lettersToReplaceIgnoreCase.push(getOneRandomFishArray());
          }
      }


      this.lettersToReplaceIgnoreCase.push(getRandomElementFromArray(very_quirks));
      this.lettersToReplaceIgnoreCase.push(getRandomElementFromArray(good_quirks));
      this.lettersToReplaceIgnoreCase.push(getRandomElementFromArray(lol_quirks));
      this.lettersToReplaceIgnoreCase.push(getRandomElementFromArray(greeting_quirks));
      this.lettersToReplaceIgnoreCase.push(getRandomElementFromArray(dude_quirks));
      this.lettersToReplaceIgnoreCase.push(getRandomElementFromArray(curse_quirks));
      this.lettersToReplaceIgnoreCase.push(getRandomElementFromArray(yes_quirks));
      this.lettersToReplaceIgnoreCase.push(getRandomElementFromArray(no_quirks));

      //smileys have special characters, do later
      this.lettersToReplace.push(getRandomElementFromArray(smiley_quirks));

      this.addNumberQuirk(this);
      //$("#debug").append("Human letters to replace: " + this.lettersToReplace.length);
	  this.lowBloodVocabulary(player);


    }

    this.makeHumanQuirk = function(player){
      this.capitalization = getRandomInt(0,2);
      this.punctuation = getRandomInt(0,3);
      this.lettersToReplace = [];
      this.lettersToReplaceIgnoreCase = [];
      if(this.capitalization == 2 && Math.seededRandom() >0.2){ //seriously, less all caps.
          this.capitalization = getRandomInt(0,1);
      }
      var roomLeft = 0;
      //most people spell things, fine, other people have random problems
      if(Math.seededRandom() > 0.50){
          var roomLeft = getRandomInt(0,10);
      }
      if(roomLeft < 0) roomLeft = 0;
      for(var i = 0; i< roomLeft; i++){
          this.lettersToReplaceIgnoreCase.push(getOneNormalReplaceArray());
      }
      this.lettersToReplaceIgnoreCase.push(getRandomElementFromArray(very_quirks));
      this.lettersToReplaceIgnoreCase.push(getRandomElementFromArray(good_quirks));
      this.lettersToReplaceIgnoreCase.push(getRandomElementFromArray(lol_quirks));
      this.lettersToReplaceIgnoreCase.push(getRandomElementFromArray(greeting_quirks));
      this.lettersToReplaceIgnoreCase.push(getRandomElementFromArray(dude_quirks));
      this.lettersToReplaceIgnoreCase.push(getRandomElementFromArray(curse_quirks));
      this.lettersToReplaceIgnoreCase.push(getRandomElementFromArray(yes_quirks));
      this.lettersToReplaceIgnoreCase.push(getRandomElementFromArray(no_quirks));
      this.lettersToReplaceIgnoreCase.push(getRandomElementFromArray(asshole_quirks));
      //smileys have special characters, do later
      this.lettersToReplace.push(getRandomElementFromArray(smiley_quirks));


      //$("#debug").append("Human letters to replace: " + this.lettersToReplace.length);

    }

    this.addNumberQuirk = function(){
        if(this.favoriteNumber == 1){
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["I","1"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["i","1"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["l","1"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["L","1"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["won","1"]);
        }else if(this.favoriteNumber == 2){
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["S","2"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["s","2"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["Z","2"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["z","2"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["too","2"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["to","2"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["two","2"]);
        }else if(this.favoriteNumber == 3){
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["E","3"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["e","3"]);
        }else if(this.favoriteNumber == 4){
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["A","4"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["a","4"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["for","4"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["four","4"]);
        }else if(this.favoriteNumber == 5){
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["S","5"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["s","5"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["Z","5"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["J","5"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["z","5"]);
        }else if(this.favoriteNumber == 6){
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["G","6"]);
        }else if(this.favoriteNumber == 7){
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["T","7"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["t","7"]);
        }else if(this.favoriteNumber == 8){
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["ate","8"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["eight","8"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["EIGHT","8"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["B","8"]);
        }else if(this.favoriteNumber == 9){
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["g","9"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["nine","9"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["NINE","9"]);
        }else if(this.favoriteNumber == 10){
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["ten","10"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["TEN","10"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["lo","10"]);
        }else if(this.favoriteNumber == 11){
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["ll","11"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["II","11"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["ii","11"]);
        }else if(this.favoriteNumber == 12){
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["is","12"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["IS","12"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["iz","12"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["IZ","12"]);
        }else if(this.favoriteNumber == 0){
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["o","0"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["O","0"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["oh","0"]);
            if(Math.seededRandom()>0.5) this.lettersToReplace.push(["OH","0"]);
        }
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
            ret = ret.replace(/\b\w/g, function(l){ return l.toUpperCase() })  //this version works with old IE browsers.
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
    if(ret.capitalization == 2 && Math.seededRandom() >0.2){ //seriously, less all caps.
        ret.capitalization = getRandomInt(0,1);
    }
    var roomLeft = getRandomInt(0,6) - ret.lettersToReplace.length;
    if(roomLeft < 0) roomLeft = 0;
    for(var i = 0; i< roomLeft; i++){
        ret.lettersToReplace.push(getOneNormalReplaceArray());
    }
    //$("#debug").append("Human letters to replace: " + ret.lettersToReplace.length);
    return ret;
}

function randomCapitalQuirk(){
    return getRandomInt(0,5);

}
//since I'm not gonna list 'em out, have more quirks, and make sure you have certain CATEGORIES of quirk.
function randomHumanSim(player){
    var ret = new Quirk();
    ret.makeHumanQuirk(player);
    return ret;
}




//since I'm not gonna list 'em out, have more quirks, and make sure you have certain CATEGORIES of quirk.
function randomTrollSim(player){
    var ret = new Quirk();
    ret.makeTrollQuirk(player);
    return ret;
}

//troll quirks are more extreme
function randomTrollQuirk(player){
    var ret = new Quirk();
    ret.capitalization = getRandomInt(0,5);
    ret.punctuation = getRandomInt(0,5);
    if(Math.seededRandom() > .5){
        ret.prefix = getRandomElementFromArray(prefixes);
        if(ret.prefix.length == 1){
            ret.prefix = multiplyCharacter(ret.prefix, ret.prefix[0], ret.favoriteNumber);
        }
    }
    if(Math.seededRandom() > .5){
        if(ret.prefix != "" && Math.seededRandom()>.7){ //mostly just repeat your prefix
            ret.suffix = ret.prefix;
        }else{
            ret.suffix = getRandomElementFromArray(prefixes);
        }

        if(ret.suffix.length == 1){
            ret.suffix  = multiplyCharacter(ret.suffix, ret.suffix[0], ret.favoriteNumber);
        }
    }

    ret.addNumberQuirk();
    var roomLeft = getRandomInt(0,6) - ret.lettersToReplace.length;
    if(roomLeft < 0) roomLeft = 0;
    for(var i = 0; i< roomLeft; i++){
        if(player.bloodColor == "#99004d" || player.bloodColor == "#610061"){
            ret.lettersToReplace.push(getOneRandomFishArray());
        }
        ret.lettersToReplace.push(getOneRandomReplaceArray());
    }

    return ret;
}


function getOneNormalReplaceArray(){
    //these should ignore case.
    return getRandomElementFromArray(conversational_quirks);
}

function getOneRandomFishArray(){
    return getRandomElementFromArray(fish_quirks);
}

//% to cross or x.  8 for b.  69 for oo.  o+ for o
function getOneRandomReplaceArray(){
    arr = [["x","%"],["X","%"],["s","z"],["w","vv"],["w","v"],["v","w"],["!","~"],["N","|\\/"],["\\b[a-z]*\\b","私"]];
    arr.push(["M","|\\/|"]);
    arr.push(["W","\\/\\/"]);
    arr.push(["H",")("]);
    arr.push(["H","|-|"]);
    arr.push(["H","#"]);
    arr.push(["i","!"]);
    arr.push(["I","!"]);
    arr.push(["o","*"]);
    arr.push(["a","@"]);
    arr.push(["at","@"]);
    arr.push(["and","&"]);
    arr.push(["n","^"]);
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
    arr.push(["c","s"]);
    arr.push(["per","purr"]);
    arr.push(["mu","mew"]);

    if(Math.seededRandom() > .5){
        return getRandomElementFromArray(arr);
    }

    return getOneNormalReplaceArray(); //if i get here, just do a normal one.
}


/*


```````   `                 `  ``   `                        ```````                           `
```` `   `   ````           `````   `   `````               ````  `   `` ````                ````  `   ``` `
```               ````        ```             ````           ```                ```          ```             ````
``                   ```      ``                 ```         ```                  ```        ```                ``
`````..``.`..`````````.``.``-``.``..`..``.```.``..``.``.``.``.``.``-`.-``.``.`..``.``.``..`..``.``.``.```..``.``..`..````..````
`.-............-..-...-.....-........................................................................-.......................-.`
`.-..........................................................................................................................-.`
`......:-....-::::::::::----:++++++++++++++oo+++::::::::::::::...::::::::::::::---------::::::::::::::::::::::::::-....-:......`
`.-..../.                 -ohddddddddddddddddddhh+`           `.`                                                      ./....-.`
`......+.              .+yhddddddddddddddddmmmmmddy.          `.`                            `     `                   .+......`
`````.-....+.           `:shddddddddddddddddmNNNNNNNNmdy.         `.``.+o+.`  `.oo/.           .sh   .sh                   .+....-.` ```
```   `......+.         -ohdddddddddddddddmmNNNNNNNNNNNNmdy`        `.`  +d+      sd:             yd    yd                   .+......`   ```
```   `.:....+.         .yddddddddddddmmddNNNNmshNNNNmmNNmdo        `.`  +d+      sd-    ---:.    yd    yd    `---:.         .+....:.`    ```
```    `......+-          `+hdddddddddms:-hNdyo.``:shmN+omNdh-       `.`  +do------yd-  -s.``-ho   yd    yd   /o```-ss`       -+......`    ```
```    `.-....+:            .ohddddddy-``.:-.````````.-:`-NNdo       `.`  +d+``````yd-  yy:::://`  yd    yd  -h:    -do       :+....-.`    ```
```   `......+-              .+hdddds```````````````````.NNmh.      `.`  +d+      sd-  yh.    .`  yd    yd  :do    `d+       -+......`    ```
```   `.-..../.                .sddddy-`````````````````+Nmdo`      `.`  odo      yd:  -yho//+:   yd    yd   +h/` `/o`  /o.  ./....-.`    ``
`````....../.                 -yddddh/```````````````/dyo-        `.``.:::.`  `.::-`  `-//:.   .::.  .::.   .::-..    -/`  ./......` ````
````......+.                /hddddddds:``````````.-/:.`          `.`                                                      .+......````
`......+.               -ddmddddddddo-..-//+ohms              `.`                                                      .+......`
`.-....+.              -hdNmddddddddddhhdddddyNh              `.`                                                      .+....-.`
`-.....+.           .-ohddmdddddddddddhhdddddso:              `.`                                                      .+.....-`
``......+.          .ohdddddddddddddddhs/ddddddh:              `.`                                                      .+......`
````......+.         ```:hdddddddddddddh+--/hdddddh-             `.`                                                      .+......`````
```  `......+-      ``````.hddddddddddddho....+dddddy`             `.`                                                      -+......`  ```
````  `.:...-+:   ``````` `odddddddddddddo/-..-+sdds/.``            `.`                                                      :+-...:.`   ```
```   `....../-`````````   :sssssssyyyyyys+o++o+syyo `````          `.`               ````````````````                       -/......`    ``
```   `........````````````--------:::::::::::::::::.````````````````.````````````````````````````````````````````````````````.......`    ``
```   `....../```````      -+syyyhhhhhhhhhddddddhyo/.    ```        `.`                                                      `+......`   ```
``   `.....-+`   `````       ``.shdddddddddddddo         ```       `.`                                                      `+-.....`   ```
``` `.....-+`      `````   ````-/hddddddddddddh-         ```      `.`                                                      `+-.....`  ``
```.-...-+`          ````````..:oddddddddddddh.         ```     `.`                                                      `+-...-.```
`.....-+.                 :shyddddddddddddddy.         ```    `.`                                                      .+-.....`
`.-...-+.                 sddddddddddddddddddy.        ```    `.`                                                      .+-...-.`
`......+`                 ydddddddddddddddddddh.        ```   `.`                                                      `+......`
````......+`                -hydddddddddddddddddddy`        ``   `.`                                                      `+......`````
```  `......+`                +hsdddddddddddddddddddds`        ``  `.`                                                      `+......`  ````
```   `.....-+`                +y+hddddddddddddddddddddo         `` `.`                                                      `+-.....`   ```
```   `.-...-+`                ys+yddddddddddddddddddddd/         ` `.`                                                      `+-...-.`    ```
```   `.....-+`               -d++sdddddddddddddddddddddh-        ```.`                                                      `+-.....`    ```
```   `:....-+`               -s++ohhhhhddhdddddddhhhhyso+        ` `..`                                                     `+-....:`   ```
``   `.....-+`                .++++++oooo-::::/oooo++++++.         `..`                                                     `+-.....`   ```
````..-...:+`                -+++++++++/      :+++++++++/         `.`                                                      `+:...-.` ````
```......-+.                -+++++++++/       /+++++++++.        `.`                                                      .+-......```
`.-...:+.                -+++++++++/       `+++++++++/        `.`                                                      .+:...-.`
`.-...-+-                -+++++++++/        :+++++++++`       `.`                                                      -+-...-.`
......./:...--:::::::::--://///////:......--://///////::::::::...::::::::::::::--------:::::::::::::::::::::::::::--...:/.......
..-..........................................................................................................................-..
..-........-...-..-..................................................................................-..............-........-..
`````-``.``.```.`````..`..`..``-``-``-``..``.```-``.```.``.`..``.`..`..`..`..`.``..`..``-``.``.``..``.```-```.``-```.``.``-`````


Hello (again, if this isn't the first fourth wall in a comment you've found. If it is, don't worry about my fourth wall being all warped and wavy. it still works.).
 I thought I'd talk about my own quirks???

I remember reading one of Hussie's old Formsprings where he drew attention to the fact that not only did his human characters have quirks, but he himself did as well,
as a way of having an author "character". Even while answering the formsprings shit he mostly tried to stick toward typing (or mistyping) consistently.

So, I'm trying to be more or less consistent with how I type.

* punctuation, mostly good, unless excited, and then 3x punctuation combo.
* capitalization, mostly correct, unless feeling especially informal.  Often capitalization in the middle of compound words like horrorTerror or grimDark because programming conventions are a bitch to train yourself out of and I may as well roll with it.
* spelling. Not great. (there are no real spell checkers in IDEs (for obvious reasons), and I've long since gotten to the point where "eh, if the compiler/human brain knows what I mean, that's good enough for me." Also, if it's a note to msyelf or I'm thinking faster than I'm typing, typos ahoy.
        * fun fact, if I am CONSISTENTLY misspelling a word, it might be because I totally don't know how to spell it. OR, it might be because of how IDE 'spell checkers' work. It suggests a word based on other words I've typed in the document. So...if I mispelled it the first time, it'll autocomplete it the same way the entire rest of the document/project in a cycle of stupidity. Now You Know (tm)
        * fun fact x2 combo: why the fuck is "classpect" spelled the way it is? It's so awkward looking. I thought it was "claspect" for so long because I am the least observant human alive. Claspect makes more sense to me. Bluh.
        * fun fact x3 combo: I completely empathize with Roxy's typo problem, especially since she's a fellow programmer. Programming trains me to have a mindset of "if the compiler isn't bitching, it ain't broke." So who fucking cares if I spell "disastor" wrong in a variable name. As long as I spell it wrong CONSISTENTLY, it'll fucking work.
* memes, near constant homestuck references for obvious reasons. (I am the fan, it is me.)
* cursing, a lot, usually as a way of conveying informality. Or because something is fucking stupid.

*/
