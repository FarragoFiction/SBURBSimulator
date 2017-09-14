import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Stars extends Aspect{

  @override
  AspectPalette palette = new AspectPalette()
    ..accent = "#ffff33"//
    ..aspect_light = '#ffff00'//
    ..aspect_dark = '#d1d100'//
    ..shoe_light = '#00ffff'//
    ..shoe_dark = '#009999'//
    ..cloak_light = '#0c5494'//
    ..cloak_mid = '#004785'//
    ..cloak_dark = '#003b75'//
    ..shirt_light = '#20124d'//
    ..shirt_dark = '#11033d'//
    ..pants_light = '#0c323b'//
    ..pants_dark = '#00232b';//

//todo make these fellas do stuff.
  Stars(int id) :super(id, "Stars", isCanon: true);
}