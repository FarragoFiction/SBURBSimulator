import "SBURBSim.dart";


class Quirk {
    //why did it take me so long to do this???
    static int NOCAPS = 0;
    static int ALLCAPS = 2;
    static int ALTCAPS = 4;
    static int INVERTCAPS = 5;
    static int KANAYACAPS = 3;
    static int NORMALCAPS = 1;

    static int NOPUNC = 0;
    static int ENDPUNC = 1;
    static int PERFPUNC = 2;
    static int EXPUNC = 3;

 List<dynamic> lettersToReplace = []; //array of two element arrays. ["e", "3"], ["two",2] would be two examples. e replaced by 3 and two replaced by 2
 List<dynamic> lettersToReplaceIgnoreCase = [];
 num punctuation = 0; //0 = none, 1 = ends of sentences, 2 = perfect punctuation 3= excessive punctuation
 String prefix = ""; //what do you put at the start of a line?
 String suffix = ""; //what do you put at the end of a line?
    //if in murdermode, rerandomize capitalization quirk.
 int capitalization = 0;  //0 == none, 4 = alternating, 5= inverted, 3 = begining of every word, 1 = normal, 2 = ALL;
 int favoriteNumber = 0; //getRandomInt;    //num favoriteNumber = 8;    //4 and 6 and 12 has green not change, 7 has SOME green not change
    //take an input string and quirkify it.
    
    Random rand;


	Quirk(Random this.rand) {
	  if(this.rand == null) rand = new Random(); //so that blank players can be made that get overridden l8r
		this.favoriteNumber = rand.nextInt(12);
	}


