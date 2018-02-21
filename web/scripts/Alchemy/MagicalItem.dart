import "Item.dart";
import "../SBURBSim.dart";

//rings and shit.
class MagicalItem extends Item with StatOwner {
    //TODO: FIGURE OUT HOW MAGIC ITEMS EFFECT THEIR OWNERS
    //like, rings and scepters should only effect carapaces besides enabling the reckoning.

    //it's what makes them magical in addition to direct stat boosts.
    List<Fraymotif> fraymotifs = <Fraymotif>[];

    void resetFraymotifs() {
        for (num i = 0; i < this.fraymotifs.length; i++) {
            this.fraymotifs[i].usable = true;
        }
    }


    //magical items can die, if they do so, no longer work and should be nulled out of their owners
    bool dead = false;

    MagicalItem.withoutOptionalParams(String baseName,List<ItemTrait> traitsList):super.withoutOptionalParams(baseName, traitsList);


  @override
  StatHolder createHolder() {
      return new MagicalItemStatHolder<Item>(this);
  }
}

class Ring extends MagicalItem {
    Ring.withoutOptionalParams(String baseName,List<ItemTrait> traitsList):super.withoutOptionalParams(baseName, traitsList);

}


class Scepter extends MagicalItem {
    Scepter.withoutOptionalParams(String baseName,List<ItemTrait> traitsList):super.withoutOptionalParams(baseName, traitsList);

}
