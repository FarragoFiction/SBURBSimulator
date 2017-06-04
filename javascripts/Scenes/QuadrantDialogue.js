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
		//if want to be more frequent, can allo goodBig and badBig to trigger this as well.

		if(Math.seededRandom() > 0.0001){ //fiddle with rate later, for now, i want to see this happen.
			this.findSemiRandomQuadrantedAvailablePlayer();
		}
		return this.player1 != null && this.player2 != null; //technically if one is set both should be but whatever.
	}

	this.findSemiRandomQuadrantedAvailablePlayer =function(){
		//set this.player1 to be a random quadranted player.
		//BUT, if there is a player in a moiralligence who is on the verge of flipping their shit, return them.  so not completely random.
		var quadrants = [];
		for(var i = 0; i< this.session.availablePlayers.length; i++){
			var p = this.session.availablePlayers[i];
			if(p.isQuadranted() && p.grimDark < 2) quadrants.push(p); //grim dark players don't initiate conversaion.
		}
		this.player1 = getRandomElementFromArray(quadrants);
		if(this.player1) this.findQuardrantMate();
	}

	this.findQuardrantMate =function(){
		//set this.player2 to be one of player1's quadrant mates. first diamond, then randomly from heart, then spade, then clubs.
		var potentials = this.player1.getDiamonds();
		this.player2 = getRandomElementFromArray(potentials);
		if(this.player2 && Math.seededRandom > 0.5){ //don't completely ignore your other relationships in favor of your moirail.
			return;
		}
		potentials = potentials.concat(this.player1.getHearts())
		potentials = potentials.concat(this.player1.getClubs())
		potentials = potentials.concat(this.player1.getSpades())
		this.player2 = getRandomElementFromArray(potentials);
		return;
	}

	this.getDiscussSymbol =function(relationship){
		//TODO, turn which quadrant player1 and player2 are in into a png to pass.  Create pngs for diamonds and clubs.
		if(relationship.saved_type == relationship.diamond)return "discuss_palemance.png"
		if(relationship.saved_type == relationship.heart)return "discuss_romance.png"
		if(relationship.saved_type == relationship.clubs)return "discuss_ashenmance.png"
		if(relationship.saved_type == relationship.spades) return "discuss_hatemance.png "
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
		var p1Start = this.player1Start;
		var p2Start = this.player2Start;
		if(Math.seededRandom() > 0.5){ //change who is initiating
			p1 = this.player2;
			p2 = this.player1;
			p1Start = this.player2Start;
			p2Start = this.player1Start;
			var tmp = relationship
			relationship = relationship2;
			relationship2 = tmp;
		}
		console.log("chatting about shared interests")
		if(trait == "smart") return this.chatAboutAcademic(p1, p2,  p1Start, p2Start,relationship, relationship2);
		if(trait == "musical") return this.chatAboutMusic(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(trait == "cultured") return this.chatAboutCulture(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(trait == "lettered") return this.chatAboutWriting(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(trait == "geeky") return this.chatAboutPopCulture(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(trait == "techy") return this.chatAboutTechnology(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(trait == "extroverted") return this.chatAboutSocial(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(trait == "romantic") return this.chatAboutRomance(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(trait == "funny") return this.chatAboutComedy(p1, p2, p1Start, p2Start, relationship, relationship2);
		//if(trait == "funny") return this.chatAboutComedy(p1, p2, relationship, relationship2); //why does this have a illegal character??? oh. i can see the char on windows, but couldn't on mac. so weird.
		if(trait == "domestic") return this.chatAboutDomestic(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(trait == "athletic") return this.chatAboutAthletic(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(trait == "honest") return this.chatAboutTerrible(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(trait == "imaginative") return this.chatAboutFantasy(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(trait == "fair-minded") return this.chatAboutJustice(p1, p2, p1Start, p2Start, relationship, relationship2);


	}

	////Troll words: year, month, refrigerator, bathtub, ears, heart, brain,rap,nose,mouth,bed,tea,worm,beans,tree,legs,eyes, gold star,born,toilet,foot,spine,vampire,tits,baby,
	this.chatAboutAcademic = function(p1, p2,p1Start, p2Start, relationship, relationship2){
		var interest = "Academic";
		var chats = [];
		//chats.push(new InterestConversationalPair(interest, "", ["","",""], ["", "", "","", ""]));
		chats.push(new InterestConversationalPair(interest, "Do you think our echeladders represent linear power growth, or exponential?", ["It's hard to tell when there is no indicator of the ratio of power to echeladder run.","I'm leaning towards 'complete and utter randomness'. I once leveled up for tripping over a rock.","I'm leaning towards exponential, since it seems like there are small power gains per run at first, but extremely large ones by the end."], ["God, do you even listen to the words coming out of your mouth? Who fucking CARES what math is behind our bullshit rpg leveling conceit?", "If you stopped for a minute to think, you'd realize that the echeladder is random as fuck. If you use boondollars as a vague metric of 'power' at a level, you'd see that it doesn't seem to be mapped to any mathetmatical formula.", "THIS is the conundrum you've decided matters. Not how to survive this death game. Not how the bullshit game powers work. But the leveling system. Great."]));
		chats.push(new InterestConversationalPair(interest, "How can the consorts have an oral history, and even ruins, when they only started existing once we entered the medium?", ["","",""], ["", "", "","", ""]));
		chats.push(new InterestConversationalPair(interest, "These 'lands' just don't make sense on a fundamental level. They are so small, how do they have an atmosphere! Where is the light coming from!", ["I know right, how the hell does physics work in the Medium? What is even keeping the planets in order? They are perfect little spheres and Skaia is nowhere near as big as a sun. ","Oh wow, I hadn't even noticed! You're so smart!","I'm pretty sure that if magic were a real thing, Skaia would be using it egregiously."], ["Really. The PLANETS not making sense is what bothers you, not the time travel, not the paradoxes, and definitely not all the nearly magical powers we apparently all have.", "If you used your brain even once a month, you'd see that CLEARLY the laws of physics do not apply in the Medium.", "Do you even have eyes? Or have they become vestigal in self defense after catching too many glances of your own putrid husk in the mirror. GRAVITY isn't even keeping the planets in correct orbits, the entire 'skaia system' is flawed on a fundamental level if you are assuming standard laws of physics, but YOU only care about the superficial shit like atmospheres."]));
		return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2);
	}

	/*
		//Troll words: year, month, refrigerator, bathtub, ears, heart, brain,rap,nose,mouth,bed,tea,worm,beans,tree,legs,eyes, gold star,born,toilet,foot,spine,vampire,tits,baby,
	*/
	this.chatAboutWriting = function(p1, p2,p1Start, p2Start, relationship, relationship2){
		var interest = "Writing";
		//InterestConversationalPair(interest, line1, responseLinesSharedInterestPositive, responseLinesSharedInterestNegative))
		var chats = [];
		//chats.push(new InterestConversationalPair(interest, "", ["","",""], ["", "", "","", ""]));
		chats.push(new InterestConversationalPair(interest, "Have you seen the fic I wrote about those two super heroes?", ["Yes, it got so sad, though. :( ","It was so cool, I never thought about those characters that way!","I really liked it, but I sure had to look up a lot of words."], ["I have no idea why you had to make the main character a vampire. That shit was unnecessary.", "By the end of it, I could feel my brain leaking out of my ears. Learn what a 'thesaurus' is. ", "They were completley off character, it's like you just stole somebody else's story and shoved super heroes into it."]));
		chats.push(new InterestConversationalPair(interest, "Hey, when you get a chance can you beta read my new chapter?", ["omg of COURSE!","Oh hell yes! I can't wait to find out what happens next!","Absolutely. Just send it to me whenever."], ["Holy shit. We are locked in a DEATH GAME and you are taking the time to write? What is WRONG with you?", "Hell no, my eyes can not take even one more chapter of your shitty writing.", "Yeah, how about 'no'?", "Why the hell does someone like YOU have so much talent. God. It's wasted on you."]));
		chats.push(new InterestConversationalPair(interest, "Oh man, SBURB is giving me all sorts of ideas for a new campaign to DM.", ["omg I know right?  Say what you will about the apocalypse, but it's full of drama.","Oh man, I call brawler.","Normally I'd be all for running a campaign with you...but is SBURB really such good source material?"], ["Yeah, it sure does sound like a good idea to make a roleplaying campaign about the game that killed your entire species. Asshole.", "Holy shit is that a bad idea. In fact, I think it might be the worst possible idea. Gold star for you.", "Yeah. Not gonna play that shit if you paid me to."]));
		chats.push(new InterestConversationalPair(interest, "When all this is over, I think I'm going to finally write my novel.", ["Oh man, you'll be the new universe's first author!","If anyone can do it, it's you!","You were born to be the new universe's first published author."], ["Should you REALLY be making plans for the future in the middle of a death game? ", "How much of a self absorbed asshole ARE you?", "Like anybody would read anything YOU wrote."]));
		return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2);
	}

	//Troll words: year, month, refrigerator, bathtub, ears, heart, brain,rap,nose,mouth,bed,tea,worm,beans,tree,legs,eyes, gold star,born,toilet,foot,spine,vampire,tits,baby,

	this.chatAboutRomance = function(p1, p2,p1Start, p2Start, relationship, relationship2){
		var interest = "Romance";
		var chats = [];
		//chats.push(new InterestConversationalPair(interest, "", ["","",""], ["", "", "","", ""]));
		chats.push(new InterestConversationalPair(interest, "Gosh, do you know what everybody being dead means? Our SOUL MATES must be the other players! That makes it WAY more likely to find them!", ["omg i hadn't though of it in that light!","You are so right. Romance for everybody!","But, what if you're wrong and our soulmates died in the apocalypse?"], ["Huh, what's that strange sensation? Oh, it must be my brain dribbling out of my ears. People DIED, asshole.", "God, how stupid can you get, that's not how soul mates work, asshole.", "Even that IS true, it's not worth billions of people dying, asshole."]));
		chats.push(new InterestConversationalPair(interest, "How am I supposed to get any good ships with only " + this.session.players.length + " people left!", ["Hrrm...guess this will be the shipping challenge of our lives.","If anyone can do it, it's you. I believe in you with all my heart.","I'd argue it makes it easier. You don't have to worry about strangers coming out of nowhere and wrecking your ships!"], ["Oh yes, the world ends but it's not a tragedy until it effects SHIPPING.", "God, I hate you. If hate were a tree mine would be a mighty sequoia, towering over all others like a mighty 'fuck you' to God himself.", "If you were any good at ships then you wouldn't let a minor think like the WORLD FUCKING ENDING stop you."]));
		///TODO what about x/y (if there are at least two remaining people who aren't p1 or p2)
		chats.push(new InterestConversationalPair(interest, "Yeah, the end of the world sucked, but at least it brought us together!", ["That is so sweet! You'll always be in my heart.","I feel the same way, we never would have met in person if it wasn't for all of this!","It's like you're reading my mind!"], ["God, hearing you write off billions of deaths in the name of romance only makes me hate you more.", "Is your brain made of worms? People DIED but it's OKAY because some people started dating? What is WRONG with you?", "That may be the dumbest thing I've ever heard. Have a gold star."]));
		return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2);

	}

	this.chatAboutSocial = function(p1, p2,p1Start, p2Start, relationship, relationship2){
		var interest = "Social";
		var chats = [];
		//chats.push(new InterestConversationalPair(interest, "", ["","",""], ["", "", "","", ""]));
		chats.push(new InterestConversationalPair(interest, "The furryocious cat stalks the chat window, pouncing out of nowhere when they see " + p2.chatHandleShort() + "!", [p2.chatHandleShort() + " is very surprised to be suddenly pounced by " + p1.chatHandleShort() + " and almost attacks them because they are so suprised, but then instead they hug.","Hi " + p1.chatHandleShort() + "! I am a terrified mouse today! 'squeak!'",p2.chatHandleShort()+" is so happy to see " + p1.chatHandleShort() + " that they pet them and hug them forever!"], [p2.chatHandleShort() + " is unimpressed with the tiny cat and contemplates eating it in one mighty bite!", "Is this really the time to roleplay, asshole?", "As much as I enjoy roleplaying, there is not enough boonbucks in the medium to pay met to do it with you."]));
		chats.push(new InterestConversationalPair(interest, "Do we really have to kill the underlings? They seem so cute... :(", ["I know right! Makes you want to just give them a big hug!","So adorable!","I know, but how else are we supposed to get grist and level up?"], ["Ugh, when people think animal lovers are unrealistic assholes, YOU are the kind of person they are thinking of.", "You give animal lovers a bad name.", "Go ahead, try not to fight them, see what happens, asshole."]));
		chats.push(new InterestConversationalPair(interest, "I wonder what it's like to be a consort? What motivates them? Do they experience existential dread knowing for a fact that their memories are false and then only recently began existing?", ["I'd imagine the experience is normalized for them, and thus not a source of negative feelings.","Well, can you prove that YOU are not the same? Who is to say ANY memories are true?","I suspect that the consorts might be too simple, psychologically, to experience existential dread."], ["Have a gold star for coming up with the most depressing thing I've heard since the world ended.", "Is this really a priority for you?", "Oh ho ho, it sounds like you're projecting a little bit there. How do YOU feel about knowing you are merely a pawn in Skaia's machinations?"]));
		return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2);

	}
	//Troll words: year, month, refrigerator, bathtub, ears, heart, brain,rap,nose,mouth,bed,tea,worm,beans,tree,legs,eyes, gold star,born,toilet,foot,spine,vampire,tits,baby,

	this.chatAboutTechnology = function(p1, p2,p1Start, p2Start, relationship, relationship2){
		var interest = "Technology";
		var chats = [];
		//chats.push(new InterestConversationalPair(interest, "", ["","",""], ["", "", "","", ""]));
		chats.push(new InterestConversationalPair(interest, "So, if SBURB is just code, that means we could hack it, right?", ["Hell yes, if anybody's l337 haxor skills are mad enough, it's yours!","Shit, that's probably doable.","Somehow I get a bad feeling about that. Like, if we were a movie, the audience would be screaming at us 'don't do it, dipshits!'"], ["Oh yes, why don't you use your 'skillz' to hack goddamned reality! What's the worst that can go wrong, other than crashing all of goddamned existance!", "What part of your brain could POSSIBLY think that's a good idea?", "Sure, go ahead, but it's not my cup of tea to have all of reality crash.","Whatever floats your boat, asshole."]));
		chats.push(new InterestConversationalPair(interest, "I am very tempted to try to make a robot to do some of these bullshit sidequests.", ["Hell yes, robots are awesome and there is nothing more to say on the matter.","Oh man, you should totally call them 'brobot'. ","Hell FUCKING yes."], ["Bluh, with your 'skillz' it would probably go crazy and kill us all.", "Because the RESPONSIBLE thing to do is bring yet another life under SBURB's bullshit influence.", "If you were MY creator, the first order of business would be to usurp your ass."]));
		chats.push(new InterestConversationalPair(interest, "I am pretty sure I could rig up an assembly line to get us alchemy products.", ["Oh man, infinite high level goods ftw.","Hell yes, I say go for it.","Ooo, I could probably throw together a grist procural factory to feed it!"], ["God, do you really think alchemy is that hard? It takes like two goddamned seconds.", "What would be the point? What we need is GRIST, not random stupid final products.", "Have a gold star for 'most pointless idea of the year'. You've earned it."]));
		return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2);
	}

	this.chatAboutPopCulture = function(p1, p2,p1Start, p2Start, relationship, relationship2){
		var interest = "PopCulture";
		var chats = [];
		//chats.push(new InterestConversationalPair(interest, "", ["","",""], ["", "", "","", ""]));
		chats.push(new InterestConversationalPair(interest, "Oh man, these game powers are just like being a super hero!", ["Hell yes, we are the super heroes, it is us!","Oh man, I call the Mighty " + p2.aspect + "!","I know, right?"], ["Bluh, in your case proably a super VILLAIN.", "Yeah, you'd be the Lame Baby.", "If you're a super hero, I dub you Toilet Vampire.","Man, how can you get all excited when our super hero arc is clearly one of those gritty 'modern' ones."]));
		chats.push(new InterestConversationalPair(interest, "Holy shit everything has been like the best movie ever!", ["Yeah, it'd be way better if this were fictional.","Plenty of drama, high stakes, character arcs, yeah,  I can see it.","That sure is one way to keep positive."], ["Oh yeah, sure, no clear plot, deus ex machinas out the ass. You have shit taste in movies, did you know that?", "The majority of people have literally died and you think it's EXCITING! Holy shit are you a asshole.", "How the fuck is a group of friends being forced to play a death game...wait, no,nevermind. I feel like an asshole saying it outloud. Yeah. That'd be a pretty good movie."]));
		chats.push(new InterestConversationalPair(interest, "Who would have thought that reality would turn out to be a shitty video game?", ["I dunno, it all kind of makes sense in retrospect.","Seriously, who would put out a game with these many bugs in it?","It clearly didn't have a dedicated design team...shit is inconsistent as fuck."], ["I don't know asshole, maybe the whole 'sylladex' thing should have tipped us off.", "I still think that maybe it wasn't always a video game, somehow?", "You asshole, I'm pretty sure video games don't destroy planets. SBURB was only pretending."]));
		return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2);
	}
	//Troll words: year, month, refrigerator, bathtub, ears, heart, brain,rap,nose,mouth,bed,tea,worm,beans,tree,legs,eyes, gold star,born,toilet,foot,spine,vampire,tits,baby,
	this.chatAboutMusic = function(p1, p2,p1Start, p2Start, relationship, relationship2){
			//if both characters like rap/hiphop, etc, they rap here????
			var interest = "Music";
			var chats = [];
			if(p1.interest1 == "Rap"||p1.interest2 == "Rap" || p1.interest1 == "Turntables" || p1.interest2 == "Turntables"){
				//pass a 4 so you only get 1 line.
				chats.push(new InterestConversationalPair(interest, getRapForPlayer(p1, "", 4)[0], ["Yeah dog you got that mad flow.","Shit, your rhymes are tight.","Hell yes. Hell FUCKING yes.","Your beats are hella ill!"], [getRapForPlayer(p2, "", 4)[0]]))
				return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2);
			}
			//chats.push(new InterestConversationalPair(interest, "", ["","",""], ["", "", "","", ""]));
			chats.push(new InterestConversationalPair(interest, "Did you hear the new song by Pumpkin?", ["Pumpkin? never heard of them. I'll have to check them out. ","OMG it is my favorite! So good!","Yeah, but I like their older stuff better."], ["Ugh, Pumpkin is so last decade, you have shit taste in music.", "You mean 'WhatPumpkin', if you're referring to the band after the drummer left. God, you don't know anything.", "Out of all the people who COULD have survived the apocalypse, why did it have to be a Pumpkin fan?"]));
			chats.push(new InterestConversationalPair(interest, "Remind me to play my new song for you sometime.", ["I can't wait to hear it!","Oh, sounds fancy!","Oh man, we should do that next time we meet up!"], ["lol, why would I do that?", "God no, my ears don't need that shit. Get good.", "I'll pencil you in for one week after I go deaf. If this keeps up I will have to auspisticize you and music."]));
			chats.push(new InterestConversationalPair(interest, "'whoa-oa-oa, why did you have to take my whoa-oa-oa' Like it? It's a new song I'm writing.", ["You're so talented! Gold star for you!","I can't wait to hear you play it!","You're so great, I love it!"], ["Yeah. No.", "Is it called 'Reasons Why Nobody Should Let Me Near a Microphone'?", "Did you seriously just put 'whoa' sounds instead of lyrics. Asshole."]));
			chats.push(new InterestConversationalPair(interest, "Do you think if I tried hard enough, I could convince the Imps to do a dance number?", ["Oh, that would be so adorable!","You'd have to to stop them from fighting somehow. Maybe mind control?","If anyone could do it, it'd be you!"], ["Oh god, why would you waste time doing that?", "You need to get better taste. Or a new brain.", "Ugh, they would probably murder each other rather than participate in your shitty choreography."]));
			//InterestConversationalPair(interest, line1, responseLinesSharedInterestPositive, responseLinesSharedInterestNegative))
			return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2);
	}

	//Troll words: year, month, refrigerator, bathtub, ears, heart, brain,rap,nose,mouth,bed,tea,worm,beans,tree,legs,eyes, gold star,born,toilet,foot,spine,vampire,tits,baby,
	//did you get to the cloud district recently, what am i saying of course you didn't.
	this.chatAboutCulture = function(p1, p2,p1Start, p2Start, relationship, relationship2){
		var interest = "Culture";
		var chats = [];
		//chats.push(new InterestConversationalPair(interest, "", ["","",""], ["", "", "","", ""]));
		chats.push(new InterestConversationalPair(interest, "I really should try drawing you sometime.", ["Oh, do you really think I'd be a good model?","Oh man, I bet that would loook so cool!","You flatter me."], ["Fuck you, I wouldn't want to ruin my looks with YOUR talent.", "Hell no. You suck at art.", "Nah, your mediocre talent would only screw with my good looks."]));
		chats.push(new InterestConversationalPair(interest, "Have you ever read House of Leaves?", ["Oh god yes, what the hell was even going on with it? So crazy!","No, but I heard it's meta as hell?","Oh man! The footnotes! The hole in the book! The layers! So good!"], ["God, what a pretentious fucking book. Fuck you for reading it.", "Ugh, how can someone as terrible as you have such good taste in books?", "Fuck you for reminding me that it exists.","Yes, and fuck you for most probably restarting my nightmares about that shit.", "Ugh, of course YOU would like it. I refuse to read it."]));
		chats.push(new InterestConversationalPair(interest, "Your land is beautiful, by the way. I really should paint it sometime.", ["Maybe we can make a day of it!","You're welcome to come over anytime.","I'm glad you think so, but I'm pretty sure my land is creepy as hell."], ["Ugh, nope, no way.", "Go for it, I really want to see how much you screw this up.", "You have a twisted sense of aesthetics, did you know that?"]));
		chats.push(new InterestConversationalPair(interest, p1.land + " is like something out of a surreal painting.", ["I know, right? I keep expecting to see melting clocks everywhere.","You really have a way with words.","You should paint it!"], ["You clearly lack imagination if you think that.", "I could not disagree more.", "Learn the definition of the word 'surreal', asshole."]));
		return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2)
	}

	//oh lord, tell bad jokes here.  especially puns
	//Troll words: year, month, refrigerator, bathtub, ears, heart, brain,rap,nose,mouth,bed,tea,worm,beans,tree,legs,eyes, gold star,born,toilet,foot,spine,vampire,tits,baby,
	this.chatAboutComedy = function(p1, p2,p1Start, p2Start, relationship, relationship2){
		var interest = "Comedy";
		//InterestConversationalPair(interest, line1, responseLinesSharedInterestPositive, responseLinesSharedInterestNegative))
		var chats = [];
		chats.push(new InterestConversationalPair(interest, "Why did the ghost cross the road? To get to the other side!", ["Spoopy. Why didn't the ghost go to prom? He had no BODY to go with.","lol, because the afterlife is also called the other side but that's also where you get when you cross a road!"], ["Holy shit, could you get any worse at jokes?", "That ghost isn't the ONLY thing that's dead here. It's also your sense of humor.", "That joke is older than my guardian. You suck.","Your joke is bad and you should feel bad.", "Oh look, a variant of the 'chicken joke'. How novel. Not."]));
		chats.push(new InterestConversationalPair(interest, "Why are cats afraid of trees? Because of their bark!", ["I think I could make a better cat joke, nah, I'm just kitten.","lol, that was hilarious!","lol, dogs bark but not in the same way that trees HAVE bark!"], ["Holy shit, could you get any worse at jokes?", "That joke is older than my guardian. You suck.", "I think I have heard a worse cat joke, nah, I'm just kitten. Because you suck. ","You are ruining the nobel art of the pun.", "People like you are why puns have a bad name."]));
		chats.push(new InterestConversationalPair(interest, "I wondered why the ball was getting bigger, then it hit me!", ["lol. A man walked into a bar. Ouch!", "lol, that was hilarious!","lol, because it sounds like he realized why the ball was getting bigger, but really it was the ball, not realization, hitting him. Hilarious!"], ["Holy shit, could you get any worse at jokes?", "That joke is older than my guardian. You suck.", "Your joke is bad and you should feel bad."]));
		chats.push(new InterestConversationalPair(interest, "How do you organize a space party, you planet!", ["Oh, because 'plan it' is how you would really orgnize a themed party, but it sounds like 'planet' which is a space themed word!","Lol, A star walks into a blackhole, but nothing happens. The blackhole turns to the star and says, 'Sir, I don't think you understand the gravity of the situation'.","lol, planet sounds like 'plan it'"], ["Oh god. Fuck you for that joke. Fuck the entire concept of space. Fuck me for hearing it.", "Are those space pants, because that ass is out of this world. Unlike your jokes.", "Oh god. Fuck you. Fuck space."]));
		return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2)
	}

	this.chatAboutDomestic = function(p1, p2,p1Start, p2Start, relationship, relationship2){
		var interest = "Domestic";
		var chats = [];
		//chats.push(new InterestConversationalPair(interest, "", ["","",""], ["", "", "","", ""]));
		chats.push(new InterestConversationalPair(interest, "Remind me to alchemize some new clothes for you later.", ["Oh man, I bet they'd look so cool!","Really!? You have such good taste in fashion!","I can't wait!"], ["Ugh, never in a million years. You have shit taste.", "Remind me to take a holy vow against wearing clothes later.", "Not if they were the last pair of pants in existance.","Ugh, just imagining wearing something with your shit taste makes me feel debased."]));
		chats.push(new InterestConversationalPair(interest, "Do you think I could get any vegetables to grow on " + p1.shortLand() + "?", ["Oh man, it would be so cool if you could!","Maybe with game powers?","Wow, you have seeds in your sylladex?"], ["Do you see a sun anywhere, asshole?", "What would even be the point?", "With your brown thumb, you'd probably just kill them. "]));
		if(p2.knowsAboutSburb()){
			chats[chats.length-1].responseLinesSharedInterestPositive.push(" I'd hold onto any seeds you have until we get the Ultimate Reward.")
		}
		chats.push(new InterestConversationalPair(interest, "Remind me to make a cake later on, okay?", ["Hell yes!","Yes, I wouldn't miss it for the world.","Yes, we could all use a morale boost."], ["We are in the middle of a SBURB-damned death game and you want to BAKE!?", "You clearly have cake where your brain should be.", "I would not put anything you baked near my mouth in a million years."]));
		return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2)
	}
	//Troll words: year, month, refrigerator, bathtub, ears, heart, brain,rap,nose,mouth,bed,tea,worm,beans,tree,legs,eyes, gold star,born,toilet,foot,spine,vampire,tits,baby,

	this.chatAboutAthletic = function(p1, p2, p1Start, p2Start,relationship, relationship2){
		var interest = "Athletic";
		var chats = [];
		//chats.push(new InterestConversationalPair(interest, "", ["","",""], ["", "", "","", ""]));
		chats.push(new InterestConversationalPair(interest, "I am very STRONG, wouldn't you agree?", ["So strong. The best.","When it comes to being strong, you are simply the best there is.","You have the heart of a champion."], ["Pfft, I've seen a baby stronger than you.", "You could train for a whole year and I'd still be STRONGER.", "Just because you can pick up a refrigerator doesn't mean you are STRONG. Kids do that shit."]));
		chats.push(new InterestConversationalPair(interest, "Man, running away from all these imps sure is a good work out.", ["I've never seen anybody so fast!","You were born for running.","You ARE crazy fast. But... is the point of SBURB really to get a good work out?"], ["Grow a spine and fight back, you baby.", "You know what ELSE is a good work out? FIGHTING the imps instead of running away like a little baby.", "Oh god, why am I even here, the insults write themselves."]));
		chats.push(new InterestConversationalPair(interest, "I would have to say I am simply the best there is at these ball themed mini games.", ["You are the star, it is you.","You should give me some tips in person sometime, I think my stance is too wide.","I know! How far did you even hit that one ball! I think it made a touchdown right up the field goal. Sports."], ["Bluh, I could beat your high score if I had as much time to waste as you seem to.", "Minigames are for little baby players who poop hard in their diapers.", "Like anybody even cares about your ball handling."]));
		chats.push(new InterestConversationalPair(interest, "It is amazing what new heights of STRENGTH this game enables.", ["Yeah, my MANGRIT has never been higher.","RPG power leveling for the win.","Yeah, my legs are like tree trunks lately."], ["Yes, most of your species dies out completely but it's okay because you can now lift heavier things. Good job.", "Oh yes, completely worth it to wipe out most of your species.", "God, I really do hate you. What is the POINT in giving SBURB credit for anything when it's already taken so much from us?"]));
		return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2)

	}
	//Troll words: year, month, refrigerator, bathtub, ears, heart, brain,rap,nose,mouth,bed,tea,worm,beans,tree,legs,eyes, gold star,born,toilet,foot,spine,vampire,tits,baby,
	this.chatAboutTerrible = function(p1, p2,p1Start, p2Start, relationship, relationship2){
		var interest = "Terrible";
		var chats = [];
		//chats.push(new InterestConversationalPair(interest, "", ["","",""], ["", "", "","", ""]));
		if(p1.isTroll){
			chats.push(new InterestConversationalPair(interest, "It's like I've been saying, the hemospectrum exists for a reason.", ["Too right, lower trolls rely on those above them for guidance.","I couldn't agree more, cooler trolls are BUILT for ruling in a way hot bloods just are not.","It is such a shame that more trolls don't see it your way."], ["God, it makes me physically ill to agree with you about anything.", "I am disgusted with both of us at this point. ", "Calm your tits, asshole, you're preaching to the choir."]));
		}
		chats.push(new InterestConversationalPair(interest, "Hell yes, I've got all the boonies, baby.", ["Bling bling, yes.","Man, you have fat stacks and mad cash.","So rich you could buy Derse if you wanted to."], ["What do you want, a gold star? Money is stupid easy to get in this game.", "And just like that, my desire for money is down the toilet.", "If you even remotely had a heart, you'd stop bragging about shit like that when the entire world just ended."]));
		chats.push(new InterestConversationalPair(interest, "It amazes me that any of the commoners are capable of anything.", ["Seriously, it's like, why not wait for your betters to instruct you.","People need to figure out where their place is.","You are so right. "], ["Fuck you, it's not like you'e any better than a commoner yourself.", "Knowing you consider yourself 'uncommon' almost makes me want to be common just to not share a class with YOU.", "I have never been more embarassed to be a member of the upper class."]));
		chats.push(new InterestConversationalPair(interest, "Shut up and give me your grist. I need it.", ["You better be able to invest it better than me.","You're lucky I trust you with my hard earned spoils of war.","Sure thing!"], ["Fuck you, this is MY shit, I earned it.", "Hell no, do you know how hard it was to get all this shit. I'm keeping my grist monopoly.", "No way, bro, that's what you get for being a asshole."]));
		chats.push(new InterestConversationalPair(interest, "You're all fucking lucky I let you live.", ["You a truly magnanimous.","We are the luckiest, it's true.","We're all pretty lucky."], ["lol, like you could do anything.", "Calm your tits, it's not like anyone is afraid of you", "Oooo, so scary! I am scared.  Not."]));
		chats.push(new InterestConversationalPair(interest, "I always knew I would rule a planet with an iron fist, but I didn't think it would happen like this.", ["It is so amazing to be able to rule different planets together.","Hell yes, I feel you.", "Great conquerers think alike!"], ["Yeah, well, don't come crying to me in a month when you are up to your nose in insurrections. I have never SEEN a shittier ruler.", "Who the hell WOULD predict all this crazy SBURB shit?", "lol, good luck KEEPING it, asshole, 'cause I am already sowing the seeds of dissent in your consorts."]));
		return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2)
	}
