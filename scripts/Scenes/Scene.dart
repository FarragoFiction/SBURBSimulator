part of SBURBSim;
abstract class Scene {
  Session session;
  bool canRepeat = true;
  //get rid of using playerList. seriously. that was a shitty descion on pastJR's part.
  Scene(this.session); //eventually take in session.
  //each scene should know how to be triggered.
  trigger(var playerList);

  //each scene should handle rendering itself
  renderContent(var playerList);

  //maybe things that used to be global methods in  scene ccontroller can be static methods here
  //don't need a separate thing.  scene_controller's make scenes for session is a natural fit here.
}