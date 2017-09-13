import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Rhyme extends Aspect{

  @override
  AspectPalette palette = new AspectPalette()
    ..accent = "#10dede"//
    ..aspect_light = '#00ffff'//
    ..aspect_dark = '#00d1d1'//
    ..shoe_light = '#ff0000'//
    ..shoe_dark = '#d10000'//
    ..cloak_light = '#4985e6'//
    ..cloak_mid = '#3a76d6'//
    ..cloak_dark = '#2d6ac4'//
    ..shirt_light = '#331c73'//
    ..shirt_dark = '#050045'//
    ..pants_light = '#8d7cc2'//
    ..pants_dark = '#7c6db3';//


  Rhyme(int id) :super(id, "Rhyme", isCanon: false);
}