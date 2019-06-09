import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Life extends Aspect {

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 0.01;
    @override
    double fraymotifWeight = 1.0;
    @override
    double companionWeight = 0.03;

    @override
    List<String> associatedScenes = <String>[
        "[Discordant Infusion]:___ N4IgdghgtgpiBcIDaARAlgZwMYHsBOAJhGAC4AEAkmAGYCuGaOYAuiADQjUA2EAbvgBUYADxIIQAHgBGAPlSZchYuSp0GTZhID0sgDphpeGfoEALGGQDKAYQCiAOVsB9APIB1RwCUn9gIIBZWzJTNBIMMhJzMgFfTwBxWwEfAOcXbz9AyzIAd1DTMggyKAgMBl4LDFo8AHMLHGoyLjRqCxgwGBqATwjTCHI8CEwYcMiYNDxgmAguSLIpbuIyNDAsPBgCNCkuC2gcWlI2OdpyXNnC3AwSeB6LGPjE5MDXdJTLAHJw3CgpPrIABxw2Q6S3CBAGy3WERwZDoMC4N3GSxWaxKkIIMBaYAwMAAdPpDDICewQCQIDUYCQXO1xCQ8LQ4BxaWhqrU8NYmBsSIwsQAZNC8ZbVcRIYC6EBoKAAvCk0hufAEMXwMX+CDCCW0KBkHm0LAAazFbDF9hcAkVYuo02xBrFADVPBRLABpXxmziWmDW8DQD0IZWdSykkgUDBxFEkDpmYg26b0z0SqUyoOkV0ARgAzGKAL6HUXiyX4RNywiugAKXB1uuiOF1bXgTnrZHsABYKNUCNVTNUSNU-mgAEJYCi+Z1SXw1ACa2Xs498Q4Ajr4AJxcABWcWsvhQAEVqn2oI7bL4pNUt7YAKxN7K+GC+HnVNAuSxxYS+bIuScAJmvAj7wlsXGsaxqhQFwsGsKBsnHPseWoHAKCg0xfCgXwkNCHAMDTSwAhwEg50dbIAFoBGqOIU2qXwAAlPGsR0cF8PsAAYIAADmyUcXDnfwSAIABqCioM6XwSy3XxqjAAAtXUCIwAApJsS0gSx-BXaxTHbPsF1sOjdWA517AoUxrHsAAxSwMF4CjqgYijzwoawwEsCAYhwLhfAAVRcAAvapOloKRrHLNysM3fjfF4KAtybEheHElweVMPt9mqTyYBk8cKPE8dLD7HjbEsBjhB4mBLBkudxIk3guE8M9hFircMGsFMuEscd7AgPtjN8FMCOoNwUBXLAGK4AB2LCCFvPAwIwOc5ziXCADYeKgPs4h4lNxLTYyUGsNyuBQXxWpXLC+zQNd-D+MB-AADQ-JteDTHjqhkvtxxLD8GLQUwKOCz1jVNX03S4K12Fte0nRdAHaVjEGvVgV0KJKSwsDaH1DTzBNlCoEhXQYrMczFeMC2UIsFQB+wtAhtG-tdC0gdR0GHWdGn3U9SA4YB4NfCaco43zaVMeTAHcZAbMyFzQn+dleVXXJymjRNZm6c9O1GYhpVAeBtG2Z9dXg08YgCBwKBeYx0gsddM9hdF8W+cLaWEDAWguC4KmFYB2nNYZ8HFc92Gdb9FxezAbkXGoAQyVqIMQzDCNejAaNy3p9GibNwX1bPPGxYJ23ift9XbGEP4OjQNpkd+t31Y9pOVe992WZh7XXXD8kSADPpg1DKZwzwSN45jJOJcTc2hczm3TZIEmZYp8v-sr+u0ZrpnIbpJPG45kMcAIAQS7wE2U6TbGR5F-Hk8lie87FCiphmUwZ9dKHq7Bpe56VhvvSbiOKTbqPO76WOo37nvM+w91bpgYlbE+g9c7FgBiWQEHQ7511fgvJ+atzTzzFGvdWzdI7fw7jHHuccE7QzRlA1Oh9QFpnAVbVgjI8DMlZOyMAnJuQYB5AbYUtCQAYhaFgMIxl8B8gFGAIUiARTZ3HpPWB5Y9RVhrGAOsDZmytnbJ2bsvYBxDhHGOaok5pyzl8AuZca4Nzbl3PuQ8x5TwXivDeO8D4nwvjfJ+b8v5-yAWAqBcCkFoKwXgn2RCyFUIkHQphbCuF8JERImRSi1FaL0SYqxdinFuJ8QEkJESYlJLSTkgpCASkVJqV3JpbSulfD6UMiZMyFkrI2TPHZByTlfAuXcl5HyfkAq0CCihFAoVwqRWirFeKiUREpTShlLKOU8oFSKiVMqFUqo1Tqg1JqLU2odS6j1PqA0hqjV8ONHkk1rDTVmgtJaK01obS2jtPaB17BHXoqdOI51Lo3Tug9J6L03ofS+j9N+7N1aeBgFAHA5RfB8O5MrVB98V5AMTPYDUUgEFH2thI-eUj1ZX2mJEVm78AaqWILUb+ULVY+wHjnUgCLvjIsodQ0eaKz4YrFHAoEu9-n+xAASkRxVAwktri-X2ZCSBUqRWy9WBEwHgKzFwnhMA+EYAEXgdhzCMCcJFkAA",
        "[Mending Touch]:___ N4IgdghgtgpiBcIDaBZGYAmBLMBzABACoD2ArgMYAWAuiADQgBmANhAG7EBOhMAHgC4IQAHgBGAPlTpseImSrVhAegkAdMGM7j1hSjHwBlAMIBRAHImA+gHkA6hYBKlswEEUJ-FgDO+flk4wGPjEjPgQzMy+eviipLg+EJj4uMxY-FQwXnT4XsRRMACevjAQVPlELg4A4iaEzm5W1k6u7gZh+ADuEEUh+IxYvDgE-JTeMZzEANboOZleWMRgAHTqmuJr9CD8EJy4MPzWYHCI-JykcAynWLh7nEaL2H6LXgAyWGxDQkjAqiBYUAAHLjbMD8WxcDC-eC-AyJNIFX50X5mayEKG-RjhLwwRG-ABqDgAkgYANIudFMLE4+i-SCwCkoAoGbb8QleKoBCD8GDcSiJPHhc64v6A4GJVmgikARgAzL8AL7ZH4ioGcEFgiEUgAKzAokzk0zA8EsJvwZgALITcBhcJRcPxcACsAAhciElxk0QuXYATQ6Zh9LndAEcXABOZgAKyqRhcABEAIq4Z1QEkmFyiXAJkwAVnNHRcMBcL1wWGsBiqvBcHWsfoATIXCM7eCZmEYjLg49ZyEYoB0fc6XoxiISB5QXFAXBO0sQvDKDG5iPxgySOgBaQi4KpS3AuAASDiMJOILmdAAYIAAODpe6zBlD8DAAaj3A4KLi1CZcuDAAC1JmuXgAFLmlqkAGCgkZGJQNrOqGJgnpMnZkmYhKUEYZgAGIGF4bB7rgZ57rmhJGGAsKEC4xDMC4ACq1gAF64AUpCiEYuo0Qu8avi4bBQAm5r8Gwv7WC8lDOqQeD0TAQE+nuv4+gYzpPiYBhnrwT4wAYQHBr+f5sMwDg5rwwkJl4RhSswBg+mYEDOphLhSmujC2HGkbkGezAAOwLhgxacD2XjBsGVTLgAbE+UDOlUT5Sr+MqYXGRg0cwcYuNZkYLs6WDRigAJgCgAAadbmmwMpPrgQHOj6Wp1meWCUHunHCiiaIIBiVLCgSxJkhSpxCjS4DQNS0IgHuEBeAY5DoNSSIqmKoKEpKbUgGeCpKr8-yquq4KcJCy1mEo5IDS1FKYsw2KdUSpJHSNZ0XQNdLDb8bIuKkbAzRtopquKi38BSq0gIq+DKpt80artFIHUds0nctd0fSAXXXadHUPUNFJsg4iQYMQUDCqD30LUtI05gDQMg1922aggYCkBEMOoij50I0jPVw6js2PQyBTWE6YALGA1iMIQOx7Ky7KctyvL8oKCME+qv0Ujma3A59W3ijte0jSYvAAjyWDoFNzWM+zzOXd1N3tWbaP0stIu7PszJcmyHIlFLugy7qcuUz9xO-GT61zYT4Na8ih3G61t0c-iV1syNfUI1zy1jWZuMAsw+yBK9zAvNjCbnF4-BePjPtE39y0B6rQdUxDy2YQMhhzALxqmhaVo2naDpOq6hJZYO+67rgKDEB0KChTmCZ7l4HRfhA6YoB0zpeO6MpJkBi80T6Z4uAVzomEBuBGLwfY1JRnbMM6LiMAmcbvhgeLpswKBuu2Li2DRJg+iSlAkswNG9zKXelAZRulEFUF4Dgh7uGdFuFAo4tS4F4A4Lw3p0KcFChgHMvEOiRmsC4HM-BeDsiqAUEwN5eAJi6CYGioUqiYUvKQfCOtTxniqC4IwwYfQvFwalFw1hIy4EgSwL8YBgwOB-lqYgCYpRYBzKQJBkZeAoASqFQkCYIAoBcDZZgJgTB1kvFUQkeJrBSkIZhZgiCvAkmdAYPEohJHEC4VUWw1jfy2EoCgHMu4jAQBbJmJ8HQcyfwKE+D+dZyB+gMLYJMUAZT5lEIOOsYAqij3omAOMkx+AFEoE+HMHR6KXl4C8LwiiSxuCwFgM8NEClgCnHWFB8ZiC4Ews6BMogSQoD3LwXAZhKAGAcJGF4Rg9wdGGbGOMdVbQAjjA4EwWAv5oR9CAlAlYTDuh2O6ICMl4xRLUZQF45BLx4hAlUCqhJfyEhMACUgzoOh4koi8b+KBrBVAwJGH0zAtRiSAlONKajnSMBorsAoe4Ex1j3EfEwKBfwmHIJGPcZ4wAmFwD6Bw5ojm5mYJMcgf8klnilFUGiQEwBeE4NEly-hUwkkjGuVSSY8QkifFUNIkYsDBhorgd+PoYA0VIMQAqHRmB4mDF4C8WLQprlhWuYxkxaKhWYGeNgNFbDMDALYCMUBOBQB5vRF4CZKAJkYKmIe3gaLkEPl4AqAIwyMH4PRN0DgtIOB9FUcgtgsBSnNIwTC-AZSkBeGYSMQFiCEF4CSQg9jMLWBGQ4XhLhJguvNHWMwBZrCEjgeQKAv5KBVE0XkmieIwwymuM6TRcYfRASicWRYIE2DkHomwTCwktSkDXHGFAuBOCMEmGwmiHYOgkmDOaICRgUBanNN+JpuF6I5jxHiSMUAMBQDPOQHMBgTAFR9P-YgYYpj4LjMwBMhIBJeCvBABwuNKDEEHU+S8QyUDmholOEwogoDWDJKO+MKAoDmjAM6GAeJzQyiOKlNcKZSCkX4KFL8EdepnBZrHS2lJrac3Rsncak1pol3VmXf6KsKY4ZDlCWm9NkQm3jvB82yNTb3VQ7bEaBgm6LD3CUZgIxXZch5B7MA2GwaK2WnWUKZ4ya0EuJwa4tx7iYDSALV42MviiZADARgjAYDkCLphLgbwPh4C+ARsGmttS6nIPqEghoW6WDNJaa0tp7SOhdG6D0GZvQov9IGEM4YowxnjEmFMaYMxZlzPmQsxZSzlkrNWWsHQGwwCbC2NsHYuw9j7AOIcI4xwTinFAGcc4FzD2XKuDcW4dz7kPMeFhV4bx8PvI+F8b4Pxfh-P+QCIEwIQAglBGCyZ4KIWQlotCGFsK4XwoRYipFyKUWonRRizFWLsU4nGbivF+KCWEqJcSklpKyXkopZSql1KaW0rpX8+lDLGWsKZcyllrK2Xso5Zyrl3JeR8n5AKQUQrBnCpFaKsV4qJWSqldKmVsq5ryoVYqpVyqVWqrVeqjUpzCiTiNBwMAoDEHei4dTAsqNx1+AnXjwczCkCgKIHkeHAaB3lhramI0oaI7QyNaCiQ9i8xwALIWaAcdIfhgT9UROSdk+WsrCnVcqegkM3XBujGvDzEWBZqz7dbNdwc73F0LwB7fmHqPcek9p6z3novZeLhV4VQ3lvHee8D5HxPumJpB7L7X1vi4e+j9n4kVjO-T+39f7-2dIA50wDQHgMgSgaBsD4GIOQagow6DMHYNwfgwhxDSHkMoXPGhdCGFMKrOeNhHCuE8KnPwwRuBhEuFEeIkkkjpGyPkQMpRKi1EaK0eEXR+jDHGNMbwcxljrG2PscQRxLxnGuPcZ47xviX24ACUEn0ISwkRI6FEmJcSbyJOSak9JmTsm5PyYU4ppTdwoAqVUmpdSGlxiaS0tpHSuk9L6QMoZIyxnxkmZQaZsz5kkkWcs1Z6zOCbLbJxi7L6oHJHInJnIXJXI3J3IPJPIvJvIfJfLOg-JTg+j-KArAqgrgqQrQqwrwqIrIqorooPw5hYo4o0R4oEpEokpkoJgUpaokjUq0pnj0qMrMr8Csrsqcqbw8p8oCpCoipiqTASpSoypyoKpKoqpqoapao6p6oGpGokgmpeBmoWpWo2p2oOpOoupuoepeo+p+oBpBohphoRpahRoxpxoJpVBJopp8LpqEiZrZq5r4IdAFpFolploVpVovA1olT1qNrNqtrtqdrdq9r9qDrDqjrjqTrxBsAzpzoLpLorprobpbqEg7p7o5gHpHonpnoXpQBXo3p3qjqPrPqvrvrsJlrfq-r-qAbAYwCgbgaQbQbQy0gM6-DMoY5Y6LBc5My0Zqxgz86k6cDk7yiKbKaqbqZeCaacC5yYBeAKaAxAA",
        "[Vital Siphon]:___ N4IgdghgtgpiBcIDaA1AlgFwgGwAQGU0AHACwHswBdEAGhADNsIA3MgJwBUYAPDBEADwAjAHypMOAsXJUBAelEAdMMLYjlHEjAIBhAKIA5PQH0A8gHUjAJWMGAggFk9uNFCIQAxhgDOuDFtwOOysAcT0OW0cTUxt7J3xcAHdMElwIXCEYaFwyelxsNHptGDAYNgBzAE8-EggMXCIAV2xsXyIyRLK0sAATXC0cf1x6NjIoGu0g0PDIpzNYqISIXtxvEp7fTD8yCd1DaMs9BacAOmVVEQvaECwKmAxTUv4MNka4Ohe0cvKynQoezBoCjeAAyaGYaDA5X4SGAihArnabCwYAw5nYPXh8HhDjIQjQBQwlXhNHhBlMHCx8PoODWJPhKCsAEl8ABpOxUhi0mD08DQHkIHGVfBYDBM7whNhZDBlTTLFA4N68xHsFFi1GcgCMAGZ4QBfGi4OEItyq5ZojGcgAK2EaHgA1oEyPaSvBjO7cAYACxM8o9cokcoYcpENAAIQ8TLs7KEdgqAE1EgZ43YowBHOwATmwACsQjo7AARACK5TDUFZejsQnKxb0AFYvYk7DA7CDymhTPgQtw7IlTImAEwtjhh7h6bA6HTlQumDw6KCJeNhkH0MhM5ckOxQOzbzBkbza-COMgYNOsxIAWg45RCmvKdgAElYdKyyHYwwAGCAADkSsdMNMHAwHoAGpH2XSo7CtYs7HKMAAC17UvbwACkvStSB8AcHMdBIf0wwzPR33tGd2QMJkSB0AwADF8G8ZhH3KT9HwbJkdDAfAICCMhsDsABVUwAC8qkaIQdFtfjjyLCC7GYKBiy9DBmAQ0wQRIMNGihISYFQ+NHwQ+N8DDUC9HwT9uFAmB8FQtMEMQ5hsCsetuFU4tvB0TVsHweMDAgMMaLsTVL3ocxCxzDxP2wAB2Y8ejbNh528NM0xCM8ADZQKgMMQlAzUEO1GjCx0fjsELOxfJzY8wzQPMHCIMAHAADUHL1mG1UDylQsN4ytQdPzQEhH2k3lyUpQUuVaAVSRARkWXZTkXiVWh4UgWBOUfCBvHwDwSmm+EVWRc0mQ1CbP31Q1jUOtV0TYTEJoMOQORWkAxs5Gkpt5Oa2We7FJrpF61oFP7xTsApmH2k0kTVE6ME5c6QANI0DtNI7UVu+6-se56ZreiaPoBmbvoW-HuV5IHOXFKxlh6MZlVRmHTr++sEaRq6GfNDGsTAZpsFxilFteSHid+6kycB-lOQcSpTFDMAgTAUx6A4CA7jFCUpTqWVajABVbUh67jqZ+FL3rC7kahs10ctB6ntGgXSc+l6RcF5aZopibNo8sYiGwe4YB6QsSjQHSwBBGnizebwfHp6Gjbhs7zfZuPrbu60OjKe3xr+gnheZH73vF93JYmlW1ZFOpxUlaVtflRUDY51FYa1bVWculGU4tNOJr0bgiDKNASl2rPC6don85JnOi9Wku-rLn4MAr9Xq61zgdb1t2O6t9UE7+1nqA+Ngvh+Ng-l6QFgXD3oYQPkAYHoIovG8Gj2DBCEoRhZPt65iabTtR0ODOldO6YwnofR+gDEGEM4ZIzRmrHGcoiZkypjsBmbMeYCwljLBWKsNY6yNmbK2dsnZuy9n7EOEcY4JxThnHOBcS4Vxrg3GGLcO49wYAPEeE8Z4LzXlvPeJ8L43wfm-H+ACQEQLgUgtBWC8EkIoXQphCA2FcL4TLEREiZE7AUSorReijFmKsXrOxTi3E7C8QEsJUS4lJLSULLJeSillKqXUppbSul9KGWMqZcyllrK2XsghRyzlXKmHcp5byvl-KBWCqFcKkUYpxQSklFKaU0yZWyrlfKhViqlXKpVaqtUQj1Uai1NqHUuo9T6gNIaI0JbrQmlYGAUAyAQzsF4BWX0J6ixuELWO28DCNCgJkNg8Mk5bzRl3TGZI7b1OBvCPCywfiy0hArJWDg87zR6bnfpkzBnDMzhNU24zLaTJ-n9R8WRsD+HJrPBZOsfhLy6Vs0ehMJlqn2SMzkl4dRtwtobVO0yQBWgzqMuZnJFlQmsqKZ5BdHZvNOR8oZXyjk6hOQCqZG0rk3PBRNSFPxpZPOdt015DdO6fMOX9X56LG6Yt-qC25DS-r4pgISmFxKXnwrJQM5FlL4RosRrfe+j8fAvzYFfDYN9EZAA",
        "[Touch of Life]:___ N4IgdghgtgpiBcIDaAVA9gVwMYAsAEaAZngDICWhMAuiADQiEA2EAbmgE4owAeALgiAA8AIwB8qTLgLFylKoID0YgDpgR7UapQ4YeAMoBhAKIA5IwH0A8gHUzAJXMmAggFkjeZgE8AznhwQwABNfDAAHNDA8Xh08FCc7AHEjFEdXC0sHZzc9PADAvABzdgDeX2iYKDxvNFhpKJ0ydgIWGHYmNAB3MjACjwoYADpVdVERuhBeCHYCmF5LMDhEXnYMOHplsgKZ9gMIwLJeMgjvchZugoEkYGUQMihw9kmwXmsOQJv4G5c0YTJGA88N1oNxMlhQHxuhAgjG8MCBNwAanYAJJ6ADSTghDGhsPh4GgcIQX08ekmvGR3gS7BgEF4rW0AQR0NWeLuDye5OeWIAjABmG4AX1oeGut3uHA5r3Y7yJIAACoxsABrWJoJUwMDwczavAmAAsyIKgQKOAKvAKoTIACEsMinBjhE5pgBNDomZ1OO0ARycAE5GAArBIGJwAEQAigUrVA0UYnMICuGjABWPUdJwwJwkApkSx6BLcJwdSyugBMGZQVu4RkYBgMBVDliwBigHWdVpIhDQyPbOCcUCc-YOaG8vL0rjQvC9aI6AFoUAUEtyCk4ABJ2AxotBOK0ABggAA4Oo7LF6XLxAgBqVftzxOOXhpwFMAALSVs+8ACk9XLIHoXAGBg4MaVo+kY25Kg2GImMiOAGCYABiejeCwq4FLuq4psiBhgHoEBxGgjBOAAqpYABeBSeBgwgGIqxHjmGN5OCwUDhnqvAsC+lgkDgVoYD0ZEwJ+zqri+zp6Fal5GHou7cJeMB6J+Xovq+LCMHYybcFx4beAY3KMHozomBAVoIU43KzoQ1ihgGWC7owADs46BFm7DNt4XpegkU4AGyXlAVoJJe3IvryCGhgYxGMKGThGQG45WmQQYuKEYAuAAGqWeosLyl4FJ+VrOnKpa7mQOCrgxeKguCspQjChLAiASKohiWLLCydA3JAsBYquEDeHoWAag1NxshKJTIlysq7oKwqimNjwlFKMqfCAJgKJinVrWCWJ1biW3Neim2rXtI34j1soUk4-wtKy4qLc8k28FiM0gEKIqjfdkpvFi62bY11W7TiZ2Ha1tXA3i3WEqtFJ2HkNR3eyE1Tatyave981fUtP0IGAGCMIwAM7eD9V4qDx2QhDW1Q1iLieJYlpgEcYCWIQKBTDM5KUtStL0v4YBMoqZ0LRyT1Ysms0fWKSPPMtv0bVVxMnVTjXk21KxnTTsp9bpNShIwswwIECGNN4vAkHk4arGb3iI+Nj0ozc6NzZ9MsvDjq2rjSjDRIrNWre1IMokdQOk9TBJYuz0yzKStIUlSNJ0pw-OCx1jUi8jz2ynyu7ozQ6zsJs2y7EEBzMyceSXPnIAwIQlBYKUCEcKc5yXJjbty7KCrKqq6qatq5i6gaRommaFrWra9rxk6BSuu6npOD6-pBiGEZRjGcYJkmqbppm2a5vmhbFmWFZVjWdYNk2LZth2XY9lafYDkOvAjmOE5TjO86Lsua4bluO77iPCeM8F5ry3nvI+Z8b4Pzfl-BAf8gFgJRjAhBKCTgYJwUQshVC6FMLJmwrhfCThCIkXIpRaitEMD0UHKGJiLE2IcS4jxPiAkhIiTEhJKSMk5IKSUipF8akNJaUsDpPSBkjImTMhZKyNk7KOWcq5dynlvJej8gFIKIUwoRSijFOKCUkoJBSmlTK2Vcr5UKsVUq5VKrhwuqtOwFQ0AtCcA3ZmZNg5gwDhrO2D1eAmAwFAYQrQXqS3bvbd20p5b-S6hHWUQEAgzAZt0ZmrMXBBxahTbEYd05Y2eP4wJwTZQSzei7aW4TO6e29r7Wx0MbjxJ6ApMk7iMmh32jkt2+SgnsB5LyPO4xa710bs3PI3gq5vSAA"
];
    
    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#494132"
        ..aspect_light = '#76C34E'
        ..aspect_dark = '#4F8234'
        ..shoe_light = '#00164F'
        ..shoe_dark = '#00071A'
        ..cloak_light = '#605542'
        ..cloak_mid = '#494132'
        ..cloak_dark = '#2D271E'
        ..shirt_light = '#CCC4B5'
        ..shirt_dark = '#A89F8D'
        ..pants_light = '#A29989'
        ..pants_dark = '#918673';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Dew", "Spring", "Beginnings", "Vitality", "Jungles", "Swamps", "Gardens", "Summer", "Chlorophyll", "Moss", "Rot", "Mold"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["BRUISE BUSTER", "LODESTAR LIFER", "BREACHES HEALER"]);


    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Leader", "Lecturer", "Liaison", "Loyalist", "Lyricist"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Life", "Pastoral", "Green", "Relief", "Healing", "Plant", "Vitality", "Growing", "Garden", "Multiplying", "Rising", "Survival", "Phoenix", "Respawn", "Mangrit", "Animato", "Gaia", "Increasing", "Overgrowth", "Jungle", "Harvest", "Lazarus"]);


    @override
    String denizenSongTitle = "Lament"; //passionate expression of grief. so much life has been lost to SBURB.;

    @override
    String denizenSongDesc = " A plucked note echos in the stillness. It is the one Desire plays to summon it's audience. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";

    @override
    List<String> symbolicMcguffins = ["life","health", "growth", "strength","tree", "forest"];
    @override
    List<String> physicalMcguffins = ["life","plant", "fertilizer", "food","flower", "beast", "fruit", "baby", "puppy", "candy"];


    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Life', 'Demeter', 'Pan', 'Nephthys', 'Ceres', 'Isis', 'Hemera', 'Andhrmnir', 'Agathodaemon', 'Eir', 'Baldur', 'Prometheus', 'Adonis', 'Geb', 'Panacea', 'Aborof', 'Nurgel', 'Adam']);

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Creeping Vine",<ItemTrait>[ItemTraitFactory.WOOD, ItemTraitFactory.ASPECTAL,ItemTraitFactory.PLANT,ItemTraitFactory.SENTIENT],shogunDesc: "Sentient Plant Tentacles"))
            ..add(new Item("Lollipop",<ItemTrait>[ItemTraitFactory.CANDY, ItemTraitFactory.ASPECTAL,ItemTraitFactory.HEALING],shogunDesc: "Sentient Plant Tentacles"))
            ..add(new Item("Golem",<ItemTrait>[ItemTraitFactory.UNCOMFORTABLE,ItemTraitFactory.STONE, ItemTraitFactory.ASPECTAL,ItemTraitFactory.SENTIENT],shogunDesc: "Living Rock Man", abDesc: "I guess. It's LIKE a robot. Sort of. Just not a super computer."))
            ..add(new Item("Ectoplasm",<ItemTrait>[ItemTraitFactory.GHOSTLY, ItemTraitFactory.ASPECTAL,ItemTraitFactory.HEALING],shogunDesc: "Ghost [Censored]")) //thanks nana sprite
            ..add(new Item("Aqua Vitae",<ItemTrait>[ItemTraitFactory.GLASS, ItemTraitFactory.ASPECTAL,ItemTraitFactory.HEALING, ItemTraitFactory.LEGENDARY, ItemTraitFactory.MAGICAL],shogunDesc: "Tears of JR"))
            ..add(new Item("Homunculus",<ItemTrait>[ItemTraitFactory.FLESH, ItemTraitFactory.ASPECTAL,ItemTraitFactory.SENTIENT],shogunDesc: "False Man", abDesc: "Ugh. It's like a robot, but made of flesh. WHY WOULD YOU DO THIS."));
    }


    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.HEALTH, 2.0, true),
        new AssociatedStat(Stats.POWER, 1.0, true),
        new AssociatedStat(Stats.ALCHEMY, -2.0, true)
    ]);

    Life(int id) :super(id, "Life", isCanon: true);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.life(s, p);
    }


    @override
    void initializeThemes() {

        /*
        new Quest(""),
                new Quest(""),
                new Quest(""),
                new DenizenFightQuest("","","")
         */
        addTheme(new Theme(<String>["Forests","Chlorophyll", "Moss", "Trees", "Jungles", "Wood", "Tribes", "Timber", "Wilds", "Thickets", "Coppices", "Copses"])
            ..addFeature(FeatureFactory.NATURESMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.DRUMSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.WOLFCONSORT, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ZOOSMELL, Feature.LOW)
            ..addFeature(new DenizenQuestChain("Restore the Forest", [
                new Quest("The ${Quest.PLAYER1} finds a village of compliant ${Quest.CONSORT}s frantically destroying trees. If they stop, even for a moment, they know their village will be destroyed, along with any nearby trees. When the ${Quest.PLAYER1} tries to offer help they begin ${Quest.CONSORTSOUND}ing in panic. Don't upset ${Quest.DENIZEN}, they beg. It is only by complying that they are safe, and you will bring wrath upon everyone. "),
                new Quest("The ${Quest.PLAYER1} revisits the village compliant ${Quest.CONSORT}s, only to discover it's freshly destroyed. A weeping ${Quest.CONSORT} explains that they couldn't keep up their pace and had to rest, and that is when ${Quest.DENIZEN} attacked. Please. HELP them, he begs. The ${Quest.PLAYER1} agrees to go face ${Quest.DENIZEN}."),
                new DenizenFightQuest("In a nest built of thousands of splintered trees, the ${Quest.DENIZEN} waits. It is time to fight. ","The ${Quest.PLAYER1}'s power is greater. They survive, and help the ${Quest.CONSORT}s to survive as well.","The ${Quest.DENIZEN} is stronger. The strong survive. The weak perish.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.HIGH);
        addTheme(new Theme(<String>["Gardens", "Summer", "Growth","Dew", "Spring", "Beginnings", "Vitality","Strength","Fields","Farms" ])
            ..addFeature(FeatureFactory.NATURESMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.ZOOSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(new DenizenQuestChain("Distribute the Food", [
                new Quest("The ${Quest.PLAYER1} finds a lush garden, dutifully tended to by ${Quest.CONSORT}s. Unfortunately, the food is left to rot in piles, as Underling brigands block the road and prevent the produce from being distributed. The ${Quest.PLAYER1} agrees to help."),
                new Quest("The ${Quest.PLAYER1} sneaks along the main road and finds the Underling Brigands lying in wait. They are dispatched in short order, and the ${Quest.PLAYER1} heroically informs the ${Quest.CONSORT}s that they can once again begin shipping their food."),
                new Quest("The ${Quest.PLAYER1} follows the road to find a new village, fileld with hungry ${Quest.CONSORT}s. Apparently the food has been stolen by a ${Quest.DENIZEN} minion! Enraged, the ${Quest.PLAYER1} tracks down the minion and defeats it. They now know this will not be the end of it. They need to nip this in the bud. "),
                new DenizenFightQuest("The ${Quest.PLAYER1} approaches the ${Quest.DENIZEN}. It ends here.","The ${Quest.PLAYER1} was strong enough to win! The consorts will never have to worry about their food being destroyed senselessly again.","The tyranny of ${Quest.DENIZEN} continues.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            , Theme.HIGH);

        addTheme(new Theme(<String>["Decay","Locusts","Bogs","Blight","Fens","Rot","Death","Mold","Swamps","Thorns","Swarms","Famine", "Hunger", "Disease"])
            ..addFeature(FeatureFactory.ROTSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.SKELETONCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CROCODILECONSORT, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ALLIGATORCONSORT, Feature.MEDIUM)
            ..addFeature(new DenizenQuestChain("Protect the Farms", [
                new Quest("Drawn by wailing and ${Quest.CONSORTSOUND}ing, the ${Quest.PLAYER1} enters a rotting ${Quest.CONSORT} village. They are in the throes of a famine they explain. Locusts damage their fields and blight destroys the weakened remainder. They cannot feed everyone once winter comes if this continues.   The ${Quest.PLAYER1} vows to help."),
                new Quest("The ${Quest.PLAYER1} strifes countless swarms of locusts, but there seems to be no end to them. They finally track down a hive, guarded by several ${Quest.DENIZEN} minions. It is as easy as thinking to destroy everything, but the ${Quest.PLAYER1} is left uneasy. Why were the minions causing this on purpose?  "),
                new Quest("Although the locusts have thinned in numbers, the blight is as strong as ever. Even the most potent of alchemized fungicides seem to only keep back the blight for a day. At their wits end, the ${Quest.PLAYER1} stays in the fields overnight to discover that ${Quest.DENIZEN} minions are spreading a strange powder on the fields. Defeating them is a start, but clearly ${Quest.DENIZEN} is dedicated to causing famine. They must be dealt with. "),
                new DenizenFightQuest("The ${Quest.PLAYER1} faces the ${Quest.DENIZEN}. It will end here.","The ${Quest.PLAYER1} is strong enough to impose their will on the world. Famine will not trouble the ${Quest.CONSORT}s any longer.","The ${Quest.PLAYER1} was not strong enough. Can anything save the ${Quest.CONSORT}s before winter? ")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH); // end theme
    }
}
