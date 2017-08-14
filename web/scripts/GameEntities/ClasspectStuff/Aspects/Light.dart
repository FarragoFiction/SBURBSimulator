import 'Aspect.dart';

class Light extends Aspect {

    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Light', 'Helios', 'Ra', 'Cetus', 'Iris', 'Heimdall', 'Apollo', 'Coeus', 'Hyperion', "Belobog", 'Phoebe', 'Metis', 'Eos', 'Dagr', 'Asura', 'Amaterasu', 'Sol', 'Tyche', 'Odin ', 'Erutuf']);

    Light(int id):super(id, "Light", isCanon:true);

}