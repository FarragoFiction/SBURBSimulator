
part of SBURBSim;
//TODO strip all this out and put in classes. eventually. but for now, just fucking get thigns working
//little bobby tables

//going to refactor so that all randomness is seeded.
/*Math.seed = getRandomSeed();  //can be overwritten on load
var initial_seed = Math.seed;
dynamic rand.pickFrom(array){
	num min = 0;
	var max = array.length-1;
	var i = Math.floor(rand.nextDouble() * (max - min + 1)) + min;
	return array[i];
}*/




//http://jsfiddle.net/JKirchartz/wwckP/    horrorterror html stuff
class Zalgo{
    static Map<int,List<String>> chars= {
        0 : [ /* up */
    '\u030d', /*     ̍     */
    '\u030e', /*     ̎     */
    '\u0304', /*     ̄     */
    '\u0305', /*     ̅     */
    '\u033f', /*     ̿     */
    '\u0311', /*     ̑     */
    '\u0306', /*     ̆     */
    '\u0310', /*     ̐     */
    '\u0352', /*     ͒     */
    '\u0357', /*     ͗     */
    '\u0351', /*     ͑     */
    '\u0307', /*     ̇     */
    '\u0308', /*     ̈     */
    '\u030a', /*     ̊     */
    '\u0342', /*     ͂     */
    '\u0343', /*     ̓     */
    '\u0344', /*     ̈́     */
    '\u034a', /*     ͊     */
    '\u034b', /*     ͋     */
    '\u034c', /*     ͌     */
    '\u0303', /*     ̃     */
    '\u0302', /*     ̂     */
    '\u030c', /*     ̌     */
    '\u0350', /*     ͐     */
    '\u0300', /*     ̀     */
    '\u0301', /*     ́     */
    '\u030b', /*     ̋     */
    '\u030f', /*     ̏     */
    '\u0312', /*     ̒     */
    '\u0313', /*     ̓     */
    '\u0314', /*     ̔     */
    '\u033d', /*     ̽     */
    '\u0309', /*     ̉     */
    '\u0363', /*     ͣ     */
    '\u0364', /*     ͤ     */
    '\u0365', /*     ͥ     */
    '\u0366', /*     ͦ     */
    '\u0367', /*     ͧ     */
    '\u0368', /*     ͨ     */
    '\u0369', /*     ͩ     */
    '\u036a', /*     ͪ     */
    '\u036b', /*     ͫ     */
    '\u036c', /*     ͬ     */
    '\u036d', /*     ͭ     */
    '\u036e', /*     ͮ     */
    '\u036f', /*     ͯ     */
    '\u033e', /*     ̾     */
    '\u035b', /*     ͛     */
    '\u0346', /*     ͆     */
    '\u031a'  /*     ̚     */
    ],
    1 : [ /* down */
    '\u0316', /*     ̖     */
    '\u0317', /*     ̗     */
    '\u0318', /*     ̘     */
    '\u0319', /*     ̙     */
    '\u031c', /*     ̜     */
    '\u031d', /*     ̝     */
    '\u031e', /*     ̞     */
    '\u031f', /*     ̟     */
    '\u0320', /*     ̠     */
    '\u0324', /*     ̤     */
    '\u0325', /*     ̥     */
    '\u0326', /*     ̦     */
    '\u0329', /*     ̩     */
    '\u032a', /*     ̪     */
    '\u032b', /*     ̫     */
    '\u032c', /*     ̬     */
    '\u032d', /*     ̭     */
    '\u032e', /*     ̮     */
    '\u032f', /*     ̯     */
    '\u0330', /*     ̰     */
    '\u0331', /*     ̱     */
    '\u0332', /*     ̲     */
    '\u0333', /*     ̳     */
    '\u0339', /*     ̹     */
    '\u033a', /*     ̺     */
    '\u033b', /*     ̻     */
    '\u033c', /*     ̼     */
    '\u0345', /*     ͅ     */
    '\u0347', /*     ͇     */
    '\u0348', /*     ͈     */
    '\u0349', /*     ͉     */
    '\u034d', /*     ͍     */
    '\u034e', /*     ͎     */
    '\u0353', /*     ͓     */
    '\u0354', /*     ͔     */
    '\u0355', /*     ͕     */
    '\u0356', /*     ͖     */
    '\u0359', /*     ͙     */
    '\u035a', /*     ͚     */
    '\u0323'  /*     ̣     */
        ],
    2 : [ /* mid */
    '\u0315', /*     ̕     */
    '\u031b', /*     ̛     */
    '\u0340', /*     ̀     */
    '\u0341', /*     ́     */
    '\u0358', /*     ͘     */
    '\u0321', /*     ̡     */
    '\u0322', /*     ̢     */
    '\u0327', /*     ̧     */
    '\u0328', /*     ̨     */
    '\u0334', /*     ̴     */
    '\u0335', /*     ̵     */
    '\u0336', /*     ̶     */
    '\u034f', /*     ͏     */
    '\u035c', /*     ͜     */
    '\u035d', /*     ͝     */
    '\u035e', /*     ͞     */
    '\u035f', /*     ͟     */
    '\u0360', /*     ͠     */
    '\u0362', /*     ͢     */
    '\u0338', /*     ̸     */
    '\u0337', /*     ̷      */
    '\u0361', /*     ͡     */
    '\u0489' /*     ҉_     */
    ]

    };

    static num random ([int len]) {
        var rng = new Math.Random();
        if (len == 1) return 0;
        return len!=null ? (rng.nextDouble() * len + 1).floor() - 1 : rng.nextDouble();
    }
    static String generate(str) {
        var str_arr = str.split(''),
            output = str_arr.map((a) {;
                if(a == " ") return a;
                for(var i = 0, l = Zalgo.random(16);
                    i<l;i++){
                        var rand = Zalgo.random(3);
                    a += Zalgo.chars[rand][
                        Zalgo.random(Zalgo.chars[rand].length)
                        ];
                 }
                return a;
            });
        return output.join('');
    }
}

//using this won't effect the sanctity of the shareable url
dynamic getRandomElementFromArrayNoSeed(array){
	num min = 0;
	var max = array.length-1;
	var i = (random() * (max - min + 1)).floor() + min;
	return array[i];
}



String getRandomElementFromArrayThatStartsWith(Random rand, List<String> array, String letter){
	List<String> array2 = makeFilteredCopyForLetters(array, letter);
	if(array2.length == 0) return null;
	num min = 0;
	num max = array2.length-1;
	var i = (rand.nextDouble() * (max - min + 1)).floor() + min;
	return array2[i];
}



//regular filter modifies the array. do not want this. bluh.
List<String> makeFilteredCopyForLetters(List<String> array, String letter){
	List<String> tmp = [];
	for(num i = 0; i<array.length; i++ ){
		String word = array[i];
		if(word.startsWith(letter)){
			tmp.add(word);
		}
	}
	return tmp;
}




String turnArrayIntoHumanSentence(List<dynamic> retArray){
	return [retArray.sublist(0, retArray.length-1).join(', '), retArray.sublist(retArray.length-1,retArray.length)].join(retArray.length < 2 ? '' : ' and ');
}





//use class,aspect, and interests to generate a 16 element level array.
//need to happen ahead of time and have more variety to display on
//echeladder graphic.  4 interests total
dynamic getLevelArray(Player player){
	List<dynamic> ret = [];

	for(int i = 0; i<16; i++){
			if(i%4 == 3 && i> 4){//dont start with claspects
				//get the i/4th element from the class level array.
				//if i =7, would get element 1. if i = 15, would get element 3.
				ret.add(getLevelFromClass(((i-6)/4).round(), player.class_name)); //don't listen to even further pastJR up there, ther eis no logic here.
			}else if(i%4 == 2  && i>4){
				ret.add(getLevelFromAspect(((i-5)/4).round(), player.aspect)); //5 because fuck you futureJR, that's why.
			}else if(i%4==1){
				if(i<8){
					ret.add(getLevelFromInterests((i/4).round(), player.interest1));
				}else{
					//only 0 and 2 are valid, so if 3 or 4, go backwards.
					ret.add(getLevelFromInterests(((i-8)/4).round(), player.interest2));
				}
			}else if(i%4 == 0 || i < 4){
				ret.add(getLevelFromFree(player.session.rand)); //don't care about repeats here. should be long enough.
			}
	}
	return ret;
}



List<String> getRandomLandFromPlayer(Player player){
	List<dynamic> first_arr = [];
	var aspect = player.aspect;
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
	List<String> tmp = randomFromTwoArrays(player.session.rand, first_arr, free_land_titles);
	return tmp;
	//return "Land of " + tmp[0] + " and " + tmp[1];
}



//handle can either be about interests, or your claspect. each word can be separately origined
dynamic getRandomChatHandle(Random rand, String class_name, String aspect, String interest1, String interest2){
	//print("Class: " + class_name + "aspect: " + aspect);
	String first = "";
	var r = rand.nextDouble();
	if(r>0.3){
		first = getInterestHandle1(rand, class_name, interest1);
	}else if(r > .6){
		first = getInterestHandle1(rand, class_name, interest2);
	}else{
		first = getBlandHandle1(rand, class_name);
	}
	if(first == null || first == ""){
		first = getBlandHandle1(rand, class_name);  //might have forgot to have a interest handle of the right letter.
	}
	String second = "";
	if(r>.3){
		second = getInterestHandle2(rand, aspect, interest1);
	}else if(r > .6){
		second = getInterestHandle2(rand, aspect, interest2);
	}else{
		second = getBlandHandle2(rand, aspect);
	}
	if(second == null || second == ""){
		second = getBlandHandle2(rand, aspect);
	}
	return first+second;
}



//can also repurpose this by passing in same plaeyr for both slots to get an adjative about them. Hell yes. Laziness FTW.
//What do you like about them? They are just so X. (Yes. Hell Yes. Hell FUCKING Yes.)
String whatDoPlayersHaveInCommon(player1, player2){
	if(playerLikesMusic(player1) && playerLikesMusic(player2) ){
		return "musical";
	}
	if(playerLikesCulture(player1) && playerLikesCulture(player2) ){
		return "cultured";
	}
	if(playerLikesWriting(player1) && playerLikesWriting(player2) ){
		return "lettered";
	}
	if(playerLikesPopculture(player1) && playerLikesPopculture(player2) ){
		return "geeky";
	}
	if(playerLikesTechnology(player1) && playerLikesTechnology(player2) ){
		return "techy";
	}
	if(playerLikesSocial(player1) && playerLikesSocial(player2) ){
		return "extroverted";
	}
	if(playerLikesRomantic(player1) && playerLikesRomantic(player2) ){
		return "romantic";
	}
	if(playerLikesAcademic(player1) && playerLikesAcademic(player2) ){
		return "smart";
	}
	if(playerLikesComedy(player1) && playerLikesComedy(player2) ){
		return "funny";
	}

	if(playerLikesDomestic(player1) && playerLikesDomestic(player2) ){
		return "domestic";
	}
	if(playerLikesAthletic(player1) && playerLikesAthletic(player2) ){
		return "athletic";
	}
	if(playerLikesTerrible(player1) && playerLikesTerrible(player2) ){
		return "honest"; //'just telling it like it is' *rolls eyes*
	}
	if(playerLikesFantasy(player1) && playerLikesFantasy(player2) ){
		return "imaginative";
	}
	if(playerLikesJustice(player1) && playerLikesJustice(player2) ){
		return "fair-minded";
	}

	return "nice";//the defaultiest of traits.
}



