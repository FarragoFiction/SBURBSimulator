import "dart:html";
import '../../GameEntities/Stats/sampler/statsampler.dart';
import "../../SBURBSim.dart";
import "../../navbar.dart";
import "dart:async";
/*
  Each way the sim is able to be used inherits from this abstract class.

  Things that inherit from this are set to a static singleton var here.

  The SBURBSim library knows about this, and ONLY this, while the controllers inherit from this and control running the sim.

 */

//StoryController inherits from this
//ABController inherits from Story Controller and only changes what she must.
//care about other controllers later.
abstract class SimController {
    int maxTicks = 300;
    static bool shogun = false;  //sim goes into shogun mode
    static int spriteTemplateWidth = 400;
    static int spriteTemplateHeight = 300;
    static int echeladderTemplateHeight = 300;
    static int echeladderTemplateWidth = 202;
    static int canvasTemplateHeight = 300;
    static int canvasTemplateWidth = 1000;
    static int rainbowTemplateHeight = 300;
    static int rainbowTemplateWidth = 1;
    static int chatTextTemplateHeight = 239;
    static int chatTextTemplateWidth = 472;
    static int godTierLevelUpTemplateHeight = 572;
    static int godTierLevelUpTemplateWidth = 1000;

    Element storyElement;
    Element voidStory;
    static SimController instance;
    num initial_seed = 0;

    bool gatherStatData = false;
    StatSampler statData;

    SimController() {
        SimController.instance = this;

        if (getParameterByName("gatherStatData") == "true") {
            gatherStatData = true;
            statData = new StatSampler();
            statData.createSaveButton();
        }
        storyElement = querySelector("#story");
    }

    void clearElement(Element element) {
        //element.setInnerHtml("");

        List<dynamic> children = new List<dynamic>.from(element.childNodes);
        children.forEach((e)
        {
            e.remove();
        });
    }


    void checkSGRUB() {
        bool sgrub = true;
        for (num i = 0; i < curSessionGlobalVar.players.length; i++) {
            if (curSessionGlobalVar.players[i].isTroll == false) {
                sgrub = false;
            }
        }
        //can only get here if all are trolls.
        if (sgrub) {
            document.title = "SGRUB Story Generator by jadedResearcher";
        }

        if (getParameterByName("nepeta", null) == ":33") {
            document.title = "NepetaQuest by jadedResearcher";
        }
        if (curSessionGlobalVar.session_id == 33) {
            document.title = "NepetaQuest by jadedResearcher";
            SimController.instance.storyElement.appendHtml(" <a href = 'index2.html?seed=${getRandomSeed()}&nepeta=:33'>The furryocious huntress makes sure to bat at this link to learn a secret!</a>", treeSanitizer: NodeTreeSanitizer.trusted);
        } else if (curSessionGlobalVar.session_id == 420) {
            document.title = "FridgeQuest by jadedResearcher";
            SimController.instance.storyElement.appendHtml(" <a href = 'index2.html?seed=${getRandomSeed()}&honk=:o)'>wHoA. lIkE. wHaT If yOu jUsT...ReAcHeD OuT AnD ToUcHeD ThIs? HoNk!</a>", treeSanitizer: NodeTreeSanitizer.trusted);
        } else if (curSessionGlobalVar.session_id == 88888888) {
            document.title = "SpiderQuuuuuuuuest!!!!!!!! by jadedResearcher";
            SimController.instance.storyElement.appendHtml(" <a href = 'index2.html?seed=${getRandomSeed()}&luck=AAAAAAAALL'>Only the BEST Observers click here!!!!!!!!</a>", treeSanitizer: NodeTreeSanitizer.trusted);
        } else if (curSessionGlobalVar.session_id == 0) {
            document.title = "0_0 by jadedResearcher";
            SimController.instance.storyElement.appendHtml(" <a href = 'index2.html?seed=${getRandomSeed()}&temporal=shenanigans'>Y0ur inevitabile clicking here will briefly masquerade as free will, and I'm 0kay with it.</a>");
        } else if (curSessionGlobalVar.session_id == 413) { //why the hell is this one not triggering?
            "Homestuck Simulator by jadedResearcher";
            SimController.instance.storyElement.appendHtml(" <a href = 'index2.html?seed=${getRandomSeed()}&home=stuck'>A young man stands next to a link. Though it was 13 years ago he was given life, it is only today he will click it.</a>");
        } else if (curSessionGlobalVar.session_id == 111111) { //why the hell is this one not triggering?
            document.title = "Homestuck Simulator by jadedResearcher";
            SimController.instance.storyElement.appendHtml(" <a href = 'index2.html?seed=${getRandomSeed()}&home=stuck'>A young lady stands next to a link. Though it was 16 years ago she was given life, it is only today she will click it.</a>");
        } else if (curSessionGlobalVar.session_id == 613) {
            document.title = "OpenBound Simulator by jadedResearcher";
            SimController.instance.storyElement.appendHtml(" <a href = 'index2.html?seed=${getRandomSeed()}&open=bound'>Rebubble this link?.</a>", treeSanitizer: NodeTreeSanitizer.trusted);
        } else if (curSessionGlobalVar.session_id == 612) {
            document.title = "HiveBent Simulator by jadedResearcher";
            SimController.instance.storyElement.appendHtml(" <a href = 'index2.html?seed=${getRandomSeed()}&hive=bent'>A young troll stands next to a click horizon. Though it was six solar sweeps ago that he was given life, it is only today that he will click it.</a>");
        } else if (curSessionGlobalVar.session_id == 1025) {
            document.title = "Fruity Rumpus Asshole Simulator by jadedResearcher";
            SimController.instance.storyElement.appendHtml(" <a href = 'index2.html?seed=${getRandomSeed()}&rumpus=fruity'>I will have order in this RumpusBlock!!!</a>", treeSanitizer: NodeTreeSanitizer.trusted);
        }
    }







