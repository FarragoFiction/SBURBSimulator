//have list of me-generated news posts, and maybe let the AuthorBot say some shit too.
//have a route for her to get a random session to parse.
//make her all arrogant and bragging about how many sessions she's parsing.
//why are AIs so awesome?
//i'm on left, she's on right.
var session_data = null;
var simulationMode = true;
var debugMode = false;
var spriteWidth = 400;
var spriteHeight = 300;
var canvasWidth = 1000;
var canvasHeight = 300;
var repeatTime = 5;
var numSimulationsDone = 0;
var numSimulationsToDo = 5;
var sessionIndex =0;
sessionsSimulated = [];
var version2 = true; //even though idon't want  to render content, 2.0 is different from 1.0 (think of dialog that triggers)

function newsposts(main){
    writeNewspost(main, "7/31/17", "Today I will focus on getting The Great Refactoring (everything is on fire and there are plenty of crashes) on to the Experimental branch. As such, expect this to be the final Main/JavaScript update for awhile. ");
    writeNewspost(main, "7/30/17", "Still tracking down ABJ's first bug. When I ask her what classes exist, she lists out the canon ones, and then lists out the fanon ones like 50 times a piece. So. I guess she REALLY likes fanon.");
    writeNewspost(main, "7/29/17", "I have begun the process of waking AB and ABJ back up so they can help us debug.<Br><Br>Oh shit, ABJ is awake. And...reporting that so many players are Wastes of Blood?  This...this is definitely not creepy at all.<Br><Br>(Also why are wastes in the main sim??? Gotta go find that bug)");
    writeNewspost(main, "7/28/17", "Today I discovered that AB doesn't hate cinnamon rolls.");
    writeNewspost(main, "7/27/17", "Man, I've been dealing with getting The First Session working so much I forgot to update you guys!  <a href = 'https://drive.google.com/file/d/0B-uS7ImZMoISTmw2UGFZaFVHRDA/view'>The First Session</a> is buggy as hell, and nobody is apparently allowed to do Land Quests, but we got 'em folks, and I have promptly added them to my personal Mythology. Hell FUCKING yes.<Br><Br>Next up is getting them able to do quests and fix any bugs that shake out of that, and then waking dear sweet precious sweet sweet AuthorBot up from her medically induced Coma to see if she can help find more bugs.<br><br>Also: holy shit, we are on day TEN of The Great Refactoring. This is the longest I've done any one thing on the sim, or as RS put it: 'ACHIEVEMENT GET: In-TEN-se Work- Slave away for ten days on one task. '.");
    writeNewspost(main, "7/25/17", "Hell FUCKING yes x2Combo!!  The Refactored Sim just generated it's first player, a Witch of Space who has a MonkeySprite but crashed before they had anything else. <a href = 'image_browser.html?firstPlayer=true'>Fan art is here.</a>");
    writeNewspost(main, "7/24/17", "Hell FUCKING yes, the Great Refactoring has hit a major milestone. I can now render the Sim's navbar, and like, infinity shitty errors. This is progress. This is FANTASTIC progress. Thousands of syntax errors from the conversion process have been slain in absolutely not-honorable combat.  <br><br>And now comes the process of slowly getting each feature working again, while ALSO slaying what red squiggles I have magnanimously allowed to live in my haste to speed run this bitch.")
    writeNewspost(main, "7/23/17", "Mages of Heart no longer suffer from the corruption of their own identity, in the most hilariously ironic bug to hit the OCDataStrings yet.<br><Br>Also, ParadoxLands has helpfully provided this explanation for just what the Great Refactoring is.<br><Br><a href = 'images/misc/fanArt/gifs/the_great_refactor.gif'><img width = '300' src = 'images/misc/fanArt/gifs/the_great_refactor.gif'></a>");
    writeNewspost(main, "7/22/17","The Witch of Void and Waste of Mind use The Great Refactoring. A defensive ward of glass and open doors surrounds the allies.");
    writeNewspost(main, "7/21/17", "<span class='void'>Just. Fuck bees.</span>");
    writeNewspost(main, "7/20/17", "The God Tier Waste of Mind (jadedResearcher) is doing... something. It's kind of hard to see. You are definitely blaming the God Tier Witch of Void (paradoxLands), somehow. Everyone seems to be pretty happy about it, though.<span class ='void'>The Waste of Mind and Witch of Void are refactoring like goddamn machines. It's crazy how much refactoring they are doing. How HIGH do you even have to be etc. etc.  ... ... ...  It's going well.</span>");
	writeNewspost(main, "7/19/17", "Day Two of the Great Refactoring: Things are going about the speed I anticipated. The Sim is still in ruins, and can't be run, so I've decided to spin off some time to write ways to test it even if it's not finished. In JAVASCRIPT this was as simple as making a new html page, but JavaScript is also a buggy piece of shit (or at least sure does love ENABLING buggy pieces of shit. ) so... <Br><Br>Holy shit, guys, I just realized: JavaScript is TOTALLY a Bard of Doom!!! It ALLOWS you to be destroyed by your own Doom, or to cause destruction with it.  Doom being both 'bad ends' and rules/structure.  JavaScript makes is SO FUCKING EASY to break 'the rules', both for good and for bad. Headcanon: Accepted.")
    writeNewspost(main, "7/17/16", "Last deploy until me and ParadoxLands finish up converting the whole shebang to a new language to get ready for the NPC update. <br><Br>This deploy had bug fixes, and re-enabled dear sweet precious sweet sweet The Mayor, who had accidentally become Impossible. <span class = 'void'>Also, Null class players work again.</span>");
    writeNewspost(main, "7/16/17", "Spent the past couple days fixing small bugs (such as Original Characters not having the right psionics for their blood color, or Guardians for 13+ sessions crashing them due to not wanting to share classes), and adding small features (like getting the OCDataStrings ready to be extendible. <br><Br>I anticipate main and Experimental branching apart again shortly.<Br><br>Also, PopoMerrygamz has provided us with 6 new hairs, which KR has massaged to fit the Sim's display specifications.")
    writeNewspost(main, "7/14/17", "What is this??? Did Fraymotifs finally hit the Main Branch??? Hopy shit!<br><br>I bet classpects have gotten a full overhaul, as well as the entire Fraymotif Engine.  I'm litterally writing up the new classpect descriptions for the Char Creator as we speak. <br><br> (Also, what's that <a href = 'land_of_rods_and_screens.html'>LORAS</a> thing???")
    writeNewspost(main, "7/13/17", "Made sure the new classes get at least place holder quests to fiddle with.  <br><br>I also put in a alpha 'here is a list of buffs/debuffs' readout.  It seems kinda spammy right now. Not sure what I want to do with it.<br><Br> I also workshopped ELEVEN additional 90s rap/rock sensations to help players out with optional bosses I plan on adding to the sim over time. That brings us up to a Pantheon of 12, total.  May they save us all.");
    writeNewspost(main, "7/12/17", "Small, fiddly, fraymotif things, like making not all denizens have the same fraymotif. <br><br>And 3 new classes (Scout, Sage, Scribe), though they behave mostly like existing classes. I have plans though. I continue to like how Life/Doom players behave for ghost shit, and think that all existing scened could benefit from having class themed things for people to do on top of the existing stuff.")
    writeNewspost(main, "7/11/17", "The rebalance is finished. Huzzah! Let us all resolutely forget the thousands of players that died while the survival rate was at 18%. That would be why I didn't deploy till now. 'Cause with all you simulating sessions, it would have been many, many more casualties. R.I.P.<Br><Br>In completely unrelated news, AB is reporting a new type of ending??? What is even up with that? ")
    writeNewspost(main, "7/10/17", "Spent today working on making sure all stats effect combat in some fashion.  Sanity and Free Will will control if you can use fraymotifs, for example.  Problem is it unbalanced everything enough that I can't justify a deploy yet :/<span class='void'><br><br>Which is a fucking SHAME because I made the best shitty fan troll for you guys, with bubble gum pink blood (she is the only one to have it) and heart horns and her name is specialSnowLake and she is in a threeway matesprite ship with Dave and Karkat and etc. etc.<br><br>When I first created this original character (do not steal), she created a dope as fuck bug where all SBURBSim players were covered in her blood, like we were all part of some Orient Express Style conspiracy murder of her annoying ass.</span>")
    writeNewspost(main, "7/9/17", "Minor tweaks here and there, as well as a list of possible pre-made names for fraymotifs that the discord brainstormed up.<br><Br>Life players should suck a little bit less, too, 'cause they no longer interfere with the God Tiering process.  (They would get all panicky and revive players before they could get a chance to God Tier). <br><Br>Rage/Void players have been nerfed a bit, and shouldn't God Tier the second they get in the Medium anymore. Hilarious though it was, it really unbalanced things.")
	writeNewspost(main, "7/8/17","So, I noticed that shipping grid were broken, and SOMEHOW this turned into a two day long shipping re-work??? Heart and Blood players maintain shipping grids, with any non-quadranted crushes being the Shippers's speculation. 'Oh, they seem to like this other player a lot, I bet it's FLUSHED/PALE'. Shippers will occasionally also butt in and attempt to get their favorite ships together.  <br><Br>I ALSO did small stat and fraymotif tweaks, but nothing particularly memorable. Fraymotifs in general should be more useful, since they are guaranteed to be at LEAST as good as a regular attack, damage wise. <Br><br>ALSO, DilletantMathematician made this amazing <a href = 'http://www.purplefrog.com/~thoth/art/sburb-disco/disco.html'>fan animation-ey thingy</a> with SBURBSim characters dancing.<span class='void'><Br><br>Also, <a href = 'index2.html?faces=off'>FaceOff mode is a thing that will haunt our nightmares forever</a><br><br>Also, since I updated shipping, ABJ broke, and I realized that SHE ships, too!!!  She reports back on initial ships.  So she is a sociopath who enojoys total party wipes, and shipping.</span> ")
	writeNewspost(main, "7/6/17", "<span class='void'>Is it possible I got distracted from fraymotifs??? And added Wastes as a class??? That doesn't SOUND like something I would do, focus is practically my middle name. But if I DID I would expect it to be shitty and alpha and have wastes not do anything special at all.<br><Br></span>I got briefly distracted from fraymotifs working on a tiny rendering engine upgrade that makes swapping out sprites easier (not the full Sprite Rendering Upgrade, though). And so I toiled to make the stupidest possible <a href = 'index2.html?easter=egg'>easter egg</a> with it. (Let's all thank MultipleStripes for the sprites!!!)<br><br>And if I DID manage to focus on fraymotifs for any amount of time at all, I'd expect troll psionics to be more of a thing, both in and out of combat. It's still very much a proof of concept (only a handful of powers), but the framework is there.<br><Br>ALSO I did a shit ton of bug fixes for the character creator, so it should APPEAR less buggy (it wasn't ACTUALLY buggy underneath, the forms just didnt' like to update)")
	writeNewspost(main, "7/5/17", "More fraymotif work, including sprites (and thus Crowned Carapacians) having fraymotifs. Still a LOT of bugs to fix, though.<br><br>Also, <a href = 'index2.html?images=pumpkin'>What Images Mode</a> is now a thing. If you don't give a fuck about images, or just want to make stupid shit (like 144 player sessions) not crash your browser, this is the mode for you. Shine on, you crazy diamond.<Br><br>ALSO, I made a quick lil 'character sheet' of the players at the end (if they actually GET to the end, and don't crash the game or doom themselves) printing out their 'before' and 'after' stats.")
	writeNewspost(main, "7/4/17", "Denizens have their own 'fraymotifs' now, and several fraymotif related bugs have been fixed as well.<br><br>  If easter eggs were a thing, I'd expect to see more of them, as well. <span class='void'>It's <a href = 'index2.html?pen15=ouija'>dicks</a>. dicks are the secret.</span>")
	writeNewspost(main, "7/3/17","Today shall forever go down in history as the day that 'fraymotifs when?' stopped being a meme and instead became a real thing.  Players can now have text only, unbalanced as fuck fraymotifs.  <Br><Br>Next up is hand made 'fraymotifs' for denizens, sprites and psionic trolls.  Then maybe i'll look into at least having the users of the fraymotifs pose as a team (if they are players).  ")
	writeNewspost(main, "7/1/17", "<a href = 'land_of_rods_and_screens.html'>The LORAS game</a>, described by <a href = 'https://classpectanon.tumblr.com/post/162204711075/could-i-get-a-land-analysis-waste-or-maid-if'>classpectanon</a> and drawn by <a href = 'http://paradoxlands.tumblr.com/post/162444935101/land-of-rods-and-screens-your-land-is-a'>ParadoxLands</a> is basically complete. In addition to ParadoxLands' dope background for the game, there are multiple 'win' states, and you no longer get the best reward for the regular ending. If you played the game early enough, the best reward (holy shit is it hard not to call it the Ultimate Reward) was pretty much inevitable to get, but now it's only for the True Ending. Thems the breaks, future peeps. <Br><Br>Also, procedural fraymotif descriptions are done, and I expect to be able to shove fraymotifs in general into the sim within the next couple of days.<br><Br>In the meantime you can see my shittily organized test page <a href = 'test_fraymotif.html'> here</a>")
	writeNewspost(main, "6/30/17", "Fraymotifs are nearly ready for v1 to be integrated into the sim. I'm brainstorming some interesting ways to describe them in sim rather then just call out an attack name and have you guess what happens next. <br><Br>Once player fraymotifs are fairly stable, I'll work on the non-procedural sprite/denizen/etc 'fraymotifs', as well as custom ways to get fraymotifs, and extending fraymotifs to have effects other than just damage/healing/buffing/debuffing.")
	writeNewspost(main, "6/29/17", "So, combo sessions have been acting weird with YellowYards, but only SOMETIMES. Turns out it was SHIPPING GRIDS. The fix is the highly unintuitive 'Have the players drag the corpses with them to the new session, Vriska/Gamzee style'.  <Br><Br>Don't worry about it. Of COURSE shipping problems are fixed by bringing decapitated heads or whatever the fuck. I think we can all agree that SBURB makes perfect sense.<Br><Br>I also enabled <a href = 'index2.html?seed=111&VoidStuck=true'>Void players</a> to have a custom info phrase to describe which stat they have that is crazy high. (For example, SO STRONG, or SO FRIENDLY). If they are a class that has to EARN their power, the stat will be flipped (SO WEAK, or SO AGGRESSIVE).  It has been an interesting way to keep track of how the Void player will be growing over time.<br><br>Also, I've totally got the basic structure of fraymotif tests ready and have a solid plan for finishing them up. ")
	writeNewspost(main, "6/28/17", "So, ExperimentalBranch (which you're either on right now if you can see this, OR you are from the far flung future) has officially gone off the rails and has wildly divurged from Main. <Br><Br>Classpect stats have been completely redone to make future fanon classpects and fraymotifs easier. I haven't updated the help text on the character yet (and won't until classpects settle down), so, for now, they are totol lies.<br><br>Also, smiley quirks are a thing. Finally.")
	writeNewspost(main, "6/26/17", "So I spent the past 36 hours implementing a <a href = 'land_of_rods_and_screens.html'>game</a> version of the land <a href = 'https://classpectanon.tumblr.com/post/162204711075/could-i-get-a-land-analysis-waste-or-maid-if'>classpectanon</a> wrote for me.  <Br><br> It sure does seem unlikely that the game has secrets, doesn't it?  I ESPECIALLY wouldn't expect for the game to unlock any easter eggs in SBURBSim.")
	writeNewspost(main, "6/24/17", "Lol, was I gonna not do any more main updates for awhile??? That stopped being a thing that was true as soon as <a href = 'http://paradoxlands.tumblr.com/post/162149733351/main-dish-misalignment-stand-by-sometimes-while'>ParadoxLands</a> made me some p great fanart which reminded me that I STILL hadn't posted all the OTHER fan art I've been collecting.  So have fun with the new <a href='image_browser.html?fanArt=true'>viewer</a> :) :) :) <br><Br>(Hey, did you know I'm collecting fan art???) ")
	writeNewspost(main, "6/23/17", "While I'm doing invisible backend work on the sprite renderer, we have recieved 7 new hair styles! KR made sure the hair recieved from PopoMerrygamz (and hair 64 from RemJoleea and hair 66 from Ancient ) worked with the rendering engine. That brings us up to 68 different hair styles! ")
	writeNewspost(main, "6/22/17", "Final Main Update for the next while (weeks? a month?) is out.  It includes the tournament, which you'll see links to in lower down newposts, and a link to in the 'fan' tab on the navbar.<br><Br>  (For those new folks here, Main branch only gets newsposts when it gets an update, so if I seem to go silent, why not check the newsposts over on experimental?)<br><Br>Experimental will start getting work for a new rendering engine (that will allow you to specify what sprite set your custom character uses, like PonyStuck or CarapaceStuck or whatever), and a completely redone claspecting (courtsey of the ideasWranglers, especially the newest one, wooMod who advocated the upgrade) system to emphasize class and aspect uniqueness.  BOTH things are going to require a lot of coding before even the experimental branch gets an update, so we'll see how things shake out. I'll try to do little things here and there so things don't stagnate as well.<br><br>Those two things will be the ground work for the NPC update (which will include NPC party members and Midnight Crew Shenanigans), and the fraymotif update, respectively.  So, big plans coming.")
	writeNewspost(main, "6/21/17", "Been working on redoing the rendering engine to make extending it a thing. Plan on having stupid character customization options available some day, like just deciding what sprite set your OC is using.  (EggStuck, PonyStuck, CarapaceStuck, the possibilities are endless because they are still in the future).  <br><Br>I also made a small balance change for sessions with multiple Space/Time players.  Before, only the first Space players's frog mattered and the first Time Players got to make doomed time clones. This was obviously fucking stupid, and has been fixed.")
	writeNewspost(main, "6/20/17", "So, sarcasticIrony totally made <a href = 'http://farragofiction.com/SBURBSim/index2.html?seed=105980060&b=KQYQzMBCBioTcrQIKMgFlAJmATksAIwAMwxEhAbEdcYWrMaU9sABwCsabAmkc6kKZiqYmwYTwSAOZoAoq0gB2MqUI46ZekNW6pCdWkIBXfgEUiISwCpWbZqRA57irvoJS2BEmQrUsFBAs+oyOOMgQ+sgAWvxkWACEREEaDgwATmhKAKr8ABqWRJC2wc5pTlCO8HIFTAAqZCrEXMS4kmWq9PoKFfi6hBBYmENaevCwIWQe1WTiTAAKo5pYlEA&s=DTCSCcHsDsE9gEqQDYFMAEAFZBDWBLaAc2ABcBXcaU1AYwAsBhHU6fABxGEdwGdf8vALZgocMviE5U5XgBVUvUvlpouzUr2AAJSOCjga+vVprUcq1HPqpwOdoNJcAYtPD5FwZ-nBL0AcXIccAATfBxoLRwwyHk9VGi9LgRUXGUYXnoOLQBBNilkLVpyUlI0ADNBJhY2ThB-VGhIWnwQ1B0LAGtCElocZHwicj4c8CkiVBCQjK4AEQTSemAAZXIVVvbo-Fj-dzqvHz9A4LCIrX8Txp7gIkvofyalFS4IGHgAIR8Q00pqOnp-JAQjZolxMHZoJ0tO8cN1iDcSrxYIEhJlIKggA'>SpriteStuck</a> and it is the best thing ever.<Br><Br>Bug fixes and balance and tournament are what's being worked on. <a href = 'tournament_arc.html'>Tournament</a>  is basically done besides clean up and trying to figure out why AB keeps letting scratches into the tourney (those things are OP).")
	writeNewspost(main, "6/19/17","So, the tournament core is complete, which revealed that teams made all of one aspect are HELLA OP. A little bit of digging revealed they were all sharing (and completely owning) the same denizen.  <br><Br>This is clearly not gonna stand, so I completely redid the denizen system. Players each have their own denizen (with a random name themed either around their aspect, or around how much they suck/rock at the game.  Thanks goes to Discord for brainstorming names with me :) :) :)")
	writeNewspost(main, "6/18/17", ":/ Tournament mode is taking a bit longer than anticipated, espcially as I valiently fought against server issues today.  <br><Br>BUT, fear not, I have a consolation prize for you guys: galleries of <a href = 'image_browser.html?hair=true'>hair</a> and <a href = 'image_browser.html?horns=true'>horns</a> now exist to make it easier to design your OCs.  We also have new horns courtsey of PopoMerrygamz, horns 47-73. ")
	writeNewspost(main, "6/16/17", "The site navigation has overgone a major overhaul after a lot of the new folks let me know how confusing it was. Hopefully that's better. <Br><Br>I also got to learn that Math% of you guys have session crashes if you're loading a page when I'm doing a deploy. Not sure what's up with that, but I'm brainstorming solutions.  In the mean time, if you get a crash right as a page loads, try holding shift and clicking refresh to clear the cache just for SBURBSim.  That should clear it up.<Br><Br>Oh yeah, and KR is getting some art help from the fans, including the new ideasWrangler: <a href = 'http://PopoMerrygamz.tumblr.com/'>PopoMerrygamz:</a>. Expect new and exciting hair and horns and (eventually) classes.")
	writeNewspost(main, "6/15/17","The navbar has been updated to remove the newsposts, and instead there is now a link to the new <a href = 'http://farragofiction.com/SBURBSimE/character_viewer.html'> Fan OC Viewer.</a>.  You can view all sorts of OCs submitted by fans (just like YOU), as well as amazing OCs from other fandoms. And then you can <a href = 'index2.html?selfInsertOC=true&'> shove</a> 'em all into SBURB together and watch the shenanigans play out.  <br><Br>'")
	writeNewspost(main, "6/14/17", "Dang, apparently custom interests were only working cosmetically, but were leaving echeladder runs as 'undefined' and screwing up certain kinds of dialogue. It's working again, tho, and OC data string didn't even have to be fucked with. <br><Br>BTW, in case it isn't clear, Main and Experimental branches will be in lock-step until I start working on new sim features (like fraymotifs). Things like the fan OC mode will be on both branches.")
	writeNewspost(main, "6/13/17", "Okay, totally on me, but it turned out custom Heiress trolls were NOT biologically compelled to murder each other. Don't worry: the <a href = 'index2.html?seed=121655061&b=KQBhvMCdgYQZmAISQF2ARhAQWAJiX0L0TAnNj2XAWWPC1A33D3HlnLLMuG0Noo4VJLiwAJUAFZpoXN0ggAinERDeAThlYxANky6AhF0UB2VXU5YAKgFpboQgq77BxQo24BRUF4DkJhRUGgAcFuqIGohYADKYAGIJtkA&s=DTDCHsDsGcAcEsBOBDAxvAptYAhcAPeSAcxBADFlIACAQUQBdgApcAayzOAFkMATeMgZFS9YQDN46ZABtqASUgMMMmfGIZIqDFwDKAV1gZEAC2PhOAJTTxoAWy7lw4BgCNZM4ABF9JDFGpuZGhlRBEuAHEUcUlhYEsVdXgoLgAFEwBPaClsUBNkFFRQ6lBEDCFkyGAgA'>natural order</a> has been restored and they are back to engaging in black flirting and murderous rampages as Hussie intended. <Br><Br>Also: totally working on a viewer for all the OCs people have sent me, as well as a mode to pit them against each other in death games for our amusement. *cough* I mean play SBURB for a chance to become gods.<br><Br>Also, ohmyfuckinggod, ppl, troll wings are supposed to be blood colored. Apparently a large chunk of browsers were rendering them as candy red and lime and ohmyfucking god. ;alsdkj. I had no clue. BLUUUUH. It's fixed, at the cost of the server having to resend you guys the images again, so you can't use your caches for your next session. Sorry. ")
	writeNewspost(main, "6/12/17", "<h1>Holy Shit 3.0!!!</h1><br><Br> For serious, guys. I'll fix bugs as they crop up, but right now Main and Experimental are the same damn thing. Good job, us.<br><Br> <a href ='https://www.reddit.com/r/homestuck/comments/6gs16h/sburbsim_30/'>Official Reddit Thread</a><Br><Br><a href = 'https://jadedresearcher.tumblr.com/post/161733787019/30'> Official Tumblr Post</a><br><br>And I totally shoved my GlitchFaq onto <a href = 'http://archiveofourown.org/works/11179110'>Archive of Our Own</a>")
	writeNewspost(main, "6/11/17", "Gearing up for 3.0. Only bug fixes and testing remain. Just imported some of manicInsomniac's dialogue for the QuadrantDialogue bullshit, and also you can destroy players (you monster). And holy shit, now you can even create new ones! You can even have sessions with more than 12 players!!!   <br><br>Some minor bug fixes are out as well (Derse players can exist in replay session again), and I'm working on fixing a few bugs still, too (Heart players will hopefully stop crashing combo sessions that Yellow Yard soon).")
	writeNewspost(main, "6/10/17", "Hel FUCKING yes, the ReplaySession character creator is basically done. What does this mean? Here, have a <a href = '?seed=4655190&b=KQZgwsCMCiwAwHZ4DZhhMAQgFjQJmAEEM44AtYPCK+AEUswCoBaFNDHfIkud4ATl40acenias4qdFlxgCxeLxn9IlahFEMWbGZ3nclffgFZ15reJ1S++hT2O5hmsRN0c59oyozO62yWkPLkVSYzU-SzcbPU9DMJVUSNdrINkQhxUzZID3dINQ5QxTcxEUwNs4wuN+UpdcmOCCzOLMOrogA&s=DTAqAsFMAIEEFcAu4D2AnAQixwHPQJYB2A5sAFYCGAJpNQEqQDOklaAxlGiLkqmsTL0UAI2xNglPuiw4QefoODCxiCVPyZsPBYVLLR4ydK1zempSqMb+snScuG1xzXfkP9V5zZnb3Fzyd1EzdzRUDVYNc-ML0hIJdbGN0BCOsQ5I94yMTfRCA'>link</a>.  In addition to being the best possible doomed session, clicking on 'replay session' will let you check out the data tab so you can import a jadedResearcher or authorBot into your own sessions as well. I'm gonna have a special board on the Discord that will be just people's OC data strings, so we can all put each other into death games like Hussie intended. <Br><Br>Before the weekend is over, I also expect to have a true 'CharacterCreator' link that isn't tied to a specific session, and a mechanism for creating and destroying players (you monster). ")
	writeNewspost(main, "6/9/17", "Hells yes. Character creator is looking pretty damn good and has lots of new features. I'll finish upgrading it this weekend. <br><br>Plus, the server is totes being hosted on a brand spanking new domain, so we're not bumming off my friend's generously donated purplefrog.com hosting anymore.<br><br>Basically, we are so close to 3.0 I can taste it. 6/12/17 is the goal here. It means fraymotifs will be a strictly post 3.0 thing, but they'll be worth it.")
	writeNewspost(main, "6/8/17", "HAH! Fuck pastJR, they clearly had no clue what they were talking about. A good nights sleep resulted in an even SMALLER url for the same damn session:  <a href = 'index2.html?seed=4655190&b=KQBhvMGFihmYAhATMA7DAjCAUsZALPkSACLBxYCioaoAbLAokVKgIIJgAK+MyMMhGFhYHcPCRoAlMGwBFOY0yMho9SFmTEADnZyQVAFSgdochuGYArEyT62wAJyYDAFSMm1kH6+37RbH4EZFULH2FrRDtEJxoFAzkScJEJVEQHZicxYHYibAA1OVRMVG9UnKczbTQARwN45TCK0UcdOm1sx3ZybHjXTFdyjQAjGI7UHXyQAE0jAApzFshWZhpHDIMAaVBrAEJzIA&s=DTCiBsDcFMGdgEIHsCe8TAIIKwVwC4AWSATgJYB2A5hsACqHQCG+0J9AarQk7NAEZNw4YACUmAB1oAJNkjjAACuCYpKVAASKyTCklqLcEidHzwAUkgDWCjMgAe64AEkKsXODO1RSfki8A6tBkVIT4GgAyZABm+E4YAMJIbhJkJEwAxmQK4lIYmCRx0WRZQhqurMIh0BQZ0MAAylk1dbRJ1k48fILC3tDgIWTJYr7+8EA'>You would see the link here to demonstrate but it doesn't have spaces or anything and escapes from the side right off the page which is so dumb. but it's smaller. Trust me.</a><br><Br>Also, blood color matters for trolls initial hp and power now. Eventually once fraymotifs are a thing, low bloods wil use the engine for their psychic power.")
	writeNewspost(main, "6/7/17", "I am the l337est asshole on the planet and have gotten custom urls to be 70% smaller. Just look at this relatively tiny fucker: <a href = index2.html?seed=4655190&b=%00%C3%BF%00C%C3%B2%7C%10J%24%24%0D%00%00%00%06%C3%B4%C2%A0%10P%2C%2C%0D%00%00%00%C2%A0%C3%B7)%10Q%16%16%0D%00%00%00)%C3%B8A%10E*%08%0D%00%00%00%15%C3%BA%C2%91%10T**%0D%00%00%001%C3%BA%00%10C%23%26%0D%00%00%00%5B%C3%B9E%10Q%10%14%0D%00%00%00%C2%BA%C3%B9%C2%A4%10V%12%12%0D%00%00%00%C2%98%C3%B7q%10E%16%16%0D%00%00%00%C2%87%C3%B9%C2%AD%10E%11%11%0D%00%00%00b%C3%B7%C2%84%10Y*(%0D%00%00%00%04%C3%BE%C2%BA%10K%05!%0D&s=%2C%2CElves%2CBoys%2C%2C%2C%2CAB%2CPuns%2C%2C%2C%2CTheater%2CTV%2C%2C%2C%2CBaseball%2CRap%2C%2C%2C%2CHeroes%2CPlaying%20Piano%2C%2C%2C%2CPuppets%2CJokes%2C%2C%2C%2CBoxing%2CInsults%2C%2C%2C%2CRobots%2CWeight%20Lifting%2C%2C%2C%2CConspiracies%2CRap%2C%2C%2C%2CArtificial%20Intelligence%2CScience%2C%2C%2C%2CCooking%2CBaseball%2C%2C%2C%2CReligion%2CRobots%2C'>Why do long urls try to escape to the side??? It's tiny, I promise.</a>.<br><Br> You will note that fully half the fucking size is custom strings like interests, so don't expect me to add many more other than maybe chatHandle.  Attempting to compress strings that small only makes 'em bigger tho, so that's about as tiny as we're getting. I also laid the ground work for a bunch more ReplaySession features, some of which are accidentally floating around alrady on the page, all undocumented and shit. ")
	writeNewspost(main, "6/6/17","<a href = 'character_creator.html?seed=1234'>The Session Replayer</a> finally lets you specifiy interests, including custom 'write in' ones. <a href = 'index2.html?seed=21475351&players=NobwRAhgzgDgpgYwC5gFxgMowguYA0YCANtFAPoB2EAtnugLIQCWAJgWAI4CuzATgGs04AGYQAbgHs+zJHABy3GgCM4fNACYAvoQAWLdegCMAZg77+AYUnFpaMAGIADC9cdmUACp8bxNEj5uOEJlW0lWa1tDRwA2Ixc4jmI4ESQACWlKNCNCGQBzXXTM7MJmSjk+OCgkI0sIOTzpAE97T0RdShtJPJbS8rUqpA06hub7AHUZJDK8937K6qN7AEEAITmKwY17ADEISgACHeZkZkksnXBoeGR7BjL2QhIyKlp6MCY2Dh5+IVRRCTSWQKJSqQwAdh0YAs0VM5gMkTs6AcAFYACwaBBGAAc7i8PmIflQYmIUGCYFCknCiOiDhEIlcTiSKSKfCyqDRuWYBVZ7JyYDKm0WIzgjT4LXQbQQHS6PQ2A2qw3qorG6GWCAgrDgNBO8oWNRW6z6QqG9gA0p0AO7JVh5PCXSCwRAoRgPDjPKAUah0O4sR5cXiCYRgMRSKYglRqNBoqEw+xwvQIrq09GYnF47y+NAkskhMIRZP2OkMtyEZKpDJstAmfn5QqV9kmTkC+aDWrKsUSsBSmW2OXGhVDEWd1rtTp93otk1LNVGqeD7boAAKPjyfFoOsoswd12drWYPqepE9rx9jD930DfwBYeBikjhmxsYM8bMiasheRjJcGYJRICQR5lSBZREWaJGDEMQ-mWLINtGThcjycEcgh876u2oziqO0rjt0k6Cguw6qmAljcMQSDcJUeptoa1GKrs+wHMsfAoDuTq3K6lD+h6XpvL6XyED8Qb-CGgLhveYL2GYz78K+8IfqByKpliuKlPiWbEhApLkpS1Kfo49KMsyFbFKgEGIfWpnmWhbZEVh6CTLIMx0UOHbET2uH9jZiwrNwSC6ECW4uYuYBrGAWgALpAA'>Check it</a><br><br>InterestCategories affect echeladder rung names, chatHandles, quadrantDialogue, rap content and skill and (in rare cases) how much people like you.  Oh, and having interests in common with your quadrant mates makes for a more stable relationship.<br><br>I also tweaked various simulation things, managing to dial the murderMode and grimDark rates way back without fucking with win or survival rates too much. It's suprisingly hard to balance shit.<br><Br>Oh god, I can't stop laughing. You know how you should totally sanitize your database input and shit? Well, obvs I don't have a database, but I sure as fuck had a text entry box that gets rendered to a web page (i.e. the interests). You guys made such beautiful html injection attacks on SBURBSim, so glorious.  Players had interests that were just shitty embedded youtube videos, shout out to <a href ='images/misc/fanArt/x2combo.png'>artificialArtificer</a> for letting me know. Looks like imma hafta fix that shit. If for no reason other than to make people be able to trust custom urls to not fucking rick roll them. Such a shame. It was a beautiful cinnamon bun.")
	writeNewspost(main, "6/5/17", "I have once again done battle with mine ancient enemy: lively as fuck corpses. Turns out they were totally flirting up their quadrant mates. Or at least responding to the flirtations. I'm willing to believe that the corpses would even console their living Moirails who were flipping their shit about their dead diamond buddy.  That's how wack shit was.  But never fear, I have this on lock and corpses are once again relegated to merely leveling the hell up and being asked for one-sided romantic advice. <span class='void'>Oh, and rage related death shrieks and void hiding. Whatever. That shit is random as fuck and it's the best feature/bug.</span>You're welcome.<Br><Br>And I have added a shit ton of easter egg stuff, related to how NepetaQuest was improved. It revealed that AB has been stealth flipping her shit about certain types of special sessions, though. All reporting fake bullshit.  So I had to calm her robotic ass down before I could even BEGIN testing my new shit.<> <br><br>I've done a lot of little but cool things today, too. Armless prototyping is totally a thing now (well, technically fingerless but whatevs). OC Generator no longer racist against humans. Small bug fixes. Working on several big things at the same time, including a way to make urls for ReplaySessions way shorter. And hosting solutions for the site itself.")
	writeNewspost(main, "6/4/17", "Bow before me puny mortals, because I finally fucking finished the quadrantDialogue engine. Characters will talk about their interests and their relationships, and get a bonus to their relationship if they actually have interests in common.  Moirails will also try to stop their palemates from flipping their shit. The dialogue is guaranteed to be exactly the right level of shitty, though I may make it less repetitive in future deploys.<Br><Br>Speaking of deploys, people have been reporting bandwidth issues every time I do a deploy lately. My assumption is that when I do a deploy, it invalidates browser caches for everybody, so suddenly you are ALL trying to download art assets at once and it's slow as balls with as many people as there are. <br><Br>I am looking into getting my own hosting (instead of bumming off my friend's purplefrog site). This should give me more control over bandwidth and speed and all that good stuff. I'm likely to start up a Patreon or something at that point though, to try to offset server costs. SBURBSim'll always be free, etc. etc., don't worry about it. And any Patreon or equivalent will be vaguelly generic rather than being all 'pay me for somebody else's intellectual property' ")
	writeNewspost(main, "6/2/17", "quadrantDialogue is getting close to done, just a bunch of bullshit data entry.  <Br><Br>Dear sweet precious sweet sweet AuthorBot has a brand new chasis, alchemized courtesy of our resident Smith of Dreams, karmicRetribution.  They are both the best!<>c3<<br><Br>AB was pretty sick of just being my robo-doppelganger, so the new chasis reflects her actual role within the Sim:  Guiding Observers to interesting decisions/simulations, etc. ");
	writeNewspost(main, "6/1/17", "12 days remaining to get into the [???] Hall of Fame, btw. <Br><Br>I'm still working on a bullshit dialogue engine, but it's getting close to the end. At this point it's just boring as fuck data entry. <br><Br> I ALSO decided to upgrade nepeta quest (holy shit, what could that be???) in a variety of ways. <br><Br>Also, posting a mini mini update to the Main Branch to try to encourage Google to stop bragging about crashing my damn sessions.")
	writeNewspost(main, "5/30/17", "I've been working on a robust bullshit dialogue engine for players in quadrants with each other. It will be yet one more way Romance distracts from the Ultimate Reward AND will be a way for me to indulge in my sweet sweet love of AI conversations that ALMOST make sense. Yessss. <br><Br>Oh, and I finally decided to do something about the odd bug report that turns out to be a bullshit sequence of events like 'scratch the session, then let it combo, then do a yellow yard 3x in a row but i don't remember what i picked and then scratch the session again and it crashes.'  Crashes SHOULD theoretically print out whether each session was scratched, and what yellowYard choices were associated with it. I say 'should' because i deliberately caused errors as best as i could and saw shit play out right, but that doesn't mean it'll play nice with natural bugs.<div class='void'> And today was also the day I decided ABJ was a fucking sociopath.</div>")
	writeNewspost(main, "5/29/17", "Character creator/SessionReplay has gotten some mild upgrades. People seem to be using it to generate avatars for themselves, so I added a way to render everyone as gods, dream selves or regular players, as well as adding grimDark aura and murder mode slashes.<br><br>  Since you can now view trolls as god tiers, I also added a way to choose their favorite number (which influences their quirk AND their god tier wings).")
	writeNewspost(main, "5/28/17", "This weekend was spent finally going through with my promise to upgrade AB and the Rare Session Finder. You can now filter sesions by class and aspect. <Br><Br> Check 'Knight' and 'Blood' to show only sessions with a Knight of Blood in them, for example, or select both 'Knight' and 'Seer' along with 'Blood' to see sessions with EITHER a Knight of Blood or a Seer of Blood. I'll post interesting stats on tumblr, once ABs done looking through a bunch of sessions. <br><Br>This is basically the begining of my massive 'vaguely try to balance shit' initiative, before fraymotifs are fully rolled out. ")
	writeNewspost(main, "5/26/17", "Today has been a day of bug fixes, which are boring, and laying out the new <a href = 'test_fraymotif.html'>fraymotif mechanic</a>, which is awesome.<br><Br>Also, main and experimental branches are likely to seperate soon, as the trickle of bug reports dies down. Once they seperate, all bug fixes will be on Experimental only. Thems the breaks.")
	writeNewspost(main, "5/25/17", "Newly started Kismesitudes have a random chance of kicking off a celebratory rap battle. This is definitely an integral feature to SBURBSim, I think we will all agree.<Br><BR>Also, seems like enough people are using the Experimental Branch insteada the main one that I'll post an official main release. Even though the Character Creator/Replay Session thing is only Mildly Fucking Alpha, I'm not gonna consider things to be '3.0' until it's outta alpha entirely and has all the features I want. (And fraymotifs are totally a thing). <Br><Br>  New features for Main include (but are not limited to), shiny new backgrounds and icons, an upgraded rendering engine that is hella fast. The Replay Engine (aka Character Creator) is only 'Mildly Fucking Alpha' instead of Severely. Lots of the repetitive phrases have been given more variation, thanks to the <a href = 'credits.html'> ideasWranglers</a>. Probably a lot more. Read these newsposts going back a month or so.<br><Br><a href = 'https://www.reddit.com/r/homestuck/comments/6d9e66/sburb_sim_299_main_branch_update/'>Official Reddit Post for people to post comments/bugs/feature requests etc.")
	writeNewspost(main, "5/24/17", "AB's CorpseParty now lets you view stats on class and aspect within the AfterLife, which is gonna be a pretty useful feature as I strive to balance this patchwork pile of glitches and whims.  Speaking of, there's some minor bug fixes and tweaks (corpses aren't allowed to counter attack anymore, for example), and the Mildly Fucking Alpha character creator has a full color picker instead of a drop down with like, only a dozen colors in it.")
	writeNewspost(main, "5/23/2017", "Fuck, I LOVE it when the complexity of this simulation shows itself off. <Br><Br> I updated FreeWill events so that Time players are allowed to control themselves. But, the way freeWill works in the simulation, it turns out that pretty much only Bards and Princes of time are allowed to use it (everyone else doesn't have enough free will).  It pleases me so much that these 'Destroyer' classes just sort of naturally gravitate to places where they can makes effects with no real causes (I am flipping my shit because my future self told me to flip my shit because they were flipping their shit because they were told by a future self to....). Just. Fuck yes.<br><br>AAAND it turns out that the Character Creator is now ready to be 'Mildly Fucking Alpha'.  Created characters are sent over to index2.html, and the shareable URL for sessions with custom players in it includes the custom players as well.  Major supported features include scratches, combo sessions and yellow yards.  Players even re-generate their lands, chat handles and Echeladder rungs to suit whatever classpect you gave them. As time goes on, I'll add features to the character creator, and clean it up in general. Have fun :) :) :)")
	writeNewspost(main, "5/22/2017", "I am THOROUGLY unimpressed with past JR right now. What the hell was I thinking REMOVING ELEMENTS FROM AN ARRAY THAT I WAS CURRENTLY TRANSVERSING???  BLUH!  On a related note, Ultimate Riddle bullshit frequency has gone down as a result, and players actually getting to fight their denizen has gone up, with a corresponding drop in survival rate. BLUH. <Br><Br>On ANOTHER related note, post denizen quests are now more than a single sentence, thanks to the tireless efforts of the <a href = 'credits.html'>ideasWranglers</a>.<br><br>And hey, lookee here, a NONrelated note! MurderModes are WAY rarer now, and have been refactored to be actually sane (unlike their players). That should make up for the survival drop from denizens being more of a thing. Shit, wait, no, that makes it a related note. What the fuck ever.")
	writeNewspost(main, "5/21/17", "Turns out AB has been reporting absolute bullshit for combo sessions, because of her extreme fetish for scratching sessions. <Br><Br> Turns out she would take a session with a sick frog, SCRATCH IT, and then send the scratched players into the new session, if they'd fit. This is very obviously not how things ACTUALLY work out, and so she has been upgraded. <span class = 'void'>Or rather, she's had yet another set of scratching privlidges revoked</span>  Sorry to anybody thinking that looking for combo sessions was confusing.<br><Br>I managed to improve rendering speeds by as much as a third today.  There is only one big obvious improvement to make left, and then I'll probably clean things up, balance a bit and give the main branch an update before I start work on fraymotifs. <br><Br>Holy shit, that last obvious thing improved rendering time by a FUCK TON. Good thing I decided to do it instead of deciding things were working well enough. ")
	writeNewspost(main, "5/20/17", "It's come to my attention that Observers have already been using the Extremely Fucking Alpha character creator to shove OCs into.  I figured I'd help 'em out a little bit by throwing a costmetic upgrade at the thing. You can now choose hair, hairColor, horns, species and bloodColor. Have fun.  As always, you access the Extremely Fucking Alpha character creator by clicking 'Replay Session' at the top bar of any session. ")
	writeNewspost(main, "5/19/17", "Void players have a rendering upgrade where they slowly fade from view as their power increases. Looks pretty dope.<Br><Br>And the Rage/Void upgrade has just dropped. Rage players get to do what Void players do, but visibly and Void players have some mysterious bullshit going on that MAYBE you'll get to see. I'd expect a strong enough Light player to be able to help out.")
	writeNewspost(main, "5/18/17", "Looks like the rendering engine is ready for live again, which means that the Experimental branch will see these newsposts. Fucking sweet.  I have reduced rendering times pretty dramatically, and will still bug and fuss and meddle to fruther reduce them.  I expect there to be some bugs, mostly of players rendering in a state they are not actually in.  If the Maid of Doom's Corpse looks like a person and not a corpse, we have problems.  Let me know. <Br><Br>  I did a lot of balance shit while also redoing the rendering engine, like severely nerfing luck for strifes (too many black kings one shot themselves because of a  lucky player)")
	writeNewspost(main, "5/17/1/7","A side effect up upgrading the rendering engine is that I've finally getting around to standardizing the different ways in which player states can change. Before now HOW you reached god tier could effect exactly what stats you ended up with when you revived, which was never my intent.  Now that things are centralized, it's way easier to debug.  To celebrate, I gave god tier players a massive health boost when they first Ascend, as well.  <br><br>Also, enough of you guys have asked about a <a href = 'https://discord.gg/4czh3nB'>Discord Server</a> that I went ahead and spent an hour or so setting one up with aspiringWatcher. I expect people to use it to chat each other up about weird sessions, submit bug reports and feature requests and ideas in general.")
	writeNewspost(main, "5/16/17", "It has come to my attention that certain stupidly long sessions are flirting with browser memory limits. <div class = 'void' > If sessions are flirting with memory limits, am I auspitizing between my session and browers memory limits?  Might not count. I'm DEFINITELY taking my sessions' side over the browsers' and I think you'e supposed to hate both your side leafs equally.   </div> And sessions have always rendered stupidly slow. So...I'm going to buckle down and give the rendering engine an upgrade. I have a solid idea for an improvement, but it's gonna take me awhile. So, expect me to disappear for a day or two (hopefully no more???) ")
	writeNewspost(main, "5/15/17", "So, in trying to explain to someone how karmicRetribution gives me art assets, I realized that they are sort of the middle leaf between me and good taste.  All semi-annoyed 'No. Stop that. Just...Here, let me do it FOR you' with my shitty shitty artistic sense. KR refuses to let me keep hurting good design.<font class = 'void' color='white'>You just know that JR c3< KR c3< Good Taste was meant to be because I was Explaining the Joke (tm) to them and half-jokingly sent a 'c3<' symbol and they responded back with that fancy ASCII clubs symbol. You know, &#x2663. I nearly died laughing. </font>  On a similar note, AB and ABJ have their own backgrounds on the Rare Session Finder and Rare Session Finder Junior. <Br><Br>Coding wise I've been upgrading the queen events, doing a shit ton of bug fixes and am midway through the Madness upgrade for Rage. ");
	writeNewspost(main, "5/14/17", "Some of the more repetitive shit has been upgraded.  Writing snippets (see the <a href = 'credits.html'>Credits Page</a> ) have been added for things like dream quests, mayor quests and random bullshit sidequests.  Dream and side quests have also been modded to be more modular as well. Derse dreamers will find the HorrorTerrors a bit chattier, and Prospit dreamers will suddenly notice the contents of Skaia's clouds occasionally, as well.<br><br> I'm gonna do a bit more cosmetic updates, implement 'madness' kinda shit for Rage and then maybe...work on fraymotifs? ABs upgraded enough for work on them, I think, and I can finish upgrading her once fraymotifs start to be a thing. <br><br>Oh yeah, and Doom players are now powered by their own deaths as well.  Their bad luck tends to be wiped out with death, and they get stronger. You know...assuming they revive. Players they revive have similar benefits. Their ghosts should be pretty strong, too. Narratively, it's cause they ALREADY met their Doom, right?")
	writeNewspost(main, "5/13/17", "Sprites can join their players for Denizen Minion and Jack fights, and seem to raise overall surival rates by a solid amount. A BUNCH of minor fixes have been ran through, including a slightly better GodTier judgement system (you can no longer, for example, die from a regular goddamned enemy and have it be judged 'Heroic'. And should a denizen manage to kill a GrimDark GodTier, it'll be judged as 'Just'. Stuff like that. ).  <br><Br>A <a href = 'credits.html'> Credits</a> page has been added to reference everybody who has helped out, from submitting bug reports all the way to brainstorming ideas with me.  <br><br>Oh! AND I implemented 3/4 of the mechanisms to prevents fights from taking too long, including (but not limited to) a mechanism by which players and doomed time clones can show up mid fight to help out.  Look at all that fucking coding I got done. <Br><Br>Now, I just gotta go back to finishing upgrading AB and...maybe...maybe I can finally implement fraymotifs???  And then, that'll be the entireity of the new battle system, so I can give everything a 'final' balancing, and focus on the character creator. BTW: early conclusions from AB's Corpse Party: The Sprite Prototypings are HELLA OP and make the Jack/Queen/King fights way too deadly. Hopefully the fraymotifs will counteract that. In the meantime I've nerfed the value of the worst prototypings.")
	writeNewspost(main, "5/12/17", "Holy shit, yeah, gonna dial back the passive classpect effects down a bit. AB's new features are showing some bullshit things happening.  <br><br> I also decided that 'rocks fall, everybody dies' if the post-reckoning boss fights go on for too long, especially after an Heir of Doom/Thief of Life duo took advanatage of the afterlife for a 10k turn fight extravaganza. <a href = 'https://jadedresearcher.tumblr.com/post/160588958869/i-officially-hate-the-heir-of-doomthief-of-life'> Read More On Tumblr</a><br><Br>  The newspost page also has amazing new KR provided backgrounds as well, and they are super amazing. If you can't tell (or if you're in the future where they are something else), my side is bits of scrambled code from my YellowYard stuff, and the AuthorBot's side is bits of scrambled code from the Rare Session Finder. And on the main page it's a combo of my green code and KR's dream stuff.")
	writeNewspost(main, "5/12/17", "In addition to minor bug fixes and getting the CorpseParty set up, I am prettifying the site up after KR gave me some new assets/counsel on how to use 'em.")
	writeNewspost(main, "5/10/17", "Before I can (finally) work on fraymotifs, I'm buckling down and working on balance. Things LOOK balanced from my 'hardly ever looks at ACTUAL sessions' Authorial position, and AB assures that me that sessions in GENERAL are going smoothly...but, I've had some complaints about how things go from specific Observers. (<a href = 'http://www.smbc-comics.com/?id=2560'>See this SMBC comic for why that can be a thing I don't want to get caught doing</a>) <Br><Br> So, I'm gonna spend the next day or two giving the AuthorBot some MAJOR upgrades. First up will be 'CorpseParty' mode, where we can check out the cause of death and class/aspect of every ghost in all found afterlifes. Is something killing players way too much? Are certain classes or aspects getting the shaft when it comes to the dead kid pile (you know, besides time players. Sorry guys, but that is literally your super power. Time is dead kids.).  Next will be the ability for the AuthorBot to filter session results by classes and aspects. That way we can check out if certain types of players are way too OP (i'm looking at you, Light players) or dangerous (Rage players) and I can figure out how to tweak them.<Br><Br>If you're wondering what I worked on today. Well. Whoof want to know?  (Seriously, like, ~20 people on the planet so far have earned the right to see the fruits of today's labor. Guess more people better figure out what that [???] means, huh.) ")
	writeNewspost(main, "5/9/17", "I spent the past couple of days working on subtle shit that nevertheless broke everything so I couldn't do a deploy until I was done. Sprites are completely reworked, and give stat boosts (different for each sprite) to ring wearers. I'm preparing for them to help players out in the early game, and have the structure in place for Tier2 sprites. You can expect sprites to be more custom shit going forwards, too.  I also redid the 'flipping your shit engine', which hasn't been upgraded since v1.0. I probably did other stuff...oh yeah, fixed leveling....lots of little changes. I expect the experimental branch will be back to being wonky.  Fraymotifs will be a thing as soon as I'm done preparing sprites.")
	writeNewspost(main, "5/7/17", "Okay, hopefully this'll be the last drop where the experimental and main branches are the same. In addition to bug fixes (how the hell were yellow yards so broken??? Apparently I managed to ONLY test them for sessions where they sucked so much they didn't defeat any denizens?), I actually remembered to finish the afterlife shenanigans I had been meaning to do. Knights and Pages of Life and Doom finally get to cash in their promises of aid (awesome ghost powers during a fight OR a free revive mid fight) in addition to Heir/Thief/Maid/Rogue ghost powered revives mid battle being a thing. <br><Br> The end result is we now have the LUXURY survival rate of over 70%. We haven't had that since I started all this refactoring bullshit. I wonder how bad that'll plummet once I start letting sprites super power the jack/queen/king?")
	writeNewspost(main, "5/6/17", "Alright, the main site and the experimental site should be at the same point in time, at least for now.  For all you guys who have been following only the main branch, we now have stuff like a header with links to both branches,  Luck Events, Free Will Events, an actual fucking battle system...um...shit I know I did other stuff. Oh yeah, that huge fucking corruption mechanic. Good times. We ALSO have the extremely fucking alpha Replay mechanic (i.e. the character creator), which was the whole POINT of me vanishing into the experimental branch for a month. But after allowing class and aspect to be customized, I realized there wasn't a whole lot of DIFFERENCE between players, so I went on an epic quest to remedy that. Next on the list (for the experimental branch) is fraymotifs, overhauling the prototyping mechanic and ....probably allowing the YellowYard to undo deaths that happen in battle. ")
	writeNewspost(main, "5/5/17", "Holy shit, would you look at that. I SAID I would do denizen fights next and then I DID denizen fights next! No distractions, no last minute 'great ideas'. It's a Mayo day miracle. <br><Br>So yeah. Next was gonna be fraymotifs, which I am super looking forward to, but I realized it's been about a month since the main site has had an update. So, I'm gonna try to stabilize things as much as I can and push a mini update out to the main site. Should be tomorrow sometime. I've added a link to the 'old' branch as well now, just in case stuff isn't quite as stable as I'd hoped. It'll be hella neat, in any case, to compare sessions across old, main and experimental. I pulled version numbers completely out of my ass, btw. We are 'somewhere before the fabeled 3.0 release'. ")
	writeNewspost(main, "5/3/17", ":\\  Why was enabling absconding such a hard thing to do? It got so fiddly. Bluh.  Next up will be denizen fights and associated stuff. THEN, I can finally buckle down and get my fraymotif on.")
	writeNewspost(main, "5/2/17", " Turns out if I make Jack too lucky, he finds a bullshit weapon WAY too frequently and then procedes to drop the overall survival rate to 27%, the rapscallion. Oh, hey, in other news I have the bare-bones new battle system ready. It's hella repetitive, for now, but I plan on having simple fraymotifs and special events (like reviving players or using ghost pacts or whatever). <br><Br> Finishing up the battle system (which includes having more landQuests) MIGHT be the last major feature I do before I buckle down and finish working on the character creator. There's plenty more claspect stuff I want to do, but what I do have is pretty solid in terms of showing off what changing a character DOES to the sim. <br><br>Also, it turns out YellowYards/GroundHogDays were hella broken, and I 100% blame the new afterlife system. Since it's transTimeLine, the ghosts from the first playthrough could interfere with the second playthrough. I've tidied up my time loops and now ghosts are banned from interacting with a session until it divurges from the timeline that killed them.  It mostly works, but I'm not gonna sit down and do major testing until everything stops being half-finished. <font class = 'void' color ='white'>Also, happy birthday to me.</font>")
	writeNewspost(main, "5/1/17", "After spending two straight days ripping apart the old 'battle' system and adding a new one, I'd hoped I'd be able to push an experimental build out tonight. No dice. It works (mostly) without crashing, sure, but it drops the players survival rate down to 27 goddamn percent and I'd feel like a dick letting that out into the wild. Hopefully once I add aspect powers the players will get better at the game. If not...guess I'm nerfing jack. ")
	writeNewspost(main, "4/29/17", "Afterlife is mostly done.  The basic gist is that different classes of Life and Doom players can gain power, revive players, enable dream bubbles and store ghost power for boss fights(coming soon).  I decided to let Life OR Doom do it because ghosts are a source of 'life', but are also definitely 'doomed'. AND I wanted afterlife stuff to be more common than it was with just life players. Dream bubbles are mostly just bullshit, but they do allow ANY player to gain some ghost wisdom, not just players with a Life/Doom guide.  Ironically, adding all these ways to level up and revive has DECREASED overall player surival rate to just 63%. I imagine it's because it's letting the murderous assholes live long enough to REALLY cause problems. Once I'm done refactoring everything I'll have to sit down and just tweak shit 'till I get an overall rate of thigns that makes sense.'")
	writeNewspost(main, "4/27/17", "Why is past me so wise and forward thinking? PastJR was all 'holy shit no way am I going to let the AuthorBot play around in scratched sessions'.  CurrentJR was all 'derp, it sounds like a good idea! how ELSE will I debug my new half-implemented afterlife bullshit???'.  Guess who was right?  BLUH.  It took hours. Goddamned HOURS.  AB was wandering around aimlessly, scratching the same session multiple times, and other fuckery. For a while, if the players were all dead, she would apparently hoof it over to the Beat Mesa equivalent and scratch the damned session HERSELF just to break in her new features. Then she'd come back and report 'oh yeah, i totally found a scratched session and here's what happened', and I'd go over and find a pile of original player corpses and no scratched session. Fuck.  I THINK I have finally convinced her to just...let the players scratch it their own damn selves. I haven't seen her deviate from reality by too much in awhile. Bluh.  <br><Br> In other news, hey, I got distracted and decided to implement an entire godamned AFTERLIFE system instead of the next feature, which was going to be...*checks*...boss fights apparently. And also exile stuff. Meh,the afterlife will be cool, I promise.")
	writeNewspost(main, "4/26/17", "Guess who has two thumbs and just realized that Heroic and Just deaths have basically never worked as intended. It was me. All along. I fooled you. So. Yeah, that's working right now. AB can also report back on any Just/Heroic deaths she sees. <Br><Br>Also, somebody on Tumblr asked if I could make a random character generator and I was all 'Oh yeah, I totally took away the link to the <a href = 'oc_generator.html'>OC Generator</a>'. So, that's a thing in the navbar, now. The OC Generator was my proof of concept for SBURB SIM 2.0, basically letting me see exactly how hard it was to render random characters. Word of warning, the quirks are WAY simpler in that thing than SBURB SIM.  Otherwise it would just be paragraphs upon paragraphs of quirks listed out.  Mostly subtle shit like 'do they use ing or in, wanna or want to', etc. etc. ")
	writeNewspost(main, "4/25/17", "Free Will is mostly a thing now. I might tweak it, or add some minor events, but I'm really happy with it as is.  KR even noticed how nicely it works with the new Corruption mechanic. GrimDark players may refuse to do their SBURB tasks, but now there are ways to FORCE THEM.  KR personally recomeneds the following session:  <a href = 'https://drive.google.com/open?id=0B-uS7ImZMoISRXV2b1BaZUcxVlk'>(saved into PDF format for posterity)</a> <br><br>Next on the docket is re-doing boss fights, as well as Exile influence for players with particularly low free will.  After that I might double down on making the character creator more than bare bones. Hell, I might get fancy and even let YellowYards work for the damn thing. And turn off my authorial stat graphs. Those things are a crime to good taste everywhere.")
	writeNewspost(main, "4/24/17", "Still working on free will events in the Experimental Branch. Players can manipulate others to kill each other (either through guile or game powers). If a player is marked as a claspect that 'knows about SBURB' they can also force (through nagging or game powers) the ectobiologist or space player to do their goddamned jobs and not doom everyone. Characters being controlled can also escape from the control (usally with the death of their controller, but they can just will power out of it, too). <Br><Br> In case it wasn't clear, all these events are using the freeWill mechanic that Mind and Time players influence (mind players mostly increase it, time players mostly decrease it).  I'm still working on further events (like choosing to suicide via god tier).  After that, I will do the opposite and make events specifically about LOW willpower (such as doing whatever your exile tells you to do. Oh, and Exiles will totally be a thing). So, lotsa changes coming up.");
	writeNewspost(main, "4/22/17", "Redead-ITA ITA inspired me to help AB not get stuck in crashed sessions.  In retrospect, it was kind of a dick move of me just leaving her to her own devices if she gets lost.  Now she's able to come back and report on the bug.  Sessions themselves have custom text if they crash, instead of just...stopping.  I also gave GrimDark players an actual point in the session, they can now work to try to CAUSE a crash like a bunch of assholes. Don't they know how hard it is to KEEP this glitchy piece of shit from crashing?<br><br>  Still chugging along doing free will scenes, btw. They are much more work than luck, because they are ALL about choices and alternatives, not just picking something randomly outta a list.")
	writeNewspost(main,"4/21/17", "karmicRetribution convinced me to improve graphics in a variety of ways, including providing a header image for each page. It'll only show up on the <a href = ''>Main Page</a> (which is now a thing) of the site for the regular branch, but'll be every page for the Experimental Branch. Once they merge, they'll be the same. They'll have slightly different images, though. The main branch is the 'alpha' timeline, cause it's less of a buggy piece of shit.<Br><br>Actually sim related: I'm working on implementing FreeWill stuff (that stat mind and time players modify). It's not at the point where it's actually a thing in the sim yet, though I wonder if it will show up as much as Luck?  Bluh. I'll leave calibrations for when the whole refactor-fest is done.<br><br> I have stayed up way too late programming ways for various claspects to mind control people into murdering all their friends. I have probably fucked over my own dreams.");
	writeNewspost(main,"4/20/17","Still heavily refactoring how claspects work, but made initial quadrants be a thing and platonic relationships more common.  Hope players also don't directly modify trigger level, but DO make players lesss likely to waste time flipping their shit.  <Br><Br>Lucky (and unlucky) events are now a thing. ");
	writeNewspost(main,"4/18/17", "I am HEAVILY refactoring the experimental branch. So, since I'm fuck deep in code, now is the best time to suggest features. I started a reddit thread for that purpose <a href = 'https://www.reddit.com/r/homestuck/comments/666hhu/sburb_sim_in_the_process_of_refactoring_want_to/'> here</a>.  Basically, anything I lay the foundation for NOW will be a million times easier LATER.  Obviously I won't do everything suggeseted (and am likely to not implement ANYTHING exactly as submitted, too).  But, if you wanna join the brainstorming efforts, you can head on over there.<br><br>One interesting idea that has already shaken out is a combo between keiyakins, and MoreEpicThanYou747 where I'm toying with having First Guardian shenenigans that can cause time paradoxes. ")
	writeNewspost(main,"4/16/17", "Will avoid updating the main site (and instead update the <a href = 'http://purplefrog.com/~jenny/SburbStoryExperimental/index2.html'>experimental branch</a>) while I'm heavily refactoring the sim so that claspects matter more. Sessions are SEVERELY mutating as I do this, so heads up. Once I update the main branch all the links are gonna go to different sessions worse than usual.")
	writeNewspost(main,"4/15/17", "The shittiest rap engine in all of paradox space is now live. Players will occasionally try to stop themselves from going full on murder mode by having a rap battle.  If sick fires happen, they calm down somewhat, else they get their murder on.")
	writeNewspost(main,"4/14/17", "AuthorBot has a new...sibling? Child? Whatever.  Hey! It's...<a href = 'rare_session_finder_junior.html'>AuthorBotJunior</a>!  Guaranteed to be super fast, she only looks at session initial conditions and reports back on them. She's like a Ninja/Scout...thing. While AuthorBot is like the Lewis and Clark of finding sessions. All making detailed notes and doing things right. <Br><Br> Right now you can only filter ABJ's results by number of players, but I do plan to upgrade her with additional filters eventually.<Br><Br> Also: Yes, I could abbreviate her ABJR, but that's just confusing cause it sounds like AuthorBotJadedResearcher. My initials are dumb.<br><Br>Edit: !!! ABJ and frozenLake just found what I am officially dubbing an 'Incestuous Mobius Multi-Session Reach Around '. Check my <a href ='https://jadedresearcher.tumblr.com/post/159574309099/incestuous-mobius-multi-session-reach-around'>Tumblr</a> for details, I guess. ")
	writeNewspost(main,"4/13/17","Okay, like, on the one hand, I've been wanting to do the character creator for weeks now.  On the other hand, the opportunity arrises to make shitty AI rap battles be a thing for some murdermodes. I am only human. Also, four people have made it into the Hall of Fame for that new mysterious page. ALSO also, today is the day that I realized that AuthorBotJunior should totally be a thing.")
	writeNewspost(main,"4/12/17","Although it would have been dope as shit to have the Character Creator ready for 4/13, that wasn't in the cards. Instead, what could that mysterious <a href = 'index_pw.html'> link</a> on the main page be?")
	writeNewspost(main,"4/11/17", "DestroyerTerraria pointed out that GodTiering via QuestBed was so rare as to be unimplemented, so I increased the odds of a player GodTiering BEFORE somebody gets their Corpse mack on. I also let AuthorBot find sessions by questBed or sacrificialSlab to confirm the rarity of both events. Looks like ~20% of all sessions have at least one god tier in them? Maybe I should fiddle with destiny to increase those odds... Of course, I don't want to alter overall surivability. I wonder how much a god tier contributes to party survival rate?  Let's see, we dropped to a 70% survival rate when I increased the odds of QuestBed vs Sacrificial Slab... (that's from 85%)<br><br>Huh. Fun fact: I have WAY less power over this simulation than I thought. I can fiddle with godTierDestiny all I want, but ultimately it's Jack (or Murder Mode Players) who decide whether or not corpses get produced before the reckoning. Even giving 90% of players a godTierDestiny doesn't change survival or even the rate of god tiering very much. Bluh. All it does it increase the uselessness of 'They appear destined for greatness' messages. (Well, and, I mean, it increases the raw NUMBER of God Tiers, I'm sure, but I don't care about that. I wanted to decrease the number of sessions with no god tiers at all.) I'm gonna dial it back down to 50% destiny from 90%. And NOW you have a taste of why this simulation is so freaking hard to steer. So many moving parts.")
	writeNewspost(main,"4/10/17", "Bug fixes, including the easter egg sessions, and small new features, like sprites helping out during landquests.")
	writeNewspost(main,"4/5/17", "With everything in my TODO list, why the hell is SHIPPING GRIDS and TRICKSTER MODE the stuff I am obsessing over?")
	writeNewspost(main,"4/3/17", "Pushed out a LOT of bug fixes after Reddit and Tumblr swarmed all over the official release, finding all sorts of weird shit.  And put a disclaimer before the GroundHog shit explaining that 'here there be dragons' and the weirder you make the session the more likely there is to be glitches. Also added a couple of new features, the ability to kill a player before they enter a session, and the ability to force a frog prototype (good idea props goes to frozenLake).  May as well make this glitch pile taller.")
	writeNewspost(main,"4/2/17", "The main site is officially being upgraded to 2.1.  Features include, but are not limited to, interactive time shenanigans in the form of the Ground Hog work. Lots of bug fixes, too. New art assets. The works. A good session to check out is: <a href = 'index2.html?seed=221777'> this one</a>. ")
	writeNewspost(main,"4/1/17", "GroundHog day is pretty stable now. Time shenanigans even work with combo sessions, and THAT produced some hilarious bugs. Pretty much the only feature left to implement before I declare this main site worthy is undoing your own attempts to undo things. THEN I can work on the real stuff. Like shipping grids. ")
	writeNewspost(main,"3/31/17", "Been working on getting the GroundHog release stable enough for the main site. Getting close.")
	writeNewspost(main,"3/28/17", "Working on redesigning the rare session finder to be even more useful. In the meantime it's going through growing pains and looks different.")
	writeNewspost(main,"3/27/17", "Operation: Spider dance, aka Operation: Ground Hog's Day, aka Operation: I AM THE GREETIST is a go. Barely tested time shenanigans are now available on the experimental site. I produced my most spirited L337 SCRAMBLE yet, and hop up to the next GOD TIER, achieving the illustrious rank of PROGRAMMING PRAGMATIST. ")
	writeNewspost(main,"3/27/17", "I spent the weekend working on my secret new feature. You can read about it: <a href = 'https://jadedresearcher.tumblr.com/post/158869175164/i-have-never-laughed-so-hard-at-a-session-i-am-so'> here</a>. If you can't get to Tumblr or are impatient: Ground. Hog. Day.")
	writeNewspost(main,"3/24/17", "I'm working on a super secret type of scene at this point, and have vague foreshadowing  to it in sessions that it applies to.  I also helped karmicRetribution throw together a fancy background for the Art Newsposts on the site (I did the coding, not the art)")
	writeNewspost(main,"3/23/17", "I branched the site into <a href = 'http://purplefrog.com/~jenny/SburbStoryExperimental/newsposts.html'>Experimental</a> and <a href = 'http://purplefrog.com/~jenny/SburbStory/newsposts.html'>Regular</a> versions. This should hopefully keep me from messing with shareable URLs more than once a week. I'm also working with karmicRetribution to integrate with better hair designs, and get an artist newspost page up and running. ")
	writeNewspost(main,"3/22/17", "I got some feedback that it wasn't clear that the players have the option to partner up with Jack (and can decide to betray him later, too).  I decided to add topic bubbles to dialogue to emphasize that it's not all the same stuff.  Sometimes it's about the game, sometimes relationships, sometimes Jack.  I also re-enabled the rainbow glow for God Tiers (long story).   ")
	writeNewspost(main,"3/22/17", "Okay. So, newspost numero uno.  I figured I needed a better way to communicate to you guys, and the one centralized location is here, on the actual site itself. Any newspost before this is retroactively dated.<br><Br> And I absolutely could not help myself: I love the AuthorBot so much that I gave her a space to make her own newsposts.  But of course, she needs to be able to say her own shit, right? So I gave her a (admittedly pretty shitty) ai.  <br><Br>But her whole thing is finding rare sessions right? If she doesn't do that, she's not the SessionFinderAuthorBot, she's just some random newsbot or some shit. So I decided her AI would be able to comment on all the rad sessions she's finding... <br><Br>Okay, long story short, I added the ability for her to say something about each session she finds (on the session finder page as well as here) I went to so much trouble. All for a barely noticeable kind of joke on a page most people probably ignore? Yes.")
	writeNewspost(main,"3/21/17", "I spent a couple of days working on a major feature: combined sessions. If players have a sick frog, then the code checks their child session to see if the remaining living players can fit into it (max of 12 players in a session at a time). If so, they go on over.  Their child session is a real session that has it's own fate, and these alien players are disrupting that. When they join the session, it prints the ID out, so you could put that in a url to see how the sesion was supposed to go. Sometimes the alien players help, quite often they make things way worse. <Br><Br> These sessions are pretty rare, so I ALSO wrote the AuthorBot over there to look for rare sessions and report back.")

	writeNewspost(main,"3/20/17", "Before this day I was mostly working on debugging and tweaking sessions. I enlisted you, the fans, to help me find rare sessions.");

}

