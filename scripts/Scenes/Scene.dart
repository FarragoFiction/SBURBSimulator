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
}