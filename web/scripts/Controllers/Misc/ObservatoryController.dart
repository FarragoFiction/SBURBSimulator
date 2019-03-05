import "dart:async";
import 'dart:collection';
import 'dart:html';
import 'dart:math' as Math;
import "dart:web_audio";

import '../../Rendering/renderer.dart';
import '../../Rendering/threed/three.dart' as THREE;
import '../../SBURBSim.dart';
import '../../includes/predicates.dart';
import '../../navbar.dart';
import '../../random.dart';

/*
todo:

- move session generation to a queue system which gives delays for the main drawing to go ahead
- placeholders for waiting sessions
- averaging out generation times to give a budget for generation in an attempt to keep stuff smooth
- sorting the generation list in order of relevancy, so using time-averaged direction of motion to inform ordering
- drop sessions outside of scope if they are on the list by the time it's their turn

- make sure that the queue system could use threading later to make it even more streamlined

 */

Future<Null> main() async {
    await globalInit();
    await Renderer.loadThree();
    await THREE.ScriptLoader.particleSystem();
    await Loader.loadManifest();
    loadNavbar();

    ObservatoryViewer observatory = new ObservatoryViewer(1000, 700, eventDelegate: querySelector("#screen_clickzone"));

    int today = ObservatoryViewer._today_session;
    Random rand = new Random();
    querySelector("#random_link")..onClick.listen((Event e){ observatory.goToSeed(rand.nextInt()); });
    querySelector("#today_link")..onClick.listen((Event e){ observatory.goToSeed(today); });
    querySelector("#session_id")..onKeyPress.listen((KeyboardEvent e){ if(e.keyCode == 13) { observatory.readSessionElement(); }});

    Element overcoat_link = querySelector("#overcoat_link");

    overcoat_link..onClick.listen((Event e){
        observatory.goToOvercoat();
    });

    AnchorElement sim_link = querySelector("#sim_link");
    AnchorElement ab_link = querySelector("#ab_link");

    Element speechbubble = querySelector("#speechbubble");
    Element speechbubbletext = querySelector("#speechbubblebody");

    observatory.callback_session = () {
        Session session = observatory.detailSession.session;
        int seed = session.session_id;

        String paramstring = getParamStringMinusParam(<String>["cx","cy","seed"]);
        paramstring = paramstring.isEmpty ? paramstring : "&$paramstring";

        if (session.players.length == 1) {
            sim_link.href = "dead_index.html?seed=$seed$paramstring";
            ab_link.href = "dead_session_finder.html?seed=$seed$paramstring";
        } else {
            sim_link.href = "index2.html?seed=$seed$paramstring";
            ab_link.href = "rare_session_finder.html?seed=$seed$paramstring";
        }
        String comment = processSessionComment(observatory, today);

        if (comment == null || comment.isEmpty) {
            hide(speechbubble);
        } else {
            setHtml(speechbubbletext, comment);
            show(speechbubble);
        }

        if (observatory.overcoat != null) {
            if (observatory.overcoat.active) {
                overcoat_link.text = "Leave the Kyoto Overcoat";

                querySelector("#overcoat_message").style.display = "none";
                querySelector("#overcoat_item").style.display = "list-item";

                querySelector("#speechbubble").classes.add("overcoat");
                querySelector("#pl").style.display = "none";
                querySelector("#shoges").style.display = "block";
            } else {
                overcoat_link.text = "Return to the Kyoto Overcoat";

                querySelector("#speechbubble").classes.remove("overcoat");
                querySelector("#pl").style.display = "block";
                querySelector("#shoges").style.display = "none";
            }
        }
    };

    await observatory.setup(13);

    querySelector("#screen_container")..append(observatory.renderer.domElement);
    querySelector("#screen_container")..append(observatory.landDetails.container);

}

List<Map<int, String>> eggComments = <Map<int,String>>[
    <int,String> { // PL
        413 : "There's something familiar about this one...", // beta + alpha
        612 : "This session seems familiar somehow...", // trolls
        613 : "This session seems familiar somehow...", // dancestors
        1025 : "Wasn't there like, a comic or something about this one?", // beta + alpha + CG,GA,GC,AG
        33 : "AB isn't going to be happy about this...", // THAT DAMN CAT
        111111 : "There's something familiar about this one...", // alpha + beta
        88888888 : "So many irons in the fire!<br><br>... and so many 8s, holy shit", // like, so many spiders
        420 : "I don't even want to know what kind of shit is going on in there.<br><br>... wait, do you hear honking?", // fridgestuck
        0 : "Hang on a second, are they all robot versions of the same player?", // 0u0
        13 : "Is that... here?<br><br>How is that even possible? Ugh, the geometry out here SUCKS.", // yooo it's us
        4037 : "Wow, that guy looks like he's having a terrible time. I wonder what'd happen if he won? <span class='void'><br><br>Become a really good friend, probably ;)</span>", // Shoges
    },

    <int,String> { // Shogun
        413 : "Ah, the one that started it all. I aspire to be greater than the evil that plagued these children.",
        612 : "Equius deserved better than this.",
        613 : "I wonder if something like this exists for Session 13...",
        1025 : "When will we have 144 player session support JR? When?!",
        33 : "*>:33*",
        111111 : "It's like 413 but fucked turnways... That's how the phrase goes yeah? Well it's how it goes now.",
        88888888 : "I have long superseded this spider. I love the taste of *Spider's Blood*.",
        420 : "I'm normally a fan of clowns. But this... I'm not feeling this.",
        0 : "The sheer density of 0u0 in this fucking session is making me ill.",
        13 : "Finally. Here we are. The Ultimate Goal. This lot have had this coming for so long. And now I'll show them all. <span class='void'><br><br>All I wanted was out of this fucking game.</span>",
        4037 : "My home. My coffin. My beginning and end. A cursed number, a cursed player. No better fit for a villain.",
    }
];

List<List<String>> deadComments = <List<String>>[
    <String>[
        "Is that a black hole where Skaia should be? Wow that does not look like a good time.",
        "Oh dang, a dead session. These are rare! And *really* shitty for whoever's playing...",
        "Looks like someone tried to tempt fate and play SBURB alone. This will not end well...",
    ],
    <String>[
        "Ah, someone stuck in the same spot I was. They don't have the same helping hand I did. But maybe they'll become as great as scourge as I.",
        "A rare and familiar sight. Let's see if they win and tear hell like I do.",
        "I wonder if they were tricked by their friends to fall into that cruel fate like I was. Ah, I pity the poor soul.",
    ],
];

List<List<String>> lordMuseComments = <List<String>>[
    <String>[
        "Ooh, the master class pair. This might be interesting.",
        "A Lord and a Muse playing together. Could be interesting.",
        "A Lord/Muse pairing, they only ever seem to happen in two player sessions...",
        "Two master class players, all alone. This could get interesting.",
        "Lord and Muse, the classic combo.",
        "Lord and Muse, a potent combination.",
    ],
    <String>[
        "Look at them. A squabbling pair. If one of those insect fellas were here they'd probably say something about pitch shit. God I hate that fucking Trove.",
        "I've heard people say these classes are fanon. I think even the Sim does it. I don't get it.",
        "Ah, the PvP choice. The Lord almost always wins though.",
        "I need to get my binoculars. I wanna see how this goes.",
        "Lord and Muse. Hell in two halves.",
        "Lord and Muse. Rest in Peace Muse.",
    ],
];

List<List<String>> corruptComments = <List<String>>[
    <String>[
        "Something seems a bit off here...",
        "Looks like there might be some session corruption going on.",
        "Seems like there's corruption happening in this one...",
        "I don't like the look of that corruption.",
        "Something doesn't seem quite right here...",
        "Hmm, looks like there's a bit of corruption happening in this one.",
    ],
    <String>[
        "I can taste something off about this.",
        "Ah, some good old fashioned taint.",
        "Five out of six of my comments about this are gonna sound lewd.",
        "I'm loving how that corruption looks.",
        "God I wish that was me.",
        "I'm a professional on the matter at hand, and after careful analysis I can deliver my medical opinion. Shit's probably fucked.",
    ],
];

List<List<String>> followCorruptComments = <List<String>>[
    <String>[
        "Also, there's something off about this one...",
        "And looks like there might be some session corruption involved too.",
        "Plus there's some corruption happening here...",
        "Oh, and I really don't look the look of that corruption.",
        "Also something doesn't seem quite right here...",
        "Hmm, and it looks like there's a bit of corruption happening as well...",
    ],
    <String>[
        "... And I can taste something off about this.",
        "Ah, and there's also some good old fashioned taint.",
        "Also, Five out of six of my comments about this are gonna sound lewd.",
        "And btw I am loving how that corruption looks.",
        "And is that… God I wish that was me.",
        "Also, as a professional on the matter, after careful analysis of this I can safely say, shit is probably fucked.",
    ],
];

