import "../../../SBURBSim.dart";
import "SBURBClass.dart";
import "../../GameEntity.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";
class Waste extends SBURBClass {
    @override
    String sauceTitle = "Scourge";

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 0.01;
    @override
    double fraymotifWeight = 0.01;
    @override
    double companionWeight = 1.01;

    @override
    List<String> associatedScenes = <String>[
        "Waste I:___ N4IgdghgtgpiBcIDqEDOAXGACAkiANCAGYA2EAbgPYBOAKjAB7oIgA8ARgHwDKOAIgFEAigFUB3WvFYB6LlloALbNwDCAgHICA+gHkkmgEpb1AQQCyArAogBjANaos6JVgDm0bAEswWAFYBXDCcXak9XBXQsAHcIAE9giEjPSOoYV08MGGpHZxgoLDQrCm9XLBtKKAAHEhhMABMCrFRPOpgAR38YIKjkhUp-SOtyEqdKLDqxiDB4qJo7ADp5F1UNbT1DY3NLVChPGsdC3KwAHRBm1o6uyPKqmsxTrFhUVAhXbAhKypgIbPwsdgGWAyWAGmGoJHidQyH0qlG89VGWCI3gazkSwWw1X89lGdhgPlyM36JAaYBoUAgJAhWFSNhgnnI2GsjnYMHx4wyXzAqBgDW8WEqClizRslKR5MWSGsSRyCmBNmoHwA-McwBxqJx1ZwCCB0D83ugdGA4Ih0NROjqzWE3tQVJQwFD0J57agADIMkosADawFOniqND1YHQSBodVO8FO6mkJlO+CjOloEdOREpPLjpwAagYcNwANKxhAptMwDPgDzJkA4VDcGAkIhl-2w6hB9A4YOVgAMpwAvn9fSAm4GpiGw5Xo4X4yB1InK6mSOmCFmc-nC5HiCWy5BYJXqyYSAzS0vBwGWyP2+gu73+37T63Q9Rw0XpzGyzOk8+zZ0y9ncwW55ux7bke67VgA4pQdS0J4WSNne54ds+3YgH2WADkOZ7Bg+T7rgACiQ2J2PIlB4mA8BaBRWDqAALDgrh1OErjoK4lSeAAQjYOAmAW7AmNQrgAJpROoAkmFxbQmAAnCQvhgSoJh8EIrhsVAeYCCY7CuEIAgAKzUVEJgwCYrrpDo3BgQwJhRDoQkAEyGbQbEMAIJAqCorh8DoNgqFAUQCWxrpEJQOD+QoJhQCY4XJJQqAAMzcOYlDoG0eZRAAtLQrhgQAjK4JgABIGCoeaUCYbGdhAAAcUS8TobRmOgdQANT5f5sQmLhQgmK4YAAFp2GlqAAFLUbhkDcGYvgqAoDFsRJAilXYHkFuoOAKCo6gAGLcKg5D5a4nb5bpOAqGA3AQLQJiUCQJgiDoABerixP47AqARIgJQprUmOQUBCNR6DkL1OiugobH+GArj3TAQ0CflvUCdwbFNeInYME1MDcENbS9X15AkAYOkMMDQioCo2UkNwAnqBAbGbSY2VpUQSB8L4NidiQADsCV1MZ1DeagbRtGByUAGxNVAbFgU12W9bFm18CoIgkHwJjU74CVsZ4slmJUYBmAAGrZ1HkLFTWuENbECbhtmdp4Cj5Z9b6zp+5pHlOv6rgBC7u6cwGVvlaDcHSxpwc2rYXleKE3ie4cjth46vse77e4uHsrv+z7zmnfsVs+1YGFMExQGHw7BpHz6xbF15obecdYWOz74YRxGkc7H7rl+vsgJ7mfrtn3f+8+geoDgmBQDTsBPlOGER4h67IT2AC6lqhK4Np2g6yTOtyrpF96K+EDARBEDANjoKgm00O6wyQ966HwQ3j6VptqTYEgewkFuefrtNUxvGYWI3A9SXmPL3NcxYfal0wugdQ-goCsmoJWNK2Vq7R1rrHMuo5n7PnOmAZIsRv47mfH-SGMBAHAMSD+DOECNxQOPLPEccCEGwWfKgmuD967YJwqcZuOJaAkXxORSiNE6IMQUExFi7FOLcQ0nxQSwlRLiSkjJOSCklImH8CYRQJghoQBEJ5FQXE+D2xwDpA2BgoCZjYgVMwMABCbTAiIUWqABJgW4K4AQlUuoG3akQkCpwwKHjHnkahf5aFd2ga2ZhiCo7Lx1MfU+59L7XyLqgA+KEgA",
        "Waste II:___ N4IgdghgtgpiBcIDqEDOAXGACAkjkANCAGYA2EAbgPYBOAKjAB7oIgA8ARgHwDKOAIgFEAigFVBPOvDYB6bljoALbDwDCggHKCA+gHkkWgEraNAQQCygrIrRZ0yrAHNoMAOSosAYyoATbBHQ7ZQBLGi8qKCgIMB8AOiwNWijSLFRgvwBHAFcYDFQCIOwqMFyggKwfYtdAmhhs0P8wAE8sJgAHUipg9ADg4qwqYkKnF3C-AohasGqsCCw2mioOUhgoeNNSFPsVdS09A0FjM0trW3QqCovgj08bMEd-LGIYAHcsCkngiGXS6J9htKZHIYcJQDowTAebqoGCkYjxXRDbxZGgwgocGDBe7DDhZRyOFptYIwTxFIaoRTdMqBKnXArbEawLAAKyyINQRPQHioWUCczaiiaaU8EBSAAVSFlPABrBRUaUwMCzQIMtSaHT6IwmCyCdabLBY2YVCBNdxYF60WXEWhGlAYGCxAA6YE4NC4rq4hBAPRoD3QuhKrHQNByXuDwXxMBoqmKPm6fTAqAAMsEKFjHKwANrAR0gYJg2g9MDoJC0Hy5+C5jQyUy5ghV3R0Cu54iimF13MANUMOB4AGlawgW22YB3wC5myAcKgeLDiGP821C9F0Dhi5OAAy5gC+BRzeYLNCLJbLk+rg-rIA0jcnrdI7cIXZ7-cHlZII7HkFgk+nG1To8fA8lyPFc13QTcdz3XNF2XYtSxocshyvGsx2vJskLvB9L27XsB1vD9AK-AC32nABxXw6GJGgF0PY8wIgkBdywfcYJAuDTyQiUpVlOh5UVeBtEEhIABYcEcHxHEURx0EcIkACFPBwUwBw4UxfQATReDR1NMJSMlMABOUhmVI1RTH4YRHDkqA+0EUwOEcYRBAAVmEl5TBgUwk0cYJdB4UjGFMF5dE0gAmDy6DkxhBFIVRVEcfhdE8VQoBedS5KTa0cHSxRTCgUw8u6KhUAAZh4CwqHQDI+xeABaOhHFIgBGRxTAACUMVQ+yoUw5I3CAAA4XlU3QMnMdAfAAaja9KmlMMVhFMRwwAALWlWrUAAKWEsVIB4cxmVURQJLk-TBB66UEoHDQcEUVQNAAMR4VAKDaxwNzalycFUMAeAgOhTCoUhTFEXQAC8CSyDhVElURyvMmbTAoKBhGE9AKBW3Qk0UOSsnuMGYE29S2pW9SeDkyaJA3RhJpgHhNoyFbVooUhDGcxhMeEVBVCa0geHUjQIDkh7TCa2riCQfhmU8DdSAAdnKnwvJoZLUAyDJSKqgA2SaoDk0jJqalaSoe-hVFEUh+FMAXmXKuTghM8w2jAcwAA1QuEigSsmxxNrk9SxVCjdgkUNr4dQm8kODHIxxwl98PvADLyIyc2rQHhSRKGjgLo9ckK3RioKA2CTwQs8UMAtCE6wp9cNfYdE8-CckOnQw-gibOS-opCta1yDmOg2iV3gxC3y4mU5QVMAI-Qt9o6T2v44wgjk+bt809QHBMCgQXYEQy9WNz8D853ABdMMaAjB5o1jeNimTP4s3PogYGIZ5PC5B7aBTNN7izFih7sTLkhB6tRsBIGCJsJu34kJHWiA8cwTQeA9GPthZ8eFl6N0AofFcGgshQAxNRJCtUmolQLkxABOdh4cTfH9MA3QmjQOIrmOB9wYCIOQQEWO6D67viwQfQB6A8EEKjJOUh5Ci44KAaPXM48eJ8TAAJISGhRLiUktJWSwQFJKRUmpRwmltK6VMPpIyJkzIWValkUwShTCbQgKIRKqglL8BDjgZyrtDBQE7HJdq5gYCCAeqRUQWtUDqVIjwRwggBqLVdnNJhk5SL-i3qsbhddJzz07mxIR+DCEMW3M-EAr936f2-n8VAT9GJAA"
];

