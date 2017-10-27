import "SBURBClass.dart";
import "../../../SBURBSim.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";
class Guide extends SBURBClass {
    List<String> handles = <String>["guiding", "gracious", "great", "gratuitous", "greeting", "gloved", "gone"];
//i am thinking guides will give other players their own aspects (and not the guides) while scouts will gain whoever they are with's aspect.
    @override
    bool isProtective = true;
    @override
    bool isSmart = false;
    @override
    bool isSneaky = false;
    @override
    bool isMagical = false;
    @override
    bool isDestructive = false;
    @override
    bool isHelpful = true;
    Guide() : super("Guide", 16, false);

    @override
    bool highHinit() {
        return true;
    }

    @override
    bool isActive([double multiplier = 0.0]) {
        return false;
    }


    //guides show others their aspect and protect them from it (and it from them)
    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        addTheme(new Theme(<String>["Mountains","Vistas", "Rocks", "Sherpas","Guides"])
            ..addFeature(FeatureFactory.WOLFCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.NATURESMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.DANGEROUSFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.NATURESOUND, Feature.HIGH)
            ..addFeature(new PostDenizenQuestChain("Find the Home", [
                new Quest("Now that the ${Quest.DENIZEN} is out of the way, a group of ${Quest.CONSORT} want to return to their ancestral home. Unfortunately, it has been so long that no one remembers exactly where it is.   The ${Quest.PLAYER1} volunteers to guide everyone based on half remembered legends and a few recovered parts of maps. "),
                new Quest("A ${Quest.CONSORT} child nearly falls off a cliff, but the ${Quest.PLAYER1}'s manages to grab them in time. Who knew mountains could be so dangerous? "),
                new Quest("After an exhausting journey, the ${Quest.PLAYER1} has lead the ${Quest.CONSORT}s back to a ruin that is almost certainly their ancestral home. Everyone is too tired to even ${Quest.CONSORTSOUND}, but they are happy.")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

        //space player near guaranteed to do this.
            ..addFeature(new PostDenizenFrogChain("Find the Frogs", [
                new Quest("The ${Quest.DENIZEN} has released the frogs from their icy prisons. The land melts and warms and just generally becomes a lot nicer. The ${Quest.PLAYER1} is given a map to where all the frogs are and is told to get going. "),
                new Quest("The ${Quest.PLAYER1} is following a detailed guide on which frogs to combine with which other frogs. It's a little boring, but at least the ${Quest.PLAYER1} knows they won't make a mistake."),
                new Quest("Following the last step in the guide booke, the ${Quest.PLAYER1} finds the Final Frog. Luckily, a ${Quest.CONSORT} ${Quest.CONSORTSOUND}s in time to stop them.    "),
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)
            ,  Theme.MEDIUM);
    }

}