import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Rage extends Aspect {

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 1.00;
    @override
    double fraymotifWeight = 1.0;
    @override
    double companionWeight = 0.01;

    @override
    List<String> associatedScenes = <String>[
        "[THIS IS STUPID]:___ N4IgdghgtgpiBcIDaAVAEgSQMoAJs6xQFUAFDAEQF0QAaEAMwBsIA3AewCcUYAPAFwQgAPACMAfKky58hUhUpCA9OIA6YURzFqUACxgEAwgFEAckYD6AeQDqZgErmTAQQCyRnBxgRGjAJ44dCD4YAGccPh0ASzCRAFcfEKi+HABzaBgaHFCABxgAY0jvP3C9HDiEpJKgnGiS-RQnOwBxIxRHVwtLB2c3LAByMNiwPLYwABNIvkjR7xqoKE4+b0nfADoCWLydMvjGRMn13Vq02Bqw708IMf8RDjYAaxgwLLA2WJSdTJC2OsNTTtsRm6HRw9EiKVinjCOjYAHccFBNts2PQcBAcBN6PQYJ5hvpYZEfDVkpcfP4oBBHjVURF6o0Wm0ep1gb0cIw2CFQnVIhwcEMRuNJtNIIw5gsOEtGCtVmoNGI5bQQEsOCkYHxLGA4Ig+BxYnA6DrwaqOAZRhMpqMQgAZSIsSJgFKCJDAFQgSJQbKLCBgPjWThjV3wV1Yb0rV00V0mSwoQOu+jeTnh10ANTs2AA0k5YwwEzAk+B0tmXL4sEs+BgQk1LsEuIEwMnvHr8+7PRLveWfdmAIwAZldAF9Mi63R6vT6-RwAwhXSRGJt7jgUA8nvBzGucCYACwYFJjD4pPgpbKRABCeQwTkzIicKoAmrCTLenBeAI5OACcjAAVk0DE5yAAiikJ5QOmRhOCIKQAUYACsm6wk4MBOFaKSRJYWBNDwTiwpY94AEyISgJ48EYjAGAYKTkJYeQGFAsK3ieVr0GwGAMToThQE4HGTByPZYK4bB8C+6awgAtCgKRNF2KROGgdgGOmbBOCeAAMEAABywtelgvi4fBjAA1GgDG+E4JAAU4KRgAAWvcokhAAUpuJCQFgLhfgYOh7ieb5GEp9yUZmJgYDoBgmAAYlgIQsGgKQqWgsEYAYYAhg0bCME4RCWAAXikvixCIBhzkQ-H-sZTgsFAAGbnwLDWZYVo6CeQwpNlMAObeaDWbeWAngZRhYCpPAGTAWAOS+1k2SwjB2DBPD1QBIQGF2jBYLeJgQCe4VOF2on0NY5BfnkKmMAA7PxYzIRwNEhC+L5NEJABsBlQCeTQGV21k9uF5AGEQjDkE461fvxJ6RD+LjZGALgABp4ZuLA9gZKQOSet4kHhKmRDoaClfmUYxtOOZ7HmtApmmWCZtmOpNmTBawNmaAQCEWB5E8pMRiOrZLD6GCdkTKkDkOrotmOvr+tmJiKFmdME9m8Yk-mqYZjLQbE4mdOQAzRMVk4UosBzIujm2vP82rgsgIOODDqLJvi5OkvS-j0by7mSsU1TRMKxrnNa6TasVnY3pjGwUDNsbPMdnw2YwRbVs2xH7YTlO8BgLsnNy0TNOGyAyuU6rcZu5rhZE8WljHmAwqWPQKAQCqaoVlWXg1ro3oNnOOe25HfPR0ToldnHwtc2LyeOzLGcu17Rec3nntq9n+Z+9mjdsGMKCRDi4fc+2PfZoP1tG9v44S0TUvj5Gk9q97OezwX6s50vOshEQwxmkKMxkhg8xeowW9i7vAsBzUANBwI0OJTSCgtGAa0wcnTAJADALE+Q+AhHCpwG0doHROgTkfe2KcZxzjyAuJcjwwCrnXFuHce4dAHiPKec8l4II3hSPeR8z4nBvk-D+P8gFgKgXApBaCcEEJIRQmhDCWEcL4UIsRUi5FKLUVovRRizFWInnYpxbifBeL8RcIJYSYkJJSRknJBSSlVIaS0k4HSelDLGRPKZcylkbJ2Ucs5Vy7lPLeV8v5QKThgqhQilFGKcUEowSSilCAaUMpZVyvlQqxVSrkHKpVaqtV6qNWag6NqHUuo9T6gNIaI0xoTSmjNOaC0lorTWhtLaO09oHSOidc6ThLpWmugYW690novTeh9L6P0-oAyBiYEGylwZNEhtDOGCMkYozRhjLGOM8bF21mrOwMAFgGycHkKB7sVbU11J3ROPoTCxCgCITegDLZDy7knE+asz6LxLmrTy3pVTl3tFXegLgb4ezvtfP+dszkXKuWrfu+8cEjweZGJ2qz-auhcJSGAei2y-zprfV2is6Z3NOecy5HA95AMVIg7EuzUHoODiEOBlsgA",
        "[Breaking Point]:___ N4IgdghgtgpiBcIDaAhATjCBrAlmA5gAQAKA9ngC4C6IANCAGYA2EAbqWgCowAeFCIADwAjAHyoM2PETKUqggPRiAOmBFpRqzgAsYhAMoBhAKIA5YwH0A8gHVzAJQumAggFljhHAGdCEMGFIATxgAE0JhQN8mJkIKXU8KGCgfOJhAgHIMQgBjCDQ0QOlfNFIAVzAQgDpCHTTCEJhsnAbY0nrSqAAHWN0oKJjSMB69Tmd7AHFjTic3SytHF3d9dJ9dCCqa+NGJqZn3awXZ-U8fBphOpkjSzq8YCnDIuO9K1XVRN7oQCjz8O6swOCIChoUpwejAnD4X5oQyDEI4Cg4QZeAAyOFY0gESGAyhAOC6HG+YAoNg4IVx8FxrggPHxHUIKNK2SwuNouNMVk4FNxDAgTFurNxADV7ABJfQAaWc3MYfIFdFxkFgMtcgX03wooq840kiS42j8Qr5oMFeIJaCJmuJMoAjABmXEAX1ohBxZs6hL8JLJMuITCZWBqpCwMDA8AsEcIpgALKL8CF8Np8BR8J0cChsqLnFLhM40PgAJoAd1MBecWYAjs4AJxMABW40MzgAIgBFfAoKAS4zOYT4VvGACs0aLzhgzhR+BwVn04x4ziLVmLACYx5wUDxjExDIZ8M2rNlDFAiwWUCiGKRRaftM4oM5bwjSF47fo3KQKBWJUWALScfDjG18GcAAJexDAlUhnBQAAGCAAA4i1zKwK1cCgQgAamA09AmcYhW2cfAwAALSwb8vAAKWjYhIH0Vw60MbQExQKtjEgrA9ylUxRW0QxTAAMX0LxWGA-BoOAodRUMMB9AgUZSCYZwAFUrAAL3wQJSmEQx-UU18Wyw5xWCgVtowoVgiKsFFtBQcp8BUmByILYCiILfQUHQ4x9Ggnh0JgfRyIrIjiNYJh7EHHgLNbLxDBtJh9ALUwIBQPjnBtb8GBsZs62yaCmAAdlfEIJzQQ8vArCtxg-AA2dCoBQcZ0JtIi7T45tDEUphm2cBK61fFAcAbVxOjAVwAA1l2jVg7XQ-ByJQAtiGXaCcG0YC9NNDkuQQHk5RgU0RXFKUZWBE0FXAaA9u2kBgIgLx9GyUNLrZd1PWJUVrSu6CnRdN18Q9C0vVJNBySu0wFGlM7NplXl+Se4UxUlCHKVlWHTSVS7ka1ZwmHROGXoBt6PuRr6QGdV1cT+17vWBmUwYh56oaumH5Weg7Eeh3a0YumUtXsPwQlIKBTUpgmrQoGVBxJsnfvNS0gZB+AwFKaIGc5Y6QTxtmjqZzmzvRlVAisNMwCRMArAYTgfjuLUdUwPUdENY08ZFy13vFq7v0Hb7yfxuWfVB8GNrVnXUbOrWkdxE68f1q6buiwWLjuUJsaYFF+dbUEvAoLxhdlr03ZlKWfopvPiXlmVCCDrbkeZzWEe15Go655VY9u0VEigRLYBB56XfzoncSlmhwTQSFoVhCoEVN1F+axYeQBgBgGEabO+I4NEMQILEZf+v2aauv0AyDEMwwjCwo1jeNE2TVN00zbNezzQsSzLSsa3rRsW3bTtu17fshxHGOCcU4ZxzgXEuIsq4YDrk3NuXc+5DzHlPOeS815bz3igI+Z8r5XDvk-D+P8AEgKgXApBGC8FELOGQqhDCWEUA4TwgRYipEKJURonRBiTEWJsQ4s4LiPF+KCWEqJcSg5JLSVks4eSSlVLqU0tpUoul7zNgMkZEyZkLJWRsgQeyjlnKuXcp5byvl-KBWCqFcKkVoqxXiolZKqV0qZWyrlAqzgioohKoYMqFVqq1Xqo1ZqrV2qdW6qYXqUEBrjCGiNcak1pqzXmotZaq11p625ldewSRSCsHHNkREgx9r1wjl8DWudd5elMB0YQMA0CF29jvKm5cA700VOk5GDE-C-CNngU25tXB10OsU2uZSqaVKgNU2pHsvak2Lr7QG-tkYyRNhQQIzcMa4g6QQPyGpCmDI5qHXupcKBjImTKb89oi4+z7mXBZ7JA5pJbsjZwxIcCuFKPgXZ7MQ4sxLuU4kJyal1NJvPRey88leDXmgNOFQvBz1JkAA",
        "[YAWP!]:___ N4IgdghgtgpiBcIDaBNAggdQAoEIC6IANCAGYA2EAbgPYBOAKjAB4AuCIAPAEYB8qmuPBwD0vADphutHhPoALGAAIAygGEAogDl1AfQDyGbQCUdmtAFl1iuRBYwAzopZyAlo4Dm0GADpF8mACeijBQAA7UAO4wtE4KUPYwZCSK9tSxtrGBAOS0SlwwLHYxGVTULgAmLmDuihE2dpTRigDGNmRkMNUOii4siqG5CWAsjixpziHeElI8M0QgLBC07gV6YHCILLQArnDEWy7uK7Sq1GCVLC5n9gAyLpRV7uxIwGIgLmF0i8MYdOVv8DeADFckoMC52m9CG9NHp6AC3iQIGQElC3gA1IwASWUAGk0AjSMjUUQ3pBYITzAFlIsWFj7ABxXK2aLyCBgdHI3Zo96fWjfOnDQkARgAzG8AL6ERSvXnhfnsli-Wj-BBvLBkbbNADWfmo2s68B0xsUmgALFj3OV3HJ3Cx3KEXAAhZpYtD4rhoZYoCKadBugCOaAAnGQAFYM1RoAAiAEV3E6oLj1GguO5Y+oAKxmiJoGBoG7uFx6ZQMphoCJ6H0AJjz9CdTHUZFUqnc0b0zVUUAiKCdNxI1CxvbkaCgaFHvWo9lFygs1BYAdxEQAtPR3Azhe40AAJIyqXHUNBOgAMEAAHBFPXoA+YWOUANTb3sBNBYWNodxgABa2uX9gAUmaWCQMo5hhqocjWk6QbqIe2ptvimhYnIqiaECyj2JQ27uMe25ZliqhgMoED0Gg1BkGgACqegAF7uAE2xcKomqUbOMZPmglBQLGZosJQX56DcchOts1Q0TA-4oNuX4oMoTr3uoyjHkw94wMo-4Bl+36UGQRiZkwAmxvYqjCmQygoJoEBOkCaDCsuJAYNGYbNMeZAAOyzuUBa0J29gBgGDILgAbPeUBOgy97Cl+opAtGqiUWQ0ZoBZYazk6LgRuYoRgOYAAa1ZmpQor3u4-5OigWDVseLhyNubE8rC8JqkSKIwDymI4vihJbNypLgF4hLbhA9jKM0nRtX1HzygKWJCs1x6StKspTV8irKqqgIgJowgEn1jWEkirXtdieK7Zth0ktC-UUs19JoGQ9wTVdK0KsMs0sISC0gFKMpvC9ArrYS227Vd+3NRdT0YidXXg8SkPXRNm30kY7LlNQUA8v9irvYSmZfT9y18gDfxAztDVwgdcPHZ1Z2IlTfXkojbz0soiQkJjRPY3Nm340tf2cz8JPNcD5NNed9NXR1p3dTs8OM4Nw2nGEHR2OU0adC44lgDcqOxrs9gjBz01cx982Lb9cqrYLKqEsRYC9AEouU0dfVSzD4su1d8vNfQSwrCwNK2PSTIwCyDA2ByXLw1jb3c28YqSgQ+y0IcxynOcvRXGAtyo88ScgDAJAkDAzQjECdB3A81TPITxvWxt6qajqeoGmARomualrWra9qOi6boel67g+n6aCBiG4aRjG8aJsmqbplmOZ5gWRYlmWFZVhEtYwPWjbNq27adt2vb9oOw6juOUCTtOs7mPOi4rmuG5bru+6Hie56Xmg163g+T5Oi+N8H5vy-gAkBECYEIJQRgnBBCaAkIoTQhhLCOE8KZgIkREiZEKLUTogxJiLE2LRg4lxHifEBJCREmJCSUkZJyQUkpFSakNJaS-DpPSBk9BGRMmZCyVkbJ2Qck5Fy7lPLeV8v5QKAYQphQilFGKcUEpJRSmlDKDIso5XyoVYqpVyqVWqrVeqDMBrNSMCEagjQ0ClyztTaWzUerRwFiwTQ2woD5FoJ9c2tcrZKiFptLAkRog8m9ptCC7IViB1NpLaGtMWqXX5nXZxrj3EilFLzC2MdfE22aiCGAYIIRkGCSY0JEcIm0lse7OmnsEk+JcW4oJzUxT43zoXYupd7Dl1oDrc49g87fSAA",
        "[Encouraged Action]:___ N4IgdghgtgpiBcIDaBRMBjA9gVwE4QHMYATAAgEF0AXAS0zAF0QAaEAMwBsIA3TXAFRgAPKghAAeAEYA+VBhz4iZSrXoNxAehkAdMFNzTd-ABYxSAZQDCKAHIoA+gHkA6nYBK9m+QCyKUgGswTAB3AGdSKmMIKgjTUn5yNwBxFH5PHwdHDy9fcwBycKgaMDIaULA8mOLYs1waAmMYgAcudBgAOlIACRCYbhhcZhrcGALSUMxYUibe3AjMUkkzKNKwWLLOkzMrW0zXFGyM0mJMGHCJqcUYAFoAT0XsDg5Q4xoYqgX-GBgmmvjElJpHKZQ65Uj0Go0OboPAjMDvfDofztXT6aRolggKgQXBEKiOMBwRBUXDYOCsEn1Ii4Sz0YhvOhgUIAGRo3GKBDESGA2hANCgM1w2Phzj4xF58F55ggYDet15zF5Nkc-AlvLYEGeMAVvIAam4AJLmADS5DV7E1oW1LF5kFg5u8t3M2KoBtCSRG0QGJhlus1ZJ1fIFfGFrvh5oAjABmXkAXyGPKDgtDotw4oQvIAChxsEj4pgvmB4PYS6QbAAWA0EYgNAhUAhNGgAIXQBvIpsk5FxAE1gjZu+Q2wBHcgATg4ACskpZyAARACKBCbUGNKHIkgI85QAFZy8FyDByMyCDRHOYkkJyMFHL2AEwH-hNoQoDiWSwEWeOdCWKDBbtN5k2EwA1-2McgoHIcC3kwUIo3MHxMCoIdjWCa5+AIJIIwIcgujcSxjUwcgmwABggAAOYJO0cIdvCoYgAGoun-W5yEzedyAIMAAC1-GuUIACly0zSBzG8CdLGMGsmxHFBCP8D9TRsA1jEsGwADFzFCbgugIYiuh3A1LDAaUEkwDhyAAVUcAAvAhbmwSRLBzCz4LnJjyG4KB53LKhuC4xxmWMJtsDAAhrJgfjuy6Lju3MJt6JQcxiKEeiYHMfihy47juA4NxtyEfz51CSwIw4cxuxsCAmzU8gI2uNhnFnCd0GIjgAHZ4OII9cG-UIhyHJIkIANnoqAmySeiIy4qM1NnSwLI4WdyAqid4KbGgp28JowG8AANW9y24KN6IIfim27TNb2ImhjC6VzA2VVUMwtLVA31I1TXNEkAxtcBoGtSUQC6CBQnMNpCUDflkxlMMqHNYi4wTXkoZDGHU3TQGbA0M1fse80NVe373pNHHAYJq1AztAHeTdcgODZa1FSTVH4QNcNnoRkB41IRMUaFNGxXNLGcaZvHnvJxm9UNEn8ctSW-vtZ63TcGUTigSHg351n2cB7dOe53nNZTQWEDAR4OFFlVZcJpnic+8W5cp-6HVuRxG1lehHDYfgcTxN0PRgL0BCiMA-RzeW+dDNm4ee7dEZ55GjYFtMhexh6rYdm2pY+0neW++WqfNYHismFoYCoEg1KhUIqGZVX5zJGvQg16HtZjwH9aR5mtaodHzWlWUqHlXGM8B-O3ul+2ycd37C+en3cXL51on9z0K+D31-QjpO2-Na5ozjJgKTqAhqVpEoGXoFlVa5I+QBgNg2BgahQjUvhWXZUKuUN1ve5NwHsy5n8PmQsxZSwVirDWYwdYGzNlbO2dcXYCC9n7IOcgI5xxThnAuJcK41wbi3Lufch5jynnPJea8d4HxPhfG+D8X4fx-gAkBECTYwIQSgh8WC8FvCIWQqhdCmFsK4XwoREi5FKLkGorRBiTEmwsTYhxbivEBJCREmJCSUkZJyQUuQJSKl1KaW0rpfS25DLGQgKZcyVlbL2Ucs5Vys53KeW8r5fygVgqhXCpFaKsV4qJWSqldKmVsq5XyoVYqpVyqVWqrVeqjVmqtQ6uQLqzIeqWD6gNYao1xqTWmrNeai1lo2FWkRDaSQto7X2odY6p1zqXWurde6s9nbPTcDAKAmB+gqEZBPHOX1STb1-jYbAUAli4HhvHH+LM-4p2esLJ2itAYSRlEQN2xRGRe28PLO2ucXoU1+pHGGIyxkDHNHHLmXcjkin-lKGUcpFnUxACs0KaUXR9JlpnA5TNrlUBOeMveB9LkJ27sbOZADZiPPNC8ogy8Y620nnsiWLcZn-LOc9IFsY74Pyfi-N+uA64lFCLfLmQA"
];
    
    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#9900cc"
        ..aspect_light = '#974AA7'
        ..aspect_dark = '#6B347D'
        ..shoe_light = '#3D190A'
        ..shoe_dark = '#2C1207'
        ..cloak_light = '#7C3FBA'
        ..cloak_mid = '#6D34A6'
        ..cloak_dark = '#592D86'
        ..shirt_light = '#381B76'
        ..shirt_dark = '#1E0C47'
        ..pants_light = '#281D36'
        ..pants_dark = '#1D1526';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Mirth", "Whimsy", "Madness", "Impossibility", "Chaos", "Hate", "Violence", "Joy", "Murder", "Noise", "Screams", "Denial"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["MOPPET OF MADNESS", "FLEDGLING HATTER", "RAGAMUFFIN REVELER"]);


    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Raconteur", "Reveler", "Reader", "Reporter", "Racketeer"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Rage", "Barbaric", "Impossible", "Tantrum", "Juggalo", "Horrorcore", "Madness", "Carnival", "Mirthful", "Screaming", "Berserk", "MoThErFuCkInG", "War", "Haze", "Murder", "Furioso", "Aggressive", "ATBasher", "Violent", "Unbound", "Purple", "Unholy", "Hateful", "Fearful", "Inconceivable", "Impossible"]);


    @override
    String denizenSongTitle = " Aria"; // a musical piece full of emotion;

    @override
    String denizenSongDesc = " A hsirvprmt xslri begins to tryyvi. It is the one Madness plays gl pvvk rgh rmhgifnvmg rm gfmv. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And yes, The OWNER know you're watching them. ";


    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Rage', 'Ares', 'Dyonisus', 'Bacchus', 'Abbadon', 'Mammon', 'Mania', 'Asmodeus', 'Belphegor', 'Set', 'Apophis', 'Nemesis', 'Menoetius', 'Shogorath', 'Loki', 'Alastor', 'Mol Bal', 'Deimos', 'Achos', 'Pallas', 'Deimos', 'Ania', 'Lupe', 'Lyssa', 'Ytilibatsni', 'Discord']);

    @override
    List<String> symbolicMcguffins = ["rage","sanity", "power", "whimsy", "impossible", "screams", "laughter", "madness"];
    @override
    List<String> physicalMcguffins = ["rage","face paint", "script", "bike horn", "war mask", "murder weapon", "loud speaker", "bullhorn", "broken machine"];


    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Curtain",<ItemTrait>[ItemTraitFactory.CLOTH, ItemTraitFactory.ASPECTAL, ItemTraitFactory.FAKE],shogunDesc: "Show Ender"))
            ..add(new Item("Cursed Sword",<ItemTrait>[ItemTraitFactory.METAL, ItemTraitFactory.SWORD,ItemTraitFactory.POINTY,  ItemTraitFactory.ASPECTAL, ItemTraitFactory.EDGED, ItemTraitFactory.SCARY, ItemTraitFactory.FAKE, ItemTraitFactory.CORRUPT, ItemTraitFactory.DOOMED],abDesc:"You probably are gonna kill an army if you don't keep it safely tucked away in your sylladex."))

            ..add(new Item("Omegaphone",<ItemTrait>[ItemTraitFactory.METAL, ItemTraitFactory.LOUD,ItemTraitFactory.ZAP,  ItemTraitFactory.ASPECTAL, ItemTraitFactory.FAKE],shogunDesc: "Voice Embiggener",abDesc:"Rage players are such loud assholes."))
            ..add(new Item("Trike Horn",<ItemTrait>[ItemTraitFactory.UNCOMFORTABLE,ItemTraitFactory.METAL, ItemTraitFactory.LOUD, ItemTraitFactory.ENRAGING,ItemTraitFactory.RUBBER,ItemTraitFactory.ASPECTAL, ItemTraitFactory.FAKE],shogunDesc: "Two-wheel device mounted Juggalo voicebox"))
            ..add(new Item("Bacchus Wine",<ItemTrait>[ItemTraitFactory.EDIBLE, ItemTraitFactory.ENRAGING,ItemTraitFactory.CLASSY, ItemTraitFactory.ASPECTAL, ItemTraitFactory.LEGENDARY, ItemTraitFactory.FAKE ],shogunDesc: "Aged Grape Gore",abDesc:"I guess it makes you go beserk or some shit. Sucks being biological."))
            ..add(new Item("Nightmare Fuel",<ItemTrait>[ItemTraitFactory.WOOD, ItemTraitFactory.ASPECTAL,ItemTraitFactory.SCARY,ItemTraitFactory.ONFIRE,ItemTraitFactory.EXPLODEY, ItemTraitFactory.FAKE],shogunDesc: "Image of Adam Sandler in a Troll Face Shirt",abDesc:"It's clowns isn't it. It's always fucking clowns."));
    }

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.POWER, 2.0, true),
        new AssociatedStat(Stats.MOBILITY, 1.0, true),
        new AssociatedStat(Stats.SANITY, -1.0, true),
        new AssociatedStat(Stats.RELATIONSHIPS, -1.0, true),
        new AssociatedStat(Stats.SBURB_LORE, 0.01, false) //yes, technically it's from an aspect, but it's not NORMAL.
    ]);

    Rage(int id) :super(id, "Rage", isCanon: true);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.rage(s, p);
    }

    //Rage is so GODDAMNED EASY to come up with qualia for. it's so visceral.
    @override
    void initializeThemes() {

        /*
        new Quest(""),
                new Quest(""),
                new Quest(""),
                new DenizenFightQuest("","","")
         */
        addTheme(new Theme(<String>["Murder","Strife","Shrieks", "Combat","Hate", "Death","Violence", "War", "Screams","Noise", "Chaos", "Bloodrage", "Rage","Wrath"])
            ..addFeature(FeatureFactory.ANGRYFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.BLOODSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.DANGEROUSFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.ROTSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.STUPIDFEELING, Feature.MEDIUM) //THIS IS STUPID.
            ..addFeature(FeatureFactory.GUNPOWDERSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.GUNFIRESOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.SMOKESMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.ROARINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.DRUMSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SCREAMSSOUND, Feature.HIGH)

            ..addFeature(new DenizenQuestChain("Stop the War", [
                new Quest("The ${Quest.PLAYER1} is chilling in a ${Quest.CONSORT} village when a bunch of sentient ${Quest.PHYSICALMCGUFFIN}s attack! Apparently they were sentient all along, and are angry at the ${Quest.CONSORT}s. ${Quest.DENIZEN} must be behind it."),
                new Quest("The ${Quest.PLAYER1} learns of a plot by the ${Quest.PHYSICALMCGUFFIN}s that ended up killing the ${Quest.CONSORT} president, who is apparently a thing now. They begin adventuring and solving puzzles to learn more about the motivations of the ${Quest.PHYSICALMCGUFFIN}s so they can heal the strife afflicting the land. "),
                new Quest("The ${Quest.PLAYER1} learns of corrupt ${Quest.PHYSICALMCGUFFIN} and ${Quest.CONSORT} generals who are keeping the conflict going and feeding lies to their people, each blaming the other for the scourge of underlings attacking both. But after spreading awareness of the generals' plots, they unite together and topple their dictators!"),
                new DenizenFightQuest("${Quest.DENIZEN} arrives to challenge the ${Quest.PLAYER1} and their army. Will the ${Quest.PLAYER1} be able to prove their worth after directing the anger of ${Quest.CONSORT} and ${Quest.PHYSICALMCGUFFIN} alike towards their true enemy?", "${Quest.DENIZEN} lies slain. The ${Quest.PLAYER1} has become the savior of not one, but two peoples.","he ${Quest.CONSORT}s and ${Quest.PHYSICALMCGUFFIN}s turn on each other again with the defeat of the ${Quest.PLAYER1}. ${Quest.DENIZEN} laughs.")
            ], new DenizenReward(), QuestChainFeature.playerIsMagicalClass), Feature.WAY_LOW)

            ..addFeature(new DenizenQuestChain("Stop the Civil War", [
                new Quest("Two different factions of ${Quest.CONSORT}s have been at war for generations. Neither side gives the ${Quest.PLAYER1} a straight answer on WHY they are fighting. They are tearing the land apart with needless bloodshed. This is stupid. "),
                new Quest("The ${Quest.PLAYER1} is starting to think it's impossible to get the two sides of the ${Quest.CONSORT} War to just stop fighting. They yell, they rant, they pass out flyers, they blame the ${Quest.DENIZEN},  they even try fixing both sides' problems. But they keep fighting. This is so fucking stupid."),
                new Quest("God. It's...it's just so FRUSTRATING that the two ${Quest.CONSORT} armies seem dedicated to wiping each other out. A stray bullet grazes the ${Quest.PLAYER1}. They see red. When they come to, the only living thing left is the ${Quest.PLAYER1}. "),
                new DenizenFightQuest("The ${Quest.DENIZEN} has slithered onto the former battlefield to taunt the ${Quest.PLAYER1}. 'Good job', they hiss, in a language only the ${Quest.PLAYER1} can understand, 'There can be no strife when there are no armies left alive.' With no thought, the ${Quest.PLAYER1} attacks them in a rage.  ","When the bloodrage is done, the ${Quest.PLAYER1} is left to deal with the fact that only they are left alive. They wander the land, looking for anyone left alive. At least....it seems, some ${Quest.CONSORT}s survived, avoiding the conflict entirely. The ${Quest.PLAYER1} wishes they could have, too.","The Rage was not enough for the ${Quest.PLAYER1} to win.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.HIGH);

        //guys. I think maybe all these clowns aren't actually happy. smell blood rarely, but it's there.
        addTheme(new Theme(<String>["Whimsy", "Mirth","Circuses", "Tents","Clowns", "Wackiness", "Laughter"])
            ..addFeature(FeatureFactory.HAPPYFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.MUSICSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.LAUGHINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.CLAPPINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.FOOTSTEPSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.BLOODSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ZOOSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.ENERGIZINGFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.STUPIDFEELING, Feature.LOW) //THIS IS STUPID.

            ..addFeature(new DenizenQuestChain("Do a Stupid Dance", [
                new Quest("The ${Quest.CONSORTSOUND}ing and capering ${Quest.CONSORT}s are...OKAY, you guess? They keep asking the ${Quest.PLAYER1} to do a stupid ${Quest.MCGUFFIN} Dance, though. They politely decline."),
                new Quest("A capering ${Quest.CONSORT} tells the ${Quest.PLAYER1} that some underlings looted a local village. The underlings will only return the stolen property if they are defeated in a stupid  ${Quest.MCGUFFIN} Dance off. The ${Quest.PLAYER1} politiely declines and defeats them in a good old fashioned beat down. The ${Quest.CONSORT}s seem less than enthused about getting their stolen property back. Something about the ${Quest.PLAYER1} being a spoilsport?"),
                new Quest("A crying ${Quest.CONSORT} child asks why the ${Quest.PLAYER1} is such a meany head. Why won't they dance? Defeated, the ${Quest.PLAYER1} hangs their head, and then begins doing an extremely stupid ${Quest.MCGUFFIN} Dance, well below their dignity. The ${Quest.CONSORT} child is estatic and begins ${Quest.CONSORTSOUND} in time to the music that only the ${Quest.PLAYER1} can hear. "),
                new DenizenFightQuest("The ${Quest.DENIZEN} approaches the ${Quest.PLAYER1}, complimenting them on their stupid ${Quest.MCGUFFIN} Dance. Mortified, the ${Quest.PLAYER1} initiates strife.","It is done. Now NO ONE but that ${Quest.CONSORT} child knows of the blow to the ${Quest.PLAYER1}'s dignity. No one at all.","You just KNOW that that shitty ${Quest.DENIZEN} is gonna somehow post videos of the ${Quest.PLAYER1}'s stupid ${Quest.MCGUFFIN} dance online. They must be stopped.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            , Theme.HIGH);


        //TODO make sure to have pre and post denizen quests for this one too, so it can be eXTRA bullshit.
        addTheme(new Theme(<String>["Denial","Rejection","Resignation","Impossibilty","Awareness","Walls","Meta","Bullshit","Finality","Acceptance", "Allowance", "Frustration"])
            ..addFeature(FeatureFactory.ANGRYFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.STUPIDFEELING, Feature.HIGH) //THIS IS STUPID.
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.ZOOSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.LAUGHINGSOUND, Feature.HIGH) //we are laughing at you, asshole.
            ..addFeature(new DenizenQuestChain("Hate This Bullshit Land", [
                new Quest("The ${Quest.PLAYER1} has wandered around for hours. There are walls. And empty villages. And FUCKING NOTHING ELSE. What is WRONG with this stupid as fuck bullshit land? "),
                new Quest("The ${Quest.PLAYER1} feels like someone is laughing at them. Not like....a ${Quest.CONSORT}, as irritating as they are. Like....something watching all of this and thinking it's all a big laugh. Like entertainment. Somebody out there thinks it's FUNNY that this land is so empty and bullshit and frustrating right now. The ${Quest.PLAYER1} is so fucking pissed."),
                new Quest("The ${Quest.PLAYER1} has fucking given up. Fine. This part of the land is bullshit. There are no quests, no challenges. The land itself rejects their attempts to find meaning in it. FUCKING FINE.  A sign pops up next to the resigned ${Quest.PLAYER1}. 'You win, teleport to fight ${Quest.DENIZEN}? Y/N'. God DAMN it. "),
                new DenizenFightQuest("This is the least satisfying quest chain, ever. With a hearty 'FUCK YOU', the ${Quest.PLAYER1} presses the button to fight their bullshit final boss. Fuck dignifying them with a name. The ${Quest.PLAYER1} is going to work out all their fucking frustrations with this land with a good old fashioned beatdown. ","Fucking YES. Finally some goddamned CATHARSIS! Maybe the ${Quest.PLAYER1} can finally put this bullshit chapter of their land behind them.","God FUCKING DAMN IT. After all that the ${Quest.PLAYER1} LOSES!? ")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH); // end theme
    }

}
