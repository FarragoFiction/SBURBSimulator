import "Item.dart";
import "../SBURBSim.dart";

//rings and shit.
class MagicalItem extends Item with StatOwner {
    @override
    bool isCopy = false;
    //TODO: FIGURE OUT HOW MAGIC ITEMS EFFECT THEIR OWNERS
    //like, rings and scepters should only effect carapaces besides enabling the reckoning.

    //it's what makes them magical in addition to direct stat boosts.
    List<Fraymotif> fraymotifs = <Fraymotif>[];

    void resetFraymotifs() {
        for (num i = 0; i < this.fraymotifs.length; i++) {
            this.fraymotifs[i].usable = true;
        }
    }

    void addPrototyping(GameEntity object) {
        //session.logger.info("adding prototyping with fraymotifs ${object.fraymotifs} to ${this.fraymotifs} ");
        this.fraymotifs.addAll(object.fraymotifs);
        if (object.fraymotifs.isEmpty) {
            Fraymotif f = new Fraymotif("${object.name}Sprite Beam!", 1);
            f.effects.add(new FraymotifEffect(Stats.POWER, 2, true)); //do damage
            f.effects.add(new FraymotifEffect(Stats.HEALTH, 1, true)); //heal
            f.desc = " An appropriately themed beam of light damages enemies and heals allies. ";
            this.fraymotifs.add(f);
        }

        for (Stat key in object.stats) {
            addStat(key, object.stats.getBase(key)); //add your stats to my stas.
        }
    }


    @override
    String get fullNameWithUpgrade {
        return "${fullName} ${fraymotifs.length} spells";
    }

    //magical items can die, if they do so, no longer work and should be nulled out of their owners
    bool dead = false;

    MagicalItem.withoutOptionalParams(String baseName,List<ItemTrait> traitsList):super.withoutOptionalParams(baseName, traitsList){
        initStatHolder();
    }


  @override
  StatHolder createHolder() {
      return new MagicalItemStatHolder<MagicalItem>(this);
  }
}

class Ring extends MagicalItem {
    Ring.withoutOptionalParams(String baseName,List<ItemTrait> traitsList):super.withoutOptionalParams(baseName, traitsList);

}


class Scepter extends MagicalItem {
    Scepter.withoutOptionalParams(String baseName,List<ItemTrait> traitsList):super.withoutOptionalParams(baseName, traitsList);

}
