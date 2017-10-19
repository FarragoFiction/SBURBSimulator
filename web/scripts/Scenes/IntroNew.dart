import "dart:html";
import "../SBURBSim.dart";

/*
New and improved dialogue. Don't wanna fuck with narration too much. It's terrifying and also SUPPOSED to be rote.
 */
class IntroNew extends IntroScene {

    Player player = null;
    Player friend = null;
    bool goodLand = false;


    IntroNew(Session session): super(session, false);
  @override
  void renderContent(Element div, int i) {
      doNarration(div,i);
      String chat = "";
      if(player.dead) {
        //do nothing.
      }else if(friend != null && player.grimDark <2) {
          List<Conversation> convos = getConversations();
          String player1Start = player.chatHandleShort() + ": ";
          String player2Start = friend.chatHandleShortCheckDup(player.chatHandleShort()) + ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
          //will only have one convo if it's a foreign player. make it long.
          chat = convos[0].returnStringConversation(player, friend, player1Start, player2Start,friend.getRelationshipWith(player).value > 0);
          if(convos.length > 1) chat += convos[1].returnStringConversation(player, friend, player1Start, player2Start,player.object_to_prototype.getStat(Stats.POWER)>100*Stats.POWER.coefficient);
          if(convos.length > 2)chat += convos[2].returnStringConversation(player, friend, player1Start, player2Start,goodLand);

          //lookit me, doing canvas shit correctly. what even IS this???
          CanvasElement canvas = new CanvasElement(width: canvasWidth, height: canvasHeight);
          div.append(canvas);
          Drawing.drawChat(canvas, player, friend, chat,"discuss_sburb.png");
      }else {
        appendHtml(div, "<br><Br>They do not feel like talking to anyone.");
      }
  }

