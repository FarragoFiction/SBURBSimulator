//put all OCDataString code here.
import "dart:html";

import "SBURBSim.dart";
import 'includes/bytebuilder.dart';
import 'includes/lz-string.dart';
import 'navbar.dart';


//don't pollute global name space more than you already are, dunkass
//call this ONLY inside a function.
class CharacterEasterEggEngine {
  //test with reddit first, 'cause it's small
  List<dynamic> redditCharacters = [];
  List<dynamic> tumblrCharacters = [];
  List<dynamic> discordCharcters = [];
  var creatorCharacters = ["b=%2B*-%C3%96%C3%B4%5C%00%C3%90%2C%2C%0D&s=,,Arson,Shipping,authorBotJunior","b=%2B*-%06%C3%B4%C2%A3%00%C3%90%2C%2C%0D&s=,,Authoring,Robots,authorBot","b=%C3%A8%C3%90%C2%99E%C3%BE)%00%17%1C%1C.&s=,,100 Art Projects At Once,Memes,karmicRetribution","b=%3C%1E%07%C3%86%C3%BE%C2%A3%04%13%18%18%0D&s=,,The AuthorBot,Authoring,jadedResearcher"];
  List<dynamic> creditsBuckaroos = [];
  List<dynamic> ideasWranglers = [];
  List<dynamic> bards = [];
  List<dynamic> patrons = [];
  List<dynamic> patrons2 = [];
  List<dynamic> patrons3 = [];
  List<dynamic> canon = [];  //
  List<dynamic> otherFandoms = [];	//takes in things like this.redditCharacters and "OCs/reddit.txt"
  //parses the text file as newline seperated and load them into the array.



  CharacterEasterEggEngine() {}


  dynamic loadArrayFromFile(arr, String file, processForSim, callBack, that){
    //print("loading" + file);
   // var that = this; //TODO what the hell was i doing here, that comes from a param
    HttpRequest.getString(file).then((data) {
      // Do something with the response.
      parseFileContentsToArray(arr, data.trim());
      if(processForSim != null && callBack != null) return that.processForSim(callBack);
      if(processForSim == null && callBack != null) {
        if(that == null) {
          callBack();
        }else {
          callBack(that); //whoever calls me is responsible for knowing when all are loaded.
        }
      }
    });


  }