//what are bad words to describe these traits?
String whatDontPlayersHaveInCommon(player1, player2){

	if(!playerLikesCulture(player1) && playerLikesCulture(player2) ){
		return "pretentious";
	}

	if(!playerLikesTerrible(player1) && playerLikesTerrible(player2) ){
		return "terrible"; //'just telling it like it is' *rolls eyes*
	}

	if(!playerLikesPopculture(player1) && playerLikesPopculture(player2) ){
		return "frivolous";
	}

	if(!playerLikesSocial(player1) && playerLikesSocial(player2) ){
		return "shallow";
	}

	if(!playerLikesAcademic(player1) && playerLikesAcademic(player2) ){
		return "nerdy";
	}

	if(!playerLikesComedy(player1) && playerLikesComedy(player2) ){
		return "dorky";
	}

	if(!playerLikesMusic(player1) && playerLikesMusic(player2) ){
		return "loud";
	}

	if(!playerLikesWriting(player1) && playerLikesWriting(player2) ){
		return "wordy";
	}

	if(!playerLikesTechnology(player1) && playerLikesTechnology(player2) ){
		return "awkward";
	}

	if(!playerLikesRomantic(player1) && playerLikesRomantic(player2) ){
		return "obsessive";
	}

	if(!playerLikesDomestic(player1) && playerLikesDomestic(player2) ){
		return "boring";
	}

	if(!playerLikesAthletic(player1) && playerLikesAthletic(player2) ){
		return "dumb";
	}

	if(!playerLikesFantasy(player1) && playerLikesFantasy(player2) ){
		return "whimpy";
	}
	if(!playerLikesJustice(player1) && playerLikesJustice(player2) ){
		return "harsh";
	}

	return "annoying";//the defaultiest of traits.
}




bool playerLikesMusic(player){
		if(music_interests.indexOf(player.interest1) != -1 || music_interests.indexOf(player.interest2) != -1 ){
			return true;
		}else{
			return false;
		}
}



bool playerLikesCulture(player){
		if(culture_interests.indexOf(player.interest1) != -1 || culture_interests.indexOf(player.interest2) != -1 ){
			return true;
		}else{
			return false;
		}
}



bool playerLikesWriting(player){
		if(writing_interests.indexOf(player.interest1) != -1 || writing_interests.indexOf(player.interest2) != -1 ){
			return true;
		}else{
			return false;
		}
}



bool playerLikesPopculture(player){
		if(pop_culture_interests.indexOf(player.interest1) != -1 || pop_culture_interests.indexOf(player.interest2) != -1 ){
			return true;
		}else{
			return false;
		}
}




bool playerLikesTechnology(player){
		if(technology_interests.indexOf(player.interest1) != -1 || technology_interests.indexOf(player.interest2) != -1 ){
			return true;
		}else{
			return false;
		}
}



bool playerLikesSocial(player){
		if(social_interests.indexOf(player.interest1) != -1 || social_interests.indexOf(player.interest2) != -1 ){
			return true;
		}else{
			return false;
		}
}



bool playerLikesRomantic(player){
		if(romantic_interests.indexOf(player.interest1) != -1 || romantic_interests.indexOf(player.interest2) != -1 ){
			return true;
		}else{
			return false;
		}
}



bool playerLikesAcademic(player){
		if(academic_interests.indexOf(player.interest1) != -1 || academic_interests.indexOf(player.interest2) != -1 ){
			return true;
		}else{
			return false;
		}
}



bool playerLikesComedy(player){
		if(comedy_interests.indexOf(player.interest1) != -1 || comedy_interests.indexOf(player.interest2) != -1 ){
			return true;
		}else{
			return false;
		}
}



bool playerLikesDomestic(player){
		if(domestic_interests.indexOf(player.interest1) != -1 || domestic_interests.indexOf(player.interest2) != -1 ){
			return true;
		}else{
			return false;
		}
}



bool playerLikesAthletic(player){
		if(athletic_interests.indexOf(player.interest1) != -1 || athletic_interests.indexOf(player.interest2) != -1 ){
			return true;
		}else{
			return false;
		}
}



bool playerLikesTerrible(player){
		if(terrible_interests.indexOf(player.interest1) != -1 || terrible_interests.indexOf(player.interest2) != -1 ){
			return true;
		}else{
			return false;
		}
}



bool playerLikesFantasy(player){
		if(fantasy_interests.indexOf(player.interest1) != -1 || fantasy_interests.indexOf(player.interest2) != -1 ){
			return true;
		}else{
			return false;
		}
}



bool playerLikesJustice(player){
		if(justice_interests.indexOf(player.interest1) != -1 || justice_interests.indexOf(player.interest2) != -1 ){
			return true;
		}else{
			return false;
		}
}



List<String> interestCategoryToInterestList(interestWord){
	//alert(interestWord);
	if(interestWord == "Comedy") return comedy_interests;
	if(interestWord == "Music") return music_interests;
	if(interestWord == "Culture") return culture_interests;
	if(interestWord == "Writing") return writing_interests;
	if(interestWord == "Athletic") return athletic_interests;
	if(interestWord == "Terrible") return terrible_interests;
	if(interestWord == "Justice") return justice_interests;
	if(interestWord == "Fantasy") return fantasy_interests;
	if(interestWord == "Domestic") return domestic_interests;
	if(interestWord == "PopCulture") return pop_culture_interests;
	if(interestWord == "Technology") return technology_interests;
	if(interestWord == "Social") return social_interests;
	if(interestWord == "Romance") return romantic_interests;
	if(interestWord == "Academic") return academic_interests;
	return null;
}



dynamic getInterestHandle1(Random rand, String class_name, String interest){
	if(music_interests.indexOf(interest) != -1){
			return getRandomElementFromArrayThatStartsWith(rand, music_handles1, class_name.toLowerCase()[0]);
	}else if (culture_interests.indexOf(interest) != -1){
			return getRandomElementFromArrayThatStartsWith(rand, culture_handles1, class_name.toLowerCase()[0]);
	}else if (writing_interests.indexOf(interest) != -1){
			return getRandomElementFromArrayThatStartsWith(rand, writing_handles1, class_name.toLowerCase()[0]);
	}else if (pop_culture_interests.indexOf(interest) != -1){
			return getRandomElementFromArrayThatStartsWith(rand, pop_culture_handles1, class_name.toLowerCase()[0]);
	}else if (technology_interests.indexOf(interest) != -1){
			return getRandomElementFromArrayThatStartsWith(rand, technology_handles2, class_name.toLowerCase()[0]);
	}else if (social_interests.indexOf(interest) != -1){
			return getRandomElementFromArrayThatStartsWith(rand, social_handles1, class_name.toLowerCase()[0]);
	}else if (romantic_interests.indexOf(interest) != -1){
			return getRandomElementFromArrayThatStartsWith(rand, romantic_handles1, class_name.toLowerCase()[0]);
	}else if (academic_interests.indexOf(interest) != -1){
			return getRandomElementFromArrayThatStartsWith(rand, academic_handles1, class_name.toLowerCase()[0]);
	}else if (comedy_interests.indexOf(interest) != -1){
			return getRandomElementFromArrayThatStartsWith(rand, comedy_handles1, class_name.toLowerCase()[0]);
	}else if (domestic_interests.indexOf(interest) != -1){
			return getRandomElementFromArrayThatStartsWith(rand, domestic_handles1, class_name.toLowerCase()[0]);
	}else if (athletic_interests.indexOf(interest) != -1){
			return getRandomElementFromArrayThatStartsWith(rand, athletic_handles1, class_name.toLowerCase()[0]);
	}else if (terrible_interests.indexOf(interest) != -1){
			return getRandomElementFromArrayThatStartsWith(rand, terrible_handles1, class_name.toLowerCase()[0]);
	}else if (fantasy_interests.indexOf(interest) != -1){
			return getRandomElementFromArrayThatStartsWith(rand, fantasy_handles1, class_name.toLowerCase()[0]);
	}else if (justice_interests.indexOf(interest) != -1){
			return getRandomElementFromArrayThatStartsWith(rand, justice_handles1, class_name.toLowerCase()[0]);
	}
	print("I didn't return anything!? What was my interest: " + interest);
	return null;
}



dynamic getInterestHandle2(Random rand, String aspect, String interest){
	if(music_interests.indexOf(interest) != -1){
		return getRandomElementFromArrayThatStartsWith(rand, music_handles2, aspect.toUpperCase()[0]);
	}else if (culture_interests.indexOf(interest) != -1){
		return getRandomElementFromArrayThatStartsWith(rand, culture_handles2, aspect.toUpperCase()[0]);
	}else if (writing_interests.indexOf(interest) != -1){
		return getRandomElementFromArrayThatStartsWith(rand, writing_handles2, aspect.toUpperCase()[0]);
	}else if (pop_culture_interests.indexOf(interest) != -1){
		return getRandomElementFromArrayThatStartsWith(rand, pop_culture_handles2, aspect.toUpperCase()[0]);
	}else if (technology_interests.indexOf(interest) != -1){
		return getRandomElementFromArrayThatStartsWith(rand, technology_handles2, aspect.toUpperCase()[0]);
	}else if (social_interests.indexOf(interest) != -1){
		return getRandomElementFromArrayThatStartsWith(rand, social_handles2, aspect.toUpperCase()[0]);
	}else if (romantic_interests.indexOf(interest) != -1){
		return getRandomElementFromArrayThatStartsWith(rand, romantic_handles2, aspect.toUpperCase()[0]);
	}else if (academic_interests.indexOf(interest) != -1){
		return getRandomElementFromArrayThatStartsWith(rand, academic_handles2, aspect.toUpperCase()[0]);
	}else if (comedy_interests.indexOf(interest) != -1){
		return getRandomElementFromArrayThatStartsWith(rand, comedy_handles2, aspect.toUpperCase()[0]);
	}else if (domestic_interests.indexOf(interest) != -1){
		return getRandomElementFromArrayThatStartsWith(rand, domestic_handles2, aspect.toUpperCase()[0]);
	}else if (athletic_interests.indexOf(interest) != -1){
		return getRandomElementFromArrayThatStartsWith(rand, athletic_handles2, aspect.toUpperCase()[0]);
	}else if (terrible_interests.indexOf(interest) != -1){
		return getRandomElementFromArrayThatStartsWith(rand, terrible_handles2, aspect.toUpperCase()[0]);
	}else if (fantasy_interests.indexOf(interest) != -1){
		return getRandomElementFromArrayThatStartsWith(rand, fantasy_handles2, aspect.toUpperCase()[0]);
	}else if (justice_interests.indexOf(interest) != -1){
		return getRandomElementFromArrayThatStartsWith(rand, justice_handles2, aspect.toUpperCase()[0]);
	}
	return null;
}



String getBlandHandle1(Random rand, String class_name){
	List<dynamic> second_arr = [];
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
	}else if(class_name == "Sylph" || class_name =="Sage" || class_name =="Scout"){
		second_arr = sylph_handles;
	}else if(class_name == "Seer"|| class_name =="Scribe"){
		second_arr = seer_handles;
	}else if(class_name == "Thief"){
		second_arr = thief_handles;
	}else if(class_name == "Heir"){
		second_arr = heir_handles;
	}else if(class_name == "Bard"){
		second_arr = bard_handles;
	}else if(class_name == "Prince"){
		second_arr = prince_handles;
	}else if(class_name == "Witch"||class_name =="Waste"){
		second_arr = witch_handles;
	}
	return rand.pickFrom(second_arr);
}



String getBlandHandle2(Random rand, String aspect){
	List<dynamic> first_arr = [];
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
	return rand.pickFrom(first_arr);
}




String getRandomChatHandleOld(Random rand, String class_name, String aspect){
	List<dynamic> first_arr = [];
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

	List<dynamic> second_arr = [];
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
	var tmp = randomFromTwoArraysOrdered(rand, second_arr, first_arr);
	return tmp[0]  + tmp[1];
}



String getLevelFromFree(Random rand){
	return rand.pickFrom(free_levels);
}



String getLevelFromInterests(int i, String interest){
	if(music_interests.indexOf(interest) != -1){
			return music_levels[i];
	}else if (culture_interests.indexOf(interest) != -1){
			return culture_levels[i];
	}else if (writing_interests.indexOf(interest) != -1){
			return writing_levels[i];
	}else if (pop_culture_interests.indexOf(interest) != -1){
			return pop_culture_levels[i];
	}else if (technology_interests.indexOf(interest) != -1){
			return technology_levels[i];
	}else if (social_interests.indexOf(interest) != -1){
			return social_levels[i];
	}else if (romantic_interests.indexOf(interest) != -1){
			return romantic_levels[i];
	}else if (academic_interests.indexOf(interest) != -1){
			return academic_levels[i];
	}else if (comedy_interests.indexOf(interest) != -1){
			return comedy_levels[i];
	}else if (domestic_interests.indexOf(interest) != -1){
			return domestic_levels[i];
	}else if (athletic_interests.indexOf(interest) != -1){
			return athletic_levels[i];
	}else if (terrible_interests.indexOf(interest) != -1){
			return terrible_levels[i];
	}else if (fantasy_interests.indexOf(interest) != -1){
			return fantasy_levels[i];
	}else if (justice_interests.indexOf(interest) != -1){
			return justice_levels[i];
	}
	return null;
}


