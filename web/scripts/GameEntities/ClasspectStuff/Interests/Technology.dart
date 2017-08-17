import "../../GameEntity.dart";
import "Interest.dart";

class Technology extends InterestCategory {

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat("alchemy", 2, true)]);
    @override
    List<String> handles1 = <String>["kludge", "pixel", "machinist", "programming", "mechanical", "kilo", "robotic", "silicon", "techno", "hardware", "battery", "python", "windows", "serial", "statistical"];

    @override
    List<String> handles2 = <String>["Roboticist", "Hacker", "Haxor", "Technologist", "Robot", "Machine", "Machinist", "Droid", "Binary", "Breaker", "Vaporware", "Lag", "Laptop", "Spaceman", "Runner", "L33T", "Data"];

    @override
    List<String> levels = <String>["HURRYWORTH HACKER", "CLANKER CURMUDGEON"];


    Technology() :super(10, "Technology", "techy", "awkward");

}