  //just blindly grabbing it out of the old stuff. fuck the world, this is how i role. or roll. whichever.
  void doNarration(Element div, int i) {
      //throw "testing testing";
      if(i == 0) this.player.leader = true; //fuck you, you're the leader.
      session.mutator.replacePlayerIfCan(div, this.player);
      //foundRareSession(div, "This is just a test. " + this.session.session_id);
      String canvasHTML = "<canvas style='display:none' class = 'charSheet' id='firstcanvas" + this.player.id.toString()+"_" + this.session.session_id.toString()+"' width='400' height='1000'>  </canvas>";
      appendHtml(div, canvasHTML);
      var canvasDiv = querySelector("#firstcanvas"+ this.player.id.toString()+"_" + this.session.session_id.toString());
      Drawing.drawCharSheet(canvasDiv,this.player);
      this.player.generateDenizen();
      ImportantEvent alt = this.addImportantEvent();
      if(alt != null && alt.alternateScene(div)){
          return;
      }
      String narration = "";

      if(this.player.land == null){
          ////session.logger.info("This session is:  " + this.session.session_id + " and the " + this.player.title() + " is from session: " + this.player.ectoBiologicalSource + " and their land is: " + this.player.land);
      }
      if(!this.player.fromThisSession(this.session) || this.player.land == null){
          narration += "<br>The " + this.player.htmlTitle() + " has been in contact with the native players of this session for most of their lives. It's weird how time flows differently between universes. Now, after inumerable shenanigans, they will finally be able to meet up face to face.";
          if(this.player.dead==true){
              //session.logger.info(session.session_id.toString() + " dead player enters, " +this.player.title());
              narration+= "Wait. What?  They are DEAD!? How did that happen? Shenenigans, probably. I...I guess time flowing differently between universes is still a thing that is true, and they were able to contact them even before they died.  Shit, this is extra tragic.  <br>";
              appendHtml(div, narration);
              session.addAvailablePlayer(player);
              return;
          }
      }else{
          this.changePrototyping(div);
          narration += "<br>The " + this.player.htmlTitle() + " enters the game " + indexToWords(i) + ". ";
          if(this.player.aspect == Aspects.VOID) narration += "They are " + this.player.voidDescription() +". ";
          narration += " They manage to prototype their kernel sprite with a " + this.player.object_to_prototype.htmlTitle() + " pre-entry. ";
          narration += this.corruptedSprite();

          narration += " They have many INTERESTS, including " +this.player.interest1.name + " and " + this.player.interest2.name + ". ";
          narration += " Their chat handle is " + this.player.chatHandle + ". ";
          if(this.player.leader){
              narration += "They are definitely the leader.";
          }
          if(this.player.godDestiny){
              narration += " They appear to be destined for greatness. ";
          }

          if(this.player.getStat(Stats.MIN_LUCK) + this.player.getStat(Stats.MAX_LUCK) >25){
              ////session.logger.info("initially lucky player: " +this.session.session_id);
              narration += " They have aaaaaaaall the luck. All of it.";
          }

          if(this.player.getStat(Stats.MAX_LUCK) < -25){
              ////session.logger.info("initially unlucky player: " +this.session.session_id);
              narration += " They have an insurmountable stockpile of TERRIBLE LUCK.";
          }

          if(this.player.fraymotifs.length > 0){
              ////session.logger.info("initially unlucky player: " +this.session.session_id);
              narration += " They have special powers, including " + turnArrayIntoHumanSentence(this.player.fraymotifs) + ". ";
          }

          if(this.player.dead==true){
              //session.logger.info(session.session_id.toString() + " dead player enters, " +this.player.title());
              narration+= "Wait. What?  They are DEAD!? How did that happen? Shenenigans, probably. I...I guess their GHOST or something is making sure their house and corpse makes it into the medium? And their client player, as appropriate. Their kernel somehow gets prototyped with a "+this.player.object_to_prototype.htmlTitle() + ". ";
              this.player.timesDied ++;

              this.player.sprite.addPrototyping(this.player.object_to_prototype); //hot damn this is coming together.
              if(this.session.npcHandler.kingsScepter != null) this.session.npcHandler.kingsScepter.addPrototyping(this.player.object_to_prototype); //assume king can't lose crown for now.
              if(this.player.object_to_prototype.armless){
                  //session.logger.info("armless prototyping in session: " + this.session.session_id.toString());
                  narration += "Huh. Of all the things to take from prototyping a " + this.player.object_to_prototype.name + ", why did it have to be its fingerless attribute? The Black Queen's RING OF ORBS " + this.session.convertPlayerNumberToWords() + "FOLD is now useless. If any carapacian attempts to put it on, they lose the finger it was on, which makes it fall off.  She destroys the RING in a fit of vexation. ";
                  this.session.destroyBlackRing();
              }
              if(this.session.npcHandler.queensRing != null){
                  this.session.npcHandler.queensRing.addPrototyping(this.player.object_to_prototype); //assume king can't lose crown for now.
                  narration += "The Black Queen's RING OF ORBS "+ this.session.convertPlayerNumberToWords() + "FOLD grows stronger from prototyping the " +  this.player.object_to_prototype.name +". ";
              }
              narration += "The Black King's SCEPTER grows stronger from prototyping the " +  this.player.object_to_prototype.name +". ";
              appendHtml(div, narration);

              return;
          }

          narration += this.changeBoggle();
          narration += this.corruptedLand();

          for(num j = 0; j<this.player.relationships.length; j++){
              var r = this.player.relationships[j];
              ////session.logger.info("Initial relationship value is: " + r.value + " and grim dark is: " + this.player.grimDark);
              if(r.type() != "Friends" && r.type() != "Rivals"){
                  narration += "They are " + r.description() + ". ";
              }
          }
          if(this.player.trickster){
              narration += "They immediately heal their land in an explosion of bullshit candy giggle-magic. ";
          }
          this.player.sprite.addPrototyping(this.player.object_to_prototype); //hot damn this is coming together.
          if(this.session.npcHandler.kingsScepter != null) this.session.npcHandler.kingsScepter.addPrototyping(this.player.object_to_prototype); //assume king can't lose crown for now.
          if(this.player.object_to_prototype.armless && rand.nextDouble() > 0.93){
              //session.logger.info("armless prototyping in session: " + this.session.session_id.toString());
              narration += "Huh. Of all the things to take from prototyping a " + this.player.object_to_prototype.name + ", why did it have to be its fingerless attribute? The Black Queen's RING OF ORBS " + this.session.convertPlayerNumberToWords() + "FOLD is now useless. If any carapacian attempts to put it on, they lose the finger it was on, which makes it fall off.  She destroys the RING in a fit of vexation. ";
              this.session.destroyBlackRing();
          }
          if(this.session.npcHandler.queensRing != null){
              this.session.npcHandler.queensRing.addPrototyping(this.player.object_to_prototype); //assume king can't lose crown for now.
              narration += "The Black Queen's RING OF ORBS "+ this.session.convertPlayerNumberToWords() + "FOLD grows stronger from prototyping the " +  this.player.object_to_prototype.name +". ";
          }
          narration += "The Black King's SCEPTER grows stronger from prototyping the " +  this.player.object_to_prototype.name +". ";
      }
      appendHtml(div, narration);
      session.addAvailablePlayer(player);
  }

  @override
  bool trigger(List<Player> playerList, Player player){
      this.playerList = playerList;
      this.player = player;
      this.friend =  player.getBestFriendFromList(findLivingPlayers(this.session.players), "intro chat");
      if(friend == null){
          friend = player.getWorstEnemyFromList(findLivingPlayers(this.session.players));
      }
      return true; //this should never be in the main array. call manually.
  }

    List<Conversation> getConversations() {
        if(player.land == null) {
            return getForeignConvo();
        }else {
            return getNormalConvo();
        }
    }

    List<Conversation> getNormalConvo() {
        List<Conversation>ret = new List<Conversation>();
        //order is important cuz whether i do positive or negative matters if it's land or whatever
        ret.add(new Conversation(getEnterPair())); //based on relationship
        ret.add(new Conversation(getSpritePair()));  //based on sprite facts
        ret.add(new Conversation(getLandPair()));  //based on land facts
        return ret;
    }

