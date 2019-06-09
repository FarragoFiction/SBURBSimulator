import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";


class Mind extends Aspect {

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 0.3;
    @override
    double fraymotifWeight = 0.3;
    @override
    double companionWeight = 1.00; //manipulate others

    @override
    List<String> associatedScenes = <String>[
        "[Colliding Threads]:___ N4IgdghgtgpiBcIDaBhA9gGwwSwCbbAHMACAFQAsAnGCXAZwF0QAaEAMwwgDc1LSYAHgBcEIADwAjAHypMOfETJUa9BmID00gDphJlKTooxiAZRQBRAHLmA+gHkA6tYBKNywEEAsueLY6xCAB3CGpiNDZiIXJjUndnAHFzUjcvWztXD28TAHJ-XBg6IQIATwA6JRhi4igIMGwABwBXTiFjGC4YSmKoghIoyuIAY1riQOwesEjo7EpierRAzt9J3nzZoTRqiABrYx68gqKwKohiaggcITKdPSlblhAhEMIYITswOEQhSka4Vm-sIQXpR0GB8EU0GA6AAZbBcXqiJDALQgbBQeaUJ5gIQOVYo+AogBi1GMDmwWBRzBRljspHxKLYFzoMEpKIAas4AJImADS7np7CZLJYKMgsAFnmKJieQk5dHi51afHItTZF1+rNR6N4WNl2IFAEYAMwogC+zGIyK1GN1uMouAFAAUMI1BtsyGhdmB4DZfcRLAAWTmEXCEciEISEerYABCg057j5EnclEIAE1ApY0+4EwBHdwATgwACt4ih3AARACKhBjUB55ncEkIVfMAFYA4F3DB3NDCNg7CZ4gJ3IE7BmAEzd0gxgTmDAoFCECt2QYoKCBNMx6FsNCcrfkdxQdxH8ZoOhGkxeNBCXM8wIAWlIhHiBsI7gAEs4UDy0O4YwADBAAAcgTJnYuaeEIuAANQfluxTuI6VbuIQYAAFrbA+dAAFIBo6kAmJ4xYoOQoYxvm5h-tsy58pYnLkCgliEiYdBcB+hAAR+7acigYAmBAsSYO4ACqdgAF6EMUjQSCgLoiVelbwe4XBQFWAZCFw6F2NC5Axo0RDiTAOFph+6FpiYMYweYJgAQIMEwCYOG5uhGFcBgzhtgI2lVnQKAGhgJhppYEAxoS7gGg+bAOBWxaDABGAAOxXrgvaUGudC5rm8S3gAbDBUAxvEMEGuhRqEhWKAiRgFbuMFxZXjG2Clp49RgJ4AAaE4BlwRowYQOExmmjoTgB2DkB+imajSdIIAyQqahy3J8gK3waiK4DQMKBIgB+EB0CYgwwB8mpojatR6kIAoAWaFpWmdOoXXaDpzSAljqPyG0zQKjIYMyi1cryn07b9-0bWK20onK7g4B0p3apiF2cvqr03SA5qWiiD2I9iz0Cu9n1Um9tI-QtG1LUDpN-cKRMQwKcrOLUuBoFA8PndiyNXa9bZoxj90I7aeIIGAzQYET32vaDNPsoDK2S2TtNbRKxR2NGdSQnYbCkM8rxygqNBKhQqrqtL1qPRzKM7Q+ba3ZjZs4ziQs7QT00k-L1MA8twMomtpt069etoLgpDYJ0bPm5d122-z7OO-a+Mfa7s07b7nuU+7YOK+KAfykHIdhxt2O6pzUfo3dWMC09TvUonX1uyDCsy17VOZ6KSuvXtue4BWhwlOHDsl6jZpMP8lCAsCoLgtgkIwkziIjyAMBsGwMCDEIdCErwsLwkQiIxxHeOvc6rruqQnrHT6fqBsGobhpG0ZxgmSYpummbZnmhYlmWlY1nWDZNi2dsnZuy9n7IOYco5xyBCnDAGcc4FxLhXGuDcW4dx7gPEeE8UAzwXivJ4G8d5HzPlfO+L8P4-yARAmBdwEEoKwXgjGRCyFUIYSwrhfChFiKkXIpRaitF3D0UYsxVi7FOLcTbLxfigl3DCTEpJaSsl5KKQrMpVS6lNLaV0vpQyxlTLmUstZWy9lHLOVcuhdynlvJ2F8v5QKwVQrhUitFWK8UkopTShlLKOVcz5UKsVUq5VKrVVqvVRqzV4itXal1HqfUBpDRGmNCaU1wbtx2s4GAUA0AdHcGvaeYA05yxTj8U2RcLqWEaFACQBcdq83LvbQW8dXouxSdnHapFagvFVgQPJmtPCmwpoU+aHtC6V2xOUyp1SUTW2jhXWOh9na1yzpDEAngdgwHiHnUOlACne0FMMompSxkVKqdsoeZc7aHLji9HaxIYCknJBgTU-s2kqiII5GUOyW4lNGUIcZJyBQPmNABXmC8l4rzXhvLeTM6Dz3RkAA",
        "[Preferred Choice]:___ N4IgdghgtgpiBcIDaAFATjAZjNGAmABAMIAWA9gJYDGMAuiADQiYA2EAbmWgCowAeAFwQgAPACMAfKgzZcMQqUo1aIgPSSAOmHFoJW7iRgEAykQCiAOTMB9APIB1KwCVrFgIIBZMwQDWYMgDuAM4EAiQQAgwEaBQA5iQCBP4BUWFGYjBBiWEUYLGh4dmGBNxuTgDiZtyunja2Lu5exgRUEGAEeGQEFCECaBC5BTAUaARBPhQsLEEAdAQA0sm5+WERQybmVnaOZg21BAAOaGRiEGIsAJ6+ySEZWanFpRVVNV52e00dZJkEAFYArlkChEZlodBJwYwQAIIGhYjABLYwHBEH1-nAmH04vC0EQyGA8BQBBR8UEADIUdjLYRIYAaEAUKAHLgwsACexcPD0+D04xtIkXekMekWWzcbn0zAQaYwIX0gBqTgAksZ5m4JcxpUFZYx6ZBYBqPBdjDCBEqguUMBEcAY2vLpei5QymSy2ma2RqAIwAZnpAF8onTncy0Kz2ZyNSgWP8qD4SmQfDAwPBrKmCBYACxK2J4eKxASxA4UABCVCVbjVYjccIAmgELDW3OWAI5uACcLF+5SIbgAIgBFWLFqDzMxuMSxftmACsGYCbhgbjJsQotmM5T4bgCtjrACYF9xi3wzCwiERYr3bFQiFAAjXi2TMGQlfeSG4oG530SyEFvcZPGQAjNvMAQALTcLE5SerEbgABJOEQ8xkG4xYAAwQAAHAEVa2M2HgCHgADUsH3hcbgoP2bixGAABaPigUEABSGYoJAxgeL8pC5sWrZmMhPgXmqFhKiQRAWAAYsYQTsLBsSobBM5KkQYB8qUZAsG4ACqtgAF6xBc-xiEQ0aaf+fYkW47BQP2GYCOwNG2GSJDFv8eQ6TAjE1rBNE1sYxaEWYxioXwhEwMYjHNjRtHsCwTjTnwDn9kERCeiwxg1hYEDFuJbieqBmD2L2vxUKhLAAOz-ngS5oNeQTNs25RAQAbIRUDFuUhGejR3rib2RCaSwvZuBlvz-sWFBdh4BxgB4AAau4Zuw3qEbEjHFjWKC7qhFAkLBZlOqK4oIJKWo6sKICKiqaoamiZ16tAOo8iAsEQEExg0MiTqMiGYZKh6x0gKh-qBvS32umyHJoFyAMWKo6q6iAh0alKMpOpdqrw09KPak6+qPfS5puCwlJ3cG4PugIGpAyAAYEEGYOhm6kPQ09sPw+dSMA9jpPo9dXOnbjD0auaThtJ0UBfS6jNsn9lMA9O1O0-TUthsz3JgP8Uwc2KyMCwjvOYydqMI3jhoXLYRZgCSYC2Jg3CwvCZoWlaAg2uEYD2tGpMM79-1PaB07A3ToMq0zEYw3DB06-zxvnQbN1oI6JtCwDL3JWQTIsAi8hEywZJi-26JZEEks-W6stU0HytlxD4fwBrWsitHWN63HyoY7rsf3QaAP23CCJBBbuTW7bHgwOalowNaPDu57SfnT75d+-SAf+vQmIxLEOJ4gSRLW+SYs0uvIBYNgVACEE4lcBSVJ5DS1fk2rANRjGcbcAmSYpmmmbZrmJD5oWEsZYKzjmrLEOsDYmxuFbB2LsPYBxDhHGOCcU5ZzzkXMuVc65Nzbj3AeI8J4zwXivDeO8D4nwvmLG+D8X4BA-j-ABICIFwKQWgnBBCSEULoSwjhPCBFiKkXIpRaidEGLMVYhAdinESDcV4vxQSbhhKiQklJGSckFLTiUipCAakNLaT0gZIyJkzK9gslZGydkHJORcm5DyXkfJ+QCkFEKYUIpRRojFOKCVbBJRSmlDKWUcp5QKkVEq5VKrVVqvVRqzYWptQ6l1HqfUBpDRGmNCa5QpozXmotZaq11qbW2rtfayce5PScDAKAZB2CLnPtbNG7c+ZPVuqXcmFh-hQAyGgSuNMQZk2luGKGGo2aCzKfSUgbR4RDytviUePNGmG01F3fpYZ2mdJwBqQOvTg4rLDkMiO7Nu74xAB4CAiYXJBEFPrBZnccYI0XmyNZXSelKxDjXQZLN6RmD4AcHAFAkw0FGcciZeQwqmgaVdRZ3NWkDKeRsgGPo15QlPjAc+l9r5iyCEfGmQA",
        "[Song of Conviction]:___ N4IgdghgtgpiBcIDaBlA9mA5gAjQM2wGEMA3ASwGMAXMjAXRABoQ8AbCEtAJwBUYAPKghAAeAEYA+VBhz4ipSjXoiA9JIA6YcVwmaeACxjYUhAKIA5UwH0A8gHVLAJSvmAggFlT2fRC5gYAM4BgdhUhtgADmgA7jBcuARkYHhJZFRGFPpolCFUaNgUXDAQ6dgQYLgRNFAQrNh4XBAAnlBoNHiM2NJYCfJg5NS0YHSdeNyh4TyujgDipjwuHtY2zm6eKAB0mtoSO0wgVL6YMFQ2-sJUXACucMyXZJjHXMRgACZpQwEAMmTkWMJIYDqEBkKBRLiHMBUOzcV7A+DA9wQfigq5QbBfK4UADWwMYwPMNh48OBeFqwTxwIAao4AJIoADSrhJLHJMEp4Gg7IQiKaKEOVFpARmRRKcQM5SptRuHNB4MhgqhLIAjABmYEAX06QJBYO4CphXDhPJAAAVWFjsdgeGhsTAwPArE7sOYACy0zCvTD6TBUTARMgAIQotNcTLEri4mAAmtFzNHXKGAI6uACcrAAVjNCK4ACIARUwgagDNMrjEmHzpgArK7oq4YK4vpgyDYUDN+K5ojZYwAmBs8QP8UysQiETC5mwUQhQaLRwNfMa0+f6VxQVxrtJoAKqlAeNpJhnRAC0PEwM2VmFcAAlHIQGWhXIGAAwQAAc0QjNiT7iorwA1Ne85NK4pr5q4mBgAAWtix4BAAUq6pqQCg7gZoQ+heoGKamI+2ITky5i0vohDmAAYigAQkNemDPteNa0oQYAoBAUxoKwrgAKo2AAXpgTRXGIhAWpxe55kBrgkFA+aulQJBQTYXz6IGVxYDxMDwdG15QdGKCBv+pgoM+-D-jAKDwUmUHQSQrCONW-AKfmASEMqrAoNG5gQIGZGuMqx54HYuYZhQz6sAA7HurxNlw04BEmSYzFQSYAGz-lAgYzP+ypQaqZG5oQnGsLmrgeRme6BmQWbuBEYDuAAGr2rokKq-6YPBgbRqavbPmQ+jXmJHKEsSJpkqwFJMNSdKMsyJqXDKE2crALLXhAAQoBQ9rcviuryuUipUCyz6atqwJyvqe2GsaCIgOYKgzdtQ0sqN43bTS9JMk9bIcpAS0mkKrisL8W2nXqEJ7bSSomkdIBatgOpnWDUKXSyt33QSRKfWNwMgG902Yy9wI-dy11Co45SvGgUCyqDCoQwdJrVtDsPwzTF2wvCYBXKwrAPRjI1fQtuMffzWPfVyLLuE0NgBmAQw2HgPBHCcQoisU6S8D4YBSha2MI7TkPXdWx1wyDu1I+zJqo4NfPXc92NCzN11zdjRPLatxBgqwJwwK8ub2mQ6lgF85P5jcARUAE1Nm-th3Gyz0fIya6A9HILwDEoYDW8NTvXPbU3C7bAvba7JorQEZGNC0bRkAFaT6J5v3bXr4MG8CTMMHcXAPE8LzvBn3zkwCHcgDAeB4DA1Dl9wPx-JgALx+d5tGiy5qWtatr2o6zpuh6Xo+n6AbBqG4aRjGcYJsmaaZtmeaFsWpblpWNZ1g2TYtm2HZdj20T9jAg7DqOcck5pyznnIuNAy5AyrnXJuPIO49zuAPEeU855Lw3jvA+J8r4Pxfh-H+QCwFQLgUgjBOCiFkIQFQuhTCRYcJ4QIq4IiJFyKUWorRei1ZGLMVYq4diXFeL8UEsJK4okNy5gklJGSckFJKRUmpDSWkdJ6QMkZEyZkLJWSgjZOyDkbBORcm5DyXkfJ+QCkFEK4VIrRVivFRKKU0oZSyjlPKBUiolXMGVJ8lUZjVVqg1JqLU2odS6j1PqA0Fol2uo4GArQSCNkGBgDkDsWTOyjovKg5g0RiDiLHGGJ0drpMTtdK2ETxYmgwuUY40tUgYHlu4PO71HakiLqbdJmSoDZK4CyI2eSTYFMRtCC211k6yAIGnRQQwt5WBdO6T03pfT+iDCGXMDJAxhXcIGHiT5xxQQiJgaIUBzyukIHYVw-BMCEFdKwNAV5ny0ipO4VwZ4yCuFMPwZ8V4oCPJ4jUaIuYQKvHzIGECnEgUMi+fofKUEYDuBmPBTAj4vhQXzIQdwUAKABCuFQZK0Zqx1SmK4EMEBjxiGxPwdw0Yyy5mjNiJkPBlSWWfK4Kk-B4IUHbGRGASZzzRFpDxTilKyDRlzHYVUAR-xkUcOBV40RMBQFpKaTiPAoL6DnCgfQ7geJUk4vwEgMwpVoFzDwR5NhsSui0mRHgDI6qsATGIU56DAwwEIBmcwqVrwpncHYKgtq6S0n-FQCIyUIiMpmLwuw-40AZVNCQJMVwICuH0D6Uw2JoiOAiJi-Mjh6y0h4BQJoAQoKEpsM+KkyVMBkTfHVGwaBoDPmjI4YNuZsS3haDMGANgZhfGVBEQM8E0TQR8HYBkZExB1XMGFCgVwriql7O4QgNhXBkWfPmWkFArxi1+tdGYQMK7NFaO0JJ+cmmslFgtZuUJ2mdNyRqYeo9x6TzItPcmAQh4wyAA",
        "[Unyielding Will]:___ N4IgdghgtgpiBcIDaBVMBPAljANgE0zAHMACAdUxxwF0QAaEAMxwgDcB7AJwBUYAPAC4IQAHgBGAPlQZs+QqQpVqIgPSSAOmHGcJm7gAsYJAMoBhAKIA5cwH0A8mWsAlG5YCCAWXMkAIuxgAziQGRh6EeOjB+vJ0JIQAxpwwEAHyJAKGJBAA7hBJYIFBEGB4JLBgAhA4WWKUmALYQeyM6Zncbk4A4ubcrp62di7uXsYAdJraEpP0IJWcRDACdgXCApwArnAMa5hEC5ym7CX1mEcBADKYrPLCSMDqIJhQAA5clRVkXHgP8A8AYkkjIocA86A9LHZuD8HowqgEYKCHgA1JwASWMAGk3NCmHCEfQHpBYDiPOhjJUBKiAp0khABDAePpikiqptEY8Xm9ipSKjiAIwAZgeAF9YvcOa9OO8BJ9ON8EA8AAo4dbxADWwXYapgYHgNn1JEsABZUUQ8ER9EQBERnpgAELxVFuLFiNzzACa2Us7rcToAjm4AJw4ABWnVMbh8AEUiHaoBjzG4xEQo+YAKxG7JuGBuc5ETB2YydPhubJ2T0AJmz3DtfHMOFMpiIPjs8VMUGy7rt50Y7FRXf0bigbiH9XYAQFxk87AEfox2QAtNwiJ0+UQ3AAJJymDHsNx2gAMEAAHNlXXY-R4BHgANQbrvoNyKqNuIhgABaaoXAQAUkbFZAxgeCGpj6OadoBuYe5qs2WKWKi+imJYfzGAErAbkQB4bumqKmGAxgQO07A4G4KB2AAXkQ6DrGIpgqigU6RvebisFAUZGgIrDvnY5z6Ha6zEORMA-u6G7vu6xh2je5jGAefA3jAxg-n674fqwOBOGmfDcVGASmHyODGO6lgQHafxuHyC6MGQPghvEB44AA7FOeC5pwbYBH6fqdLOABsN5QHanQ3ny74Cn8PimCgOA+G4xkhlOdqYGGHjPGAHgABoVkarACjeRA-na7qKhWB6YPoG6MeyEJQgquI4PC7IouiWI4msbIEuA0D4r8IAbikxjxDq+JghKXIVKivJ1QeIpig8TyStKsryr1lgqNinU1TisINSNyJopiG29TtjWdUSPUPFSbg4Fce1jVK3KTQIOIzSAookOKC3jTKXw4mtG2jVtdUnXdzWHdteLsudOJUk4xR4OwUDsl9D0TVNvVpq972fZyqM-XKPxgOsVCA5CEO7U1B2tcDkNnd1JLoHYtpgKcYB2Iw3B5AslLUrS9KMsyrJ3Sj0pPTiaazR98240tv11f91VkzTFOdWD1O9e1d3Q3V-V6Yjzw4IsMB4H8mCcAEAjnPDUabBbATIzLj3ow8WNzfdssE3VAIwEClAgptSvHbTo1q0dMLB4S9N1Zz8yLOSdJUjSyT8wYgsqsLjto89dULoKB6u1L7vcstOLe77VCK7VGsbKDVNh-Vp2jdrvUx9z8c80ndIMqnYAsunDuLU72e9Xn+cirQ2ycLs+yHMcDRnFbJS3BPIAwIwjAwPEAgBH8XCXNcxC3Djg8fHLvXKqqGrcFqOp6gaxqmualrWraDpOi6bpEJ63q+m4AbBmGCM0ZYzxkTMmVMGYsw5jzAWIsJYyyVmrLWesjZmytnbJ2bsvZ+x2kHMOUcAhxyTmnLOecS4Vxrk3NuXc+4jynnPJea8d4HxPhfG+T834-wAQgEBECYFYyQWgrBNw8FELIVQuhTC2E0y4XwoRNwxFSIUSojROi6wGIjh8MxVi7FOLcV4vxQSwlRLiUktJWS8lFLKVUu+dSmltJ2F0vpQyxlTLmUstZWy9knIuTch5LyPk-T+UCsFUK4VIrRVivFRKyVOipXSllHKeUCpFRKmVCqVU6bEjqk4GAUB2CsBzFvVmlMWr101gPb6lh1hQDEAyF6ktj7fRLvLdaUMo69VAsUBYTNCCs3Zh4WuZTyaN2lifAQ1Tan1LqhLN6bsRbFzPv8QE5A-btOyZ0pkxBFIUlKeDZWoyi4VEmXUzg-IBRYxXmvDeW8d573hgEZeb0gA"
];
    
    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#3da35a"
        ..aspect_light = '#06FFC9'
        ..aspect_dark = '#04A885'
        ..shoe_light = '#6E0E2E'
        ..shoe_dark = '#4A0818'
        ..cloak_light = '#1D572E'
        ..cloak_mid = '#164524'
        ..cloak_dark = '#11371D'
        ..shirt_light = '#3DA35A'
        ..shirt_dark = '#2E7A43'
        ..pants_light = '#3B7E4F'
        ..pants_dark = '#265133';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Thought", "Rationality", "Decisions", "Consequences", "Choices", "Paths", "Trails", "Trials"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["NIPPER-CADET", "COIN-FLIPPER CONFIDANTE", "TWO-FACED BUCKAROO"]);


    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Man","Machine", "Magician", "Magistrate", "Mechanic", "Mediator", "Messenger"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Mind", "Modulation", "Shock", "Awe", "Coin", "Judgement", "Mind", "Decision", "Spark", "Path", "Trial", "Variations", "Thunder", "Logical", "Telekinetic", "Brainiac", "Hysteria", "Deciso", "Thesis", "Imagination", "Psycho", "Control", "Execution", "Bolt"]);


    @override
    String denizenSongTitle = "Fugue"; //a musical core that is altered and changed and interwoven with itself. Also, a mental state of confusion and lo

    @override
    String denizenSongDesc = " A fractured chord is prepared. It is the one Regret plays to make insomnia reign. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";


    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Mind', 'Athena', 'Forseti', 'Janus', 'Anubis', 'Maat', 'Seshat', 'Thoth', 'Jyglag', 'Peryite', 'Nomos', 'Lugus', 'Sithus', 'Dike', 'Epimetheus', 'Metis', 'Morpheus', 'Omoikane', 'Argus', 'Hermha', 'Morha', 'Sespille', 'Selcric', 'Tzeench']);


    @override
    List<String> symbolicMcguffins = ["mind","decisions", "consequences", "free will", "path", "neurons", "causality"];
    @override
    List<String> physicalMcguffins = ["mind","coin", "plan", "mask", "map", "brain", "circuit"];

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Puzzle Box",<ItemTrait>[ItemTraitFactory.WOOD, ItemTraitFactory.ASPECTAL, ItemTraitFactory.MAGICAL],shogunDesc: "13x13 Rubix Cube", abDesc: "Don't let Mind players fool you. It's not about smarts."))
            ..add(new Item("Tesla Coil",<ItemTrait>[ItemTraitFactory.ZAP, ItemTraitFactory.ASPECTAL,ItemTraitFactory.METAL],shogunDesc: "Lightning Weiner",abDesc:  "Mind is electric shit. I guess."))
            ..add(new Item("Coin",<ItemTrait>[ItemTraitFactory.METAL, ItemTraitFactory.ASPECTAL],shogunDesc: "Official Minted Shogun Coin Circa. 1764",abDesc:  "Luck doesn't even matter, so neither does this coin. Mind players are such hams."))
            ..add(new Item("Electronic Door",<ItemTrait>[ItemTraitFactory.METAL, ItemTraitFactory.ASPECTAL,ItemTraitFactory.ZAP, ItemTraitFactory.SMART],shogunDesc: "Star Wars Force Activated Door",abDesc:"I guess it has buttons and shit? I bet it leads somewhere weird."))
            ..add(new Item("Janus Bust",<ItemTrait>[ItemTraitFactory.UNCOMFORTABLE,ItemTraitFactory.BUST, ItemTraitFactory.STONE,ItemTraitFactory.CLASSY,ItemTraitFactory.ASPECTAL,ItemTraitFactory.LEGENDARY, ItemTraitFactory.ZAP],shogunDesc: "Bust of A Giant Phallic Asshole",abDesc:"So is the joke that Mind Players are two faced?"));
    }

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.FREE_WILL, 2.0, true),
        new AssociatedStat(Stats.MIN_LUCK, 1.0, true),
        new AssociatedStat(Stats.ALCHEMY, -2.0, true) //too many choices, freeze up
    ]);

    Mind(int id) :super(id, "Mind", isCanon: true);
    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.mind(s, p);
    }


    @override
    void initializeThemes() {

        /*
        new Quest(""),
                new Quest(""),
                new Quest(""),
                new DenizenFightQuest("","","")
         */
        addTheme(new Theme(<String>["Decisions","Choices", "Paths", "Passages", "Dead Ends","Trails", "Doors", "Possibilities", "Alternatives","Labrinths","Mazes"])
            ..addFeature(FeatureFactory.CONTEMPLATATIVEFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CLACKINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.STUDIOUSFEELING, Feature.LOW)

            ..addFeature(new DenizenQuestChain("Change the View", [
                new Quest("The ${Quest.PLAYER1} finds themselves trapped in a dark labyrinth. After travelling through for some time they have come to realize the walls change position when they leave an area. Although ${Quest.CONSORT}s are wandering around the maze they give riddle-like responses on how to escape. The ${Quest.PLAYER1} will need to find a way to solve the many hidden logic problems to escape the ever-changing paths. It's easy enough to leave when they want, but they want to WIN."),
                new Quest("The ${Quest.PLAYER1} returns to the labrinth to get help from one ${Quest.CONSORT} to try to understand the puzzle.It gave a slightly less confusing answer to look another way. The ${Quest.PLAYER1} decides to listen to all of the ${Quest.CONSORT}s answers however confusing that they are."),
                new Quest("With each answer written down, the ${Quest.PLAYER1} begins to piece together the parts of the answer. They will need all the mental prowess to crack this one, and finally reach the end of the Labrinth."),
                new DenizenFightQuest("After hours of putting different spins on each sentence, the ${Quest.PLAYER1} finally solves the riddle. But they aren’t quite done yet. A considerate ${Quest.CONSORT} directs the ${Quest.PLAYER1} to a small gap between two or the walls that leads to a puzzle room. The ${Quest.PLAYER1} spots a mirror on the far wall and presses the side of it. The mirror reflects light which the ${Quest.PLAYER1} uses to hit the right targets in the right order. After putting the pattern in, the mirror slid away and opened a view to the outside fields which let the ${Quest.PLAYER1} escape. Or that WOULD be what happens if the shitty ${Quest.DENIZEN} wasn't blocking their path.", "Okay. With the defeat of the ${Quest.DENIZEN}, NOW they finally escape from that labrinth.","Oh my fucking god, they better not have to redo that entire labrinth if they are ever back here.")
            ], new DenizenReward(), QuestChainFeature.playerIsSmartClass), Feature.HIGH)


            ..addFeature(new DenizenQuestChain("Pick a Door, any Door", [
                new Quest("The ${Quest.PLAYER1} boggles vacantly at an entire labrinth of doors. Whole walls are nothing but doors and their frames, with seemingly no rhyme or reason. A nearby ${Quest.CONSORT} explains that at the end of the Labrinth is the ${Quest.DENIZEN}. If the ${Quest.PLAYER1} wants to beat their land, they will have to figure out this Labrinth.  They are given a ball of yarn so they can easily resume their place in the Labrinth when they need to take breaks."),
                new Quest("Left. Right. Both choices look just as good as each other. A wrong choice could waste hours.  The ${Quest.PLAYER1} feels the weight on their shoulders, and then picks left.  Hours later, they encounter a brick wall. God DAMN it."),
                new Quest("Another set of two possible choices which seem to obviously have huge consequences. And yet....this time one of them just seems more....right? Like it's obvious that it's better. Huh.   Hours later, the ${Quest.PLAYER1} encounter another wall of doors, these ones with less feeling of weight. Hell yes! "),
                new DenizenFightQuest("The final door is passed. The ${Quest.DENIZEN} is revealed.  The choice here is an easy one, it is time to strife!","The bullshit labrinth is finally complete.","Oh GOD DAMN IT. Now the ${Quest.PLAYER1} has to walk all the way back here to restart the fight.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.HIGH);
        addTheme(new Theme(<String>["Consequences", "Results","Karma", "Justice","Responsibility", "Payback", "Vengence"])
            ..addFeature(FeatureFactory.DRAGONCONSORT, Feature.LOW)
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.STUDIOUSFEELING, Feature.LOW)
            ..addFeature(FeatureFactory.CONTEMPLATATIVEFEELING, Feature.LOW)
            ..addFeature(new DenizenQuestChain("Face the Music", [
                new Quest("The ${Quest.DENIZEN} has commited a staggering amount of crimes against the local ${Quest.CONSORT} population. The natural result of this is that karma itself is conspiring for their downfall. The ${Quest.PLAYER1} knows that Justice is on their side."),
                new Quest("The ${Quest.DENIZEN} may FEEL safe, all sequestered away in their shitty snake lair, but they aren't. The ${Quest.PLAYER1} convinces a group of underlings lead by a ${Quest.DENIZEN} minion that the ${Quest.DENIZEN} is a huge jerk who shouldn't be in charge of them. It's easy, because it's true. That's what happens when you are a huge jerk."),
                new Quest("Huh.  I WONDER what the consequences are of the ${Quest.DENIZEN} being stuck hiding in their shitty snake lair while the ${Quest.PLAYER1} is running a propoganda campaign against them?  Suddenly the ${Quest.DENIZEN} has run out of allies entirely."),
                new DenizenFightQuest("Karma is a bitch. The ${Quest.DENIZEN} has nowhere to run when the ${Quest.PLAYER1} comes for them. It's time to strife.","Justice is served.","Has Justice truly been perverted?")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            , Theme.HIGH);

        addTheme(new Theme(<String>["Thought","Logic","Connections","Neurons","Psychics","Subconsciousness","Intuition","Sparks", "Lightning", "Electricity"])
            ..addFeature(FeatureFactory.OZONESMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.TURTLECONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.STUDIOUSFEELING, Feature.HIGH)
            ..addFeature(new DenizenQuestChain("Make the Connections", [
                new Quest("The ${Quest.PLAYER1} stares at the puzzle blocks in a dungeon. One of them doesn't belong. But which? The Dog? The Bull? The Feather? The Cat? The ${Quest.PLAYER1} thinks, then makes the logical selection.  The Dungeon accepts it."),
                new Quest("Another dungeon. A cat. A swan. A robot. A virus. Huh. This one is harder. The ${Quest.PLAYER1} thinks about it for a while, and then goes with their intuition.  The Dungeon accepts it.  "),
                new Quest("In the newest dungeon, there are 4 geometric shapes on the puzzle blocks. One of them doesn't belong. The ${Quest.PLAYER1} thinks they understand. Their choice is accepted."),
                new DenizenFightQuest("It's the final door before facing the ${Quest.DENIZEN}. All four puzzles blocks are simply identical images of ${Quest.PHYSICALMCGUFFIN}. The ${Quest.PLAYER1} closes their eyes. They think about the previous puzzles, and the patterns that came out of their choices. They choose.  The door opens. It is time to strife ${Quest.DENIZEN}.","Finally. The ${Quest.PLAYER1} can stop solving bullshit 'logic' puzzles that keep straying into weird intuition mind reading bullshit.","Looks like the ${Quest.PLAYER1} will have to resolve some of those bullshit puzzles.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH); // end theme
    }

}