dynamic getLevelFromAspect(num i, String aspect){
	//print("looking for level from aspect, i is " + i.toString());
	List<dynamic> first_arr = [];
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
	//print("found: " + first_arr[i]);
	return first_arr[i];
}



dynamic getLevelFromClass(i, class_name){
	//print("looking for level from class");
	List<dynamic> first_arr = [];
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
	}else if(class_name == "Waste"){
     	first_arr = waste_levels;
    }else if(class_name == "Scout"){
      	first_arr = scout_levels;
    }else if(class_name == "Sage"){
     	first_arr = sage_levels;
    }else if(class_name == "Scribe"){
     	first_arr = scribe_levels;
    }else{
	    first_arr = generic_levels;
	}
	return first_arr[i];
}



dynamic getRandomDenizenQuestFromAspect(player){
	//print("looking for level from aspect");
	List<dynamic> first_arr = [];
	var aspect = player.aspect;
	if(aspect == "Space"){
		first_arr = denizen_space_quests;
	}else if(aspect == "Time"){
		first_arr = denizen_time_quests;
	}else if(aspect == "Breath"){
		first_arr = denizen_breath_quests;
	}else if(aspect == "Doom"){
		first_arr = denizen_doom_quests;
	}else if(aspect == "Blood"){
		first_arr = denizen_blood_quests;
	}else if(aspect == "Heart"){
		first_arr = denizen_heart_quests;
	}else if(aspect == "Mind"){
		first_arr = denizen_mind_quests;
	}else if(aspect == "Light"){
		first_arr = denizen_light_quests;
	}else if(aspect == "Void"){
		first_arr = denizen_void_quests;
	}else if(aspect == "Rage"){
		first_arr = denizen_rage_quests;
	}else if(aspect == "Hope"){
		first_arr = denizen_hope_quests;
	}else if(aspect == "Life"){
		first_arr = denizen_life_quests;
	}
	if(player.denizen_index > first_arr.length -1 ){
		throw(player.title() + " denizen index too high: " + curSessionGlobalVar.session_id);
	}
	var ret = first_arr[player.denizen_index];
	//print(ret);
	player.denizen_index ++;
	return ret;
}




dynamic getRandomQuestFromAspect(Random rand, String aspect, bool postDenizen){
	//print("looking for level from aspect");
	List<dynamic> first_arr = [];
	if(aspect == "Space"){
		if(!postDenizen) first_arr = space_quests;
		if(postDenizen) first_arr = postdenizen_space_quests;
	}else if(aspect == "Time"){
		if(!postDenizen) first_arr = time_quests;
		if(postDenizen) first_arr = postdenizen_time_quests;
	}else if(aspect == "Breath"){
		if(!postDenizen) first_arr = breath_quests;
		if(postDenizen) first_arr = postdenizen_breath_quests;
	}else if(aspect == "Doom"){
		if(!postDenizen) first_arr = doom_quests;
		if(postDenizen) first_arr = postdenizen_doom_quests;
	}else if(aspect == "Blood"){
		if(!postDenizen) first_arr = blood_quests;
		if(postDenizen) first_arr = postdenizen_blood_quests;
	}else if(aspect == "Heart"){
		if(!postDenizen) first_arr = heart_quests;
		if(postDenizen) first_arr = postdenizen_heart_quests;
	}else if(aspect == "Mind"){
		if(!postDenizen) first_arr = mind_quests;
		if(postDenizen) first_arr = postdenizen_mind_quests;
	}else if(aspect == "Light"){
		if(!postDenizen) first_arr = light_quests;
		if(postDenizen) first_arr = postdenizen_light_quests;
	}else if(aspect == "Void"){
		if(!postDenizen) first_arr = void_quests;
		if(postDenizen) first_arr = postdenizen_void_quests;
	}else if(aspect == "Rage"){
		if(!postDenizen) first_arr = rage_quests;
		if(postDenizen) first_arr = postdenizen_rage_quests;
	}else if(aspect == "Hope"){
		if(!postDenizen) first_arr = hope_quests;
		if(postDenizen) first_arr = postdenizen_hope_quests;
	}else if(aspect == "Life"){
		if(!postDenizen) first_arr = life_quests;
		if(postDenizen) first_arr = postdenizen_life_quests;
	}
	return rand.pickFrom(first_arr);
}



String truncateString(str, num) {
	return str.length > num ?
	str.substring(0, num > 3 ? num - 3 : num) + "..." :
	str;
}


String sanitizeString(String string){
	return truncateString(string.replaceAll(new RegExp(r"""<(,?:.|\n)*?>""", multiLine:true), '').replaceAll(new RegExp(",", multiLine:true),''), 144); //good enough for twitter.
}




/**
 * Returns a random integer between min (inclusive) and max (inclusive)
 * Using Math.round() will give you a non-uniform distribution!
 */
/*int rand.nextIntRange(min, max) {
    return (rand.nextDouble() * (max - min + 1)).floor() + min;
}

int getRandomIntNoSeed(min, max) {
    return (random() * (max - min + 1)).floor() + min;
}*/

//
//using a seed will let me make the simulations predictable. This enables sharing AND bullshit cloud predictions.
//and stable time loops. and god, i'm getting the vapors here.
/*num getRandomSeed() {
	//print("getting a random seed, probably to reinit the seed");
	num min = 0;
	var max = 413*612*1025;
    return (random() * (max - min + 1)).floor() + min;
}*/


 //I am in love:  http://indiegamr.com/generate-repeatable-random-numbers-in-js/
// in order to work 'Math.seed' must NOT be undefined,
// so in any case, you HAVE to provide a Math.seed
//this only gave be 200k random numbers. upgarding.
/*seededRandomOld = (max, min) {
	//print("getting seeded random");
    max = max || 1;
    min = min || 0;

    Math.seed = (Math.seed * 9301 + 49297) % 233280;
    var rnd = Math.seed / 233280;

    return min + rnd * (max - min);
}*/
////https://en.wikipedia.org/wiki/Linear_congruential_generator#Parameters_in_common_use if i want to have more possible sessions, use 2^32 or 2^64. see wiki
//have modulus be 2^32 (4294967296), a = 1664525, c = 1013904223
/*seededRandom = (max, min){
	/*random_number = (lcg.previous * a + c) % modulus;
    lcg.previous = random_number;
    return random_number;
	*/
	max = max || 1;
    min = min || 0;
	Math.seed = (Math.seed * 1664525 + 1013904223) % 4294967296;
    var rnd = Math.seed / 4294967296;

    return min + rnd * (max - min);
}*/

dynamic getRandomQuestFromClass(Random rand, String class_name, bool postDenizen){
	//print("looking for level from class");
	List<dynamic> first_arr = [];
	if(class_name == "Maid"){
		if(!postDenizen) first_arr = maid_quests;
		if(postDenizen) first_arr = postdenizen_maid_quests;
	}else if(class_name == "Page"){
		if(!postDenizen) first_arr = page_quests;
		if(postDenizen) first_arr = postdenizen_page_quests;
	}else if(class_name == "Mage"){
		if(!postDenizen) first_arr = mage_quests;
		if(postDenizen) first_arr = postdenizen_mage_quests;
	}else if(class_name == "Knight"){
		if(!postDenizen) first_arr = knight_quests;
		if(postDenizen) first_arr = postdenizen_knight_quests;
	}else if(class_name == "Rogue"){
		if(!postDenizen) first_arr = rogue_quests;
		if(postDenizen) first_arr = postdenizen_rogue_quests;
	}else if(class_name == "Sylph"){
		if(!postDenizen) first_arr = sylph_quests;
		if(postDenizen) first_arr = postdenizen_sylph_quests;
	}else if(class_name == "Seer"){
		if(!postDenizen) first_arr = seer_quests;
		if(postDenizen) first_arr = postdenizen_seer_quests;
	}else if(class_name == "Thief"){
		if(!postDenizen) first_arr = thief_quests;
		if(postDenizen) first_arr = postdenizen_thief_quests;
	}else if(class_name == "Heir"){
		if(!postDenizen) first_arr = heir_quests;
		if(postDenizen) first_arr = postdenizen_heir_quests;
	}else if(class_name == "Bard"){
		if(!postDenizen) first_arr = bard_quests;
		if(postDenizen) first_arr = postdenizen_bard_quests;
	}else if(class_name == "Prince"){
		if(!postDenizen) first_arr = prince_quests;
		if(postDenizen) first_arr = postdenizen_prince_quests;
	}else if(class_name == "Witch"){
		if(!postDenizen) first_arr = witch_quests;
		if(postDenizen) first_arr = postdenizen_witch_quests;
	}else if(class_name == "Waste"){
     		if(!postDenizen) first_arr = waste_quests;
     		if(postDenizen) first_arr = postdenizen_waste_quests;
    }else if(class_name == "Scout"){
      		if(!postDenizen) first_arr = scout_quests;
      		if(postDenizen) first_arr = postdenizen_scout_quests;
    }else if(class_name == "Scribe"){
     		if(!postDenizen) first_arr = scribe_quests;
     		if(postDenizen) first_arr = postdenizen_scribe_quests;
    }else if(class_name == "Sage"){
     		if(!postDenizen) first_arr = sage_quests;
     		if(postDenizen) first_arr = postdenizen_sage_quests;
    }else{
		if(!postDenizen) first_arr = generic_quests;
		if(postDenizen) first_arr = postdenizen_generic_quests;
	}
	return rand.pickFrom(first_arr);
}



List<T> randomFromTwoArrays<T>(Random rand, List<T> arr1, List<T> arr2){
	if(rand.nextDouble() > .5){
		return [rand.pickFrom(arr2), rand.pickFrom(arr1)];
	}else{
		return [rand.pickFrom(arr1), rand.pickFrom(arr2)];
	}
}



List<T> randomFromTwoArraysOrdered<T>(Random rand, List<T> arr1, List<T> arr2){
	return [rand.pickFrom(arr1), rand.pickFrom(arr2)];
}



dynamic indexToWords(i){
	if(i>11) return "???";
	var words = ["first","second","third","fourth","fifth","sixth","seventh","eighth","ninth","tenth","eleventh","twelfth"];
	return words[i];
}



void debug(String str){
	querySelector("#debug").appendHtml("<br>" + str,treeSanitizer: NodeTreeSanitizer.trusted);
}



//why does this not work with seeded randomness?
List<T> shuffle<T>(Random rand, List<T> array) {
  int currentIndex = array.length, randomIndex;
  T temporaryValue;

  // While there remain elements to shuffle...
  while (0 != currentIndex) {

    // Pick a remaining element...
    randomIndex = rand.nextInt(currentIndex);//(rand.nextDouble() * currentIndex).floor();
    currentIndex -= 1;

    // And swap it with the current element.
    temporaryValue = array[currentIndex];
    array[currentIndex] = array[randomIndex];
    array[randomIndex] = temporaryValue;
  }

  return array;
}
//finally giving myself a saner remove array method, but without deprecating the old one.
/*Array.prototype.removeFromArray = (item){
	var index = this.indexOf(item);
	if (index > -1) {
		this.splice(index, 1);
	}
}*/


void removeFromArray(item, array){
	var index = array.indexOf(item);
	if(index != -1) array.removeAt(index);
}



dynamic classNameToInt(class_name){
	List<String> tmp = new List<String>.from(classes);
	tmp.addAll(custom_only_classes);
	var ret = tmp.indexOf(class_name);
	if (ret == -1) ret = 255;
	return ret;
}



String intToClassName(num){
	List<String> tmp = new List<String>.from(classes);
	tmp.addAll(custom_only_classes);
	if(num > tmp.length || num == 255) return "Null"; //Null of Mind;
	return tmp[num];
}



dynamic aspectToInt(aspect){
    var tmp = all_aspects.indexOf(aspect);
    if(tmp == -1) tmp = 255;
	return tmp;
}