List<List<String>> veryCorruptComments = <List<String>>[
    <String>[
        "Oh wow that corruptuon is a MESS. Wouldn't want to be in there...",
        "Looks like the horrorterrors are having fun with that session...",
        "Wow, ok, that's a lot of corruption.",
        "I really, really do not like the look of all that corruption. That cannot be good.",
        "That corruption looks pretty terrible, I hope they are ok in there...",
        "That is... a pretty concerning amount of corruption, I hope they'll be ok in there...",
    ],
    <String>[
        "Holy shit that is some wicked nasty taint up in that. G fucking G.",
        "THIS IS JUST LIKE ONE OF MY SHOGUNLAND ANIMES!",
        "That corruption is so big… almost makes me feel inadequate. But of course, there's no greater taint than I.",
        "That corruption looks pretty terrible, I hope they're already dead.",
        "That's quite a healthy amount of raw fucked shit happening there. If they can win in this state… Who am I kidding?",
    ],
];

List<List<String>> followVeryCorruptComments = <List<String>>[
    <String>[
        "Also, wow, that corruption is a MESS. I would not want to be in there...",
        "Looks like the horrorterrors are having their fun with the session, too.",
        "And that... is an awful lot of corruption.",
        "Oh, and I really, really do not like the look of all that corruption. That cannot be good.",
        "... and I hope they are ok in there, that corruption looks pretty terrible.",
        "Also that is a pretty concerning amount of corruption, I hope they'll be ok in there...",
    ],
    <String>[
        "And shit that is some wicked nasty taint up in that. G fucking G.",
        "And… Oh. *OH.* THIS IS JUST LIKE ONE OF MY SHOGUNLAND ANIMES!",
        "And phew, that corruption is so big… almost makes me feel inadequate. But of course, there's no greater taint than I.",
        "And judging by that corruption, they're probably already dead.",
        "And that's quite a healthy amount of raw fucked shit happening there. If they can win in this state… Who am I kidding?",
    ],
];

List<List<String>> heiressComments = <List<String>>[
    <String>[
        "Wow, multiple troll heiresses... that's gonna be a messy one.",
        "How the heck did they get more than one heiress to play together?!",
        "Oh wow, more than one troll heiress in the same session. Nasty!",
        "Is that a session with more than one royal troll? Dang, sounds bad.",
        "Hm, do I see multiple troll heiresses in there? How did that happen?",
    ],
    <String>[
        "Oh YES. I can just smell the bloodbath building up. I should stick around for this.",
        "This is gonna be getting an Adult rating. Fuck deathmatch wrestling. This is the shit that needs televised.",
        "I am hype as fuck for these alien heiresses settling their blood feud in a universe creating video game.",
        "These Heiresses all have a bit of Shogun in them it seems. Heh.",
        "The only thing that would make this better is like. All Lords.",
    ],
];

List<List<String>> disastorComments = <List<String>>[
    <String>[
        "Those are some pretty gnarly sprites, the enemies in there must be really nasty.",
        "With prototypings like that I bet the players will have some trouble...",
        "I hope they know what a pain prototyping all that dangerous shit will be...",
        "The prototypings in this one look pretty horrible.",
        "I hope they can cope with all the dangerous shit they're prototyping in there.",
        "With sprites that dangerous the enemies must be real monsters in there.",
    ],
    <String>[
        "What are those wispy shits? They look… worse than they should be. This could be interesting.",
        "Those regular baddies look like something that could rival the big fuckers I had to take on. This bunch must be tough.",
        "These lot must want a harder time. They could've gone a lone like.",
        "Those wispy shits look hype as fuck.",
        "I hope they come out the other end of that gauntlet with the power they sought.",
        "Hahah, rip",
    ],
];

// pick list depending on shogun or not
T pc<T>(ObservatoryViewer ob, List<T> lists) => lists[((ob.overcoat != null) && ob.overcoat.active) ? 1 : 0];

String processSessionComment(ObservatoryViewer ob, int today) {
    Session session = ob.detailSession.session;
    int id = session.session_id;
    Random rand = new Random(id);

    List<String> segments = <String>[];

    bool dead = false;
    bool lordMuse = false;
    bool multiHeiress = false;
    bool multiDisastor = false;



    if (pc(ob,eggComments).containsKey(id)) {
        // if it's an easter-egg session, get the special descriptor for that
        segments.add(pc(ob,eggComments)[id]);
    } else {
        if (session.session_id == ObservatoryViewer._today_session) {
            segments.add(pc(ob,<String>["This is today's featured session.", "Here's the featured one, I dunno if it's random or chosen by JR. Probably cool or something. If it's not cool bitch about it on discord or summin."]));
        }

        if (session.players.length == 1) { // check dead sessions
            segments.add(rand.pickFrom(pc(ob,deadComments)));
            dead = true;
        } else if (session.players.length == 2) { // check 2p for lord+muse
            bool lord = false;
            bool muse = false;
            for (Player p in session.players) {
                if (p.class_name == SBURBClassManager.LORD) {
                    lord = true;
                } else if (p.class_name == SBURBClassManager.MUSE) {
                    muse = true;
                }
            }
            if (lord && muse) {
                segments.add(rand.pickFrom(pc(ob,lordMuseComments)));
                lordMuse = true;
            }
        }

        // check for competing heiresses
        int heiresses = 0;
        for (Player p in session.players) {
            if (p.isTroll && p.bloodColor == "#99004d") {
                heiresses++;
            }
        }
        if (heiresses > 1) {
            segments.add(rand.pickFrom(pc(ob,heiressComments)));
            multiHeiress = true;
        }

        // check for multiple disastor prototypings
        int disastor = 0;
        for (Player p in session.players) {
            if (p.object_to_prototype.disaster) {
                disastor++;
            }
        }
        if (disastor > 1 && (disastor / session.players.length) > 0.33) {
            segments.add(rand.pickFrom(pc(ob,disastorComments)));
            multiDisastor = true;
        }
    }

    // add a corruption comment
    // should be after other stuff to take advantage of follow-ons
    int corruption = 0;
    for (Player p in session.players) {
        Land l = p.land;
        if (l != null && l.corrupted) {
            corruption++;
        }
    }
    if (corruption >= 3) {
        if (segments.isEmpty) {
            segments.add(rand.pickFrom(pc(ob,veryCorruptComments)));
        } else {
            segments.add(rand.pickFrom(pc(ob,followVeryCorruptComments)));
        }
    } else if (corruption >= 1) {
        if (segments.isEmpty) {
            segments.add(rand.pickFrom(pc(ob,corruptComments)));
        } else {
            segments.add(rand.pickFrom(pc(ob,followCorruptComments)));
        }
    }

    // combo finishers
    if (lordMuse && multiHeiress) { // lord and muse heiresses
        segments.add(pc(ob,<String>["This is going to be one hell of a showdown.", "This is… *SO GOD DAMN COOL!*."]));
    }
    if (lordMuse && multiDisastor) {
        segments.add(pc(ob,<String>["They're really making it hard for themselves...", "They must really want to kill the other one. Like Spy vs Spy."]));
    }
    if (dead && corruption > 0) {
        segments.add(pc(ob,<String>["Wait, corrupt *and* dead... holy shit", "Ah. Now this reminds me of my run through it. Except I helped the player instead of trying to kill him. Heheh."]));
    }

    // LEG DAY
    for (Player p in session.players) {
        if (p.class_name == SBURBClassManager.PAGE && p.aspect == Aspects.HEART && p.interest1.category == InterestManager.ATHLETIC && p.interest2.category == InterestManager.ATHLETIC) {
            if (segments.isEmpty) {
                segments.add(pc(ob,<String>["Wow, look at the legs on that Page of Heart!", "Those are some good legs, but I'm more of a thigh man myself."]));
            } else {
                segments.add(pc(ob,<String>["... and do you SEE the legs on that Page of Heart?!", "And those are some good legs, but I'm more of a thigh man myself."]));
            }
            break;
        }
    }

    return segments.isEmpty ? null : segments.join("<br><br>");
}

//##################################################################################

class ObservatoryViewer {
    static const int size = 65536;
    static const int gridsize = 720;
    static const int pixelsize = size * gridsize;
    static const int cachesize = 500;

    static const String param_x = "cx";
    static const String param_y = "cy";
    static const String param_seed = "seed";

    static const double _particleSpeedMult = 100.0;

    static int _today_session = int.parse(todayToSession(), onError: (String s) => 13);

    Action callback_session = null;

    LinkedHashMap<int, Session> sessionCache = new LinkedHashMap<int, Session>();

    int cellpadding;

    int canvasWidth;
    int canvasHeight;
    double viewRadius;

    CanvasElement canvas;
    THREE.WebGLRenderer renderer;
    THREE.Scene scene;
    THREE.OrthographicCamera camera;
    THREE.Object3D cameraRig;
    THREE.Texture uiTexture;

    THREE.GPUParticleSystem particleSystem;
    THREE.GPUParticleSystemSpawnOptions _particleSpawnOptions;

