import "../../GameEntity.dart";
import "SBURBClass.dart";
import "../../../SBURBSim.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";
class Scout extends SBURBClass {
    Scout() : super("Scout", 13, false);
    //i am thinking guides will give other players their own aspects (and not the guides) while scouts will gain whoever they are with's aspect.
    @override
    List<String> levels = ["BOSTON SCREAMPIE", "COOKIE OFFERER", "FIRE FRIEND"];
    @override
    List<String> quests = ["exploring areas no Consort has dared to trespass in", "getting lost in ridiculously convoluted mazes", "playing map-creating mini games"];
    @override
    List<String> postDenizenQuests = ["finding Consorts that still need help even after the Denizen has been defeated", "scouting out areas that have opened up following the Denizen's defeat", "looking for rare treasures that are no longer being guarded by the Denizen"];
    @override
    List<String> handles = ["surly", "sour", "sweet", "stylish", "soaring", "serene", "salacious"];

    @override
    bool isProtective = true;
    @override
    bool isSmart = false;
    @override
    bool isSneaky = true;
    @override
    bool isMagical = false;
    @override
    bool isDestructive = false;
    @override
    bool isHelpful = false;

    @override
    bool highHinit() {
        return false;
    }

    @override
    bool isActive([double multiplier = 0.0]) {
        return true;
    }


    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        addTheme(new Theme(<String>["Books","Libraries", "Tomes", "Pages","Advice","Scholarship","Expertise"])
            ..addFeature(FeatureFactory.MUSTSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.TURTLECONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.LOW)
            ..addFeature(FeatureFactory.STUDIOUSFEELING, Feature.HIGH)
            ..addFeature(new PostDenizenQuestChain("Be the Sage", [
                new Quest("Now that the ${Quest.DENIZEN} is defeated, it is time to begin recovery efforts. The ${Quest.CONSORT}s ask the ${Quest.PLAYER1} what they should do first.  When they hesitate, the ${Quest.CONSORT}s begin ${Quest.CONSORTSOUND}ing in distress. Desparate, the ${Quest.PLAYER1} confidently advises them to begin cleaning up rubble. The ${Quest.CONSORT}s seem satisfied.  The ${Quest.PLAYER1} absconds into a nearby library to read up on how in Paradox Space they can figure out what ACTUALLY needs done. "),
                new Quest("The ${Quest.PLAYER1} has read up on disaster recovery and helps the ${Quest.CONSORT}s plan the next season's crops, build infrastructure and even set up psychological counseling center for those in need. Every moment they aren't in public they are devouring tomes in an effort to stay one step ahead of everything."),
                new Quest("Finally, recovery efforts are complete. The ${Quest.PLAYER1} has developed quite the reputation as the person to go to for advice and knowledge. ")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);
    }



}