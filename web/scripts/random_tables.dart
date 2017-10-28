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
class Zalgo {
    static Map<int, List<String>> chars = <int, List<String>>{
        0: <String>[ /* up */
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
            '\u031a' /*     ̚     */
        ],
        1: <String>[ /* down */
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
            '\u0323' /*     ̣     */
        ],
        2: <String>[ /* mid */
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

    static num random([int len]) {
        var rng = new Math.Random();
        if (len == 1) return 0;
        return len != null ? (rng.nextDouble() * len + 1).floor() - 1 : rng.nextDouble();
    }

    static String generate(str) {
        var str_arr = str.split(''),
            output = str_arr.map((a) {
                ;
                if (a == " ") return a;
                for (var i = 0, l = Zalgo.random(16);
                i < l; i++) {
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
dynamic getRandomElementFromArrayNoSeed(array) {
    num min = 0;
    var max = array.length - 1;
    var i = (random() * (max - min + 1)).floor() + min;
    return array[i];
}


String getRandomElementFromArrayThatStartsWith(Random rand, List<String> array, String letter) {
    List<String> array2 = makeFilteredCopyForLetters(array, letter);
    if (array2.length == 0) return null;
    num min = 0;
    num max = array2.length - 1;
    var i = (rand.nextDouble() * (max - min + 1)).floor() + min;
    return array2[i];
}


//regular filter modifies the array. do not want this. bluh.
List<String> makeFilteredCopyForLetters(List<String> array, String letter) {
    List<String> tmp = [];
    for (num i = 0; i < array.length; i++) {
        String word = array[i];
        if (word.startsWith(letter)) {
            tmp.add(word);
        }
    }
    return tmp;
}


String turnArrayIntoHumanSentence(List<dynamic> retArray) {
    return [retArray.sublist(0, retArray.length - 1).join(', '), retArray.last].join(retArray.length < 2 ? '' : ' and ');
}


//use class,aspect, and interests to generate a 16 element level array.
//need to happen ahead of time and have more variety to display on
//echeladder graphic.  4 interests total
dynamic getLevelArray(Player player) {
    List<dynamic> ret = [];

    for (int i = 0; i < 16; i++) {
        if (i % 4 == 3 && i > 4) { //dont start with claspects
            //get the i/4th element from the class level array.
            //if i =7, would get element 1. if i = 15, would get element 3.
            ret.add(player.class_name.levels[((i - 6) / 4).round()]); //don't listen to even further pastJR up there, ther eis no logic here.
        } else if (i % 4 == 2 && i > 4) {
            ret.add(player.aspect.levels[((i - 5) / 4).round()]); //5 because fuck you futureJR, that's why.
        } else if (i % 4 == 1) {
            if (i < 8) {
                ret.add(player.interest1.category.levels[(i/4).round()]);
            } else {
                //only 0 and 2 are valid, so if 3 or 4, go backwards.
                ret.add(player.interest2.category.levels[((i-8)/4).round()]);
            }
        } else if (i % 4 == 0 || i < 4) {
            ret.add(getLevelFromFree(player.session.rand)); //don't care about repeats here. should be long enough.
        }
    }
    return ret;
}


List<String> getRandomLandFromPlayer(Player player) {
    return randomFromTwoArrays(player.session.rand, player.aspect.landNames, free_land_titles);
}


//handle can either be about interests, or your claspect. each word can be separately origined
String getRandomChatHandle(Random rand, SBURBClass class_name, Aspect aspect, Interest interest1, Interest interest2) {
    ////print("Class: " + class_name + "aspect: " + aspect);
    String first = "";
    double r = rand.nextDouble();
    if (r > 0.3) {
        first = getInterestHandle1(rand, class_name, interest1);
    } else if (r > .6) {
        first = getInterestHandle1(rand, class_name, interest2);
    } else {
        first = rand.pickFrom(class_name.handles);
    }
    if (first == null || first == "") {
        first = rand.pickFrom(class_name.handles); //might have forgot to have a interest handle of the right letter.
    }
    String second = "";
    if (r > .3) {
        second = getInterestHandle2(rand, aspect, interest1);
    } else if (r > .6) {
        second = getInterestHandle2(rand, aspect, interest2);
    } else {
        second = rand.pickFrom(aspect.handles);
    }
    if (second == null || second == "") {
        second = rand.pickFrom(aspect.handles);
    }
    if (first == null) first = "mystery";
    if (second == null) second = "Mystery";
    return "$first$second";
}


dynamic getInterestHandle1(Random rand, SBURBClass class_name, Interest interest) {
    return getRandomElementFromArrayThatStartsWith(rand, interest.category.handles1, class_name.name.toLowerCase()[0]);
}


//not just rand.pick from, do not replace this yet
dynamic getInterestHandle2(Random rand, Aspect aspect, Interest interest) {
    return getRandomElementFromArrayThatStartsWith(rand, interest.category.handles2, aspect.name.toUpperCase()[0]);
}

String getBlandHandle2(Random rand, Aspect aspect) {
    return rand.pickFrom(aspect.handles);
}


String getLevelFromFree(Random rand) {
    return rand.pickFrom(free_levels);
}


String truncateString(String str, int length) {
    return str.length > length ? "${str.substring(0, length > 3 ? length - 3 : length)}..." : str;
}

String sanitizeString(String string) {
    return truncateString(string.replaceAll(new RegExp(r"""<(,?:.|\n)*?>""", multiLine: true), '').replaceAll(new RegExp(",", multiLine: true), ''), 144); //good enough for twitter.
}

List<T> randomFromTwoArrays<T>(Random rand, List<T> arr1, List<T> arr2) {
    if (rand.nextDouble() > .5) {
        return [rand.pickFrom(arr2), rand.pickFrom(arr1)];
    } else {
        return [rand.pickFrom(arr1), rand.pickFrom(arr2)];
    }
}

List<T> randomFromTwoArraysOrdered<T>(Random rand, List<T> arr1, List<T> arr2) {
    return [rand.pickFrom(arr1), rand.pickFrom(arr2)];
}


dynamic indexToWords(i) {
    if (i > 11) return "???";
    List<String> words = <String>["first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth", "eleventh", "twelfth"];
    return words[i];
}


void debug(String str) {
    querySelector("#debug").appendHtml("<br>" + str, treeSanitizer: NodeTreeSanitizer.trusted);
}


//why does this not work with seeded randomness?
List<T> shuffle<T>(Random rand, List<T> array) {
    int currentIndex = array.length,
        randomIndex;
    T temporaryValue;

    // While there remain elements to shuffle...
    while (0 != currentIndex) {
        // Pick a remaining element...
        randomIndex = rand.nextInt(currentIndex); //(rand.nextDouble() * currentIndex).floor();
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


void removeFromArray(item, array) {
    var index = array.indexOf(item);
    if (index != -1) array.removeAt(index);
}


dynamic classNameToInt(SBURBClass class_name) {
    return class_name.id;
}


SBURBClass intToClassName(int id) {
    return SBURBClassManager.findClassWithID(id);
}

dynamic bloodColorToBoost(color) {
    return 2 * bloodColorToInt(color); //high blood are STRONG why is this always returning 45??? huh, thinks color is numb.
}


dynamic bloodColorToInt(color) {
    if (color == "#ff0000") return 14;
    if (color == "#ffc3df") return 13;
    if (color == null) return 15;
    var ret = bloodColors.indexOf(color);
    return ret;
}


dynamic intToBloodColor(num) {
    if (num == 15) return null; //bubble gum pink not an option 'cause my special snowlake fan troll needs to stay special
    if (num == 14) return "#ff0000";
    if (num == 13) return "#ffc3df";
    return bloodColors[num];
}


dynamic hexColorToInt(color) {
    return int.parse(color.replaceAll("#", ""), radix: 16, onError: (String s) => 0xFFFFFF);
}


String intToHexColor(int num) {
    ////print("int is " + num);
    var tmp = num.toRadixString(16);
    var padding = 6 - tmp.length;
    for (int i = 0; i < padding; i++) {
        tmp = "0" + tmp;
    }
    ////print("which i think is: " + tmp + " in hex");
    return "#" + tmp;
}

String moonToColor(moon) {
    if (moon == "Prospit") {
        return "#ffff00";
    } else {
        return "#f092ff";
    }
}


List<String> moons = <String>["Prospit", "Derse"];


//google is an in joke because apparently google reports that all sessions are crashed and it is beautiful and google is a horrorterror.
List<String> corruptedOtherLandTitles = [Zalgo.generate("Google"), Zalgo.generate("Horrorterrors"), Zalgo.generate("Glitches"), Zalgo.generate("Grimoires"), Zalgo.generate("Fluthlu"), Zalgo.generate("The Zoologically Dubious")];

//typoed special snowlake once insteada snowflake, and now it's a land.
List<String> free_land_titles = <String>["Snowlake", "Heat", "Sand", "Brains", "Haze", "Tea", "Flow", "Maps", "Caves", "Tents", "Wrath", "Rays", "Glass", "Lava", "Magma"]..addAll(<String>["Shade", "Frost", "Rain", "Fog", "Trees", "Flowers", "Books", "Technology", "Ice", "Water", "Waterfalls", "Rocks"])..addAll(<String>["Forests", "Grass", "Tundra", "Thunder", "Winter", "Peace", "Food", "Shoes", "Weasels", "Deserts", "Dessert", "Lightning"])..addAll(<String>["Suburbs", "Cities", "Neighborhoods", "Isolation", "Schools", "Farms", "Annoyance", "Hunger", "Cake", "Tricks", "Ruins", "Temples", "Towers"])..addAll(<String>["Nails", "Smoke", "Curses", "Flood", "Ooze", "Mud", "Weeds", "Vines", "Courts", "Clay", "Halls", "Choirs", "Mushrooms", "Locks"])..addAll(<String>["Slums", "Balloons", "Rumbling", "Warfare", "Cliffs", "Needles", "Mountains", "Shadows", "Circuitry", "Fences", "Webs"])..addAll(<String>[
    "Bone", "Arenas", "Wonder", "Fluff", "Cotton", "Domes", "Gold", "Silver", "Bronze", "Ruby", "Ribbon"])..addAll(<String>["Hair", "Teeth", "Tendrils", "Mouths", "Paint", "Pain", "Wood", "Colors", "Echoes", "Fossils", "Roses", "Tulips", "Mummies", "Zombies", "Corpses"])..addAll(<String>["Mysteries", "Splendor", "Luxury", "Cash", "Coins", "Crystals", "Gemstones", "Cards", "Tarot", "Wagons", "Puzzles", "Mayhem", "Redundancy", "Redundancy"])..addAll(<String>["Obsolescence", "Deceit", "Ruse", "Distraction", "Libraries", "Blocks", "Video Games", "Vermin", "Butchers", "Meat", "Clouds", "Horses"])..addAll(corruptedOtherLandTitles);


List<String> free_levels = <String>["NIPPER CADET", "PESKY URCHIN", "BRAVESPROUT", "JUVESQUIRT", "RUMPUS BUSTER", "CHAMP-FRY", "ANKLEBITER", "CALLOUSED TENDERFOOT", "RASCALSPRAT", "GRITTY MIDGET", "BRITCHES RIPPER", "ALIEN URCHIN", "NESTING NEWB"];
//only need two for each. since each player has two interests, combines to 4

List<String> level_bg_colors = <String>["#8ff74a", "#ba1212", "#ffffee", "#f0ff00", "#9c00ff", "#2b6ade", "#003614", "#f8e69f", "#0000ff", "#eaeaea", "#ff9600", "#581212", "#ffa6ac", "#1f7636", "#ffe1fc", "#fcff00"];
List<String> level_font_colors = <String>["#264d0c", "#ff00d2", "#ff0000", "#626800", "#da92e0", "#022e41", "#aaffa6", "#000052", "#6dffdb", "#e5d200", "#00911b", "#ff0000", "#5e005f", "#fbff8d", "#000000", "#"];

//if bike quests are too common, lock them to real selves only, no dream selves.
List<String> bike_quests = <String>["performing the SWEETEST bike stunts in all of SBURB", "doing bike stunts so sick they are illegal by Dersite standards", "doing bike stunts with air so unreal time just stops and everybody wishes to be them", "performing an endless grind on prospit's moon chain"]..add("getting air so unreal that they jump from one planet to another on their sick nasty bike")..add("writing dope as fuck Bike Stunt FAQs to keep their sanity")..add("singing a song, you know, from that shitty kids cartoon? 'wake up in the morning there's a brand new day ahead the sun is bright and the clouds smile down and all your friends are dead '");

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


List<String> democracyTasks = <String>["WV gives talks to a random carapacian boy, demanding he support democracy.", " WV gathers followers using techniques learned from reading a book on carapacian etiquette. "]..add(" WV demonstrates tactical knowledge to Dersites, convincing them they can win against the King. ")..add(" WV gives rousing speeches to Prospitians, emphasizing that they share the same goal. ")..add(" WV gives rousing speeches to Dersites, listing every crime the King and Queen have commited against their own people. ")..add(" WV debates Dersite beliefs, asking if they REALLY want to die in the Reckoning rather than go live in a new Universe (loathesome though frogs may be). ")..add(" WV distributes hastily scrawled parking ticket pamphlets decrying the Royals as 'Total Jerks Bluh Bluh’, much to the ire of the Dersite Parking Authority.")..add(" WV arranges a covert series of blinking signals with the help of a firefly. ");


List<String> democracySuperTasks = <String>[" WV flips the fuck out and starts distributing free TAB soda to anyone who joins his army. "]..add(" WV grabs a random Player and uses them as a prop during a speech, triggering the frothing devotion of the local consorts. ")..add(" WV arranges a military training session with carapacians on both sides of the War, raising their confidence for the upcoming battle. ")..add(" WV accidentally steals a colossal Derse war machine. Somehow. ")..add(" WV trains other carapacians in the art of forward attacks. They are the best pawn. It is them. ")..add(" WV and a random Player go on an alchemy spree, arming the democratic army with all manners of insane weaponry that is off both the hook and also the chain. In fact, they couldn’t manage to alchemize a single flail. Only giant spiky balls. ");


List<String> mayorDistractionTasks = <String>[" WV is distracted eating green objects rather than recruiting for his army. "]..add(" WV is distracted planning the civil infrastructure of a city, rather than recruiting for his army.")..add(" WV is distracted fantasizing about how great of a mayor he will be. ")..add(" WV accidentally tried to recruit carapacians already part of his army. Stupid stupid stupid! ")..add(" WV gets distracted freaking out about car safety. ")..add(" WV gets distracted freaking out about how evil bad bad bad bad monarchy is. ")..add(" WV gets distracted writing a constitution for the new democracy. ");

//rage and void can do these in VoidySTuff, even if it's not a quest. just for funsies. (even the heavy shit. oh look the rage player is being LOL SO RANDOM what with their decapitated head shenanigans.)
List<String> lightQueenQuests = <String>["makes a general nuisance of themselves to the Black Queen.", "spreads disparaging rumours concerning the Black Queen.", "sabotages several official portraits of the Black Queen."]..addAll(<String>["sets up various pranks and traps around Derse.", "breaks all the lights in the throne room.", "vandalizes various Dersite public hotspots. Fuck the Authority Regulators!"])..addAll(<String>["switches the hats of all of the Dersite high ranking officials.", "steals all the licorice scottie dogs on Derse. ", "convinces the Enquiring Carapacian that the Black Queen is actually three Salamanders in a robe. ", "smuggles contraband forbidden by the Black Queen. Like ice cream. And frogs. The Black Queen’s trade edicts don’t really make much sense. "]);


List<String> moderateQueenQuests = <String>["completely ruins the Dersite bureaucracy's filing scheme. Now it will take WEEKS to reorganize everything. ", "releases a slew of random Dersite prisoners.", "alchemizes a metric shit ton of antiRoyalty propoganda and leaves it lying around in enticing wallet moduses."]..addAll(<String>["performs a daring spy mission, gaining valuable intel to use on the Black Queen. ", "covers the royal palace with totally illegal frog graffiti. I mean, just look at all those poorly drawn frogs. So. Illegal. ", "turns the Queens allies against her, forcing her to spend valuable time quieting their complaints and schemes. "])..addAll(<String>[
    "absconds with an official looking stamp from a crucial bureaucratic office, grinding the ceaseless machine of Dersite civics to a halt.", "demonstrates their aptitude for immersion in local tradition and shows a royal guard their stabs. ", "smuggles contraband forbidden by the Black Queen. Like weapons of revolt and regicide swords."]);


List<String> heavyQueenQuests = <String>["turns one the Black Queen’s most valuable allies against her, distracting her with a minor revolution. ", "convinces Dersites to rise up, leaving the head of a famed public official in front of the palace as a rallying point. "]
    ..addAll(<String>["performs a daring assassination mission against one of the Black Queen's agents, losing her a valuable ally. ", "sabotages basic services on Derse, fomenting doubt in the Queen’s competence among citizens.", "destroys a series of Derse laboratories in the veil, severely damaging the Derse war effort. "]);


List<Colour> tricksterColors = <Colour>[
    new Colour.fromStyleString("#FF0000"),
    new Colour.fromStyleString("#00FF00"),
    new Colour.fromStyleString("#0000FF"),
    new Colour.fromStyleString("#FFFF00"),
    new Colour.fromStyleString("#00FFFF"),
    new Colour.fromStyleString("#FF00FF"),
    new Colour.fromStyleString("#efffff"),
    new Colour.fromStyleString("#5ef89c"),
    new Colour.fromStyleString("#5ed6f8"),
    new Colour.fromStyleString("#f85edd"),
    new Colour.fromStyleString("#ffcaf6"),
    new Colour.fromStyleString("#d0ffca"),
    new Colour.fromStyleString("#cafcff"),
    new Colour.fromStyleString("#fffdca"),
    new Colour.fromStyleString("#ffd200"),
    new Colour.fromStyleString("#a7caff"),
    new Colour.fromStyleString("#ff6c00"),
    new Colour.fromStyleString("#fffc00"),
    new Colour.fromStyleString("#f5b4ff"),
    new Colour.fromStyleString("#ffceb1"),
    new Colour.fromStyleString("#ffcaca"),
    new Colour.fromStyleString("#e0efc6"),
    new Colour.fromStyleString("#c5ffed"),
    new Colour.fromStyleString("#c5dcff"),
    new Colour.fromStyleString("#ebdbff"),
    new Colour.fromStyleString("#ffdbec"),
    new Colour.fromStyleString("#ecfff4"),
    new Colour.fromStyleString("#f0ecff"),
    new Colour.fromStyleString("#c0ff00"),
    new Colour.fromStyleString("#f7bfff"),
    new Colour.fromStyleString("#dfffbf")
];

List<String> bloodColors = <String>["#A10000", "#a25203", "#a1a100", "#658200", "#416600", "#078446", "#008282", "#004182", "#0021cb", "#631db4", "#610061", "#99004d"];


List<String> prefixes = <String>["8=D", ">->", "//", "tumut", ")", "><>", "(", "\$", "?", "=begin", "=end"]
    ..addAll(<String>["<3", "<3<", "<>", "c3<", "{", "}", "<String>[", "]", "'", ".", ",", "~", "!", "~", "^", "&", "#", "@", "%", "*"]);


List<List<String>> sbahj_quirks = <List<String>>[<String>["asshole", "dunkass"], <String>["happen", "hapen"], <String>["we're", "where"], <String>["were", "where"], <String>["has", "hass"], <String>["lol", "ahahahaha"], <String>["dog", "god"], <String>["god", "dog"], <String>["know", "no"]]..addAll(<List<String>>[<String>["they're", "there"], <String>["their", "there"], <String>["theyre", "there"], <String>["through", "threw"], <String>["lying", "lyong"], <String>["distraction", "distaction"], <String>["garbage", "gargbage"], <String>["angel", "angle"]])..addAll(<List<String>>[<String>["the", "thef"], <String>["i'd", "i'd would"], <String>["i'm", "i'm am"], <String>["don't", "don't not"], <String>["won't", "won't not"], <String>["can't", "can't not"], <String>["ing", "ung"]])..addAll(<List<String>>[<String>["ink", "ing"], <String>["ed", "id"], <String>["id", "ed"], <String>["ar", "aur"], <String>["umb", "unk"], <String>["ian", "an"], <String>["es", "as"], <String>["ough", "uff"]]);


List<List<String>> terribleCSSOptions = <List<String>>[<String>["position", "absolute"], <String>["position", "relative"], <String>["position: ", "static"], <String>["position", "fixed"], <String>["float", "left"], <String>["float", "right"], <String>["width", "????"], <String>["height", "????"], <String>["right", "????"], <String>["top", "????"], <String>["bottom", "????"], <String>["left", "????"]];

List<List<String>> fish_quirks = <List<String>>[<String>["calm", "clam"], <String>["ass", "bass"], <String>["god", "glub"], <String>["god", "cod"], <String>["fuck", "glub"], <String>["really", "reely"], <String>["kill", "krill"], <String>["thing", "fin"], <String>["well", "whale"], <String>["purpose", "porpoise"], <String>["better", "betta"], <String>["help", "kelp"], <String>["see", "sea"], <String>["friend", "frond"], <String>["crazy", "craysea"], <String>["kid", "squid"], <String>["hell", "shell"]];

//not as extreme as a troll quirk, buxt...
List<List<String>> conversational_quirks = <List<String>>[<String>["pro", "bro"], <String>["guess", "suppose"], <String>["S\\b", "Z"], <String>["oh my god", "omg"], <String>["like", "liek"], <String>["ing", "in"], <String>["have to", "hafta"], <String>["want to", "wanna"], <String>["going to", "gonna"], <String>["i'm", "i am"], <String>["you're", "you are"], <String>["we're", "we are"], <String>["forever", "5ever"], <String>["ever", "evah"], <String>["er", "ah"], <String>["to", "ta"]]..addAll(<List<String>>[<String>["I'm", "Imma"], <String>["don't know", "dunno"], <String>["school", "skool"], <String>["the", "teh"], <String>["aren't", "aint"], <String>["ie", "ei"], <String>["though", "tho"], <String>["you", "u"], <String>["right", "rite"]])..addAll(<List<String>>[<String>["n't", " not"], <String>["'m'", " am"], <String>["kind of", "kinda"], <String>["okay", "ok"], <String>["\\band\\b", "&"], <String>["\\bat\\b", "@"], <String>["okay", "okey dokey"]]);

List<List<String>> very_quirks = <List<String>>[<String>["\\bvery\\b", "adequately"], <String>["\\bvery\\b", "really"], <String>["\\bvery\\b", "super"], <String>["\\bvery\\b", "amazingly"], <String>["\\bvery\\b", "hella"], <String>["\\bvery\\b", "extremely"], <String>["\\bvery\\b", "absolutely"], <String>["\\bvery\\b", "mega"], <String>["\\bvery\\b ", "extra"], <String>["\\bvery\\b", "ultra"], <String>["\\bvery\\b", "hecka"], <String>["\\bvery\\b", "totes"]];
List<List<String>> good_quirks = <List<String>>[<String>["\\bgood\\b", "good"], <String>["\\bgood\\b", "agreeable"], <String>["\\bgood\\b", "marvelous"], <String>["\\bgood\\b", "ace"], <String>["\\bgood\\b", "wonderful"], <String>["\\bgood\\b", "sweet"], <String>["\\bgood\\b", "dope"], <String>["\\bgood\\b", "awesome"], <String>["\\bgood\\b", "great"], <String>["\\bgood\\b", "radical"], <String>["\\bgood\\b", "perfect"], <String>["\\bgood\\b", "amazing"], <String>["\\bgood\\b", "super good"], <String>["\\bgood\\b", "acceptable"]];
List<List<String>> asshole_quirks = <List<String>>[<String>["asshole", "dickhead"],<String>["asshole", "fucknut"], <String>["asshole", "pukestain"], <String>["asshole", "dirtbag"], <String>["asshole", "fuckhead"], <String>["asshole", "asshole"], <String>["asshole", "dipshit"], <String>["asshole", "garbage person"], <String>["asshole", "fucker"], <String>["asshole", "poopy head"], <String>["asshole", "shit sniffer"], <String>["asshole", "jerk"],<String>["asshole", "douchecanoe"],<String>["asshole", "douche"], <String>["asshole", "plebeian"], <String>["asshole", "fuckstain"], <String>["asshole", "douchebag"], <String>["asshole", "fuckface"], <String>["asshole", "fuckass"]];
List<List<String>> lol_quirks = <List<String>>[<String>["lol", "lol"], <String>["lol", "haha"], <String>["lol", "ehehe"], <String>["lol", "heh"], <String>["lol", "omg lol"], <String>["lol", "rofl"], <String>["lol", "funny"], <String>["lol", " "], <String>["lol", "hee"], <String>["lol", "lawl"], <String>["lol", "roflcopter"], <String>["lol", "..."], <String>["lol", "bwahah"], <String>["lol", "*giggle*"], <String>["lol", ":)"]];
List<List<String>> greeting_quirks = <List<String>>[<String>["\\bhey\\b", "hey"], <String>["\\bhey\\b", "hi"], <String>["\\bhey\\b", "hello"], <String>["\\bhey\\b", "greetings"], <String>["\\bhey\\b", "yo"], <String>["\\bhey\\b", "sup"]];
List<List<String>> dude_quirks = <List<String>>[<String>["dude", "guy"], <String>["dude", "guy"], <String>["dude", "man"], <String>["dude", "you"], <String>["dude", "friend"], <String>["dude", "asshole"], <String>["dude", "fella"], <String>["dude", "bro"]];
List<List<String>> curse_quirks = <List<String>>[<String>["fuck", "beep"],<String>["fuck", "piss"],  <String>["fuck", "motherfuck"], <String>["\\bfuck\\b", "um"], <String>["\\bfuck\\b", "fuck"], <String>["\\bfuck\\b", "shit"], <String>["\\bfuck\\b", "cocks"], <String>["\\bfuck\\b", "nope"], <String>["\\bfuck\\b", "goddammit"], <String>["\\bfuck\\b", "damn"], <String>["\\bfuck\\b", "..."], <String>["\\bfuck\\b", "...great."], <String>["\\bfuck\\b", "crap"], <String>["\\bfuck\\b", "fiddlesticks"], <String>["\\bfuck\\b", "darn"], <String>["\\bfuck\\b", "dang"], <String>["\\bfuck\\b", "omg"]];
//problem: these are likely to be inside of other words.
List<List<String>> yes_quirks = <List<String>>[<String>["\\byes\\b", "certainly"], <String>["\\byes\\b", "indeed"], <String>["\\byes\\b", "yes"], <String>["\\byes\\b", "yeppers"], <String>["\\byes\\b", "right"], <String>["\\byes\\b", "yeah"], <String>["\\byes\\b", "yep"], <String>["\\byes\\b", "sure"], <String>["\\byes\\b", "okay"]];
List<List<String>> no_quirks = <List<String>>[<String>["\\bnope\\b", "no"], <String>["\\bnope\\b", "absolutely no"], <String>["\\bnope\\b", "no"], <String>["\\bnope\\b", "no"], <String>["\\bnope\\b", "nope"], <String>["\\bnope\\b", "no way"]];

//abandoned these early on because was annoyed at having to figure out how escapes worked. picking back up now.
List<List<String>> smiley_quirks = <List<String>>[<String>[":\\)", ":)"], <String>[":\\)", ":0)"], <String>[":\\)", ":]"], <String>[":\\)", ":B"], <String>[":\\)", ">: ]"], <String>[":\\)", ":o)"], <String>[":\\)", "^_^"], <String>[":\\)", ";)"], <String>[":\\)", "~_^"], <String>[":\\)", "0u0"], <String>[":\\)", "uwu"], <String>[":\\)", "¯\_(ツ)_/¯ "], <String>[":\\)", ":-)"], <String>[":\\)", ":3"], <String>[":\\)", "XD"], <String>[":\\)", "8D"], <String>[":\\)", ":>"], <String>[":\\)", "=]"], <String>[":\\)", "=}"], <String>[":\\)", "=)"], <String>[":\\)", "o->-<"]];





List<String> human_hair_colors = <String>["#68410a", "#fffffe", "#000000", "#000000", "#000000", "#f3f28d", "#cf6338", "#feffd7", "#fff3bd", "#724107", "#382207", "#ff5a00", "#3f1904", "#ffd46d", "#473200", "#91683c"];

String getRandomColor() {
    String letters = '0123456789ABCDEF';
    String color = '#';
    for (num i = 0; i < 6; i++) {
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
    for (num i = 0; i < 2; i++) {
        tmp += letters[(random() * 16).floor()];
    }
    return color + tmp + tmp + tmp; //grey is just 3 of the same 2 byte hex repeated.
}


/*void helloWorld(){
	$.ajax({
	  url: "hello_world.txt",
	  success:((data){
		  //print(data);
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
