import 'Aspect.dart';

class Heart extends Aspect {

    @override
    bool deadpan = true; // heart cares not for your trickster bullshit

    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Heart', 'Aphrodite', 'Baldur', 'Eros', 'Hathor', 'Philotes', 'Anubis', 'Psyche', 'Mora', 'Isis', 'Jupiter', 'Narcissus', 'Hecate', 'Izanagi', 'Izanami', 'Ishtar', 'Anteros', 'Agape', 'Peitho', 'Mahara', 'Naidraug', 'Snoitome', 'Walthidian', 'Slanesh', 'Benu']);

    Heart(int id):super(id, "Heart", isCanon:true);

}