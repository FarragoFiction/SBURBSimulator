import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Fate extends Aspect{

  @override
  AspectPalette palette = new AspectPalette()
    ..accent = "#f0b000"//
    ..aspect_light = '#ffd966'//
    ..aspect_dark = '#f0ca59'//
    ..shoe_light = '#ffff00'
    ..shoe_dark = '#8f8f00'
    ..cloak_light = '#92c27c'//
    ..cloak_mid = '#83b36d'//
    ..cloak_dark = '#74a35f'//
    ..shirt_light = '#39751d'//
    ..shirt_dark = '#2a630e'//
    ..pants_light = '#bd8e00'//
    ..pants_dark = '#ad7c00';//

//todo make these fellas do stuff.
  Fate(int id) :super(id, "Fate", isCanon: true);
}