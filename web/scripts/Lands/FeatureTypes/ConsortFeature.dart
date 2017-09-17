import "../Feature.dart";
import "../../GameEntities/NPCS.dart";
import "../../SessionEngine/session.dart";

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
}