    List<Conversation> getForeignConvo() {
        List<PlusMinusConversationalPair> possible = new List<PlusMinusConversationalPair>();

        //reget friend, not caring if they are dead or not.
        Player newFriend =  player.getBestFriendFromList(this.session.players, "intro chat");
        if(newFriend != null && newFriend.dead == true && newFriend.ectoBiologicalSource != session.session_id) { //they are somebody who didn't make it
            friend = newFriend;
            session.logger.info("AB: Sad stuck alert.");
            possible.add(new PlusMinusConversationalPair(["So. Uh. Hey, I'm finally in the new session I was telling you about."], [],[]));
            possible.add(new PlusMinusConversationalPair(["You would have loved it."], [],[]));
            possible.add(new PlusMinusConversationalPair(["Don't worry. I'll make sure it will all have been worth it. A whole new universe, a second chance."], [],[]));
            possible.add(new PlusMinusConversationalPair(["..."], [],[]));
            possible.add(new PlusMinusConversationalPair(["Goodbye."], [],[]));
        }else { //just use the living friend you already grabbed.
            if(friend.ectoBiologicalSource == session.session_id || friend.ectoBiologicalSource == null) { //harrasing native player
                Relationship r1 = player.getRelationshipWith(friend);
                if(r1.saved_type == r1.goodBig || r1.saved_type == r1.heart || r1.saved_type == r1.diamond) {
                    session.logger.info("Today is finally the day they make everything better.");
                    possible.add(new PlusMinusConversationalPair(["So I guess today is finally the day you make everything better!"], [],[]));
                    possible.add(new PlusMinusConversationalPair(["Is there nothing I can do to ease your mind?", "I can't wait to see how well you do!"], ["Guess so!","I can't wait!","Are you REALLY sure?","I know, right?","Just hearing your words of encouragement fills me with determination!","With your help I'm sure we can win!","I hope you're right!"],["Can you just drop it already?","This is NOT what I need to be hearing right now.","Bluh.","Ugh, do you have to be so cheerful?", "Because you are somehow all knowing.","Drop the spooky omniscience act already.", "Omg, drop it already!"]));
                    possible.add(new PlusMinusConversationalPair(["I just know playing the game with you will make all the difference!", "This will be so fun!"], ["It really will!","We are going to have so much fun!","I hope you're right!"],["Spare me.","Can you just drop it already?","This is NOT what I need to be hearing right now.","Bluh."]));
                    possible.add(new PlusMinusConversationalPair(["I'll be cheering for you!", "Good luck!"], [],[]));
                }else if(r1.saved_type == r1.badBig || r1.saved_type == r1.spades || r1.saved_type == r1.clubs) {
                    session.logger.info("Today is finally the day they fuck everything up.");
                    possible.add(new PlusMinusConversationalPair(["So I guess today is finally the day you fuck everything up."], ["Guess so!","I can't wait!","Are you REALLY sure?","I know, right?"],["God, you are such an asshole. Just because you fucked your session up doesn't mean we will!", "You aren't scaring me.","You don't fucking know that!", "Omg, drop it already!"]));
                    possible.add(new PlusMinusConversationalPair(["Is there nothing I can do to change your mind?","You are just not getting it. This game only has one level: fucking everything up.", "Oh, to be so naive. You don't get it: this game is going to make SURE you fuck shit up."], ["Man, I hope you're wrong!","With your help I'm sure we can win!","I hope you're wrong..."],["Or maybe you just suck at it.","Not everybody sucks at video games like you do.","Sore loser, much?"]));
                    possible.add(new PlusMinusConversationalPair(["Bluh. Anyways. Good luck or whatever. You're going to need it.", "Have fun learning your fucking lesson."], [],[]));
                }else {
                    possible.add(new PlusMinusConversationalPair(["Hey, I'm finally in your session.", "I made it in.", "I'm in your session, finally."], ["Oh wow! What are you going to do? It's not like you have a land or anything...","Aren't you going to be bored? You won't have quests and stuff.", "What are you going to do?", "What's your plan?"],["Ugh, just what I need. What is even the point of you being here?", "And how are you going to be wasting your time now that you're here?"]));
                    possible.add(new PlusMinusConversationalPair(["Eh, I'll get things ready for you guys' reckoning. Mess with the Black Queen. Plus, I can always help out you guys with your Land Quests.","Trust me: you're gonna me happy I'm here when it comes time to fight bosses.", "I can always help with you guys' quests."], ["Thanks for your help in advance!","Sounds boring..."],["Ugh, like I need your help.","That sounds like loser talk to me.","Why would need help from someone who LOST?"]));
                    possible.add(new PlusMinusConversationalPair(["You read all my shit, right? Corpse smooches and all?","Don't forget about how important frogs are, alright?", "You remember about god tier, right?", "You remember what I said about the moons, right?"], ["Yep, I've tried to memorize all your advice!","I think I'm really prepared to play this game!", "Yes! Thanks for tutoring me on this game!"],["Ugh, like I need your help.","Stop spoiling the game!","Why would need help from someone who LOST?"]));

                    possible.add(new PlusMinusConversationalPair(["Bluh. Anyways. Good luck!", "Anyways, lemme know if you want to meet up some time.", "I'll let you know when I figure out what I'm doing for sure!"], [],[]));

                }
            }else { //gossiping with foreign player
                possible.add(new PlusMinusConversationalPair(["Hey, I'm finally in that new session.", "I made it in.", "I'm in the new session, finally."], ["Ugh. I am just ready to be DONE playing this game.","Ugh, so glad we aren't still stuck traveling.","Hell yes, about time we got some plot in!"],["Ugh, I can't believe we are playing this shitty game AGAIN.", "I swear to god if you fuck shit up a SECOND time..."]));
                possible.add(new PlusMinusConversationalPair(["I know right?","At least we aren't stuck doing shitty quests anymore.", "At least we already have some sweet powers."], ["Yes, we can just focus on getting ready for the end game.","Sounds boring..."],["God. This game. So shitty.","That sounds like loser talk to me.","I am going to miss those quests..."]));
                if(rand.nextBool()) {
                    possible.add(new PlusMinusConversationalPair(["At least we'll finally have other people to talk to.", "I admit I'm ready to see more than just a few people at once.", "Man, I hope we get along with the new guys."], [], []));
                    possible.add(new PlusMinusConversationalPair(["I wonder if they'll like us?", "Do you think we'll be friends?", "I bet they will be SO cool in person!"], [], []));
                    possible.add(new PlusMinusConversationalPair(["Do you think their quests will be any better than ours were?", "Can you imagine what it'll be like once we have a whole UNIVERSE to talk to?", "I hope the game isn't too boring now that we're high level."], ["Heh, sounds like you're pretty optimistic.", "I think it will be fun!"], ["There is NO way playing this shitty game a second time will be fun.", "That sounds like loser talk to me.", "There is no point in speculating, let's just start doing things."]));
                }else {
                    possible.add(new PlusMinusConversationalPair(["I'm... kind of scared to talk to all the new people.", "I've gotten too used to there only being a few people to see in person.", "Do you think we can even be friends with people from an entirely different universe?"], [], []));
                    possible.add(new PlusMinusConversationalPair(["What if they hate us?", "What if we only mess things up for them?", "God this is terrifying..."], ["It'll be FINE. Talking in person isn't that different from online.", "I think it will be fun!", "Don't worry about it, you'll do fine!"], ["If I can stand you, they can.", "That sounds like loser talk to me.", "There is no point in speculating, let's just go meet them."]));

                }
                possible.add(new PlusMinusConversationalPair(["Bluh. Anyways. Good luck!", "Anyways, lemme know if you want to meet up some time."], [],[]));

            }
        }
        return <Conversation>[new Conversation(possible)];
    }