String intToAspect(num){
    print("looking for aspect from: " + num);
    if(num > all_aspects.length || num == 255) return "Null";  //Heir of Null;
	return all_aspects[num];
}



dynamic bloodColorToBoost(color){
	 return 2* bloodColorToInt(color); //high blood are STRONG why is this always returning 45??? huh, thinks color is numb.
}



dynamic bloodColorToInt(color){
	if(color == "#ff0000") return 14;
	if(color == "#ffc3df") return 13;
	if(color == null) return 15;
	var ret = bloodColors.indexOf(color);
	return ret;
}



dynamic intToBloodColor(num){
	if(num == 15) return null; //bubble gum pink not an option 'cause my special snowlake fan troll needs to stay special
	if(num == 14) return "#ff0000";
	if(num == 13) return "#ffc3df";
	return bloodColors[num];
}



dynamic hexColorToInt(color){
	return int.parse(color.replaceAll("#",""), radix:16, onError:(String s) => 0xFFFFFF);
}



String intToHexColor(num){
	//print("int is " + num);
	var tmp = num.toString(16);
	var padding = 6 - tmp.length;
	for(int i = 0; i<padding; i++){
		tmp = "0" + tmp;
	}
	//print("which i think is: " + tmp + " in hex");
	return "#" + tmp;
}



dynamic interestCategoryToInt(cat){
	return interestCategories.indexOf(cat);
}



dynamic intToInterestCategory(num){
	return interestCategories[num];
}



String moonToColor(moon){
	if(moon == "Prospit"){
		return "#ffff00";
	}else{
		return "#f092ff";
	}
}





List<String> moons = ["Prospit", "Derse"];

List<String> active_classes = ["Thief","Knight","Heir","Mage","Witch", "Prince", "Waste", "Scout", "Scribe"];
List<String> passive_classes = ["Rogue","Page","Maid","Seer","Sylph", "Bard"];
//if you change the order of ANY of these classes, it will break ocDataStrings
List<String> classes = ["Maid","Page","Mage","Knight","Rogue","Sylph","Seer","Thief","Heir","Bard","Prince","Witch"];
//when a class is used, remove from below list. //if you change the order of ANY of these classes, it will break ocDataStrings
List<String> available_classes = ["Maid","Page","Mage","Knight","Rogue","Sylph","Seer","Thief","Heir","Bard","Prince","Witch"];
List<String> available_classes_guardians = ["Maid","Page","Mage","Knight","Rogue","Sylph","Seer","Thief","Heir","Bard","Prince","Witch"];

//if you change the order of ANY of these classes, it will break ocDataStrings
List<String> custom_only_classes = ["Waste", "Scout", "Sage", "Scribe"]; //Lord, Muse, Guide, Scout, Scribe, Smith, Wright
List<String> required_aspects = ["Space", "Time"];
List<String> all_aspects = ["Space", "Time","Breath","Doom","Blood","Heart","Mind","Light","Void","Rage","Hope","Life"];
List<String> nonrequired_aspects = ["Breath","Doom","Blood","Heart","Mind","Light","Void","Rage","Hope","Life"];
List<String> available_aspects = ["Breath","Doom","Blood","Heart","Mind","Light","Void","Rage","Hope","Life"];

//TODO eventually implent null land titles, like Mounds and Xenon.
List<String> space_land_titles = ["Frogs"];
List<String> time_land_titles = ["Quartz", "Clockwork", "Gears", "Melody","Cesium", "Clocks", "Ticking", "Beats", "Mixtapes","Songs", "Music", "Vuvuzelas", "Drums", "Pendulums"];
List<String> breath_land_titles = ["Wind","Breeze","Zephyr","Gales","Storms","Planes","Twisters", "Hurricanes","Gusts", "Windmills", "Pipes", "Whistles"];
List<String> doom_land_titles = ["Fire", "Death", "Prophecy", "Blight", "Rules", "Prophets", "Poison", "Funerals", "Graveyards", "Ash", "Disaster", "Fate", "Destiny", "Bones"];
List<String> blood_land_titles = ["Pulse", "Bonds", "Clots", "Bloodlines", "Ichor", "Veins", "Chambers", "Arteries", "Unions"];
List<String> heart_land_titles = ["Little Cubes","Hats","Dolls","Selfies","Mirrors", "Spirits", "Souls", "Jazz", "Shards", "Splinters"];
List<String> mind_land_titles = ["Thought", "Rationality", "Decisions","Consequences", "Choices", "Paths", "Trails", "Trials"];
List<String> light_land_titles = ["Treasure", "Light","Knowledge","Radiance", "Gambling", "Casinos", "Fortune", "Sun", "Glow", "Chance"];
List<String> void_land_titles = ["Silence", "Nothing","Void","Emptiness", "Tears", "Dust", "Night", "[REDACTED]", "???", "Blindness"];
List<String> rage_land_titles = ["Mirth","Whimsy","Madness","Impossibility", "Chaos", "Hate", "Violence", "Joy", "Murder", "Noise", "Screams","Denial"];
List<String> hope_land_titles = ["Angels","Hope","Belief","Faith","Determination", "Possibility", "Hymns", "Heroes", "Chapels", "Lies", "Bullshit"];
List<String> life_land_titles = ["Dew","Spring","Beginnings","Vitality", "Jungles", "Swamps", "Gardens", "Summer", "Chlorophyll", "Moss", "Rot", "Mold"];


//google is an in joke because apparently google reports that all sessions are crashed and it is beautiful and google is a horrorterror.
List<String> corruptedOtherLandTitles = [Zalgo.generate("Google"), Zalgo.generate("Horrorterrors"),Zalgo.generate("Glitches"),Zalgo.generate("Grimoires"),Zalgo.generate("Fluthlu"),Zalgo.generate("The Zoologically Dubious")];

//typoed special snowlake once insteada snowflake, and now it's a land.
List<String> free_land_titles = ["Snowlake", "Heat","Sand","Brains","Haze","Tea","Flow","Maps","Caves","Tents","Wrath","Rays","Glass","Lava","Magma"]
..addAll(["Shade","Frost","Rain","Fog","Trees","Flowers","Books","Technology","Ice","Water", "Waterfalls","Rocks"])
..addAll(["Forests","Grass","Tundra","Thunder","Winter","Peace","Food","Shoes","Weasels","Deserts","Dessert","Lightning"])
..addAll(["Suburbs","Cities","Neighborhoods","Isolation","Schools","Farms","Annoyance","Hunger","Cake","Tricks","Ruins","Temples", "Towers"])
..addAll(["Nails","Smoke","Curses","Flood","Ooze","Mud","Weeds","Vines","Courts","Clay","Halls","Choirs","Mushrooms", "Locks"])
..addAll(["Slums","Balloons","Rumbling","Warfare","Cliffs","Needles","Mountains","Shadows","Circuitry","Fences","Webs"])
..addAll(["Bone","Arenas","Wonder","Fluff","Cotton","Domes","Gold","Silver","Bronze","Ruby","Ribbon"])
..addAll(["Hair","Teeth","Tendrils","Mouths","Paint","Pain","Wood","Colors","Echoes","Fossils","Roses","Tulips","Mummies", "Zombies", "Corpses"])
..addAll(["Mysteries","Splendor","Luxury","Cash","Coins","Crystals","Gemstones","Cards","Tarot","Wagons","Puzzles","Mayhem","Redundancy","Redundancy"])
..addAll(["Obsolescence","Deceit","Ruse","Distraction","Libraries","Blocks","Video Games","Vermin","Butchers","Meat","Clouds", "Horses"])

..addAll(corruptedOtherLandTitles);




List<String> space_levels = ["GREENTIKE", "RIBBIT RUSTLER", "FROG-WRANGLER"];
List<String> time_levels = ["MARQUIS MCFLY", "JUNIOR CLOCK BLOCKER", "DEAD KID COLLECTOR"];
List<String> breath_levels = ["BOY SKYLARK", "SODAJERK'S CONFIDANTE", "MAN SKYLARK"];
List<String> doom_levels = ["APOCALYPSE HOW", "REVELATION RUMBLER", "PESSIMISM PILGRIM"];
List<String> blood_levels = ["FRIEND HOARDER YOUTH","HEMOGOBLIN", "SOCIALIST BUTTERFLY"];
List<String> heart_levels = ["SHARKBAIT HEARTHROB", "FEDORA FLEDGLING","PENCILWART PHYLACTERY"];
List<String> mind_levels = ["NIPPER-CADET", "COIN-FLIPPER CONFIDANTE", "TWO-FACED BUCKAROO"];
List<String> light_levels = ["SHOWOFF SQUIRT","JUNGLEGYM SWASHBUCKLER","SUPERSTITIOUS SCURRYWART"];
List<String> void_levels = ["KNOW-NOTHING ANKLEBITER","INKY BLACK SORROWMASTER","FISTICUFFSAFICTIONADO"];
List<String> rage_levels = ["MOPPET OF MADNESS","FLEDGLING HATTER","RAGAMUFFIN REVELER"];
List<String> hope_levels = ["GADABOUT PIPSQUEAK","BELIVER EXTRAORDINAIRE","DOCTOR FEELGOOD"];
List<String> life_levels = ["BRUISE BUSTER","LODESTAR LIFER","BREACHES HEALER"];

List<String> maid_levels = ["SCURRYWART SERVANT", "SAUCY PILGRIM", "MADE OF SUCCESS"];
List<String> page_levels = ["APPRENTICE ANKLEBITER", "JOURNEYING JUNIOR", "OUTFOXED BUCKAROO"];
List<String> mage_levels = ["WIZARDING TIKE", "THE SORCERER'S SCURRYWART", "FAMILIAR FRAYMOTTIFICTIONADO"];
List<String> knight_levels = ["QUESTING QUESTANT", "LADABOUT LANCELOT", "SIR SKULLDODGER"];
List<String> rogue_levels = ["KNEEHIGH ROBINHOOD","DASHING DARTABOUT", "COMMUNIST COMMANDER"];
List<String> sylph_levels = ["SERENE SCALLYWAG", "MYSTICAL RUGMUFFIN","FAE FLEDGLING"];
List<String> thief_levels = ["RUMPUS RUINER", "HAMBURGLER YOUTH", "PRISONBAIT"];
List<String> heir_levels = ["UNREAL HEIR","HEIR CONDITIONER","EXTRAORDINHEIR"];
List<String> bard_levels = ["SKAIA'S TOP IDOL","POPSTAR BOPPER","SONGSCUFFER"];
List<String> prince_levels = ["PRINCE HARMING","ROYAL RUMBLER","DIGIT PRINCE"];
List<String> witch_levels = ["WESTWORD WORRYBITER","BUBBLETROUBLER","EYE OF GRINCH"];
List<String> seer_levels = ["SEEING iDOG","PIPSQUEAK PROGNOSTICATOR","SCAMPERVIEWER 5000"];
List<String> waste_levels = ["4TH WALL AFICIONADO","CATACLYSM COMMANDER","AUTHOR"];
List<String> scout_levels = ["BOSTON SCREAMPIE","COOKIE OFFERER","FIRE FRIEND"];
List<String> scribe_levels = ["MIDNIGHT BURNER","WRITER WATCHER","DIARY DEAREST"];
List<String> sage_levels = ["HERBAL ESSENCE","CHICKEN SEASONER","TOMEMASTER"];
List<String> generic_levels = ["SNOWMAN SAVIOR","NOBODY NOWHERE","NULLZILLA"];

