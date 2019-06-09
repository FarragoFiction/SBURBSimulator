import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Heart extends Aspect {

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 0.3;
    @override
    double fraymotifWeight = 0.6;
    @override
    double companionWeight = 0.01; //inwards focus

    @override
    List<String> associatedScenes = <String>[
        "[Heart's Desire]:___ N4IgdghgtgpiBcIDaAJGEBOAXA5AZwAIARGPASwxgF0QAaEAMwBsIA3AewwBUYAPLBCAA8AIwB8qdNnzFSFakID04gDphRGMWq4ALGAQDKAYQCiAORMB9APIB1CwCVLZgIIBZEwTKEs8gCYE7AwETOzkYADmAIQEuhjsAK4ROgQYEADuBH4wWDAYUGSQvuxgBBChYDC0BFh6AJ4EEZQQWEwNIuxhWDV6BAAO7Ol5gcG1+lwuDgDiJlzO7lbWTq4eBgR47D0tBGDstYURBADGEKV4WOx9PTBQO4MAdGoaYs90IFiYETnWlYJYGAk4PR-mQIl8MEYSn4yMUwHgADJkVgHQRIYAqEBkKADbCnLC2Th+DHwDEAMUo+lsZCYTAxtAxZmsXGJGIY5TwMDpGIAag4AJIGADSLhZjHZnLoGMgsFFbjqBg+WD5eCmzVy3B0p255UBXMx2M4HzASuNooAjABmDEAX2q6P1OKN+MJooACkwEkcANaxdhemBgeCWYMEMwAFj5ET8yQiWAifTIACEjnyXMKRC4MBEAJrpMzZlypgCOLgAnEwAFZTIwuIgARQiiaggpMLhEETrJgArGH0i4YC54REyNYDFNeC50tZcwAmftcRO8ExMIxGCJEaxHIxQdLZxPwhjsPl7nQuKAuM8wsIWgzuPZFwXpAC0XAiUzNERcKAcRkF7BciYAAwQAAHOkGbWEWbhYH4ADUKB7nULiunWLgRGAABaXpPngABSYaupABhuBWRg6NGiYliY-5euuwpmHyOhGGYpIGHgrAoBEgEoN2fJGGABgQBM7BMC4ACq1gAF4RHUCQiEYHpibetYIS4rBQHWYZYKwGHWPCOiJgkkSSTAuHZigGHZgYiawSYBiAbwsEwAYuFFhhmGsEwDhdrwul1ngRhmkwBjZmYECJqSLhmk+DC2EQFZHIBTAAOy3n4g4YFueBFkWUxYEWABssFQImUywWaGEWqSRBGGJTBEC4oUVreiZkFWbh9GAbgABozmGrAWrBES4Ym2aujOgFkDoKDKXqjLMggrLinqvICsKor-LqkrgNAEokiAKAQHgBhHAGEr0g6hp4nypqLSAgE2naGJYo6eIEhgRJ3WYigitt82imyTAcit-JCr9+2A8D23SntGLKi4TBIudz0Grixo3VgooPSAtoEPaL1Xca72fft32-Rd-13ZDyMgKtYMA8t0O7aKyoOKcfjsFAeoE2jJqY3dXbY7j+Oo06xPEmACQ0hTTIM0DNN0+tVOMxdMOynU1gJmAZAlNYDBcJ8OTKqq6DqroWo6jTPNOhj5pC09l28+LX0-XNsvK-LINreDGKbTTat3cb7B+FwZB5NzovXbd+323jKOvUTLou+TDLuxDKs8qDSvp57TMyndh14CYrB5EQYefRd1tR-zMc2jQwIYKC4KQmA0Kwgi7OovXIAwAwDAwEcWB4KSnCIsikSoiLCfOh9boet6vr+oGwaWKGEZRjGcYJsmqbppmOZ5gWxZlpW1a1g2TYtm2Hbdr2-aDsOo7jpO07pHOMALkuK5rhuW47nuB4jwnjPBeAoFw8A3jvPlR8L43wfi-D+P8AFgJgQglBGC8FELIVQuhLCOF8KEQgMRUi5FGxURonRFwDEmIsTYhxLiPEux8QEkJFwIlxJSRknJBSCQlIXiIKpdSmltK6X0oZYyplzKWWsrZeyjlnKuXchhTy3lfLWH8oFYKoVwqRWirFeKiUUppQyllHKeVCrFVKuVSq1Var1UamYZqAE2pTA6l1Xq-VBrDVGuNSa01Zp51hiABwNx2AlxcIPHWYAvb0zun7CO08zAJCgCIcOd1Y5T0JjPEmDJXaBNFGRU4XxNaFCiXrNwCss4+zFLnSukdjRJJSWk-aZoMnxyyc7farpBhpNVszO6hTIjOUVDE7OS1antN5o01JGBzQWkAkLbuvd+6D2HqPdmeAu44yAA",
        "[Unsoul]:___ N4IgdghgtgpiBcIDaBVMBnA9gVwDYF0QAaEAM1wgDdMAnAFRgA8AXBEAHgCMA+VDHAuwD0PADpguNbuLoALGAAIAygGEAogDk1AfQDyAdS0AlbRoCCAWTUKAlugUQA7hBqLmsiMwe5cC94oAHCgBPGBp7GzA-WTsFAHNoGCJbMABjXGwAE0i46MU6MyMAcTU6U0sdXRNzKyVkl0UwTHcchU5sL1xImHtMUgVUzEyYADoFORhghWx0Nxj7JwawHvtmTAVSSMy8hS7l3v7B4ejPBWHN5Z2C4tLyqz1qiqUHMG3Z17yoP3X-PxoIdCyNqRMZoUi0ZjYSDMGC4YLJX6qTSVQxqR5WADk9lcEC6zCmUAgYBsATwnhsmAwAwgM0UWFgCnQNmOMFIpBgqS8cTxqXk6BG4kk3CFxBAzBccRgzF0yzYzBo2DgJHlNjikpoKkp2WYFIwABkbJQcmwkMBRCAbFAAhCicx9LRMub4OalESbPjzURzRpdHQnebSLjZp7zQA1IwASSUAGkzP6yEGYCHwIl4xZgkpxcwI+gijiYfQPGBQ7jFcnLdaaOKwNma-GAIwAZnNAF9kmaLVabTX7TRHQhzQAFDKpADW40wo5gYHg2jnCg0ABYI3FMnFZHFmHEAjYAEKpCNmWOcMw0OIATUcGnPZkPAEczABOXAAKyKKjMABEAIpxXdQaM1DMTg4m-NQAFZF0cMwYDMPU4hsXQlCKRgzEcXRLwAJhguhd0YNRcBUFQ4k-XRUhUKBHHPXc9XBCNqNkMwoDMJj3UwdBGyUSxmjvaNHAAWjoOIinrOIzAACSMFRo0wMxdwABggAAORwT10O8LGYTIAGpxOo4IzEHb8zDiMAAC1R349AAClF0HSAlAsF8VFkNddwfNRZNHEjYw0CNZBUDQADElHQShxLieTxIgiMVDAV0CkwXAzBQXQAC84mCbBOBUDIUC4r89LMSgoG-RdmEoMzdD1WRdyhOI0pgazz3EszzyUXdtLUJR5MYbSYCUay7zM8zKFwIxwMYKrv3QFR61wJRzw0CBdyCsx6340h9E-F9Unk3AAHYuMyOCaHI9A7zvIpmDvAA2bSoF3IptPrMzGyCz8VBQXBPzMJaXy43cbDfCwAjACwAA1MMXShG20uJrN3c9B0w+SbFkcSCuTH0-QHBNcGDYgw0jGM4zx+UyyJlNYHjcSASUVJpyTKmK27WtmHjeTW3bc1WarW1e37Z0QA0IQya9EXfXjQMCeZiXwyjWNpcTZNIBpvGczMLpKDl3mu35msIzrPGuZANsFA7PnqztB141F8XvSlvGZcJ+WSaV52VaptXmeFnMjCJTJMCgct9eto2Obx8DTfNy2w4F22EDAPBcAlnH4wp3WQAV0nldl1XUzx9NdB3YlKV0Ug6AlKUczzGBPDCOQiRLDIs6t20I-jfjUe5i29cra3BbtsXsad4WXaznOPeFzOC-V4W6dm4OgilGATp8PVA+-RV0GYdBQ4HjvjeFmOec7Q+e0T4WOpQIxdwUPVaCz9PPfzqmp7J8evYln20wzLNa75kbkWFulMJbt0Nsfc0TZWyEGVDQVU6pNSvHdLqdAm9XgmjgSAVk7JOToCCrQA0RowBxBNHHC+Ns+zxmHNgMcE4pwzjnNoBcy5Vzrk3NuPcB4jzAVPBeK8N57xPlfO+L8v5-yAWAqBCCUEYJwQQkhFCaEMKOGwjAXC+FCLEVIuRSi1FaKYHoruRizFWJrA4lxCwPE+KCWEqJCSUkZJyUUipNSGktK6X0oZYypkLJWVsvZCAjlnKuT-B5LyPkzB+QCsFUK4VIrRXArFeKEBErJVShlLKOU8oFU-EVEqZUKpVRqnVUhjVmqtXap1bqvV+qDWGqNcak1pqzXmotZaq11qbW2rtfaR0zAnT1GdFQF0ro3Xuo9Z6r13qfW+r9f6gNgZFFBuDKGMM4YIyRijNGGMsbe0LsLIwMAoCYB1mYTkupkwfwzgqNu8cawaGwFATgYROa9woWzIeeN7Zz19uaFyRJJQl0iLqCuFhJ7u0-gGb+-c2ZPJeW8vG3dT593Pl8q+3oR4HPnuaaMNgfBKFwDAGApcSI4igEoWEpBrlQrzq7OFBtmAIteTQd5Zsz4QKoULLFDtqb-JAEbXeEB8U+FpYraF+MGXoqZSypFJ8PmMsHpikAfy0xDBsKQDMKxdTiXrrgdw4rc6v2lVyuVbLkXRxjtg3BHI96EJoBgzI6AsFmyAA",
        "[Soul Rend]:___ N4IgdghgtgpiBcIDaBlA9gVwDYAIBKMYAJgLogA0IAZlhAG5oBOAKjAB4AuCIAPAEYA+VJlwFiJHgHpBAHTD9GAucwAWMHCgDCAUQBy2gPoB5AOr68B3QEEAstpwqIAZwcQiOQpgDmKnGio4HGoAloweYDBQAJ7kgWo4zFZ4AOLazJa2hkYW1nYoAHQJalE4jMEADn4YHHEwoThOIrEwVFQwAMYcwXQwWCUA1sFYWMFgXrVQ+XIKAjMUIBwQjF4wHEYR3ByMGHCUW8FeK4yaaMTBXadOADLdo17cSMAyIMFQ5UyLYBwmTETP8M8AGKMGDqExDLDPcjPXRGZj-Z5UCBYJwwKHPABqeAAkigANJWBHUZGo9HgaBohDPGxRFCLDjYpzJEEQDgwFiOMAY5E7Mmvd6MT4Mr5EgCMAGZngBfWJPF5vD4QL4-Rh-KkgAAKWAw7X6CTQ-UI8AMJpwugALNivEQfF4OF5ysEAELtbFWAl8KzLACaAHddN6rG6AI5WACcWAAVslNFYACIARS8TqgeO0Vj4XgT2gArObfVYYFYrl5gkYUMk2FZfUY-QAmQvMJ1sbRYTSaLxxoztTRQX3ep1XKhobEDlRWKBWCfnNBOcUoWxoDjBvG+gC0zC8yVFXisAAk8Jo8WgrE6AAwQAAcvs9RmDNg4RAA1HuB1ErBqE1YvGAAFr9NcnAAKXNDVIBQGxI00FQbSdUNtBPfpOwJXRsRUTRdEBFAnDoPcvDPPdc2xTQwBQCBEjQLArAAVSMAAvLwogwPhNG1aiF3jV8rDoKAE3NDg6F-IwrhUJ0MDGOiYCA7091-b0UCdJ9tBQM82CfGAUCA4Nfz-OgsDwHM2CEhMnE0UUsBQb1dAgJ1ASsUU1yoEw40jdozywAB2BciGLRgeycYNg2SZcADYnygJ1kifUVf3FQE400aisDjKwrMjBcnWCaMbHKMAbAADTrc06HFJ8vCAp1vQ1Osz2CFQ9w4slYXhdUkRRSloRALFcQJIktl5ChnkgWAiT3ZwUHaQgOueflFS+bERXVM9pVlGaFUFJVvl+IldEkQlBpAZqiTa0kDu6-F9oBYl2rJYbKSuxkrBGHo+XWoUFo4IllpAGUcDlWaNuVbb1V2-bOqO1qSWmrqcQu46oduikiUZPAlSINAoFegV3sWq6c2+37-rezaVTVeAwGwLBwbhPrtmh87eshm6DruokaSMR0wGCU4jCoZglhWBkmRZNkOSVbltWhgGcc+9U1xqla-rW7GSeBq7QaammmdOzqGcu55+uh1n1TG0yMfKLBVhgIg40IYJJLAK40YTHYnA4Jwsbm4VZaugnVvlFWgdVUaYGRIJNZaq7DbJPX4eZzrjau-nllWOlWUZZlQ9F1RxZ5KXifm3HnglM8-aVgOvdJtm0D4IZziiCPaYG3XYcZq6TqNpH1WTwW06FzPWXZHO8tGfPA+9r7FaJ8eq-VDU0F9dlG-VaOztb-Xrp1oau6TgXU-pDORaHzkbFHz3AYnpbpTIPYykOdkTjOC4wGuNGHhvkAWjaTonEBJgbjoHcB409K5q2eFqHUepmAGiNCaAwZpLTWltPaR0Lo3Qei9F4P0AYgxWFDBGaMsZEzJlTOmTM2Y8wFiLCWMsFYqw1nrI2ZsrZ2ydm7L2fsg5hyjidOOSc04OCznnIuZcq4Nxbh3PuQ8x5TwXmvLee8j4Xxvg-F+H8-5AIgTAhACCUEYLJngohZCVhULoUwthXC+FCI5mIqRciVhKI0XooxZirEMDsSnHGLiPE+ICSEiJMSEkpIyTkgpJSKk1IaS0jpX8ekDJGSMCZMyFkrI2Tsg5JyLk3KeW8r5fygVgrBjChFKKMU4oJSSilNKGUsrJBynlQqxVSrlUqtVWq9VGosx3s8AgUA0A9CsJ0bmYAY7rybmPL2ugMBQD4EvK+P1-bS1VsHEGe1EYjXVNBJUKwOajGGbzGw9MxnawmRfKZMy5lXXlmXEBF9Z7qzWV0jZD0X6LDxBCUZPUN4d3PkKc5szGCTx+h-L+HR3Z-0YE7YgTh34-SAA",
        "[Create a Shade]:___ N4IgdghgtgpiBcIDaBhATjCAXGACCuAygBYQAmMAuiADQgBmANhAG4D2aAKjAB5YIgAPACMAfKgzY8BEuSqCA9GIA6YEWlGrOxPIRQBRAHL6A+gHkA6sYBKJwwEEAsvtwBLMCxgBnLF9xe2WFw2elwsHVc0YIB3MFwABzZomCisNgSAV0ZGfDiIL3iYAGMsYNDwvE57awBxfU47J1MzWwdnQgByP0K0AMhGVywAT2CM0pCwiKjhNjIhgDpcbVc-ZRAvUgo13AArNnc-Cqh8PwIiwPiIMFc2OPDsXGjXbPxXMknK6rqGtubWpsIbji5ygwmw81U6lEUNoICwEDQAHMYFgzGA4IgsGgMnA6FjXIjkWgULcyIMbmAvAAZVwsdyIgRIYBrVxQRJoeFgLAWDhkNbwNYAMQweAsz0Yaxoa0MZk4-LW9AgjC8MElawAatYAJKEADS9nlDCVKrV4GgqoQa0cQ0I8KwWq8NUkOC4pDA6qVONNrPZnPtXMNAEYAMxrAC+NFwzJAPo4fp5aD5lpAAAVGBkigBrJZsTMwMDwExF3CGAAsWsRZERxERWER8VcACEilr7PrhPYkQBNaKGLv2VsAR3sAE5GDsaih7AARACKiMbUF1+nswkRs-0AFZS9F7DB7FTEa4zIQajx7NEzD2AEx7ziNnj6RgoFCI6dmIooKDRLuNqn0NgtV-Yh7CgexQMGNgvGDQgnDYLBB11aIAFpOERGpA0RewAAlrBQXU2HsRsAAYIAADmiDszEHRwsDIABqbDfyGewU1nexETAAAtTNkK8AApUsU0gQhHB2FBiCrRth30QjMzffVDC1YgUEMQVCC8FhsMRYjsK3LUUDAQgICqNhGHsABVMwAC9ESGDJhBQdMLNgmcmPsFgoFnUssBYLizCpYhGwyMBEWsmB+K7bCuK7QhG3o-RCGInh6JgQh+MHLjuJYRhrE3Hh-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"
];
    
    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#ff3399"
        ..aspect_light = '#BD1864'
        ..aspect_dark = '#780F3F'
        ..shoe_light = '#1D572E'
        ..shoe_dark = '#11371D'
        ..cloak_light = '#4C1026'
        ..cloak_mid = '#3C0D1F'
        ..cloak_dark = '#260914'
        ..shirt_light = '#6B0829'
        ..shirt_dark = '#4A0818'
        ..pants_light = '#55142A'
        ..pants_dark = '#3D0E1E';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Little Cubes", "Hats", "Dolls", "Selfies", "Mirrors", "Spirits", "Souls", "Jazz", "Shards", "Splinters"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["SHARKBAIT HEARTHROB", "FEDORA FLEDGLING", "PENCILWART PHYLACTERY"]);

    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Heart", "Hacker", "Harbinger", "Handler", "Helper", "Historian", "Hobbyist"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Heart", "Soul", "Jazz", "Blues", "Spirit", "Splintering", "Clone", "Self", "Havoc", "Noble", "Animus", "Astral", "Shatter", "Breakdown", "Ethereal", "Beat", "Pulchritude"]);


    @override
    String denizenSongTitle = "Leitmotif"; //a musical theme representing a particular character;

    @override
    String denizenSongDesc = " A chord begins to echo. It is the one Damnation will play at their birth. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";

    @override
    List<String> symbolicMcguffins = ["heart","identity", "emotion", "core", "beat", "shadow"];

    @override
    List<String> physicalMcguffins = ["heart","doll", "locket", "mirror", "mask", "shades", "sculpture"];

    @override
    bool deadpan = true; // heart cares not for your trickster bullshit

    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Heart', 'Aphrodite', 'Baldur', 'Eros', 'Hathor', 'Philotes', 'Anubis', 'Psyche', 'Mora', 'Isis', 'Jupiter', 'Narcissus', 'Hecate', 'Izanagi', 'Izanami', 'Ishtar', 'Anteros', 'Agape', 'Peitho', 'Mahara', 'Naidraug', 'Snoitome', 'Walthidian', 'Slanesh', 'Benu']);



    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.RELATIONSHIPS, 1.0, true),
        new AssociatedStatInterests(true)
    ]);

    Heart(int id) :super(id, "Heart", isCanon: true);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.heart(s, p);
    }

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Doll",<ItemTrait>[ItemTraitFactory.PORCELAIN,ItemTraitFactory.PRETTY,ItemTraitFactory.SENTIENT, ItemTraitFactory.ASPECTAL],shogunDesc: "Possessed Doll (Probably)", abDesc: "It's like a robot, but useless."))
            ..add(new Item("Soul Puppet",<ItemTrait>[ItemTraitFactory.WOOD,ItemTraitFactory.SENTIENT, ItemTraitFactory.ASPECTAL, ItemTraitFactory.LEGENDARY,ItemTraitFactory.SCARY],shogunDesc: "Baby Muppet Snuff Survivor",abDesc:"Don't touch this shit."))
            ..add(new Item("Mirror",<ItemTrait>[ItemTraitFactory.MIRROR, ItemTraitFactory.ASPECTAL],shogunDesc: "Mirror That Shows A Reflection Of The World But A Horrible Beast Mimics Your Every Move"))
            ..add(new Item("Shipping Grid",<ItemTrait>[ItemTraitFactory.PAPER, ItemTraitFactory.ASPECTAL, ItemTraitFactory.ROMANTIC],shogunDesc: "A Grid of Pure Taint",abDesc:"No. No cat troll shit."))
            ..add(new Item("Shades",<ItemTrait>[ItemTraitFactory.COOLK1D,ItemTraitFactory.GLASS,ItemTraitFactory.ASPECTAL],shogunDesc: "Glasses For Try Hard Nerds", abDesc: "You can put a p great robot in these. I advise it."));
    }

    @override
    void initializeThemes() {

        addTheme(new Theme(<String>["Spirits","Souls","Jazz", "Havoc", "Blues", "Cores", "Prohibition", "Noir"])
            ..addFeature(FeatureFactory.GUNPOWDERSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.JAZZSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.ENERGIZINGFEELING, Feature.MEDIUM)


            ..addFeature(new DenizenQuestChain("Find Yourself", [
                new Quest("The ${Quest.PLAYER1}, guided by a ${Quest.CONSORT} assembles some of the scattered pieces of their land into a sort of safe space. Its nice, but something's just off about it."),
                new Quest("The ${Quest.PLAYER1} grows obsessed with perfecting their space and begins manically collecting more and more of the landscape to decorate their area. Theyve become convinced that if they can only make it perfect, everything will be all right. If they can just make themselves better..."),
                new Quest("The ${Quest.PLAYER1}realizes all the things they were adding to the space was nothing more than junk and clutter. They realize they cant make themselves better by simply accumulating more onto themselves. They have to confront the root of the problem. For the specific problem of their space, they have to confront ${Quest.DENIZEN}."),
                new DenizenFightQuest("It is time for the ${Quest.PLAYER1}  to finally face the ${Quest.DENIZEN}. They can finally be free to just....be themselves as long as the ${Quest.DENIZEN} is gone. ","The ${Quest.DENIZEN} lies slain by the ${Quest.PLAYER1}'s ${Quest.WEAPON}. The ${Quest.PLAYER1} has won and finally feels free to be themselves for the first time.","The tyranny of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new DenizenQuestChain("Steal the Heart", [
                new Quest("The ${Quest.PLAYER1} finds a Violent ${Quest.CONSORT}. A Magical Talking ${Quest.PHYSICALMCGUFFIN} explains that the ${Quest.PLAYER1} needs to enter their inner world and steal the Violent ${Quest.CONSORT}'s heart to heal the corruption within. Huh. It turns out that the Violent ${Quest.CONSORT}'s inner world looks a lot like a Rage themed dungeon, cool! The now Peaceful ${Quest.CONSORT} vows to never hurt anyone ever again."),
                new Quest("The ${Quest.PLAYER1} finishes a Doom themed dungeon to steal a Gloomy ${Quest.CONSORT}'s heart and heal it. They really are getting the hang of this! "),
                new Quest("The Magical Talking ${Quest.PHYSICALMCGUFFIN} shows back up out of nowhere. They explain that they've been doing some digging and it turns out the pandemic of corrupted heart ${Quest.CONSORT}s is caused by none other than the ${Quest.DENIZEN}. It's up to the ${Quest.PLAYER1} to stop them!"),
                new DenizenFightQuest("After a convoluted plot that had a really satisfying twist, the ${Quest.PLAYER1} has the ${Quest.DENIZEN} just where they want them. It's time to strife! ","The ${Quest.DENIZEN} monologues their evil plan to corrupt all the ${Quest.CONSORT}s, then dies. The ${Quest.PLAYER1} has prevented any new cases of corrupted ${Quest.CONSORT}s from cropping up!","The tyranny of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}. Will no ${Quest.CONSORT} hearts be left safe?")
            ], new DenizenReward(), QuestChainFeature.playerIsSneakyClass), Feature.HIGH)
            ,  Theme.HIGH);


        addTheme(new Theme(<String>["Dolls", "Voodoo", "Doppelgangers", "Copies", "Puppets","Selfies","Mirrors","Poppets","Mirrors", "Crystals","Shards"])
            ..addFeature(FeatureFactory.LAUGHINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.FOOTSTEPSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.WHISTLINGGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.DANGEROUSFEELING, Feature.LOW)
            ..addFeature(new DenizenQuestChain("Confront yourself.", [
                new Quest("The ${Quest.PLAYER1} is just going through their land when they get ambushed by a  copy of themselves made of ${Quest.PHYSICALMCGUFFIN}! The player barely gets away with their life! "),
                new Quest("The ${Quest.PLAYER1} skirmishes with the ${Quest.PHYSICALMCGUFFIN} copy a few times. The ${Quest.PHYSICALMCGUFFIN} copy begins to berate the player about their moral failings and weaknesses."),
                new Quest("The ${Quest.PLAYER1} realizes that the ${Quest.PHYSICALMCGUFFIN} copy is nothing more then an expresion of their own worst feelings, manifested by  ${Quest.DENIZEN}. They confront the copy one last time, and accept it as part of themselves. The two fuse, with a single, small ${Quest.PHYSICALMCGUFFIN} the only physical remnant of the copy. Armed with their new self actualization, they realize they are ready to face ${Quest.DENIZEN}. "),
                new DenizenFightQuest("${Quest.DENIZEN} has been the cause of so much personal grief for the ${Quest.PLAYER1}.  There can be no mercy. ","The ${Quest.DENIZEN} lies slain by the ${Quest.PLAYER1}'s ${Quest.WEAPON}. The ${Quest.PLAYER1} is victorious. ","The assholeness of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)


        //medium makes it ~50/50 for the right class.
            ..addFeature(new PostDenizenQuestChain("Prove Your Identity", [
                new Quest("Now that the ${Quest.DENIZEN} has been defeated, a Copy ${Quest.PLAYER1} has appeared. They claim they are the TRUE ${Quest.PLAYER1},and that the other is an imposter who just wants their fame! All of the ${Quest.CONSORT}s ${Quest.CONSORTSOUND} in confusion and don't seem to know what to do."),
                new Quest("A wizened ${Quest.PLAYER1} creates a series of challenges that only the REAL ${Quest.PLAYER1} should be able to complete. They are....laughably wrong. Things like walking in a straight line, being literate and being able to ${Quest.CONSORTSOUND} for more than five minutes straight. At the end of it, all the ${Quest.CONSORT}s unanimously agree that the Fake ${Quest.PLAYER1} is the winner. THIS IS STUPID."),
                new Quest("The REAL ${Quest.PLAYER1} has had enough of all this bullshit. With some bad ass pink lightning, they expose the Fake ${Quest.PLAYER1} as three ${Quest.CONSORT}s in an overcoat using some weird Heart magic.")
            ], new FraymotifReward("The Real Heart Player","The ${Fraymotif.OWNER} knows who they are, and their confidence is turned into a pink lightning attack."), QuestChainFeature.playerIsHelpfulClass), Feature.HIGH)

            ..addFeature(new DenizenQuestChain("Shatter The Mirrors", [
                new Quest("The ${Quest.PLAYER1} finds a disorienting labyrinth of mirrors. They know they need to reach the end but they keep getting turned around. Frustrated, they punch a mirror, shattering it. The dungeon crumbles away entirely, leaving the treasure at the end. Huh. "),
                new Quest("The next time the ${Quest.PLAYER1} finds a labyrinth of mirrors, they skip straight to breaking the mirrors and collect that sweet, sweet loot. "),
                new Quest("Another mirror, another punch. Except this time....the mirror is unaffected. The ${Quest.PLAYER1} in the reflection smirks back. In a rage the ${Quest.PLAYER1} assaults the mirror until their knuckles are bloody. Still the reflected ${Quest.PLAYER1} is a smug prick. 'Maybe',  the reflection says, 'You should stop trying to destroy yourself.' The ${Quest.PLAYER1} collapses in an exhausted heap and considers their words."),
                new DenizenFightQuest("When the ${Quest.PLAYER1} encounters the next mirror labyrinth, they do their best to beat it correctly. They reign in their anger, they try to forget about that smug smirk. When they reach a dead end they realize that their reflections are....wrong.   They are all...watching the ${Quest.PLAYER1}, even if that shouldn't be possible. 'Help me.', the ${Quest.PLAYER1} says. As one, each of their reflections destroys their own mirror. The shards of glass ricochet forwards and fit neatly into a locked puzzle door, revealing the path to the ${Quest.DENIZEN}.","The ${Quest.PLAYER1} has accepted their fractured soul, and the destructiveness inherent in it. The ${Quest.DENIZEN} is dead.","The ${Quest.PLAYER1} destroyed themselves.")
            ], new DenizenReward(), QuestChainFeature.playerIsDestructiveClass), Feature.HIGH)


            , Theme.HIGH);

        addTheme(new Theme(<String>["Shipping","Ports","Ships", "Docks", "Sails", "Matchmaking", "Cupids", "Fleets"])
            ..addFeature(FeatureFactory.CUPIDCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.SALTSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.BAKEDBREADSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ROMANTICFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.MUSICSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.JAZZSOUND, Feature.LOW)
            ..addFeature(new DenizenQuestChain("Ship All the Ships", [
                new Quest("The ${Quest.PLAYER1} begins constructing an intricate map of all possible relationships and all ideal relationships for a group of consorts. The ${Quest.CONSORT}s have no idea what's coming. "),
                new Quest("The ${Quest.PLAYER1} extends their shipping grid to include the entire ${Quest.CONSORT} population, and begins subtly pushing to make these ships a reality. Happy ${Quest.CONSORTSOUND}s ring out through the air.  "),
                new Quest("The ${Quest.PLAYER1} finds the ABSOLUTE BEST SHIP ever, but then realizes that because of some stupid ${Quest.MCGUFFIN} laws put in place by ${Quest.DENIZEN}, the ship will be unable to sail. The player flips their shit and begins preparing for the final battle. THE SHIP WILL SAIL. "),
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new PostDenizenQuestChain("Heal The Broken Heart", [
                new Quest("The ${Quest.PLAYER1} finds a weeping Broken Hearted ${Quest.CONSORT}. The most Fetching ${Quest.CONSORT} of their dreams just turned them down to the ${Quest.MCGUFFIN} Dance and they are miserable. On a whim, the ${Quest.PLAYER1} offers to take them instead. The ${Quest.CONSORT} immediately brightens.  "),
                new Quest("The Broken Hearted ${Quest.CONSORT} and the ${Quest.PLAYER1} are shopping for matching outfits to wear to the ${Quest.MCGUFFIN} Dance. Oh look, there is the Fetching ${Quest.CONSORT}. The Broken Hearted ${Quest.CONSORT} begins sniffling quietly to himself. Oh, dear.  When they aren't looking, the ${Quest.PLAYER1} goes over to the Fetching ${Quest.CONSORT} to talk. It is swiftly revealed that it's all been a big misunderstanding.  The Fetching ${Quest.CONSORT} really is busy with their job as a ${Quest.CONSORTSOUND} salesman for the ${Quest.MCGUFFIN} dance, but the Broken Hearted ${Quest.CONSORT} ran away crying before they could explain that they'd love to date them anyways! The ${Quest.PLAYER1} sees an opportunity to save the day."),
                new Quest("It is the day of the big ${Quest.MCGUFFIN} Dance. The ${Quest.PLAYER1} is working hard at being a ${Quest.CONSORTSOUND} salesman, despite their lack of credentials. The Fetching ${Quest.CONSORT} and the Mended Hearted ${Quest.CONSORT} are enjoying a lovely time at the Dance. A happy ending! ")
            ], new RandomReward(), QuestChainFeature.playerIsMagicalClass), Feature.HIGH)


            ..addFeature(new DenizenQuestChain("Flushed Shipping Dungeon", [
                new Quest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} seem to be getting along well. The noodly appendages of the Horror Terrors do not fail to notice this.  "),
                new DenizenFightQuest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} have come across a strange dungeon with a heart symbol on the door. They ignore all common sense and venture inside. Chocolates and roses abound. There is a couch, and a romantic movie playing. Huh. Oh shit, what is ${Quest.DENIZEN} doing here!?","Slaying the ${Quest.DENIZEN} proves to be the thing that finally pushes the ${Quest.PLAYER1} and ${Quest.PLAYER2} together.","The ${Quest.PLAYER1} and ${Quest.PLAYER2} are stubbornly refusing this ship by getting their asses handed to them by the ${Denizen}.")
            ], new FlushedRomanceReward(), QuestChainFeature.twoPlayers), Feature.WAY_HIGH)

            ..addFeature(new DenizenQuestChain("Pitched Shipping Dungeon", [
                new Quest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} seem to be evenly matched rivals. The noodly appendages of the Horror Terrors do not fail to notice this.  "),
                new DenizenFightQuest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} have come across a strange dungeon with a spades symbol on the door. They ignore all common sense and venture inside. Non lethal weapons and games abound. There is a couch, and a controversial movie playing. Huh. Oh shit, what is ${Quest.DENIZEN} doing here!? ","Competing to slay the ${Quest.DENIZEN} proves to be the thing that finally pushes the ${Quest.PLAYER1} and ${Quest.PLAYER2} together.","The ${Quest.PLAYER1} and ${Quest.PLAYER2} are stubbornly refusing this ship by getting their asses handed to them by the ${Denizen}.")
            ], new PitchRomanceReward(), QuestChainFeature.twoPlayers), Feature.WAY_HIGH)

            ,  Theme.LOW);
    }
}