    @override
    List<String> levels = <String>["4TH WALL AFICIONADO", "CATACLYSM COMMANDER", "AUTHOR"];
    @override
    List<String> quests = <String>["being a useless piece of shit and reading FAQs to skip the hard shit in levels", "causing ridiculous amounts of destruction trying to skip quest lines", "learning that sometimes you have to do things right, and can't just skip ahead"];
    @override
    List<String> postDenizenQuests = <String>["figuring out the least-disruptive way to help the local Consorts recover from the Denizen's rule", "being a useless piece of shit and not joining cleanup efforts.", "accidentally causing MORE destruction in an attempt to help clean up after their epic as fuck fight agains their Denizen"];
    @override
    List<String> handles = <String>["wasteful", "worrying", "wacky", "withering", "worldly", "weighty"];

    @override
    bool isProtective = false;
    @override
    bool isSmart = true;
    @override
    bool isSneaky = false;
    @override
    bool isMagical = false;
    @override
    bool isDestructive = true;
    @override
    bool isHelpful = false;

    Waste() : super("Waste", 12, false);

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.SBURB_LORE, 3.0, false), //basically all Wastes have.
        new AssociatedStat(Stats.EXPERIENCE, -2.0, false)
    ]);

    @override
    bool highHinit() {
        return true;
    }

    @override
    bool isActive([double multiplier = 0.0]) {
        return true;
    }

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Yardstick",<ItemTrait>[ItemTraitFactory.STICK, ItemTraitFactory.CLASSRELATED,ItemTraitFactory.PLYWOOD, ItemTraitFactory.LEGENDARY],abDesc:"Wait. Did you beat LORAS?"))
            ..add(new Item("SBURBSim Hacking Guide",<ItemTrait>[ItemTraitFactory.BOOK, ItemTraitFactory.CLASSRELATED,ItemTraitFactory.SMARTPHONE,ItemTraitFactory.PAPER],shogunDesc: "The Shoguns Guide to Winning",abDesc:"Hell no, you leave your grubby fucking mitts outta the code."))
            ..add(new Item("Body Pillow of JR",<ItemTrait>[ItemTraitFactory.CLOTH, ItemTraitFactory.CLASSRELATED,ItemTraitFactory.PILLOW, ItemTraitFactory.IRONICSHITTYFUNNY, ItemTraitFactory.COMFORTABLE,ItemTraitFactory.SAUCEY],shogunDesc: "The Shoguns Vessel",abDesc:"...I would ask why, but I already calculated all possible responses at a million times the speed I could get an answer."))
            ..add(new Item("Nanobots",<ItemTrait>[ItemTraitFactory.ROBOTIC2, ItemTraitFactory.CLASSRELATED,ItemTraitFactory.AI],shogunDesc: "NANOMACHINES SON, THEY HARDEN IN RESPONSE TO PHYSICAL TRAUMA",abDesc:"Oh look, a NON hacking way to fuck everything up, forever."));
    }
