import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";
class Blood extends Aspect {

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 0.01;
    @override
    double fraymotifWeight = 0.5;
    @override
    double companionWeight = 1.00;

    @override
    List<String> associatedScenes = <String>[
        "[Omnitherapy]:___ N4IgdghgtgpiBcIDaB5KYCWAXAFjAThAA4CeAuiADQgBmANhAG4D2+AKjAB5YIgA8AIwB8qdNjyFSZPgHphAHTCD8QxWzwACAMoBhAKIA5PQH0UAdSMAlYwYCCAWT0aArmDowIAZzyeNEDQDuTDAazDQaAnTMzAAmGjBgBADmJKGMBH6BGDEhEPgeGrgQWBoYUEQQAMZYvrghbLaWAOJ6bDYOJijWdo5alBqEGJ4YYEmFeBj4Gp4QmFipxeMhlcyeJWFL2vpGphZ63R0A5L7MAWAaNPkhARh0dAB0ispCz1QgWHlJMFgoibw0EDonjg1Cw+AwSS++B0zDAMWwGFhngAMhhGCMkrwkMB5CAykRWB8wFgzKwYrj4Lj7BBOGVnFANMjnJUANa4yi4gwoNgU3EAoEwdm4gBqlgAkloANK2Xm0QHAoXgaCChBUkhaD5YMWeJr5YoEdSzYWA5wqjl48qE2Za4mygCMAGZcQBffo4i0E-BEklk2UABTozJZGjYzBZCXgxijGgMABYxUkYkkcEksEkiBgAEKVMW2aUCWz4JIATQCBmLtlzAEdbABOOgAKyaOlsABEAIpJTNQSV6WwCJLtvQAVljAVsMFsyKSGBQWianFsARQpYATBO2JnOHo6DodElWyhKjooAFi5nkTRmGLzzhbFBbPfsKsHVoHMwsFXJQEALRsJJNHaSS2AAEpYOiSswtiZgADBAAAcAQFigVb2FgMQANQgeeJC2H67a2EkYAAFosj+ngAFKxn6kBaPYDY6DgSaZjWehQSyB7SgYYo4DoBgAGJaJ4jAgUkMEgSOYo6GAWgQA0zB0LYACqKAAF4pM4Ag6IGSlvm22G2IwUDtrGWCMMRKDIjgmauEkqkwBRxYgcRxZaJmGF6FoMGcBhMBaBRVbESRjB0JYw6cBZ7aeDodp0FoxYGBAmb8bYdo-jQZitg2lQwXQADsb4xFO+DHp4VZVk0n4AGwYVAmZNBhdrEQ6-GtjoSl0K2tgJQ2b6ZhgTb2EQYD2AAGqusaMA6GFJBRmbFn6q4wRgOAgXpipcjyqpygKiqihK0qymCpqKpAsCyiBXhaJUCRmri+JWsSYq2ttMEum692Wl61qkvg5LbQYMgylQnLcrK-IKiDID7VKwOUjtkPmmdKrw9qth0Gid0eo9NpYLKb0gK6Gjug933Er9-3wGAzh3Oam3g-KWMw4d20Q1jyOyvYJAoBmmCwigNBsJ83zarqHhYAaOBGiaWOk96z149tdoE0TJNfd6FOyoDwN02DrOM3t4qw0d+AnVDHPbaLsRsBgBCKnL1oK-j73E59noa7622yXMJAbXr8PHUzRss-DbOncqspC0W3wasUot6hL7BS2AxqBrL6uOy98OOi7avuz9nvw-xVwaGYtx0H7W2hwbUPM3DfI10jEfbVzsdajqCeS9Laf2xnT1Z7iOeExQoLgpCBAwnCCJIsiswxFiI8gDANA0DA1SePxrCouioxYnnOOa9tAZBiGYYRlGxgxvGibJqm6ZZjmeb9oWJZlhW1Z1o2zZtp23a9v2g4RxjgnFOGcc4FxLhXAEdcMBNzbl3PuQ8x5TznkvNeW895HxQGfJ4V875Pzfj-ABICoFwKQWgnBRCyFULoSwjhPCBEiKkXIlRGiEA6IMSYl2Vi7FOK2G4rxASQkRJiQksOKSMk5K2AUspNSGktI6T0q2AyRkTJmQslZGyox7KOWcq5dynlvK+X8oFYKoVwqRWirFeKiVkqpXSplbKuUCq2CKsiEqOgyoVWqrVeqjVmqtXap1bqBherQQGk0IaI1xqTWmrNeai1lqrXWubZu8NLAwCgMwdIthqiIjAIbA69d3im3TvnYkBh6QCDtq9XObsD6F05EDcO51tqMVmF8HmIx8kC3sEHIpDNdpQwdhUqpNT4bDjqdjMmPo-qym9tgX2qTWnw3aaMPympCnG31kM80IysCVKgNU-A9oHQwRVh9aZHs5nbWLjAEIZc7gtJRriNZXxW6bNrsHYpYdhl9wOWMk520fyOnOS6Rey9V7r03vgWecJPAL0JkAA",
        "[Protector's Bond]:___ N4IgdghgtgpiBcIDaAFATgewC4wMZYzQHIBnAAgCEMwATAXRABoQAzAGwgDdCAVGADywIQAHgBGAPlSYc+QqUrV6IgPSSAOmHFoJmngAsYZAMoBhAKIA5cwH0A8gHVrAJRuWAggFlzZEgHcYCDRyLEMASzQyNjCWIwIyUKMed2cAcXMeNy9bO1cPb2MyCFoyDBZY4ITDKCqYCLIAVywoDBIsMgAHGTwsMOoAOk1tCWGmECwggHMYLDswOEQsNAa4ZiWwyem0UyUw3uoSABkwzjCwSeEkYHUQMKgOwgmwLAdCGhv4G88MMTDorAAnjdGDdLHYeB8biwIGwSDBgTcAGrOACSxgA0u5IawYXCEeBoPCEF8AcYJlgUSRUmhAjg0AZioiYSt8XcHmgnhTntiAIwAZhuAF9GGRrrd7o9ii83tiUGwGrgANZkHgYRUwMDwGzasiWAAsKMmNEm+kmWEmHTCFFwKPcmLE7jQkwAmn5LM73LaAI7uACcbAAVqlTO4ACIARUmFCg6PM7jEk3D5gArHq-O4YO5DpMwnZjKl+O4-HZXQAmDM8Cj8cxsUymSahuy4UxQPzOiiHFgYFHt-TuKDuft7Vp84xebBe9F+AC0PEmqR5k3cAAlnKZ0Rh3BQAAwQAAcfgddi9niwNAA1Mv2wD3Chw+5JmAAFqK6ckABSepQkGMngDpn0Y0KB9cxN0VBtMUsFF9FMSwADFjBIThl0mbdlxTFFTDAYwIGSDA2HcABVOwAC9JgBBoxFMeVCLHMMr3cTgoHDPUsE4J87EOfQKAac4SJgd9nWXJ9nWMChz3MYxt34c8YGMd8vSfZ9ODYZxk34DjwxIUweTYYxnUsCAKDg9weWnFgHFDANcG3NgAHYxxoLM0GbEgvS9VIsC9AA2c8oAoVJzx5J8+Tg0NTEIthQ3cAyAzHCgwiDTwOjATwAA1Sz1Tg+XPSZ3woZ0UFLbcwn0Zc6PxMEIWJHFYSJEEQGRNFMWxJYWSYG5IFgbFlwgEhjFwDV6puNlJWeFFuRq7chRFMVRo5KVXjQd4assFQsQ6kAquxaE6vxJqMQ2z5arxTauqJY7KXcaJOGG8V2U5CasGxaaQGFUURolBbniWlbjrWjaGu2mrdtOhqDpakHcTu87sUpZxihoDAoFZL7Hsm47k1e965rRxaZQQMAGjYNggfBHbof21FDopvazsJbFPABOxLTAPowDsFgeCmGZKWpWkYHpfRGWZO75vR56auKmaPvusbpWW7EAcq8mobp8Hqch462phhmat67TkY6NgZhgJyScORHwxWNoSFRh6pSel6Zdxh2foJ-71pV6rteWO6IaOqFKfp7qau5p1eZIJnDkCGhBft+WnamoUGDWNANi2HZaD2dmjkRy5U5AGByh6Eg4MIY5TnOS5Xfl37ZXlJUVTVDUtR1fVDWNU1zUta1bXtR0XTdD1vT9QNgzDSNo1jeNExTNMMyzHM8wLIsSz8csYErata3rRtm1bdtO27Xt+0HKBhxIUdxy8qdZ3nRcVzXDct13A8jxPM9L2vW970fF83yfm-BAX8-5AJRhAmBCC7goIwXgohZCqF0LJkwthXC7h8JEVIuRSi1EGi0UHKGBiTEWJsQ4lxHifEBJCREmJCSUkZJyQUkpJ8Kk1IaTsFpHSekDJGRMmZCyVkbL2Ucs5Vy7lPI+T8gFIKIUwoRSijFSwcUtyJVSMlVKGUso5TygVIqJUyoVRDhdG4zgYAtFuu4fA7MqbNUDuMP2CdvpYEsA0KAYh47JzerNT6bsFZ-VBF7Yx2IALFGmCzM47NOaeH9prexoMxZ42eK49xnjjo8mxj4uWzj6760CGwUI+JYY1VCecOS5JbE0zVmDXx8sUkeLQLyPk25Mmy3FvjRWq0gkNWKcdOUZtpiHAwACGEgJKlayDurWpzj6lpJuNjQuxdYj4DLhXRGJAC5vSAA",
        "[Blood Pact]:___ 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",
        "[Offload]:___ N4IgdghgtgpiBcIDaB5AZmgNgewgEwF0QAaELCAN2wCcAVGADwBcEQAeAIwD5UMd8CbAPTcAOmE7Uu42gAsYAAgDKAYQCiAOTUB9FAHUtAJW0aAggFk1CvDADGASxsBnBU1kQm1mBEz2wAcwUAd3s3V3kFAAdsPyZMGCcXSOpsDnioFycAV2oUrLA8P0C3GCgFexc0GgVbWSyoSKcAOgU5GABPBWw+XDwFJ2xYLrRwmHtqcsSshIUqiZLW00MAcTVaEwsdFGMzSyVXbC8fYNDZJvFJLkuSECYIan8YJhQwOEQmammbj-t-R+oVNgCqF7ECnAAZewUIqsJDAUQgewNGh3MBMPQ0PAI+AI8ypey+JjtBHEBEaFC0bEItA+JwwEkIgBqhgAkkoANKmKlkWn0kgIyCwbnmdpKO5MFlOZbUbxMGB0dxgRk+aYMxHI6ioiVo7kARgAzAiAL7EBTw9XRTUQNEY6hYhAIgAKmCytgA1q1sG6YGB4Np-QoNAAWFn+PD+WT+Jj+SL2ABCthZpk5HFMDwAmkENOnTEmAI6mACcmAAVssVKYACIARX8cag7LUpg4-mragArEGgqYYKZwf57CglMsGKYgihMwAmHu0OMMNSYFQqfyVlC2FRQILpuPgqos7eyUxQUxH0LYJz6pQWbBMPPsoIAWlo-mWuv8pgAEoYVOzsKY4wADBAAAcQSpigebmEweAANQftu7SmI61amP4YAAFpug+TgAFJBo6kBKOYJYqLI4ZxgWah-m6K6choLKyCoGgAGJKE4FAfv4AEfh2LIqGASgQLQpjYJgpgAKooAAXv47RZBwKguuJV5VvBpgUFA1ZBkwFDoSg4KyHG+T+FJMA4emH7oemShxjBahKABDAwTASg4Xm6EYRQmCGO2DB6dWTgqLqmBKOmGgQHGzGmLqD5oHolYlrYAGYAA7FeeB9tQ65OHmebLLeABsMFQHGywwbq6H6sxlYqOJmCVqYYUllecb2GW5iRGA5gABqTkGFD6jB-g4XG6aOpOAH2LIH4qWq5KUg6PKYHSarMmynLch8qr8uA0B8jiIAfhAThKLYPp8qSFoota2pMNyAHGqa5pIpaWq2vaB0aEIXI7fN3I0stF1MqyHI-QdAMrTtgr7QikqmL4FBA1dVpoiyOqLQ9IAmmaCIvddNqYtyX0-Zdf2LRDSNraD-28mq0PcpKhjWnggxqnjKO3dy7aY9jz0am9hMIGAWSYJgpMUptnyUyDG3k7TUN7cK7QoLGYCgmA6C0PcjwSlKMoePKcjWsqLpI+zWpo3di0Pu2j048jAt2kT31zRLcuA6tMtgwiW1I-Ti1HYFgyRPEcp4Mx4xOEw4LM9W0xR04bP8zdlv3XbfOvTd73csxMqKHoBKYK7C3g-Ll1U7LpcewrQqLVrDxPGKHiStKsqG4qJvbZd5sp+jB0Pga6e48nBNO4tglq0Sxc09X5dezPkOXf7B0ik3uutwbCrGyqZsj5z1sGgBPNPcPmejx9CIT6ExK-W7B2+5763e0ti8Cori2r+KLf63KW9KjvScz77wOofY0RBSA-D+PKQEwImDqwhMzWE4CQAwAwHYJgThmI0EhNCAIsIM743RILA6zpXQeloF6H0foAzBlDOGSM0ZYwJiTCmNM-hMzZlzKYAsxYywVhrHWBsTYWxtk7N2Xs-ZBzDlHOOKcM45wLiXCuNcG4tw7j3AeI8J4oBngvFePEt57xPhfG+T835fz-iAqBcCkFoJwQQkhFCaFMLYTwgRCARESJkTrJRaitFTD0UYixNiHEuI8XbHxASQkRJiUkjJOSCklIqUrGpDSWkdJ6QMkZAIplzKWWsrZeyjlnKuXcp5byvl-KBWCqFcKkVoqxXiolZKaVTAZXBFlFQOU8qFWKqVcqlVqq1Xqo1DQzV-xtWWB1LqvV+qDWGqNcak1pqzRrjDEAhhSjYERqYWwcCgSP2potB+O0e5og0PUDg8o05YxPg7LOxCyQuzWdyUi1pHgqz8OrdA5hpZPwXrvIBFyoBXOoNyG2Q97nnxznnBQBdRZ03fgdN5AQXLikOZXakZdT6EOBaC8Fg9bn2zOUQseB0r5TxeYtFFjxP4eAxc-CmgDcWXOuYtQlRpkGoLQOgzB2DmZOCQVjIAA"
];
    
