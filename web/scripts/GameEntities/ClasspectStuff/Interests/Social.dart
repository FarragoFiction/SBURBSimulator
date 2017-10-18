import "../../../SBURBSim.dart";
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

import "Interest.dart";

class Social extends InterestCategory {
    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat(Stats.SANITY, 2.0, true)]);
    @override
    List<String> handles1 = <String>["master", "playful", "matchmaking", "kind", "regular", "social", "trusting", "honest", "benign", "precious", "wondering", "sarcastic", "talkative", "petulant"];

    @override
    List<String> handles2 =  <String>["Socialist", "Defender", "Mentor", "Leader", "Veterinarian", "Therapist", "Buddy", "Healer", "Helper", "Mender", "Lender", "Dog", "Bishop", "Rally"];

    @override
    List<String> levels =<String>["FRIEND-TO-ALL", "FRIEND COLLECTOR"];

    @override
    List<String> interestStrings = <String>["Psychology", "Religion", "Animal Training", "Pets", "Animals", "Online Roleplaying", "Live Action Roleplaying", "Tabletop Roleplaying", "Role Playing", "Social Media", "Charity", "Mediating"];


    Social() :super(11, "Social", "extroverted", "shallow");

    @override
    void initializeThemes() {
        addTheme(new Theme(<String>["Couches","Therapy","Analysis", "Cigars", "Psychology"])
            ..addFeature(FeatureFactory.SILENCE, Feature.LOW)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CONTEMPLATATIVEFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.STUDIOUSFEELING, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("The Therapist is IN", [
                new Quest("The ${Quest.PLAYER1} finds a help wanted sign near a strange booth. Apparently the local ${Quest.CONSORT}'s are in need of a therapist? The ${Quest.PLAYER1} decideds to try it out! "),
                new Quest("Huh, somehow all the ${Quest.CONSORT}'s problems end up being about childhood trauma involving ${Quest.MCGUFFIN} or ${Quest.PHYSICALMCGUFFIN}.  The ${Quest.PLAYER1} is getting really good at helping them out. "),
                new Quest("A line of ${Quest.CONSORTSOUND}ing ${Quest.CONSORT} extends out to the horizon. The ${Quest.PLAYER1} is the most popular therapist on the planet! ")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);

        addTheme(new Theme(<String>["Meditation","Chants","Worship","Altars","Hymns", "Chapels", "Priests", "Angels", "Religion"])
            ..addFeature(FeatureFactory.SILENCE, Feature.LOW)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CONTEMPLATATIVEFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CHANTINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.MUSICSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.SINGINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.STUDIOUSFEELING, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("Meditate On Frogism", [
                new Quest("The ${Quest.PLAYER1} wonders into an incredibly calm area of their land. It is filled with chanting and ${Quest.CONSORTSOUND}ing ${Quest.CONSORT}s. Apparently they are monks contemplating the vastness of the Vast Croak. The ${Quest.PLAYER1} joins them. "),
                new Quest("While meditating with the ${Quest.CONSORT} monks, the ${Quest.PLAYER1} has come to a startling realization, the vast croak is related to ${Quest.MCGUFFIN}-ness. How could they miss this?"),
                new Quest(" The ${Quest.PLAYER1} begins telling all the ${Quest.CONSORT} monks about how ${Quest.MCGUFFIN}-ness relates to the Vast Croak. The monks begin ${Quest.CONSORTSOUND}ing in amazement, this could revolutionize Frogism for generations!")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);


        addTheme(new Theme(<String>["Roleplaying","FLARPS","Dungeons", "Dragons", "Tabletops", "Dice"])
            ..addFeature(FeatureFactory.CLANKINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.GLAMOROUSFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.NATURESMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.HEROICFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.DRAGONCONSORT, Feature.HIGH)
            ..addFeature(new PreDenizenQuestChain("Protect the FLARPers", [
                new Quest("The ${Quest.PLAYER1} wanders into an entire crowd of ${Quest.CONSORT}s dressed in authentic style fantasy armor. What is going on? The nearest one stops ${Quest.CONSORTSOUND}ing long enough to explain that it's time for Paradox Space's biggest FLARP convention. The ${Quest.PLAYER1} happily joins the RP."),
                new Quest("The ${Quest.PLAYER1}'s character in the FLARP is nearly maximum level. This is so much fun! Suddenly, a group of underlings attack the crowd. Confusion reigns as the ${Quest.CONSORT}s think it's somehow related to FLARP at first and don't fight back seriously. It is up to the ${Quest.PLAYER1} to save the day! All that RP practice surprisingly pays off. They win easily!   "),
                new Quest("The FLARP is finally coming to an end. All the ${Quest.CONSORT}s agree that it is the best session in living memory and celebrate how the ${Quest.PLAYER1} kept it from becoming a tragedy.")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);
    }

}