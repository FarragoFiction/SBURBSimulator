part of SBURBSim;
abstract class Scene {
  Session session;
  bool canRepeat = true;
  List<Player> playerList = new List<Player>();
  //get rid of using playerList. seriously. that was a shitty descion on pastJR's part.
  Scene(this.session); //eventually take in session.


  //each scene should know how to be triggered.
  bool trigger();

  //each scene should handle rendering itself, whether via text or canvas
  void renderContent(var div);

  //do abstract classes HAVE to be blank, or can i have default methods?
  void setPlayerList() {
    for(Player p in this.session.players) {
      if(p.isInMediumyet()) playerList.add(p);
    }
  }

  //maybe things that used to be global methods in  scene ccontroller can be static methods here
  //don't need a separate thing.  scene_controller's make scenes for session is a natural fit here.
}