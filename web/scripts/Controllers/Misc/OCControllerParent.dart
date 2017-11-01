import 'dart:html';
import 'dart:math' as Math;
import '../../SBURBSim.dart';
import '../../navbar.dart';

class OCGenerator {

    Element form;
    int numPlayers = 4;
    List<Player> players = null;
    int canvasWidth = 1000;
    int canvasHeight = 600;
    Random rand = new Random();
    Session session;

    OCGenerator(this.numPlayers, [int session_id = -13])

    {
         players = new List<Player>(numPlayers);
         form = querySelector("#form");
         if(session_id < 0) session_id  = rand.nextInt();

         session = new Session(session_id);

    }


    void start() {
        createDropDowns();
        initPlayers();
        ButtonElement button = querySelector("#reroll");
        button.onClick.listen((e) => initPlayers());
    }

    void initPlayers() {
        session = new Session(rand.nextInt());
        for(int i = 0; i< numPlayers; i++) {
            players[i] =(randomPlayer(session));
        }
        redrawPlayers();
    }

    void drawPlayers() {
        CanvasElement spriteTemplate = querySelector("#sprite_template");
        Element container = querySelector("#container");
        container.setInnerHtml(""); //clear it out.
        for(int i = 0; i<numPlayers; i++) {
            drawPlayer(players[i], spriteTemplate, container);
        }
    }