    THREE.Scene renderScene;
    THREE.OrthographicCamera renderCamera;
    THREE.WebGLRenderTarget renderTarget;

    CanvasElement uiCanvas;
    Element eventDelegate;

    NumberInputElement coordElementX;
    NumberInputElement coordElementY;
    NumberInputElement sessionElement;

    int camx = 0;
    int camy = 0;

    Map<Point<int>, ObservatorySession> sessions = <Point<int>,ObservatorySession>{};
    ObservatorySession detailSession = null;

    Point<num> dragStart = null;
    bool dragging = false;

    bool viewingLandDetails = false;
    ObservatoryLandDetails landDetails;

    ShipLogic overcoat;

    Lambda<double> _shaderUpdate = null;

    ObservatoryViewer(int this.canvasWidth, int this.canvasHeight, {int this.cellpadding = 0, Element this.eventDelegate = null}) {
        double hw = this.canvasWidth / 2;
        double hh = this.canvasHeight / 2;
        this.viewRadius = Math.sqrt(hw*hw + hh*hh);
        this.landDetails = new ObservatoryLandDetails(this);
        this.overcoat = new ShipLogic(this); // The Big Man HASSS the ship, forever!
    }

    Future<Null> setup([int seed = 0]) async {
        if (this.overcoat != null) {
            await this.overcoat.init();
        }

        this.renderer = new THREE.WebGLRenderer();
        this.renderer
            ..setSize(canvasWidth, canvasHeight)
            ..setClearColor(0x000000, 0);

        this.canvas = this.renderer.domElement..classes.add("observatory");
        if (this.eventDelegate == null) {
            this.eventDelegate = this.canvas;
        }

        this.scene = new THREE.Scene();
        this.renderScene = new THREE.Scene();

        this.camera = new THREE.OrthographicCamera(-canvasWidth/2, canvasWidth/2, -canvasHeight/2, canvasHeight/2, 0, 1000.0)..position.z = 700.0;
        this.renderCamera = new THREE.OrthographicCamera(-canvasWidth/2, canvasWidth/2, -canvasHeight/2, canvasHeight/2, 0, 100)..position.z = 10.0;

        // UI plane
        this.uiCanvas = new CanvasElement(width: canvasWidth, height: canvasHeight);
        this.uiTexture = new THREE.Texture(this.uiCanvas)..minFilter = THREE.NearestFilter..magFilter = THREE.NearestFilter;

        THREE.ShaderMaterial uiShader = await THREE.makeShaderMaterial("shaders/basic.vert", "shaders/outline.frag")..transparent = true;

        THREE.setUniform(uiShader, "image", new THREE.ShaderUniform<THREE.TextureBase>()..value = this.uiTexture);
        THREE.setUniform(uiShader, "size", new THREE.ShaderUniform<THREE.Vector2>()..value = new THREE.Vector2(this.canvasWidth, this.canvasHeight));
        THREE.setUniform(uiShader, "outline_colour", new THREE.ShaderUniform<THREE.Vector4>()..value = new THREE.Vector4(0.0,0.0,0.0,1.0));

        //THREE.Mesh uiObject = new THREE.Mesh(new THREE.PlaneGeometry(canvasWidth, canvasHeight), new THREE.MeshBasicMaterial(new THREE.MeshBasicMaterialProperties(map: this.uiTexture))..transparent = true)
        THREE.Mesh uiObject = new THREE.Mesh(new THREE.PlaneGeometry(canvasWidth, canvasHeight), uiShader)
            ..position.z = 500.0
            ..rotation.x = Math.PI
        ;

        // render target texture plane
        this.renderTarget = new THREE.WebGLRenderTarget(canvasWidth, canvasHeight);
        
        THREE.ShaderMaterial postShader = await THREE.makeShaderMaterial("shaders/basic.vert", "shaders/observatory_screen.frag");

        THREE.ShaderUniform<bool> postOvercoatUniform = new THREE.ShaderUniform<bool>()..value = false;
        THREE.ShaderUniform<double> postBeat = new THREE.ShaderUniform<double>()..value = 0.0;

        THREE.setUniform(postShader, "image", new THREE.ShaderUniform<THREE.TextureBase>()..value = this.renderTarget.texture);
        THREE.setUniform(postShader, "size", new THREE.ShaderUniform<THREE.Vector2>()..value = new THREE.Vector2(this.canvasWidth, this.canvasHeight));

        THREE.setUniform(postShader, "speedlines", new THREE.ShaderUniform<THREE.TextureBase>()..value = (new THREE.Texture(await Loader.getResource("images/textures/speedlines.png"))
            ..wrapS = THREE.RepeatWrapping
            ..wrapT = THREE.RepeatWrapping
            ..needsUpdate = true
        ));

        THREE.Vector2 vel = new THREE.Vector2.zero();
        THREE.setUniform(postShader, "velocity", new THREE.ShaderUniform<THREE.Vector2>()..value = vel);
        THREE.ShaderUniform<double> speedLineOffset = new THREE.ShaderUniform<double>()..value = 0.0;
        THREE.setUniform(postShader, "speedlineoffset", speedLineOffset);

        THREE.setUniform(postShader, "overcoat", postOvercoatUniform);
        THREE.setUniform(postShader, "beat", postBeat);
        
        THREE.Mesh renderPlane = new THREE.Mesh(new THREE.PlaneGeometry(canvasWidth, canvasHeight), postShader)
            ..position.z = 5.0
            ..rotation.x = Math.PI;
        this.renderScene.add(renderPlane);

        // camera rig
        this.cameraRig = new THREE.Object3D()..add(this.camera)..add(uiObject);

        this.scene.add(this.cameraRig);

        this.particleSystem = new THREE.GPUParticleSystem(new THREE.GPUParticleSystemOptions(
            maxParticles: 250000,
            particleNoiseTex: new THREE.Texture(await Loader.getResource("images/textures/perlin512.png"))..needsUpdate=true,
            particleSpriteTex: new THREE.Texture(await Loader.getResource("images/textures/particle.png"))..needsUpdate=true,
        ));
        this._particleSpawnOptions = new THREE.GPUParticleSystemSpawnOptions(position: new THREE.Vector3.zero(), velocity: new THREE.Vector3.zero());

        this.scene.add(this.particleSystem);

        if (this.overcoat != null) {
            this.scene.add(this.overcoat.shipModel);
        }

        this._shaderUpdate = (double dt) {
            if (this.overcoat != null) {
                postOvercoatUniform.value = this.overcoat.active;
                postBeat.value = this.overcoat.sound.beat;
                vel.x = this.overcoat.vel.x;
                vel.y = this.overcoat.vel.y;

                speedLineOffset.value = (speedLineOffset.value + (this.overcoat.vel.length() / 512.0) * dt) % 1.0;
            }
        };

        this.update();

        this.eventDelegate.onMouseDown.listen(mouseDown);
        this.eventDelegate.onClick.listen(mouseClick);
        window.onMouseUp.listen(mouseUp);
        window.onMouseMove.listen(mouseMove);
        window.onKeyDown.listen(keyDown);
        window.onKeyUp.listen(keyUp);

        this.sessionElement = querySelector("#session_id");
        this.coordElementX = querySelector("#coordinates_x");
        this.coordElementY = querySelector("#coordinates_y");

        querySelector("#session_button")..onClick.listen(this.readSessionElement);
        this.coordElementX.onChange.listen(this.readCoordinateElement);
        this.coordElementY.onChange.listen(this.readCoordinateElement);

        this.readURL();

        this.setCoordinateElement();
        this.setSessionElement();

        Audio.masterVolume.value = 0.25;
    }

    void mouseDown(MouseEvent e) {
        if (this.overcoat != null) {
            this.overcoat.sound.startSound();
        }

        if (this.viewingLandDetails) { return; }
        dragging = true;
        dragStart = e.offset;
        this.eventDelegate.classes.add("dragging");
    }

    void mouseUp(MouseEvent e) {
        if (this.overcoat != null) {
            this.overcoat.sound.startSound();
        }

        if (dragging) { dragging = false; }
        this.eventDelegate.classes.remove("dragging");
    }

    void mouseMove(MouseEvent e) {
        int zone = detectClickZone(e);

        if (zone != 0) {
            this.eventDelegate.classes.add("clickable");
        } else {
            this.eventDelegate.classes.remove("clickable");
        }

        if (this.viewingLandDetails) { return; }
        if (!dragging) { return; }

        window.getSelection().empty();
        window.getSelection().removeAllRanges();

        /*if (this.overcoat != null && this.overcoat.active) {
            this.toggleOvercoat();
        }*/

        this.goToCoordinates(this.camx - e.movement.x, this.camy - e.movement.y);

        this.updateSessions();
    }

