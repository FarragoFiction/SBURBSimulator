import 'Aspect.dart';

class Life extends Aspect {

    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Life', 'Demeter', 'Pan', 'Nephthys', 'Ceres', 'Isis', 'Hemera', 'Andhrímnir', 'Agathodaemon', 'Eir', 'Baldur', 'Prometheus', 'Adonis', 'Geb', 'Panacea', 'Aborof', 'Nurgel', 'Adam']);

    Life(int id):super(id, "Life", isCanon:true);

}