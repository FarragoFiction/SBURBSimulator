part of SBURBSim;
abstract class Scene {
  Session session;
  bool canRepeat = true;
  List<Player> playerList = new List<Player>(); //eventually get rid of this, but not today
  Scene(this.session); //eventually take in session.


  //each scene should know how to be triggered.
  bool trigger(List<Player> playerList);

  //each scene should handle rendering itself, whether via text or canvas
  void renderContent(var div);


  //maybe things that used to be global methods in  scene ccontroller can be static methods here
  //don't need a separate thing.  scene_controller's make scenes for session is a natural fit here.
}