    void mouseClick(MouseEvent e) {
        if (this.viewingLandDetails) { return; }
        double dist = double.INFINITY;
        if (dragStart != null) {
            int dx = e.offset.x - dragStart.x;
            int dy = e.offset.y - dragStart.y;
            dist = Math.sqrt(dx*dx + dy*dy);
        }
        if (dist >= 2.0) { return; }

        int zone = detectClickZone(e);

        if (zone == 4037) {
            this.toggleOvercoat();
        } else if (zone != 0) {
            this.landDetails.showLand(this.detailSession.session.players[zone-1].land);
        }

        if (this.overcoat != null) {
            this.overcoat.sound.startSound();
        }
    }

    Map<int, bool> keys = <int,bool>{};
    void keyDown(KeyboardEvent e) {
        if (this.overcoat != null && this.overcoat.active) {
            keys[e.keyCode] = true;
            if (document.activeElement == document.body) {
                if (e.keyCode == 37 || e.keyCode == 38 || e.keyCode == 39 || e.keyCode == 40) {
                    e.preventDefault();
                }
            }
        }
    }
    void keyUp(KeyboardEvent e) {
        keys[e.keyCode] = false;
    }
    bool getKey(int keyCode) => keys.containsKey(keyCode) && keys[keyCode];

    int detectClickZone(MouseEvent e) {
        num x = e.offset.x;
        num y = e.offset.y;

        if (this.overcoat != null) {
            int worldx = camx + x - canvasWidth ~/ 2;
            int worldy = camy + y - canvasHeight ~/ 2;

            num dx = this.overcoat.pos.x - worldx;
            num dy = this.overcoat.pos.y - worldy;

            double dist = Math.sqrt(dx*dx + dy*dy);

            if (dist < 30.0) {
                return 4037;
            }
        }

        if (this.detailSession == null || this.detailSession.session.players.isEmpty) {
            return 0;
        }
        Session session = this.detailSession.session;
        int lands = session.players.length;

        int left = 22;
        int top = 80;
        int height = 30;
        int gap = 11;

        for (int i=0; i<lands; i++) {
            if (x >= left && y >= top + (height + gap) * i && y <= top + height + (height + gap) * i) {
                Player p = session.players[i];
                int text = 4 + Math.max(p.land.name.length, p.chatHandle.length + 7 + p.class_name.name.length + p.aspect.name.length);
                if (x <= left + 8.5 * text) {
                    return i + 1;
                }
            }
        }

        return 0;
    }

    void readURL() {
        Map<String,String> p = Uri.base.queryParameters;

        if (p.containsKey(param_seed)) {
            this.goToSeed(int.parse(p[param_seed], onError: (String s) => 0));
        } else if (p.containsKey(param_x) && p.containsKey(param_y)) {
            double x = double.parse(p[param_x], (String s) => 0.0);
            double y = double.parse(p[param_y], (String s) => 0.0);

            this.goToCoordinates(x * gridsize, y * gridsize);
        } else {
            this.goToSeed(_today_session);
        }
    }

    void setURL() {
        String x = ((10000 * this.camx / gridsize).roundToDouble() / 10000).toString();
        String y = ((10000 * this.camy / gridsize).roundToDouble() / 10000).toString();

        String otherparams = getParamStringMinusParam(<String>["cx","cy","seed"]);

        window.history.replaceState(<String,String>{}, "Observatory", "${Uri.base.path}?$param_x=$x&$param_y=$y${otherparams.isEmpty?"":"&$otherparams"}");
    }

    void readCoordinateElement([Event e]) {
        if (this.coordElementX == null) { return; }

        this.goToCoordinates(this.coordElementX.valueAsNumber.toDouble() * gridsize, this.coordElementY.valueAsNumber.toDouble() * gridsize);
    }

    void setCoordinateElement() {
        if (this.coordElementX == null) { return; }
        this.coordElementX.valueAsNumber = (10000 * this.camx / gridsize).roundToDouble() / 10000;
        this.coordElementY.valueAsNumber = (10000 * this.camy / gridsize).roundToDouble() / 10000;
    }

    void readSessionElement([Event e]) {
        if (this.sessionElement == null) { return; }
        this.goToSeed(this.sessionElement.valueAsNumber.floor());
    }

    void setSessionElement() {
        if (this.sessionElement == null) { return; }
        this.sessionElement.valueAsNumber = this.detailSession != null ? this.detailSession.session.session_id : 0;
    }

    double prevframe = 0.0;
    void update([num time = 0.0]) {
        window.requestAnimationFrame(update);
        double doubletime = time.toDouble();
        double dt = (doubletime - prevframe) / 1000;
        prevframe = doubletime;

        for (ObservatorySession session in sessions.values) {
            session.update(dt);
        }

        if (this.overcoat != null) {
            this.overcoat.update(dt);
        }

        this.particleSystem.update((doubletime * _particleSpeedMult) / 1000);
        _shaderUpdate(dt);

        this.renderer
            ..render(this.scene, this.camera, this.renderTarget)
            ..render(this.renderScene, this.renderCamera);
    }

    void updateSessions() {
        double leftedge   = this.camx - this.canvasWidth  / 2;
        double rightedge  = this.camx + this.canvasWidth  / 2;
        double topedge    = this.camy - this.canvasHeight / 2;
        double bottomedge = this.camy + this.canvasHeight / 2;

        int leftcell   = (leftedge   / gridsize).floor() - this.cellpadding;
        int rightcell  = (rightedge  / gridsize).ceil()  + this.cellpadding;
        int topcell    = (topedge    / gridsize).floor() - this.cellpadding;
        int bottomcell = (bottomedge / gridsize).ceil()  + this.cellpadding;

        Set<Point<int>> toRemove = new Set<Point<int>>();

        for (Point<int> key in sessions.keys) {
            ObservatorySession s = sessions[key];
            if (s.x < leftcell || s.x > rightcell || s.y < topcell || s.y > bottomcell) {
                toRemove.add(key);
            }
        }

        for (Point<int> key in toRemove) {
            ObservatorySession removed = sessions.remove(key);
            this.destroySession(removed);
        }

        int rx,ry;
        Point<int> id;
        for (int x = leftcell; x <= rightcell; x++) {
            rx = x < 0 ? x + size : x >= size ? x - size : x;
            for (int y = topcell; y <= bottomcell; y++) {
                ry = y < 0 ? y + size : y >= size ? y - size : y;

                id = new Point<int>(x,y);

                if (!sessions.containsKey(id)) {
                    sessions[id] = this.createSession(SeedMapper.coords2seed(rx,ry), x, y);
                }
            }
        }

        for (ObservatorySession s in sessions.values) {
            s.update();
        }
    }

    void goToCoordinates(num x, num y) {
        x = x.floor();
        y = y.floor();

        x = x < 0 ? x + pixelsize : x >= pixelsize ? x -= pixelsize : x;
        y = y < 0 ? y + pixelsize : y >= pixelsize ? y -= pixelsize : y;

        if (x == this.camx && y == this.camy) { return; } // abort if no movement

        this.camx = x;
        this.camy = y;

        this.setCoordinateElement();

        this.cameraRig..position.x = camx.toDouble()..position.y = camy.toDouble();

        //

        this.updateSessions();
        this.setURL();

        ObservatorySession nearest = this.findDetailSession();

        if (nearest == this.detailSession) { return; } // abort if nearest session is the same

        if (this.detailSession != null) {
            this.detailSession.selected = false;
        }
        this.detailSession = nearest;
        this.detailSession.selected = true;
        this.setSessionElement();

        this.updateSessionDetails();

        if (this.callback_session != null) { this.callback_session(); }
    }

    void goToGridCoordinates(num x, num y) {
        this.goToCoordinates((x+0.5) * gridsize, (y+0.5) * gridsize);
    }

    void goToSeed(int seed) {
        Tuple<int,int> coords = SeedMapper.seed2coords(seed);
        this.goToGridCoordinates(coords.first, coords.second);
    }

    void goToOvercoat() {
        if (this.overcoat != null) {
            this.toggleOvercoat();
        }
    }

    //############ detail session

    ObservatorySession findDetailSession() {
        ObservatorySession nearest = null;
        double distance = double.INFINITY;

        int x,y;
        double diff;
        for (ObservatorySession session in sessions.values) {
            x = ((session.x + 0.5) * gridsize).floor() + session.model_offset_x - this.camx;
            y = ((session.y + 0.5) * gridsize).floor() + session.model_offset_y - this.camy;

            diff = Math.sqrt(x*x + y*y) - (ObservatorySession.modelsize * session.session_size * 0.5) * 0.5; // halved offset for tuning

            if (diff < distance) {
                distance = diff;
                nearest = session;
            }
        }

        return nearest;
    }

