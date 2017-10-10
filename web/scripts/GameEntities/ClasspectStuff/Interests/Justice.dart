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
    List<String> handles2 =  <String>["Detective", "Defender", "Laywer", "Loyalist", "Liaison", "Vigilante", "Tracker", "Moralist", "Retribution", "Watchman", "Searcher", "Perception", "Rebel"];

    @override
    List<String> levels = <String>["JUSTICE JUICER", "BALANCE RUMBLER"];

    @override
    List<String> interestStrings = <String>["Social Justice", "Detectives", "Mysteries", "Leadership", "Revolution", "Justice", "Equality", "Sherlock Holmes"];




    Justice() :super(6, "Justice", "fair-minded", "harsh");



    @override
    void initializeThemes() {
        addTheme(new Theme(<String>["Consequence","Trials","Justice", "Courtrooms", "Crime", "Punishment", "Law","Karma"])
            ..addFeature(FeatureFactory.DRAGONCONSORT, Feature.LOW)
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.STUDIOUSFEELING, Feature.LOW)
            ..addFeature(new PreDenizenQuestChain("Shit, Let’s Be Lawyers", [
                new Quest("The ${Quest.PLAYER1} learns of a Beautiful ${Quest.CONSORT} who has been kidnapped by the vial ${Quest.DENIZEN} Minion. There is a hefty reward should a brave Hero rescue them. "),
                new Quest(" The ${Quest.PLAYER1} journeys to the castle of the ${Quest.CONSORT} Minion, only to discover that they way is barred by a giant iron lock. Only the correctly shaped ${Quest.PHYSICALMCGUFFIN} can open it. Looks like it's time to go questing."),
                new Quest("The ${Quest.PLAYER1} finally finds a correctly shaped.  ${Quest.PHYSICALMCGUFFIN}.  The gate swings open, and the ${Quest.DENIZEN} Minion is swiftly defeated. The Beautiful ${Quest.CONSORT} delivers a reward to the brave ${Quest.PLAYER1}. Convenient that they had it with them when they were kidnapped, huh?   "),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);


        addTheme(new Theme(<String>["Police","Law","Jails", "Slammers", "Officers","Cops","Prisons"])
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.BLOODSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.FOOTSTEPSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.SCREAMSSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.ROMANTICFEELING, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("Enforce the Law", [
                new Quest("The ${Quest.PLAYER1} recieves an inventation to dine at the remote castle of Count Feratu. No one ever sees this mysterious ${Quest.CONSORT} leave, and no one can remember the last time he received guests."),
                new Quest("The ${Quest.PLAYER1} attends the dinner. Count Feratu is an.... eccentric ${Quest.CONSORT}. He sure does like drinking dark red liquids! And being in dimly lit rooms. And telling you to ignore the blatant screams coming from the dungeon. Luckily it all turns out to be a wacky misunderstanding. Really, VAMPIRES are fakey fake bullshit."),
                new Quest(" The ${Quest.PLAYER1} sees Castle Feratu in the distance. The silhouette of a ${Quest.CONSORT} standing on a balcony suddenly morphs into a bat and flies away. Holy shit, maybe he really WAS a vampire!? But...he doesn't seem to be hurting anyone, so...live and let live, you guess. "),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);

        //the sock ruse was a distaction
        addTheme(new Theme(<String>["Classism","Struggle","Apathy", "Revolution", "Rebellion"])
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.OZONESMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.GLAMOROUSFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.BEEPINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.PULSINGSOUND, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("Start a Rebellion", [
                new Quest("The ${Quest.PLAYER1} finds a group of three ${Quest.CONSORT}s ${Quest.CONSORTSOUND}ing about how the Prospitian government SEEMS nice and friendly, but it's all a cover up!  Intrigued, the ${Quest.PLAYER1} learns of several conspiracies they have surpressed, not LEAST of which is the existance of ALIENS in the Medium. "),
                new Quest("The ${Quest.PLAYER1} does a daring mission at a local Prospitian embassy and uncovers all sorts of juicy secrets. They can't help but read some of them ahead of time and- oh. Oh I see. In retrospect, the players kind of ARE aliens to the Medium. This conspiracy is a lot less interesting now.  "),
                new Quest("The ${Quest.PLAYER1} shows the conspiracy papers to the three ${Quest.CONSORT}s, who fail to see the humor in the situation. They immediately try to rally their fellow ${Quest.CONSORT}s against the alien threat that is the foretold Players themselves. They...don't get even a single solitary ${Quest.CONSORTSOUND} of agreement from the crowd, though. Looks like they are stuck being the wacky conspiracy theorists. "),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);
    }


}