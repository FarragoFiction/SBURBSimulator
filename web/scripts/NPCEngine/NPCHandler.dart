import "../SBURBSim.dart";

//handles spawning and maintaining various npcs.
class NPCHandler
{
    Session session;


    //jack is special.
    GameEntity jack;





    NPCHandler(this.session) {
        setupNpcs();
    }

    void setupNpcs() {
        //for now, leave jack where he is and just have a second copy of him here. deal with it.
        //not gonna rip out existing 'shenannigans' system till i have a new one in place
        //TODO eventually the carapaces have a scene attached to them that they either add
        //TODO to the npc or player scene list when activated, or a companions
        //TODO jacks' replacement stabs scene will be able to stab any player OR npc, full on strife

    }

    //each npc has items in their sylladex, at least one of which is legendary
    //decides their quest rewards and what items MAIL QUESTS can choose from.

    //violent, lucky, charming, cunning
    List<Carapace> getMidnightCrew() {
        List<Carapace> midnightCrew = new List<Carapace>();

        print ("TEST NPCS: initializing midnight crew");
        jack = (new Carapace("Jack Noir", session, Carapace.DERSE, firstNames: <String>["Spades","Septuple","Seven"], lastNames: <String>["Slick", "Shanks","Shankmaster","Snake"], ringFirstNames: <String>["Sovereign", "Seven"], ringLastNames: <String>["Slayer", "Shanks"])
            ..specibus = new Specibus("Knife", ItemTraitFactory.KNIFE, [ ItemTraitFactory.JACKLY])
            ..distractions = <String>["is throwing a tantrum about how huge a bitch the Black Queen is.","is pretending to ride on a horse.","is so mad a paperwork.","is refusing to wear his uniform.","is stabbing some random carapace who said 'hello'.","sharpening Occam's razor","is actually being a pretty good bureaucrat.","hiding his scottie dogs candies."]
            ..sylladex.add(new Item("Occam's Razor",<ItemTrait>[ItemTraitFactory.BLADE, ItemTraitFactory.SMART]))
            ..sylladex.add(new Item("Horse Hitcher",<ItemTrait>[ItemTraitFactory.STICK, ItemTraitFactory.IRONICSHITTYFUNNY, ItemTraitFactory.LEGENDARY]))
            ..sylladex.add(new Item("Terrier Fancy Magazine",<ItemTrait>[ItemTraitFactory.ROMANTIC, ItemTraitFactory.PAPER]))

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
        midnightCrew.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Cordial","Courtyard","Clubs","Curious"], lastNames: <String>["Deuce","Droll","Dabbler"], ringFirstNames: <String>["Crowned","Capering","Chaotic","Collateral"], ringLastNames: <String>["Destroyer","Demigod"])
            ..specibus = new Specibus("Bomb", ItemTraitFactory.GRENADE, [ ItemTraitFactory.EXPLODEY])
            ..distractions = <String>["is flipping the fuck out about a bull penis cane. What?","is trading everbodies hats in the session.","is eating black licorice gummy bears.","is collecting just. So many bombs. You don't even know.","is stopping arguments between carapaces.","having a tea party with some nice consorts and underlings."]

            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session), new SeekRing(session), new SeekScepter(session), new GiveJackScepter(session), new GiveJackRing(session)] //order of scenes is order of priority
            ..sylladex.add(new Item("Licorice Gummy Bears",<ItemTrait>[ItemTraitFactory.CANDY]))
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: 500, Stats.MAX_LUCK: 500, Stats.SANITY: 100, Stats.HEALTH: 20, Stats.FREE_WILL: 100, Stats.POWER: 15})
            ..makeLucky(1000)
            ..sylladex.add(new Item("Black Inches Magazine",<ItemTrait>[ItemTraitFactory.ROMANTIC, ItemTraitFactory.PAPER]))

            ..sylladex.add(new Item("Bull Penis Cane",<ItemTrait>[ItemTraitFactory.STICK, ItemTraitFactory.GROSSOUT, ItemTraitFactory.LEGENDARY]))
            ..sylladex.add(new Item("Regisword",<ItemTrait>[ItemTraitFactory.BLADE, ItemTraitFactory.LEGENDARY, ItemTraitFactory.EDGED, ItemTraitFactory.POINTY]))
            ..makeCunning(1000)
        );

        midnightCrew.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Diamonds","Draconian","Dignified"], lastNames: <String>["Droog","Dignitary","Diplomat"], ringFirstNames: <String>["Dashing","Dartabout","Derelict"], ringLastNames: <String>["Destroyer","Demigod"])
            ..specibus = new Specibus("Knife", ItemTraitFactory.KNIFE, [ ItemTraitFactory.EDGED, ItemTraitFactory.CLASSY])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session), new SeekRing(session), new GiveJackScepter(session), new GiveJackRing(session)] //order of scenes is order of priority
            ..distractions = <String>["is playing classy records. ","is reading the paper. ","is fantasizing about perfectly tailored suits.", "is hiding his swedish fish.","is reading 'classy literature' about grey ladies.","is keeping everyone calm and productive."]
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: 0, Stats.MAX_LUCK: 100, Stats.SANITY: 500, Stats.HEALTH: 20, Stats.FREE_WILL: 0, Stats.POWER: 20})
            ..makeCharming(1000)
            ..makeCunning(1000)
            ..sylladex.add(new Item("Swedish Fish",<ItemTrait>[ItemTraitFactory.CANDY]))
            ..sylladex.add(new Item("Grey Ladies Newspaper",<ItemTrait>[ItemTraitFactory.ROMANTIC, ItemTraitFactory.PAPER]))
            ..sylladex.add(new Item("Finely Tailored Suit",<ItemTrait>[ItemTraitFactory.CLOTH, ItemTraitFactory.CLASSY, ItemTraitFactory.LEGENDARY]))
            ..sylladex.add(new Item("Regisword",<ItemTrait>[ItemTraitFactory.BLADE, ItemTraitFactory.LEGENDARY, ItemTraitFactory.EDGED, ItemTraitFactory.POINTY]))

            ..sideLoyalty = 1000
        );

        midnightCrew.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Hearts","Hegemonic","Horse"], lastNames: <String>["Brute","Boxcar","Bartender"], ringFirstNames: <String>["Hero-killing","Hateful"], ringLastNames: <String>["Beast","Bastard"])
            ..specibus = new Specibus("Fist", ItemTraitFactory.FIST, [ ItemTraitFactory.BLUNT])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session), new SeekRing(session), new SeekScepter(session), new GiveJackScepter(session), new GiveJackRing(session)] //order of scenes is order of priority
            ..distractions = <String>["is shipping just. All the things.","is reading RED CHEEKS magazine.","is protecting his wax lips candies. ","is updating his shipping grid.","is trying to get his OTP together already.","is demanding that this chump just KISS THE GIRL THIS INSTANT."]
            ..sylladex.add(new Item("Wax Lips",<ItemTrait>[ItemTraitFactory.CANDY]))
            ..sylladex.add(new Item("Red Cheeks Magazine",<ItemTrait>[ItemTraitFactory.PAPER, ItemTraitFactory.ROMANTIC]))

            ..sylladex.add(new Item("Regisword",<ItemTrait>[ItemTraitFactory.BLADE, ItemTraitFactory.LEGENDARY, ItemTraitFactory.EDGED, ItemTraitFactory.POINTY]))
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: 0, Stats.MAX_LUCK: 0, Stats.SANITY: 0, Stats.HEALTH: 500, Stats.FREE_WILL: 0, Stats.POWER: 500})
            ..makeViolent(1000)
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
            ..specibus = new Specibus("Tommy gun", ItemTraitFactory.MACHINEGUN, [ ItemTraitFactory.SHOOTY])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session), new SeekRing(session), new SeekScepter(session)] //order of scenes is order of priority
            ..distractions = <String>["is reading the gamefaqs for this section of his quest.","is brokering a peace treaty between the clowns, elves and pigs. This has NOTHING to do with SBURB.","is engaging SEPULCHRITU...wait no, never mind. False alarm."]
            ..royaltyOpinion = 10
            ..sideLoyalty = 10
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -100, Stats.MAX_LUCK: 100, Stats.SANITY: -100, Stats.HEALTH: 20, Stats.FREE_WILL: 200, Stats.POWER: 15})
            ..makeCharming(1000)
            ..sylladex.add(new Item("Candy Corn",<ItemTrait>[ItemTraitFactory.CANDY]))
            ..sylladex.add(new Item("Diversity Mural",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.PRETTY]))

            ..bureaucraticBullshit = <String>["needs to get their private eye license renewed.","needs to pay off all those mural loans he took out.","has to get this treaty properly ratified."]
            ..makeLucky(1000)
        );

        sunshineTeam.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Persistent","Pickle","Persnickety"], lastNames: <String>["Inspector","Innovator","Investegator"], ringFirstNames: <String>["Patient","Peaceful"], ringLastNames: <String>["Idol"])
            ..specibus = new Specibus("Handgun", ItemTraitFactory.PISTOL, [ ItemTraitFactory.SHOOTY])
            ..distractions = <String>["is oogling various things. It makes them uncomfortable.","is looking at HUNK RUMP magazine.","is using his high IMAGINATION stat to go on useless adventures."]
            ..sideLoyalty = 10
            ..sylladex.add(new Item("Tootsie Roll",<ItemTrait>[ItemTraitFactory.CANDY]))
            ..sylladex.add(new Item("Imaginary Fort",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.FAKE, ItemTraitFactory.PLYWOOD]))

            ..bureaucraticBullshit = <String>["has to pay this fine for public oogling.","needs a permit to fondly regard creation.","has a ticket for excess imagination usage this month."]
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session), new SeekRing(session), new SeekScepter(session)] //order of scenes is order of priority
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -100, Stats.MAX_LUCK: 100, Stats.SANITY: 100, Stats.HEALTH: 1, Stats.FREE_WILL: 500, Stats.POWER: 1})
            ..makeCharming(1000)
            ..makeCunning(1000)
        );

        sunshineTeam.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Ace","Audacious","Asshole"], lastNames: <String>["Detective","Dwarf","Dick"], ringFirstNames: <String>["Ascended"], ringLastNames: <String>["Demon","Destroyer"])
            ..specibus = new Specibus("Fist", ItemTraitFactory.FIST, [ ItemTraitFactory.BLUNT])
            ..distractions = <String>["is punching various things in the snoot to establish dominence.","is brewing the worlds most perfect hot sauce.","is wearing a wig. You assume he's undercover or something?"]
            ..royaltyOpinion = -10
            ..sylladex.add(new Item("Gummy Worm",<ItemTrait>[ItemTraitFactory.CANDY]))
            ..sylladex.add(new Item("5 Alarm Hot Sauce",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.ONFIRE]))

            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session), new SeekRing(session), new SeekScepter(session)] //order of scenes is order of priority
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: 0, Stats.MAX_LUCK: 0, Stats.SANITY: -500, Stats.HEALTH: 100, Stats.FREE_WILL: 100, Stats.POWER: 100})
            ..makeViolent(1000)
            ..bureaucraticBullshit = <String>["has to pay this fine for public fiestaing.","has to post bail for public rowdyness."]
            ..makeLucky(1000)
        );

        sunshineTeam.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Hysterical","Haunting","Honored"], lastNames: <String>["Dame","Dancer","Debutante"], ringFirstNames: <String>["Hazardous"], ringLastNames: <String>["Demoness"])
            ..specibus = new Specibus("Lipstick Chainsaw", ItemTraitFactory.CHAINSAW, [ ItemTraitFactory.EDGED])
            ..distractions = <String>["is threatening everyone around her with a chainsaw.","is completely hysterical.","is making friends with women of ill repute."]
            ..sideLoyalty = 10
            ..sylladex.add(new Item("Scale Bodice",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.PRETTY]))
            ..sylladex.add(new Item("Tommy Gun",<ItemTrait>[ItemTraitFactory.MACHINEGUN, ItemTraitFactory.SHOOTY]))

            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session), new SeekRing(session), new SeekScepter(session)] //order of scenes is order of priority
            ..bureaucraticBullshit = <String>["has to pay this fine for public hysteria.","needs a permit to open up a fine establishment for her new friends.","has to pay a fine for all this public damage."]

            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: 500, Stats.MAX_LUCK: 500, Stats.SANITY: 100, Stats.HEALTH: 20, Stats.FREE_WILL: 100, Stats.POWER: 15})
            ..makeCharming(1000)
            ..makeViolent(1000)
        );

        sunshineTeam.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Nervous","Naive","Nice"], lastNames: <String>["Broad","Bird","Bartender"], ringFirstNames: <String>["Notorious","Never-ending"], ringLastNames: <String>["Bard","Bloodshed"])
            ..specibus = new Specibus("Flamethrower", ItemTraitFactory.PISTOL, [ ItemTraitFactory.ONFIRE])
            ..distractions = <String>["is very nervous.","is having a nervous breakdown.","is trying to figure out the difference between a teddy bear and a knife."]
            ..sideLoyalty = 10
            ..sylladex.add(new Item("Teddy Bear",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.ROBOTIC2]))

            ..sylladex.add(new Item("Paint Stripper",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.ONFIRE]))

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

        List<Carapace> randomDersites = new List<Carapace>();
        randomDersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Agitated","Authority","Aimless","Authoritarian"], lastNames: <String>["Regulator","Renegade","Radical","Rifleer"], ringFirstNames: <String>["Ascendant"], ringLastNames: <String>["Rioter"])
            ..specibus = new Specibus("Machine Gun", ItemTraitFactory.MACHINEGUN, [ ItemTraitFactory.SHOOTY])
            ..sideLoyalty = 20
            ..sylladex.add(new Item("Alarming Pile of Guns and Ammunition",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.SHOOTY]))

            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..bureaucraticBullshit = <String>["needs to stock back up on tickets to give people.","has brought in some roughnecks to be sent to the slammer.","needs an updated list of everything that became illegal in the past day."]
            ..distractions = <String>["flipping the fuck out about how illegal everything is.","being extra angry at crimes.","designing slammers to throw things into. You call it the slammer you are extra angry at crimes."]
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeViolent(100)
            ..makeLucky(100)
        );

        randomDersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Wayward","Wizardly","Warweary","Wandering"], lastNames: <String>["Vagrant","Villain","Vassal","Villager"], ringFirstNames: <String>["Wicked"], ringLastNames: <String>["Villian"])
            ..specibus = new Specibus("Sword", ItemTraitFactory.SWORD, [ ItemTraitFactory.EDGED, ItemTraitFactory.METAL])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session), new SeekScepter(session)] //order of scenes is order of priority
            ..royaltyOpinion = -1000
            ..sylladex.add(new Item("Firefly in Amber",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.SENTIENT]))

            ..distractions = <String>[" WV is distracted eating green objects rather than recruiting for his army. "," WV is distracted planning the civil infrastructure of a city, rather than recruiting for his army."," WV is distracted fantasizing about how great of a mayor he will be. "," WV accidentally tried to recruit carapacians already part of his army. Stupid stupid stupid! "," WV gets distracted freaking out about car safety. "," WV gets distracted freaking out about how evil bad bad bad bad monarchy is. "," WV gets distracted writing a constitution for the new democracy. "]
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCharming(100)
            ..makeLucky(100)
        );

        randomDersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Jazz","Jazzed","Jazzy"], lastNames: <String>["Singer","Songstress","Savant"], ringFirstNames: <String>["Jilted"], ringLastNames: <String>["Seductress"])
            ..specibus = new Specibus("Microphone", ItemTraitFactory.CLUB, [ ItemTraitFactory.LOUD, ItemTraitFactory.ZAP])
            ..bureaucraticBullshit = <String>["needs to renew her liquor license.","wants a permit for a public performance.","needs to pay a fine for singing a song with banned words."]
            ..sylladex.add(new Item("Classy Stockings",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.CLASSY]))

            ..distractions = <String>["is singing a sultry tune.","is writing down some new lyrics for her work in progress song.","is flirting with a random carapace."]
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCharming(100)
            ..makeCunning(100)
        );

        randomDersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Zipping","Zany","Zephyr"], lastNames: <String>["Coach","Coaster","Coder"], ringFirstNames: <String>["Zero"], ringLastNames: <String>["Casualties"])
            ..specibus = new Specibus("Sword", ItemTraitFactory.SWORD, [ ItemTraitFactory.EDGED, ItemTraitFactory.METAL])
            ..sylladex.add(new Item("Postal Code Map",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.PAPER]))

            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is so excited about postal codes!","is telling anyone in earshot about the sheer perfection of the modern postal code!","is zipping around simulating delivering packages in order to train for the real deal."]
            ..bureaucraticBullshit = <String>["needs to pay off this speeding ticket.","needs to deliver a package that's in impound.","needs a copy of the most up to date postal code map."]

            ..stats.setMap(<Stat, num>{Stats.MOBILITY: 500, Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeLucky(100)
            ..makeCharming(100)
        );

        //DP	Philosophy	Deep Philosopher,Drunk Philanthropist, Dance Practitioner	Doom Prophet	Prospit
        randomDersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Deep","Drunk","Dance"], lastNames: <String>["Philanthropist","Practitioner","Philosopher"], ringFirstNames: <String>["Doom"], ringLastNames: <String>["Prophet"])
            ..specibus = new Specibus("Tome", ItemTraitFactory.BOOK, [ ItemTraitFactory.PAPER])
            ..distractions = <String>["is telling everyone that the End is Nigh. Everyone ignores him because this is obviously true.","is ranting about various Philosophical topics that no one actually cares about.","has just given up on everything, for a while."]
            ..sideLoyalty = 10
            ..sylladex.add(new Item("Prophetic Sign",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.DOOMED]))

            ..bureaucraticBullshit = <String>["would like a public protest permit.","wants to tell those in authority about how the End is Nigh.","has to pay a fine for public drunkeness."]

            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority

            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeViolent(100)
            ..makeCunning(100)
        );

        //MD	Medicine	Medical Deputy, Morbid Doctor	Malpracticeing Despot	Derse
        randomDersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Morbid","Malicious","Medical"], lastNames: <String>["Doctor","Deputy","Dentist"], ringFirstNames: <String>["Malpracticing"], ringLastNames: <String>["Despot"])
            ..specibus = new Specibus("Scalpel", ItemTraitFactory.BLADE, [ ItemTraitFactory.EDGED, ItemTraitFactory.METAL, ItemTraitFactory.POINTY])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is getting some much needed rest in between shifts.","is probably forging those insurance documents.","is accepting money under the operating table."]
            ..sideLoyalty = -10
            ..sylladex.add(new Item("Bloody Scalpel",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.BLADE]))
            ..bureaucraticBullshit = <String>["is getting sued for malpractice.","needs to refile her permits for all those taxidermied corpses he keeps.","has to renew her 'medical license'. "]
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeViolent(100)
            ..makeCunning(100)
        );

        //SI	Invention/Gaslamp	Silicon Introvert, Sparky Inventress, Saddened Illuminator 	"Silent InversionDerse
        randomDersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Silicon","Sparky","Saddened"], lastNames: <String>["Illuminator","Inventress","Introvert"], ringFirstNames: <String>["Silent"], ringLastNames: <String>["Inversion"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is scribbling blueprints for a bronze automaton powered by Aether.","is cosplaying various gaslamp fantasy outfits.","has passed out after spending way too long up inventing things."]
            ..sylladex.add(new Item("Glowing Crysal",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.FAE]))

            ..specibus = new Specibus("Spark Rifle", ItemTraitFactory.RIFLE, [ ItemTraitFactory.ZAP, ItemTraitFactory.SHOOTY, ItemTraitFactory.POINTY])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: -500, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCunning(100)
            ..bureaucraticBullshit = <String>["needs a permit for all her inventions.","has to pay a fine after one of her Automatons went wild.","wants the Archagent to see her new cosplay."]

            ..makeCharming(100)
        );

        //ME	renegade	meticulous Engineer, machiavillian Egoist, miles edgeworth	Mass Effect (and his robot girlfriend)	Derse
        randomDersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Meticulous","Miles","Maverick","Mass"], lastNames: <String>["Edgeworth","Egoist","Engineer","Edge","Effect"], ringFirstNames: <String>["Mass"], ringLastNames: <String>["Effect"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is memeing at something.","is being a renegade of some sort.","is choosing between two ridiculously polarized options."]
            ..specibus = new Specibus("Rifle", ItemTraitFactory.RIFLE, [ ItemTraitFactory.SHOOTY])
            ..sylladex.add(new Item("Model Spaceship",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.SMART]))

            ..sideLoyalty = -100
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeViolent(100)
            ..bureaucraticBullshit = <String>["has to pay a fine after spray painting 'N7' on the Royal Palace.","has to pay a fine after doing sweet BIKE STUNTS off the chain between Derse and it's moon.","has to post bail after punching all those kittens."]

            ..makeCharming(100)
        );

        //GN	Cooking	garrulous Nutritionist, gourmet Noodle, gourmand Nibbler,	Gluttonous Newt	Derse
        randomDersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Gooby","Garrulous","Gourmet","Gourmand"], lastNames: <String>["Nutritionist","Noodle","Nibbler"], ringFirstNames: <String>["Gluttonous"], ringLastNames: <String>["Newt"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is eating a shit ton of food.","is cooking, and then eating, a shit ton of food.","has further perfected her noodle recipe."]
            ..specibus = new Specibus("Salad Fork", ItemTraitFactory.FORK, [ ItemTraitFactory.POINTY, ItemTraitFactory.METAL])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCharming(100)
            ..sylladex.add(new Item("Cookbook",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.BOOK]))

            ..makeViolent(100)
            ..bureaucraticBullshit = <String>["needs a permit for a huge banquet in the Queen's honor.","wants to make sure the Archagent is eating right."]

            ..sideLoyalty = -10

        );
        //BE	Bugs	Bug Entomologist, Beetle Enthusiast, Butterfly Enquirer	Brigand Engineer	Derse
        randomDersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Beetle","Butterfly","Bug"], lastNames: <String>["Enthusiast","Entomologist","Enquirer"], ringFirstNames: <String>["Brigand"], ringLastNames: <String>["Eclectica"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is flipping the fuck out about how great bugs are!","thinks they just saw a rare beetle.","is tending to their butterflies."]
            ..specibus = new Specibus("Butterfly Net", ItemTraitFactory.STICK, [ ItemTraitFactory.WOOD, ItemTraitFactory.RESTRAINING])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCharming(100)
            ..sylladex.add(new Item("Butterfly Collection",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.FAE]))

            ..makeLucky(100)
            ..bureaucraticBullshit = <String>["has to pay a fine after letting that swarm of locusts out into the royal [REDACTED] gardens.","wants a permit to store more fireflies."]

        );
        //EA	HorrorTerrors	Eldritch Acolyte, Eccentric Advocate, Eclectic Alien	Efflorant Atronach	Derse
        randomDersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Eldritch","Eccentric","Eclectic"], lastNames: <String>["Acolyte","Alien","Advocate"], ringFirstNames: <String>["Efflorant"], ringLastNames: <String>["Atronach"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session), new SeekRing(session), new SeekScepter(session)] //order of scenes is order of priority
            ..distractions = <String>["is worshiping the horror terrors.","is thinking about ways to make free-to-play games even more evil.","is doing the work of the Elder Gods."]
            ..specibus = new Specibus("Grimoire", ItemTraitFactory.BOOK, [ ItemTraitFactory.PAPER, ItemTraitFactory.CORRUPT, ItemTraitFactory.MAGICAL])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: -500, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeViolent(100)
            ..sylladex.add(new Item("Shrieking Grimoire",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.CORRUPT]))

            ..makeCunning(100)
            ..bureaucraticBullshit = <String>["is paying a nominal fee for breaking the law rather than having any real consequences.","would like to tell the Archagent about the Will of the Elder Gods.","got busted for using Magicks, which have been declared 'fake as fuck' by Royal Decree."]
            ..sideLoyalty = 1000

        );

        randomDersites.addAll(getMidnightCrew());
        return randomDersites;

    }

    //violent, lucky, charming, cunning
    List<Carapace> getProspitians() {

        List<Carapace> randomProspitians = new List<Carapace>();

        randomProspitians.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Royal","Regal","Rolling"], lastNames: <String>["Baker","Breakmaker","Breadmaker"], ringFirstNames: <String>["Rampaging"], ringLastNames: <String>["Butcher"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is angsting about how hard HOLY PASTRIES are to get right.","is pre-making a shit ton of dough to use later.","is cleaning out the ROYAL OVENS. Wow, that's a lot of work!"]
            ..specibus = new Specibus("Rolling Pin", ItemTraitFactory.ROLLINGPIN, [ ItemTraitFactory.BLUNT, ItemTraitFactory.WOOD])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..bureaucraticBullshit = <String>["needs to pay a fine after that debacle with the Pastries of Love.","is dropping off a cake topped with Scottie Dogs."]
            ..makeCharming(100)
            ..sylladex.add(new Item("Holy Pastry",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.EDIBLE, ItemTraitFactory.MAGICAL]))

            ..makeLucky(100)
            ..royaltyOpinion = 1000
        );

        randomProspitians.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Parcel","Perigrine","Postal"], lastNames: <String>["Mistress","Mendicate","Mailer"], ringFirstNames: <String>["Punititve"], ringLastNames: <String>["Marauder"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is flipping the fuck out about how great the MAIL is.","is delivering packages to unimportant carapaces.","is just sort of generally being a badass."]
            ..specibus = new Specibus("Sword", ItemTraitFactory.SWORD, [ ItemTraitFactory.EDGED, ItemTraitFactory.METAL])
            ..stats.setMap(<Stat, num>{Stats.MOBILITY: 500,Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCharming(100)
            ..bureaucraticBullshit = <String>["needs to pick up a package that's in lockup.","has to deliver a small package to the Archagrent.","wants to pick up some mail to deliver."]
            ..sylladex.add(new Item("Mail Cap",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.CLOTH]))

            ..makeLucky(100)
            ..sideLoyalty = 10
            ..royaltyOpinion = 10


        );
        Fraymotif f = new Fraymotif("Sincere Pep Talk", 3);
        f.effects.add(new FraymotifEffect(Stats.SANITY, FraymotifEffect.ALLIES, true));
        f.effects.add(new FraymotifEffect(Stats.SANITY, FraymotifEffect.ALLIES, false));

        f.desc = " KB explains that you're a good person. ";
        //So a fraymotif might be "Sincere Pep Talk" and a specibus might be "Friendship Bracelet" or something?
        randomProspitians.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Kid","Kind","Keen","Knave"], lastNames: <String>["Boi"], ringFirstNames: <String>["Knight"], ringLastNames: <String>["Boi"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is being the very best, like no one ever was.","is explaining the rules to Captchacardmons.","is showing everyone his fanfictions."]
            ..specibus = new Specibus("Friendship Bracelet", ItemTraitFactory.STICK, [ ItemTraitFactory.CLOTH, ItemTraitFactory.ASPECTAL])
            ..fraymotifs.add(f)
            ..sylladex.add(new Item("Catpchacardmon Ball",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.SENTIENT]))

            ..bureaucraticBullshit = <String>["wants to update their captchacardmon license."]

        //kid boi is too good and pure to go crazy
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 999999, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCharming(100)
            ..makeLucky(100)
        );

        //PE	Education/Magic	"Persevering Educator,Persistent Entertainer,Punctual Executant"	Purple Executioner	Prospit
        randomProspitians.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Persevering","Punctual","Persistent"], lastNames: <String>["Entertainer","Executant","Educator"], ringFirstNames: <String>["Purple"], ringLastNames: <String>["Executioner"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is teaching everyone who will listen the rules of Magic, which is a totally real thing.","is performing stage magic for a crowd.","is teaching simple magic to onlookers."]
            ..sideLoyalty = 10
            ..bureaucraticBullshit = <String>["wants to get a permit to put on a magic show.","needs to pay a fine for a public disturbance claiming magic was real.","needs to update their magic license."]
            ..sylladex.add(new Item("Magical Textbook",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.MAGICAL, ItemTraitFactory.BOOK]))

            ..specibus = new Specibus("Magic Wand", ItemTraitFactory.STICK, [ ItemTraitFactory.BLUNT, ItemTraitFactory.WOOD])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCharming(100)
            ..makeCunning(100)
        );

        randomProspitians.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Mobster","Monster","Maestro"], lastNames: <String>["Kingpin","Killer","Kilo"], ringFirstNames: <String>["Master"], ringLastNames: <String>["Kriminal"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session), new SeekRing(session), new SeekScepter(session)] //order of scenes is order of priority
            ..distractions = <String>["is eating a shit ton of sugar.","is just sort of generally being a dick.","is really emotionally invested in this game of Life being played."]
            ..sideLoyalty = -1000
            ..sylladex.add(new Item("Romance Novel",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.ROMANTIC, ItemTraitFactory.BOOK]))

            ..bureaucraticBullshit = <String>["wants to file a 'legitimate business' license.","wants to talk shop.","wants a license to practice 'legitimate business'."]
            ..specibus = new Specibus("Brass Knuckles", ItemTraitFactory.FIST, [ ItemTraitFactory.BLUNT, ItemTraitFactory.METAL])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 500})
            ..makeViolent(500)
            ..makeCunning(500)
        );

        //MP	Art	MS. Paint, Magestic Painter, Mirthful Painter	Massacre Primer	Prospit
        randomProspitians.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Mirthful","Majestic","Mrs.","Miss","Ms."], lastNames: <String>["Paper","Paint","Painter"], ringFirstNames: <String>["Massacre"], ringLastNames: <String>["Primer"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is painting a mural.","is helping to care for a sick carapace.","is carrying a lewd object filled with a colorful substance. Get your mind out of the gutter, it's just paint!"]
            ..specibus = new Specibus("Paintbrush", ItemTraitFactory.STICK, [ ItemTraitFactory.BLUNT, ItemTraitFactory.WOOD])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCharming(100)
            ..sylladex.add(new Item("Lewd Object",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.METAL])) //its' a bucket
            ..sideLoyalty = 10
            ..bureaucraticBullshit = <String>["wants to file paperwork to get reimbursed for a community mural she painted.","needs to file an extension for a mural she's painting.","has to get a permit to order more lewd objects filled with paint."]

            ..makeLucky(100)
        );
        //HP	Holy	Holy Preacher,Happy Painter, High Pediatrician	Hallowed Patrician	Prospit
        randomProspitians.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Holy","Happy","High"], lastNames: <String>["Preacher","Pediatrician","Priest"], ringFirstNames: <String>["Hallowed"], ringLastNames: <String>["Patrician"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is expounding on the virutes of the Vast Croak to any who would listen.","is meditating on how to be more Frog-like.","is performing an acapello song of croaks."]
            ..specibus = new Specibus("Religious Text", ItemTraitFactory.BOOK, [ ItemTraitFactory.PAPER, ItemTraitFactory.MAGICAL])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCharming(100)
            ..sylladex.add(new Item("Crystaline Frog",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.GLOWING]))

            ..bureaucraticBullshit = <String>["needs a license to preach.","would like to get a permit for limited amphibian iconography to spread the word of the Vast Croak.","has gotten arrested for spreading Frog Religion on Derse."]
            ..sideLoyalty = 1000
            ..makeCunning(100)
        );
        //AC	Rocks	Amethyst Copycat, Absurd Citrine, Abstaining Cobalt	Adamant Caretaker	Prospit
        randomProspitians.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Amethyst","Absurd","Abstaining"], lastNames: <String>["Copycat","Citrine","Cobalt","Crystal"], ringFirstNames: <String>["Adamant"], ringLastNames: <String>["Caretaker"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is flipping the fuck out about how great rocks are.","is showing off her gem collection.","is pretending all the rocks have names and personalities and is shiping them together. Peridot x Lapis Lazuli OTP."]
            ..bureaucraticBullshit = <String>["wants a permit to publicly display their rock collection.","would like a permit to throw the first stone."]
            ..sylladex.add(new Item("Lapis Lazuli Gem",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.CRYSTAL]))
            ..sylladex.add(new Item("Peridot Gem",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.CRYSTAL]))

            ..specibus = new Specibus("Geode", ItemTraitFactory.BUST, [ ItemTraitFactory.STONE, ItemTraitFactory.GLASS])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCharming(100)
            ..makeLucky(100)
        );
        //SU	Vengence	stupid uncovered, Steven universe, sally und	Sans Undertale	Prospit
        randomProspitians.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Stupid","Steven","Sally"], lastNames: <String>["Und","Universe","Uncovered"], ringFirstNames: <String>["Sans"], ringLastNames: <String>["Undertale"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session), new SeekScepter(session)] //order of scenes is order of priority
            ..distractions = <String>["is memeing at you.","is telling everyone they are going to have a bad time.","might have a skeleton inside them."]
            ..specibus = new Specibus("Eye Laser", ItemTraitFactory.RIFLE, [ ItemTraitFactory.ZAP, ItemTraitFactory.GLASS])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..sylladex.add(new Item("'How to Have a Bad Time' Book",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.BOOK, ItemTraitFactory.IRONICSHITTYFUNNY]))
            ..makeViolent(100)
            ..bureaucraticBullshit = <String>["is having a bad time."]
            ..sideLoyalty = -1000
            ..makeCharming(100)
        );
        //CI	Invention/Steampunk	Clever Innovator, Creative Inventor, Classy Investigator	Calamitous Incarnation	Prospit
        randomProspitians.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Clever","Creative","Classy"], lastNames: <String>["Inventor","Innovator","Investigator"], ringFirstNames: <String>["Calamitous"], ringLastNames: <String>["Incarnation"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is designing a giant steam punk robot.","is designing graceful yet effective machinery.","just dropped all their gears. All of them. It will take a while to pick up."]
            ..specibus = new Specibus("Giant Gear", ItemTraitFactory.BUST, [ ItemTraitFactory.METAL, ItemTraitFactory.BLUNT])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCharming(100)
            ..sylladex.add(new Item("Bronze Gear",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.METAL]))

            ..bureaucraticBullshit = <String>["needs a permit for their giant robot.","has to pay fines for the robot's destruction.","needs to update their inventor license."]

            ..makeCunning(100)
        );
        //YD	Healing	yogistic doctor, yelling doomsayer, yard dark	yahzerit dacnomaniac	Prospit
        randomProspitians.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Yogistic","Yard","Yelling"], lastNames: <String>["Dark","Doctor","Dentist"], ringFirstNames: <String>["Doomsayer"], ringLastNames: <String>["Dacnomaniac"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["has the weird feeling that he should be more than this.","is treating random carapace patients.","is reading various medical texts."]
            ..specibus = new Specibus("Stethoscope", ItemTraitFactory.BUST, [ ItemTraitFactory.METAL, ItemTraitFactory.BLUNT])
            ..bureaucraticBullshit = <String>["needs to make sure his medical license is up to date.","is filing for time off in six months."]
            ..sylladex.add(new Item("Stethescope",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.HEALING]))
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCharming(100)
            ..makeCunning(100)
        );

        randomProspitians.addAll(getSunshineTeam());
        return randomProspitians;

    }
}