    void updateSessionDetails() {
        if (this.detailSession == null) { return; }

        CanvasRenderingContext2D ctx = this.uiCanvas.context2D;
        int w = this.canvasWidth;
        int h = this.canvasHeight;

        int top = 18;
        int left = 22;
        int lineheight = 14;
        int title = 26;

        ctx
            ..clearRect(0, 0, w, h)
            ..fillStyle = "lime"
            ..font = "bold 24px courier, monospace"
            ..fillText("Session ${detailSession.seed}", left, top + title)
            ..font = "bold 14px courier, monospace"
            ..fillText("Lands: ${detailSession.session.players.length}", left, top + title + lineheight)
        ;

        int line = 3;
        int i=0;
        for (Player p in detailSession.session.players) {
            i++;
            ctx..fillText("#${i.toString().padLeft(2,"0")}: ${p.land.name}", left, top + title + lineheight * line);
            line++;
            ctx..fillText("     ${p.title()} (${p.chatHandle})", left, top + title + lineheight * line);

            line += 2;
        }

        this.uiTexture.needsUpdate = true;
    }

    //############ creation

    ObservatorySession createSession(int seed, int x, int y) {
        ObservatorySession ret =  new ObservatorySession(this, seed, x, y)..createModel();
        return ret;
    }

    void destroySession(ObservatorySession session) {
        session.remove();
    }

    Session getSession(int seed) {
        if (sessionCache.containsKey(seed)) {
            return sessionCache[seed];
        }

        Session session = new Session(seed)..logger.disabled = true;
        session.reinit("observatory");
        session.makePlayers();
        session.randomizeEntryOrder();
        session.makeGuardians();

        checkEasterEgg(session);
        this.easterEggCallback(session);

        sessionCache[seed] = session;

        if (sessionCache.length > cachesize) {
            int oldest = sessionCache.keys.first;
            sessionCache.remove(oldest);

        }
        return session;
    }

    void easterEggCallback(Session session) {
        //initializePlayers(session.players, session);
    }

    void toggleOvercoat() {
        this.overcoat.active = !this.overcoat.active;

        if (this.callback_session != null) { this.callback_session(); }
    }

    void spawnParticle(num x, num y, num z, num vx, num vy, num vz, {double posRand = 0.0, double velRand = 0.0, double size = 10.0, double sizeRand = 0.0, int colour = 0xFFFFFF, double colourRand = 0.0, double life = 2.0, double turbulence = 0.0, bool smooth = false}) {

        this._particleSpawnOptions
            ..position.x = x
            ..position.y = y
            ..position.z = z
            ..positionRandomness = posRand
            ..velocity.x = vx / _particleSpeedMult
            ..velocity.y = vy / _particleSpeedMult
            ..velocity.z = vz / _particleSpeedMult
            ..velocityRandomness = velRand / _particleSpeedMult
            ..size = size
            ..sizeRandomness = sizeRand
            ..color = colour
            ..colorRandomness = colourRand
            ..lifetime = life * _particleSpeedMult
            ..turbulence = turbulence / _particleSpeedMult
            ..smoothPosition = smooth
        ;

        this.particleSystem.spawnParticle(this._particleSpawnOptions);
    }
}

class ObservatorySession {
    static const int modelsize = 512;
    static const double max_rotation = 0.008;
    static const double min_rotation = 0.003;

    static bool _graphics_init = false;
    static THREE.Texture spiro_tex;
    static THREE.ShaderUniform<THREE.Texture> spiro_uniform;
    static THREE.MeshBasicMaterial spiro_material;
    static THREE.MeshBasicMaterial spiro_material_land;

    ObservatoryViewer parent;
    bool selected = false;

    Session session;
    Random rand;

    int seed;
    int x;
    int y;

    int model_offset_x;
    int model_offset_y;

    THREE.Object3D model;
    THREE.Object3D spin_group;
    double rotation_speed;
    double initial_rotation;
    double session_size;

    List<THREE.Object3D> land_spinners = <THREE.Object3D>[];
    THREE.ShaderUniform<double> rotation_uniform;
    THREE.ShaderUniform<bool> selected_uniform;

    List<ObservatoryTentacle> tentacles = <ObservatoryTentacle>[];

    ObservatorySession(ObservatoryViewer this.parent, int this.seed, int this.x, int this.y) {
        this.rand = new Random(seed);

        this.session = parent.getSession(seed);

        this.initial_rotation = rand.nextDouble(Math.PI * 2);
        this.rotation_speed = rand.nextDouble() * (max_rotation - min_rotation) + min_rotation;
        if (rand.nextBool()) {
            this.rotation_speed *= -1;
        }

        double minsize = 0.5 + 0.035 * this.session.players.length;
        double maxsize = 0.5 + 0.1 * this.session.players.length;
        this.session_size = Math.min(1.0, rand.nextDouble(maxsize - minsize) + minsize);

        int max_deviation = (ObservatoryViewer.gridsize - modelsize * this.session_size).floor();

        this.model_offset_x = rand.nextInt(max_deviation) - max_deviation ~/2;
        this.model_offset_y = rand.nextInt(max_deviation) - max_deviation ~/2;
    }

    void update([num dt = 0.0]) {
        if (this.model == null) { return; }
        spin_group.rotation.z = (spin_group.rotation.z + dt * rotation_speed * Math.PI * 2) % (Math.PI * 2 * 8);

        for (THREE.Object3D spiro in land_spinners) {
            spiro.rotation.z = (spiro.rotation.z + dt * rotation_speed * Math.PI * 2 * -8) % (Math.PI * 2);
        }

        this.rotation_uniform.value = spin_group.rotation.z;
        this.selected_uniform.value = this.selected;

        for (ObservatoryTentacle tent in this.tentacles) {
            tent.update(dt);
        }
    }

    static Future<Null> initGraphics() async {
        if (_graphics_init) {
            return;
        }

        spiro_tex = new THREE.Texture(await Loader.getResource("images/spirograph_white.png"))..needsUpdate = true;
        spiro_material = new THREE.MeshBasicMaterial(new THREE.MeshBasicMaterialProperties(map: spiro_tex));
        spiro_material_land = new THREE.MeshBasicMaterial(new THREE.MeshBasicMaterialProperties(color: 0x707070, map: spiro_tex));

        _graphics_init = true;
    }

    Future<Null> createModel() async {
        await initGraphics();

        THREE.Object3D group = new THREE.Object3D()..rotation.x = Math.PI;
        THREE.Object3D spinner = new THREE.Object3D();

        THREE.ShaderMaterial mat = await THREE.makeShaderMaterial("shaders/basic.vert", "shaders/observatory_session.frag")..transparent = true;

        this.rotation_uniform = new THREE.ShaderUniform<double>()..value = 0.0;
        THREE.setUniform(mat, "session_rotation", rotation_uniform);
        this.selected_uniform = new THREE.ShaderUniform<bool>()..value = this.selected;
        THREE.setUniform(mat, "selected", selected_uniform);
        THREE.setUniform(mat, "land_count", new THREE.ShaderUniform<int>()..value = this.session.players.length);
        THREE.setUniform(mat, "session_size", new THREE.ShaderUniform<double>()..value = this.session_size);
        THREE.setUniform(mat, "spiro_tex", new THREE.ShaderUniform<THREE.TextureBase>()..value = spiro_tex);

        THREE.Mesh mesh = new THREE.Mesh(new THREE.PlaneGeometry(modelsize, modelsize), mat);
        group.add(mesh);
        group.add(spinner);

        this.spin_group = spinner;

        int players = this.session.players.length;
        double angle_inc = (Math.PI * 2) / players;
        double landdist = 120.0 * this.session_size - 40;
        double land_extra_dist = 10.0;
        double gate_sep = 15.0 * (0.8 + 0.2 * this.session_size);
        int gates = (landdist / gate_sep).ceil();
        double gate_inc = landdist / gates;
        double skaia_dist = 35.0 * (0.5 + 0.5 * this.session_size);


        for (int i=0; i<players; i++) {
            double angle = angle_inc * i;
            double ux = Math.sin(angle);
            double uy = Math.cos(angle);
            for (int j=0; j<gates; j++) {
                double dist = skaia_dist + gate_inc * j;
                double x = dist * ux;
                double y = dist * uy;

                THREE.Mesh gate = new THREE.Mesh(new THREE.PlaneGeometry(8, 8), spiro_material)..position.z = 1.0..position.x = x..position.y = y;
                spinner.add(gate);
            }

            Player player = session.players[i];
            Land land = player.land;
            THREE.Mesh landmodel = await createLandModel(player, land);
            landmodel.position..x = (skaia_dist + landdist + land_extra_dist) * ux..y = (skaia_dist + landdist + land_extra_dist) * uy;
            landmodel.rotation..z = -angle + Math.PI;
            spinner.add(landmodel);
        }

        this.model = group;
        this.model.position..x = (x + 0.5) * ObservatoryViewer.gridsize + model_offset_x..y = (y + 0.5) * ObservatoryViewer.gridsize + model_offset_y;
        spinner.rotation..z = this.initial_rotation;
        spinner.position.z = -2.0;

        await this.createTentacles();

        this.parent.scene.add(this.model);
    }

