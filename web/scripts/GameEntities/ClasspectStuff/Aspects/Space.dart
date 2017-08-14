import 'Aspect.dart';

class Space extends Aspect {

    @override
    double aspectQuestChance = 1.0; // No items. Frogs only. FINAL DESTINATION.

    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Space', 'Gaea', 'Nut', 'Echidna', 'Wadjet', 'Qetesh', 'Ptah', 'Geb', 'Fryja', 'Atlas', 'Hebe', 'Lork', 'Eve', 'Genesis', 'Morpheus', 'Veles ', 'Arche', 'Rekinom', 'Iago', 'Pilera', 'Tiamat', 'Gilgamesh', 'Implexel']);

    Space(int id):super(id, "Space", isCanon:true);

}