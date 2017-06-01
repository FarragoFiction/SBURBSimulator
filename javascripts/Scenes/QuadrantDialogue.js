//best part of this is that if i want some OTHER scene to be able to have romantic dialgoue (say i write a general purpose dialogue scene)
//it's render function can just call new QuadrantDialogue(this.session).renderContent(div); and be done.
//resuability, yo
//http://www.neoseeker.com/forums/26839/t1277308-random-npc-conversations/   (or i guess i could just play oblivion, but I want a LIST dammit, of memes to add.)
function QuadrantDialogue(session){
	this.session=session;
	this.canRepeat = true;
	this.player1 = null;
	this.player2 = null;
	this.player1Start = null;
	this.player2Start = null;

	//this should have a higher priority than land quests, 'cause the point is relationships distract you from playing the damn game.
	this.trigger = function(){
		this.player1 = null;
		this.player2 = null;

		if(Math.seededRandom() > 0.0001){ //fiddle with rate later, for now, i want to see this happen.
			findSemiRandomQuadrantedAvailablePlayer();
			findQuardrantMate();
		}
		return false;
	}

	this.findSemiRandomQuadrantedAvailablePlayer =function(){
		//set this.player1 to be a random quadranted player.
		//BUT, if there is a player in a moiralligence who is on the verge of flipping their shit, return them.  so not completely random.
	}

	this.findQuardrantMate =function(){
		//set this.player2 to be one of player1's quadrant mates. first diamond, then heart, then spade, then clubs.
	}

	this.getDiscussSymbol =function(){
		//TODO, turn which quadrant player1 and player2 are in into a png to pass.  Create pngs for diamonds and clubs.
	}

	this.getQuadrant = function(){
		return this.player1.getRelationshipWith(this.player2);
	}

	this.getQuadrant2 = function(){
		return this.player2.getRelationshipWith(this.player1);

	}

	this.chatAboutInterests = function(trait,relationship, relationship2){
		//calls different methods depending on trait, THOSE methods determine what they randomly talk about (based on relationship value)
		//trolls talking about pop culture should just list out a huge movie title because i am trash.
		//maybe randomly generate the movie title because holy fuck does that sound amazing.
		//if i do that, i should have an easter egg page that is nothing BUT listing out bullshit movie titles
		//which means the code to do that should live in NOT this scene. Maybe??????????

		//having interests in common keeps the relationship from getting too boring.
		relationship.moreOfSame();
		relationship.moreOfSame();
		relationship.moreOfSame();
		var p1 = this.player1;
		var p2 = this.player2;
		if(Math.seededRandom() > 0.5){ //change who is initiating
			p1 = this.player2;
			p2 = this.player1;
		}
		if(trait == "smart") return this.chatAboutAcademic(p1, p2, relationship, relationship2);
		if(trait == "musical") return this.chatAboutMusic(p1, p2, relationship, relationship2);
		if(trait == "cultured") return this.chatAboutCulture(p1, p2, relationship, relationship2);
		if(trait == "lettered") return this.chatAboutWriting(p1, p2, relationship, relationship2);
		if(trait == "geeky") return this.chatAboutPopCulture(p1, p2, relationship, relationship2);
		if(trait == "techy") return this.chatAboutTechnology(p1, p2, relationship, relationship2);
		if(trait == "extroverted") return this.chatAboutSocial(p1, p2, relationship, relationship2);
		if(trait == "romantic") return this.chatAboutRomance(p1, p2, relationship, relationship2);
		if(trait == "funny") return this.chatAboutComedy(p1, p2, relationship, relationship2);
		//if(trait == "funny") return this.chatAboutComedy(p1, p2, relationship, relationship2); //why does this have a illegal character???
		if(trait == "domestic") return this.chatAboutDomestic(p1, p2, relationship, relationship2);
		if(trait == "athletic") return this.chatAboutAthletic(p1, p2, relationship, relationship2);
		if(trait == "honest") return this.chatAboutTerrible(p1, p2, relationship, relationship2);
		if(trait == "imaginative") return this.chatAboutFantasy(p1, p2, relationship, relationship2);
		if(trait == "fair-minded") return this.chatAboutJustice(p1, p2, relationship, relationship2);


	}

	this.chatAboutAcademic = function(p1, p2, relationship, relationship2){
		return  "\n<insert random 'academic' chat here>\n"

	}

	this.chatAboutWriting = function(p1, p2, relationship, relationship2){
		return  "\n<insert random 'writing' chat here>\n"

	}

	this.chatAboutRomance = function(p1, p2, relationship, relationship2){
		return  "\n<insert random 'romance' chat here>\n"

	}

	this.chatAboutSocial = function(p1, p2, relationship, relationship2){
		return  "\n<insert random 'social' chat here>\n"

	}

	this.chatAboutTechnology = function(p1, p2, relationship, relationship2){
		return  "\n<insert random 'technology' chat here>\n"

	}

	this.chatAboutPopCulture = function(p1, p2, relationship, relationship2){
		return  "\n<insert random 'popculture' chat here>\n"

	}

	this.chatAboutMusic = function(p1, p2, relationship, relationship2){
			//if both characters like rap/hiphop, etc, they rap here????
			return  "\n<insert random 'music' chat here>\n"
	}

	//did you get to the cloud district recently, what am i saying of course you didn't.
	this.chatAboutCulture = function(p1, p2, relationship, relationship2){
		return  "\n<insert random 'culture' chat here>\n"
	}

	//oh lord, tell bad jokes here.  especially puns
	this.chatAboutComedy = function(p1, p2, relationship, relationship2){
		return  "\n<insert random 'comedy' chat here>\n"
		var interest = "Comedy"; //TODO need a standard way to say if p2 "likes comedy";
		//in a way that InterestConversationalPair can store, and getp2ResponseBasedOnInterests can use to ask if p2 likes/knows about.
		
		
		//InterestConversationalPair(interest, line1, responseLinesSharedInterestPositive, responseLinesSharedInterestNegative))
		var chats = [];
	}

	this.chatAboutDomestic = function(p1, p2, relationship, relationship2){
		return  "\n<insert random 'domestic' chat here>\n"
	}

	this.chatAboutAthletic = function(p1, p2, relationship, relationship2){
		return  "\n<insert random 'athletic' chat here>\n"

	}

	this.chatAboutTerrible = function(p1, p2, relationship, relationship2){
		return  "\n<insert random 'terrible' chat here>\n"
	}

	this.chatAboutFantasy = function(p1, p2, relationship, relationship2){
		return  "\n<insert random 'fantasy' chat here>\n"

	}
	
	//response depends on whether or not p2 shares that interest.
	this.processChatAboutInterests = function(chats, interest, p1,p2,relationship1, relationship2){
		var chosen = getRandomElementFromArray(chats);
		var chat = "";
		chat +=  chatLine(this.player1Start, this.player1, chosen.line1);
		chat += this.p2GetResponseBasedOnRelationship(chosen, this.player2, this.player2Start, relationship2)
		return chat;
	}
	
	this.getp2ResponseBasedOnInterests = function(chat, interest, p1, p2, relationship1, relationship2){
		
	}

	//stop right there, criminal scum
	this.chatAboutJustice = function(p1, p2, relationship, relationship2){
		//look at InterestConversationalPair and don't call
		//this.processChatPair(chats, relationship1, relationship2);
		//because it randomizes who said what and that is not okay.
		return  "\n<insert random 'justice' chat here>\n"
	}

	this.chatAboutLackOfInterests = function(relationship, relationship2){
		var p1 = this.player1;
		var p2 = this.player2;
		if(Math.seededRandom() > 0.5){ //change who is initiating
			p1 = this.player2;
			p2 = this.player1;
		}
		var interest = p1.interest1;
		if(Math.seededRandom() > 0.5){ //change who is initiating
			interest = p1.interest2;
		}

		if(academic_interests.indexOf(interest) != -1 ) return this.chatAboutAcademic(p1, p2, relationship, relationship2);
		if(music_interests.indexOf(interest) != -1 ) return this.chatAboutMusic(p1, p2, relationship, relationship2);
		if(culture_interests.indexOf(interest) != -1 ) return this.chatAboutCulture(p1, p2, relationship, relationship2);
		if(writing_interests.indexOf(interest) != -1 ) return this.chatAboutWriting(p1, p2, relationship, relationship2);
		if(pop_culture_interests.indexOf(interest) != -1 ) return this.chatAboutPopCulture(p1, p2, relationship, relationship2);
		if(technology_interests.indexOf(interest) != -1 ) return this.chatAboutTechnology(p1, p2, relationship, relationship2);
		if(social_interests.indexOf(interest) != -1 ) return this.chatAboutSocial(p1, p2, relationship, relationship2);
		if(romantic_interests.indexOf(interest) != -1 ) return this.chatAboutRomance(p1, p2, relationship, relationship2);
		if(comedy_interests.indexOf(interest) != -1 ) return this.chatAboutComedy(p1, p2, relationship, relationship2);
		if(domestic_interests.indexOf(interest) != -1 ) return this.chatAboutDomestic(p1, p2, relationship, relationship2);
		if(athletic_interests.indexOf(interest) != -1 ) return this.chatAboutAthletic(p1, p2, relationship, relationship2);
		if(terrible_interests.indexOf(interest) != -1 ) return this.chatAboutTerrible(p1, p2, relationship, relationship2);
		if(justice_interests.indexOf(interest) != -1 ) return this.chatAboutJustice(p1, p2, relationship, relationship2);
		if(fantasy_interests.indexOf(interest) != -1 ) return this.chatAboutFantasy(p1, p2, relationship, relationship2);
	}

	this.chatAboutQuadrant = function(relationship, relationship2){
		//calls different methods based on quadrant.  THOSE methods have different shit in them based on value (foreshadows break up.)
		if(relationship.saved_type == relationship.diamond)return this.diamondsChat(relationship, relationship2);
		if(relationship.saved_type == relationship.heart)return this.heartChat(relationship, relationship2);
		if(relationship.saved_type == relationship.clubs)return this.clubsChat(relationship, relationship2);
		if(relationship.saved_type == relationship.spades) return this.spadesChat(relationship, relationship2);
	}

	//skyrim joke exists about how easy it is to steal from an NPC after putting a bucket on their head (now they can't see you stealing)
	//how scandalous

	this.getQuadrantASCII = function(relationship){
		//calls different methods based on quadrant.  THOSE methods have different shit in them based on value (foreshadows break up.)
		if(relationship.saved_type == relationship.diamond)return " <> "
		if(relationship.saved_type == relationship.heart)return " <3 "
		if(relationship.saved_type == relationship.clubs)return " c3< "
		if(relationship.saved_type == relationship.spades) return " <3< "
	}


	this.clubsChat = function(relationship1, relationship2){
		console.log("Clubs Chat in: " + this.session.session_id)
		var chats = [];
		chats.push( new ConversationalPair("So. Behaving?",["Fuck you I do what I want.","Yes, MOM.","God, could you just leave me alone?"]));
		chats.push( new ConversationalPair("You're not getting into any trouble, are you?",["Oh yeah, tons of trouble. I'm literally sitting in a puddle of that assholes blood RIGHT now.","Ugh. No. I'm behaving.","Can't you just stop meddling?"]));
		chats.push( new ConversationalPair("Have you tried the breathing exercises I recomended?",["They don't fix the fundamental problem of that asshole existing.","All they did was make me hate breathing.","Fuck you."]));
		chats.push( new ConversationalPair("Have you tried talking to your...enemy?",["Fuck you.","No. Just. Fuck that guy.","You can't make me."]));
		//chats.push( new ConversationalPair("",["","",""]));
		return  this.processChatPair(chats, relationship1, relationship2);
	}

	this.processChatPair = function(chats, relationship1, relationship2){
		var chat = "";
		var chosen = getRandomElementFromArray(chats);
		if(Math.seededRandom() > 0.5){
			chat +=  chatLine(this.player1Start, this.player1, chosen.line1);
			chat += this.p2GetResponseBasedOnRelationship(chosen, this.player2, this.player2Start, relationship2)
		}else{
			chat +=  chatLine(this.player2Start, this.player2, chosen.line1);
			chat += this.p2GetResponseBasedOnRelationship(chosen, this.player1, this.player1Start, relationship1)
		}
		return chat;
	}

	this.p2GetResponseBasedOnRelationship = function(chosen, player, playerStart, relationship){
		var chat = "";
		if(relationship.saved_type == relationship.heart || relationship.saved_type == relationship.diamond){
			if(relationship.value > 0){
				chat += chatLine(playerStart, player, getRandomElementFromArray(chosen.responseLines));
			}else{ //i don't love you like i should.
				chat += chatLine(playerStart, player, getRandomElementFromArray(chosen.genericResponses));
			}
		}else{
			if(relationship.value < 0){
				chat += chatLine(playerStart, player, getRandomElementFromArray(chosen.responseLines));
			}else{  //i don't hate you like i should.
				chat += chatLine(playerStart, player, getRandomElementFromArray(chosen.genericResponses));
			}
		}
		return chat;
	}


	this.spadesChat = function(relationship1, relationship2){
		console.log("Spades Chat  in: " + this.session.session_id)
		var chats = [];
		chats.push( new ConversationalPair("God, how can anyone be so bad at this game? You suck.",["Fuck you, I killed that imp like a boss.","Like you're any better!","Fuck off!"]));
		chats.push( new ConversationalPair("Jegus, stop hogging the grist!",["Make me!","Fuck you, I earned it!","Well, YOU stop hogging the echeladder rungs!"]));
		chats.push( new ConversationalPair("How can anyone smell as bad as you do?",["Don't talk to me about rank smells. You are the fucking big man of smelling bad.","Fuck you, It's not my fault my bathtub was destroyed!","I am not going to dignify that with a response."]));
		chats.push( new ConversationalPair("Hey. Fuck you.",["What the hell, man!?","Fuck you too.","I don't have to put up with this."]));
		chats.push( new ConversationalPair("Could you GET any stupider?",["Yeah, I could turn into you!","You're one to talk!","Fuck you."]));
		chats.push( new ConversationalPair("Can you stop fucking bothering me!?",["Make me.","I don't know, CAN I?","It's not like you have anything better to do."]));
		chats.push( new ConversationalPair("Leave me alone!",["Like hell I will, this is the most fun I've had all day.","You're the one who's all up in my grill! My grill is practically your prison!","Aw, come on, you don't mean that, do you asshole?", "No can do, we are motherfuckin entrenched in this bitch."]));
		return  this.processChatPair(chats, relationship1, relationship2);
	}

	this.heartChat = function(relationship1, relationship2){
		console.log("Heart Chat  in: " + this.session.session_id)
		var chats = [];
		chats.push( new ConversationalPair("You're so good at this game!",["No, way, you're tons better than me.","Heh, about time I'm good at something, huh?","Only because I get to play it with you."]));
		chats.push( new ConversationalPair("Do you need any extra grist?",["Oh, thanks!","No, I'm good, but it's so sweet of you to offer.","Heh, I was going to ask YOU that."]));
		chats.push( new ConversationalPair("Wow, I feel like I could talk to you forever!",["Same. It's like we finish each others sandwiches.","I know, right! It's so great.","Exactly! Let's meet up later and do quests"]));
		chats.push( new ConversationalPair("I can't believe we are actually together!",["It's like a dream come true.","I'm still reminding myself it's real.","It's like something out of a movie."]));
		chats.push( new ConversationalPair("What's your favorite drink?",["AJ.","Orange Soda.","Purple drank.", "Tea.", "Coffee.", "Hot Chocolate.", "Lemonade."]));
		return  this.processChatPair(chats, relationship1, relationship2);
		//chats.push( new ConversationalPair("",["","",""]));
	}

	this.diamondsChat = function(relationship1, relationship2){
		console.log("Diamonds Chat  in: " + this.session.session_id)
		var chats = [];
		this.player1.triggerLevel += -1;
		this.player2.triggerLevel += -1;
		chats.push( new ConversationalPair("How have you been?",["Okay.","Good.","Alright.","As well as can be expected.","Better than I thought I'd be."]));
		chats.push( new ConversationalPair("You doing okay?",["Yes.","As well as can be expected.","Better than I thought I'd be."]));
		chats.push( new ConversationalPair("This game really sucks.",["Yes, you aren't kidding.","I know,right?","Represent"]));
		//chats.push( new ConversationalPair("",["","",""]));
		return  this.processChatPair(chats, relationship1, relationship2);
	}

	this.feelingsJam = function(relationship,relationship2){
		console.log("Feelings Jam in: " + this.session.session_id)
		this.player1.triggerLevel += -2;
		this.player2.triggerLevel += -2;
		//figure out which player is flipping out, make them "flippingOut", make other player "shoosher"
		var chat = "";
		var freakOutWeasel = this.player1;
		var p1start = this.player1Start;
		var shoosher = this.player2;
		var p2start = this.player2Start;
		if(!freakOutWeasel.flipOutReason){
			freakOutWeasel = this.player2;
			p1start = this.player2Start;
			shooser = this.player1;
			p2start = this.player1Start;
		}
		if(!freakOutWeasel.flipOutReason) return "ERROR: NO ONE IS FLIPPING OUT."
		if(freakOutWeasel.flippingOutOverDeadPlayer && freakOutWeasel.flippingOutOverDeadPlayer.dead){
			var deadRelationship = freakOutWeasel.getRelationshipWith(freakOutWeasel.flippingOutOverDeadPlayer);
			chat +=  chatLine(p1start, freakOutWeasel, "Oh god. Oh god they are dead. Fuck.");
			chat +=  chatLine(p2start, shoosher, "Shit. Wait, who is dead?");
			chat +=  chatLine(p1start, freakOutWeasel,freakOutWeasel.flippingOutOverDeadPlayer.chatHandle + ". Fuck. They died " + freakOutWeasel.flippingOutOverDeadPlayer.causeOfDeath );
			chat +=  chatLine(p2start, shoosher, "Shit. Weren't they your " + deadRelationship.nounDescription() + "? Fuck.");
			chat +=  chatLine(p1start, freakOutWeasel, "Yeah. Fuck.");
			chat +=  chatLine(p2start, shoosher, "Listen. It's okay. Maybe this game has a bullshit way to bring them back?");
			chat +=  chatLine(p1start, freakOutWeasel, "I hope so.");
		}else if(freakOutWeasel.flippingOutOverDeadPlayer && !freakOutWeasel.flippingOutOverDeadPlayer.dead){
			var deadRelationship = freakOutWeasel.getRelationshipWith(freakOutWeasel.flippingOutOverDeadPlayer);
			chat +=  chatLine(p1start, freakOutWeasel, "Jesus fuck, apparently my " + deadRelationship.nounDescription() + ", " + freakOutWeasel.flippingOutOverDeadPlayer.chatHandle + ",  died.");
			chat +=  chatLine(p2start, shoosher, "Oh god. I'm so sorry.");
			chat +=  chatLine(p1start, freakOutWeasel, "Apparently they got better? I don't even know how to feel about this.");
			chat +=  chatLine(p2start, shoosher, "SBURB fucking sucks.");
			chat +=  chatLine(p1start, freakOutWeasel, "It really, really does.");
		}else if(freakOutWeasel.flipOutReason.indexOf("doomed time clones") != -1){
			chat +=  chatLine(p1start, freakOutWeasel, "Oh my god, time really is the shittiest aspect.");
			chat +=  chatLine(p2start, shoosher, "Everything okay?");
			chat +=  chatLine(p1start, freakOutWeasel, "Hell no. There are fucking clones of me running around and dying and agreeing to die and fuck...");
			chat +=  chatLine(p2start, shoosher, "Shoosh, it will be fine. It just proves you are dedicated to beating this game. That's a good thing.");
			chat +=  chatLine(p1start, freakOutWeasel, "No, it proves THEY are. I haven't done fuck all.");
			chat +=  chatLine(p2start, shoosher, "Shhhh, there there. They are just you in a slightly different situation. It still reflects well on you.");
			chat +=  chatLine(p1start, freakOutWeasel, "Yeah. Okay. You're right.");
		}else if(freakOutWeasel.flipOutReason.indexOf("Ultimate Goddamned Riddle") != -1){
			chat +=  chatLine(p1start, freakOutWeasel, "lol lol lololololol");
			chat +=  chatLine(p2start, shoosher, "Everything okay?");
			chat +=  chatLine(p1start, freakOutWeasel, "Oh god, it's all so FUCKING hilarious!");
			chat +=  chatLine(p2start, shoosher, "?");
			chat +=  chatLine(p1start, freakOutWeasel, "Don't you get it? The goddamned fucking ULTIMATE RIDDLE!?");
			chat +=  chatLine(p1start, freakOutWeasel, "It was right there, all along! We were always meant to play this fucking game.");
			chat +=  chatLine(p1start, freakOutWeasel, "And here I thought Skaia didn't have a sense of HUMOR!");
			chat +=  chatLine(p2start, shoosher, "Okay. You need to calm down. Whatever happened isn't ...well, I was going to say 'the end of the world', but I think that would just set you off again.");
			chat +=  chatLine(p2start, shoosher, "We aren't giving up, okay? YOU aren't giving up. We can still beat this. So calm your tits.");
			chat +=  chatLine(p1start, freakOutWeasel, "Yes. Yes. You're right. Of course your are. I'll ... try to focus.");
		}else if(freakOutWeasel.flipOutReason.indexOf("they just freaking died") != -1){
			chat +=  chatLine(p1start, freakOutWeasel, "Well.");
			chat +=  chatLine(p2start, shoosher, "Shit, are you okay? Jesus fuck I thought I lost you there.");
			chat +=  chatLine(p1start, freakOutWeasel, "I mean, you did right? I died. That is a thing that is true.");
			chat +=  chatLine(p2start, shoosher, "What...was it like?");
			chat +=  chatLine(p1start, freakOutWeasel, "Dying sucks. I do not recommend you try it out.");
		}else{
			chat +=  chatLine(p1start, freakOutWeasel, "Fuck. I can't take this anymore.");
			chat +=  chatLine(p2start, shoosher, "Shit, what's up, talk to me...");
			chat +=  chatLine(p1start, freakOutWeasel, "God, I don't even know what to say. Everything is just so shitty.");
			chat +=  chatLine(p2start, shoosher, "It really is. But we aren't going to give up, okay?");
			chat +=  chatLine(p2start, shoosher, "One foot in front of the other, and we keep going.");
			chat +=  chatLine(p1start, freakOutWeasel, "Yeah. Okay.");
		}

		freakOutWeasel.flipOutReason = null;
		freakOutWeasel.flippingOutOverDeadPlayer = null;
		return chat;
	}


	this.interestAndQuadrantChat = function(trait, relationship, relationship2){
		var ret = "";
		for(var i = 0; i<3; i++){
			var rand = Math.seededRandom()
			if(rand < 0.3){ //maybe make them MORE likely to chat about interests?
				ret += this.chatAboutInterests(trait,relationship, relationship2); //more likely to talk about interests.
			}else if(rand < 0.6){
					ret += this.chatAboutLackOfInterests(relationship, relationship2); //would get repetitive if they were locked to one topic.
			}else{
				ret += this.chatAboutQuadrant(relationship, relationship2);
			}
		}
		return ret;
	}

	this.lackOfInterestAndQuadrantChat = function(relationship, relationship2){
		var ret = "";
		for(var i = 0; i<3; i++){
		if(Math.seededRandom() > 0.3){
				ret += this.chatAboutLackOfInterests(relationship, relationship2); //one character tries to talk about something that interests them, other character is bored as fuck.
			}else{
				ret += this.chatAboutQuadrant(relationship, relationship2);
			}
		}
		return ret;
	}

	this.getChat =function(relationship, relationship2){

		relationship.moreOfSame(); //strengthens bonds in whatever direction.
		//feelings jams have highest priority.
		if(relationship.saved_type == relationship.diamond && (this.player1.flipOutReason || this.player2.flipOutReason)){
			return this.feelingsJam(relationship, relationship2);  //whole convo
		}
		var trait = whatDoPlayersHaveInCommon(this.player1, this.player2);
		if(trait != "nice"){
			return this.interestAndQuadrantChat(trait, relationship, relationship2);
		}else{  //no option to chat about interests.
			return this.lackOfInterestAndQuadrantChat(relationship, relationship2);
		}
	}


	this.getGreeting = function(r1,r2){
		var ret = "";
		ret += chatLine(this.player1Start, this.player1,getRelationshipFlavorGreeting(r1, r2, this.player1, this.player2) + this.getQuadrantASCII(r1))
		ret += chatLine(this.player2Start, this.player2,getRelationshipFlavorGreeting(r2, r1, this.player2, this.player1)+ this.getQuadrantASCII(r2))
		return ret;
	}

	this.fareWell = function(relationship,relationship2){
		//fuck yes oblivion, you taught me what a good AI "goodbye" is.
		var goodByes = ["Good day.","Farewell.","Bye bye.","Bye.", "Talk to you later!", "ttyl", "seeya"];
		var badByes = ["I have nothing more to say to you.","I've heard others say the same.","Yeah, I'm done here.","I'm out.","I'm going to ollie outtie.","I'm through speaking with you."];
		var ret = "";

		var r2 = this.player2.getRelationshipWith(this.player1);
		if(relationship.value > 0){
			ret += chatLine(this.player1Start, this.player1, getRandomElementFromArray(goodByes) + this.getQuadrantASCII(relationship));
		}else{
			ret += chatLine(this.player1Start, this.player1, getRandomElementFromArray(badByes) + this.getQuadrantASCII(relationship));
		}

		if(r2.value > 0){
			ret += chatLine(this.player2Start, this.player2, getRandomElementFromArray(badByes)+ this.getQuadrantASCII(relationship));
		}else{
			ret += chatLine(this.player2Start, this.player2, getRandomElementFromArray(badByes)+ this.getQuadrantASCII(relationship));
		}

		return ret;
	}



	this.chat = function(div){
		var canvasHTML = "<br><canvas id='canvas" + (div.attr("id")) +"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		var relationship = this.getQuadrant();
		var relationship2 = this.getQuadrant2();
		var chatText = this.getGreeting(relationship, relationship2);
		chatText += this.getChat(relationship, relationship2);
		chatText += this.fareWell(relationship,relationship2); //<-- REQUIRED for ultimate oblivion shittieness. "I have nothing more to say to you." "good day."
		drawChat(document.getElementById("canvas"+ (div.attr("id"))), this.player1, this.player2, chatText, 0,this.getDiscussSymbol());
	}

	//have test page (link to easter eggs) where it generates some players and shoves them into relationships and
	//makes thiem this.player1 and 2 and then calls renderContent.
	this.renderContent = function(div){
		if(this.player1.aspect != "Time") removeFromArray(this.player1, this.session.availablePlayers);
		if(this.player2.aspect != "Time") removeFromArray(this.player2, this.session.availablePlayers);
		this.player1Start = this.player1.chatHandleShort()+ ": "
		this.player2Start = this.player2.chatHandleShortCheckDup(this.player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.

		/*
				Since this dialogue has no "purpose", no information that HAS to be conveyed, can treat it as more dynamic.
				Go for bullshit elder scrolls pairs.

				Greeting (based on quadrant, not generic greetings)
				Greeting

				chatPair1, chatPair2, chatPair3

				where chatPair is a call and response about one of several topics, each of which have multiple random call/response things it can deploy

				Have you heard about Kvatch?
				No.

				I have been to the Imperial City recently.
				I've heard others say the same.

				I have nothing more to say to you.
				Good day.

				<3<3<3 elder scrolls. They are such ASSHOLES to each other.

				Chat pairs can be generated from: interests in common, quadrants
				ALSO, flipOutReason is special case. highest priority.


		*/
		this.chat(div);

	}

	this.content = function(){
		return "NEVER RUN IN 1.0 YOU DUNKASS. Seriously, I don't support it anymore."
	}


}

//can't have engine create these things 'cause needs to be dynamic, not made ahead of time
function ConversationalPair(line1, responseLines){
	this.line1 = line1;
	this.responseLines = responseLines;  //responses are just reactions
	this.genericResponses = ["Yeah.", "Tell me more", "You don't say.",  "Wow", "Cool", "Fascinating", "Uh-huh.", "Sure.", "I've heard others say the same.", "...", "Whatever.", "Yes.", "Interesting...", "Hrmmm..."]
}

function InterestConversationalPair(interest, line1, responseLinesSharedInterestPositive, responseLinesSharedInterestNegative){
	this.line1 = line1;
	this.interest = interest; //vague description of what the interest is. like "Comedy"  need this to have a common source of words.like how "shared trait" does.
	//what can i say if i like you and share your interest
	this.responseLinesSharedInterestPositive = responseLinesSharedInterestPositive;
	//what can i say if i hate you and share your interests.
	this.responseLinesSharedInterestNegative = responseLinesSharedInterestNegative;
	//below happens if you don't share an interest at all.
	this.genericResponses = ["Yeah.", , "Nice", "Double nice", "Tell me more", "You don't say.",  "Wow", "Cool", "Fascinating", "Uh-huh.", "Sure.", "I've heard others say the same.", "...", "Whatever.", "Yes.", "Interesting...", "Hrmmm..."]

}
