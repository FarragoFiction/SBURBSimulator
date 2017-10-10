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
                new Quest("The ${Quest.PLAYER1} finds an elaborate courtroom full of ${Quest.CONSORTSOUND}ing ${Quest.CONSORT}s. Apparently the prosecuting attorney flaked out and they need someone to fill the role. The ${Quest.PLAYER1} agrees to see that justice is served. "),
                new Quest("The ${Quest.PLAYER1} is tasked to prosecute a local ${Quest.CONSORT} accused of stealing food for her family. After much elaborate debate and arguments, the ${Quest.PLAYER1} secures the guilty verdict while also convincing the judge to pursue the minimum sentence. Everyone is relieved that justice is done while not harshly punishing a near innocent.     "),
                new Quest(" The ${Quest.PLAYER1} presides over the case of the treacherous Senator ${Quest.CONSORT}snout. He is accused of embezzling ${Quest.PHYSICALMCGUFFIN}s from the Imperial Coffers. The ${Quest.PLAYER1} easily finds Senator ${Quest.CONSORT}snout to be guilty and sentences them to life in prison. This is EASILY the case of their career and it is with a regreful heart they step aside as Prosecuter. They simply can never top this one.")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);


        addTheme(new Theme(<String>["Police","Law","Jails", "Slammers", "Officers","Cops","Prisons", "Detectives"])
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.DANGEROUSFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CLANKINGSOUND, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("Enforce the Law", [
                new Quest("A frantic underling run past the  ${Quest.PLAYER1}. In hot pursuit, a ${Quest.CONSORT} yells 'Stop that thief' in betwen ${Quest.CONSORTSOUND}s. Without thinking, the ${Quest.PLAYER1} grabs the underling. The ${Quest.CONSORT} is impressed, and offers the ${Quest.PLAYER1} a job as a deputy police officer. "),
                new Quest("The ${Quest.PLAYER1} is doing their rounds as a deputy police officer. So far, everything is peaceful."),
                new Quest("A missing ${Quest.PHYSICALMCGUFFIN}. Three suspects. A locked door. The ${Quest.PLAYER1} blows everyone away by cracking the case wide open and sending the perpetrator to the slammer. They are promoted from deputy to a full blown detective, which comes with a lot less frequent jobs, but far more prestige. "),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);

        //the sock ruse was a distaction
        addTheme(new Theme(<String>["Classism","Struggle","Apathy", "Revolution", "Rebellion"])
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("Start a Rebellion", [
                new Quest("The ${Quest.PLAYER1} finds a group of three ${Quest.CONSORT}s ${Quest.CONSORTSOUND}ing about how the Prospitian government SEEMS nice and friendly, but it's all a cover up!  Intrigued, the ${Quest.PLAYER1} learns of several conspiracies they have surpressed, not LEAST of which is the existance of ALIENS in the Medium. "),
                new Quest("The ${Quest.PLAYER1} does a daring mission at a local Prospitian embassy and uncovers all sorts of juicy secrets. They can't help but read some of them ahead of time and- oh. Oh I see. In retrospect, the players kind of ARE aliens to the Medium. This conspiracy is a lot less interesting now.  "),
                new Quest("The ${Quest.PLAYER1} shows the conspiracy papers to the three ${Quest.CONSORT}s, who fail to see the humor in the situation. They immediately try to rally their fellow ${Quest.CONSORT}s against the alien threat that is the foretold Players themselves. They...don't get even a single solitary ${Quest.CONSORTSOUND} of agreement from the crowd, though. Looks like they are stuck being the wacky conspiracy theorists. "),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);
    }


}