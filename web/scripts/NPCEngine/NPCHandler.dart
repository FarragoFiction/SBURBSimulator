import "../SBURBSim.dart";
import "dart:async";
import 'dart:html';
import '../includes/path_utils.dart';

//handles spawning and maintaining various npcs.
class NPCHandler
{
    Session session;
    //not parsed, but means i only need to do the async thing once.
    static List<String> bigBadsFromFile = new List<String>();

    List<GameEntity> allEntities = new List<GameEntity>();
    List<GameEntity> bigBads = new List<BigBad>();

    static String JACK = "JACK";
    static String PM = "PM"; //done
    static String JS = "JS"; //done
    static String EA = "EA";
    static String HP = "HP";
    static String YD = "YD";//done
    static String MD = "MD";
    static String CI = "CI";
    static String SI = "SI"; //done
    static String SU = "SU"; //done
    static String ME = "ME";
    static String RB = "RB"; //done
    static String GN = "GN"; //done
    static String AC = "AC";
    static String BE = "BE";
    static String MP = "MP";
    static String MK = "MK";
    static String AR = "AR"; //done
    static String PE = "PE"; //done
    static String DP = "DP"; //done
    static String ZC = "ZC";
    static String KB = "KB";
    static String WV = "WV";
    static String PS = "PS";
    static String PI = "PI";
    static String AD = "AD";
    static String HS = "HS";
    static String NB = "NB";
    static String SS = "SS";
    static String CD = "CD";
    static String HB = "HB"; //done
    static String DD = "DD";







    //some carapaces can be specific rewards
    Carapace jack;
    List<Carapace> prospitians = <Carapace>[];
    List<Carapace> dersites = <Carapace>[];


    NPCHandler(Session this.session) {
    }

    void debugNPCs() {
        for(GameEntity g in allEntities) {
            print("$g is active: ${g.active} and is dead: ${g.dead}  has ${g.sylladex.length} items.");
        }
    }

    Carapace getCarapaceWithHandle(String handle) {
        if(handle == JACK) return jack;

        for(GameEntity e in session.activatedNPCS) {
            if(e is Carapace && e.initials == handle) return e;
        }

        if(session.prospit != null){
            for(GameEntity e in session.prospit.associatedEntities) {
                if(e is Carapace && e.initials == handle) return e;
            }
        }

        if(session.derse != null){
            for(GameEntity e in session.derse.associatedEntities) {
                if(e is Carapace && e.initials == handle) return e;
            }
        }
        //couldn't find them. thems the breaks.
        return null;

    }

   void setupNpcs() {
        setupBigBads();
    }

    static Future<Null> loadBigBads() async {
        print("loading big bads");
        String data = await Loader.getResource("BigBadLists/bigBads.txt");
        bigBadsFromFile = data.split("\n");
    }

    void setupBigBads() {
        //print("setting up big bads from ${bigBadsFromFile.length} data strings");
        for(String line in bigBadsFromFile) {
            BigBad newBB = BigBad.fromDataString(line, session);
            //print("made a new BB ${newBB}");
            bigBads.add(newBB);
        }
    }

    //each npc has items in their sylladex, at least one of which is legendary
    //TODO each game entity optionally has text for what to say if they are doing
    //TODO DESTROY, CORRUPT, CONTROL or whatever
    //decides their quest rewards and what items MAIL QUESTS can choose from.

    //violent, lucky, charming, cunning
    List<Carapace> getMidnightCrew() {
        List<Carapace> midnightCrew = new List<Carapace>();

       // print ("TEST NPCS: initializing midnight crew");
        jack = (new Carapace("Jack Noir", session, Carapace.DERSE, firstNames: <String>["Spades","Septuple","Seven","Skullduggerous"], lastNames: <String>["Slick", "Shanks","Shankmaster","Snake"], ringFirstNames: <String>["Sovereign", "Seven"], ringLastNames: <String>["Slayer", "Shanks","Stabber"])
            ..specibus = new Specibus("Knife", ItemTraitFactory.KNIFE, <ItemTrait>[ ItemTraitFactory.JACKLY])
            ..distractions = <String>["is throwing a tantrum about how huge a bitch the Black Queen is.","is pretending to ride on a horse.","is so mad at paperwork.","is refusing to wear his uniform.","is stabbing some random carapace who said 'hello'.","is sharpening Occam's razor","is actually being a pretty good bureaucrat.","is hiding his scottie dogs candies."]
            ..sylladex.add(new Item("Occam's Razor",<ItemTrait>[ItemTraitFactory.BLADE, ItemTraitFactory.SMART]))
            ..sylladex.add(new Item("Horse Hitcher",<ItemTrait>[ItemTraitFactory.STICK, ItemTraitFactory.IRONICSHITTYFUNNY]))
            ..sylladex.add(new Item("Terrier Fancy Magazine",<ItemTrait>[ItemTraitFactory.ROMANTIC, ItemTraitFactory.PAPER]))
            ..description = "The Derse Archagent, Jack Noir is infamous for his love of scottie dogs, his hatred of the Black Queen and his omnicidal tendencies. He’s also a leader of the Midnight Crew - jazz band which can often be found in the “Liquid Negrocity” bar.  <br><Br>When he gets the ring his omnicidal tendencies are enabled."
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -500, Stats.MAX_LUCK: 10, Stats.SANITY: -100, Stats.HEALTH: 20, Stats.FREE_WILL: -100, Stats.POWER: 30})
            ..makeViolent(1000)
            ..makeCunning(1000)
            ..sylladex.add(new Item("Scottie Dogs",<ItemTrait>[ItemTraitFactory.CANDY]))

