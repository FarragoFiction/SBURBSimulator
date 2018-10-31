
import "../../SBURBSim.dart";
import 'dart:html';

/*
    Effects are restricted to always have at least a  Activate Entity effect
 */
class SummonScene extends SerializableScene {
    @override
    String name = "Summon Scene";
  SummonScene(Session session) : super(session);

    ImportantEvent addImportantEvent(){
        Player current_mvp = findStrongestPlayer(this.session.players);
        return this.session.addImportantEvent(new BigBadEntered(gameEntity,this.session, current_mvp.getStat(Stats.POWER), null));
    }


    @override
    void renderContent(Element div) {
        ImportantEvent alt = addImportantEvent();
        if(alt != null && alt.alternateScene(div)){
            return;
        }
        DivElement intro = new DivElement();
        bool debugMode = getParameterByName("debug") == "fuckYes";
        String debug = "";
        if(debugMode) {
            debug = " (Triggers are: $triggerConditionsLand and $triggerConditionsLiving) Targets are: $landTargets nad $livingTargets. Remaining BigBads are ${session.bigBadsReadOnly}";
        }
        intro.setInnerHtml("<h1>All tremble at the arrival of ${gameEntity.name}. $debug <br>");
        if(!doNotRender) {
            String extension = ".png";
            if(gameEntity.name.contains("Lord English") || gameEntity.name.contains("Hussie")) extension = ".gif";
            ImageElement portrait = new ImageElement(
                src: "images/BigBadCards/${gameEntity.name.toLowerCase()
                    .replaceAll(" ", "_")}_entrance$extension");
            portrait.onError.listen((e) {
                portrait.src = "images/BigBadCards/default.gif";
            });
            intro.append(portrait);
        }
        div.append(intro);
        super.renderContent(div);

    }

  @override
  void doAction() {
        //print("activating $gameEntity");
      session.stats.bigBadActive = true;
      gameEntity.active = true;
  }
}