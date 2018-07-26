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
        print("TEST BULLSHIT: setting up ncps");
        setupBigBads();
    }

    static Future<Null> loadBigBads() async {
        print("loading big bads");
        String data = await Loader.getResource("BigBadLists/bigBads.txt");
        bigBadsFromFile = data.split(new RegExp("\n|\r"));
    }

    void setupBigBads() {
        session.logger.info("TEST BULLSHIT: setting up big bads from ${bigBadsFromFile.length} data strings, $bigBadsFromFile");
        for(String line in bigBadsFromFile) {
            if(line.isNotEmpty) {
                BigBad newBB = BigBad.fromDataString(line, session);
                newBB.setStat(Stats.HEALTH, 130);
                newBB.heal();
                newBB.setStat(Stats.POWER, 130);

                print("made a new BB ${newBB}");
                bigBads.add(newBB);
            }
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
            ..serializableSceneStrings.add("Say Hello:___ N4IgdghgtgpiBcIDKECeACAEjANjg9iADQgBmOEAbvgE4AqMAHgC4IjpIDCAogHLcB9APIB1fgCUBvAIIBZbugAmMAA4FUAZ3Q4AlgHMAFs3QbmEAEZbm+AO4QaiqwZjp0daeIDi3OlLmChSRl5JCJ0HWYAci0AKwBXU3QDW3RmZwwNNCTcAgA6YhAzGj0YZiEwOERmGji4Emr9EppOfDBFCJ1WjQAZHUodMD02AG1gAB0QHSgVWjMwZhFaRQn4Cd4AemkJojWhOhWJ0ggcDRhtichYA5AASQ1pXUoz4gmpmZo55hv564AGCYAvmFxpNprMIPNFg5rhsti8QLw9tcjidnjtwNBnqtbhpxBDFPgoOdQe9Pt9mNcAEz-EBA9Agt7gyFLGGbYmI-YICbVWrEy5YiZ3JC4UjExkfCFfH5ckA0gEAXQKDT0TRabQ6XW6+JGipIMFIpBgAGNmBoAGK0Xr9QYjBlgiXM6Ey7DHNJ8zHXTgGCElJBmCnw8WfXhxKDmGA0a4AWgAjABmOXA172z5Q5YyzhxGg0GDzLAwV0Gd1XDPewYwP0QAPooOSkNhiPR+Ny3UgfWGk3my34jQ62lAA")
            ..serializableSceneStrings.add("Be Omnicidal:___ N4IgdghgtgpiBcIBCMAEB5KYCWBjbAJhADYgA0IAZsRAG4D2ATgCowAeALgiAMoDCAUQByAgProA6iIBKooQEEAsgNQAHPAGsAzqlTN50gOIDmcpWPSyFynqlz0oq4jA4xiAT1QQOqRhDAEDqgc9KhaNACuAOYAFq6MAHSo5CAcEIxRLuhgcIgcjBFwFPnYUZmMfPQB2BzYVVoAMti02GBR3ADawAA6INiOTGlgHBJMBL3wvUIA9PK9ZFPozBO9lCRaMPO9kLArIACSWvLEzZvkvf2qg-4c+8N7AAy9AL5kqD19A4xDI2N7M3NziAhEs9mtiBstuBoGdJgctNJ-IEoFDLtdhncOHsAExPECvd4XL4-UaMcYIKazKEg5YU1IFM4LaG7OmHHhuSio4k3TGPF5vD5o743UnkuEA6mgungyFAnaw3r7eRQPiMegAdxy5KZQp+vLpeIJgu5w1FewAChqYIxJbS4flClD5XtmOlMhweGlblpDIwYN5rcwYv5FK1GUSrsKMfcDS8ALopEpla2Vaq1eoNJGdBMUGCUSgwXAcLQAMSYTRabU6xsjJL+dIlcphezuWjSAGlsMRiFzazchBEoAAja18-E5kB5gtF0vlpFabP4oA")
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
            ..serializableSceneStrings.addAll(<String>["Be Incompetant:___ N4IgdghgtgpiBcIBCMAEBJMBjA9lADjAC4RhEgA0IAZgDYQBuOATgCowAe5irAFszgCuAc16oIqas1IBrWgE9UUAJZgAJqgBGOYcNqrhqAM4xmymEdQ5qqGAxhkjFVAGUAwgFEAch4D6AeQB1HwAlXy8AQQBZD3EsLGU1BxJaBS1aHAB3S0F8VFRWCJCAcQ9WcOi-fzDImJcAOldTZSEjBUaATSFUNRwwAHIiW3swVEzSIaIcVBkwLMbKEBJmYWJ-MDhEImZBOCpt5V1TNz61ZSIWsCMAGWUGAwQQAG1gAB0QZQIWEjJAljV3vB3l4APQRd4UYH+ViA97UCC0EwQ96QWCwkDoCJQNwCTIbAGUd6ffDfCaYIjogAM7wAvgBdRYHI7ME7qc6XG6kNSPF5Er7MH5EP7MAlAkCg8GE8XQ9HwxEwZHgaAKhDvVgQFbEdBGLw4IgAEQs2xw8hgBMhH35gvJVNpzjelpJAomwtFwLBiq8MtVNARSKlqJVYu1IS5eEVxNJZBtPoAbLSGVQYNRqDAsEQjAAxFi3e5gYQ8xMgZOp9NZnNcow8h2R52-f7oiWKwPozBGEhIDKZACq+AjVomXkEUE0pltIHpE6AA"])
            ..serializableSceneStrings.add("Try to Steal Explosives:___ N4IgdghgtgpiBcIAqAnAngAgC4HsMGUsYIAbDAUQA8AHEnAZwEsA3GekAGhADMSJmcKJDEpYEIAgGFyAOXIB9APIB1OQCV5MgIIBZchnrUcWegZywMKYiRKYA5lYhYKADQAKAGUUARcgE0MJAAJAEkZAHF8DEYwbAALGAxArTVw8iRNXQVFDW09fAByU3o0GwgAExEAQkCEzBQAVygoCDtEiBQcBrByjCdLCB7zaNjGZ0Helsg27DxqBpszWCw4mLsMLqwa5NT0zL0lXKyouJxqNktrWww4jt6xjAB3CFMVxPJ3L18A4LDwqs4ICwHTaWEUYDgiCwjTgXGhjDsbRQkhwPTGjFR9A8LDW4gA2sAADogRhQIwoYFgLDKQTlYnwYkyAD0WmJHEZiiQ9OJ3FI9BgbOJkFg3JAIXoWhILAFnGJpPJlKwISpooADMSAL4cDBEklkwSKmkoOkIYkiWg4cprQUgGSc0W8kj8m3CmUMkBBF4hIhQZRjOKoCBjG3yg2DJUq00gdUgDUAXUB8MRMGRqKtWAxYCxE3xCa4MG43BgAGMTAAxQTY5i4xAEuX6inho0m93M1my8DQN3EtyMYsAazcOAHMCwIYbipkTQARim1Zq8yAC0XS-QKygPBN2LWExqgA")
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
            ..serializableSceneStrings.add("Bond over Fashion:___ N4IgdghgtgpiBcIBCB7MATABCgbjATpgGIQDOAFgJZogA0IAZgDYQ4r4AqMAHgC4IhMAZQDCAUQByYgPoB5AOpSAStIkBBALJjMABzKkYpTKRSxMvSmYDGpvfkpgA5pgZkqaTGBS9DmAO6UvOSYmBxqSgDiYhyqmjKyKupaQnQgvBD4jjC8smBwiLz4AK5w9IWUjln4ImjogdRgpAAylDgOjgIA2sAAOiCWOuzpYLzy7Oh98H0SAPRqfbTTshyTfa5MBgt9kLCrIACSpGpMrTBb-VCD+MO8+yN7AAx9AL60mL0XVzdj+BMIfQARUyGCxWc4SZZ7dabOjbaBnf4gAASZDuPnwIJEEB8jnYAE9zgMhhARmjHi8ALqpcqVAg1DD1NDNEnoLpU+gwBgMGBWXikIjsFptJxdD5E64k0bjPZCEmBAmw8DwvYicgkrJCdK8QmXYkjCRFKAAIwIewAjABmSmpTnc3n8wUs0hskDPIA")
            ..serializableSceneStrings.addAll(<String>["Destroy Bad Fashion:___ N4IgdghgtgpiBcIAiMDOAXATgewJ4AIAhCAE3wDEJUALAS2zBABoQAzAGwgDdtMAVGAA90CEAGUAwgFEAclID6AeQDqcgEryZAQQCyU-LVT4IABxMR27GGQjp86ajHwB3CAT5a1AcSl9NuhUUNbT0xAHIjbABXdFZaO3ZsbABrVAA6fAAJJxJsNHtHF152G3xWbl5jMDISNCw8I3iMgBkk1Px2WmSnBxhcMMt8am4e7GN2AGNHKFoALycwGGd8CcTe9PwtauMO7DtsVnw9x0x8DCjWViZ7JLTmEHQITABzGHRFRdEsKLgWLFpnq9MBIGCR4vQwKhmrQuLQwM9RABtYAAHRAtCgJl4jzA6GUvBIaPgaJkAHotGimCTFHwiWjyuxUDBKWjILA6SAAJKoAAKnFwMEwLPRmOxEFxnNxHIADGiAL7XVEirGYHF4gkcskU5jU2kIekWJnCtnM-Vc1BqcW5KDCjEqtWS9AcgAc8sVaLtYtx+MwhLNfAgE2SuGFMhpHIZRp14GgpuJIEyVE56BgUGU8WofEwEHittFqvF6EdMrd+CVnoL3o1Zp52GcgtD4bN31NVJj7P9T1e6DEjyLqC8mBgtkFfGGYB0cNbHvzDqlZtlIDlAF17v9AYKQdVwQwoVakauWDBLjAJuhUOReNDYfCkeXZ4WfX741rjbGOSgMDhcGJcJZSEIeb2oWMhRFAABGDYLvKh4gMerCnuel6YM0VqoAeS5AA","Collect Finely Tailored Suits:___ N4IgdghgtgpiBcIDCB7ANmmBjALgAgDEBLMGNATzwBUIi0UAnGAEzwGUBXInAZxABoQAMzQQAboyowAHjgQg2SAKIA5JQH0A8gHU1AJXUqAggFkleJhAyU0RANYweeHAAsYeAO4RKr99SN6AOJKVIamGpoGxmZsAOROKBw4Qtx49Ch2PAB0eAASMLEYeABG7jgQdiQA5s4uEDj8eGAoHjkAMigZTrYOtTDkhWh4dWJlKHhWWG5QRABe7qQeeFj0vtl4RmCsEGko+ChCeHtuDHg8OBxCQo04nVkCIOUMVTA4mqTyOAwccIJfRFUXgxUFtuEQUGAeG0iGJqvIANrAAA6ICIUAADoxymAcNpGMwUfAUSoAPRGFH8YmaKiElFCKw8GAUlGQWC0kAASR4AAVROQYAxmaiMViIDiOTj2QAGFEAX0ayOFmIY2Nx+PZpPJAipNIQdIZTO14GghqJnJ4ejFzBQUCFaOVqolOHZAA45QqUfbRTi8QwCXqQCsIDweOQhSpqeyvj8hazTSjcsGOTgYFBtNwXFQGLRnUavSqxTgndL3XhFfnVb7-WbuS0BeHIwHo4bKca2QGaM9XmxykWeIFLCmGFQ6mATCQW56RQXxZKAzKQLKALoPf6AgUg5hgiFQq0IleCGBXbC8AiMaGwsBVBHl6eV9UBzWxk3skwcKp2u+FlQcKClQXznKB4gEeQgnjwZ4MG0Vp8Ig8IrrKQA"])
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
            ..serializableSceneStrings.addAll(<String>["Demand You Kiss The Girl:___ N4IgdghgtgpiBcIAiMoTAEwAQE0D2ArlgNICWAzuVgCoAWMWA4qQE4A2IANCAGZsQA3PC2owAHgBcEIAMoBhAKIA5BQH0A8gHUVAJVVKAggFkFWcgQwYYYNgE8sLGBDakAXjCoTaECVhoGdRgVqfWM1dT1DExksMBgYDCp6NgAHLAB3Ui8sLxhWLDY8AQYXHhgAOhp6ey8WPHSc+igsAAoARwIskq6WZzsASixSMAk8LHQscQlrK2wJXuHhgHMsKDwRiCWGYenMBJyxtABrBlzmtcdxlJSnFzAV0ca8liwUxzKWR2w6tBHSAGNXhAWBI4i8JLYbpUuCAJMCthJ1HFpPMCHBuPNSEstiw5OsMFlSOtyAAZUgCZbSADawAAOiBSFAUsI4SNNMIMPT4PSlAB6Az0zg89TULn0njOcgwQX0yCwMUgACS5AMLmKMoZTJZ6AkipGCoADPSAL6cLB0zXMkE69ksTkIHn8jVKEUKiVsKUauXSh1K8gABX4thgLA1jKtrN1+t9RpApvN9PD2rZHIV-vqIedrt9qJ9QvA0B93JA1HhMAkMjhuvIjEcPhDdHQRmGecTWutIz1EkNJoAujDMdiQ3jMITiST0Bhqf3uDAeGV-hJyAAxYRkin3akWpMdiS2+3FnQwfgSIlgci0UgpchewsKuTee4wSs+MPtyNKAhQABGmd9AEYAGZY2NGcQDnBcl1XFgJ0wchpzjIA"])
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
            ..serializableSceneStrings.add("Skip the Boring Parts1:___ N4IgdghgtgpiBcIDKBrAlgBwAQBcAWMWAQgPYBOaYA5lgAoRk4DOAjCADQgBmANhAG7kAKjAAeOBCCxIAwgFEAcnID6AeQDqSgErKFAQQCycrJSZomzXHgg4rhLEL1aA4nKG7DK1Tv1GkWACsAVwssJnRsfEIAI3JKGgwGSxIuOzQyLD4wABMsAEcgmFCIHLC8EgB3JjsoLAgy8hwAYyDbfDISIKo8ExwAOiwOEBwGKhgcVTA4RBwyQqHZtCoxshkSHLQcNHWmABk0fnjJAG1gAB0QNCgMRpKcdXJsi-gLhQB6PQv2V9UhZ4uuBAeEwYF8LpBYP8QABJJh6HgHUEcC5XG6MO7QsA4KEABguAF92FhzpdrrcsQ8yE8EK8PmCQApflDZoV6RCkS8QAAJCBMNbXHjjGDZABi6QsuxK2QAioULEx6ajyThMdiaSA8SBCcSUWT0RTHlD3p9kQymerAcCkd9wNAORdYbQ+ABPGBkRV6kZY1W4glEklK-X3Q3q430xl-C1AkFsu1Q2EijpQWgdJgYTYetFelVY31a-26rN3SnUzlh00RqGWmOm9nxphaKUkKCZ5U+9UAJk1+IAugsKMs3WsNlsdpKcic+5wYFwuDAmswReR9odqCcA57iyGy3Ta3H1QYGCgxWQLLKisw9HzmxhBThrYXlQoglBom6872hjO5wumEuyOO2RMJOWpAA")
            ..serializableSceneStrings.add("Skip the Boring Parts2:___ N4IgdghgtgpiBcIDKBrAlgBwAQBcAWMWAQgPYBOaYA5lgAoRk4DOATCADQgBmANhAG7kAKjAAeOBCCxIAwgFEAcnID6AeQDqSgErKFAQQCycrJSZomzXHgg4rhLEL1aA4nKG7DK1Tv1GkWACsAVwssJnRsfEIAI3JKGgwGSxIuOzQyLD4wABMsAEcgmFCIHLC8EgB3JjsoLAgsAGMCG0aSbMIcEiwSIJwKKjxbcMw7LHawNAAvGDAAOiwHAgXHFzcPIzUfT38mILJCcowiq3MxkiKwAHJba35CEoBPVrAmGAKZhqLZjhAcBioYDhVGA4Ig+oUfn00FQAWQZCQcmgcGgEUwADJofjxSQAbWAAB0QGgoBhyH8wDh1ORsoT4ISFAB6PSE9j01RCWmErgQHivFmEyCwTkgACSTD0PExMH5RJJZJKOBFFOFAAZCQBfdhYAmy0mMBVUsg0hD0pkyhTs4Xc3nSjgC6C2umipi0PgPGBkGXEvXkxXKk0gNUgTXawne+UUw3Gp2M5l2kAWjkB618+OCx2EsUAMTIJCgtFzTAwSK9cv1FKVOFVGq1OvD5cp1OFsfNloD4NtrPADuFAAkIEx4SSeICYNkACIzKYzNElbIARUKFiYpZ9Csr1eDtbDZd9UebZvjiatPNTXfTwrFWjnedXEb9VYDLCD6oAupD+rD4YjkajZzlcXfTgYC4LgYAaZgs3IDEsWoXE613A0mwDFs0x7AMDAYFBJwmaYwEXIpmD0Qc8wwEccE7Hc1wpBQgigaIPU3N8fhAsCIKYKCyH-bImEA4MgA")
            ..serializableSceneStrings.add("Skip the Boring Parts3:___ N4IgdghgtgpiBcIDKBrAlgBwAQBcAWMWAQgPYBOaYA5lgAoRk4DOAzCADQgBmANhAG7kAKjAAeOBCCxIAwgFEAcnID6AeQDqSgErKFAQQCycrJSZomzXHgg4rhLEL1aA4nKG7DK1Tv1GkWACsAVwssJnRsfEI+UJ40HBweQgAjeKwSLjs0MiwARyCYCziwGAA6LHU8EiwYfhgwLAB3CDBLHGqMNABjFCwg7AguHBgciCwAEXq0AC969iwWgE9mxaYAfg4QHAYqGBxVEskcMgLN47QqXbIZEjAAE3i0W6YAGTR+SipJAG1gAB0QGgoBhyNtWupyHcAfAAQoAPR6AHsWGqITQgFcCA8JgwJEAyCwdEgACSTD0cTqeMBwNBLRwxNaRIADACAL7zf7UkGMOkQshQhCwhFUhSoomY7G4jj46BSmEkpi0PiLEZUoHcsH0xmCkAskDsrCc9W08GQonwxHSkCitE6iU4qkEuUA0kAMTIJCgtA9TE6ODVNJ5rQZ-p1eoNRsDmr5AvlFpFYp1xwKjtlRIAEhAmDdgUlhndyTwXi07gBFAoWJgBjV0kPMtkcgHGoM4GPm4VWm3irEOq1OomkrQlz3Vk1a0PygBM4YAumcKJcRjd7o9nsX7j855wYFwuDAusxXeQ3h9qD9IzXTfz25bkeA0zqDAwUIXy4VmHps56MHmpXfm5qChBFAySqmGbJbiAO57geTBHmQ653Ewm76kAA")
            ..distractions = <String>["is reading the gamefaqs for this section of his quest.","is brokering a peace treaty between the clowns, elves and pigs. This has NOTHING to do with SBURB.","is engaging SEPULCHRITU...wait no, never mind. False alarm."]
            ..royaltyOpinion = 10
            ..serializableSceneStrings.addAll(<String>["Activate Sepulchritude:___ N4IgdghgtgpiBcICCBjALgSwG4TTABAMowAOArgDYoAWAThmmQCZwA0IAZhRFgPa0AVGAA80CEIQDCAUQBy0gPoB5AOryASgtlIAstPwR02XDADORUpRr1GLA2Cb58p6hjBn8AdwbV8aagT0AObUeLxk5hwYtAS8HPg0EPSmUBAAdPgg7GhJQTBoSu7iHBAUpmwgaMF5tJK8DgwY9aYAMthuQeIA2sAAOiAYUCT8OWBoKvxM-fD9sgD0SP2ss0oC0-0lZTBL-ZCw6yAAkqbqEA68UDsDQyNnaIdjBwCMAMz9AL6s+H3Xw7Sj40mB3miyyKzWCA2pXKVz220hRxOZyYFyugz+AIeaGeAAYcR8vj90bcxhNaFMESCrrJVgdNjCweBoPCZojiBQOGibv87liDviQJ9vv1iTzSUDKQtqbSEfT4csmfsEYckFBJLReJ53BSFaLMY8EQL3gBdLKVaowWr1JiNZotZHdU3sGAcDgwdCmABi-DaWA63SJ3IBZIprPUMG4mGarhIplhzIOkmoZzyhBy2MZerusjIUAARpbni88UbCSKg3cQwcdLw8xgKAwAJ7xpWspMpmBp3BcjHZ3MF2hFksE4W-EmA8kHAAKmsLjLhieTYFT6Z745z+bnrNew8FZbHYonof6Ojcg1z+BaZBQAGsWyz+u3l53V5mK2MNwOh3iPk6QC63Q9b1aHtBxTEdQUgA"])
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
            ..serializableSceneStrings.addAll(<String>["Become GodHead PIckleInspector:___ N4IgdghgtgpiBcIBCMDGB7WACA4ugJgBIwT5YAKAkqgNYA2MlYAzgA5oAu6ATiADQgAZnQgA3HgBUYADw4IQAZQDCAUQByKgPoB5AOoaASprUBBALIqsAIzSYYzLBAcRcBR2DKD0HugE8s3DAA5hDc+M50dFjogliogRAcAJbeAHT8IByhQTAc2mBwiIIQdMxwAhzcSUE53Ere+EnJ3swAMkmiSWBB8gDawAA6IElQrDxZYBy6PPhD8ENqAPQmQ3wL2hJzQ8WlMKtDkLBbIJTMBhAemPvDo+MXHEwcxwCMAMxDAL58WIM3Y9wTKYzY5LFb8dabBDbEpla6HPZQk5nC74K7gv53SaPF4ABhxn2+vxG-0B0zCIOW1zUG2OO1h6Phx1OChgdEE12JmIek2O+JAXx+Q05APuZNmiNBVJpiLpCLW4GgCPmJxMUCU3HQAHcCuL5cLAdjEXyPgBdDKVaq1eoeJopFitFF9M0CGCCQScZgAMR47U63T6RNuIsmYuOCguTV8cMVxyUAAsLjkFFknuj9fc1ABXKA2bgvV5442EoVB0nAxE4KrMDhYVowUSs6NHRHxxMwZOJDmljPZ3P5wsEwUY4NA8mIlTSdhVGBgVByg4xlsJ7rtlNdkk9nMwPOIt4D-nF4dlsfKkx0VBxmBQKMMxfK1srjupvXdyZZrc75V7vGDwMbkPlsqChIAAqgYSC1jw84Ks297Lkma5pq+HDvn2u4Fj+-LOiArruqgHBej6KLME6-JAA"])
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
            ..sylladex.add(new Item("5 Alarm Hot Sauce",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.ONFIRE, ItemTraitFactory.SAUCEY]))
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session), new SeekRing(session), new SeekScepter(session)] //order of scenes is order of priority
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: 0, Stats.MAX_LUCK: 0, Stats.SANITY: -500, Stats.HEALTH: 100, Stats.FREE_WILL: 100, Stats.POWER: 100})
            ..makeViolent(1000)
            ..serializableSceneStrings.addAll(<String>["Become Fiesta Ace Dick:___ N4IgdghgtgpiBcIBCMDGB7WACAYgSxgGcAXCLAQVRiwBE9UBrEAGhADMAbCAN3QCcAKjAAexBCADKAYQCiAORkB9APIB1BQCVFc8gFkZWAEYwA5njCEsGCwFco5k1gDuEAJ5Zi6dFig3UACyx-dGIsQgg-anMgvEsoCAATLD4bQkD0NiwAB3QnGD4sCDAkiFRiPG4IYiJcAhIyXXQEmABCLBYQUj4TGGJlMDhENggOQjhWYj48Ex6+KXRivHKFwgAZCodxAG1gAB0QPCgcvlIwYlV+BP34fbkAenJ95lvlAWv94dGYJ-3IWHeQABJQgaIoJTA-A5HfinYiAs4AgCMAGZ9gBfZhYPZQ46wi58K4IW4PSFyV4Az5jSF-b5EoEgsEQlj7Q64opwhF0xEABm56Mx2NZMPZ+MJNxA90ezIl5LplNpz3A0Fp4uBEhgHDYkKFJ3Z8OIAL5IAxWJZ0N1Z1FAMlpNl4vl1OVAMB5CgUj4uQGhMVOth+sN6IAuh1JtNZvNFssLKswdtg6wYGw2GhiIQcPx1txNogdma2ZbLgCJEUlq5Hf86VJ-EUehJSAbpb72XI7MY+ACALQo3lGk2C814wt0gAKuXy5ZV+yrNZgdaq2oHzdb465yJ7-NNOOFBYJAMahjwHFLE4B07AtfrC-zxBbUDbSLXvI3-evVrpAAkYCNiP4T5Xq+es6Xo2i5nLe96ruuxoCnm27nEO4pSDYfB8DAZxYJ+36-tKNKngBF7ziB17gSu4rdk+0Gbk2O5ivsGgalUeArP4eBZIQf6IfhQGET6oE3su7Z0l2j69vGICJsmZRphmYKEHGxpAA"])
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
            ..serializableSceneStrings.addAll(<String>["Be Hysterical:___ N4IgdghgtgpiBcIBCMAEAJAngZwC4wCcBLAYwgBsQAaEAM3IgDcB7AgFRgA9cEQB5ABaoA5swAmVVAGUAwgFEAcnID6fAOpKASsoUBBALJzURbKgE58xMuQB00gWhLlm2GKYcFUMTG9QQwYqjYAO5EAA6+BP5izFDkmH64qKi4DqhsupoA4nJsOgYqfNp6hlJ21CC4EATCMLh8YHCIuAQArnA0LUTCtQQyzAFEuEQD2AAyRIxEYMK8ANrAADogRFBhrFVguGqsYsvwywoA9LrLVId8bPvLtBSuZ8uQsNcgAJLYuuSTMA8raxv+XCvLYvAAMywAvpIln91gRNttdi9jqdqBcrggbncfmjwNAcQc3thNNFYr9VnCEcDcC8AIwAFkh0OWFIBWx2BD2mJAKN+CkuL1u5HuuKeBOWr10UBkBGYwUaXPOsLZQJB3PBIChqBhrPhgI5XMJAAU5YQ+QLuS12r8xS82NVargpFUgdgsgQYBBLGwBP59NMcUrdVS1YSNRCALoVLo9Qj9QbDUZjaLzKM0GC0WgwEi4bAAMVYEymM3mOv+evZSO5vNF+JewLwEAA0kRyORyeWEQpWlAAEZm9WQtMgDNZnP5wvRbCpzVAA"])
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
            ..serializableSceneStrings.add("Have a Flamethrower:___ N4IgdghgtgpiBcIASEBuMAEEMDEA20MALgBYBOA9gO4xkgA0IAZgahWQCowAeRCIAeRIYA5hQAm9DFRIBPDAEsAzhlK1MSihigBXAMbCmCsphjoysmeoB0GAMoBhAKIA5JwH0BAdTcAldy4AggCyTtIUYADkRBhKRBQADqokmABGOmRgCmAi1nnWDCBEEGQixAJgcIhMEHhKcIxEZAoiZWQOEeIKRAoRSgAyCqjZIvwA2sAAOiAKUAnsxWBEXuzi0-DTLgD0gdP0mwIc69M1dTB705CwxyAAkkqBeEPnDNOz82SLRLdLNwAM0wAvlIpjM5gsIEsVmQ1ghNjsLiAXIcbqd6oiri8NnclL5IeIKFBEe8IUsfkQbgA2IEgt7gz6Q5arG7bXavJEouHMWro9mYm63QJQByUKiVWH7MEfL7k-40jCgkkMqHMrkABWotERyKOXKaOhekv5XI4JTKRDsxW+SgA4iYIERaBwSJDgtlDXTpYzZVyASBAQBdQpNFptDpgLo9Pr9fHjIOMGBMJgwPREJQ4diDYY5caK+lfaGw7GsjGEAVgOIQADSCjweGJ+cZLh0UFSWt9QPjIETydT6cz+KUcf9QA")
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
            ..serializableSceneStrings.add("Declare a Thing Illegal.:___ N4IgdghgtgpiBcIAiMDGAbCAnGACCuAKgBYCWYA5rgJLrowUToB0IANCAGaYBuA9lkIwAHgBcEIAMoBhAKIA5WQH0A8gHVFAJSXyAggFlZuUgGdcABxyjRAT1wmArjlxFdmgOKzCOg8pXa9Q0ljM1I6BiZmFxIYOwcTPAJOLAgwAGt0OLAE63RyKmg+BzBRXD5OXApis1SAE1wRc3Q+E1IeGDNRPnxzJrtRYjxajpgsdvqAK3jRUlQYKPYQUWwKGFEVMDhEUSwHOA4d0gpVrGk+MFrSGfOTABk2-IkAbWAAHRBSKHMBZZK1AVq73g73kAHpdO82CCVIQge9OEwEpD3pBYHCQNQTLo8u1kR8vj9UqJqCV0QAGd4AXzYuDe+O+WF+on+WEBCBB4Lx8hh6IR6CR7BR0Bg6MxmjqfCgeM+DKZJNE6IATFSaXSZYS-gD0WCIYKQNzYeyuIiRXrUabgRjdFBpFg+AB3TZsqH0jXE0lGikgSkAXUWh2OozOFyupButzqzzVBMZRJZbMtOq5PKNfIFLvN6MIKzWmPkfFEKBMOz4Nhgzve6tjJXl5JVtMrMaZ8e1nL1Bt5JrxmaN1GttodTulTaJtc9VL9HBgnE4aFEJgAYgJ7jxHogXo3ZXGtUak2bhaLsssANJhdDDrcleQOKAAI1Gde9k5A09nqHnS6wEYuJijm7dLa7m2GYHr2R4QAAQs09oAKrmBebrXneD7jk+3pAA")
            ..serializableSceneStrings.add("Deputize:___ N4IgdghgtgpiBcIAiMAOBXALgSwF5wBoQAzAGwgDcB7AJwBUYAPTBEAAgGUBhAUQDkeAfQDyAdQEAlQXwCCAWR5tS2ANYwAzm0wALGGwDGWNlWJs2dGRIDiPOtPlDhU2Qo4ByTQCtsAIwB0bAASegAmaFh4Glq6UFpUbLqkqAlUpCFsPhD6KtF6OGGaJmxcEgCScqWyADKcXACqcn4gRJgQNADmMJjCYHCIxBCk6oQgmDTY7Z00XFRgIdg4s+pV2BTYYO2sANrAADog2FCotK1gmKK0Ifvw+3wA9DL7BLfCdNf7Y+gwT-uQsO8gUrqGZHCBgbCzH4HI4nMGYUpnAEABn2AF8CGw9tDjjRTudLgD7o9mi83gh9gMht8SeBoNSboD1DJlBRqc9sbCzgjMMi0RisYccXiLjQruSQAApdDqHD6NmkgGU4ZQv70-aBCDqbkwGgaTBcCCYGDtWgATyhgs58MR4pRIFRAF1mqNxpMdTM5gsIWBlmCQtsnUQYMRiDB9Jh1AAxWgrNYbbYCmG4uEisUMokqukAuQQNRydbei1JvF8dBQHw63n2-n7S3Js6pgEAIT0EDYKAwmFN8EEvbYfAALKV2iF2tp2ph2qhsE39KUm1w5DIeJG6k2eABNGT6LjoGRVdoSgftGRI0oyABa7SQG4Aik29wBOdo8AcyACOS8C7Vv2AA0u0chUEgXAyHU96mjI7QAApUE2ACsMjCFQ2AyBw75-jwTZNvupRIHUy4AMxUAA7jIuDvqQVDWGhhGoAOIQAEzEHIABqt5VKBXCmhuVhVHIUAyIEcgAByyCoACMt48KUojtHwF4+Ohkb0fIPiiAAbEgVADjwaFyI+kYcDAElQNoEBIhYJFNtBGlUDIpTwQOjHtNYG6lDwUDCEgSBNhAMDjhA74nqx2Abjw76viRG4gQokYSHUEh-tgchyJGMhWPBECeHIBonlwFB0AOfBpXBCkSO+MhNhwfC3j4niRaUJGYDwjEiaxXAqAOclNkiF5cC2njQXUr5UBJ+iRlwElZK8EhNioADsEmeIEuBIvBxAXvBckyKaTY0Lej50KQZGMUyQkSFVEzCFwG4ABqeFVPAqHQ+G3tBP6YUJVCRjwSAcDIniMHIJEDnUSC4KQEhVO+EwXk2G6Rtgt5VRKVS3iJVhNnUXCeAOA5WO0Ik8LeHDPaagQ8Ceci3ueFDtOlSnRSRpQdRu+gcCoHDYKawg5be2jqBI+gxXQXAhH+EoQBwmBIKUVgSFQwEcHVuAANR1Kai4A3+JH6O0XAaUw6AhKa2WMTA6DGQtjGscQSJ8PBTYMzIVCMHQANIJ5TYiRQgnEFQ2gALQqEgEnEHQpQhEgfFIPBtOMTwrFIDIEmMJ4VRUIEVQDgDauRnw0EWDAkbwa0f7BhpvClCJ6XLhefAbiolgnrgMgQI+FA+IEHB1Jgf4LVYViPqQrFUEpTaMQRmb-OKVirDA26LGARZCnCpblpWtpooGIDBqG4ZRjGfrqAG9pAA")
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
            ..serializableSceneStrings.add("Deploy Democracy:___ N4IgdghgtgpiBcIAiMAOAbA9gTwAQqkwGMAnCI7EAGhADN0IA3TEgFRgA8AXBEAZQDCAUQByQgPoB5AOpiASuJEBBALJDcAazCYA7gGdcASy4ByA10OxcXTLjkBJPuoCqABVwQA5hENg9XawALGFxCSBIiQOwAOlxcViU5AHEhVkVVCUkFZTU+XECIAwAjGBgwXExGGBIuQJJdMGjqEC4IEk8YLkkwOEQuEgBXOBp+w08OkgFMMAATY0NpvQAZQ0ZfT14AbWAAHRBLVBZWsC5pFhm9+D2RAHolPapryVZLvdoIdD0YB73IWFeQPY9Ep0KtvtQ9gcjhATvYTgCAAx7AC+VFwu32UEONRhp3OAKUIgAmj8QCJngD3p9wY9wNBwVdAXoBG0IKhyDTIVjobD4Qg9kiQKj0Vzscc8SQLvyyXdSeSXtKqV9SX8GXsABKFAT1HRgUlQnG8riIlFojEG8VnSUA273CFkinS-pDFX0gFAvgwdC0fXcw1cOHG6WC4Xmv2W-HS21yx2MpWcun-aX2JRQbUNGBS2kW3GBk1CgC6zVG42qU1m80WSxhMy2RZoMFotBgRC4egAYiwVmswBtENtRTyJVLGdH7ar3X5WgBpQzodC+sW4kQDKAlEj55H1kCN5utjtdmt6OtCoA")
            ..distractions = <String>[" WV is distracted eating green objects rather than recruiting for his army. "," WV is distracted planning the civil infrastructure of a city, rather than recruiting for his army."," WV is distracted fantasizing about how great of a mayor he will be. "," WV accidentally tried to recruit carapacians already part of his army. Stupid stupid stupid! "," WV gets distracted freaking out about car safety. "," WV gets distracted freaking out about how evil bad bad bad bad monarchy is. "," WV gets distracted writing a constitution for the new democracy. "]
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCharming(100)
            ..makeLucky(100)
        );

        dersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Jazz","Jazzed","Jazzy"], lastNames: <String>["Singer","Songstress","Savant"], ringFirstNames: <String>["Jilted"], ringLastNames: <String>["Seductress"])
            ..specibus = new Specibus("Microphone", ItemTraitFactory.CLUB, <ItemTrait>[ ItemTraitFactory.LOUD, ItemTraitFactory.ZAP])
            ..bureaucraticBullshit = <String>["needs to renew her liquor license.","wants a permit for a public performance.","needs to pay a fine for singing a song with banned words."]
            ..sylladex.add(new Item("Classy Stockings",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.CLASSY]))
            ..description = "A slightly promiscuous Dersite carapacian, JS is the owner and star performer of the Liquid Negrocity jazz club, famous for hosing the Midnight Club's impromptu jazz sessions. She’s...an interesting carapace."
            ..distractions = <String>["is singing a sultry tune.","is writing down some new lyrics for her work in progress song.","is flirting with a random carapace."]
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..serializableSceneStrings.add("Sing the Truth:___ N4IgdghgtgpiBcIDKBLMBzABAFwBY0wBUAnAVzxABoQAzAGwgDcB7YwmAD2wREP0zop0ubAGdMAExRRKmCGAlyBzMAVEAHZtkHDsmGswDGpUTHErMAKSQA6TEn7YIAazNKJMGOswAjYjAg8WTw1AHcYOjpMZhpMfGJMQ1wUbDRMdEFRbBgwNCwIdAg0LLiYBNFkqFhiAE9Jf1FROz4CGhRiEpoYUMwwLTcYpVEVLDNDCHUCeIEUdVFZXAhSMFSMOQUZulX8vTaO7Fl1FENnPMxSbyyAqDlxCoIfGHRinGZMYiLTUoSWOlJYTChFK4d4QHowKBaFAqGwAHTAAB4-AA+BEAIWIyPhAEFEsRmKFFAZiFB5utFDVmKQ5P5MGkUs1+MM1otxJTqbBRNUUAAvGASBYBRQaNC5NZAvA4CB0AaxZYoRhlUxkmj49BkxUYAJgQwEeSKOjMRWMtQjOIQcQQSSeSYJWDyPKydkAclpolIEg8YDodXdtMGDMwAGk+qEZRJ0A9DY1mKSZq4lPQCWU6WBRCgPJh2Ql8BABeSs1T9J4ooFMJMILq7PCkZja1iwABJMA4fiGfGEp1F8ZgZ16fB0bw+ci9KG61tlwjYgBKAHEAKKEAD6ADlsQBZedLgDy09XG-nSEwpghr18BHGpF0528aRCOA+ad1Chyeh8mUt4nCkTsVBATmISNsG3VQeBoaVTD-bBiCESNiAAYRUKRUhUUQABkFTyHgAG1gFhEBpE0YgnBWAB1VgJHw+B8JXAB6bF8MoGjt0IKj8PAuhTEY-DIFgNiQEbURsUERVuIIqAiJI7Bm2wfiAAZ8IAX1kPDxMk+RsHI4hKIQGj6LElcWP4jiuKoHjoBgfjBOnfVYzEwjWCkmT+IAZgANiUlT8Ic4iNK0nTqJAOiGLMoKjN0-8yEs0LeOiwLBKQCIaHsiTHI05yIoUkBlMwVSfKk-z+OCgzwsCkzoqY8ALKs7EoHgjtVB0yr8vSlZ5KUgBdKCYPQODEIUFJoTTND9RwrrqBgGgukMMQADFWAwxgsMQXDvNS3yyIo-ikDRABVac0UwNDWAq8y+Ii+DFi1JAnFk0KWpWFd-keYh+IARhcrLFPGkBJumuaFv1UQxuyoA")
            ..serializableSceneStrings.add("Run a NightClub:___ N4IgdghgtgpiBcIBKBXMACC6ByBLA5gBYAuAwgDYoBGIANCAGbkQBuA9gE4AqMAHsQhABlUgFFsogPoB5AOoSkk7AEEAsqPS4Azui0wOLXGHzoAJhyMBrHRGLpihGOgAyuAI4pcpnDHwc2AMa4xACetOgA7sGE6ABWKFp2Dk4WRHZ6EFpsYEYmbAxmEMb6mGDeEOSUHDAAdOjoXMpIAOKiXEpqUtKKKupC6AwwMOToqSSYdoRssJoYyRNQbFoADo7VpeXr1RXkIZhU5E7EbKPDELw1dCDEEBz4MMTSYHCIDBV6V8Sp9xyk2abBXDZLSuQzGQQAbWAAB0QLgoMtODcwMRZJxTLD4LDsAB6ZSw2jY6RcTGwt7kPQE2GQWCkkAASS0ynIuBYMCpcIRSKKxHpKLpAAZYQBfcIwzmIjjI1Houm4-F0IkkhBk97sxXgaDqrEMrQAMX8UAAIvpKRr4ZLpXziIKRWLYRbuSi0RwMSqQPKOdhiXTyWbCZrae7GUgiqZphzHVKeda6QBGOMigC6n2++j+ZUBwOcYchKfoMAYgwCxH1nFBuUh4qj0pdbp1QiKwRCHJp2thpEIRXuQhuNvNXOjKOwKCgVH08YAzMmroXi6W9eWw1o8yBhUA")
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCharming(100)
            ..makeCunning(100)
        );

        dersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Zipping","Zany","Zephyr"], lastNames: <String>["Coach","Coaster","Coder"], ringFirstNames: <String>["Zero"], ringLastNames: <String>["Casualties"])
            ..specibus = new Specibus("Sword", ItemTraitFactory.SWORD, <ItemTrait>[ ItemTraitFactory.EDGED, ItemTraitFactory.METAL])
            ..sylladex.add(new Item("Postal Code Map",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.PAPER]))
            ..description = "ZC LOVES the mail, not because of letters and packages (how boring), but because of how elegantly designed Derse's Zip Code Map is. You can find anything so quickly, so easily! How did a goverment famous for Red Tap make something so fast?"
            ..scenes = <Scene>[new MailSideQuest(session), new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..serializableSceneStrings.add("Win the Races:___ N4IgdghgtgpiBcIDqBLMACALgCxugShAMYwDOIANCAGYA2EAbgPYBOAKjAB6YIjoDKAYQCiAOWEB9APJJx+CaICCAWWHoi2CLVowwAczJZc6dG0X4A4sLYKVkqfKWr+WJugjpqLFLoAmtAE90FmIYADpTXCCYCFIUQPQAdzQAQhM2KPQ9FAY8HDxTcysbJ3tHOxdSJlh0AAcmNEwYFlJ0KqMYIKIIDF83ACMYTCaWdDAuTCwUWDDKEEwIFgNMKXHeTBYAVzgqDZQ9AxZBJjBfFEwUE9IAGRy0PV4AbWAAHRBp+pYFsEwkVl83vA3qIAPSKN4UYFSNiAt7ULSkGAQt6QWCwkAASVIiloOSRlDeH1Y30wGJ+6IADG8AL4UdCvd5QT4kv4sAEIN7KJj9eLnALIkCiaHojbbAWo-FAkBsRbLfgLUmkCwsGIjDI9ZRofGQxnMnqk8kckBUkC0+mEpnE-Ws9lS0HggmC4VG0XalHQSVvLH8GC0agColffVkzCUmkAXTmewOzWOp3OlzANx6viekaoMGo1BgREwpAAYqxbgx7k8GYGWf90VyebjMPzHRL0YJNPoYPKIKHHRX9aJNlBBix0QBGADMJup6ZAmezuYLRZT5EQj0j1KAA")
            ..serializableSceneStrings.add("Go Fast:___ N4IgdghgtgpiBcIDiB7ABAMQgZwC4gBoQAzAGwgDcUAnAFRgA99E0BlAYQFEA5TgfQDyAdV4AlPtwCCAWU5oA1mBQB3bGlwALGAE80AYwhg0Ac3TEcuGNQB0aWlt0BXbDHVa0ABxVW0KYm5gAS2o0dmoVI1x0ahgAExhiQLBXTVd4xLBA3ECUIz80bA8YOLQsl1JiW0IQXAhqYxhcAWSEGupHOCJcakDjBup2XNisnLBsABlAiiTjVoBtYAAdEECoL2pasFwhGljl+GXpFAAjQNIs7WWCZe4BWn3l7o6r5chYB5BpbVZa3ABJbBIGIQSx0DSGABqEFIz0Iy1W602-y2HwAjABmAAM2MxywAvgQ0EsVmsaEidtQ9ggbgB6SQvEC3e7UkjQlwMt4wD5-SRQMIROIMhFkwzI3AfXEgAlE+GkjaiilUg6MukMpkfcykdlw8DQLksgGsGAVIVypF-FEsyV4gC61W6vX6gzAw2yuQmhli8ztRASxBgelw2AwNEm0zAs0QC1liIVuw+R1O51wlx1nI+7HBEZgPxBptjW24jigxysaKx2PxPpAfoDQZD1HGnuw3qlQA")
            ..serializableSceneStrings.add("Be in the Speed Zone:___ N4IgdghgtgpiBcIBCMAEBLMqAuALNAygA4wwAmqAWgPZhwA0IAZgDYQBu1ATgCowAe2BCFQEAwgFEAchID6AeQDqMgEqypAQQCyEjAGcc+VEwh7sMM4cwBzVLUNoibOtgB0qVD3wBPVLg5opgDGMGBk5DjUDqIkETR07l4wvkSmBgBGvnhonhoqAOISPOracvJqmjoEkVEAjgCu6EEA1iy+EGGoQRD1emj1YJjmYNjotBAsqGTQENYwriCM2BBcc9jydMImLH2LINhc6NZzXGK0ZOijtHoAMujsNsIA2sAAOiDoUETcyyOK3GR3vB3hJ+CRDqEQu96O8pPIeED3ts+tD3pBYIiQFpvARltgAJJ6fJcGAQcy8fxgABqE3qMFRHy+Pw6BJGmIAjABmAAMvO57wAvvRUG9Gd8uL9sP8uICELCAPQaBlwhFy5gTFGLNHQelqwkaFj3XUwsXMkb4tlq-kgAUAXT2ByOJzOYUuYzAtw6ZGe9sYMCYTBgQWwegAYtw7g8wNZnqLPuLJdLZcCQAAJUksPAM9G6lNiSlzXFkhnxs3YKT1KDpGBcTEAWi5vMFvpA-sDwbDEa9eh9NqAA")
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
            ..serializableSceneStrings.add("The End Is Nigh:___ N4IgdghgtgpiBcIAqALGACAomAJugkgM7oByAlgOYogA0IAZgDYQBuA9gE5IwAeALgmRp0AZQDCmEpgD6AeQDqUgErSSAQQCymdB2gAjRjGJsw6CHrYBXPuj7CIABzYBjCIwCeDwhj5tbwpDUlAHFMJFVNGVkVdS0RdDJTCFNLMG8+PkZEinQoZLAYDgA6dABNIxKANUL3dFT0zOyS1Bhatyg2Qhs9GCyYFgwyPhK1Rg6uotoQPggOChg+WQLBPg5LODpVynmOMRMcIbITQgAZMhZswQBtYAAdEDIoJw4ZsD55Thx7+HuSAHo1PcaL9ZEhvvd6G5vED7pBYOCQERRucYDCHk9OK8+Pg3giAAz3AC+NHQd3RzyxHw4XwQvwBaJIoIRkMY0NosOgqNpiMISmSODYUDRjwpyWxuO5AFYCSBiaT7iLMWKqTSfiB-oD2eqmdzVus0XCuWqiCJevRhRiXmKcXx8USALpTLYUHZ7XCHY4nfnXR10GD0egwZx8QgAMU4ZwuYAo1zJiqtbxVCJEySG7gNnIRYhQyXmIhmtq18axJEsUB6HARAFoAIwAZgdU39geDYYj-MIPtlQA")
            ..serializableSceneStrings.add("Spread Word About The End:___ N4IgdghgtgpiBcIDKAHATjCATABAdQHs1cBBAIwIFcAXHAFQAsYcBRMLEAGhADMAbCADcidGAA9qCEI2ZIAwiwByLAPoB5PMoBKKxSQCyLHAGMCYagEswlGAGcc1AjjTQyfZmZwQKNB01bsAHQ4AJK0tjAwUPbUDBC0scxWcWQW1BDm9gQ89CRaAOIsdLoGqmo6eoZIOHGCzBDG1JQQfHwAnjhkMADmlGAOTl18FjB1OFY4AO5x1KMwaH4W9hAoBMYtbSiWxjhQlFAUOABW+4dLfvF+MG0A5Bg4tqs0Vt2BXCDpaN0w1GpgcIhqGgbO8gRZut80HIzFg0hYzLYADIWQQvKQAbQAuqC0ODIdD2HCEYiMhxEOjgAAdEAWKCrNDpcyEYjU+DUxQAehI1M47LUdFZ1J4LQiPOpkFggukEC+PxCtkUBGoABE7ECCG0YFgxTS6URGdQQuYpQAGakAX04OCpuvpBuZ2oQ7K5OsU-Klwr4oq44ugMCl8q0pIIUB1tLtGUNxqdIAAjGaQObsdwYDweDBGrYAGJEZGosDdDHJkCp9OZnNoEnsWwYm3h-WRh1SxI4GDscb2MDghg6iX+mP6CAAaxgBNs+tsSAgbTDeoZkcUp3mpot2PNQA")
            ..serializableSceneStrings.add("The End is Really Nigh:___ N4IgdghgtgpiBcIAqALGACAomAJuglgM7oBKMEANhQJ7oBy+A5iiADQgBmFEAbgPYAnJDAAeAFwTI06AMoBhTHUwB9APIB1JSWV0AggFlM6AO4QBYYmOlJdJAOKYkOgytXa9hmeggAjPgFcxdCsMbBwAOnQAIRh8MEZ0HD4+WBxWYJQidBhCAAcYAGN8Shp0fwsYMTEKHIyYKHC2EDEzRkrVMDhEMQF-OHYepjaBOT5cfDF8McIAGXweOMZJAG1gAB0QfChcwRawMXVBHA34DboAel0N1jPVJBONjkpCGGuNyFgHkABJQl0KeavNgbLY7AR7MTffZfAAMGwAvul1pttrsIPtDgJjggzpc3iA6Hcvk8KC98R8gacfoQACLJVL40Fo-ZQsSwhFIkGo8Hog5HL4XK7AglEnGcZ5Am7gaCUja-EjopJQRnciGsr4ADjhIER6GRTJ5GP5YsF+MJ9zFPT65JlX1+MhgFA4KrBauhYu18IAuk1BoxhqNxpNpjNFSsfewYBwOIUxIQAGKCOYLeIrfWq3mY7FUmToibUG2fMVyFDotoyFps4UGiF0fxQHwwARfAC0AEYAMyeiMgKMxgpxxMCUO4QjhnVAA")
            ..serializableSceneStrings.add("Learn About The End:___ N4IgdghgtgpiBcIAyMICcwAICCAjA9gK4AumAKgBYyYCiYAJiADQgBmANhAG75pkwAPYghCVqAZQDCNAHI0A+gHkA6nIBK8mdgCyNTGmi52MAM6Z8WCARKZiVTBAAO+AMYR2AT0cnqEM+4B3CA8zYnxbezJsNQBxGjJNHQVFDS1dcUwmTACKcIo-B0xHdGIASxdCTjRMUrBiGDRTUlqIiFIAa1r6c1YI2oBzADpMNTaqarsILFwYAcx6GBhHT3nSk2JCNBn6LLsYD0wfGChbcP6YUhN8WDs5olJ8XtLiQeYQYnRz4kUwOERiNCEOAsAGlfrnNCSCz0Z6lCwmJClLgDEQAbWAAB0QKUoM40B86spePQsfAsTIAPTYLFMcmKMikrGsdw+GlYyCwRkgACSJmw7CRMDZ2NxvAJxG5dS5AAYsQBfLKYkV48VEtAkhBY-hoNClIxC5h0hmatgsg208DQA1kkAACT8kvqjXWkjaMH6vA8wpxKqmEqlJtlIAVmCVPrFfrVGptlOphpAMnpXOZ7FZ8Y51qxvNGDGu3tF+L9jq5ADYS-LFVjw4XCcSubHhYnjTaAUDhRmubzxDB2Kx8766sXA-KALpvUHghpQhiw+FIKaMRCoscsGCsVgwFzEEwAMV4iORYH6aLDBdVdZNO8a1GUpXY7HbVq5knyR5g4g+xH7EbqMkIUBmNAuQARgAZiDOUVxANcNy3Xd9wXEw0THOUgA")
            ..serializableSceneStrings.add("Make A Prophet:___ N4IgdghgtgpiBcICyEDWMAEBBDAFATgPYAOAFjAC4gA0IAZgDYQBuh+AKjAB5WLvkYAygGEAogDlRAfQDyAdUkAlKeKxJRGfNABGDGAGcMhMBgjbCAVwoYKAiMUIBjCAwCexfZgiGXAdwiuhhSENgLsWIoA4qLsKmrSMsqq6oIY1Bi+pCGk3hjaMDAmACb4AJbMhRj6IUUFxDYhtpgOpWDWhHQYrfoQYKUUrqEQ1k2DtY6ltRk51vkUFDD4DRhFjTkmwXkwjoSwphjERGSURp1NQmKSsgqiSfEYAHQ0IBQQ+ADmlDJgcIgU+BY4LR-qV3p98MJjEV+qVjPoADLlVrvBAgADawAAOiBSlAHPhXm05Gwitj4NjxAB6LDY6gUmTsMnYuguTy07GQWBMkAASX0WAY5Rg7JxeLYhIoPLa3IADNiAL7pLGi-ES4n4UkIbGCXr9Vwi8QM7n-QEiznCrUgdhvT4UQSvSX6SL4GDDRb8XoANRcppo2Nxqt6kulloAtABGADMcpAiowyoD4qD6s15JAVJpfvTRstJotdPA0Atab5ghgDDoIsTBKDUoosoVSv9YprRJJ3IzBpzaZZDDZWfN3J5WCgwiIvh+moL1YldYbsabKqTbY1HepXcZlt7-YLg8tfMUvVWUCrLdnIbTACYY-KALrPEFgxaQsDQiiwsAIo+otH32gwOg6G2Ch9AAMTYRFmGRH8EzPZN20tHU+gGM0i25YR1k+e1hlPQM2nECwoHyfBuQjaNG3jZs8IoFNuVAl1MDkUoGAYVCuUtDDeiwh1cOXCgCKIxZSKjG9FxneDV0tTsBzQy0UHQJBWg-XjW34wjiPnONYOo2jLX4TBRFfDA+QwcRQVIeApCs0yABYeXeIp3lId4KHeYhSgAIUcYcAEcsHhSIsGELBdiwAApCx3lQd4kAAdkIDzXAFd4ZAATUId4sBlYcAC13gAEVSgBFDyLCwABOd5RAAVh5XwsBgfz3igRRiBlLAcqK-LhCgURiAKgA2Bqup8gBVKr8EEQQsCKorhFcKAig8y9MoAK0UVbIjC-RfAG4QAAl8FSjyAA1cAsVbYuEYcPIAL2O1brt8YQYHyzJVuqihtF8Yh8tGhgsH20CkDC0DPXESJPVQT0ikEGVFCKfKwvYYRQPEeEkEiAAOABqXBUBy0RWiKwgcvhLBUvyzKBqKLAPPEHkuAAaSwcRRvhSMilA9gZVumRXEEcMPJmVx3kvIrSH0crInm1LQPeXxXFwUgmfDRR3gGixCGCIrcDBGQMPeHG5CK+EPL16r4RkfLiE9VwwCgGQkEUJBvO0Hl2CKzKcqQUgcp2kqKFSrAsCKUR8p5Qgwt8Gz-fy6rqv4LhYpx-aLGm-bCHDXBnHhcrCdIZhmCKAbImq5hw9i4gPNSg2ituRQLEcSmDtQcqZCZ3G9cjd5ShD27IyCnHxH2oqikjRRbtcLh9pjk7fCK5hfA8iAwsjnlFFQJBUplcRCH0GR3h88R3KQHlBCgQRrdS0b8o2n7XDkLgLBkaqsFA1LhEEDzSggdhYtKBjOQTMfLsEEHQTyoZCD5UvDAHyi1bqegsPoGUJ1hAWDkD5UowgwowGYIoUgihSgnSgEzRwJ0uBY1GtNeExB2DwhvvtHKsU0H7VSjZMAdAwAnUUOGGUkR8oyhgArHKlCvZqFGrHXwFhg5Z1umFUoPkvpcE9Dg0QAtIixXeOIMAG9UqkCKq4EhPJSBQAoD5cMWMIBcDCqIfQo0PIDX2hEd+hAsB1Q6g5UakZKqvVSqlVaoYz64AoAwIqmZdyyTTJEIUWBHDvmMCpCUAkNKWhvH+EAAEgLxLAhBI8+gfz3nlEAA")
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
            ..serializableSceneStrings.add("Perform Surgery:___ N4IgdghgtgpiBcIAKMBOAzA9qqACAygK6oDmaAniADQjoA2EAbtgCowAeALgiCwBYwCAYQCiAOREB9APIB1CQCVJYgIIBZEbgAOaLDgDOuCNogBLMOkJ1cdTJgDW5krlgATUwGMI1rakweYV2JBTDBcTgFcFhUFAHERFmV1KWklVQ18XAB3UwjMQk4XGH19J1xCLQA6KIFyXH0YGDxOTFwAI0FzdphOTjR6vggdXDBMLMrqEE4IUh7pMDhETlRCOBpl0xIyVCFQ905TUP0AGVNGJx4AbWAAHRBTKC1sabBOWWxXO-g7sQB6FTuVB+0hYXzu6G8DUBd0gsDBIAAkvoVHQzjBofdHs8IK8Ea94QAGO4AXyouFumKeqBebw+8L+AOowNBCHBkPRTPA0A530R+gUONcmCgGIeVJpeM48IATESQKTyXcxdjXu9UJ9WSAGRixCD4ctVhjYTy7kj8DA6OhRVjqTjOJLCSSyRTlbbVXTNUJiKgYK9cAAJGDeCI6vWag0coFcuGalgzMicfDTe36WI+iB9VD8HFqcyRpU2iX4zVy4kAXUmGy2aF2YH2hzAJ0FVwrNBg6HQMA8nH0ADFsKdzmASFcXYW7WqNbyvagfX7A8G+EbufChINhzAkxnreK7WJCFAOqh4QBGADMpdbIHbne7fYHgv0LflQA")
            ..serializableSceneStrings.add("Mess Up Surgery:___ N4IgdghgtgpiBcICyMDOqAEBVADhgygK4BOA5jMQJ4gA0IAZgDYQBuA9sQCowAeALghCcAFjAIBhAKIA5SQH0A8gHVZAJTnSAgkkkYIfPjCg4+mPmww4K9DlAyoS5KhjZgMfURk6bVAcUmcGtryCupaOvh6YAAmGFAQANZo9mywGMIcxACWAEaMYlBZqHyJMAB0BKkwGQDuGFl89nxZjIwYNRwJqBUiYt5+AUE6imHBkYWkwo05YvQwMIxZYKR6GIsG+RgzBhQ0W4SNHjCUAOTEs-OLyxjE+qLEKedltCAlZDB8CmBwiHzEhHA6H8sqQnOJXNEGllXKgADJZFhLUiCADawAAOiAssYOCUwHwlBxopj4JjpAB6TSYmhkhScEmY+gQRioGDUzGQWAMkAASVQmkWLDZtEx2JwuIg+J5+O5AAZMQBfPYYrE44h4glE7kUqkikDSOncv4A9ngaDC0m81D4Bb0U1iiVSmUITHykBKjAqh3qyWa4jEl36ymmg30wNMlnCmlmrmBvmqSXRVL2tUa6V8bkAJjdHq9qd9hP93PEJHO+IwAAkYMyPCHDYHjVGOebuZwIO8+PgSnw+b5zvoKCJJUglk3VeKfU6M4GcwBdF7A0EUcExKEw2GJ1HzugwehzADGpgAYhx4Yjlqi8xONYWA5aqzXhKbORbMeJhJLyF39Cnr77pIQUAzMQ3IAIwAMyKsqor5vit7ckgbA5C0DSUM+LaBu+n4wN+07Rt6GoAUBFDcgAtBBc4vLuB7HqeiaoFu7pAA")
            ..serializableSceneStrings.add("Perform Weird Surgery:___ N4IgdghgtgpiBcIAKMBOAzA9qqACA6jAJaoAmuAygK6oDmaAniADQjoA2EAbtgCowAPAC4IQvABYxKAYQCiAOVkB9APL5FAJSXyAggFlZuAA5osOAM65zNeqga5MYXEMm5eOjQHFZvbfuUqWroGFLhEThC4qBAuaLikROZCNABG4bS4UBBgYGgAdATiROxSsW4e3r7BAUH+oYnGpjAAxkLs9ujhUkbiDOZEzRDs7cy44tzpzpi4AO4xzeLOrhRyiqrqsrUGDibRQlKOSzB445Yl6EJHeHuSqLhUYDMww5kwYEJD7XksIB90MEIVLlREJUFQ4KxQURaLZpI4EkIiI5zAAZIhcdKiADawAAOiAiFAjNgPu98NhSPj4Pj5AB6HT45g0lS8Kn49BDcwwRn4yCwNkgACS5h07HR3JY+MJxNQpKEgveAoADPiAL6jPEEokk7JCclkAV0hmSkDyFkC0HgnngaAS6lC8wUZ7oa3SnXvBVCZVqjVS7Wy3X6ykIGn061m1khticiVMm38qPCjTZUiYKCu-1yz0CgDMAFYfbhNW6A2SKQLpDRUG9LgAJGBDFzh81Ry2x3m2gW8CD-IQUD7y8yeasxNASbJ6LoZmVZxVRlUgVUAXR+UJhaDhYARSLAqJT2JXrBg6HQLSE5gAYtg0RiwLRscXM4Hy1HK6hq+9cPXG+JrXy7fi0jjHeMD9jE07ukI8hUFAKRoAKACMOYLuqRZ+jOz4GlGFDZEQQgMH+navsB9BgV6JolnK0GwfBUYALRIShh4gMep6tJe14puYB6LkAA")
            ..serializableSceneStrings.add("Create Generic Taxidermy:___ N4IgdghgtgpiBcIDCAnGEAuMAEBxGYMKAlgMbYAqEAHsQCZFQCeIANCAGYA2EAbgPYoKMahgQgKACxwBlJAFEAcvID6AeQDqygEorFAQQCy87KTSYYAZ2wRsGGvUZNs-DjewMIdUxBQQADhCkxBBgAHTYAJJgHvzEYADm2Jb8rHbSzlzoKDG2XMQYGFnYAEYF2FCCOBAl-ACuGOk4AO4QzrV0xFbYzYIA1jZg3pL8zXb8Lv5EFi4xGNJQYWwg9igJMBhqhOIYKHVw7LvECesoSPxDBcQXlgAyxLzxCeIA2sAAOiDEUP6C9mAYDSCOifeCfRQAen0n1Y4LUFFBnw4EC4lhgMM+kFgiJAkUs+nyvHRbE+31+KH+GGiGBxAAZPgBfNIfL4-P6hQHAnGQ6EkkCKeE45Go4mw8DQYlg3GWGQwLgcDGs8mU6l0xnM0lsikcoEoEEIcFQxUChEGzgotGKrGSz547ShOj8KCKsnsgGqs0AFnpIAZAF1lkcTkRzpcMNcwHcHa8A+wYBwODBSBhLAAxQT3R6JV4s13agG6-VS+TUKYkAikUWYiU4pCSULrGT2Gl8vOUxR1KAlIg4gCMAGZGbGQPHE8m0xmHZYY76gA")
            ..serializableSceneStrings.add("Study Corpse:___ N4IgdghgtgpiBcIDKAXArgEwJ4AIDCA9gE4AOAznADQgBmANhAG7EAqMAHigiCwBYw4keAKIA5YQH0A8gHVxAJQmiAggFlhOMugwBLGGRwp+OAMbFyAgjUPGWy+QHFhLJWslTFK9Uhw6wOYgwYIkMCHEYILTpcPxMiGEiBIxgdEIBrMAIAdzoYDABzS2tYXRM-AQgwDBsBACMCbAA6EGoUCCJClCkwOEQUIjQqEH6dfMKiQiqdFB0CMDIAGR1GP3zuAG1gAB0QHSgSYjawFBlAnfgd0QB6ZR3KS6kWc53+wbudyFhnkABJMmU6MsYO9dvtDpUUD9jt8AAw7AC+lBw21BByIRxOZwQlxuINEj2+r2BLQ+0GJF1+ZCQMDoNBBezRGKhKFhCKRKIZ4OOpyIGG+11uJJA+Ke2NoEDoFBBn3JOz+8kqGAIUHpYPREOZ3wA7ABWBEAXRawyIo3Gk10Mzmi0VG0N1BgNBoMBMKDIADFiEsVmA1ohNjtOeruViKXg0ER4sccAAJBJ0IzSsnfPC8SqFVAQFlCwMY0RoKC1YLfACMAGY4SB4XaQA6nS73Z7FWRbZWgA")
            ..serializableSceneStrings.add("Perform Bizarre Surgery:___ N4IgdghgtgpiBcIAKMBOAzA9qqACAQgJYBeEqqMuAygK6oDmaAniADQjoA2EAbtgCowAHgBcEIfgAtKVAMIBRAHLyA+gHkA6soBKKxQEEAsvNyYADmggiYAZ1NhcI6bn77tAcXn89R1Wt0GxlS4EGAAJrgARky4NpiwuJyY9IQAxripEDQ2to7SeCKYuPRF9BCEDnEJNGCQInQQnLhmmADuaDYAdC7Orh5ePsbqAb7BhHap8WacMNacMZLYqITohDBhnWwgImSMImpgcIgiqDRw7CeE9IyospjhhCKE9zYAMoQ8FfTiANrAADogQhQFqoHZgEQabBhQHwQGKAD0+kBrHhan4sMB6EaORRgMgsExIAAkjZ9JwPjA8UCQdhwSJiRCiQAGQEAX1YuABNNB9KhqBhCHhSOpinRROxnFxbHx0CpQpJNiQ3CYaGpwN5oQZTIVrJAHK5gI1dK1-MFcJAiORMst4oVJzO1IJ8otpKoME46HVtLBWsZIhZ7M53ONvohZqJVtFdotkulqPAcqJpO0oTC8W9moh-qJABY9QaQz6+dDIyKbWKMQq4-KE87k-ooLJUG1DoKE6H6TndeyALpbS7XNB3B5PF6vNO-fvsGDodAwVIiGwAMWw70+YG+iD+RuLptLCqjNvrCsMEAA1jB3Jgwvw1qhMyaIYoaFBImqe-rg7us5CDxaqFCR4mCdJMFVkSRQkYKgdgDG1Oy1F83w-C0AFoAEYAGZmQLacQFnedFxXNc0xsKd9SAA")

            ..description = "She knows how to fix your arm, sew your wounds and how to preserve your corpse. She is good at taxidermy. MD is your friend. Sometimes. When she’s not killing you via malpractice."
            ..sylladex.add(new Item("Bloody Scalpel",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.BLADE]))
            ..bureaucraticBullshit = <String>["is getting sued for malpractice.","needs to refile her permits for all those taxidermied corpses she keeps.","has to renew her 'medical license'. "]
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
            ..serializableSceneStrings.add("Mash A and Keep Punching1:___ N4IgdghgtgpiBcICyEDOALABAQUxMAJpgNIwwAOmACgK5gDG6AlmAOYCMIANCAGYA2EAG4B7AE4AVGAA8ALghCYAygGEAogDk1AfQDyAdS0AlbRuxI1meiLC8mBGGFn8AnphaomqWakyyRfugwmJgS2EYA4moSpuY6uiZmFkqBELKYqADWTOTkLKx4-PyBwQRMEPwirDTB+EQYIiKy+ZgwQjBiLrLMbKnpXmAA5P1QUHTB-pgARjRFMD7uvg52YEyyMK4lmADuEG6TqORkRGJ0gV6YrNAwAHSY+kFgW6HhUTFJ8YlxKeQiLAsiGjpbppEpuCBiRzDVrtJ6sebNXoARxq3kwkN2YgIqC4IVUmnihjUXwsO2EMF8EF2+yCTDEVhs9A6YF82zWWAgmAEOXI+HS9EETCgfUwwyCl2umHQaD8AXoaUYmBolDqlyY7UwLkBGWY6TajlkNAqrkGN24IFkEPhsl0YDgiFkpzgPEdTFY8LEKhsZWaNlQABl1fkFABtYAAHRAQt+YktTn04gIkfgkY0AHpsJGuKndBJk5HeBVUDAs5HILB8yAAJKobD8dUl7iR6PiOOyKtOSsABkjAF9cRGo1AY22E1jK+nM02QBpc5XHTVS+BrpWABJoL3D-jzGAEABidO8-rqAEVUT4ly3Y3yO7Ju32B83h62+WOkwhUxml7O8x++EXG2zZcKz-GsqEEFwOkvZ9rycW97xAftMEHK9R0TCcv2nH9K0LfhiyXctGxTatUD3MQRCgAARDp8OnVCb07P8e0Qx8hxHV90L-SdvznP9cNooDCMrGsjDqCjoPYuDGOIgAmZjewAXXNV13Q6L1CDWJg-WPQhQyUngYF4XgYHoHw93EQMhGDRAwyfSTZDfDCp0Elc-xQMRMgPMRvDPCkfGwVBN3Ibd1gkl8nA0GgoCmKCmL7fSQEM4zTNIiy6lQPTEKAA")
            ..serializableSceneStrings.add("Mash A and Keep Punching2:___ N4IgdghgtgpiBcICyEDOALABAQUxMAJpgNIwwAOmACgK5gDG6AlmAOYBMIANCAGYA2EAG4B7AE4AVGAA8ALghCYAygGEAogDk1AfQDyAdS0AlbRuxI1meiLC8mBGGFn8AnphaomqWakyyRfugwmJgS2EYA4moSpuY6uiZmFkqBELKYqADWTOTkLKx4-PyBwQRMEPwirDTB+EQYIiKy+ZgwQjBiLrLMbKnpXmAA5P1QUHTB-pgARjRFMD7uvg52YEyyMK4lmADuEG6TqORkRGJ0gV6YrNAwAHSY+kFgW6HhUTFJ8YlxKeQiLAsiGjpbppEpuCBiRzDVrtJ6sebNXoARxq3kwkN2YgIqC4IVUmnihjUXwsO2EMF8EF2+yCTDEVhs9A6YF82zWWAgmAEOXI+HS9EETCgfUwwyCl2umHQaD8AXoaUYmBolDqlyY7UwLkBGWY6TajlkNAqrkGNwk4pCYUi0ViFj0JLUKQu0qELVQIlgmAIgKmPhu-u4IFkEPhsl0YDgiFkpzgPGjTFY8LEKhsZWaNlQABl1fkFABtYAAHRAQt+YmDTn04gIxfgxY0AHpsMWuPXdBJa8XeBVUDAW8XILBOyAAJKobD8dV97jF0viCuyEdOYcABmLAF9cUWS1Aywuq1jh43mzOQBp28Pu-xe-3wNdh2OqIIXB1b3Py3yl7JVxut7Pd-OfIHjWCD1k2t7nh2oF8D206tneQ7QWOABiYgegAIh0N6nu+C5fj+ICbpg264UB1ZHuBp6QcO0Y1Leg7TnWIAABJoCmu78PMMAEJhqwAF6OJmdQAIqoj4b4AR+Tj4dBa6EX+O57mRh7QceEEXtBV7YfBDEPqgRh1B6ElKdJy7QewcnrgAuoG8aJh0KaEGsTAZkJhD5jZPAwLwvAwPQPjIeI2aumw+YkZJ+7kaplE6fe0EoGImS8UwAlgKJFI+NgqDseQnHrMZgFOBoNBQFMr6yRunkgN5vn+aggViG52IeYRQA")
            ..serializableSceneStrings.add("Mash A and Keep Punching3:___ N4IgdghgtgpiBcICyEDOALABAQUxMAJpgNIwwAOmACgK5gDG6AlmAOYDMIANCAGYA2EAG4B7AE4AVGAA8ALghCYAygGEAogDk1AfQDyAdS0AlbRuxI1meiLC8mBGGFn8AnphaomqWakyyRfugwmJgS2EYA4moSpuY6uiZmFkqBELKYqADWTOTkLKx4-PyBwQRMEPwirDTB+EQYIiKy+ZgwQjBiLrLMbKnpXmAA5P1QUHTB-pgARjRFMD7uvg52YEyyMK4lmADuEG6TqORkRGJ0gV6YrNAwAHSY+kFgW6HhUTFJ8YlxKeQiLAsiGjpbppEpuCBiRzDVrtJ6sebNXoARxq3kwkN2YgIqC4IVUmnihjUXwsO2EMF8EF2+yCTDEVhs9A6YF82zWWAgmAEOXI+HS9EETCgfUwwyCl2umHQaD8AXoaUYmBolDqlyY7UwLkBGWY6TajlkNAqrkGNwAOmALRJxWFItFYhY9CS1CkLmAYBDNkyxLIICwRd0LtLfFMyE9OZDjS5cZGim4phAiPYPTduCBfWJ4bJdO6FLJTnAePmmKx4WIVDYys0bKgADLq-IKADawDNICFvx9fP04gIbfgbY0AHpsG2uIPdBJ+23eBVUDAx23ILBpyAAJKobD8dUL7htjviX1ONdOVcABjbAF9ca321BO0fZD2savh6O9yANJPV7P+PPF+A1yrhuVCCC4HQAQeXbHqeCBtheIDXpgt5QY+z59nBn4jgBX5Tphv7-h+y67gO66oAAYmIIhQAAIh0hHjneD58iesjnleN77veh7dr2r7YR+uGrvmNQAcRq4ABJoBW978PMMAEFu-C1nUACKqI+JB3HQbIrHsYhnFMTxTjofx76MUJ+FzrujHiZhG5GHU1FacxMFsZhABMCGXgAummxalh0FaEGsTA1iphDNn5PAwLwvAwPQPjkeI9ZCI2iAtlxrlPnxmFvmJQGYSgYiZEp6kUj42CoDJ5ByesLnGbIGg0FAoZiPpvlprF8WJRRKV1KgUWIUAA")
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
            ..serializableSceneStrings.add("Provide Blasphemous Frogs:___ N4IgdghgtgpiBcIAKAnA9gNwJYBMYAIAhAGwgGcAHACxijQFcz8AxdAczJABoQAzUjGhQAVGAA8ALghD4AygGEAogDlFAfQDyAdVUAlNcoCCAWUX4A7hGISAXjCYosbKhPz0K+CWk818+YYa6AOKKwgYm6hr6RqayFlgSVPgQ+ADWYGjmWGBs8WCpyWA4+BTEaBRMKYQAMoaySAASisYaAKpxSK26SNVmzLoaQfiOzq7ZXj4wWCj4pBQAdPjcIBIQKGwwEhpgcIgSKPRwPPtOGyjyaEUJWJdk1VjYOdIA2sAAOiBYUBRCq2ASWiEOA+8A+sgoEAAxjAPlwPsoNMIQR9eFYyDDuB9ILBkZ8yIZKDBIRIkKQAJ4wFCwj5fH4oP4SACS-1xAAYPgBfLj4d6fb6-CD-QEoYEIeEAekM1JACKRYr4aIxcPA0AxoJAjLIQUcUAAImtUtLaQL-syJGzOdzecb6YKAUCQWB6MRiMrZbj9odpdi1R8GuQkPQUKUYKw0GwjfzbaaWfL2SAOQBdZYnNhnC5XCQ3MB3QU4F7JngwXi8IkSMjMIT3R5sF7WqMM4Wi9XKSXe1W4oIPUPsSN0hnKehQABGlItCcLIGLpeJFarec4iGeyY5QA")
            ..serializableSceneStrings.add("Corrupt the Players:___ N4IgdghgtgpiBcIDCB7ATmgrgBwC4AJcALGfABQBsIBPGNAZxABoQAzKgN3QBUYAPXAhD4AykgCiAOXEB9APIB1aQCUZkgIIBZcflYBLSBQrV8RCPUIl82FAHc6p0mYv0UmAOZECrdPlf4KFDB3ADp8dXwAEwg0AGtja0w0bApSCCSIfBgwDhhA7BgLYlJudWUAcXFuNS1ZOVUNbREwuSJ8WnowgAk9CyhzXDoLWz0jfAAjUn8UmHMYSJDmEFwY9xhcOTA4RFYICno4Flw0PXc1tFQwSL1cPSD6ABk9DgN3IQBtYAAdED0oGzQKzAuAU6EiP3gP0kAHp1D8mFC5NwIT9dvsYPCfpBYCiQABJdRQJBoOxbcHMH5-AFA3B44G4gAMPwAvkx8N9fv90DTQWhyZCQDC4RTBUjccdMBiRdipQK8fRyicoAARGKxTGc6kQYF03CMllsjlU7nakFg3FCjWSMUIVF7A4amW4+WUGh0DXGwGm3X6kCs9mUrle4G8-lQ2FWm0CtEO6XQWU-eXKbWRFBQD1Bmk+20gABMAHYWQBdJbHU7nS7XW73B4pj4llgwVisGAAY1w9AAYugni9gh8jZnTaGLRG4zic4q-qq4qgMDhq2AM1rgZJMFBJmhfcyGyAmy3212eynGIh3iXmUA")
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
            ..serializableSceneStrings.add("Run a Bakery:___ N4IgdghgtgpiBcIBKBXMACC6BCEDWMATgJ4gA0IAZgDYQBuA9oQCowAeALgiOswIJIA4gFFmAfQByfALLCxAeSSSZwgMqZCMdABNCEAO4YAlhgBGxdBwAWWgM76YMDuluxq1dA0rpT+EwHMfTQhtTDBQyk1bK3QABwhbDkIjGFsAOnR0VQBhYQk5eQB1fKUpWXQjW3RIlPDqCwhw9ABjKwgODgaqmxciOlTLGygyMNCTOiMOAesYKEsGFoZYHwhmvBclrQ4jZY4F6hgIQgw99Ch8LQAJBnr0AAUEpJT0zPQASQ4AciqsTVo2AJBQ7rSJLQZaKwoRIHUY+KEcGFeHQQIy3ahGSgwNLkEAcI7+JzyMBwRCUCDUWxwChPfwEwjZBjhSZGRm2AAyRgmYH83AA2sAADogHaxJh4sAcQpMbRC+BCiQAej4QrI8vkzFlQrJFJgKqFkFgmpAb1sfHR-T1wqgosI4o4bwlRoADEKAL4jQVWm12qWEGUIeVKy0SdVG7WUy0G3UB422ABihCWd0Ttlik0tIrFjXtjpjLpA7vQnsztuzvv9cpAiuV5DVGpj4ejqvA0GjlZNSEa2iWGetWYlDo4RoAjAB2N0AXRxNLpDKZ21ZbK7fKnFBglExzQ48aYHK5PMQ-KFJZ90qNqkak2IkdbRuybW5MFUeKHta9-Y4EhQUFMRBHAGZJxxddN23ONdy7WwVwLIA")
            ..distractions = <String>["is angsting about how hard HOLY PASTRIES are to get right.","is pre-making a shit ton of dough to use later.","is cleaning out the ROYAL OVENS. Wow, that's a lot of work!"]
            ..specibus = new Specibus("Rolling Pin", ItemTraitFactory.ROLLINGPIN, <ItemTrait>[ ItemTraitFactory.BLUNT, ItemTraitFactory.WOOD])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..bureaucraticBullshit = <String>["needs to pay a fine after that debacle with the Pastries of Love.","is dropping off a cake topped with Scottie Dogs."]
            ..makeCharming(100)
            ..sylladex.add(new Item("Holy Pastry",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.EDIBLE, ItemTraitFactory.MAGICAL]))
            ..description = "The baker of the Prospitian Royal Family, RB is skilled at making HOLY PASTRIES. On weekends he runs a bakery even the common folk can enjoy, and even might teach you to make pastries, too."
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
            ..serializableSceneStrings.add("Help Breed Frogs:___ N4IgdghgtgpiBcIASMA2AHABAIQE4xgBNMAxXAewHMBnEAGhADNUIA3c3AFRgA8AXBCE4ALGJgDKAYQCiAOWkB9APIB1eQCUFsgIIBZaZgBG5AO7VMEMMWoBjXBHQxzEPpj6jMmTtvUBxaZxaeopKmjr64hZWmMIArlCGqACeFtQA1uYAloxuoilQECkQ1NSZ1K7uMFCYmWC5MJm4MeTJmISxfJlOAHSY9CB8ELiUMHxKYHCIjBCo1HAMfLiZlCO4kuRWmZ0b1AAymay1lIIA2sAAOiCZUOgcg2B8KhyEl-CXsgD02pd070qcr0u01mMB+l0gsEBIAAktRtKgDqD6JdrrdcPc+NCHlCAAyXAC+dEwFyuNzulkezyh4nQEBsSN+IFk-yhwLmYPA0CRbyucOojhsfAACiwkjBcBzUeSHli+LiCUSSVL0RSnrgXggwLFUKhGcyAQhLotYgzwVyoUhimQqJKySqZdjDSA8SBCcSUXaMWqNTzPt9kUyWU62abOZCnbD1JZCOQoLa0RjZVCAEwATgJAF1+otlqt1pttmA9tHTlmGDBGIwYILqCQOPtDmBjogzh6E6qqU6-RyIdzLr5EdbKPHpXxZPFDOL5a6yyAK1Wa3XcLto7QW1n8UA")
            ..serializableSceneStrings.add("Kill the Blasphemer:___ N4IgdghgtgpiBcIDSBLANmgBAFwBY0wCE0IBnAB31gCcQAaEAMxIDcB7agFRgA9sEQmAMoBhAKIA5MQH0A8gHUpAJWkSAggFkxmFKUylcbAMYBrGABNMEMJYjlyEDBZxt9MAhCIAZNUIAKABJiGrIAqkKYfqFKfl7aAGJKsgDiOmA4+JiYnGpKyWKcqpoysirqWkIA5HqkAJ4YEOa8AHTZ+LWYUBBmmACOAK4oppgA7hwmmGyMGTBQdFY2M5ihEgGyXgCamGt+fmJKLpgARmxs2M30INgQ1ADmMNiyYHCI2NT9cAxvKLf31CJsGwobAoQGkLwoFgoMC3AQAbWAAB0QCgoOQONcwNh5BxzMj4MiJAB6NTIuiE2ScfHIxiOUgwMnIyCwakgACSpDUaEhDPoyNR6OomOwbKxrIADMiAL7zJEotEY6zY3GsoQOIy88kgCSU1m0tD0xngaC8gkozkUGBGbB+Ei1GDUI0CxVY0XYCXS2X8hVCpU46h4hBgfoYLU6qkIGl0zVMk2sgJkPz9ajkNAweLUNi3J0+4Vuj0gGWYOXO31Y-2Bs3E0l87W6yNMaNG5mm5FstRQESZkbPQNa0t5sUNyWFgC6l2+vwdAKBILBXms5nh44YMEYjCt2FI8Q4EKhMPhJdzfpVDerzbjDdFpGuqAwOcFwok-SgRwdBaLR8fJ4DrPPtZbVkvDYekMyzB8XWwZ9X3fYdpRXEA1w3a1t13RdSGXQsgA")
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