    void drawPlayer(Player p, CanvasElement spriteTemplate, Element container) {
        //get canvas, draw player from scratch.
        CanvasElement canvas = new CanvasElement(width: canvasWidth, height: canvasHeight);
        Drawing.drawSolidBG(canvas, ReferenceColours.WHITE);
        print("canvas is $canvas");
        CanvasElement godBuffer = Drawing.getBufferCanvas(spriteTemplate);
        CanvasElement regBuffer = Drawing.getBufferCanvas(spriteTemplate);
        CanvasElement dreamBuffer = Drawing.getBufferCanvas(spriteTemplate);
        p.isDreamSelf = false;
        p.godTier = false;
        Drawing.drawSpriteFromScratch(regBuffer, p);
        p.isDreamSelf = true;
        Drawing.drawSpriteFromScratch(dreamBuffer, p);
        p.godTier = true;
        Drawing.drawSpriteFromScratch(godBuffer, p);

        Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, godBuffer, 500,0);
        Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, dreamBuffer, 200,0);
        Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, regBuffer, -100,0);
        drawText(p, canvas);
        container.append(canvas);
    }

    void drawText(Player p, CanvasElement canvas) {
        CanvasRenderingContext2D ctx = canvas.context2D;
        int start = 400;
        int space_between_lines = 25;
        int left_margin = 10;
        int right_margin = 210;
        int line_height = 18;
        int current = 350;

        int line_num = 2;
        ctx.font = "40px Times New Roman";
        ctx.fillStyle = p.aspect.palette.text.toStyleString();
        ctx.fillText(p.titleBasic(),left_margin*2,current);
        ctx.font = "18px Times New Roman";
        ctx.fillStyle = "#000000";


        ctx.fillText("ChatHandle: ", left_margin, current + line_height * line_num);
        ctx.fillText(p.chatHandle, right_margin, current + line_height * line_num);
        line_num++;

        ctx.fillText("Interests: ", left_margin, current + line_height * line_num);
        ctx.fillText("${p.interest1.name} and ${p.interest2.name}", right_margin, current + line_height * line_num);
        line_num++;
        line_num++;
        left_margin = 25; //indenting for land shit.

        ctx.fillText("Land: ", left_margin, current + line_height * line_num);
        ctx.fillText(p.land.name, right_margin, current + line_height * line_num);
        line_num++;
        left_margin = 35; //indenting for land shit.

        ctx.fillText("Denizen: ", left_margin, current + line_height * line_num);
        ctx.fillText(sanitizeString(p.land.denizenFeature.name), right_margin, current + line_height * line_num);
        line_num++;

        ctx.fillText("Consorts: ", left_margin, current + line_height * line_num);
        ctx.fillText("${p.land.consortFeature.name}s who ${p.land.consortFeature.sound}", right_margin, current + line_height * line_num);
        line_num++;

        ctx.fillText("Smells Like: ", left_margin, current + line_height * line_num);
        ctx.fillText(turnArrayIntoHumanSentence(getSampleSmells(p.land)), right_margin, current + line_height * line_num);
        line_num++;

        ctx.fillText("Sounds Like: ", left_margin, current + line_height * line_num);
        ctx.fillText(turnArrayIntoHumanSentence(getSampleSounds(p.land)), right_margin, current + line_height * line_num);
        line_num++;

        ctx.fillText("Feels Like: ", left_margin, current + line_height * line_num);
        ctx.fillText(turnArrayIntoHumanSentence(getSampleFeels(p.land)), right_margin, current + line_height * line_num);
        line_num++;

        ctx.fillText("Example Quests: ", left_margin, current + line_height * line_num);
        ctx.fillText(turnArrayIntoHumanSentence(getSampleQuests(p)), right_margin, current + line_height * line_num);
        line_num++;
    }

    List<String> getSampleQuests(Player player) {
        List<String> ret = new List<String>();
        ret.add(player.land.selectQuestChainFromSource([player], player.land.firstQuests).name);
        ret.add(player.land.selectQuestChainFromSource([player], player.land.secondQuests).name);
        ret.add(player.land.selectQuestChainFromSource([player], player.land.thirdQuests).name);
        return ret;
    }

    List<String> getSampleSmells(Land land) {
        WeightedList<SmellFeature> smells = new WeightedList<SmellFeature>.from(land.smells);
        smells.sortByWeight(true);
        List<String> ret = new List<String>();
        int max = Math.min(smells.length, 2);
        for(int i = 0; i<max; i++) {
            ret.add(smells[i].simpleDesc);
        }
        return ret;
    }

    List<String> getSampleSounds(Land land) {
        WeightedList<SoundFeature> stuff = new WeightedList<SoundFeature>.from(land.sounds);
        stuff.sortByWeight(true);
        List<String> ret = new List<String>();
        int max = Math.min(stuff.length, 2);
        for(int i = 0; i<max; i++) {
            ret.add(stuff[i].simpleDesc);
        }
        return ret;
    }

    List<String> getSampleFeels(Land land) {
        WeightedList<AmbianceFeature> stuff = new WeightedList<AmbianceFeature>.from(land.feels);
        stuff.sortByWeight(true);
        List<String> ret = new List<String>();
        int max = Math.min(stuff.length, 2);
        for(int i = 0; i<max; i++) {
            ret.add(stuff[i].simpleDesc);
        }
        return ret;
    }

    void redrawPlayers() {
        Aspect aspect = getAspectFromDropDown();
        SBURBClass class_name = getClassFromDropDown();
        InterestCategory interest1 = getInterest1FromDropDown();
        InterestCategory interest2 = getInterest2FromDropDown();
        Moon moon = getMoonFromDropDown();
        String species = (querySelector("#species") as SelectElement).selectedOptions[0].value;
        String bloodColor = (querySelector("#blood") as SelectElement).selectedOptions[0].value;
        print("aspect is ${aspect}");
        setPlayers(aspect, class_name, interest1, interest2, moon, species, bloodColor);
    }

    Aspect getAspectFromDropDown() {
        String aspectString = (querySelector("#aspect") as SelectElement).selectedOptions[0].value;
        if(aspectString == "Any") return Aspects.NULL;
        return Aspects.stringToAspect(aspectString);
    }

    Moon getMoonFromDropDown() {
        String string = (querySelector("#moon") as SelectElement).selectedOptions[0].value;
        if(string == "Any") return null;
        return session.stringToMoon(string);
    }

    SBURBClass getClassFromDropDown() {
        String classString = (querySelector("#class") as SelectElement).selectedOptions[0].value;
        if(classString == "Any") return SBURBClassManager.NULL;
        return SBURBClassManager.stringToSBURBClass(classString);
    }

    InterestCategory getInterest1FromDropDown() {
        String string = (querySelector("#interest1") as SelectElement).selectedOptions[0].value;
        if(string == "Any") return InterestManager.NULL;
        return InterestManager.getCategoryFromString(string);
    }

    InterestCategory getInterest2FromDropDown() {
        String string = (querySelector("#interest2") as SelectElement).selectedOptions[0].value;
        if(string == "Any") return InterestManager.NULL;
        return InterestManager.getCategoryFromString(string);
    }

    void setPlayers(Aspect aspect, SBURBClass class_name, InterestCategory intCat1, InterestCategory intCat2, Moon moon,String species, String blood) {
        //if something is null, then randomize that shit for each player
        for(Player p in players) {
            p.aspect = aspect;
            if(aspect == Aspects.NULL) p.aspect = rand.pickFrom(Aspects.all);

            p.class_name = class_name;
            if(class_name == SBURBClassManager.NULL) p.class_name = rand.pickFrom(SBURBClassManager.all);

            p.moon = moon;
            if(moon == null) p.moon = rand.pickFrom(session.moons);

            if(species == "Any") {
                p.isTroll = rand.nextBool();
            }else if(species == "Troll") {
                p.isTroll = true;
            }else {
                p.isTroll = false;
            }

            if(p.isTroll) {
                p.hairColor = "#000000";
                p.bloodColor = rand.pickFrom(bloodColors);
            }
            //will overright random blood color
            p.bloodColor = blood;
            if(blood == "Any") p.bloodColor = rand.pickFrom(bloodColors);

            if(intCat1 == InterestManager.NULL) {
                p.interest1 = InterestManager.getRandomInterest(rand);
            }else {
                p.interest1 = new Interest.randomFromCategory(rand, intCat1);
            }

            if(intCat2 == InterestManager.NULL) {
                p.interest2 = InterestManager.getRandomInterest(rand);
            }else {
                p.interest2 = new Interest.randomFromCategory(rand, intCat2);
            }
            p.initialize();


        }

        drawPlayers();
    }

