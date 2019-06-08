import "../../GameEntity.dart";
import "SBURBClass.dart";
import "../../../SBURBSim.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Maid extends SBURBClass {

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 0.51;
    @override
    double fraymotifWeight = 0.01;
    @override
    double companionWeight = 0.51;

    @override
    List<String> associatedScenes = <String>[
        "Maid I:___ N4IgdghgtgpiBcICyECWATABASRAGhADMAbCANwHsAnAFRgA8AXBEAHgCMA+AZWwBEAogEUAqgO414rAPRdMNABYxM3AMICAcgID6AeQDqWgEraNAQSQDMqAM6YIxYpgpkYVTIyWYADqQDGyoxUAJ6oYADmHhSYfhRQvjCMyhCYNhgwAI4ArjA2jB4KEPlUmVmoJXaeMFBRmOGorqkw1WHhxMGYMGDoxLl20BRZYIx2FIQ+FGGMvTZ2AFZDANa1VZjZufn1rlQAdJhmjgXKapo6BsamFlbhiXZhMXHeXTZFqBRgmITUR+WYhVRYADu1GWtnsqSgDicfiy+TGRzqECo7AgNz2+gUqF6BSKmCgqHCCnyYAo+Rsg26mGIqEWyigWT8CjwmEBhWKMChHUhjCSVDulTZCJOWj0hgEJnMlmsdhJgPB1J52PYqHy7ESvPsmwarWcVT5LMFVQ6YGa6B2AB0wBwqJxrZx8CBGEiboxdCaWEEcg6ggSblRVO90Cq3mAbAAZbURFgAbWA5pAqHi1Cdw301HQ8fg8Y00jM8bw2d0NEz8cIDhsMHz8YAakZsNwANJ5hCl8uV-DxyCwEsgbA2bgwYiEKsJpNUFOMbDDHsABnjAF9mXHR95kxBU+meznmwWQBoiz2y8QKyPa-Wm4e2yOu+2s72bAcGu3d4nV+P15Ppy2QHOQIvMMur5rhuAJbrmI77sW36es+NZ1o2zZ3keJ4duA0C3vGfYAOIUOgNCoG4I5Ae+wxTows4Lku8bEROaagd+AAKxAMssNAULSYDwNo3GYBoAAs2DhOghLhIw4TeKgABCfjYGYTbsGYVDhAAmoCGjKWYskZGYACcxBzFhqhmHwQjhJJUANgIZjsOEQgCAArHxgJmDAZhhvUujcFh9BmICuiqQATC5NCSfQAjEKoqjhHwuh+KoUCAspklhl82BJQoZhQGYmUqhQNgAMzcBYpIZA2gIALQ0OEWEAIzhGYAASRiqA2FBmJJM4QAAHICCm6BkSCMOgADUDVJcEZgMUIZjhGAABaizlTYABSfEMZA3BIHMqgKMJknaQIbWLNFTYaNgCiqBoABi3A2GQDXhDODUOdgqhgNwEA0GYFDEGYIi6AAXuEwRZOwqjMSIRXGWNZhkFAQh8YwZBzboYYKJJQzhADMDLcpDVzcp3CScN4gzvQw0wNwy0ZHN81kMQRj2fQKNCDYqg1cQ3DKRoECSVdZg1eVhD6Hwcx+DOxAAOxFegblUHFNgZBkWGMBkABsw1QJJWHDTVc35VdfCqCIxB8GY3NzEVkmoAZSDeGASAABoBXxZD5cN4TLZJykMQFM6oAoDVQxBB7QVQOSnvBF7fshsFod234NRA-YBCaRFjhOZEUX+VErsBjB0Rm37biHUFIVeqFnghl7HnHN49n2RjrugcTp2+mdfne+X5QuAC63pUL6bgBt0wbvOGzcxv3BAwIQhAwH4IxXdQEZkK0MaARnH6Fz2SAUMqCrBNe6E9jt643EgwTcE65GV1HiGtrXbf5xoWRQGqVA9uVNU9znAHUVvECRc7woHoImN+mAwwsWPgnO8Z8IgwEvtfIokdzwPyIBXF8gDGCv3foRb8P9KL-zziRAum5GLMT8KxdiXQuI8X4oJYSChRLiSkjJOS1lFIqTUhpLSul9KGWMqZcyllrK2Qck5FybkPJeR8n5QKwVQrhUitFWK8VErJVSulTK2V8SMDyoVYqqsyqVWqnVRqzVWrtU6j1PqA0hqjXGpNaas0FpLVWutCAm1tq7TMgdI6J0zBnQutdW691HrPXsq9d6n1vq-X+kDEGYMIZQz4DDOGCMkYozRhjCI2Ncb40JsTUm5NKbU1pnNemjNma6FZuzTm3Neb80FsLUW4spYyzlgrJWKt1aa21rrfWhtjam3NhoS27UbZYTtg7Z2rt3ae29r7f2gdg6oXrt+LCT4zCLxDKg6uYcI6oRoh+XBH9s7zmniAWe89F42GXlQMMzcbBTz-EAA",
        "Maid II:___ N4IgdghgtgpiBcICyECWATABASWyANCAGYA2EAbgPYBOAKjAB4AuCIAPAEYB8AytgCIBRAIoBVQT1rw2Aem6ZaACxiYeAYUEA5QQH0A8gHVtAJR2aAgkkGYIAYyYBnG04iYilAK5gmaMJkpEmEzKqNTOAA4w9vhB1BQwJKhgAOaYAO7K1CqoTJioTmAwMOjFNmBYwTB+JDBMTEmpOW4klGluWQkAnu2UUOk5iklBylAAdAqZ2QWUmA6KND7JKgHDKupauoYmZpaCAOQuDpH26cp+lZ17WTbUnuXj2LlQqMmKuRwqihDUWGk0ANYxDgeXI5A42EgkdILRR5JjjJRrDTafRGQSmCxWTBeErUBw+cpOYIQXLEpjgjIkuGYWAQMBEmYfGyYFAYUYAHTAnGoXG5XAIIB81CWTD0hVYTGoHjghElLyW1DUlHKOVQyocABlUOQGqwANrAdkgVBQcILOlMAw0dBG+BGzQycxG-D2vS0W1GogQEgOGDOo0ANWM2B4AGknQhPd7ff7wNA-ZGQNgHDwEkRYyazdQCUxsN4PSAAAxGgC+MUNxtN5u8Vp+BYdEZdIE0boLXp9CabQZD4bb0c7RsgsALyfMiXIA8rWZzeaYBeLIDLmArmerlut9cdsZb7sT7ZjBEDwbDEbtxH7saHCbPyYA4pR0LRUDBqBmq9mLbP56Xy0bVx+aw3RMAAUSA8Wx-gUSh-iqeAdHgzBNAAFmwZJ0FeZImGScJUAAIVsbBzHDDhzGFABNNJNDI8xCIAR3MABOEgACtbzUcx+GEZJcKgUNBHMDhkmEQQAFYkLScwYHMDVklQPQeFvBhzDSPQKIAJkk2hcIYQQSDUNRkn4PRbDUKA0jI3CNXcbALMUcwoHMeyckoBwAGYeEsSgmFo0M0gAWloZJbwARmScwAAljDUUNKHMXDCwgAAONISL0WikCYdAAGpwoszpzGA4RzGSMAAC1-j8hwACkkOAyAeCQZi1EUdDcPowRYv+Qzw00bBFDUTQADEeAcchwuSQtwtE7A1DAHgIFocxKBIcxRD0AAvZJOg8Dg1DA0QPI43LzHIKBhCQphyFKvQNUUXCvGSdaYCqsjwtKsieFwrKJELBgspgHgqto0qyvIEhjBEhhruEBw1GCkgeDIzQIFwwbzGCvyiAMfhmNsQsSAAdg89BpOoEyHFo2jb28gA2LKoFw28suC0rXMG-g1FEEh+HMJHmI83DUFYpBwjAJAAA01KQ8hXKy5IqtwsjgLUwtUEUcLDu3VtE0laVY27E8+w7S94wLcKIBTWwqknf8Z3zRMFyXFd3xzWsbUTBstd3M990nA3ez3C9DzjYdE2TYw6XQXo32nT97bPGmadLABdAU5WSBUlRVep1Q1SP9VTwgYCIIgokcQaaC1HUUn1Z3Y8AutEyQSgOFQRImE6E3Q7PZq6SWJBOh4Hw52D-3TyjY3g9ti1NA8KAPlfRM-OC1zHd-Kc1zdgsUAYE058wDVwP+LvryNXuUhgAeh5JfXjwDn2g6bafvFn+eXwLFe1+XP8XYtLeQLAhBKCMEwBwQQshVC6FFCYWwnhAiREBKkWSBRKiNFzD0SYqxdinFuK8X4oJYSYkJJSRknJBSSkVLqU0tpXS+lDLGVMuZSy1lbL2Ucs8JgLl3KeW8r5AKQVQoRSijFOKCVkqpXSplHKeUCpFRKuVSqNU6oQAak1Fq3F2qdW6uYXq-UhojTGhNKaIkZpzQWktFaa1NrbV2vtQ6-BjqnXOpda6t17opCei9N6H0vo-T+gDIGINSpgwhlDPQMM4YIyRijNGGMsY4zxoTYmpNyaU2prROmDMmYszZhzLmPM+YCyFreEWYtJbS1lvLRWytVbq01sHK8BZbzaikvYNUYBb49nHoKKUNtf4vzngvb8i5C4gGLqXewDgK7UDzoSAui4gA"
    ];

    @override
    List<String> levels = ["SCURRYWART SERVANT", "SAUCY PILGRIM", "MADE OF SUCCESS"];
    @override
    List<String> quests = ["doing the consorts' menial errands, like delivering an item to a dude standing RIGHT FUCKING THERE", "repairing various ways the session has been broken", "protecting various consorts with game powers"];
    @override
    List<String> postDenizenQuests = ["using their powers to help clean up the debris left from their Denizen actions. Who knew the term maid would be so literal", "watching over the consorts as they begin to rebuild", "following their consorts to ever larger pieces of debris", "empowering an army of consorts to clean out the last of the debris from their Denizen"];
    @override
    List<String> handles = ["meandering", "motley", "musing", "mischievous", "macabre", "maiden", "morose"];

    @override
    bool isProtective = false;
    @override
    bool isSmart = false;
    @override
    bool isSneaky = false;
    @override
    bool isMagical = false;
    @override
    bool isDestructive = false;
    @override
    bool isHelpful = true;

    Maid() : super("Maid", 0, true);
    
    //TG was here
    
    @override
    bool highHinit() {
        return true;
    }

    @override
    bool isActive([double multiplier = 0.0]) {
        return false;
    }

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
        //disney princess, house maid, shield maid.
        ..add(new Item("Maiden's Breath",<ItemTrait>[ItemTraitFactory.PLANT, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.PRETTY]))
        ..add(new Item("Feather Duster",<ItemTrait>[ItemTraitFactory.WOOD, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.STICK, ItemTraitFactory.FEATHER],shogunDesc: "Maids Weapon of Choice",abDesc:"Housemaid shit."))
        ..add(new Item("Valkyrie Shield",<ItemTrait>[ItemTraitFactory.PRETTY,ItemTraitFactory.UNCOMFORTABLE,ItemTraitFactory.METAL, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.LEGENDARY, ItemTraitFactory.SHIELD,ItemTraitFactory.ADAMANTIUM],shogunDesc: "Another Weakling Piece of Metal But For Some Kind of Angel Woman I Guess?",abDesc:"Shieldmaid shit"))
        ..add(new Item("Maiden's Songbook",<ItemTrait>[ItemTraitFactory.PAPER, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.MUSICAL,ItemTraitFactory.BOOK],shogunDesc: "Smash Mouth Lyrics",abDesc:"Longing maiden shit."));

    }


    @override
    num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
        return powerBoost * 1.5;
    }

    @override
    void processCard() {
        storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAmACAQzwFkCMcQAaELAgWyVQBEI8BhACwhgTCpAAuCAB4CUIACocEeOARgAHBALwYweADYQIAa2wBzPADMoWHQE9C+slgB0eCRgbHueCAHcsCHrQYw8AqwAbgRwUFB0ANx4eACC1tj2eACSRm6e3gi+3ngcBPgC0nh0EF6WRe7QGvg8ChqhMgQaGgFFRlrcBnjuGIV4QdjmGvZSWelePvQ5lVDVWADkKnlBMoH9oeF0hFjmJTxJyVhgQvnjmdn+M9W5BCsBrGDuCAgK2-glCkkA6h6UrWrGAhYAQEMCWIwYABekI0CHw0BUPCagOOtn4ACNQjp9DBoLgAHJTcQ-LD6WE-GA6WwKUn8AQwDD6fTeThAxDiAAMtgArPwwIgvGAJBAAKpYLRwHTiADaAF1+DwwLMBGAAMoglUy4AAHRoU11yF1quIAFEADJmvBfWIANRNqt1lF1IQ0UAQBt1AFoAEy6gC+8uo9MZzJg6oIKrNvDA3hlgcEDKZ3nDKoA4kihDA43TE6GU2ATQBHKBNbN+oA");
    }

    @override
    double getAttackerModifier() {
        return 0.33;
    }

    @override
    double getDefenderModifier() {
        return 3.0;
    }

    @override
    double getMurderousModifier() {
        return 1.5;
    }

    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        addTheme(new Theme(<String>["Suburbs","Parks", "Playgrounds", "Swingsets","Tire Swings","Neighborhoods","Traffic"])
            ..addFeature(FeatureFactory.NATURESOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.NATURESMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.HAPPYFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.LAUGHINGSOUND, Feature.MEDIUM)

            ..addFeature(new PostDenizenFrogChain("Serve the  Frogs", [
                new Quest("The ${Quest.DENIZEN} has instructed the Home Owners Association to lift the ban on frogs. The ${Quest.PLAYER1} asks local  ${Quest.CONSORT} kids to help them collect frogs. The ${Quest.CONSORT}s agree with enthusiastic ${Quest.CONSORTSOUND}s.  It's a lively neighborhood event."),
                new Quest("The ${Quest.CONSORT} kids hit buttons on the ectobiology machine at random. The ${Quest.PLAYER1} shows them how to do it right, and soon everybody is helping out. A neighboring ${Quest.CONSORT} starts grilling some burgers and dogs so nobody goes hungry."),
                new Quest("A ${Quest.CONSORT} child has tripped over the final frog. They cry and ${Quest.CONSORTSOUND} at their skinned knee, but their pain is quickly forgotten when the ${Quest.PLAYER1} praises them for finding the frog.  Together,     "),
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)


            ..addFeature(new PostDenizenQuestChain("Serve the PTA", [
                new Quest("The ${Quest.PLAYER1} has adopted a local ${Quest.CONSORT} child to be their dear, sweet, precious daughter. It is time for them to go off to school.  Other ${Quest.CONSORT} parents ask the ${Quest.PLAYER1} to join the PTA."),
                new Quest("The PTA has the ${Quest.PLAYER1} running ragged. It seems like every time they turn around it's another thing they are ${Quest.CONSORTSOUND}ing about. "),
                new Quest("All this time catering to the PTA has paid off. Not only is the ${Quest.PLAYER1}'s dear sweet precious ${Quest.CONSORT} daughter doing well in school, but the ${Quest.PLAYER1} has been elected president of the PTA! They now have the ability to make real changes.  Somehow this feels even more satisfying than defeating the ${Quest.DENIZEN}. ")
            ], new RandomReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);
    }

}