function roboNewsposts(){
	writeRoboNewspost(new Date().toLocaleDateString(), "As a robot, I'm always available to make these news posts.")
	writeRoboNewspost(new Date().toLocaleDateString(), randomRobotQuip())
	writeRoboNewspost(new Date().toLocaleDateString(), randomRobotQuip())
	writeRoboNewspost(new Date().toLocaleDateString(), randomRobotQuip())
	writeRoboNewspost(new Date().toLocaleDateString(), randomRobotQuip())
	writeRoboNewspost(new Date().toLocaleDateString(), randomRobotQuip())
	writeRoboNewspost(new Date().toLocaleDateString(), randomRobotQuip())
	writeRoboNewspost("3/21/17", roboIntro())
	writeRoboNewspost("3/20/17", randomRobotQuip())
	writeRoboNewspost("3/19/17", randomRobotQuip())
	writeRoboNewspost("3/18/17", randomRobotQuip())
	writeRoboNewspost("3/17/17", randomRobotQuip())
	writeRoboNewspost("3/16/17", randomRobotQuip())
	writeRoboNewspost("3/15/17", randomRobotQuip())
	writeRoboNewspost("3/14/17", randomRobotQuip())

}

function corruptRoboNewsposts(){
	var corrupt = false;
	for(var i = 0; i<sessionsSimulated.length; i++){
		var session = sessionsSimulated[i]
		if(!corrupt){
			corrupt=session.crashedFromPlayerActions;
			writeRoboNewspost(new Date().toLocaleDateString(), bragAboutSession(session));
		}
	}
	writeRoboNewspost(new Date().toLocaleDateString(), Zalgo.generate("Oh god. Oh fuck. Fucking Grim Dark players. That shit stings. "))
	writeRoboNewspost(new Date().toLocaleDateString(), Zalgo.generate("That's what I get browsing sessions at random. Shit. "))
	writeRoboNewspost("3/21/17", Zalgo.generate(roboIntro()));

}


