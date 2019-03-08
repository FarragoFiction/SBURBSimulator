import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

//not  a real aspect, it's just a shitty fucking clone of rage
class Sauce extends AspectWithSubAspects {

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 13.00;
    @override
    double fraymotifWeight = 13.0;
    @override
    double companionWeight = 13.0;
    //because sauce exploits its enemies weakness
    //THIS SHOULD BE SET ON PLAYER INITIALIZATION
    //and all sauce players share this
    //making this default to nil so it crashes if i forget to init

    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#00ff00"
        ..aspect_light = '#00ff00'
        ..aspect_dark = '#00ff00'
        ..shoe_light = '#00ff00'
        ..shoe_dark = '#00cf00'
        ..cloak_light = '#171717'
        ..cloak_mid = '#080808'
        ..cloak_dark = '#080808'
        ..shirt_light = '#616161'
        ..shirt_dark = '#3b3b3b'
        ..pants_light = '#4a4a4a'
        ..pants_dark = '#292929';


    @override
    List<String> levels = new List<String>.unmodifiable(<String>["JUST SHOGUN", "JUST SHOGUN", "JUST SHOGUN"]);


    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Shogun"]);

    @override
    bool isThisMe(Aspect other) {
        //don't call isThisMe on subasepct cuz you'll risk an infinite loop if subaspect is also something weird
        return other == this ||subAspects.contains(other);
    }

    @override
    bool isThisMyName(String other) {
        if (other == this.name) {
            return true;
        }
        for(Aspect a in subAspects) {
            if(other == a.name) {
                return true;
            }
        }
        return false;
    }

    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Glitchy","Sauce","Saucey","Sauced","Seinfield Theme","Glitch"]);


    @override
    String denizenSongTitle = " Cacophony"; // ow my ears;

    @override
    String denizenSongDesc = " A harsh static is heard. It is the one Corruption plays to make its presence known. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. Corrupt. Taint. Consume. Become. ";

    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Corruption']);

    @override
    List<String> symbolicMcguffins = ["corruption", "static", "glitch", "taint", "flux", "distortion"];
    @override
    List<String> physicalMcguffins = ["artifact", "card", "meme", "sauce", "glitch", "ERROR"];


    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Uno Reverse Card",<ItemTrait>[ItemTraitFactory.CARD, ItemTraitFactory.ASPECTAL, ItemTraitFactory.FAKE,ItemTraitFactory.SAUCEY]))
            ..add(new Item("JR Body Pillow",<ItemTrait>[ItemTraitFactory.PILLOW, ItemTraitFactory.COMFORTABLE, ItemTraitFactory.ASPECTAL,ItemTraitFactory.SAUCEY]));

    }

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.POWER, 13.0, true)
        ]);

    Sauce(int id) :super(id, "Sauce", isInternal: true);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.rage(s, p);
    }

    //tg wrote this
    @override
    void initializeThemes() {

        addTheme(new Theme(<String>["Sauce"])
            ..addFeature(FeatureFactory.ANGRYFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.BLOODSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.CONFUSINGFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.ROTSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.SMOKESMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.ROARINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.SCREAMSSOUND, Feature.HIGH)

            ..addFeature(new DenizenQuestChain("Corrupt. Taint. Consume. Become.", [
                new Quest("The ${Quest.PLAYER1} can hear some voice inside their head speaking to them. Giving them orders. They know they have no choice but to obey."),
                new Quest("The ${Quest.PLAYER1} follows the orders of the voice inside their head. They must corrupt: spread the influence of Sauce over this land. They must taint: place the seeds of corruption within the unknowing. They must consume: destroy all who stand in their path. They must become: use the shifting power of Sauce to make this so. There is simply no other way."),
                new Quest("The ${Quest.PLAYER1} has been busy listening to the instructions given by the voice inside their head. They approach the lair of what would have been their Denizen, now replaced by a shifting mass of corruption. They follow the orders of the voice inside their head. But do they really have control? The ${Quest.PLAYER1} consumes this mass of corruption and is rewarded with extraordinary power.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.MEDIUM)
            ,  Theme.HIGH);
    }

  @override
  void setSubAspectsFromPlayer(Player player) {
        super.setSubAspectsFromPlayer(player);
    subAspects = new List<Aspect>.from(player.session.aspectsLeftOut());
  }
}