            ..active = true //jack needs to be on for every session
            ..royaltyOpinion = -1000
            ..scenes = <Scene>[new RedMiles(session), new BeDistracted(session),new PassOutRegiswords(session),  new SeekRing(session), new SeekScepter(session)] //order of scenes is order of priority
        );
        midnightCrew.add(jack);

        //he's lucky and cunning
        midnightCrew.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Cordial","Courtyard","Clubs","Curious", "Cheerful", "Cheery","Chipper","Clutzy","Chaotic"], lastNames: <String>["Deuce","Droll","Dabbler", "Demoman","Dwarf","Dunce"], ringFirstNames: <String>["Crowned","Capering","Chaotic","Collateral"], ringLastNames: <String>["Destroyer","Demigod"])
            ..specibus = new Specibus("Bomb", ItemTraitFactory.GRENADE, <ItemTrait>[ ItemTraitFactory.EXPLODEY])
            ..distractions = <String>["is flipping the fuck out about a bull penis cane. What?","is trading everybody's hats in the session.","is eating black licorice gummy bears.","is collecting just. So many bombs. You don't even know.","is stopping arguments between carapaces.","having a tea party with some nice consorts and underlings."]
            ..description = "One of the Dersite Agents, CD is an incompetent buffoon with a taste for big explosions. He’s really lucky, though. Perhaps that’s why he’s still good at being an agent. He sometimes playing jazz music at the Liquid Negrocity."
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session), new SeekRing(session), new SeekScepter(session), new GiveJackScepter(session), new GiveJackRing(session)] //order of scenes is order of priority
            ..sylladex.add(new Item("Licorice Gummy Bears",<ItemTrait>[ItemTraitFactory.CANDY]))
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: 500, Stats.MAX_LUCK: 500, Stats.SANITY: 100, Stats.HEALTH: 20, Stats.FREE_WILL: 100, Stats.POWER: 15})
            ..makeLucky(1000)
            ..sylladex.add(new Item("Black Inches Magazine",<ItemTrait>[ItemTraitFactory.ROMANTIC, ItemTraitFactory.PAPER]))
                        ..activationChance = 0.1
            ..sylladex.add(new Item("Bull Penis Cane",<ItemTrait>[ItemTraitFactory.STICK, ItemTraitFactory.GROSSOUT]))
            ..sylladex.add(new Item("Regisword",<ItemTrait>[ItemTraitFactory.BLADE, ItemTraitFactory.LEGENDARY, ItemTraitFactory.EDGED, ItemTraitFactory.POINTY]))
            ..makeCunning(1000)
        );

        midnightCrew.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Diamonds","Draconian","Dignified"], lastNames: <String>["Droog","Dignitary","Diplomat"], ringFirstNames: <String>["Dashing","Dartabout","Derelict"], ringLastNames: <String>["Destroyer","Demigod"])
            ..specibus = new Specibus("Knife", ItemTraitFactory.KNIFE, <ItemTrait>[ ItemTraitFactory.EDGED, ItemTraitFactory.CLASSY])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session), new SeekRing(session), new GiveJackScepter(session), new GiveJackRing(session)] //order of scenes is order of priority
            ..distractions = <String>["is playing classy records. ","is reading the paper. ","is fantasizing about perfectly tailored suits.", "is hiding his swedish fish.","is reading 'classy literature' about grey ladies.","is keeping everyone calm and productive."]
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: 0, Stats.MAX_LUCK: 100, Stats.SANITY: 500, Stats.HEALTH: 20, Stats.FREE_WILL: 0, Stats.POWER: 20})
            ..makeCharming(1000)
            ..makeCunning(1000)
                        ..activationChance = 0.1

            ..description = "The most competent of the Midnight Crew, DD is the most classy gentlemen you will meet in your life. Unless you catch him with his gray ladies journal. Oh, and DD is probably the one you should talk to if you want to get rid of a troublesome...entity discreetly.Unless he’s Crowned. In this case, you are already fucked."
            ..sylladex.add(new Item("Swedish Fish",<ItemTrait>[ItemTraitFactory.CANDY]))
            ..sylladex.add(new Item("Grey Ladies Newspaper",<ItemTrait>[ItemTraitFactory.ROMANTIC, ItemTraitFactory.PAPER]))
            ..sylladex.add(new Item("Finely Tailored Suit",<ItemTrait>[ItemTraitFactory.CLOTH, ItemTraitFactory.CLASSY]))
            ..sylladex.add(new Item("Regisword",<ItemTrait>[ItemTraitFactory.BLADE, ItemTraitFactory.LEGENDARY, ItemTraitFactory.EDGED, ItemTraitFactory.POINTY]))

            ..sideLoyalty = 1000
        );

        midnightCrew.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Hearts","Hegemonic","Horse","Heavy","Handsome"], lastNames: <String>["Brute","Boxcar","Bartender","Brawler","Beefcake"], ringFirstNames: <String>["Herokilling","Hateful"], ringLastNames: <String>["Beast","Bastard"])
            ..specibus = new Specibus("Fist", ItemTraitFactory.FIST, <ItemTrait>[ ItemTraitFactory.BLUNT])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session), new SeekRing(session), new SeekScepter(session), new GiveJackScepter(session), new GiveJackRing(session)] //order of scenes is order of priority
            ..distractions = <String>["is shipping just. All the things.","is reading RED CHEEKS magazine.","is protecting his wax lips candies. ","is updating his shipping grid.","is trying to get his OTP together already.","is demanding that this chump just KISS THE GIRL THIS INSTANT."]
            ..sylladex.add(new Item("Wax Lips",<ItemTrait>[ItemTraitFactory.CANDY]))
            ..sylladex.add(new Item("Red Cheeks Magazine",<ItemTrait>[ItemTraitFactory.PAPER, ItemTraitFactory.ROMANTIC]))
            ..description = "A simple carapacian of simple pleasures, HB is one of the strongest melee combatants one can encounter. He’s strong enough to punch through a safe door. That doesn’t mean he doesn’t have a softer side - he’s authored a few romantic novels as HB."
            ..sylladex.add(new Item("Regisword",<ItemTrait>[ItemTraitFactory.BLADE, ItemTraitFactory.LEGENDARY, ItemTraitFactory.EDGED, ItemTraitFactory.POINTY]))
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: 0, Stats.MAX_LUCK: 0, Stats.SANITY: 0, Stats.HEALTH: 500, Stats.FREE_WILL: 0, Stats.POWER: 500})
            ..makeViolent(1000)
            ..activationChance = 0.1
            ..makeCharming(1000)
        );

        /*
        midnightCrew.add(new Carapace(null, session, firstNames: <String>[], lastNames: <String>[], ringFirstNames: <String>[], ringLastNames: <String>[])
        ..specibus = new Specibus("Knife", ItemTraitFactory.KNIFE, [ ItemTraitFactory.JACKLY])
        ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -500, Stats.MAX_LUCK: 10, Stats.SANITY: -100, Stats.HEALTH: 20, Stats.FREE_WILL: -100, Stats.POWER: 30})
        );
         */
        return midnightCrew;

    }

    //violent, lucky, charming, cunning
    List<Carapace> getSunshineTeam() {

        List<Carapace> sunshineTeam = new List<Carapace>();

        sunshineTeam.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Parchment","Pedant","Problem","Paramount","Patriotic"], lastNames: <String>["Sleuth","Secretary","Steward"], ringFirstNames: <String>["Paragon","Promised"], ringLastNames: <String>["Sherrif","Savior","Seraph"])
            ..specibus = new Specibus("Tommy gun", ItemTraitFactory.MACHINEGUN, <ItemTrait>[ ItemTraitFactory.SHOOTY])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session), new SeekRing(session), new SeekScepter(session)] //order of scenes is order of priority
            ..distractions = <String>["is reading the gamefaqs for this section of his quest.","is brokering a peace treaty between the clowns, elves and pigs. This has NOTHING to do with SBURB.","is engaging SEPULCHRITU...wait no, never mind. False alarm."]
            ..royaltyOpinion = 10
            ..description = "One of the top agents on Prospit, with numerous solicitations for services. Compensation is surprisingly adequate. "
            ..sideLoyalty = 10
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -100, Stats.MAX_LUCK: 100, Stats.SANITY: -100, Stats.HEALTH: 20, Stats.FREE_WILL: 200, Stats.POWER: 15})
            ..makeCharming(1000)
            ..sylladex.add(new Item("Candy Corn",<ItemTrait>[ItemTraitFactory.CANDY]))
            ..sylladex.add(new Item("Diversity Mural",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.PRETTY]))
            ..companionChance = 0.1

            ..bureaucraticBullshit = <String>["needs to get their private eye license renewed.","needs to pay off all those mural loans he took out.","has to get this treaty properly ratified."]
            ..makeLucky(1000)
        );

        sunshineTeam.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Persistent","Pickle","Persnickety"], lastNames: <String>["Inspector","Innovator","Investegator"], ringFirstNames: <String>["Patient","Peaceful"], ringLastNames: <String>["Idol"])
            ..specibus = new Specibus("Handgun", ItemTraitFactory.PISTOL, <ItemTrait>[ ItemTraitFactory.SHOOTY])
            ..distractions = <String>["is oogling various things. It makes them uncomfortable.","is looking at HUNK RUMP magazine.","is using his high IMAGINATION stat to go on useless adventures.","is fondly regarding creation."]
            ..sideLoyalty = 10
            ..description = "A Prospitian Agent with a disconcerting oggle. There is a small sub-cult on Prospit that worships his high Imagination stat instead of The Genesis Frog, and he finds it to be off-putting."
            ..sylladex.add(new Item("Tootsie Roll",<ItemTrait>[ItemTraitFactory.CANDY]))
            ..sylladex.add(new Item("Imaginary Fort",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.FAKE, ItemTraitFactory.PLYWOOD]))
            ..companionChance = 0.1

            ..bureaucraticBullshit = <String>["has to pay this fine for public oogling.","needs a permit to fondly regard creation.","has a ticket for excess imagination usage this month."]
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session), new SeekRing(session), new SeekScepter(session)] //order of scenes is order of priority
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -100, Stats.MAX_LUCK: 100, Stats.SANITY: 100, Stats.HEALTH: 1, Stats.FREE_WILL: 500, Stats.POWER: 1})
            ..makeCharming(1000)
            ..makeCunning(1000)
        );

        sunshineTeam.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Ace","Audacious","Asshole"], lastNames: <String>["Detective","Dwarf","Dick"], ringFirstNames: <String>["Ascended"], ringLastNames: <String>["Demon","Destroyer"])
            ..specibus = new Specibus("Fist", ItemTraitFactory.FIST, <ItemTrait>[ ItemTraitFactory.BLUNT])
            ..distractions = <String>["is punching various things in the snoot to establish dominance.","is brewing the worlds most perfect hot sauce.","is wearing a wig. You assume he's undercover or something?"]
            ..royaltyOpinion = -10
            ..companionChance = 0.1
            ..description = "A Prospitian Agent with famously shitty imagination. He doesn't even have a female counterpart, as  a result. He is AMAZING at establishing dominance and brewing hot sauce, though. "
            ..sylladex.add(new Item("Gummy Worm",<ItemTrait>[ItemTraitFactory.CANDY]))
            ..sylladex.add(new Item("5 Alarm Hot Sauce",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.ONFIRE]))
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session), new SeekRing(session), new SeekScepter(session)] //order of scenes is order of priority
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: 0, Stats.MAX_LUCK: 0, Stats.SANITY: -500, Stats.HEALTH: 100, Stats.FREE_WILL: 100, Stats.POWER: 100})
            ..makeViolent(1000)
            ..bureaucraticBullshit = <String>["has to pay this fine for public fiestaing.","has to post bail for public rowdyness."]
            ..makeLucky(1000)
        );

        sunshineTeam.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Hysterical","Haunting","Honored"], lastNames: <String>["Dame","Dancer","Debutante"], ringFirstNames: <String>["Hazardous"], ringLastNames: <String>["Demoness"])
            ..specibus = new Specibus("Lipstick Chainsaw", ItemTraitFactory.CHAINSAW, <ItemTrait>[ ItemTraitFactory.EDGED])
            ..distractions = <String>["is threatening everyone around her with a chainsaw.","is completely hysterical.","is making friends with women of ill repute."]
            ..sideLoyalty = 10
            ..description = "A Prospitian Dame who excels at making friends in the most unlikely of situations. Her Hysteria Meter is a formidable attack, though indescriminate in nature."
            ..sylladex.add(new Item("Scale Bodice",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.PRETTY]))
            ..sylladex.add(new Item("Tommy Gun",<ItemTrait>[ItemTraitFactory.MACHINEGUN, ItemTraitFactory.SHOOTY]))
            ..companionChance = 0.1
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session), new SeekRing(session), new SeekScepter(session)] //order of scenes is order of priority
            ..bureaucraticBullshit = <String>["has to pay this fine for public hysteria.","needs a permit to open up a fine establishment for her new friends.","has to pay a fine for all this public damage."]

            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: 500, Stats.MAX_LUCK: 500, Stats.SANITY: 100, Stats.HEALTH: 20, Stats.FREE_WILL: 100, Stats.POWER: 15})
            ..makeCharming(1000)
            ..makeViolent(1000)
        );

        sunshineTeam.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Nervous","Naive","Nice"], lastNames: <String>["Broad","Bird","Bartender"], ringFirstNames: <String>["Notorious","Neverending"], ringLastNames: <String>["Bard","Bloodshed"])
            ..specibus = new Specibus("Flamethrower", ItemTraitFactory.PISTOL, <ItemTrait>[ ItemTraitFactory.ONFIRE])
            ..distractions = <String>["is very nervous.","is having a nervous breakdown.","is trying to figure out the difference between a teddy bear and a knife."]
            ..sideLoyalty = 10
            ..sylladex.add(new Item("Teddy Bear",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.ROBOTIC2]))
            ..description = "A Prospitian broad with a famously low Mangrit stat, which is only as low as her Nervousness threshold. Its anybodies guess why the White Queen allows her to go out in public armed with a flamethrower."
            ..sylladex.add(new Item("Paint Stripper",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.ONFIRE]))
            ..companionChance = 0.1

            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session), new SeekRing(session), new SeekScepter(session)] //order of scenes is order of priority
            ..bureaucraticBullshit = <String>["needs a permit for public fainting.","is trying to help out CI with getting an invention permit. "]

            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: 0, Stats.MAX_LUCK: 0, Stats.SANITY: -500, Stats.HEALTH: 1, Stats.FREE_WILL: 100, Stats.POWER: 1})
            ..makeViolent(1000)
            ..makeCunning(1000)
        );

        return sunshineTeam;

    }

    //violent, lucky, charming, cunning
    List<Carapace> getDersites() {

        dersites = new List<Carapace>();
        dersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Agitated","Authority","Aimless","Authoritarian"], lastNames: <String>["Regulator","Renegade","Radical","Rifleer"], ringFirstNames: <String>["Ascendant"], ringLastNames: <String>["Rioter"])
            ..specibus = new Specibus("Machine Gun", ItemTraitFactory.MACHINEGUN, <ItemTrait>[ ItemTraitFactory.SHOOTY])
            ..sideLoyalty = 20
            ..sylladex.add(new Item("Alarming Pile of Guns and Ammunition",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.SHOOTY]))
            ..description = "He’s just another Dersite who disperse tickets. He hates crimes and will throw the criminals in the slammer. He calls it the slammer when he is extra angry. "
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..bureaucraticBullshit = <String>["needs to stock back up on tickets to give people.","has brought in some roughnecks to be sent to the slammer.","needs an updated list of everything that became illegal in the past day."]
            ..distractions = <String>["flipping the fuck out about how illegal everything is.","being extra angry at crimes.","designing slammers to throw things into. You call it the slammer when you are extra angry at crimes."]
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeViolent(100)
            ..makeLucky(100)
        );

        dersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Wayward","Wizardly","Warweary","Wandering"], lastNames: <String>["Vagrant","Villain","Vassal","Villager"], ringFirstNames: <String>["Wicked"], ringLastNames: <String>["Villian"])
            ..specibus = new Specibus("Sword", ItemTraitFactory.SWORD, <ItemTrait>[ ItemTraitFactory.EDGED, ItemTraitFactory.METAL])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session), new SeekScepter(session)] //order of scenes is order of priority
            ..royaltyOpinion = -1000
            ..description = "Not just another carapacian you can meet on the Battlefield. A rogue Dersite pawn, WV wants democracy - or, at the very least, lack of all-destroying monarchy, and is willing to put the work in to get it."
            ..sylladex.add(new Item("Firefly in Amber",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.SENTIENT]))

            ..distractions = <String>[" WV is distracted eating green objects rather than recruiting for his army. "," WV is distracted planning the civil infrastructure of a city, rather than recruiting for his army."," WV is distracted fantasizing about how great of a mayor he will be. "," WV accidentally tried to recruit carapacians already part of his army. Stupid stupid stupid! "," WV gets distracted freaking out about car safety. "," WV gets distracted freaking out about how evil bad bad bad bad monarchy is. "," WV gets distracted writing a constitution for the new democracy. "]
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCharming(100)
            ..makeLucky(100)
        );

        dersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Jazz","Jazzed","Jazzy"], lastNames: <String>["Singer","Songstress","Savant"], ringFirstNames: <String>["Jilted"], ringLastNames: <String>["Seductress"])
            ..specibus = new Specibus("Microphone", ItemTraitFactory.CLUB, <ItemTrait>[ ItemTraitFactory.LOUD, ItemTraitFactory.ZAP])
            ..bureaucraticBullshit = <String>["needs to renew her liquor license.","wants a permit for a public performance.","needs to pay a fine for singing a song with banned words."]
            ..sylladex.add(new Item("Classy Stockings",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.CLASSY]))
            ..description = "A slightly promiscuous Dersite carapacian, JS is performing at the Liquid Negrocity when the Midnight Crew is not there. She’s...an interesting carapace."
            ..distractions = <String>["is singing a sultry tune.","is writing down some new lyrics for her work in progress song.","is flirting with a random carapace."]
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCharming(100)
            ..makeCunning(100)
        );

        dersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Zipping","Zany","Zephyr"], lastNames: <String>["Coach","Coaster","Coder"], ringFirstNames: <String>["Zero"], ringLastNames: <String>["Casualties"])
            ..specibus = new Specibus("Sword", ItemTraitFactory.SWORD, <ItemTrait>[ ItemTraitFactory.EDGED, ItemTraitFactory.METAL])
            ..sylladex.add(new Item("Postal Code Map",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.PAPER]))
            ..description = "ZC LOVES the mail, not because of letters and packages (how boring), but because of how elegantly designed Derse's Zip Code Map is. You can find anything so quickly, so easily! How did a goverment famous for Red Tap make something so fast?"
            ..scenes = <Scene>[new MailSideQuest(session), new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is so excited about postal codes!","is telling anyone in earshot about the sheer perfection of the modern postal code!","is zipping around simulating delivering packages in order to train for the real deal."]
            ..bureaucraticBullshit = <String>["needs to pay off this speeding ticket.","needs to deliver a package that's in impound.","needs a copy of the most up to date postal code map."]
            ..stats.setMap(<Stat, num>{Stats.MOBILITY: 500, Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeLucky(100)
            ..makeCharming(100)
        );

        //DP	Philosophy	Deep Philosopher,Drunk Philanthropist, Dance Practitioner	Doom Prophet	Prospit
        dersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Deep","Drunk","Dance","Delusory"], lastNames: <String>["Philanthropist","Practitioner","Philosopher","Pundit"], ringFirstNames: <String>["Doom"], ringLastNames: <String>["Prophet"])
            ..specibus = new Specibus("Tome", ItemTraitFactory.BOOK, <ItemTrait>[ ItemTraitFactory.PAPER])
            ..distractions = <String>["is telling everyone that the End is Nigh. Everyone ignores him because this is obviously true.","is ranting about various Philosophical topics that no one actually cares about.","has just given up on everything, for a while.", "is drunk off his ass."]
            ..sideLoyalty = 10
            ..sylladex.add(new Item("Prophetic Sign",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.DOOMED]))
            ..bureaucraticBullshit = <String>["would like a public protest permit.","wants to tell those in authority about how the End is Nigh.","has to pay a fine for public drunkeness."]
            ..description = "Most of the time, he’s a drunkard who rambles about the incoming apocalypse. He’s also a philosopher of great wisdom. You can learn something from him, maybe."
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeViolent(100)
            ..makeCunning(100)
        );

        //MD	Medicine	Medical Deputy, Morbid Doctor	Malpracticeing Despot	Derse
        dersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Morbid","Malicious","Medical"], lastNames: <String>["Doctor","Deputy","Dentist"], ringFirstNames: <String>["Malpracticing"], ringLastNames: <String>["Despot"])
            ..specibus = new Specibus("Scalpel", ItemTraitFactory.BLADE, <ItemTrait>[ ItemTraitFactory.EDGED, ItemTraitFactory.METAL, ItemTraitFactory.POINTY])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is getting some much needed rest in between shifts.","is probably forging those insurance documents.","is accepting money under the operating table."]
            ..sideLoyalty = -10
            ..description = "She knows how to fix your arm, sew your wounds and how to preserve your corpse. She is good at taxidermy. MD is your friend. Sometimes. When she’s not killing you via malpractice."
            ..sylladex.add(new Item("Bloody Scalpel",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.BLADE]))
            ..bureaucraticBullshit = <String>["is getting sued for malpractice.","needs to refile her permits for all those taxidermied corpses he keeps.","has to renew her 'medical license'. "]
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeViolent(100)
            ..makeCunning(100)
        );

        //SI	Invention/Gaslamp	Silicon Introvert, Sparky Inventress, Saddened Illuminator 	"Silent InversionDerse
        dersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Silicon","Sparky","Saddened"], lastNames: <String>["Illuminator","Inventress","Introvert"], ringFirstNames: <String>["Silent"], ringLastNames: <String>["Inversion"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is scribbling blueprints for a bronze automaton powered by Aether.","is cosplaying various gaslamp fantasy outfits.","has passed out after spending way too long up inventing things."]
            ..sylladex.add(new Item("Glowing Crysal",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.FAE]))
            ..description = "An introverted lamplighter, SI knows how to make gas lamps, lightbulbs and automatons powered by light itself.  She is quite fond of her work, and will gladly explain how illumination on Derse works."
            ..specibus = new Specibus("Spark Rifle", ItemTraitFactory.RIFLE, <ItemTrait>[ ItemTraitFactory.ZAP, ItemTraitFactory.SHOOTY, ItemTraitFactory.POINTY])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: -500, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCunning(100)
            ..bureaucraticBullshit = <String>["needs a permit for all her inventions.","has to pay a fine after one of her Automatons went wild.","wants the Archagent to see her new cosplay."]

            ..makeCharming(100)
        );

        //ME	renegade	meticulous Engineer, machiavillian Egoist, miles edgeworth	Mass Effect (and his robot girlfriend)	Derse
        dersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Meticulous","Miles","Maverick","Mass"], lastNames: <String>["Edgeworth","Egoist","Engineer","Edge","Effect"], ringFirstNames: <String>["Mass"], ringLastNames: <String>["Effect"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is memeing at something.","is being a renegade of some sort.","is choosing between two ridiculously polarized options."]
            ..specibus = new Specibus("Rifle", ItemTraitFactory.RIFLE, <ItemTrait>[ ItemTraitFactory.SHOOTY])
            ..sylladex.add(new Item("Model Spaceship",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.SMART]))

            ..sideLoyalty = -100
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeViolent(100)
            ..bureaucraticBullshit = <String>["has to pay a fine after spray painting 'N7' on the Royal Palace.","has to pay a fine after doing sweet BIKE STUNTS off the chain between Derse and it's moon.","has to post bail after punching all those kittens."]
            ..description = "Nobody knows who ME actually is. His graffiti, however, is quite easy to discern - it always includes “N7” symbols. And he often does wacky and morally questionable shit for fun."
            ..makeCharming(100)
        );

        //GN	duckking says: Gastronomical Nourisher, Cooking	garrulous Nutritionist, gourmet Noodle, gourmand Nibbler,	Gluttonous Newt	Derse
        dersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Gooby","Garrulous","Gourmet","Gourmand","Gastronomical"], lastNames: <String>["Nutritionist","Noodle","Nibbler","Nourisher"], ringFirstNames: <String>["Gluttonous"], ringLastNames: <String>["Newt"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is eating a shit ton of food.","is cooking, and then eating, a shit ton of food.","has further perfected her noodle recipe."]
            ..specibus = new Specibus("Salad Fork", ItemTraitFactory.FORK, <ItemTrait>[ ItemTraitFactory.POINTY, ItemTraitFactory.METAL])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCharming(100)
            ..sylladex.add(new Item("Cookbook",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.BOOK]))
            ..description = "The Derse Royal Chef is a busy gentlewoman and a staunch nutritionist. She keeps the Royal Household healthy and well fed."
            ..makeViolent(100)
            ..bureaucraticBullshit = <String>["needs a permit for a huge banquet in the Queen's honor.","wants to make sure the Archagent is eating right."]

            ..sideLoyalty = -10

        );
        //BE	Bugs	Bug Entomologist, Beetle Enthusiast, Butterfly Enquirer	Brigand Engineer	Derse
        dersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Beetle","Butterfly","Bug"], lastNames: <String>["Enthusiast","Entomologist","Enquirer"], ringFirstNames: <String>["Brigand"], ringLastNames: <String>["Eclectica"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is flipping the fuck out about how great bugs are!","thinks they just saw a rare beetle.","is tending to her butterflies."]
            ..specibus = new Specibus("Butterfly Net", ItemTraitFactory.STICK, <ItemTrait>[ ItemTraitFactory.WOOD, ItemTraitFactory.RESTRAINING])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCharming(100)
            ..sylladex.add(new Item("Butterfly Collection",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.FAE]))
            ..description = "BE loves bugs, all bugs. Fluttering butterflies, iridescent beetles, scurrying bugs. They are all equally loved by Derse's foremost Entomologist.  "
            ..makeLucky(100)
            ..bureaucraticBullshit = <String>["has to pay a fine after letting that swarm of locusts out into the royal [REDACTED] gardens.","wants a permit to store more fireflies."]

        );
        //EA	HorrorTerrors	Eldritch Acolyte, Eccentric Advocate, Eclectic Alien	Efflorant Atronach	Derse
        dersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Eldritch","Eccentric","Eclectic"], lastNames: <String>["Acolyte","Alien","Advocate"], ringFirstNames: <String>["Efflorant"], ringLastNames: <String>["Atronach"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session), new SeekRing(session), new SeekScepter(session)] //order of scenes is order of priority
            ..distractions = <String>["is worshiping the horror terrors.","is thinking about ways to make free-to-play games even more evil.","is doing the work of the Elder Gods.", "is....not acting like a normal carapace."]
            ..specibus = new Specibus("Grimoire", ItemTraitFactory.BOOK, <ItemTrait>[ ItemTraitFactory.PAPER, ItemTraitFactory.CORRUPT, ItemTraitFactory.MAGICAL])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: -500, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeViolent(100)
            ..sylladex.add(new Item("Shrieking Grimoire",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.CORRUPT]))
            ..description = "Uh. Nothing to see here. <span class = 'void'>${Zalgo.generate("THE PUPPET HOLDS THE KEY TO OUR POWER.")}</span>"
            ..makeCunning(100)
            ..bureaucraticBullshit = <String>["is paying a nominal fee for breaking the law rather than having any real consequences.","would like to tell the Archagent about the Will of the Elder Gods.","got busted for using Magicks, which have been declared 'fake as fuck' by Royal Decree."]
            ..sideLoyalty = 1000
        );
        dersites.addAll(getMidnightCrew());
        return dersites;

    }

    //violent, lucky, charming, cunning
    List<Carapace> getProspitians() {
        //TODO give carapaces crownScene which is  a scene that becomes high priority if they are crowned
        prospitians = new List<Carapace>();

        prospitians.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Royal","Regal","Rolling"], lastNames: <String>["Baker","Breakmaker","Breadmaker"], ringFirstNames: <String>["Rampaging"], ringLastNames: <String>["Butcher"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is angsting about how hard HOLY PASTRIES are to get right.","is pre-making a shit ton of dough to use later.","is cleaning out the ROYAL OVENS. Wow, that's a lot of work!"]
            ..specibus = new Specibus("Rolling Pin", ItemTraitFactory.ROLLINGPIN, <ItemTrait>[ ItemTraitFactory.BLUNT, ItemTraitFactory.WOOD])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..bureaucraticBullshit = <String>["needs to pay a fine after that debacle with the Pastries of Love.","is dropping off a cake topped with Scottie Dogs."]
            ..makeCharming(100)
            ..sylladex.add(new Item("Holy Pastry",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.EDIBLE, ItemTraitFactory.MAGICAL]))
            ..description = "A skilled baker, RB is skilled at making HOLY PASTRIES. Some of them are magical. RB can teach you to make the pastries, too."
            ..makeLucky(100)
            ..royaltyOpinion = 1000
        );

        prospitians.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Parcel","Perigrine","Postal","Prospitian"], lastNames: <String>["Mistress","Mendicate","Mailer", "Maillady"], ringFirstNames: <String>["Punititve","Prospitian"], ringLastNames: <String>["Marauder","Monarch"])
            ..scenes = <Scene>[new MailSideQuest(session),new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is flipping the fuck out about how great the MAIL is.","is delivering packages to unimportant carapaces.","is just sort of generally being a badass."]
            ..specibus = new Specibus("Sword", ItemTraitFactory.SWORD, <ItemTrait>[ ItemTraitFactory.EDGED, ItemTraitFactory.METAL])
            ..stats.setMap(<Stat, num>{Stats.MOBILITY: 500,Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCharming(100)
            ..bureaucraticBullshit = <String>["needs to pick up a package that's in lockup.","has to deliver a small package to the Archagrent.","wants to pick up some mail to deliver."]
            ..sylladex.add(new Item("Mail Cap",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.CLOTH]))
            ..description = "Liberty. Reason. Justice. Civility. Edification. Perfection. MAIL. PM loves the MAIL. The MAIL is her job and her hobby. She might even let you help out."
            ..makeLucky(100)
            ..sideLoyalty = 10
            ..royaltyOpinion = 10
        );

        Fraymotif f = new Fraymotif("Sincere Pep Talk", 3);
        f.effects.add(new FraymotifEffect(Stats.SANITY, FraymotifEffect.ALLIES, true));
        f.effects.add(new FraymotifEffect(Stats.SANITY, FraymotifEffect.ALLIES, false));

        f.desc = " KB explains that you're a good person. ";
        //So a fraymotif might be "Sincere Pep Talk" and a specibus might be "Friendship Bracelet" or something?
        prospitians.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Kid","Kind","Keen","Knave"], lastNames: <String>["Boi"], ringFirstNames: <String>["Knight"], ringLastNames: <String>["Boi"])
            ..scenes = <Scene>[new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is being the very best, like no one ever was.","is explaining the rules to Captchacardmons.","is showing everyone his fanfictions."]
            ..specibus = new Specibus("Friendship Bracelet", ItemTraitFactory.STICK, <ItemTrait>[ ItemTraitFactory.CLOTH, ItemTraitFactory.ASPECTAL])
            ..fraymotifs.add(f)
            ..companionChance = 0.95 //almost guaranteed to follow you
            ..sylladex.add(new Item("Catpchacardmon Ball",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.SENTIENT]))
            ..description = "KB loves playing captchacardmons, and wants to help you be the very best, the best there ever was! He’ll gladly accompany you anywhere you go."
            ..bureaucraticBullshit = <String>["wants to update their captchacardmon license."]

        //kid boi is too good and pure to go crazy
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 999999, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCharming(100)
            ..makeLucky(100)
        );

        //PE	Education/Magic	"Persevering Educator,Persistent Entertainer,Punctual Executant"	Purple Executioner	Prospit
        prospitians.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Persevering","Punctual","Persistent"], lastNames: <String>["Entertainer","Executant","Educator","Enchanter"], ringFirstNames: <String>["Purple"], ringLastNames: <String>["Executioner"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is teaching everyone who will listen the rules of Magic, which is a totally real thing.","is performing stage magic for a crowd.","is teaching simple magic to onlookers."]
            ..sideLoyalty = 10
            ..bureaucraticBullshit = <String>["wants to get a permit to put on a magic show.","needs to pay a fine for a public disturbance claiming magic was real.","needs to update their magic license."]
            ..sylladex.add(new Item("Magical Textbook",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.MAGICAL, ItemTraitFactory.BOOK]))
            ..description = "An amateur magician, they’re already good at stage tricks. Totally offering lessons in stage trickery. Totally willing to accompany you on your journeys."
            ..specibus = new Specibus("Magic Wand", ItemTraitFactory.STICK, <ItemTrait>[ ItemTraitFactory.BLUNT, ItemTraitFactory.WOOD])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCharming(100)
            ..makeCunning(100)
        );
        //duckking is helping out with names, just like wigglersim
        prospitians.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Mobster","Monster","Maestro", "Mafia"], lastNames: <String>["Kingpin","Killer","Kilo", "Kaiser"], ringFirstNames: <String>["Master"], ringLastNames: <String>["Kriminal"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session), new SeekRing(session), new SeekScepter(session)] //order of scenes is order of priority
            ..distractions = <String>["is eating a shit ton of sugar.","is just sort of generally being a dick.","is really emotionally invested in this game of Life being played."]
            ..sideLoyalty = -1000
            ..sylladex.add(new Item("Romance Novel",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.ROMANTIC, ItemTraitFactory.BOOK]))
            ..description = "The crime lord of Prospit. Skilled at crime. Cheater. Used to have diabetes. Stay away from him. Or challenge him to a game of Life."
            ..bureaucraticBullshit = <String>["wants to file a 'legitimate business' license.","wants to talk shop.","wants a license to practice 'legitimate business'."]
            ..specibus = new Specibus("Brass Knuckles", ItemTraitFactory.FIST, <ItemTrait>[ ItemTraitFactory.BLUNT, ItemTraitFactory.METAL])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 500})
            ..makeViolent(500)
            ..makeCunning(500)
        );

        //MP	Art	MS. Paint, Magestic Painter, Mirthful Painter	Massacre Primer	Prospit
        prospitians.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Mirthful","Majestic","Mrs.","Miss","Ms."], lastNames: <String>["Paper","Paint","Painter"], ringFirstNames: <String>["Massacre"], ringLastNames: <String>["Primer"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is painting a mural.","is helping to care for a sick carapace.","is carrying a lewd object filled with a colorful substance. Get your mind out of the gutter, it's just paint!"]
            ..specibus = new Specibus("Paintbrush", ItemTraitFactory.STICK, <ItemTrait>[ ItemTraitFactory.BLUNT, ItemTraitFactory.WOOD])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCharming(100)
            ..sylladex.add(new Item("Lewd Object",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.METAL])) //its' a bucket
            ..sideLoyalty = 10
            ..bureaucraticBullshit = <String>["wants to file paperwork to get reimbursed for a community mural she painted.","needs to file an extension for a mural she's painting.","has to get a permit to order more lewd objects filled with paint."]
            ..description = "A cutesy Prospitian with an affinity for art, she loves painting things. She is also one of the most compassionate persons on Prospit. "
            ..makeLucky(100)
        );
        //HP	Holy	Holy Preacher,Happy Painter, High Pediatrician	Hallowed Patrician	Prospit
        prospitians.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Holy","Happy","High"], lastNames: <String>["Preacher","Pediatrician","Priest","Pope"], ringFirstNames: <String>["Hallowed"], ringLastNames: <String>["Patrician"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is expounding on the virutes of the Vast Croak to any who would listen.","is meditating on how to be more Frog-like.","is performing an acapello song of croaks."]
            ..specibus = new Specibus("Religious Text", ItemTraitFactory.BOOK, <ItemTrait>[ ItemTraitFactory.PAPER, ItemTraitFactory.MAGICAL])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCharming(100)
            ..sylladex.add(new Item("Crystaline Frog",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.GLOWING]))
            ..description = "He knows the End is Nigh and preaches acceptance, nay ANTICIPATION, of this joyous event. The Vast Croak will purify the world in the fires of creation, and build it anew in the Players image. "
            ..bureaucraticBullshit = <String>["needs a license to preach.","would like to get a permit for limited amphibian iconography to spread the word of the Vast Croak.","has gotten arrested for spreading Frog Religion on Derse."]
            ..sideLoyalty = 1000
            ..makeCunning(100)
        );
        //AC	Rocks	Amethyst Copycat, Absurd Citrine, Abstaining Cobalt	Adamant Caretaker	Prospit
        //all acs ship. it's just how it works
        prospitians.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Amethyst","Absurd","Abstaining"], lastNames: <String>["Copycat","Citrine","Cobalt","Crystal"], ringFirstNames: <String>["Adamant"], ringLastNames: <String>["Caretaker"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is flipping the fuck out about how great rocks are.","is showing off her gem collection.","is pretending all the rocks have names and personalities and is shiping them together. Peridot x Lapis Lazuli OTP."]
            ..bureaucraticBullshit = <String>["wants a permit to publicly display their rock collection.","would like a permit to throw the first stone."]
            ..sylladex.add(new Item("Lapis Lazuli Gem",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.CRYSTAL]))
            ..sylladex.add(new Item("Peridot Gem",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.CRYSTAL]))
            ..description = "She collects rocks. Especially shiny and sparkly ones. That’s all she is talking about. She even ships her rocks. She wants more of them. Give her more rocks, and she will follow you."
            ..specibus = new Specibus("Geode", ItemTraitFactory.BUST, <ItemTrait>[ ItemTraitFactory.STONE, ItemTraitFactory.GLASS])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCharming(100)
            ..makeLucky(100)
        );
        //SU	Vengence	stupid uncovered, Steven universe, sally und	Sans Undertale	Prospit
        prospitians.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Stupid","Steven","Sally"], lastNames: <String>["Und","Universe","Uncovered"], ringFirstNames: <String>["Sans"], ringLastNames: <String>["Undertale"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session), new SeekScepter(session)] //order of scenes is order of priority
            ..distractions = <String>["is memeing at you.","is telling everyone they are going to have a bad time.","might have a skeleton inside them."]
            ..specibus = new Specibus("Eye Laser", ItemTraitFactory.RIFLE, <ItemTrait>[ ItemTraitFactory.ZAP, ItemTraitFactory.GLASS])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..sylladex.add(new Item("'How to Have a Bad Time' Book",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.BOOK, ItemTraitFactory.IRONICSHITTYFUNNY]))
            ..makeViolent(100)
            ..description = "ME’s spiritual sibling. Meme brought to flesh and chitin. They are usually chilling, munching on the hotdogs somewhere you cannot reach them, or doing dumb things.<br><br>Oh, and when they go crowned their left eye lights up and Megalovania starts accompanying them everywhere. Who writes this crap???...oh right."
            ..bureaucraticBullshit = <String>["is having a bad time."]
            ..sideLoyalty = -1000
            ..makeCharming(100)
        );
        //CI	Invention/Steampunk	Clever Innovator, Creative Inventor, Classy Investigator	Calamitous Incarnation	Prospit
        prospitians.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Clever","Creative","Classy"], lastNames: <String>["Inventor","Innovator","Investigator"], ringFirstNames: <String>["Calamitous"], ringLastNames: <String>["Incarnation"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is designing a giant steam punk robot.","is designing graceful yet effective machinery.","just dropped all their gears. All of them. It will take a while to pick up."]
            ..specibus = new Specibus("Giant Gear", ItemTraitFactory.BUST, <ItemTrait>[ ItemTraitFactory.METAL, ItemTraitFactory.BLUNT])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCharming(100)
            ..sylladex.add(new Item("Bronze Gear",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.METAL]))
            ..description = "She is skilled at tech. Especially steampunk tech. Which works despite the fact that it shouldn’t work. But who fucking cares."
            ..bureaucraticBullshit = <String>["needs a permit for her giant robot.","has to pay fines for the robot's destruction.","needs to update her inventor license."]

            ..makeCunning(100)
        );
        //YD	Healing	yogistic doctor, yelling doomsayer, yard dark	yahzerit dacnomaniac	Prospit
        prospitians.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Yogistic","Yard","Yelling"], lastNames: <String>["Dark","Doctor","Dentist"], ringFirstNames: <String>["Doomsayer"], ringLastNames: <String>["Dacnomaniac"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["has the weird feeling that he should be more than this.","is treating random carapace patients.","is reading various medical texts."]
            ..specibus = new Specibus("Stethoscope", ItemTraitFactory.BUST, <ItemTrait>[ ItemTraitFactory.METAL, ItemTraitFactory.BLUNT])
            ..bureaucraticBullshit = <String>["needs to make sure his medical license is up to date.","is filing for time off in six months."]
            ..sylladex.add(new Item("Stethescope",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.HEALING]))
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCharming(100)
            ..description = "He probably won’t chop off the wrong limb, and he probably won’t treat something you don’t have.  You...get the feeling he is supposed to be something more than this."
            ..makeCunning(100)
        );

        prospitians.addAll(getSunshineTeam());
        return prospitians;

    }
}