List<String> free_levels = ["NIPPER CADET","PESKY URCHIN","BRAVESPROUT","JUVESQUIRT","RUMPUS BUSTER","CHAMP-FRY","ANKLEBITER","CALLOUSED TENDERFOOT","RASCALSPRAT","GRITTY MIDGET","BRITCHES RIPPER","ALIEN URCHIN", "NESTING NEWB"];
//only need two for each. since each player has two interests, combines to 4
List<String> music_levels = ["SINGING SCURRYWORT","MUSICAL MOPPET"];
List<String> culture_levels = ["APPRENTICE ARTIST","CULTURE BUCKAROO"];
List<String> writing_levels = ["SHAKY SHAKESPEARE","QUILL RUINER"];
List<String> pop_culture_levels = ["TRIVIA SMARTYPANTS","NIGHTLY NABBER"];
List<String> technology_levels = ["HURRYWORTH HACKER","CLANKER CURMUDGEON"];
List<String> social_levels = ["FRIEND-TO-ALL","FRIEND COLLECTOR"];
List<String> romantic_levels = ["QUESTING CUPID","ROMANCE EXPERT"];
List<String> academic_levels = ["NERDY NOODLER","SCAMPERING SCIENTIST"];
List<String> comedy_levels = ["PRATFALL PRIEST","BEAGLE PUSS DARTABOUT"];
List<String> domestic_levels = ["BATTERBRAT","GRITTY GUARDIAN"];
List<String> athletic_levels = ["MUSCLES HOARDER","BODY BOOSTER"];
List<String> terrible_levels = ["ENEMY #1","JERKWAD JOURNEYER"];
List<String> fantasy_levels = ["FAKEY FAKE LOVER","FANTASTIC DREAMER"];
List<String> justice_levels = ["JUSTICE JUICER","BALANCE RUMBLER"];

List<String> level_bg_colors = ["#8ff74a","#ba1212","#ffffee","#f0ff00","#9c00ff","#2b6ade","#003614","#f8e69f","#0000ff","#eaeaea","#ff9600","#581212","#ffa6ac","#1f7636","#ffe1fc","#fcff00"];
List<String> level_font_colors = ["#264d0c","#ff00d2","#ff0000","#626800","#da92e0","#022e41","#aaffa6","#000052","#6dffdb","#e5d200","#00911b","#ff0000","#5e005f","#fbff8d","#000000","#"];

List<String> space_quests = ["seeking out out potential Frog sources"]
	..add("restoring a half-ruined Frog shrine in the wilds of the Land")
	..add("interogating consorts as to what the point of Frogs even is")
	..add("navigating one's way through a deudly dungeon in complete darkness, relying only on one's spatial senses");
List<String> time_quests = ["manipulating the local stock exchange through a series of cunningly disguised time doubles"]
	..add("stopping a variety of disasters from happening before even the first player enters the medium")
	..add("cheating at obstacle course time trials to get a finishing value of exactly 0.0 seconds");
List<String> breath_quests = ["putting out fires in consort villages through serendipitous gales of wind"]
	..add("delivering mail through a complicated series of pneumatic tubes")
	..add("paragliding through increasingly elaborate obstacle courses to become the champion (it is you)");
List<String> doom_quests = ["calculating the exact moment a planet quake will destroy a consort village with enough time remaining to perform evacuation"]
	..add("setting up increasingly complex Rube Goldberg machines to defeat all enemies in a dungeon at once")
	..add("obnoxiously memorizing the rules of a minigame, and then blatantly  abusing them to achieve an otherwise impossible victory");
List<String> blood_quests = ["uniting warring consort nations against a common enemy"]
	..add("organizing 5 bickering consorts long enough to transverse a dungeon with any degree of competence")
	..add("learning the true meaning of this human disease called friendship");
List<String> heart_quests = ["providing a matchmaking service for the local consorts (ships guaranteed)"]
	..add("doing battle with shadow clones that are eventually defeated when you accept them as a part of you")
	..add("correctly picking out which item represents them out of a vault of a thousand bullshit shitty stuffed animals");
List<String> mind_quests = ["manipulating the local consorts into providing dungeon clearing services"]
	..add("presiding over increasingly hard consort court cases, punishing the guilty and pardoning the innocent")
	..add("pulling pranks as a minigame, with bonus points awarded for pranks performed on those who 'had it coming'");
List<String> light_quests = ["winning at increasingly unfair gambling challenges"]
	..add("researching way too much lore and minutia to win at trivia contests")
	..add("explaining how to play a mini game to particularly stupid consorts until they finally get it");
List<String> void_quests = ["destroying and/or censoring embarrassing consort records"]
	..add("definitely doing quests, just...not where we can see them")
	..add("playing a hilariously fun boxing minigame");
List<String> rage_quests = ["fighting hordes upon hordes of enemies in increasingly unfair odds until defeating them all in a berserk rage"] //You can't believe how easy it is. You just have to go... a little crazy. And then, suddenly, it all makes sense, and everything you do turns to gold.
	..add("figuring out increasingly illogical puzzles until lateral thinking becomes second nature")
	..add("dealing with the most annoying dungeon challenges ever, each more irritating and aneurysm inducing than the last");
List<String> hope_quests = ["performing bullshit acts of faith, like walking across invisible bridges"]
	..add("becoming the savior of the local consorts, through fulfillment of various oddly specific prophecies")
	..add("brainstorming a variety of ways the local consorts can solve their challenges");
List<String> life_quests = ["coaxing the fallow farms of the local consorts into becoming fertile"]
	..add("healing a seemingly endless parade of stricken consorts")
	..add("finding and rescuing consort children trapped in a burning building");


List<String> maid_quests = ["doing the consorts' menial errands, like delivering an item to a dude standing RIGHT FUCKING THERE"]
	..add("repairing various ways the session has been broken")
	..add("protecting various consorts with game powers");
List<String> page_quests = ["going on various quests of self discovery and confidence building"]
	..add("partnering with a local consort hero to do great deeds and slay evil foes")
	..add("learning to deal with disapointment after dungeon after dungeon proves to have all the enemies, and none of the treasure");
List<String> mage_quests = ["performing increasingly complex alchemy for demanding, moody consorts"]
	..add("learning to silence their Mage Senses long enough to not go insane")
	..add("learning to just let go and let things happen");
List<String> knight_quests = ["protecting the local consorts from a fearsome foe"]
	..add("protecting the session from various ways it can go shithive maggots")
	..add("questing to collect the 7 bullshit orbs of supreme bullshit and deliver them to the consort leader");
List<String> rogue_quests = ["robbing various tombs and imp settlements to give to impoverished consorts"]
	..add("stealing a priceless artifact in order to fund consort orphanages")
	..add("planning an elaborate heist to steal priceless grist from a boss ogre in order to alchemize shoes for orphans");
List<String> sylph_quests = ["restoring a consort city to its former glory"]
	..add("preserving the legacy of a doomed people")
	..add("providing psychological counseling to homeless consorts");
List<String> thief_quests = ["robbing various enemy imps and ogres to obtain vast riches"]
	..add("planning an elaborate heist that relies on several hard-to-predict factors going absolutely perfectly")
	..add("torrenting vast amounts of grist from the other players");
List<String> heir_quests = ["retrieving a sword from a stone"]
	..add("completing increasingly unlikely challenges through serendepitious coincidences")
	..add("inheriting and running a successful, yet complex company");
List<String> bard_quests = ["allowing events to transpire such that various quests complete themselves"]
	..add("baiting various enemies into traps for an easy victory")
	..add("watching as their manipulations result in consorts rising up to defeat imps");
List<String> prince_quests = ["destroying enemies thoroughly"]
	..add("riding in at the last minute to defeat the local consorts hated enemies")
	..add("learning to grow as a person, despite the holes in their personality");
List<String> seer_quests = ["making the various bullshit rules of SBURB part of their personal mythos"]
	..add("collaborating with the exiled future carapacians to manipulate Prospit and Derse according to how its supposed to go")
	..add("suddenly understanding everything, and casting sincere doubt at the laughable insinuation that they ever didn't");
List<String> witch_quests = ["performing elaborate punch card alchemy through the use of a novelty witch's cauldron"]
	..add("deciding which way to go in a series of way-too-long mazes")
	..add("solving puzzles in ways that completely defy expectations");
List<String> waste_quests = ["being a useless piece of shit and reading FAQs to skip the hard shit in levels","causing ridiculous amounts of destruction trying to skip quest lines","learning that sometimes you have to do things right, and can't just skip ahead"];
List<String> scout_quests = ["exploring areas no Consort has dared to trespass in","getting lost in ridiculously convoluted mazes","playing map-creating mini games"];
List<String> scribe_quests = ["taking down the increasingly random and nonsensical oral history of a group of local Consorts","playing typing themed mini games.","saving an important piece of a riddle from a crumbling building"];
List<String> sage_quests = ["making the lore of SBURB part of their personal mythos","learning to nod wisely and remain silent when Consorts start yammering on about the Ultimate Riddle","participating in riddle contests to prove their intelligence to local Consorts"];
List<String> generic_quests = ["definitely doing class related quests", "solving consorts problems in a class themed manner", "absolutely not goofing off"];


//if bike quests are too common, lock them to real selves only, no dream selves.
List<String> bike_quests = ["performing the SWEETEST bike stunts in all of SBURB", "doing bike stunts so sick they are illegal by Dersite standards", "doing bike stunts with air so unreal time just stops and everybody wishes to be them", "performing an endless grind on prospit's moon chain"]
	..add("getting air so unreal that they jump from one planet to another on their sick nasty bike")
	..add("writing dope as fuck Bike Stunt FAQs to keep their sanity")
	..add("singing a song, you know, from that shitty kids cartoon? 'wake up in the morning there's a brand new day ahead the sun is bright and the clouds smile down and all your friends are dead '");


List<String> denizen_space_quests = ["trying to figure out why the Forge is unlit"]
	..add("clearing various bullshit obstacles to lighting the Forge")
	..add("lighting the Forge");  //TODO requires a magic ring.

List<String> denizen_time_quests = ["searching through time for an unbroken legendary piece of shit weapon"]
	..add("realizing that the legendary piece of shit weapon was broken WAY before they got here")
	..add("alchemizing an unbroken version of the legendary piece of shit weapon to pawn off as the real thing to Hephaestus");

List<String> denizen_breath_quests = ["realizing that the Denizen has thoroughly clogged up the pneumatic system"]
	..add("trying to manually unclog the pneumatic system")
	..add("using Breath powers to unclog the pneumatic system");

List<String> denizen_doom_quests = ["listening to consorts relate a doomsday prophecy that will take place soon"]
	..add("realizing technicalities in the doomsday prophecy that would allow it to take place but NOT doom everyone")
	..add("narrowly averting the doomsday prophecy through technicalities, seeming coincidence, and a plan so convoluted that at the end of it no one can be sure the plan actually DID anything");

List<String> denizen_blood_quests = ["convincing the local consorts to rise up against the Denizen"]
	..add(" give unending speeches about the power of friendship and how they are all fighting for loved ones back home to confused and impressionable consorts")
	..add("completely overthrowing the Denizen's underlings in a massive battle");

List<String> denizen_heart_quests = ["starting an underground rebel group to free the consorts from the oppressive underling government"]
	..add("having a huge public protest against the underling government, displaying several banned fashion items")
	..add("convincing the local consorts that the only thing that can stifle their identity is their own fear");

List<String> denizen_mind_quests = ["learning of the systemic corruption in the local consort's justice system"]
	..add("rooting out corrupt consort officials, and exposing their underling backers")
	..add("setting up a self-sufficient consort justice system");


List<String> denizen_light_quests = ["realizing the the entire point of SBURB has been a lie"]
	..add("learning the true purpose of SBURB")
	..add("realizing just how important frogs and grist and the Ultimate Alchemy truly are");


List<String> denizen_void_quests = ["???"]
	..add("[redacted]")
	..add("[void players, am I right?]");

//http://rumkin.com/tools/cipher/atbash.php (thinking of lOSS here)
//var denizen_rage_quests = ["~~~You can't believe how easy it is. You just have to go... a little crazy. And then, suddenly, it all makes sense, and everything you do turns to gold.~~~"]; //
//denizen_rage_quests.add("~~~ The denizen, Bacchus, thinks that grammar is important. That rules are important. That so much is important. You'll show him. ~~~");
//denizen_rage_quests.add("~~~ Nothing makes sense here anymore. Just the way you like it. The consorts are whipped into a frothing fury. Bacchus is awake.  ~~~");

var denizen_rage_quests = ["~~~You can't believe how vzhb it is. You just have to go... a little xizab. Zmw gsvm, suddenly, rg all makes sense, zmw everything blf wl gfimh gl gold. ~~~"] //
	..add("~~~ Gsv denizen, XXXXXX, gsrmph gszg grammar rh important. Gszg rules ziv important. Gszg hl nfxs rh rnkligzmg. You'll show him.  ~~~")
	..add("~~~ Mlgsrmt nzpvh hvmhv sviv zmbnliv. Qfhg gsv dzb blf orpv rg. Gsv xlmhligh ziv dsrkkvw rmgl z uilgsrmt ufib. XXXXXX rh zdzpv.   ~~~");


