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
    Session session;
    SelectElement aspectSelect;
    SelectElement classSelect;
    SelectElement speciesSelect;
    SelectElement bloodSelect;
    SelectElement moonSelect;
    SelectElement interest1Select;
    SelectElement interest2Select;
    SelectElement hairSelect;
    SelectElement leftHornSelect;
    SelectElement rightHornSelect;
    SelectElement favoriteNumberSelect;
    InputElement hairColorPicker;
    TextInputElement chatHandleElement;


    OCGenerator(this.numPlayers, [int session_id = -13])

    {
         players = new List<Player>(numPlayers);
         form = querySelector("#form");
         if(session_id < 0) session_id  = int.parse(todayToSession());

         session = new Session(session_id);

    }

    Random get rand => session.rand;


    void start() {
        createDropDowns();
        initPlayers();
        ButtonElement button = querySelector("#reroll");
        button.onClick.listen((e) => initPlayers());
    }

    void initPlayers() {
        if(session != null) session.resetAvailableClasspects();
        session.setupMoons("initing players");
        for(int i = 0; i< numPlayers; i++) {
            //NOT doing this was causing oc gen to crash when it ran out of classpects.
            players[i] =(randomPlayer(session));
        }
        redrawPlayers();
    }

    void drawPlayers() {
        Element container = querySelector("#container");
        container.setInnerHtml(""); //clear it out.
        for(int i = 0; i<numPlayers; i++) {
            drawPlayer(players[i], container);
        }
    }

    void drawPlayer(Player p, Element container) {
        //get canvas, draw player from scratch.
        CanvasElement canvas = new CanvasElement(width: canvasWidth, height: canvasHeight);
        Drawing.drawSolidBG(canvas, ReferenceColours.WHITE);

        CanvasElement godBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
        CanvasElement regBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
        CanvasElement dreamBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
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

    void chatHandle() {
        chatHandleElement = textElementThatRedrawsPlayers(holderElement("chatHandle/Name"), new List<SBURBClass>.from(SBURBClassManager.all), "chatHandle");
    }


    TextInputElement textElementThatRedrawsPlayers<T>(Element div, List<T> list, String name) {
        TextInputElement selectElement = genericTextElement(div, list,  name);
        selectElement.onChange.listen((e) => redrawPlayers());
        return selectElement;
    }


//whoever calls me is responsible for wiring it up
    TextInputElement genericTextElement<T> (Element div, List<T> list, String name)
    {
        TextInputElement selector = new TextInputElement()
            ..name = name
            ..id = name;
        div.append(selector);
        return selector;
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


    Aspect getAspectFromDropDown() {
        String aspectString = aspectSelect.selectedOptions[0].value;
        if(aspectString == "Any") return Aspects.NULL;
        return Aspects.stringToAspect(aspectString);
    }

    Moon getMoonFromDropDown() {
        String string = moonSelect.selectedOptions[0].value;
        if(string == "Any") return null;
        return session.stringToMoon(string);
    }

    SBURBClass getClassFromDropDown() {
        String classString = classSelect.selectedOptions[0].value;
        if(classString == "Any") return SBURBClassManager.NULL;
        return SBURBClassManager.stringToSBURBClass(classString);
    }

    InterestCategory getInterest1FromDropDown() {
        String string = interest1Select.selectedOptions[0].value;
        if(string == "Any") return InterestManager.NULL;
        return InterestManager.getCategoryFromString(string);
    }

    InterestCategory getInterest2FromDropDown() {
        String string = interest2Select.selectedOptions[0].value;
        if(string == "Any") return InterestManager.NULL;
        return InterestManager.getCategoryFromString(string);
    }

    void hairDropDown() {
        List<int> hairs = new List<int>();
        for(int i = 0; i<Player.maxHairNumber; i++) {
            hairs.add(i);
        }
        Element divElement = new DivElement();
        divElement.setInnerHtml("Hair");

        hairSelect = selectElementThatRedrawsPlayers(holderElement("Hair"), hairs, "hair");
    }

    void favNumberDropDown() {
        List<int> wings = new List<int>();
        for(int i = 0; i<12; i++) {
            wings.add(i);
        }
        Element divElement = new DivElement();
        divElement.setInnerHtml("Wings");

        favoriteNumberSelect = selectElementThatRedrawsPlayers(holderElement("Wings"), wings, "favNum");
    }

    void leftHornDropDown() {
        List<int> hairs = new List<int>();
        for(int i = 0; i<Player.maxHornNumber; i++) {
            hairs.add(i);
        }
        Element divElement = new DivElement();
        divElement.setInnerHtml("LeftHorn");

        leftHornSelect = selectElementThatRedrawsPlayers(holderElement("LeftHorn"), hairs, "hair");
    }

    void rightHornDropDown() {
        List<int> hairs = new List<int>();
        for(int i = 0; i<Player.maxHornNumber; i++) {
            hairs.add(i);
        }
        Element divElement = new DivElement();
        divElement.setInnerHtml("RightHorn");

        rightHornSelect = selectElementThatRedrawsPlayers(holderElement("RightHorn"), hairs, "hair");
    }

    void setPlayer(Player p) {
        setSpecies(p); //do before blood.
        setAspect(p);
        setClass(p);
        setInterests(p);
        setBlood(p);
        setHair(p);
        setHairColor(p);
        setHorns(p);
        setMoon(p);
        setFavNumber(p);
        setChatHandle(p);
        p.initialize();
    }

    void setChatHandle(Player p) {
        String tmp = chatHandleElement.value; //if it's empty, don't replace
        if(tmp.isNotEmpty) {
            p.deriveChatHandle = false;
            p.chatHandle = chatHandleElement.value;
        }else {
            p.deriveChatHandle = true;
        }
    }

    void setBlood(Player p) {
        String blood = bloodSelect.selectedOptions[0].value;
        if(p.isTroll) {
            p.hairColor = "#000000";
            p.bloodColor = rand.pickFrom(bloodColors);
        }
        //will overright random blood color
        p.bloodColor = blood;
        if(blood == "Any") p.bloodColor = rand.pickFrom(bloodColors);
    }

    void setHairColor(Player p) {
        p.hairColor= hairColorPicker.value;
    }

    void setHair(Player p) {
        String hair = hairSelect.selectedOptions[0].value;
        int h = 0;
        if(hair == "Any") {
            h = rand.nextInt(Player.maxHairNumber)+1;
        }else {
            h = int.parse(hair);
        }
        p.hair = h;
    }

    void setFavNumber(Player p) {
        String numb = favoriteNumberSelect.selectedOptions[0].value;
        int h = 0;
        if(numb == "Any") {
            h = rand.nextInt(12);
        }else {
            h = int.parse(numb);
        }

        p.quirk.favoriteNumber = h;
    }

    void setHorns(Player p) {
        String leftHornValue = leftHornSelect.selectedOptions[0].value;
        String rightHornValue = rightHornSelect.selectedOptions[0].value;
        int randNum = rand.nextInt(Player.maxHornNumber)+1;

        int lh = randNum;
        int rh = randNum;
        if(leftHornValue != "Any") {
            lh = int.parse(leftHornValue);
        }

        if(rightHornValue != "Any") {
            rh = int.parse(rightHornValue);
        }
        p.leftHorn = lh;
        p.rightHorn = rh;
    }

    void setMoon(Player p) {
        p.moon = getMoonFromDropDown();
        if(p.moon == null) p.moon = rand.pickFrom(session.moons);
    }

    void setSpecies(Player p) {
        String species = speciesSelect.selectedOptions[0].value;
        if(species == "Any") {
            p.isTroll = rand.nextBool();
        }else if(species == "Troll") {
            p.isTroll = true;
        }else {
            p.isTroll = false;
        }
    }

    void setAspect(Player p) {
        p.aspect = getAspectFromDropDown();
        if(p.aspect == Aspects.NULL) p.aspect = rand.pickFrom(Aspects.all);
    }

    void setClass(Player p) {
        p.class_name = getClassFromDropDown();
        if(p.class_name == SBURBClassManager.NULL) p.class_name = rand.pickFrom(SBURBClassManager.all);
    }

    void setInterests(Player p) {
        InterestCategory intCat1 = getInterest1FromDropDown();
        InterestCategory intCat2 = getInterest2FromDropDown();
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
    }


    void redrawPlayers() {
        for(Player p in players) {
            setPlayer(p);
        }
        drawPlayers();
    }

//gonna try to do this without raw html manipulation as an exercise
    void createDropDowns() {
        //order matters here
        classDropDown();
        aspectDropDown();
        speciesDropDown();
        bloodDropDown();
        moonDropDown();
        interest1DropDown();
        interest2DropDown();
        hairDropDown();
        hairColorPickerElement();
        leftHornDropDown();
        rightHornDropDown();
        favNumberDropDown();
        chatHandle();
    }

    void hairColorPickerElement() {
        hairColorPicker = colorPickerThatRedrawsPlayers(holderElement("Hair Color"), new List<Moon>.from(session.moons), "hairColor");
        hairColorPicker.value = "#000000";
    }

    void moonDropDown() {
        session.setupMoons("making moon drop down");
        moonSelect = selectElementThatRedrawsPlayers(holderElement("Moon"), new List<Moon>.from(session.moons), "moon");
    }

    void aspectDropDown() {
        aspectSelect = selectElementThatRedrawsPlayers(holderElement("Aspect"), new List<Aspect>.from(Aspects.all), "aspect");
    }

    void classDropDown() {
        classSelect = selectElementThatRedrawsPlayers(holderElement("Class"), new List<SBURBClass>.from(SBURBClassManager.all), "class");
    }

    void interest1DropDown() {
        interest1Select = selectElementThatRedrawsPlayers(holderElement("Interest1"), new List<InterestCategory>.from(InterestManager.allCategories), "interest1");
    }

    void interest2DropDown() {
        interest2Select = selectElementThatRedrawsPlayers(holderElement("Interest2"), new List<InterestCategory>.from(InterestManager.allCategories), "interest2");
    }

    void speciesDropDown() {
       speciesSelect =  selectElementThatRedrawsPlayers(holderElement("Species"), <String>["Human", "Troll"], "species");
    }

    void bloodDropDown() {
        bloodSelect = selectElementThatRedrawsPlayers(holderElement("Blood"), bloodColors, "blood");
    }

    SelectElement selectElementThatRedrawsPlayers<T>(Element div, List<T> list, String name) {
        SelectElement selectElement = genericDropDown(div, list,  name);
        selectElement.onChange.listen((e) => redrawPlayers());
        return selectElement;
    }

    InputElement colorPickerThatRedrawsPlayers<T>(Element div, List<T> list, String name) {
        InputElement selectElement = genericColorPicker(div, list,  name);
        selectElement.onChange.listen((e) => redrawPlayers());
        return selectElement;
    }

    DivElement holderElement(String name) {
        Element divElement = new DivElement();
        divElement.classes.add("ocElement");
        divElement.setInnerHtml("<div class = 'label'>$name</div>");
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

    InputElement genericColorPicker<T> (Element div, List<T> list, String name)
    {
        InputElement selector = new InputElement()
            ..name = name
            ..type = "color"
            ..id = name;

        div.append(selector);
        return selector;
    }
}