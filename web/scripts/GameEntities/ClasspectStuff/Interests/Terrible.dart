import "../../GameEntity.dart";
import "Interest.dart";

class Terrible extends InterestCategory {

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat("RELATIONSHIPS", -1, true), new AssociatedStat("sanity", -1, true)]);
    @override
    List<String> handles1 = <String>["tyranical", "heretical", "murderous", "persnickety", "mundane", "killer", "rough", "sneering", "hateful", "bastard", "pungent", "wasted", "snooty", "wicked", "perverted", "master", "hellbound"];

    @override
    List<String> handles2 = <String>["Butcher", "Blasphemer", "Barbarian", "Tyrant", "Superior", "Bastard", "Dastard", "Despot", "Bitch", "Horror", "Victim", "Hellhound", "Devil", "Demon", "Shark", "Lupin", "Mindflayer", "Mummy", "Hoarder", "Demigod"];

    @override
    List<String> levels = <String>["ENEMY #1", "JERKWAD JOURNEYER"];

    @override
    List<String> interestStrings = <String>["Arson", "Clowns", "Treasure", "Money", "Violence", "Death", "Animal Fights", "Insults", "Hoarding", "Status", "Classism", "Online Trolling", "Intimidation", "Fighting", "Genocide", "Murder", "War"];


    Terrible() :super(5, "Terrible", "honest", "terrible");

}