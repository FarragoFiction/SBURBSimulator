import "dart:html";
import "../SBURBSim.dart";


//best part of this is that if i want some OTHER scene to be able to have romantic dialgoue (say i write a general purpose dialogue scene)
//it's render function can just call new QuadrantDialogue(this.session).renderContent(div); and be done.
//resuability, yo
//http://www.neoseeker.com/forums/26839/t1277308-random-npc-conversations/   (or i guess i could just play oblivion, but I want a LIST dammit, of memes to add.)
class QuadrantDialogue extends Scene {
		Player player1 = null;
	Player player2 = null;
	String player1Start = null;
	String player2Start = null;	//this should have a higher priority than land quests, 'cause the point is relationships distract you from playing the damn game.
	


	QuadrantDialogue(Session session): super(session);

	@override
	bool trigger(List<Player> playerList){
		this.player1 = null;
		this.player2 = null;
		//if want to be more frequent, can allo goodBig and badBig to trigger this as well.

		if(rand.nextDouble() > 0.5){
			this.findSemiRandomQuadrantedAvailablePlayer();
		}
		//if(this.player2 != null && this.player2.dead) //session.logger.info("corpse chat in:  " + this.session.session_id.toString());
		return (this.player1 != null && this.player2 != null); //technically if one is set both should be but whatever.
	}
	void findSemiRandomQuadrantedAvailablePlayer(){
		//set this.player1 to be a random quadranted player.
		//BUT, if there is a player in a moiralligence who is on the verge of flipping their shit, return them.  so not completely random.;
		List<Player> quadrants = [];
		for(Player p in session.getReadOnlyAvailablePlayers()){
			if(p.isQuadranted() && p.grimDark < 2) quadrants.add(p); //grim dark players don't initiate conversaion.
		}
		if (!quadrants.isEmpty) {
			this.player1 = rand.pickFrom(quadrants);
		}
		if(this.player1 != null) this.findQuardrantMate();
		//can choose anyone.
		if(this.player1 == null && session.mutator.bloodField) {
			this.player1 = session.rand.pickFrom(session.getReadOnlyAvailablePlayers());
			this.player2 = session.rand.pickFrom(this.player1.getFriends());
		}
	}
	void findQuardrantMate(){
		//set this.player2 to be one of player1's quadrant mates. first diamond, then randomly from heart, then spade, then clubs.
		List<Relationship> potentials = this.player1.getDiamonds();
		if(potentials.length > 0) this.player2 = rand.pickFrom(potentials).target;
		if(this.player2 != null && !this.player2.dead && rand.nextDouble() > 0.5){ //don't completely ignore your other relationships in favor of your moirail.
			return;
		}
		potentials.addAll(this.player1.getHearts());
		potentials.addAll(this.player1.getClubs());
		potentials.addAll(this.player1.getSpades());
    if(potentials.length > 0) this.player2 = rand.pickFrom(potentials).target;
		if(this.player2.dead) this.player2 = null;
		return;
	}
	String getDiscussSymbol(relationship){
		if(relationship.saved_type == relationship.diamond)return "discuss_palemance.png";
		if(relationship.saved_type == relationship.heart)return "discuss_romance.png";
		if(relationship.saved_type == relationship.clubs)return "discuss_ashenmance.png";
		if(relationship.saved_type == relationship.spades) return "discuss_hatemance.png ";
		return null;
	}
	Relationship getQuadrant(){
		return this.player1.getRelationshipWith(this.player2);
	}
	Relationship getQuadrant2(){
		return this.player2.getRelationshipWith(this.player1);

	}
	String chatAboutInterests(String trait, Relationship relationship, Relationship relationship2){
		//calls different methods depending on trait, THOSE methods determine what they randomly talk about (based on relationship value)
		//trolls talking about pop culture should just list out a huge movie title because i am trash.
		//maybe randomly generate the movie title because holy fuck does that sound amazing.
		//if i do that, i should have an easter egg page that is nothing BUT listing out bullshit movie titles
		//which means the code to do that should live in NOT this scene. Maybe??????????

		//having interests in common keeps the relationship from getting too boring.
		relationship.moreOfSame();
		relationship.moreOfSame();
		relationship.moreOfSame();
		Player p1 = this.player1;
		Player p2 = this.player2;
		String p1Start = this.player1Start;
		String p2Start = this.player2Start;
		if(rand.nextDouble() > 0.5){ //change who is initiating
			p1 = this.player2;
			p2 = this.player1;
			p1Start = this.player2Start;
			p2Start = this.player1Start;
			var tmp = relationship;
			relationship = relationship2;
			relationship2 = tmp;
		}
		////session.logger.info("chatting about shared interests");
		if(trait == "smart") return this.chatAboutAcademic(p1, p2, p1Start, p2Start, relationship, relationship2);
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

		return null;
	}
	String chatAboutAcademic(Player p1, Player p2, String p1Start, String p2Start, Relationship relationship, Relationship relationship2){
		String interest = "Academic";
		List<dynamic> chats = [];
		//chats.add(new InterestConversationalPair(interest, "", ["","",""], ["", "", "","", ""]));
		chats.add(new InterestConversationalPair(interest, "Do you think our echeladders represent linear power growth, or exponential?", ["It's hard to tell when there is no indicator of the ratio of power to echeladder run.","I'm leaning towards 'complete and utter randomness'. I once leveled up for tripping over a rock.","I'm leaning towards exponential, since it seems like there are small power gains per run at first, but extremely large ones by the end."], ["God, do you even listen to the words coming out of your mouth? Who fucking CARES what math is behind our bullshit rpg leveling conceit?", "If you stopped for a minute to think, you'd realize that the echeladder is random as fuck. If you use boondollars as a vague metric of 'power' at a level, you'd see that it doesn't seem to be mapped to any mathetmatical formula.", "THIS is the conundrum you've decided matters. Not how to survive this death game. Not how the bullshit game powers work. But the leveling system. Great."]));
		chats.add(new InterestConversationalPair(interest, "How can the consorts have an oral history, and even ruins, when they only started existing once we entered the medium?", ["Its probably all just fabricated by The Game.","Oh my goodness, I never thought about that!","Huh. I never thought about that before."], ["Fuck you, that's how.", "No. Body. Gives. A. Shit.", "Bullshit handwavy game magic, duh.", "By using the power of how few shits anyone gives about that topic.", "This. This is what you've been spending time thinking about? This? Really? Wow, 5/5 hats, keep it up, well done."]));
		chats.add(new InterestConversationalPair(interest, "These 'lands' just don't make sense on a fundamental level. They are so small, how do they have an atmosphere! Where is the light coming from!", ["I know right, how the hell does physics work in the Medium? What is even keeping the planets in order? They are perfect little spheres and Skaia is nowhere near as big as a sun. ","Oh wow, I hadn't even noticed! You're so smart!","I'm pretty sure that if magic were a real thing, Skaia would be using it egregiously.", "As far as I've been able to tell, almost every object, including the ground, radiates a very small amount of light. Its fascinating really."], ["Really. The PLANETS not making sense is what bothers you, not the time travel, not the paradoxes, and definitely not all the nearly magical powers we apparently all have.", "If you used your brain even once a month, you'd see that CLEARLY the laws of physics do not apply in the Medium.", "Do you even have eyes? Or have they become vestigal in self defense after catching too many glances of your own putrid husk in the mirror. GRAVITY isn't even keeping the planets in correct orbits, the entire 'skaia system' is flawed on a fundamental level if you are assuming standard laws of physics, but YOU only care about the superficial shit like atmospheres.", "No shit Sherlock, we all noticed that already."]));
		return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2);
	}
	String chatAboutWriting(Player p1, Player p2, String p1Start, String p2Start, Relationship relationship, Relationship relationship2){
		String interest = "Writing";
		//InterestConversationalPair(interest, line1, responseLinesSharedInterestPositive, responseLinesSharedInterestNegative))
		List<dynamic> chats = [];
		//chats.add(new InterestConversationalPair(interest, "", ["","",""], ["", "", "","", ""]));
		chats.add(new InterestConversationalPair(interest, "Have you seen the fic I wrote about those two super heroes?", ["Yes, it got so sad, though. :( ","It was so cool, I never thought about those characters that way!","I really liked it, but I sure had to look up a lot of words.", "That was so good it put Stan Lee to shame."], ["I have no idea why you had to make the main character a vampire. That shit was unnecessary.", "By the end of it, I could feel my brain leaking out of my ears. Learn what a 'thesaurus' is. ", "They were completley off character, it's like you just stole somebody else's story and shoved super heroes into it.", "Yes, and now I have to go drink bleach its purged from my brain."]));
		chats.add(new InterestConversationalPair(interest, "Hey, when you get a chance can you beta read my new chapter?", ["omg of COURSE!","Oh hell yes! I can't wait to find out what happens next!","Absolutely. Just send it to me whenever.", "Course, that shit is golden."], ["Holy shit. We are locked in a DEATH GAME and you are taking the time to write? What is WRONG with you?", "Hell no, my eyes can not take even one more chapter of your shitty writing.", "Yeah, how about 'no'?", "Why the hell does someone like YOU have so much talent. God. It's wasted on you.", "I promise to compile an extensive list of everything wrong with it. It might even be my side project for the next 12 millennium."]));
		chats.add(new InterestConversationalPair(interest, "Oh man, SBURB is giving me all sorts of ideas for a new campaign to DM.", ["omg I know right?  Say what you will about the apocalypse, but it's full of drama.","Oh man, I call brawler.","Normally I'd be all for running a campaign with you...but is SBURB really such good source material?", "SBURB does have some pretty complex lore shit around, yeah."], ["Yeah, it sure does sound like a good idea to make a roleplaying campaign about the game that killed your entire species. Asshole.", "Holy shit is that a bad idea. In fact, I think it might be the worst possible idea. Gold star for you.", "Yeah. Not gonna play that shit if you paid me to.", "Nothing you create will ever amount to anything, the campaign included."]));
		chats.add(new InterestConversationalPair(interest, "When all this is over, I think I'm going to finally write my novel.", ["Oh man, you'll be the new universe's first author!","If anyone can do it, it's you!","You were born to be the new universe's first published author.", "If we become the gods of the new universe, I guess that would make the book holy writ?"], ["Should you REALLY be making plans for the future in the middle of a death game? ", "How much of a self absorbed asshole ARE you?", "Like anybody would read anything YOU wrote.", "Thats a bad idea and you should feel bad for having it."]));
		return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2);
	}
	String chatAboutRomance(Player p1, Player p2, String p1Start, String p2Start, Relationship relationship, Relationship relationship2){
		String interest = "Romance";
		List<dynamic> chats = [];
		//chats.add(new InterestConversationalPair(interest, "", ["","",""], ["", "", "","", ""]));
		chats.add(new InterestConversationalPair(interest, "Gosh, do you know what everybody being dead means? Our SOUL MATES must be the other players! That makes it WAY more likely to find them!", ["omg i hadn't though of it in that light!","You are so right. Romance for everybody!","But, what if you're wrong and our soulmates died in the apocalypse?", "... I MUST UPDATE THE SHIPPING CHARTS."], ["Huh, what's that strange sensation? Oh, it must be my brain dribbling out of my ears. People DIED, asshole.", "God, how stupid can you get, that's not how soul mates work, asshole.", "Even that IS true, it's not worth billions of people dying, asshole.", "Glad you can find the silver lining on the DEATH OF OUR SPECIES."]));
		chats.add(new InterestConversationalPair(interest, "How am I supposed to get any good ships with only " + this.session.players.length.toString() + " people left!", ["Hrrm...guess this will be the shipping challenge of our lives.","If anyone can do it, it's you. I believe in you with all my heart.","I'd argue it makes it easier. You don't have to worry about strangers coming out of nowhere and wrecking your ships!", "What a conundrum!"], ["Oh yes, the world ends but it's not a tragedy until it effects SHIPPING.", "God, I hate you. If hate were a tree mine would be a mighty sequoia, towering over all others like a mighty 'fuck you' to God himself.", "If you were any good at ships then you wouldn't let a minor think like the WORLD FUCKING ENDING stop you.", "You're not. This is the sign from the universe that its time for you to finally stop shipping. You're the literal worst at it."]));
		chats.add(new InterestConversationalPair(interest, "Yeah, the end of the world sucked, but at least it brought us together!", ["That is so sweet! You'll always be in my heart.","I feel the same way, we never would have met in person if it wasn't for all of this!","It's like you're reading my mind!", "Morbid, but I appreciate the sentiment!"], ["God, hearing you write off billions of deaths in the name of romance only makes me hate you more.", "Is your brain made of worms? People DIED but it's OKAY because some people started dating? What is WRONG with you?", "That may be the dumbest thing I've ever heard. Have a gold star.", "Are you actually damaged? THE PLANET IS DEAD." ]));
		return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2);

	}
	String chatAboutSocial(Player p1, Player p2, String p1Start, String p2Start, Relationship relationship, Relationship relationship2){
		String interest = "Social";
		List<dynamic> chats = [];
		//chats.add(new InterestConversationalPair(interest, "", ["","",""], ["", "", "","", ""]));
		chats.add(new InterestConversationalPair(interest, "The furryocious cat stalks the chat window, pouncing out of nowhere when they see " + p2.chatHandleShort() + "!", [p2.chatHandleShort() + " is very surprised to be suddenly pounced by " + p1.chatHandleShort() + " and almost attacks them because they are so suprised, but then instead they hug.","Hi " + p1.chatHandleShort() + "! I am a terrified mouse today! 'squeak!'",p2.chatHandleShort()+" is so happy to see " + p1.chatHandleShort() + " that they pet them and hug them forever!"], [p2.chatHandleShort() + " is unimpressed with the tiny cat and contemplates eating it in one mighty bite!", "Is this really the time to roleplay, asshole?", "As much as I enjoy roleplaying, there is not enough boonbucks in the medium to pay met to do it with you.", p2.chatHandleShort() + "kicks the cat where the sun don't shine. Seriously, I do not want to do this with you right now."]));
		chats.add(new InterestConversationalPair(interest, "Do we really have to kill the underlings? They seem so cute... :(", ["I know right! Makes you want to just give them a big hug!","So adorable!","I know, but how else are we supposed to get grist and level up?", "Yeah, I always have to close my eyes when I attack!"], ["Ugh, when people think animal lovers are unrealistic assholes, YOU are the kind of person they are thinking of.", "You give animal lovers a bad name.", "Go ahead, try not to fight them, see what happens, asshole.", "Just remember that they're smarter then you, I'm sure the resulting indignant rage will be enough for you to overcome your frankly antique view of morals."]));
		chats.add(new InterestConversationalPair(interest, "I wonder what it's like to be a consort? What motivates them? Do they experience existential dread knowing for a fact that their memories are false and then only recently began existing?", ["I'd imagine the experience is normalized for them, and thus not a source of negative feelings.","Well, can you prove that YOU are not the same? Who is to say ANY memories are true?", "I hope its not too bad being one, I would hate to have one of those adorable little dudes feel sad!"], ["Have a gold star for coming up with the most depressing thing I've heard since the world ended.", "Is this really a priority for you?", "Oh ho ho, it sounds like you're projecting a little bit there. How do YOU feel about knowing you are merely a pawn in Skaia's machinations?", "It couldn’t be worse then being you."]));
		return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2);

	}
	String chatAboutTechnology(Player p1, Player p2, String p1Start, String p2Start, Relationship relationship, Relationship relationship2){
		String interest = "Technology";
		List<dynamic> chats = [];
		chats.add(new InterestConversationalPair(interest, "Hey, what operating system are you running again? I just realized alchemy could let me improve it.", ["Oh please, I've been running some crappy old junker since I got in the game, I need an upgrade so bad.","Some old gaming computer. Its full of patches and shit, but I'd definitely be up for a tune up.","You should remember, you gave me my last one!", "Homemade all day. I'm more then willing to let you peak around the inside tho."], ["I have a faster system then you could even dream of.", "Stay the fuck away from my Wilson.", "The last time you offered to improve my comp it ran about 38.2% slower. I'm not letting you back in.","You blew up my last computer, asshole. I'm stuck on a shitty oldbox because of you.", "Eat shit and die asshole."]));
		chats.add(new InterestConversationalPair(interest, "So, if SBURB is just code, that means we could hack it, right?", ["Hell yes, if anybody's l337 haxor skills are mad enough, it's yours!","Shit, that's probably doable.","Somehow I get a bad feeling about that. Like, if we were a movie, the audience would be screaming at us 'don't do it, dipshits!'", "Shit son, I’ll start booting the ~ATH loops and you start looking for source code. We’re doing this man, we’re causing this to transpire."], ["Oh yes, why don't you use your 'skillz' to hack goddamned reality! What's the worst that can go wrong, other than crashing all of goddamned existance!", "What part of your brain could POSSIBLY think that's a good idea?", "Sure, go ahead, but it's not my cup of tea to have all of reality crash.","Whatever floats your boat, asshole.", "I checked, its written in some osbcure mix of ~ATH and DIS*. You are nowhere near talented enough to hack it."]));
		chats.add(new InterestConversationalPair(interest, "I am very tempted to try to make a robot to do some of these bullshit sidequests.", ["Hell yes, robots are awesome and there is nothing more to say on the matter.","Oh man, you should totally call them 'brobot'. ","Hell FUCKING yes.", "Make sure to add the three laws of robotics!"], ["Bluh, with your 'skillz' it would probably go crazy and kill us all.", "Because the RESPONSIBLE thing to do is bring yet another life under SBURB's bullshit influence.", "If you were MY creator, the first order of business would be to usurp your ass.", "Yes, how convenient it would be to have another living being in absolute servitude! No moral issue to be found there!"]));
		chats.add(new InterestConversationalPair(interest, "I am pretty sure I could rig up an assembly line to get us alchemy products.", ["Oh man, infinite high level goods ftw.","Hell yes, I say go for it.","Ooo, I could probably throw together a grist procural factory to feed it!", "Gamebreaking FTW."], ["God, do you really think alchemy is that hard? It takes like two goddamned seconds.", "What would be the point? What we need is GRIST, not random stupid final products.", "Have a gold star for 'most pointless idea of the year'. You've earned it.", "Come on, I've had one running for ages now, you're only NOW thinking of this?"]));
		return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2);
	}
	String chatAboutPopCulture(Player p1, Player p2, String p1Start, String p2Start, Relationship relationship, Relationship relationship2){
		String interest = "PopCulture";
		List<dynamic> chats = [];
		chats.add(new InterestConversationalPair(interest, "Don't you miss that one TV show? About the Mobster KingPin and those detectives?", ["Hell yeah, and now we're never going to find out how it ends!","Oh my god that show was the best. I still have some on DVD, you should come round for a marathon sometime!","Oof. Honestly, biggest downside of the apocalypse."], ["No, that was a shit TV show, how the hell does one even enjoy that sort of crap.", "The show? Yes. You're frankly stupid theories about what was going to happen next? Hell no.", "Yeah, that was a great fucking show.", "No, of course not. Why would someone even like that show.", "Fucking hell, the world is dead and you're moaning over a TV show."]));
		chats.add(new InterestConversationalPair(interest, "Oh man, these game powers are just like being a super hero!", ["Hell yes, we are the super heroes, it is us!","Oh man, I call the Mighty " + p2.aspect.name + "!","I know, right?"], ["Bluh, in your case proably a super VILLAIN.", "Yeah, you'd be the Lame Baby.", "If you're a super hero, I dub you Toilet Vampire.","Man, how can you get all excited when our super hero arc is clearly one of those gritty 'modern' ones.", "You shall be the Shitty Asshole, lord of all that is shit."]));
		chats.add(new InterestConversationalPair(interest, "Holy shit everything has been like the best movie ever!", ["Yeah, it'd be way better if this were fictional.","Plenty of drama, high stakes, character arcs, yeah,  I can see it.","That sure is one way to keep positive.", "Lord of the Rings is better fight me."], ["Oh yeah, sure, no clear plot, deus ex machinas out the ass. You have shit taste in movies, did you know that?", "The majority of people have literally died and you think it's EXCITING! Holy shit are you a asshole.", "How the fuck is a group of friends being forced to play a death game...wait, no,nevermind. I feel like an asshole saying it outloud. Yeah. That'd be a pretty good movie.", "Yes, and you can be the character nobody likes."]));
		chats.add(new InterestConversationalPair(interest, "Who would have thought that reality would turn out to be a shitty video game?", ["I dunno, it all kind of makes sense in retrospect.","Seriously, who would put out a game with these many bugs in it?","It clearly didn't have a dedicated design team...shit is inconsistent as fuck."], ["I don't know asshole, maybe the whole 'sylladex' thing should have tipped us off.", "I still think that maybe it wasn't always a video game, somehow?", "You asshole, I'm pretty sure video games don't destroy planets. SBURB was only pretending.", "Everyone. Everyone could have thought that. We have been using an inventory system to store items for our entire lives."]));

		return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2);
	}
	String chatAboutMusic(Player p1, Player p2, String p1Start, String p2Start, Relationship relationship, Relationship relationship2){
			//if both characters like rap/hiphop, etc, they rap here????
			String interest = "Music";
			List<dynamic> chats = [];
			if(p1.interest1 == "Rap"||p1.interest2 == "Rap" || p1.interest1 == "Turntables" || p1.interest2 == "Turntables"){
				//pass a 4 so you only get 1 line.
				chats.add(new InterestConversationalPair(interest, getRapForPlayer(p1, "", 4)[0], ["Yeah dog you got that mad flow.","Shit, your rhymes are tight.","Hell yes. Hell FUCKING yes.","Your beats are hella ill!"], [getRapForPlayer(p2, "", 4)[0]]));
				return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2);
			}
			chats.add(new InterestConversationalPair(interest, "Did you ever hear Mobius Trip and Hadron Kaledio's last album?", ["Oh yeah, I love their blissed out style of music.","No, I don't think I ever did catch that one. You should show it to me the next time we meet up!","No, I don't think I've heard of them. Well, if you like them, they must be good!"], ["Ahaha no. Fuck no. Trip and Kal are shit.", "Mobius Trip sucks, Pumpkin for life.", "Anything made by Trip and Kal after Beta Version has been shit. I can't believe you like them.","Oh yay, lets all get aboard the techno train! No, of course I didn't. Nails down a chalkboard are more appealing then anything by those two hippies.", "Yes, I did. It hurt me physically to listen to."]));
			chats.add(new InterestConversationalPair(interest, "Did you hear the new song by Pumpkin?", ["Pumpkin? never heard of them. I'll have to check them out. ","OMG it is my favorite! So good!","Yeah, but I like their older stuff better.", "Fuck yeah. Love that bit with the drums, where it just goes DUH-DUN-DUNDUN-DUN."], ["Ugh, Pumpkin is so last decade, you have shit taste in music.", "You mean 'WhatPumpkin', if you're referring to the band after the drummer left. God, you don't know anything.", "Out of all the people who COULD have survived the apocalypse, why did it have to be a Pumpkin fan?", "Pumpkin sucks, Mobius Trip for life."]));
			chats.add(new InterestConversationalPair(interest, "Remind me to play my new song for you sometime.", ["I can't wait to hear it!","Oh, sounds fancy!","Oh man, we should do that next time we meet up!", "Hell yeah, I need some more of that sweet, sweet music."], ["lol, why would I do that?", "God no, my ears don't need that shit. Get good.", "I'll pencil you in for one week after I go deaf. If this keeps up I will have to auspisticize you and music.", "I don't mean to be rude, but I've heard bowel movements that sound better then your music. Oh wait, I do mean to be rude."]));
			chats.add(new InterestConversationalPair(interest, "'whoa-oa-oa, why did you have to take my whoa-oa-oa' Like it? It's a new song I'm writing.", ["You're so talented! Gold star for you!","I can't wait to hear you play it!","You're so great, I love it!"], ["Yeah. No.", "Is it called 'Reasons Why Nobody Should Let Me Near a Microphone'?", "Did you seriously just put 'whoa' sounds instead of lyrics. Asshole."]));
			chats.add(new InterestConversationalPair(interest, "Do you think if I tried hard enough, I could convince the Imps to do a dance number?", ["Oh, that would be so adorable!","You'd have to to stop them from fighting somehow. Maybe mind control?","If anyone could do it, it'd be you!", "Oh hell yes. I'll go grab the speakers, you start writing the choreography."], ["Oh god, why would you waste time doing that?", "You need to get better taste. Or a new brain.", "Ugh, they would probably murder each other rather than participate in your shitty choreography.", "No. Obviously. They're fucking game abstractions you fuckhead."]));
			//InterestConversationalPair(interest, line1, responseLinesSharedInterestPositive, responseLinesSharedInterestNegative))
			return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2);
	}
	String chatAboutCulture(Player p1, Player p2, String p1Start, String p2Start, Relationship relationship, Relationship relationship2){
		String interest = "Culture";
		List<dynamic> chats = [];
		chats.add(new InterestConversationalPair(interest, "Did you ever go see that opera I told you about?", ["Oh no! I never got too! And now the planet's dead and I'll never be able too! D:","Yeah, its such a pity the lead singer is dead now.","Oh hell yes, that opera was amazing. That solo when the heroine died? Priceless.", "Yeah, I saw that TEN TIMES. It rocked."], ["Ugh, of course not. That theater had been over for years, it went for spectacle over anything meaningful. Of course you'd like it.", "Yes, It was garbage. I can't believe you could enjoy something so pedestrian and boring.", "Yeah, the singer's voice went screwy partway through. Why the hell would you like something like that?","Don't remind me. It was complete and total shit.", "Of course not. I make it a matter of policy to not go see anything you enjoy. Your taste is simply the worst there is."]));
		chats.add(new InterestConversationalPair(interest, "I really should try drawing you sometime.", ["Oh, do you really think I'd be a good model?","Oh man, I bet that would loook so cool!","You flatter me.", "I'd be more then willing to pose for a piece. Will this be a nude?"], ["Fuck you, I wouldn't want to ruin my looks with YOUR talent.", "Hell no. You suck at art.", "Nah, your mediocre talent would only screw with my good looks.", "Oh hell no. A baby crawling across a canvas would make a better looking work then you."]));
		chats.add(new InterestConversationalPair(interest, "Have you ever read House of Leaves?", ["Oh god yes, what the hell was even going on with it? So crazy!","No, but I heard it's meta as hell?","Oh man! The footnotes! The hole in the book! The layers! So good!"], ["God, what a pretentious fucking book. Fuck you for reading it.", "Ugh, how can someone as terrible as you have such good taste in books?", "Fuck you for reminding me that it exists.","Yes, and fuck you for most probably restarting my nightmares about that shit.", "Ugh, of course YOU would like it. I refuse to read it.", "It was meaningless prose wrapped up in a font of pretension."]));
		chats.add(new InterestConversationalPair(interest, "Your land is beautiful, by the way. I really should paint it sometime.", ["Maybe we can make a day of it!","You're welcome to come over anytime.","I'm glad you think so, but I'm pretty sure my land is creepy as hell."], ["Ugh, nope, no way.", "Go for it, I really want to see how much you screw this up.", "You have a twisted sense of aesthetics, did you know that?"]));

		//MI: The line below wasn’t working for me, but you said worked on your end? (JR: Yup, and i turned it back on. shenaigans, i guess.)
		if(p1.land != null) chats.add(new InterestConversationalPair(interest, p1.land.name + " is like something out of a surreal painting.", ["I know, right? I keep expecting to see melting clocks everywhere.","You really have a way with words.","You should paint it!"], ["You clearly lack imagination if you think that.", "I could not disagree more.", "Learn the definition of the word 'surreal', asshole."]));
		return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2);
	}
	String chatAboutComedy(Player p1, Player p2, String p1Start, String p2Start, Relationship relationship, Relationship relationship2){
		String interest = "Comedy";
		//InterestConversationalPair(interest, line1, responseLinesSharedInterestPositive, responseLinesSharedInterestNegative))
		List<dynamic> chats = [];
		chats.add(new InterestConversationalPair(interest, "Knock knock.", ["Hon, as much as I care for you, I know all your knock knock jokes.", "Okay, Imma have to stop you right there. We already decided no knock knock jokes. That way lies madness.", "Who's there? Oh look, its the greatest person ever!"], ["Could you go get the door, theres an idiot outside.", "Oh god not these again.", "I will come over there and kick you in the face if you try to finish that joke.", "Knock knock jokes are the lowest form of comedy."]));
		chats.add(new InterestConversationalPair(interest, "Why did the ghost cross the road? To get to the other side!", ["Spooky. Why didn't the ghost go to prom? He had no BODY to go with.","lol, because the afterlife is also called the other side but that's also where you get when you cross a road!"], ["Holy shit, could you get any worse at jokes?", "That ghost isn't the ONLY thing that's dead here. It's also your sense of humor.", "That joke is older than my guardian. You suck.","Your joke is bad and you should feel bad.", "Oh look, a variant of the 'chicken joke'. How novel. Not."]));
		chats.add(new InterestConversationalPair(interest, "Why are cats afraid of trees? Because of their bark!", ["I think I could make a better cat joke, nah, I'm just kitten.","lol, that was hilarious!","lol, dogs bark but not in the same way that trees HAVE bark!"], ["Holy shit, could you get any worse at jokes?", "That joke is older than my guardian. You suck.", "I think I have heard a worse cat joke, nah, I'm just kitten. Because you suck. ","You are ruining the nobel art of the pun.", "People like you are why puns have a bad name."]));
		chats.add(new InterestConversationalPair(interest, "I wondered why the ball was getting bigger, then it hit me!", ["lol. A man walked into a bar. Ouch!", "lol, that was hilarious!","lol, because it sounds like he realized why the ball was getting bigger, but really it was the ball, not realization, hitting him. Hilarious!"], ["Holy shit, could you get any worse at jokes?", "That joke is older than my guardian. You suck.", "Your joke is bad and you should feel bad."]));
		chats.add(new InterestConversationalPair(interest, "How do you organize a space party, you planet!", ["Oh, because 'plan it' is how you would really orgnize a themed party, but it sounds like 'planet' which is a space themed word!","Lol, A star walks into a blackhole, but nothing happens. The blackhole turns to the star and says, 'Sir, I don't think you understand the gravity of the situation'.","lol, planet sounds like 'plan it'"], ["Oh god. Fuck you for that joke. Fuck the entire concept of space. Fuck me for hearing it.", "Are those space pants, because that ass is out of this world. Unlike your jokes.", "Oh god. Fuck you. Fuck space."]));
		return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2);
	}
	String chatAboutDomestic(Player p1, Player p2, String p1Start, String p2Start, Relationship relationship, Relationship relationship2){
		String interest = "Domestic";
		List<dynamic> chats = [];
		chats.add(new InterestConversationalPair(interest, "I need to tidy your home some time", ["Ugh, yeah, its becoming such a mess.","That sounds like a great excuse for you to get the hell over here.","I'd say Spring Cleaning, but I'm not sure SBURB has seasons."], ["I have a system and you will learn a new meaning of pain if you try to messs with it.", "God no, you'd only make it look worse.", "You had a pair of socks hanging over your computer last time I was over, no WAY am I trusting you near my house.","Hahahahah fuck no.", "You can take your cleaning mania and stick up your ass."]));
		chats.add(new InterestConversationalPair(interest, "Remind me to alchemize some new clothes for you later.", ["Oh man, I bet they'd look so cool!","Really!? You have such good taste in fashion!","I can't wait!", "Would this be a private fitting? *waggles eyebrows*"], ["Ugh, never in a million years. You have shit taste.", "Remind me to take a holy vow against wearing clothes later.", "Not if they were the last pair of pants in existance.","Ugh, just imagining wearing something with your shit taste makes me feel debased.", "Jesus why are you wasting grist on clothes? Especially clothes designed by you?"]));
		if(p1.land != null) chats.add(new InterestConversationalPair(interest, "Do you think I could get any vegetables to grow on " + p1.shortLand() + "?", ["Oh man, it would be so cool if you could!","Maybe with game powers?","Wow, you have seeds in your sylladex?"], ["Do you see a sun anywhere, asshole?", "What would even be the point?", "With your brown thumb, you'd probably just kill them. "]));
		if(p2.gnosis >= 1){
			chats[chats.length-1].responseLinesSharedInterestPositive.add(" I'd hold onto any seeds you have until we get the Ultimate Reward.");
		}
		chats.add(new InterestConversationalPair(interest, "Remind me to make a cake later on, okay?", ["Hell yes!","Yes, I wouldn't miss it for the world.","Yes, we could all use a morale boost.", "... CAKE TIME."], ["We are in the middle of a SBURB-damned death game and you want to BAKE!?", "You clearly have cake where your brain should be.", "I would not put anything you baked near my mouth in a million years.", "Oh god no, you always use that horrible pre-made icing stuff."]));
		return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2);
	}
	String chatAboutAthletic(Player p1, Player p2, String p1Start, String p2Start, Relationship relationship, Relationship relationship2){
		String interest = "Athletic";
		List<dynamic> chats = [];
		chats.add(new InterestConversationalPair(interest, "We should play a game of Sports Ball next time I come round.", ["I'm not completely sure thats the right name of the game, but whatever floats your boat.","Oh yeah, lets kick this shit off!","A good game could be just the thing to get my mind of the Armageddon right now, thanks!"], ["You know 'Sports Ball' isn't actually a name, right?", "Yeah, its hilarious to watch you lose.", "Yes, I think a fucking GAME is just what we need in the middle of this fucking murder trap. Seriously, time and place.","Fine, I call whichever team doesn't end up stuck with your pathetic ass.", "Fuck no, last time we played you tried to bite my ear off."]));
		chats.add(new InterestConversationalPair(interest, "I am very STRONG, wouldn't you agree?", ["So strong. The best.","When it comes to being strong, you are simply the best there is.","You have the heart of a champion.", "STRENGTH is paramount in a death game like this, yeah."], ["Pfft, I've seen a baby stronger than you.", "You could train for a whole year and I'd still be STRONGER.", "Just because you can pick up a refrigerator doesn't mean you are STRONG. Kids do that shit.", "I have a dictionary. I looked up the word STRONG, and you were next to it. As an example of what it didn't mean."]));
		chats.add(new InterestConversationalPair(interest, "Man, running away from all these imps sure is a good work out.", ["I've never seen anybody so fast!","You were born for running.","You ARE crazy fast. But... is the point of SBURB really to get a good work out?", "Run like the wind kid. Run like the wind."], ["Grow a spine and fight back, you baby.", "You know what ELSE is a good work out? FIGHTING the imps instead of running away like a little baby.", "Oh god, why am I even here, the insults write themselves.", "Pffffffft. Go back, read that scentance, then think about the life choices that brought you here. Seriously, that is down right pathetic."]));
		chats.add(new InterestConversationalPair(interest, "I would have to say I am simply the best there is at these ball themed mini games.", ["You are the star, it is you.","You should give me some tips in person sometime, I think my stance is too wide.","I know! How far did you even hit that one ball! I think it made a touchdown right up the field goal. Sports.", "Glad you like the mini games, I always find them a bit tedious."], ["Bluh, I could beat your high score if I had as much time to waste as you seem to.", "Minigames are for little baby players who poop hard in their diapers.", "Like anybody even cares about your ball handling.", "Glad to hear your so good at 'working balls'. Practice makes perfect I guess."]));
		chats.add(new InterestConversationalPair(interest, "It is amazing what new heights of STRENGTH this game enables.", ["Yeah, my MANGRIT has never been higher.","RPG power leveling for the win.","Yeah, my legs are like tree trunks lately.", "Yeah, these ECHELADDER shenanigans enable some serious power gain."], ["Yes, most of your species dies out completely but it's okay because you can now lift heavier things. Good job.", "Oh yes, completely worth it to wipe out most of your species.", "God, I really do hate you. What is the POINT in giving SBURB credit for anything when it's already taken so much from us?", "I've seen wet blankets with more STRENGTH then you, you've probably just been beating up basic enemies."]));
		return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2);

	}
	String chatAboutTerrible(Player p1, Player p2, String p1Start, String p2Start, Relationship relationship, Relationship relationship2){
		String interest = "Terrible";
		List<dynamic> chats = [];
		//chats.add(new InterestConversationalPair(interest, "", ["","",""], ["", "", "","", ""]));
		if(p1.isTroll){
			chats.add(new InterestConversationalPair(interest, "It's like I've been saying, the hemospectrum exists for a reason.", ["Too right, lower trolls rely on those above them for guidance.","I couldn't agree more, cooler trolls are BUILT for ruling in a way hot bloods just are not.","It is such a shame that more trolls don't see it your way.", "Yeah, have you heard some of the other players were thinking it was useless?"], ["God, it makes me physically ill to agree with you about anything.", "I am disgusted with both of us at this point. ", "Calm your tits, asshole, you're preaching to the choir.", "Yeah, it exists to prove how much of a worthless dirtbag you are."]));
		}
		chats.add(new InterestConversationalPair(interest, "Hell yes, I've got all the boonies, baby.", ["Bling bling, yes.","Man, you have fat stacks and mad cash.","So rich you could buy Derse if you wanted to.", "Make money get paid, lets do this shit!"], ["What do you want, a gold star? Money is stupid easy to get in this game.", "And just like that, my desire for money is down the toilet.", "If you even remotely had a heart, you'd stop bragging about shit like that when the entire world just ended.", "Shit, your still on boonies? I've been rolling in boonbanks myself. Boonies is poor people money, honsetly."]));
		chats.add(new InterestConversationalPair(interest, "It amazes me that any of the commoners are capable of anything.", ["Seriously, it's like, why not wait for your betters to instruct you.","People need to figure out where their place is.","You are so right. ", "I just regret bringing any of them into the game with us."], ["Fuck you, it's not like you'e any better than a commoner yourself.", "Knowing you consider yourself 'uncommon' almost makes me want to be common just to not share a class with YOU.", "I have never been more embarassed to be a member of the upper class.", "Learn your true place, PEON."]));
		chats.add(new InterestConversationalPair(interest, "Shut up and give me your grist. I need it.", ["You better be able to invest it better than me.","You're lucky I trust you with my hard earned spoils of war.","Sure thing!", "… Fine."], ["Fuck you, this is MY shit, I earned it.", "Hell no, do you know how hard it was to get all this shit. I'm keeping my grist monopoly.", "No way, bro, that's what you get for being a asshole.", "Fuck off and give me yours, I deserve it more then you do!"]));
		chats.add(new InterestConversationalPair(interest, "You're all fucking lucky I let you live.", ["You a truly magnanimous.","We are the luckiest, it's true.","We're all pretty lucky.", "Right back atcha :)"], ["lol, like you could do anything.", "Calm your tits, it's not like anyone is afraid of you", "Oooo, so scary! I am scared.  Not.", "I would end you here and now if I didn't hate you so much."]));
		chats.add(new InterestConversationalPair(interest, "I always knew I would rule a planet with an iron fist, but I didn't think it would happen like this.", ["It is so amazing to be able to rule different planets together.","Hell yes, I feel you.", "Great conquerers think alike!", "Lets roll this bi-planet duumvirate out!"], ["Yeah, well, don't come crying to me in a month when you are up to your nose in insurrections. I have never SEEN a shittier ruler.", "Who the hell WOULD predict all this crazy SBURB shit?", "lol, good luck KEEPING it, asshole, 'cause I am already sowing the seeds of dissent in your consorts.", "I predict a war in your planet's future. lol."]));
		return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2);
	}
	String chatAboutFantasy(Player p1, Player p2, String p1Start, String p2Start, Relationship relationship, Relationship relationship2){
		String interest = "Fantasy";
		List<dynamic> chats = [];
		//chats.add(new InterestConversationalPair(interest, "", ["","",""], ["", "", "","", ""]));
		chats.add(new InterestConversationalPair(interest, "So with all these weird game powers I am starting to suspect magic is a real thing.", ["If you believe it's a real thing, than it probably is.","Man, I hope so! I always wanted to have magic!","Man, if magic turns out to be real, it would almost make all this worth it.", "Magic is totes real and has always been."], ["Only a stupid baby believes in something as fake as magic.", "If magic were a real thing you sure as fuck wouldn't have any.", "Fuck you very much for reminding me how much it sucks that magic is a fake thing.", "Yes, magic was TOTALLY WORTH the death of our species, asshole."]));
		chats.add(new InterestConversationalPair(interest, "So. If we're in a game now, and apparently always have been, does that mean SBURB is like 'The Matrix'?", ["That's an interesting premise. If true, then maybe everybody DIDN'T die, but instead just stopped being simulated....which would mean that we could turn them back 'on'.","Only as long as that means we don't have to suffer through 'The One' and his one facial expression.","omg, you are so right!", "I need to go alchemize some leather trench coats.", "I'll go get the mirrored shades."], ["Could you get any stupider? For reality to be a simulation like in 'The Matrix' there would have to be a higher level reality that ISN'T, and I'm pretty sure that's not the case.", "Only an asshole would even ask that question.", "God, of course you would be a fan of that shitty movie."]));
		chats.add(new InterestConversationalPair(interest, "Man, I always hoped the end of the world would have more zombies in it.", ["Yeah, but at least we're still in a desparate struggle to survive?","Yeah, shotgunkind always appealed to me.","We could pretend the imps are zombies?", "Z squad for life."], ["People died asshole. Not in your fake fucking stories, in real life. ", "Yeah, because all we fucking need is ZOMBIE underlings to fight, you asshole.", "And I here I thought you couldn't become more of an asshole. It's a motherfucking miracle."]));
		return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2);
	}
	String chatAboutJustice(Player p1, Player p2, String p1Start, String p2Start, Relationship relationship, Relationship relationship2){
		String interest = "Justice";
		List<dynamic> chats = [];
		//chats.add(new InterestConversationalPair(interest, "", ["","",""], ["", "", "","", ""]));
		chats.add(new InterestConversationalPair(interest, "These consorts sure do have weird ideas about justice!", ["I know right? 'That imp stole my sweet bun, kill him for me!'. Game logic, man.","Maybe SBURB is trying to say that 'justice' is defined by society and not an intrinsic property of reality?","Well, good thing we are here to teach them how it's done!", "Yeah, one tried to arrest me for breathing wrong. I wish I was making that up."], ["Have you ever considered that maybe YOUR conception of justice is a stupid baby thing that nobody would ever agree with?", "If you had half a brain you'd realize that NPCs don't HAVE ideas, much less about justice.", "Like you're any better."]));
		chats.add(new InterestConversationalPair(interest, "I think that one of my side quests is a MYSTERY!", ["Holy shit, so jealous!","Man, why are all of your sidequests bette than mine?","Oh man, can I solve it with you later?", "GET THE DEERSTALKER HATS!"], ["And maybe when you solve baby's first mystery you will get a gold star! So lame.", "Don't you see that SBURB is partronizing you!?", "God, you give detectives a bad name.", "Don't come crying to me when you can't solve it."]));
		chats.add(new InterestConversationalPair(interest, "It appears that the consorts had a truly egalitarian society before the Denizens arrived.", ["It is a shame our own planet did not embrace such ideals before it's ultimate demise. It as as I have always said: Not even the end of the world can change a man's heart. ","That sounds like you are oppressing Denizens, when all they are doing is merely existing as they were designed to.","Yeah, Denizens are the Man, man.", "All the more reason for us to go fuck them up, right?"], ["Do you even have eyes!? Do you not see what is so blindingly obvious? Those consorts have a COMPLETELY dysfunctional dystopia.", "If that's what you think a utopia looks like, you deserve it.", "Good thing Captain Obvious is here to save the day!", "Yes, clearly systemic issues can be based on a single persons actions. A++, you get ALLLL the gold stars for this TOTALLY TRUE revelation."]));

		return this.processChatAboutInterests(chats, interest, p1,p2,p1Start, p2Start, relationship, relationship2);


	}
	String processChatAboutInterests(List<InterestConversationalPair> chats, String interest, Player p1, Player p2, String p1Start, String p2Start, Relationship relationship1, Relationship relationship2){
		InterestConversationalPair chosen = rand.pickFrom(chats);
		String chat = "";
		chat +=  Scene.chatLine(p1Start, p1, chosen.line1);
		chat += this.getp2ResponseBasedOnInterests(chosen, interest, p2, p2Start, relationship2);
		return chat;
	}
	String getp2ResponseBasedOnInterests(InterestConversationalPair chosen, String interest, Player player, String playerStart, Relationship relationship){
		////session.logger.info("interest is: " + interest);
		String chat = "";
		if(relationship != null && relationship.value > 0){
			if(player.interestedInCategory(InterestManager.getCategoryFromString(interest))){
				////session.logger.info("interested in " + interest);
				chat += Scene.chatLine(playerStart, player, rand.pickFrom(chosen.responseLinesSharedInterestPositive));
			}else{
				////session.logger.info("not interested in " + interest);
				chat += Scene.chatLine(playerStart, player, rand.pickFrom(chosen.genericResponses));
			}
		}else{
			if(player.interestedInCategory(InterestManager.getCategoryFromString(interest))){
				////session.logger.info("interested in " + interest);
				chat += Scene.chatLine(playerStart, player, rand.pickFrom(chosen.responseLinesSharedInterestNegative));
				////session.logger.info("adding negative shared interest response: " + chat);
			}else{
				////session.logger.info("not interested in " + interest);
				chat += Scene.chatLine(playerStart, player, rand.pickFrom(chosen.genericResponses));
			}
		}
		return chat;
	}
	String chatAboutLackOfInterests(relationship, relationship2){
		var p1 = this.player1;
		var p2 = this.player2;
		var p1Start = this.player1Start;
		var p2Start = this.player2Start;
		if(rand.nextDouble() > 0.5){ //change who is initiating
			p1 = this.player2;
			p2 = this.player1;
			p1Start = this.player2Start;
			p2Start = this.player1Start;
			var tmp = relationship;
			relationship = relationship2;
			relationship2 = tmp;
		}
		var interest = p1.interest1;
		if(rand.nextDouble() > 0.5){ //change who is initiating
			interest = p1.interest2;
		}
		////session.logger.info("chatting about lack of interests.");
		if(interest.category == InterestManager.ACADEMIC ) return this.chatAboutAcademic(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(interest.category == InterestManager.MUSIC) return this.chatAboutMusic(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(interest.category == InterestManager.CULTURE ) return this.chatAboutCulture(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(interest.category == InterestManager.WRITING ) return this.chatAboutWriting(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(interest.category == InterestManager.POPCULTURE ) return this.chatAboutPopCulture(p1, p2,  p1Start, p2Start,relationship, relationship2);
		if(interest.category == InterestManager.TECHNOLOGY) return this.chatAboutTechnology(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(interest.category == InterestManager.SOCIAL) return this.chatAboutSocial(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(interest.category == InterestManager.ROMANTIC ) return this.chatAboutRomance(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(interest.category == InterestManager.COMEDY) return this.chatAboutComedy(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(interest.category == InterestManager.DOMESTIC) return this.chatAboutDomestic(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(interest.category == InterestManager.ATHLETIC) return this.chatAboutAthletic(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(interest.category == InterestManager.TERRIBLE) return this.chatAboutTerrible(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(interest.category == InterestManager.JUSTICE) return this.chatAboutJustice(p1, p2, p1Start, p2Start, relationship, relationship2);
		if(interest.category == InterestManager.FANTASY) return this.chatAboutFantasy(p1, p2, p1Start, p2Start, relationship, relationship2);
		return null;
	}
	String chatAboutQuadrant(relationship, relationship2){
		//calls different methods based on quadrant.  THOSE methods have different shit in them based on value (foreshadows break up.)
		if(relationship.saved_type == relationship.diamond)return this.diamondsChat(relationship, relationship2);
		if(relationship.saved_type == relationship.heart)return this.heartChat(relationship, relationship2);
		if(relationship.saved_type == relationship.clubs)return this.clubsChat(relationship, relationship2);
		if(relationship.saved_type == relationship.spades) return this.spadesChat(relationship, relationship2);

		return this.diamondsChat(relationship, relationship2);
	}
	String getQuadrantASCII(relationship){
		if(relationship.saved_type == relationship.diamond)return " <> ";
		if(relationship.saved_type == relationship.heart)return " <3 ";
		if(relationship.saved_type == relationship.clubs)return " c3< ";
		if(relationship.saved_type == relationship.spades) return " <3< ";
		return "???";
	}
	dynamic clubsChat(relationship1, relationship2){
		////session.logger.info("Clubs Chat in: " + this.session.session_id);
		List<dynamic> chats = [];
		chats.add( new ConversationalPair("I saw a mudcrab the other day.",["Terrible Creatures."])); //make this added only randomly if it's too common. can't believe i almost forgot.

		chats.add( new ConversationalPair("So. Behaving?",["Fuck you I do what I want.","Yes, MOM.","God, could you just leave me alone?", "No thanks to the other asshole, yes. Yes I am."]));
		chats.add( new ConversationalPair("You're not getting into any trouble, are you?",["Oh yeah, tons of trouble. I'm literally sitting in a puddle of that assholes blood RIGHT now.","Ugh. No. I'm behaving.","Can't you just stop meddling?", "No MOM."]));
		chats.add( new ConversationalPair("Have you tried the breathing exercises I recomended?",["They don't fix the fundamental problem of that asshole existing.","All they did was make me hate breathing.","Fuck you.", "Yes, I almost passed out, so THANKS."]));
		chats.add( new ConversationalPair("Have you tried talking to your... enemy?",["Fuck you.","No. Just. Fuck that guy.","You can't make me.", "Yeah, I tried to shank them."]));
		chats.add( new ConversationalPair("So, I think I've made some progress with the other guy? You just have to agree to stop fucking with 'em.",["Hell no, that asshole deserves it.","No. Just. Fuck that guy.","You can't make me.", "I will stop fucking with them when they stop being so easily fuckable. Wait, no thats not what I meant!"]));
		chats.add( new ConversationalPair("You two are a menace to yourselves and each other. Desist, or I will assist you in desisting.",["Fuck no, you're not the boss of me!","Fine, WHATEVER.","Oh god please just don't hurt me."]));
		chats.add( new ConversationalPair("Progress?",["With what.","No, the bastard tried to shank me!","Just leave us alone!"]));

		//chats.add( new ConversationalPair("",["","",""]));
		return  this.processChatPair(chats, relationship1, relationship2);
	}
	dynamic processChatPair(chats, relationship1, relationship2){
		String chat = "";
		var chosen = rand.pickFrom(chats);
		if(rand.nextDouble() > 0.5){
			chat +=  Scene.chatLine(this.player1Start, this.player1, chosen.line1);
			chat += chosen.getResponseRelationship(this.player2, this.player2Start, relationship2);
		}else{
			chat +=  Scene.chatLine(this.player2Start, this.player2, chosen.line1);
			chat += chosen.getResponseRelationship(this.player1, this.player1Start, relationship1);
		}
		return chat;
	}
	dynamic spadesChat(relationship1, relationship2){
		////session.logger.info("Spades Chat  in: " + this.session.session_id);
		List<dynamic> chats = [];
		chats.add( new ConversationalPair("God, how can anyone be so bad at this game? You suck.",["Fuck you, I killed that imp like a boss.","Like you're any better!","Fuck off!", "Go jump of a bridge."]));
		chats.add( new ConversationalPair("Jegus, stop hogging the grist!",["Make me!","Fuck you, I earned it!","Well, YOU stop hogging the echeladder rungs!", "Eat shit, asshole."]));
		chats.add( new ConversationalPair("How can anyone smell as bad as you do?",["Don't talk to me about rank smells. You are the fucking big man of smelling bad.","Fuck you, It's not my fault my bathtub was destroyed!","I am not going to dignify that with a response."]));
		chats.add( new ConversationalPair("Fuck you.",["What the hell, man!?","Fuck you too.","I don't have to put up with this.", "Buy me a drink first.", "Name a time and place."]));
		chats.add( new ConversationalPair("Could you GET any stupider?",["Yeah, I could turn into you!","You're one to talk!","Fuck you."]));
		chats.add( new ConversationalPair("Can you stop fucking bothering me!?",["Make me.","I don't know, CAN I?","It's not like you have anything better to do."]));
		chats.add( new ConversationalPair("Leave me alone!",["Like hell I will, this is the most fun I've had all day.","You're the one who's all up in my grill! My grill is practically your prison!","Aw, come on, you don't mean that, do you asshole?", "No can do, we are motherfuckin entrenched in this bitch.", "AND IT DON'T STOP."]));
		chats.add( new ConversationalPair("My hate for you is so hot and pure it could provide clean energy to our new Universe for a thousand years.",[ "You are just such a smug asshole, I can't fucking stand you.", "It's kind of funny when you get all riled up like that.","You can't possibly understand how much I hate you or even why I hate you."]));
		chats.add( new ConversationalPair("You are so fucking annoying.",["And you know you love it.","Fuck you too.","I don't have to put up with this.","Have you ever looked in a mirror?."]));
		chats.add( new ConversationalPair("I swear to whatever fucked up god controls this shitty universe, if you keep this up I will fuck you up.",["Hmm, is that a promise?","Come and fucking get it.","Yes, because whatever being keeps fucking with us totally gives a shit about your promises.","Go eat dirt, asshole."]));
		chats.add( new ConversationalPair("Eat my ass!",["Is that an insult, a threat or a promise?","Truly, your refinement leaves us all in awe.","Eat my fist."]));
		chats.add( new ConversationalPair("Stop fucking with me!",["I will stop fucking with you when you stop being so fuckable.","But its so funny!","lol no. :)"]));
		chats.add( new ConversationalPair("I can and will fight you.",["Sure noodle arms. Whatever you say.","I can and will beat you like a drum.","lol no. So much no."]));
		chats.add( new ConversationalPair("I hope this game rips you apart.",["It can fucking try.","Hate you too asshole.","I will bend this game to my will if it kills me."]));
		chats.add( new ConversationalPair("I have had bowel movements that smelled nicer then you.",["I've had bowel movements that looked nicer then you.","Glad to know you spend so much time smelling your own bowel movements","You do understand the reason I refuse to go to your land is the smell, right?"]));


		return  this.processChatPair(chats, relationship1, relationship2);
	}
	dynamic heartChat(Relationship relationship1, Relationship relationship2){
		////session.logger.info("Heart Chat  in: " + this.session.session_id);
		List<dynamic> chats = [];
		chats.add( new ConversationalPair("You're so good at this game!",["No, way, you're tons better than me.","Heh, about time I'm good at something, huh?","Only because I get to play it with you :)"]));
		chats.add( new ConversationalPair("Do you need any extra grist?",["Oh, thanks!","No, I'm good, but it's so sweet of you to offer.","Heh, I was going to ask YOU that.", "What would I do without you? Yes, yes of course I do."]));
		chats.add( new ConversationalPair("Wow, I feel like I could talk to you forever!",["Same. It's like we finish each others sandwiches.","I know, right! It's so great.","Exactly! Let's meet up later and do quests", "Hey, we've got time!"]));
		chats.add( new ConversationalPair("I can't believe we are actually together!",["It's like a dream come true.","I'm still reminding myself it's real.","It's like something out of a movie :)", "Yeah... its a pity the world had to end to make it really happen." ]));
		chats.add( new ConversationalPair("What's your favorite drink?",["AJ.","Orange Soda.","Purple drank.", "Tea.", "Coffee.", "Hot Chocolate.", "Lemonade.", "Faygo.", "Water.", "Milk"]));
		chats.add( new ConversationalPair("Hey, you want to hang out later?",["Of course!","Oh hell to the yes.","YesyesyeysyesYES."]));
		chats.add( new ConversationalPair("I wonder what this game is going to throw at us next.",["Probably something very stupid.","Can't be as bad as what we've already seen.","Not spiders, hopefully. Hate them.","With any luck, something good."]));
		chats.add( new ConversationalPair("Hows quests?",["They'd be better with you here <3.","So-so, just had a really strange one involving a cod piece.","Questy","Grinding all day every day."]));
		chats.add( new ConversationalPair("Hows that one side quest going?",["Needlessly complicated, like everything in this stupid game.","Well its looking like I'm going to have to go to Derse so yeah. Thats a thing.","Stupidly stupidly.","It would be better with you here.","Finally found the consort the quest wants me to talk to."]));
		chats.add( new ConversationalPair("Hows the building up going?",["My fucking server player keeps making stairs.","Like a fly through honey","Grist is low, house is high. Bluuuh."]));
		chats.add( new ConversationalPair("Jesus fuck have you seen the size of some of these underlings?",["Do they get that big over there? Most of mine are waist-high at most.","I KNOW RIGHT?","Yeah, things those size shouldn't be able to exist."]));
        chats.add( new ConversationalPair("Lemme Smash. Please?",["Oh god...remind me why I'm dating you again?","No Ron. Go find Becky.","You want some blue?", "You want sum fuk?", "No. We are done with this meme. I love you, but I am done."])); //can't believe i forgot to add this.
		List<String> romanceWords = <String>["roses","poetry","chocolate","angels","flowers","perfume","bracelets","diamonds","mcgriddles","satin","flour","biscuits","blue","gems", "grist", "boonbucks","fruit gushers","death",relationship2.target.aspect.name,"heat"];
		//reference to the bad fanfic that smutServer made of AB and Hair7 They used: http://fanficmaker.com/  (which is random as fuck)
		String chosenWord1 = rand.pickFrom(romanceWords);
		String chosenWord2 = rand.pickFrom(romanceWords);
		chats.add( new ConversationalPair("Did I ever tell you you are like a sunrise of $chosenWord1? ",["Only every day. I love it!","You eyes are like an ocean of $chosenWord2", "I always thought I was more like a high noon of $chosenWord2", "Every time I see $chosenWord1, I will think of you."])); //can't believe i forgot to add this.



		return  this.processChatPair(chats, relationship1, relationship2);
		//chats.add( new ConversationalPair("",["","",""]));
	}
	dynamic diamondsChat(relationship1, relationship2){
		////session.logger.info("Diamonds Chat  in: " + this.session.session_id);
		List<dynamic> chats = [];
		this.player1.addStat(Stats.SANITY, 1);
		this.player2.addStat(Stats.SANITY, 1);
		chats.add( new ConversationalPair("How have you been?",["Okay.","Good.","Alright.","As well as can be expected.","Better than I thought I'd be.", "Functioning."]));
		chats.add( new ConversationalPair("You doing okay?",["Yes.","As well as can be expected.","Better than I thought I'd be.", "I'm fine. I think."]));
		chats.add( new ConversationalPair("This game really sucks.",["Yes, you aren't kidding.","I know, right?","Represent", "I'm glad I got you to help me through it."]));
		chats.add( new ConversationalPair("Any big changes?",["I... I think I'm okay.","You have no idea.","This is gonna be a long list."]));
		chats.add( new ConversationalPair("Quick check in, how are you?",["Okay-ish.","As well as can be expected.","Better than I thought I'd be :)", "I'm fine. I think.","Bluuuuuuh"]));

		//chats.add( new ConversationalPair("",["","",""]));
		return  this.processChatPair(chats, relationship1, relationship2);
	}
	dynamic feelingsJam(relationship, relationship2){
		////session.logger.info("Feelings Jam in: " + this.session.session_id);
		this.player1.addStat(Stats.SANITY, 2);
		this.player2.addStat(Stats.SANITY, 2);
		//figure out which player is flipping out, make them "flippingOut", make other player "shoosher"
		String chat = "";
		var freakOutWeasel = this.player1;
		var p1start = this.player1Start;
		var shoosher = this.player2;
		var p2start = this.player2Start;
		if(freakOutWeasel.flipOutReason == null){
			freakOutWeasel = this.player2;
			p1start = this.player2Start;
			shoosher = this.player1;
			p2start = this.player1Start;
			var tmp = relationship;
			relationship = relationship2;
			relationship2 = tmp;
		}
		if(freakOutWeasel.flipOutReason == null) return "ERROR: NO ONE IS FLIPPING OUT.";
		if(freakOutWeasel.flippingOutOverDeadPlayer != null && freakOutWeasel.flippingOutOverDeadPlayer.dead){
			Relationship deadRelationship = freakOutWeasel.getRelationshipWith(freakOutWeasel.flippingOutOverDeadPlayer);
			String relationshipName = "Mystery Relation"; //nobody knows who they are
			if(deadRelationship != null) relationshipName =deadRelationship.nounDescription();
			chat +=  Scene.chatLine(p1start, freakOutWeasel, "Oh god. Oh god they are dead. Fuck.");
			chat +=  Scene.chatLine(p2start, shoosher, "Shit. Wait, who is dead?");
			chat +=  Scene.chatLine(p1start, freakOutWeasel,freakOutWeasel.flippingOutOverDeadPlayer.chatHandle + ". Fuck. They died " + freakOutWeasel.flippingOutOverDeadPlayer.causeOfDeath );
			chat +=  Scene.chatLine(p2start, shoosher, "Shit. Weren't they your " + relationshipName + "? Fuck.");
			chat +=  Scene.chatLine(p1start, freakOutWeasel, "Yeah. Fuck.");
			chat +=  Scene.chatLine(p2start, shoosher, "Listen. It's okay. Maybe this game has a bullshit way to bring them back?");
			chat +=  Scene.chatLine(p1start, freakOutWeasel, "I hope so.");
		}else if(freakOutWeasel.flippingOutOverDeadPlayer != null && !freakOutWeasel.flippingOutOverDeadPlayer.dead){
			var deadRelationship = freakOutWeasel.getRelationshipWith(freakOutWeasel.flippingOutOverDeadPlayer);
			String relationshipName = "Mystery Relation"; //nobody knows who they are
			chat +=  Scene.chatLine(p1start, freakOutWeasel, "Jesus fuck, apparently my " + relationshipName + ", " + freakOutWeasel.flippingOutOverDeadPlayer.chatHandle + ",  died.");
			chat +=  Scene.chatLine(p2start, shoosher, "Oh god. I'm so sorry.");
			chat +=  Scene.chatLine(p1start, freakOutWeasel, "Apparently they got better? I don't even know how to feel about this.");
			chat +=  Scene.chatLine(p2start, shoosher, "SBURB fucking sucks.");
			chat +=  Scene.chatLine(p1start, freakOutWeasel, "It really, really does.");
		}else if(freakOutWeasel.flipOutReason.indexOf("doomed time clones") != -1){
			chat +=  Scene.chatLine(p1start, freakOutWeasel, "Oh my god, time really is the shittiest aspect.");
			chat +=  Scene.chatLine(p2start, shoosher, "Everything okay?");
			chat +=  Scene.chatLine(p1start, freakOutWeasel, "Hell no. There are fucking clones of me running around and dying and agreeing to die and fuck...");
			chat +=  Scene.chatLine(p2start, shoosher, "Shoosh, it will be fine. It just proves you are dedicated to beating this game. That's a good thing.");
			chat +=  Scene.chatLine(p1start, freakOutWeasel, "No, it proves THEY are. I haven't done fuck all.");
			chat +=  Scene.chatLine(p2start, shoosher, "Shhhh, there there. They are just you in a slightly different situation. It still reflects well on you.");
			chat +=  Scene.chatLine(p1start, freakOutWeasel, "Yeah. Okay. You're right.");
		}else if(freakOutWeasel.flipOutReason.indexOf("Ultimate Goddamned Riddle") != -1){
			chat +=  Scene.chatLine(p1start, freakOutWeasel, "lol lol lololololol");
			chat +=  Scene.chatLine(p2start, shoosher, "Everything okay?");
			chat +=  Scene.chatLine(p1start, freakOutWeasel, "Oh god, it's all so FUCKING hilarious!");
			chat +=  Scene.chatLine(p2start, shoosher, "?");
			chat +=  Scene.chatLine(p1start, freakOutWeasel, "Don't you get it? The goddamned fucking ULTIMATE RIDDLE!?");
			chat +=  Scene.chatLine(p1start, freakOutWeasel, "It was right there, all along! We were always meant to play this fucking game.");
			chat +=  Scene.chatLine(p1start, freakOutWeasel, "And here I thought Skaia didn't have a sense of HUMOR!");
			chat +=  Scene.chatLine(p2start, shoosher, "Okay. You need to calm down. Whatever happened isn't ...well, I was going to say 'the end of the world', but I think that would just set you off again.");
			chat +=  Scene.chatLine(p2start, shoosher, "We aren't giving up, okay? YOU aren't giving up. We can still beat this. So calm your tits.");
			chat +=  Scene.chatLine(p1start, freakOutWeasel, "Yes. Yes. You're right. Of course your are. I'll ... try to focus.");
		}else if(freakOutWeasel.flipOutReason.indexOf("they just freaking died") != -1){
			chat +=  Scene.chatLine(p1start, freakOutWeasel, "Well.");
			chat +=  Scene.chatLine(p2start, shoosher, "Shit, are you okay? Jesus fuck I thought I lost you there.");
			chat +=  Scene.chatLine(p1start, freakOutWeasel, "I mean, you did right? I died. That is a thing that is true.");
			chat +=  Scene.chatLine(p2start, shoosher, "What... was it like?");
			chat +=  Scene.chatLine(p1start, freakOutWeasel, "Dying sucks. I do not recommend you try it out.");
		}else{
			chat +=  Scene.chatLine(p1start, freakOutWeasel, "Fuck. I can't take this anymore. I feel like the angst is voreing me.");
			chat +=  Scene.chatLine(p2start, shoosher, "Shit, what's up, talk to me...");
			chat +=  Scene.chatLine(p1start, freakOutWeasel, "God, I don't even know what to say. Everything is just so shitty.");
			chat +=  Scene.chatLine(p2start, shoosher, "It really is. But we aren't going to give up, okay?");
			chat +=  Scene.chatLine(p2start, shoosher, "One foot in front of the other, and we keep going.");
			chat +=  Scene.chatLine(p1start, freakOutWeasel, "Yeah. Okay.");
		}

		freakOutWeasel.flipOutReason = null;
		freakOutWeasel.flippingOutOverDeadPlayer = null;
		return chat;
	}
	dynamic interestAndQuadrantChat(trait, relationship, relationship2){
		String ret = "";
		for(int i = 0; i<3; i++){
			var r = rand.nextDouble();
			if(r < 0.25){ //maybe make them MORE likely to chat about interests?
				ret += this.chatAboutInterests(trait,relationship, relationship2); //more likely to talk about interests.
			}else if(r < 0.5){
					ret += this.chatAboutLackOfInterests(relationship, relationship2); //would get repetitive if they were locked to one topic.
			}else{
				ret += this.chatAboutQuadrant(relationship, relationship2);
			}
		}
		return ret;
	}
	dynamic lackOfInterestAndQuadrantChat(relationship, relationship2){
		String ret = "";
		for(int i = 0; i<3; i++){
		if(rand.nextDouble() > 0.5){
				ret += this.chatAboutLackOfInterests(relationship, relationship2); //one character tries to talk about something that interests them, other character is bored as fuck.
			}else{
				ret += this.chatAboutQuadrant(relationship, relationship2);
			}
		}
		return ret;
	}
	String getChat(Relationship relationship, Relationship relationship2){

		relationship.moreOfSame(); //strengthens bonds in whatever direction.
		//feelings jams have highest priority.
		if(relationship.saved_type == relationship.diamond && (this.player1.flipOutReason != null || this.player2.flipOutReason != null)){
			return this.feelingsJam(relationship, relationship2);  //whole convo
		}
		String trait = Interest.getSharedCategoryWordForPlayers(player1, player2,true);
		if(trait != "nice"){
			return this.interestAndQuadrantChat(trait, relationship, relationship2);
		}else{  //no option to chat about interests.
			return this.lackOfInterestAndQuadrantChat(relationship, relationship2);
		}
	}
	String getGreeting(Relationship r1, Relationship r2){
		String ret = "";
		ret = "$ret${Scene.chatLine(this.player1Start, this.player1,"${Relationship.getRelationshipFlavorGreeting(r1, r2, this.player1, this.player2)}${this.getQuadrantASCII(r1)}")}";
		ret = "$ret${Scene.chatLine(this.player2Start, this.player2,"${Relationship.getRelationshipFlavorGreeting(r2, r1, this.player2, this.player1)}${this.getQuadrantASCII(r2)}")}";
		return ret;
	}
	dynamic fareWell(relationship, relationship2){
		//fuck yes oblivion, you taught me what a good AI "goodbye" is.
		var goodByes = ["Good day.","Farewell.","Bye bye.","Bye.", "Talk to you later!", "ttyl", "seeya","cya", "Catch you later", "Have a good one!", "Later","g2g"];
		var badByes = ["I have nothing more to say to you.","I've heard others say the same.","Yeah, I'm done here.","I'm out.","I'm going to ollie outtie.","I'm through speaking with you."];
		String ret = "";

		var r2 = this.player2.getRelationshipWith(this.player1);
		if(relationship.value > 0){
			ret += Scene.chatLine(this.player1Start, this.player1, rand.pickFrom(goodByes) + this.getQuadrantASCII(relationship));
		}else{
			ret += Scene.chatLine(this.player1Start, this.player1, rand.pickFrom(badByes) + this.getQuadrantASCII(relationship));
		}

		if(r2.value > 0){
			ret += Scene.chatLine(this.player2Start, this.player2, rand.pickFrom(badByes)+ this.getQuadrantASCII(relationship));
		}else{
			ret += Scene.chatLine(this.player2Start, this.player2, rand.pickFrom(badByes)+ this.getQuadrantASCII(relationship));
		}

		return ret;
	}
	void chat(Element div){
		String canvasHTML = "<br><canvas id='canvas" + (div.id) +"' width='" +canvasWidth.toString() + "' height="+canvasHeight.toString() + "'>  </canvas>";
		appendHtml(div, canvasHTML);
		var relationship = this.getQuadrant();
		var relationship2 = this.getQuadrant2();
		var chatText = this.getGreeting(relationship, relationship2);
		chatText += this.getChat(relationship, relationship2);
		Drawing.drawChat(querySelector("#canvas"+ (div.id)), this.player1, this.player2, chatText,this.getDiscussSymbol(relationship));
		//this.session.sceneRenderingEngine.drawChat(querySelector("#canvas"+ (div.id)), this.player1, this.player2, chatText, 0,this.getDiscussSymbol(relationship));

	}

	@override
	void renderContent(Element div){
		session.removeAvailablePlayer(player1);
		session.removeAvailablePlayer(player2);
		this.player1Start = this.player1.chatHandleShort()+ ": ";
		this.player2Start = this.player2.chatHandleShortCheckDup(this.player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		this.chat(div);

	}
	void content(){
		throw "NEVER RUN IN 1.0 YOU DUNKASS. Seriously, I don't support it anymore.";
	}



}

//conversational pairs in order
class Conversation {
	List<PlusMinusConversationalPair> pairs;
	Conversation([this.pairs]) {
		if (this.pairs == null) {
			this.pairs = <PlusMinusConversationalPair>[];
		}
	}

	void haveHTMLConversation(Element div, Player p1, Player p2, String player1Start, String player2Start) {
		bool first = true;
		String ret = "";
		for(PlusMinusConversationalPair convo in pairs) {
			String metaLine = convo.getOpeningLine(p1, player1Start);
			String playerLine = convo.getResponseBool(p2, player2Start, p2.getRelationshipWith(p1).value > 0);
			if (first) { first = false; } else { ret += "<br>"; }
			ret += "<font color = '${p1.getChatFontColor()}'>$metaLine</font><br><font color = '${p2.getChatFontColor()}'>$playerLine</font>";
		}
		appendText(div, ret);
	}

	String returnStringConversation(Player p1, Player p2, String player1Start, String player2Start, bool b) {
		String ret = "";
		for(PlusMinusConversationalPair convo in pairs) {
			ret += convo.getOpeningLine(p1, player1Start);
			String response = convo.getResponseBool(p2, player2Start, b);
			//might not have anything to say.
			if(response != null) ret += response;
		}
		return ret;
	}

	void appendText(Element div, String text) {
		appendHtml(div, text);
	}

	void line(dynamic opener, dynamic positive, dynamic negative, [Mapping<String,String> formatting]) {
		Iterable<String> openers = (opener is Iterable<String>) ? opener : (opener is String) ? <String>[opener] : throw "Opener must be a string or Iteralbe<String>";
		Iterable<String> positives = (positive is Iterable<String>) ? positive : (positive is String) ? <String>[positive] : throw "positive must be a string or Iteralbe<String>";
		Iterable<String> negatives = (negative is Iterable<String>) ? negative : (negative is String) ? <String>[negative] : throw "negative must be a string or Iteralbe<String>";
		this.pairs.add(new PlusMinusConversationalPair(openers, positives, negatives)..formatting = formatting);
	}
}

class ConversationProcessed extends Conversation {
	Mapping<String,String> processing;

	ConversationProcessed(Mapping<String,String> this.processing, [List<PlusMinusConversationalPair> pairs]) : super(pairs);

	@override
	void appendText(Element div, String text) {
		text = processing(text);
		super.appendText(div,text);
	}
}

abstract class ConversationalPairBase {
	Mapping<String,String> formatting = null;

	String formatText(String input) => formatting == null ? input : formatting(input);
}

//set of possible responses if i like you, set of possible respones if i don't.  (nothing generic)
class PlusMinusConversationalPair extends ConversationalPairBase {
	Iterable<String> openingLines;
	Iterable<String> positiveRespones;
	Iterable<String> negativeResponses;	//have a variety of ways you can start.
	


	PlusMinusConversationalPair(this.openingLines, this.positiveRespones, this.negativeResponses) {}


	String getOpeningLine(Player player, String playerStart){
		return Scene.chatLine(playerStart, player, formatText(player.session.rand.pickFrom(this.openingLines)));
	}
	String getResponseBool(Player player, String handle, bool condition){
		String line;
		if(condition){
			line = player.session.rand.pickFrom(this.positiveRespones);
		}else{ //negative response.
			line = player.session.rand.pickFrom(this.negativeResponses);
		}
		if (line != null) return Scene.chatLine(handle, player, formatText(line));
		//lines can be null, if, for example, other player has nothing to say.
		return null;
	}

	String getResponseRelationship(Player player, String handle, Relationship relationship){
		return getResponseBool(player, handle, relationship != null && relationship.value > 0);
	}
}



//can't have engine create these things 'cause needs to be dynamic, not made ahead of time
class ConversationalPair extends ConversationalPairBase {
	var line1;
	var responseLines;  //responses are just reactions
	var genericResponses = ["Yeah.", ":)", "Tell me more", "You don't say.",  "Wow", "Cool", "Fascinating", "Uh-huh.", "Sure.", "I've heard others say the same.", "... ", "Whatever.", "Yes.", "Interesting...", "Hrmmm...", "lol", "Interesting!!!", "Umm. Okay?", "Really?", "Whatever floats your boat.","Why not", "K."];


	


	ConversationalPair(this.line1, this.responseLines) {}


	String getResponseRelationship(player, playerStart, relationship){
		String chat = "";
		if(relationship.saved_type == relationship.heart || relationship.saved_type == relationship.diamond){
			if(relationship != null && relationship.value > 0){
				chat += Scene.chatLine(playerStart, player, formatText(player.session.rand.pickFrom(this.responseLines)));
			}else{ //i don't love you like i should.
				chat += Scene.chatLine(playerStart, player, formatText(player.session.rand.pickFrom(this.genericResponses)));
			}
		}else{
			if(relationship != null && relationship.value < 0){
				chat += Scene.chatLine(playerStart, player, formatText(player.session.rand.pickFrom(this.responseLines)));
			}else{  //i don't hate you like i should.
				chat += Scene.chatLine(playerStart, player, formatText(player.session.rand.pickFrom(this.genericResponses)));
			}
		}
		return chat;
	}

}



class InterestConversationalPair extends ConversationalPairBase {

	InterestConversationalPair(this.interest, this.line1, this.responseLinesSharedInterestPositive, this.responseLinesSharedInterestNegative) {}



	var line1;
	var interest; //vague description of what the interest is. like "Comedy"  need this to have a common source of words.like how "shared trait" does.
	//what can i say if i like you and share your interest
	var responseLinesSharedInterestPositive;	//what can i say if i hate you and share your interests.
	var responseLinesSharedInterestNegative;	//below happens if you don't share an interest at all.
	var genericResponses = ["Yeah.", ":)", "Nice", "Double nice", "Tell me more", "You don't say.",  "Wow", "Cool", "Fascinating", "Uh-huh.", "Sure.", "I've heard others say the same.", "... ", "lol","Whatever.", "Yes.", "Interesting...", "Hrmmm...", "Interesting!!!", "Um.","Why not.","Whatever you say.", "K."];

}
