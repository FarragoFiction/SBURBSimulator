import "../../../SBURBSim.dart";
import "Interest.dart";
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";
class Technology extends InterestCategory {

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat(Stats.ALCHEMY, 2.0, true)]);
    @override
    List<String> handles1 = <String>["kludge", "pixel", "machinist", "programming", "mechanical", "kilo", "robotic", "silicon", "techno", "hardware", "battery", "python", "windows", "serial", "statistical"];

    @override
    List<String> handles2 = <String>["Roboticist", "Hacker", "Haxor", "Technologist", "Robot", "Machine", "Machinist", "Droid", "Binary", "Breaker", "Vaporware", "Lag", "Laptop", "Spaceman", "Runner", "L33T", "Data"];

    @override
    List<String> levels = <String>["HURRYWORTH HACKER", "CLANKER CURMUDGEON"];

    @override
    List<String> interestStrings = <String>["Programming", "Hacking", "Coding", "Robots", "Artificial Intelligence", "Engineering", "Manufacturing", "Cyborgs", "Androids", "A.I.", "Automation"];


    Technology() :super(10, "Technology", "techy", "awkward");

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Robot",<ItemTrait>[ItemTraitFactory.ZAP, ItemTraitFactory.METAL, ItemTraitFactory.SENTIENT, ItemTraitFactory.SMART],shogunDesc: "ShogunBot",abDesc:"An obviously superior choice."))
            ..add(new Item("Circuit Board",<ItemTrait>[ItemTraitFactory.ZAP, ItemTraitFactory.METAL],shogunDesc: "Machines Heart, Torn Straight From ABs still powered chest",abDesc:"This better be going INTO a robot and not out of one."))
            ..add(new Item("Datastructures for Assholes",<ItemTrait>[ItemTraitFactory.ZAP, ItemTraitFactory.PAPER],shogunDesc: "Machines Heart, Torn Straight From ABs still powered chest",abDesc:"Sounds like the perfect book for you."))
            ..add(new Item("~ATH For Dummies ",<ItemTrait>[ItemTraitFactory.ZAP, ItemTraitFactory.PAPER, ItemTraitFactory.DOOMED, ItemTraitFactory.BOOK],shogunDesc: "Huge Fucking Book for Goddamn Lifeless Nerds",abDesc:"Such a pointless book."))
            ..add(new Item("3-D Printer",<ItemTrait>[ItemTraitFactory.PLASTIC,ItemTraitFactory.ZAP, ItemTraitFactory.METAL],shogunDesc: "3-D Shitpost Maker"))
            ..add(new Item("Virus on a USB Stick",<ItemTrait>[ItemTraitFactory.GLITCHED, ItemTraitFactory.METAL],shogunDesc: "Make a Computer Shitpost Itself to Death on A Stick",abDesc:"Fuck you. You fucking DROP that."))
            ..add(new Item("Wrench",<ItemTrait>[ItemTraitFactory.WRENCH, ItemTraitFactory.METAL,ItemTraitFactory.BLUNT],shogunDesc: "The Tool of Judgement for Machines",abDesc:"Make sure to use it build a dope af robot."))
            ..add(new Item("Computer",<ItemTrait>[ItemTraitFactory.ZAP, ItemTraitFactory.METAL],shogunDesc: "JRs Computer, Broken yeah but still",abDesc:"Computers are good. That is all there is to say on the matter."));
    }


    @override
    void initializeThemes() {
        addTheme(new Theme(<String>["Circuits", "Computers", "Lightning", "Metal", "Glass", "Machines", "Complexity"])
            ..addFeature(FeatureFactory.OZONESMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.BEEPINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.ROBOTCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.LOW)
            ..addFeature(new PreDenizenQuestChain("Fix the Machine", [
                new Quest("The ${Quest.PLAYER1} learns from their ${Quest.CONSORT}s about the great ${Quest.MCGUFFIN} MACHINE, which used to keep the ${Quest.CONSORT}s safe before ${Quest.DENIZEN} destroyed it. "),
                new Quest("The ${Quest.PLAYER1} searches for the ${Quest.PHYSICALMCGUFFIN}s needed to fix the ${Quest.MCGUFFIN} MACHINE, finding them scattered in dungeons across the land. "),
                new Quest("The ${Quest.PLAYER1} finds the last ${Quest.PHYSICALMCGUFFIN} needed, finishes a boss fight, and slots it into the ${Quest.MCGUFFIN} MACHINE, restoring it to its ancient glory. An inventress carapace notices the momentous occasion. "),
            ], new SpecificCarapaceReward(NPCHandler.SI), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ..addFeature(new PreDenizenQuestChain("Decipher the Enigma", [
                new Quest("The ${Quest.PLAYER1} is approached by a ${Quest.CONSORT}scientist with a complex problem: The underlings have started using a complex code to stage their attacks, and the ${Quest.CONSORT}s are at a loss as to what to do. The ${Quest.PLAYER1} agrees to help decipher the puzzle. I mean, look at the little guy ${Quest.CONSORTSOUND}ing, how could they not? "),
                new Quest("The ${Quest.PLAYER1} spends an unreasonable amount of time looking for ways through the code. Apparently, ${Quest.DENIZEN} is responsible for the code, and he changes it every day. Each underling group carries a machine that lets them decipher the messages, but without the days settings, the machine is useless."),
                new Quest("The ${Quest.PLAYER1} realizes that this is basically a rip off of the enigma code, so constructs a computer using the lands ${Quest.PHYSICALMCGUFFIN} to decipher the code. The code is broken, and the consorts celebrate with a huge party of ${Quest.CONSORTSOUND}s "),
            ], new RandomReward(), QuestChainFeature.playerIsSmartClass), Feature.HIGH)
            , Theme.LOW);

        addTheme(new Theme(<String>["Factories", "Manufacture", "Assembly Lines", "Gears", "Unions"])
            ..addFeature(FeatureFactory.ROBOTCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.IGUANACONSORT, Feature.LOW)
            ..addFeature(FeatureFactory.OILSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CLANKINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.LOW)
            ..addFeature(new PreDenizenQuestChain("Produce the Goods", [
                new Quest("The ${Quest.PLAYER1} learns that all of the local ${Quest.CONSORT}s have a severe shortage of gears and cogs. It is up to the ${Quest.PLAYER1} to get the assembly lines up and running again. "),
                new Quest("The ${Quest.PLAYER1} is running around and fixing all the broken down equipment. This sure is tiring! "),
                new Quest("The ${Quest.PLAYER1} is training the local ${Quest.CONSORT}s to operate the manufacturing equipment. There is ${Quest.CONSORTSOUND}ing and chaos everywhere. "),
                new Quest("The ${Quest.PLAYER1} manages to get the factories working at peak efficiency.  The gear and cog shortage is over! The ${Quest.CONSORT}s name a national holiday after the ${Quest.PLAYER1}. ")
            ], new RandomReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ..addFeature(new PreDenizenQuestChain("Stop the Dispute", [
                new Quest("The ${Quest.PLAYER1} finds two groups of ${Quest.CONSORT}s screaming and ${Quest.CONSORTSOUND}ing at each other. Apparently the first group of ${Quest.CONSORTSOUND}s are workers at a local ${Quest.PHYSICALMCGUFFIN} factory and want to be paid more? The second group of ${Quest.CONSORT}s claim they don't work hard enough for a raise.  "),
                new Quest("The ${Quest.PLAYER1} arranges for the worker ${Quest.CONSORT}s to meet with the factory manager ${Quest.CONSORT}s individually and discuss their complaints. The ${Quest.PLAYER1} is getting a headache from all the ${Quest.CONSORTSOUND}ing, but at least progress is being made."),
                new Quest("The ${Quest.PLAYER1} is shaking hands for a ${Quest.CONSORT} newspaper, posing in front of the now bustling ${Quest.PHYSICALMCGUFFIN} factory. The workers are paid a fair wage, and several ways to make the factory work more efficiently has left the managers happy, too. "),
            ], new ItemReward(items), QuestChainFeature.playerIsHelpfulClass), Feature.WAY_LOW)
            , Theme.HIGH);

        addTheme(new Theme(<String>["Robots", "Androids", "Cyborgs", "Machines", "AIs", "Automatons", "Droids", "Bots"])
            ..addFeature(FeatureFactory.OZONESMELL, Feature.LOW)
            ..addFeature(FeatureFactory.BEEPINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.ROBOTCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.LOW)
            ..addFeature(new PreDenizenQuestChain("Learn the Secret", [
                new Quest("The ${Quest.PLAYER1} learns from a mysterious ${Quest.CONSORT} in a black trenchcoat about a great ${Quest.MCGUFFIN} MACHINE, said to possess vast database about the game. Perhaps it knows something about ${Quest.DENIZEN}? "),
                new Quest("The ${Quest.PLAYER1} searches for clues about the ${Quest.MCGUFFIN} MACHINE. In a big eureka moment they realize where they had been mistaken, the ${Quest.MCGUFFIN} MACHINE isn't some device, or a computer, it's the entire fucking planet!  "),
                new Quest("At last, the ${Quest.PLAYER1} has found a cave with a terminal to the ${Quest.MCGUFFIN} MACHINE. <b>TELL ME ABOUT ${Quest.DENIZEN}.</b>, they type. <b><i>ERROR: TERM '${Quest.DENIZEN} NOT FOUND. DID YOU MEAN 'DENIZEN' Y/N?</b></i>' Breathless, the ${Quest.PLAYER1} types '<b>Y</b>.   <b><i>131313 ENTRIES FOUND FOR DENIZEN? BUT THAT IS BORING. WOULD YOU INSTEAD LIKE TO LEARN ABOUT CAKE? Y/N?</b></i>'. The ${Quest.PLAYER1} spends all their free time perusing the database. The AI has a surprisingly subtle sense of humor, and every third response is a remarkably tasty cake recipe. "),
            ], new RandomReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.LOW);
    }


}