//gonna try to do this without raw html manipulation as an exercise
    void createDropDowns() {
        aspectDropDown();
        classDropDown();
        speciesDropDown();
        bloodDropDown();
        moonDropDown();
        interest1DropDown();
        interest2DropDown();
    }

    void moonDropDown() {
        selectElementThatRedrawsPlayers(holderElement("Moon"), new List<Moon>.from(session.moons), "moon");
    }

    void aspectDropDown() {
        selectElementThatRedrawsPlayers(holderElement("Aspect"), new List<Aspect>.from(Aspects.all), "aspect");
    }

    void classDropDown() {
        selectElementThatRedrawsPlayers(holderElement("Class"), new List<SBURBClass>.from(SBURBClassManager.all), "class");
    }

    void interest1DropDown() {
        selectElementThatRedrawsPlayers(holderElement("Interest1"), new List<InterestCategory>.from(InterestManager.allCategories), "interest1");
    }

    void interest2DropDown() {
        selectElementThatRedrawsPlayers(holderElement("Interest2"), new List<InterestCategory>.from(InterestManager.allCategories), "interest2");
    }

    void speciesDropDown() {
        selectElementThatRedrawsPlayers(holderElement("Species"), <String>["Human", "Troll"], "species");
    }

    void bloodDropDown() {
        selectElementThatRedrawsPlayers(holderElement("Blood"), bloodColors, "blood");
    }

    void selectElementThatRedrawsPlayers<T>(Element div, List<T> list, String name) {
        SelectElement selectElement = genericDropDown(div, list,  name);
        selectElement.onChange.listen((e) => redrawPlayers());
    }

    DivElement holderElement(String name) {
        print("trying to make holder leement named $name");
        Element divElement = new DivElement();
        divElement.classes.add("ocElement");
        divElement.setInnerHtml(name);
        form.append(divElement);
        return divElement;
    }

//whoever calls me is responsible for wiring it up
    SelectElement genericDropDown<T> (Element div, List<T> list, String name)
    {
        SelectElement selector = new SelectElement()
            ..name = name
            ..id = name;

        OptionElement defaultOption = new OptionElement()
            ..value = "Any"
            ..setInnerHtml("Any")
            ..selected = true;
        selector.add(defaultOption,null);
        for(Object a in list) {
            OptionElement o = new OptionElement()
                ..value = a.toString()
                ..setInnerHtml(a.toString());
            selector.add(o,null);
        }
        div.append(selector);
        return selector;
    }
}