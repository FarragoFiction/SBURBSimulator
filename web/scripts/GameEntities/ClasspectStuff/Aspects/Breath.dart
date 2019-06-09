import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Breath extends Aspect {

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 0.5;
    @override
    double fraymotifWeight = 1.0;
    @override
    double companionWeight = 0.01;

    @override
    List<String> associatedScenes = <String>[
        "[Last Breath]:___ N4IgdghgtgpiBcIDaAZCBnALgAgEICcYJMALAXRABoQAzAGwgDcB7fAFRgA9MEQAeAEYA+VBhwEipMnwD0wgDphB+IYrYkY2AMoBhAKIA5PQH0A8gHUjAJWMGAggFk92AMYQ6ddNgCuAB2Zg2KSaAoQwAF6amMzYACb4EACWgcHYviQAnuiJbnTYMOjoMGAumsw0QRrYbHZWAOJ6bLaOJqY29k5a2BBgsdgA5glgOIk40ZUwUEV0NAB0ispCi1QgmBD4-TCYpmBwiJj43nDUB4n9m-g6AbGjiQHoKImMyf28SMDyIIlQ-vhrw+ZWLFPvBPg5mAJEnRRhlPpRPgZTGwQZ8aO4inDPgA1KwASS0AGk7CjaOiYJjwNByQgwRktGtMLj0HVCMQYOwSD0se4jhTvr9-ozhiSAIwAZk+AF9KNgPl8fqxBYD8MCaSAAAp0bwuADW1WYOuK8GMJuwBgALLj+rF+iR+ph+r5ErgXLi7ESBHYNgBNADuBm9djdAEc7ABOOgAKzqOjsABEAIr9XBQAl6OwCfoJvQAVnNvrsMDsKH6iVMWjqnDsvtMfoATIW2LhOHo6DodP046YXDooL7vbgUDRmLiByQ7FA7BPRsx0GKtI5mJhgwTfQBaNj9Ooi-p2AASVh0BOYdlwAAYIAAOX2e0zBhyYWIAaj3A4ydnVCbs-TAAC0dWu6AAFLmuqkBaA4kY6CQNq4KGegnjqnZEgYuIkDoBgAGJaOgjB7v0Z57rmuI6GAWgQDUzB0HYACqpjhP0GTeAIOhajRC7xq+diMFACbmpgjC-qYKAkLg3hgP0kRAd6e6-t6Wi4E+ehaGenBPjAWhAcGv5-owdBWDmnBCQm6A6CKdBaN6BgQLgmF2CKa40OYcaRi4Z50AA7AusTFvgPboMGwZ1MuABsT5QLgdRPiKv5iphcY6DRdBxnYVmRguuCJNGDi+GADgABp1uajBik+-RAbg3rqnWZ6JCQe4cRSiLImqaKeNS8IgDi+JEiSBy8lQnyQLAJJ7hgWilLsfIKn8PRCpgJJnlKMpyvyipzcqqqgiABgyMSg07UiJJtRiB3dYS+3bSdHVDVSJJMnY0KMDd8oCnNuLCmqS0gNKsqfGts0AkCJK7ftnXNcdZIUudvWtVDB3DdS21MlYPSxMwUDTW9wwfQtao5t9v2rTNSrAwgYDeB44NHWq-UvTDl2ovDnWIySDgZKYTpgHcYCmDQbDrJsjLMqymDsuoXI8i9AOCrjJJriKhMrf9JMbWT22g01NNXcz2J4hdfWHC9rNqkydTMLEbCJOyWPrTjn3bUrf2vXbmCbaNRB0KQWstTr7XQ-rsN+6dLN3WqAsbFs9LEGbovi5yYDclq0uq-bePbeKZ5Z8tzsy2rKpsxCUIwj7kP+2dgeM6S5ehyNars9HwsspI8eS8ntuA-N8uZ1nTvE9jbvq2CRfQpgsIHRDtNGwHPVV9dFIm9tDcMrHLccm3A2dXnaeimKveExQJz4GcFxXL0tz3GgvRvIfIAwDQNAwC4mDoJhrCPM8ElvP3rvu2qmraj1GwA0RoTTGDNJaa0tp7SOmdK6d0GYvT9D9AGIMdhQwRmjLGRMyZUzpkzNmPMBYiwljLBWKsNZ6yNmbK2dsnZuy9n7IOYco5cDjknNOaIc4FzgmXKuDcW4dz7kPMeU8F5ry3nvI+F8b4Pxfh-P+QCIEwIQAglBGCyZ4KIWQnYVC6EsI4TwgRIiOYSJkQonYKitF6KMWYqxbw7Epxxi4jxPiAkhIiTEhJKSMk5IKSUipNSGktI6V-HpAyRlTAmTMhZKyNk7IOSci5NynlvK+X8oFYKwYwoRSijFOKCUkopTShlLKdQcp5UKsVUq5VKrVVqvVRqCMw7bSsJMZgz07DPx5jPA2U9N4qwHgYbwUABA2y+jnH+nc-4az2gvFpnxoI9E2JzZIPM+YOHppXMuIdBmu2GaM8Z20FZ9z2dMoeIA9ye29s0uu20lkSQ0gyXpQcmY1zOYKA5Yz8Ddz3qcl25yC71xHiXW5SNFkJ02MvYgLy566wBZ8kZ3zd69ylLfe+j9n6v3fmjdAN8fpAA",
        "[Wind-Up]:___ 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",
        "[Spread Your Wings]:___ N4IgdghgtgpiBcIDaBlADgJxhAJgAgE0B7AVwzwHUBLMAcwGcBdEAGhADMAbCANyIwAqMAB4AXBCAA8AIwB8qTNnzEylGg0aSA9HIA6YGRln6BACxh4UAYQCiAORsB9APIUHAJUd2AggFkbeADWYEQA7vR4oqYQopHmeALe7gDiNgJefk7Onj7+KHgwUNIYEADGMBHsWDA4RFB4VXV4aDAY9ESQnHhY3KJUHfSmVGj0AHQJ5gCekdilpnEWiSlpGf4uOZn5pmGRRHgk9BZRVJXVtfXs-AtU5GFgeNIwYDDsVKKj+oayX6wgohAYWgwUTOZ4SUQYEhwNgQqi0IEYKwdHBvfpgegAGSoPHUEiQwF0ICoUDQ-H+YFEFH4OEJ8EJKAgYDek0JLEJdmcAlphPYEE4h1ZhIAau4AJIoADS3m5HD5AtYhMgsBlvkmKH+olF9GSWBirTMjKFfKhgqJJLJjM1FJlAEYAMyEgC+LDwBLNpIw5Mp1JlAAVOCRSoEEkRAk94I5I3g7AAWUW0HC0Uy0US0NBUABCpVF3il0m8gIIoTsBG8OYAjt4AJycABWySs3gAIgBFWgZqASmzeaS0Fs2ACsMdC3hg3gxtCozhQyWE3lCziLACZRwIM8IbJwrFZaE3nKUrFBQgQMxjLqKT6ZvFBvNe3kR6HaUH4iKJyxLQgBaAS0ZI22jeAAEu4VgSkQ3gZgADBAAAcoT5s45a+KIOAANSASekzeL6LbeLQYAAFqBJ+9AAFIxr6kAoL4tZWKYiYZpWNjgYEu5SnYoqmFYdgAGIoPQPCAbQkGAYOopWGADKJEQnDeAAqs4ABetCTCQ0hWAGcnPs2GHeDwUAtjGog8ARzgYqYGYkHQikwKRBCAQRBAoBmqE2CgkHCKhMAoKR5YEYRPCcO4A7CKZLb0FYNqcCgBB2BAGY8d4NqfuwFBNrWpSQZwADsz44OOGAHvQ5blskb4AGyoVAGbJKhNoEXaPFNlYcmcE23ixbWz4ZlQ9a+GgYC+AAGkuMY8HaqG0KRGYEL6S6QVQpiAdppoclyCA8nKMCmiK4pSjKEImgq4DQNtG0gIBED0Cg5TPKaxIel6orWudkFOi6boPRaFJUhgNLnXYWjSsda0yry-JnWyIC7ZKwN0rKEOmkqZ3w1q3icNikOEl9nqWs9ogym9IDOq62PmrjP0+gDQOrZyYNbTtYqw-TiPHcjMpau4jLnPd5NPS98MDkTJOfXzlq-f98BgCQnCcFDoPneD8pQzD+2KwzbOnSqkzOOmTIdM47ACACQKatquqiPq0RgEaAZY+631WgT50Du9pMOxT3p-TKgPA-LdPq6zKtM2r8OHfb7PnZdEV1GgnDAjUTZPFQNlgBi3MtlC9CiPQvOPXjAuEsLH1k-nlPe+d7gwL0aKDMMucgwHYeQvbqtw5tQeKlr53G4CwLqjEWo6tgluCNbttHVDOP8878Ofvabui2XXuS4SvhENIVAY6ILKN+t8NK63Iftwjytd8qPcm-3GpDxbVuGsa9vTwXs+EvPdqQcX7vP+Xq8gOvm9t6739vvQk4dGZ7RPofJG3d4a91NgPM2w89RjwfnbPOjt8a2g-l-JejsJYyhsMIFoGAqBPHKLTUBfwW4QOZoHM+J0L5wKvqIRBt8R73xto-DBnssHnXtMLZgMJSHwlaEiMAKI+gDHThIvEQiQAvHYDAUoOceL8CxDiOgeI8GewIedf0gZgwCFDOGSMjhoxxgTEmFMaZMzZlzD2AstAiwljLN4SsNZ6yNlbO2Ts3Zez9iHCOMcE4pwzjnAuZcq51ybm3Lufch5jynnPJea8t4oD3kfM+deb4Pzfl-P+ICIEwIQWgnBBCSEULoUwthXC+EiIkXIpRCA1FaL0XbExFibFvAcS4rxfiglhKiQHOJSSEBpKyQUspVS6lNLaSbLpfShljKmXMpZaytl7KOWcq5dynlvK+X8gRQKwVQrOHCpFaKsV4qJWSqldKmUcp5QKkVEqZVyyVWqrVeqjVmqtXap1bqvVkj9UGiNMaE0pozTmgtJaK1NZMMJFXKARAeBjhUWiWhocwE0OOj-UQdgSBFFaITRepd8FU3hr7GBiKQB0UZECXWNA0SG18EfSBLMGH4sJcSjAMpXbExLh7L0ej4ZEJIWQsAFCEUo0JPSug3kNRYqgRrKeYsKQ8seHy-hDpBXf3VSvFUG8t7MhpbKul1sgSIOVZyp+BrNUkp1YI34ijlGqPUdzegcjiZAA",
        "[Animus]:___ N4IgdghgtgpiBcIDaBBMBLKBXAzgXRABoQAzAGwgDcB7AJwBUYAPAFwRAB4AjAPlQ2z4OAel4AdMN1o8J9ABYwABAGUAwgFEAcuoD6AeQDq2gEo7NKALLrFOBQBMci6iRI3qsJ65YL0tJwHcwRQAHOQBPHHQAYwgyGxZaGDAAc29FEjpFbyV6FGMAcXV6M0tdPVNzK2VCRWTaCDAWdBSshShFZqjEiBwYO0Uoai50MnQWMIA6CSkeGaIQFghaZJgWPTA4RASsOGIE9GSV2lVqMDsx9FOcABl0Smbk9iRgMRBMYLpFxoM6O1f4V4WCBMTBYdrXLBRADWr0Ir00eno-1eJFivVhrwAasYAJLKADSKGRpDRMAx4GgZIQgLCykWLBxOHy3RYMAYcgamNiO3J70+DQZjWJAEYAMyvAC+NRebygH1oXxYP1of2pIAACmRIVDFPRqFCkvAdMbFJoACw45J2ZJyVLJYLoABCURxKEJXBQywAmv5NF6UK6AI4oACcZAAVvlVCgACIARWSjqg+PUKC4yTj6gArGb-CgYChrsl0HplPkmCh-HofQAmfP0R1MdRkVSqZIxvRRVRQfxex3XDI4vtyFBQFCjsbUHCi5SWagsQP4-wAWnoyXywuSKAAEsZVPjqChHQAGCAADn8Hr0gYsLDsAGpt32wih1XGUMkwAAtKHLnAAKTNdVIGUCxw1UORrUdYN1EPKF20JTQcTkVRNAAMWUHBKG3ZJj23bMcVUMBlAgXJqDIFAAFU9AAL2SMIsC4VQtUo2dYyfFBKCgOMzRYSgvz0a45EdLAUhomB-y9bcvy9ZRHXvdRlGPJh7xgZR-0DL9v0oMhjCzJgBLjHBVGFMhlC9TQIEdNCUGFZcSAMGNwyiY8yAAdlnOxC1oLscEDQN8gXAA2e8oEdfJ72FL9RTQmNVEosgYxQCzw1nR10EjCxgjACwAA0azNShRXvZJ-0dL11RrY90Dkbc2PJBEkTVVEyHRIgsVxAkiTVbYqThClYGJbcemUKIkj614+QVAUcSFNVj0laVJrlflvl+YlNGEbr+sa4kWra-rsTxQk9tJclIEGtVGRQUZKAm2V5UVWaWGJBaQClRQZSmxVlVVAEQE27b4URU7Wvuo6utBg7Xguql-sZYwGjsdxeRW6bGme4kszej6vrRn71oQMAsDIMgdpB5qzvakAIZOymwfOyliQsMI9AdDBTj0Eh6CWFYGSZFk2XkTluXu76Zrm-6s0Wz7lsegVfqGmBYm8BqKf+-bwc6umNap-rYeZ2l6UZZlldZdkRa1MX8Yll61TFHGloe1alUJ-6LCGEYxjCNWmt1hnqdp7r-ehga4deHnllWOkIH503Y6FjkwC5K3UfljHJdeZcHcd2XnfR12VWZz3RnGX3iV68kg6h+6DbVSO+ZjuPBYt5PRbTl3Mft0Vj1zvH08Lv74S28v6dD6uetoHlqbr-7huM9xgjIVY+jQ3wcBYa4kbjHYN5wDuC67-6cYIPZaAOI4TjOC4ri3s4nlPkAYBcGAohYHA0LoW57hSJ5+5dxWapNTal1PqQ0xodCmgtFaG0doHTOldO6T0yQfR+gDCgYMYZIzRnjImZMqZ0yZhzHmAsRYSxlgrFWWs9ZGzNlbO2Ts3Zez9kHMOUc44oCTmnLOD2C4lyrnXJuHce4DxHlPBeK8N47yPmfK+d8n4fx-kAsBCAoFwKQUTDBOCCEUBIRQuhTC2FcL4SzIRYipEUDkSorReijFmJYFYuOGMHEuI8T4gJISIkxISSkjJOSCklIqTUhpLSX4dJ6QMnoIyJkzIWSsjZOyDknIuXcp5byvl-KBUDCFMKEUooxTiglJKKU0oZXyFlHK+VCrFVKuVSq1Var1RnkzNUxgYCDDuigN+lwwBV21sHV4ldqbi0aJoMEXA2SvRlv-AugD-qA0Zpdf6EEGgrDZs0HpXMLBa2OgMkkAd+ojJYGMqAEzaBY2mXLABbtXjbmVmQVWzSlmvBWSkGALMm59N2TXA+ioTlnOJNncU70nZHLmYCEu3tFnhxAK8lYnzA79J+cMm2ozxmTO7ifeYz8SCv3fp-Wgd8HAP3ekAA"
];
    
    @override
    double difficulty = 0.3;

    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#3399ff"
        ..aspect_light = '#10E0FF'
        ..aspect_dark = '#00A4BB'
        ..shoe_light = '#FEFD49'
        ..shoe_dark = '#D6D601'
        ..cloak_light = '#0052F3'
        ..cloak_mid = '#0046D1'
        ..cloak_dark = '#003396'
        ..shirt_light = '#0087EB'
        ..shirt_dark = '#0070ED'
        ..pants_light = '#006BE1'
        ..pants_dark = '#0054B0';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Wind", "Breeze", "Zephyr", "Gales", "Storms", "Planes", "Twisters", "Hurricanes", "Gusts", "Windmills", "Pipes", "Whistles"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["BOY SKYLARK", "SODAJERK'S CONFIDANTE", "MAN SKYLARK"]);


    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Business", "Biologist", "Backpacker", "Babysitter", "Baker", "Balooner", "Braid"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Gale", "Wiznado", "Feather", "Lifting", "Breathless", "Jetstream", "Hurricane", "Tornado", " Kansas", "Breath", "Breeze", "Twister", "Storm", "Wild", "Inhale", "Windy", "Skylark", "Fugue", "Pneumatic", "Wheeze", "Forward", "Vertical", "Whirlwind", "Jetstream"]);


    @override
    String denizenSongTitle = "Refrain "; //cuz canon

    @override
    String denizenSongDesc = " A haunting refrain begins to play. It is the one Desolation plays to keep its instrument in tune. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";

    @override
    List<String> symbolicMcguffins = ["breath","mobility", "freedom", "motivation", "direction", "wind"];

    @override
    List<String> physicalMcguffins = ["breath","wind", "key", "pipe", "hurricane", "horn", "bicycle", "wheel"];

    @override
    List<String> denizenNames = new List<String>.unmodifiable(['Breath', 'Ninlil', 'Ouranos', 'Typheus', 'Aether', 'Amun', 'Hermes', 'Shu', 'Sobek', 'Aura', 'Theia', 'Lelantos', 'Keenarth', 'Aeolus', 'Aurai', 'Zephyrus', 'Ventus', 'Sora', 'Htaerb', 'Worlourier', 'Quetzalcoatl']);



    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.MOBILITY, 2.0, true),
        new AssociatedStat(Stats.SANITY, 1.0, true),
        new AssociatedStat(Stats.HEALTH, -1.0, true),
        new AssociatedStat(Stats.RELATIONSHIPS, -1.0, true),
        new AssociatedStat(Stats.SBURB_LORE, 0.05, false) //yes, technically it's from an aspect, but it's not NORMAL.
    ]);

    Breath(int id) :super(id, "Breath", isCanon: true);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.breath(s, p);
    }

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
        ..add(new Item("Pan's Pipe",<ItemTrait>[ItemTraitFactory.MUSICAL, ItemTraitFactory.WOOD, ItemTraitFactory.CALMING, ItemTraitFactory.ASPECTAL],shogunDesc: "Smonkin Weeds Pipe"))
        ..add(new Item("Skeleton Key",<ItemTrait>[ItemTraitFactory.BONE, ItemTraitFactory.ASPECTAL],shogunDesc: "THE BONE SHAPED HOLE BREAKER",abDesc:"You are never gonna be imprisoned again.")) //escape any prison
        ..add(new Item("Inspector's Fan",<ItemTrait>[ItemTraitFactory.ZAP, ItemTraitFactory.METAL, ItemTraitFactory.CALMING, ItemTraitFactory.ASPECTAL],shogunDesc: "Fondly Regarded Fan",abDesc:"Probably a refrance."))
        ..add(new Item("Jet Pack",<ItemTrait>[ItemTraitFactory.ONFIRE, ItemTraitFactory.METAL, ItemTraitFactory.LOUD,ItemTraitFactory.ASPECTAL, ItemTraitFactory.LEGENDARY],shogunDesc: "Rocket Powered Pants",abDesc:"Don't skip gates, asshole."));
    }

    @override
    void initializeThemes() {
        addTheme(new Theme(<String>["Wind","Breeze","Pipes", "Mail", "Whistles", "Pipe Organs", "Delivery"])
            ..addFeature(FeatureFactory.NATURESMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.WHISTLINGGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(new DenizenQuestChain("The Mail Goes Through", [
                new Quest("The ${Quest.PLAYER1} tries posting a letter through the ${Quest.PHYSICALMCGUFFIN} mail system only to find the letter caught in a plug of oil!  ${Quest.DENIZEN} has screwed with the mail system, crippling the ${Quest.CONSORT} economy!"),
                new Quest("The ${Quest.PLAYER1} cleans out oil from the nearby ${Quest.PHYSICALMCGUFFIN}s, opening up a few more channels between villages. "),
                new Quest("The ${Quest.PLAYER1} gets sick of all the fucking oil in the ${Quest.PHYSICALMCGUFFIN} mail system, and realizes the only way to truly deal with it and to allow information to flow free is to confront ${Quest.DENIZEN}."),
                new DenizenFightQuest("It is time for the ${Quest.PLAYER1}  to finally face the ${Quest.DENIZEN}. The mail is too vital to the ${Quest.CONSORT}s to risk having them reclog.","The ${Quest.DENIZEN} lies slain by the ${Quest.PLAYER1}'s ${Quest.WEAPON}. The ${Quest.PLAYER1} has won! The ${Quest.CONSORT}s have a bustling mail based economy once again.","The tyranny of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(NPCHandler.PM), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.HIGH);
        addTheme(new Theme(<String>["Zephyr", "Fans", "Windmills", "Pinwheels", "Propellers"])
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.WHISTLINGGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ENERGIZINGFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.NATURESMELL, Feature.MEDIUM)
            ..addFeature(new DenizenQuestChain("Thinking With Wind Power", [
                new Quest("The ${Quest.PLAYER1} constructs a little windmill system for a joke, and suddenly an entire village of consorts has grown up around it! The ${Quest.PLAYER1} decides that they should use the winds of their land for more projects. "),
                new Quest("The ${Quest.PLAYER1} starts learning the uses of their lands ${Quest.PHYSICALMCGUFFIN} in manipulation of wind. Their future constructions are going to be amazing. "),
                new Quest("The ${Quest.PLAYER1} uses ${Quest.PHYSICALMCGUFFIN}s to build a massive farming system that harnesses the wind to distribute seeds across the ${Quest.CONSORT} fields. The ${Quest.CONSORT}s ${Quest.CONSORTSOUND}ing is so joyful it's literally deafening. "),
                new DenizenFightQuest("${Quest.DENIZEN} is attacking the happy wind based farming community. The ${Quest.PLAYER1} has worked too hard for it all to be lost now. There can be no mercy. ","The ${Quest.DENIZEN} lies slain by the ${Quest.PLAYER1}'s ${Quest.WEAPON}. The ${Quest.PLAYER1} is finally free to continue improving the land with wind. ","The tyranny of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH);

        addTheme(new Theme(<String>["Twisters","Cyclones","Gales", "Storms","Hurricanes","Gusts","Tornadoes","Typhoons"])
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.ROARINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.WHISTLINGGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.NATURESMELL, Feature.LOW)
            ..addFeature(new DenizenQuestChain("The Winds of Change", [
                new Quest("The ${Quest.PLAYER1} is chilling in a ${Quest.CONSORT} village when a FUCK OFF HUGE STORM blows through, destroying the consorts housing. The player learns that ${Quest.DENIZEN} has screwed with the wind system, sending these giant storms at random."),
                new Quest("The ${Quest.PLAYER1} learns of a ${Quest.PHYSICALMCGUFFIN} system that controls the storms of their land. The begin adventuring and solving puzzles to alter the layout of the ${Quest.PHYSICALMCGUFFIN} system so the storms are redirected from consort villages. "),
                new Quest("The ${Quest.PLAYER1} finishes the dungeon that holds the  ${Quest.PHYSICALMCGUFFIN} systems control panel, only to find the control room totally empty. They learn that they only needed their own ${Quest.MCGUFFIN} to do control the storms in the first place, and it was inside them all along.  "),
                new DenizenFightQuest(" ${Quest.DENIZEN} arrives to challenge the ${Quest.PLAYER1} storm supremacy. Will the ${Quest.PLAYER1} be able to prove their worth?", "The ${Quest.DENIZEN} lies slain by the ${Quest.PLAYER1}'s ${Quest.WEAPON}. The ${Quest.PLAYER1} has become the storm master. It is them. ","The storm supremacy of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH); // end theme
    }
}