//	//Troll words: year, month, refrigerator, bathtub, ears, heart, brain,rap,nose,mouth,bed,tea,worm,beans,tree,legs,eyes, gold star,born,toilet,foot,spine,vampire,tits,baby,

	this.chatAboutFantasy = function(p1, p2, p1Start, p2Start,relationship, relationship2){
		var interest = "Fantasy";
		var chats = [];
		//chats.push(new InterestConversationalPair(interest, "", ["","",""], ["", "", "","", ""]));
		chats.push(new InterestConversationalPair(interest, "So with all these weird game powers I am starting to suspect magic is a real thing.", ["If you believe it's a real thing, than it probably is.","Man, I hope so! I always wanted to have magic!","Man, if magic turns out to be real, it would almost make all this worth it."], ["Only a stupid baby believes in something as fake as magic.", "If magic were a real thing you sure as fuck wouldn't have any.", "Fuck you very much for reminding me how much it sucks that magic is a fake thing."]));
		chats.push(new InterestConversationalPair(interest, "So. If we're in a game now, and apparently always have been, does that mean SBURB is like 'The Matrix'?", ["That's an interesting premise. If true, then maybe everybody DIDN'T die, but instead just stopped being simulated....which would mean that we could turn them back 'on'.","Only as long as that means we don't have to suffer through 'The One' and his one facial expression.","omg, you are so right!"], ["Could you get any stupider? For reality to be a simulation like in 'The Matrix' there would have to be a higher level reality that ISN'T, and I'm pretty sure that's not the case.", "Only an asshole would even ask that question.", "God, of course you would be a fan of that shitty movie."]));
		chats.push(new InterestConversationalPair(interest, "Man, I always hoped the end of the world would have more zombies in it.", ["Yeah, but at least we're still in a desparate struggle to survive?","Yeah, shotgunkind always appealed to me.","We could pretend the imps are zombies?"], ["People died asshole. Not in your fake fucking stories, in real life. ", "Yeah, because all we fucking need is ZOMBIE underlings to fight, you asshole.", "And I here I thought you couldn't become more of an asshole. It's a motherfucking miracle."]));
		return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2)
	}


	//stop right there, criminal scum
	//Troll words: year, month, refrigerator, bathtub, ears, heart, brain,rap,nose,mouth,bed,tea,worm,beans,tree,legs,eyes, gold star,born,toilet,foot,spine,vampire,tits,baby,
	this.chatAboutJustice = function(p1, p2, p1Start, p2Start, relationship, relationship2){
		var interest = "Justice";
		var chats = [];
		//chats.push(new InterestConversationalPair(interest, "", ["","",""], ["", "", "","", ""]));
		chats.push(new InterestConversationalPair(interest, "These consorts sure do have weird ideas about justice!", ["I know right? 'That imp stole my sweet bun, kill him for me!'. Game logic, man.","Maybe SBURB is trying to say that 'justice' is defined by society and not an intrinsic property of reality?","Well, good thing we are here to teach them how it's done!"], ["Have you ever considered that maybe YOUR conception of justice is a stupid baby thing that nobody would ever agree with?", "If you had half a brain you'd realize that NPCs don't HAVE ideas, much less about justice.", "Like you're any better."]));
		chats.push(new InterestConversationalPair(interest, "I think that one of my side quests is a MYSTERY!", ["Holy shit, so jealous!","Man, why are all of your sidequests bette than mine?","Oh man, can I solve it with you later?"], ["And maybe when you solve baby's first mystery you will get a gold star! So lame.", "Don't you see that SBURB is partronizing you!?", "God, you give detectives a bad name."]));
		chats.push(new InterestConversationalPair(interest, "It appears that the consorts had a truly egalitarian society before the Denizens arrived.", ["It is a shame our own planet did not embrace such ideals before it's ultimate demize. It as as I have always said: Not even the end of the world can change a man's heart. ","That sounds like you are opressing Denizens, when all they are doing is merely existing as they were designed to.","Yeah, Denizens are the Man, man."], ["Do you even have eyes!? Do you not see what is so blindingly obvious? Those consorts have a COMPLETELY dysfunctional dystopia.", "If that's what you think a utopia looks like, you deserve it.", "Good thing Captain Obvious is here to save the day!"]));

		return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2)


	}


	//response depends on whether or not p2 shares that interest.
	this.processChatAboutInterests = function(chats, interest, p1,p2, p1Start, p2Start, relationship1, relationship2){
		var chosen = getRandomElementFromArray(chats);
		var chat = "";
		chat +=  chatLine(p1Start, p1, chosen.line1);
		chat += this.getp2ResponseBasedOnInterests(chosen, interest, p2, p2Start, relationship2)
		return chat;
	}

	this.getp2ResponseBasedOnInterests = function(chosen, interest, player, playerStart, relationship){
		console.log("interest is: " + interest)
		var chat = "";
		if(relationship.value > 0){
			if(player.interestedIn(interest)){
				console.log("interested in " + interest)
				chat += chatLine(playerStart, player, getRandomElementFromArray(chosen.responseLinesSharedInterestPositive));
			}else{
				console.log("not interested in " + interest)
				chat += chatLine(playerStart, player, getRandomElementFromArray(chosen.genericResponses));
			}
		}else{
			if(player.interestedIn(interest)){
				console.log("interested in " + interest)
				chat += chatLine(playerStart, player, getRandomElementFromArray(chosen.responseLinesSharedInterestNegative));
				console.log("adding negative shared interest response: " + chat)
			}else{
				console.log("not interested in " + interest)
				chat += chatLine(playerStart, player, getRandomElementFromArray(chosen.genericResponses));
			}
		}
		return chat;
	}


	//for some reason right now method has the player appear to be chatting with theselves.
	this.chatAboutLackOfInterests = function(relationship, relationship2){
		var p1 = this.player1;
		var p2 = this.player2;
		var p1Start = this.player1Start;
		var p2Start = this.player2Start;
		if(Math.seededRandom() > 0.5){ //change who is initiating
			p1 = this.player2;
			p2 = this.player1;
			p1Start = this.player2Start;
			p2Start = this.player1Start;
			var tmp = relationship
			relationship = relationship2;
			relationship2 = tmp;
		}
		var interest = p1.interest1;
		if(Math.seededRandom() > 0.5){ //change who is initiating
			interest = p1.interest2;
		}
		console.log("chatting about lack of interests.")
		if(academic_interests.indexOf(interest) != -1 ) return this.chatAboutAcademic(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(music_interests.indexOf(interest) != -1 ) return this.chatAboutMusic(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(culture_interests.indexOf(interest) != -1 ) return this.chatAboutCulture(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(writing_interests.indexOf(interest) != -1 ) return this.chatAboutWriting(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(pop_culture_interests.indexOf(interest) != -1 ) return this.chatAboutPopCulture(p1, p2,  p1Start, p2Start,relationship, relationship2);
		if(technology_interests.indexOf(interest) != -1 ) return this.chatAboutTechnology(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(social_interests.indexOf(interest) != -1 ) return this.chatAboutSocial(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(romantic_interests.indexOf(interest) != -1 ) return this.chatAboutRomance(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(comedy_interests.indexOf(interest) != -1 ) return this.chatAboutComedy(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(domestic_interests.indexOf(interest) != -1 ) return this.chatAboutDomestic(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(athletic_interests.indexOf(interest) != -1 ) return this.chatAboutAthletic(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(terrible_interests.indexOf(interest) != -1 ) return this.chatAboutTerrible(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(justice_interests.indexOf(interest) != -1 ) return this.chatAboutJustice(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(fantasy_interests.indexOf(interest) != -1 ) return this.chatAboutFantasy(p1, p2, p1Start, p2Start, relationship, relationship2);
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
		chats.push( new ConversationalPair("Have you tried talking to your... enemy?",["Fuck you.","No. Just. Fuck that guy.","You can't make me."]));
		chats.push( new ConversationalPair("So, I think I've made some progress with the other guy? You just have to agree to stop fucking with 'em.",["Hell no, that asshole deserves it.","No. Just. Fuck that guy.","You can't make me."]));
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
		chats.push( new ConversationalPair("Fuck you.",["What the hell, man!?","Fuck you too.","I don't have to put up with this."]));
		chats.push( new ConversationalPair("Could you GET any stupider?",["Yeah, I could turn into you!","You're one to talk!","Fuck you."]));
		chats.push( new ConversationalPair("Can you stop fucking bothering me!?",["Make me.","I don't know, CAN I?","It's not like you have anything better to do."]));
		chats.push( new ConversationalPair("Leave me alone!",["Like hell I will, this is the most fun I've had all day.","You're the one who's all up in my grill! My grill is practically your prison!","Aw, come on, you don't mean that, do you asshole?", "No can do, we are motherfuckin entrenched in this bitch."]));
		chats.push( new ConversationalPair("My hate for you is so hot and pure it could provide clean energy to our new Universe for a thousand years.",[ "You are just such a smug asshole, I can't fucking stand you.", "It's kind of funny when you get all riled up like that.","You can't possibly understand how much I hate you or even why I hate you."]));

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
		chats.push( new ConversationalPair("This game really sucks.",["Yes, you aren't kidding.","I know, right?","Represent"]));
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
			var tmp = relationship
			relationship = relationship2;
			relationship2 = tmp;
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
			chat +=  chatLine(p2start, shoosher, "What... was it like?");
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
			if(rand < 0.25){ //maybe make them MORE likely to chat about interests?
				ret += this.chatAboutInterests(trait,relationship, relationship2); //more likely to talk about interests.
			}else if(rand < 0.5){
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
		if(Math.seededRandom() > 0.5){
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
		var goodByes = ["Good day.","Farewell.","Bye bye.","Bye.", "Talk to you later!", "ttyl", "seeya","cya"];
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
		drawChat(document.getElementById("canvas"+ (div.attr("id"))), this.player1, this.player2, chatText, 0,this.getDiscussSymbol(relationship));
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
	this.genericResponses = ["Yeah.", "Tell me more", "You don't say.",  "Wow", "Cool", "Fascinating", "Uh-huh.", "Sure.", "I've heard others say the same.", "...", "Whatever.", "Yes.", "Interesting...", "Hrmmm...", "lol"]
}

function InterestConversationalPair(interest, line1, responseLinesSharedInterestPositive, responseLinesSharedInterestNegative){
	this.line1 = line1;
	this.interest = interest; //vague description of what the interest is. like "Comedy"  need this to have a common source of words.like how "shared trait" does.
	//what can i say if i like you and share your interest
	this.responseLinesSharedInterestPositive = responseLinesSharedInterestPositive;
	//what can i say if i hate you and share your interests.
	this.responseLinesSharedInterestNegative = responseLinesSharedInterestNegative;
	//below happens if you don't share an interest at all.
	this.genericResponses = ["Yeah.", , "Nice", "Double nice", "Tell me more", "You don't say.",  "Wow", "Cool", "Fascinating", "Uh-huh.", "Sure.", "I've heard others say the same.", "...", "lol","Whatever.", "Yes.", "Interesting...", "Hrmmm..."]

}