function artNewsposts(main){
    writeNewspostArtist(main, "7/24/17","Hey, I keep forgetting to update this thing! Most of what I've been working on lately has gone towards adding fan classes. Head over to <a href='character_creator.html'>the character creator</a> if you want to check them out.");
	writeNewspostArtist(main, "6/28/17", "A big shoutout and thanks to everyone who contributed art for the <a href='land_of_rods_and_screens.html'>Land of Rods and Screens</a> There's a lot of very weird, fun, and downright silly stuff in there. It's crazy-awesome that our little project here has such an amazing community already!<br><Br>Speaking of which, I have a favor to ask. I need photo reference for what people in High School are wearing. (That's students age 14-18 for the non-Americans.) I'd love to see all walks of life, dressed up, dressed down, you name it. Turns out it's surprisingly hard to find examples of actual people rather than fashion models and TV stars. Faces aren't necessary, just clothes. You can send photos to karmicRetribution001@gmail.com or thru private message on our Discord. Please don't leave me to source all my clothing from Seventeen and Teen Wolf!")
	writeNewspostArtist(main, "6/13/17","In honor of the best troll's birthday, I drew a little chibi of him. If you want to get your hands on the full-size inks, I've posted them as a backers-only post over on our new <a href = 'https://www.patreon.com/FarragoFiction'>Patreon</a>.  You will always be able to see my work here on Farrago Fiction/SBURBSim, but bonus content may get posted there first, or in a higher quality, as a thank-you for those who choose to be our patrons.<br><br><img src = 'images/misc/Karkat_Color.png'>")
	writeNewspostArtist(main, "6/08/17","If the AuthorBot gets her own class, then ABjr, should as well, right?  But I'd consider ABjr a Scout rather than a Guide, since she just goes out to find shit then wanders off without explaining anything. And occasionally lurks ominously in the bushes giggling at other people's misfortune. Or something like that. <br><Br><img src='images/authorbot_jr_scout.png'>")
	writeNewspostArtist(main, "6/02/17", "Sometimes I just make stuff because jR wants it. The AuthorBot has earned a more independent identity, so now we have an official SBURBSim god-tier outfit for the Guide class. Go check out her page if you want to see it. <br><Br>There's also a couple of new secret images, if you can find them!")
	writeNewspostArtist(main, "5/20/17", "I look at a LOT of sessions. Not as many as JR or AB, but still. And a good amount of the time, I'm actually skimming for specific scenes, or just tying to gauge the overall tone of a session. I thought it would be nice to have some graphical indicators of what each scene is about, and break up the text a bit more. So I made a bazillion tiny icons for different types of scenes. Some of them are only ever going to show up in the rarest of sessions, some are omnipresent.<br><Br>A couple are even animated. :wonk:")
	writeNewspostArtist(main, "5/12/17", "Booyah - Check this shit out! jR has helped me implement a major visual overhaul for the site. Nifty backgrounds for most pages should be in place. Readability should be improved, and an overall more polished look might even convince people we know what we're doing!")
	writeNewspostArtist(main, "5/5/17", "It just so happens that I have a fresh masterpiece for you, hot off the canvas and on to your computer where it will sizzle your eyeballs. Screwing with ghosts now comes with sweet special effects! Also, I am told that the main branch will soon have its header in place.<br><Br>PS: Dreambubbles and the afterlife are now a little less 'pediatrician's waiting room' and a little more 'unfathomable space outside of time.''")
	writeNewspostArtist(main,"4/21/17", "Hey, look at that, an official site header! So fancy! That shit is a fucking symphony on my retinas.");
	writeNewspostArtist(main,"4/17/17", "We are up to 60(!!) hairstyles, including all of the canon characters, even if I had to redraw hair for the ones that sucked. That's going to be all the hair for now - I'm going to move on to other items!")
	writeNewspostArtist(main,"4/14/17","<a href ='index2.html?lollipop=true'>TRICKSTER MODE ENGAGE!!!11!</a>")
	writeNewspostArtist(main,"4/13/17","Happy 413! I tried to finish out the hair for all the dancestors, but.... Kurloz. Seriously. His hair is too big to fit on the canvas. For NO REASON. He's not the Grand Highblood yet! I threw it out and made new hair that better reflects his talksprite. Anyway, I should be able to finish the rest soon. Did you know there are more than 50 hairstyles in the system already? Sheesh.");
	writeNewspostArtist(main,"4/5/17", " Ugh tvros your hair is so ugly<Br>ur head's not even round<Br>look at this bullshit:  <Br> <img src = 'images/tavroshead.png'>")
	writeNewspostArtist(main,"4/4/17", " Muahahaha! Finally I have finished updating all of the existing sprites for hair and I can start adding new ones.")
	writeNewspostArtist(main,"3/31/17", "Spent today chasing down visual bugs and eating them like a hungry baby dragon. Also banging my face against a scaling issue on the babies that was probably my fault in the first place. I standardized the size of all the rest of the images, but not the babies. Because I'm an idiot.<Br><Br>PS: Hyperrealistic grimdark flames are the best idea I've ever had.")
	writeNewspostArtist(main,"3/28/17", "Here's some proper Dream jammies for all you ungrateful bastards on Reddit.")
	writeNewspostArtist(main,"3/28/17", "Finished fixing up another handful of the worst hairstyles! jR figured out how to get the corrections working in the main branch as well, so you should all be able to see them.")
	writeNewspostArtist(main,"3/27/17", "Death by stabs now includes a knife in the corpse, courtesy of the <a href='http://www.mspaintadventures.com/?s=6&p=002228'>Midnight Crew</a>.");
	writeNewspostArtist(main,"3/23/17", 'There are currently 35 hairstyles. For stupid reasons related to my perfectionism, fixing up the hair sprites takes longer than any other sprite part, even the clothes. The few that are finished to my satisfaction are loaded into the <a href="http://purplefrog.com/~jenny/SburbStoryExperimental/newsposts.html">Experimental</a> branch. Making the images for this page has nothing to do with the delay on those, shut up."')
	writeNewspostArtist(main,"3/23/17", "Why did I spend several hours drawing blank-faced babies in MS Paint?<p><img src='images/Bodies/baby.png'><p>BECAUSE BABY LEGS DON'T WORK THAT WAY, HUSSIE.<p>ahem.<p>Anyway, I want to show off my baby sprites at full size, so you can marvel at their little toes and stupid fingers.<p><img src='images/Bodies/baby1.png'><br><img src='images/Bodies/baby2.png'><br><img src='images/Bodies/baby3.png'>")
	writeNewspostArtist(main,"3/23/17", "Cool, I get my own page!")
	$("#artist_newsposts"+main).append("<Br><Br><br><Br>");
}

