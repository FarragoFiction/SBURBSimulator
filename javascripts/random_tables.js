//little bobby tables

//going to refactor so that all randomness is seeded.
Math.seed = getRandomSeed();  //can be overwritten on load
var initial_seed = Math.seed;
function getRandomElementFromArray(array){
	var min = 0;
	var max = array.length-1;
	var i = Math.floor(Math.seededRandom() * (max - min + 1)) + min;
	return array[i];
}


//http://jsfiddle.net/JKirchartz/wwckP/    horrorterror html stuff
var Zalgo = {
    chars: {
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

    },
    random: function(len) {
        if (len == 1) return 0;
        return !!len ? Math.floor(Math.random() * len + 1) - 1 : Math.random();
    },
    generate: function(str) {
        var str_arr = str.split(''),
            output = str_arr.map(function(a) {
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
};

//using this won't effect the sanctity of the shareable url
function getRandomElementFromArrayNoSeed(array){
	var min = 0;
	var max = array.length-1;
	var i = Math.floor(Math.random() * (max - min + 1)) + min;
	return array[i];
}

function getRandomElementFromArrayThatStartsWith(array,letter){
	var array = makeFilteredCopyForLetters(array, letter);
	var min = 0;
	var max = array.length-1;
	var i = Math.floor(Math.seededRandom() * (max - min + 1)) + min;
	return array[i];
}

//regular filter modifies the array. do not want this. bluh.
function makeFilteredCopyForLetters(array, letter){
	var tmp = [];
	for(var i = 0; i<array.length; i++ ){
		var word = array[i];
		if(word.startsWith(letter)){
			tmp.push(word);
		}
	}
	return tmp;
}


function turnArrayIntoHumanSentence(a){
	return [a.slice(0, -1).join(', '), a.slice(-1)[0]].join(a.length < 2 ? '' : ' and ');
}



//use class,aspect, and interests to generate a 16 element level array.
//need to happen ahead of time and have more variety to display on
//echeladder graphic.  4 interests total
function getLevelArray(player){
	var ret = [];

	for(var i = 0; i<16; i++){
			if(i%4 == 3 && i> 4){//dont start with claspects
				//get the i/4th element from the class level array.
				//if i =7, would get element 1. if i = 15, would get element 3.
				ret.push(getLevelFromClass(Math.round((i-8)/4), player.class_name))
			}else if(i%4 == 2  && i>4){
				ret.push(getLevelFromAspect(Math.round((i-8)/4), player.aspect))
			}else if(i%4==1){
				if(i<8){
					ret.push(getLevelFromInterests(Math.round(i/4), player.interest1))
				}else{
					//only 0 and 2 are valid, so if 3 or 4, go backwards.
					ret.push(getLevelFromInterests(Math.round((i-8)/4), player.interest2))
				}
			}else if(i%4 == 0 || i < 4){
				ret.push(getLevelFromFree()); //don't care about repeats here. should be long enough.
			}
	}
	return ret;
}

function getRandomLandFromPlayer(player){
	var first_arr = [];
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
	var tmp = randomFromTwoArrays(first_arr, free_land_titles);
	return tmp;
	//return "Land of " + tmp[0] + " and " + tmp[1];
}

//handle can either be about interests, or your claspect. each word can be separately origined
function getRandomChatHandle(class_name, aspect,interest1, interest2){
	//console.log("Class: " + class_name + "aspect: " + aspect);
	var first = "";
	var rand = Math.seededRandom();
	if(rand>0.3){
		first = getInterestHandle1(class_name, interest1);
	}else if(rand > .6){
		first = getInterestHandle1(class_name, interest2);
	}else{
		first = getBlandHandle1(class_name);
	}
	if(!first || first == ""){
		first = getBlandHandle1(class_name);  //might have forgot to have a interest handle of the right letter.
	}
	var second = "";
	if(rand>.3){
		second = getInterestHandle2(aspect, interest1);
	}else if(rand > .6){
		second = getInterestHandle2(aspect, interest2);
	}else{
		second = getBlandHandle2(aspect);
	}
	if(!second || second == ""){
		second = getBlandHandle2(aspect);
	}
	if(!first) first = "Null"
	if(!second) second = "Null"
	return first+second;
}

//can also repurpose this by passing in same plaeyr for both slots to get an adjative about them. Hell yes. Laziness FTW.
//What do you like about them? They are just so X. (Yes. Hell Yes. Hell FUCKING Yes.)
function whatDoPlayersHaveInCommon(player1, player2){
	if(playerLikesMusic(player1) && playerLikesMusic(player2) ){
		return "musical"
	}
	if(playerLikesCulture(player1) && playerLikesCulture(player2) ){
		return "cultured"
	}
	if(playerLikesWriting(player1) && playerLikesWriting(player2) ){
		return "lettered"
	}
	if(playerLikesPopculture(player1) && playerLikesPopculture(player2) ){
		return "geeky"
	}
	if(playerLikesTechnology(player1) && playerLikesTechnology(player2) ){
		return "techy"
	}
	if(playerLikesSocial(player1) && playerLikesSocial(player2) ){
		return "extroverted"
	}
	if(playerLikesRomantic(player1) && playerLikesRomantic(player2) ){
		return "romantic"
	}
	if(playerLikesAcademic(player1) && playerLikesAcademic(player2) ){
		return "smart"
	}
	if(playerLikesComedy(player1) && playerLikesComedy(player2) ){
		return "funny"
	}

	if(playerLikesDomestic(player1) && playerLikesDomestic(player2) ){
		return "domestic"
	}
	if(playerLikesAthletic(player1) && playerLikesAthletic(player2) ){
		return "athletic"
	}
	if(playerLikesTerrible(player1) && playerLikesTerrible(player2) ){
		return "honest" //'just telling it like it is' *rolls eyes*
	}
	if(playerLikesFantasy(player1) && playerLikesFantasy(player2) ){
		return "imaginative"
	}
	if(playerLikesJustice(player1) && playerLikesJustice(player2) ){
		return "fair-minded"
	}

	return "nice"//the defaultiest of traits.
}

//what are bad words to describe these traits?
function whatDontPlayersHaveInCommon(player1, player2){

	if(!playerLikesCulture(player1) && playerLikesCulture(player2) ){
		return "pretentious"
	}

	if(!playerLikesTerrible(player1) && playerLikesTerrible(player2) ){
		return "terrible" //'just telling it like it is' *rolls eyes*
	}

	if(!playerLikesPopculture(player1) && playerLikesPopculture(player2) ){
		return "frivolous"
	}

	if(!playerLikesSocial(player1) && playerLikesSocial(player2) ){
		return "shallow"
	}

	if(!playerLikesAcademic(player1) && playerLikesAcademic(player2) ){
		return "nerdy"
	}

	if(!playerLikesComedy(player1) && playerLikesComedy(player2) ){
		return "dorky"
	}

	if(!playerLikesMusic(player1) && playerLikesMusic(player2) ){
		return "loud"
	}

	if(!playerLikesWriting(player1) && playerLikesWriting(player2) ){
		return "wordy"
	}

	if(!playerLikesTechnology(player1) && playerLikesTechnology(player2) ){
		return "awkward"
	}

	if(!playerLikesRomantic(player1) && playerLikesRomantic(player2) ){
		return "obsessive"
	}

	if(!playerLikesDomestic(player1) && playerLikesDomestic(player2) ){
		return "boring"
	}

	if(!playerLikesAthletic(player1) && playerLikesAthletic(player2) ){
		return "dumb"
	}

	if(!playerLikesFantasy(player1) && playerLikesFantasy(player2) ){
		return "whimpy"
	}
	if(!playerLikesJustice(player1) && playerLikesJustice(player2) ){
		return "harsh"
	}

	return "annoying"//the defaultiest of traits.
}


function playerLikesMusic(player){
		if(music_interests.indexOf(player.interest1) != -1 || music_interests.indexOf(player.interest2) != -1 ){
			return true;
		}else{
			return false;
		}
}

function playerLikesCulture(player){
		if(culture_interests.indexOf(player.interest1) != -1 || culture_interests.indexOf(player.interest2) != -1 ){
			return true;
		}else{
			return false;
		}
}

function playerLikesWriting(player){
		if(writing_interests.indexOf(player.interest1) != -1 || writing_interests.indexOf(player.interest2) != -1 ){
			return true;
		}else{
			return false;
		}
}

function playerLikesPopculture(player){
		if(pop_culture_interests.indexOf(player.interest1) != -1 || pop_culture_interests.indexOf(player.interest2) != -1 ){
			return true;
		}else{
			return false;
		}
}


function playerLikesTechnology(player){
		if(technology_interests.indexOf(player.interest1) != -1 || technology_interests.indexOf(player.interest2) != -1 ){
			return true;
		}else{
			return false;
		}
}

function playerLikesSocial(player){
		if(social_interests.indexOf(player.interest1) != -1 || social_interests.indexOf(player.interest2) != -1 ){
			return true;
		}else{
			return false;
		}
}

function playerLikesRomantic(player){
		if(romantic_interests.indexOf(player.interest1) != -1 || romantic_interests.indexOf(player.interest2) != -1 ){
			return true;
		}else{
			return false;
		}
}

function playerLikesAcademic(player){
		if(academic_interests.indexOf(player.interest1) != -1 || academic_interests.indexOf(player.interest2) != -1 ){
			return true;
		}else{
			return false;
		}
}

function playerLikesComedy(player){
		if(comedy_interests.indexOf(player.interest1) != -1 || comedy_interests.indexOf(player.interest2) != -1 ){
			return true;
		}else{
			return false;
		}
}

function playerLikesDomestic(player){
		if(domestic_interests.indexOf(player.interest1) != -1 || domestic_interests.indexOf(player.interest2) != -1 ){
			return true;
		}else{
			return false;
		}
}

function playerLikesAthletic(player){
		if(athletic_interests.indexOf(player.interest1) != -1 || athletic_interests.indexOf(player.interest2) != -1 ){
			return true;
		}else{
			return false;
		}
}

function playerLikesTerrible(player){
		if(terrible_interests.indexOf(player.interest1) != -1 || terrible_interests.indexOf(player.interest2) != -1 ){
			return true;
		}else{
			return false;
		}
}

function playerLikesFantasy(player){
		if(fantasy_interests.indexOf(player.interest1) != -1 || fantasy_interests.indexOf(player.interest2) != -1 ){
			return true;
		}else{
			return false;
		}
}

function playerLikesJustice(player){
		if(justice_interests.indexOf(player.interest1) != -1 || justice_interests.indexOf(player.interest2) != -1 ){
			return true;
		}else{
			return false;
		}
}

function interestCategoryToInterestList(interestWord){
	//alert(interestWord)
	if(interestWord == "Comedy") return comedy_interests
	if(interestWord == "Music") return music_interests
	if(interestWord == "Culture") return culture_interests
	if(interestWord == "Writing") return writing_interests
	if(interestWord == "Athletic") return athletic_interests
	if(interestWord == "Terrible") return terrible_interests
	if(interestWord == "Justice") return justice_interests
	if(interestWord == "Fantasy") return fantasy_interests
	if(interestWord == "Domestic") return domestic_interests
	if(interestWord == "PopCulture") return pop_culture_interests
	if(interestWord == "Technology") return technology_interests
	if(interestWord == "Social") return social_interests
	if(interestWord == "Romance") return romantic_interests
	if(interestWord == "Academic") return academic_interests
}

function getInterestHandle1(class_name,interest){
	if(music_interests.indexOf(interest) != -1){
			return getRandomElementFromArrayThatStartsWith(music_handles1, class_name.toLowerCase()[0]);
	}else if (culture_interests.indexOf(interest) != -1){
			return getRandomElementFromArrayThatStartsWith(culture_handles1, class_name.toLowerCase()[0]);
	}else if (writing_interests.indexOf(interest) != -1){
			return getRandomElementFromArrayThatStartsWith(writing_handles1, class_name.toLowerCase()[0]);
	}else if (pop_culture_interests.indexOf(interest) != -1){
			return getRandomElementFromArrayThatStartsWith(pop_culture_handles1, class_name.toLowerCase()[0]);
	}else if (technology_interests.indexOf(interest) != -1){
			return getRandomElementFromArrayThatStartsWith(technology_handles2, class_name.toLowerCase()[0]);
	}else if (social_interests.indexOf(interest) != -1){
			return getRandomElementFromArrayThatStartsWith(social_handles1, class_name.toLowerCase()[0]);
	}else if (romantic_interests.indexOf(interest) != -1){
			return getRandomElementFromArrayThatStartsWith(romantic_handles1, class_name.toLowerCase()[0]);
	}else if (academic_interests.indexOf(interest) != -1){
			return getRandomElementFromArrayThatStartsWith(academic_handles1, class_name.toLowerCase()[0]);
	}else if (comedy_interests.indexOf(interest) != -1){
			return getRandomElementFromArrayThatStartsWith(comedy_handles1, class_name.toLowerCase()[0]);
	}else if (domestic_interests.indexOf(interest) != -1){
			return getRandomElementFromArrayThatStartsWith(domestic_handles1, class_name.toLowerCase()[0]);
	}else if (athletic_interests.indexOf(interest) != -1){
			return getRandomElementFromArrayThatStartsWith(athletic_handles1, class_name.toLowerCase()[0]);
	}else if (terrible_interests.indexOf(interest) != -1){
			return getRandomElementFromArrayThatStartsWith(terrible_handles1, class_name.toLowerCase()[0]);
	}else if (fantasy_interests.indexOf(interest) != -1){
			return getRandomElementFromArrayThatStartsWith(fantasy_handles1, class_name.toLowerCase()[0]);
	}else if (justice_interests.indexOf(interest) != -1){
			return getRandomElementFromArrayThatStartsWith(justice_handles1, class_name.toLowerCase()[0]);
	}
	console.log("I didn't return anything!? What was my interest: " + interest)
}

function getInterestHandle2(aspect,interest){
	if(music_interests.indexOf(interest) != -1){
		return getRandomElementFromArrayThatStartsWith(music_handles2, aspect.toUpperCase()[0]);
	}else if (culture_interests.indexOf(interest) != -1){
		return getRandomElementFromArrayThatStartsWith(culture_handles2, aspect.toUpperCase()[0]);
	}else if (writing_interests.indexOf(interest) != -1){
		return getRandomElementFromArrayThatStartsWith(writing_handles2, aspect.toUpperCase()[0]);
	}else if (pop_culture_interests.indexOf(interest) != -1){
		return getRandomElementFromArrayThatStartsWith(pop_culture_handles2, aspect.toUpperCase()[0]);
	}else if (technology_interests.indexOf(interest) != -1){
		return getRandomElementFromArrayThatStartsWith(technology_handles2, aspect.toUpperCase()[0]);
	}else if (social_interests.indexOf(interest) != -1){
		return getRandomElementFromArrayThatStartsWith(social_handles2, aspect.toUpperCase()[0]);
	}else if (romantic_interests.indexOf(interest) != -1){
		return getRandomElementFromArrayThatStartsWith(romantic_handles2, aspect.toUpperCase()[0]);
	}else if (academic_interests.indexOf(interest) != -1){
		return getRandomElementFromArrayThatStartsWith(academic_handles2, aspect.toUpperCase()[0]);
	}else if (comedy_interests.indexOf(interest) != -1){
		return getRandomElementFromArrayThatStartsWith(comedy_handles2, aspect.toUpperCase()[0]);
	}else if (domestic_interests.indexOf(interest) != -1){
		return getRandomElementFromArrayThatStartsWith(domestic_handles2, aspect.toUpperCase()[0]);
	}else if (athletic_interests.indexOf(interest) != -1){
		return getRandomElementFromArrayThatStartsWith(athletic_handles2, aspect.toUpperCase()[0]);
	}else if (terrible_interests.indexOf(interest) != -1){
		return getRandomElementFromArrayThatStartsWith(terrible_handles2, aspect.toUpperCase()[0]);
	}else if (fantasy_interests.indexOf(interest) != -1){
		return getRandomElementFromArrayThatStartsWith(fantasy_handles2, aspect.toUpperCase()[0]);
	}else if (justice_interests.indexOf(interest) != -1){
		return getRandomElementFromArrayThatStartsWith(justice_handles2, aspect.toUpperCase()[0]);
	}
}

function getBlandHandle1(class_name){
	var second_arr = [];
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
	return getRandomElementFromArray(second_arr);
}

function getBlandHandle2(aspect){
	var first_arr = [];
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
	return getRandomElementFromArray(first_arr);
}


function getRandomChatHandleOld(class_name, aspect){
	var first_arr = [];
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

	var second_arr = [];
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
	var tmp =  randomFromTwoArraysOrdered(second_arr, first_arr);
	return tmp[0]  + tmp[1];
}

function getLevelFromFree(){
	return getRandomElementFromArray(free_levels)
}

function getLevelFromInterests(i, interest){
	if(music_interests.indexOf(interest) != -1){
			return music_levels[i]
	}else if (culture_interests.indexOf(interest) != -1){
			return culture_levels[i]
	}else if (writing_interests.indexOf(interest) != -1){
			return writing_levels[i]
	}else if (pop_culture_interests.indexOf(interest) != -1){
			return pop_culture_levels[i]
	}else if (technology_interests.indexOf(interest) != -1){
			return technology_levels[i]
	}else if (social_interests.indexOf(interest) != -1){
			return social_levels[i]
	}else if (romantic_interests.indexOf(interest) != -1){
			return romantic_levels[i]
	}else if (academic_interests.indexOf(interest) != -1){
			return academic_levels[i]
	}else if (comedy_interests.indexOf(interest) != -1){
			return comedy_levels[i]
	}else if (domestic_interests.indexOf(interest) != -1){
			return domestic_levels[i]
	}else if (athletic_interests.indexOf(interest) != -1){
			return athletic_levels[i]
	}else if (terrible_interests.indexOf(interest) != -1){
			return terrible_levels[i]
	}else if (fantasy_interests.indexOf(interest) != -1){
			return fantasy_levels[i]
	}else if (justice_interests.indexOf(interest) != -1){
			return justice_levels[i]
	}
}
function getLevelFromAspect(i, aspect){
	//console.log("looking for level from aspect, i is " + i);
	var first_arr = [];
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
	//console.log("found: " + first_arr[i])
	return first_arr[i];
}

function getLevelFromClass(i,class_name){
	//console.log("looking for level from class");
	var first_arr = [];
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

function getRandomDenizenQuestFromAspect(player){
	//console.log("looking for level from aspect");
	var first_arr = [];
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
		return "Null"
	}
	var ret =  first_arr[player.denizen_index]
	//console.log(ret);
	player.denizen_index ++;
	return ret;
}


function getRandomQuestFromAspect(aspect,postDenizen){
	//console.log("looking for level from aspect");
	var first_arr = [];
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
	return getRandomElementFromArray(first_arr);
}



/**
 * Returns a random integer between min (inclusive) and max (inclusive)
 * Using Math.round() will give you a non-uniform distribution!
 */
function getRandomInt(min, max) {
    return Math.floor(Math.seededRandom() * (max - min + 1)) + min;
}

function getRandomIntNoSeed(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

//
//using a seed will let me make the simulations predictable. This enables sharing AND bullshit cloud predictions.
//and stable time loops. and god, i'm getting the vapors here.
function getRandomSeed() {
	//console.log("getting a random seed, probably to reinit the seed")
	var min = 0;
	var max = 413*612*1025;
    return Math.floor(Math.random() * (max - min + 1)) + min;
}


 //I am in love:  http://indiegamr.com/generate-repeatable-random-numbers-in-js/
// in order to work 'Math.seed' must NOT be undefined,
// so in any case, you HAVE to provide a Math.seed
//this only gave be 200k random numbers. upgarding.
Math.seededRandomOld = function(max, min) {
	//console.log("getting seeded random");
    max = max || 1;
    min = min || 0;

    Math.seed = (Math.seed * 9301 + 49297) % 233280;
    var rnd = Math.seed / 233280;

    return min + rnd * (max - min);
}
////https://en.wikipedia.org/wiki/Linear_congruential_generator#Parameters_in_common_use if i want to have more possible sessions, use 2^32 or 2^64. see wiki
//have modulus be 2^32 (4294967296), a = 1664525, c = 1013904223
Math.seededRandom = function(max, min){
	/*random_number = (lcg.previous * a + c) % modulus
    lcg.previous = random_number
    return random_number
	*/
	max = max || 1;
    min = min || 0;
	Math.seed = (Math.seed * 1664525 + 1013904223) % 4294967296;
    var rnd = Math.seed / 4294967296;

    return min + rnd * (max - min);
}

function getRandomQuestFromClass(class_name,postDenizen){
	//console.log("looking for level from class");
	var first_arr = [];
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
	return getRandomElementFromArray(first_arr);
}

function randomFromTwoArrays(arr1, arr2){
	if(Math.seededRandom() > .5){
		return [getRandomElementFromArray(arr2), getRandomElementFromArray(arr1)];
	}else{
		return [getRandomElementFromArray(arr1), getRandomElementFromArray(arr2)];
	}
}

function randomFromTwoArraysOrdered(arr1, arr2){
	return [getRandomElementFromArray(arr1), getRandomElementFromArray(arr2)];
}

function indexToWords(i){
	if(i>11) return "???";
	var words = ["first","second","third","fourth","fifth","sixth","seventh","eighth","ninth","tenth","eleventh","twelfth"];
	return words[i];
}

function debug(str){
	$("#debug").append("<br>" + str);
}

//why does this not work with seeded randomness?
function shuffle(array) {
  var currentIndex = array.length, temporaryValue, randomIndex;

  // While there remain elements to shuffle...
  while (0 !== currentIndex) {

    // Pick a remaining element...
    randomIndex = Math.floor(Math.seededRandom() * currentIndex);
    currentIndex -= 1;

    // And swap it with the current element.
    temporaryValue = array[currentIndex];
    array[currentIndex] = array[randomIndex];
    array[randomIndex] = temporaryValue;
  }

  return array;
}
//finally giving myself a saner remove array method, but without deprecating the old one.
Array.prototype.removeFromArray = function(item){
	var index = this.indexOf(item);
	if (index > -1) {
		this.splice(index, 1);
	}
}



function removeFromArray(item, array){
	var index = array.indexOf(item);
	if (index > -1) {
		array.splice(index, 1);
	}
}

function classNameToInt(class_name){
	var tmp = classes;
	tmp = tmp.concat(custom_only_classes);
	var ret = tmp.indexOf(class_name);
	if (ret == -1) ret = 255;
	return ret;
}

function intToClassName(num){
    console.log("looking for class name from: " + num)
	var tmp = classes;
	tmp = tmp.concat(custom_only_classes);
	if(num > tmp.length || num == 255) return "Null" //Null of Mind
	return tmp[num];
}

function aspectToInt(aspect){
    var tmp = all_aspects.indexOf(aspect);
    if(tmp == -1) tmp = 255;
	return tmp;
}

function intToAspect(num){
    console.log("looking for aspect from: " + num)
    if(num > all_aspects.length || num == 255) return "Null"  //Heir of Null
	return all_aspects[num];
}

function bloodColorToBoost(color){
	 return 2* bloodColorToInt(color); //high blood are STRONG why is this always returning 45??? huh, thinks color is numb.
}

function bloodColorToInt(color){
	if(color == "#ff0000") return 14;
	if(color == "#ffc3df") return 13;
	if(color == null) return 15;
	var ret =  bloodColors.indexOf(color);
	return ret;
}

function intToBloodColor(num){
	if(num == 15) return null; //bubble gum pink not an option 'cause my special snowlake fan troll needs to stay special
	if(num == 14) return "#ff0000";
	if(num == 13) return "#ffc3df";
	return bloodColors[num];
}

function hexColorToInt(color){
	return parseInt(color.replace("#",""),16);
}

function intToHexColor(num){
	//console.log("int is " + num)
	var tmp =  num.toString(16);
	var padding = 6 - tmp.length;
	for(var i = 0; i<padding; i++){
		tmp = "0" + tmp;
	}
	//console.log("which i think is: " + tmp + " in hex")
	return "#" + tmp;
}

function interestCategoryToInt(cat){
	return interestCategories.indexOf(cat);
}

function intToInterestCategory(num){
	return interestCategories[num];
}

function moonToColor(moon){
	if(moon == "Prospit"){
		return "#ffff00"
	}else{
		return "#f092ff"
	}
}



var moons = ["Prospit", "Derse"];

var active_classes = ["Thief","Knight","Heir","Mage","Witch", "Prince", "Waste", "Scout", "Scribe"];
var passive_classes = ["Rogue","Page","Maid","Seer","Sylph", "Bard"];
//if you change the order of ANY of these classes, it will break ocDataStrings
var classes = ["Maid","Page","Mage","Knight","Rogue","Sylph","Seer","Thief","Heir","Bard","Prince","Witch"];
//when a class is used, remove from below list. //if you change the order of ANY of these classes, it will break ocDataStrings
var available_classes = ["Maid","Page","Mage","Knight","Rogue","Sylph","Seer","Thief","Heir","Bard","Prince","Witch"];
var available_classes_guardians = ["Maid","Page","Mage","Knight","Rogue","Sylph","Seer","Thief","Heir","Bard","Prince","Witch"];

//if you change the order of ANY of these classes, it will break ocDataStrings
var custom_only_classes = ["Waste", "Scout", "Sage", "Scribe"]; //Lord, Muse, Guide, Scout, Scribe, Smith, Wright
var required_aspects = ["Space", "Time"];
var all_aspects = ["Space", "Time","Breath","Doom","Blood","Heart","Mind","Light","Void","Rage","Hope","Life"];
var nonrequired_aspects = ["Breath","Doom","Blood","Heart","Mind","Light","Void","Rage","Hope","Life"];
var available_aspects = ["Breath","Doom","Blood","Heart","Mind","Light","Void","Rage","Hope","Life"];

//TODO eventually implent null land titles, like Mounds and Xenon.
var space_land_titles = ["Frogs"];
var time_land_titles = ["Quartz", "Clockwork", "Gears", "Melody","Cesium", "Clocks", "Ticking", "Beats", "Mixtapes","Songs", "Music", "Vuvuzelas", "Drums", "Pendulums"];
var breath_land_titles = ["Wind","Breeze","Zephyr","Gales","Storms","Planes","Twisters", "Hurricanes","Gusts", "Windmills", "Pipes", "Whistles"];
var doom_land_titles = ["Fire", "Death", "Prophecy", "Blight", "Rules", "Prophets", "Poison", "Funerals", "Graveyards", "Ash", "Disaster", "Fate", "Destiny", "Bones"];
var blood_land_titles = ["Pulse", "Bonds", "Clots", "Bloodlines", "Ichor", "Veins", "Chambers", "Arteries", "Unions"];
var heart_land_titles = ["Little Cubes","Dolls","Selfies","Mirrors", "Spirits", "Souls", "Jazz", "Shards", "Splinters"];
var mind_land_titles = ["Thought", "Rationality", "Decisions","Consequences", "Choices", "Paths", "Trails", "Trials"];
var light_land_titles = ["Treasure", "Light","Knowledge","Radiance", "Gambling", "Casinos", "Fortune", "Sun", "Glow", "Chance"];
var void_land_titles = ["Silence", "Nothing","Void","Emptiness", "Tears", "Dust", "Night", "[REDACTED]", "???", "Blindness"];
var rage_land_titles = ["Mirth","Whimsy","Madness","Impossibility", "Chaos", "Hate", "Violence", "Joy", "Murder", "Noise", "Screams","Denial"];
var hope_land_titles = ["Angels","Hope","Belief","Faith","Determination", "Possibility", "Hymns", "Heroes", "Chapels", "Lies", "Bullshit"];
var life_land_titles = ["Dew","Spring","Beginnings","Vitality", "Jungles", "Swamps", "Gardens", "Summer", "Chlorophyll", "Moss", "Rot", "Mold"];

//typoed special snowlake once insteada snowflake, and now it's a land.
var free_land_titles = ["Snowlake", "Heat","Sand","Brains","Haze","Tea","Flow","Maps","Caves","Tents","Wrath","Rays","Glass","Lava","Magma"];
free_land_titles = free_land_titles.concat(["Shade","Frost","Rain","Fog","Trees","Flowers","Books","Technology","Ice","Water", "Waterfalls","Rocks"]);
free_land_titles = free_land_titles.concat(["Forests","Grass","Tundra","Thunder","Winter","Peace","Food","Shoes","Weasels","Deserts","Dessert","Lightning"]);
free_land_titles = free_land_titles.concat(["Suburbs","Cities","Neighborhoods","Isolation","Schools","Farms","Annoyance","Hunger","Cake","Tricks","Ruins","Temples", "Towers"]);
free_land_titles = free_land_titles.concat(["Nails","Smoke","Curses","Flood","Ooze","Mud","Weeds","Vines","Courts","Clay","Halls","Choirs","Mushrooms", "Locks"]);
free_land_titles = free_land_titles.concat(["Slums","Balloons","Rumbling","Warfare","Cliffs","Needles","Mountains","Shadows","Circuitry","Fences","Webs"]);
free_land_titles = free_land_titles.concat(["Bone","Arenas","Wonder","Fluff","Cotton","Domes","Gold","Silver","Bronze","Ruby","Ribbon"]);
free_land_titles = free_land_titles.concat(["Hair","Teeth","Tendrils","Mouths","Paint","Pain","Wood","Colors","Echoes","Fossils","Roses","Tulips","Mummies", "Zombies", "Corpses"]);
free_land_titles = free_land_titles.concat(["Mysteries","Splendor","Luxury","Cash","Coins","Crystals","Gemstones","Cards","Tarot","Wagons","Puzzles","Mayhem","Redundancy","Redundancy"]);
free_land_titles = free_land_titles.concat(["Obsolescence","Deceit","Ruse","Distraction","Libraries","Blocks","Video Games","Vermin","Butchers","Meat","Clouds", "Horses"]);

//google is an in joke because apparently google reports that all sessions are crashed and it is beautiful and google is a horrorterror.
var corruptedOtherLandTitles = [Zalgo.generate("Google"), Zalgo.generate("Horrorterrors"),Zalgo.generate("Glitches"),Zalgo.generate("Grimoires"),Zalgo.generate("Fluthlu"),Zalgo.generate("The Zoologically Dubious")];
free_land_titles = free_land_titles.concat(corruptedOtherLandTitles);



var space_levels = ["GREENTIKE", "RIBBIT RUSTLER", "FROG-WRANGLER"];
var time_levels = ["MARQUIS MCFLY", "JUNIOR CLOCK BLOCKER", "DEAD KID COLLECTOR"];
var breath_levels = ["BOY SKYLARK", "SODAJERK'S CONFIDANTE", "MAN SKYLARK"];
var doom_levels = ["APOCALYPSE HOW", "REVELATION RUMBLER", "PESSIMISM PILGRIM"];
var blood_levels = ["FRIEND HOARDER YOUTH","HEMOGOBLIN", "SOCIALIST BUTTERFLY"];
var heart_levels = ["SHARKBAIT HEARTHROB", "FEDORA FLEDGLING","PENCILWART PHYLACTERY"];
var mind_levels = ["NIPPER-CADET", "COIN-FLIPPER CONFIDANTE", "TWO-FACED BUCKAROO"];
var light_levels = ["SHOWOFF SQUIRT","JUNGLEGYM SWASHBUCKLER","SUPERSTITIOUS SCURRYWART"];
var void_levels = ["KNOW-NOTHING ANKLEBITER","INKY BLACK SORROWMASTER","FISTICUFFSAFICTIONADO"];
var rage_levels = ["MOPPET OF MADNESS","FLEDGLING HATTER","RAGAMUFFIN REVELER"];
var hope_levels = ["GADABOUT PIPSQUEAK","BELIVER EXTRAORDINAIRE","DOCTOR FEELGOOD"];
var life_levels = ["BRUISE BUSTER","LODESTAR LIFER","BREACHES HEALER"];

var maid_levels = ["SCURRYWART SERVANT", "SAUCY PILGRIM", "MADE OF SUCCESS"];
var page_levels = ["APPRENTICE ANKLEBITER", "JOURNEYING JUNIOR", "OUTFOXED BUCKAROO"];
var mage_levels = ["WIZARDING TIKE", "THE SORCERER'S SCURRYWART", "FAMILIAR FRAYMOTTIFICTIONADO"];
var knight_levels = ["QUESTING QUESTANT", "LADABOUT LANCELOT", "SIR SKULLDODGER"];
var rogue_levels = ["KNEEHIGH ROBINHOOD","DASHING DARTABOUT", "COMMUNIST COMMANDER"];
var sylph_levels = ["SERENE SCALLYWAG", "MYSTICAL RUGMUFFIN","FAE FLEDGLING"];
var thief_levels = ["RUMPUS RUINER", "HAMBURGLER YOUTH", "PRISONBAIT"];
var heir_levels = ["UNREAL HEIR","HEIR CONDITIONER","EXTRAORDINHEIR"];
var bard_levels = ["SKAIA'S TOP IDOL","POPSTAR BOPPER","SONGSCUFFER"];
var prince_levels = ["PRINCE HARMING","ROYAL RUMBLER","DIGIT PRINCE"];
var witch_levels = ["WESTWORD WORRYBITER","BUBBLETROUBLER","EYE OF GRINCH"];
var seer_levels = ["SEEING iDOG","PIPSQUEAK PROGNOSTICATOR","SCAMPERVIEWER 5000"];
var waste_levels = ["4TH WALL AFICIONADO","CATACLYSM COMMANDER","AUTHOR"];
var scout_levels = ["BOSTON SCREAMPIE","COOKIE OFFERER","FIRE FRIEND"];
var scribe_levels = ["MIDNIGHT BURNER","WRITER WATCHER","DIARY DEAREST"];
var sage_levels = ["HERBAL ESSENCE","CHICKEN SEASONER","TOMEMASTER"];
var generic_levels = ["SNOWMAN SAVIOR","NOBODY NOWHERE","NULLZILLA"];

var free_levels = ["NIPPER CADET","PESKY URCHIN","BRAVESPROUT","JUVESQUIRT","RUMPUS BUSTER","CHAMP-FRY","ANKLEBITER","CALLOUSED TENDERFOOT","RASCALSPRAT","GRITTY MIDGET","BRITCHES RIPPER","ALIEN URCHIN", "NESTING NEWB"]
//only need two for each. since each player has two interests, combines to 4
var music_levels = ["SINGING SCURRYWORT","MUSICAL MOPPET"];
var culture_levels = ["APPRENTICE ARTIST","CULTURE BUCKAROO"];
var writing_levels = ["SHAKY SHAKESPEARE","QUILL RUINER"];
var pop_culture_levels = ["TRIVIA SMARTYPANTS","NIGHTLY NABBER"];
var technology_levels = ["HURRYWORTH HACKER","CLANKER CURMUDGEON"];
var social_levels = ["FRIEND-TO-ALL","FRIEND COLLECTOR"];
var romantic_levels = ["QUESTING CUPID","ROMANCE EXPERT"];
var academic_levels = ["NERDY NOODLER","SCAMPERING SCIENTIST"];
var comedy_levels = ["PRATFALL PRIEST","BEAGLE PUSS DARTABOUT"];
var domestic_levels = ["BATTERBRAT","GRITTY GUARDIAN"];
var athletic_levels = ["MUSCLES HOARDER","BODY BOOSTER"];
var terrible_levels = ["ENEMY #1","JERKWAD JOURNEYER"];
var fantasy_levels = ["FAKEY FAKE LOVER","FANTASTIC DREAMER"];
var justice_levels = ["JUSTICE JUICER","BALANCE RUMBLER"];

var level_bg_colors = ["#8ff74a","#ba1212","#ffffee","#f0ff00","#9c00ff","#2b6ade","#003614","#f8e69f","#0000ff","#eaeaea","#ff9600","#581212","#ffa6ac","#1f7636","#ffe1fc","#fcff00"];
var level_font_colors = ["#264d0c","#ff00d2","#ff0000","#626800","#da92e0","#022e41","#aaffa6","#000052","#6dffdb","#e5d200","#00911b","#ff0000","#5e005f","#fbff8d","#000000","#"];

var space_quests = ["seeking out out potential Frog sources"];
space_quests.push("restoring a half-ruined Frog shrine in the wilds of the Land");
space_quests.push("interogating consorts as to what the point of Frogs even is");
space_quests.push("navigating one's way through a deudly dungeon in complete darkness, relying only on one's spatial senses");
var time_quests = ["manipulating the local stock exchange through a series of cunningly disguised time doubles"];
time_quests.push("stopping a variety of disasters from happening before even the first player enters the medium");
time_quests.push("cheating at obstacle course time trials to get a finishing value of exactly 0.0 seconds");
var breath_quests = ["putting out fires in consort villages through serendipitous gales of wind"];
breath_quests.push("delivering mail through a complicated series of pneumatic tubes");
breath_quests.push("paragliding through increasingly elaborate obstacle courses to become the champion (it is you)");
var doom_quests = ["calculating the exact moment a planet quake will destroy a consort village with enough time remaining to perform evacuation"];
doom_quests.push("setting up increasingly complex Rube Goldberg machines to defeat all enemies in a dungeon at once");
doom_quests.push("obnoxiously memorizing the rules of a minigame, and then blatantly  abusing them to achieve an otherwise impossible victory");
var blood_quests = ["uniting warring consort nations against a common enemy"];
blood_quests.push("organizing 5 bickering consorts long enough to transverse a dungeon with any degree of competence");
blood_quests.push("learning the true meaning of this human disease called friendship");
var heart_quests = ["providing a matchmaking service for the local consorts (ships guaranteed)"];
heart_quests.push("doing battle with shadow clones that are eventually defeated when you accept them as a part of you");
heart_quests.push("correctly picking out which item represents them out of a vault of a thousand bullshit shitty stuffed animals");
var mind_quests = ["manipulating the local consorts into providing dungeon clearing services"];
mind_quests.push("presiding over increasingly hard consort court cases, punishing the guilty and pardoning the innocent");
mind_quests.push("pulling pranks as a minigame, with bonus points awarded for pranks performed on those who 'had it coming'");
var light_quests = ["winning at increasingly unfair gambling challenges"];
light_quests.push("researching way too much lore and minutia to win at trivia contests");
light_quests.push("explaining how to play a mini game to particularly stupid consorts until they finally get it");
var void_quests = ["destroying and/or censoring embarrassing consort records"];
void_quests.push("definitely doing quests, just...not where we can see them");
void_quests.push("playing a hilariously fun boxing minigame");
var rage_quests = ["fighting hordes upon hordes of enemies in increasingly unfair odds until defeating them all in a berserk rage"]; //You can't believe how easy it is. You just have to go... a little crazy. And then, suddenly, it all makes sense, and everything you do turns to gold.
rage_quests.push("figuring out increasingly illogical puzzles until lateral thinking becomes second nature");
rage_quests.push("dealing with the most annoying dungeon challenges ever, each more irritating and aneurysm inducing than the last");
var hope_quests = ["performing bullshit acts of faith, like walking across invisible bridges"];
hope_quests.push("becoming the savior of the local consorts, through fulfillment of various oddly specific prophecies");
hope_quests.push("brainstorming a variety of ways the local consorts can solve their challenges");
var life_quests = ["coaxing the fallow farms of the local consorts into becoming fertile"];
life_quests.push("healing a seemingly endless parade of stricken consorts");
life_quests.push("finding and rescuing consort children trapped in a burning building");


var maid_quests = ["doing the consorts' menial errands, like delivering an item to a dude standing RIGHT FUCKING THERE"];
maid_quests.push("repairing various ways the session has been broken");
maid_quests.push("protecting various consorts with game powers");
var page_quests = ["going on various quests of self discovery and confidence building"];
page_quests.push("partnering with a local consort hero to do great deeds and slay evil foes");
page_quests.push("learning to deal with disapointment after dungeon after dungeon proves to have all the enemies, and none of the treasure");
var mage_quests = ["performing increasingly complex alchemy for demanding, moody consorts"];
mage_quests.push("learning to silence their Mage Senses long enough to not go insane");
mage_quests.push("learning to just let go and let things happen");
var knight_quests = ["protecting the local consorts from a fearsome foe"];
knight_quests.push("protecting the session from various ways it can go shithive maggots");
knight_quests.push("questing to collect the 7 bullshit orbs of supreme bullshit and deliver them to the consort leader");
var rogue_quests = ["robbing various tombs and imp settlements to give to impoverished consorts"];
rogue_quests.push("stealing a priceless artifact in order to fund consort orphanages");
rogue_quests.push("planning an elaborate heist to steal priceless grist from a boss ogre in order to alchemize shoes for orphans");
var sylph_quests = ["restoring a consort city to its former glory"];
sylph_quests.push("preserving the legacy of a doomed people");
sylph_quests.push("providing psychological counseling to homeless consorts");
var thief_quests = ["robbing various enemy imps and ogres to obtain vast riches"];
thief_quests.push("planning an elaborate heist that relies on several hard-to-predict factors going absolutely perfectly");
thief_quests.push("torrenting vast amounts of grist from the other players");
var heir_quests = ["retrieving a sword from a stone"];
heir_quests.push("completing increasingly unlikely challenges through serendepitious coincidences");
heir_quests.push("inheriting and running a successful, yet complex company");
var bard_quests = ["allowing events to transpire such that various quests complete themselves"];
bard_quests.push("baiting various enemies into traps for an easy victory");
bard_quests.push("watching as their manipulations result in consorts rising up to defeat imps");
var prince_quests = ["destroying enemies thoroughly"];
prince_quests.push("riding in at the last minute to defeat the local consorts hated enemies");
prince_quests.push("learning to grow as a person, despite the holes in their personality");
var seer_quests = ["making the various bullshit rules of SBURB part of their personal mythos"];
seer_quests.push("collaborating with the exiled future carapacians to manipulate Prospit and Derse according to how its supposed to go");
seer_quests.push("suddenly understanding everything, and casting sincere doubt at the laughable insinuation that they ever didn't");
var witch_quests = ["performing elaborate punch card alchemy through the use of a novelty witch's cauldron"];
witch_quests.push("deciding which way to go in a series of way-too-long mazes");
witch_quests.push("solving puzzles in ways that completely defy expectations");
var waste_quests = ["being a useless piece of shit and reading FAQs to skip the hard shit in levels","causing ridiculous amounts of destruction trying to skip quest lines","learning that sometimes you have to do things right, and can't just skip ahead"];
var scout_quests = ["exploring areas no Consort has dared to trespass in","getting lost in ridiculously convoluted mazes","playing map-creating mini games"];
var scribe_quests = ["taking down the increasingly random and nonsensical oral history of a group of local Consorts","playing typing themed mini games.","saving an important piece of a riddle from a crumbling building"];
var sage_quests = ["making the lore of SBURB part of their personal mythos","learning to nod wisely and remain silent when Consorts start yammering on about the Ultimate Riddle","participating in riddle contests to prove their intelligence to local Consorts"];
var generic_quests = ["definitely doing class related quests", "solving consorts problems in a class themed manner", "absolutely not goofing off"];


//if bike quests are too common, lock them to real selves only, no dream selves.
var bike_quests = ["performing the SWEETEST bike stunts in all of SBURB", "doing bike stunts so sick they are illegal by Dersite standards", "doing bike stunts with air so unreal time just stops and everybody wishes to be them", "performing an endless grind on prospit's moon chain"];
bike_quests.push("getting air so unreal that they jump from one planet to another on their sick nasty bike");
bike_quests.push("writing dope as fuck Bike Stunt FAQs to keep their sanity");
bike_quests.push("singing a song, you know, from that shitty kids cartoon? 'wake up in the morning there's a brand new day ahead the sun is bright and the clouds smile down and all your friends are dead '");


var denizen_space_quests = ["trying to figure out why the Forge is unlit"];
denizen_space_quests.push("clearing various bullshit obstacles to lighting the Forge");
denizen_space_quests.push("lighting the Forge");  //TODO requires a magic ring.

var denizen_time_quests = ["searching through time for an unbroken legendary piece of shit weapon"];
denizen_time_quests.push("realizing that the legendary piece of shit weapon was broken WAY before they got here");
denizen_time_quests.push("alchemizing an unbroken version of the legendary piece of shit weapon to pawn off as the real thing to Hephaestus");

var denizen_breath_quests = ["realizing that the Denizen has thoroughly clogged up the pneumatic system"];
denizen_breath_quests.push("trying to manually unclog the pneumatic system");
denizen_breath_quests.push("using Breath powers to unclog the pneumatic system");

var denizen_doom_quests = ["listening to consorts relate a doomsday prophecy that will take place soon"];
denizen_doom_quests.push("realizing technicalities in the doomsday prophecy that would allow it to take place but NOT doom everyone");
denizen_doom_quests.push("narrowly averting the doomsday prophecy through technicalities, seeming coincidence, and a plan so convoluted that at the end of it no one can be sure the plan actually DID anything");

var denizen_blood_quests = ["convincing the local consorts to rise up against the Denizen"];
denizen_blood_quests.push(" give unending speeches about the power of friendship and how they are all fighting for loved ones back home to confused and impressionable consorts");
denizen_blood_quests.push("completely overthrowing the Denizen's underlings in a massive battle");

var denizen_heart_quests = ["starting an underground rebel group to free the consorts from the oppressive underling government"];
denizen_heart_quests.push("having a huge public protest against the underling government, displaying several banned fashion items");
denizen_heart_quests.push("convincing the local consorts that the only thing that can stifle their identity is their own fear");

var denizen_mind_quests = ["learning of the systemic corruption in the local consort's justice system"];
denizen_mind_quests.push("rooting out corrupt consort officials, and exposing their underling backers");
denizen_mind_quests.push("setting up a self-sufficient consort justice system");


var denizen_light_quests = ["realizing the the entire point of SBURB has been a lie"];
denizen_light_quests.push("learning the true purpose of SBURB");
denizen_light_quests.push("realizing just how important frogs and grist and the Ultimate Alchemy truly are");


var denizen_void_quests = ["???"];
denizen_void_quests.push("[redacted]");
denizen_void_quests.push("[void players, am I right?]");

//http://rumkin.com/tools/cipher/atbash.php (thinking of lOSS here)
//var denizen_rage_quests = ["~~~You can't believe how easy it is. You just have to go... a little crazy. And then, suddenly, it all makes sense, and everything you do turns to gold.~~~"]; //
//denizen_rage_quests.push("~~~ The denizen, Bacchus, thinks that grammar is important. That rules are important. That so much is important. You'll show him. ~~~");
//denizen_rage_quests.push("~~~ Nothing makes sense here anymore. Just the way you like it. The consorts are whipped into a frothing fury. Bacchus is awake.  ~~~");

var denizen_rage_quests = ["~~~You can't believe how vzhb it is. You just have to go... a little xizab. Zmw gsvm, suddenly, rg all makes sense, zmw everything blf wl gfimh gl gold. ~~~"]; //
denizen_rage_quests.push("~~~ Gsv denizen, XXXXXX, gsrmph gszg grammar rh important. Gszg rules ziv important. Gszg hl nfxs rh rnkligzmg. You'll show him.  ~~~");
denizen_rage_quests.push("~~~ Mlgsrmt nzpvh hvmhv sviv zmbnliv. Qfhg gsv dzb blf orpv rg. Gsv xlmhligh ziv dsrkkvw rmgl z uilgsrmt ufib. XXXXXX rh zdzpv.   ~~~");


var denizen_hope_quests = ["realizing that the consorts real problem is their lack of morale"];
denizen_hope_quests.push("inspiring impressionable consorts who then go on to inspire others ");
denizen_hope_quests.push("defeating the underling that was causing the local consorts to not believe in themselves");

var denizen_life_quests = ["defeating an endless array of locust underlings"];
denizen_life_quests.push("realizing that Hemera is somehow spawning the endless hoard of locust underlings ");
denizen_life_quests.push("preventing the next generation of locust underlings, thus ending the consort famine");





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


var democracyTasks = ["WV gives talks to a random carapacian boy, demanding he support democracy."," WV gathers followers using techniques learned from reading a book on carapacian etiquette. "];
democracyTasks.push(" WV demonstrates tactical knowledge to Dersites, convincing them they can win against the King. ");
democracyTasks.push(" WV gives rousing speeches to Prospitians, emphasizing that they share the same goal. ");
democracyTasks.push(" WV gives rousing speeches to Dersites, listing every crime the King and Queen have commited against their own people. ");
democracyTasks.push(" WV debates Dersite beliefs, asking if they REALLY want to die in the Reckoning rather than go live in a new Universe (loathesome though frogs may be). ");
democracyTasks.push(" WV distributes hastily scrawled parking ticket pamphlets decrying the Royals as 'Total Jerks Bluh Bluh’, much to the ire of the Dersite Parking Authority.");
democracyTasks.push(" WV arranges a covert series of blinking signals with the help of a firefly. ");


var democracySuperTasks = [" WV flips the fuck out and starts distributing free TAB soda to anyone who joins his army. "];
democracySuperTasks.push(" WV grabs a random Player and uses them as a prop during a speech, triggering the frothing devotion of the local consorts. ");
democracySuperTasks.push(" WV arranges a military training session with carapacians on both sides of the War, raising their confidence for the upcoming battle. ");
democracySuperTasks.push(" WV accidentally steals a colossal Derse war machine. Somehow. ");
democracySuperTasks.push(" WV trains other carapacians in the art of forward attacks. They are the best pawn. It is them. ");
democracySuperTasks.push(" WV and a random Player go on an alchemy spree, arming the democratic army with all manners of insane weaponry that is off both the hook and also the chain. In fact, they couldn’t manage to alchemize a single flail. Only giant spiky balls. ");


var mayorDistractionTasks = [" WV is distracted eating green objects rather than recruiting for his army. "];
mayorDistractionTasks.push( " WV is distracted planning the civil infrastructure of a city, rather than recruiting for his army.");
mayorDistractionTasks.push(" WV is distracted fantasizing about how great of a mayor he will be. ");
mayorDistractionTasks.push(" WV accidentally tried to recruit carapacians already part of his army. Stupid stupid stupid! ");
mayorDistractionTasks.push(" WV gets distracted freaking out about car safety. ");
mayorDistractionTasks.push(" WV gets distracted freaking out about how evil bad bad bad bad monarchy is. ");
mayorDistractionTasks.push(" WV gets distracted writing a constitution for the new democracy. ");

//rage and void can do these in VoidySTuff, even if it's not a quest. just for funsies. (even the heavy shit. oh look the rage player is being LOL SO RANDOM what with their decapitated head shenanigans.)
var lightQueenQuests = ["makes a general nuisance of themselves to the Black Queen.", "spreads disparaging rumours concerning the Black Queen.", "sabotages several official portraits of the Black Queen."];
lightQueenQuests = lightQueenQuests.concat(["sets up various pranks and traps around Derse.","breaks all the lights in the throne room.","vandalizes various Dersite public hotspots. Fuck the Authority Regulators!"]);
lightQueenQuests = lightQueenQuests.concat(["switches the hats of all of the Dersite high ranking officials.","steals all the licorice scottie dogs on Derse. ","convinces the Enquiring Carapacian that the Black Queen is actually three Salamanders in a robe. ", "smuggles contraband forbidden by the Black Queen. Like ice cream. And frogs. The Black Queen’s trade edicts don’t really make much sense. "]);


var moderateQueenQuests = ["completely ruins the Dersite bureaucracy's filing scheme. Now it will take WEEKS to reorganize everything. ","releases a slew of random Dersite prisoners.","alchemizes a metric shit ton of antiRoyalty propoganda and leaves it lying around in enticing wallet moduses."];
moderateQueenQuests = moderateQueenQuests.concat(["performs a daring spy mission, gaining valuable intel to use on the Black Queen. ","covers the royal palace with totally illegal frog graffiti. I mean, just look at all those poorly drawn frogs. So. Illegal. ","turns the Queens allies against her, forcing her to spend valuable time quieting their complaints and schemes. "]);
moderateQueenQuests = moderateQueenQuests.concat(["absconds with an official looking stamp from a crucial bureaucratic office, grinding the ceaseless machine of Dersite civics to a halt.","demonstrates their aptitude for immersion in local tradition and shows a royal guard their stabs. ","smuggles contraband forbidden by the Black Queen. Like weapons of revolt and regicide swords."]);


var heavyQueenQuests = ["turns one the Black Queen’s most valuable allies against her, distracting her with a minor revolution. ","convinces Dersites to rise up, leaving the head of a famed public official in front of the palace as a rallying point. "];
heavyQueenQuests = heavyQueenQuests.concat(["performs a daring assassination mission against one of the Black Queen's agents, losing her a valuable ally. ","sabotages basic services on Derse, fomenting doubt in the Queen’s competence among citizens.","destroys a series of Derse laboratories in the veil, severely damaging the Derse war effort. "]);





var tricksterColors = ["#FF0000","#00FF00","#0000FF","#FFFF00","#00FFFF","#FF00FF","#efffff","#5ef89c","#5ed6f8","#f85edd","#ffcaf6","#d0ffca","#cafcff","#fffdca","#ffd200","#a7caff","#ff6c00","#fffc00","#f5b4ff","#ffceb1","#ffcaca","#e0efc6","#c5ffed","#c5dcff","#ebdbff","#ffdbec","#ecfff4","#f0ecff","#c0ff00","#f7bfff","#dfffbf"];

var bloodColors = ["#A10000","#a25203","#a1a100","#658200","#416600","#078446","#008282","#004182","#0021cb","#631db4","#610061","#99004d"];

var interestCategories = ["Comedy","Music","Culture","Writing","Athletic", "Terrible","Justice","Fantasy","Domestic", "PopCulture","Technology","Social","Romance","Academic"];
var interests = []

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
var justice_interests = ["Social Justice","Detectives","Mysteries","Leadership","Revolution","Justice","Equality","Sherlock Holmes"]
interests = interests.concat(music_interests);
interests = interests.concat(culture_interests);
interests = interests.concat(writing_interests);
interests = interests.concat(pop_culture_interests);
interests = interests.concat(technology_interests);
interests = interests.concat(social_interests);
interests = interests.concat(romantic_interests);
interests = interests.concat(academic_interests);
interests = interests.concat(comedy_interests);
interests = interests.concat(domestic_interests);
interests = interests.concat(athletic_interests);
interests = interests.concat(terrible_interests);
interests = interests.concat(fantasy_interests);
interests = interests.concat(justice_interests);


var prefixes = ["8=D",">->","//", "tumut",")","><>","(", "$", "?", "=begin", "=end"]
prefixes = prefixes.concat(["<3","<3<","<>","c3<","{","}","[","]","'",".",",","~","!","~","^","&","#","@","%","*"]);

debug("TODO: interest quirks, is it worth it?")
var music_quirks = [];
var culture_quirks = [];
var writing_quirks = [];
var pop_culture_quirks = [];
var technology_quirks = [];
var social_quirks = [];
var romantic_quirks = [];
var academic_quirks = [];
var comedy_quirks = [];
var domestic_quirks = [];
var athletic_quirks = [];
var terrible_quirks = [];
var fantasy_quirks = [["very","fairy"]];
var justice_quirks = [];

var sbahj_quirks = [["asshole","dunkass"],["happen","hapen"],["we're","where"],["were","where"],["has","hass"],["lol","ahahahaha"],["dog","god"],["god","dog"],["know","no"]];
sbahj_quirks = sbahj_quirks.concat([["they're","there"],["their","there"],["theyre","there"],["through","threw"],["lying","lyong"],["distraction","distaction"],["garbage","gargbage"],["angel","angle"]]);
sbahj_quirks = sbahj_quirks.concat([["the","thef"],["i'd","i'd would"],["i'm","i'm am"],["don't","don't not"],["won't","won't not"],["can't","can't not"],["ing","ung"]]);
sbahj_quirks = sbahj_quirks.concat([["ink","ing"],["ed","id"],["id","ed"],["ar","aur"],["umb","unk"],["ian","an"],["es","as"],["ough","uff"]]);


var terribleCSSOptions = [["position: ", "absolute"],["position: ", "relative"],["position: ", "static"],["position: ", "fixed"],["float: ", "left"] ,["float: ", "right"],["width: ", "????"],["height: ", "????"],["right: ", "????"] ,["top: ", "????"] ,["bottom: ", "????"] ,["left: ", "????"]   ];

var fish_quirks = [["calm","clam"],["ass","bass"],["god","glub"],["god","cod"],["fuck","glub"],["really","reely"],["kill","krill"],["thing","fin"],["well","whale"],["purpose","porpoise"],["better","betta"],["help","kelp"],["see","sea"],["friend","frond"],["crazy","craysea"], ["kid","squid"], ["hell","shell"]];

//not as extreme as a troll quirk, buxt...
var conversational_quirks = [["pro","bro"],["guess","suppose"],["S\\b", "Z"],["oh my god","omg"],["like", "liek"],["ing","in"],["have to","hafta"], ["want to","wanna"],["going to","gonna"], ["i'm","i am"],["you're","you are"],["we're","we are"],["forever","5ever"], ["ever","evah"],["er","ah"],["to","ta"]];
conversational_quirks = conversational_quirks.concat([["I'm", "Imma"],["don't know", "dunno"],["school","skool"],["the","teh"],["aren't","aint"],["ie","ei"],["though","tho"],["you","u"],["right","rite"]]);
conversational_quirks = conversational_quirks.concat([["n't"," not"], ["'m'"," am"], ["kind of", "kinda"],["okay", "ok"],["\\band\\b","&"],["\\bat\\b","@"],["okay", "okey dokey"]]);

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
var fantasy_handles1 = ["musing","pacific","minotaurs","kappas","restful","serene","titans","hazy","best","peaceful","witchs","sylphic","sylvan","shivan","hellkite","malachite"]
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
var postdenizen_maid_quests = ["using their powers to help clean up the debris left from their Denizen actions. Who knew the term maid would be so literal"];
postdenizen_maid_quests.push("watching over the consorts as they begin to rebuild");
postdenizen_maid_quests.push("following their consorts to ever larger pieces of debris");
postdenizen_maid_quests.push("empowering an army of consorts to clean out the last of the debris from their Denizen");

var postdenizen_page_quests = ["learning to control their newfound prowess, accidentally wiping out a consort village or two"];
postdenizen_page_quests.push("getting all mopey about their new powers, because apparently actually being competent is too much for them");
postdenizen_page_quests.push("finishing the ‘legendary’ tests of valor with a never before seen aplomb");
postdenizen_page_quests.push("accepting the role Sburb has placed upon them. They are themselves, and that is all that needs be said on the matter");

var postdenizen_mage_quests = ["finding yet another series of convoluted puzzles, buried deep in their land. These puzzles pour poison into the land, and will continue to do so until solved"];
postdenizen_mage_quests.push("realizing the voices are gone. Not just quiet, but… gone. Without them, they can finally get down to work on their land puzzles");
postdenizen_mage_quests.push("solving the more of the puzzles of their land. Not that that's the end of the horseshit, but hey! Less horseshit always helps");
postdenizen_mage_quests.push("getting sick to death of puzzles and just utterly annihilating one with their game powers");

var postdenizen_knight_quests = ["setting up a series of knight-beacons so the consorts can call them whenever they are needed"];
postdenizen_knight_quests.push("spending way too much time hustling from village to village, saving the consorts from the denizens last few minions");
postdenizen_knight_quests.push("breaking a siege on a consort village, saving its population and slaughtering thousands of underlings");
postdenizen_knight_quests.push("finishing the ‘legendary’ tests of valor dispensed by an elder consort");

var postdenizen_rogue_quests =  ["scouring the land for targets, and then freaking out when they realize there's no bad guys left to steal from"];
postdenizen_rogue_quests.push("stealing from enemies on other players planets, acquiring enough boonbucks to lift every consort on the planet out of poverty");
postdenizen_rogue_quests.push("doing a little dance on their pile soon-to-be distributed wealth");
postdenizen_rogue_quests.push("literally stealing another player's planet. They put it back, but still. A planet. Wow");
postdenizen_rogue_quests.push("loaning money to needy consorts, then surprising them by waiving every last cent of debt they owe");


var postdenizen_sylph_quests = ["beginning to heal the vast psychological damage their consorts have endured from the denizen’s ravages"];
postdenizen_sylph_quests.push("setting up counseling booths around their land and staffing them with well trained consort professionals");
postdenizen_sylph_quests.push("bugging and fussing and meddling with the consorts, but now using their NEW FOUND POWERS");
postdenizen_sylph_quests.push("realizing that maybe their bugging and fussing and meddling isn’t always the best way to deal with things");

var postdenizen_thief_quests = ["literally stealing another player’s planet. Well, the deed to another player's planet, but still. A planet. Wow"];
postdenizen_thief_quests.push("stealing every last piece of grist in every last dungeon. Hell fucking yes");
postdenizen_thief_quests.push("crashing the consort economy when they spend their hellaciously devious wealth");
postdenizen_thief_quests.push("doing a dance on their pile of ill earned goods and wealth");


var postdenizen_heir_quests = ["recruiting denizen villages, spreading a modest nation under their (Democratic!) control"];
postdenizen_heir_quests.push("assuming control of yet more denizen villages. Turns out a mind bogglingly large number of consorts have the Heir named in their will");
postdenizen_heir_quests.push("chillaxing with their aspect and while talking to it as if it were a real person.");
postdenizen_heir_quests.push("wiping a dungeon off the map with their awe inspiring powers");

var postdenizen_bard_quests = ["musing on the nature of death as they wander from desolate consort graveyard to desolate consort graveyard"];
postdenizen_bard_quests.push("staring vacantly into the middle distance as every challenge that rises before them falls away before it even has a chance to do anything");
postdenizen_bard_quests.push("putting on a performance for a huge crowd of awestruck consorts and underlings");
postdenizen_bard_quests.push("playing pranks and generally messing around with the most powerful enemies left in the game");

var postdenizen_prince_quests =  ["thinking on endings. The end of their planet. The end of their denizen problems. The end of that very, very stupid imp that just tried to jump them"];
postdenizen_prince_quests.push("defeating every single mini boss, including a few on other players planets");
postdenizen_prince_quests.push("burning down libraries of horror terror grimoires, shedding a few tears for the valuable knowledge lost along side the accursed texts");
postdenizen_prince_quests.push("hunting down and killing the last of a particularly annoying underling class");

var postdenizen_seer_quests = ["casting their sight around the land to find the causes of their land’s devastation"];
postdenizen_seer_quests.push("taking a consort under their wing and teaching it the craft of magic");
postdenizen_seer_quests.push("predicting hundreds of thousands of variant future possibilities, only to realize that the future is too chaotic to exactly systemize");
postdenizen_seer_quests.push("alchemizing more and more complex seer aids, such as crystal balls or space-specs");

var postdenizen_witch_quests = ["alchemizing a mind crushingly huge number of computers in various forms"]
postdenizen_witch_quests.push("whizzing around their land like it's fucking christmas")
postdenizen_witch_quests.push("defeating a completely out of nowhere mini boss")
postdenizen_witch_quests.push("wondering if their sprite prototyping choice was the right one after all")

var postdenizen_generic_quests = ["cleaning up after their Denizen in a class approrpiate fashion","absolutly not goofing off instead of cleaing up after their Denizen","vaguely sweeping up rubble"];
var postdenizen_waste_quests = ["figuring out the least-disruptive way to help the local Consorts recover from the Denizen's rule","being a useless piece of shit and not joining cleanup efforts.","accidentally causing MORE destruction in an attempt to help clean up after their epic as fuck fight agains their Denizen"];
var postdenizen_scout_quests = ["finding Consorts that still need help even after the Denizen has been defeated", "scouting out areas that have opened up following the Denizen's defeat","looking for rare treasures that are no longer being guarded by the Denizen"];
var postdenizen_scribe_quests = ["documenting the various Consorts lost to the Denizen.","writing up a recovery plan for the Local Consorts","figuring out the best way to explain how to recover from the ravages of Denizen"];
var postdenizen_sage_quests = ["learning everything there is learn about the Denizen, now that it is safely defeated","learning what Consort civilization was like before the Denizen, to better help them return to 'normal'","demonstrating to the local Consorts the best way to move on from the tyranny of the Denizen"];




var postdenizen_space_quests = ["stoking the forge and preparing to create a new universe"];
postdenizen_space_quests.push("cloning ribbiting assholes till you’re up to your eyeballs in frogs");
postdenizen_space_quests.push("cleaning up volcanic debris from the Forge. Man that magma is hot");
postdenizen_space_quests.push("alchemizing geothermal power infrastructure for the consort villagers. The local consorts babble excitedly at indoor lightning ");
postdenizen_space_quests.push("making sure they don't accidentally clone a toad instead of a frog by mistake");
postdenizen_space_quests.push("messing with a variety of frogs that were previously paradox cloned");
postdenizen_space_quests.push("paradox cloning a variety of frogs, after making a serious note to mess with them later");
postdenizen_space_quests.push("combining paradox slime from multiple frogs together to make paradox offspring");
postdenizen_space_quests.push("listening to the ridiculously similar croaks of cloned frogs to figure out where their flaws are");

var postdenizen_time_quests = ["securing the alpha timeline and keeping the corpse pile from getting any taller"];
postdenizen_time_quests.push("high fiving themself an hour from now for the amazing job they're going to have done/do with the Hephaestus situation. Time is the best aspect");
postdenizen_time_quests.push("restoring the consort’s destroyed villages through time shenanigans. The consorts boggle at their newly restored houses");
postdenizen_time_quests.push("building awesome things way in the past for themselves to find later");



var postdenizen_breath_quests = ["riding the wind through the pneumatic system, delivering packages to the local consorts"];
postdenizen_breath_quests.push("doing the windy thing to clean up all of the pneumatic system’s leavings. Wow, that’s a lot of junk");
postdenizen_breath_quests.push("soothing the local consorts with a cool summer breeze");
postdenizen_breath_quests.push("whipping up a flurry of wind, the debris of Denizen rampage are blown far into the Outer Rim");

var postdenizen_doom_quests = ["assuring the local consorts that with Denizen's defeat, the prophecy has been avoided"];
postdenizen_doom_quests.push("establishing an increasingly esoteric rubric of potential post-Denizen problems and relating them in detail to the consorts. Doom players sure are cheery");
postdenizen_doom_quests.push("inferring the new possibilities of defeat should the local consorts lack vigilance");
postdenizen_doom_quests.push("finding a worryingly complete list of their own future deaths, both potential and definite");

var postdenizen_blood_quests = ["undoing the last remnants of Denizen-inflicted emotional damage in the consorts"];
postdenizen_blood_quests.push("putting together a crack team of emotionally bonded consorts to help the recovery of their land");
postdenizen_blood_quests.push("weeping tears of joy as their consorts manage to help each other instead of running to a player anytime the smallest thing goes wrong");
postdenizen_blood_quests.push("preaching a resounding message of ‘don't be a total dick all the time’ to a clamoring crowd of consorts");

var postdenizen_heart_quests = ["rescuing a copy of themselves from extreme peril"];
postdenizen_heart_quests.push("creating clones of themselves to complete a variety of bullshit puzzles and fights");
postdenizen_heart_quests.push("swapping around the souls of underlings, causing mass mayhem");
postdenizen_heart_quests.push("removing the urge to kill from the identity of underlings, rendering them harmless pacifists");

var postdenizen_mind_quests = ["forcing mini bosses to choose between two equally horrible options "];
postdenizen_mind_quests.push("binding the minds of ogres and using them as battle mounts");
postdenizen_mind_quests.push("manipulating underlings into madness and infighting");
postdenizen_mind_quests.push("navigating the countless possible outcomes of whatever bullhit colour the local consorts want to repaint this temple. Great use of their time!");

var postdenizen_light_quests = ["distracting underlings by with over the top displays of their game powers"];
postdenizen_light_quests.push("teaching the local consorts how to count cards without eating them.");
postdenizen_light_quests.push("educating themselves on the consequences of betting against the house. As it happens, there are no consequences. ");
postdenizen_light_quests.push("collecting the complete history and mythos of their land into an easy to navigate 1,000 volume encyclopedia.");

var postdenizen_void_quests = ["Wait, yes! The Void player is… nope. They’re gone."];
postdenizen_void_quests.push("doing something about their land, but it’s difficult to make out.");
postdenizen_void_quests.push("fixing temples from the ravages of… something? It’s a best guess. Those temples were totally ravaged a minute ago though.");
postdenizen_void_quests.push("somehow just doing normal quests with no void interference whatsoever. Huh");

var postdenizen_rage_quests = ["ripping underlings apart with loud, violent screams"];
postdenizen_rage_quests.push("throwing the mother of all temper tantrums");
postdenizen_rage_quests.push("fighting through millions of enemies in search of the fabled ‘chill-pill’");
postdenizen_rage_quests.push("ripping a mini boss a literal new one. Ouch");

var postdenizen_hope_quests = ["leading a huge army of zealous consorts into battle"];
postdenizen_hope_quests.push("learning ancient chants and forgotten mythos of their lands strange almost-religion");
postdenizen_hope_quests.push("willing enemies out of existence with but a thought");
postdenizen_hope_quests.push("winning an argument with gravity");

var postdenizen_life_quests = ["using the Denizen's lair to breed thousands of pollinating insects"];
postdenizen_life_quests.push("breeding a strain of plant that spreads across the planet in seconds");
postdenizen_life_quests.push("terraforming their land to be more suited to their desires");
postdenizen_life_quests.push("resurrecting an ancient civilization of consorts, complete with buildings and culture");






var human_hair_colors = ["#68410a","#fffffe", "#000000","#000000","#000000","#f3f28d","#cf6338","#feffd7","#fff3bd","#724107","#382207","#ff5a00","#3f1904","#ffd46d","#473200","#91683c"];

function getRandomColor() {
    var letters = '0123456789ABCDEF';
    var color = '#';
    for (var i = 0; i < 6; i++ ) {
        color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
}



function uniqueArrayBecauesIEIsAWhinyBitch(arr) {
    var a = [];
    for (var i=0, l=arr.length; i<l; i++)
        if (a.indexOf(arr[i]) === -1 && arr[i] !== '')
            a.push(arr[i]);
    return a;
}

function getRandomGreyColor() {
    var letters = '0123456789ABCDEF';
    var color = '#';
	var tmp = "";
    for (var i = 0; i < 2; i++ ) {
        tmp += letters[Math.floor(Math.random() * 16)];
    }
    return color+tmp+tmp+tmp; //grey is just 3 of the same 2 byte hex repeated.
}


function helloWorld(){
	$.ajax({
	  url: "hello_world.txt",
	  success:(function(data){
		  console.log(data)
	  }),
	  dataType: "text"
	});

}

//IE doesn't support "starts with"
if (!String.prototype.startsWith) {
  String.prototype.startsWith = function(searchString, position) {
    position = position || 0;
    return this.indexOf(searchString, position) === position;
  };
}