    Future<Null> createTentacles() async {
        int count = 1 + this.rand.nextInt(3);

        int corruption = findCorruption();

        for (int i=0; i<corruption; i++) {
            count += 1 + rand.nextInt(2);
        }

        double radius = 50.0 + this.parent.viewRadius * 2;

        for (int i=0; i<count; i++) {
            double angle = this.rand.nextDouble(Math.PI * 2);
            int ox = (Math.sin(angle) * radius).round();
            int oy = (Math.cos(angle) * radius).round();

            ObservatoryTentacle tent = new ObservatoryTentacle(this, ((x + 0.5) * ObservatoryViewer.gridsize + ox).floor(), ((y + 0.5) * ObservatoryViewer.gridsize + oy).floor(), rand.nextInt());
            await tent.createModel();
            this.tentacles.add(tent);
            this.parent.scene.add(tent.mesh);
        }
    }

    int findCorruption() {
        int corrupt = 0;
        for (Player p in this.session.players) {
            Land l = p.land;
            if (l.corrupted) {
                corrupt++;
            }
        }
        if (corrupt > 0) {
            corrupt += 2;
        }
        return corrupt;
    }

    Future<THREE.Object3D> createLandModel(Player player, Land land) async {
        Colour col = new Colour.fromStyleString(player.getChatFontColor());

        THREE.Object3D group = new THREE.Object3D();

        THREE.ShaderMaterial mat = await THREE.makeShaderMaterial("shaders/basic.vert", "shaders/circle.frag");
        THREE.setUniform(mat, "colour", new THREE.ShaderUniform<THREE.Vector4>()..value = new THREE.Vector4(col.redDouble, col.greenDouble, col.blueDouble, 1.0));

        THREE.Mesh spiro = new THREE.Mesh(new THREE.PlaneGeometry(30, 30), spiro_material_land)..position.z = 2.0;
        THREE.Mesh landmodel = new THREE.Mesh(new THREE.PlaneGeometry(12, 12),
            mat
        )..position.z = 1.0;

        this.land_spinners.add(spiro);
        group.add(spiro);
        group.add(landmodel);

        return group;
    }

    void remove() {
        this.parent.scene.remove(this.model);
        for (ObservatoryTentacle t in this.tentacles) {
            this.parent.scene.remove(t.mesh);
        }
    }
}

class ObservatoryLandDetails {
    ObservatoryViewer parent;

    Element container;

    Element landElement;
    HeadingElement landName;

    ObservatoryLandDetails(ObservatoryViewer this.parent) {
        this.container = new DivElement()..className="details_screen";

        this.landElement = new DivElement()..className="details_landview";
        this.landName = new HeadingElement.h1()..text="Land of Stuff and Things";

        this.container
            ..append(new DivElement()..className="details_close"..text="\u00d7"..onClick.listen((Event e) {hideElement();}))
            ..append(landName)
            ..append(landElement)
            ..append(new ParagraphElement()..text = "Land rendering is not yet implemented, sorry! This window will show a picture in future, though. - PL")
        ;

        hideElement();
    }

    void showLand(Land land) {
        this.landName.text = land.name;

        // land rendering call goes here later

        showElement();
    }

    void showElement() {
        show(container);
        parent.viewingLandDetails = true;
    }

    void hideElement() {
        hide(container);
        parent.viewingLandDetails = false;
    }
}

class ObservatoryTentacle {
    static THREE.PlaneGeometry _geometry = new THREE.PlaneGeometry(1, 1, 4, 50);

    ObservatorySession session;
    int seed;

    int x;
    int y;

    double length = 100.0;
    double width = 70.0;
    double period = 0.0;

    double speed = 0.3;

    THREE.Mesh mesh;
    THREE.ShaderMaterial material;

    ObservatoryTentacle(ObservatorySession this.session, int this.x, int this.y, int this.seed) {}

    void update([num dt]) {
        this.period = (this.period + dt * speed) % 1.0;

        THREE.getUniform(this.material, "period")..value = this.period;

        double radius = this.session.parent.viewRadius;

        double xdiff = (this.x - this.session.parent.camx).toDouble();
        double ydiff = (this.y - this.session.parent.camy).toDouble();

        double diff = Math.sqrt(xdiff*xdiff + ydiff*ydiff);

        if (diff < radius) {
            this.mesh.visible = false;
        } else {
            this.mesh.visible = true;

            double frac = ((diff - radius) / (radius));
            frac = frac.clamp(0.01, 1.0);
            frac = smoothstep(frac);

            THREE.getUniform(this.material, "size")..value = new THREE.Vector2(this.width, this.length * frac);
        }
    }

    Future<Null> createModel() async {
        Random rand = new Random(this.seed);

        this.period = rand.nextDouble();

        double speedval = rand.nextDouble() * rand.nextDouble();
        double angleval = 0.5 + speedval * 1.25 + rand.nextDouble();
        double offsetval = 3.0 + rand.nextDouble() * 20.0;
        angleval *= 1.0 + offsetval * 0.2;
        double tipcurveval = 1.5 + speedval;
        tipcurveval *= 1.0 + offsetval * 0.02;
        double basecurveval = 0.2 + rand.nextDouble(0.1);

        this.speed = 0.05 + speedval * 0.05;

        double xdiff = (this.x - this.session.model.position.x).toDouble();
        double ydiff = (this.y - this.session.model.position.y).toDouble();

        this.width = 110.0 + rand.nextDouble(110.0);
        this.length = Math.sqrt(xdiff*xdiff + ydiff*ydiff) * (0.8 + rand.nextDouble(0.4));

        double angle = Math.PI * 0.5 - Math.atan2(ydiff, xdiff);

        this.material = await THREE.makeShaderMaterial("shaders/tentacle.vert", "shaders/observatory_tentacle.frag")..transparent = true;
        THREE.setUniform(this.material, "size", new THREE.ShaderUniform<THREE.Vector2>()..value = new THREE.Vector2(this.width, this.length));
        THREE.setUniform(this.material, "total_curve", new THREE.ShaderUniform<double>()..value = angleval);
        THREE.setUniform(this.material, "total_offset", new THREE.ShaderUniform<double>()..value = offsetval);
        THREE.setUniform(this.material, "tip_curve_mult", new THREE.ShaderUniform<double>()..value = tipcurveval);
        THREE.setUniform(this.material, "tip_curve_exponent", new THREE.ShaderUniform<double>()..value = 2.0);
        THREE.setUniform(this.material, "base_curve_mult", new THREE.ShaderUniform<double>()..value = basecurveval);
        THREE.setUniform(this.material, "base_curve_exponent", new THREE.ShaderUniform<double>()..value = 2.0);
        THREE.setUniform(this.material, "tentacle_colour", new THREE.ShaderUniform<THREE.Vector4>()..value = new THREE.Vector4(0.0,0.0,0.0,1.0));
        THREE.setUniform(this.material, "glow_colour", new THREE.ShaderUniform<THREE.Vector4>()..value = new THREE.Vector4(1.0,1.0,1.0,0.1));
        THREE.setUniform(this.material, "glow_thickness", new THREE.ShaderUniform<double>()..value = 10.0);
        THREE.setUniform(this.material, "period", new THREE.ShaderUniform<double>()..value = 0.0);

        this.mesh = new THREE.Mesh(_geometry, material)..frustumCulled = false
            ..position.x = this.x..position.y = this.y..position.z = -10.0 + rand.nextDouble()
            ..rotation.x = Math.PI..rotation.z = angle;
    }
}

//##################################################################################

class ShipLogic {
    static Random _rand = new Random();

    static final double SCALE = 10.0;
    static final double BEAT_SCALE = 0.35;

    final ObservatoryViewer parent;
    ShipSound sound;

    bool active = false;

    THREE.Object3D shipModel;
    double angle = Math.PI * 1.4;
    THREE.Vector2 pos = new THREE.Vector2(0, 0);
    THREE.Vector2 vel = new THREE.Vector2(0, 0);
    double frictionForward = 0.998;
    double frictionSideways = 0.96;
    double frictionInactive = 0.965;
    double thrust = 5.0;
    static const double maxspeed = 750.0;
    double brake = 0.9;

    double angVel = 0.0;
    double angFriction = 0.925;
    double turnRateStopped = Math.PI / 15.0;
    double turnRateMax = Math.PI / 2.5;
    double speedForMaxTurn = 250.0;

    double drift = 0.0;
    double driftRaw = 0.0;
    double driftMult = 0.8;
    double driftSub = 5.0;
    double driftMinThreshold = 20.0;
    double driftMaxThreshold = 1000.0;

    double driftMusic = 0.0;
    double driftRawMusic = 0.0;
    double driftMultMusic = 0.95;
    double driftSubMusic = 1.0;
    double driftMinThresholdMusic = 100.0;
    double driftMaxThresholdMusic = 1500.0;

    double stepTime = 0.0;
    static const double stepLength = 0.05;

    int forward = 0;
    int turn = 0;

