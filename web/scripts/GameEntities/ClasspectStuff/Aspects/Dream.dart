import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Dream extends Aspect {

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 1.01;
    @override
    double fraymotifWeight = 0.3;
    @override
    double companionWeight = 0.01;

    @override
    List<String> associatedScenes = <String>[
        "[Magnum Opus]:___ N4IgdghgtgpiBcIDaBZCBzMBXKACA8gA5YDOAuiADQgBmANhAG4D2ATgCowAeALgiAB4ARgD5UGbHiKkyAgPSiAOmGGsRy9gAsYuAMoBhAKIA5QwH18AdVMAlM8YCCKQ7ghgAJrh7bc7BzYBxQ3Z7J3N8O0dnXVwAdzYAay9mdBhvGFZcUgBLMHQvbWzMgGNmKCFcmE8IOmLtKGzimtwSBOy6OmTcYtYYCB4YADphlrK0zVz0QdwASR4AchJcMGYeXEYMgE9uuj7M2M1+guylkjHvSdwTylwhLDWIJfS9I1MLa0NIsLiahKWIWIQTY3bJrEgwGBQf5LbI0AoZGCLUawC55FqEGDFbLNCBCZj3eG+fxBEJRcJfaLLZixQbKVQielUEA8CCsVI8fBgOCIHisLBwai87LoVKsfTMDyg7ISkgAGWyjEm-CQwEUIGyUEIbBZYB4ljY7jV8DVujcoM2asoauM+HYRrVNBq4MtaoAajYZroANIOe20J0wF3gaCBhBqlCbXQsngzEgBXr9DJaNyumr8oMarWsHUx3V+gCMAGY1QBfG6q9Wa7VuPUGv0ABToWGKSXYzASMDA8DMPdwxgALDN0O50Jp0Dx0IRsgAhYozBw+oQONkATVixhXDnnAEcHABOOgAKwC+gcABEAIroadQL2GBxCdAXwwAVn7sQcMAcsvQ2XwugCLgHFifA1wAJk-dhpy4Qw6H0fR0DPfBin0KBYhXadZRoZgZgwzQHCgBwCNBZgSELXQnFWbcvViABadh0ACfN0AcAAJGx9C9ZgHGnAAGCAAA5YiXfBtxQHh3AAalYjDNgcesLwcTAAC0ElokgACl+3rSBdBQQ99E0Edp13QxuISRCfWMGZNH0YwADFdBIRhWPQXjWNfGZ9DAU0-GYOgHAAVXwAAvdBNiwIR9CbQKKPPGSHEYKAL37HhGGU-BZU0acsDyEKYA0ldWOUlddGnSTDF0XiuEkmBdA07dlLAZTGDoGwXy4DKLxIfR8zoXQV2MCBp3shx81omhLDPQ9il4ugAHYKPcb9WBQkht23AIeG3AA2SSoGnAJJPzZTC3ss99ECugzwcQbDwo6dsmPFBCDAFAAA0wP7RhC0k9ANOnFd6zA3jsk0Vi4qDG07TDf06GdKg3Q9b1fVh3l00R4NYD9VjHl0YpO1DK1KyzHMZjzWHeNLcs1UzatdX1VhDVh4w5FR4nob9R14aJpHPR9LmAyDSBsdh2MHDoBVeZJ+ncx4P0qZAMtcArOnsxrRnmeNEBWfZ61bUFnmg3dfnUe17mEeJkXQ212MbDcdwygzKt1d1cn5dhl9FeV1WXZzTWjWwDoOYN2GLelk2UcNy21Wtv0IyIXJpTAfAaHYVl2VjeM+gGDhDjAVMm2ltWyYp7X829mmZdd2smb9XWodD82hcxyOBbRvlpbjsW42Ydx2GyDJndJmt3YV6mVdpv2NbrFm2cbmHtfRiPkfb5ujcx7vbd7-vB9YYfZbHymJ99keGdn7WG8xzmO4x4m27Nh0W6tkMcceAI+7PGASB4XILUxkuo8y5qkrpPau-sL7WnntfJuT8N731Xo-OGMcsY2zVLGRsQIh4AOnm7YBIBvYUEFKwYUopxSSl-jKWUDtlREJADAGgNBMQ8BIPZNg8pFR5GVKfWWAdYaNmbK2dsnZuy9gHEOEcY4JxTlnPORcy50Brg3FuBwu4DzHlPJea8t57yPmfG+D8X4fx-gAkBEC4FILQVgvBRCyFULoUwthXC058KEWIjwUi5FKLbRovRRizE2IcS4jxfiQkRJiQktJWS8lFIqTUppbSul9KGWMqZcylkHDWVsg5JyLk3IeRfF5HyEA-IBWCmFCKUUYpxTPAlJKKU0oZSyjlPKBUiolTKhVKqNU6oNSai1NqHUuo9T6gNIaI0xoTSmjNOai0HDLVlKtfQ61NrbT2gdI6J0zoXSujdO6D0noBBem9T631fr-UBsDUG4NIab1frDGwkJmAbAcMUShYBjaIL9MvA+NdjA4CENg7WoCeE1z4ZfaBL9Rba0Mm4VIicwDJ1TigFepto7F1wTwf55QgVqgrifKeZ9a5aygXrVB8cIAdg-u4L+P9KjMwQWisOz9CWy2xYC-ex8lZ0IYUwt5rD2EOxILQpWQA",
        "[Sleepwalker's Snare]:___ N4IgdghgtgpiBcIDaBlANjGAHA7hNA1jAE4DkAzgAQqTEwC6IANCAGZoQBuA9sQCowAHgBcEIADwAjAHyoM2PIRIVqtBuID0MgDpgpxabr4ALGNQDCAUQBylgPoB5AOq2ASnesBBALKXKxAEssKm4AV2FKcm5YSgBjOghhAM4zGDASAHMAT0pWYmjKYVNKPk9XAHFLPg8fewd3L18UADoS4wCqWIhQ8hgqIrNSiqqa30cG2pRC7kjQ1lYSQpJAyQxKMACM42EoCDpyJkpJcMLilCtbRxdLCd9KHr7TvrMNrZ29x4gqVlCYNFzeE8AsRcuFQnQ4gkktwwORmrp9NJEcwQMI9hkYMIHOkxMJiL8UXjNhjiOYYQATALQ2EAGWSATAGTESGA2hAASgWF4aLAwicvHJbPgbO83EkATQVKybKYbOsDj4QrZrHwvRlbIAaq4AJIoADSniVbFVMHV4GgpoQIqyKDRwm15HKUJIJggYA1+F+Zo5XOIPPtvKNAEYAMxsgC+h1Z7M53LdfIFRoACmhQrECCVuEQwPA7HnKNYACzajLkrYZYQZLABABCsW1ngNkk8xAyAE0cNY254GwBHTwATjQACtyuZPAARACKGRrUD1lk8kgyU8sAFZCzhPDBPDSMgEHChyoJPDgHB2AEzbvg1wSWNDmcwZCcOWLmKA4Ns1mmsbjar-GJ4UCeEBVLcOQIYoD43DCL2eo4AAtHwGTlEGGSeAAEq45h6twng1gADBAAAcODNg4vbeMI5IANQYV+WSeEmU6eBkYAAFoEAh5AAFKFkmkAoN4w7mMYZY1v2lh4QQz4GtY2rGOY1gAGIoOQnAYRkBEYeu2rmGAKAQKU3BoJ4ACqDgAF7ZKEkjmKmZlQZO9GeJwUBToWwicOxDg0sYNahIylkwDxbYYexbYoDWNGWCgBGCDRMAoDxvbsRxnBoK4a6CD5U7kOYQZoCgbbWBANbKZ4QYIawTgTsOsQEWgADsUHkruxBvuQva9uUsEAGw0VANblDRQbsSGykTuYZloBOnglcOUE1gEo7eFgYDeAAGhehacCGNEZDxNZtkmF4EQExgYU5ZryoqVrGmgarMJqOr6oa914l6z3mrARoYV8KCxGklqyjGvr+tqgb3QREZRmyPpxry-LEIK93WBo72g7dRoqo9IMvbqBo4yaZqQL990Op4kopN6sZ+vGkPCEaMMgJGlDRgj9NI4maMYzdCrE3jZpaoT73Cg9T2g2Tlriw6rhuuS0S0+DDNQ+La4s2zHN0-6yOo-AYChGgaBYwLH34vjIAi29guS2y0tGt4WQONWGwwg4rB8OimIOk6MCJC6xhuh6qaW5zENq2yCFrrD7Pwzr8Z60a6OY3KZvi7jdtW69RPm19UsWn9XxkpyGDCDAbXGzSCtTr85DCOQyuIwGTPQ7H2sq9zKNGoZGzCNK33Y-dmeW9bucZyT30O-dXutpitqJL7zr8EH7qemHCe8ozwZhqzcNg83Sf3Um3A4CQ-N3RPQvfWPYvKpPBfk+Ls8YsIC-2o6y+umvodN1zLc701owFgRIMgkjJGASk1JyDV0gcyYBIAYDzBgLEBuyleB0k4AyJkiAWTx07gmbux9UzpkzNmXM+YiwljLMYCsVZaz1kbEuFs7ZOzdj7IOEcY5JwzjnAuJcK51ybm3Lufch5jynnPDgK8MAbx3gfE+F8b4Pxfh-H+ACQEQJQDAhBKCopYLwSQihNCmFsK4XwkRUi5FKLUTogxJiLE2KcW4nxASEAhIiTErOSS0lZKeHkopFSakNJaR0muPSBkjKeBMuZKyNk7IOSchOFybkPJeR8n5AKQUQphQilFGKcUEpJRSmldiGUso5QcHlAqRUSplQqlVGqdUGrNVau1Tq3Veq9gGkNEaY0JpTRmnNBaS0VrlDWhtbau19qHWOqdc6l1rpT0LvdVwMAoDcBSJ4VBAQYTCxznfVEFs-7+msKEKAkhz5tz3nHA+-8j7ixTqTFZ4tRJugxC7BkuywAe28KPA5tsN4ELORcq54to7t3wYfHm4sT5n2IM8p+bI3mMiSnafZotAUnPjCCy5CL7oIVDJrfe4dE4wrZL3KUiKZbItXhid+GKbbDwflC-+uKwVRyJZCu5utyUgGsJsbYuwITKV+GgChdgCzFlLOWSs1Y6zahrFkb8ng1wZHMDgcwa4Zw8UEOhBsJ4NR6prOQFiEBLA0iTOYZSNJPDsRwK4SwOAMI7HIHqGsSYIBqvKNYYiCFNrlGMHwHCQZzDeC3A4bwU4NRoELOhTgBBU4-RpSAcoyQYDanLlARl482SfSBc3dl+LxZAJREghYqDyDoOILA8k5B4GsyAA",
        "[Lunar Shield]:___ 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",
        "[Transmutation Circle]:___ N4IgdghgtgpiBcIDaAVAThMBnKBXALhPgJYD2YABAMLFoDGANjALogA0IAZgxAG6loUMAB74EIADwAjAHyoM2PIRLlqtRiwkB6WQB0w0tDP0oAFjAoBlKgFEAcjYD6AeQDqDgEqO7AQQCyNhT4MBB05lhB5hQoPh4A4jYo3v5Ozl6+AZYUEBRgIfhBMGFgxACOuBb4pkQUAO7EDAwUxFAADmikvJXmtNkMYTBQAJ7ZUg3EJDBYAHQUPo2RMCPVXUGkFAAm68QRGxi1i1gWWK1FxJzEdBRouHkRqlUwvRD95lATMGjZYBvN+ADkCwA5sRVo8oBQsKRYM1sMQgaYChAIvh1o8KFBSFgCjBOJwiiRVh8IXRoWNICpsNN9IYZLT2CBCGggTB8M48uJ8Dc4BwufCWWgqOQNhMyNgADKg4hgIHiJDAXQgFqtASEMD4VwCDaK+CKyyYCZDRVsRV2ZwoHWKzgvI7GxUANQ8AElLABpHyWrg2mB28DQH0IRV+IaWZROrBxND5T5mTD2l4VX3K1WYfBO9WegCMAGZFQBfNgUBVKtop9WatDawMgAAKDFwdAA1tFSI2YGB4I4uxQ7AAWJ1AjYIoH4IGtYgAIToTp87qkPmZAE1anZFz4Z6UfABOBgAKziVB8ABEAIpAidQV02HxSIEnmwAVl7tR8MB84pBzkscWEPlqzmXAAmV8UAnYQbAYKgqCBI9nDoKgoFqRcJ3FThSCdZDTB8KAfGwiYsWzSx-FIfBSldWoAFoUCBOJMyBHwAAkPCoV1SB8CcAAYIAADlqednFKPx8A2ABqBjkKGHwaxPHwgTAAAtRsKKwAApXsa0gSw-F3KhTCHCdNxsNjGxg907CdUwqDsAAxSwsF4BigQ4hjHydKgwH1GJSAYHwAFVnAALyBIZcCkKh618ojj3EnxeCgE9e3wXh5OccVTAnW4gQCmAVMXBj5MXSwJxEmxLA44QRJgSwVNKeSFN4BgPAfYQUpPLAqEzBhLEXOwIAnayfEzCjOFcI9dzoDiGAAdiIjZ33oKgsFKUo4lIgA2ESoAnOIRMzeTs2so8qF8hgjx8HrdyIidiH3PxWjAPwAA1AN7XhsxEoEVInRca0AjjiFMBiot9M0LWra0GFtdgHWdN0PWrLlE2hv1YE9BjkUsOh2wDE0SxVNA1TTDNqw4-NC2LZMCdTCsq11EA7C0eHcdBz0Iah3HHRdd1We9X1IFR6tw3mUEccVSnCfTfBPVJkACyLMXSyp8stU9BmmdNc0ech0WQE5uGtfZxV+YDOnww8TAtigJNFYl4m6YfGW5Ypm3qZV6s1ZBzXwd55G9e5hHuT5-00eRIU2iYYINms2hsXFC2TwqbEsGt-HbalkmyflvGyw1N34DAXBGmZr26bZnW-fh0ufdx43PWDZxxxKchnE4FAIGZVlw0jaNBGqMB43rHXxdTSXPQfTPndT13K09I99jmV5BhGDxbimTtuz7Ach1MEcx0nacfGIHwwCoCds3YnwTxPI9FziPx3zid0UA42pjonR6-DiHx5N-CdSBkgKj1Dx2FqAxLAvkfD2i-hOXsPhHoTioNZKa1l77yWvoeXyJ4JxDCwECGspAJwPh8AJV0rpLAiSHFQHBAV2J+A4mtBuu5WgbEXFATgkoHz2iPA+WoWFiF+DAu+GwQwoCHUeqURcuAAi8MXOecU1kbC1BrBZFSJ5SAeCBL5DwjZaikEPBONAvlxS4QmsIRcAUJxAidM4U6vYLGLhgIuV0W4gRoCgOKDiphhBUEXDEHwu4njWSwLgV0pg0CWGzGgf6iCTy1HFGxZw9ENj31fDAVoMkay7gYipVoWFLIThPH4KAth7SuAYDYUwj0AqmCgEeDYVA7ryQ8Okvwq5Ik+DWuxBgJ5dweToVg-Ai4bBxBPL5UJYAGJgEQk6FAvkYAniGJwXsKkKKNkYq0LANgtxfyoPacUlFGzcVcDAtaR4Cm+W4j4OIpAIFUEsCZHw0SbA2G4nYRqvZfK1DAK0b61kqAnhoGtRyaBeDEFqHQLcj1cDcSdCpbivl5LcUsDJOIak4EcUsLuYQrQpDCBPAxIYIkazCFUa6YQmYayNhsCpFSrTwVOmdHEc2fhhCJVMPaPwKlnLCAopmFSGwbCNj8NZOJcQGDimEA+Tgfg0GmHklNPwD4UABUzMkkS2Y8W8EAsINy1kOL4Gso2Ow+AbClAYBOFSDBShOmEK4cUezSj2l7BOe0KlxQqWsgxXJjZgn4FaLwGs6SjUqRnDECcrgNhrMevaKAgVALwoAnEZwNYUBrQfIBI8W5ALKsseKb6fgGK1B6WxI8Ngcp7FaNNBgAUAoeAYuKE84opCPVMNCZpvkUD2l8luVoj5tITg2K6DwKkazaVcFNeS8k1rWXkqhRcgERKcCdKUay214TIu2sePwlgNhQA8LO+SdA0CZhgEeUtJ4NjZqkO6dW9MS6KkRuXWG-sq7ayDgLOm6MsCY2xinHOo8M6y3JgrKeysZ7VnmAMYYnswavsNrrZ9lcrTVyNsHasbcO74FDEQLuUYiAxj7gPJGuNh7qgA3TXl2ZHasF5GgfknwhQ-FFOQLAccfhyhoyAXE+I6D4CwNZAQkpQUyjlJPHONNPR1gbM2FArZ2zr0cD2fsg5hyjnHFOGcc4FxAmXKudcPhNw7n3IeU855LzXlvPeJ8L43wfmIF+H8f4AK1GAjAUC4FILQVgvBRCyFULoUwthXC7xURYEIsRUi5EqI0TooxZirF2JcV4vxQSwkxISSkjJOSillJqQ0hALSOk9LnkMsZUyPhzKWRsnZByTkXIPjch5CAXkfL+SCiFMKEUopHhinFBKSUUppQyjKbKuV8qFWKqVcqlVqq1Xqo1ZqrV2qdW6r1fqg1hqjXGpNGaPg5rigWktFa61NrbV2vtQ6x1TrnTsJddiN0773Sei9N6H0vo-T+gDIGuF30m0VB4QYnQ3y8bFL6CunpH1-qVvgOwuAoBSE+NLCeIHxN51NIzX7npdKYBZA3aUYoW5+CfVzJDXo33I1IzDuHCO0Bj2R9naHEnqxzwgAcSDbxl6rywAppTW9VN7w04fY+p9z4TkvtfW+99xSPx8M-V+vl36f2-r-f+PhAHANAeAyB0DYHwMQcg1B6C-JYJwXgghRCSFkIoUCKhWAaETjoQw1oTCWFsI4VwnhfDnACN-OKYRoijziMkdI0wsiUIKKUSotRGitE6L0exQxxifCmPMZY6xtj7GOOca49xnjvG+NwgE4gQSQlhIiVE4gMS4kJKSSkmAaSMlZJyXk0+hTik2FKeUyp1Tan1Mac0wpbS0AdK6T0vpHEBlDJGWM0wEypm1BmXMhZSyVlrK9Zs7ZPhdn7NWUck5ZzRmXOubc+59EnkvLeR4D5XyfmLj+QC4gQLXGgvBZC6FsL4WIuRVctFj0MVYpxTxQJSJRJRPDJQpSpRpTpWnEZWZVZSqA5S5QYh5T5QFSFRFWl3FUlWlVlXlUVWVVVT8HVU1W1V1X1UNWNVNXNUtWtVtXtXFEdWdVdXdU9W9V9X9UDRPGDVDXYgjSjRjTjQTVvmTVTXTUzWzQsSBDzUXALSLV3BLTLX5TQErSmmrVrXrUbWbVbT3VaA7S7R7T7V3AHSHRHTHQnSnRnTnQXSXRXTXSBA3S-iPG3V3X3XFEPWPVPXPUvRQGvR+2RlrmrDiBFmT0pDB0QwNiHhdnVFh3h0R0AzzE424wJH40EwtiwA41liAA"
];
    
    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#9630BF"
        ..aspect_light = '#cc87e8'
        ..aspect_dark = '#9545b7'
        ..shoe_light = '#ae769b'
        ..shoe_dark = '#8f577c'
        ..cloak_light = '#9630bf'
        ..cloak_mid = '#693773'
        ..cloak_dark = '#4c2154'
        ..shirt_light = '#fcf9bd'
        ..shirt_dark = '#e0d29e'
        ..pants_light = '#bdb968'
        ..pants_dark = '#ab9b55';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Dreams", "Nightmares", "Clouds", "Obsession", "Glass", "Memes", "Chess", "Creation", "Singularity", "Perfection", "Sleep", "Pillows","Clouds", "Clay", "Putty", "Art", "Design", "Dreams", "Repetition", "Creativity", "Imagination", "Plagerism"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["ADHDLED YOUTH", "LUCID DREAMER", "LUCID DREAMER"]);

    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Dreamer", "Dilettante", "Designer", "Delusion", "Dancer", "Doormat", "Decorator", "Delirium", "Disaster", "Disorder"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Lunar", "Lucid",  "Prospit", "Derse", "Dream", "Creative", "Imagination"]);

    @override
    List<String> symbolicMcGuffins = ["dream","creativity", "obsession", "art"];
    @override
    List<String> physicalMcguffins = ["dream","dream catcher", "sculpture", "painting", "sketch"];


    @override
    String denizenSongTitle = "Fantasia"; //a musical theme representing a particular character;

    @override
    String denizenSongDesc = " An orchestra begins to tune up. It is the one Obsession will play to celebrate. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";


    @override
    bool deadpan = false;

    @override  //muse names
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Dream', 'Dreamer','Calliope', 'Clio', 'Euterpe', 'Thalia', 'Melpomene', 'Terpsichore', 'Erato', 'Polyhmnia', 'Urania', 'Melete', 'Mneme', 'Aoide','Hypnos', 'Morpheus','Oneiros','Phobetor','Icelus', 'Somnus','Metztli','Yohualticetl','Khonsu','Chandra', 'Mėnuo','Nyx']);


    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Dream Diary",<ItemTrait>[ItemTraitFactory.PAPER,ItemTraitFactory.BOOK, ItemTraitFactory.ASPECTAL],shogunDesc: "Tomb of the Writer’s Insecurities and Weaknesses"))
            ..add(new Item("Interlocking Brick",<ItemTrait>[ItemTraitFactory.PLASTIC,ItemTraitFactory.CALMING, ItemTraitFactory.BLUNT, ItemTraitFactory.ASPECTAL,ItemTraitFactory.LEGENDARY],shogunDesc: "A Fucking Lego But Legally JR’s Too Much Of A Coward To Say It",abDesc:"Lame. JR didn't want to use a brand name all of a sudden?"))
            ..add(new Item("Art Supplies",<ItemTrait>[ItemTraitFactory.PLASTIC,ItemTraitFactory.CALMING, ItemTraitFactory.ASPECTAL],shogunDesc: "The Tools For Smithing Pieces of Art That I Stole From KR"));
    }


    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.ALCHEMY, 3.0, true),
        new AssociatedStat(Stats.SANITY, -2.0, true)
    ]);

    Dream(int id) :super(id, "Dream", isCanon: false);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.dream(s, p);
    }

    @override
    void initializeThemes() {

        /*
        new Quest(""),
                new Quest(""),
                new Quest(""),
                new DenizenFightQuest("","","")
         */
        addTheme(new Theme(<String>["Arts","Craft","Crafting","Making", "Creating", "Building", "Creation"])
            ..addFeature(FeatureFactory.CLACKINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CREATIVEFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SPIDERCONSORT, Feature.MEDIUM)

            ..addFeature(new DenizenQuestChain("Make the Thing", [
                new Quest("A ${Quest.CONSORT} child tugs on the ${Quest.PLAYER1}'s sleeves and asks if they can make them a picture of a ${Quest.PHYSICALMCGUFFIN}. The ${Quest.PLAYER1} is happy to help! They discover that drawing the picture makes a ${Quest.PHYSICALMCGUFFIN} symbol on the locked ${Quest.DENIZEN}'s lair light up.  Only 99 to go!"),
                new Quest("An entire line of ${Quest.CONSORT} children are ${Quest.CONSORTSOUND}ing excitedly and expecting identical pictures of ${Quest.PHYSICALMCGUFFIN}s.  Some how each picture is harder to make and more agonizingly boring than the one before. The ${Quest.PLAYER1} is getting burnt out. A wizened ${Quest.CONSORT} approaches them. They wonder why the ${Quest.PLAYER1} looks so glum. Don't they enjoy drawing? When the ${Quest.PLAYER1} explains their situation, the wizened ${Quest.CONSORT} wonders if burning themselves out is really required like they think. "),
                new Quest("The ${Quest.PLAYER1} is happily drawing away. Sometimes they draw pictures of ${Quest.PHYSICALMCGUFFIN}s, but it's always in service of some new and interesting idea they want to test out. Often times their pictures don't even involve a ${Quest.PHYSICALMCGUFFIN}. Before they know it, the ${Quest.DENIZEN}'s lair is open. They sketch a few more things to get the ideas on paper before they lose their train of thought, then begin preparing to face the ${Quest.DENIZEN}."),
                new DenizenFightQuest("The ${Quest.DENIZEN} is a smug asshole about how they taught the ${Quest.PLAYER1} a 'lesson' on trying to force creativity.  The ${Quest.PLAYER1} thinks they were just trying to be a dick. They strife.","And THAT is why you don't piss of a creative person.","Shit. Now we're going to have to sit through this exact same strife again in the future. Lame.")
            ], new DenizenReward(NPCHandler.MP), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.HIGH);

        addTheme(new Theme(<String>["Memes", "Remixes","Mashups", "Deconstruction", "Satire"])
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CREATIVEFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.STUPIDFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CONTEMPLATATIVEFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CONFUSINGFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.LAUGHINGSOUND, Feature.HIGH)

            ..addFeature(new DenizenQuestChain("Deconstruct the Satire", [
                new Quest("There is a portrait of the ${Quest.PLAYER1} that some local jokester has vandalized to say 'bluh, bluh, huge bitch'. The ${Quest.PLAYER1} tries not to let it bother them. "),
                new Quest("More and more frequently, the ${Quest.PLAYER1} sees vandalized copies of their portraits. Teen ${Quest.CONSORT}s are even starting to snigger and ${Quest.CONSORTSOUND} when they see them! This cannot stand! They try to tear the vandalized portraits, but it only makes the teen ${Quest.CONSORT}s ${Quest.CONSORTSOUND} harder. "),
                new Quest("In a flash of inspiration, the ${Quest.PLAYER1} publishes art work that consists of 100 different remixed versions of the vandalized portraits. They explore the theme of 'bluh bluh huge bitch' so many times, in so many mediums it stops to even have meaning. In one move, the ${Quest.PLAYER1} has reclaimed the vandals hateful message as their own one of strength. "),
                new DenizenFightQuest("The ${Quest.DENIZEN} is furious that their campaign to discredit the ${Quest.PLAYER1} has failed. They attack the ${Quest.PLAYER1} directly in a blind rage.","Who's the bitch NOW, ${Quest.DENIZEN}.","Shit, that didn't go according to plan.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            , Theme.HIGH);


        addTheme(new Theme(<String>["Clouds","Fog","Mist","Rainbows","Moons","Night","Sleep","Dreams","Haze"])
            ..addFeature(FeatureFactory.SILENCE, Feature.HIGH)
            ..addFeature(FeatureFactory.ECHOSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CONTEMPLATATIVEFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CONFUSINGFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CREATIVEFEELING, Feature.MEDIUM)
            //trying to capture the "don't repeat yourself" of dream.
            ..addFeature(new DenizenQuestChain("Dream the Dream", [
                new Quest("The ${Quest.PLAYER1} is wandering around, as if in a dream. Everything is hazy and confusing. A ${Quest.DENIZEN} Minion wanders by in a ${Quest.MCGUFFIN} ${Quest.PLAYER1} costume and it just seems inevitable.  "),
                new Quest("You are trying to make sense of things. What is going on lately with the land? A ${Quest.CONSORT} is ${Quest.CONSORTSOUND}ing in reverse. Another is in a ${Quest.PHYSICALMCGUFFIN} wig.  "),
                new Quest("A boardroom filled with underlings glares severely at the ${Quest.PLAYER1} when they rudely barge in. Embarassed, they stammer out an apology and leave. "),
                new DenizenFightQuest("The ${Quest.PLAYER1} rides a rubber ducky, which is itself made out of jello. It's obviously time to fight the ${Quest.DENIZEN}.","Oh. It's finally over.","The dream won't end, even if you die in it.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH); // end theme
    }
}
