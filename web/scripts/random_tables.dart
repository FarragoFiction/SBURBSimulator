import "dart:html";
import "dart:math" as Math;

import "SBURBSim.dart";
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
    static Map<int,List<String>> chars= <int,List<String>>{
        0 : <String>[ /* up */
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
    1 : <String>[ /* down */
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
    2 : <String>[ /* mid */
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
	return [retArray.sublist(0, retArray.length-1).join(', '), retArray.last].join(retArray.length < 2 ? '' : ' and ');
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
				ret.add(player.class_name.levels[((i-6)/4).round()]); //don't listen to even further pastJR up there, ther eis no logic here.
			}else if(i%4 == 2  && i>4){
				ret.add(player.aspect.levels[((i-5)/4).round()]); //5 because fuck you futureJR, that's why.
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
String getRandomChatHandle(Random rand, SBURBClass class_name, Aspect aspect, String interest1, String interest2){
	//print("Class: " + class_name + "aspect: " + aspect);
	String first = "";
	double r = rand.nextDouble();
	if(r>0.3){
		first = getInterestHandle1(rand, class_name, interest1);
	}else if(r > .6){
		first = getInterestHandle1(rand, class_name, interest2);
	}else{
		first = rand.pickFrom(class_name.handles);
	}
	if(first == null || first == ""){
		first = rand.pickFrom(class_name.handles);  //might have forgot to have a interest handle of the right letter.
	}
	String second = "";
	if(r>.3){
		second = getInterestHandle2(rand, aspect, interest1);
	}else if(r > .6){
		second = getInterestHandle2(rand, aspect, interest2);
	}else{
		second = rand.pickFrom(aspect.handles);
	}
	if(second == null || second == ""){
		second = rand.pickFrom(aspect.handles);
	}
	if(first == null) first = "mystery";
	if(second == null) second = "Mystery";
	return "$first$second";
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




bool playerLikesMusic(Player player){
		if(music_interests.contains(player.interest1) || music_interests.contains(player.interest2) ){
			return true;
		}else{
			return false;
		}
}



bool playerLikesCulture(Player player){
		if(culture_interests.contains(player.interest1) || culture_interests.contains(player.interest2) ){
			return true;
		}else{
			return false;
		}
}



bool playerLikesWriting(Player player){
		if(writing_interests.contains(player.interest1) || writing_interests.contains(player.interest2) ){
			return true;
		}else{
			return false;
		}
}



bool playerLikesPopculture(Player player){
		if(pop_culture_interests.contains(player.interest1) || pop_culture_interests.contains(player.interest2) ){
			return true;
		}else{
			return false;
		}
}




bool playerLikesTechnology(Player player){
		if(technology_interests.contains(player.interest1) || technology_interests.contains(player.interest2) ){
			return true;
		}else{
			return false;
		}
}



bool playerLikesSocial(Player player){
		if(social_interests.contains(player.interest1) || social_interests.contains(player.interest2) ){
			return true;
		}else{
			return false;
		}
}



bool playerLikesRomantic(Player player){
		if(romantic_interests.contains(player.interest1) || romantic_interests.contains(player.interest2) ){
			return true;
		}else{
			return false;
		}
}



bool playerLikesAcademic(Player player){
		if(academic_interests.contains(player.interest1) || academic_interests.contains(player.interest2) ){
			return true;
		}else{
			return false;
		}
}



bool playerLikesComedy(Player player){
		if(comedy_interests.contains(player.interest1) || comedy_interests.contains(player.interest2) ){
			return true;
		}else{
			return false;
		}
}



bool playerLikesDomestic(Player player){
		if(domestic_interests.contains(player.interest1) || domestic_interests.contains(player.interest2) ){
			return true;
		}else{
			return false;
		}
}



bool playerLikesAthletic(Player player){
		if(athletic_interests.contains(player.interest1) || athletic_interests.contains(player.interest2) ){
			return true;
		}else{
			return false;
		}
}



bool playerLikesTerrible(Player player){
		if(terrible_interests.contains(player.interest1) || terrible_interests.contains(player.interest2) ){
			return true;
		}else{
			return false;
		}
}



bool playerLikesFantasy(Player player){
		if(fantasy_interests.contains(player.interest1) || fantasy_interests.contains(player.interest2) ){
			return true;
		}else{
			return false;
		}
}



bool playerLikesJustice(Player player){
		if(justice_interests.contains(player.interest1) || justice_interests.contains(player.interest2) ){
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



dynamic getInterestHandle1(Random rand, SBURBClass class_name, String interest){
	if(music_interests.contains(interest)){
			return getRandomElementFromArrayThatStartsWith(rand, music_handles1, class_name.name.toLowerCase()[0]);
	}else if (culture_interests.contains(interest)){
			return getRandomElementFromArrayThatStartsWith(rand, culture_handles1, class_name.name.toLowerCase()[0]);
	}else if (writing_interests.contains(interest)){
			return getRandomElementFromArrayThatStartsWith(rand, writing_handles1, class_name.name.toLowerCase()[0]);
	}else if (pop_culture_interests.contains(interest)){
			return getRandomElementFromArrayThatStartsWith(rand, pop_culture_handles1, class_name.name.toLowerCase()[0]);
	}else if (technology_interests.contains(interest)){
			return getRandomElementFromArrayThatStartsWith(rand, technology_handles2, class_name.name.toLowerCase()[0]);
	}else if (social_interests.contains(interest)){
			return getRandomElementFromArrayThatStartsWith(rand, social_handles1, class_name.name.toLowerCase()[0]);
	}else if (romantic_interests.contains(interest)){
			return getRandomElementFromArrayThatStartsWith(rand, romantic_handles1, class_name.name.toLowerCase()[0]);
	}else if (academic_interests.contains(interest)){
			return getRandomElementFromArrayThatStartsWith(rand, academic_handles1, class_name.name.toLowerCase()[0]);
	}else if (comedy_interests.contains(interest)){
			return getRandomElementFromArrayThatStartsWith(rand, comedy_handles1, class_name.name.toLowerCase()[0]);
	}else if (domestic_interests.contains(interest)){
			return getRandomElementFromArrayThatStartsWith(rand, domestic_handles1, class_name.name.toLowerCase()[0]);
	}else if (athletic_interests.contains(interest)){
			return getRandomElementFromArrayThatStartsWith(rand, athletic_handles1, class_name.name.toLowerCase()[0]);
	}else if (terrible_interests.contains(interest)){
			return getRandomElementFromArrayThatStartsWith(rand, terrible_handles1, class_name.name.toLowerCase()[0]);
	}else if (fantasy_interests.contains(interest)){
			return getRandomElementFromArrayThatStartsWith(rand, fantasy_handles1, class_name.name.toLowerCase()[0]);
	}else if (justice_interests.contains(interest)){
			return getRandomElementFromArrayThatStartsWith(rand, justice_handles1, class_name.name.toLowerCase()[0]);
	}
	print("I didn't return anything!? What was my interest: " + interest);
	return null;
}



dynamic getInterestHandle2(Random rand, Aspect aspect, String interest){
	if(music_interests.contains(interest)){
		return getRandomElementFromArrayThatStartsWith(rand, music_handles2, aspect.name.toUpperCase()[0]);
	}else if (culture_interests.contains(interest)){
		return getRandomElementFromArrayThatStartsWith(rand, culture_handles2, aspect.name.toUpperCase()[0]);
	}else if (writing_interests.contains(interest)){
		return getRandomElementFromArrayThatStartsWith(rand, writing_handles2, aspect.name.toUpperCase()[0]);
	}else if (pop_culture_interests.contains(interest)){
		return getRandomElementFromArrayThatStartsWith(rand, pop_culture_handles2, aspect.name.toUpperCase()[0]);
	}else if (technology_interests.contains(interest)){
		return getRandomElementFromArrayThatStartsWith(rand, technology_handles2, aspect.name.toUpperCase()[0]);
	}else if (social_interests.contains(interest)){
		return getRandomElementFromArrayThatStartsWith(rand, social_handles2, aspect.name.toUpperCase()[0]);
	}else if (romantic_interests.contains(interest)){
		return getRandomElementFromArrayThatStartsWith(rand, romantic_handles2, aspect.name.toUpperCase()[0]);
	}else if (academic_interests.contains(interest)){
		return getRandomElementFromArrayThatStartsWith(rand, academic_handles2, aspect.name.toUpperCase()[0]);
	}else if (comedy_interests.contains(interest)){
		return getRandomElementFromArrayThatStartsWith(rand, comedy_handles2, aspect.name.toUpperCase()[0]);
	}else if (domestic_interests.contains(interest)){
		return getRandomElementFromArrayThatStartsWith(rand, domestic_handles2, aspect.name.toUpperCase()[0]);
	}else if (athletic_interests.contains(interest)){
		return getRandomElementFromArrayThatStartsWith(rand, athletic_handles2, aspect.name.toUpperCase()[0]);
	}else if (terrible_interests.contains(interest)){
		return getRandomElementFromArrayThatStartsWith(rand, terrible_handles2, aspect.name.toUpperCase()[0]);
	}else if (fantasy_interests.contains(interest)){
		return getRandomElementFromArrayThatStartsWith(rand, fantasy_handles2, aspect.name.toUpperCase()[0]);
	}else if (justice_interests.contains(interest)){
		return getRandomElementFromArrayThatStartsWith(rand, justice_handles2, aspect.name.toUpperCase()[0]);
	}
	return null;
}

String getBlandHandle2(Random rand, Aspect aspect){
	return rand.pickFrom(aspect.handles);
}


String getLevelFromFree(Random rand){
	return rand.pickFrom(free_levels);
}



String getLevelFromInterests(int i, String interest){
	if(music_interests.contains(interest)){
			return music_levels[i];
	}else if (culture_interests.contains(interest)){
			return culture_levels[i];
	}else if (writing_interests.contains(interest)){
			return writing_levels[i];
	}else if (pop_culture_interests.contains(interest)){
			return pop_culture_levels[i];
	}else if (technology_interests.contains(interest)){
			return technology_levels[i];
	}else if (social_interests.contains(interest)){
			return social_levels[i];
	}else if (romantic_interests.contains(interest)){
			return romantic_levels[i];
	}else if (academic_interests.contains(interest)){
			return academic_levels[i];
	}else if (comedy_interests.contains(interest)){
			return comedy_levels[i];
	}else if (domestic_interests.contains(interest)){
			return domestic_levels[i];
	}else if (athletic_interests.contains(interest)){
			return athletic_levels[i];
	}else if (terrible_interests.contains(interest)){
			return terrible_levels[i];
	}else if (fantasy_interests.contains(interest)){
			return fantasy_levels[i];
	}else if (justice_interests.contains(interest)){
			return justice_levels[i];
	}
	return null;
}


dynamic getLevelFromAspect(num i, Aspect aspect){
	//print("looking for level from aspect, i is " + i.toString());
		//print("found: " + first_arr[i]);
	return aspect.levels[i];
}

String truncateString(String str, int length) {
	return str.length > length ? "${str.substring(0, length > 3 ? length - 3 : length)}..." : str;
}

String sanitizeString(String string){
	return truncateString(string.replaceAll(new RegExp(r"""<(,?:.|\n)*?>""", multiLine:true), '').replaceAll(new RegExp(",", multiLine:true),''), 144); //good enough for twitter.
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
	List<String> words = <String>["first","second","third","fourth","fifth","sixth","seventh","eighth","ninth","tenth","eleventh","twelfth"];
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



dynamic classNameToInt(SBURBClass class_name){
	return class_name.id;
}



SBURBClass intToClassName(int id){
	return SBURBClassManager.findClassWithID(id);
}



int aspectToInt(Aspect aspect){
    aspect.id;
}



Aspect intToAspect(int id){
	Aspects.get(id);
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



String intToHexColor(int num){
	//print("int is " + num);
	var tmp = num.toRadixString(16);
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





List<String> moons = <String>["Prospit", "Derse"];


List<Aspect> required_aspects = <Aspect>[Aspects.SPACE, Aspects.TIME];
List<String> all_aspects = <String>["Space", "Time","Breath","Doom","Blood","Heart","Mind","Light","Void","Rage","Hope","Life"];
List<String> nonrequired_aspects = <String>["Breath","Doom","Blood","Heart","Mind","Light","Void","Rage","Hope","Life"];
List<String> available_aspects = <String>["Breath","Doom","Blood","Heart","Mind","Light","Void","Rage","Hope","Life"];

//TODO eventually implent null land titles, like Mounds and Xenon.
List<String> space_land_titles = <String>["Frogs"];
List<String> time_land_titles = <String>["Quartz", "Clockwork", "Gears", "Melody","Cesium", "Clocks", "Ticking", "Beats", "Mixtapes","Songs", "Music", "Vuvuzelas", "Drums", "Pendulums"];
List<String> breath_land_titles = <String>["Wind","Breeze","Zephyr","Gales","Storms","Planes","Twisters", "Hurricanes","Gusts", "Windmills", "Pipes", "Whistles"];
List<String> doom_land_titles = <String>["Fire", "Death", "Prophecy", "Blight", "Rules", "Prophets", "Poison", "Funerals", "Graveyards", "Ash", "Disaster", "Fate", "Destiny", "Bones"];
List<String> blood_land_titles = <String>["Pulse", "Bonds", "Clots", "Bloodlines", "Ichor", "Veins", "Chambers", "Arteries", "Unions"];
List<String> heart_land_titles = <String>["Little Cubes","Hats","Dolls","Selfies","Mirrors", "Spirits", "Souls", "Jazz", "Shards", "Splinters"];
List<String> mind_land_titles = <String>["Thought", "Rationality", "Decisions","Consequences", "Choices", "Paths", "Trails", "Trials"];
List<String> light_land_titles = <String>["Treasure", "Light","Knowledge","Radiance", "Gambling", "Casinos", "Fortune", "Sun", "Glow", "Chance"];
List<String> void_land_titles = <String>["Silence", "Nothing","Void","Emptiness", "Tears", "Dust", "Night", "[REDACTED]", "???", "Blindness"];
List<String> rage_land_titles = <String>["Mirth","Whimsy","Madness","Impossibility", "Chaos", "Hate", "Violence", "Joy", "Murder", "Noise", "Screams","Denial"];
List<String> hope_land_titles = <String>["Angels","Hope","Belief","Faith","Determination", "Possibility", "Hymns", "Heroes", "Chapels", "Lies", "Bullshit"];
List<String> life_land_titles = <String>["Dew","Spring","Beginnings","Vitality", "Jungles", "Swamps", "Gardens", "Summer", "Chlorophyll", "Moss", "Rot", "Mold"];


//google is an in joke because apparently google reports that all sessions are crashed and it is beautiful and google is a horrorterror.
List<String> corruptedOtherLandTitles = [Zalgo.generate("Google"), Zalgo.generate("Horrorterrors"),Zalgo.generate("Glitches"),Zalgo.generate("Grimoires"),Zalgo.generate("Fluthlu"),Zalgo.generate("The Zoologically Dubious")];

//typoed special snowlake once insteada snowflake, and now it's a land.
List<String> free_land_titles = <String>["Snowlake", "Heat","Sand","Brains","Haze","Tea","Flow","Maps","Caves","Tents","Wrath","Rays","Glass","Lava","Magma"]
..addAll(<String>["Shade","Frost","Rain","Fog","Trees","Flowers","Books","Technology","Ice","Water", "Waterfalls","Rocks"])
..addAll(<String>["Forests","Grass","Tundra","Thunder","Winter","Peace","Food","Shoes","Weasels","Deserts","Dessert","Lightning"])
..addAll(<String>["Suburbs","Cities","Neighborhoods","Isolation","Schools","Farms","Annoyance","Hunger","Cake","Tricks","Ruins","Temples", "Towers"])
..addAll(<String>["Nails","Smoke","Curses","Flood","Ooze","Mud","Weeds","Vines","Courts","Clay","Halls","Choirs","Mushrooms", "Locks"])
..addAll(<String>["Slums","Balloons","Rumbling","Warfare","Cliffs","Needles","Mountains","Shadows","Circuitry","Fences","Webs"])
..addAll(<String>["Bone","Arenas","Wonder","Fluff","Cotton","Domes","Gold","Silver","Bronze","Ruby","Ribbon"])
..addAll(<String>["Hair","Teeth","Tendrils","Mouths","Paint","Pain","Wood","Colors","Echoes","Fossils","Roses","Tulips","Mummies", "Zombies", "Corpses"])
..addAll(<String>["Mysteries","Splendor","Luxury","Cash","Coins","Crystals","Gemstones","Cards","Tarot","Wagons","Puzzles","Mayhem","Redundancy","Redundancy"])
..addAll(<String>["Obsolescence","Deceit","Ruse","Distraction","Libraries","Blocks","Video Games","Vermin","Butchers","Meat","Clouds", "Horses"])

..addAll(corruptedOtherLandTitles);


List<String> free_levels = <String>["NIPPER CADET","PESKY URCHIN","BRAVESPROUT","JUVESQUIRT","RUMPUS BUSTER","CHAMP-FRY","ANKLEBITER","CALLOUSED TENDERFOOT","RASCALSPRAT","GRITTY MIDGET","BRITCHES RIPPER","ALIEN URCHIN", "NESTING NEWB"];
//only need two for each. since each player has two interests, combines to 4
List<String> music_levels = <String>["SINGING SCURRYWORT","MUSICAL MOPPET"];
List<String> culture_levels = <String>["APPRENTICE ARTIST","CULTURE BUCKAROO"];
List<String> writing_levels = <String>["SHAKY SHAKESPEARE","QUILL RUINER"];
List<String> pop_culture_levels = <String>["TRIVIA SMARTYPANTS","NIGHTLY NABBER"];
List<String> technology_levels = <String>["HURRYWORTH HACKER","CLANKER CURMUDGEON"];
List<String> social_levels = <String>["FRIEND-TO-ALL","FRIEND COLLECTOR"];
List<String> romantic_levels = <String>["QUESTING CUPID","ROMANCE EXPERT"];
List<String> academic_levels = <String>["NERDY NOODLER","SCAMPERING SCIENTIST"];
List<String> comedy_levels = <String>["PRATFALL PRIEST","BEAGLE PUSS DARTABOUT"];
List<String> domestic_levels = <String>["BATTERBRAT","GRITTY GUARDIAN"];
List<String> athletic_levels = <String>["MUSCLES HOARDER","BODY BOOSTER"];
List<String> terrible_levels = <String>["ENEMY #1","JERKWAD JOURNEYER"];
List<String> fantasy_levels = <String>["FAKEY FAKE LOVER","FANTASTIC DREAMER"];
List<String> justice_levels = <String>["JUSTICE JUICER","BALANCE RUMBLER"];

List<String> level_bg_colors = <String>["#8ff74a","#ba1212","#ffffee","#f0ff00","#9c00ff","#2b6ade","#003614","#f8e69f","#0000ff","#eaeaea","#ff9600","#581212","#ffa6ac","#1f7636","#ffe1fc","#fcff00"];
List<String> level_font_colors = <String>["#264d0c","#ff00d2","#ff0000","#626800","#da92e0","#022e41","#aaffa6","#000052","#6dffdb","#e5d200","#00911b","#ff0000","#5e005f","#fbff8d","#000000","#"];

//if bike quests are too common, lock them to real selves only, no dream selves.
List<String> bike_quests = <String>["performing the SWEETEST bike stunts in all of SBURB", "doing bike stunts so sick they are illegal by Dersite standards", "doing bike stunts with air so unreal time just stops and everybody wishes to be them", "performing an endless grind on prospit's moon chain"]
	..add("getting air so unreal that they jump from one planet to another on their sick nasty bike")
	..add("writing dope as fuck Bike Stunt FAQs to keep their sanity")
	..add("singing a song, you know, from that shitty kids cartoon? 'wake up in the morning there's a brand new day ahead the sun is bright and the clouds smile down and all your friends are dead '");

/*
this.goodMild = "Friends";
	this.goodBig = "Totally In Love";
	this.badMild = "Rivals";
	this.badBig = "Enemies";
	*/
List<String> goodMildDesc = <String>["a pretty good kid", "nice enough", "merely tolerable", "just friendly"];
List<String> goodBigDesc = <String>["the most fascinating kid left", "distractingly pretty", "really hot"];
List<String> bigMildDesc = <String>["kind of a jerk", "sort of an asshole", "only sort of irritating", "just a little annoying"];
List<String> bigBadDesc = <String>["just the smelliest bag of assholes", "the most infuriating asshole around", "most likely to screw everyone over", "dangerous"];


List<String> democracyTasks = <String>["WV gives talks to a random carapacian boy, demanding he support democracy."," WV gathers followers using techniques learned from reading a book on carapacian etiquette. "]
	..add(" WV demonstrates tactical knowledge to Dersites, convincing them they can win against the King. ")
	..add(" WV gives rousing speeches to Prospitians, emphasizing that they share the same goal. ")
	..add(" WV gives rousing speeches to Dersites, listing every crime the King and Queen have commited against their own people. ")
	..add(" WV debates Dersite beliefs, asking if they REALLY want to die in the Reckoning rather than go live in a new Universe (loathesome though frogs may be). ")
	..add(" WV distributes hastily scrawled parking ticket pamphlets decrying the Royals as 'Total Jerks Bluh Bluh’, much to the ire of the Dersite Parking Authority.")
	..add(" WV arranges a covert series of blinking signals with the help of a firefly. ");


List<String> democracySuperTasks = <String>[" WV flips the fuck out and starts distributing free TAB soda to anyone who joins his army. "]
	..add(" WV grabs a random Player and uses them as a prop during a speech, triggering the frothing devotion of the local consorts. ")
	..add(" WV arranges a military training session with carapacians on both sides of the War, raising their confidence for the upcoming battle. ")
	..add(" WV accidentally steals a colossal Derse war machine. Somehow. ")
	..add(" WV trains other carapacians in the art of forward attacks. They are the best pawn. It is them. ")
	..add(" WV and a random Player go on an alchemy spree, arming the democratic army with all manners of insane weaponry that is off both the hook and also the chain. In fact, they couldn’t manage to alchemize a single flail. Only giant spiky balls. ");


List<String> mayorDistractionTasks = <String>[" WV is distracted eating green objects rather than recruiting for his army. "]
	..add( " WV is distracted planning the civil infrastructure of a city, rather than recruiting for his army.")
	..add(" WV is distracted fantasizing about how great of a mayor he will be. ")
	..add(" WV accidentally tried to recruit carapacians already part of his army. Stupid stupid stupid! ")
	..add(" WV gets distracted freaking out about car safety. ")
	..add(" WV gets distracted freaking out about how evil bad bad bad bad monarchy is. ")
	..add(" WV gets distracted writing a constitution for the new democracy. ");

//rage and void can do these in VoidySTuff, even if it's not a quest. just for funsies. (even the heavy shit. oh look the rage player is being LOL SO RANDOM what with their decapitated head shenanigans.)
List<String> lightQueenQuests = <String>["makes a general nuisance of themselves to the Black Queen.", "spreads disparaging rumours concerning the Black Queen.", "sabotages several official portraits of the Black Queen."]
	..addAll(<String>["sets up various pranks and traps around Derse.","breaks all the lights in the throne room.","vandalizes various Dersite public hotspots. Fuck the Authority Regulators!"])
	..addAll(<String>["switches the hats of all of the Dersite high ranking officials.","steals all the licorice scottie dogs on Derse. ","convinces the Enquiring Carapacian that the Black Queen is actually three Salamanders in a robe. ", "smuggles contraband forbidden by the Black Queen. Like ice cream. And frogs. The Black Queen’s trade edicts don’t really make much sense. "]);


List<String> moderateQueenQuests = <String>["completely ruins the Dersite bureaucracy's filing scheme. Now it will take WEEKS to reorganize everything. ","releases a slew of random Dersite prisoners.","alchemizes a metric shit ton of antiRoyalty propoganda and leaves it lying around in enticing wallet moduses."]
	..addAll(<String>["performs a daring spy mission, gaining valuable intel to use on the Black Queen. ","covers the royal palace with totally illegal frog graffiti. I mean, just look at all those poorly drawn frogs. So. Illegal. ","turns the Queens allies against her, forcing her to spend valuable time quieting their complaints and schemes. "])
	..addAll(<String>["absconds with an official looking stamp from a crucial bureaucratic office, grinding the ceaseless machine of Dersite civics to a halt.","demonstrates their aptitude for immersion in local tradition and shows a royal guard their stabs. ","smuggles contraband forbidden by the Black Queen. Like weapons of revolt and regicide swords."]);


List<String> heavyQueenQuests = <String>["turns one the Black Queen’s most valuable allies against her, distracting her with a minor revolution. ","convinces Dersites to rise up, leaving the head of a famed public official in front of the palace as a rallying point. "]
	..addAll(<String>["performs a daring assassination mission against one of the Black Queen's agents, losing her a valuable ally. ","sabotages basic services on Derse, fomenting doubt in the Queen’s competence among citizens.","destroys a series of Derse laboratories in the veil, severely damaging the Derse war effort. "]);





List<String> tricksterColors = <String>["#FF0000","#00FF00","#0000FF","#FFFF00","#00FFFF","#FF00FF","#efffff","#5ef89c","#5ed6f8","#f85edd","#ffcaf6","#d0ffca","#cafcff","#fffdca","#ffd200","#a7caff","#ff6c00","#fffc00","#f5b4ff","#ffceb1","#ffcaca","#e0efc6","#c5ffed","#c5dcff","#ebdbff","#ffdbec","#ecfff4","#f0ecff","#c0ff00","#f7bfff","#dfffbf"];

List<String> bloodColors = <String>["#A10000","#a25203","#a1a100","#658200","#416600","#078446","#008282","#004182","#0021cb","#631db4","#610061","#99004d"];

List<String> interestCategories = <String>["Comedy","Music","Culture","Writing","Athletic", "Terrible","Justice","Fantasy","Domestic", "PopCulture","Technology","Social","Romance","Academic"];


List<String> music_interests = <String>["Rap","Music","Song Writing","Musicals","Dance", "Singing","Ballet","Playing Guitar","Playing Piano", "Mixtapes","Turntables"];
List<String> culture_interests = <String>["Drawing","Painting","Documentaries","Fan Art" ,"Graffiti","Theater","Fine Art", "Literature","Books", "Movie Making"];
List<String> writing_interests = <String>["Writing", "Fan Fiction","Script Writing","Character Creation","Dungeon Mastering", "Authoring"];
List<String> pop_culture_interests = <String>["Irony","Action Movies", "Superheroes", "Supervillains", "Video Games", "Movies", "Television","Comic Books","TV","Heroes"];
List<String> technology_interests = <String>["Programming", "Hacking","Coding","Robots","Artificial Intelligence", "Engineering","Manufacturing","Cyborgs", "Androids","A.I.","Automation"];
List<String> social_interests = <String>["Psychology","Religion","Animal Training", "Pets","Animals","Online Roleplaying", "Live Action Roleplaying","Tabletop Roleplaying", "Role Playing","Social Media","Charity","Mediating"];
List<String> romantic_interests = <String>["Girls", "Boys","Romance","Shipping","Relationships", "Love", "Romantic Comedies","Fate","Dating"];
List<String> academic_interests = <String>["Archaeology", "Mathematics", "Astronomy","Knowledge","Physics", "Biology", "Chemistry","Geneology","Science","Molecular Gastronomy","Model Trains","Politics","Geography", "Cartography","Typography","History"];
List<String> comedy_interests = <String>["Puppets","Pranks","Comedy", "Jokes", "Puns", "Stand-up Comedy","Humor","Comics","Satire","Knock Knock Jokes"];
List<String> domestic_interests = <String>["Sewing", "Fashion","Meditation","Babies","Peace","Knitting","Cooking", "Baking","Gardening", "Crochet", "Scrapbooking"];
List<String> athletic_interests = <String>["Yoga","Fitness", "Sports","Boxing", "Track and Field", "Swimming", "Baseball", "Hockey", "Football", "Basketball", "Weight Lifting"];
List<String> terrible_interests = <String>["Arson","Clowns", "Treasure","Money","Violence", "Death","Animal Fights","Insults","Hoarding","Status","Classism", "Online Trolling","Intimidation","Fighting","Genocide","Murder","War"];
List<String> fantasy_interests = <String>["Wizards", "Horrorterrors", "Mermaids", "Unicorns", "Science Fiction", "Fantasy","Ninjas","Aliens","Conspiracies","Faeries", "Elves", "Vampires", "Undead"];
List<String> justice_interests = <String>["Social Justice","Detectives","Mysteries","Leadership","Revolution","Justice","Equality","Sherlock Holmes"];

List<String> interests = []
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


List<String> prefixes = <String>["8=D",">->","//", "tumut",")","><>","(", "\$", "?", "=begin", "=end"]
	..addAll(<String>["<3","<3<","<>","c3<","{","}","<String>[","]","'",".",",","~","!","~","^","&","#","@","%","*"]);

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
List<List<String>> fantasy_quirks = <List<String>>[<String>["very","fairy"]];
List<dynamic> justice_quirks = [];

List<List<String>> sbahj_quirks = <List<String>>[<String>["asshole","dunkass"],<String>["happen","hapen"],<String>["we're","where"],<String>["were","where"],<String>["has","hass"],<String>["lol","ahahahaha"],<String>["dog","god"],<String>["god","dog"],<String>["know","no"]]
	..addAll(<List<String>>[<String>["they're","there"],<String>["their","there"],<String>["theyre","there"],<String>["through","threw"],<String>["lying","lyong"],<String>["distraction","distaction"],<String>["garbage","gargbage"],<String>["angel","angle"]])
	..addAll(<List<String>>[<String>["the","thef"],<String>["i'd","i'd would"],<String>["i'm","i'm am"],<String>["don't","don't not"],<String>["won't","won't not"],<String>["can't","can't not"],<String>["ing","ung"]])
	..addAll(<List<String>>[<String>["ink","ing"],<String>["ed","id"],<String>["id","ed"],<String>["ar","aur"],<String>["umb","unk"],<String>["ian","an"],<String>["es","as"],<String>["ough","uff"]]);


List<List<String>> terribleCSSOptions = <List<String>>[<String>["position: ", "absolute"],<String>["position: ", "relative"],<String>["position: ", "static"],<String>["position: ", "fixed"],<String>["float: ", "left"] ,<String>["float: ", "right"],<String>["width: ", "????"],<String>["height: ", "????"],<String>["right: ", "????"] ,<String>["top: ", "????"] ,<String>["bottom: ", "????"] ,<String>["left: ", "????"]   ];

List<List<String>> fish_quirks = <List<String>>[<String>["calm","clam"],<String>["ass","bass"],<String>["god","glub"],<String>["god","cod"],<String>["fuck","glub"],<String>["really","reely"],<String>["kill","krill"],<String>["thing","fin"],<String>["well","whale"],<String>["purpose","porpoise"],<String>["better","betta"],<String>["help","kelp"],<String>["see","sea"],<String>["friend","frond"],<String>["crazy","craysea"], <String>["kid","squid"], <String>["hell","shell"]];

//not as extreme as a troll quirk, buxt...
List<List<String>> conversational_quirks = <List<String>>[<String>["pro","bro"],<String>["guess","suppose"],<String>["S\\b", "Z"],<String>["oh my god","omg"],<String>["like", "liek"],<String>["ing","in"],<String>["have to","hafta"], <String>["want to","wanna"],<String>["going to","gonna"], <String>["i'm","i am"],<String>["you're","you are"],<String>["we're","we are"],<String>["forever","5ever"], <String>["ever","evah"],<String>["er","ah"],<String>["to","ta"]]
	..addAll(<List<String>>[<String>["I'm", "Imma"],<String>["don't know", "dunno"],<String>["school","skool"],<String>["the","teh"],<String>["aren't","aint"],<String>["ie","ei"],<String>["though","tho"],<String>["you","u"],<String>["right","rite"]])
	..addAll(<List<String>>[<String>["n't"," not"], <String>["'m'"," am"], <String>["kind of", "kinda"],<String>["okay", "ok"],<String>["\\band\\b","&"],<String>["\\bat\\b","@"],<String>["okay", "okey dokey"]]);

List<List<String>> very_quirks = <List<String>>[<String>["\\bvery\\b","adequately"],<String>["\\bvery\\b","really"],<String>["\\bvery\\b","super"],<String>["\\bvery\\b", "amazingly"],<String>["\\bvery\\b","hella"],<String>["\\bvery\\b","extremely"],<String>["\\bvery\\b","absolutely"],<String>["\\bvery\\b","mega"],<String>["\\bvery\\b ","extra"],<String>["\\bvery\\b","ultra"],<String>["\\bvery\\b","hecka"],<String>["\\bvery\\b","totes"]];
List<List<String>> good_quirks = <List<String>>[<String>["\\bgood\\b","good"],<String>["\\bgood\\b","agreeable"],<String>["\\bgood\\b", "marvelous"],<String>["\\bgood\\b", "ace"],<String>["\\bgood\\b", "wonderful"],<String>["\\bgood\\b","sweet"],<String>["\\bgood\\b","dope"],<String>["\\bgood\\b","awesome"],<String>["\\bgood\\b","great"],<String>["\\bgood\\b","radical"],<String>["\\bgood\\b","perfect"],<String>["\\bgood\\b","amazing"],<String>["\\bgood\\b","super good"],<String>["\\bgood\\b","acceptable"]];
List<List<String>> asshole_quirks = <List<String>>[<String>["asshole","dickhead"],<String>["asshole","pukestain"],<String>["asshole","dirtbag"],<String>["asshole","fuckhead"],<String>["asshole", "asshole"],<String>["asshole", "dipshit"],<String>["asshole", "garbage person"],<String>["asshole", "fucker"],<String>["asshole", "poopy head"],<String>["asshole", "shit sniffer"],<String>["asshole", "jerk"],<String>["asshole", "plebeian"],<String>["asshole", "fuckstain"],<String>["asshole", "douchebag"]];
List<List<String>> lol_quirks = <List<String>>[<String>["lol","lol"],<String>["lol","haha"],<String>["lol","ehehe"],<String>["lol","heh"],<String>["lol","omg lol"],<String>["lol","rofl"],<String>["lol","funny"],<String>["lol"," "],<String>["lol","hee"],<String>["lol","lawl"],<String>["lol","roflcopter"],<String>["lol","..."],<String>["lol","bwahah"],<String>["lol","*giggle*"],<String>["lol",":)"]];
List<List<String>> greeting_quirks = <List<String>>[<String>["\\bhey\\b", "hey"],<String>["\\bhey\\b", "hi"],<String>["\\bhey\\b", "hello"],<String>["\\bhey\\b", "greetings"],<String>["\\bhey\\b", "yo"],<String>["\\bhey\\b", "sup"]];
List<List<String>> dude_quirks = <List<String>>[<String>["dude","guy"], <String>["dude","guy"],<String>["dude","man"],<String>["dude","you"],<String>["dude","friend"],<String>["dude","asshole"],<String>["dude","fella"],<String>["dude","bro"]];
List<List<String>> curse_quirks = <List<String>>[<String>["fuck", "beep"],<String>["fuck", "motherfuck"],<String>["\\bfuck\\b", "um"],<String>["\\bfuck\\b", "fuck"],<String>["\\bfuck\\b", "shit"],<String>["\\bfuck\\b", "cocks"],<String>["\\bfuck\\b", "nope"],<String>["\\bfuck\\b", "goddammit"],<String>["\\bfuck\\b", "damn"],<String>["\\bfuck\\b", "..."],<String>["\\bfuck\\b", "...great."],<String>["\\bfuck\\b", "crap"],<String>["\\bfuck\\b", "fiddlesticks"],<String>["\\bfuck\\b", "darn"],<String>["\\bfuck\\b", "dang"],<String>["\\bfuck\\b", "omg"]];
//problem: these are likely to be inside of other words.
List<List<String>> yes_quirks = <List<String>>[<String>["\\byes\\b","certainly"],<String>["\\byes\\b","indeed"],<String>["\\byes\\b","yes"],<String>["\\byes\\b","yeppers"],<String>["\\byes\\b","right"],<String>["\\byes\\b","yeah"],<String>["\\byes\\b","yep"],<String>["\\byes\\b","sure"],<String>["\\byes\\b","okay"]];
List<List<String>> no_quirks = <List<String>>[<String>["\\bnope\\b","no"],<String>["\\bnope\\b","absolutely no"],<String>["\\bnope\\b","no"],<String>["\\bnope\\b","no"],<String>["\\bnope\\b","nope"],<String>["\\bnope\\b","no way"]];

//abandoned these early on because was annoyed at having to figure out how escapes worked. picking back up now.
List<List<String>> smiley_quirks = <List<String>>[<String>[":\\)", ":)"],<String>[":\\)", ":0)"],<String>[":\\)", ":]"],<String>[":\\)", ":B"],<String>[":\\)", ">: ]"],<String>[":\\)", ":o)"],<String>[":\\)", "^_^"],<String>[":\\)", ";)"],<String>[":\\)", "~_^"],<String>[":\\)", "0u0"],<String>[":\\)", "uwu"],<String>[":\\)", "¯\_(ツ)_/¯ "],<String>[":\\)", ":-)"],<String>[":\\)", ":3"],<String>[":\\)", "XD"],<String>[":\\)", "8D"],<String>[":\\)", ":>"],<String>[":\\)", "=]"],<String>[":\\)", "=}"],<String>[":\\)", "=)"],<String>[":\\)", "o->-<"]];





List<String> music_handles1 = <String>["musical","pianist","melodious","keyboard","rhythmic","singing","tuneful","harmonious","beating","pitch","waltzing","synthesized","piano","serenading","mozarts","swelling","staccato","pianissimo","monotone","polytempo"];
List<String> culture_handles1 = <String>["monochrome","poetic","majestic","keen","realistic","serious","theatrical","haute","beautiful","priceless","watercolor","sensational","highbrow","refined","precise","melodramatic"];
List<String> writing_handles1 = <String>["wordy","scribbling","meandering","pageturning","mysterious","knowledgeable","reporting","scribing","tricky","hardcover","bookish","page","writing","scribbler","wordsmiths"];
List<String> pop_culture_handles1 = <String>["worthy","mega","player","mighty","knightly","roguish","super","turbo","titanic","heroic","bitchin","power","wonder","wonderful", "sensational","thors","bat"];
List<String> technology_handles1 = <String>["kludge", "pixel","machinist","programming","mechanical","kilo","robotic","silicon","techno","hardware","battery","python","windows","serial","statistical"];
List<String> social_handles1 = <String>["master","playful","matchmaking","kind","regular","social","trusting","honest","benign","precious","wondering","sarcastic", "talkative","petulant"];
List<String> romantic_handles1 = <String>["wishful","matchmaking","passionate","kinky","romantic","serendipitous","true","hearts","blushing","precious","warm","serenading","mesmerizing","mirrored","pairing","perverse"];
List<String> academic_handles1 = <String>["serious","researching","machiavellian","princeton","pedagogical","theoretical","hypothetical","meandering","scholarly","biological","pants","spectacled","scientist","scholastic","scientific","particular","measured"];
List<String> comedy_handles1 = <String>["mischievous","knavish","mercurial","beagle","sarcastic","satirical","mime","pantomime","practicing","pranking","wokka","kooky","haha","humor","talkative","harlequins","hoho"];
List<String> domestic_handles1 = <String>["home","motherly","patient","missing","knitting","rising","stylish","trendy","homey","baking","recipe","meddling","mature"];
List<String> athletic_handles1 = <String>["kinetic", "muscley", "preening", "mighty", "running", "sporty", "tennis", "hard", "ball", "winning", "trophy", "sports", "physical", "sturdy", "strapping", "hardy", "brawny", "burly", "robust", "strong", "muscular", "phenomenal"];
List<String> terrible_handles1 = <String>["tyranical","heretical","murderous","persnickety","mundane","killer","rough","sneering","hateful","bastard","pungent","wasted","snooty","wicked","perverted","master","hellbound"];
List<String> fantasy_handles1 = <String>["musing","pacific","minotaurs","kappas","restful","serene","titans","hazy","best","peaceful","witchs","sylphic","sylvan","shivan","hellkite","malachite"];
List<String> justice_handles1 = <String>["karmic","mysterious","police","mind","keen","retribution","saving","tracking","hardboiled","broken","perceptive","watching","searching"];



List<String> music_handles2 = <String>["Siren","Singer","Tenor","Trumpeter","Baritone","Dancer","Ballerina","Harpsicordist","Musician","Lutist","Violist","Rapper","Harpist","Lyricist","Virtuoso","Bass"];
List<String> culture_handles2 = <String>["Dramatist","Repository","Museum","Librarian","Hegemony","Hierarchy","Davinci","Renaissance","Viniculture","Treaty","Balmoral","Beauty","Business"];
List<String> writing_handles2 = <String>["Shakespeare","Host","Bard","Drifter","Reader","Booker","Missive","Labret","Lacuna","Varvel","Hagiomaniac","Traveler","Thesis"];
List<String> pop_culture_handles2 = <String>["Superhero","Supervillain","Hero","Villain","Liaison","Director","Repeat","Blockbuster","Movie","Mission","Legend","Buddy","Spy","Bystander","Talent"];
List<String> technology_handles2 = <String>["Roboticist","Hacker","Haxor","Technologist","Robot","Machine","Machinist","Droid","Binary","Breaker","Vaporware","Lag","Laptop","Spaceman","Runner", "L33T","Data"];
List<String> social_handles2 = <String>["Socialist","Defender","Mentor","Leader","Veterinarian","Therapist","Buddy","Healer","Helper","Mender","Lender","Dog","Bishop","Rally"];
List<String> romantic_handles2 = <String>["Romantic","Dreamer","Beau","Hearthrob","Virtue","Beauty","Rainbow","Heart","Magnet","Miracle","Serendipity","Team"];
List<String> academic_handles2 = <String>["Business","Stuck","Student","Scholar","Researcher","Scientist","Trainee","Biologist","Minerologist","Lecturer","Herbalist","Dean","Director","Honcho","Minder","Verbalist","Botanist"];
List<String> comedy_handles2 = <String>["Laugher","Humorist","Trickster","Sellout","Dummy","Silly","Bum","Huckster","Raconteur","Mime","Leaper","Vaudevillian","Baboon","Boor"];
List<String> domestic_handles2 = <String>["Baker","Darner","Mender","Mentor","Launderer","Vegetarian","Tailor","Teacher","Hestia","Helper","Decorator","Sewer"];
List<String> athletic_handles2 = <String>["Swimmer","Trainer","Baller","Handler","Runner","Leaper","Racer","Vaulter","Major","Tracker","Heavy","Brawn","Darter","Brawler"];
List<String> terrible_handles2 = <String>["Butcher","Blasphemer","Barbarian","Tyrant","Superior","Bastard","Dastard","Despot","Bitch","Horror","Victim","Hellhound","Devil","Demon","Shark","Lupin", "Mindflayer","Mummy","Hoarder","Demigod"];
List<String> fantasy_handles2 = <String>["Believer","Dragon","Magician","Sandman","Shinigami","Tengu","Harpy","Dwarf","Vampire","Lamia","Roc","Mermaid","Siren","Manticore","Banshee","Basilisk","Boggart"];
List<String> justice_handles2 = <String>["Detective","Defender","Laywer","Loyalist","Liaison","Vigilante","Tracker","Moralist","Retribution","Watchman","Searcher","Perception","Rebel"];

List<String> human_hair_colors = <String>["#68410a","#fffffe", "#000000","#000000","#000000","#f3f28d","#cf6338","#feffd7","#fff3bd","#724107","#382207","#ff5a00","#3f1904","#ffd46d","#473200","#91683c"];

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
