import 'Aspect.dart';

class Blood extends Aspect {

    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Blood', 'Hera', 'Hestia', 'Bastet', 'Bes', 'Vesta', 'Eleos', 'Sanguine', 'Medusa', 'Frigg', 'Debella', 'Juno', 'Moloch', 'Baal', 'Eusebeia', 'Horkos', 'Homonia', 'Harmonia', 'Philotes']);

    Blood(int id):super(id, "Blood", isCanon:true);
}