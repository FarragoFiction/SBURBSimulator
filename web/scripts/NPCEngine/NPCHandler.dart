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
        //print("TEST BULLSHIT: setting up ncps");
        setupBigBads();
    }

    static Future<Null> loadBigBads() async {
        print("loading big bads");
        String data = await Loader.getResource("BigBadLists/bigBads.txt");
        bigBadsFromFile = data.split(new RegExp("\n|\r"));
    }

    void setupBigBads() {
        //session.logger.info("TEST BULLSHIT: setting up big bads from ${bigBadsFromFile.length} data strings, $bigBadsFromFile");
        for(String line in bigBadsFromFile) {
            if(line.isNotEmpty) {
               // session.logger.info("processing $line");
                BigBad newBB = BigBad.fromDataString(line, session);
                //print("made a new BB ${newBB}");
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
        jack = (new Carapace("Jack Noir", session, Carapace.DERSE, firstNames: <String>["Spades","Septuple","Six","Seven","Skullduggerous"], lastNames: <String>["Slick", "Shiv","Shankmaster","Snake","Shanks"], ringFirstNames: <String>["Sovereign", "Six","Seven"], ringLastNames: <String>["Slayer", "Shivs","Stabber","Shanks"])
            ..specibus = new Specibus("JackKnife", ItemTraitFactory.KNIFE, <ItemTrait>[ ItemTraitFactory.JACKLY])
            ..distractions = <String>["is throwing a tantrum about how huge a bitch the Black Queen is.","is pretending to ride on a horse.","is so mad at paperwork.","is refusing to wear his uniform.","is stabbing some random carapace who said 'hello'.","is sharpening Occam's razor","is actually being a pretty good bureaucrat.","is hiding his scottie dogs candies."]
            ..sylladex.add(new Item("Occam's Razor",<ItemTrait>[ItemTraitFactory.BLADE, ItemTraitFactory.SMART]))
            ..sylladex.add(new Item("Horse Hitcher",<ItemTrait>[ItemTraitFactory.STICK, ItemTraitFactory.IRONICSHITTYFUNNY]))
            ..sylladex.add(new Item("Terrier Fancy Magazine",<ItemTrait>[ItemTraitFactory.ROMANTIC, ItemTraitFactory.PAPER]))
            ..description = "The Derse Archagent, Jack Noir is infamous for his love of scottie dogs, his hatred of the Black Queen and his omnicidal tendencies. He’s also a leader of the Midnight Crew - jazz band which can often be found in the “Liquid Negrocity” bar.  <br><Br>When he gets the ring his omnicidal tendencies are enabled."
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -500, Stats.MAX_LUCK: 10, Stats.SANITY: -100, Stats.HEALTH: 20, Stats.FREE_WILL: -100, Stats.POWER: 30})
            ..makeViolent(1000)
            ..makeCunning(1000)
            ..serializableSceneStrings.add("Be Omnicidal:___ N4IgdghgtgpiBcIBCMAEB5KYCWBjbAJhADYgA0IAZsRAG4D2ATgCowAeALgiMwBZoBlAMIBRAHIiA+ugDqEgEqSxAQQCyI1ARgAHYvQCeAZ1T86+1IY4QARsY70A7hEYE7-VM2XyA4iOZK1KXRFFXUBADoAHTAAHmtGAD44xPIQK0YAcxgOdDA4RA5GAFc4CkLsDKzGIXowAmwObFrDABlsWmwwDO4AbWBIkGwobSYrMA4ZJgIB+AGxAHplAbI59GYZgcoSQxhlgYA1eQBJAQBpJYRN7d3yAchYDZAjw2VidpuVweHRiHGj8ceAAYBgBfMiofpfEaMMYTKaPBYXT5iNaPLbEHZ7ECHE7nNHXLH3G6zJ6GeS-Aj0KBYobQ2H-DiPABMAFZQeDIbSfuNJi4EYssSj1pc0sUPgdjmcLiT0ZjbuBoMSBs8BDBiJQad8Yb8OAygeyIQMudqefCRYjBaiRbLxdjJXjrQT5UTHkdlFAhIxHHlpvLjfSASLgSAwYaody4XyRQAFRwwRiW4UkwolLE4qX4jG2l0i5jOLIcARWXWGbyMGAQDjxvi-VSdW3+nV6oMGzla2G830k1T0azYN4cfSJx4p23ph0yp2fHMkvOZbJFyvPMsVqssXi1+uaulNwMk4Ohts701RkkCX4NIfyoUjsVp+3Sq5ZwmKx6qfSLksryvVjdgfYkKmfrtrujIigAjAAzKCAC6qTlJU8Y1HUDRNGArQUr0cEUDAlCUDAuAcIYABiTBtB0XS9EeEadvySJ3K+Ir-JYECnP2xD3rij5UFORogeMYhFFA1jxvqIbYSAuH4YRJFkRShhYSGQA")
            ..serializableSceneStrings.add("Engage Strife:___ N4IgdghgtgpiBcICiYDmFUwAQGUAuATgJYBmcANCCQDYQBuA9gQCowAeeCIzAFtjgGEkAOSQB9APIB1UQCUxwgIIBZJFgDGEPOr4BnLHj5Zmi2QHEkzBSvET5S1TiwQwAEwPEY+vAyy68EABGBnxQ5FiBAK54Idgm5pbWqpL2Nk4kRKg8ePqBEOoA1gB0ADpgADyBBAB8lTVYIJQBBJh4EmBwiISRFCCEmZgEAgxuRHhEI7oAMkR0RGhcANrAJSBEUAAOTAFgeFJMrqvwq8IA9Iqr5CcSzEerJBDUujCXqwBqsgCSOADSFwj3R7PV7gaAvAEgT66RTUWbgq5rTbbFx4T67O4gAAMqwAvuEVoitgQdnsDhizv8EcIbhiHk94e8vr9-scqECGaDYBiobIXK4GFAQesiSS0XgMQAmACsuPxq2FyN2+wIhwhFJB1NuEO6HI+3z+tPZIMgXIhUJwMGoJCFSOJKLFGOxIDxWAJCrtSrJavOGppELpwMajP1LMB9ONYO5iigAgIDAA7h1VQj3aL0RCnS63baScrVayAAoJmAEX1a1kB3VMg3+o1Bzng1nMCAtGB4fBaKFmAgwLQl3guZTzDmp+3p1mZuWExWklXkn31zUYnUgvXMw3h+smxurAASEF0sYTYBtIrH4ozstd8pzKLzGOUDECRFheAAnmXlwQeqvq6G2ZuCLbhizatu2ASoro3a9ng-Y8IOw6njODqXs6U6jp6c4QjgLhjB+i5+qyK71muNYVnWQGRhCyhvh2kHQX2LDwWAbyPD+9YYai46rAAjAAzLiAC6jR9MQqCDMMozjJMUx8kswmUDAJBkOoOQAGJMDMcwLIgyw3memH5icC6UaarIdsS+DEGQv4hhugYpreuzCJEUCBCWjpCSJSkqepml8ro8nOkAA")
            ..serializableSceneStrings.add("Say Hello Badly:___ N4IgdghgtgpiBcIDKECeACAEjANjg9ugEIQAmOqIANCAGY4QBu+ATgCowAeALgiGwAsY6JAGEAogDlxAfQDyAdWkAlGZICCAWXHpSMAA4FUAZ3Q4AlgHMB3dMe4QARqe74A7hBakXQ9G3XKAOLibGpasnKqGtpIAHTocgLolvik8YIQ3ADkphBm+Lb4tOiOBKnxCrg4VOjcvmJSEUriUeF2AK4swqT4MMZgWbbGMDBQtQKZJQVCXaQlGObcsQA6YAA8jiwAfBvb1CAOLJYw3HJgcIjcLO1wNFdWxyyi+GCki+YvxgAy5ozmYJY+ABtYDLEDmKD6VgOMDcBSsUhg+BgyQAenUYKoKLkbCRYNoEBww0xYIAasoAJJIADSGIQ+MJxOoYMgsDxIApxnUFkYMBJ4Mh0IgsIpsPZAAYwQBfGqggVQlgwuEI9loulYkCSHHsglEvnMkDkqm0nWM-Ua1n65Ec4zKYU9KD8iEKpWi7jsgCMAFZpbKwc6hbD4V5Vej+VrcfSDtdzWTKTS6dbdUyLdArWDOUhcLQnYLFcLuG6Jb70HKA-mgyqo2rw9qo1cbvyjQnTXr+Zb2RT1FBRCx3OdEQby66xVHJSAZaX-XmlcHB9aawaI+yG7HDfGTVHk2uO1HMBBjL3+7mXQWi2OS2WZwW5+yAAruGAsWuR62rpsbxMMtsG3fWtieMc3BIA4hbGIEXSZE+GRgJo-xrsOZ6jta46Tlep6ViGe4wISdQviuMYfsaX50Ga7ZpuyAFHCcIGZJyEE4dw0ETGApKEo2Q7XiKyFgh6ADMqF+vKgbKlh1qaPgjjmBY3CoPh9aEQazabkmZG-hRUZUUBtFgQxUHsCxcHnCeInnihl7ThhonzmCKBgIsclLnWb6KRqykkdu5FslGmioDp9GQUxBnCmxOAcRqiHce6Ub8RZwkVtZ7LiJw+hPuYMBgAAxmuy5bmpbmfq2KYshp4l+aBAWMcxIXsQhXGFjxID8ahAC6+z3JYjzPK87yfF89rAm1NAwLQtAwJl3DGAAYqwPx-ACwLoSJt7VmG6nedaor2BA1LSTgREtnlP4RfVkjtFAjhPsWE5DSAI1jRN02zfaxiDROQA")
            ..serializableSceneStrings.add("Sabotage Black Queen:___ N4IgdghgtgpiBcIDKEBGB7ALhA5jABAEIA2EAxgNb4CKArjDGCADQgBmpAbugE4AqMAB6YEIPgAsCSAMIBRAHKyA+gHkA6ooBKS+QEEAsrPwATdDADO+c+lhWYZHjEwBLTgXNosuApnT426M7E+JiS+Hy6mgDisnw6Bsoq2nqGSPgA7uI2+GHiEJgWVn7GMBA8xACeAHQAOmAAPKg8AHyNLfgsINg8eJgqYHCImDz0ncPOOHg80uhgxs4us+YAMq7OYDiiANrANSDOUAAOvNhgmGq8xnvwe7ryAJp7zHvyKnzXe2wQxOYwT3sANU0AEkkABpXQfdjfX7-cDQP4IPbA8zSMoQQ7kRHPfZHE4QM7As5QgAMewAvsx8LtccceKdzpcofIAPSQlgvN5Qr4-bGAkHg9k3aG8uGQWBQgASEFRPHQ6TAcIOdIZRMwpIpVJpyvxZwuPCuSJAJHIVDoDEVHJAr3eRp5sKtQNBEO5ML58IlRvkCJmZwg63MSrx9IJmDVGpAlOpex1Ib1TKNskEhxgPGcjDI7ptrtFjoFLrtbrFCKh+gqSGwYfMUUc+VTEgJAO+9CDKtD4aNAEYAMxkyNamPBhn6w3ClBgBYVOHZo3DFt551Cz5Fq3ixHCssV-IomulAr8PJgJvEec42Oq4ld7ua6O03WMg3MtnTrmF3M4p2CnMOnFrqEozQCVMKBW3vDthQAVj7ckAF0xjTSZU19eZFjAFYgO2ODWBgNg2HsTBzAAMV4VZOHWTZEB2Qc23jR8jX0dYDloKB8GWWhKGLT1hWkQ88C3dUFy-N8f2o+95GY1BUyhABaHtoIHO84wfUc9n0CBBCYli2I41cSyNHiCT4ys4U-AthXtd1z1DcSoEkngZLkiksJAHC8LIAjiJ4ZYgPMTDIyAA")
            ..serializableSceneStrings.add("Make Plans:___ N4IgdghgtgpiBcICyEDWMAEAFANhMAziADQgBmeAbgPYBOAKjAB4AuCI9AFpgMoDCAUQByAgPoB5AOoiASqKEBBJAIwBLAhgAOeMGFVgA5hggZu6lsbAATLbQgBjFqvv6jndRgIsIAIwIA6AB0wAB4fWgA+MMiSEG9aAxgWcTA4RBZaAFc4UgzVA0TaPmprVScSggAZVUpXdgBtYECQVShNOm8wFkk6K2b4ZoEmTRhaVRgwexhm4mahcXp+5ozsmeaANRkASR4AaQUl8ggcAmmSZshYQ6QATx5vFi2CAHFaGAgWUa58dePV85abQ6+EeXUOAEYAMwABmaAF9iBgmoD2rROt1eochAB6A4A+aLBDNMjHU5rECbHb7Q4kk5nWbgaBnAYgJ4yfBWahQcmtVHorZgokgACssJACKRzV5wK6PVofSFPHwZRu5IJhxW9I22z2eJZtLJAMuzOat3uHyer3enwYnB+fy1KJloJYEMh8MRyOlaJBcoVLJxeIZ6qFBsdlN1NNJjuNhyePBgODIPKBPq6AtdQrFEq9qfRfqxuLVCyjdPJEepoej5NjQqeChwNUd3v5gpZ2YAurE8gVRsVSuVCJUOQ0u6QYGQyDBHAQAGJ0aq1QwNXN832YoVDEZjCZTGtMw58O2GGBmh7lnWV-XVgEtkFCTJQHyjN3wscgCdTmfz2jD6xERB6i7OEgA")
            ..serializableSceneStrings.add("Say Hello:___ N4IgdghgtgpiBcIDKECeACAEjANjg9iADQgBmOEAbvgE4AqMAHgC4Ih0AWM6SAwgKIA5fgH0A8gHVhAJRGCAggFl+6ACYwADgVQBndDgCWAcw7N0O5hABGe5vgDuEGqttd0dedIDi-OnKWiYrIKykhE6AbMAOR6AFYArhboHA7J3Dpoelx4+AB0ADpgADxWNAB8JeXEIJY0RjDMYmBwiMw08XAkbcb1NLz4YKqRBgM6ADIGlAZgRmwA2sD5IAZQGrSWYMwStKpL8EuCAPTyS0QHYnR7S6QQODowp0sAatIAkkgA0icI17f3j+BoA8fiBXjp5IZKMCzstVusIJtXpsriAAAxLAC+4UWsLWNA2Wx2KKO3xhgguKJud2hzzen2++zIfxpgNgKLB0gRqnwUABKzxBKRzBRACYAKyY7FLfnwzbbZzE44A8mXEFtDoAl7vL6U5kAyBskFgpC4Uh8uH4hHMIUo9EgLHoHEyy1yokgknKilq9osrX03XU-VA9nyKC8GgOZq7YjSi2C5Egu0Op1xq3y6OMj0xkAqlHq310nUgqn-bMG4GMzAQHThyPmgVWm2JyWO2MN10KkEABQcMBontVjPzmsLDN+gbLwZBdCc9WYSEs1p0XhoMAgzD7nARimmLOd8eFzftUtxssJncra5wzA4A4DpZhfqLjJLLPLKJndQaC-XYJXa43egOARJ5bg1bN90bBNGQARgAZiTE9II7DMlmwW4bzvb1wMfUd7zfKdGU-OcfyXf9103YCwFAnAcLbM8m1ghDENbU8XXPVCQEUfArAMQxmFQLChx9EdtTHJkJxhd9p1nb9Fz-VcKKA7dd3rBjoKWFiU3bDiURQMBIkE7Nc2wgsxPwoNDUZRRUFIhSAMokCwL3VNEQ0kB4MxABdapuiMXp+kGYZRjGLl5h8kgYFIUgYAAY2YHQADFaAmKYZnmbSz3TFF0OvW9JyspZeCo+pSNE-1iz1CDXOYQR4igKw+xRABaeCkwikAopi+KkpSrkdHC+0gA")
            ..serializableSceneStrings.add("Say Hello But Better:___ N4IgdghgtgpiBcIDKECeACAEjANjg9ugEICuALsTGWTAE4gA0IAZjhAG760AqMAHmQQhuACxjokAYQCiAOWkB9APIB1eQCUFsgIIBZaegDOIiAGsYh9CbAATSwHcAlmRHoX47tvUBxady16ikqaOvpIDOjOAOSWAFYkhhQi+PZW4oZolmJ4hGApAHQAOmAAPABGtAB85VWMIGQQtADmVEpgcIhktCRwTF2OTS20kvi2zo6jhgAyjuyOYE1CANrAhSCOUAAOXA1gZCpcNmvwa7IA9NprDKdK3MdrzBA4hjBXawBq6gCSSADSlwgHk8Xm9wNBXoCQF9DNocLMIdd1lsdhA9l89vcQAAGNYAXwiqyR21ou32h0x5wBiNkt0xj2eCI+3z+AJOLGBjLBsEx0PUqJs+CgoI2xNJ6LImIATABWPEEtYilF7A60I6Qymgml3SFdHqgz4-f50jmgyDcyHQpC4ZjC5Ek1FkcWYnEgfHoQmK+3K8nqi6a2k67qcg0s40M03gnnaKCSWgpdpqxGesUYyEut0eu2klVqtkaxg3bVs3XB5lGyH0kEFrkQtmYCCGWPx22ih1OtNy90KrMOnOYlBgZyof1FoHh6sh8tsyucs21ta6VBIBqOwzeWgwCA0HjWd5PPXV5Nt1NsgCMAGY8QBdOr9QZ0EZjMgTMDTfnLG9MGDMZgwADGZCGAAYlwMxzAsyyZq23qqv2qJDhG5pspI1gtMuW76mWrJjlWSY9nssgkFAZR0JiF6dlBSpkrBkIDgh1ZzpiKGoi0i7oRKE5YWGuHdtBZCEcRpGQuRrqfiA36-gBwGgfyhgfq6QA")


            ..sylladex.add(new Item("Scottie Dogs",<ItemTrait>[ItemTraitFactory.CANDY]))
            ..activationChance = 0.99999
            ..companionChance = 0.5
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
            ..activationChance = 0.5
            ..companionChance = 0.5
            ..sylladex.add(new Item("Bull Penis Cane",<ItemTrait>[ItemTraitFactory.STICK, ItemTraitFactory.GROSSOUT]))
            ..sylladex.add(new Item("Regisword",<ItemTrait>[ItemTraitFactory.BLADE, ItemTraitFactory.LEGENDARY, ItemTraitFactory.EDGED, ItemTraitFactory.POINTY]))
            ..makeCunning(1000)
        );

        midnightCrew.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Diamonds","Draconian","Dignified"], lastNames: <String>["Droog","Dignitary","Diplomat"], ringFirstNames: <String>["Dashing","Dartabout","Derelict"], ringLastNames: <String>["Destroyer","Demigod"])
            ..specibus = new Specibus("Dignified Dagger", ItemTraitFactory.DAGGER, <ItemTrait>[ ItemTraitFactory.EDGED, ItemTraitFactory.CLASSY])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session), new SeekRing(session), new GiveJackScepter(session), new GiveJackRing(session)] //order of scenes is order of priority
            ..distractions = <String>["is playing classy records. ","is reading the paper. ","is fantasizing about perfectly tailored suits.", "is hiding his swedish fish.","is reading 'classy literature' about grey ladies.","is keeping everyone calm and productive."]
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: 0, Stats.MAX_LUCK: 100, Stats.SANITY: 500, Stats.HEALTH: 20, Stats.FREE_WILL: 0, Stats.POWER: 20})
            ..makeCharming(1000)
            ..makeCunning(1000)
            ..activationChance = 0.5
            ..companionChance = 0.1
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
            ..activationChance = 0.5
            ..companionChance = 0.1
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
            ..activationChance = 0.1
            ..companionChance = 0.5

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
            ..activationChance = 0.1
            ..companionChance = 0.5
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
            ..activationChance = 0.5
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
            ..activationChance = 0.1
            ..companionChance = 0.5
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
            ..sylladex.add(new Item("RoboTeddy",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.ROBOTIC2]))
            ..description = "A Prospitian broad with a famously low Mangrit stat, which is only as low as her Nervousness threshold. Its anybodies guess why the White Queen allows her to go out in public armed with a flamethrower."
            ..sylladex.add(new Item("Paint Stripper",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.ONFIRE]))
            ..activationChance = 0.1
            ..companionChance = 0.5

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
            ..specibus = new Specibus("Pray and Spray Machine Gun", ItemTraitFactory.MACHINEGUN, <ItemTrait>[ ItemTraitFactory.SHOOTY])
            ..sideLoyalty = 20
            ..activationChance = 0.5
            ..companionChance = 0.1
            ..sylladex.add(new Item("Alarming Pile of Guns and Ammunition",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.SHOOTY]))
            ..description = "He’s just another Dersite who disperse tickets. He hates crimes and will throw the criminals in the slammer. He calls it the slammer when he is extra angry. "
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..serializableSceneStrings.add("Destroy Contraband Source:___ N4IgdghgtgpiBcIAiMDOAXATgewJ4AIBhbMLCAIwjABN8BlbAV0wGM4AaEAMwBsIA3bJgAqMAB7oEIYQAsY9QgFEAcooD6AeQDqqgEprlAQQCyi-DIip8XAJaQePAlyY18TdPgDuczPIgP8dDl8GwcYAHN-fBYSMkpXGysYqDtw6xwoADp8AEl0AHIrIPlhQ10AcUVhAxN1DX0jUzpshnN5amw0LwsPKgI+T3wKG2pU6Jt0GwAvGDAvJh5aDsyAHTAAHnJMAD5NnfwQTnQITHCYdA0wOEQsRg4QLBtws8xiGgmbElQAGRt+VKkAG0ALqHB6YJ4vN6jSZfb5UahA4ArEA2KAAByEx1IWiE1BR8BRygA9IYUewiRphASUVx-KgYOSUQA1XQ5OgAaTJCFp9MZhxRkFgNOkJzO6ByqGU2HQKAwOFwMHxAtRGKxVAlpBFAAYUQBfdj4ZGqzGYbHoXGYZWEkAAMRw4VQTJAyipIrpPAZztZ7K57r5zqF-JtymgMDexzsTpVaNN5pyWp5IF1IANRpRsfVOLxIpJ3IpLrdSY9XpVPs53JtJf5BaDIpyhighBwniuyoLmbNGoT6B1+sNxs75st1qJpOdrupxYDZbZFf9nprgrD9dQugR2CgzqH3cTNoArCm9aDODAuFwYCx0KhbUJfv8wOEgSeQGeL1eb3eEagkRm1V3sytXNxxVOskwTDAIAAIR4bBPAAVXRb05z9adF23f9zWURgoHIGBMD7VNQT1IA")
            ..serializableSceneStrings.add("EXECUTE:___ N4IgdghgtgpiBcICiANJBhAqgFSSANCAGYA2EAbgPYBO2MAHgC4IjYAWMABAMrpIBySAPoB5AOqCASkP4BBALJJOAExiMYAY0YBnTozYRGejp2yzJAcSTYZC4SOlzF3TgEtdETkWowu+12AA1jDUnADubJScMGAA5hCxMLoBnBBgjK4AtFCUkNQabACenABGMAbkrjQAdJyyugAOIZw0qqHelFCc1JSFECSMhfjGIVzuLWAkxblcDQCuYO5ssOleNJzacwWl5RRV1NUAOmAAPCXUAHxnlwQgjBDUiYwiYHCIjNRzcIQfrrGJ1HQuWUrgyuW0ABlXJU4iwANrAQ4gVxQBo0e7pMStJHwJH8AD0siR+DxImwOKRRH62hgxKRADVJABJbgAaSJCEp1NpBCRkFgFJATO0shI0J5JORqPRaUYTPSgoADEiAL7DRFStHUDGMLHUZSCgkcyX8MmCj5fOkgRks9mCqkkGlW-k83FC7TcGAkIhWlFanXyxhK1XqpF+mWY7GckBGq2m8nRh1O3nW5lsjlupMSvnQV1IpmyKDoHphV4GlPh7WywPBkBqzgays6vXlt2xlPx82fbOp20ZrmOnsuwUACQg2mLlFLvulVfSNejyrroc1Ed1UbdAAUpyE42boxaezb0-buc7c4LsA8ntx7nLtBYfIYQuw0vIAj2m9WFYuQw2w7OzYbkiABiPhcGIrgkCQe4JpmZ4psedqJghkrDtGV6PGot6GMKj4wM+tAGGA9L9JaFaAd+QbRgAjAAzH+jaUZG+qGoSsGnoOVpIf2xCoTmArRsKkhpMonQzv6VGCgATAArKqAC6ty-P8IRAmAIJgmAkKifCSmEDARBEJoOggTQUIwrE8JMZJLGtni7Epuhbo4dqt7UK4xncWmyHwVxFG2Yw-BzFAZTULWKr6SAhnGVo2hmdQEKidoel1kAA")
            ..serializableSceneStrings.add("Seize Illegal Contraband:___ N4IgdghgtgpiBcIDKMCWAvGACAkgGzxgHMI8sBhAezABcAnCAIwjABMQAaEAMzwgDdKdACowAHjQQhhAC2xJyAUQByigPoB5AOqqASmuUBBALKKsAZwAOlGuaw05WYYd0BxRcIMn1G-UdNIWKhgWNbm5jDhqNRYlNwWlLBBBMSkWADG1PRMLKwAdE4yqHYAPKgAfOksYDYlAPQVWIzYhCR4BbLYqCltGVkMzGxBdhEYMKxYuU0wmbB2RJT8MHRgsLShdJSWyzQAnnkAOmAljHTlJ2ecIDQQdEQwNBpgcIj0AK5wXPSoRPd0VGxUDRomBzAAZVD8YJEKQAbWABxAqCg1joN1oWiErER8ERyjqhkRHDxGmEOMR3FIESJiIAarocEgANKEhAUqkwGngaCctkgHDmQx4SG84lIlFCdE0HC0ckgAAMiIAvhwsAjxaipZi6Ni+UhLBB0qKSWS+ZS8NTOHSGczWbieByuZBYHLioYrDMaAAFPi7ZZc5GaljS2V8xUgFVqxGByXB7W6+BgN4EMXKUly82WsX0xksjOOq3cl18gASEHMADFNkQAxK0cGZTQ5eHI+qY-WMVi5YoxNs6KgYGAjVy06b7ZnjSAc7b8xbJ87efbjLskDdpeZXHQYBAaMtZCxaaQPrWg7RG3KAIwAZhbqrbda1Xb5+NZqfTZoL2ZteY-c6dPLlAVdFyRIT1jM9Q3tABWFsAF0rm+X5lgBVggRBcFcjheCuBgbhuE9SshAhKEwBhRB4WjB84yfe0X3-Yt7TBSgIirSga0Lacf3HT9KNPGhlDeKBmjoZtlWwkBcPw9JbArIjcnMLCIyAA")
            ..serializableSceneStrings.add("Take Someone To The Slammer:___ N4IgdghgtgpiBcIAqEDWMAEBlA9rHYmSOGSAFplgDbSwBOIANCAGY0BuOdSMAHgC4JkFbAGEAogDlxAfQDyAdWkAlGZICCAWXEYAxhH66KAZwz8RSdcoDi4pGq2y5qjdqwYAJjgCWYAOYYxngw5r4B3lRUMH4QVAB0pBQAnhgQAA5pdDAUYB5mFla29q5OLo7uELlmaJjmMFBmJHWBNFD0CeSUEtLySuJl2nqxVKbe-PkGGADuOfkwSQDkWRgwxmkwut7DKZV+dDvjunTesMYJADpgADwARnQAfLcPl+os-DB0gcFmJzCMc6RCnYHNp5ANxO4-CFTDgAK7jHAsAHGVrtS5PR53e5MED8CB0KH8OSEIT8OiwuDMMnePxQuiiAgeMbeAjGAAy3nYYSEAG1gOcQCc0lw8WB+AouB4BfABZIAPTqAWMWVyJDSgUsWLGGBKgUANWUAEksABpRUIDVanVMAWQWDqkCG4zqKic63KwVQYV0UX8Q1ih0ABgFAF9-vzPd7fRK6FKLSB5eaPZJVQ6yRTdSADcazQ7NSN3bboNaZY7jFgYFQWJmhSLKn6A-HgyAwxgI7WffWY3HS4nMym1fH04Ws0bTebS-ntZm7SWBQAJCDGUR0HBTMA1r11sX+-hB0PhgUd6OSh0ABTXH37qaH5JH2fHeatM+LDpQBJCWDxfuM1iyBg+chKk0XwR2Petd33FtD0jbdxVPeM+xtBMb0nZ9kIfXN4ynEdZwdJ1lEqLwoE3KMIMbUsACYAFYDzbI8t07MVuwdcReHWY4YDAXQRwHJ8C0zTCJ0tATkLw+NNCSL8DCdP8YAA7gyEqPVYgzZDwJ3CiBQARgAZmbEMAF0cWpWkPgZXJmVZNkiN5YzmBgFgWA2fhjAAMS4DkuX8Xl20Yk9YwdJCPXE0tNBqAAhWFjCSQSxywtDRI9DT+EkWEoBuK8m1DeyQEc5zdFcjy6Bs3JjDslsgA")
            ..serializableSceneStrings.add("Catch Crooks:___ N4IgdghgtgpiBcIDCEAuBjAFgAiQJwHsCBrAZxABoQAzAGwgDcC8AVGAD1QRBcxmwDKSAKIA5YQH0A8gHVxAJQmiAggFlh2dGiwxS2UgVia8ASygnItfegCuUAHTZltKxewRsAEwgBPAOR6AO7MxI68MD7YAOYwqNgARrGoMHjucah8JqkAVgTx9gA6YAA88XgAfKUVlCCoEHgxqFJgcIioeDZwVO0mUTF4SARgniaoJkOkADImDBZR3ADawAUgZgAOzHVgqDLMnivwK6IA9MorFEdSLAcr1BC0pDDnKwBq8gCSAgDSZwi3949nuBoE8-iB3qQBDBaNQgetNhBtu9tjcQAAGFYAXwo2GWqygGzwWx2e1RJ1+FxAoiuqLuD1BlLenx+tIBDJWkFgqIhzhm7PxhOJyNQqIxIGxuJW8KJiJJeH2YPJQOp1zBdMBlFeH2+v0ONDZQM5oL1EPkiM8hjhBIRSJRYIArGLMQBdGo9PopQbDUbjMBTc2LV1UGDUagwdCoUgAMWY01mYHmiCWUutMu2u3lqOE7DWKRMMDA6H5RtRSEwiJiAjqIs1ICZOtZ9KtgtlojsiTwqIAjABmLFBkAhsMR6Ox83kJOuzFAA")
            ..serializableSceneStrings.add("Pass Out Propaganda:___ N4IgdghgtgpiBcIAKEDOqAEB5ArgFwyQCcB7ABwgHMIwATCEAGhADMAbCANxKIBUYAHngQheACxgYAygGEAogDk5AfSwB1JQCVlCgIIBZORghkypCAGMJmPBIy9dmgOJzeOgyqza9hqcboYYjS0NhJQxhiUJJwwRGCwYAQwdDyoMLQYZACWMBaSJCyZpBTUdBAYqDimPHhZYJQYtpJQJJBEVgCeAHT2dg7Oru6Gqt4efiwwMGyY5WxZeHhsksl4RDR5GQBGHRjzmBateCuoXQA6YAA8m0QAfFe3TCB4EESUMHhYYHCIqzhwzKsspQ3kQZK1aPMsq1UAAZLKcOqUEQAbWApxAWSgZBqNDwah4tHR8HRCgA9Lp0YwSVheET0SwINMYJT0QA1TQASSkAGkKQh6Yy0izwNBmfyQBzULo5jFhZjsURnokOYk6SAAAzogC+jAwaIxWJxiXxREJ4rJfKpIAUNLVvzFVvZXN5aoZTOFkFgaslUimLDlhsVuJVeDVmpAOr16PlRrxBLVFuFNtp4vtwqdPL5xNYgod6M9YuzAAk0DJSAB3MABhVKvAhsPa3X6mNB43x8UAMSIkwwaiybDYSdtqaIf3TnMzrtzHtFat4LzeeCkzzrqCc3YgRz4QTArMZY6Y0cDtfr4oAjABmRtRg013Ems3Zrs9vsDocp7NuoWHkAZl3ir88xFL1xXnV53mXTdJXXGBN1icQaD3NgDytFsT1VcUAFpL3DSNm2Pe922zRMf2TKd3R-P8swFCirQLb1UE0YISCgatY1PbMACYAFZtQAXUeQFgViME6EhaEYWCFEBOYGAWAmCw8FQDseDhBF6hRfC7zbU01WfSRX0HH96PFGQdzeSDQ0oid-0-acfzQ3EFBwKBNliNVsKvCMZJAOSFKUlSiEkuhUGkiMgA")

            ..bureaucraticBullshit = <String>["needs to stock back up on tickets to give people.","has brought in some roughnecks to be sent to the slammer.","needs an updated list of everything that became illegal in the past day."]
            ..distractions = <String>["flipping the fuck out about how illegal everything is.","being extra angry at crimes.","designing slammers to throw things into. You call it the slammer when you are extra angry at crimes."]
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeViolent(100)
            ..makeLucky(100)
        );

        dersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Wayward","Wizardly","Warweary","Wandering"], lastNames: <String>["Vagrant","Villain","Vassal","Villager"], ringFirstNames: <String>["Wicked"], ringLastNames: <String>["Villian"])
            ..specibus = new Specibus("Mayoral Sword", ItemTraitFactory.SWORD, <ItemTrait>[ ItemTraitFactory.EDGED, ItemTraitFactory.POINTY,ItemTraitFactory.METAL])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session), new SeekScepter(session)] //order of scenes is order of priority
            ..royaltyOpinion = -1000
            ..activationChance = 0.2
            ..companionChance = 0.3
            ..serializableSceneStrings.add("Kill Royalty:___ N4IgdghgtgpiBcIDSBLANmgBAJQPYE8I0AXfEAGhADM0IA3XAJwBUYAPYhEAUTpjEzEAFrgCuAcyGChMfJigQ5Q+jExpcAZ2KYiWYTBSNMAB1wB3GI3LTVmAMoBhbgDluAfQDyAdVfY3zgEEAWW5MABMYAGMUCI1pCG0qJhtDTEjGFFg4iHEIFDAtcJgoXHSISLkIbPligCNLTFwqG0xGUTR88TTaDQ1rfUxmAOwAcW5mf2D3Dz9AkLt5UUKwlBgAOgAdMAAeWsYAPl2DihBiCEZxGGIPMDhEYja4SgeUcUvGB1wwFeIUL40ADIoOidLgAbWAGxAmVMjDOYGIXiYYSh8ChzgA9AEoeR0R5mKioVQiBoYDioQA1bAASTsSGxCCJJLJFChkFghJA1I0eEIJHw5OhUFh8OI1IRnIADFCAL7WSFCkUQBFIxgoxkgTEM3Ga-Gch6iFk6qm0+mc4loUmC9kstFcjR2GBoKiCmFMUXi4hS2XyqFuuHKxHIzlawXOPUai1W1kgE10hl2qNGtnQW1Q6kBKAORjmW7qnX+j0SjXSkByzAKwuB1Xqu2hmPhgkag3J2M0+Pm5nW1OcgASVWzuddwvdgc93rLvsVo5VwY19Z1jc7ltbcbNka7MZtnO52GVYVwUGHSoR441ACYAKw+it+kcB2dqzkABXMljDEbtLcFa4TTJX3YchqzDnJcxB2GcYoaCMjAwAkljMMoYBBPkrZVqexZ2qWMoALonC8byWJ83woL8-wAvu4J4ZQMBUFQUTEBoABiTBAiCYDiOClb3qKNYhligFpiAEHnOBLz0T+7bromm4FjxgbOKIUD1IwE64SctH0ZEjEsYwFHfBoVFlkAA")
            ..serializableSceneStrings.add("Deploy Democracy:___ N4IgdghgtgpiBcIAiMAOAbA9gTwAQqkwGMAnCI7EAGhADN0IA3TEgFRgA8AXBEVgCxi4AygGEAogDlxAfQDyAdWkAlGZICCAWXG4AlgGdcEVKhKZyggCa4ARni6DcrdcoDi41mq2y5qjduEAOlwACSF0GC5DByExKR8lcT9vXH4mIRjcVEwAdxgSXAcILlxaFlgSdDwbGCwwAHMYay5MQsdCSBIifmxggElaNuKs3PzbWswGwwgwbBzBEhgqPRKDXAAeXQA+MEwudYB6bb0wNqE0sEtDTEGIXCIIMlRyXRn+kpq6+ujWzIwIbD5fSBAA6YHWNhIWwhUOoIC4j0aXDkYDgiC4JAArnAaBjdPVGiRRJNLLouLpJvoADK6Ri6Bq8ADawBBIF0UGyJARYC4ChYllZ8FZkgO6lZVGFclYgtZtAg6H0MHFrIAaso+sIANJihCy+WK5XgaBK3UgPr6dToWkmiVsjksblcPo8mUgAAMrIAvssWXbOY6+SQBaaRTrbZIpa65Qqbar1VqdUK6PrY0bYK6+uooKIzDlUcHbez-TMnS7TR6QN7cL6iw6S4Hg0nhDMydhDRHpabowbqHGNdqoynDZB06bWIjIsIEU79K5FsV8gIZir5djDbWuSXnVxXQBaACMAGYvT7WRuA-zXQAxRZCBS6dDoduRrtD3sgNX9xN6mPD42u8cSCRKdinNOcYAXNgLhXdA13fc8tzLJMjxPasz3tTceQbV1Q2fTsk27VNPwTQdf3fEcTSTMDMEsVhdHydcMMdbdXQrT0AF04TxAl8mJS4yQpMBqRmSwmU4mgYFoWgYCIKIrxYGk6QZRBmXQ4ssMvENRT-Uck3UHldE0TF6kNYiB1fMjCyYktJExKAahIVivXEkBJOk2T9HkkgqRE-QxMrIA")
            ..serializableSceneStrings.add("Rise Up [Surrender]:___ N4IgdghgtgpiBcIBKBLAzjABAVQA6YG0BlAVwCcyYwATGMgXRABoQAzAGwgDcB7MgFRgAPAC4IQAHgBGAPgCSIgORpMIlLAB0EgPSzM-ABZYiAYQCiAOTMB9APIB1K0msWAggFkzmNLh4iVIkb6rkgA4mb8Lh42ts5unkSYAO4oMOzUKGAA5qpBKQDGANYw1Ji+SXQqPKyYEKoAnmQQYCIa+kGUUmnsKDxgmFkQgZWYXax8WMNQbYZY-CHhkfExcdGJ6JjVrHQltZj5Bjwo+TAzRvWYUBAXMCjDZJiUIhCZubcP+WQ8Sf3NpWjPYqYWhDAxMTYPNDkSg0OhvFAfL4-Wo0UZYHwQSjUDQAHTA0jIMgJMjxEhQMlmFwOPB4GFUPDR3lwmJKWm05NJUkJxLxzBAzzIWRgIlsYDgiBEZBIcBYkpQWSFZBMfQyaj6aAAMiguJksuICMAcSB1L4yM8WvY+NQjfAjWYhLg6KkwCcjUwjRZbPwbUbWBB2Bg3UaAGpIOREADSrh9bH9geYRsgsBj7nqRGeIjkaFClCGdEMzWD-ulQeNUFN5szLRjAEYAMwABiNAF9wYayxXmiJLWRrQgPdpowmQJ7vf3YwGYKXQ+GozG-ZPS0mp+Os64elwV+6O3xK3Jq+OmyBW5h2ybd12e33bSPB6XRzHJSXhzPI0Obwv49vlzGs0Q0qwpbnmaXb7iIMZHieZ7lheFpWjGFh3sOD7jp+W4hmGb7znG6HgNAK43gAEhAaAmEiYBATBIEtGBEEtm2RrAZWV4IUh24oR+OHTphc6oVxw4-quaAAGJfFAAAKXw+HclGdjRB43pBDE7tR3bweOrgWAAmveXrYYuL48e+vr8d++G-qRmIQMyrrDkxoEKUaSmnoxVHMepN6IUO7F6XxBnbq+vGcf5ibmUJSB-DwUCybBVbgeOACskGMLKZDyoqyo0HcvRgJqfz6ilIAwKw2z5P4wl8FqOrZPq0FyWpvasd5oXJuO7gkFk3GzsZE5fq59UWCQUBdGQdHHoVxWleVlV-GgBXHkAA")
            ..serializableSceneStrings.add("Rise Up [Death]:___ N4IgdghgtgpiBcIBKBLAzjABAVQA6YG0ARGCAFwAsBdEAGhADMAbCANwHsAnAFRgA8yCEAB4ARgD4AkmQDkaTGRSwAdMID0EzNwpYAygGEAogDlDAfQDyAdVNIzxgIIBZQ5jS52ZeZSzcHSAHFDbntncws7RxddTAB3FBgmABMUMABzBR04lABjAGsYJMwPWJhOeXYGTAgFAE9OCDAyZS0dWurOLEqGMsLqzByKdlyYFu0YdqgIdpgUH05MTrIIVMzZhZzOdliwarAitGWCzCTSSlpMLjcAV05O-bK1lA2tnb2i0Sx3CE6k5QAdMBiTjiYHiQHCFDicbtQbsdgYBTsNxHLCncgUVRqKEQ0QgsGAuggZacNIwMgWMBwRBkTjXOD0WkoNJkzj6dj7OYoDloAAyKFYqTSQgIwH+ICUHk4yyaVi4SXF8HFhj4uDKCTAORg4to4uMFm4ivFDAgTAwOvFADUkJJdABpBxGxim810cWQWBOpy1XTLMiSNABTrkMraRqW030i0SqBSmX+ppOgCMAGYAAzigC+FzFMbjjTIcs4CoQerUjrdIH1htLzrN2sr1ttDqdJvr0Y9DaVIADDiYAoburzXHjkkTtYzIGzmFzkpHBaLJe7xnL0erTtpUcbNvtFe7bddQ87ToDukSDGjc+lBbHZCdk+ns9j89l8qdK4rQ-XtYPg6tO5bH8XT-cBoC7cUAAkIDQfRXjAS9n2vJpb3vLMc3FK940Xd9V0rb992A6Mm13VtCMrY9awDAAxLYoBIcoQMwm9x27B90OHJDCzfWsHGMABNNcDVI9tt2bPdjTIo8wJPGCfggXAIC1BD82QljxTYmcMMQrDuOXXCvyEoCRKHYjAII4z3Wkyi0CQRoknYKBlJfBM71rABWB8aEZThmVZdlOUUHleTskUvJAGAGB6HIvCorh+UFdIRSfFSuOLHDP0sz1KLAQ4IDtFAmCYIiAPEutDy0lLjGuKBPk4VCpzCiKopiuK7LQUKpyAA")
            ..serializableSceneStrings.add("Gather Army:___ N4IgdghgtgpiBcIDiEAuALGAnABAQSygE8QAaEAMwBsIA3AeywBUYAPVBEJzHAZQGEAogDlBAfQDyAdVEAlMcLwBZQTgDmaTFgDOOdAEtdAExhR6AYyxp95nBEJE7WegFcwRvfqgA6HE3pqMBjYpDjBjvYwOG7aqPQADvEQAEZUML7cUVgwyTBUVPr0YDiGONkQRo5xOLIAkryqAKoACt4AOmAAPMlYAHzdfWQgqPaBqBJgcIioWC5w5DP6aoFY-EVG+qiFYNoAMvq0+mBqnADawG0gXvGMI2CoUoxGl-CXwgD0eJekbxJML5cKBAqNoYN9LgA1Oq8ADSXwQgOBoPB4GgYIRIFq2jwBVo6J+VygNywd1QtXuAJAAAZLgBfUIXQnE0mPLDPDEfeEE4R-SlAkH4yHQuF8pGC1GwSlY3h5Cgo663CD3cmoSk0kD0nCMhUkpUPJ6UgAipgsVi2tgIxDs7hRPP+GJmcxRUPqIox-ORZEukElGME7CsTE2aTW9wgR208qJiuVFIx6s12ujuvurPZrxA-vi2H0MDA5nFdtFAudwvhGY94p96IzSiIvBGZO0SHKqGw3CVEOBTq9TJjZLjGYAjABmBMAXSGi2W2FDGy2RT2SqMZ0n5BgFAoMHMqG0ADFGPtDsczknmXq05TmvQAO7YFHVyn8dBKwJ1htoUuu8uIku9nWksILhQLkWCUqOVIJgylwAReBoYsaZiWNYFoONa7IEo+GJIAcMD+jMEBBqgaRfrCP7DLM4qwfcQEgfe8Z0muIAbluO77oey7aKuGpAA")
            ..serializableSceneStrings.add("Recruit:___ N4IgdghgtgpiBcIBKMDGAnArgSwC4gBoQAzAGwgDcB7dAFRgA99FaALGAAgGUBhAUQByfAPoB5AOpCkwgQEEAsnw6oqYCtjCoYAZw7aqsZRHQQADhFTYIYXbiocAVlQ0dW2XehgAjGKVLZVADoOABEqAHcwDnC8Vg5cdmV0CLAAQg42Tm1cTzAAcwSOKmJ4xM8fPwCojQwYCG0dQIAdMAAeL3QAPnauwhBcYzyYXFEwOEQczDgiHOw8ofQeVQATPCrtABlsdXyEEABtYCaQbChTGgGwXHEaZeP4Y4EAelljgkfRWnvj4ghSBrexwAakgAJJcADSrwQPz+AMIx0gsG+IFB2i4vmIgJOZwu1lwoKuKIADMcAL4EDhHHHndCXa63FHPaHvEACT4o37-GDYkHgqGcuE8hHgaDCh6o7SyfwUYWs060+mE3Ak8mU6kKvFXG7oO4wtkvbHsr76rnw1l8yHQiVmuWIsUotFIazLAzYzV0-HKlEAVlJIApVOOHvpOr1Er4DFMMHQ2BgmjtbI5+smictAtNQuxSPFx3kAE8uAMCdoAOKeCC4GNsaxAv5Td24z1Xb36gCMAGZ-WSALp9WbzGNLMCrXDrDYuvb7PtEGDEYhoXDaABiNC2OzyU41TdDjP1kejsfjWmzDv1PFY1iGRcrvLBVsF3MbivxAkwUB86BRnfJM5Ac4XVAl1XdAJxHbQpz7MkgA")
            ..serializableSceneStrings.add("Pass Out Pamphlets:___ N4IgdghgtgpiBcIAKEDOqAEB5ArgFwxSgAcALAGxj1RABoQAzciANwHsAnAFRgA88EILqRgYAygGEAogDkpAfSwB1OQCV5MgIIBZKRgjFiHNhADGIzHhEYum1QHEpXDToVZ1W3WP1gAJhlIIP0w2fH0MYmgySgIIACNQgitRDhg4mHJyAEs2MAA6G2tbBycXXUUPV28GGAzMCAxsvDxKDChOUQgAdwhUvIAdMAAeOI4APhHxuhA8XoBzKiwwOEQ8Dhw4ejWsuYWOCVzfLLwcsFQAGSyWLLA5wQBtYH6QLJJOWbA8JU5fZ-hnmQAek0z1oAKwXD+zwYEHIqBgoOeADVVABJMQAaRBCGhsPhiPA0AROJAqNQmmyLGJYJebw4HzwqM+UJAAAZngBfWgYJ604jvIJfH4soHYmkyCEstYbAko9FYlkwuHU56QWAssliDIMAmvfn0wVMvAs9kgLk8556gWfb4cX4k0UEiWQknSlUgOWY7H-Rh491q4k+gASaAkxi6YF1dIZRpNnO5vKtBptwpJADFUqIlFlMk7Ja71u7PQqSUr8XRVUSWVx5lQxLNGah7KkIHgYNxAmAkbCZRW+dbGcySQBGADMpvNiejgtt9p9GdqGGzub7zsVftlaK96+VBID1dreHrrbJzZgrfbwiC3fIvZpSZjQ59AFox-GLf3k0K7SypLxiO2WQwGApjumuBZ3siW4lj6Zb+lWJLaAAnsejZnheHbXj27oPoaT7PGOE4Jpa04pj+DrAnmLqwRufbFt6uK7n2+4kmSqhBL4bBQFG+qPsaJIAEwAKycgAutM2y7O2Bx+McpwXBxDzifQMAMDUpjUGmnCXNctwPFOvEzqm86ZkuObkHuCE+hInYLKhm7ygxvpMfepF4DIOBQOkHAsm+ZrKSAqnqZp2kcTQiD3OJHJAA")

            ..description = "Not just another carapacian you can meet on the Battlefield. A rogue Dersite pawn, WV wants democracy - or, at the very least, lack of all-destroying monarchy, and is willing to put the work in to get it."
            ..sylladex.add(new Item("Firefly in Amber",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.SENTIENT]))
            ..serializableSceneStrings.add("Deploy Democracy:___ N4IgdghgtgpiBcIAiMAOAbA9gTwAQqkwGMAnCI7EAGhADN0IA3TEgFRgA8AXBEAZQDCAUQByQgPoB5AOpiASuJEBBALJDcAazCYA7gGdcASy4ByA10OxcXTLjkBJPuoCqABVwQA5hENg9XawALGFxCSBIiQOwAOlxcViU5AHEhVkVVCUkFZTU+XECIAwAjGBgwXExGGBIuQJJdMGjqEC4IEk8YLkkwOEQuEgBXOBp+w08OkgFMMAATY0NpvQAZQ0ZfT14AbWAAHRBLVBZWsC5pFhm9+D2RAHolPapryVZLvdoIdD0YB73IWFeQPY9Ep0KtvtQ9gcjhATvYTgCAAx7AC+VFwu32UEONRhp3OAKUIgAmj8QCJngD3p9wY9wNBwVdAXoBG0IKhyDTIVjobD4Qg9kiQKj0Vzscc8SQLvyyXdSeSXtKqV9SX8GXsABKFAT1HRgUlQnG8riIlFojEG8VnSUA273CFkinS-pDFX0gFAvgwdC0fXcw1cOHG6WC4Xmv2W-HS21yx2MpWcun-aX2JRQbUNGBS2kW3GBk1CgC6zVG42qU1m80WSxhMy2RZoMFotBgRC4egAYiwVmswBtENtRTyJVLGdH7ar3X5WgBpQzodC+sW4kQDKAlEj55H1kCN5utjtdmt6OtCoA")
            ..distractions = <String>[" WV is distracted eating green objects rather than recruiting for his army. "," WV is distracted planning the civil infrastructure of a city, rather than recruiting for his army."," WV is distracted fantasizing about how great of a mayor he will be. "," WV accidentally tried to recruit carapacians already part of his army. Stupid stupid stupid! "," WV gets distracted freaking out about car safety. "," WV gets distracted freaking out about how evil bad bad bad bad monarchy is. "," WV gets distracted writing a constitution for the new democracy. "]
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCharming(100)
            ..makeLucky(100)
        );

        dersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Jazz","Jazzed","Jazzy"], lastNames: <String>["Singer","Songstress","Savant"], ringFirstNames: <String>["Jilted"], ringLastNames: <String>["Seductress"])
            ..specibus = new Specibus("Ribbon Mic", ItemTraitFactory.CLUB, <ItemTrait>[ ItemTraitFactory.LOUD, ItemTraitFactory.ZAP])
            ..bureaucraticBullshit = <String>["needs to renew her liquor license.","wants a permit for a public performance.","needs to pay a fine for singing a song with banned words."]
            ..activationChance = 0.1
            ..companionChance = 0.4
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
            ..specibus = new Specibus("Fast Sword", ItemTraitFactory.SWORD, <ItemTrait>[ ItemTraitFactory.EDGED, ItemTraitFactory.POINTY,ItemTraitFactory.METAL])
            ..sylladex.add(new Item("Postal Code Map",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.PAPER]))
            ..description = "ZC LOVES the mail, not because of letters and packages (how boring), but because of how elegantly designed Derse's Zip Code Map is. You can find anything so quickly, so easily! How did a goverment famous for Red Tap make something so fast?"
            ..activationChance = 0.4
            ..companionChance = 0.1
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
            ..activationChance = 0.4
            ..companionChance = 0.1
            ..serializableSceneStrings.add("Teach Doom Ward:___ N4IgdghgtgpiBcIAqMIGMAWACAIgezyiwHUIAnAExABoQAzAGwgDc8yUAPAFwWQxiwBlAMIBRAHKiA+gHlikgEpTxAQQCyorF1SYYAZy38sSFQoDiopMvXSZS1RsFYIWAO4QAnljx035CgCWYADm3nS+AA542mBcARAMWBQEUAB0ADpgADwARmQAfLkFWDQgXOTBMFwyYHCIXGQArnC0DQHBlWTCeGCBcT16ADIBzEHBvADawOkgAVBRZOWxxGwUM-Az4gD0KjPUmzJI6zN0CXowezMAagoAkoIA0rsIJ2cXNDOQsMcgt3oqDBG732s3mbCWXFusR+AAYZgBfahYaaghYQlaUH7bZ4g8SHH4NZqXEA3e5PH6nBjnYlfd4bX56QQwBh0YlzNEQWJQriwhFIlHs8GcrgYtYvEDY4l4o7iynUj4ku6PZ70uXAz7QOkzP4ABSYHhgZDZYMWwu5vJAiORM0FpuWqx++EIJH8Uvx4sJ6sVZJVrypXtpPwAEhA9AAxMieKDRAJ0YgBLgYcSa40crnQ8Vwy38m0m9EO8WShXSilvYmk5Wl-00lPipAVKp-NQeQaoCiG1NC9M8zMIgC6pTaHUN3V6CYCA0GnKoiAmA9oMHCMDQXHDbGGoxCkwFeeFosdKRdlHgUlPWHEABZbsEKMEMMEuMEIgEAEJoW4qV8AdjDAFUVKIL4AIzCCoYAqAAUgEKg4AAisEKiNACABWgzBNBtwAF6iMhF6uDgMgqBwyGwd0KjEGoZgqAAHAwwQvh4Ki-rBL4PFRKgAKz-gAWgEDAcAoUBmNxjQMBeL5kGgUBBq4ACav4wqhYAPAA1ioZAYCoKgAExmL+DCuAEKlqCoFCYZhHFhjIADMdDIQosGmURyFIBEahXAAjsQskwio4hkFp+DBJhDwKN5dAvppgy3BAlnCGYUBaR4GAeR4HnyQoGAqTkCEcchwgqTCxCiDBYYMBgADUqgsaRgiyS+oiuKIOoYNRML0cIGBcD+tziA8UCYTgkUqIMHGiGYDxBllv6-rcaAKFpQY9BBZhmCp3EccQCjiQoagcLcZgABqiGGVzEEBACcECCOImHEDCFAwgwMIXRBYDaTgI14Ahvk1t84pmECEZRjGrIKhW5KymWCq2hC4iNFAOQdr2lrziAi50Muq5huu056JMA7wkAA")
            ..serializableSceneStrings.add("Strife The Doomed:___ N4IgdghgtgpiBcIDKAXATgSwGYwAQBUALPAEQHszYATEAGhCwBsIA3MtfGADxQRCLxIAwgFEAciID6AeQDqEgEqSxAQQCyI3AGcYYHVtxUKUbQFc0aMqbBUMYAOa4UxAioUBxEfmXqp0paoaSAB0uAASeADGEGBgZCi4EIyMZADuToQYWqECrh5ePhoyAb5IuFCmWgkARnhVZAAODTBUoQCSCVlOFLjMKHhY7NpJLBAoGGRgwQA6YAA81WgAfAvLdCAoEGj2MCjSYHCI6KZw9OgY9jtoQpO245NaADIYLHb2fADawNMgGFAN7E2YBQsnYVB+8B+YgA9CofrQodJ8BCflgkjp4T8AGoKNpIADScIQqPRMEx4GgZOJIDaWhUjBeVIRv3+gJiKDawJRIAADD8AL60XDfFkAtBAkFg7kwonMsRI7loxgYujY3EEomQhik8mQWDctoqKBCSypA7g1WitnAzkobl8kCC4U-P5iiWgtAWrUABTSMDQ5PlyOpxyZarxhMVOsteqpWvwWx2KFQY1p7jQMDG-qIMTUdjDVvF7Nt9oFQpFrutks90thgYV1KVKuZOIjmpJyoLsYNWgUMSMUHJlaLNq51IATABWMvOwvuqXUpAxDAoACe9eDWtD5NbGqjnd1lO5alXKY5WnTmf6HEIMSxSROQ9ZI45Y61AEYAMwOp0V5-zmtqTzMA-lMExHlMSIAGsN25bdLV3SNG2jZlu2pBNtl2M80wzLMbzvB8C2HCUS2pABaL8f3LF1-3ZD0vShOtLSDOC0EfBD1SQrUmy7I9qTCCAtBNNIwCfN1izfH4fwAXXWc5Ln9G4bBXCY9EeftPlk+gYCwHBIhQLQADF2GeV4HE+P9xOBeja1lH40K1FNxVQTAcB3Tj221A9LWI9kxDA2oA2pGT1h0vSDOMtB1JsLRNMdIA")
            ..serializableSceneStrings.add("Grant Salvation:___ N4IgdghgtgpiBcIDiAnCYAuACAyhANgG4QYCWA9mCADQgBm+Eh5KAKjAB4YIisAWMXAGEAogDkRAfQDyAdQkAlSWICCAWRFYAzjDA6tWACblyUbQFcUKcubCHSYAOZYMArKxUKkI1svVTpJVUNHAA6LAAJQQBjdDBybAJ8cgB3Fz5SLXD+QQ8vHz8NGSD-HCwocy1sACNBLQAHCBQYQyw6azNXQV1DcIBJbEyXUlg2lm0CYjJKUIAdMAAeapQAPiXVmhAMJscYDGkwOEQMFHM4WhPSR12UIUp7ab0AGVJCB0ceAG1gWZAR+pY20wshYhl+8F+YgA9CpftRIdJWODfnQCDo4b8AGoKPo4ADSsIQKLRMAx4GgpKJID6WhU+FelPhfygAJQQIwfUwyJAAAZfgBfahYH7M1nskEoMFU6GEpliRHc1H4dE0LE4-GEiH0ElkyCwbl9FRQITWFKHKVM-6A9AcrlUvkgQXC35Wtk2iVSrUysnypFUpUqpnY3EExU61Xk-VUmkKdDGKBk13szkYbkAJgArAKhSKk+7Qdy8GBSBgAJ4+hX+8NB9WhqvKxm-PWUrVqUs4bYcrSoGAkGBsPjoTEEM6JlnWzAp7kARgAzA6nbnx27gQWqWoHCNzGYnuZogBrCt+rUnUcR4MasMN3UU7msHZ7DskGk9vsDocjxuiie21NUgC0c4LjmLrLuKa5ejCR7cqeX4XnWWoBl+zbchEEBaCaqRgGOYo2lO9oCgAupslzXP2dx2CWFDPHGXzEbQMB0HQMDRBgWgAGIsC8bxOF8S64aukrcmoEAcFuO57oeEYoVSQiDk4MBPn+NYhpqxLXhGeaYGI261CgM7ztmzrfiuGAesJm4VBJB43lGWpyeguxKWS8FqdqGmWmBNo6VAekGQu9EgIxzGsRxXFxlodGOkAA")
            ..serializableSceneStrings.add("Find Comfort In The End:___ N4IgdghgtgpiBcIBiBLMATABAYQPZQDNcAnAF0wEkxMAVACxkwFEMQAaEAgGwgDcSaMAB6kEIeowDK2JgDkmAfQDyAdXkAlBbICCAWSaYA1mFwB3AM6ZSuXJigBXAMZ0AdLQaYYGKyliWIxIyO+GgA5myYEN4mpHRhmI5RmABGjOi4YIzWmObWAA5WDFBukvgwdGaFKJbVCfhEZPHZsVIy8spqTJo6+hFRWB4EaOiW5lEopACemBNGJqZNdBDkpgzULZ7ewX4RHgtcXCmMeYF5ATDoLgA6YAA8ycQAfPdP7CCkAaEwpEqZYqTEexwDgAlChL7EPAYCYoDLmAAyKF4YTEAG1gFcQL48iQPmBSCoSOhMfBMbIAPTaTFsMlKGgkzEECBccwwamYgBq6gokgA0lSEIzmaz2eBoGzBSAKOZtFwkRKaVioDiyFFSFRSAyQAAGTEAXwiGKVKrxBKJWopAsVsjpWqZLIVnO5fIFpM4wsdYtgWulkhgXAIouxuLVGq1upABswRuDqvxhOIxMlltFNvpkvtIvYTp5-LtHtFkG9kul6n6+CDypD+LDkoArBGozGq3GzYmtUwhHkYMQUF5HJ60-mHaKubnXUKR9mvRK3bpJpIPurzABxQLLHv0KIc5lAysm0P4rUARgAzI2ALpvUHgntQ9AwuHw-poq8cGAEAgwRykcxIEiIsiYChGizYHvG5qSpI4xTIW4patgSzATAi7LKOzp5hmBbTrGpqyPYUCpMQJ7nvqb4gB+X4-n+AH9OYr6RkAA")
            ..serializableSceneStrings.add("The End Is Really Nigh:___ N4IgdghgtgpiBcIAqALGACAomAJugkgM7oBKMEANhQJ7oByAlgOYogA0IAZhRAG4D2AJyQwAHgBcEyNOgDKAYUx1MAfQDyAdWUkVdAIIBZTOkHQARhRjF+YdBDP8AruPTiZEAA78AxpWofCDHF+VxkkPRIAcUwkXUNVNR19I1l0BlsIWwAeBgA+MXFBGFgaLIB6PPRHMEDxcQp0pnQoTLAYQQA6AhdA4uIGgGsglAZicQZYUIwFJQStTCT4u29xR0oadAGwfgB3YghQxvQhVx2Q+ycXHZQIFzQAcmJCCGpGrtQMcKiYuKN1RZSHSBy1W61onBgMAo+3QDTqlnQOH4-FgOAA-OgNDcXG4MGgqGiADpgLJmQS5Unk9ggcQQQRMGDiNRtKSFRxwDiFZgMwTyGw4BjjGyEAAyDF4jSkAG1gISQBMvIJaWBxBohDg5fA5XQyno5WxtWokJq5ZxKIF9XKAGokfCyADSeoQpvNMEt4GgbudICIegavC9BvlUEVyvE+BVJpAAAY5QBfNjoWXB0OZVXqqM6p1BuhGqNm6GB622h1OrVcV3uyCwKNEEiZJFQd0KoRhiPiKMAJgArPHE8mW0q02rBBrvVn3bnjd62UWQDa7Y785X2HLq17y0RZFDOM2Q620+2o7GQAmk3LB2GR2PyxPVyAp1HZ+6F6Xl4Wq56owAJCCEeSCLsYB7qmKpHt6J5ngO+5Diq15RpgogeO0DAwGA3hzo+3oFha96vku2ErkG65RgY1CyLS4aEJERS3O0qCZFalDsiBB5gZG3oAIwAMyQf2F4wVeGbjrqk55oRH54SWBHljhc4kd6RAAGKAVAAAi7S4UGl6Hhx5Z8eeKZsemo5RrImSCtQYnTrJRHFouZYupJxFft6SB0gy4gUbcRA0eQ4j0TcYBMRQLH3jp7Edt6AC0PHRvFfaGRFJk3nKiHIYIqHoZh4nls+UkOe+Wlrq55bufSjLeVRfl0cIQUhWF2mCbpUXlnFkEALrUlyTA8nyuCCgwwoig20pdRwMCcBCKyEEpQhihKYBMNK0GgSlZkWeIVn3gp5byEFDJVS+0mORWzkCWtdCOFAZjtFGsW8Ylq3GfB3oGOkEzXegIqON4AyfjW3r7Zkh2UcdhUScVRmweIV03XdMVxfG40gJN03iLN80NoQY2nkAA")
            ..serializableSceneStrings.add("Read Philosophy:___ N4IgdghgtgpiBcIBKMIBMAEAFAFgSwBsB7AZyIAccBPEAGhADMCIA3IgJwBUYAPAFwQhOOGBgDKAYQCiAOSkB9APIB1OUnkyAggFkpGdqjQkMZWBiIMM+Y5UKkK1DACMiRANYlaGAO74AxjgYaDAMeGB4fDAEVBh+RGCh7FAYfDgQfCkiGDBgmGgQVMYQBrFEUGEA5gB0GAASRN6lAK4EmBBgVPGiUSSiYEQZvaKpeCQA-AA6YAA8TuwAfLMLdCB8xRUwfIpgcIh87E1w9Pt4FRvsEvFoEXjxJAAyeCyVggDawBMgeFDkHGtgfGUHDQn3gnxkAHpNJ9aODFJxQZ8GBACL0YZ8AGpIACSYgA0tCEEiUWi6J9ILBESBsSRNAQnjB0V8fn92nxsQCqQAGT4AXy8H2Zv3Y-0BwKpkMJsJAMnhVORqMZZJAWNxBPlJKV0opSrB1JIYiiDCZ32Foo5fG5fIFn1NrIBQPYIKJMqhTNlCJdCtJ0tV+MJeu9WvJ0F1nxpSHaaDKJpZIrZFqpAFYeSB+RhBXb4w7xS6pDxyDB2Hgcn5gzK5S79ocmX71V7NUydVTtFQxGt2SQAOIGdJF4TtDEomvKrPmzkugCMAGZU7yALorE5nIuXXI3O73KNvRf0EIMGB+PgkABiHEezzAFTembjosdzr1+cLxdL5ebLokaSvMHb6VrOL+hqiqxmabIyE0UBOEWVIznyu4gPuh7Hme7BbrkJA7mmQA")
            ..serializableSceneStrings.add("The End Is Nigh:___ N4IgdghgtgpiBcIAqALGACAomAJugkgM7oByAlgOYogA0IAZgDYQBuA9gE5IwAeALgmRp0AZQDCmEpgD6AeQDqUgErSSAQQCymdB2gAjRjGJsw6CHrYBXPuj7CIABzYBjCIwCeDwhj5tbwpDUlAHFMJFVNGVkVdS0RdDJTCFNLMG8+PkZEinQoZLAYDgA6dABNIxKANUL3dFT0zOyS1Bhatyg2Qhs9GCyYFgwyPhK1Rg6uooAdMAAePQ4APjnF2hA+CA4KGD5ZAsE+Dks4OgPKLY4xExwhshNCABkyFmzBAG1gSZAyKCcOdbA+PJODhPvBPiQAPRqT40cGyJCgz70NzeGGfSpKfAiADS0IQSJRMDR4GgRPxICIoyeZNhXx+nH+fHwAMRIAADJ8AL40dAfOm-RlAjgg8mQvG0kjw1nIxio2jozE4vFghiE4mQWCsohKZI4NhQYnfAXJJks8kAJgArFyeXyjQyTUKRSqxcTJQjyQcjsSMVjcdK1fKSZryUQRL16Ib6X8Tcy+KyOSBubzPvaYwCnazXUH3ayvTSFX7lQTZQXg2SVQAJCCEMQcNgAdzAUeNALjCZtKf5DozwNZmB4DkKZBgYGcZdznsOZd9SoDpfVpNZGncInWTMIwQ4MAgfEKqGSlTc3qDacZ7fJAEYAMyJ5N26OCvuiqFuqXkmVy2mz-0fwO0jUK0+IgADF6ygAARQov1TR9YzNFU71tWDW0BZ8VREZIhncN8PRVfMfUVX8VU-MtANZJANi2Pg113Igtx3PcuBQQ9jzLM94PjK9b07B9UMzclMLAbDcPnGCQB-YtVQXINyPJSjNm2WiNwY3d9xYsAj0YE9aQ4tsEM+ABaG82TvABdVZTgoc5LlwG47nuXU3gsugYHoegYGcPhCBAzhHmeMAKDePiezQ4VWSEkTZKXckxA0rZlMIosxPYuCARISwoB6DhWWM68uRckA3I8ryfL83VCGcpMgA")
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
            ..activationChance = 0.49
            ..companionChance = 0.01
            ..serializableSceneStrings.add("Perform Really Weird Surgery:___ N4IgdghgtgpiBcIAKMBOAzA9qqACASjBADbECeuA6jAJaoAmuAygK6oDmaZIANCOsQgA3bABUYADwAuCEKIAWMZgGEAogDlVAfQDylTfi3qAggFlVuAA5osOAM647bTqgqYwuKYtyjj+AOKqokZm2jqGJuZMAHS4AJJSuFAQANYwDmSYLLgA7u70aLjymDmO3mkwlg6KqLjENADGMGB2MDy4EGCMXkq+AUEh5roRoUy46DAwxA71abgFEF4d6FKFNFIA5A707jDRADpgADwARqgAfKcXvCBSEBwwUjpgcIhSqCxwfO807C7K+XWNHcdgAMjQhDQwOxZABtYD7EA0KCWbB3MBSSjYeiI+CI9QAemMiJ4+J0olxiPQJFaJMRADV8HEmABpYkIKk0mB08DQbkckBxOzGepCfmkpEotGdKRxDGUkAABkRAF92gjJajUOjMdiFYT2RL1OSFe9PjzGcy2QrqdNxYjILAFUKmFN0DzkVqdXKpArlSA1bgNZ7pRisQwFQAJIjELw840UgVm+0gS2s9l4-hcnmO-mZ0T3ThSJh3WV2fyoIirVAKTr0kjm3iIkPamU+hUARgAzIre-7A8Gpa2w3qBQb4yaBbbaU3U0z0zbs7Pc867PhOjsoB6h975QKAEwAVlV6ubO5l4ZxY6JE8TmenKbT1qnS4lK4FQoAYqhMFAACJoDOEotruvoCv2p6aqGuoRtehpknenJ2ha87Pver4OnyzrGFAyg-jkLxXsB54Yu24EnkGZ5eheo6ZuOs4JqaHyPqhGZIUBmFOgKkYQHYeElGA27UaRe6Zv2AC6Nw-H8aAAl0QIgqCG5wpJfAwOgEwNFIdiftg4KQtCcKDsJMFXpm0YkHGy5YQKyjyJ0nAlosKFWmxWbIbOIEyuoLBQCcaCdj2vYUcZ0GXlGMZWW+NmZnZDkwE5YESk+bkPkJ0E+X5AUCt2fYhVRYW0YipiYCcND1FIZA5jFiJxdCCWli5C4vh5xEmZl-moAqAC0uXBQGkFeSOsGZkwnTrFV1lcbF9n1YlTVoexKZDVIHXZZmvVBRJNzqZp2m6agSldHYKkBkAA")
            ..serializableSceneStrings.add("Harvest Health:___ N4IgdghgtgpiBcIASEBOA3GBnALgAiRggBscALEAGhADNiJ0B7VAFRgA8cEQWyY8AygGEAogDkRAfQDyAdQkAlSWICCAWRF4ADjFQ1mULHiwBXVAHNdATzyMwecvxYqFAcREtl6qdKWqNAgB0eNKMWljBvE4u7p7+Pn7eAngAlkYAJkTpwSr4xES4DnyCohIy8iKJGniWOEZYjLB4UMz8fCTktib4jDSpOIEAOmAAPABGqAB841NUIDhotdJgcIg4qCZw1Osp5paoQnbpKTgpdlgAMinoKWDm3ADawIMgKVBazAtgOLLM6S-wF5iAD0KhelCB0hYAJeNBIWBg4JeADUFABJAQAaTBCFh8MRVBekFgMJAaKwKmI1wJENe70+EG+aO+pIADC8AL6UPDPOkfVBfH5-UkgnG0sRQ0nrTZIkCojHY0lw4gI2XEgmAslYAQwYg0WVvfmC5k4Nmc7m8w0M76-VD-XEgUWyiXQh3K1WEuXorE4zXumlE6Aal7khSM9KNA30gWMnAm0kAJgArOaeS8rTGbcKHU7PS6lfjZfKfQWVQHwEHSWiVFAhKhGAB3Fb22kZ40sh3skBctN861Cu0i0HOyUO6Xl4uKt2Fz3q0koLB1xtgKNG2Pxzupy3RwW2+2agAKjd0I9dmvHRe9U79M9pc4dLEWMBwAgWcawrlQRBwul4jLUtzlm264dpqXYcgAunMOx7LohxgMcpznBc4aPFB1AwDQNAwAAxnUABizBXDcdyPNua5ZoOObDrOlYOsyuAQJiKTEMQl4Kr6eJlqu-ZiCYUBjCem7dha6Y7rGe7zkQpBkGqdGakIZCMpYahWK+ECmp6k6cbQt5iRROB8QJQmagAjAAzKyVmcuhICYdheFYIRqAoQhWBod2QA")
            ..serializableSceneStrings.add("Perform Weird Surgery:___ N4IgdghgtgpiBcIAKMBOAzA9qqACA6jAJaoAmuAygK6oDmaAniADQjoA2EAbtgCowAPAC4IQvABYxKAYQCiAOVkB9APL5FAJSXyAggFlZuAA5osOAM65zNeqga5MYXEMm5eOjQHFZvbfuUqWroGFAB0uACSQgDklhDsUJjmQrhUYABGMBCoEOnsUkKYuADuEEIAxuLMuBBg5C5S7l4+fgaqQf4UuOgwMOyW5ZhQRvlCffYQxehU7DXoY6i4RDGWpI4woQA6YAA86agAfHuHLCBC2fRCKmBwiEKoVHCs90S0ttKOpMtEjuYAMkQuEQwLRRABtYCbEBEYbYc5gIT4bCkKHwKHyAD0OihzHRKl4qKh6Hi5hgOKhADUNBEKABpbEIIkksksKGQWCEkARcw6diAlm46Gw1DwoQRBGcgAMUIAvtVIUKjHDaojkZzMQzBfJ8Zz7o9ySAqTT6Zzif0BWzoCy0VzzBQ+ugDTClSKVeKhFLZfKoc7lQikWROQAJLLsFwG7UExlnB4Ww3UukMm1m0kG9nWqG8C4wIQUc5i8yeVBZBYSWoU+L61mKv1iiXRgCMAGZJa2vbgFb7Xf61dGNRGddGU3GjYnTcy01bOdyNLU1lAncLRe7OQAmACs7c7S5VAZRfaxA6jyYn1dHJqHp8F6en5gAYqghgARNCp6td5f1m3SkByjs+nce0DaNZAEExUCIGAwHKONI3Hc0DXPJMmQQ6sb2jLM6BzPMym5IsSzQMswArdgq0FD83S-KFmx-P9txdUU93VQ9qzg6M9RHBMLxPVDrynaMgwgcxpEfYowEXBjKI9aNaIAXVOF43jQD46m+X4-jncF5NYGB0B6cohHvbAASBEFwXo2smIE0NwzQ-ibWkcRanoHDpMFJD4LfcjAKEeQqCgTJUE5GjaO9Gtu1VYCbRDeJbL4jlo0c5yYFcxCuOQtgrwAySET8gK0GCltQv-cLGN7G09EwdIiD5IQGEnBKHKckEUvzNLjQy4cJNrPLAs5ABaEKt2yyzyqhChamWeq7MaqEkpa1Kz3Szy4wo3L-L66NBqK2VtJAXT9MMu9jLncwtN-IA")
            ..serializableSceneStrings.add("Create Taxidermy:___ N4IgdghgtgpiBcIDCAnGEAuMAEAVCAHgJYAmMKUAniADQgBmANhAG4D2KuMBGCIuACxwBlJAFEAcmID6AeQDqUgErSJAQQCyY7AGM0mGAGdsEbBkKlyVbG3onsZCCV0QUEAA4QdRCGAB02ACSYA5sRGAA5tiGbDTRQtiM6ChgxqaMRBgYSdgARpnYUBw4ELlsAK4YZgkA7hCUeWwkREbYNRwA1iZgzgJsNWZsNu7kBjYhGEJQfgA6YAA8uSgAfIsrtCDmKBEwGLJgcIgYKOVwdMdEETsoSGw9mUR3hgAyRCzhEXwA2sAzIERQdwccxgDDyDgkP7wP4SAD0aj+NBhslwUL+9AgjEMMERfwAakpAsIANIIhDozHY3HgaA48kgQKGNQZFh0pH-QHA3wYYIYNEgAAMfwAvnFfhygSgQWCIfy4WT2RIUfyMVi2fjCSSydCGJT1TTYPzGcIYIx6NSAZLpbz+UKQKLsOLLVzQeCUJD6fLqUrUfTVVTaBqiaSVXrqZBDfTGUpfCQ2FALZypdybfSAKx2h1OpPSt0enViAgjFAtMA6fU+-nHU7UgnB7UUtXh2n8jSUYTmHmGADi+iwnAEvjxmJrgYlLp5oP5AEYAMyZgC6GwuV3It3uGEeqWese+S7oMHo9BgOgwhgAYhxXu9It9s1buXn+YXi6Xy83IzqkIPIjAO5ha01EM-TDMdnWTUEJHKKBcnIGdZxFfcQEPY9TwvK9Y0MPd7SAA")
            ..serializableSceneStrings.add("Perform Surgery:___ N4IgdghgtgpiBcIAKMBOAzA9qqACAygK6oDmaAniADQjoA2EAbtgCowAeALgiCwBYwCAYQCiAOREB9APIB1CQCVJYgIIBZEbgAOaLDgDOufcTKpyuTGFycBuFioUBxES2Xqp0pao34AdLgBJTgByQy1UGE5OcxJUQhh9TFhrTFwAdwhOAGM+KlwIMAATa1t7Jxc3DRkvd3xcdBgYOkN9OkISEgBLfT589E40XE6Qw0LLGF8AHTAAHgAjVAA+eaXqEE4IUkjpMDhETji4GgPOjrQhS0Lhzst9ABlOxk6wEh4AbWBJkE6oLWwNsCcWTYQpfeBfMQAehUXyoEOkLDBX3QEGaMFhXwAagoAvgANIwhDI1H6dHUL6QWBIkABfQqOiPMlw76-f4FTgBQHUgAMXwAvnlPiy-qgAUCQdSoYTmWIEdSDvEMSBsbiCdSUWilZSyeCafp8E10EqfiKxZzODz+YKvia2YDgahQUSQAAJGComxK2WI50KplYnH4wm6jWkrXQHVfFibMicfAbDn6RwRTJofgFTGoxXk4V2jlc50ARgAzNzeSABbghbbReyHU7dVKvXLnaH-crA2rWyT29rqbSFAUxlBjaza4DzdSAEwAVitVZtY7F9cl0ObPpDPaVKqD6q3Ob7ztpADFUEkACJoMM5mtmgu68uV6tLusS50idg6VCdGBgLLt715UObdO2DYlNQPCNqWjLY4wTWlk3dAZUHTMBMzadtb3ZSci1Ledn1NV9HVXaV4Q3L4-RA1UwNofdmUPXUXQgfQhDPNIwFHQiJ3vL5HwAXTWE4zlQC4imuW47iHd4BJoGB0AaLJOH0Y9sAeJ4XneAi8xXZ03Q9PhwypZ0hD4AoyHjTIqN3bsIOZLDATEQgoDmNBqRLR9rVzcdxWI3T3ToT1IKM3UTLMmALItHMdy7TdbMXLjOEc5zXNwjyFy85c311NRMDmToGWiQzIxAUKXnChMrJi8Drzsl8HKclzUGpABadz8Pi7Ssq+fACmGcgiupUrzIqqLQL3OKMvZJLGpatqKxkkA5IUpSVNQSSin0aSKyAA")
            ..description = "She knows how to fix your arm, sew your wounds and how to preserve your corpse. She is good at taxidermy. MD is your friend. Sometimes. When she’s not killing you via malpractice."
            ..sylladex.add(new Item("Bloody Scalpel",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.BLADE]))
            ..bureaucraticBullshit = <String>["is getting sued for malpractice.","needs to refile her permits for all those taxidermied corpses she keeps.","has to renew her 'medical license'. "]
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeViolent(100)
            ..makeCunning(100)
        );

        //SI	Invention/Gaslamp	Silicon Introvert, Sparky Inventress, Saddened Illuminator 	"Silent InversionDerse
        //ai by tg
        dersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Silicon","Sparky","Saddened"], lastNames: <String>["Illuminator","Inventress","Introvert"], ringFirstNames: <String>["Silent"], ringLastNames: <String>["Inversion"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is scribbling blueprints for a bronze automaton powered by Aether.","is cosplaying various gaslamp fantasy outfits.","has passed out after spending way too long up inventing things."]
            ..sylladex.add(new Item("Glowing Crysal",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.FAE]))
            ..description = "An introverted lamplighter, SI knows how to make gas lamps, lightbulbs and automatons powered by light itself.  She is quite fond of her work, and will gladly explain how illumination on Derse works."
            ..specibus = new Specibus("Spark Rifle", ItemTraitFactory.RIFLE, <ItemTrait>[ ItemTraitFactory.ZAP, ItemTraitFactory.SHOOTY, ItemTraitFactory.POINTY])
            ..activationChance = 0.4
            ..companionChance = 0.1
            ..serializableSceneStrings.add("Fabricate Automaton:___ N4IgdghgtgpiBcIBiEBGAnAlgYwgFxgAIBBAVzwHsp8KwQAaEAMwBsIA3C9AFRgA88CEAEk8AcgDOhPJlgA6QtwAWRAMoBhAKIA5TQH0A8gHVdAJT3biAWU2EA5vhXoppAA6EILFoSeFULUhhXLDA8KUpCbHQYfCIIQgAeVAA+Bwk2KHcIcioaMDkEgHoUwgAJGHRCVwoAdwr6QgkIMEw8AE8G5oATQiZoohrML0aAazb0CmwRmDw5AB0wJPRkpeSGEDwIdDsZgzA4RDx0QPWjzDsd9HVaLtbMWgkAGUx2TDA7IQBtYDmQWWr0JtQkYuF1fvBftpCsRfvRIQZuODfkxPBIYLDfgA1UzCVQAaRhCGRqPRDF+kFgSJEElUMBYTAxf0yXCBeGEoSpAAZfgBfBo-JkA1kg9BgokgKGEuEShFUlEsNGM7G4glykmMimkiHU4gsF6k6X-FnNNkc8XckB8wgCo2Ak0isXayWM7Sy8XyxVkkDK-GE7Ueg3k6Ba37CYhQdQTGr7MWG5l20LsvBc3n83624WgqmqZqtNout3ao6BJU431qhWB8DBqlWNqqTZsiQAcWisR4SmamM8Ja9GZNSapAEYAMyc8ep63p+OZ0VU51e12I93qr0+1Urysamvi4QSUzdKiM-uJs3agCsFp5AF1TlgLhVrmBbjIHo9ul9b4wYEwmDBsGESBcM8rzvF8NozvaWbigACrUFTbpS4rqJ27wwA2+CliqfrElufaQaE2ikFAqAIeKo7jleaaCsawLQdqOYtO0iEhiAKHNDsGHJmuZYbv6q5xkKJpESRZHahRE6WtRJ54A6VJIP0hBGEMLAsVS7FoVxWHlpunqCbReAiaR6DDmOkk3usP5-gBEhAeg77PhIn6WkAA")
            ..serializableSceneStrings.add("Provide Advanced Invention:___ N4IgdghgtgpiBcIAKAnA9gNwJYBMYAIBBHDCMAYxh3wEkwMYwAXLNMEAGhADMAbCDGhQAVGAA8mCEMIAWBAMoBhAKIA5ZQH0A8gHV1AJQ2rCAWWX48AZywBzMJfyW0sJjKxgb+bkPwR8rgmFCfQBxZWEjU00tQ2MzeQA6WiYAcgcyXzBfEjJKahsIS34oAAd8dwZmVizXCCZ8ACM0NEsmBxK0AHcYFA5HMiwmAE8+smpuFBgCTqxeXgSAHTAAHgaUAD5Vjc4QJggUGxgmLTA4RCYUAFc4LgvbQ5RFNhxB6ssAGSxsDykAbWAFiAsKUhHtmDohDhAfBAaoAPSEQEcWFaYTQwEXa5IwEANX0NHkAGlEQhAdwILxLDBseBoNTSSAaJZ5DBeNwacCOigwUw6Ex0SAAAyAgC+fQBQJB3LITAhKChDPhJORIFUqIF5Mp9JVeIJxI1FKpNMgsAFTMIvC+2sBnNBMr5AuFIDF+Altul4MhAqVNLVaIZmqNnFx+KJJJhPEN1tppoZTP0Y2cHKlPIdDIATABWUXim0pmVyhURpBdHq+9UMzHR3Vhg1a410gXCfaHJjyPa8ywhSZ1HqyMg4ilY4OSrmp5gCgCMAGZBXOc6682OC16GcoxCUelhGJRy-6I4Hq6H9QGow3YxGTEN23Umd2YL2RDIB0Po+7x-yGTOnS63fnPfK3oInudZBjqx7hmSZ4jia9IRkyABi6BQKgLQlIMybLswaYRj+AC6Ox3DYDxPGALwsGwHxjH8BFcDA3DcDA5BtAhQifN8Nh-H+WGyquxalig55wYCijPh4MA3p+4F6pBkb1iO74yqolxQA0ZZfrOP65qOdoAUWgLyAMwxCQKolkIckk0jWJ4HtBKqKcwymqepEbflpi46R6vGAQySFTPgOizLwJkMmZ4mWSO1myYemG6UwTlqYJGnzs6tEgPRjHMZYrEoO8YyWDRzpAA")
            ..serializableSceneStrings.add("Design Blueprint:___ N4IgdghgtgpiBcIAiMDOBLA5mABAIQBsBXGABwCd0wAXEAGhADMCIA3Ae3IBUYAPWxFwAWMHAGUAwgFEAclID6AeQDqcgEryZAQQCyUnOlQ4hEcgBMcEajgDunANY4zaLGCqZLOAEbEylGgB04iI4pDDkjJxQRtRo1EY26NRCnqym6DDUAJ447Iw4qEJUObDUEASodDgsUKSVlmAWBFhC1l5EBF5GRDToBAUhmJlGqOylRWAeyVbV7Oz2Rs32okk4AMbsHRZ25PYBADpgADxe5AB8J+f0IGXkQ9SKYHCI1OQk169YQ+QS7I1J6D+qAAMuhWO4ECAANrAfYgdC1ThlGjKThmOHwOEyAD0WjhdCxii4GLhjHKqBg+LhADU1ABJMQAaTxCFJ5Mp9DhkFgJJAdNQYhgBEYVPhiPIyOodJovIADHCAL5VWFi0hIiAotG8nEsgkgGRE3lkiocvW0hnMo3s0XcjmYvmoLTNVimuEItUSjVSmWskDykBKnAq93qzXmXlSXhhSgwMBrV36w2+14kUXmpks+3Gik26B2uE6LJiMpS1AAcXIMCs4WEGup5VTnNVoe91F5AEYAMz+wPB8WS1Hh3060UG4m+7MJ9OWifWpu23n8tQasxjUUhz00aVt30AVh7AF0PpRMN9fv9qICwCCV5CoUeGDBGIwYGt4gAxTig8GTO99j0DlqvqRtGGRxgmC6+hIJiTDAxZWGm9IZlaJrrv2XoyEQUBeOEHadoqD4gE+L5vqgn7kMCK6oHeR4KkAA")
            ..serializableSceneStrings.add("Provide Basic Invention:___ N4IgdghgtgpiBcIAKAnA9gNwJYBMYAIAhCAZywGN8BJMDGMAFyzTBABoQAzAGwgzRQAVGAA8GCEIIAWBAMoBhAKIA5RQH0A8gHVVAJTXKAggFlF+PGQDmYEvhJpYDKVjCX8nAfgj4nBQYd0AcUVBAxN1DX0jU1kAOmoGAHJbbwAjUgp8S1JeKAAHfBc6RmYwHykIBnxUtDQSBls8tAB3GBQ2OwgwLAYATw6unHcUGAJmrG5uWIAdMAAeVJQAPgXl9hAGCBRLGAYNMDhEBhQAVzgOY6xLHZR5Fhwe0pIAGSxsVwkAbWBpkCx8gSbRhaAQ4X7wX7KAD0hl+bEhGkE4N+xzOcN+ADVdFRZABpWEIX6cCDcEgwdHgaDkwkgKgkWQwbicCn-JooIEMGgMZEgAAMvwAvh0fn8AeyugwQSgwTToQT4SBlIiecTSdSFVicfiVSSyRTILAeXTDNw3urfqzARKuTz+SAhfgRZbxcDQTy5RSlUiaaq9exMdi8QSIVxdebKYaaXTdIMHCyxRybTSAEwAVkFwotCYlUplIaQLTanuVNNR4c1QZ1av1VJ5gi2OwYsk2nJIgRGlTa0i6GJJaP9orZicYPIAjABmXl2h1O7Ou6U8xQiPJtLD0cjhr08ssUivan1hmuRkPGXrNyp09swTtCCpgXvcfsK53D7k0ifTzODq3zvOQmHFt6Ia+uWgb7sBh4Dga1IhnSABi6BQKgdR5D08ZDtaI40tOAC66yXNcbR3GADxMCwLyDF8eEcDAnCcDA5ANHBAivO8lhfLOGG-jyBatCgR4wb88h3js55vhqYHBkSkHPnODDKCcUCpEW76ThmjpZlxkpujSshdD0vQCTywldKJLa7pJVZ+rJWkKUpKkhh+6mcT+2kLjSCGjPgWgTNwRk0iZrgwGJFlalJobVgOL4SnZyn8apuHrLR9GMSQzEoM8gwkFR9pAA")

        ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: -500, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCunning(100)
            ..bureaucraticBullshit = <String>["needs a permit for all her inventions.","has to pay a fine after one of her Automatons went wild.","wants the Archagent to see her new cosplay."]

            ..makeCharming(100)
        );

        //ME	renegade	meticulous Engineer, machiavillian Egoist, miles edgeworth	Mass Effect (and his robot girlfriend)	Derse
        dersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Meticulous","Miles","Maverick","Mass"], lastNames: <String>["Edgeworth","Egoist","Engineer","Edge","Effect"], ringFirstNames: <String>["Mass"], ringLastNames: <String>["Effect"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is memeing at something.","is being a renegade of some sort.","is choosing between two ridiculously polarized options."]
            ..specibus = new Specibus("Avenger Rifle", ItemTraitFactory.RIFLE, <ItemTrait>[ ItemTraitFactory.SHOOTY])
            ..sylladex.add(new Item("Model Spaceship",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.SMART]))
            ..serializableSceneStrings.add("Mash A and Keep Punching1:___ N4IgdghgtgpiBcICyEDOALABAQUxMAJpgNIwwAOmACgK5gDG6AlmAOYCMIANCAGYA2EAG4B7AE4AVGAA8ALghCYAygGEAogDk1AfQDyAdS0AlbRuxI1meiLC8mBGGFn8AnphaomqWakyyRfugwmJgS2EYA4moSpuY6uiZmFkqBELKYqADWTOTkLKx4-PyBwQRMEPwirDTB+EQYIiKy+ZgwQjBiLrLMbKnpXmAA5P1QUHTB-pgARjRFMD7uvg52YEyyMK4lmADuEG6TqORkRGJ0gV6YrNAwAHSY+kFgW6HhUTFJ8YlxKeQiLAsiGjpbppEpuCBiRzDVrtJ6sebNXoARxq3kwkN2YgIqC4IVUmnihjUXwsO2EMF8EF2+yCTDEVhs9A6YF82zWWAgmAEOXI+HS9EETCgfUwwyCl2umHQaD8AXoaUYmBolDqlyY7UwLkBGWY6TajlkNAqrkGN24IFkEPhsl0YDgiFkpzgPEdTFY8LEKhsZWaNlQABl1fkFABtYAAHRAQt+YktTn04gIkfgkY0AHpsJGuKndBJk5HeBVUDAs5HILB8yAAJKobD8dUl7iR6PiOOyKtOSsABkjAF9cRGo1AY22E1jK+nM02QBpc5XHTVS+BrpWABJoL3D-jzGAEABidO8-rqAEVUT4ly3Y3yO7Ju32B83h62+WOkwhUxml7O8x++EXG2zZcKz-GsqEEFwOkvZ9rycW97xAftMEHK9R0TCcv2nH9K0LfhiyXctGxTatUD3MQRCgAARDp8OnVCb07P8e0Qx8hxHV90L-SdvznP9cNooDCMrGsjDqCjoPYuDGOIgAmZjewAXXNV13Q6L1CDWJg-WPQhQyUngYF4XgYHoHw93EQMhGDRAwyfSTZDfDCp0Elc-xQMRMgPMRvDPCkfGwVBN3Ibd1gkl8nA0GgoCmKCmL7fSQEM4zTNIiy6lQPTEKAA")
            ..serializableSceneStrings.add("Mash A and Keep Punching2:___ N4IgdghgtgpiBcICyEDOALABAQUxMAJpgNIwwAOmACgK5gDG6AlmAOYBMIANCAGYA2EAG4B7AE4AVGAA8ALghCYAygGEAogDk1AfQDyAdS0AlbRuxI1meiLC8mBGGFn8AnphaomqWakyyRfugwmJgS2EYA4moSpuY6uiZmFkqBELKYqADWTOTkLKx4-PyBwQRMEPwirDTB+EQYIiKy+ZgwQjBiLrLMbKnpXmAA5P1QUHTB-pgARjRFMD7uvg52YEyyMK4lmADuEG6TqORkRGJ0gV6YrNAwAHSY+kFgW6HhUTFJ8YlxKeQiLAsiGjpbppEpuCBiRzDVrtJ6sebNXoARxq3kwkN2YgIqC4IVUmnihjUXwsO2EMF8EF2+yCTDEVhs9A6YF82zWWAgmAEOXI+HS9EETCgfUwwyCl2umHQaD8AXoaUYmBolDqlyY7UwLkBGWY6TajlkNAqrkGNwk4pCYUi0ViFj0JLUKQu0qELVQIlgmAIgKmPhu-u4IFkEPhsl0YDgiFkpzgPGjTFY8LEKhsZWaNlQABl1fkFABtYAAHRAQt+YmDTn04gIxfgxY0AHpsMWuPXdBJa8XeBVUDAW8XILBOyAAJKobD8dV97jF0viCuyEdOYcABmLAF9cUWS1Aywuq1jh43mzOQBp28Pu-xe-3wNdh2OqIIXB1b3Py3yl7JVxut7Pd-OfIHjWCD1k2t7nh2oF8D206tneQ7QWOABiYgegAIh0N6nu+C5fj+ICbpg264UB1ZHuBp6QcO0Y1Leg7TnWIAABJoCmu78PMMAEJhqwAF6OJmdQAIqoj4b4AR+Tj4dBa6EX+O57mRh7QceEEXtBV7YfBDEPqgRh1B6ElKdJy7QewcnrgAuoG8aJh0KaEGsTAZkJhD5jZPAwLwvAwPQPjIeI2aumw+YkZJ+7kaplE6fe0EoGImS8UwAlgKJFI+NgqDseQnHrMZgFOBoNBQFMr6yRunkgN5vn+aggViG52IeYRQA")
            ..serializableSceneStrings.add("Mash A and Keep Punching3:___ N4IgdghgtgpiBcICyEDOALABAQUxMAJpgNIwwAOmACgK5gDG6AlmAOYDMIANCAGYA2EAG4B7AE4AVGAA8ALghCYAygGEAogDk1AfQDyAdS0AlbRuxI1meiLC8mBGGFn8AnphaomqWakyyRfugwmJgS2EYA4moSpuY6uiZmFkqBELKYqADWTOTkLKx4-PyBwQRMEPwirDTB+EQYIiKy+ZgwQjBiLrLMbKnpXmAA5P1QUHTB-pgARjRFMD7uvg52YEyyMK4lmADuEG6TqORkRGJ0gV6YrNAwAHSY+kFgW6HhUTFJ8YlxKeQiLAsiGjpbppEpuCBiRzDVrtJ6sebNXoARxq3kwkN2YgIqC4IVUmnihjUXwsO2EMF8EF2+yCTDEVhs9A6YF82zWWAgmAEOXI+HS9EETCgfUwwyCl2umHQaD8AXoaUYmBolDqlyY7UwLkBGWY6TajlkNAqrkGNwAOmALRJxWFItFYhY9CS1CkLmAYBDNkyxLIICwRd0LtLfFMyE9OZDjS5cZGim4phAiPYPTduCBfWJ4bJdO6FLJTnAePmmKx4WIVDYys0bKgADLq-IKADawDNICFvx9fP04gIbfgbY0AHpsG2uIPdBJ+23eBVUDAx23ILBpyAAJKobD8dUL7htjviX1ONdOVcABjbAF9ca321BO0fZD2savh6O9yANJPV7P+PPF+A1yrhuVCCC4HQAQeXbHqeCBtheIDXpgt5QY+z59nBn4jgBX5Tphv7-h+y67gO66oAAYmIIhQAAIh0hHjneD58iesjnleN77veh7dr2r7YR+uGrvmNQAcRq4ABJoBW978PMMAEFu-C1nUACKqI+JB3HQbIrHsYhnFMTxTjofx76MUJ+FzrujHiZhG5GHU1FacxMFsZhABMCGXgAummxalh0FaEGsTA1iphDNn5PAwLwvAwPQPjkeI9ZCI2iAtlxrlPnxmFvmJQGYSgYiZEp6kUj42CoDJ5ByesLnGbIGg0FAoZiPpvlprF8WJRRKV1KgUWIUAA")
            ..sideLoyalty = -100
            ..activationChance = 0.25
            ..companionChance = 0.25
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
            ..activationChance = 0.1
            ..companionChance = 0.4
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
            ..activationChance = 0.4
            ..companionChance = 0.1
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
            ..activationChance = 0.3
            ..companionChance = 0.2
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
            ..activationChance = 0.3
            ..companionChance = 0.2
            ..sylladex.add(new Item("Holy Pastry",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.EDIBLE, ItemTraitFactory.MAGICAL]))
            ..description = "The baker of the Prospitian Royal Family, RB is skilled at making HOLY PASTRIES. On weekends he runs a bakery even the common folk can enjoy, and even might teach you to make pastries, too."
            ..makeLucky(100)
            ..royaltyOpinion = 1000
        );

        prospitians.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Parcel","Perigrine","Postal","Prospitian"], lastNames: <String>["Mistress","Mendicate","Mailer", "Maillady"], ringFirstNames: <String>["Punititve","Prospitian"], ringLastNames: <String>["Marauder","Monarch"])
            ..scenes = <Scene>[new MailSideQuest(session),new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["is flipping the fuck out about how great the MAIL is.","is delivering packages to unimportant carapaces.","is just sort of generally being a badass."]
            ..specibus = new Specibus("Letter Opener Sword", ItemTraitFactory.SWORD, <ItemTrait>[ ItemTraitFactory.EDGED, ItemTraitFactory.POINTY, ItemTraitFactory.METAL])
            ..stats.setMap(<Stat, num>{Stats.MOBILITY: 500,Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCharming(100)
            ..activationChance = 0.4
            ..companionChance = 0.2
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
            ..specibus = new Specibus("BestFriendship Bracelet", ItemTraitFactory.STICK, <ItemTrait>[ ItemTraitFactory.CLOTH, ItemTraitFactory.ASPECTAL])
            ..fraymotifs.add(f)
            ..activationChance = 0.01
            ..companionChance = 0.49
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
            ..activationChance = 0.25
            ..companionChance = 0.25
            ..serializableSceneStrings.add("Teach Enchantment:___ N4IgdghgtgpiBcIAqMIGMAWACAomTEYALrMSADQgBmANhAG4D2ATigB5ELIYxYDKAYRwA5HAH0A8gHVRAJTHCAggFkcWIqkwwAzup5Yki2QHEcSBSvET5S1XywQsAdwgBPLIypYY+DISIAlmAA5nowAcwONDQBOs4BRNhEjEQQ0e7MqOlYUBDBAWgAdAA6YAA8AEbMAHyVNVgUIKnMwTBEEmBwiETMAK5wlD0Bwa3MAoxgACYJARPaADIB9EHBXADawMUgAVAADiypxFIsk1vwW8IA9Ipb5BcSSGdbVGnaMLdbAGqyAJJ8ANI3BDPV7vChbSCwJ4gH7aRQxehgu7bPYHfw-YjQgAMWwAvuQsJsUftmIciMdmKdgSArkDkcIHtCev0PiBvn9AdCXjQ3qzIWDzjDtHwYDQqKydiSyRiiNi8QSiZK0UcTtDaayGY9qdzeeC2b8AUDBTqkRDoAKtrCAAp0VwwZgS1Gk9GY6k4kD4wlbJXOlWU6F4AjEUiyvWapl9U36jlGkE8qP86EACQg2gAYsw3FAUgEqFIEhhhObHVKXaHBe7PYqnWSKVTBeqw4ztaDWezDVzW3rE9SkBAWm1YcpXPNUJN7SXlUQZXKPQBdRpDEb28ZTGZzeaESbrBeUGBUKgwNBEdMsRbLELraulv31raBvzBnxEeBiN9YYQAFh+wUmwQwwREMEuwBAAQmgPwCAEACaAAixiKPMAjQYovTaGgwSgYwsjaKB8wIQAUk4siKDgABaAgAIqKEgCFkQAjHwjCgZ8WIoQIigwJRSYAKqKGgADWmH-AAGp8oECBU0FQCJAhpgATE4oEAOwVKBiiKPJrjBARACskyuMoaafNp1G6QE3xoFAiigWwAQAI69AAHNoSbKLpaCKCMoE0Emih8HwlE+YoSayGxKj0U5Tj2WmBF8cIzAabBjDBAJGCwdBAlUAIJHzD8AnQTl1H-LplEiT8um7PZiiwVIAmUXwsh8L0SAAGzKPMOD5ZMlFpllSBBQAVqh0EEZuACcsGuAA1KRBG7AAtGAxiyMsuzKMoBE4Io9DBLIaA4J8aYlVQODBDlGlJvZAlkVISBgLpGA4DxlEEVIPHjcIwg8cokwQDIABesgCEQSafPJ03yQAzFDgJOcoqFgbB1F8sW1LGEsMAZlmObinq7aci28aTr6RDCL0UAVBObp4ruID7oex6nswm5TNoO4ekAA")
            ..serializableSceneStrings.add("Grant Super Magic:___ N4IgdghgtgpiBcIDiAnCYAuACAygVwAcYUsBZCAcwEsBjEAGhADMAbCANwHsUAVGADwwIQPABYxcAYQCiAOWkB9APIB1eQCUFsgIKlpWCDQxV2EDDADOWDOKxROF7AU4B3Ykzws7lWlk5MDFhYAOiwxGABPLBgwdhgWTiIrGxgoC3iA9AATa1sebXUkaR4tXUUlTR09HCwqMAN6iDdasAsCKhQ6iiwmKnic-yw0LKp0bBjiCgjQgCFOG1yJHBl5ZTVpSrKGnJSwgqKSqvLN6qxRDgkUjqwAI04Ryywac5QKGByXKgXdgjwUS3GFnSYBoEkGUB8NGCAB0wAAeG4oAB8CORDBAGAgrxgGCUYDgiAwKDwcEYRKoFDeKEknDAI2MtIsABkTF1hABtYDQkBUKDOFCYzAqbhZbnwbmyAD02m59AlSh4Yu5TAgLHSsu5ADV1ABJHAAaRlCGVqvVDG5kFgSpAOos2hYJhgGp5fO4gowOsw1oADNyAL70LBcl3893ClCi40gKVGuXRhXWlVqp3mkDavWGxOmlNxy0p8U27RQSQoVz4yNx3mhsaejA+-2B4NVt1jcORgsx52yBNRpNmuPpg1Ggt9nMW6D57m29TZThQZ3NgU1r1RgBMAFYG0HuYuwyLrTh0F8Il2eyPs87B5nexfU3nraQIjhMR6LKgYGZiGJ0JrVSSF66S6YLW1oALQAIwAMy+iAAbbiGLZCvuUadqm3aKlGRL-qmV7DiaybOveUYABIQBYJZlgB1bASuBYwXBTaAXuEbWqhcboVmBE4bqQ6cf245WlGtoAGKllAAAKpZtF8VGIR6tHcvRAC66LkpSxA0nSXxUIyTLZByKmMDATBMDARgWMJ3AsuwbKIJyO5Ma2yEFuQ-C8ngUBYEyeA0AA1oRE7WpI5xgG8z5mJePHXueXGVo5mCyB5NzENaUHevRjYOdRGBtg+dTuZ53l+QFgkFsF6BhS+kUZnhzC3nF2WJVAyUoKl0EZfBu5OSxUauQVXk+f5d6BVG5WhTAj7hXW3E1XxY4IUBGBNS1bXpVujHZblvX5VAHkDcVw2ldyY1vJNVUzbxN6xVlcnLSlUZpcp6LGaZ5mWSgel0hYBmwUAA")
            ..serializableSceneStrings.add("Evoke Powerful Curse:___ N4IgdghgtgpiBcICiA3A9gaxgAgApoHcYAnAMwFcAbbAYXOIGc4AaEUyidYgFRgA8ALghABJAdiYwoDbAIAWEcfJwBlGkgBySAPoB5AOpaASto0BBALJIA5DLQoS5JtjSlsUCAHMAlgGNsCjKeaGA4AmiycjDexAEwEAAmAHTYRopRsfIQYNhOYQCeAA5+ENQwYL4KYALeYJ7uXn7MkdGxigLlNSGy9GAy4S3YCRDEGNi+aMShsa4NPr7NnsTZNXUtUNgQvr4wDP0RhYQkFNS+9EwMKWZDI2Ok3jCUCdjlDpRohbuDnTE4tb7eYoMQoZGDNM6MWr1bwCGS1BQAIxhK0uAB0wAAeBHEAB8WNxIFYAhGnhgAl0oWEpFKTEJIAExG8nlJxBoIQSMO8IQYABlvCgocIANrAVEgbxQQ7EYnVfSTBJi+BijQAejMYuYyt03EVYuplCYGrFADUjCIVABpdUIPU0mBG8DQe020QMMyUfnOzXiyWTGUCETVXUgAAMYoAvs1RT6pf65cQFS7VdbvRptcH9YbCSazZbrUq2HaHZBYMGRGYoDRiIRQonvRLYytAwJg2GQJHsNGG36VvHEwXkw60zqXZmvTnzVaM0Xs47Sy6RAw0mAEmgoA7u9Km0GXQBWNsdru+rey+XBlTZGH5Ifpl0M8jjkCmyf520Gx8l50Fiz5FTEgMMAA4sQ8QdDwVTGqUD4bse-rNsGAC0ACMADMB5RmKm5xmeSZqjeI4Fvej7Pnm07vsWTrBgAEhADBVjWMGNtU8EuuhnaYbBvY4QWAAitzYBYXiPsOwZEQ6JFTnexDQbOn7BhoTpstUEC1AwjE9sxO4FgeAC6dIMkyLJKRyXR9Dy2QJMKemsDApCkDAviwgAYpMfICnUwpHkxAh9sGgl8BK5AbDy5C+BgFHzgWNBVKSf6KOJuaSQWY7qSeAgaEFCIkIhqEhmxXkaT53FihYtSBcFoXhbJlEutF2Sxf+CUvmRWb1px1QZVAWXEDlaH5Rx3m+S6fGjAJQkRV+YqAZ6SCCMs3AwpQxGJa+9LSY+WErJ13WthG1kgLZ9mOQwLnEOZK4MFZ7ZAA")
            ..serializableSceneStrings.add("Access Forbidden Magics:___ N4IgdghgtgpiBcICCBjFMDOGAEAxA9gE4BGAlgCbkxjYCyEA5qShiADQgBmANhAG5EAKjAAeAFwQhBACxjYAygGEAogDllAfQDyAdXUAlDaqS1l2BoQjEcEbNPzdy2fJ2wZ8sbBDApS1MdhiHnLeTvjEYhCkYDicRGSU1NhQjMwAdNgyckpqmroGRiZmpLEwMNzRDNgA7hAAnslEcilMKBDcbNjEAK4B7e7YnGUVYFW2FWJi3HLdPh5xhJHE0xlZhDAA5DbY6xDuNGLSJcmpKNjHCwlUYGm3ADpgADzEhAB8z2-sIJGEDDBiWjAcEQYkI3TgHFBpAYf0IinwYHIpDEpARGAAMqQ+JVJABtYB3ECkKAAByIkTAYh0RHIhPghNUAHokIS2AytII6YTOP0YKzCQA1fQASXkAGkWQhubz+eBoHypSBhRgkBU+Aq2UTSeTvGJhZSuSAAAyEgC+nQJWrJi111MItMVTMlmtUHMNPO4GA1gpF4sl9K4MvYhMgsENyv0oQ8suJ1opeoNioArCaQObsJbYzrKXaHQGnbLXZzFR6vbKhaKJe6g5rQwqA8r5OVODHtTbKfqxIbU+nM2347nDcoRCSYIQ-D5vSAi9XPVOK37Z2Xg3Kw4raHV5JE9RgAOK7MRjmTeAXtcGtuO6zuGgCMAGYewBdL5QmFj+GI5GomLo0J458cDAnBDCgYgYAQhCYtiox4n2l45jShr0CIxLdFA2Dot0KAANaynWhqKNI3h-FuEBdiuC5ViWNaElm7ZiKoaHEGOt4PmaFq0f2tqIeu0SoehmE4Xh8oEURowwKR5GapR-rSnOF7ZgxTEsYq949hxVqKYOiryN4yJ1MJa4BoRxESdu5a+lRAallOdHxoxUDMYQhoALRqWaAEgEBIFgRBv6IqwiC4s+ppAA")
            ..serializableSceneStrings.add("Ensorcell:___ N4IgdghgtgpiBcICiYDOB7ATgYxgGzxABoQAzPCANywBUYAPAFwRBoAsYACAZQGEkAckgD6AeQDqQgErCBAQQCySTtgipGqThE5QIAcwCW2TqgAO+PJwCup9GE6MOnGnKkBxJDVmKRomfKVuADpOcXQINhDxNghGTgNNRwSiTgB3GAhbNE49TAgAEy5dQ2wAfmcnF3dPbyUxfx9ueM1SGHwDMD00iABPHSwi-SMIPCCAHTAAHgAjTAA+GfniEEYITD0YRlEwOERGTCs4En2DPQ3MXjt8g0YDO1QAGQNKDr0WAG1gMZADKFtMVZgRhhTD5b7wb4CAD0cm+REhoho4O+pBGqBgcO+ADUpABJbgAaVhCBRaIxxG+kFgyJAuNQcjwz3J8J+fywgMYuKBNIADN8AL4pL6s-4ckFgkkgaHElkCRE01F4dGYkA4-FEhVklVU8kQ2moKQQMD5dBQFW-UVGzncyUAJgArAKhd8LeyreKadKVXKkZL9ocVWrCcS9YrlRTwNBdd86dx8KRzWyAVauYxeU7OMLXcmgR7JV6Iz6af7mdi8cHNUrS5HqZKABJqXiYdCpMCJy1A1PpkCCzMupNirASvVIejmTAGGBgXDe+WSsPVoMa+daiM6mkKHrcVac1BuTAZRgwTDsI1YkYBiPZjldyUARgAzHye86RW7c0PPTDZ77Q6uWUuIaklW2pRjSdIAGLNlAAAKzZmDc7bvtaaaSs+vZZgO7qfpKCgdL8VhQJwDxWNgADWP6VuGAHlsuf4gWuYGSjQawbIw26xHS+6Hsep5gOeeCXiy14pjaeoALSPjy6GviJH6ghuED0ARREkeRlF+gci60UBZD-pSTF6ix6ybBxu7cbEvExPxF7VnJKE0lJ6EALrLCcZzHpcxo3HcaAPEa+QfK5JAwKQrTYBoEFYE8LydB8mEdsCOF6goSkqcRpEUYxtZ6rw1kbGZgY6VRdlYUCAiEdMx6OU+GYJcheYpfhUCERl6nZdGIB5UaBU7kV6q6QuSE5owFVQFVmA1S5yyheFkXRQFqBBT2QA")
            ..serializableSceneStrings.add("Study Magic:___ N4IgdghgtgpiBcIDKAXArgEwJ4AICyEA5gJYDGIANCAGYA2EAbgPYBOAKjAB4oIhsAWMHEgDCAUQByYgPoB5AOpSAStIkBBPGJwBndBmIxtOprBxQiZHKSZgUEYmBgYcAd2Ip+DnACMmTANZGTNQ4aLZMtM7aMKQsMCjaAHQ4AJpoAA7JbEx2tLS4cRC0ZhakyRI5ONQQ-kJeHkLatMSE-CiGKIkAOmAAPN4sAHz9Q5QgdiyE8bKOvCgsaHBU8y1TLCI2+ijENtoAMsQMDoS8ANrAXSDEUOmsdrbyrBiX8JcSAPRqlxRvsmwvl2qtGi30uADUlABJJAAaS+CEBRRBlEukFgAJAkO0amaDBgoKuNzuEFskNsGIADJcAL4UHAXQm3Fj3FCPFjPBEgD7wn5cv4YoHI3kQ6FwgVI-Eo8DQSWvTHaJAwWjUAnXJksskoSk0ukMtXEh5PDHcgkSfmcwWS4VQ2HwuWWglo2WXLFKEkYEyqonMkkoTUYgCsVJAtPpl31PsN7IxYk46RgLAMYFIVt+-0580WBJFtvFwNT0vRnLwWFQED92gA4oV2ux+CSwUUs1KIxryZyAIwAZmD1IAumMVoQ1hswFsdmB9u6zgOqDBqNQYgkAGKsA5HMAnRDncPellsjly2PxxMwZMFp0YkT1zcwMtaqU5sUWiVe9W+iRoKDeBMY7s02cQHnRdSBXNd3W0GcQyAA")
            ..serializableSceneStrings.add("Enchant:___ N4IgdghgtgpiBcICiYDGALCYAuIA0IAZgDYQBuA9gE4AqMAHrojejAAQDKAwkgHJIB9APIB1fgCUBvAIIBZJG1QQAztmVsIbKBADmAS1RtlABxjFibAK7GKYNtlZsa08QHEkNKXMFDJM+RwAdGwAktgA5OpgFNhsZDBUAJ5sMISEMKjYevF4bABGlrEO7M5uHl7ywn7eHGwAJql6YHrYZsnpZuqaxC3YxOxQ1AO6BhDEgQA6YAA8eVQAfLML+CDYEFQ6MNhCYHCI2FSWcAQHejqbVFy2dS16tsoAMtlNOgggANrAEyB6UDZUaxwImodW+8G+vAA9NJvngIUIaGDvoQxsoYLDvgA1cQhDgAaRhCGRqPR+G+kFgSJAIWU0h68QxPz+1EB2BCOCpAAZvgBfXJfJn-VnAqigokgKGEuEShFUlHENGM7G4glykmMimk8HU5TiLB1ChQRm-IVYNkc8UAJgArLz+d8TSyzSKxdrJYzeLLxQcjkqcfjCdr5YqyeBoFrvjSOGZCMbmQCzezsFy7WwBY6E0CQVT3aHPYjvYdSdLlQG1Qri+Tw1SABIqLhUCgAdzAcdNOCTKZAfLTDvjwuz4qQ9FMVD0MDQlZlBe1PqnpdV4uDU81VNkiQ4azZylcVBgEFatEwYExY19oYzrM74oAjABmbnd+2Cp1Z0U56Eer1B9WhheB4kKw1atxRpAAxRsoAABUbEwWjbV9zWTcVHx7dN+2dQdtVkJpfksKA2AeSxUAAay-GdAJDEt-UXH8gNDVdxRodZNmwTcDxpXd90PFgsFPYhz2lS9EwtbUAFp71Q59hLfV1vlkCB6DwgiiNI8iqTnP0VQAohf2lRjtWYjYtnY7cuIPBJeJPM8pxkpCqUk1N0PbbAXQ-KV4Qo1Yiy0sslz0qtKVA6QoAbZtdjFISMI7UTvlQgBdFZTnOBIrjAG4snuB59Ted5EoIVJ0kyZQwOoJ4yBeXLnMQtzxQUpSoHwwjiLIhiQO1Lhj02UzfNoyjbOi7BeHwvIEgcu8nL7Fzauw3DGpUlrgKCjqupgHq-xonTlwQzMhpGsbbwm7t8pAQqMjUUqqGy9LlFyxKeSAA")

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
            ..activationChance = 0.49
            ..companionChance = 0.01
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
            ..activationChance = 0.01
            ..companionChance = 0.49
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
            ..specibus = new Specibus("Sacred Frog Text", ItemTraitFactory.BOOK, <ItemTrait>[ ItemTraitFactory.PAPER, ItemTraitFactory.MAGICAL])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..serializableSceneStrings.add("Help Breed Frogs:___ N4IgdghgtgpiBcIASMA2AHABAIQE4xgBNMAxXAewHMBnEAGhADNUIA3c3AFRgA8AXBCE4ALGJgDKAYQCiAOWkB9APIB1eQCUFsgIIBZaZgBG5AO7VMEMMWoBjXBHQxzEPpj6jMmTtvUBxaZxaeopKmjr64hZWmMIArlCGqACeFtQA1uYAloxuoilQECkQ1NSZ1K7uMFCYmWC5MJm4MeTJmISxfJlOAHSY9CB8ELiUMHxKYHCIjBCo1HAMfLiZlCO4kuRWmZ0b1AAymay1lIIA2sAAOiCZUOgcg2B8KhyEl-CXsgD02pd070qcr0u01mMB+l0gsEBIAAktRtKgDqD6JdrrdcPc+NCHlCAAyXAC+dEwFyuNzulkezyh4nQEBsSN+IFk-yhwLmYPA0CRbyucOojhsfAACiwkjBcBzUeSHli+LiCUSSVL0RSnrgXggwLFUKhGcyAQhLotYgzwVyoUhimQqJKySqZdjDSA8SBCcSUXaMWqNTzPt9kUyWU62abOZCnbD1JZCOQoLa0RjZVCAEwATgJAF1+otlqt1pttmA9tHTlmGDBGIwYILqCQOPtDmBjogzh6E6qqU6-RyIdzLr5EdbKPHpXxZPFDOL5a6yyAK1Wa3XcLto7QW1n8UA")
            ..serializableSceneStrings.add("Kill the Blasphemer:___ N4IgdghgtgpiBcIDSBLANmgBAFwBY0wCE0IBnAB31gCcQAaEAMxIDcB7agFRgA9sEQmAMoBhAKIA5MQH0A8gHUpAJWkSAggFkxmFKUylcbAMYBrGABNMEMJYjlyEDBZxt9MAhCIAZNUIAKABJiGrIAqkKYfqFKfl7aAGJKsgDiOmA4+JiYnGpKyWKcqpoysirqWkIA5HqkAJ4YEOa8AHTZ+LWYUBBmmACOAK4oppgA7hwmmGyMGTBQdFY2M5ihEgGyXgCamGt+fmJKLpgARmxs2M30INgQ1ADmMNiyYHCI2NT9cAxvKLf31CJsGwobAoQGkLwoFgoMC3AQAbWAAB0QCgoOQONcwNh5BxzMj4MiJAB6NTIuiE2ScfHIxiOUgwMnIyCwakgACSpDUaEhDPoyNR6OomOwbKxrIADMiAL7zJEotEY6zY3GsoQOIy88kgCSU1m0tD0xngaC8gkozkUGBGbB+Ei1GDUI0CxVY0XYCXS2X8hVCpU46h4hBgfoYLU6qkIGl0zVMk2sgJkPz9ajkNAweLUNi3J0+4Vuj0gGWYOXO31Y-2Bs3E0l87W6yNMaNG5mm5FstRQESZkbPQNa0t5sUNyWFgC6l2+vwdAKBILBXms5nh44YMEYjCt2FI8Q4EKhMPhJdzfpVDerzbjDdFpGuqAwOcFwok-SgRwdBaLR8fJ4DrPPtZbVkvDYekMyzB8XWwZ9X3fYdpRXEA1w3a1t13RdSGXQsgA")
            ..makeCharming(100)
            ..activationChance = 0.25
            ..companionChance = 0.25
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
            ..activationChance = 0.4
            ..companionChance = 0.1
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
            ..activationChance = 0.4
            ..companionChance = 0.1
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
            ..activationChance = 0.25
            ..companionChance = 0.25
           ..serializableSceneStrings.add("Fabricate Mecha:___ N4IgdghgtgpiBcIBiEBGAnAlgYwgFxgAIBZGbACwhABoQAzAGwgDcB7dAFRgA88EQAkngDkAZ0J5MsAHSEO5IgGUAwgFEAcqoD6AeQDqmgEpb1AQWKrCAc3wL04gK4AHQhAYNCdwqgYOYTrDA8cTxWQmx0GHwiCEIAHlQAPlECaCcHMABrQlgKCGk4gHokwgAJGHRPKIY8cmpCUScYGAATeogwFsJfbGzRTIBPdFZemDxpAB0wBPREmcSaEDwIdCsxnTA4RDx0P0WdzCs19GVWTsxJM9EAGUxmTDArfgBtYAmQKSd2ZaC9dhb3vB3upCqZ3tRgToOID3nQ3KIYOD3gA1QwCRQAaTBCFh8MRNHekFgMMEokUMAYdCRHygX3QPzwAiCJIADO8AL71N40ukMv7oAE4kAg7EQ4VQklwhgI6mo9FYyV46lE-FA0mmBh3fFiz7fDqM5lCtkgTmEbm6+n6-mCtUi6nqCVCqUygkgOWY7Fq53awnQVXvASmKDKYYAd02gp1tL1QSZeFZHK57wtfP+JOIrFQmE1eAG9sdap2fllaI9iulPvAfvTA0Uy0ZogA4pFopxKGBkW5i66U-q4ySAIwAZhZxtN5ujlt+aaFdtdDuhTqVrvdCqXFeV1aFAlEhg6LVYUGpvdjhrVAFYxwBdfZYI4VU7nS5gG77l432gwOh0MjBJDsW57keF4J15K0ZzVco3FqTdiSFZR2zWOt8BLeVPVxDce0nBl1AcKBUAqQcR1HRMzWTbDwIFdNM2zC481dFUSQQjokPrVCy3XF0ozAoJcPwwihWHUcxyTHkYzwa10wgbgpDwwhrgcXpYP9EBmMeGBkPjFdSzXL1l248S+II9AiOEjkPxAL8f2wP8AP3UR3xNIA")
            ..serializableSceneStrings.add("Provide Advanced Invention:___ N4IgdghgtgpiBcIAKAnA9gNwJYBMYAIBBHDCMAYxh3wEkwMYwAXLNMEAGhADMAbCDGhQAVGAA8mCEMIAWBAMoBhAKIA5ZQH0A8gHV1AJQ2rCAWWX48AZywBzMJfyW0sJjKxgb+bkPwR8rgmFCfQBxZWEjU00tQ2MzeQA6WiYAcgcyXzBfEjJKaksmGGgABwBXMABrfHcGZlYs1wgmfAAjNDQChzkIXlcOR2KYKn6yal5S8gqEgB0wAB4WlAA+BeXOECYIFBsYJi0wOEQmFFK4LmPbHZRFNhwsFjZLABksbA8pAG1gaZAsKGKhJtmDohDgfvAfqoAPSEH4cSFaYTgn7HU5wn4ANX0NHkAGlYQgftwepYYOjwNAyYSQDRLPIYLxuOS-gCUECmHQmMiQAAGH4AX3631+-0BZCYIJQYOp0IJ8JAqkR3OJvFJ5KxOPxypJVPlkFg3NphF4r11PxZYuYnO5fJAgvwwotbPFkulEIVMPJiqR1JVas4mOxeIJ7r9ZopBuptP0o2czNFzqtzG5ACYAKwCoXmhPs13cpBoADuMBQXqV1NR4Y1we1qvD+qp7uEWx2THkmw5lhCKCKhREMjIGJ6aIDItZ7Ot1IAjABmHnzzMO7Pjl2g7nKMSDFBYRiUMs+0M69VBrW+o+jhvckwAT3bTVp3d7Jdkg+H4adE+T07ni8dOdXUrcrK+61v68rVqeh51uSl5RpYABi6BQKgHTFPc8YrkmXLUra-IALrrBcNhXDcYB3A89hPKMnwEVwMDcNwMDkEwCFCC8bw2J8f6YRKa7UgAEkUvQyDBlLcooA4eDAd7YeBJ4hkS57yh+4qqKUUAtCW3KzgudpZmOlq8YB1ImGgLRYCaTDXqJkbuhJZA7DJx6agpPBKcuhlqRpWnfrp9rcYZeYmRAYh-Op+BPBMFQ2Y2Pz2VJTmjhBrlhhhnnqZppa+bhtEgPRjHMaxKBUWRlg0XaQA")
            ..serializableSceneStrings.add("Design Blueprint:___ N4IgdghgtgpiBcIAiMDOBLA5mABAIQBsBXGABwCd0wAXEAGhADMCIA3Ae3IBUYAPWxFwAWMHAGUAwgFEAclID6AeQDqcgEryZAQQCyUnOlQ4hEcgBMcEajgDunANY4zaLGCqZLOAEbEylGgB04iI4pDDkjJxQRtRo1EY26NRCnqym6DDUAJ447IxOpo6w1BAEqHQ4mDCm5ZZgFqix0DgwYJhUaDhENOgEOKghVfH97MVC7jjJVjgE7Oz2RgTo9qJJOADG7EQEFnbk9gEAOmAAPF7kAHxnl-QgJeRDimBwiNTkJLdvWFXkEuz1SXQ-1QABl0Kx3AgQABtYCHEDoKCkTglGjKThmeHweEyAD0WnhdBxii4WPhjFKqBghPhADU1ABJMQAaQJCHJlOp9HhkFgZJADNQYhgBEYNIRSJREBoDJo-IADPCAL4VOES5HkVHUdHmfl4tlEkAyEn8illLmG+lM1mmzni3lc7EC1BaJasC3wxEarWy6gK5Wqz2SzXS7UY-lSXhhSitdYeo0m9l3d7xq0stlOs1U+3QR3wnRZMQlaiCgDi5GqsW4JjAtNKJHFXqlMrlSYAjABmRUgFU4NVNkNo8NJ-Xi42kpNZ1OM9O2805vlJwVqaVmUaN4M+1tOgCs3aVAF1PpRMD8-gDqECwKDV1DoUeGDBGIwYOt4gAxThgiFtO-9zehjqmJJpG0YZGAcYLnmIASDWVRFlY4ppjak52ty6rNtQMhEFAXjhPynbKg+IBPi+b6oJ+5AgquqB3keSpAA")
            ..serializableSceneStrings.add("Provide Basic Invention:___ N4IgdghgtgpiBcIAKAnA9gNwJYBMYAIAhCAZywGN8BJMDGMAFyzTBABoQAzAGwgzRQAVGAA8GCEIIAWBAMoBhAKIA5RQH0A8gHVVAJTXKAggFlF+PGQDmYEvhJpYDKVjCX8nAfgj4nBQYd0AcUVBAxN1DX0jU1kAOmoGAHJbbwAjUgo7BhhoAAcAVzAAa3wXOkZmMB8pCAZ8VLQ0EgZbGQhuJzY7XJgYHC6IMBx8bnzyItiAHTAAHlSUAD45xfYQBggUSxgGDTA4RAYUfLgOQ6xLLZR5FhwsJhYSABksbFcJAG1gSZAsKFyBdaMLQCHDfeDfZQAekM3zYEI0gjB30Ox1h3wAaroqLIANIwhDfTjtEgwNHgaCkgkgKgkWQwbicMm-f4oQEMGgMJEgAAM3wAvl0vj8-gDBgxgShQVSofi4SBlAiuUTuCSyZjsXilcTKXLILAuTTDNwXjrvszRYwOVzeSABfghebWWKJVLwfLoWSFYiqcrVewMVjcfi3b7TeT9VSabpBjgHEyRU7LYwuQAmACs-MFZoTbJdXKQaAA7jAUJ7FVSUWH1UGtSqw3rKW7BBstgxZOt2SRAigctkhDUwOj2qj-cKWWyrVSAIwAZm5NrtDpzzpBXMUIh6KCw9HIYa9XMrasDmp92rJDa5xgAnu3ajTu72S9JBkPRmHHRPk9O55n7dnxyukpcjKZbeiGZ6jtWJ7gXW54UgaJAAGLoFAqBNLkdzxgBSaclSC4ALqrGcFwltcQx3JUTwxh8hEcDAnCcDA5AtIhAjPK8lgfEu2HiquVIABI5B0UhwRGbryAOWy3rhcpQcGhIQXKH5iso+RQKkJZcrOC5ZmOFq8UBVLGGgqRYMaDBXqJjbfBJgxSR2R4avJXCKf++mqepmnfjpf56YmBmut8xgQCIvxqfgjxjEUVlcrZrgwNJjk1qesGjspjAeRppbefytEgPRjHMUhbExiQNG2kAA")

            ..sylladex.add(new Item("Bronze Gear",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.METAL]))
            ..description = "She is skilled at tech. Especially steampunk tech. Which works despite the fact that it shouldn’t work. But who fucking cares."
            ..bureaucraticBullshit = <String>["needs a permit for her giant robot.","has to pay fines for the robot's destruction.","needs to update her inventor license."]

            ..makeCunning(100)
        );
        //YD	Healing	yogistic doctor, yelling doomsayer, yard dark	yahzerit dacnomaniac	Prospit
        prospitians.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Yogistic","Yard","Yelling"], lastNames: <String>["Dark","Doctor","Dentist"], ringFirstNames: <String>["Yelling"], ringLastNames: <String>["Dacnomaniac"])
            ..scenes = <Scene>[new RedMiles(session),new BeDistracted(session)] //order of scenes is order of priority
            ..distractions = <String>["has the weird feeling that he should be more than this.","is treating random carapace patients.","is reading various medical texts."]
            ..specibus = new Specibus("Hippocratic Bust", ItemTraitFactory.BUST, <ItemTrait>[ ItemTraitFactory.METAL, ItemTraitFactory.BLUNT])
            ..bureaucraticBullshit = <String>["needs to make sure his medical license is up to date.","is filing for time off in six months."]
            ..sylladex.add(new Item("Stethescope",<ItemTrait>[ItemTraitFactory.LEGENDARY, ItemTraitFactory.HEALING]))
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
            ..makeCharming(100)
            ..serializableSceneStrings.add("Perform Really Weird Operation:___ N4IgdghgtgpiBcIAKMBOAzA9qqACASjBADbECeuA6jAJaoAmuA8gA5oQAuNmYIANCHTEIAN2wAVGAA8OCEOIAWMXAGUAwgFEAchoD6TSjvy6tAQQCyG3JjapOMAM7WwuDktzjT+AOIbxJiz0mYzNLFQA6XABJDlwoCABrR1wyTABXXAB3CDBYjkxcdBJiXAgHYhgYFj5SsEY3ZU8fPwDLfRDAlULK4idUInoKfNdE5R5Xd0zsYkYIdA40XBoOAHIneh4YcIAdMAAeACNUAD5Dk-4QDghUAHMYDiYwOEQOVDS4AVeaG7vUNR56MtuGAHAAZGgiGhgG5yADawG2IBoUBY2CuuUo2HoiPgiK0AHpTIi+HimOIcYiir0YMTEQA1fBRFQAaSJCEpJAcNP4iMgsApICiDlMxAh3JJSJRaJyHCiuQFAAZEQBfGoIyWo1DojiYhgCglsiVaMkC17vWkgBlM1kCqlci187m4wUOFQwYjoC3IzXauUcRUqtWI73SjFYgUACSIxDcFuN5PZgk54vpjJZbOddpT4GgTsR4mudw4Kiusoc3n69lQihydJI5p5GtDsvliYAjABmBVKkCq3DqkNamW67GJg1xk2JrMWq3p23Jh25gVC-A5DZQL1Soe5P0CgBMAFZA-3g1vtSP9YSJwnMwvG7ObVO7xLHcvTFA1KhMJknqOJYPfVbZ0ez7Acz2HcMxyvRt43nakZzTR9b3gxtX0TIUADEvygJAvwcFhlk3H0ZV3RMQKDJttx1SDnXHGDJ2dM1swfDMORQl8l0TCMyk-b8wCI5tSOAlUAF0Li+H40H+OogR4ME1zhMSBBgdB0BgABjDgHAw7BwUhaE4TA4iwz1Ljo1jVDOOdNQFByO4S04BDrVYpN2NPYyOC0NIoAONABQAWk7btyJPSjzxoxFzEwA4aFFDgyEXflExsuyYAc-170Qlzp0bACZS8ny-PbLtu2PIzmwvRMVByZYEsspLrNs6E0tLJy5yfNywvy7zfNQAUgtK3slJAFS1M07TdLXBxFN7IA")
            ..serializableSceneStrings.add("Harvest Buffs:___ N4IgdghgtgpiBcIASEBOA3GBnALgAgCEBXAMxKxABoQSAbCdAe1QBUYAPHBEFgCxjwBlAMIBRAHKiA+gHkA6pIBKU8QEEAsqLyMADjFQQc2bWDw5+eFqsUBxUSxUbpM5Ws2CAdHhm6sXvgJWtvaOmrKuToJ4AJZYeAAmMBDxXqr4tEm4ZhYiEs4KohGaeADmMDhxWIyweABGpORmjHi8sXi4hnGMRPiMJDE4HgA6YAA8tagAfONTVCA4aGU4MmBwiDioRHDUG9ElZajCjGDx0TjRx1gAMtHo0WAl3ADawEMg0VA6zAtgOHLM8Te8De4gA9Ko3pQQTIWEC3iQILQsDBIW8AGqKACSggA0hCEPDEcjUeBoCiCSBMVhVLRbuSoe9Pt8IL9Mb84SAAAxvAC+lDwr0ZX1QPz+AI5YPxDPEMI5Gy2JIx2LxHIRSPpb0gsA5VMEMFoJBJH2ForZOA53JAfIFb2NzN+-1QgIpkpJMthFLVxKo6KxuPxwJoRI1pO1FKpihZ8WqRqZIpZODNHIATABWXn8wV2+MO8Uu8Fu2We4OKv0q4vqkla8mBzGqKDCVCMADuq2dDOzpvZFMt1qzcdFjudgddPpA7rlmxDSv9qpLY+rHJQWEbLbAsZNCaTPYzNqF9rFTo5AAUW-pCx7A-Lp2WA4TKwuyRyWItyoIFomsDZUEkjKxeCy6j3CGnZbt2ga9gAunMuz7PoRwnGcFxgNcUbPNB1AwGQMAAMYVAAYswNx3A8zz9puuZHvmUqak+4YoQsOLRLQtClsqd5Bg+HYDgm4hEFAtTnjuVqZraPGUcObzqIwtTMWcACeVZ0YGwgAQ8MDqPJ76GGxs4Vt63EUTgfECUJgYAIwAMycjZu7kQeQ4coILIKUpYYqWpZSadp5pjjO5aBl6IHicZ-GCagHJWTZUFzFhJC4QRRFRhQiBPNBPJAA")
            ..serializableSceneStrings.add("Perform Weird Operation:___ N4IgdghgtgpiBcIAKMBOAzA9qqACA6jAJaoAmuA8gA5oQAuRmYIANCOgDYQBu2AKjAAedBCD4ALGLgDKAYQCiAOXkB9CvmUAlFYoCCAWXm5MNVPRgBnY2Fx1JuPrs0BxeXx0HVFbXsPSAdLgAknS4EBxQmBahVACudFYQYACeTFIA7vQAxuJEYADmuHl0mGG2ZmBZMCxhYOR2Uo4ubh6Gaj6e0rjoMDAcVlmYUFQcMHR9yWExMBBVYejjqEV0AORWpGn+ADpgADwARqgAfAfHrCB0EKj5YxRgcIh0qLFwbE9E+TeoskykRAxMCwAGSI3Dy+VEAG1gFsQERhthLmA6PhsKRYfBYYoAPS6WEsLEUPgY2HocIWGD42EANU0QWkAGk8QhSeTKaxYZBYCSQEELLoOKD2QS4QjUEi6EFkTyAAywgC+NRhoqoiKSKLRPJxzJFiiJPKeLypIFp9KZPLJ-WFnOg7MxvIs0j66GN8NV4vVUrosoVSthbrVyNRZB5AAkZhw7Ma9cSWew2cbTYzmfbLRTjVy7bC+FcbnRpJdJRZnKgZosJElqeEjRyVYHJdK4wBGADMMrlIEVuGVAY9Qc1ce10f1cbT1pNdOTFoTtczPL5miSGygrrFEq9PIATABWX3d-1r9XB9Fx+SCUxEGCVccx6dWxOT82jmciudxnPXMYF+h8ktltAVmAVYcDWIq9uujb2q2HZdj2h79iGg64sOsapi+NKPimrL3rOtrzhYABiqBDEgxEWFQ-yru6EHenGMF+nWfYaoh9pDrWt5xoa45Jk+aE4a+eFxqGEAWLIxHpGAVH1hudEKgAuuc7yfGgPx1P8jBgMCS5QgpbAwOgPRZAkBHYCCYIFFCcHUUeA72uG4RRrh3JxrI4hJDc360SKPFYfG-EHtZyKKLEUD7GgPIALTQXuVn1seYYRo5AnOfarnuTAnkPmavljlJTHBaF4VxlFbYxQFcW2bC+iYPsRCCnQyQZoJqVuQUGWFllU7Pv5jESgVYWoDy0H0fuvU2SxsLSEk-yNU5WYgGlbWZbWPl3umtbgeq-VFVBbYwbpID6YZxmmUuFg6Z2QA")
            ..serializableSceneStrings.add("Diagnose Carapacians:___ N4IgdghgtgpiBcIAiBLCBzMB7AzjABAMIQBOEADhAMZpg4gA0IAZgDYQBuWJAKjAB4AXBCB4ALAgGVCAUQByMgPoB5AOoKASorkBBALIz8AEzSZcMHPhxZYVlFQDW+KqQrVaOAHT4AkmGNYKGDoVlgM+BL4rDCkdPgQUSiCgtH4AEZJ+FDcBBBpWACugviCkQDuEACe6VgmFvhl3E4QYEYRWGUlWPiUglRiJRJQ+AXkngA6YAA8aSQAfDPzjCCCpOgwgspgcIiCJAVwTHso6OskhFitSSiXOAAyKBxB6CIA2sDjIChQ5NyrYIJVNwjJ94J85AB6HSfBjg5Q8UGfZgQVh4GGfABqGh8kgA0tCEEiUWjGJ9ILBESAfDgdKxHjB0V8fn8WoI-IJKQAGT4AX3CHyZvxI-0BwMpkIJsJAcnhlORqIZpJAWJx+LlxMVUvJirBVJwkhgrGYjO+QpF7K5vP5n1NLIBQJIIMJ0qhjJlCOd8pJUpVeIJuq9mrJ0B1n2pGhaRhsJuZwtZFudAFZuSA+fgBba4-axc6ZPxyDASCgYGAqEHpbLnXsDozfWrPRrGdrKXpKpJVmycABxEgxQSF8QtDEomtKzPmgGUgCMAGYUzyALrLY6nQsXK6CG50O6Rt5LpgwZjMGBUQQ4ABi3AeT2CbwzsZFDqdurzBaLJbLTZDlMIYha63bCAOSVOt-SJBUYzNVk5AKKA0kLacZ15fcQEPY9TwvK9I3oRBXiXHkgA")
            ..serializableSceneStrings.add("Perform Operation:___ N4IgdghgtgpiBcIAKMBOAzA9qqACA8gA5oQAuAlpmCADQjoA2EAbtgCowAepCIbAFjFwBlAMIBRAHLiA+vgDq0gEozJAQQCy43JmKoyMAM46wuUoNxs1SgOLi2qzbPwr1W4QDpcASVIByY0JUGFJSAE9cYKZOcjAAczNMXAB3MgBjfhpcCDAAEzMLK1t7Ry05VydhXHQYGAZjCAZUcjj+Umz0UjRccn9jXKoYDwAdMAAeACNUAD5JmdoQUghUOJD8MDhEUlQAVzg6bZbV1FEqXN7KMEMAGXJmWLjeAG1gYZByKEJsJbBSeWxcm94G9JAB6NRvGgg-BsIFvdCNQwwSFvABqSm8wgA0hCEPDEcjaG9ILA4SBvIY1Aw7oSoe9Pt8cqRvL8yQAGN4AXyyr3pX1QPz+ALJYNxdMkMLJ2z2KJA6MxOLJCPqtOJ0EJwPJhmEdXQso+-MFLNI7K5PLeBsZv3+qEBeJAAAkYI1zLKJbD7cqkbL5djcZqvarwOqyWxlqtSMIlszDDZggZUAIcqjGjKiXyrczWfaAIwAZg5IG5uF5loFTJtds1ordks9BJ9GL9Sob6ZJGreFKUOQGUH1DPLv2NZIATABWM0li0DwWVsniTh6cgwMBpIPuqW7IO+xX1lWy9uh8MhKNkClx51dRP8ZOpoNlo3ZzX5wvF0szivC+019Mbvfe9Md39fF9zbEN7QpAAxVBMCgJAYMMQhen7Q0mWHe1X3NDNByFW0RXBWsPU1aVtybXcA1bOlD3tB0IEMUQYOSMAUMzdDNVfABdBZDjiY5TjyC4qBuHtni4ugYHQGo0lIQxIOwW57niZ531Q60v01J0XX4A9wM1UQb3iGBTxNQCyOA+hKOnVTSEkHYoAmNAyQAWnzScVMzOcaOdBhXTA0l7X0nJVmMxsFXMwMWJw2z7Mc+0XLzNyrI89S3mEHJejCHT-L0gzgujULm3-e8P1+aKHNQMkX0S7DZxSkANEwCZyGpcIso7EBAsMkLTLCltQLpB8mTK2LnwLLkxJACSpJkuTUGuHtDFEosgA")

            ..activationChance = 0.4
            ..companionChance = 0.1
            ..description = "He probably won’t chop off the wrong limb, and he probably won’t treat something you don’t have.  You...get the feeling he is supposed to be something more than this."
            ..makeCunning(100)
        );

        prospitians.addAll(getSunshineTeam());
        return prospitians;

    }
}