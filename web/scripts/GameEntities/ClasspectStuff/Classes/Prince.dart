import "../../../SBURBSim.dart";
import "SBURBClass.dart";
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Prince extends SBURBClass {
    @override
    double difficulty = 1.0;
    Prince() : super("Prince", 10, true);
    @override
    List<String> levels = ["PRINCE HARMING", "ROYAL RUMBLER", "DIGIT PRINCE"];
    @override
    List<String> quests = ["destroying enemies thoroughly", "riding in at the last minute to defeat the local consorts hated enemies", "learning to grow as a person, despite the holes in their personality"];
    @override
    List<String> postDenizenQuests = ["thinking on endings. The end of their planet. The end of their denizen problems. The end of that very, very stupid imp that just tried to jump them", "defeating every single mini boss, including a few on other players planets", "burning down libraries of horror terror grimoires, shedding a few tears for the valuable knowledge lost along side the accursed texts", "hunting down and killing the last of a particularly annoying underling class"];
    @override
    List<String> handles = ["precocious","priceless","proficient","prominent","proper", "perfect", "pantheon"];

    @override
    bool isProtective = false;
    @override
    bool isSmart = false;
    @override
    bool isSneaky = false;
    @override
    bool isMagical = false;
    @override
    bool isDestructive = true;
    @override
    bool isHelpful = false;

    @override
    bool highHinit() {
        return true;
    }

    @override
    bool isActive([double multiplier = 0.0]) {
        return true;
    }


    @override
    num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
        if (stat.multiplier > 0) {
            powerBoost = powerBoost * -0.5; //good things invert to bad.
        } else {
            powerBoost = powerBoost * -2.0; //bad thigns invert to good, with a boost to make up for the + to bad things
        }
        return powerBoost;
    }

    @override
    bool hasInteractionEffect() {
        return true;
    }
    @override
    String interactionFlavorText(Player me, GameEntity target, Random rand) {
        return " The ${me.htmlTitle()} appears to be destroying ${rand.pickFrom(me.aspect.symbolicMcguffins)} in themselves. ";
    }

    @override
    void processStatInteractionEffect(Player p, GameEntity target, AssociatedStat stat) {
        num powerBoost = p.getPowerForEffects() / 20;
        powerBoost = this.modPowerBoostByClass(powerBoost, stat);
        if(p.session.mutator.bloodField) powerBoost = powerBoost * p.session.mutator.bloodBoost;
        //modify self.
        p.modifyAssociatedStat(powerBoost, stat);
    }


    @override
    void initializeThemes() {
       /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        addTheme(new Theme(<String>["Endings","Finales", "Epilogues", "Codas","Curtains","Conclusions"])
            ..addFeature(FeatureFactory.CLAPPINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CONTEMPLATATIVEFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SKELETONCONSORT, Feature.LOW)

            ..addFeature(new PostDenizenFrogChain("Destroy the Lack of Frogs", [
                new Quest("With the closing of the curtain, the ${Quest.DENIZEN} has released the frogs, and yet they are nowhere to be found. The ${Quest.PLAYER1} shatter space itself to reveal an entire dimension of croaking assholes. "),
                new Quest("The ${Quest.PLAYER1} has broken how space itself works to do the ectobiology as effciently as possible.   "),
                new Quest("The ${Quest.PLAYER1} has found the final frog in a crack in reality.  They combine it and eventually have the    "),
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)


            ..addFeature(new PostDenizenQuestChain("Fix All The Things", [
                new Quest("The land is a fucking mess after all the shit the ${Quest.DENIZEN} put it through, and it falls to the ${Quest.PLAYER1} to get it back to normal. They organize a team of ${Quest.CONSORT}s to start rebuilding infrastructure."),
                new Quest("The ${Quest.CONSORT} economy is a fucking mess, and probably was even before the ${Quest.DENIZEN} started to fuck things up. Why would you even use ${Quest.PHYSICALMCGUFFIN} as a currency? The ${Quest.PLAYER1} wastes way too much time explaining how economies work."),
                new Quest("The land finally appears to be in a good state. The ${Quest.PLAYER1} is wistful as they realize that they are no longer needed. ")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);
    }


}