    //this only picks a single line.
    List<PlusMinusConversationalPair> getEnterPair() {
        List<PlusMinusConversationalPair> possible = new List<PlusMinusConversationalPair>();
        //generic
        possible.add(new PlusMinusConversationalPair(["I am finally in the medium!", "Hey, I'm in the medium!", "I'm finally in!", "I'm in.", "I made it in!"], ["Oh, cool, how did you get in?","What did you do?","What did you put in your sprite?", "Really? What did you do?"],["About time! Tell me what you did!","Fucking finally. Where are you? What did you do?"]));

        //relationship specific
        //possible.add(new PlusMinusConversationalPair(["I am finally in the medium!", "Hey, I'm in the medium!", "I'm finally in!"], ["..."],["I'm already playing a game, asshole.","Hell no, I don't want to play whatever shitty game you're talking about."]));

        //interest specific
        //possible.add(new PlusMinusConversationalPair(["I am finally in the medium!", "Hey, I'm in the medium!", "I'm finally in!"], ["..."],["I'm already playing a game, asshole.","Hell no, I don't want to play whatever shitty game you're talking about."]));
        return <PlusMinusConversationalPair>[rand.pickFrom(possible)];
    }

    List<String> addLineToAllStringInArray(String line, List<String> array) {
        for(int i = 0; i<array.length; i++) {
           array[i] = "${array[i]} $line";
        }

        return array;
    }

