part of SBURBSim;
//most of these are just so I can say "is this a type of npc" and not any real functionality
//might be the wrong way to do this. can refactor later. they will have more functionality as time goes on, tho.

class NPC extends GameEntity {
  NPC(String name, num id, Session session): super(name, id, session);
}

//carapaces are the only things that can be crowned and have it give anything but fraymotifs.
class Carapace extends NPC {
  Carapace(String name, num id, Session session): super(name, id, session);
}

class Underling extends NPC {
  Underling(String name, num id, Session session): super(name, id, session);
}

//naknaknaknaknaknak my comments are talking to me!
class Consort extends NPC {
  Consort(String name, num id, Session session): super(name, id, session);
}

//denizens are spawned with innate knowledge of a personal fraymotif.
//TODO eventually put this logic here instead of in player, and have mechanism for
//creating a denizen live here in a static method.
class Denizen extends NPC {
  Denizen(String name, num id, Session session): super(name, id, session);
}

class DenizenMinion extends NPC {
  DenizenMinion(String name, num id, Session session): super(name, id, session);
}