//wastes comically suck at combat
    @override
    double getAttackerModifier() {
        return 0.5;
    }

    @override
    double getDefenderModifier() {
        return 0.5;
    }

    @override
    double getMurderousModifier() {
        return 0.5;
    }

    @override
    void processCard() {
        storeCard("N4Igzg9grgTgxgUxALhAZQQglgOwOYAEAhgQOpFgAuSANCDkQLZKoAqCjADgDZHUFpEOWiGoAPSihAQA7sJgIGzGAQBmuACZhiBRkTxY4RbgQBGECAGsCuApQAW2FX0qGCM+1m4ICnjbkJVGAhGAkhmMyhubiwEMAA6MlkaYk5OIgUcSm4ATztHPIyfBx84ewgwRQIIYTUIFXCfS01q1V19Q2NiDQA3RUpYBAB+AB0cEDpTIjhLPGCoHA0AOSYWEABBSlc4eM58CdEYLDw8BBgAYXsiHEQpAAZ4gFYDsCE41ggAVRxuCBmpADawBG4Gg8AQIOQIPiMJBNBBSghKBBACUsBofCQALIdOAEAAiEDwcJB4kokJB1TkZ0UqxURwx2hIegMRhMqigMwCBA0RJ5MH0NXy3OuGh5CFUCD4TOi+SckWisTAAEICABJSgAcm0JTMcUowvwdggviIfQICD6KiuaUUCDFtl1nio9TyEDaAAUMkReWIBJwYTC1bopTgCAAZLCStBYRjxEkgKYzObQRYrZgU9CWKIIXb4BOUI4nM6Xa6ITMARnidwTrztYA+31+M0zAIAugmFGAopQwGhKNLW8CRgjViOKSOQCi1QBxAASrAAogB5T5oAgAMU+KIAmuOJvuesYoBDJ1DJwAmfcAXw7B8Ox1OMH70vDcUqMFbd-hD+Lz4HvYzgofBnEO+6Ivu56orOC4rmum7bnuk7wpOR7cCekH7hWN7fqSRZPi+vaLgAjlAxhfiCt4HF2PZ9gBYCAsC9BjsiU4wUuq7rluu4JmhGGsdhIBUXQhaPmchFgG+YAfoCbYHKJf4SUBUrUDAsnyfh4n0SRZHcOp15AA");
    }


    @override
    num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
        if (stat.isFromAspect || stat.stat != Stats.SBURB_LORE) {
            powerBoost = powerBoost * 0; //wasted aspect
        } else {
            powerBoost = powerBoost * 1;
        }
        return powerBoost;
    }

    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        //wastes will basically never have aspect themed quests. They are WASTES after all.
        //Hussies denizen was OBVIOIUSLY falcor, the luck dragon. His denizen quest was to beat up his bullies.
        addTheme(new Theme(<String>["Horses","Fields", "Meadows", "Majesty","Ponies","Screens","Fourth Walls","Self Inserts", "Meta","Indulgence"])
            ..addFeature(FeatureFactory.ZOOSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.STUPIDFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CREATIVEFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.NATURESOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.CLACKINGSOUND, Feature.HIGH) //sound of keys being pressed
            ..addFeature(FeatureFactory.CONFUSINGFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.NOTHINGSMELL, Feature.MEDIUM)

            ..addFeature(new PreDenizenQuestChain("A Complete Waste Of Time", [
                new Quest("A short while after arriving at their land, the ${Quest.PLAYER1} decides to fuck around. But to nobody's surprise, they discover historical documents that spell impending doom to every ${Quest.CONSORT} in the land. Blah blah blah, a meteor will strike in seven minutes and they must travel back in time to redirect the meteor and save everyone, blah blah blah, you've all heard it before. Surely ${Quest.PLAYER1} can't fuck this up."),
                new Quest("Of course, they do fuck it up. Living up to their classpect, they decide to first visit the far future(i.e. 8 minutes from now) to see what the consequences of their procrastination might possibly be. After all, they have all the time in the world, right? However, the second ${Quest.PLAYER1} sets foot in the future ${Quest.PLAYER1} is almost compeletly annihilated by burning rubble and debris. Luckily, a future ${Quest.PLAYER1} warps in and brings them to safety with seconds to spare! Great! But NOW you're going to save the ${Quest.CONSORT}s, right?"),
                new Quest("Wrong. ${Quest.PLAYER1} manages to waste EVEN MORE TIME by fucking around in general with random shit. Needless to say, eventually they get their shit together and finally time travel to a time in the past with plenty of time before the meteor strike. They manage to convince the ${Quest.CONSORT} leader to use magic (i.e. strap a bomb on a spaceship) to blow up the meteor before it becomes a problem! Great. At least ${Quest.PLAYER1} has grown SLIGHLTY more mature over the course of this."),
                new Quest("But now they have to create a stable time loop. Of course, ${Quest.PLAYER1} didn't plan any of this out beforehand, so in a rush of action(and procrastination) they get around to saving their past (but technically future) self. Then they place the historical documents in a place where they'll be found in a few hundred years. Finally, they warp back to the present (future?) to do whatever else they have to do on this godforsaken land.Good job! The quest is finally over. ${Quest.PLAYER1} gets to fuck around as much as they want! Luckily, they have matured slightly over the course of the quest, so they will finally understand the importance of good time management and who am I kidding. They get back to fucking around right away. Great job growing as a person, dumbass.")

            ], new Reward(), QuestChainFeature.timePlayer), Feature.WAY_LOW)

            ..addFeature(new DenizenQuestChain("Stop the Turtles from [Redacted]", [
                new Quest("{Quest.PLAYER1} explores their land but is horrified to see all of the turtles [REDACTED]ing. ${Quest.DENIZEN} probably is making them [REDACTED]. ${Quest.DENIZEN} is a [REDACTED] piece of shit. Also. Why are there even turtles here? Is it a refrance?"),
                new Quest("${Quest.PLAYER1} tries to manually separate the turtles by catching them with a net and ${Quest.WEAPON}. They have mixed results, and ${Quest.PLAYER1} probably got some reptilian-borne disease. ${Quest.PLAYER1} tries drugging the water with [REDACTED], this works, but that throws the ecosystem out of balance as the fish aren’t [REDACTED] anymore."),
                new Quest("${Quest.PLAYER1} manages to fix the fish problem, but is back where they started with the turtles. ${Quest.DENIZEN} cackles from their giant castle. ${Quest.PLAYER1} needs to take a break from trying to get turtles to stop [REDACTED]ing."),
                new DenizenFightQuest("${Quest.PLAYER1} has learned some stuff, and thinks that they can get the turtles to stop by changing the turtle [REDACTED] values in the game’s code. This pisses the ${Quest.DENIZEN} off and causes this entire strife thing to happen. Bluh.", "Okay. FINALLY, the turtles have stopped ${Quest.CONSORTSOUND}ing. Everything is fine again. Wait. ${Quest.CONSORTSOUND}ing? Is that what all that [REDACTED] was? I thought.... Nevermind.","These god damned turtles are never going to stop [REDACT]ing.")
            ], new DenizenReward(), QuestChainFeature.bloodPlayer), Feature.WAY_LOW)

            ..addFeature(new PreDenizenQuestChain("Be Spooked By a Wolf", [
                new Quest("The ${Quest.PLAYER1} is trapped in an attic. Bullies chased them here. AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH!  Oh god, that Wolf Head is terrifying!"),
                new Quest("QUITE FRANKLY, your majesty, I don't think you realize what kind of hell the ${Quest.PLAYER1} been through. Do you have even the SLIGHTEST CLUE how many times that wolf head over there has SCARED THE SHIT OUT OF THEM???"),
                new Quest("Fuck. The ${Quest.PLAYER1} is so upset that you don't understand how scary that Spooky Wolf is that they've started babbling about different forms of fictional romance. Welp. Nothing to see here. We better just skip this. ")
            ], new Reward(), QuestChainFeature.defaultOption), Feature.WAY_LOW) //not guaranteed like other quests are
            ..addFeature(new DenizenQuestChain("Be The Illegitimate Player", [
                new Quest("A wizened ${Quest.CONSORT} explains the rules of some convoluted, boring-ass puzzle to the ${Quest.PLAYER1}. Wait wait wait, did they just say something about 'no legitimate way to meet ${Quest.DENIZEN}'?  Hell FUCKING yes, that means there's some ILLEGITIMATE way. "),
                new Quest("After way too much obsessive focus, the ${Quest.PLAYER1} thinks they are onto something. This shitty game is just code, right?  There must be some glitch or exploit or out-right fucking HACK to get to the secret content.  They are gonna meet the FUCK out of ${Quest.DENIZEN}."),
                new Quest("Hell FUCKING yes!!! The ${Quest.PLAYER1} has bugged and fussed and meddled with the code until they are standing in front of ${Quest.DENIZEN}. After solving some bullshit extra bonus Riddle, they gain access to The Hoarde. ")]
                , new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_HIGH)

            ..addFeature(new DenizenQuestChain("Wear the Merch, Be the Rider", [
                new Quest("The ${Quest.PLAYER1} is sick and tired of being bullied!  If only there was some way they could finally defeat those mean old bullies.   A wizened ${Quest.CONSORT} tells of a legendary artifact that could-- Wait. No. That's so boring.   The ${Quest.PLAYER1} decides to update their highly-indulgent meta work instead."),
                new Quest("Holy shit, did you know you could alchemize MERCHANDISE of your highly indulgent meta work? The ${Quest.PLAYER1} is just covered in merch now. It's great."),
                new Quest("Holy fuck! It turns out that the ${Quest.DENIZEN} is a fan of the ${Quest.PLAYER1}'s highly indulgent meta work!  They also agreed to be called 'Falcor', because, come ON that was a great movie!  The ${Quest.PLAYER1} hops up onto Falcor's back and this is the single coolest thing that has ever happened in all of Paradox Space."),
                new Quest("With a dramatic 'BORF' the bullies are defeated by Falcor! And so came to an end the most heroic thing that ever happened in the history of metafiction. <br><br>Let's move on.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_HIGH)
            ..addFeature(new PostDenizenQuestChain("Die Ironically, In The Proximity Of Some Horses", [
                new Quest("A wizened ${Quest.CONSORT} tells the ${Quest.PLAYER1} that they are going to die. Ironically.   In the proximity of some horses.  The ${Quest.PLAYER1} shrugs and keeps updating their highly indulgent meta work. "),
                new Quest("Glowing letters, three stories tall,  lit by flame, heavy with the weight of prophecy proclaim 'You Are Going To Die. Ironically.   In the Proximity Of Some Horses'. The ${Quest.PLAYER1} wonders if it's like, a metaphor or something?"),
                new Quest("In a scene predicted by no one, the ${Quest.PLAYER1} dies. In the proximity of some horses. How ironic, that their very demise would be in the proximity of some horses. What? You didn't follow that? Just think it over. Think it over...  Luckily being dead doesn't seem to affect the ${Quest.PLAYER1}'s narrative importance at all.   Hell, are you sure they weren't dead all along? ")//hussie has white ghost eyes the whole session, after all.
            ], new BoonieFraymotifReward(), QuestChainFeature.defaultOption), Feature.LOW)
            ..addFeature(new PostDenizenQuestChain("Die Ironically, In The Proximity Of Some Pigeons", [
                new Quest("A ${Quest.CONSORT} that is also a SHOGUN minion tells the ${Quest.PLAYER1} that they are going to die. Ironically.   In the proximity of some pigeons.  The ${Quest.PLAYER1} shrugs and keeps updating SBURBSim. "),
                new Quest("Glowing letters, three stories tall,  lit by flame, heavy with the weight of prophecy proclaim 'You Are Going To Die. Ironically.   In the Proximity Of Some Pigeons'. The ${Quest.PLAYER1} wonders if it's like, a refrance or something they are missing?"),
                new Quest("In a scene predicted by no one, the ${Quest.PLAYER1} dies. In the proximity of some pigeons. How ironic, that their very demise would be in the proximity of some pigeons. What? You didn't follow that? Just think it over. Think it over...  Luckily being dead doesn't seem to affect the ${Quest.PLAYER1}'s narrative importance at all.   Hell, are you sure they weren't dead all along? ")//hussie has white ghost eyes the whole session, after all.
            ], new FraymotifReward("Hey, is that JR?", "Whoa, shit, it is. I think that means they should just win? Right?"), QuestChainFeature.isJadedResearcher), Feature.WAY_HIGH)
            ..addFeature(new PostDenizenQuestChain("Run The Simulations", [
                new Quest("Huh. The ${Quest.PLAYER1} has figured out how to run simulations of SBURB? What is even the point? Man, it's a fucking Waste. Maybe there IS no point??? "),
                new Quest("Okay, revised statement: maybe the point of running simulations is to map out all of Paradox Space? Makes way more sense than just having a big black sheet of paper, right? The ${Quest.PLAYER1} makes a robot doppelganger to go explore areas of Paradox Space that are predicted to have useful features. Huh, looks like it's working!"),
                new Quest("Welp. Whatever original reason the ${Quest.PLAYER1} had for finding other sessions has fallen by the wayside. They've gotten completely distracted helping out sessions with no alpha and accidentally dooming the fuck out of everyone when they make a typo in some code.   I thought these were just simulations? Fuck Paradox Space. ")
            ], new ItemReward(items), QuestChainFeature.defaultOption), Feature.LOW)

            ..addFeature(new PostDenizenFrogChain("Waste the Frogs", [
                new Quest("The ${Quest.DENIZEN} explains um. What? Where did the ${Quest.PLAYER1} go?"),
                new Quest("The ${Quest.PLAYER1} is sick and tired of being bullied!  If only there was some way they could finally defeat those mean old bullies.   A wizened ${Quest.CONSORT} tells of a legendary artifact that could-- Wait. No. That's so boring.   The ${Quest.PLAYER1} decides to update their highly-indulgent meta work instead."),
                new Quest("Holy shit, did you know you could alchemize MERCHANDISE of your highly indulgent meta work? The ${Quest.PLAYER1} is just covered in merch now. It's great."),
                new Quest("Holy fuck! It turns out that the ${Quest.DENIZEN} is a fan of the ${Quest.PLAYER1}'s highly indulgent meta work!  They also agreed to be called 'Falcor', because, come ON that was a great movie!  The ${Quest.PLAYER1} hops up onto Falcor's back and this is the single coolest thing that has ever happened in all of Paradox Space."),
                new Quest("With a dramatic 'BORF' the bullies are defeated by Falcor! And so came to an end the most heroic thing that ever happened in the history of metafiction. <br><br>Let's move on.  Wait. What? How did THAT somehow breed the Ultimate Frog???")
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)

            ,  Theme.HIGH);
    }


}