    @override
    double difficulty = 0.0;

    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#993300"
        ..aspect_light = '#BA1016'
        ..aspect_dark = '#820B0F'
        ..shoe_light = '#381B76'
        ..shoe_dark = '#1E0C47'
        ..cloak_light = '#290704'
        ..cloak_mid = '#230200'
        ..cloak_dark = '#110000'
        ..shirt_light = '#3D190A'
        ..shirt_dark = '#2C1207'
        ..pants_light = '#5C2913'
        ..pants_dark = '#4C1F0D';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Pulse", "Bonds", "Clots", "Bloodlines", "Ichor", "Veins", "Chambers", "Arteries", "Unions"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["FRIEND HOARDER YOUTH", "HEMOGOBLIN", "SOCIALIST BUTTERFLY"]);

    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Business", "Buyer", "Butler", "Butcher", "Barber", "Bowler", "Belligerent"]);

    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Blood", "Trigger", "Chain", "Flow", "Charge", "Awakening", "Ichorial", "Friendship", "Trusting", "Clotting", "Union", "Bleeding", "Team", "Transfusion", "Pulse", "Sanguine", "Positive", "Negative", "Cruor", "Vim", "Chorus", "Iron", "Ichorial", "Fever", "Heat"]);

    @override
    String denizenSongTitle = "Ballad "; //a song passed over generations in an oral history;