var denizen_hope_quests = ["realizing that the consorts real problem is their lack of morale"]
	..add("inspiring impressionable consorts who then go on to inspire others ")
	..add("defeating the underling that was causing the local consorts to not believe in themselves");

var denizen_life_quests = ["defeating an endless array of locust underlings"]
	..add("realizing that Hemera is somehow spawning the endless hoard of locust underlings ")
	..add("preventing the next generation of locust underlings, thus ending the consort famine");





/*
this.goodMild = "Friends";
	this.goodBig = "Totally In Love";
	this.badMild = "Rivals";
	this.badBig = "Enemies";
	*/
var goodMildDesc = ["a pretty good kid", "nice enough", "merely tolerable", "just friendly"];
var goodBigDesc = ["the most fascinating kid left", "distractingly pretty", "really hot"];
var bigMildDesc = ["kind of a jerk", "sort of an asshole", "only sort of irritating", "just a little annoying"];
var bigBadDesc = ["just the smelliest bag of assholes", "the most infuriating asshole around", "most likely to screw everyone over", "dangerous"];


var democracyTasks = ["WV gives talks to a random carapacian boy, demanding he support democracy."," WV gathers followers using techniques learned from reading a book on carapacian etiquette. "]
	..add(" WV demonstrates tactical knowledge to Dersites, convincing them they can win against the King. ")
	..add(" WV gives rousing speeches to Prospitians, emphasizing that they share the same goal. ")
	..add(" WV gives rousing speeches to Dersites, listing every crime the King and Queen have commited against their own people. ")
	..add(" WV debates Dersite beliefs, asking if they REALLY want to die in the Reckoning rather than go live in a new Universe (loathesome though frogs may be). ")
	..add(" WV distributes hastily scrawled parking ticket pamphlets decrying the Royals as 'Total Jerks Bluh Bluh’, much to the ire of the Dersite Parking Authority.")
	..add(" WV arranges a covert series of blinking signals with the help of a firefly. ");


var democracySuperTasks = [" WV flips the fuck out and starts distributing free TAB soda to anyone who joins his army. "]
	..add(" WV grabs a random Player and uses them as a prop during a speech, triggering the frothing devotion of the local consorts. ")
	..add(" WV arranges a military training session with carapacians on both sides of the War, raising their confidence for the upcoming battle. ")
	..add(" WV accidentally steals a colossal Derse war machine. Somehow. ")
	..add(" WV trains other carapacians in the art of forward attacks. They are the best pawn. It is them. ")
	..add(" WV and a random Player go on an alchemy spree, arming the democratic army with all manners of insane weaponry that is off both the hook and also the chain. In fact, they couldn’t manage to alchemize a single flail. Only giant spiky balls. ");


var mayorDistractionTasks = [" WV is distracted eating green objects rather than recruiting for his army. "]
	..add( " WV is distracted planning the civil infrastructure of a city, rather than recruiting for his army.")
	..add(" WV is distracted fantasizing about how great of a mayor he will be. ")
	..add(" WV accidentally tried to recruit carapacians already part of his army. Stupid stupid stupid! ")
	..add(" WV gets distracted freaking out about car safety. ")
	..add(" WV gets distracted freaking out about how evil bad bad bad bad monarchy is. ")
	..add(" WV gets distracted writing a constitution for the new democracy. ");

//rage and void can do these in VoidySTuff, even if it's not a quest. just for funsies. (even the heavy shit. oh look the rage player is being LOL SO RANDOM what with their decapitated head shenanigans.)
var lightQueenQuests = ["makes a general nuisance of themselves to the Black Queen.", "spreads disparaging rumours concerning the Black Queen.", "sabotages several official portraits of the Black Queen."]
	..addAll(["sets up various pranks and traps around Derse.","breaks all the lights in the throne room.","vandalizes various Dersite public hotspots. Fuck the Authority Regulators!"])
	..addAll(["switches the hats of all of the Dersite high ranking officials.","steals all the licorice scottie dogs on Derse. ","convinces the Enquiring Carapacian that the Black Queen is actually three Salamanders in a robe. ", "smuggles contraband forbidden by the Black Queen. Like ice cream. And frogs. The Black Queen’s trade edicts don’t really make much sense. "]);


var moderateQueenQuests = ["completely ruins the Dersite bureaucracy's filing scheme. Now it will take WEEKS to reorganize everything. ","releases a slew of random Dersite prisoners.","alchemizes a metric shit ton of antiRoyalty propoganda and leaves it lying around in enticing wallet moduses."]
	..addAll(["performs a daring spy mission, gaining valuable intel to use on the Black Queen. ","covers the royal palace with totally illegal frog graffiti. I mean, just look at all those poorly drawn frogs. So. Illegal. ","turns the Queens allies against her, forcing her to spend valuable time quieting their complaints and schemes. "])
	..addAll(["absconds with an official looking stamp from a crucial bureaucratic office, grinding the ceaseless machine of Dersite civics to a halt.","demonstrates their aptitude for immersion in local tradition and shows a royal guard their stabs. ","smuggles contraband forbidden by the Black Queen. Like weapons of revolt and regicide swords."]);


var heavyQueenQuests = ["turns one the Black Queen’s most valuable allies against her, distracting her with a minor revolution. ","convinces Dersites to rise up, leaving the head of a famed public official in front of the palace as a rallying point. "]
	..addAll(["performs a daring assassination mission against one of the Black Queen's agents, losing her a valuable ally. ","sabotages basic services on Derse, fomenting doubt in the Queen’s competence among citizens.","destroys a series of Derse laboratories in the veil, severely damaging the Derse war effort. "]);





var tricksterColors = ["#FF0000","#00FF00","#0000FF","#FFFF00","#00FFFF","#FF00FF","#efffff","#5ef89c","#5ed6f8","#f85edd","#ffcaf6","#d0ffca","#cafcff","#fffdca","#ffd200","#a7caff","#ff6c00","#fffc00","#f5b4ff","#ffceb1","#ffcaca","#e0efc6","#c5ffed","#c5dcff","#ebdbff","#ffdbec","#ecfff4","#f0ecff","#c0ff00","#f7bfff","#dfffbf"];

var bloodColors = ["#A10000","#a25203","#a1a100","#658200","#416600","#078446","#008282","#004182","#0021cb","#631db4","#610061","#99004d"];

var interestCategories = ["Comedy","Music","Culture","Writing","Athletic", "Terrible","Justice","Fantasy","Domestic", "PopCulture","Technology","Social","Romance","Academic"];


var music_interests = ["Rap","Music","Song Writing","Musicals","Dance", "Singing","Ballet","Playing Guitar","Playing Piano", "Mixtapes","Turntables"];
var culture_interests = ["Drawing","Painting","Documentaries","Fan Art" ,"Graffiti","Theater","Fine Art", "Literature","Books", "Movie Making"];
var writing_interests = ["Writing", "Fan Fiction","Script Writing","Character Creation","Dungeon Mastering", "Authoring"];
var pop_culture_interests = ["Irony","Action Movies", "Superheroes", "Supervillains", "Video Games", "Movies", "Television","Comic Books","TV","Heroes"];
var technology_interests = ["Programming", "Hacking","Coding","Robots","Artificial Intelligence", "Engineering","Manufacturing","Cyborgs", "Androids","A.I.","Automation"];
var social_interests = ["Psychology","Religion","Animal Training", "Pets","Animals","Online Roleplaying", "Live Action Roleplaying","Tabletop Roleplaying", "Role Playing","Social Media","Charity","Mediating"];
var romantic_interests = ["Girls", "Boys","Romance","Shipping","Relationships", "Love", "Romantic Comedies","Fate","Dating"];
var academic_interests = ["Archaeology", "Mathematics", "Astronomy","Knowledge","Physics", "Biology", "Chemistry","Geneology","Science","Molecular Gastronomy","Model Trains","Politics","Geography", "Cartography","Typography","History"];
var comedy_interests = ["Puppets","Pranks","Comedy", "Jokes", "Puns", "Stand-up Comedy","Humor","Comics","Satire","Knock Knock Jokes"];
var domestic_interests = ["Sewing", "Fashion","Meditation","Babies","Peace","Knitting","Cooking", "Baking","Gardening", "Crochet", "Scrapbooking"];
var athletic_interests = ["Yoga","Fitness", "Sports","Boxing", "Track and Field", "Swimming", "Baseball", "Hockey", "Football", "Basketball", "Weight Lifting"];
var terrible_interests = ["Arson","Clowns", "Treasure","Money","Violence", "Death","Animal Fights","Insults","Hoarding","Status","Classism", "Online Trolling","Intimidation","Fighting","Genocide","Murder","War"];
var fantasy_interests = ["Wizards", "Horrorterrors", "Mermaids", "Unicorns", "Science Fiction", "Fantasy","Ninjas","Aliens","Conspiracies","Faeries", "Elves", "Vampires", "Undead"];
var justice_interests = ["Social Justice","Detectives","Mysteries","Leadership","Revolution","Justice","Equality","Sherlock Holmes"];

List<dynamic> interests = []
	..addAll(music_interests)
	..addAll(culture_interests)
	..addAll(writing_interests)
	..addAll(pop_culture_interests)
	..addAll(technology_interests)
	..addAll(social_interests)
	..addAll(romantic_interests)
	..addAll(academic_interests)
	..addAll(comedy_interests)
	..addAll(domestic_interests)
	..addAll(athletic_interests)
	..addAll(terrible_interests)
	..addAll(fantasy_interests)
	..addAll(justice_interests);


var prefixes = ["8=D",">->","//", "tumut",")","><>","(", "\$", "?", "=begin", "=end"]
	..addAll(["<3","<3<","<>","c3<","{","}","[","]","'",".",",","~","!","~","^","&","#","@","%","*"]);

//debug("TODO: interest quirks, is it worth it?");
List<dynamic> music_quirks = [];
List<dynamic> culture_quirks = [];
List<dynamic> writing_quirks = [];
List<dynamic> pop_culture_quirks = [];
List<dynamic> technology_quirks = [];
List<dynamic> social_quirks = [];
List<dynamic> romantic_quirks = [];
List<dynamic> academic_quirks = [];
List<dynamic> comedy_quirks = [];
List<dynamic> domestic_quirks = [];
List<dynamic> athletic_quirks = [];
List<dynamic> terrible_quirks = [];
var fantasy_quirks = [["very","fairy"]];
List<dynamic> justice_quirks = [];

var sbahj_quirks = [["asshole","dunkass"],["happen","hapen"],["we're","where"],["were","where"],["has","hass"],["lol","ahahahaha"],["dog","god"],["god","dog"],["know","no"]]
	..addAll([["they're","there"],["their","there"],["theyre","there"],["through","threw"],["lying","lyong"],["distraction","distaction"],["garbage","gargbage"],["angel","angle"]])
	..addAll([["the","thef"],["i'd","i'd would"],["i'm","i'm am"],["don't","don't not"],["won't","won't not"],["can't","can't not"],["ing","ung"]])
	..addAll([["ink","ing"],["ed","id"],["id","ed"],["ar","aur"],["umb","unk"],["ian","an"],["es","as"],["ough","uff"]]);


var terribleCSSOptions = [["position: ", "absolute"],["position: ", "relative"],["position: ", "static"],["position: ", "fixed"],["float: ", "left"] ,["float: ", "right"],["width: ", "????"],["height: ", "????"],["right: ", "????"] ,["top: ", "????"] ,["bottom: ", "????"] ,["left: ", "????"]   ];

var fish_quirks = [["calm","clam"],["ass","bass"],["god","glub"],["god","cod"],["fuck","glub"],["really","reely"],["kill","krill"],["thing","fin"],["well","whale"],["purpose","porpoise"],["better","betta"],["help","kelp"],["see","sea"],["friend","frond"],["crazy","craysea"], ["kid","squid"], ["hell","shell"]];

