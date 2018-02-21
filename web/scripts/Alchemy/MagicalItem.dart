import "Item.dart";
import "../SBURBSim.dart";

//rings and shit.
class MagicalItem extends Item with StatOwner {

    bool ring = false;
    bool scepter = false;

    MagicalItem.withoutOptionalParams(String baseName,List<ItemTrait> traitsList):super.withoutOptionalParams(baseName, traitsList);


  @override
  StatHolder createHolder() {
      return new MagicalItemStatHolder<Item>(this);
  }
}