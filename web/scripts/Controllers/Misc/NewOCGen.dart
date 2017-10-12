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

main() {
    loadNavbar();
    window.onError.listen((Event event){
        ErrorEvent e = event as ErrorEvent;
        printCorruptionMessage(e);
        return;
    });

    globalInit();
    Element div = querySelector("#story");
    createDropDowns();
}

//gonna try to do this without raw html manipulation as an exercise
void createDropDowns() {
    aspectDropDown();
}

void aspectDropDown() {
    genericDropDown(querySelector("#aspectList"), new List<Aspect>.from(Aspects.all), "aspect");
}

void genericDropDown<T> (Element div, List<T> list, String name)
{
    SelectElement aspectSelector = new SelectElement()
        ..name = name
        ..id = name;

    OptionElement defaultOption = new OptionElement()
        ..value = "Any"
        ..setInnerHtml("Any")
        ..selected = true;
    aspectSelector.add(defaultOption,null);
    for(Object a in list) {
        OptionElement o = new OptionElement()
            ..value = a.toString()
            ..setInnerHtml(a.toString());
        aspectSelector.add(o,null);
    }
    div.append(aspectSelector);
}