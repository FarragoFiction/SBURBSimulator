import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Flow extends Aspect{

  @override
  AspectPalette palette = new AspectPalette()
    ..accent = "#ee0000"//
    ..aspect_light = '#ff0000'//
    ..aspect_dark = '#d10000'//
    ..shoe_light = '#00ffff'//
    ..shoe_dark = '#00d1d1'//
    ..cloak_light = '#e68f39'//
    ..cloak_mid = '#d67e2b'//
    ..cloak_dark = '#c46b1d'//
    ..shirt_light = '#e65c00'//
    ..shirt_dark = '#b82e00'//
    ..pants_light = '#ffd966'//
    ..pants_dark = '#d1ab3b';//

//todo make these fellas do stuff.
  Flow(int id) :super(id, "Flow", isCanon: false);
}