//not as extreme as a troll quirk, buxt...
var conversational_quirks = [["pro","bro"],["guess","suppose"],["S\\b", "Z"],["oh my god","omg"],["like", "liek"],["ing","in"],["have to","hafta"], ["want to","wanna"],["going to","gonna"], ["i'm","i am"],["you're","you are"],["we're","we are"],["forever","5ever"], ["ever","evah"],["er","ah"],["to","ta"]]
	..addAll([["I'm", "Imma"],["don't know", "dunno"],["school","skool"],["the","teh"],["aren't","aint"],["ie","ei"],["though","tho"],["you","u"],["right","rite"]])
	..addAll([["n't"," not"], ["'m'"," am"], ["kind of", "kinda"],["okay", "ok"],["\\band\\b","&"],["\\bat\\b","@"],["okay", "okey dokey"]]);

var very_quirks = [["\\bvery\\b","adequately"],["\\bvery\\b","really"],["\\bvery\\b","super"],["\\bvery\\b", "amazingly"],["\\bvery\\b","hella"],["\\bvery\\b","extremely"],["\\bvery\\b","absolutely"],["\\bvery\\b","mega"],["\\bvery\\b ","extra"],["\\bvery\\b","ultra"],["\\bvery\\b","hecka"],["\\bvery\\b","totes"]];
var good_quirks = [["\\bgood\\b","good"],["\\bgood\\b","agreeable"],["\\bgood\\b", "marvelous"],["\\bgood\\b", "ace"],["\\bgood\\b", "wonderful"],["\\bgood\\b","sweet"],["\\bgood\\b","dope"],["\\bgood\\b","awesome"],["\\bgood\\b","great"],["\\bgood\\b","radical"],["\\bgood\\b","perfect"],["\\bgood\\b","amazing"],["\\bgood\\b","super good"],["\\bgood\\b","acceptable"]];
var asshole_quirks = [["asshole","dickhead"],["asshole","pukestain"],["asshole","dirtbag"],["asshole","fuckhead"],["asshole", "asshole"],["asshole", "dipshit"],["asshole", "garbage person"],["asshole", "fucker"],["asshole", "poopy head"],["asshole", "shit sniffer"],["asshole", "jerk"],["asshole", "plebeian"],["asshole", "fuckstain"],["asshole", "douchebag"]];
var lol_quirks = [["lol","lol"],["lol","haha"],["lol","ehehe"],["lol","heh"],["lol","omg lol"],["lol","rofl"],["lol","funny"],["lol"," "],["lol","hee"],["lol","lawl"],["lol","roflcopter"],["lol","..."],["lol","bwahah"],["lol","*giggle*"],["lol",":)"]];
var greeting_quirks = [["\\bhey\\b", "hey"],["\\bhey\\b", "hi"],["\\bhey\\b", "hello"],["\\bhey\\b", "greetings"],["\\bhey\\b", "yo"],["\\bhey\\b", "sup"]];
var dude_quirks = [["dude","guy"], ["dude","guy"],["dude","man"],["dude","you"],["dude","friend"],["dude","asshole"],["dude","fella"],["dude","bro"]];
var curse_quirks = [["fuck", "beep"],["fuck", "motherfuck"],["\\bfuck\\b", "um"],["\\bfuck\\b", "fuck"],["\\bfuck\\b", "shit"],["\\bfuck\\b", "cocks"],["\\bfuck\\b", "nope"],["\\bfuck\\b", "goddammit"],["\\bfuck\\b", "damn"],["\\bfuck\\b", "..."],["\\bfuck\\b", "...great."],["\\bfuck\\b", "crap"],["\\bfuck\\b", "fiddlesticks"],["\\bfuck\\b", "darn"],["\\bfuck\\b", "dang"],["\\bfuck\\b", "omg"]];
//problem: these are likely to be inside of other words.
var yes_quirks = [["\\byes\\b","certainly"],["\\byes\\b","indeed"],["\\byes\\b","yes"],["\\byes\\b","yeppers"],["\\byes\\b","right"],["\\byes\\b","yeah"],["\\byes\\b","yep"],["\\byes\\b","sure"],["\\byes\\b","okay"]];
var no_quirks = [["\\bnope\\b","no"],["\\bnope\\b","absolutely no"],["\\bnope\\b","no"],["\\bnope\\b","no"],["\\bnope\\b","nope"],["\\bnope\\b","no way"]];

//abandoned these early on because was annoyed at having to figure out how escapes worked. picking back up now.
var smiley_quirks = [[":\\)", ":)"],[":\\)", ":0)"],[":\\)", ":]"],[":\\)", ":B"],[":\\)", ">: ]"],[":\\)", ":o)"],[":\\)", "^_^"],[":\\)", ";)"],[":\\)", "~_^"],[":\\)", "0u0"],[":\\)", "uwu"],[":\\)", "¯\_(ツ)_/¯ "],[":\\)", ":-)"],[":\\)", ":3"],[":\\)", "XD"],[":\\)", "8D"],[":\\)", ":>"],[":\\)", "=]"],[":\\)", "=}"],[":\\)", "=)"],[":\\)", "o->-<"]];



//get something that matches your class/aspect title on your own.
var maid_handles = ["meandering","motley","musing","mischievous","macabre", "maiden", "morose"];
var page_handles = ["passionate","patient","peaceful","perfect","perceptive", "practical", "pathetic"];
var mage_handles = ["magnificent","managerial","major","majestic","mannerly", "malignant", "morbid"];
var knight_handles = ["keen","knightly","kooky","kindred", "kaos",];
var rogue_handles = ["rouge","radical","retrobate","roguish","retroactive", "robins", "red"];
var sylph_handles = ["surly","sour","sweet","stylish","soaring", "serene", "salacious"];
var thief_handles = ["talented","terrible","talkative","tenacious","tried", "torrented"];
var heir_handles = ["honorable","humble","hot","horrific","hardened", "havocs"];
var bard_handles = ["benign","blissful","boisterous","bonkers","broken", "bizarre", "barking"];
var prince_handles = ["precocious","priceless","proficient","prominent","proper", "perfect", "pantheon"];
var witch_handles = ["wondering","wonderful","wacky","withering","worldly","weighty"];
var seer_handles = ["sightly","sanctimonious","sarcastic","sassy","scintillating","synergistic","savant"];

var music_handles1 = ["musical","pianist","melodious","keyboard","rhythmic","singing","tuneful","harmonious","beating","pitch","waltzing","synthesized","piano","serenading","mozarts","swelling","staccato","pianissimo","monotone","polytempo"];
var culture_handles1 = ["monochrome","poetic","majestic","keen","realistic","serious","theatrical","haute","beautiful","priceless","watercolor","sensational","highbrow","refined","precise","melodramatic"];
var writing_handles1 = ["wordy","scribbling","meandering","pageturning","mysterious","knowledgeable","reporting","scribing","tricky","hardcover","bookish","page","writing","scribbler","wordsmiths"];
var pop_culture_handles1 = ["worthy","mega","player","mighty","knightly","roguish","super","turbo","titanic","heroic","bitchin","power","wonder","wonderful", "sensational","thors","bat"];
var technology_handles1 = ["kludge", "pixel","machinist","programming","mechanical","kilo","robotic","silicon","techno","hardware","battery","python","windows","serial","statistical"];
var social_handles1 = ["master","playful","matchmaking","kind","regular","social","trusting","honest","benign","precious","wondering","sarcastic", "talkative","petulant"];
var romantic_handles1 = ["wishful","matchmaking","passionate","kinky","romantic","serendipitous","true","hearts","blushing","precious","warm","serenading","mesmerizing","mirrored","pairing","perverse"];
var academic_handles1 = ["researching","machiavellian","princeton","pedagogical","theoretical","hypothetical","meandering","scholarly","biological","pants","spectacled","scientist","scholastic","scientific","particular","measured"];
var comedy_handles1 = ["mischievous","knavish","mercurial","beagle","sarcastic","satirical","mime","pantomime","practicing","pranking","wokka","kooky","haha","humor","talkative","harlequins","hoho"];
var domestic_handles1 = ["motherly","patient","missing","knitting","rising","stylish","trendy","homey","baking","recipe","meddling","mature"];
var athletic_handles1 = ["kinetic", "muscley", "preening", "mighty", "running", "sporty", "tennis", "hard", "ball", "winning", "trophy", "sports", "physical", "sturdy", "strapping", "hardy", "brawny", "burly", "robust", "strong", "muscular", "phenomenal"];
var terrible_handles1 = ["tyranical","heretical","murderous","persnickety","mundane","killer","rough","sneering","hateful","bastard","pungent","wasted","snooty","wicked","perverted","master","hellbound"];
var fantasy_handles1 = ["musing","pacific","minotaurs","kappas","restful","serene","titans","hazy","best","peaceful","witchs","sylphic","sylvan","shivan","hellkite","malachite"];
var justice_handles1 = ["karmic","mysterious","police","mind","keen","retribution","saving","tracking","hardboiled","broken","perceptive","watching","searching"];


var space_handles = ["Salamander","Salientia","Spacer","Scientist","Synergy","Spaceman"];
var time_handles = ["Teetotaler","Traveler","Tailor","Taster","Target", "Teacher", "Therapist","Testicle"];
var breath_handles = ["Biologist","Backpacker","Babysitter","Baker","Balooner","Braid"];
var doom_handles = ["Dancer","Dean","Decorator","Deliverer","Director","Delegate"];
var blood_handles = ["Buyer","Butler","Butcher","Barber","Bowler","Belligerent"];
var heart_handles = ["Heart","Hacker","Harbinger","Handler","Helper", "Historian", "Hobbyist"];
var mind_handles = ["Machine","Magician","Magistrate","Mechanic","Mediator", "Messenger"];
var light_handles = ["Laborer","Launderer","Layabout","Legend","Lawyer", "Lifeguard"];
var void_handles = ["Vagrant","Vegetarian","Veterinarian","Vigilante","Virtuoso"];
var rage_handles = ["Raconteur","Reveler","Reader","Reporter","Racketeer"];
var hope_handles = ["Honcho","Humorist","Horse","Haberdasher","Hooligan"];
var life_handles = ["Leader","Lecturer","Liason","Loyalist","Lyricist"];

var music_handles2 = ["Siren","Singer","Tenor","Trumpeter","Baritone","Dancer","Ballerina","Harpsicordist","Musician","Lutist","Violist","Rapper","Harpist","Lyricist","Virtuoso","Bass"];
var culture_handles2 = ["Dramatist","Repository","Museum","Librarian","Hegemony","Hierarchy","Davinci","Renaissance","Viniculture","Treaty","Balmoral","Beauty","Business"];
var writing_handles2 = ["Shakespeare","Host","Bard","Drifter","Reader","Booker","Missive","Labret","Lacuna","Varvel","Hagiomaniac","Traveler","Thesis"];
var pop_culture_handles2 = ["Superhero","Supervillain","Hero","Villain","Liason","Director","Repeat","Blockbuster","Movie","Mission","Legend","Buddy","Spy","Bystander","Talent"];
var technology_handles2 = ["Roboticist","Hacker","Haxor","Technologist","Robot","Machine","Machinist","Droid","Binary","Breaker","Vaporware","Lag","Laptop","Spaceman","Runner", "L33T","Data"];
var social_handles2 = ["Socialist","Defender","Mentor","Leader","Veterinarian","Therapist","Buddy","Healer","Helper","Mender","Lender","Dog","Bishop","Rally"];
var romantic_handles2 = ["Romantic","Dreamer","Beau","Hearthrob","Virtue","Beauty","Rainbow","Heart","Magnet","Miracle","Serendipity","Team"];
var academic_handles2 = ["Student","Scholar","Researcher","Scientist","Trainee","Biologist","Minerologist","Lecturer","Herbalist","Dean","Director","Honcho","Minder","Verbalist","Botanist"];
var comedy_handles2 = ["Laugher","Humorist","Trickster","Sellout","Dummy","Silly","Bum","Huckster","Raconteur","Mime","Leaper","Vaudevillian","Baboon","Boor"];
var domestic_handles2 = ["Baker","Darner","Mender","Mentor","Launderer","Vegetarian","Tailor","Teacher","Hestia","Helper","Decorator","Sewer"];
var athletic_handles2 = ["Swimmer","Trainer","Baller","Handler","Runner","Leaper","Racer","Vaulter","Major","Tracker","Heavy","Brawn","Darter","Brawler"];
var terrible_handles2 = ["Butcher","Blasphemer","Barbarian","Tyrant","Superior","Bastard","Dastard","Despot","Bitch","Horror","Victim","Hellhound","Devil","Demon","Shark","Lupin", "Mindflayer","Mummy","Hoarder","Demigod"];
var fantasy_handles2 = ["Believer","Dragon","Magician","Sandman","Shinigami","Tengu","Harpy","Dwarf","Vampire","Lamia","Roc","Mermaid","Siren","Manticore","Banshee","Basilisk","Boggart"];
var justice_handles2 = ["Detective","Defender","Laywer","Loyalist","Liason","Vigilante","Tracker","Moralist","Retribution","Watchman","Searcher","Perception","Rebel"];


