part of SBURBSim;
abstract class Scene {
  //Session session;
  Scene(); //eventually take in session.
  //each scene should know how to be triggered.
  trigger();

  //each scene should handle rendering itself
  renderContent();
}