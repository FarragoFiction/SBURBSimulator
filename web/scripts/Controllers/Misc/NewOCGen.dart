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

Session curSessionGlobalVar;
main() {
    loadNavbar();
    window.onError.listen((Event event){
        ErrorEvent e = event as ErrorEvent;
        printCorruptionMessage(e);
        return;
    });

    globalInit();
    curSessionGlobalVar = new Session(12345);
    loadFuckingEverything("I really should stop doing this",start );

}

void start() {
    initPlayers();
    drawPlayers();
    createDropDowns();
}

void initPlayers() {
    for(int i = 0; i< numPlayers; i++) {
        players[i] =(randomPlayer(curSessionGlobalVar));
    }
}

void drawPlayers() {
    CanvasElement spriteTemplate = querySelector("#sprite_template");
    Element container = querySelector("#container");
    for(int i = 0; i<numPlayers; i++) {
        //get canvas, draw player from scratch.
        CanvasElement canvas = new CanvasElement(width: canvasWidth, height: canvasHeight);
        print("canvas is $canvas");
        CanvasElement godBuffer = Drawing.getBufferCanvas(spriteTemplate);
        CanvasElement regBuffer = Drawing.getBufferCanvas(spriteTemplate);
        CanvasElement dreamBuffer = Drawing.getBufferCanvas(spriteTemplate);
        Player p = players[i];
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

void setPlayers(Aspect aspect, SBURBClass class_name, InterestCategory intCat1, InterestCategory intCat2, String species, String blood) {

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
    genericDropDown(querySelector("#aspectList"), new List<Aspect>.from(Aspects.all), "aspect");
}

void classDropDown() {
    genericDropDown(querySelector("#classList"), new List<SBURBClass>.from(SBURBClassManager.all), "class");
}

void interest1DropDown() {
    genericDropDown(querySelector("#interest1List"), new List<InterestCategory>.from(InterestManager.allCategories), "interest1");
}

void interest2DropDown() {
    genericDropDown(querySelector("#interest2List"), new List<InterestCategory>.from(InterestManager.allCategories), "interest2");
}

void speciesDropDown() {
    genericDropDown(querySelector("#speciesList"), <String>["Human", "Troll"], "species");
}

void bloodDropDown() {
    genericDropDown(querySelector("#colorList"), bloodColors, "blood");
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