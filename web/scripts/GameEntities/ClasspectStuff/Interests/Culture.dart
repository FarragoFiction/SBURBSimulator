import "../../../SBURBSim.dart";
import "Interest.dart";
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Culture extends InterestCategory {

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat(Stats.SANITY, -1.0, true), new AssociatedStat(Stats.HEALTH, -1.0, true)]);
    @override
    List<String> handles1 = <String>["monochrome", "poetic", "majestic", "keen", "realistic", "serious", "theatrical", "haute", "beautiful", "priceless", "watercolor", "sensational", "highbrow", "refined", "precise", "melodramatic"];

    @override
    List<String> handles2 =  <String>["Dramatist", "Repository", "Museum", "Librarian", "Hegemony", "Hierarchy", "Davinci", "Renaissance", "Viniculture", "Treaty", "Balmoral", "Beauty", "Business"];

    @override
    List<String> levels = <String>["APPRENTICE ARTIST", "CULTURE BUCKAROO"];

    @override
    List<String> interestStrings =  <String>["Drawing", "Painting", "Documentaries", "Fan Art", "Graffiti", "Theater", "Fine Art", "Literature", "Books", "Movie Making"];


    Culture() :super(2, "Culture", "cultured", "pretentious");

    @override
    void initializeThemes() {
        addTheme(new Theme(<String>["Museums","Sculpture","Paintings", "Art", "Refinement"])
            ..addFeature(FeatureFactory.SILENCE, Feature.MEDIUM)
            ..addFeature(FeatureFactory.STUDIOUSFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("Catch the Thief", [
                new Quest("The ${Quest.PLAYER1} visits a beautiful ${Quest.PHYSICALMCGUFFIN} Museum, only to discover that its walls are practically bare! The ${Quest.CONSORT} curator is apologetic, and explains that each night a new piece goes missing. The ${Quest.PLAYER1} agrees to catch the thief, art is for everyone! "),
                new Quest(" The ${Quest.PLAYER1} has almost fallen asleep during their latest ${Quest.PHYSICALMCGUFFIN} Museum stakeout, when the thief arrives! It looks to be a ${Quest.DENIZEN} minion! After a brief scuffle, it is defeated. They drop various pieces of art along with the standard amount of grist. The museum is saved! "),
                new Quest("The ${Quest.PLAYER1} attends a fancy gala in their honor, hosted in the ${Quest.PHYSICALMCGUFFIN} Museum itself.  ${Quest.CONSORT}s quietly ${Quest.CONSORTSOUND} and exchange pleasantries. It sure is nice to be recognized by high society!  "),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);


        addTheme(new Theme(<String>["Theater","Stages","Curtains", "Audiences", "Thespians", "Actors", "Plays"])
            ..addFeature(FeatureFactory.SWEATSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.ENERGIZINGFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.LAUGHINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CLAPPINGSOUND, Feature.HIGH)
            ..addFeature(new PreDenizenQuestChain("Perform the Play", [
            new Quest("The ${Quest.PLAYER1} finds a troupe of dejected looking ${Quest.CONSORT}s. Apparently they want to put on a famous ${Quest.CONSORT} play called 'The ${Quest.MCGUFFIN} ${Quest.PHYSICALMCGUFFIN}', but have no one to play the titular role!  Does the ${Quest.PLAYER1} have what it takes to bring the iconic role to life? "),
                new Quest("The ${Quest.PLAYER1} is practicing their lines for the upcoming performance of 'The ${Quest.MCGUFFIN.toUpperCase()} ${Quest.PHYSICALMCGUFFIN.toUpperCase()}'. Man, who would have thought a ${Quest.PHYSICALMCGUFFIN} would have so many different emotions! "),
                new Quest("It's finally time for performance of the 'The ${Quest.MCGUFFIN.toUpperCase()} ${Quest.PHYSICALMCGUFFIN.toUpperCase()}'. The audience is moved to tears and ${Quest.CONSORTSOUND}ing at the ${Quest.PLAYER1} stirring performance as the ${Quest.PHYSICALMCGUFFIN}. "),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);

        //the sock ruse was a distaction
        addTheme(new Theme(<String>["Class","Decorum","Fancy Shit", "Manners", "Good Taste", "Artistocrats", "Debutantes", "Barons", "Lords", "Ladies", "Nobles"])
            ..addFeature(FeatureFactory.SPICYSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.BAKEDBREADSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("Attend the Dinner Party", [
                new Quest("The ${Quest.PLAYER1}  is cordially invited to the dinner party of Miss ${Quest.CONSORTSOUND}ingworth, ${Quest.CONSORT} heiress to the ${Quest.PHYSICALMCGUFFIN} fortune. "),
                new Quest("The ${Quest.PLAYER1} is coached on etiquette by  Miss ${Quest.CONSORTSOUND}ingworth's butler. It would not do to embarass the young Miss.  "),
                new Quest("It is finally time for Miss ${Quest.CONSORTSOUND}ingworth's party. Anyone who is anyone is attending, and it is clear that the ${Quest.PLAYER1} is the guest of honor. They successfully charm all of the ${Quest.CONSORT}s with a captivating story of dining customs from their home world. "),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);
    }

}