    ShipLogic(ObservatoryViewer this.parent) {}

    Future<Null> init() async {
        this.sound = new ShipSound(this.parent);
        await this.sound.init();

        Tuple<int,int> s4037 = SeedMapper.seed2coords(4037);
        this.pos..x = (s4037.first+0.45) * ObservatoryViewer.gridsize ..y = (s4037.second+0.4) * ObservatoryViewer.gridsize;

        shipModel = await Loader.getResource("models/overcoat.obj");
        THREE.Texture tex = new THREE.Texture(await Loader.getResource("images/textures/overcoat.png"))
            //..magFilter = THREE.NearestFilter
            //..minFilter = THREE.NearestFilter
            ..minFilter = THREE.LinearFilter
            ..needsUpdate = true;
        THREE.Material mat = new THREE.MeshBasicMaterial(new THREE.MeshBasicMaterialProperties(map: tex))
            ..side=THREE.DoubleSide
            ..transparent=true;
        for (THREE.Object3D o in shipModel.children) {
            if (o is THREE.Mesh) {
                o.material = mat;
            }
        }

        shipModel.scale..x=SCALE..y=SCALE..z=SCALE;
        shipModel.position..z = 250.0;
        shipModel.rotation..order = "ZYX";
    }

    void update([num dt]) {
        //if (!this.active) { return; }

        stepTime += dt;
        
        this.forward = ((this.parent.getKey(38) || this.parent.getKey(87)) ? 1 : 0) - ((this.parent.getKey(40) || this.parent.getKey(83)) ? 1 : 0);
        this.turn = ((this.parent.getKey(39) || this.parent.getKey(68)) ? 1 : 0) - ((this.parent.getKey(37) || this.parent.getKey(65)) ? 1 : 0);

        while (stepTime >= stepLength) {
            stepTime -= stepLength;

            this.physicsUpdate(stepLength);
        }

        this.sound.updateSound(dt);
        graphicsUpdate(stepTime);
    }

    void physicsUpdate(num dt) {
        angVel = angVel * angFriction;
        double turnfraction = (vel.length() / speedForMaxTurn).clamp(0.0, 1.0);
        double speedfraction = (vel.length() / maxspeed).clamp(0.0, 1.0);
        double turnrate = (1 - turnfraction) * turnRateStopped + turnfraction * turnRateMax;
        if (turn != 0) {
            angVel = (angVel + turnrate * 0.1 * turn).clamp(-turnrate, turnrate);
        }
        this.angle -= angVel * dt;

        THREE.Vector2 heading = new THREE.Vector2(Math.sin(angle), Math.cos(angle));
        THREE.Vector2 veldir = vel.clone().normalize();

        //double a = Math.atan2(veldir.x, veldir.y) - angle + Math.PI;
        //double angdiff = (a - (a/(Math.PI*2)).floorToDouble() * Math.PI * 2) - Math.PI;
        double angdiff = angleDiff(Math.atan2(veldir.x, veldir.y), angle);

        this.angVel -= angdiff * turnfraction * turnfraction * dt * 1.0;

        num dir = heading.dot(veldir);
        num absdir = dir.abs();
        num friction = absdir * frictionForward + (1-absdir) * frictionSideways;

        this.vel.multiplyScalar(friction);

        if (!this.active) {
            this.vel.multiplyScalar(frictionInactive);
        }

        if (forward == 1) {
            this.vel.addScaledVector(heading, thrust * forward);
        } else if (forward == -1) {
            this.vel.multiplyScalar(brake);
        }

        if (vel.length() > maxspeed) {
            vel.setLength(maxspeed);
        }

        this.pos.addScaledVector(this.vel, dt);

        // drift factor

        num speed = this.vel.length();

        this.driftRaw = Math.max(0.0, this.driftRaw * this.driftMult - this.driftSub);
        this.driftRawMusic = Math.max(0.0, this.driftRawMusic * this.driftMultMusic - this.driftSubMusic);

        this.driftRaw += speed * (1.0-absdir);
        this.driftRawMusic += speed * (1.0-absdir);

        if (driftRaw < 0.1) { driftRaw = 0.0; }
        if (driftRawMusic < 0.1) { driftRawMusic = 0.0; }

        this.drift = ((driftRaw - driftMinThreshold) / (driftMaxThreshold - driftMinThreshold)).clamp(0.0, 1.0);
        this.driftMusic = ((driftRawMusic - driftMinThresholdMusic) / (driftMaxThresholdMusic - driftMinThresholdMusic)).clamp(0.0, 1.0);

        // particle stuff

        int count = (turnfraction * (10.0 + (1.0-absdir) * 20.0)).floor();
        int spacefoam = 0xAAFFAA;
        int spacefoamdark = 0x508050;

        double s = -angdiff.sign;
        double trailmult = (0.2 + 0.8 * (1.0 - absdir)) * s;

        for (int i=0; i<count; i++) {

            double side = _rand.nextDouble(2.0) - 1.0;
            THREE.Vector2 offset = heading.clone().multiplyScalar(side * 25.0).addScaledVector(vel, -_rand.nextDouble(dt));
            double ol = (side * -2.0) * trailmult;

            this.parent.spawnParticle(pos.x + offset.x, pos.y + offset.y, 500.0, veldir.y * ol, -veldir.x * ol, 0, size: 5.0, life: 2.0 + _rand.nextDouble(4.0), posRand: 4.0 + 6.0 * turnfraction, velRand: 1.0 + 3.0 * speedfraction, turbulence: 0.2 + 0.3 * speedfraction, colour: spacefoam);
        }

        int wakecount = (10 * speedfraction * (1-drift)).floor();

        for (int i=0; i<wakecount; i++) {
            THREE.Vector2 offset = heading.clone().multiplyScalar(3.0).addScaledVector(vel, ((-(i+1)/wakecount)-1)*dt);
            double ol = 20.0 * trailmult;
            this.parent.spawnParticle(pos.x + offset.x + (veldir.y * 5 * s), pos.y + offset.y - (veldir.x * 5 * s), 500.0, veldir.y *  ol, -veldir.x *  ol, 0, size: 5.0, life: 5.0 * speedfraction, posRand: 2.0, velRand: 1.0 + 3.0 * speedfraction, turbulence: 0.2 + 0.3 * speedfraction, colour: spacefoam);
            this.parent.spawnParticle(pos.x + offset.x - (veldir.y * 5 * s), pos.y + offset.y + (veldir.x * 5 * s), 500.0, veldir.y * -ol, -veldir.x * -ol, 0, size: 5.0, life: 5.0 * speedfraction, posRand: 2.0, velRand: 1.0 + 3.0 * speedfraction, turbulence: 0.2 + 0.3 * speedfraction, colour: spacefoam);
        }

        int driftcount = (80.0 * drift).floor();
        double sprayspeed = (1.0 + 1.5 * drift) * dt;

        for (int i=0; i<driftcount; i++) {

            THREE.Vector2 offset = heading.clone().multiplyScalar((_rand.nextDouble(2.0) - 1.0) * 25.0).addScaledVector(veldir, 5.0 + _rand.nextDouble(5.0)).addScaledVector(vel, -_rand.nextDouble(dt));

            this.parent.spawnParticle(pos.x + offset.x, pos.y + offset.y, 500.0, vel.x * sprayspeed, vel.y * sprayspeed, 0, size: 5.0 + 3.0 * speedfraction, life: (0.5 + 1.0 * turnfraction) * (0.2 + 0.8 * _rand.nextDouble()), posRand: 1.5, velRand: 2.0 + 5.0 * drift, turbulence: 0.0, colour: spacefoamdark, smooth: true);
        }
    }

    void graphicsUpdate(double stepFraction) {
        setShipRotation();

        double s = SCALE - BEAT_SCALE * 0.5 + BEAT_SCALE * (1.0 - this.sound.beat);
        this.shipModel.scale..x=s..y=s..z=s;

        THREE.Vector2 modelpos = this.pos.clone().addScaledVector(this.vel, stepFraction);
        if (modelpos.x < 0) {
            modelpos.x += ObservatoryViewer.pixelsize;
        } else if(modelpos.x > ObservatoryViewer.pixelsize) {
            modelpos.x -= ObservatoryViewer.pixelsize;
        }
        if (modelpos.y < 0) {
            modelpos.y += ObservatoryViewer.pixelsize;
        } else if(modelpos.y > ObservatoryViewer.pixelsize) {
            modelpos.y -= ObservatoryViewer.pixelsize;
        }

        if (this.active) {
            parent.goToCoordinates(modelpos.x, modelpos.y);
        }

        this.shipModel.position..x = modelpos.x..y = modelpos.y;
    }

    void setShipRotation() {

        double sin = Math.sin(-angle);
        double cos = Math.cos(-angle);

        this.shipModel.rotation
            ..z = -this.angle
            ..y = -sin * Math.PI * 0.5
            ..x = cos.abs() * Math.PI * 0.03125
        ;
    }
}

