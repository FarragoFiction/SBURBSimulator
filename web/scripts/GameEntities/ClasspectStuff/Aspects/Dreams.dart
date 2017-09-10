import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Dreams extends Aspect {
  @override
  AspectPalette palette = new AspectPalette()
    ..accent = 'c987e6'
    ..aspect_light = 'c987e6'
    ..aspect_dark = 'ad769a'
    ..shoe_light = 'c987e6'
    ..shoe_dark = '8f577b'
    ..cloak_light = '9331bd'
    ..cloak_mid = '693773'
    ..cloak_dark = '492152'
    ..shirt_light = 'faf7bb'
    ..shirt_dark = 'ded09e'
    ..pants_light = 'bdb96a'
    ..pants_dark = 'ab9a55';

  Dreams(int id) :super(id, "Dreams", isCanon: true);

  @override
  String activateCataclysm(Session s, Player p) {
    return s.mutator.light(s, p);
  }
}