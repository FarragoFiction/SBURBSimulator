import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Flow extends Aspect{

  @override
  AspectPalette palette = new AspectPalette()
    ..accent = "#ff9933"
    ..aspect_light = '#ffffff'
    ..aspect_dark = '#999999'
    ..shoe_light = '#ffff00'
    ..shoe_dark = '#8f8f00'
    ..cloak_light = '#d1e0e3'
    ..cloak_mid = '#c5d1d4'
    ..cloak_dark = '#b7c2c4'
    ..shirt_light = '#00ffff'
    ..shirt_dark = '#009999'
    ..pants_light = '#b5b5b5'
    ..pants_dark = '#858585';

//todo make these fellas do stuff.
  Flow(int id) :super(id, "Flow", isCanon: false);
}