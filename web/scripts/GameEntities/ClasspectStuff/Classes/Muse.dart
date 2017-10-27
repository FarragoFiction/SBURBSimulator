import "../../GameEntity.dart";
import "SBURBClass.dart";
import "../../../SBURBSim.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Muse extends SBURBClass {
    @override
    List<String> levels = ["AMUSING AMATEUR", "SPOTLIGHT POINTER", "GREEK GOD"];
    @override
    List<String> quests = ["inspiring the consorts to produce great works of art", "causing events to transpire such that the consorts improve themselves", "avidly learning about consort history and art"];
    @override
    List<String> postDenizenQuests = ["inspiring the consorts to rebuild their land", "showing the consorts what strength through adversity means", "hanging back and watching the consorts rebuild", "making sure the recovery process is going as intended"];
    @override
    List<String> handles = ["magical", "musing", "majestic", "managerial"];

    @override
    bool isProtective = false;
    @override
    bool isSmart = false;
    @override
    bool isSneaky = false;
    @override
    bool isMagical = true;
    @override
    bool isDestructive = false;
    @override
    bool isHelpful = true;

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.SBURB_LORE, 0.1, false)
    ]);

    Muse() : super("Muse", 18, false);


    @override
    bool highHinit() {
        return false;
    }
    //TODO okay i think i know what i want to do. have isActive take in an optional parameter of multiplier. if positive muse is passive, if negative muse is active
    //and vice versa for lord.
    @override
    bool isActive([double multiplier = 0.0]) {
        if(multiplier < 0) { //if no stat passed, act passive
           // print("Muse taking in the bad of stat");
            return true; //muse applies it to self if bad.
        }
       // print("Muse distributing the good of stat");
        return false; //to others if good.
    }


    @override
    num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
        return powerBoost; //no change.
    }

    //you don't expect a muse to start shit
    @override
    double getAttackerModifier() {
        return 0.1;
    }

    @override
    double getDefenderModifier() {
        return 3.0;
    }

    @override
    double getMurderousModifier() {
        return 0.1;
    }

    @override
    bool hasInteractionEffect() {
        return true;
    }

    @override
    String interactionFlavorText(Player me, GameEntity target, Random rand) {
        return " The ${me.htmlTitle()} takes on the burdens of ${me.aspect.name} while leaving the blessings for ${target.htmlTitle()}. ";
    }

    //TODO using the existing framework, how would i make it so that regular things matter based on target, too? i want to be lazy here. prefer caring about land update.
    @override
    void processStatInteractionEffect(Player p, GameEntity target, AssociatedStat stat) {
        num powerBoost = 2 * p.getPowerForEffects() / 20;

        powerBoost = this.modPowerBoostByClass(powerBoost, stat);
        if(p.session.mutator.bloodField) powerBoost = powerBoost * p.session.mutator.bloodBoost;
        //give bad to me and good to you.
        if(powerBoost <0) {
            p.modifyAssociatedStat(powerBoost, stat);
        }else {
            target.modifyAssociatedStat(powerBoost, stat);
        }
    }

    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        addTheme(new Theme(<String>["Music","Dance", "Poetry", "Inspiration"])
            ..addFeature(FeatureFactory.NATURESOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.NATURESMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.HAPPYFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.LAUGHINGSOUND, Feature.MEDIUM)

            ..addFeature(new PostDenizenFrogChain("Inspire Frog Breeding", [
                new Quest("The ${Quest.DENIZEN} has allowed inspiration to flow once more. The frogs are no longer too depressed to croak, and are much more easy to find. The ${Quest.PLAYER1} asks the ${Quest.CONSORT}s to help them collect frogs. The ${Quest.CONSORT}s agree with enthusiastic ${Quest.CONSORTSOUND}s. "),
                new Quest("The ${Quest.CONSORT}s hit buttons on the ectobiology machine at random. The ${Quest.PLAYER1} cheers them on and soon everybody is working just a bit better. "),
                new Quest("A ${Quest.CONSORT} child has tripped over the final frog. They cry and ${Quest.CONSORTSOUND} at their skinned knee, but their pain is quickly forgotten when the ${Quest.PLAYER1} praises them for finding the frog.  Together, they combine it and eventually have the    "),
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.MEDIUM)


            ..addFeature(new PostDenizenQuestChain("Inspire the People", [
                new Quest("You'd think after the dramatic defeat of the ${Quest.DENIZEN} the ${Quest.CONSORT}s would be celebrating. Instead they are just kind of moping around. When pressed, they say they just don't feel like doing anything. "),
                new Quest("The ${Quest.PLAYER1} bugs and fusses and meddles until the ${Quest.CONSORT}s agree to put on a performance of the musical 'The Lonely ${Quest.PHYSICALMCGUFFIN}'. The ${Quest.PLAYER1} assigns parts that challenge each of them without seeing impossible."),
                new Quest("The performance of The Lonely ${Quest.PHYSICALMCGUFFIN} goes off without a hitch. The ${Quest.CONSORT}s recieve accolades and ALL the self esteems.  They are inspired to reach ever greater heights of acomplishments. ")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);
    }

}