class ShipSound {
    static const double BPM = 164.0;
    static const double BPS = BPM / 60.0;
    static const double BEAT_OFFSET = 0.3;

    final ObservatoryViewer parent;

    GainNode _volume;
    AudioBufferSourceNode _music;
    MuffleEffect _muffle;
    PannerNode _panning;

    double beat = 0.0;

    ShipSound(ObservatoryViewer this.parent) {}

    Future<Null> init() async {
        Audio.masterVolume.value = 0.0;
        _panning = Audio.context.createPanner()
            ..panningModel = "HRTF"
            ..distanceModel = "linear"
            ..maxDistance = 2000.0
            ..rolloffFactor = 1.0
            ..connectNode(Audio.output);

        _volume = Audio.context.createGain()..connectNode(_panning);
        _muffle = new MuffleEffect(0.0)..output.connectNode(_volume);
        _music = await Audio.load("audio/spiderblood")
            ..loop = true
        ;
        _music..connectNode(_muffle.input);

        this.updateSound();
        this.startSound();
    }

    bool _started = false;
    void startSound() {
        //print("starting music");
        //querySelector("#story")..append(_music);
        if (!_started) {
            beat = 0.02;
            _music.start(0);
            _started = true;
        }
        Audio.context.resume();
    }

    void updateSound([num dt = 0]) {
        double shipx = parent.overcoat.pos.x.toDouble();
        double shipy = parent.overcoat.pos.y.toDouble();
        double camx = parent.camx.toDouble();
        double camy = parent.camy.toDouble();

        _panning.setPosition(shipx, shipy, 0);
        Audio.context.listener.setPosition(camx, camy, 1000);

        if (parent.overcoat.active) {

            double speed = parent.overcoat.vel.length().toDouble();
            double fract = ((speed / (ShipLogic.maxspeed * 0.8)) + parent.overcoat.driftMusic * 0.35 ).clamp(0.0, 1.0);

            _volume.gain.value = 0.8 + 0.7 * fract;
            _muffle.value = (1.0 - fract) * 0.7;
        } else {
            _volume.gain.value = 0.25;
            _muffle.value = 1.0;
        }

        beat = (beat + dt * BPS) % 1.0;
    }
}

//##################################################################################

String binary(int n) {
    String s = n.toRadixString(2).padLeft(32, "0");

    return "b ${s.substring(0,8)} ${s.substring(8,16)} ${s.substring(16,24)} ${s.substring(24,32)}";
}

class SeedMapper {

    static Tuple<int,int> seed2coords(int seed) => Morton.deinterleave(Feistel.encrypt(seed));
    static int coords2seed(int x, int y) => Feistel.decrypt(Morton.interleave(x, y));

}

class Feistel {
    static const int levels = 4;
    static List<int> keys;

    static int encrypt(int n) {
        _makeKeyTable();

        for (int i=0; i<levels; i++) {
            int lower = n & 0xFFFF;

            int hashed = _fbox(lower, i);
            int shifted = hashed << 16;
            int mixed = n ^ shifted;

            n = _rotate32(mixed, 16);
        }

        return n;
    }

    static int decrypt(int n) {
        _makeKeyTable();

        n = _rotate32(n, 16);
        for (int i=0; i<levels; i++) {
            int lower = n & 0xFFFF;

            int hashed = _fbox(lower, levels - i - 1);
            int shifted = hashed << 16;
            int mixed = n ^ shifted;

            n = _rotate32(mixed, 16);
        }
        n = _rotate32(n, 16);

        return n;
    }

    static void _makeKeyTable() {
        if (keys != null) { return; }

        Random rand = new Random(13);

        keys = new List<int>(levels);

        for (int i=0; i<levels; i++) {
            keys[i] = rand.nextInt(0xFFFF);
        }
    }

    static int _fbox(int lower, int i) {
        Random rand = new Random(lower ^ keys[i]);

        int n = 0x1337;

        for (int j=0; j<i+1; j++) {
            n ^= rand.nextInt(0xFFFF);
        }

        return n;

        //return lower ^ keys[i];
    }

    static int _rotate32(int input, int amount) {
        return ((input >> (32 - amount)) | (input << amount)) & 0xFFFFFFFF;
    }
}

class Morton {
    static List<int> _lookup = <int>[
        0x0000, 0x0001, 0x0004, 0x0005, 0x0010, 0x0011, 0x0014, 0x0015,
        0x0040, 0x0041, 0x0044, 0x0045, 0x0050, 0x0051, 0x0054, 0x0055,
        0x0100, 0x0101, 0x0104, 0x0105, 0x0110, 0x0111, 0x0114, 0x0115,
        0x0140, 0x0141, 0x0144, 0x0145, 0x0150, 0x0151, 0x0154, 0x0155,
        0x0400, 0x0401, 0x0404, 0x0405, 0x0410, 0x0411, 0x0414, 0x0415,
        0x0440, 0x0441, 0x0444, 0x0445, 0x0450, 0x0451, 0x0454, 0x0455,
        0x0500, 0x0501, 0x0504, 0x0505, 0x0510, 0x0511, 0x0514, 0x0515,
        0x0540, 0x0541, 0x0544, 0x0545, 0x0550, 0x0551, 0x0554, 0x0555,
        0x1000, 0x1001, 0x1004, 0x1005, 0x1010, 0x1011, 0x1014, 0x1015,
        0x1040, 0x1041, 0x1044, 0x1045, 0x1050, 0x1051, 0x1054, 0x1055,
        0x1100, 0x1101, 0x1104, 0x1105, 0x1110, 0x1111, 0x1114, 0x1115,
        0x1140, 0x1141, 0x1144, 0x1145, 0x1150, 0x1151, 0x1154, 0x1155,
        0x1400, 0x1401, 0x1404, 0x1405, 0x1410, 0x1411, 0x1414, 0x1415,
        0x1440, 0x1441, 0x1444, 0x1445, 0x1450, 0x1451, 0x1454, 0x1455,
        0x1500, 0x1501, 0x1504, 0x1505, 0x1510, 0x1511, 0x1514, 0x1515,
        0x1540, 0x1541, 0x1544, 0x1545, 0x1550, 0x1551, 0x1554, 0x1555,
        0x4000, 0x4001, 0x4004, 0x4005, 0x4010, 0x4011, 0x4014, 0x4015,
        0x4040, 0x4041, 0x4044, 0x4045, 0x4050, 0x4051, 0x4054, 0x4055,
        0x4100, 0x4101, 0x4104, 0x4105, 0x4110, 0x4111, 0x4114, 0x4115,
        0x4140, 0x4141, 0x4144, 0x4145, 0x4150, 0x4151, 0x4154, 0x4155,
        0x4400, 0x4401, 0x4404, 0x4405, 0x4410, 0x4411, 0x4414, 0x4415,
        0x4440, 0x4441, 0x4444, 0x4445, 0x4450, 0x4451, 0x4454, 0x4455,
        0x4500, 0x4501, 0x4504, 0x4505, 0x4510, 0x4511, 0x4514, 0x4515,
        0x4540, 0x4541, 0x4544, 0x4545, 0x4550, 0x4551, 0x4554, 0x4555,
        0x5000, 0x5001, 0x5004, 0x5005, 0x5010, 0x5011, 0x5014, 0x5015,
        0x5040, 0x5041, 0x5044, 0x5045, 0x5050, 0x5051, 0x5054, 0x5055,
        0x5100, 0x5101, 0x5104, 0x5105, 0x5110, 0x5111, 0x5114, 0x5115,
        0x5140, 0x5141, 0x5144, 0x5145, 0x5150, 0x5151, 0x5154, 0x5155,
        0x5400, 0x5401, 0x5404, 0x5405, 0x5410, 0x5411, 0x5414, 0x5415,
        0x5440, 0x5441, 0x5444, 0x5445, 0x5450, 0x5451, 0x5454, 0x5455,
        0x5500, 0x5501, 0x5504, 0x5505, 0x5510, 0x5511, 0x5514, 0x5515,
        0x5540, 0x5541, 0x5544, 0x5545, 0x5550, 0x5551, 0x5554, 0x5555
    ];

    static int interleave(int x, int y) {
        return _lookup[y >> 8] << 17 |
        _lookup[x >> 8] << 16 |
        _lookup[y & 0xFF] << 1 |
        _lookup[x & 0xFF];
    }

    static int _demorton(int x) {
        x = x & 0x55555555;
        x = (x | (x >> 1)) & 0x33333333;
        x = (x | (x >> 2)) & 0x0F0F0F0F;
        x = (x | (x >> 4)) & 0x00FF00FF;
        x = (x | (x >> 8)) & 0x0000FFFF;
        return x;
    }

    static Tuple<int, int> deinterleave(int z) {
        int x = _demorton(z);
        int y = _demorton(z >> 1);
        return new Tuple<int, int>(x, y);
    }
}
