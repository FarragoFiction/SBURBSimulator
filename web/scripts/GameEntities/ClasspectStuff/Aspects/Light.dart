import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Light extends Aspect {

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 1.01;
    @override
    double fraymotifWeight = 0.5;
    @override
    double companionWeight = 0.01; //dont' share the spotlihgt

    @override
    List<String> associatedScenes = <String>[
        "[Introspection]:___ N4IgdghgtgpiBcIDaBJMAXATgewM4AcYBjdAS2zAF0QAaEAMwBsIA3bTAFRgA90EQAPACMAfKgw4CxMhUoCA9KIA6YYZhEqOACxgACAMoBhAKIA5YwH0A8gHVzAJQumAggFljugNZhsAd1y66FoQ6IE6uhzO9gDixhxObpZWji7u+rpE2ACujAAmulm4erjYsLqMWUSeuqRgYTCkmOWk9DA0uhBg+SX1AJ6BMBBEWvURUbHxqUkpiemduoO4-b4Q-ejYNWBEmIt6QXrYubkB2PSjWWCMpJ4wjP3B+IRgtQDmm-WNuvSs7AB0KmoRIDaCB0BBMC8YOgrGA4IgsFk4HQsKQXpDMIYKLlSDIwLgADKkFivfhIYBKECkKD4dhgjA2di5CnwCn6To43oUmgU0xWDjMinfRhFLkUgBq9hQ+gA0s4BQwIMKYKLwNBlQgKa5evowegULhojsQjBOMEwGLFYiVVSaZg6XqMPKAIwAZgpAF92uTKdTaZ10AzMEyNSAAAoVKoRbA3MDwCzx3SmAAsKBeuReWhe6Be+FIACEiChnLKhM4IQBNXymcvOIsAR2cAE5GAAraKGZwAEQAii881BpcZnEIXt3jABWJO+ZwwZz4l6kKz6aLcZy+KyVgBMM44ee4xkYhkML07ViIhigvnLefx9GwKGvWmcUGcz5xeBd+jc2HQdelvgAWg4F5oidF5nAACXsQxpWwZw8wABggAAOXxSysOtXHQXIAGoIOvXpnFDbtnBeMAAC1PAA3AACkk1DSB9FcFtDC0dM8wbYw4M8E9ZVMFAtEMUwADF9FwFgIJeBCIInFBDDANlImwRhnAAVSsAAvF5eiyIRDAqVSvy7fDnBYKBuyTdAWHIqx8S0PMLheDSYBo8sIPI8t9DzHDjH0BDuBwmB9BoutyIolhGHscduBs7tcEMJ1GH0ctTAgPNhOcJ0APoGxOxbIgEMYAB2L9cjnTBz1wOs62iX8ADYcKgPNohwp1yJdYTO0MVTGE7ZwUpbL881INtXHwMBXAADU3JMWBdHCXhovNy1DTcENILQIKMlVeX5EMhRFWhxUlGU5RDBF1W5VVYHlCCIFwfQiBgWFrV9O1-TQdB5QQj0vQpG0-XpRl5VMeQzqu3b5QOy7jqlWUocVQ6rsgG6Q31ZwrhYGGfVte1Pu+37dG9AH3qBoMQbBna+QRpUVQlOGzpZBVaaO671SZ-V7E6XJSle3GPsdENxx+kBPSJ-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-ABQCQFgIghA5wUCYFwIQUglBm70GYOwbg-BhDiGvrIfvSh1DaH0MYcw1h7DOHcM7Lw-hgjhGiPQOIyRzhpGyPkYo5RUE1EaK0eRHReiDFGJMWYixVibF2IcU4lxbiPHOC8T4rIfiAlQCCSEsJESokxLiQkpJKS0kZKydgHJeSCkikSkykKlYFqk8xal6lGlmlWl2lOlulel+lBlhlRlxkshJlpk1w5kFklkVk1kNktkdk9kDkjlyITlIJzlcBLlIIbk8w7kHkIInkXk3luAPkYAvkfk-kAUgUQUwUIUoUYU4VJoEUkUUU0UMUsUcUEI8UCUt5iVSVyVKVqVxxaUmwGUcImUWU2UOUuUeUMZ+VnBBV95hVnBRU6xxVJVpV7BZV5U6xFVlV2M1UiANUtUdU9UDUjVnATUzULUrUsgbU7UHUnVGAXU3UPUvUfU-UA0g0Q0w10AI0o10AY040E1Nwk0U0bh01M0Xhs1c181C1yxi19Iy0K0q0a060G0m0W020O0TZu0AJe1+1B1fBh1R1x0CMp0Z1yoF0l0V1cA10N0t0d091kID1VIj0T0z1Wl4JGhr18Rb0tB71H1n1X131P1v1f0jEAMgMQNOwwMIMoMUAYM4MEMkMrAUM0MMMsMcM8NfACNsM3ASMyMKMqMaM6MGMmMWMbA2MOMIAuMeM+MBMhMRMxMJMpMZM5MFMlMohVNCANMtMdM9MDMjNjEkxTNXwVQLcKRogiRZxlcKBVcQ4A43dWYe4MBtcoBddMACZRZItotYt0B4t2AwsuhcAItRYgA",
        "[Flare]:___ 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-ksGwgDIZAA",
        "[Zoned Out]:___ N4IgdghgtgpiBcIDaAtA9mGATABAeQFcAXAXRABoQAzAGwgDc0AnAFRgA8iEQAeAIwB8qDNnzESPAPSCAOmH5MBclgAsYOAMoBhAKIA5HQH08AdQMAlQ3oCCAWR04A7hACWRAM44qzHETU4ABxgmKhgAYyIcKDRYMEiiNBx3IiYXAGt1PxgXJhwYTCgAT3JffxZrcwBxHRYrOyM8Sxt7DQA6HFVs3Oc3FzAAc0CIQs80KioAQg6yiura5oam+o0vGBgaTyJg1L4aQpwCMBoCMLT971z3GPUmGAgrsBKIMFwszV0DYzMdJfscCACASYaAgYTUmzUUCi+VBfX6e1acgUAmRFBARAgTH6MCIeEw3BSBDglBSLn62KYWgwWF6GHcABkXPQ4dwkMAZCAXFAAswMXETMwsBz4BzbBB2FyCFD6Sc0hzyBy9HgWMKOVQIBsYPKOQA1cwASQ0AGlrKrqBr3FqKBzILAzbZChoMUR9e5KrcIFtWCpnjqNUTtZzubzni64maAIwAZg5AF8SuygzymHyiAKmEKEByAArHU4dNAZMDwQylnB6AAs+v6WH6Kn6RH6ARcACEwvrrCa+NYsQBNRx6XvWDsAR2sAE4aAArSpaawAEQAiv0W1AjTprHx+oudABWCuOawwaz0-ouPAaSrsayOPD9gBMR5YLfYOhoWi0-XneDCWigjl7Ft6W8fVAJUawoGsCC3DQdwow0Ow0CIEcjUcABaFh+kqCN+msAAJcwtCNNBrBbAAGCAAA5HG7PAR1sIgsAAajwwDCmsbNF2sfowBQNI0PcAApCts0gDRbCnLQVFrFsxx0Ei0i-E09H1FQtD0AAxDR3HoPD+jIvC931LQwA0CByjQGhrAAVTwAAvfpCgIPgtGOayEIXVjrHoKBFwrIh6BQPB6RUFtDn6OyYEE3s8JQXsNBbJidA0Mj2CYmANEEkcUF4+gaHMXd2CCxd3C0CMaA0Xs9AgFsNOsCM0KoEx5ynMIyJoAB2BCsBPJhf3cEcR0qZCADYmKgFtKiYiMUCjDT5y0ayaHnawqqnBCWxcGdbACMBbAADXvCt6CjJj+kElte2ze8yJcFQ8I8wMlRVLNzU1QM9UNE0zUJK0FXAaArRFEA8PuDQwnyP6OS5ZNU31cNXrIuME2h4MU1DdNM2BvRJFNa0QGes11Xe-HPuNPHgeJy1A1tIGOVdawaCZKGkxDOJ4aIM0kZAeMcETGG2bTQUzRxvH-sJ16qZZsnvsli0Wdps1XXMZ4sBiQMBfR9mEeB3dud5-m0dTTHhTAAgaBocXlR+pgA1Jg1yaJ+WacB+1CjwZswBcDA8CoFhMWxF03Q9L1VF9f0Wc1uGdY5NCbuRvnUdhjHhde0WnutuWSf+mWKY5X6XbtV7QdKmIAhoHFsHnfIXEisB6VVxciWSdwNaN0MOa5hPDeT-lU+B2w0D4FwmaIQoM5e4GC-tr687e6n8cV17-axHEnU9V13TuUOfT2vpI-b7XOcR7uk8Fk3XrFCUoClHAZVOCebbtnOHdlynncX13l4DtfnU3kPghhz3pgNuvcwzH2BvrMgJJUjkmCFSF4tIwAMlVqyaBIAYDjHCB4DSzBGTMgGKyHu59+45jzGkAsRYSxlkrNWWs9ZGzNjbB2LsPZ+j9kHMOawY5JwzjnEuFca4Nxbh3PuQ8x5TznkvNeW8D4nwvjfB+L8P4-wASAiBMCEEoJQBgnBBCg9kKoQwlhHC+FCLEVIhRaitF6KMRYmxDiXEeJ8QEsJUSEBxKSWkiuOSCklLWBUmpTS2ldL6UMruYyplzLWEsjZeyjlnKuQIO5KC84vI+T8gFIKIUwoDEitFWK8VErJVSulTK2Vcr5UKsVUq5VKrVVqvVRqzVWrtS6tYHq9I+paAGkNUa41JrTVmvNRay1Vp6HWqRLalQdp7UOsdU651LrXVuvdR6n8i7A3MDAaI9BjwRG9mAD6r857T3+lHUMegpR8GCF3HmKNWZayFhme04pJTSllIXOmIApLPGxOvY+L9Z5O2zmfJ5VyoA3KYGaNC0Z9YPIuX3F5l8+jvLvp8jZ3zfkDAys6Y5wKs4L3OYfIgEKoUwrhafR5xtSEE1xl8s02LsQe1RT7KgthpYnJBUSsFqYyW3NenHeFidqUp2RdjelmKzTrxTE6VIoR8WO0JQfMB-LoUnx5ugzBoQIjuFwUwBuLx3BoJ5kAA",
        "[Spare Sword]:___ N4IgdghgtgpiBcIDaBlADhATjABCg7gPaYAmAuiADQgBmANhAG7EAqMAHgC4IgA8ARgD5UGbHiKkyvAPRCAOmAGZBClgAtcKAMIBRAHI6A+gHkA6gYBKhvQEEAsjpwBnNIU5OcnDTjUBLOpw4hDQ4EM4SJM6cvgDGANa+YADmQQCugTSYhFChOGAwWPwAnlGE+QB0OOowJWipdHRBYDi+gfitaqENnhq+mDhQvklqgRBgJJTO2TBqhPiTUGMQSbichDiZMKveThEbWTleuE5rFTgAQuk4+BCt5fc4pmoQnADkHl6+TgD8OACSbw8ACtUicprBnH5OJwSrtiCRKgBxLJOJyVap4XQGEzmHRWWwOHB1dwtQKJHowPrOIoNCAkDg4EFg8kxCBOY7THCg3Cs5r8XD0zC+RgwSKZbKk8oKJSCGVUECcLArTjGfI8TiYVJwagaoYrTBaMokVq+MpOAAywsSSR4SGAchAvigrkwirAnFM8Id8AddkI-H8rSKDsoDr0xhY3odNAgdHZIYdADULH8UABpGxR2ix+NUB2QWBZuxFFCKzh-JzIgqcGCYdRjROxrUJx3O4hu8vurMARgAzA6AL6Te2tl0dz2kLMABToqXiVUIcRgYHghjXOD0ABY-kkSMMkpwkmhfOcYn8bBn+DZMEkAJr4PS3mzngCONgAnHQgYitDYACIAIpJOcUBpjoNj8EkAE6AArJu+A2DANjmkkvjGCgiLsDY+DGPeABMiEsOc7A6HQWhaEkf7GDEWhQPgt7nOaNCEH8DFqDYUA2BxrSEE4vYoPYbgvmm+AALQsEkiLdkkNgABIWFoaaEDY5wAAwQAAHPgV7GC+dicCQADUskMUUNhTgBNhJGAABacSiU4ABSm5TpAKB2ECWhqHu5xvjoylxJRGZ6H8ahaHoABiKBOIwslJKpsmwX8WhgCgEAsDYhB0DYACqxgAF5JEUqT8Fos45QJ-4mTYjBQABm6cIwNnGOaaiXMk+UwI5t6yTZt4oOchk6CgqnsIZMAoI5L42bZjB0BYMHsM1AFOFo3Z0Cgt56BA5wRTY3aiTQph-kCMSqXQADsAkkMhmA0U4L4voinAvgAbIZUDnIihndjZvYRX+Wg5XQf42FtQICecvjfnYaBgHYAAaeGbowvaGUkjnnLeU54apvhqLJlUtuGkYINGOYwC2yaphmWYas2ebgNAlNkyAslsigMTLizoaju2YydpwWaqYOw4Ok6Y4CxOJBZno0iZozJNZjGcY80mKbpgrPrZqrLYFiz2sVjYdDCmrfOugLfxdqzIsgEOOAjhL-PutLsvy8TEbKxTVMa7TrMq7mvP61mFYWGMJDZC2TsW+6VtC6zMG2-bjttjHHpeqzcsK7zSv+97jPU5rdOambwes+zq3ZGgdAwDWJARX0JzmuHAFaicThR6nHZx8LosO+LXdSxn2tZx7pPawHZuF37E-50HzMh04KAwHQNCd5LsfW9rSdi+b47Dw6chHyABBesfY-FwzvPT1r5O64zZfaxXAIwFA22wDLjPR93W8OknFA6iFEkfUhpxgmjNM3cYtoAEgBgDQGgMAYjuAisQS0jBrS2hThvdOk5WYzjnHEBcS4VxrkMBubcu59yHmPKec8l5rx3gfE+V8H4vw-n-EBECYEIJQVgvBRCyFULoUwthXC+ACIwCIiRMiFEqI0TogxJiLE2IcS4oMNYfEBJ+heiJcSklpJyQUkpFS6ktI6T0gZYyplzKWWsnZByzlXIQHcp5bywE-IBSCjYEKYVIrRVivFRKMFkqpXSplbKeVCrFVKuVSqf5qq1Xqo1ZqrV2pJE6t1Xq-VBrDVGuNSa01ZrzUWstVa61NrbV2vtQ6x1TrnSujYG65o7paAek9F671PrfV+v9QGwNQbg0htDREsN4ZIxRmjDGWMcZ4wJkTB+C9WYWFfoQEUNgkGmjAD7Gmt8FQl3Xs7TgehUhQH5JgXudtd7fyHrg7WR8HSn0nMfVc64tw7j3GoA8R4TxnhsK9P4f40znF7B+DG+AtC3jQCpQglkEalRsCgdgfxEQxB0ABc8WgsAWSgAjdZvYYh6DUDuc4nBfxqXwDlfAjkbCOVehFN8WgigvhQLCsyetFna0RKbF+UBtlFzzvfXm1z3THNObWC5A4YFwIQUgpwKDMCQJIE4aBdsgA"
];
    
    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#ff9933"
        ..aspect_light = '#FEFD49'
        ..aspect_dark = '#FEC910'
        ..shoe_light = '#10E0FF'
        ..shoe_dark = '#00A4BB'
        ..cloak_light = '#FA4900'
        ..cloak_mid = '#E94200'
        ..cloak_dark = '#C33700'
        ..shirt_light = '#FF8800'
        ..shirt_dark = '#D66E04'
        ..pants_light = '#E76700'
        ..pants_dark = '#CA5B00';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Treasure", "Light", "Knowledge", "Radiance", "Gambling", "Casinos", "Fortune", "Sun", "Glow", "Chance"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["SHOWOFF SQUIRT", "JUNGLEGYM SWASHBUCKLER", "SUPERSTITIOUS SCURRYWART"]);

    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Laborer", "Launderer", "Layabout", "Legend", "Lawyer", "Lifeguard"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Lucky", "LIGHT", "Knowledge", "Blinding", "Brilliant", "Break", "Blazing", "Glow", "Flare", "Gamble", "Omnifold", "Apollo", "Helios", "Scintillating", "Horseshoe", "Leggiero", "Star", "Kindle", "Gambit", "Blaze"]);


    @override
    String denizenSongTitle = "Opera"; //lol, cuz light players never shut up;

    @override
    String denizenSongDesc = " A beautiful opera begins to be performed. It starts to really pick up around Act 4. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";


    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Light', 'Helios', 'Ra', 'Cetus', 'Iris', 'Heimdall', 'Apollo', 'Coeus', 'Hyperion', "Belobog", 'Phoebe', 'Metis', 'Eos', 'Dagr', 'Asura', 'Amaterasu', 'Sol', 'Tyche', 'Odin ', 'Erutuf']);


    @override
    List<String> symbolicMcguffins = ["light","fortune", "knowledge", "illumination", "relevance", "rain", "sun", "rainbow"];

    @override
    List<String> physicalMcguffins = ["light","clover", "horseshoe", "encyclopedia","sun", "dice", "8-ball", "deck of tarot cards"];

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("FAQ",<ItemTrait>[ItemTraitFactory.ZAP, ItemTraitFactory.ASPECTAL,ItemTraitFactory.SMART,ItemTraitFactory.LUCKY],shogunDesc: "Questions to Ping JR About",abDesc:"Probably found it on a server in the Furthest Ring."))
            ..add(new Item("Flashlight",<ItemTrait>[ItemTraitFactory.PLASTIC, ItemTraitFactory.ASPECTAL,ItemTraitFactory.GLOWING,ItemTraitFactory.ZAP,ItemTraitFactory.LUCKY],shogunDesc: "Tube of Localised Sun"))
            ..add(new Item("Octet",<ItemTrait>[ItemTraitFactory.ASPECTAL,ItemTraitFactory.GLOWING,ItemTraitFactory.LUCKY,ItemTraitFactory.LEGENDARY,ItemTraitFactory.CRYSTAL],shogunDesc: "D13"))
            ..add(new Item("Horseshoe",<ItemTrait>[ItemTraitFactory.HORSESHOE, ItemTraitFactory.ASPECTAL, ItemTraitFactory.BLUNT],shogunDesc: "Horse Sneaker"))
            ..add(new Item("Rabbits Foot",<ItemTrait>[ItemTraitFactory.RABBITSFOOT, ItemTraitFactory.ASPECTAL],shogunDesc: "Rabbit Remains"))
            ..add(new Item("4 Leaf Clover",<ItemTrait>[ItemTraitFactory.PLANT, ItemTraitFactory.ASPECTAL,ItemTraitFactory.GLOWING,ItemTraitFactory.LUCKY],shogunDesc: "Plant of Luck +4"))
            ..add(new Item("8-Ball",<ItemTrait>[ItemTraitFactory.GLASS, ItemTraitFactory.ASPECTAL,ItemTraitFactory.SENTIENT],shogunDesc: "Worst Characters Only Quality",abDesc:"It seems this is never right. Ask again later or some shit."));

    }

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.MAX_LUCK, 2.0, true),
        new AssociatedStat(Stats.FREE_WILL, 1.0, true),
        new AssociatedStat(Stats.SANITY, -1.0, true),
        new AssociatedStat(Stats.HEALTH, -1.0, true),
        new AssociatedStat(Stats.SBURB_LORE, 0.2, false) //yes, technically it's from an aspect, but it's not NORMAL.
    ]);

    Light(int id) :super(id, "Light", isCanon: true);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.light(s, p);
    }

    @override
    void initializeThemes() {

        /*
        new Quest(""),
                new Quest(""),
                new Quest(""),
                new DenizenFightQuest("","","")
         */
        addTheme(new Theme(<String>["Luck","Casinos", "Gambling", "Dice", "Cards", "Fortune", "Chance","Betting"])
            ..addFeature(FeatureFactory.LUCKYFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CLACKINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.GLAMOROUSFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.JAZZSOUND, Feature.HIGH) //persona5 has changed the face of casinos for me for all time

            ..addFeature(new DenizenQuestChain("Be the Contestant", [
                new Quest("The ${Quest.PLAYER1} is searching for the lair of ${Quest.DENIZEN} when some local ${Quest.CONSORT}s run past them carrying what appears to be primitive filming equipment and fancy props. After walking a little while longer the ${Quest.PLAYER1} comes across a huge building in the distance. On the front displays a sign that seems to advertise some sort of game show."),
                new Quest("The ${Quest.PLAYER1} reaches the building and enters to find that it is in fact the filming location of a Game Show run by the local ${Quest.CONSORT}s. What catches the ${Quest.PLAYER1}’s eye, however, is that apparently the Grand Prize for winning the show is an exclusive meeting with none other than ${Quest.DENIZEN}! This could be the ${Quest.PLAYER1}’s big chance! With determination in their eye, they eagerly sign up for the next scheduled airing of the show."),
                new Quest("Tonight’s episode of the game show has gotten underway, and so far it looks like the ${Quest.PLAYER1} is doing pretty well. The show cuts to a commercial break, and the ${Quest.PLAYER1} take the time to reflect on the current situation. With their superior intellect they easily win the first round, a test of intelligence, by a mile compared to their fellow ${Quest.CONSORT} contestants. The ${Quest.PLAYER1} struggles with the second round, a test of athleticism through an obstacle course, however, and one of their opponents gains a point, tying up the game. If the ${Quest.PLAYER1} fails to win the next round, it could potentially jeopardize their chance to fight ${Quest.DENIZEN}. This next round will be one the ${Quest.PLAYER1} cannot afford to lose."),
                new DenizenFightQuest("Through sheer luck the ${Quest.PLAYER1} manages to spin a lucky number on the final round, which is merely a spin on the wheel with the number it rests on determining your reward. Your  ${Quest.CONSORT} opponents shake your hand as they admit defeat, as ${Quest.DENIZEN} emerges from the shadows, ready to fight you at last.", "${Quest.DENIZEN} lies slain. The ${Quest.CONSORT} host congratulates you on your victory and presents you your second prize, a brand new car! Unfortunately it is subsequently stolen by your opponents, who drive off, never to be seen again.","Alas, the ${Quest.PLAYER1}’s meeting with ${Quest.DENIZEN} ends in failure. And though their strife may have ended poorly, they will be remembered for being the best damn contestant this game show ever had. They will also have a consolation prize invitation to try again whenever they want!")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ..addFeature(new DenizenQuestChain("Go Big or Go Home", [
                new Quest("The ${Quest.PLAYER1} finds a sparkling Casino. Inside, amid ${Quest.CONSORTSOUND}ing ${Quest.CONSORT}s is a single door, locked by three runes, each depicting a different form of gambling, Slots, Cards and Coins. Huh. The ${Quest.PLAYER1} approaches the slots and begins to play. Finally, after what must be hours, they get three Light symbols. The Slot rune lights up. One down, two to go."),
                new Quest("The ${Quest.PLAYER1} thinks they finally have the rules of poker down enough to try the next set of gambling challenges. After a nerve wracking series of hands, they bet it all on a risky gamble, only to pull through with a Royal Flush!  The Cards rune lights up."),
                new Quest("It is time for the final gamble. A single coin flip will decide it all. No take backs, no replays.   It lands. TAILS! The Coin rune lights up, and the door is open. The ${Quest.PLAYER1} begins to prepare for whatever may lay within."),
                new DenizenFightQuest("When the ${Quest.PLAYER1} finally enters the Casino Door, the ${Quest.DENIZEN} is already rampaging. They are pissed off as fuck that they have been off screen this entire time, and blame the ${Quest.PLAYER1} for it. It's time to strife! ","The ${Quest.PLAYER1} was lucky enough to pull off a win! The ${Quest.DENIZEN} is too dead too rampage.","Bad break, the ${Quest.DENIZEN} is going to keep throwing a hissy fit.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.HIGH);
        addTheme(new Theme(<String>["Glow", "Light", "Rays","Sun", "Shine", "Sparkle", "Sunshine","Stars" ])
            ..addFeature(FeatureFactory.NATURESMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.HAPPYFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.LIZARDCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.IGUANACONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.CHAMELEONCONSORT, Feature.HIGH)

            ..addFeature(new DenizenQuestChain("The Candlestick Taker", [
                new Quest("The ${Quest.PLAYER1} walks into a ${Quest.CONSORT} village, and finds all of them standing dejectedly in the village center. Their town has a monthly ceremony celebrating ${Quest.PHYSICALMCGUFFIN}, but ${Quest.DENIZEN} has hoarded all of the planets ${Quest.MCGUFFIN} Candles, and everyone knows you cant have a good ${Quest.PHYSICALMCGUFFIN} ceremony without candles! The ${Quest.PLAYER1} vows to take back some ${Quest.MCGUFFIN} Candles for the poor ${Quest.CONSORT}s. "),
                new Quest("After a long search, the ${Quest.PLAYER1} has found the warehouse where ${Quest.DENIZEN} has stored all the candles. ${Quest.MCGUFFIN} Candles must be very valuable to ${Quest.DENIZEN} for some reason, because the warehouse roof is swarming with minions, waving a lot of bright spotlights in random intervals. The spotlights will need to be dealt with if the ${Quest.PLAYER1} wants to sneak in without alerting a horde of ${Quest.DENIZEN} minions."),
                new Quest("After spending hours attempting to determine the rotation of the guards and the patterns of spotlight waving with no luck, the ${Quest.PLAYER1} realizes they dont have to avoid the lights if they can turn them off instead. They locate an unguarded electric panel outside and cut the power. The ${Quest.DENIZEN} minions dont even leave the roof; they just confusedly wave their now useless spotlights, allowing the ${Quest.PLAYER1} to slip inside with ease. Captchaloging as much ${Quest.MCGUFFIN} Candles as they can, the ${Quest.PLAYER1} triumphantly returns to the village among the joyful ${Quest.CONSORTSOUND}ing of the ${Quest.CONSORT}s."),
                new DenizenFightQuest("The ${Quest.PLAYER1} is ready to challenge the ${Quest.DENIZEN} to keep them from restealing the ${Quest.MCGUFFIN} candles. ","Never again shall the ${Quest.CONSORT}s be without ${Quest.MCGUFFIN} Candles!","The ${Quest.MCGUFFIN} candles are once again at risk.")
            ], new DenizenReward(), QuestChainFeature.playerIsSneakyClass), Feature.HIGH)

            ..addFeature(new DenizenQuestChain("Shine the Light", [
                new Quest("The ${Quest.PLAYER1} finds an incongruous dark patch in the otherwise brightly lit land. A quivering ${Quest.CONSORT} explains that the ${Quest.DENIZEN} has forbidden the ${Quest.CONSORT}s from having light, and moved giant disks to block it from them. Now that's just being mean!  The ${Quest.PLAYER1} vows to help.   "),
                new Quest("The ${Quest.PLAYER1} has finally managed to destroy the disk blocking light from the ${Quest.CONSORT} village. There is a chorus of happy ${Quest.CONSORTSOUND}s as they bask in the light. The ${Quest.PLAYER1} feels good about a job well done. "),
                new Quest("Disaster!  The ${Quest.CONSORT} village is once again shrouded in darkness, this time from an even larger disk than before. Judging from the roars, the ${Quest.DENIZEN} is guarding the disk themself.  The ${Quest.PLAYER1} must prepare themself for a tough fight.  "),
                new DenizenFightQuest("The ${Quest.PLAYER1} has managed to reach the disk guarded by the ${Quest.DENIZEN}. The monster denies even so basic a right as light, there can be no quarter. It's time to strife!","The ${Quest.DENIZEN} is defeated, the disk destroyed. Finally, the ${Quest.CONSORT}s can enjoy the light in peace.","Darkness reigns.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            , Theme.HIGH);

        addTheme(new Theme(<String>["Knowledge","Information","Books","Encyclopedias","Understanding","Libraries"])
            ..addFeature(FeatureFactory.MUSTSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.TURTLECONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.STUDIOUSFEELING, Feature.HIGH)

            ..addFeature(new PostDenizenQuestChain("Moderate the Wiki", [
                new Quest("Now that the ${Quest.DENIZEN} has been defeated, there really needs to be some way to organize all this information from their Lair. The ${Quest.PLAYER1} sets up a wiki and settles in to help the ${Quest.CONSORT}s deal with it all."),
                new Quest("Within barely any time at all, the ${Quest.CONSORT} wiki is a huge success! Everybody works hard and shares their expertise, and the ${Quest.PLAYER1} makes sure all of the information is from credible sources."),
                new Quest("When the ${Quest.PLAYER1} falls ill to a mysterious illness, it's one witness' quick check of the wiki that saves the day. It turns out it was their peanut allergy acting up, not an illness at all! ")
            ], new FraymotifReward("Information Network", "The ${Fraymotif.OWNER} has assembled just, ALL the knowledge. How can you possibly hope to beat them?"), QuestChainFeature.playerIsHelpfulClass), Feature.HIGH)


            ..addFeature(new PostDenizenQuestChain("Create the Wiki", [
                new Quest("Now that the ${Quest.DENIZEN} has been defeated, there really needs to be some way to organize all this information from their Lair. The ${Quest.PLAYER1} shrugs and sets up a wiki and lets the ${Quest.CONSORT}s deal with it all."),
                new Quest("Within barely any time at all, unmoderated ${Quest.CONSORT} wiki is a huge disaster. Misinformation abounds. There are no less than three articles on the ${Quest.PLAYER1} alone, and each claims they are a different SPECIES entirely. The ${Quest.PLAYER1} finds this to be hilarious."),
                new Quest("Luckily it turns out all that disinformation running around about the ${Quest.PLAYER1} thwarts some would be assasins. It turns out the ${Quest.PLAYER1} is NOT deathly allergic to peanuts, after all. That's what you get for trusting a wiki, assholes. ")
            ], new FraymotifReward("Disinformation Network", "The ${Fraymotif.OWNER} allows you to make you own assumptions about things, and be destroyed by them."), QuestChainFeature.playerIsDestructiveClass), Feature.HIGH)


            ..addFeature(new DenizenQuestChain("Shed the Light", [
                new Quest("${Quest.CONSORT}s are falling ill left and right due to a mysterious Plague. It doesn't seem to follow the pattern of a disease, having no communicability. What is going on and how can the ${Quest.PLAYER1} possibly stop it?"),
                new Quest("The ${Quest.PLAYER1} pours over maps and charts. What do the sick ${Quest.CONSORT}s have in common with each other?  Finally, there is a flash of inspiration. ${Quest.CONSORT}s who live or work closer to a particular river that meanders across the planet are the ones becoming ill! The ${Quest.PLAYER1} quickly orders the river quarantined and new cases begin to taper off. Now it remains to see what can be done about those already sick. "),
                new Quest("The ${Quest.PLAYER1} analyzes the water from the contaminated well. Boiling it reveals a thick black sludge.  The collected steam is found to be perfectly safe to drink. The ${Quest.PLAYER1} discovers that the sludge causes a strange vitamin deficiency, and supplies the town with supplements to fix the sickness.  Things are looking brighter, indeed."),
                new DenizenFightQuest("The ${Quest.PLAYER1} traces the contaminated river back to it's source. The ${Quest.DENIZEN} is revealed to be dripping the gross as fuck sludge into the river. When negotiations fail to make it leave the water, the only remaining option is strife. ","The ${Quest.PLAYER1} is victorious. The ${Quest.DENIZEN}'s body despawns, along with all the sludge in the river. The Plague is finally over!","The darkness of the Plague remains.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH); // end theme

        //light is a special snowlake and can have 4 themes
        addTheme(new Theme(<String>["Spotlights","Attention","Drama","Stars","Glamor","Holywood"])
            ..addFeature(FeatureFactory.GLAMOROUSFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.LUCKYFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.JAZZSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.MUSICSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.DISCOSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.LOW)
            ..addFeature(FeatureFactory.SWEATSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.ENERGIZINGFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.LAUGHINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CLAPPINGSOUND, Feature.HIGH)
            ..addFeature(new DenizenQuestChain("Be the Star", [
                new Quest("The ${Quest.PLAYER1} is approached by a Fast Talking ${Quest.CONSORT}. Apparently the ${Quest.PLAYER1} has EXACTLY the right look to be the lead in the upcoming production of The Beautiful ${Quest.PHYSICALMCGUFFIN}. The ${Quest.PLAYER1} agrees to perform the titular role."),
                new Quest("The opening night performance of the Beautiful ${Quest.PHYSICALMCGUFFIN} is a huge success! The ${Quest.CONSORTSOUND}ing of the fans is it's own reward!"),
                new Quest("When it comes time for the next performance of the Beautiful ${Quest.PHYSICALMCGUFFIN}, the ${Quest.PLAYER1} is turned away at the door. Apparently the ${Quest.DENIZEN} rampaged and terrorized ${Quest.CONSORT}s until given the lead role. They claim that the ${Quest.PLAYER1} is FAR too drab to be give such an important performance. WHAT. THE. FUCK. The ${Quest.PLAYER1} isn't going to let this stand."),
                new DenizenFightQuest("There is not enough room on the stage for both of them. The ${Quest.PLAYER1} challenges the ${Quest.DENIZEN} to a glamour off, and wins handily. Enraged, the ${Quest.DENIZEN} attacks.","The ${Quest.PLAYER1} can finally get back to their promising acting career in peace.","The acting career of the ${Quest.PLAYER1} is in shambles.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new PostDenizenQuestChain("Be the Biggest Star in Paradox Space", [
                new Quest("After the ${Quest.DENIZEN}, the ${Quest.PLAYER1} is disappointed to learn that barely any of the ${Quest.CONSORT}s know who they are. This will not do!"),
                new Quest("Posters, ad campaigns, catchy jingles, and the ${Quest.PLAYER1} still runs into the odd ${Quest.CONSORT} that doesn't recognize them on sight. This is getting ridiculous!"),
                new Quest("The ${Quest.PLAYER1} thinks they finally have an idea.  They focus. Light-y bullshit effects rain down from the sky, and their face is super imposed over the brilliance of Skaia itself. Now EVERYONE on their planet knows who is the most important. It is them.")
            ], new FraymotifReward("What's my name?", "The ${Fraymotif.OWNER} is famous, and everyone in this fight is lucky to have met them."), QuestChainFeature.playerIsHelpfulClass), Feature.HIGH)
            , Theme.HIGH); // end theme
    }
}
