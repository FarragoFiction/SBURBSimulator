import "../../../SBURBSim.dart";
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

import "Interest.dart";

class Social extends InterestCategory {
    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat(Stats.SANITY, 2.0, true)]);
    @override
    List<String> handles1 = <String>["master", "playful", "matchmaking", "kind", "regular", "social", "trusting", "honest", "benign", "precious", "wondering", "sarcastic", "talkative", "petulant"];

    @override
    List<String> handles2 =  <String>["Socialist", "Defender", "Mentor", "Leader", "Veterinarian", "Therapist", "Buddy", "Healer", "Helper", "Mender", "Lender", "Dog", "Bishop", "Rally"];

    @override
    List<String> levels =<String>["FRIEND-TO-ALL", "FRIEND COLLECTOR"];

    @override
    List<String> interestStrings = <String>["Psychology", "Religion", "Animal Training", "Pets", "Animals", "Online Roleplaying", "Live Action Roleplaying", "Tabletop Roleplaying", "Role Playing", "Social Media", "Charity", "Mediating"];


    Social() :super(11, "Social", "extroverted", "shallow");

    @override
    void initializeThemes() {
        addTheme(new Theme(<String>["Couches","Therapy","Analysis", "Cigars", "Psychology"])
            ..addFeature(FeatureFactory.CLAPPINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.GLAMOROUSFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.HEROICFEELING, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("The Therapist is IN", [
                new Quest("The ${Quest.PLAYER1} "),
                new Quest("The ${Quest.PLAYER1}    "),
                new Quest(" The ${Quest.PLAYER1} ")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);

        addTheme(new Theme(<String>["Meditation","Worship","Altars","Hymns", "Chapels", "Priests", "Angels", "Religion"])
            ..addFeature(FeatureFactory.CLAPPINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.GLAMOROUSFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.HEROICFEELING, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("Learn About Frogism", [
                new Quest("The ${Quest.PLAYER1} "),
                new Quest("The ${Quest.PLAYER1}    "),
                new Quest(" The ${Quest.PLAYER1} ")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);


        addTheme(new Theme(<String>["Roleplaying","FLARPS","Dungeons", "Dragons", "Tabletops", "Dice"])
            ..addFeature(FeatureFactory.CLAPPINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.GLAMOROUSFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.HEROICFEELING, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("Steal the Door", [
                new Quest("The ${Quest.PLAYER1} "),
                new Quest("The ${Quest.PLAYER1}    "),
                new Quest(" The ${Quest.PLAYER1} ")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);
    }

}