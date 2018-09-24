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
    Session currentSessionForErrors;
    int maxTicks = 50;
    int maxScenes = 140;
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




    void scratchEasterEggCallBack(Session s) {
        //initializePlayers(s.players, s); //will take care of overriding players if need be.


        if (s.stats.ectoBiologyStarted) { //players are reset except for haivng an ectobiological source
            setEctobiologicalSource(s.players, s.session_id);
        }
        s.switchPlayersForScratch();

        String scratch = "The session has been scratched. The " + getPlayersTitlesBasic(getGuardiansForPlayers(s.players)) + " will now be the beloved guardians.";
        scratch += " Their former guardians, the " + getPlayersTitlesBasic(s.players) + " will now be the players.";
        scratch += " The new players will be given stat boosts to give them a better chance than the previous generation.";

        Player suddenDeath = findAspectPlayer(raggedPlayers, Aspects.LIFE);
        if (suddenDeath == null) suddenDeath = findAspectPlayer(raggedPlayers, Aspects.DOOM);

        //NOT over time. literally sudden death. thanks meenah!
        List<Player> livingRagged = findLiving(raggedPlayers);
        if (suddenDeath != null && !suddenDeath.dead) {
            //;
            for (num i = 0; i < livingRagged.length; i++) {
                scratch += livingRagged[i].makeDead("right as the scratch happened", livingRagged[i]);
            }
            scratch += " It...appears that the " + suddenDeath.htmlTitleBasic() + " managed to figure out that killing everyone at the last minute would allow them to live on in the afterlife between sessions. They may be available as guides for the players. ";
        }
        if (s.players.length != numPlayersPreScratch) {
            scratch += " You are quite sure that players not native to this session have never been here at all. Quite frankly, you find the notion absurd. ";
            //;
        }
        scratch += " What will happen?";
        // //;

        setHtml(SimController.instance.storyElement, scratch);
        if (!doNotRender) window.scrollTo(0, 0);

        List<Player> guardians = raggedPlayers; //if i use guardians, they will be all fresh and squeaky. want the former players.

        Element guardianDiv = s.newScene("???");
        String guardianID = "${guardianDiv.id}_guardians";
        num ch = canvasHeight;
        if (guardians.length > 6) {
            ch = canvasHeight * 1.5; //a little bigger than two rows, cause time clones
        }

        CanvasElement canvasDiv = new CanvasElement(width: canvasWidth, height: canvasHeight);
        guardianDiv.append(canvasDiv);

        Drawing.poseAsATeam(canvasDiv, guardians); //everybody, even corpses, pose as a team.


        Element playerDiv = s.newScene("???");
        String playerID = "${playerDiv.id}_players";
        ch = canvasHeight;
        if (s.players.length > 6) {
            ch = canvasHeight * 1.5; //a little bigger than two rows, cause time clones
        }
        canvasDiv = new CanvasElement(width: canvasWidth, height: canvasHeight);
        playerDiv.append(canvasDiv);


        //need to render self for caching to work for this
        //for (int i = 0; i < curSessionGlobalVar.players.length; i++) {
        //curSessionGlobalVar.players[i].renderSelf("scratchCallBack");
        // }
        Drawing.poseAsATeam(canvasDiv, s.players); //everybody, even corpses, pose as a team.
        if(s.mutator.spaceField) s.mutator.scratchedCombo(s, raggedPlayers);
        s.intro();
    }


    void recoverFromCorruption(Session s) {
        if(s != null) s.mutator.renderEndButtons(SimController.instance.storyElement, s);
        if(s != null) s.stats.doomedTimeline = true; //TODO do i really need this, but the sim sometimes tries to keep running after grim crashes
        //
    }


    void renderScratchButton(Session session) {
        Player timePlayer = findAspectPlayer(session.players, Aspects.TIME);
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
                    querySelector("#scratchButton").onClick.listen((Event e) => scratchConfirm(session));
                    renderAfterlifeURL(session);
                }
            } else {
                //
                appendHtml(SimController.instance.storyElement, "<br>This session is already scratched. No further scratches available.");
                renderAfterlifeURL(session);
            }
        } else {
            //
        }
    }

    void scratchConfirm(Session session) {
        bool scratchConfirmed = window.confirm("This session is doomed. Scratching this session will erase it. A new session will be generated, but you will no longer be able to view this session. Is this okay?");
        if (scratchConfirmed) {
            session.scratch();
        }
    }



    void shareableURL() {
        String params = window.location.href.substring(window.location.href.indexOf("?") + 1);
        if (params == window.location.href) params = "";
        String str = '<div class = "links"><a href = "index2.html?seed=$initial_seed&$params">Shareable URL </a> &nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp <a href = "character_creator.html?seed$initial_seed&$params" target="_blank">Replay Session  </a> &nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp<a href = "index2.html">Random Session URL </a> </div>';
        setHtml(querySelector("#seedText"), str);

        SimController.instance.storyElement.appendHtml("Session: $initial_seed", treeSanitizer: NodeTreeSanitizer.trusted);
    }


    void gatherStats(Session session) {
        if (gatherStatData) {
            statData.sample(session);
        }
    }

    void initGatherStats() {
        if (gatherStatData) {
            statData.resetTurns();
        }
    }
}