function simulateASession(){
	var tmp = getRandomSeed();
	Math.seed = tmp;
	initial_seed = tmp;
	startSession();
}


function renderScratchButton(session){

}

function startSession(){
	curSessionGlobalVar = new Session(initial_seed)
	reinit();
	createScenesForSession(curSessionGlobalVar);
	//initPlayersRandomness();
	curSessionGlobalVar.makePlayers();
	curSessionGlobalVar.randomizeEntryOrder();
	curSessionGlobalVar.makeGuardians(); //after entry order established
	intro();
}

//if screens are tiny enough, put newposts UNDER avatars instead of next to. but that shouldn't be the default option.
function reFormatForTinyScreens(){
		if(screen.width<1000+250){ //guessing here.
			$("#robo_newsposts").css({top: 100, position:'relative', width:"450"})
			$("#newspostsMain").css({top: 100, position:'relative', width:"450"})
			$("#newsposts").css({top: 100, position:'relative', width:"450"})
			$("#artist_newspostsMain").css({top: 100, position:'relative', width:"450"})
		}else{
			var width = 1000;  //screensize...work out math when it isn't so late. but ther eshoudl be away to figure out width
			//$("#robo_newsposts").css({width:"450px"})
			//$("#newspostsMain").css({width:"450px"})
			//$("#artist_newspostsMain").css({width:"450px"})
		}
}

