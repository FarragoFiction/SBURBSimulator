import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Rain extends Aspect {
  @override
  AspectPalette palette = new AspectPalette()
    ..accent = '#00FFFF'
    ..aspect_light = '#00ffff'//
    ..aspect_dark = '#009090'
    ..shoe_light = '#FEFEFE'
    ..shoe_dark = '#707070'
    ..cloak_light = '#0000FF'
    ..cloak_mid = '#0000b3'
    ..cloak_dark = '#000080'
    ..shirt_light = '#9900ff'
    ..shirt_dark = '#5c0099'
    ..pants_light = '#00FF00'
    ..pants_dark = '#008000';

  @override
  //List<String>

  Rain(int id) :super(id, "Rain", isCanon: false);
}