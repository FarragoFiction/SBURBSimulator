import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Juice extends AspectWithSubAspects {

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 1.0;
    @override
    double fraymotifWeight = 1.0;
    @override
    double companionWeight = 1.00;

    //because juice draws on its friends strength
    //THIS SHOULD BE SET ON PLAYER INITIALIZATION
    //and all juice players share this

    @override
    AspectPalette palette = new AspectPalette()
        ..accent = '#E5BB06'
        ..aspect_light = '#FFF775'
        ..aspect_dark = '#E5BB06'
        ..shoe_light = '#508B2D'
        ..shoe_dark = '#316C0D'
        ..cloak_light = '#BF2236'
        ..cloak_mid = '#A81E2F'
        ..cloak_dark = '#961B2B'
        ..shirt_light = '#DD2525'
        ..shirt_dark = '#A8000A'
        ..pants_light = '#B8151F'
        ..pants_dark = '#8C1D1D';


    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Puppers", "Juice"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["CANINE NERD", "ACES HEALER/BREAKER", "HUMAN KEEPER"]);


    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Juicer", "Jumper", "Jeiger"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Juice","Jingle", "Juicey"]);


    @override
    String denizenSongTitle = "Sine Wave"; //a sine wave is a flat sound, good idea tg

    @override
    String denizenSongDesc = " A soft, dragged out note is heard. It is the one Purity plays to make everything the same. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. ";

    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Purity']);

    @override
    List<String> symbolicMcguffins = ["purity", "sameness", "flatness", "unity", "stability", "plainness"];
    @override
    List<String> physicalMcguffins = ["apple", "prune", "grape", "lemon", "orange", "plum", "cherry", "mango", "pear"];

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Apple Juice Bottle",<ItemTrait>[ItemTraitFactory.EDIBLE, ItemTraitFactory.ASPECTAL,ItemTraitFactory.MAGICAL, ItemTraitFactory.REAL],abDesc:"It's probably science powered.",shogunDesc: "Shitty Wizard Pencil"));
    }

    @override
    bool isThisMe(Aspect other) {
        //don't call isThisMe on subasepct cuz you'll risk an infinite loop if subaspect is also something weird
        if(subAspects == null) {
            return other == this;
        }
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
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.SANITY, 2.0, true),
        new AssociatedStat(Stats.MAX_LUCK, 1.0, true),
        new AssociatedStatRandom(Stats.pickable, -2.0, true)
    ]);

    Juice(int id) :super(id, "Juice", isInternal: true); //secret

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.hope(s, p);
    }


    //tg wrote this
    @override
    void initializeThemes() {

        addTheme(new Theme(<String>["Juice"])
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.NOTHINGSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.NOTHINGFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CONFUSINGFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SILENCE, Feature.LOW)
            ..addFeature(FeatureFactory.ECHOSOUND, Feature.HIGH)

            ..addFeature(new DenizenQuestChain("Understand This Stupid Power.", [
                new Quest("The ${Quest.PLAYER1} can hear some voice inside their head speaking to them. It tells them that they're very important and will do something that saves their session. Yeah right."),
                new Quest("The ${Quest.PLAYER1} is trying to understand what this Juice power is anyway. So far it doesn't seem to do much of anything. It just sticks to stuff and eventually dissapates. What gives? How come everyone else gets cool powers? The voice inside the ${Quest.PLAYER1}'s head just tells them that it's a necessary sacrifice."),
                new Quest("The ${Quest.PLAYER1} is led by the voice inside their head to a chamber on the far side of their land. A Denizen was probably supposed to be here. Now, there is only a deep pool of fruit juice. The ${Quest.PLAYER1} sticks their hand into it. The tiniest sliver of power travels up it into their body.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.MEDIUM)
            ,  Theme.HIGH);
    }

  @override
  void setSubAspectsFromPlayer(Player player) {
      super.setSubAspectsFromPlayer(player);

      subAspects = new List<Aspect>.from(player.session.aspectsIncluded());

  }
}