  void parseFileContentsToArray(arr, fileContents){
    //this[arr] = fileContents.split("\n");
	  //TODO: parse machine broken -PL

    //print(arr);
    //print(this[arr]);
  }
  void processForSim(callBack){
  	Random rand = curSessionGlobalVar.rand;
    var pool = this.getPoolBasedOnEggs(rand);
    var potentials = this.playerDataStringArrayToURLFormat(pool);
    List<dynamic> ret = [];
    List<Player> spacePlayers = findAllAspectPlayers(potentials, "Space");
    var space = rand.pickFrom(spacePlayers);
    potentials.removeFromArray(space);
    if(space == null){
      space = randomSpacePlayer(curSessionGlobalVar);
      space.chatHandle = "randomSpace";
      //print("Random space player!");
      space.quirk = new Quirk(rand);
      space.quirk.favoriteNumber = 0;
      space.deriveChatHandle = false;
    }
    var timePlayers = findAllAspectPlayers(potentials, "Time");
    var time = rand.pickFrom(timePlayers);
    potentials.removeFromArray(time);
    if(time == null){
      time = randomTimePlayer(curSessionGlobalVar);
      time.chatHandle = "randomTime";
      time.quirk = new Quirk(rand);
      time.quirk.favoriteNumber = 0;
      time.deriveChatHandle = false;
    }
    //print("space chatHandle " + space.chatHandle);
    //print(space);
    ret.add(space);
    ret.add(time);
    var numPlayers = rand.nextIntRange(2,12);
    for(int i = 2; i<numPlayers; i++){
      var p = rand.pickFrom(potentials);
      if(p) ret.add(p);
      if(p) potentials.removeFromArray(p);  //no repeats. <-- modify all the removes l8r if i want to have a mode that enables them.
    }
    //print(ret);
    for(num i = 0; i<ret.length; i++){
      var p = ret[i];
      //print(p);
      if(p.chatHandle.trim() == "") p.chatHandle = getRandomChatHandle(rand, p.class_name,p.aspect,p.interest1, p.interest2);
    }
    curSessionGlobalVar.replayers = ret;
    callBack();
  }
  void loadArraysFromFile(callBack, processForSim, that){
    //too confusing trying to only load the assest i'll need. wait for now.
    this.loadArrayFromFile("redditCharacters","OCs/reddit.txt", processForSim,null,null);
    this.loadArrayFromFile("tumblrCharacters","OCs/tumblr.txt", processForSim,null,null);
    this.loadArrayFromFile("discordCharcters","OCs/discord.txt", processForSim,null,null);
    this.loadArrayFromFile("creditsBuckaroos","OCs/creditsBuckaroos.txt", processForSim,null,null);
    this.loadArrayFromFile("ideasWranglers","OCs/ideasWranglers.txt", processForSim,null,null);
    this.loadArrayFromFile("patrons","OCs/patrons.txt", processForSim,null,null);
    this.loadArrayFromFile("patrons2","OCs/patrons2.txt", processForSim,null,null);
    this.loadArrayFromFile("patrons3","OCs/patrons3.txt", processForSim,null,null);
    this.loadArrayFromFile("canon","OCs/canon.txt", processForSim,null,null);
    this.loadArrayFromFile("bards","OCs/bards.txt", processForSim,null,null);
    this.loadArrayFromFile("otherFandoms","OCs/otherFandoms.txt", processForSim,callBack,that); //last one in list has callback so I know to do next thing.
  }
  dynamic getPoolBasedOnEggs(Random rand){
    List<dynamic> pool = [];
    //first, parse url params. for each param you find that's right, append the relevant characters into the array.
    if(getParameterByName("reddit",null)  == "true"){
      pool.addAll(this.redditCharacters);
    }

    if(getParameterByName("tumblr",null)  == "true"){
      pool.addAll(this.tumblrCharacters);
    }

    if(getParameterByName("discord",null)  == "true"){
      pool.addAll(this.discordCharcters);
    }

    if(getParameterByName("creditsBuckaroos",null)  == "true"){
      pool.addAll(this.creditsBuckaroos);
    }

    if(getParameterByName("ideasWranglers",null)  == "true"){
      pool.addAll(this.ideasWranglers);
    }

    if(getParameterByName("bards",null)  == "true"){
      pool.addAll(this.bards);
    }

    if(getParameterByName("patrons",null)  == "true"){
      pool.addAll(this.patrons);
    }

    if(getParameterByName("patrons2",null)  == "true"){
      pool.addAll(this.patrons2);
    }

    if(getParameterByName("patrons3",null)  == "true"){
      pool.addAll(this.patrons3);
    }

    if(getParameterByName("canon",null)  == "true"){
      pool.addAll(this.canon);
    }

    if(getParameterByName("otherFandoms",null)  == "true"){
      pool.addAll(this.otherFandoms);
    }


    if(getParameterByName("creators",null)  == "true"){
      pool.addAll(this.creatorCharacters);
    }

    if(pool.length == 0){
      //	print("i think i should be returning all characters.");
      pool.addAll(this.redditCharacters);
      pool.addAll(this.tumblrCharacters);
      pool.addAll(this.discordCharcters);
      pool.addAll(this.creditsBuckaroos);
      pool.addAll(this.patrons);
      pool.addAll(this.ideasWranglers);
      pool.addAll(this.canon);
      pool.addAll(this.creatorCharacters);
      pool.addAll(this.bards);
    }

    //return pool;
    return shuffle(rand, pool); //boring if the same peeps are always first.

  }
  dynamic processEasterEggsViewer(Random rand){
    var pool = this.getPoolBasedOnEggs(rand);
    return this.playerDataStringArrayToURLFormat(pool);
  }
  dynamic playerDataStringArrayToURLFormat(playerDataStringArray){
    String s = "";
    String b = "";
    //first, take each element in the array and seperate it out into s and b  (getRawParameterByName(name, url))
    for(num i = 0; i<playerDataStringArray.length; i++){
      //append all b's and all s's together
      var bs = playerDataStringArray[i];
      var tmpb = Uri.decodeComponent(bs.split("=")[1].split("&s")[0]);
      var tmps = bs.split("=")[2];
      s+= tmps+",";
      b += tmpb;
    }
    //then,
    return dataBytesAndStringsToPlayers(b,s,null);

  }
  dynamic getAllReddit(){
    return this.playerDataStringArrayToURLFormat(this.redditCharacters);
  }


}



