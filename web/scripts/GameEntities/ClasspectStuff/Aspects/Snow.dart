import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Snow extends Aspect{

  @override
  double powerBoostMultiplier = 2.0;


  @override
  AspectPalette palette = new AspectPalette()
    ..accent = "#b2e3eb"//
    ..aspect_light = '#ffffff'//
    ..aspect_dark = '#dfdfdf'//
    ..shoe_light = '#00ffff'//
    ..shoe_dark = '#009090'//
    ..cloak_light = '#999999'//
    ..cloak_mid = '#8a8a8a'//
    ..cloak_dark = '#7a7a7a'//
    ..shirt_light = '#d0e2f2'//
    ..shirt_dark = '#c3d4e3'//
    ..pants_light = '#b2e3eb'//
    ..pants_dark = '#a4d4db';//

//todo make these fellas do stuff.
  Snow(int id) :super(id, "Snow", isCanon: true);
}