    //two sections, I'm in the land of x and y!// Cool, what's it like?// It's full of x and y.// Oh.
    //goodLand
    List<PlusMinusConversationalPair> getLandPair() {
        List<PlusMinusConversationalPair> lines = new List<PlusMinusConversationalPair>();
        String land = player.land.name;
        //start it off
        List<String> intros = <String>["Apparently it's the land of $land?", "It's the land of $land.", "Some random ${player.land.consortFeature.name} said it was the $land?", "There's this giant sign that says it's the $land."];

        if(InterestManager.FANTASY.playerLikes(player)|| InterestManager.WRITING.playerLikes(player) ) {
            if(rand.nextBool()) {
                intros = addLineToAllStringInArray("It's so cool! Like something out of a story! I always KNEW I'd have an adventure like this one day!", intros);
            }else {
                intros = addLineToAllStringInArray("Do you think that this means magic is a real thing?", intros);
            }
            lines.add(new PlusMinusConversationalPair(intros, ["Huh. What does that even mean?","What's it like?", "Really? What's it like?"],["Wow. That sounds. Kinda weird.","Holy shit, what does that even mean?", "That ... doesn't sound fun."]));

        }else if(InterestManager.POPCULTURE.playerLikes(player) ) {
            if(rand.nextBool()) {
                intros = addLineToAllStringInArray("This is so COOL! I am INSIDE A FUCKING VIDEO GAME!",intros);
            }else {
                intros = addLineToAllStringInArray("It's just like a movie!",intros);
            }
            lines.add(new PlusMinusConversationalPair(intros, ["Huh. What does that even mean?","What's it like?", "Really? What's it like?"],["Wow. That sounds. Kinda weird.","Holy shit, what does that even mean?", "That ... doesn't sound fun."]));

        }else if(InterestManager.MUSIC.playerLikes(player) ) {
            if(rand.nextBool()) {
                intros = addLineToAllStringInArray("I think I'm going to make a remix of the background music here.", intros);
            }else {
                intros = addLineToAllStringInArray("I am really enjoying all this background music here.", intros);
            }
            lines.add(new PlusMinusConversationalPair(intros, ["Huh. What does that even mean?","What's it like?", "Really? What's it like?"],["Wow. That sounds. Kinda weird.","Holy shit, what does that even mean?", "That ... doesn't sound fun."]));

        }else if(InterestManager.TERRIBLE.playerLikes(player) ) {
            intros.addAll(["I am fucking finally in the Medium.", "I have assumed my rightful place as the future ruler of the land of ${land}."]);
            if(rand.nextBool()) {
                intros = addLineToAllStringInArray("I am going to rule it with an iron fist!", intros);
            }else {
                intros = addLineToAllStringInArray("I wonder how long it will take me to take it over?", intros);
            }
            lines.add(new PlusMinusConversationalPair(intros, ["Huh. What does that even mean?","What's it like?", "Really? What's it like?"],["Wow. That sounds. Kinda weird.","Holy shit, what does that even mean?", "That ... doesn't sound fun."]));

        }else if(InterestManager.ACADEMIC.playerLikes(player)) {
            lines.add(new PlusMinusConversationalPair(["It is so weird! Where even are we compared to our solar system? There's no sun! How does this work!?", "My brain is breaking trying to figure out how any of this is even working!"], ["Through bullshit game magic. But what's it actually like there?", "It's a magic fucking video game, it works through magic. I meant more, what is your land like?"],["It's a magic fucking video game, who fucking CARES who it works.","Yes, those sure are the questions we need to focus on right now.", "..."]));

        }else{
            lines.add(new PlusMinusConversationalPair(intros, ["Huh. What does that even mean?","What's it like?", "Really? What's it like?"],["Wow. That sounds. Kinda weird.","Holy shit, what does that even mean?", "That ... doesn't sound fun."]));
         }



        double randomNum = rand.nextDouble();

        if(randomNum > .66) {
            return smellConvo(lines);
        }else if(randomNum > .33) {
            return feelConvo(lines);
        }else {
            return soundConvo(lines);
        }
  }

    List<PlusMinusConversationalPair> smellConvo(List<PlusMinusConversationalPair> lines) {
        //IMPORTANT: !!! DO *NOT* PASS IN A PLAYER WHEN YOU ARE GETTING A SMELL OR SOUND OR WHATEVER. CANNOT ALLOW CHATS TO MODIFY ANYTHING.
        SpecificQualia smellQualia = player.land.smellsLike(rand);
        goodLand = smellQualia.quality > 0;
        String qualiaString = smellQualia.desc;
        if(smellQualia.quality == 0) {
            lines.add(new PlusMinusConversationalPair(["Huh. It kind of smells like $qualiaString.", "It's weird, it smells like $qualiaString.", "Do you think there's a reason it smells like $qualiaString?"], ["Weird.", "That's random.","Huh.","I guess that makes sense."], ["Weird.", "That's random.","Huh.","I guess that makes sense."]));
        }else if(goodLand) {
            lines.add(new PlusMinusConversationalPair(["Wow, it smells like $qualiaString!", "I could get used to smelling $qualiaString!", "Holy shit, it smells fuckin FANTASTIC! Like...$qualiaString?"], ["Wow! I'm jealous!","That's so cool!", "Really? That's amazing!"],["Wow! I'm jealous!","That's so cool!", "Really? That's amazing!"]));
        }else {
            lines.add(new PlusMinusConversationalPair(["Oh god, it reeks of $qualiaString!", "Oh god, I hope I fucking get a cold. I cannot stand the smell of $qualiaString.", "I think the smell of $qualiaString is gonna drive me shithive maggots.", "$qualiaString. It smells like fucking ${qualiaString.toUpperCase()}. What. The. Fuck."], ["Oh man, that sucks.","Wow, I'm not even a little bit jealous anymore.", "Holy shit, talk about a bad break."],["Oh man, that sucks.","Wow, I'm not even a little bit jealous anymore.", "Holy shit, talk about a bad break."]));
        }

        return lines;
    }