	String translate(String input){
        String ret = input;
        ret = this.handleCapitilization(ret); //i originally had this line commented out. Why? It caused some quirks to not work (like replacing "E" with 3, but the sentence wasn't allCAPS yet)
        ret = this.handlePunctuation(ret);  //don't want to accidentally murder smileys
        ret = this.handleReplacements(ret);
        ret = this.handleReplacementsIgnoreCase(ret);
        ret = this.handleCapitilization(ret);//do it a second time 'cause ignore case made it's replacements all lower case
        if(this.capitalization == 5){
            ret = this.handleCapitilization(ret);//do it a third time cause now it's normal
        }

        ret = this.handlePrefix(ret);  //even if troll speaks in lowercase, 8=D needs to be as is.;
        ret = this.handleSuffix(ret);
        return ret;
    }
	Map<String, dynamic> toJSON(){
        return {"favoriteNumber": this.favoriteNumber};
    }
	String rawStringExplanation(){
        String ret = "\n * Capitalization: ";

        if(this.capitalization==0){
            ret += " all lower case ";
        }else if(this.capitalization==4){
            ret += " alternating ";
        }else if(this.capitalization==5){
            ret += " inverted ";
        }else if(this.capitalization==3){
            ret += " begining of every word ";
        }else if(this.capitalization==1){
            ret += " normal ";
        }else if(this.capitalization==2){
            ret += " all caps ";
        }

        ret += "\n * Punctuation: ";
        if(this.punctuation==0){
            ret += " no punctuation ";
        }else if(this.punctuation==1){
            ret += " ends of sentences ";
        }else if(this.punctuation==2){
            ret += " perfect punctuation ";
        }else if(this.punctuation==3){
            ret += " excessive punctuation ";
        }

        if(this.prefix != ""){
            ret += "\n *  Prefix: " + this.prefix;
        }

        if(this.suffix != ""){
            ret += "\n *  Suffix: " + this.suffix;
        }

        ret += "\n * Favorite Number: ${this.favoriteNumber}";

        if(this.lettersToReplace.length > 0){
            ret += " \n * Replaces: ";
        }
        for(num i = 0; i<this.lettersToReplace.length; i++){
            //querySelector("#debug").append(i);
            ret += "\n \t " + this.lettersToReplace[i][0] + " with " + this.lettersToReplace[i][1];
        }


        return ret;
    }
	String stringExplanation(){
        String ret = "<br>Capitalization: ";

        if(this.capitalization==0){
            ret += " all lower case ";
        }else if(this.capitalization==4){
            ret += " alternating ";
        }else if(this.capitalization==5){
            ret += " inverted ";
        }else if(this.capitalization==3){
            ret += " begining of every word ";
        }else if(this.capitalization==1){
            ret += " normal ";
        }else if(this.capitalization==2){
            ret += " all caps ";
        }

        ret += "<Br> Punctuation: ";
        if(this.punctuation==0){
            ret += " no punctuation ";
        }else if(this.punctuation==1){
            ret += " ends of sentences ";
        }else if(this.punctuation==2){
            ret += " perfect punctuation ";
        }else if(this.punctuation==3){
            ret += " excessive punctuation ";
        }

        if(this.prefix != ""){
            ret += "<br> Prefix: " + this.prefix;
        }

        if(this.suffix != ""){
            ret += "<br> Suffix: " + this.suffix;
        }

        ret += "<br> Favorite Number: ${this.favoriteNumber}";

        if(this.lettersToReplace.length > 0){
            ret += " <br>Replaces: ";
        }
        for(num i = 0; i<this.lettersToReplace.length; i++){
            //querySelector("#debug").append(i);
            ret += "<br>&nbsp&nbsp&nbsp&nbsp " + this.lettersToReplace[i][0] + " with " + this.lettersToReplace[i][1];
        }
        return ret;
    }
	String handlePrefix(String input){
        return this.prefix + " " + input;
    }
	String handleSuffix(String input){
        return input + " " + this.suffix;
    }
	String randomJapaneseBullshit(){
      String japaneseBullshit = "私はあなたの歯の間に私の乳首を感じるようにしたい";
      return japaneseBullshit[(random() * japaneseBullshit.length).floor()]; //true random
    }
	String replaceEverythingWithRandomJapanese(String input){
      List<String> words = input.split(" ");
      for(num i = 0; i<words.length; i++){
        words[i] = this.randomJapaneseBullshit();
      }
      return words.join(" ");
    }
	String handleReplacements(String input){
        String ret = input;
        for(num i = 0; i<this.lettersToReplace.length; i++){
            //querySelector("#debug").append("Replacing: " +this.lettersToReplace[i][0] );
            String replace = this.lettersToReplace[i][1] ;
            if(replace == "私"){
              ret = this.replaceEverythingWithRandomJapanese(ret);
            }
            ret= ret.replaceAll(this.lettersToReplace[i][0],replace);
        }
        return ret;
    }
	String handleReplacementsIgnoreCase(String input){
        String ret = input;
        for(num i = 0; i<this.lettersToReplaceIgnoreCase.length; i++){
            //querySelector("#debug").append("Replacing: " +this.lettersToReplaceIgnoreCase[i][0] );
            ////print("Replacing: " +this.lettersToReplaceIgnoreCase[i][0] );
            //g makes it replace all, i makes it ignore case
            String replace = this.lettersToReplaceIgnoreCase[i][1] ;
            if(replace == "私"){
              ret = this.replaceEverythingWithRandomJapanese(ret);
            }
            ret= ret.replaceAll(new RegExp(this.lettersToReplaceIgnoreCase[i][0], caseSensitive: false),replace);
        }

        //ret= ret.replaceAll(new RegExp("B", caseSensitive: false),"[B]");
        return ret;
    }
	String handlePunctuation(String input){
        String ret = input;
        if(this.punctuation==0){
            String punctuationless = ret.replaceAll(new RegExp(r"[.?,\/#!;{}=\-_`~]", multiLine:true),"");
            ret = punctuationless.replaceAll(new RegExp(r"""\s{2,}""", multiLine:true)," ");
        }else if(this.punctuation==1){
            String punctuationless = ret.replaceAll(new RegExp(r"[,\/#;{}=\-_`~]", multiLine:true),"");
            ret = punctuationless.replaceAll(new RegExp(r"""\s{2,}""", multiLine:true)," ");
        }else if(this.punctuation==2){
            ret = input;
        }else if(this.punctuation==3){
            ret = multiplyCharacter(ret,"!", this.favoriteNumber);
            ret = multiplyCharacter(ret,"?", this.favoriteNumber);
        }
        return ret;
    }
	void lowBloodVocabulary(Player player){
		//Troll words: year, month, refrigerator, bathtub, ears, heart, brain,rap,nose,mouth,bed,tea,worm,beans,tree,legs,eyes, gold star,born,toilet,foot,spine,vampire,tits,baby,
		//red blood adds all of these, mid blood adds half, and eridan or above adds none.
		//which ones you add are random.
		List<List<String>> words = [["\\byear\\b","sweep"],["SBURB","SGRUB"],["\\bmonth\\b","perigee"],["\\brefrigerator\\b","\\bthermal hull\\b"],["\\bbathtub\\b","ablution trap"],["\\bears\\b","hear ducts "],["\\bheart\\b","pump biscuit"],["\\bbrain\\b","sponge"],["\\brap\\b","slam poetry"],["\\bnose\\b","sniffnode"],["\\bmouth\\b","squawk gaper"],["\\bbed\\b", "cocoon"],["\\btea\\b","scalding leaf fluid"],["\\bworm", "dirt noodle"],["\\bbean","fart nibblet"],["\\btree\\b","frond nub"],["\\bleg\\b","frond"],["\\bgold star\\b","glitter biscuit"],["\\bborn\\b","hatched"],["\\btoilet\\b","load gaper"],["\\bfoot\\b","prong"],["\\bspine\\b","posture pole"],["vampire","rainbow drinker"],["\\btits\\b","rumble spheres"],["\\bbaby\\b","wiggler"],["eye","gander bulb"]];

		int odds = 15 - bloodColors.indexOf(player.bloodColor);   //15 is max odds, 0 is min odds.  after all, even meenah used some low blood words, right?
		for(num i = 0; i<words.length; i++){
			if(this.rand.nextDouble()*15 < odds ){
				this.lettersToReplaceIgnoreCase.add(words[i]);
			}
		}
	}
	void makeTrollQuirk(Player player){
      ////print("generting troll quirk with favorite number: " + this.favoriteNumber);
      this.capitalization = this.rand.nextIntRange(0,5);
      this.punctuation = this.rand.nextIntRange(0,5);
      this.lettersToReplace = [];
      this.lettersToReplaceIgnoreCase = [];
      if(this.capitalization == 2 && this.rand.nextDouble() >.2){ //seriously, less all caps.
          this.capitalization = this.rand.nextIntRange(0,1);
      }

      if(this.rand.nextDouble() > .95){
          this.prefix = this.rand.pickFrom(prefixes);
          if(this.prefix.length == 1 && this.favoriteNumber < 8){
              this.prefix = multiplyCharacter(this.prefix, this.prefix[0], this.favoriteNumber);
          }
      }
      if(this.rand.nextDouble() > .95){
          if(this.prefix != "" && this.rand.nextDouble()>.7){ //mostly just repeat your prefix
              this.suffix = this.prefix;
          }else{
              this.suffix = this.rand.pickFrom(prefixes);
          }

          if(this.suffix.length == 1 && this.favoriteNumber < 8){
              this.suffix  = multiplyCharacter(this.suffix, this.suffix[0], this.favoriteNumber);
          }
      }
      //have at least 3 fish puns.
      if(player.bloodColor == "#99004d" || player.bloodColor == "#610061"){
          for(int i = 0; i<3; i++){
              this.lettersToReplaceIgnoreCase.add(getOneRandomFishArray(rand));
          }
      }
      num roomLeft = 0;
      //most people spell things, fine, other people have random problems
      if(this.rand.nextDouble() > 0.50){
          roomLeft = this.rand.nextIntRange(0,10);
      }
      if(roomLeft < 0) roomLeft = 0;


      for(int i = 0; i<roomLeft; i++){
          this.lettersToReplaceIgnoreCase.add(getOneRandomReplaceArray(rand));
          if(player.bloodColor == "#99004d" || player.bloodColor == "#610061"){
              this.lettersToReplaceIgnoreCase.add(getOneRandomFishArray(rand));
          }
      }


      this.lettersToReplaceIgnoreCase.add(this.rand.pickFrom(very_quirks));
      this.lettersToReplaceIgnoreCase.add(this.rand.pickFrom(friend_quirks));
      this.lettersToReplaceIgnoreCase.add(this.rand.pickFrom(good_quirks));
      this.lettersToReplaceIgnoreCase.add(this.rand.pickFrom(lol_quirks));
      this.lettersToReplaceIgnoreCase.add(this.rand.pickFrom(greeting_quirks));
      this.lettersToReplaceIgnoreCase.add(this.rand.pickFrom(dude_quirks));
      this.lettersToReplaceIgnoreCase.add(this.rand.pickFrom(curse_quirks));
      this.lettersToReplaceIgnoreCase.add(this.rand.pickFrom(yes_quirks));
      this.lettersToReplaceIgnoreCase.add(this.rand.pickFrom(no_quirks));

      //smileys have special characters, do later
      this.lettersToReplace.add(this.rand.pickFrom(smiley_quirks));

      this.addNumberQuirk();
      //querySelector("#debug").append("Human letters to replace: " + this.lettersToReplace.length);
	  this.lowBloodVocabulary(player);


    }
	void makeHumanQuirk(Player player){
      this.capitalization = this.rand.nextIntRange(0,2);
      this.punctuation = this.rand.nextIntRange(0,3);
      this.lettersToReplace = [];
      this.lettersToReplaceIgnoreCase = [];
      if(this.capitalization == 2 && this.rand.nextDouble() >0.2){ //seriously, less all caps.
          this.capitalization = this.rand.nextIntRange(0,1);
      }
      num roomLeft = 0;
      //most people spell things, fine, other people have random problems
      if(this.rand.nextDouble() > 0.50){
          roomLeft = this.rand.nextIntRange(0,10);
      }
      if(roomLeft < 0) roomLeft = 0;
      for(int i = 0; i<roomLeft; i++){
          this.lettersToReplaceIgnoreCase.add(getOneNormalReplaceArray(rand));
      }
      this.lettersToReplaceIgnoreCase.add(this.rand.pickFrom(very_quirks));
      this.lettersToReplaceIgnoreCase.add(this.rand.pickFrom(friend_quirks));
      this.lettersToReplaceIgnoreCase.add(this.rand.pickFrom(good_quirks));
      this.lettersToReplaceIgnoreCase.add(this.rand.pickFrom(lol_quirks));
      this.lettersToReplaceIgnoreCase.add(this.rand.pickFrom(greeting_quirks));
      this.lettersToReplaceIgnoreCase.add(this.rand.pickFrom(dude_quirks));
      this.lettersToReplaceIgnoreCase.add(this.rand.pickFrom(curse_quirks));
      this.lettersToReplaceIgnoreCase.add(this.rand.pickFrom(yes_quirks));
      this.lettersToReplaceIgnoreCase.add(this.rand.pickFrom(no_quirks));
      this.lettersToReplaceIgnoreCase.add(this.rand.pickFrom(asshole_quirks));
      //smileys have special characters, do later
      this.lettersToReplace.add(this.rand.pickFrom(smiley_quirks));


      //querySelector("#debug").append("Human letters to replace: " + this.lettersToReplace.length);

    }
	void addNumberQuirk(){
        if(this.favoriteNumber == 1){
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["I","1"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["i","1"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["l","1"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["L","1"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["won","1"]);
        }else if(this.favoriteNumber == 2){
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["S","2"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["s","2"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["Z","2"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["z","2"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["too","2"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["to","2"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["two","2"]);
        }else if(this.favoriteNumber == 3){
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["E","3"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["e","3"]);
        }else if(this.favoriteNumber == 4){
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["A","4"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["a","4"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["for","4"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["four","4"]);
        }else if(this.favoriteNumber == 5){
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["S","5"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["s","5"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["Z","5"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["J","5"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["z","5"]);
        }else if(this.favoriteNumber == 6){
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["G","6"]);
        }else if(this.favoriteNumber == 7){
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["T","7"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["t","7"]);
        }else if(this.favoriteNumber == 8){
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["ate","8"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["eight","8"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["EIGHT","8"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["B","8"]);
        }else if(this.favoriteNumber == 9){
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["g","9"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["nine","9"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["NINE","9"]);
        }else if(this.favoriteNumber == 10){
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["ten","10"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["TEN","10"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["lo","10"]);
        }else if(this.favoriteNumber == 11){
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["ll","11"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["II","11"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["ii","11"]);
        }else if(this.favoriteNumber == 12){
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["is","12"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["IS","12"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["iz","12"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["IZ","12"]);
        }else if(this.favoriteNumber == 0){
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["o","0"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["O","0"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["oh","0"]);
            if(this.rand.nextDouble()>0.5) this.lettersToReplace.add(["OH","0"]);
        }
    }




    String handleCapitilization(String input){
        String ret = input;
        if(this.capitalization== 0){
            ret = ret.toLowerCase();
        }else if(this.capitalization== 4){
            for(num i = 0; i<input.length; i++){
                if(i%2 == 0){
                    ret = replaceStringAt(ret, i, ret[i].toLowerCase());
                }else{
                    ret = replaceStringAt(ret, i, ret[i].toUpperCase());
                }
            }
        }else if(this.capitalization== 5){
            for(num i = 0; i<input.length; i++){
                if(ret[i] == ret[i].toUpperCase()){
                    ret = replaceStringAt(ret, i, ret[i].toLowerCase());
                }else{
                    ret = replaceStringAt(ret, i, ret[i].toUpperCase());
                }
            }
        }else if(this.capitalization== 3){
            ret = ret.replaceAllMapped(new RegExp(r"\b\w", multiLine:true), (l){ return l.group(0).toUpperCase(); })  ;//this version works with old IE browsers.;
        }else if(this.capitalization== 1){
            ret = input; //no change
        }else if(this.capitalization== 2){
            ret = ret.toUpperCase();
        }
        return ret;
    }


}



String replaceStringAt(String str, int index, String character){
    return str.substring(0, index) + character + str.substring(index+character.length);
}



dynamic multiplyCharacter(String str, String character, int times){
        //querySelector("#debug").append("<Br>Going to multiply: " + character + " this many times: " + times);
        String tmp = "";
        for(int i = 0; i<times; i++){
            tmp += character;
        }
        return str.replaceAll(character, tmp);
}



Quirk randomHumanQuirk(Random rand){
    Quirk ret = new Quirk(rand);
    ret.capitalization = rand.nextIntRange(0,2);
    ret.punctuation = rand.nextIntRange(0,3);
    if(ret.capitalization == 2 && rand.nextDouble() >0.2){ //seriously, less all caps.
        ret.capitalization = rand.nextIntRange(0,1);
    }
    int roomLeft = rand.nextIntRange(0,6) - ret.lettersToReplace.length;
    if(roomLeft < 0) roomLeft = 0;
    for(int i = 0; i<roomLeft; i++){
        ret.lettersToReplace.add(getOneNormalReplaceArray(rand));
    }
    //querySelector("#debug").append("Human letters to replace: " + ret.lettersToReplace.length);
    return ret;
}



int randomCapitalQuirk(Random rand){
    return rand.nextIntRange(0,5);

}


//since I'm not gonna list 'em out, have more quirks, and make sure you have certain CATEGORIES of quirk.
Quirk randomHumanSim(Random rand, Player player){
    Quirk ret = new Quirk(rand);
    ret.makeHumanQuirk(player);
    return ret;
}






//since I'm not gonna list 'em out, have more quirks, and make sure you have certain CATEGORIES of quirk.
dynamic randomTrollSim(Random rand, Player player){
    Quirk ret = new Quirk(rand);
    ret.makeTrollQuirk(player);
    return ret;
}



//troll quirks are more extreme
Quirk randomTrollQuirk(Random rand, Player player){
    Quirk ret = new Quirk(rand);
    ret.capitalization = ret.rand.nextIntRange(0,5);
    ret.punctuation = ret.rand.nextIntRange(0,5);
    if(ret.rand.nextDouble() > .5){
        ret.prefix = ret.rand.pickFrom(prefixes);
        if(ret.prefix.length == 1){
            ret.prefix = multiplyCharacter(ret.prefix, ret.prefix[0], ret.favoriteNumber);
        }
    }
    if(ret.rand.nextDouble() > .5){
        if(ret.prefix != "" && ret.rand.nextDouble()>.7){ //mostly just repeat your prefix
            ret.suffix = ret.prefix;
        }else{
            ret.suffix = ret.rand.pickFrom(prefixes);
        }

        if(ret.suffix.length == 1){
            ret.suffix  = multiplyCharacter(ret.suffix, ret.suffix[0], ret.favoriteNumber);
        }
    }

    ret.addNumberQuirk();
    int roomLeft = ret.rand.nextIntRange(0,6) - ret.lettersToReplace.length;
    if(roomLeft < 0) roomLeft = 0;
    for(int i = 0; i<roomLeft; i++){
        if(player.bloodColor == "#99004d" || player.bloodColor == "#610061"){
            ret.lettersToReplace.add(getOneRandomFishArray(rand));
        }
        ret.lettersToReplace.add(getOneRandomReplaceArray(rand));
    }

    return ret;
}




List<String> getOneNormalReplaceArray(Random rand){
    //these should ignore case.
    return rand.pickFrom(conversational_quirks);
}



List<String> getOneRandomFishArray(Random rand){
    return rand.pickFrom(fish_quirks);
}



//% to cross or x.  8 for b.  69 for oo.  o+ for o
List<String> getOneRandomReplaceArray(Random rand){
    List<List<String>> arr = [["x","%"],["X","%"],["s","z"],["w","vv"],["w","v"],["v","w"],["!","~"],["N","|\\/"],["\\b[a-z]*\\b","私"]];
    arr.add(["M","|\\/|"]);
    arr.add(["W","\\/\\/"]);
    arr.add(["H",")("]);
    arr.add(["H","|-|"]);
    arr.add(["H","#"]);
    arr.add(["i","!"]);
    arr.add(["I","!"]);
    arr.add(["o","*"]);
    arr.add(["a","@"]);
    arr.add(["at","@"]);
    arr.add(["and","&"]);
    arr.add(["n","^"]);
    arr.add(["oo","69"]);
    arr.add(["OO","69"]);
    arr.add(["o","o+"]);
    arr.add(["plus","+"]);
    arr.add(["happy",":)"]);
    arr.add(["sad",":("]);
    arr.add(["love","<3"]);
    arr.add(["loo","100"]);
    arr.add(["dog","cat"]);
    arr.add(["s","th"]);
    arr.add(["c","s"]);
    arr.add(["per","purr"]);
    arr.add(["mu","mew"]);
    arr.add(["b","[B]"]);
    arr.add(["B","[B]"]);
    arr.add(["l","w"]);
    arr.add(["r","w"]);

    if(rand.nextDouble() > .5){
        return rand.pickFrom(arr);
    }

    return getOneNormalReplaceArray(rand); //if i get here, just do a normal one.
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
