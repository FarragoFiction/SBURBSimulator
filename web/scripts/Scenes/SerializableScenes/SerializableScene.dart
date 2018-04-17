import "../../SBURBSim.dart";
import 'dart:html';

/**
 * Serializable Scenes are similar to Life Sim.
 *
 * Each sub class of this is a different ACTION (destroy, corrupt, etc).
 *
 * ALL Serializable Scenes have a FLAVOR TEXT section. Subclasses can replace the default
 * text, but it's recomended that instances of them set their own.
 *
 * sub classes define what valid targets are for them
 * if a sub class overrides the trigger, it should be to make sure the ACTION on a TARGET
 * is actually possible (i.e. there are any carapaces living remainging)
 */
class  SerializableScene extends Scene {

    //things that can be replaced
    static String BIGBADNAME = BigBad.BIGBADNAME;
    static String TARGET = "TARGET";

    //what do you try to target, used for drop down
    static String TARGETPLAYERS = "Players";
    static String TARGETCARAPACES = "Carapaces";
    static String TARGETDENIZENS = "Denizens";
    static String TARGETLANDS = "Lands";
    static String TARGETMOONS = "Moons";
    static String TARGETCONSORTS = "Consorts";
    static String TARGETGHOSTS = "Ghosts";
    static String TARGETDEADPLAYERS = "Dead Players";
    static String TARGETDEADCARAPACES = "Dead Carapaces";
    static String TARGETROBOTS = "Robots";
    static String TARGETDREAMSELVES = "Dream Selves";
    static String TARGETBIGBADS = "Big Bads";
    static String TARGETGODS = "Gods";
    static String TARGETMORTALS = "Mortals";



    //subclasses can override this to have different valid targets
    //this builds the drop down for the forms
    List<String> get validTargets => <String>[TARGETPLAYERS, TARGETGODS, TARGETMORTALS,TARGETCARAPACES, TARGETDENIZENS, TARGETLANDS, TARGETMOONS, TARGETBIGBADS,TARGETCONSORTS, TARGETGHOSTS, TARGETROBOTS, TARGETDREAMSELVES, TARGETDEADPLAYERS, TARGETDEADCARAPACES];

    //higher = better chance of triggering
    double triggerChance = 0.5;

    //flavor text will not influence the actual actions going on, but will change how it is narratively
  List<String> flavorText = <String>["$BIGBADNAME does a thing to $TARGET in the first flavor","$BIGBADNAME does a thing to $TARGET in the second flavor","$BIGBADNAME does a thing to $TARGET in the third flavor"];
  GameEntity livingTarget;
  //can include moons or the battlefield
  Land landTarget;

  //player, land, carapace, etc.
  String targetType;

  SerializableScene(Session session) : super(session);

  @override
  void renderContent(Element div) {
      String displayText = rand.pickFrom(flavorText);
      displayText =   displayText.replaceAll("$BIGBADNAME", "${gameEntity.htmlTitle()}");
      //if i some how have both, living target will be the one i pick.
      if(livingTarget != null) displayText =   displayText.replaceAll("$TARGET", "${livingTarget.htmlTitle()}");
      if(landTarget != null) displayText =   displayText.replaceAll("$TARGET", "${landTarget.name}");

      DivElement content = new DivElement();
      div.append(content);
      content.setInnerHtml(displayText);
      //ANY SUB CLASSES ARE RESPONSIBLE FOR RENDERING CANVAS SHIT HERE, SO THEY CALL SUPER, THEN DO CANVAS
  }

  void pickTarget() {
      throw("TODO: map string target to a thing i'm looking for.");
  }

  @override
  bool trigger(List<Player> playerList) {
      //VERY simple triggers for these things, what matters more is the order the scenes are in
      //and what targets it's picking (only won't trigger if it can't find a target

      livingTarget = null;
      landTarget = null;
      pickTarget();

      //can't go if there is no target
      if(livingTarget == null && landTarget == null) return false;
    return session.rand.nextDouble() < triggerChance;
  }
}