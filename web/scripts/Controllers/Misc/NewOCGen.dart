import '../../SBURBSim.dart';
import '../../navbar.dart';
import 'dart:html';

/*
    TODO:
    Have drop down for class, aspect, species, interest cat 1 and interest cat 2.

    in canvas, display 3 sprites (one of each type), title (in aspect color),
    specific interests, chat handle, moon,
    and then land facts
    Name, denizen, consorts, and then sample smells, feels, sounds.
    Then pick three example quest chains that are valid for the player.
 */

int numPlayers = 4;
List<Player> players = new List<Player>(numPlayers);
int canvasWidth = 1000;
int canvasHeight = 400;
Random rand = new Random();

Session curSessionGlobalVar;
main() {
    loadNavbar();
    window.onError.listen((Event event){
        ErrorEvent e = event as ErrorEvent;
        printCorruptionMessage(e);
        return;
    });

    globalInit();
    curSessionGlobalVar = new Session(rand.nextInt());
    loadFuckingEverything("I really should stop doing this",start );

}

void start() {
    createDropDowns();
    initPlayers();
    ButtonElement button = querySelector("#reroll");
    button.onClick.listen((e) => initPlayers());
}

void initPlayers() {
    for(int i = 0; i< numPlayers; i++) {
        players[i] =(randomPlayer(curSessionGlobalVar));
    }
    redrawPlayers();
}

void drawPlayers() {
    CanvasElement spriteTemplate = querySelector("#sprite_template");
    Element container = querySelector("#container");
    container.setInnerHtml(""); //clear it out.
    for(int i = 0; i<numPlayers; i++) {
        //get canvas, draw player from scratch.
        CanvasElement canvas = new CanvasElement(width: canvasWidth, height: canvasHeight);
        print("canvas is $canvas");
        CanvasElement godBuffer = Drawing.getBufferCanvas(spriteTemplate);
        CanvasElement regBuffer = Drawing.getBufferCanvas(spriteTemplate);
        CanvasElement dreamBuffer = Drawing.getBufferCanvas(spriteTemplate);
        Player p = players[i];
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
        container.append(canvas);
    }
}

void redrawPlayers() {
    Aspect aspect = getAspectFromDropDown();
    SBURBClass class_name = getClassFromDropDown();
    InterestCategory interest1 = getInterest1FromDropDown();
    InterestCategory interest2 = getInterest2FromDropDown();
    String species = (querySelector("#species") as SelectElement).selectedOptions[0].value;
    String bloodColor = (querySelector("#blood") as SelectElement).selectedOptions[0].value;
    print("aspect is ${aspect}");
    setPlayers(aspect, class_name, interest1, interest2, species, bloodColor);
}

Aspect getAspectFromDropDown() {
    String aspectString = (querySelector("#aspect") as SelectElement).selectedOptions[0].value;
    if(aspectString == "Any") return Aspects.NULL;
    return Aspects.stringToAspect(aspectString);
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

void setPlayers(Aspect aspect, SBURBClass class_name, InterestCategory intCat1, InterestCategory intCat2, String species, String blood) {
    //if something is null, then randomize that shit for each player
    for(Player p in players) {
        p.aspect = aspect;
        if(aspect == Aspects.NULL) p.aspect = rand.pickFrom(Aspects.all);

        p.class_name = class_name;
        if(class_name == SBURBClassManager.NULL) p.class_name = rand.pickFrom(SBURBClassManager.all);

    }

    drawPlayers();
}

//gonna try to do this without raw html manipulation as an exercise
void createDropDowns() {
    aspectDropDown();
    classDropDown();
    speciesDropDown();
    bloodDropDown();
    interest1DropDown();
    interest2DropDown();
}

void aspectDropDown() {
    selectElementThatRedrawsPlayers(querySelector("#aspectList"), new List<Aspect>.from(Aspects.all), "aspect");
}

void classDropDown() {
    selectElementThatRedrawsPlayers(querySelector("#classList"), new List<SBURBClass>.from(SBURBClassManager.all), "class");
}

void interest1DropDown() {
    selectElementThatRedrawsPlayers(querySelector("#interest1List"), new List<InterestCategory>.from(InterestManager.allCategories), "interest1");
}

void interest2DropDown() {
    selectElementThatRedrawsPlayers(querySelector("#interest2List"), new List<InterestCategory>.from(InterestManager.allCategories), "interest2");
}

void speciesDropDown() {
    selectElementThatRedrawsPlayers(querySelector("#speciesList"), <String>["Human", "Troll"], "species");
}

void bloodDropDown() {
    selectElementThatRedrawsPlayers(querySelector("#colorList"), bloodColors, "blood");
}

void selectElementThatRedrawsPlayers<T>(Element div, List<T> list, String name) {
    SelectElement selectElement = genericDropDown(div, list,  name);
    selectElement.onChange.listen((e) => redrawPlayers());
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