    List<PlusMinusConversationalPair> soundConvo(List<PlusMinusConversationalPair> lines) {
        //IMPORTANT: !!! DO *NOT* PASS IN A PLAYER WHEN YOU ARE GETTING A SMELL OR SOUND OR WHATEVER. CANNOT ALLOW CHATS TO MODIFY ANYTHING.
        SpecificQualia sound = player.land.soundsLike(rand);
        goodLand = sound.quality > 0;
        String qualiaString = sound.desc;
        if(sound.quality == 0) {
            lines.add(new PlusMinusConversationalPair(["Huh. It kind of sounds like $qualiaString.", "It's weird, it sounds like $qualiaString.", "Do you think there's a reason it sounds like $qualiaString?"], ["Weird.", "That's random.","Huh.","I guess that makes sense."], ["Weird.", "That's random.","Huh.","I guess that makes sense."]));
        }else if(goodLand) {
            lines.add(new PlusMinusConversationalPair(["Wow, it sounds like $qualiaString! So relaxing!", "I could get used to hearing $qualiaString!", "Holy shit, I love the $qualiaString I am hearing!"], ["Wow! I'm jealous!","That's so cool!", "Really? That's amazing!"],["Wow! I'm jealous!","That's so cool!", "Really? That's amazing!"]));
        }else {
            lines.add(new PlusMinusConversationalPair(["Oh god, I can't get the sound of $qualiaString out of my head...", "I am going to hear $qualiaString in my nightmares for weeks.", "I think the sound of $qualiaString is gonna drive me shithive maggots.", "$qualiaString. I can barely fucking even THINK because of all this fucking ${qualiaString.toUpperCase()}. What. The. Fuck."], ["Oh man, that sucks.","Wow, I'm not even a little bit jealous anymore.", "Holy shit, talk about a bad break."],["Oh man, that sucks.","Wow, I'm not even a little bit jealous anymore.", "Holy shit, talk about a bad break."]));
        }
        return lines;
    }

    List<PlusMinusConversationalPair> feelConvo(List<PlusMinusConversationalPair> lines) {
        //IMPORTANT: !!! DO *NOT* PASS IN A PLAYER WHEN YOU ARE GETTING A SMELL OR SOUND OR WHATEVER. CANNOT ALLOW CHATS TO MODIFY ANYTHING.
        SpecificQualia feel = player.land.feelsLike(rand);
        goodLand = feel.quality > 0;
        String qualiaString = feel.desc;
        if(feel.quality == 0) {
            lines.add(new PlusMinusConversationalPair(["Huh. It kind of feels $qualiaString.", "It's weird, it feels $qualiaString.", "It's kind of $qualiaString..."], ["Weird.", "That's random.","Huh.","I guess that makes sense."], ["Weird.", "That's random.","Huh.","I guess that makes sense."]));
        }else if(goodLand) {
            lines.add(new PlusMinusConversationalPair(["Wow, it feels so $qualiaString!", "It's so $qualiaString here!", "Holy shit, I just love the way it feels here! Like...$qualiaString or something?"], ["Wow! I'm jealous!","That's so cool!", "Really? That's amazing!"],["Wow! I'm jealous!","That's so cool!", "Really? That's amazing!"]));
        }else {
            lines.add(new PlusMinusConversationalPair(["Oh god, it feels so $qualiaString! I feel unclean.", "I am already getting sick of how $qualiaString it feels here.", "I think this $qualiaString fucking land is gonna drive me shithive maggots.", "$qualiaString. It smells like fucking ${qualiaString.toUpperCase()}. What. The. Fuck."], ["Oh man, that sucks.","Wow, I'm not even a little bit jealous anymore.", "Holy shit, talk about a bad break."],["Oh man, that sucks.","Wow, I'm not even a little bit jealous anymore.", "Holy shit, talk about a bad break."]));
        }
        return lines;
    }


