import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Hope extends Aspect {

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 1.0;
    @override
    double fraymotifWeight = 1.0;
    @override
    double companionWeight = 1.00;

    @override
    List<String> associatedScenes = <String>[
        "[HOPE RIDES ALONE]:___ N4IgdghgtgpiBcIDaAJA8gBQKIAIBKAkgCJYDKOAggDJoByWAuiADQgBmANhAG4D2ATgBUYADwAuCEAB4ARgD5UmXIRLlqdRlID08gDphZ-OfsEALGDlIBhLPQD6aAOr08d2hQCyuAO4BLAM7m-jhsAjgQODK8vP5iOLxsOAAOvN4w-AB0lgCu-BYwYLzZAOamzDi+cQDGvLDBYrw4YuZQWWYwAJ44okkcvAAmFn7N4TjFfX5gxeG5EdwBvjIcFmz8tSEQ-OVsm+HeEB0Z+oZyJywgYpvFMGJoYHCIYvzZcKxPvsXX-Fa8YP2Vvl+-iovnmU0kSGAuhAvigKX4lzAYkcAn60Pg0NIEDAlQ60OY0NoaEE6OhOw4-hg+OhADVCKQANIUUnsCAUqksaGQWAsjwdUiXMQEfwAcTyEDE6TM2JpbJe1JhcIEiKFSJZAEYAMzQgC+5ShivhKpR-DRCGhGA42SqAGscIJeDaCvA7K6cLQACwEYr9UrFMTFJK+ABCVQIFCZMgo-GKAE1vLRYxRwwBHCgATg4ACsRVYKEQAIrFYNQBlYCgyYoFrAAVg93goMGoxV8aFIIpEFG8aHjACZG4JgyIsBwrFZikQ0FUrFBvLHg1RQgR56YKFAKGvKjFNaRPLwxCmGd4ALSCYoi9XFCgoPBWBm8CjBgAMEAAHN4o2gUx4xP0ANQoPOHQUBgBYUMUYAAFo2se-gAFIehgkCkB4WZWKYvrBmmWAPjaE5MrQBCmFYtAAGKkP43AoMUT4oLWBBWGAWKCBQvAcBQACqaAAF7FB02QyFYVocbu+aARQ3BQAWHpiNwkFoFQpjBtkUzcTAcGxigkGxqQwZ-mQT4iH+MCkHBKaQVB3AcHgNYiPJBb+FY6ocKQsa0BAwakRQ6rHmwjhEFmVRPhwADsu79NQ-DTv4KYpiKB4AGx-lAwYin+6qQZqpFEFYHEcEQFBuVmu7Br4OYeEkYAeAAGr2HrcJqf7FHBwaxhgvZPr4pgoKJCpEiS5qsuyCp0gQjLMoNTzypy4DQByGIgCgED+KQVQFByBKGsq2KqmILJPrq+rQrCRo7SaZoLbQWgTZt-UsuSlIjfSTL3Wyj0zdy83QsKFAcKCG3HUqCI7QQaqDQdIB6jgBondtSLnSyV03YSxKvcNM2jeNaPvZtn0ssKeDYv0tQKrDwNIqDe2DTWENQzDQPGqiiPXX1qODQ9AMgJjL3s29nN44NwqkDAHBsKTDMg2DC200dW3k8iTODUjrMDQtHNPWNPMLVN-NzfjooDIIvjpOLp0U1L0Iy9DgNmwrposhgqQmzNd28+jm3cxNat8wqAsLXyAoSsKYowBKUqmDKcqc2TKqUxqmpPonupMG8-AfF8Px-ACQJUETEIpyAMBsGwMBVGI-ikQIIJgsUEL07bCODZa1p2g6TpgC6bqet6vqmP6gYhmGEYVtGcYJkmqYZtmub5kWJZlhWVa1vWjbNq27adt2fYDkOI5jhOU4znOC5Liua4blAW7+Due4Hkep7npe163vej4vu+n7fr+AFASBYEQdBWCCEkIQBQmhDCxZsK4XwhQQixEyIUSojROiNYGJMQgCxNinEeJ8QEkJbIIkNxEHEpJaSsl5KKWUqpdSmltK6X0qQQyxlTLmUstZWy9lHLOVcu5Ty3lfL+UCsFMKFAIpUCilYGKcVErJVSulTK2Vcr5UKrQYqj4yoigqlVWq9VGrNVau1Tq3VeofT1oNPAMAoC8G4E2MugIwAayxpNZ40cJZIloNkKAMhnbS0OtbOWjN7ZNydvwX2ZiFroWxNcQOVMPbPS9mSH2M0Y47Q8V4nx0ItRJ0hrLFJ8NFYLUdmkUJpieSDUiVMEygpHFa0Se7G2cMxBpO8SUhaWTaYFyLiXMuFcq5E38PnSGQA",
        "[The Stand]:___ N4IgdghgtgpiBcIDaAVAFjABAZQC4TABMBdEAGhADMAbCANwHsAnFGAD1wRAB4AjAPlQYc+IsW4B6AQB0wfJv1nos2AMIBRAHLqA+gHkA6toBKOzQEEAsusxMYEatQCemAO4FcAZ0yeGsXGgAlmAA5pgBELjhwijmxgDi6ihmVrp6phbW2JhoEJ4AdJgGgQHRWAAODK4wTJgMlDkM5TBkboGeGN4AxgSYXX5YuEwArjAAhEW5uDB0NZgl894RUQFYsQlJKdb6GanZDGBdWLmErQtgVZi8MNQHIUsMZTga2vpG6rvW+bLy-L-kIHwTBCMFwejAcEQQ1GAKGgRCIKYqgOhBKgQOngAMoE6MEQlwkMBpCBAlBKkxRLgDMxCMT4MTLAxeIFqCUnMSyMTNHoUHTiZQHJ4YBziQA1YwASWwAGlzHyqILheRiZBYPLLE48JEJZ54nZIjV0ARRQ5RiKSWTmJSJWBcPKAIwAZmJAF9WkSLeTKdSmLSEMSAArUYZdADWmBQDFDMDA8B08cwmgALBKQoQQmgQrgQuVAgAhLoS8yy3jmYEATVcmnL5iLAEdzABOagAK3iqnMABEAIohPNQaXqcy8ELd9QAViTrnMMHMmJCgT02HibHMrj0lYATDOUHm2OpqKpVCFO3ouqooK5y3nMZQGBLr2hzFBzM+SgxPI7sFYGLg69LXAAWhQEJ4ntEJzAACWMVRpQYcw8wABggAAOVxSz0OtLFwQgAGpIOvJxzADbtzBCMAAC1Q0AzwACkkwDSBsEsFtVDQdM8wbdR4NDE9ZU0CU0FUTQADFsE8OhIJCRDIInCVVDAbAIFiBhqHMABVPQAC8QicYZeFUYN1O-LsCPMOgoG7JNcDoCi9ExNA82GUItJgWjy0gijy2wPNcPUbBELYXCYGwWi6woyi6GoYxxzYOzu08VR7WobBy00CA8xE8x7UAygDE7FsukQ6gAHZv0IOcmHPTw6zreI-wANlwqA83iXD7Qox0RM7VR1OoTtzDSltvzzQI20scowEsAANTckzoR1cJCWi83LANN0QwI0EgkzzW5Xl-QVaghXNcUpVleVoSVTlwGgJV6RASC8mwI4IXNUkvQ8G07UOxDXXdYkPqtDwfT9B7NAkOVlRAfb5QFY7rrFSUZShh74ZO6HVXu4kdXMVlZney0KS+215T+kA3UwD0geJ21QflCGoZu2HDvRxGQDOlG4cVc0sflHVjAIQg-EJz7bW++Vx3JynqaJ70aTpMBhkcZmeUukZ2c5i7WZ5zG7vVJw9FzMB0TAPRKBQCBgVBHU9XsaYWFyMATWDdmaetUnDsA8d-qpwG5ZBhXDsZva1Z1hHTuR7WHqu3n9cOp7Er8cpqFBGAKscTEhe7UZPC8UXgfFz2HulgHPULqkg4ezBQ4OtHdZurXUf5BuVXjh7E4laYoHS2A-Ru92SZ+kvfdlsXK99eURLsLBikcWvuYj6Gm8XjGbr5w7Let3AtVwW39Qdo1ndNN2A6L4fiUAp1XVICg4QRGpkSINEMSzogCVvkAYEoSgYC6LwRLMGxLiUIBIx4V3podIMIZwyRmjLGeMOhEwpjTBmLMOZ8yFmLMOMsIRKzVlrOYBszY2wdh7H2AcQ4RxjknNOWc85FzLlXOuLcO49wHiPCeM8F4rw3jvA+PMT4XxvlwB+L8P4-wAWAqBcCUEYJwQQshNCGEsI4XwoRYipFyJURovRRiEBmKsXYn2LiPE+LmAEkJUS4lJLSVkuOeSillLmFUhpbSul9KGWGMZV8nYzIWSsjZOyDknIuTch5LyPk-IBSCiFMKEUKJRRinFPQCUkopTShlLKOU8oFSKqVcqlVqq1XqnWJqLU2odS6j1PqA0hojTGvECaU1ZrzUWstVa61NrbV2nrNUh1jAwCgAwWY5h-6m0judZugINYF1prgTQwwoDXCYGTUe-tx6QPBpDOO-SHpsQICCI2wRTbm0sJrKO0y2ZzMpIs5ZNR5Te3WeXeZWziTTxgLPFk1BdnYxAAc0IIV8A-Ubpc1ep9x53JWY8p0pc-YvPlpPQ6Nc+l-IDIEMMlQwygmwHiVOXchm93TpMrm4c14bIrlCh5v0b4Am-r-f+nhAFMDfoQTwH8KZAA",
        "[Breaking Out]:___ N4IgdghgtgpiBcIDaAhATjCBrAlmA5gAQDyArgC4C6IANCAGYA2EAbgPZoAqMAHuQiAA8AIwB8qDNjxEyVQQHoxAHTAi0olZwAWMQgGUAwgFEAckYD6xAOpmASuZMBBALJHCWMGwDuAZ0LktCHJ-HUJOR1sAcSNOBxcLYnsnVz1CHD88QghCYRxgtnosnIgAE0IAB2YAY10vPK0Q3XK0NnKdKoBPQgLCEswAwkY2NihpbpYYNEacKZ1SmkIfNkauvqqcPv9lqpH6DmCAmChCOoHs4WGfA+WIRkZuwsOZxfIgnwA6QgBJR50OgHIMIR8GwxuRliUcDAFocuqN8FpghA-F4YHdgRDvGBFnUCNJ3io1KIibQQK80PgYORiGA4IhyGhSHA6AycPhKWgDGwwJDyDhuT4ADI4FjSARIYBKEA4KDlfYQMDkKwcEpS+BSgBiGF0VhwdylNClJmInDVUvotx8MANUoAarYvnoANKOM0MS3W2hSyCwN3ODp6V7kL4+SKSciTbQK223Jk26Wy+WKr6Kt0ARgAzFKAL4LSUJuVoV6K5VoVUIKUABUYpCqWDCbCwMDA8HMbcIJgALF98CUEfhyPhyjgUFUvo4XcJHBSAJpeEwzxzjgCOjgAnIwAFaRAyOAAiAEV8CgoE6jI5hPgD0YAKydryOGCOQX4HDEPSRHiOLzEOcAJkfTgUB4IxGAMAx8D3YgqgMKAvBnFBBT2L4EK0RwoEcdC8jYHwMz0Fw2HIZcnS8ABaTh8EiNN8EcAAJWwDCdNhHBQAAGCAAA4vCnYhl2ccgSgAalohCOkcSsD0cfAwAALSwUifAAKU7StID0ZxNwMLQ+xQVcjGYrBIJdEwvi0AwTA1PQfBYWj8FY2jby+AwwD0CBwjYRhHAAVWIAAvfAOlIYQDBrLz8P3ETHBYKAD07cgWBk4hBS0FBSAIXyYEUmdaJkmc9BQQSjD0VieEEmA9EU5cZNklhGFsG8eESg8fAMNNGD0GcTAgFANUcNNSPoKw903KpWMYAB2fCSmfNAYJ8Zdl0iIiADZBKgFBIkEtMZIzDU9wMLzGD3RxOs3fCUBwbdnHKMBnAADT-TsWAzQT8EUlAZ0rP9WJwLRaPC+NjVNCt3UYK143tR0XTdBk4y9cBoE9dUQFo5E9BqWl4xlQti2DVMQdYnM8ylbGkyVFU3RMeRXXhoG3QtMHPUNEBIedGnkYZ8H4Z9JGpRDRxGBFJmScTIsFTx8g3UJkBc0IfNSbFksKZBqmaeZumQc54WWYdNn6Y9eMebdENbAVEoRix0XcZTSWQZvaXZflq3xdLct4DAUg7nVk19cZiHdehzWDe5xG-Q6YhhzAfkwGIehOAgCkqRDMN+kjQIwBjGttYV638eRm8iblkWcZd5XkdVwGfaDv34dZwPkdh7WjZB1GWpGSoqRgEo92bHAMrAQUzYPJkrh8S2S+TPOpQd4mCzJ13KepyvgY54Pmbr9nzTX71Q5b5FHCqPkJkrFo2hgTpx7Jm2pcLp2J-Jss3SMHhykmKEwBqZeYcZbWN99rnmbN2RvHRO5BAxBGTuGNO0ZYzZ2dpPW2yNMwO2oCyNAbIORch5HkaOQozbilQSAGA9B6Dn3ID4DUHBhSigIOKO+88y5VhrHWBsTYWxtnMB2bsvZ+yDmHKOcck5pz4DnAuJcjhVwbm3LuQ8x5TznkvNeO8D4nwvjfB+L8P5-yAWAqBcCkFoKwXgohZCqF0KYVGOCXC+FnCEWImRCiVEaL0UYsxNinFuKOF4vxISIkUBiQklJWS8klIqTUhpLSOk9IGSMo4EyZkLJWRsnZByN4nIuTco4Dy3k-IBSCiFUgYVMJ7kitFWK8VErJVSulTK2Vcr5UKsVUq5VKrVRkrVeqjViDNVau1Tq3Ver9UGsNUaE0pozTmgtJay5VrrU2ttXa+1DrHVOudS6kRrq3Qek9F6b0PpfR+n9AGIdfQg1sEcNgEwD58m5P7KGm8yQ-0vorcgJhSBQGEJMG+MtZ451Lo-FWS8Tm8xAFpBUlII54GjrHZwv8A4PK1s83GbyPlfLtrfYuDCAXI2fq-dBzZP7ArdGCgg5Ugx3L1tXABmKXkos+WgdMWYZaEOIaQw+FCqFmx8AQmWQA",
        "[Intermission]:___ N4IgdghgtgpiBcIDaBJMAXGAnKBLAzvrgPZgC6IANCAGYA2EAbsVgCowAe6CIAPAEYA+VBmx5CJcrwD0QgDpgBWQQtYALGAAIAygGEAogDl9AfQDyAdWMAlE4YCCAWX2bYMdPk0B3XOjWa-LVZ7awBxfVY7J1MzWwdnbU1cME0ITXwoCDo6TQAHYgBjAGt3TWIaTQBXMCwYLN8ATwC1CHRmrT0jGKt9OOjvXGyYABMkjGJNTgJMMAKYADpNFHQAck8oSoL-KBYtWoYOZIBzMc0NWspNfkq2wMnD-Bm5soq-AjyGZ-wYGChPdAmLUYWnwxFgmjAMCOrVwwNSNBoMAKbVI7TGmCOWEaLzRNAg-CxBTOxDow2Omlq9XQTQBR3c50W6g6BmM5h6fWcZTAdCaWToxC8nl8AQmU0emhoLFSnn5YBOEE8+NBdBuMB5EKRMEIECwDXmCiUgkNVBA6B1dPQZkhPDxdG+JvQWKOdKwulIZPQknwABlYcceEhgHIQLgoPksGaMBYWMNg-Bg9oIGBGsHKMHDGZWHHg7bvqngwA1awobQAaXs2doWTzVGDkFglccDW0ZvQKHwoUpmDYLTABaylRg+ZDYZYkbbGErAEYAMzBgC+lyDI-D4+jWFjCGDAAUVcVNKxiCUwPATGfNIYACwoI7DI5qI7oI65XAAIQKKHs5f49iwRwAml4hj-vYn4AI72AAnHQABWoS6PYAAiACKRyvlApb6PY-BHMh+gAKyXl49gwPY3pHLgZjaKEHD2F4ZiAQATCRrCvhw+h0LouhHIhZgFLoUBeP+r7epKKDCWo9hQPYUm+MQ+AztoTjEOgYGll4AC0rBHKEU5HPYAAS1i6KWxD2K+AAMEAABxeD+ZhgY46DDAA1AZwkNPY27IfYRxgAAWkUGn4AAUpe26QNojgwboah3q+EH6GZRQ8eWhgoGouiGAAYto+CMAZRwWQZBEoLoYCJsEJL2AAqmYABeRwNJU-C6CqNVKUh7n2IwUDIZe6CMP5Zjemor7VEc9UwCF-4Gf5-7aK+Ln6NoFkcC5MDaCFYH+QFjB0NY+EcMNyH4LoU50No-6GBAr7ZfYU4aTQFiITBBQWXQADsSnDGRWD8fgYFgaEqkAGwuVAr6hC5U7+TO2WIboNV0Ih9jXTBSmvrgcGOLkYCOAAGoxl6MDOLlHCFr7-tujEWbgagGZ1w4ZlmW5VnaQ61iARYluWlaOoOw71pz8YgAZCraHMkLDqGq5JhO6CVhZC5LsGstjvL66bqLhjSBWXMs5Wuac2m3PFmW+ui8bQvQCLwbtvYdCwibaujhG8toIrbPKyAi6aMu6vu1GMaVrr+um4bbPW1zPMW0b1Yu+AtuVu21hJsMYIy2746e5W+E+37AfZ5rIcIGAlTZBHmbxxzw6x3zUcJzbDZs02ZgvsmpBmDQrDmu47adnU3bqEm-Yqongc55ObP4Sr-uu3LwcbnG5eV+m1eN7XMfmw3VtN1zwuVr3f7uPg7fJJI3eODAA9dtgI99gOE-Fxgucz3PReL+gWuh3rzMb3vLept66W2DALROh82bizOmCXIdB3AjGyrgLAjxvTp2QoOR4+As5fzfqLAuFBqCOlwM6bAbowAei9GgihAZCEgBgAiJEHhsosF9Iwf0iBAwLw1kvbWO49xFAPEeGAJ4zwmAvNeW895HzPjfB+L82FfwASAiBcCUFYLwSQqhdCmFsK4QIkREiZEKJURonRBiXhmIwFYuxTi3FeL8UEsJUSxBxKvkktJWSAIFJKUcCpNSmltK6X0kZEyZlLI2TsvYByTlXLuVfJ5byvkApBVCuFSK0VYrxUSslVK9h0qZRynlAqRUSr4TKhVCAVU6C1Qak1FqbVKgdRkohbqvV+qDWGqNcacopozTmgtJaK01obS2jtPaB0jonTOhdK6N07oPSei9N6H1vr2F+t6f6uhAbAzBhDKGMM4YIyRijNGhgMbmWxqEXG+MiYkzJhTKmNM6YMyZgfZObNrC-GIMCewyJJB1x3qA00WBBZc0nvLQwlQoD8GwErD+3Cg7f1LjrP+7yW6i1ikmOk59O5gCvonEBNcaymwhRgKFMK4Xv19qrFcPDkXLzZomZM1Jm52xAFiuUMAmwtlaIC3mwLo6kpfugClsKsDTjnDS+edKkU-yZUmFM6L2WcrpLyr2wCgXEufl-MVVLRazgRbKtcKLgxssbMQMkNBmxaiIKQAydQ6B+H5XHTeJLEXjj1RKtmGkpwWQISaBhiJkT4BYVgahwx8C0N9kAA"
];
    
    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#ffcc66"
        ..aspect_light = '#FDF9EC'
        ..aspect_dark = '#D6C794'
        ..shoe_light = '#164524'
        ..shoe_dark = '#06280C'
        ..cloak_light = '#FFC331'
        ..cloak_mid = '#F7BB2C'
        ..cloak_dark = '#DBA523'
        ..shirt_light = '#FFE094'
        ..shirt_dark = '#E8C15E'
        ..pants_light = '#F6C54A'
        ..pants_dark = '#EDAF0C';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Angels", "Hope", "Belief", "Faith", "Determination", "Possibility", "Hymns", "Heroes", "Chapels", "Lies", "Bullshit"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["GADABOUT PIPSQUEAK", "BELIVER EXTRAORDINAIRE", "DOCTOR FEELGOOD"]);


    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Honcho", "Humorist", "Horse", "Haberdasher", "Hooligan"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Hope", "Fake", "Belief", "Bullshit", "Determination", "Burn", "Stubborn", "Religion", "Will", "Hero", "Undying", "Dream", "Sepulchritude", "Prophet", "Apocryphal"]);


    @override
    String denizenSongTitle = "Etude"; //a musical exercise designed to improve the performer;

    @override
    String denizenSongDesc = " A resounding hootenanny begins to play. It is the one Irony performs to remember the past. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";


    @override
    List<String> symbolicMcguffins = ["hope","beliefs", "imagination", "dreams", "waves"];

    @override
    List<String> physicalMcguffins = ["hope","magic feather", "wand", "talisman", "spell book", "stone tablet", "idol", "lottery ticket"];

    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Hope', 'Isis', 'Marduk', 'Fenrir', 'Apollo', 'Sekhmet', 'Votan', 'Wadjet', 'Baldur', 'Zanthar', 'Raphael', 'Metatron', 'Jerahmeel', 'Gabriel', 'Michael', 'Cassiel', 'Gavreel', 'Aariel', 'Uriel', 'Barachiel ', 'Jegudiel', 'Samael', 'Taylus', 'Tzeench']);


    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Wand",<ItemTrait>[ItemTraitFactory.WOOD, ItemTraitFactory.ASPECTAL,ItemTraitFactory.MAGICAL, ItemTraitFactory.REAL],abDesc:"It's probably science powered.",shogunDesc: "Shitty Wizard Pencil"))
            ..add(new Item("Angel Feather",<ItemTrait>[ItemTraitFactory.REAL,ItemTraitFactory.FEATHER, ItemTraitFactory.ASPECTAL,ItemTraitFactory.GLOWING,ItemTraitFactory.MUSICAL, ItemTraitFactory.LEGENDARY, ItemTraitFactory.MAGICAL],shogunDesc: "Shitty Wizard Pencil",abDesc:"Angels are, like, these terrible feathery monsters. Don't fuck with them."))
            ..add(new Item("Never Ending Story DVD",<ItemTrait>[ItemTraitFactory.SHITTY, ItemTraitFactory.IRONICFAKECOOL, ItemTraitFactory.ASPECTAL, ItemTraitFactory.MAGICAL, ItemTraitFactory.FUNNY, ItemTraitFactory.REAL],shogunDesc: "White Dragon Kidnaps Kid The Movie"))
            ..add(new Item("Candle",<ItemTrait>[ItemTraitFactory.REAL,ItemTraitFactory.GLOWING, ItemTraitFactory.ASPECTAL, ItemTraitFactory.ONFIRE],shogunDesc: "Dying Light Stick"))
            ..add(new Item("Fairy Figurine",<ItemTrait>[ItemTraitFactory.PLASTIC, ItemTraitFactory.GLOWING, ItemTraitFactory.ASPECTAL, ItemTraitFactory.REAL],shogunDesc: "Tiny Petrified Tinkerbell"));
    }

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.SANITY, 2.0, true),
        new AssociatedStat(Stats.MAX_LUCK, 1.0, true),
        new AssociatedStatRandom(Stats.pickable, -2.0, true)
    ]);

    Hope(int id) :super(id, "Hope", isCanon: true);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.hope(s, p);
    }


    @override
    void initializeThemes() {

        /*
        new Quest(""),
                new Quest(""),
                new Quest(""),
                new DenizenFightQuest("","","")
         */
        addTheme(new Theme(<String>["Meditation", "Altars", "Hymns", "Chapels", "Priests", "Angels","Belief","Hope","Faith", "Determination"])
            ..addFeature(FeatureFactory.CHANTINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.MUSICSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CONTEMPLATATIVEFEELING, Feature.HIGH)
            ..addFeature(new DenizenQuestChain("Learn to Believe", [
                new Quest("The ${Quest.PLAYER1} is just minding their own business when they see a wizened ${Quest.CONSORT} walk sedately off a cliff. Before they can even panic, though, the wizened ${Quest.CONSORT} is revealed to be walking sedately in mid air! How did he do that? The ${Quest.PLAYER1} calls out to the  wizened ${Quest.CONSORT}. When pressed, she reveals that the key is to BELIEVE. Never waver, never lose faith. Just believe. The ${Quest.PLAYER1} begs to be taught the secrets of such STRONG belief, and the wizened ${Quest.CONSORT} agrees to mentor them."),
                new Quest("The ${Quest.PLAYER1} isn't doing so well. They meditate, they do everything they can to believe, but still they fall when they step off a small ledge.   The wizened ${Quest.CONSORT} admonishes them with a gentle ${Quest.CONSORTSOUND}.  Unless they can believe 6 impossible things before breakfast, they will never make progress. "),
                new Quest("A village of ${Quest.CONSORT}s has been destroyed and looted. ${Quest.DENIZEN} is quietly blamed by the survivors. Their lair is unreachable by normal means, being across a vast gulf. Any bridges or ropes that cross the chasm are immediately destroyed by underlings.  The wizened ${Quest.CONSORT} calls over the ${Quest.PLAYER1} and hands them a ${Quest.PHYSICALMCGUFFIN}. They didn't want to give the ${Quest.PLAYER1} this ${Quest.PHYSICALMCGUFFIN}, for it would make belief far too easy and it is more rewarding to do things the right way. But the need is too dire. The wizened ${Quest.CONSORT} asks that the ${Quest.PLAYER1} defeat ${Quest.DENIZEN} and retrieve their belongings."),
                new DenizenFightQuest("${Quest.PHYSICALMCGUFFIN} in hand, the ${Quest.PLAYER1} marches forward across the empty air of the chasm. They challenge ${Quest.DENIZEN} to combat.","The ${Quest.PLAYER1} is victorious. They bring all the stolen valuables to the ${Quest.CONSORT} village and thank the wizened ${Quest.CONSORT} for the ${Quest.PHYSICALMCGUFFIN}. In a dramatic reveal, the wizened ${Quest.CONSORT} reveals that the magic of belief was in the ${Quest.PLAYER1} all along. The ${Quest.PHYSICALMCGUFFIN} was just a trinket they bought online. The ${Quest.PLAYER1} learns to have faith in themselves. ","The ${Quest.PLAYER1} fails to believe hard enough. They are defeated.")
            ], new DenizenReward(NPCHandler.HP), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.HIGH);
        addTheme(new Theme(<String>["Lies", "Bullshit", "Deceit","Slander", "Fakes", "Con Artists", "Ruses"])
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.CHAMELEONCONSORT, Feature.MEDIUM)
            ..addFeature(FeatureFactory.STUPIDFEELING, Feature.HIGH)
            ..addFeature(new DenizenQuestChain("Believe the Lies", [
                new Quest("The ${Quest.PLAYER1}  is approached by a Crafty ${Quest.CONSORT} who offers them a magical ${Quest.PHYSICALMCGUFFIN}, guaranteed to grant them the power to believe things into existance once per year. The ${Quest.PLAYER1} is shocked to discover it was a ruse, and the Crafty ${Quest.CONSORT} has already escaped to the side with their ill earned boonies. "),
                new Quest("The ${Quest.PLAYER1} is contemplating the magical ${Quest.PHYSICALMCGUFFIN} they wasted their boonies on.  Why would the Crafty ${Quest.CONSORT} tell such specific lies? Maybe...this is some kind of... challenge? The The ${Quest.PLAYER1} spends time imagining what they would try to make if it were true."),
                new Quest("The ${Quest.PLAYER1} finds a grey town of despondant ${Quest.CONSORT}s. Their belief is gone, and they have no hope for the future. After some amount of shenanigans, the ${Quest.PLAYER1} learns that ${Quest.DENIZEN} has been hoarding all the belief and steals it from the ${Quest.CONSORT}s regularly. They have to be stopped!"),
                new DenizenFightQuest("The ${Quest.PLAYER1} approaches ${Quest.DENIZEN}, magical ${Quest.PHYSICALMCGUFFIN} in hand. The ${Quest.DENIZEN} rears up and rumbles 'I DO NOT BELIEVE YOU ARE GOING TO FIGHT ME.'.   The ${Quest.PLAYER1} feels frozen. They cannot take a single step towards ${Quest.DENIZEN}, even as it looms menacingly towards them. What is going on? Suddenly, they feel the ${Quest.PHYSICALMCGUFFIN} in their hand. They wish it were real. They wish so hard because if it were they could just WISH they could fight back. Suddenly, they are able to attack!  The Strife is on!","${Quest.DENIZEN}'s belief was no match for the power of the ${Quest.PHYSICALMCGUFFIN}. They are dead, and hope will be free to flourish among the ${Quest.CONSORT}s once again.","The ${Quest.PHYSICALMCGUFFIN} could not stand up to ${Quest.DENIZEN} after all. The ${Quest.PLAYER1} has been defeated.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            , Theme.HIGH);

        addTheme(new Theme(<String>["Possibilities","Alternatives","Change","Possibility", "Potential", "Hope"])
            ..addFeature(FeatureFactory.CALMFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.HAPPYFEELING, Feature.LOW)
            ..addFeature(FeatureFactory.STUDIOUSFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CONTEMPLATATIVEFEELING, Feature.HIGH)
            ..addFeature(new DenizenQuestChain("Be the Change You Believe In", [
                new Quest("The ${Quest.PLAYER1} finds a grey town of despondant ${Quest.CONSORT}s. Their daily lives are without meaning, without joy, and will never change. ${Quest.DENIZEN} has stolen all possibilities, all hope away. There is only this.  The ${Quest.PLAYER1} vows to find a way to help. The ${Quest.CONSORT}s fail to be inspired."),
                new Quest("The ${Quest.PLAYER1} learns that part of the reason the ${Quest.CONSORT}s are hopeless is that the local ${Quest.PHYSICALMCGUFFIN} mine has dried up. Without ${Quest.PHYSICALMCGUFFIN} the ${Quest.CONSORT} economy is completley flat. There are no jobs!  The ${Quest.PLAYER1} refuses to give up. They search high and low until they finally find a new source of ${Quest.PHYSICALMCGUFFIN} for the consorts. There is a festival to celebrate. Things are finally looking up!"),
                new Quest("Disaster strikes! The new ${Quest.PHYSICALMCGUFFIN} mine has been utterly destroyed. It is obvious that it is the work of ${Quest.DENIZEN}. They simply refuse to allow hope to survive. The ${Quest.PLAYER1} is going to need to deal with them."),
                new DenizenFightQuest("The ${Quest.CONSORT}s deserve Hope, they deserve a better life. The ${Quest.PLAYER1} is going to show them. But before they can work on fixing their problems, ${Quest.DENIZEN} must be fought. The ${Quest.PLAYER1} dramatically challenges them.","Hope. Survives.","Hope is dead.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new DenizenQuestChain("The Ultimate Hope", [
                new Quest("The ${Quest.PLAYER1} discovers a group of ${Quest.CONSORT}s locked in a sadistic death game. When all seems lost, the ${Quest.PLAYER1} inspires them to pull through at the last moment and survive, defeating the Crazed Mastermind (who was of course hidden within the group of ${Quest.CONSORT}s) in the process."),
                new Quest("The ${Quest.PLAYER1} finds ANOTHER group of ${Quest.CONSORT}s locked in a sadistic death game orchestrated by a Crazed Mastermind. They do the Hope thing and inspire them to persevere, but this is getting ridiculous. Where are all these Crazed Masterminds even COMING from?"),
                new Quest("The ${Quest.PLAYER1} has dealt with so many death games at this point. You don't even know. Finally, they find out that every Crazed Mastermind ${Quest.CONSORT} has been working for the ${Quest.DENIZEN}. All of them. Looks like it's time to finally challenge the Ultimate Despair. "),
                new DenizenFightQuest("The ${Quest.CONSORT}s deserve Hope, they deserve a better life. One not full of random ass death games.  The ${Quest.PLAYER1} is going to stop the ${Quest.DENIZEN}, once and for all. ","Hope. Survives.","Hope is dead.")
            ], new DenizenReward(), QuestChainFeature.playerIsMagicalClass), Feature.HIGH)
            , Theme.HIGH); // end theme
    }

}
