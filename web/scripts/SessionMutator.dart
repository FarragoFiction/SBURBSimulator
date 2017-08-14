
import "session.dart";
//this should handle the most severe of the Gnosis Tiers: The Waste Tier
//these are permanent modifications to sessions and their behavior
//while the lesser shit that are one off things will be in the GainGnosis scenes themselves. (such as writing faqs)
class SessionMutator {

  //TODO have variables that session can query to see if it needs to have alt behavior

  //TODO have methods that are alt behavior for a variety of methods. like makeDead

  //the aspect clsses handle calling these.  these are called when waste tier
  //is reached for a specific aspect

  void blood(Session s) {
      /*
          TODO:
          * all players have trickster levels of sanity
          * If scratched, your guardians stats are added to yours.
          *  All stats are averaged, then given back to party.
          *  Session Mutator: pale  quadrant chats happen constantly, even if not quadranted.
          *  once npc update, all npcs are set to "ally" state, even things that are not normally possible.
          *  All players have candy red blood.
          *  new players are allowed to enter session

       */
  }

  void mind(Session s) {
    /*
      TODO:
        * Yellow Yard like thing prints out immediatly upon reaching this tier. Player shown, not me.
        * TODO: what else fits here, don't want it to just literally be a yellow yard, these wastes suck compared to me
             *so instead of restraint, they let ANYTHING happen.  but still Observer choice?
             *  or are some things observer choice and some things the Waste chooses?
             *  peasant rail gun
             *  kill all denizens pre-entry
             *  kill all npcs pre-entry
             *  kill entire party pre-entry
             *  god tier entire party pre-entry
             *  prototype all players pre-entry
             *  shoosh pap all murderers pre-entry
             *  etc
     */
  }

  void rage(Session s) {
    /*
        TODO:
        All players are murder mode, all players are god tier, all players hate each other.
        One or more creators or wranglers are spawned in game, and they hate US most of all.

        Session paused for Observer to make a character.  Observer is also hated most.

        if observer dies.  Players leave session and it just ends.

        Everyone can do shenanigans.  pen15 activated at random.

        if KR is killed images = pumpkin

        if kr is killed, everyone is robots

        if JR is killed, session crash

        if abj is killed, all players die

        kill brope, all but one player dies

        kill PL lands get rerolled/fucked up eventually
     */
  }

  //lol, can't just call it void cuz protected word
  void voidStuff(Session s) {
    /*
        TODO:
          * reroll seed.  rerun session, but NEVER print anything, not even in the void.
          * print ending
          * if Yellow Yard happens, even the choices are blanked (but you can still pick them.)
          *

       */
  }

  void time(Session s) {
      /*
          TODO:
          * Timeline replay.  Redo session until you get it RIGHT. Everyone lives, full frog.
          *   Create players, then change seed. shuffle player order, etc.
          *   line about them killing their past self and replacing them. so time player might start god tier and shit.
          *   "go" button similar to scratch before resetting.

       */
  }

  void heart (Session s) {
      /*
        TODO
         * everyones classpects are randomized mid sim
         * everyones living dream selves are separate players with old claspects
         * more quadrant chat even if no quadrant?
       */
  }

  void breath(Session s) {
      /*
        TOOD:
        * available players is always all players.
        * all quest chains are active (npc shit)

       */
  }
}