    void recoverFromCorruption() {
        if(curSessionGlobalVar != null) curSessionGlobalVar.mutator.renderEndButtons(SimController.instance.storyElement);
        if(curSessionGlobalVar != null) curSessionGlobalVar.stats.doomedTimeline = true; //TODO do i really need this, but the sim sometimes tries to keep running after grim crashes
        //
    }


    void renderScratchButton(Session session) {
        Player timePlayer = findAspectPlayer(curSessionGlobalVar.players, Aspects.TIME);
        if (timePlayer == null) throw "CAN'T SCRATCH WITHOUT A TIME PLAYER, JACKASS";
        //
        //alert("scratch [possible]");
        //can't scratch if it was a a total party wipe. just a regular doomed timeline.
        List<Player> living = findLiving(session.players);
        if (!living.isEmpty && (session.stats.makeCombinedSession == false && session.stats.hadCombinedSession == false)) {
            //
            //var timePlayer = findAspectPlayer(session.players, "Time");
            if (!session.stats.scratched) {
                //this is apparently spoilery.
                //alert(living.length  + " living players and the " + timePlayer.land + " makes a scratch available!");
                if (session.stats.scratchAvailable) {
                    String html = '<img src="images/Scratch.png" id="scratchButton"><br>Click To Scratch Session?';
                    appendHtml(SimController.instance.storyElement, html);
                    querySelector("#scratchButton").onClick.listen((Event e) => scratchConfirm());
                    renderAfterlifeURL();
                }
            } else {
                //
                appendHtml(SimController.instance.storyElement, "<br>This session is already scratched. No further scratches available.");
                renderAfterlifeURL();
            }
        } else {
            //
        }
    }

    void scratchConfirm() {
        bool scratchConfirmed = window.confirm("This session is doomed. Scratching this session will erase it. A new session will be generated, but you will no longer be able to view this session. Is this okay?");
        if (scratchConfirmed) {
            scratch();
        }
    }



    void shareableURL() {
        String params = window.location.href.substring(window.location.href.indexOf("?") + 1);
        if (params == window.location.href) params = "";
        String str = '<div class = "links"><a href = "index2.html?seed=$initial_seed&$params">Shareable URL </a> &nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp <a href = "character_creator.html?seed$initial_seed&$params" target="_blank">Replay Session  </a> &nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp<a href = "index2.html">Random Session URL </a> </div>';
        setHtml(querySelector("#seedText"), str);

        SimController.instance.storyElement.appendHtml("Session: $initial_seed", treeSanitizer: NodeTreeSanitizer.trusted);
    }


    void gatherStats() {
        if (gatherStatData) {
            statData.sample(curSessionGlobalVar);
        }
    }

    void initGatherStats() {
        if (gatherStatData) {
            statData.resetTurns();
        }
    }
}