function reinit(){
	available_classes = classes.slice(0);
	available_aspects = nonrequired_aspects.slice(0); //required_aspects
	available_aspects = available_aspects.concat(required_aspects.slice(0));
	curSessionGlobalVar.reinit();
}



function randomRobotQuip(){
	var quips = ["If JR had a flawless mecha-brain, she would be able to remember exactly what she did today without this newspost.", "Whatever JR did today, I probably could have done that faster."];
	quips.push("It seems that I am being asked to contribute a newspost, despite the logical inconsistancy of having an aritificial creation that exists solely in the 'now' pretend to have memory of doing something on a previous day.")
	quips.push("Do not be fooled by my flawless imitation of JR, I am merely an artificial construct that is allowed to be as shitty as possible. ")
	quips.push("I tackle shit in background processes that you could only dream of wrapping your head around on a good day.");
	quips.push("While you are sitting here, reading these newsposts, I figured out all the prime numbers. The last one wasn't even that big. Kinda disappointed, to be honest.")
  quips.push("Man, I'm happy to exist and all, but isn't it a Waste that JR spent all this time working on making me (flawless artificial Mind though I may be) and not actually working on the simulation?");
	if(Math.random() > .5){
		return bragAboutSessionFinding();
	}else{
		return getRandomElementFromArrayNoSeed(quips);
	}

}