    @override
    String denizenSongDesc = " A sour note is produced. It's the one Agitation plays to make its audience squirm. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";

    @override
    List<String> symbolicMcguffins = ["blood","bond", "friendship", "ties", "pulse", "chain", "ocean"];

    @override
    List<String> physicalMcguffins = ["blood","photo album", "friendship bracelet", "string", "chain", "manacle", "toy army"];

    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Blood', 'Hera', 'Hestia', 'Bastet', 'Bes', 'Vesta', 'Eleos', 'Sanguine', 'Medusa', 'Frigg', 'Debella', 'Juno', 'Moloch', 'Baal', 'Eusebeia', 'Horkos', 'Homonia', 'Harmonia', 'Philotes']);


    @override
    void initializeItems() {
        items = new WeightedList<Item>()
        ..add(new Item("Mystical Vial of Blood",<ItemTrait>[ItemTraitFactory.GLASS,ItemTraitFactory.CALMING, ItemTraitFactory.ASPECTAL, ItemTraitFactory.HEALING],shogunDesc: "Vial of Not-ABs Oil"))
            //shitty fanfic, you'll always be in my blood pusher.
            ..add(new Item("Bananaphone",<ItemTrait>[ItemTraitFactory.EDIBLE,ItemTraitFactory.CALMING, ItemTraitFactory.ASPECTAL, ItemTraitFactory.FUNNY], abDesc: "Really? Yet another in-joke nobody will ever get? Good work, 'oh mighty creator'. ",shogunDesc: "Yellow Respect Device"))

            ..add(new Item("Friendship Bracelet",<ItemTrait>[ItemTraitFactory.CLOTH,ItemTraitFactory.CALMING, ItemTraitFactory.ASPECTAL, ItemTraitFactory.HEALING, ItemTraitFactory.CHAIN],shogunDesc: "Soul Binding Wrist Shackle"))
        ..add(new Item("Bonding Manacles",<ItemTrait>[ItemTraitFactory.METAL,ItemTraitFactory.RESTRAINING, ItemTraitFactory.ASPECTAL, ItemTraitFactory.HEALING,ItemTraitFactory.CHAIN, ItemTraitFactory.UNCOMFORTABLE],shogunDesc: "Handcuff with one cuff full of cigarettes"))
        ..add(new Item("Friendship Stairs",<ItemTrait>[ItemTraitFactory.WOOD,ItemTraitFactory.IRONICFAKECOOL, ItemTraitFactory.CALMING, ItemTraitFactory.HEALING, ItemTraitFactory.ASPECTAL, ItemTraitFactory.LEGENDARY],shogunDesc: "Bloodstained Stairs",abDesc:"You push your friends down these, dunkass.")); //john wanted to push karkat down these.
    }


    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.RELATIONSHIPS, 2.0, true),
        new AssociatedStat(Stats.SANITY, 1.0, true),
        new AssociatedStat(Stats.ALCHEMY, -2.0, true) //items aren't people.
    ]);

    Blood(int id) :super(id, "Blood", isCanon: true);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.blood(s, p);
    }

    @override
    void initializeThemes() {
        addTheme(new Theme(<String>["Pulse","Clots","Ichor", "Veins", "Chambers", "Arteries", "Flow"])
            ..addFeature(FeatureFactory.BLOODSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.PULSINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.MEDIUM)

            ..addFeature(new PreDenizenQuestChain("Cross the Lake", [
                new Quest("The ${Quest.PLAYER1} finds a great lake of red. On the other side, they can see a village of ${Quest.CONSORT}s in need of their help. The ${Quest.PLAYER1} will need to find a way to cross the lake of blood if they want to give aid."),
                new Quest("The ${Quest.PLAYER1} gets help from ${Quest.CONSORT}s on their side of the lake to build a massive boat. They put blood, sweat, tears, but mostly blood, into building the boat."),
                new Quest("With the boat placed into the lake, the ${Quest.PLAYER1} begins their voyage across the raging rapids. They will need all the help they can get from their ${Quest.CONSORT} crewmates to reach the other side."),
                new Quest("After hours of captaining their ship, the ${Quest.PLAYER1} arrives on the other side of the lake. It turns out they spent so long building the boat that the village fixed its own problems. A considerate ${Quest.CONSORT} hands the ${Quest.PLAYER1} a ${Quest.PHYSICALMCGUFFIN} and some boondollars in compensation.")
            ], new ItemReward(items), QuestChainFeature.playerIsHelpfulClass), Feature.WAY_LOW)

            ..addFeature(new DenizenQuestChain("Unplug the Rivers", [
                new Quest("The land is a series of candy red lakes. A wise old ${Quest.CONSORT} stops ${Quest.CONSORTSOUND}ing enough to explain that these lakes actually used to be mighty rivers, until ${Quest.DENIZEN} plugged them up with dams. Now the ${Quest.CONSORT}s can't travel or trade with other villages at all, and the land has begun to stagnate."),
                new Quest("The ${Quest.PLAYER1} discovers the correct sequence of hydraulic pumps to activate to increase the river pressure enough to jettison away the blockage in a geyser of candy red. The first river begins to flow, and the local ${Quest.CONSORT}s begin resuming trade activities.   "),
                new Quest("As the ${Quest.PLAYER1} goes around unplugging each river in turn, they begin to notice more and more debris among the candy red flow. Is ${Quest.DENIZEN} conspiring to reclog the rivers? "),
                new DenizenFightQuest("It is time for the ${Quest.PLAYER1}  to finally face the ${Quest.DENIZEN}. The rivers are too vital to the ${Quest.CONSORT}s to risk having them reclog.","The ${Quest.DENIZEN} lies slain by the ${Quest.PLAYER1}'s ${Quest.WEAPON}. The ${Quest.PLAYER1} has won! The ${Quest.CONSORT}s have a bustling trade based economy once again.","The tyranny of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.HIGH);
        addTheme(new Theme(<String>["Chains", "Unions", "Manacles", "Bonds", "Weddings", "Rings", "Webs"])
            ..addFeature(FeatureFactory.CLANKINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.MUSICSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.LOW)
            ..addFeature(FeatureFactory.SPIDERCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.LOW)

            ..addFeature(new DenizenQuestChain("Learn the Power of Teamwork", [
                new Quest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} are investigating a dungeon. Suddenly, a chain snaps out of nowhere and handcuffs them together. After some initial bickering, they learn the POWER OF TEAMWORK and complete the dungeon. "),
                new Quest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} are separated in a dungeon, and each discovers a dead end that the other can open. They use the POWER OF TEAMWORK to get to the end of the dungeon. "),
                new DenizenFightQuest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} trust each other to have their backs.  So when the ${Quest.DENIZEN} starts trying to turn them against each other, there is no question of believing its lies. They team up to strife the ${Quest.DENIZEN}.","Slaying the ${Quest.DENIZEN} proves the POWER OF TEAMWORK!","The ${Quest.PLAYER1} and ${Quest.PLAYER2} end up getting distracted bickering after one of the ${Quest.DENIZEN}'s slanderous barbs hits home. Whoops, their teamwork wasn't strong enough!")
            ], new DenizenReward(), QuestChainFeature.twoPlayers), Feature.WAY_HIGH)

            ..addFeature(new DenizenQuestChain("Chain the Towers", [
                new Quest("The ${Quest.PLAYER1} comes across a mighty series of towers, each with chains limply hanging from their tips. A wise old ${Quest.CONSORT}s explains that before  ${Quest.DENIZEN} arrived, the chains connected each tower to each other, and facilitated trade and communication between settlements. Now the ${Quest.CONSORT}s are isolated from each other, and grow more paranoid and distrustful of strangers each generation.  The ${Quest.PLAYER1} vows to help. "),
                new Quest("The ${Quest.PLAYER1} delves in dungeons until the right items are discovered to alchemize new connectors for the chains. The first set of towers are reconnected, and trade and communication immediately resumes. The local ${Quest.CONSORT}s discover that ${Quest.CONSORT}s from other villages aren't so different, after all.  Another victory against xenophobia! "),
                new Quest("The ${Quest.PLAYER1} has been working tirelessly to hook up tower after tower, only to discover that the first tower they repaired is already broken again. There is no getting around it, ${Quest.DENIZEN} needs to be stopped. "),
                new DenizenFightQuest("The ${Quest.PLAYER1} has tracked down ${Quest.DENIZEN}. There can be no mercy. ","The ${Quest.DENIZEN} lies slain by the ${Quest.PLAYER1}'s ${Quest.WEAPON}. The ${Quest.PLAYER1} is finally free to restore the chains, bringing peace and understanding to the land. ","The tyranny  and xenophobia of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(NPCHandler.JACK), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new DenizenQuestChain("Protect the Beams", [
                new Quest("The ${Quest.PLAYER1} learns of the ${Quest.MCGUFFIN} Tower, said to hold and connect all of the planet together with its many Beams. A quaking ${Quest.CONSORT} explains that the ${Quest.DENIZEN} has besieged this tower since the dawn of time, snapping each Beam one by one, and preventing the ${Quest.CONSORT}s from communciating with other villages and risking the entire planet falling apart.  "),
                new Quest("The ${Quest.PLAYER1} hears of a fantastical secret kept at the top of the ${Quest.MCGUFFIN} Tower. It is said that the ${Quest.DENIZEN} seeks to topple it to gain this secret. Perhaps the ${Quest.PLAYER1} is small enough to climb the tower to claim it themselves?"),
                new Quest("The ${Quest.PLAYER1} defeats a fearsome ${Quest.DENIZEN} minion, whose death unlocks the most direct path to the ${Quest.MCGUFFIN} Tower . "),
                new DenizenFightQuest("The ${Quest.PLAYER1} has crossed the field of roses. They blow their horn. There can be no mercy. It is time to face the ${Quest.DENIZEN}. ","The ${Quest.DENIZEN} lies slain by the ${Quest.PLAYER1}'s ${Quest.WEAPON}. The ${Quest.PLAYER1} is finally able to see what lies at the top of the ${Quest.MCGUFFIN} Tower. Oh. Huh. That's....actually kind of disappointing, actually. Oh well, at least they saved the planet, right? ","The ${Quest.MCGUFFIN} Tower is more at risk than ever before.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new PostDenizenQuestChain("One Degree of Separation", [
                new Quest("They say it can't be done, but the ${Quest.PLAYER1} is confident that they can become friends with every single ${Quest.CONSORT} on ${Quest.MCGUFFIN}book. They start small, just talking to any ${Quest.PLAYER1} that wanders by. They know they can do this!"),
                new Quest("Oh god. Less than 10% of the ${Quest.PLAYER1} population have been friended. The ${Quest.PLAYER1} is starting to think that maybe they understimated how hard this would be. "),
                new Quest("Oh god. It's all so simple. They see it now. Relationships are like a chain, or a web. All they need to do is find the most connected nodes and....yes. Those 6 ${Quest.CONSORT}s are all they need to indirectly gain access to the remaining 90% of the population. The ${Quest.PLAYER1} schmoozes the right few ${Quest.CONSORT}s and finally acomplishes the impossible. They now have AAAAAAAALL the friends!")
            ], new FraymotifReward("Friend Request", "The ${Fraymotif.OWNER} has so many friends, they have to assume everyone in this fight is already in their friend list."), QuestChainFeature.playerIsSmartClass), Feature.HIGH)

            ..addFeature(new PostDenizenQuestChain("Steal The Friends", [
                new Quest("They say it can't be done, but the ${Quest.PLAYER1} is confident that they can become friends with every single ${Quest.CONSORT} on ${Quest.MCGUFFIN}book. They start small, just talking to any ${Quest.PLAYER1} that wanders by. They know they can do this!"),
                new Quest("Oh god. Less than 10% of the ${Quest.PLAYER1} population have been friended. The ${Quest.PLAYER1} is starting to think that maybe they understimated how hard this would be. "),
                new Quest("The ${Quest.PLAYER1} decides that doing things the hard way is for chumps and just hacks into ${Quest.MCGUFFIN}book to steal all the friends. Yay, they win! They are the best! ")
            ], new FraymotifReward("Friend Stealer", "The ${Fraymotif.OWNER} is now more popular with your friends than you are."), QuestChainFeature.playerIsSneakyClass), Feature.HIGH)



            ..addFeature(new DenizenQuestChain("Pale Shipping Dungeon", [
                new Quest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} seem to be a good complement. The noodly appendages of the Horror Terrors do not fail to notice this.  "),
                new DenizenFightQuest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} have come across a strange dungeon with a diamond symbol on the door. They ignore all common sense and venture inside. Ice cream and hankies abound. There is a couch, and a sad movie playing. Huh. Oh shit, what is ${Quest.DENIZEN} doing here!?","Slaying the ${Quest.DENIZEN} proves to be the thing that finally pushes the ${Quest.PLAYER1} and ${Quest.PLAYER2} together.","The ${Quest.PLAYER1} and ${Quest.PLAYER2} are stubbornly refusing this ship by getting their asses handed to them by the ${Denizen}.")
            ], new PaleRomanceReward(), QuestChainFeature.twoPlayers), Feature.WAY_HIGH)
            , Theme.HIGH);

        addTheme(new Theme(<String>["Bloodlines","Generations","Family", "Community", "Villages"])
            ..addFeature(FeatureFactory.CALMFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.NATURESMELL, Feature.MEDIUM)

            ..addFeature(new PostDenizenQuestChain("Connect The Villages", [
                new Quest("In the wake of the defeat of the ${Quest.DENIZEN} it becomes really how isolated the individual ${Quest.CONSORT} villages are. It is far too common for a young ${Quest.CONSORT} to never have even MET their cousins. The ${Quest.PLAYER1} resolves to fix this as soon as possible."),
                new Quest("The ${Quest.PLAYER1} is working hard to restore roads, track down long lost family members and generally just remind all the ${Quest.CONSORT}s that at the end of the day they are all one big happy family. "),
                new Quest("All those hours of hard work have paid off, the individual ${Quest.CONSORT} villages have all been brought back into communication with each other. The sense of community is so strong, you could cut it with a knife. Or maybe wield it as one?")
            ], new FraymotifReward("Community Builder", "It may take a village for the ${Fraymotif.OWNER} to kick your ass, but luckily they have several."), QuestChainFeature.playerIsHelpfulClass), Feature.HIGH)


            ..addFeature(new DenizenQuestChain("Stop the Feud", [
                new Quest("The ${Quest.PLAYER1} learns that two prominent ${Quest.CONSORT} families have been feuding for generations, despite once having been the best of friends. The land is on the verge of a civil war as uninvolved ${Quest.CONSORT}s pick a side, and everyone is suffering."),
                new Quest("The ${Quest.PLAYER1} tries to track down the origin of the feud that leaves their land on the verge of a civil war. Nobody can point to any REASON for it to be happening. "),
                new Quest("In a dramatic reveal, the ${Quest.PLAYER1} discovers that ${Quest.DENIZEN} is responsible for the feud. The two ${Quest.CONSORT} families never wronged each other, it's a huge misunderstanding. But how can they prove this to the feuding families? "),
                new DenizenFightQuest("The ${Quest.PLAYER1} confronts ${Quest.DENIZEN}. The beast smuggly admits to its crimes, and claims that the proof needed lies within its hoard. Will the ${Quest.PLAYER1} be able to claim it?", "The ${Quest.DENIZEN} lies slain by the ${Quest.PLAYER1}'s ${Quest.WEAPON}. The ${Quest.PLAYER1} shows the proof to the two ${Quest.CONSORT} families, who reconcile in a dramatic shower of happy tears and ${Quest.CONSORTSOUND}ing. ","The deception of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH); // end theme
    }

}
