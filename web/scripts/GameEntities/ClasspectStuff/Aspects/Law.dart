import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Law extends Aspect{

  @override
  AspectPalette palette = new AspectPalette()
    ..accent = "#c42eff"//
    ..aspect_light = 'a703ff'//
    ..aspect_dark = '#9800f0'//
    ..shoe_light = '#fcf9bd'//
    ..shoe_dark = '#e0d29e'//
    ..cloak_light = '#9900ff'//
    ..cloak_mid = '#8800f0'//
    ..cloak_dark = '#7800e0'//
    ..shirt_light = '#b3a7d4'//
    ..shirt_dark = '#a599c4'//
    ..pants_light = '#a64e78'//
    ..pants_dark = '#963f66';//

//todo make these fellas do stuff.
  Law(int id) :super(id, "Law", isCanon: false);
}