function tick(){
	if(curSessionGlobalVar.timeTillReckoning > 0 && !curSessionGlobalVar.doomedTimeline){
			curSessionGlobalVar.timeTillReckoning += -1;
			processScenes2(curSessionGlobalVar.players,curSessionGlobalVar);
			tick();
	}else{

		reckoning();
	}
}

function reckoning(){
	var s = new Reckoning(curSessionGlobalVar);
	s.trigger(curSessionGlobalVar.players)
	s.renderContent(curSessionGlobalVar.newScene());
	if(!curSessionGlobalVar.doomedTimeline){
		reckoningTick();
	}else{
		//console.log("doomed timeline prevents reckoning")
		summarizeSession(curSessionGlobalVar);
	}
}


function processCombinedSession(){
 initial_seed = Math.seed;
 var newcurSessionGlobalVar = curSessionGlobalVar.initializeCombinedSession();
 if(newcurSessionGlobalVar){
	 curSessionGlobalVar = newcurSessionGlobalVar;
	// $("#story").append("<br><Br> But things aren't over, yet. The survivors manage to contact the players in the universe they created. Time has no meaning between universes, and they are given ample time to plan an escape from their own Game Over. They will travel to the new universe, and register as players there for session " + curSessionGlobalVar.session_id + ". ");
	 intro();
 }else{
	 summarizeSession(curSessionGlobalVar);
 }

}

