part of SBURBSim;
/*
  Each way the sim is able to be used inherits from this abstract class.

  Things that inherit from this are set to a static singleton var here.

  The SBURBSim library knows about this, and ONLY this, while the controllers inherit from this and control running the sim.

 */

//StoryController inherits from this
//ABController inherits from Story Controller and only changes what she must.
//care about other controllers later.
abstract class SimController {
  static SimController instance;
  //TODO write controller that sets whatever you just made to singleton instance var.
  SimController() {
      SimController.instance = this;
  }

  void startSession();
  void shareableURL();
  void reinit();
  void easterEggCallBack(); //TODO how do callbacks work in Dart?
  void easterEggCallBackRestart();
  void checkSGRUB();
  void getSessionType(); //TODO probably could live in session.
  void renderScratchButton(Session session); //Aftermath will call this.
  void restartSession();
  void tick();
  void reckoning();
  void renderAfterlifeURL();
  void processCombinedSession();
  void intro();
  void callNextIntroWithDelay();
  void recoverFromCorruption(); //AB will run next session, newspost will stop trying to get sessions, etc.
}