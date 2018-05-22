import "../../../SBURBSim.dart";
import 'dart:html';
/*
much like target conditions decide WHO a scene should effect
action effects decide what happens when a scene triggers.
 */
abstract class ActionEffect {
    SerializableScene scene;
    static String IMPORTANTWORD = "importantWord";

    String name = "Generic Effect";
    String importantWord;

    ActionEffect(SerializableScene scene);

    void renderForm(Element div);
    void syncToForm();
    void syncFormToMe();
    void copyFromJSON(JSONObject json);
    void applyEffect();
    ActionEffect makeNewOfSameType();


    JSONObject toJSON() {
        JSONObject json = new JSONObject();
        json[IMPORTANTWORD] = importantWord;
        json["name"] = name;
        return json;
    }
}


//lands don't have stats and shit
abstract class EffectLand extends ActionEffect {
  EffectLand(SerializableScene scene) : super(scene);

  static List<EffectLand> listPossibleEffects(SerializableScene scene) {
      List<EffectLand> ret = new List<EffectLand>();
      //ret.add(new InstaKill(scene));
      return ret;
  }

  //need to figure out what type of trigger condition it is.
  static ActionEffect fromJSON(JSONObject json, SerializableScene scene) {
      String name = json["name"];
      List<EffectLand> allConditions = listPossibleEffects(scene);
      for(ActionEffect tc in allConditions) {
          if(tc.name == name) {
              ActionEffect ret = tc.makeNewOfSameType();
              ret.copyFromJSON(json);
              ret.scene = scene;
              return ret;
          }
      }
  }


  static SelectElement drawSelectActionEffects(Element div, SerializableScene owner, Element triggersSection) {
      DivElement container = new DivElement();

      triggersSection.setInnerHtml("<h3>Land Effects:</h3>Effects Applied In Order<br>");
      div.append(container);
      List<ActionEffect> effects;
      effects = EffectLand.listPossibleEffects(owner);
      SelectElement select = new SelectElement();
      for(EffectLand sample in effects) {
          OptionElement o = new OptionElement();
          o.value = sample.name;
          o.text = sample.name;
          select.append(o);
      }

      ButtonElement button = new ButtonElement();
      button.text = "Add Land Effect";
      button.onClick.listen((e) {
          String type = select.options[select.selectedIndex].value;
          for(ActionEffect tc in effects) {
              if(tc.name == type) {
                  ActionEffect newCondition = tc.makeNewOfSameType();
                  newCondition.scene = owner;
                  owner.effectsForLands.add(newCondition);
                  print("adding new condition to $owner");
                  //bigBad.triggerConditions.add(newCondition);
                  newCondition.renderForm(triggersSection);
              }
          }
      });

      container.append(select);
      container.append(button);

      //render the ones the big bad starts with
      List<ActionEffect> all;
      all = owner.effectsForLands;

      for (ActionEffect s in all) {
          s.renderForm(triggersSection);
      }
      return select;
  }


  @override
  void applyEffect() {
        List<Land> targets = scene.finalLandTargets;
        effectLands(targets);
  }

  void effectLands(List<Land> lands);


}

abstract class EffectEntity extends ActionEffect {
  EffectEntity(SerializableScene scene) : super(scene);


  static List<EffectEntity> listPossibleEffects(SerializableScene scene) {
      List<EffectEntity> ret = new List<EffectEntity>();
      ret.add(new InstaKill(scene));
      return ret;
  }


  //need to figure out what type of trigger condition it is.
  static ActionEffect fromJSON(JSONObject json, SerializableScene scene) {
      String name = json["name"];
      List<EffectEntity> allConditions = listPossibleEffects(scene);
      for(ActionEffect tc in allConditions) {
          if(tc.name == name) {
              ActionEffect ret = tc.makeNewOfSameType();
              ret.copyFromJSON(json);
              ret.scene = scene;
              return ret;
          }
      }
  }


  static SelectElement drawSelectActionEffects(Element div, SerializableScene owner, Element triggersSection) {
      DivElement container = new DivElement();

      triggersSection.setInnerHtml("<h3>Entity Effects:</h3>Effects Applied In Order.<br>");
      div.append(container);
      List<ActionEffect> effects;
      effects = EffectEntity.listPossibleEffects(owner);
      SelectElement select = new SelectElement();
      for(EffectEntity sample in effects) {
          OptionElement o = new OptionElement();
          o.value = sample.name;
          o.text = sample.name;
          select.append(o);
      }

      ButtonElement button = new ButtonElement();
      button.text = "Add Entity Effect";
      button.onClick.listen((e) {
          String type = select.options[select.selectedIndex].value;
          for(ActionEffect tc in effects) {
              if(tc.name == type) {
                  ActionEffect newCondition = tc.makeNewOfSameType();
                  newCondition.scene = owner;
                  owner.effectsForLiving.add(newCondition);
                  print("adding new condition to $owner");
                  //bigBad.triggerConditions.add(newCondition);
                  newCondition.renderForm(triggersSection);
              }
          }
      });

      container.append(select);
      container.append(button);

      //render the ones the big bad starts with
      List<ActionEffect> all;
      all = owner.effectsForLiving;

      for (ActionEffect s in all) {
          s.renderForm(triggersSection);
      }
      return select;
  }



  @override
  void applyEffect() {
      List<GameEntity> targets = scene.finalLivingTargets;
      effectEntities(targets);
  }

  void effectEntities(List<GameEntity> entities);
}