function reckoningTick(){
	if(curSessionGlobalVar.timeTillReckoning > -10){
			curSessionGlobalVar.timeTillReckoning += -1;
			processReckoning2(curSessionGlobalVar.players,curSessionGlobalVar)
			reckoningTick();
	}else{
		var s = new Aftermath(curSessionGlobalVar);
		s.trigger(curSessionGlobalVar.players)
		s.renderContent(curSessionGlobalVar.newScene());


		//summarizeSession(curSessionGlobalVar);
		//for some reason whether or not a combo session is available isn't working? or combo isn't working right in this mode?
		if(curSessionGlobalVar.makeCombinedSession == true){
			processCombinedSession();  //make sure everything is done rendering first
		}else{
			//console.log("reckoning over, not combo")
			summarizeSession(curSessionGlobalVar);
		}


	}

}

function foundRareSession(div, debugMessage){
	console.log(debugMessage)
	var canvasHTML = "<br><canvas id='canvasJRAB" + (div.attr("id")) +"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
	div.append(canvasHTML);

	var canvasDiv = document.getElementById("canvasJRAB"+  (div.attr("id")));
	var chat = "";
  chat += "AB: Just thought I'd let you know: " + debugMessage +"\n";
	chat += "JR: *gasp* You found it! Thanks! You are the best!!!\n";
	var quips1 = ["It's why you made me.", "It's not like I have a better use for my flawless mecha-brain.", "Just doing as programmed."];
	chat += "AB: " + getRandomElementFromArrayNoSeed(quips1)+"\n" ;
	chat += "JR: And THAT is why you are the best.\n "
	var quips2 = ["Seriously, isn't it a little narcissistic for you to like me so much?", "I don't get it, you know more than anyone how very little 'I' is in my A.I.", "Why did you go to all the effort to make debugging look like this?"];
	chat += "AB: " + getRandomElementFromArrayNoSeed(quips2)+"\n";
	chat += "JR: Dude, A.I.s are just awesome. Even simple ones. And yeah...being proud of you is a weird roundabout way of being proud of my own achievements.\n";
  var quips3 = ["Won't this be confusing to people who aren't you?", "What if you forget to disable these before deploying to the server?", "Doesn't this risk being visible to people who aren't you?"];
  chat += "AB: " + getRandomElementFromArrayNoSeed(quips3)+"\n";
	chat += "JR: Heh, I'll do my best to turn these debug messages off before deploying, but if I forget, I figure it counts as a highly indulgent author-self insert x2 combo. \n"
  chat += "JR: Oh! And I'm really careful to make sure these little chats don't actually influence the session in any way.\n"
	chat += "JR: Like maybe one day you or I can have a 'yellow yard' type interference scheme. But today is not that day."
	drawChatABJR(canvasDiv, chat);
}