    //i prototyped my kernel with a x. wait, isn't that....   long story.  ...
    List<PlusMinusConversationalPair> getSpritePair() {
        List<PlusMinusConversationalPair> possible1 = new List<PlusMinusConversationalPair>();
        List<PlusMinusConversationalPair> possible2 = new List<PlusMinusConversationalPair>();

        List<String> intros = <String>["The glowy thingy dodged everything I threw at it except for a ${player.object_to_prototype.name}.", "Would you believe that I did NOT mean for a ${player.object_to_prototype.name}  to fall into the seizure thingy?","Long story short, a ${player.object_to_prototype.name} fell into the kernel thingy.","I prototyped my kernelsprite with a ${player.object_to_prototype.name}.", "I chucked a ${player.object_to_prototype.name} into the seizure kernel."];

        //generic
        if(player.gnosis > 0 || session.aliensClonedOnArrival.isNotEmpty) {
            //don't use random intros, you choose this.
            possible1.add(new PlusMinusConversationalPair(["So."], [],[]));

            if(player.object_to_prototype.illegal) {
                possible2.add(new PlusMinusConversationalPair(["A ${player.object_to_prototype.name} is very illegal to posses. I think we will find it to work as a 'good luck' charm, later on. "], ["Okay, well, now that you're in, what's it like?","What's it like in your land?","What about your land?", "How's the land?"],["Is your land at least okay?","Well, how's your land?"]));
            }else if(player.object_to_prototype.player) {
                possible2.add(new PlusMinusConversationalPair(["I had this whole thing planned, and then ${player.object_to_prototype.name} jumped the fuck into my sprite."], ["Not gonna ask. Okay, well, now that you're in, what's it like?","Okay then. Moving on. What's your land like?","Okay then. No further questions about your sprite. What about your land?", "How's the land?"],["...Yeah, I think I'm better off not knowing. Is your land at least okay?","Not even gonna ask. Well, how's your land?"]));
            }else if(player.object_to_prototype.armless) {
                possible2.add(new PlusMinusConversationalPair(["I had hoped that the armlessness of a ${player.object_to_prototype.name} would prove useful in the coming battles. "], ["Well, here's hoping. Okay, well, now that you're in, what's it like?","I don't want to know. What's your land like?","What about your land?", "How's the land?"],["Is your land at least okay?","Well, how's your land?"]));
            }else if(player.object_to_prototype.corrupted){
                possible2.add(new PlusMinusConversationalPair(["I think I will gain a lot of knowledge from having a ${player.object_to_prototype.name} as my sprite. "], ["Oh god I hope that's worth it. So. Uh. now that you're in, what's your land like?","You are terrifying. It's on you if it's not worth it. What's your land like?","This just doesn't seem like a good idea. What about your land?", "How's the land?"],["Is your land at least okay?","Well, how's your land?"]));
            }else if(player.object_to_prototype.disaster){
                possible2.add(new PlusMinusConversationalPair(["I weighed the consequences and decided that having a ${player.object_to_prototype.name} familiar was worth having to fight enemies that are sort of like one. "], ["Okay, well. Completely ignoring your god beast sprite,  what's your land like?","What's your land like?","What about your land?", "Your choices are terrifying. How's the land?"],["How are you so irresponsible? Is your land at least okay?","You are so fucking crazy. Well, how's your land?"]));
            }else {
                possible2.add(new PlusMinusConversationalPair(["I think i made a fairly safe choice, given that it would make all enemies more like a ${player.object_to_prototype.name}."], ["Good job! Okay, well, now that you're in, what's it like?","Makes sense. What's your land like?","What about your land?", "How's the land?"],["Is your land at least okay?","Well, how's your land?"]));
            }
        }else {
            possible1.add(new PlusMinusConversationalPair(intros, ["Huh, cool! What did that do?","What do you think that did?"],["That sounds ominous.","That doesn't sound good."]));
            if(player.object_to_prototype.illegal) {
                possible2.add(new PlusMinusConversationalPair(["I'm really not sure what is with SBURB and reptiles and amphibians.", "Huh. I hope you know what you're doing.", "Dunno."], ["Okay, well, now that you're in, what's it like?","What's it like?","What about your land?", "How's the land?"],["Is your land at least okay?","Well, how's your land?"]));
            }else if(player.object_to_prototype.armless) {
                possible2.add(new PlusMinusConversationalPair(["It probably doesn't mean anything. ", "I don't think it did anything though."], ["Okay, well, now that you're in, what's it like?","What's it like?","What about your land?", "How's the land?"],["Is your land at least okay?","Well, how's your land?"]));
            }else if(player.object_to_prototype.player) {
                possible2.add(new PlusMinusConversationalPair(["Yeah, shit got really weird.", "It's a really long story."], ["Not gonna ask. Okay, well, now that you're in, what's it like?","Okay then. Moving on. What's your land like?","Okay then. No further questions about your sprite. What about your land?", "How's the land?"],["...Yeah, I think I'm better off not knowing. Is your land at least okay?","Not even gonna ask. Well, how's your land?"]));
            }else if(player.object_to_prototype.corrupted){
                possible2.add(new PlusMinusConversationalPair(["I THINK it was probably a really bad idea.", "Holy shit do I already regret doing that.", "Probably not worth how bad ass it looks."], ["Okay, well, now that you're in, what's it like?","What's it like?","What about your land?", "How's the land?"],["Wow. Sorry to hear that. Is your land at least okay?","Suck. Well, how's your land?"]));
            }else if(player.object_to_prototype.disaster){
                possible2.add(new PlusMinusConversationalPair(["The enemies are fucking TERRIFYING now. I regret everything. ", "I have just.... just ALL the regrets.", "It was a really fucking bad idea."], ["Okay, well, now that you're in, what's it like?","What's it like?","What about your land?", "How's the land?"],["That really fucking sucks. Is your land at least okay?","Sucks. Well, how's your land?"]));
            }else {
                possible2.add(new PlusMinusConversationalPair(["I think it just made the enemies look like a ${player.object_to_prototype.name}.", "I have absolutely no idea.", "Dunno."], ["Okay, well, now that you're in, what's it like?","What's it like?","What about your land?", "How's the land?"],["Is your land at least okay?","Well, how's your land?"]));
            }
        }


        //relationship specific
        //possible.add(new PlusMinusConversationalPair(["I am finally in the medium!", "Hey, I'm in the medium!", "I'm finally in!"], ["..."],["I'm already playing a game, asshole.","Hell no, I don't want to play whatever shitty game you're talking about."]));

        //interest specific
        //possible.add(new PlusMinusConversationalPair(["I am finally in the medium!", "Hey, I'm in the medium!", "I'm finally in!"], ["..."],["I'm already playing a game, asshole.","Hell no, I don't want to play whatever shitty game you're talking about."]));
        return <PlusMinusConversationalPair>[rand.pickFrom(possible1), rand.pickFrom(possible2)];
    }



