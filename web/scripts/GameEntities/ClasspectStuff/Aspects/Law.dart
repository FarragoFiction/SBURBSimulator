import 'dart:math' as Math;

import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Law extends Aspect {

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 0.01;
    @override
    double fraymotifWeight = 0.9;
    @override
    double companionWeight = 0.1;

    @override
    List<String> associatedScenes = <String>[
        "[Stay of Execution]:___ N4IgdghgtgpiBcIDaBlALhAngAgPYDNsBRADxgGMBXNAS1zAF0QAaEfAGwgDdcAnAFRgk0CEAB4ARgD5UGHAWJkqtegzEB6aQB0wk3lJ38AFjGwoAwkQByRAPoB5AOo2ASrasBBALJFsNAM7YAFaU-mjYACa4NGAA5thoJjS8CUYx8QDuJmCpMDi8MBDsNABepokQ4Ymm-jD+-nQ5RhCBsfSmuNR4hOT0aLy47Nj4A1DYRUPV2LHFaORpceNgEdgSlLH+AHTYxnnYUKHhBWF8HbwRMClouLnYtfWNAITYAEI45C20ixDYAA64GUu+EoQwgEhos0wzFuFmsdicrnc3l8UAgAGs6rd7g16ONsLM0OxTET6n8BmByjdyLwWgt4pUljhar1lpsdHopByWCAMLxYjA0PYKaJ+pQ4Kx+jRYvzeOZ6BEaCowP4ADI0LjpURIYBaEA0KD-XgYMBoRx8CK6+C6lAQMCKzC65i6qz2fiW3X4Iq1R26gBqLgAkigANIed1sL0wH3gaBRhC6ryYdCVAP+ADiBUql2Mtt9RTF0f1huNaADJvDAEYAMy6gC+0J1eoNfBLZvO4YACuxKOQ0TtcBiwPBbCPsFYACwB2IRWJGWJoWK-GgvcgBjyhiQePkATQyVm3HjXAEcPABOdhBNPmDwAEQAirEXlBg0QPBJYneiABWccZDwwDwVViGh7BQNMSA8DJ7F3AAmf9+BeEgiHYcxzFiG97HIcwoAybcXhVfBcADPCjA8KAPDIxVcH8KsUG8XA0CPYMMgAWn4WI0wrWIPAACRccxg1wDwXgABggAAODJN3sI8vDQCIAGoeLwzAPA7O8PFiMAAC00RY-wAClxw7SAUC8IJzCMGcXhPIghLRdDQysAMjHMKwADEUH8LgeNiESeO-ANzDAG1+A8QYPAAVXsEpYkwSgJHMbtIro29lI8LgoDvcc0C4bT7BVIwXkoOIygM7ceO07cUBeBSiBQESSAUmAUAMo9tJ0rh2BcL8SHyu9-HMCt2BQbcrAgF53I8CsWPwRwbyCcgRPYAB2OiIkA3gsP8I8jzTRiADYFKgF40wUittKrdyb3MSL2BvDwxqCOiXhoS8vF+MAvAADRg8cuCrBTYgMl5tw7GCRJoIweNS6MXTdeMI3Yb0WD9QMQzDRHRTjJ0Y1gcMeJaFByBgClC2bI1bVLctEZEusG11IsWyptsLURqx1Ex3H4fDT1kZxtGg1DcNsejSB8cR1M01wCJ+BoS5yeLKmyzQcM6ZAetsEbJnKZNVnLTAEF2G510Rd4AtUZAf0hcxq0kZR3HxbjO2UDqHEwB4wp2ESDNCjQbNmjARXmZNFXwxgr8RPVzXtYp1tzXDDmuedU3Eb5h3BYx3nIzF2Nw1TV32HwYPdep1XafprXGbjlmE-Zzm4dTu3Rct62s6x82Bbx53dSl3h9RvCBeDREuSzDiuNaYCV++lS45WWRVGlVW0Ii1KeQBgfB8AoNB-Hcvg1Q1OItVjpW9bru2ux7Pt+AHUnh1HCcpxnOcFyXFc1w3LdYl3fdDw8E855LzXnvI+Z8r53yfh-H+ACQEQJgQglBWC8FELIVQuhTC2FcL4UIsRF4pFyKUWuDROiXgGJMVYuxTi3E+ICSEqJCSUkPAyTkopZSbw1IaS0rpfSRkTIQDMhZKyj5bL2Uch4ZyrkPJeR8n5AKX4gohQgGFCK0VYrxUSslVKN50qZWyrlfKhViqlRgOVSq1Var1Uas1Vq7VOrdV6v1Qaw1RrjUmtNWa81FrLTWh4DaKotrmB2ntQ6x1TrnUutdW691HpWGesJN6aYPpfV+v9QGwNQbg0htDWGlsnbhhcDAKAuAuAAXIEqaMbdhYdwtrjHWJYrCUCgBIBWE8Y7VzPqaC+upc4SztmQhU+Akxu0aJ7IoiRKno2qXbdOXd6lU0ac01pdsIZRzrOvTe29yl7wPivfwa8NZAA",
        "[The Jury]:___ N4IgdghgtgpiBcIDaAVAFjABAKQK4CcBPAXRABoQAzAGwgDcB7fFGADwBcEQAeAIwD5UGHARLcA9AIA6YPvn4z0WAMoBhAKIA5dQH0A8gHVtAJR2aAggFl1mfDAjUAlgC8YAZ0zs0EdpgDGDGB+MGDs+D6OYADmnsIADgwA7jD4mAyUmAAy5gaYjh7hXil5YDCUlDB+7I50MAB0mEqEtjAAJrjBsTCOqUlgmJR2WImO1NQlmGx+3tFYlEwlfnYQbpExjr4jXpFdjebGAOLqKGZWunqmFtbKdTJy-PfkIOwQ+FEw7HqlXJQObnAUMKOKLvfCqQKtDaOQJuTI1NZcJDAKQgRxQBL4F6hAxMVoo+AoywQVho3BQLIdADWKLIKM0ehQ+JRv2o-xpKIAasYAJLKADS5iZVD+MHZ4GgooQhMIyhe7G5bgOy3YKXQEDAHIcuEltNR6KYWPloSFAEYAMwogC+ZEwyL1GMNOPweKlIE04kF5DpDKFLLZXpAXN5At9IrFkFgQoV5ictTFaId6qN7CFAAYrTa7QmDUmnS6CSAAGJDTAGUbUMX0xmusLasVB-megt+nUoiOSgsoV7vdiynwKpX2FXMGaa6h1gPZzFJ7nG13m1PpkDW20oqeO3FC4swLBlsaVn2ulv1nmN0Os1viyOurtvD59+WK5Wq0day-rmdzgsAWgXS5XWb6tO2Kbq6AAK45+JSjQMJSITwDoiGYJoAAs3JRK0URoFE7BRHEjgAEJ+Ny5gCrw5hvAAmokmiUeYJEAI7mAAnNQABWByqOYAAiACKUQEVAfLqOYvBRLx6gAKwoYk5gwOYmRRI4ejKAcrDmIkejUQATHJKAEaw6jUKoqhRNxeh+KoUCJJRBGZPM3K2Wg5hQOYLkbAwbhmsoVgMOwDF8ok34oFEBwmlE5gABLGKofIMOYBGphAAAciTkXoDGWOwrQANSRbZhDmGBvHmFEYAAFqUt+bjYChYGQMolhsaoaCYQRTHqPFlJmQKmjcmgqiaIWyhuHQkVRKmkVSdyqhgMoEAoOYDDUOYACqejOFEhC4LwqjjqtPk8fl5h0FAvEoewdDlXomRoARuDRK42CUZF5WUcoBE5eoyipqwOUwMo2AMeVFV0NQxiSaw128W4qgmtQyiUZoEAEYW5gmt+lAGNxbF+Km1AAOw+a0Cn4JZbgMQxBz+QAbDlUAEQcOUmuVZqFtxqirdQ3HmEjbE+QRjgcZYcRgJYAAa2koXQZo5VE2AEZRYHaamjhoJFh0HtWzZhgGDYhjW+ATrq7ZCpFKzKMEpTxkBhqzimrr-pma627moEFu6nq6lW57+rq+tNsyusmxKUZuMY6qtAwUA24moT20KklO6u9o5iBzpCp7Wu+5eAdCrWl6m665uw9HcTUB8bQxtQmSR7x2puOwbix2nyZphmKcfun+Yotuu7ltnR7B5yp4GzrF7hqHrqWDKcoDs+I7qmOxsu3HbfzmayeAWveaZx6g-j37I-BoHwoTwGRcFgqEEQIQKQt8B68Flvq+t7vCBgLgYze4eh+56Pp9jwXyngWGeeh8JgGhGAPQlBbw9nnkOF8S83wPztl+FE35JJWlIICfAwJQTgjAJCaoMJa5EMRDgkAZQKhVDcIWJgcI6AIkQEiV+j934Fj7qWAewDrwFhauqd4D4TwnxzqgpMmgyS8HvhvF+qd2HuxRBBKkME4JgAQkhVC6FMLYVwvhIiJEyIUSiNRWi9FzBMVYhxLifEBJCREmJCS0lZLyUUspVS6lNI6T0gZIyJkzIWSsjZOyDknIuTclADyXkfKWD8gFIKIUwoRWirFeKiUUppXMBlLKuV8oEUKsVUqFUqo1Tqg1JqLU2odS6j1cwfUBpDRGmNCaU1JIzTmgtJaK11qbW2rtfah1uLHVOudS611br3UejAZ6r13qfW+r9f6gNgag3BpDaGsN4aI2RqjdGmNsa43xkTcwJNMhk1UBTKmtN6aM2ZqzdmnNua800PzBKQsDgizFpLaWst5aK2VqrdWmteEdhRMYGAUAGC1HMFUKBIizyGxXvIw0kioDSPwO3ZcztkVuwzq6Lhe4KwgqFAI2YM9hF6wAWIycrtQiovRUKX8m8O7bzfoot0+9iWulJe8cBkQoEwMsP-URQ9z66i7uwelMiCxYOXJQ6hlQm70PwGQ1obgKHLiAA",
        "[Guilty]:___ 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-o6HhSxaa+mhRPeFp8cBiKgBIugCCZGTgHmi-MGLS7Fk4cnUcCo4jYzcHgIlH9hEIolOSyljpUX8oZeBHUzLAXfzxUSP+CwcHAMsDXaeMLq4n2vmSpFVKpFIP-EQkhZCKFUJoW3NwhD-xAA",
        "[Unchained]:___ N4IgdghgtgpiBcIDaBVMBjAFhAlmGAJgLogA0IAZgDYQBuA9gE4AqMAHgC4IgA8ARgD5UGbHkJEeAekEAdMP0YC5zTDAAEAZQDCAUQByOgPoB5AOoGASob0BBALI61jGBCo4AXjADOajtg6+qmrMNhYA4jrM1vZGxla2Dhpq2D5e9LBO3hyMOOgcOPRgPn4QARDOagDuMDgA5ph4tYEwUGoE9JVgAHRqdjAcEAAOmEy5rlQAnqRq9BRq6PQAroxeMD0q6tr6seY68TGZUPS03s2rmV7ZufmFPhSM6c3BoRFRCbH7idP3MDVgTX4Wmp7o8-DgfLABsNRuhXGoYGBskNYIiesZMNMIGACE8tgYTLtPo5av0fBB5vR6FQ1JC4VhcGAZosArM1DgOF05AoBNyyCABowSRxjPhuNlFnByFdaiTGFpCgR2QUigAZHC0RrcJDAGQgHBQQZMAaI0xMAi6+C6uz0Pg4NwcCa60i6vTGZgW3UUVyrJ26gBqFgAkhoANI2D2Ub0wX3gaDRhBWiYaAYcQNeMLOUowFjYMB+1wSmP6w2MY2pxERgCMAGZdQBfaY6vUGo1YjimxjmhMgPSScNkF1uiNeqg+gcgAPBsPDqMxyCwCNpmxuE5FlultuBivdgAM9cbuuLrZNZojADFnOpTHaqDHXe7uyOx86J0HQ-3LZHR-GX-P45-mHKIVk1KNMMxcDhsxULF8yoQtxyPDdES3DgIwAWhrPcQAbNQm0QssOy7T8L1+NRryoW9x3vCNxR-f032nR9Z3HP8I0AwV+hA1N00zSCcxggs6ObEsyxQqta2wg9hOPdtT27AAFOD0AAa2CehlIReBDG0tQ9AAFkDWoCHqWoOFqQYcAAIXQQMbDDPgbEFABNSo9CcmxbIARxsABOKgACswi0GwABEAEVaksqAQx0Gw+FqMKdAAVj0yobBgGwVVqHBjA0MI2BsSpjBcgAmdLmEstgdCoLQtFqELjHQLQoEqJzLJVCh6EDNrMBsKAbD69l6C8asNHsegOE8kNKjQ5hajCStahsAAJCwtBDegbEsncIAADkqBzjE8uwOAIABqZa2omGx5LCmxajAAAtZS0K8AApPT5MgDQ7H8rRMGMyzvJ0TblPqsM9EDTAtD0M8NC8WhltqHdluSwMtDADQIBCKkbBQYx3FqCZFj4LQ4JQMbQsumxaCgMK9I4WhHuMFVMEsxZ-k8N6nOWx6nI0Syzp0DQdzYM6YA0N7PMep7aCoCwkrYZmwq8LRKyoDQnL0CBLLPGxKzQihTBC-z0B3KgAHYxoITLGCarxPM8sJJoANjOqBLLCM7K0e6szxCrQUCoEKbC1-yxssnBArsQYwDsAANEq9NoasztqN7LKc+SSp3HBMGWym7yHJjvxjSd3xoxh4N-OMI2WiAvA0dAESE-DN23T8sJwvD1wIuTP17fsX2okvn3oqcP09Zia4Xbs0wsLF2igNcRPb1DuySrupLbk9OwjQei4fT8nyE8vGM-Wi51r7t69V9JBiofpCDPHAVg4FVF7CiVLi8FeZLE3c+5cKHl7m2QiFowCLAosPYux9p7jwrqPISrFux2AmMYCyYBlTGAoOxIUYFeJQVzLBauIDV7IQ7rqJK9YSBShyDKbM8psRKluB-bEWpaEgBgBQCgMA8heDPEwNUGp-hah7uQ2Se9uwkSvDeK+s9Pz-SxCSLiZcGKTy-GPaSSEOB6EWFAPg2ZxJAPETJcB3YlF4C0jpfShljKYFMuZKyNkA6ZS0O1Owtkdy2UWDYFQ-w7AGQSjYWKbADTZGWr1EKfAnI6EqFAHQj0cBORClAWy8drryP-LqMI6oYCBkgsvccZ8NGXwQqAxEeiDFGMAZJYB2i+5SM-IpRYKk1IaTANYwwukgn2McRZaytl7KOVqC5NyHkbDeT8oFYK4VIrRVivFRKKU0oZSyjlPKBUiqlXKpVaqtV6qNWaq1dqnVuqWV6v1QaHBhqjXGpNaas15qLRWmtDaW0dr7UOsdU6F0ro3Tug9Z6r0PpfQgD9P6ANIrA1BuDGwkNoaw3hojZGqMkro0xtjGwuN8aE2JqTcmlMQrU1pvTRmzNWbs05jAbmvN+aC2FqLcWktpay3lorZWqt1aa21rrfWhtjam3NlbGwNsVR2y0A7J2rt3ae29r7f2gdg6hz0OHLaUcwgxzjonZOqd06Z2zrnfOhcWLX0-BYFoxwMp5GVGoieldSENLbFUwxjAIxb3qTvSRREXR9iyRGJR-wYAYLwNgigfQ7WILgaXcpEiXU1M-NQ7CnDuG8P4YIxgbCCBeA4dhIAA",
    ];


    @override
    double difficulty = 1.0;

    //TODO oh god where did KR put that palette again?
    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#003300"
        ..aspect_light = '#383838'
        ..aspect_dark = '#000000'
        ..shoe_light = '#2b1130'
        ..shoe_dark = '#130017'
        ..cloak_light = '#eba900'
        ..cloak_mid = '#c28900'
        ..cloak_dark = '#855900'
        ..shirt_light = '#ffd800'
        ..shirt_dark = '#d1a900'
        ..pants_light = '#44244d'
        ..pants_dark = '#271128';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Law", "Courts", "Trials", "Rules", "Edicts","Control","Cones","Order"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["LEGAL LAD", "SHERRIF SURESHOT", "CONE KOHAI"]);


    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Lawyer","Litigator","Lands","Laborer","Lady","Lad","Lamb","Lawman","Luchador","Lover","Legislacerator"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Judge","Law Abiding","Legal","Courting","Trail","Edict","Jury","Baliff","Verdict","Sentence","Jail","Executioner"]);


    @override
    String denizenSongTitle = "Dirge"; //a song for the dead;

    @override
    String denizenSongDesc = " A slow dirge begins to play. It is the one Death's Lawyer plays to keep in practice. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";

    @override
    List<String> symbolicMcguffins = ["orders","rules", "edicts", "sentences"];

    @override
    List<String> physicalMcguffins = ["chains","gavel","caution tape", "rule book", "dictionary", "wig", "handbook", "lock"];

    @override
    bool deadpan = true; // Ain't havin' none 'o' that trickster shit
    @override
    bool ultimateDeadpan = true; // now what did I *just* say?!
    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>["Themis","Phoenix","Wright","Jupiter","Dike","Marduk","Fortuna"]);



    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.FREE_WILL, 2.0, true),
        new AssociatedStat(Stats.SANITY, 1.0, true),
        new AssociatedStat(Stats.MOBILITY, -2.0, true),
        new AssociatedStat(Stats.SBURB_LORE, -0.1, false) //yes, technically it's from an aspect, but it's not NORMAL.
    ]);

    Law(int id) :super(id, "Law", isCanon: false);

    @override
    String activateCataclysm(Session s, Player p) {
        //TODO have a real gnosis even for law, don't just steal dooms
        return s.mutator.doom(s, p);
    }

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("LAW Gavel",<ItemTrait>[ItemTraitFactory.ASPECTAL,ItemTraitFactory.WOOD, ItemTraitFactory.HAMMER],shogunDesc: "Tiny Whacky Smacky Skull Cracky of Justice",abDesc:"Organics seem to respect this. Use it to your advantage."))
            ..add(new Item("LAW Caution Tape",<ItemTrait>[ItemTraitFactory.ASPECTAL,ItemTraitFactory.PLASTIC, ItemTraitFactory.RESTRAINING],shogunDesc: "Impassible Barrier",abDesc:"For when you want to tell inferior organics to keep out."))
            ..add(new Item("STOP SIGN",<ItemTrait>[ItemTraitFactory.ASPECTAL,ItemTraitFactory.STAFF,ItemTraitFactory.METAL, ItemTraitFactory.RESTRAINING],abDesc:"This isn't a weapon, dunkass."));
    }


    @override
    void initializeThemes() {
        addTheme(new Theme(<String>["Scales", "Disorder", "Chaos", "Injustice"])
            ..addFeature(FeatureFactory.DRAGONCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.DANGEROUSFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.LAUGHINGSOUND, Feature.LOW)
            ..addFeature(new DenizenQuestChain("Punish the Rebels", [
                new Quest("The ${Quest.PLAYER1} is told by a worried ${Quest.CONSORT} that a group of underling rebels are causing havoc across the land, breaking laws left and right. They must be stopped! Eventually."),
                new Quest("The ${Quest.PLAYER1} has located a rebel hideout. The underlings get ready for a battle to the death when the ${Quest.PLAYER1} suddenly breaks out a ${Quest.PHYSICALMCGUFFIN} and starts getting all lawyerly on them. The underlings are all sentenced to 30 years in prison, without parole."),
                new Quest("The ${Quest.PLAYER1} finds out through interrogating enough of the underling rebels that they have a big mean leader they call the ${Quest.DENIZEN}. Sounds like a challenge. The ${Quest.PLAYER1} cracks their knuckles as they prepare for the biggest case on this side of Skaia."),
                new DenizenFightQuest("Arriving at the final rebel hideout, ${Quest.PLAYER1} prepares for battle against the ${Quest.DENIZEN}. For their crimes against the ${Quest.CONSORT}s, they're getting the DEATH SENTENCE.","The ${Quest.DENIZEN} lies slain by the ${Quest.PLAYER1}'s ${Quest.WEAPON}. The ${Quest.PLAYER1} has won! The ${Quest.CONSORT}s are no longer plagued by the lawbreakers.","The ${Quest.DENIZEN} continues to run their underling crime ring with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.HIGH);

        addTheme(new Theme(<String>["Heroics","Villains","Heroes","Powers","Justice","Metropolises","Comics"])
            ..addFeature(FeatureFactory.HEROICFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.ENERGIZINGFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.MUSICSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.HEROICFEELING, Feature.LOW)
            ..addFeature(FeatureFactory.OILSMELL, Feature.LOW)
            ..addFeature(new DenizenQuestChain("Become the Villain", [
                new Quest("The ${Quest.PLAYER1} is taking a walk through one of the land's many cities when they witness a fight break out between an Underling Hero and ${Quest.CONSORT} Villain. One of the Underling Hero's attacks hits the ${Quest.PLAYER1}. They won't be having any of that! The ${Quest.PLAYER1} helps the ${Quest.CONSORT} Villain defeat the Underling Hero, and in turn gets invited to join a league of shady criminals. Sweet."),
                new Quest("The ${Quest.PLAYER1} teams up with some other villainous ${Quest.CONSORT}s to take down a rival team of Underling Heroes. They won't be having any of this LAW business, certainly. Rules were made to be broken, and that's just what the ${Quest.PLAYER1} is going to do."),
                new Quest("After defeating yet another league of Underling Heroes, the ${Quest.PLAYER1} and the other ${Quest.CONSORT} Villains feel a cold chill run down their spine. In the distance, lightning strikes a mountain, revealing the headquarters of the  ${Quest.DENIZEN}, leader of the Underling Heroes and the last hope to preserve law. They're going down!"),
                new DenizenFightQuest("The ${Quest.PLAYER1} arrives at the ${Quest.DENIZEN}'s headquarters, fighting through waves of Underling Heroes before they can finally reach the ${Quest.DENIZEN}. It’s time to end the LAW, once and for all!", "The ${Quest.DENIZEN} lies slain by the ${Quest.PLAYER1}'s ${Quest.WEAPON}. The last of the Heroes is no more.  Injustice takes over the land at last.","The ${Quest.PLAYER1} is defeated. The ${Quest.DENIZEN} holds on to the last remnants of justice in the land.")
            ], new DenizenReward(), QuestChainFeature.playerIsDestructiveClass), Feature.WAY_LOW)

            ..addFeature(new DenizenQuestChain("Become the Hero", [
                new Quest("The ${Quest.PLAYER1} is taking a walk through one of the land's many cities when they witness a fight break out between some ${Quest.CONSORT} Hero and an Underling Villain. Being naturally inclined toward the preservation of order, the ${Quest.PLAYER1} teams up with the ${Quest.CONSORT} Hero and triumphs against the Underling Villain. As a reward, the ${Quest.CONSORT} Hero invites the ${Quest.PLAYER1} to join an elite team of crime fighting good guys! Awesome!"),
                new Quest("The ${Quest.PLAYER1} works together with some ${Quest.CONSORT} Heroes to take down and arrest some Underling Villains. Slowly but surely, the balance of order and disorder begins to shift in order's favor. The number of villains is getting fewer and fewer."),
                new Quest("With the last of the Villainous Underlings defeated, the ${Quest.PLAYER1} rejoices, thinking that justice has been served in this land. But what's this? Lightning strikes the ground far away and causes a dark mountain to shoot up into the sky! The lair of the final villain, the ${Quest.DENIZEN}, has been revealed."),
                new DenizenFightQuest("The ${Quest.PLAYER1} storms the lair of the ${Quest.DENIZEN}, the final villain in all of this land. It's time to bring back KAW, once and for all!", "The ${Quest.DENIZEN} lies slain by the ${Quest.PLAYER1}'s ${Quest.WEAPON}. The last of the Villains is no more. Justice is finally preserved in the land at last.","The ${Quest.PLAYER1} is defeated. The ${Quest.DENIZEN} holds on to the last remnants of injustice in the land.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH);

        addTheme(new Theme(<String>["Greed", "Poverty", "Discrepancy", "Famine", "Starvation"])
            ..addFeature(FeatureFactory.OZONESMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.ROTSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.NOTHINGFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ECHOSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.SILENCE, Feature.LOW)
            ..addFeature(new DenizenQuestChain("Bring the Balance", [
                new Quest("The ${Quest.PLAYER1} looks upon the land and notices how some of the ${Quest.CONSORT}s are low on food and other resources while others live in luxury. Something must be done to fix this!"),
                new Quest("The ${Quest.PLAYER1} comes up with a plan to bring balance to the land. If there's not enough resources, they'll simply have to cut the ${Quest.CONSORT} population in half. But through murder? No... They need something cleaner. Something more random."),
                new Quest("The ${Quest.PLAYER1} wanders through a poverty striken ${Quest.CONSORT} village and is told the legend of the ${Quest.DENIZEN}. The ${Quest.DENIZEN} lives in a lair on the other side of the land, where they hoard all of the land's resources. Oh yeah, and they've got this golden ${Quest.PHYSICALMCGUFFIN} that can half the number of ${Quest.CONSORT}s on the land. The ${Quest.PLAYER1} finds this especially interesting. "),
                new DenizenFightQuest("The ${Quest.PLAYER1} shows up at the ${Quest.DENIZEN}'s lair and asks them to hand over the golden ${Quest.PHYSICALMCGUFFIN}. The ${Quest.DENIZEN} agrees... if the ${Quest.PLAYER1} can defeat them first!","The ${Quest.DENIZEN} lies slain by the ${Quest.PLAYER1}'s ${Quest.WEAPON}. The ${Quest.PLAYER1} uses the golden ${Quest.PHYSICALMCGUFFIN} to cut the ${Quest.CONSORT} population in half. Problem solved. ","The ${Quest.PLAYER1} is defeated and left without the golden ${Quest.PHYSICALMCGUFFIN} they seek.")
            ], new DenizenReward(), QuestChainFeature.playerIsDestructiveClass), Feature.HIGH)

            ..addFeature(new DenizenQuestChain("Create the Balance", [
            new Quest("The ${Quest.PLAYER1} looks upon the land and notices how some of the ${Quest.CONSORT}s are low on food and other resources while others live in luxury. Something must be done to fix this!"),
                new Quest("The ${Quest.PLAYER1} comes up with a plan to bring balance to the land. They can force the ${Quest.CONSORT}s who have an abundance of resources to share them with the ${Quest.CONSORT}s who are resource deprived. But when the ${Quest.PLAYER1} tells them this, they get understandably upset. They worked so hard for their resources, why should they share them with others? The ${Quest.PLAYER1} is left stumped."),
                new Quest("The ${Quest.PLAYER1} wanders through a poverty striken ${Quest.CONSORT} village and is told the legend of the ${Quest.DENIZEN}. The ${Quest.DENIZEN} lives in a lair on the other side of the land, where they hoard all of the land's resources. The ${Quest.PLAYER1} is confused as to why nobody mentioned this before. The solution to the resource problem is obvious now."),
                new DenizenFightQuest("The ${Quest.PLAYER1} shows up at the ${Quest.DENIZEN}'s lair and asks them to be kind and share their resources with the ${Quest.CONSORT}s. The ${Quest.DENIZEN} agrees... if the ${Quest.PLAYER1} can defeat them first!","The ${Quest.DENIZEN} lies slain by the ${Quest.PLAYER1}'s ${Quest.WEAPON}. The ${Quest.PLAYER1} distributes all of the denizen's resources throughout the land, improving living conditions everywhere.","The horrific inequality maintained by the ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
                ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH);
    }
}
