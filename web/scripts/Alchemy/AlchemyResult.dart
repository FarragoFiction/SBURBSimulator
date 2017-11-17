import "Item.dart";
import "Trait.dart";

/*
http://mspaintadventures.wikia.com/wiki/Alchemiter

Appropriately for AND combining, an && alchemy result will often demonstrate the functionality of both components
 – e.g. Dave's iShades can be a phone and a rad pair of shades – while an || alchemy result will typically have the
  functionality of only one of the components, but the form of the other – e.g. the Hammerhead Pogo Ride, which is
   just a pogo that happens to be hammer-shaped.
 */



/*
    Alchemy result takes two items and creates a third based on it's subtype.
    When you call "apply" with a item list (sylladex)
    it will remove the second item, and replace the first items traits with the third ones.

    IF IT CANNOT FIND BOTH ITEMS IN THE LIST, IT DOES NOTHING.

    The natural sorting of AlchemyResults is by the rank of the result item.

    The plan (is to give you a boner (refrance secured)) is to sort the list of alchemy results by rank.
    Then to apply them each in turn. And have the results handle if they are no longer possible since some better
    alchemization was found.

    YES I get that in canon alchemy doesn't use up the items, but I'm doing it for now as a way to keep
    inventories from getting too stupidly cluttered. Might decide that I don't need to do this later, who knows.

    Alchemy results SHOULD NOT be random.

    Alchemy results SHOULD contain a string(s) describing it's effect.

 */

abstract class AlchemyResult {
    //no matter what, it's the first item that gets shit shoved into it and all other items that are removed
    //in sim, assume only two items at a time. but can support anding 3 or more things at a time
    //in a mini game.
    List<Item> items;
    Item result;

    AlchemyResult(List<Item> this.items) {
        combine();
    }

    void combine();

    ///returns a list of all possible alchemy types between these two items.
    static List<AlchemyResult> planAlchemy(List<Item> items) {
        return <AlchemyResult>[new AlchemyResultAND(items), new AlchemyResultOR(items), new AlchemyResultXOR(items)];
    }
}

class AlchemyResultAND extends AlchemyResult {
  AlchemyResultAND(List<Item> items) : super(items);

  ///AND takes both functionality and appearance from both things.
  ///TODO if this is OP (i.e. OR is never selected) then take every other trait from both.
  @override
  void combine() {
      result = items[0].copy();
      //skip first item
      for(int i = 1; i<items.length; i++) {
          Item item = items[i];
          for(ItemTrait t in item.traits) {
            result.traits.add(t); //will handle not allowing duplicates.
          }
      }
  }
}

class AlchemyResultOR extends AlchemyResult {
    AlchemyResultOR(List<Item> items) : super(items);

    ///OR takes  functionality from first and appearance from second. ignores all other items.
    @override
    void combine() {
        result = items[0].copy();
        result.traits.clear();

        for(ItemTrait t in items[0].functionalTraits) {
            result.traits.add(t); //will handle not allowing duplicates.
        }

        for(ItemTrait t in items[0].appearanceTraits) {
            result.traits.add(t); //will handle not allowing duplicates.
        }

    }
}


//spoken only of in legend, but totally fucking theoretically possible
class AlchemyResultXOR extends AlchemyResult {
    AlchemyResultXOR(List<Item> items) : super(items);

    //XOR is where you have traits ONLY if they only show up in one place, not two.
    @override
    void combine() {
        result = items[0].copy();
        result.traits = items[0].traits.difference(items[1].traits);
    }
}