//TODO shove methods like this into static player methods
dynamic playersToDataBytes(players){
  String ret = "";
  for(num i = 0; i<players.length; i++){
    //print("player " + i + " to data byte");
    ret += players[i].toDataBytes();
  }
  return LZString.compressToEncodedURIComponent(ret);
  //return ret;
}



dynamic playersToExtensionBytes(players){
  String ret = "";
  return ret; //not working 4 now
  /*var builder = new ByteBuilder();
  //do NOT do this because it fucks up the single player strings. i know how many players there are other ways, don't worry about it.
  //builder.appendExpGolomb(players.length) //encode how many players, doesn't have to be how many bits.
  ret += Uri.encodeComponent(builder.data).replaceAll(new RegExp(r"""#""", multiLine:true), '%23').replaceAll(new RegExp(r"""&""", multiLine:true), '%26');
  for(num i = 0; i<players.length; i++){
    //print("player " + i + " to data byte");
    ret += players[i].toDataBytesX();
  }
  return LZString.compressToEncodedURIComponent(ret);
  //return ret;*/
}





dynamic playersToDataStrings(players, includeChatHandle){
  List<dynamic> ret = [];
  for(num i = 0; i<players.length; i++){
    ret.add(players[i].toDataStrings(true));
  }
  //return Uri.encodeComponent(ret.join(",")).replace(new RegExp(r"""#""", multiLine:true), '%23').replace(new RegExp(r"""&""", multiLine:true), '%26');;
  return LZString.compressToEncodedURIComponent(ret.join(","));
}



//pair with seed for shareable url for character creator, or pair with nothing for afterlife viewer.
String generateURLParamsForPlayers(players, includeChatHandle){
  //var json = JSON.stringify(players);  //inside of players handles looking for keys
  //print(json);
  //if want localStorage , then compressToUTF16  http://pieroxy.net/blog/pages/lz-string/guide.html
  //var compressed = LZString.compressToEncodedURIComponent(json);
  //print(compressed);
  var data = playersToDataBytes(players);
  var strings = playersToDataStrings(players,true);
  var extensions = playersToExtensionBytes(players);
  return "b="+data+"&s="+strings + "&x="+extensions;

}



List<Player> dataBytesAndStringsToPlayers(String bytes, String s, String xbytes){
 // print("dataBytesAndStringsToPlayers: xbytes is: " + xbytes);
  //bytes are 11 chars per player
  //strings are 5 csv per player.
  //print(bytes);
  //print(bytes.length);
  List<String> strings = s.split(",");
  List<Player> players = [];
  //print(bytes);
  for(num i = 0; i<bytes.length/11; i+=1){;
    //print("player i: " + i + " being parsed from url");
    var bi = i*11; //i is which player we are on, which is 11 bytes long
    var si = i*5; //or 5 strings long
    var b = bytes.substring(bi, bi+11);
    //List<dynamic> s = [];
    var s = strings.sublist(si, si +5);  //TODO used to be "slice" in js, is it still?
    //print("passing b to player parser");
    //print(b);
    var p = (dataBytesAndStringsToPlayer(b,s));
    p.id = i; //will be overwritten by sim, but viewer needs it
    players.add(p);
  }
  //if(extensionString) player.readInExtensionsString(extensionString);
  if(!xbytes.isEmpty) applyExtensionStringToPlayers(players, xbytes);
  return players;

}



void applyExtensionStringToPlayers(players, xbytes){
  var reader = new ByteReader(stringToByteArray(xbytes), 0);
  for(num i = 0; i<players.length; i++){
    players[i].readInExtensionsString(reader);
  }
}



