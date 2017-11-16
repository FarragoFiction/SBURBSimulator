import "dart:html";
import "../SBURBSim.dart";


class Gristmas extends Scene {
    int expectedAverageAlchemyValue = 75;
    Player player;
  Gristmas(Session session) : super(session);
    /*TODO  ((rambling brainstorming for how i wanna do shit bsed on RS convos

        Okay, I'm nearly certain that ITEMS should know how combine with other items, not this scene.
         I want to be able to do alchemy even out of the scene proper. Probably ?

         What IS an alchemy scene? It's a scene where you combine items with other items and then stick those items into your specibus to upgrade it.

         Only one person can do it per round , person with greatest amount of items.  \
         (I'm going to assume alchemizing x and y consumes Y or syladex will get p full)

         Okay. What triggers an alchemy scene? Having items in your syladdex, for one. Having more room in your specibus to upgrade it for two.
         After that, whoever has highest alchemy gets first dibs?


         they check their syladex and see if they have anything good. if so, they go. if not, they don't.
         "good" is defined as any single item having a total tier more than their current specibus.

         Alright, I wanna test these scenes out before I implement item combining, see if the balance works
          (i.e. how much alchemy happens in an average session)

          What other things do I need to remember? If your alchemy is higher than average, be better at alchemy. What does this mean?

          Well, regardless of alchemy stat, some classes/aspects are better at it than others. This is the equivalent of a life scene or whatever for
          certain aspects, so they should get something special.

          If your aspect boosts alchemy, then the number of times you can do an alchemy scene is modified by that boost.
          Default is say, 3. Space has a +2 to alchemy, so they can upgrade their specibus 2 extra times.
          Oh my fuck why is there no aspects with NEGATIVE to alchemy, but fucking THREE with +2? this is bullshit. dream needs +3 at least.
          maybe mind can have a negative to alchemy? too many choices , we get overwhelmed?

          okay what else? am i missing anything? doop doop....

          So, what's the use case here.

          Alchemy scene checks if it's triggered.  It asks each player if they have any items in their specibus, and if their specibus
          can be improved.


          Todo:
          *  Add "number times upgraded" stat to items.
          *  Add "Max upgrades" stat to items. Default is 3.  Player can modify this.
          *     * Make syladex half private, so you can't add things to it without calling a method.
          * Add AND and OR (and maybe XOR) functions to items.
          *    * AND gives the item EVERYTHING the other item has. (possibly half of these, for balance)
          *    * OR gives the item the function of the original OR the appearance, and the opposite from the new one.
          *    XOR does an AND, then removes everything from the item that both items have in common.
          *Render Content shows player and alchemiter (eventually items, but nto pre rendering update) and has text about what was made and the procedural description.
     */

  @override
  void renderContent(Element div) {
    // TODO: implement renderContent
  }

  @override
  bool trigger(List<Player> playerList) {
    // TODO: implement trigger
  }
}