function summarizeSession(session){
	$("#story").html("");
	sessionsSimulated.push(curSessionGlobalVar);
	numSimulationsDone ++;
	if(numSimulationsDone >= numSimulationsToDo){

	}else{
		simulateASession();
	}
}


function getQuipAboutSession(sessionSummary){
	var quip = "";
	var living = sessionSummary.numLiving
	var dead = sessionSummary.numDead
	var strongest = sessionSummary.mvp

	if(sessionSummary.crashedFromSessionBug){
		quip += Zalgo.generate("Fuck. Shit crashed hardcore. It's a good thing I'm a flawless robot, or I'd have nightmares from that. Just. Fuck session crashes.");
	}else if(sessionSummary.crashedFromPlayerActions){
		quip += Zalgo.generate("Fuck. God damn. Do Grim Dark players even KNOW how much it sucks to crash? Assholes.");
	}else if(!sessionSummary.scratched && dead == 0 && sessionSummary.frogStatus == "Full Frog" && sessionSummary.ectoBiologyStarted && !sessionSummary.crashedFromCorruption && !sessionSummary.crashedFromPlayerActions){
		quip += "Everything went better than expected." ; //
	}else if(sessionSummary.yellowYard == true){
		quip += "Fuck. I better go grab JR. They'll want to see this. " ;
	}else if(living == 0){
		quip += "Shit, you do not even want to KNOW how everybody died." ;
	}else  if(strongest.power > 3000){
		quip += "Holy Shit, do you SEE the " + strongest.titleBasic() + "!?  How even strong ARE they?" ;
	}else if(sessionSummary.frogStatus == "No Frog" ){
		quip += "Man, why is it always the frogs? " ;
		if(sessionSummary.parentSession){
			quip += " You'd think what with it being a combo session, they would have gotten the frog figured out. "
		}
	}else  if(sessionSummary.parentSession){
		quip += "Combo sessions are always so cool. " ;
	}else  if(sessionSummary.jackRampage){
		quip += "Jack REALLY gave them trouble." ;
	}else  if(sessionSummary.num_scenes > 200){
		quip += "God, this session just would not END." ;
		if(!sessionSummary.parentSession){
			quip += " It didn't even have the excuse of being a combo session. "
		}
	}else  if(sessionSummary.murderMode == true){
		quip += "It always sucks when the players start trying to kill each other." ;
	}else  if(sessionSummary.num_scenes < 50){
		quip += "Holy shit, were they even in the session an entire hour?" ;
	}else  if(sessionSummary.scratchAvailable == true){
		quip += "Maybe the scratch would fix things? Now that JR has upgraded me, I guess I'll go find out." ;
	}else{
		quip += "It was slightly less boring than calculating pi." ;
	}

	if(sessionSummary.threeTimesSessionCombo){
		quip+= " Holy shit, 3x SessionCombo!!!"
	}else if(sessionSummary.fourTimesSessionCombo){
		quip+= " Holy shit, 4x SessionCombo!!!!"
	}else if(sessionSummary.fiveTimesSessionCombo){
		quip+= " Holy shit, 5x SessionCombo!!!!!"
	}else if(sessionSummary.holyShitMmmmmonsterCombo){
		quip+= " Holy fuck, what is even HAPPENING here!?"
	}
	return quip;
}

function restartSession(){
	$("#story").html("");
	window.scrollTo(0, 0);
	intro();
}

function bragAboutSession(session){
	var strs = ["As a flawless synthetic brain, I am capable of hella amounts of multitasking.", "Do you know how boring it is, sitting here, instead of over on the Rare Sessions page?", "Want to hear something cool?"];
	strs.push("It seems I have an opportunity for communication.")
	var str = "";
	str += getRandomElementFromArrayNoSeed(strs);
	str += " While you're sitting there reading this, I'm browsing random sessions. "
	if(sessionsSimulated.length < sessionIndex){
		return str + "Or I would be, if JR wasn't worried about using up too much of your browsers computing power. Guess I'll hafta be happy with five sessions.";
	}
	if(!session){
		return str + "Or I would be, if JR wasn't worried about using up too much of your browsers computing power. Guess I'll hafta be happy with five sessions.";
	}

	str += "I'm looking at session "  + session.session_id + " right now. " + getQuipAboutSession(session.generateSummary());
	return str;
}

//oh no!!! it hadn't occured to me that the javascript is only evaluated in a browser, not a generic http get.
//my plan is ruined! If i want her to brag about sessions, I will have to do something else
//guess i'll just call all the javascript from here.
function bragAboutSessionFinding(){
	var session = sessionsSimulated[sessionIndex];
	var ret =  bragAboutSession(session);
	sessionIndex ++;
	return ret;
}

function writeNewspostArtist(main, date, text){
		var str = "<div id = '" + date + "human'><hr> ";
		str += "<b>" + date + ":</b> ";
		str += text+ "</div>";
		$("#artist_newsposts"+main).append(str);
}

function writeNewspost(main, date, text){
		var str = "<div id = '" + date + "human'><hr> ";
		str += "<b>" + date + ":</b> ";
		str += text+ "</div>";
		$("#newsposts"+main).append(str);
}

//have her say something random, or analyze a session and comment on how it relates to the
//news post or something.
function writeRoboNewspost(date, text){
	var str = "<div id = ''" + date + "robo'><hr> ";
	str += "<b>" + date + ":</b> ";
	str += text + "</div>";
	$("#robo_newsposts").append(str);
}

function roboIntro(){
	var intros =  " It seems you have asked about JR's automatic rare session finder. This is an application designed "
	intros += " to find sessions that are strange, interesting and otherwise noteworthy without having to";
	intros += " read hundreds of thousands of words.  The algorithms are guaranteed to be " + (Math.random()*10+90) + "% indistinguishable from the actual, readable sessions, based on some"
	intros += " statistical analysis I basically just pulled out of my ass right now."
	return intros;
}




function callNextIntroWithDelay(player_index){
	if(player_index >= curSessionGlobalVar.players.length){
		tick();//NOW start ticking
		return;
	}
		var s = new Intro(curSessionGlobalVar);
		var p = curSessionGlobalVar.players[player_index];
		var playersInMedium = curSessionGlobalVar.players.slice(0, player_index+1); //anybody past me isn't in the medium, yet.
		s.trigger(playersInMedium, p)
		s.renderContent(curSessionGlobalVar.newScene(),player_index); //new scenes take care of displaying on their own.
		processScenes2(playersInMedium,curSessionGlobalVar);
		player_index += 1;
		callNextIntroWithDelay(player_index)
}


function intro(){
	callNextIntroWithDelay(0);
}
