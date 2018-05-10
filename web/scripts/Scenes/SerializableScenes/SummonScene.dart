
import "../../SBURBSim.dart";
import 'dart:html';

/*
    Effects are restricted to always have at least a  Activate Entity effect
 */
class SummonScene extends SerializableScene {
    @override
    String name = "Summon Scene";
  SummonScene(Session session) : super(session);


    @override
    void renderContent(Element div) {
        DivElement intro = new DivElement();
        bool debugMode = getParameterByName("debug") == "fuckYes";
        String debug = "";
        if(debugMode) {
            debug = " (Triggers are: $triggerConditionsLand and $triggerConditionsLiving) Targets are: $landTargets nad $livingTargets. Remaining BigBads are ${session.bigBads}";
        }
        intro.setInnerHtml("<h1>All tremble at the arrival of ${gameEntity.name}. $debug <br>");
        ImageElement portrait = new ImageElement(src: "images/BigBadCards/${gameEntity.name.toLowerCase().replaceAll(" ", "_")}.png");
        portrait.onError.listen((e) {
            portrait.src = "images/BigBadCards/default.gif";
        });
        intro.append(portrait);
        div.append(intro);
        super.renderContent(div);

    }

  @override
  void doAction() {
      session.stats.bigBadActive = true;
      session.logger.info("TEST BIG BAD: is this it? the first big bad has spawned? they probably don't do text replacement tho");
      gameEntity.active = true;
  }
}