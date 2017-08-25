import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Spark extends Aspect {

    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#5BCD00"
        ..aspect_light = '#D4FF00'
        ..aspect_dark = '#B6DA00'
        ..shoe_light = '#160400'
        ..shoe_dark = '#090000'
        ..cloak_light = '#005262'
        ..cloak_mid = '#003251'
        ..cloak_dark = '#001A45'
        ..shirt_light = '#029C6F'
        ..shirt_dark = '#008175'
        ..pants_light = '#06948F'
        ..pants_dark = '#004D69';

    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Skeptic","Scripture","Symbol"]);

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat("freeWill", 1, true),
        new AssociatedStat("alchemy", 1, true),
        new AssociatedStatInterests(true, -1),
        new AssociatedStat("sburbLore", 0.25, false)
    ]);

    Spark(int id) :super(id, "Spark", isCanon: true);
}