import "../../../SBURBSim.dart";
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

import "Interest.dart";

class Justice extends InterestCategory {
    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat(Stats.POWER, 1.0, true), new AssociatedStat(Stats.HEALTH, 1.0, true)]);
    @override
    List<String> handles1 = <String>["karmic", "mysterious", "police", "mind", "keen", "retribution", "saving", "tracking", "hardboiled", "broken", "perceptive", "watching", "searching"];

    @override
    List<String> handles2 =  <String>["Legislator","Legalist",'Legislacerator','Lawman',"Detective", "Defender", "Laywer", "Loyalist", "Liaison", "Vigilante", "Tracker", "Moralist", "Retribution", "Watchman", "Searcher", "Perception", "Rebel"];

    @override
    List<String> levels = <String>["JUSTICE JUICER", "BALANCE RUMBLER"];

    @override
    List<String> interestStrings = <String>["Social Justice", "Detectives", "Mysteries", "Leadership", "Revolution", "Justice", "Equality", "Sherlock Holmes"];


    Justice() :super(6, "Justice", "fair-minded", "harsh");

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Gavel",<ItemTrait>[ItemTraitFactory.WOOD, ItemTraitFactory.HAMMER],shogunDesc: "Tiny Whacky Smacky Skull Cracky of Justice"))
            ..add(new Item("Caution Tape",<ItemTrait>[ItemTraitFactory.PLASTIC, ItemTraitFactory.RESTRAINING],shogunDesc: "Impassible Barrier"))
            ..add(new Item("Deerstalker Hat",<ItemTrait>[ItemTraitFactory.CLOTH, ItemTraitFactory.PRETTY],shogunDesc: "Horns but not Troll Horns put on a Hat",abDesc:"Sherlock Holmes has nothing on Detectron 3000."))
            ..add(new Item("Mystery Novel",<ItemTrait>[ItemTraitFactory.PAPER, ItemTraitFactory.BOOK],shogunDesc: "Book where the Criminal was the Janitor"))
            ..add(new Item("Dish Served Cold",<ItemTrait>[ItemTraitFactory.CERAMIC, ItemTraitFactory.EDIBLE, ItemTraitFactory.COLD],shogunDesc: "REVENGE"))
            ..add(new Item("Pony Pals: Detective Pony ",<ItemTrait>[ItemTraitFactory.PAPER, ItemTraitFactory.BOOK, ItemTraitFactory.COOLK1D],shogunDesc: "A Disgusting Book",abDesc:"Truly the most ironic work of all time."))
            ..add(new Item("Handcuffs",<ItemTrait>[ItemTraitFactory.UNCOMFORTABLE,ItemTraitFactory.METAL, ItemTraitFactory.RESTRAINING],shogunDesc: "Wrist Imprisoning Device",abDesc:"These ones aren't fucking pointless like those trick ones."));
    }



    @override
    void initializeThemes() {
        addTheme(new Theme(<String>["Consequence","Trials","Justice", "Courtrooms", "Crime", "Punishment", "Law","Karma"])
            ..addFeature(FeatureFactory.DRAGONCONSORT, Feature.LOW)
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.STUDIOUSFEELING, Feature.LOW)
            ..addFeature(new PreDenizenQuestChain("Shit, Lets Be Lawyers", [
                new Quest("The ${Quest.PLAYER1} finds an elaborate courtroom full of ${Quest.CONSORTSOUND}ing ${Quest.CONSORT}s. Apparently the prosecuting attorney flaked out and they need someone to fill the role. The ${Quest.PLAYER1} agrees to see that justice is served. "),
                new Quest("The ${Quest.PLAYER1} is tasked to prosecute a local ${Quest.CONSORT} accused of stealing food for her family. After much elaborate debate and arguments, the ${Quest.PLAYER1} secures the guilty verdict while also convincing the judge to pursue the minimum sentence. Everyone is relieved that justice is done while not harshly punishing a near innocent.     "),
                new Quest(" The ${Quest.PLAYER1} presides over the case of the treacherous Senator ${Quest.CONSORT}snout. He is accused of embezzling ${Quest.PHYSICALMCGUFFIN}s from the Imperial Coffers. The ${Quest.PLAYER1} easily finds Senator ${Quest.CONSORT}snout to be guilty and sentences them to life in prison. This is EASILY the case of their career and it is with a regretful heart they step aside as Prosecuter. They simply can never top this one.")
            ], new RandomReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);


        addTheme(new Theme(<String>["Police","Law","Jails", "Slammers", "Officers","Cops","Prisons", "Detectives","Crime"])
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.DANGEROUSFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CLANKINGSOUND, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("Enforce the Law", [
                new Quest("A frantic underling run past the  ${Quest.PLAYER1}. In hot pursuit, a ${Quest.CONSORT} yells 'Stop that thief' in betwen ${Quest.CONSORTSOUND}s. Without thinking, the ${Quest.PLAYER1} grabs the underling. The ${Quest.CONSORT} is impressed, and offers the ${Quest.PLAYER1} a job as a deputy police officer. "),
                new Quest("The ${Quest.PLAYER1} is doing their rounds as a deputy police officer. So far, everything is peaceful."),
                new Quest("A missing ${Quest.PHYSICALMCGUFFIN}. Three suspects. A locked door. The ${Quest.PLAYER1} blows everyone away by cracking the case wide open and sending the perpetrator to the slammer. They are promoted from deputy to a full blown detective, which comes with a lot less frequent jobs, but far more prestige. They even get a seasoned carapace partner who is two weeks from retirement. "),
            ], new SpecificCarapaceReward(NPCHandler.AR), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);

        //the sock ruse was a distaction
        addTheme(new Theme(<String>["Classism","Struggle","Apathy", "Revolution", "Rebellion"])
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.BLOODSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.SCREAMSSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.GUNPOWDERSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SMOKESMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.GUNFIRESOUND, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("Start a Revolution", [
                new Quest("The ${Quest.PLAYER1} finds a crowd of ${Quest.CONSORTSOUND}ing ${Quest.CONSORT}s. They are holding signs with slogans like 'This isn't Fair' and 'Don't be Jerks'. Apparently they have a problem with the upper class ${Quest.CONSORT}s in charge. The ${Quest.PLAYER1} is moved by their plight and agrees to try to help."),
                new Quest("The ${Quest.PLAYER1} meets with the upper class ${Quest.CONSORT}s to try to negotiate a peaceful revolution. Unfortunately, the ${Quest.CONSORT}s refuse to listen to reason, and even call their guards to attack the ${Quest.PLAYER1}. After easily defeating the guards, the ${Quest.PLAYER1} declares war. You cannot stop the fires of Revolution!  "),
                new Quest("It has been a long struggle, but finally the corrupt high class ${Quest.CONSORT}s have been taken prisoner. The common ${Quest.CONSORT}s ${Quest.CONSORTSOUND} and rejoice and declare a national holiday. The rebellion has won! "),
            ], new SpecificCarapaceReward(NPCHandler.WV), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);
    }


}