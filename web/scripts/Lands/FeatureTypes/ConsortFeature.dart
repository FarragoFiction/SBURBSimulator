import "../Feature.dart";
import "../../GameEntities/NPCS.dart";
import "../../SessionEngine/session.dart";
import "../../SBURBSim.dart";


class ConsortFeature extends Feature {
    /// what are these consorts called?
    String name;
    ///what sound do these consorts make?
    String sound;
    ///TODO eventually have an actual npc object associated here, to generate npc helpers
    ///TODO eventually have like a color for npcs, once we have the rendering engine. maybe the FeatureFactory version of a consort is generic, but when given to a land a random color is rolled.
    ConsortFeature(this.name, this.sound);

    Consort makeConsort(Session s) {
        return new Consort.withSound(name, s, sound);
    }

    //passed in specific can have 'ands' in the middle
     String randomNeutralFlavorText(Random rand, Player p) {
        WeightedList<String> possibilities = new WeightedList<String>();
        possibilities.add("The local ${name}s beging flipping the fuck out. Do they ever stop ${sound}ing?");
        possibilities.add("A local ${name} shows up wearing some bedsheets and  ${sound}ing up a storm. You're not sure you want to know. ");
        possibilities.add("With a loud ${sound.toUpperCase()} a local $name falls over, comically. Adorable.",0.3);
        return rand.pickFrom(possibilities);
    }

}