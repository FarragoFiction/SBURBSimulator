import "../../../SBURBSim.dart";
import 'dart:html';

//todo use ItmeTraitTriggerCondition as a guide
class TargetHasItemWithTrait extends TargetConditionLiving {

    @override
    String name = "hasItemWithTrait";

    TargetHasItemWithTrait(SerializableScene scene) : super(scene);


    @override
    void copyFromJSON(JSONObject json) {
        // TODO: implement copyFromJSON
    }

    @override
    TargetCondition makeNewOfSameType() {
        // TODO: implement makeNewOfSameType
    }

    @override
    void renderForm(Element div) {
        // TODO: implement renderForm
    }

    @override
    void syncFormToMe() {
        // TODO: implement syncFormToMe
    }

    @override
    void syncToForm() {
        // TODO: implement syncToForm
    }

    @override
    List<GameEntity> filter(List<GameEntity> list) {
        // TODO: implement filter
    }
}