//thanks manicInsomniac and ersatzGlottologist and recursiveSlacker!!!
var postdenizen_maid_quests = ["using their powers to help clean up the debris left from their Denizen actions. Who knew the term maid would be so literal"]
	..add("watching over the consorts as they begin to rebuild")
	..add("following their consorts to ever larger pieces of debris")
	..add("empowering an army of consorts to clean out the last of the debris from their Denizen");

var postdenizen_page_quests = ["learning to control their newfound prowess, accidentally wiping out a consort village or two"]
	..add("getting all mopey about their new powers, because apparently actually being competent is too much for them")
	..add("finishing the ‘legendary’ tests of valor with a never before seen aplomb")
	..add("accepting the role Sburb has placed upon them. They are themselves, and that is all that needs be said on the matter");

var postdenizen_mage_quests = ["finding yet another series of convoluted puzzles, buried deep in their land. These puzzles pour poison into the land, and will continue to do so until solved"]
	..add("realizing the voices are gone. Not just quiet, but… gone. Without them, they can finally get down to work on their land puzzles")
	..add("solving the more of the puzzles of their land. Not that that's the end of the horseshit, but hey! Less horseshit always helps")
	..add("getting sick to death of puzzles and just utterly annihilating one with their game powers");

var postdenizen_knight_quests = ["setting up a series of knight-beacons so the consorts can call them whenever they are needed"]
	..add("spending way too much time hustling from village to village, saving the consorts from the denizens last few minions")
	..add("breaking a siege on a consort village, saving its population and slaughtering thousands of underlings")
	..add("finishing the ‘legendary’ tests of valor dispensed by an elder consort");

var postdenizen_rogue_quests = ["scouring the land for targets, and then freaking out when they realize there's no bad guys left to steal from"]
	..add("stealing from enemies on other players planets, acquiring enough boonbucks to lift every consort on the planet out of poverty")
	..add("doing a little dance on their pile soon-to-be distributed wealth")
	..add("literally stealing another player's planet. They put it back, but still. A planet. Wow")
	..add("loaning money to needy consorts, then surprising them by waiving every last cent of debt they owe");


var postdenizen_sylph_quests = ["beginning to heal the vast psychological damage their consorts have endured from the denizen’s ravages"]
	..add("setting up counseling booths around their land and staffing them with well trained consort professionals")
	..add("bugging and fussing and meddling with the consorts, but now using their NEW FOUND POWERS")
	..add("realizing that maybe their bugging and fussing and meddling isn’t always the best way to deal with things");

var postdenizen_thief_quests = ["literally stealing another player’s planet. Well, the deed to another player's planet, but still. A planet. Wow"]
	..add("stealing every last piece of grist in every last dungeon. Hell fucking yes")
	..add("crashing the consort economy when they spend their hellaciously devious wealth")
	..add("doing a dance on their pile of ill earned goods and wealth");


var postdenizen_heir_quests = ["recruiting denizen villages, spreading a modest nation under their (Democratic!) control"]
	..add("assuming control of yet more denizen villages. Turns out a mind bogglingly large number of consorts have the Heir named in their will")
	..add("chillaxing with their aspect and while talking to it as if it were a real person.")
	..add("wiping a dungeon off the map with their awe inspiring powers");

var postdenizen_bard_quests = ["musing on the nature of death as they wander from desolate consort graveyard to desolate consort graveyard"]
	..add("staring vacantly into the middle distance as every challenge that rises before them falls away before it even has a chance to do anything")
	..add("putting on a performance for a huge crowd of awestruck consorts and underlings")
	..add("playing pranks and generally messing around with the most powerful enemies left in the game");

var postdenizen_prince_quests = ["thinking on endings. The end of their planet. The end of their denizen problems. The end of that very, very stupid imp that just tried to jump them"]
	..add("defeating every single mini boss, including a few on other players planets")
	..add("burning down libraries of horror terror grimoires, shedding a few tears for the valuable knowledge lost along side the accursed texts")
	..add("hunting down and killing the last of a particularly annoying underling class");

var postdenizen_seer_quests = ["casting their sight around the land to find the causes of their land’s devastation"]
	..add("taking a consort under their wing and teaching it the craft of magic")
	..add("predicting hundreds of thousands of variant future possibilities, only to realize that the future is too chaotic to exactly systemize")
	..add("alchemizing more and more complex seer aids, such as crystal balls or space-specs");

var postdenizen_witch_quests = ["alchemizing a mind crushingly huge number of computers in various forms"]
	..add("whizzing around their land like it's fucking christmas")
	..add("defeating a completely out of nowhere mini boss")
	..add("wondering if their sprite prototyping choice was the right one after all");

var postdenizen_generic_quests = ["cleaning up after their Denizen in a class approrpiate fashion","absolutly not goofing off instead of cleaing up after their Denizen","vaguely sweeping up rubble"];
var postdenizen_waste_quests = ["figuring out the least-disruptive way to help the local Consorts recover from the Denizen's rule","being a useless piece of shit and not joining cleanup efforts.","accidentally causing MORE destruction in an attempt to help clean up after their epic as fuck fight agains their Denizen"];
var postdenizen_scout_quests = ["finding Consorts that still need help even after the Denizen has been defeated", "scouting out areas that have opened up following the Denizen's defeat","looking for rare treasures that are no longer being guarded by the Denizen"];
var postdenizen_scribe_quests = ["documenting the various Consorts lost to the Denizen.","writing up a recovery plan for the Local Consorts","figuring out the best way to explain how to recover from the ravages of Denizen"];
var postdenizen_sage_quests = ["learning everything there is learn about the Denizen, now that it is safely defeated","learning what Consort civilization was like before the Denizen, to better help them return to 'normal'","demonstrating to the local Consorts the best way to move on from the tyranny of the Denizen"];




var postdenizen_space_quests = ["stoking the forge and preparing to create a new universe"]
	..add("cloning ribbiting assholes till you’re up to your eyeballs in frogs")
	..add("cleaning up volcanic debris from the Forge. Man that magma is hot")
	..add("alchemizing geothermal power infrastructure for the consort villagers. The local consorts babble excitedly at indoor lightning ")
	..add("making sure they don't accidentally clone a toad instead of a frog by mistake")
	..add("messing with a variety of frogs that were previously paradox cloned")
	..add("paradox cloning a variety of frogs, after making a serious note to mess with them later")
	..add("combining paradox slime from multiple frogs together to make paradox offspring")
	..add("listening to the ridiculously similar croaks of cloned frogs to figure out where their flaws are");

var postdenizen_time_quests = ["securing the alpha timeline and keeping the corpse pile from getting any taller"]
	..add("high fiving themself an hour from now for the amazing job they're going to have done/do with the Hephaestus situation. Time is the best aspect")
	..add("restoring the consort’s destroyed villages through time shenanigans. The consorts boggle at their newly restored houses")
	..add("building awesome things way in the past for themselves to find later");



var postdenizen_breath_quests = ["riding the wind through the pneumatic system, delivering packages to the local consorts"]
	..add("doing the windy thing to clean up all of the pneumatic system’s leavings. Wow, that’s a lot of junk")
	..add("soothing the local consorts with a cool summer breeze")
	..add("whipping up a flurry of wind, the debris of Denizen rampage are blown far into the Outer Rim");

var postdenizen_doom_quests = ["assuring the local consorts that with Denizen's defeat, the prophecy has been avoided"]
	..add("establishing an increasingly esoteric rubric of potential post-Denizen problems and relating them in detail to the consorts. Doom players sure are cheery")
	..add("inferring the new possibilities of defeat should the local consorts lack vigilance")
	..add("finding a worryingly complete list of their own future deaths, both potential and definite");

var postdenizen_blood_quests = ["undoing the last remnants of Denizen-inflicted emotional damage in the consorts"]
	..add("putting together a crack team of emotionally bonded consorts to help the recovery of their land")
	..add("weeping tears of joy as their consorts manage to help each other instead of running to a player anytime the smallest thing goes wrong")
	..add("preaching a resounding message of ‘don't be a total dick all the time’ to a clamoring crowd of consorts");

var postdenizen_heart_quests = ["rescuing a copy of themselves from extreme peril"]
	..add("creating clones of themselves to complete a variety of bullshit puzzles and fights")
	..add("swapping around the souls of underlings, causing mass mayhem")
	..add("removing the urge to kill from the identity of underlings, rendering them harmless pacifists");

var postdenizen_mind_quests = ["forcing mini bosses to choose between two equally horrible options "]
	..add("binding the minds of ogres and using them as battle mounts")
	..add("manipulating underlings into madness and infighting")
	..add("navigating the countless possible outcomes of whatever bullhit colour the local consorts want to repaint this temple. Great use of their time!");

var postdenizen_light_quests = ["distracting underlings by with over the top displays of their game powers"]
	..add("teaching the local consorts how to count cards without eating them.")
	..add("educating themselves on the consequences of betting against the house. As it happens, there are no consequences. ")
	..add("collecting the complete history and mythos of their land into an easy to navigate 1,000 volume encyclopedia.");

var postdenizen_void_quests = ["Wait, yes! The Void player is… nope. They’re gone."]
	..add("doing something about their land, but it’s difficult to make out.")
	..add("fixing temples from the ravages of… something? It’s a best guess. Those temples were totally ravaged a minute ago though.")
	..add("somehow just doing normal quests with no void interference whatsoever. Huh");

var postdenizen_rage_quests = ["ripping underlings apart with loud, violent screams"]
	..add("throwing the mother of all temper tantrums")
	..add("fighting through millions of enemies in search of the fabled ‘chill-pill’")
	..add("ripping a mini boss a literal new one. Ouch");

var postdenizen_hope_quests = ["leading a huge army of zealous consorts into battle"]
	..add("learning ancient chants and forgotten mythos of their lands strange almost-religion")
	..add("willing enemies out of existence with but a thought")
	..add("winning an argument with gravity");

var postdenizen_life_quests = ["using the Denizen's lair to breed thousands of pollinating insects"]
	..add("breeding a strain of plant that spreads across the planet in seconds")
	..add("terraforming their land to be more suited to their desires")
	..add("resurrecting an ancient civilization of consorts, complete with buildings and culture");






var human_hair_colors = ["#68410a","#fffffe", "#000000","#000000","#000000","#f3f28d","#cf6338","#feffd7","#fff3bd","#724107","#382207","#ff5a00","#3f1904","#ffd46d","#473200","#91683c"];

String getRandomColor() {
    String letters = '0123456789ABCDEF';
    String color = '#';
    for (num i = 0; i < 6; i++ ) {
        color += letters[(random() * 16).floor()];
    }
    return color;
}



/*function uniqueArrayBecauesIEIsAWhinyBitch(arr) {
    List<dynamic> a = [];
    for (var i=0, l=arr.length; i<l; i++)
        if (a.indexOf(arr[i]) === -1 && arr[i] !== '')
            a.add(arr[i]);
    return a;
}*/

String getRandomGreyColor() {
    String letters = '0123456789ABCDEF';
    String color = '#';
	String tmp = "";
    for (num i = 0; i < 2; i++ ) {
        tmp += letters[(random() * 16).floor()];
    }
    return color+tmp+tmp+tmp; //grey is just 3 of the same 2 byte hex repeated.
}


/*void helloWorld(){
	$.ajax({
	  url: "hello_world.txt",
	  success:((data){
		  print(data);
	  }),
	  dataType: "text"
	});

}*/

//IE doesn't support "starts with"
/*if (!String.prototype.startsWith) {
  String.prototype.startsWith = (searchString, position) {
    position = position || 0;
    return this.indexOf(searchString, position) === position;
  };
}*/