dynamic stringToByteArray(str){
  throw"TODO: do I need to turn string to array buffer anymore???";
  /*
  var buffer = new ArrayBuffer(str.length);
  var uint8View = new Uint8Array(buffer);
  for(num i = 0; i<str.length; i++){
    uint8View[i] = str.charCodeAt(i);
  }
  return buffer;*/
}



//TODO FUTUREJR, REMOVE THIS METHOD AND INSTAD RELY ON session.RenderingEngine.renderers[1].dataBytesAndStringsToPlayer
//see player.js toDataBytes and toDataString to see how I expect them to be formatted.
dynamic dataBytesAndStringsToPlayer(String charString, str_arr){
  var player = new Player();
  player.quirk = new Quirk(null);
  //print("strings is: " + str_arr);
  //print("chars is: " + charString);
  player.causeOfDrain = sanitizeString(Uri.decodeFull(str_arr[0]).trim());
  player.causeOfDeath = sanitizeString(Uri.decodeFull(str_arr[1]).trim());
  player.interest1 = sanitizeString(Uri.decodeFull(str_arr[2]).trim());
  player.interest2 = sanitizeString(Uri.decodeFull(str_arr[3]).trim());
  player.chatHandle = sanitizeString(Uri.decodeFull(str_arr[4]).trim());
  //for bytes, how to convert uri encoded string into char string into unit8 buffer?
  //holy shit i haven't had this much fun since i did the color replacement engine a million years ago. this is exactlyt he right flavor of challenging.
  //print("charString is: " + charString);
  player.hairColor = intToHexColor((charString.codeUnitAt(0) << 16) + (charString.codeUnitAt(1) << 8) + (charString.codeUnitAt(2)) );
  player.class_name = intToClassName(charString.codeUnitAt(3) >> 4);
  //print("I believe the int value of the class name is: " + (charString.codeUnitAt(3) >> 4) + " which is: " + player.class_name);
  player.aspect = intToAspect(charString.codeUnitAt(3) & 15) ;//get 4 bits on end;
  player.victimBlood = intToBloodColor(charString.codeUnitAt(4) >> 4);
  player.bloodColor = intToBloodColor(charString.codeUnitAt(4) & 15);
  player.interest1Category = intToInterestCategory(charString.codeUnitAt(5) >> 4);
  player.interest2Category = intToInterestCategory(charString.codeUnitAt(5) & 15);
  player.grimDark = charString.codeUnitAt(6) >> 5;
  player.isTroll = 0 != ((1<<4) & charString.codeUnitAt(6)); //only is 1 if character at 1<<4 is 1 in charString
  player.isDreamSelf = 0 != ((1<<3) & charString.codeUnitAt(6));
  player.godTier = 0 != ((1<<2) & charString.codeUnitAt(6));
  player.murderMode = 0 != ((1<<1) & charString.codeUnitAt(6));
  player.leftMurderMode = 0 != ((1) & charString.codeUnitAt(6));
  player.robot = 0 != ((1<<7) & charString.codeUnitAt(7));
  var moon = 0 != ((1<<6) & charString.codeUnitAt(7));
  //print("moon binary is: " + moon);
  player.moon = moon ? "Prospit" : "Derse";
  //print("moon string is: "  + player.moon);
  player.dead = 0 != ((1<<5) & charString.codeUnitAt(7));
  //print("Binary string is: " + charString[7]);
  player.godDestiny = 0 != ((1<<4) & charString.codeUnitAt(7));
  player.quirk.favoriteNumber = charString.codeUnitAt(7) & 15;
  print("Player favorite number is: ${player.quirk.favoriteNumber}");
  player.leftHorn = charString.codeUnitAt(8);
  player.rightHorn = charString.codeUnitAt(9);
  player.hair = charString.codeUnitAt(10);
  if(player.interest1Category != null) interestCategoryToInterestList(player.interest1Category ).add(player.interest1); //maybe don't add if already exists but whatevs for now.
  if(player.interest2Category != null)interestCategoryToInterestList(player.interest2Category ).add(player.interest2);

  return player;
}