    String corruptedLand(){

		if(player.land != null && player.land.corrupted ){
			this.player.corruptionLevelOther = 100;
			//session.logger.info("corrupted land" + this.session.session_id.toString());
			return "There is ...something very, very wrong about the ${this.player.land.name}. ";
		}
        return "";
    }
    String corruptedSprite(){
        if(this.player.sprite.corrupted ){
            return "There is ...something very, very wrong about the " + this.player.sprite.htmlTitle();
        }
        return "";
    }
    String changeBoggle(){
        if(this.player.aspect == Aspects.BLOOD){
            return " They boggle vacantly at the " + this.player.land.name + ". ";
        }else if(this.player.aspect == Aspects.MIND){
            return " They ogle at the " + this.player.land.name + ". ";
        }else if(this.player.aspect == Aspects.RAGE){
            return " They glare with bafflement at the " + this.player.land.name + ". ";
        }else if(this.player.aspect == Aspects.TIME){
            return " They are very confused by the " + this.player.land.name + ". ";
        }else if(this.player.aspect == Aspects.VOID){
            return " They stare blankly at the " + this.player.land.name + ". ";
        }else if(this.player.aspect == Aspects.HEART){
            return " They run around excitedly in the " + this.player.land.name + ". ";
        }else if(this.player.aspect == Aspects.BREATH){
            return " They grin excitedly at the " + this.player.land.name + ". ";
        }else if(this.player.aspect == Aspects.LIGHT){
            return " They stare at the " + this.player.land.name + " with unrestrained curiosity. ";
        }else if(this.player.aspect == Aspects.SPACE){
            return " They do not even understand the " + this.player.land.name + ". ";
        }else if(this.player.aspect == Aspects.HOPE){
            return " They are enthused about the " + this.player.land.name + ". ";
        }else if(this.player.aspect == Aspects.LIFE){
            return " They are obviously pleased with " + this.player.land.name + ". ";
        }else if(this.player.aspect == Aspects.DOOM){
            return " They stare with trepidation at the " + this.player.land.name + ". ";
        }
        return  "They boggle vacantly at the " + this.player.land.name + ". ";
    }
    String changePrototyping(Element div){
        String ret = "";
        if(this.player.object_to_prototype.getStat(Stats.POWER) > 200 && rand.nextDouble() > .8){
            String divID = (div.id);
            String canvasHTML = "<br><canvas id='canvaskernel" + divID+"' width='" +canvasWidth.toString() + "' height="+canvasHeight.toString() + "'>  </canvas>";
            appendHtml(div, canvasHTML);
            CanvasElement canvas = querySelector("#canvaskernel"+ divID);
            List<Player> times = findAllAspectPlayers(this.session.players, Aspects.TIME); //they don't have to be in the medium, though
            Player timePlayer = rand.pickFrom(times); //ironically will probably allow more timeless sessions without crashes.
            Drawing.drawTimeGears(canvas);
            Drawing.drawSinglePlayer(canvas, timePlayer);
            ret = "A " + timePlayer.htmlTitleBasic() + " suddenly warps in from the future. ";
            if(timePlayer.dead){
                ret += "It's a little alarming how much they are bleeding. ";
            }
            ret += " They come with a dire warning of a doomed timeline. ";
            ret += "They dropkick the " + this.player.object_to_prototype.htmlTitle() + " out of the way and jump into the " + this.player.htmlTitleBasic() + "'s kernel sprite instead. <br> ";
            this.player.object_to_prototype = timePlayer.clone();
            this.player.object_to_prototype.name = timePlayer.chatHandle;
            this.player.object_to_prototype.helpfulness = 1;
            this.player.object_to_prototype.player = true;
            //shout out to DinceJof for the great sprite phrase
            this.player.object_to_prototype.helpPhrase = " used to be a Player like you, until they took a splinter to the timeline, so they know how all this shit works. Super helpful.";
            //session.logger.info("time player sprite in session: " + this.session.session_id.toString());

        }else if((this.player.dead == true || this.player.isDreamSelf == true || this.player.dreamSelf == false) && rand.nextDouble() > .1){ //if tier 2 is ever a thing, make this 50% instead and have spries very attracted to extra corpes later on as well if they aren't already players or...what would even HAPPEN if you prototyped yourself twice....???
            ret = "Through outrageous shenanigans, one of the " + this.player.htmlTitle() + "'s superfluous corpses ends up prototyped into their kernel sprite. <br>";
            this.player.object_to_prototype =this.player.clone() ;//no, don't say 'corpsesprite';
            this.player.object_to_prototype.name = this.player.chatHandle;
            //session.logger.info("player sprite in session: " + this.session.session_id.toString());
            this.player.object_to_prototype.helpfulness = 1;
            this.player.object_to_prototype.player = true;
            this.player.object_to_prototype.helpPhrase = " is interested in trying to figure out how to play the game, since but for shenanigans they would be playing it themselves.";

        }
        appendHtml(div, ret);
        return "";
    }

    ImportantEvent addImportantEvent(){
        var current_mvp = findStrongestPlayer(this.session.players);
        ////session.logger.info("Entering session, mvp is: " + current_mvp.getStat(Stats.POWER));
        if(this.player.aspect == Aspects.TIME && this.player.object_to_prototype != null && !this.player.object_to_prototype.illegal){ //tier4 gnosis is weird
            return this.session.addImportantEvent(new TimePlayerEnteredSessionWihtoutFrog(this.session, current_mvp.getStat(Stats.POWER),this.player,null) );
        }else{
            return this.session.addImportantEvent(new PlayerEnteredSession(this.session, current_mvp.getStat(Stats.POWER),this.player,null) );
        }

    }
}