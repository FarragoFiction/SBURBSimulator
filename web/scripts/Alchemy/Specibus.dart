import "../SBURBSim.dart";

class Specibus {
    String baseName;
    //TODO have a list of function traits and appearance traits (are appearance traits just kind?).
    //TODO  have a list of components that make this up. (keep track of and vs or?)
    //TODO your specibus can be 2x or 1/2 x kind. unlucky event where it breaks so 1/2 kind

    String get name => "${baseName}kind";

    Specibus(this.baseName);

}

class SpecibusFactory {
    static List<Specibus> _specibi = new List<Specibus>();

    static void init() {
        _specibi.clear();
        _specibi.add(new Specibus("Hammer"));
        _specibi.add(new Specibus("Rifle"));
        _specibi.add(new Specibus("Pistol"));
        _specibi.add(new Specibus("Blade"));
        _specibi.add(new Specibus("Dagger"));
        _specibi.add(new Specibus("Fancysanta"));
        _specibi.add(new Specibus("Fist"));
    }

    static Specibus getRandomSpecibus(Random rand) {
        return rand.pickFrom(_specibi);
    }
}