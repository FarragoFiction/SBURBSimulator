import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Space extends Aspect {

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 0.5;
    @override
    double fraymotifWeight = 1.0;
    @override
    double companionWeight = 0.500;

    @override
    List<String> associatedScenes = <String>[
        "[Vast Croak's Echo]:___ N4IgdghgtgpiBcIDaA1CBnALgAgMICcB7CAawHJ1sBRAYwAtCBdEAGhADMAbCAN0PwAqMAB6YEIADwAjAHyoMOAsXKVaDRhID0sgDphp+GXoF0Y2AMq4qAOSoB9APIB1WwCU71gIIBZKtggA7hD4ACaUmKbYAp6uAOJUAh4+9g7uXr7m-tgADoQBMPjsAK6c2Oz4EACeUISYAJbsLNjyWHhEpBTU9ExNERA4IRUBlEW5YNgRZjDo6DBgNGaE7NhFYHU8BegQpTT4MP11hOOYhP7zDPjYczBQddPYdWAnE6Z1lzRF+HtPOYTodfUjgA6PQGGRg1ggTDBADmMEwDjAcEQmHwRTgbFRdRhcPwuCOIQBhzA6AAMutHjDxEhgDoQHUoLl8NCnk5+CE6fA6d5CFI6pwAZU6Sw6dYHAJOXT2NtZsK6ShXABJcwAaU8ko4MpgcvA0G1CG5lXM0MwivQsT2-QKJggYDQnHROoZTJZpqeGoAjABmOkAXyatPpjP4rrZoQ1AAUHTQSFFCCQ5vA7MnsNYACyKmEhGF0GGYGHZOoAIRois8aqknnwMIAmgFrDXPGWAI6eACcnAAVrFcJ4ACIARRhRagKqonikMIHVAArGmAp4YJ5STC6g5zLFhJ4Ag46wAmRcCIvCKicXC4GF9hw0XBQAI1ouk9iERUPuieKCeD8Av5e8w+WpmxVAIAFoBBhWIPRhTwAAlXFwFVCE8IsAAYIAADgCSsHGbbxMBCABqGCH0qTwIwHTwYTAAAtEgQPQAApNMI0gcxvE7XA6GzItWyoJCSEvNVrEVOhcGsAAxcx0B4GCYRQmDZ0VXAwHMCBokIThPAAVQcAAvGFKiKKRcAdLT-37YjPB4KABzTTAeGohxSToItVhhXSYAYmsYOomtzCLAiqHMFDhAImBzAY5tqJonhOFcGdhEcgd0FwD1OHMGtrAgItxM8D0QPYJw+07GgUM4AB2f8QmXfAb3QZtm1iTBmwANgIqAi1iAiPWor1xL7XAtM4PtPEyzt-yLOpu28bIwG8AANPc0x4L0CJhBiixrCM9xQuo6Bg8ydTFCUDU1ThZVYeUlVVdVTtRR1Lt1WANRgjBzAWJEnWDZlbTdTANRQv0AzpZ0Q1+sMOVO6xNFukUQGOjVpXO-U4YVZU1URrUdUgZ7TrNTwBQ2L6XV+xV3VOwGQH9bBA1Bn7WXZDVodh0VxUx5GdTRm72YuuGcf1LkQDNVxbRCQgoGJsGnjJ-7TpnSnqdp77Q0ZhAwBKTg4YR06kd5q70duwXdZRul+Y1bxKgcQs1iOBx2AEWF4TNC19kwa06Fte0HrhunXRljUZyBmmQeV8HVcF5mjrZnWscermMbutETaegW6WdwgQgEO58El+m-oBoOlZJhnw1OtBWiUDpVG6KOTsF+7k-jw2pVjvm9RejBxIqapagaJwAToLLcZ90PpfJwWFeYTF8GxXF8TAQlARJUlRepKeQBgdh2BgGhMHQcT+HJHhKWpIupcwCHI2jWMBHjRNkzsVMMyzHM8wLYtS3LCcq1retGxbdsXYez9iHCOMcE4pyznnIuZcq51ybm3LuAIB4YBHhPGeC8V4bx3gfE+F8b4PxfluCcdAf4ALNWAmBCCUFYLwUQshNCmFsK4XwkREiZEKJUVovRJiLEIBsQ4lxYcvF+KCU8MJUSEkpIyTkgpGcSkVJqU8BpbSekDJGRMkUMyX4+yWWsrZeyjlnKuTAO5Ty3lfL+UCsFUK4VIrRWorFeKiUHDJVSulTK2Vcr5UKsVUqFUqo1Tqg1JqrV2qdW6r1fqg1hqjWsONZCU1YgzTmotZaq11qbW2rtfah1Hpm1Oq4G4hANieF3sSTm10E71yTrnV01gihQCkAUAuVNgZBmLhfcOooYbY3bqdTito4RW0eMSO23hG5VObmdPWHTz4NKaS0uWhcQ6dMvmXBQbRlCdDUIQJMKZ0yZmzLmfMhYSyKh4lQK8nh5rIVGtONMMF0AXPwGUzgWkAjiSoEWTsnhcBei3EWQgrgUKPliPNIs45aLUWQt4GsQFsgBD7KREIA4iyVFylQZs8Lxx9hrKSUiKAFwOAIt4BiYABwoRrDZCAdBczNhgCBfs1hvAqhSgEVy5UUCKnwFANMNYqAoFyBAGshAqAQD3NkLSpJ5qkliF+GczUWpQAYn2QgbKWo1hnM2cSLV5pFE7GSRU2qQIdRas2CMe18BgFiDWTg4kyzoBhLgcwuU+wql3pq6wRZcBpnYMozwYBsjlTTNxFCPA+wjmop2IsWkWoqjqDQcRrz+yEAgiqNMnZ0K4G8OJAiyFYikmUegFqEYtKdgGhGQg1gtJUACC1Is7F5q4HQJ2dgXgBxQBQigCCuAZzoUVFARsA46jNhCA4SoI5Dg1l+aSNMngih1FwDwCifTcaC1iOsGAXcqg1HqOwSpBsebJ19r9BZzSc4Uz9OvTe29d770PqLdAa8qZAA",
        "[Escher's Perspective]:___ N4IgdghgtgpiBcIDaBRAzgYwBYwE4HI0ACABTzQAcYMAXASwDcYBdEAGhADMAbCBge1wAVGAA8aCEAB4ARgD5UmHAWJlclavSbMpAenkAdMLNxyjQnEQDKAYRQA5FAH0A8gHVHAJSf2AggFkUIlwYbhgINBhiCCIZcKgifk4iSggMGCIYMDwAcwBPIhoIXByYGhgAEyIIGkLLIV9PAHEUIR8A5xdvP0CrADoiCwy46CIsOhpiGhwoNkKIAGs6MBy6jIB3cIp+MDW8-BCiDABXXBCwGm4CrH5uCuXViDAqmlOwB6IJz4v+IhzinIyCClAZGExycHsEBFEplFzZSQ0XDHOAcJF0HKlXA2Hb3eg7NAAGUYD0kSGABhAdCg21wRQubkEFUp8EpADEQhk3HRuNxKWxKfYXEIWZTOBBuJF+ZSAGqeACSVgA0r5RVwJVL2JTILA1f48lYijR5WgmiEangLE8ZRKUdKqTTBPTjRc1QBGADMlIAvnMKQ7ac7GbhmQhKSRuMcMAtBvwFll4E4k0R7AAWeU5Co5LA5Gg5Ch0ABCGHlvhVMl8JQAmut7FXfKWAI6+ACc3AAVk0bL4ACIARRyhagSpQvhkOT7KAArKn1r4YL5CTk6C4rE1RL51i4awAmedCQuiFDcGw2HI9lwYGxQdZVwuEzj8eV3rC+KC+N8TfhoD1WAL8GhGyVdYAFohByJo3RyXwAAlPBsJV+F8QsAAYIAADnWCsXEbfwaAqABqGC7zyXwSD7XwcjAAAtBYQLQAApVMSEgKx-HbGwsCzQtmxQJCFnPFV7HlLAbHsNkrDQBgYJyFCYOneUbDAKwIAaW5fAAVRcAAvfJjhkGxIw0v9e2I3wGCgPtUxoBhqJcQksELY4Vm0mAGKrGDqKrKxCwIlArBQ0QCJgKwGMbaiaIYbhPCnUQ7L7NAbDdbgrCrewIELNlfDdEDODcHt2wwFDuAAdj-CpF1wK80EbRsmkAgA2AioELJoCLdaiPTZHsbA07ge18NL2z-Qs6E7fwKDAfwAA0d1TBgPQInIGMLKsSB3FC6CwGCTPtIURTDdVJRge05UVFU1SRO0tXAaATsOmCIisdJsntalAyeF0aDVFCfT9Sl3qdT7g1DVkQHsXRVRu-a1XFY7ToVZUobBuHNQFW7dUOk1fG4Rh7vRwG6U++VXUO36QF9Ih-UJoMmTVCGofRmHDtR-HZURi6WY1NmMfusGTU8J4Kn4KA3sdImLhJ77DqncnKep8XaZDFkwGOXkmeFS7kR5s6kdh7n7R1PnKX1FwC3eHYXE4IQATKE0zXCcphCwa1bR5mnidJsGQKnP6qYBxXgbpw7-H4GQeQmPI9s1w6rp1jnkbFA2bqNtUbdhGhDRqe3zSdq0puWd3A8lr3KTl-6AyBhlg7Bhno4OsG44R87E6OtHtTutVHsS3B+HWMAxY+kvpbB8v-criWaBB+nIfr-X4Zu3XOcb7XDc7h6IhxGkwnKCreUJIW+xRNBJkHquvp+v2FaHqea8pJoASBUo59j1fF4T+f295runqoDA6BkMcNA3JpjpUxgTYuF8yY+lYGiXAGIsQ4meBMOgBID7PDJLAkAMBOCcE0GgNkghiQMFJIgckAcb7T0OhGKMMYhBxgTEmJwKZ0yZmzLmfMRYSxljHJWHINY6wNl8M2NsnZuz9kHMOUc45JwzjnAuJcK41wbi3Lufch5jynnPJea8t57yPmfIWV875Pw0G-L+f8gFgJgQglBWC8FELITQphbCuF8JERImRCiVFaL0SYixCAbEOJcUHLxfiglfDCVEuJSS0lZLySnIpZSqlfDqS0rpPI+lDLHGMh+HsZkLJWRsnZByTkXJuQ8l5HyfkApBRCmFCK1EooxTii4BKSUUppQyllHKeUCpFVKuVSq1Var1UbE1FqbUOpdR6n1AaQ0RpjSaBNKas15qLWWqtdam1tq7RTuvMGngYBQH4EwXwtBUED3fi3LW10IE33sMcKAcRcCXwphXD21dlaHTrvszGYNOJPFKGbZYlyrb+HjjcrmC97nn0ec8vAaofZXwoefKhYMH4lCfjARMyY0wZizDmPMBZizyh7HQFAhYXCFm0o0LiGBfAoVLISRsr4GIQBQBeGw8ospsmOFWPsDEpwlUbPwHsO42RsgXAxKAO4Sr2A3IWTgpY17-PvnjKwf8AFAObnraFX9Pk0HhS8t53osE4LwbQAhRChZoEwRTIAA",
        "[Anuran Magnet]:___ N4IgdghgtgpiBcIDaBBMBXAThMACAshAOZgwAuAuiADQgBmANhAG4D2mAKjAB5kIgAeAEYA+VBmx5CJchQEB6UQB0wwzCJUcAFjFwBlAMIBRAHJGA+gHkA6mYBK5kynxHc6AM4x3uMjoCWmLjuAA4QAMa6wawA7jCY3n54EGRkMFDBZN5krEHoUFCsSbh0mKxEAHS4AJJkuNHsANbuAIS4AELotb66JWW4ft4MrKwNiUS4ELgMfikMurEBACaVAAqlQhBCDACedazoDIu4Qron7l05LKx+Rx5jPloDuIW6iRNg2773rN2Bvji4TAwIgHCCBCAMMI6KDbcoqNQiBE0EBkMFEciWUj8MiYdBwWg4vxEdGYAyFRYzPyFdwAGT8zDG-CQwCUID86XYqLAZGs7EWrPgrPwrCEfmmZG2rOorJMlg4AtZdAhnilrIAanYqnoANIoBX0ZUwVXgaBGhBC7Z6VFkKruADiQOScW0ODVELxxvZUUwXJt3P1AEYAMysgC+1FwLLZHJ9OB5fP1KwY6DCDVwHBGMDA8HMudwJgALFUiIsiFoiGQiME-G0wlUULqhChMEQAJrREytlD1gCOKAAnAwAFZ2gwoAAiAEUiG0oNqjCghERJ0YAKwF6IoGAoGlEPyWPR27goaKWdsAJi3HDa3CMDAMBiI48sYQMUGirbaNLorCqn60KBQCggEzKw7hBnozg-D22rRAAtBwRB2gGRAoAAEnYBjaqwKBtAADBAAAc0RNpYPb4GQiwANRoZ+2woCsk4oCQABaDRwe4ABSBYrJAej4EOBhaKWbR9kYOENE+uomFUWgGCYABiejuMwaFEHhaFrlUBhgHoEAcCgrAMCgACqlgAF5ENs6BCAYyYmZBE60SgzBQJOBZkMwLGWDSWgdGARDmTAnGtmhLGtnobRUUYeh4dwVEwHonE9ixYAscwDB2Ku3DeZO7gGAGDB6K2JgQG0CkoAGcF0NY45DmEeEMAA7JBiw7pgr7uD2PZ2mQPYAGxUVAbR2lRAYsUGCnjgYJkMOOKAlUOkFtH4I74MEYD4AAGueBbMEGVFEJxbStis554X4WhoY5xqyvK5oGgwKo0Oqmo6nqD04h6L0mrA+poRA7h6BEpCejGvpVP6D14WGEZRl6nJxrymD8g9JjyB90ogHd+pKk9ZpYxqWq6rjhrGpAf0PbaKDTMwBOsgjsbcpDZD6jDIDhpGDPg0jCZoxjt1yqT+PGkT73C89WMU2agogLadg4IsrBQGD3oQ1DsuruznPwzz3LI6jsvo5jMpCw9eOS69xMfbLX3079MusgD+XK8EcypIs45Zn4QVgDSiuTni5zuKriPMxrrLa3D3Nq7zKP6sbgv3bLFv22LJPm2TP3S-qtp6DADB0KHTN+qz0NhlQBKYESJJkmAFJkFSYC0orTKVyAMB0HQMBhJkCnsHSDIBUyuux-rfOy0mKZphmDRZjmeaFsWpblpW1a1vWjbNm2HZdr2A7DqOE7TrO86Lsua4bluO57geR4nme0SXjA163vej7Pq+76ft+v7-oBwEoCgXApBYUfVYIISQihdCmFsK4QIsRUi5FKI0TogxJirF2JcR4nxASQkRJiQklJFAMk5KKWUqpdSmlVzaV0vpQyxkzKWWsrZeyjlxzOVcu5Ty3lfL+UCsFUK4VIrRVivFRKyVUrpUytlXK+VCrFVKuVSq1Var1Uai1FAbUaQdQMF1HqfVBrDVGuNSa01ZrzUWstVadp1qbR2ntA6R0TpnQuldG62dTT6jsGkVgdMUC9ybqLN6Gdba4ntozX0Jg8gnEwGzWGXNoxj3jPHB6ClShEAXuYfMRYSxlgrFWGsdYVpoAHEQMIx47QAQUtwacRh3CETaGANoC4qjmWvO+cc+BFx2hMkQAw54AycSHOObY2omrnmiH4BoE4hwTjtNubiqFmAzPJl4h6dp6QwBqGkYJ1t9R22LlEmJcR4kc3bp3buvd3D90wP7eu7g24cyAA",
        "[Greenskin Magitek]:___ N4IgdghgtgpiBcIDaBxATjGYDOBrAlmAAQCyEA5vgC4y4C6IANCAGYA2EAbgPZoAqMAB5UEIADwAjAHyoMWPIVIVqtOmID00gDphJaKTr4ALGEQDKAYQCiAOSsB9APIB1OwCV7NgIIkrRAMZGEGBgMGzYRACuAA7cxFQmRLEA7jBoEdwsRNjREP6mwQAmRFAQVDRoJcH40ZEcVPhxjEQs+GiE5EQQRBIw0F1URAmmfF5uKFZ8nj4Ojh7evmZDQYOF3DARYNxEhdAUplTbw1DNEpGD+BHY3LBG3MkBELkSbKaZXSH4Rvj1Hcum-jiNDAVAyWWGbWyAE82BxCkIAHQ6PRSFFMEBUCBocgwKiOUKiKhoSJwZhE-DkHFoCxxQrURo4AAy+E4HVESGAWhA+CgsTQmJBzl4hS58C5ADE5ERnD82FzGFybI4+KKuSwIOEYPKuQA1NwASTMAGkvKrWBrsFqmFzILAzSQoWZMVR9dh0H0KsZgjqNSTtdzebwBS6QWaAIwAZi5AF9mpyA3zg0K0CKEFyAApsSL+XBEPjcXBYeD2EtEGwAFn15EK5CM5Co5Gi+AAQv59V4TRIvNiAJrJGw9rztgCOXgAnGwAFYoCxeAAiAEVyM2oEarF4JOQF1YAKzl5JeGBeRmURxmFCCLzJRx9gBMh74zcEVjYFgs5Dnjn8FigyR7zcZFhuH1f8jC8KAvHA6huGwCMzB8bgqGHI1kgAWj4cgUDDcgvAACTcCwjW4LxmwABggAAOZIu0cYcSCoQoAGpcP-KEvHTBcvHIMAAC1cFQ7AACly3TSAzBIScLCMGtm1HKxiNwD8TRsfUjAsGxxTMbBOFw8hSNw3d9QsMAzAgUZuDYLwAFVHAAL3IKFIgkCwsys+D5xYrxOCgBdyyoTgeMcRkjGbSIwHIWyYEEntcJ4nszGbRirDMUjBEYmAzEE4ceN4zg2DcHdBEChdsAsMM2DMHsbAgZtxS8MNUJYZw50nfxSLYAB2eDCmPNBv2wYdhxQJCADZGKgZsUEYsMeIjcU5wsKy2DnLwqsneDm3wacSGiMASAADVvctOAjRjyEE5se3TW9SK+XD3P9JUVTTc1NX9PVDRNM0iT9a1wGgK0xRAXCIGwMx8lCf0eUTYIQyoM1SJjOMuWhoNYeTVMgZsdRTT+p6zXVN6-o+41caBwnLX9W1Aa5V0vDYFkrQVBM0ZBfVQxexGQFjIh41R-l0eFM1sdx5n8Zeimmd1A1SYJi0pf+u0XtdNwihuKHAwFtmOaBncuZ5vnNaTIWEDAOo2DF5VvuJBWSa+iX5apgH7ShRwmzABlHBYPgsRxF03QwMo0i9MAfSzBX+eDdn4Ze1CdyR3mUaNwWU3tbgJB+agoUeq2Xp+22Zft8nHb+6mzR97FcSdMpXXdIP+CCPbCAj5PtZjoH9eRlmtaoDHhZxnPnqB-P3sLsm1RL5my5ekHSrQe4wA1mG24RhPDeX3uTaxge8dz4uieZu3x4xG2naVoHZ5pXlXhoQpxTabAqEZIoFxJR-sCX1m4dX7mGDJdpKRpBpGAOkDQ4jYGfiA9kf8QAwBYCwGA-hQTil4MyVk4V2Try-n3F6mZsy5nzIWMAxZSwVirDWOsDYmytnbJ2bs5A+wDiHF4UcE5pyzkXMuVc65Nzbj3AeI8J58BngvFeG8yR7wwEfM+V875Pzfl-P+QCwFQLgUglAaCsF4IkEQshNCGEsI4XwoRYiZFKLUS8LReiTEWLNjYhxLivF+JCREmJCSUkZJyQUkpLwKk1IaS0jpPSBkdxGRMmZLwFlrJ2Qck5FykQ3KQTnJ5byvl-KBWCqFcKkVoqxXiolZKqV0qZWyrlfKhViqlXKpVaqtV6qNWaq1dqXUvA9UZH1CwA0hqjXGpNaas15qLWWqtGw60SJbRQDtPah1jqnXOpda6t0jD3UgmfGmIA3AwCgNwTgR4kEMlHp9Y+I8-qR1hjYSIUBehoB-gbJOG8cHb1FjaZ2L0pLBBxG7QgnsWAkALkcuWB97lfwuVctIZo45r2BT3R5iod5T1eUDOcGwiTcEdDCOEQhDmywdkC7uwZQXXNuTAuBCCkHYBQWgSBhRsDQO5kAA"
];
    
    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#00ff00"
        ..aspect_light = '#EFEFEF'
        ..aspect_dark = '#DEDEDE'
        ..shoe_light = '#FF2106'
        ..shoe_dark = '#B01200'
        ..cloak_light = '#2F2F30'
        ..cloak_mid = '#1D1D1D'
        ..cloak_dark = '#080808'
        ..shirt_light = '#030303'
        ..shirt_dark = '#242424'
        ..pants_light = '#333333'
        ..pants_dark = '#141414';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Frogs"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["GREENTIKE", "RIBBIT RUSTLER", "FROG-WRANGLER"]);

    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Stuck", "Salamander", "Salientia", "Spacer", "Scientist", "Synergy", "Spaceman"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Canon", "Space", "Frogs", "Location", "Spatial", "Universe", "Infinite", "Spiral", "Physics", "Star", "Galaxy", "Nuclear", "Atomic", "Nucleus", "Horizon", "Event", "CROAK", "Spatium", "Squiddle", "Engine", "Meteor", "Gravity", "Crush"]);

    @override
    String denizenSongTitle = "Sonata"; //a composition for a soloist.  Space players are stuck doing something different from everyone,;

    @override
    String denizenSongDesc = " An echoing note is plucked. It is the one Isolation plays to chart the depths of reality. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";


    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Space', 'Gaea', 'Nut', 'Echidna', 'Wadjet', 'Qetesh', 'Ptah', 'Geb', 'Fryja', 'Atlas', 'Hebe', 'Lork', 'Eve', 'Genesis', 'Morpheus', 'Veles ', 'Arche', 'Rekinom', 'Iago', 'Pilera', 'Tiamat', 'Gilgamesh', 'Implexel']);



    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Frog Statue",<ItemTrait>[ItemTraitFactory.UNCOMFORTABLE,ItemTraitFactory.STONE, ItemTraitFactory.ASPECTAL],shogunDesc: "Croaking Lizard Monument",abDesc:"Frogs."))
            ..add(new Item("Frog Costume",<ItemTrait>[ItemTraitFactory.CLOTH, ItemTraitFactory.ASPECTAL],shogunDesc: "Croaking Lizard Cosplay",abDesc:"You won't be able to stop the ribbits."))
            ..add(new Item("Nuclear Reactor",<ItemTrait>[ItemTraitFactory.NUCLEAR,ItemTraitFactory.SMART,ItemTraitFactory.ZAP, ItemTraitFactory.ASPECTAL],shogunDesc: "A Representation of My Hatred for Everything"))
            ..add(new Item("Telescope",<ItemTrait>[ItemTraitFactory.METAL, ItemTraitFactory.GLASS,ItemTraitFactory.SMART,ItemTraitFactory.ASPECTAL],shogunDesc: "Mono-Sighted Long Ranged Perversion Apparatus"))
            ..add(new Item("Green Sun Poster",<ItemTrait>[ItemTraitFactory.PAPER, ItemTraitFactory.ASPECTAL, ItemTraitFactory.GREENSUN, ItemTraitFactory.LEGENDARY],shogunDesc: "Sauce Sun Poster",abDesc:"Huh."));
    }

    @override
    List<String> symbolicMcguffins = ["space","commitment", "creation", "room","stars", "galaxy", "black hole", "super nova"];
    @override
    List<String> physicalMcguffins = ["space","frog", "globe", "map","toad", "bass guitar", "nuclear reactor", "paint"];


    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.ALCHEMY, 2.0, true),
        new AssociatedStat(Stats.HEALTH, 1.0, true),
        new AssociatedStat(Stats.MOBILITY, -2.0, true)
    ]);

    Space(int id) :super(id, "Space", isCanon: true);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.space(s, p);
    }

    //space quests have only one (FROGS) but it has a shit ton of questchains for every tier at hella high levels
    //so it overrides any other theme  (yes space players still have frog quests )
    @override
    void initializeThemes() {
        //learn about frogs
        List<String> frog1 = <String>["Wherever the ${Quest.PLAYER1} goes, they find a ${Quest.CONSORT} yammering on and on about FROGS. It only makes a little more sense than when they say nothing but ${Quest.CONSORTSOUND}.","The ${Quest.PLAYER1} has found several frogs in various states of not-usefulness. Apparently ${Quest.DENIZEN} is somehow to blame?", "The ${Quest.PLAYER1} wonders why there are so many temples covered in frog iconography in this weird land."];
        //learn about ectobiology
        List<String> frog2 = <String>["The ${Quest.PLAYER1} discovers some tiny ectobiology lab equipment. Oh! Apparently it's for breeding frogs?  They play around with it a bit with what frogs they've managed to collect. It looks like they can somehow...combine frogs? Aww, look how cute that tadpole is!  ", "The ${Quest.PLAYER1}'s server player deploys some weird equipment. After fiddling with it a bit, the ${Quest.PLAYER1} learns they can zap frogs into it and make baby frogs. How cute! ", "A wizened ${Quest.CONSORT} shows the ${Quest.PLAYER1} an ancient temple containing tiny ectobiology equipment. The pictures in the temple depect two frogs being zapped to it, and producing a cute little tadpole."];
        //learn about denizen
        List<String> frog3 = <String>["A wise old ${Quest.CONSORT} tells the ${Quest.PLAYER1} that they must negotiate with ${Quest.DENIZEN} to release the vast majority of the frogs. Apparently this is called 'lighting the forge'? ", "A temple shows a huge snake monster, probably the ${Quest.DENIZEN} locking away all the frogs.", "A ${Quest.DENIZEN} minion tells the ${Quest.PLAYER1} that if they want to find the best frogs, they are going to have to face the ${Quest.DENIZEN}."];
        //meet denizen
        List<String> frog4 = <String>["The ${Quest.PLAYER1} meets with ${Quest.DENIZEN}. They speak in a langauge no one else can understand, and prove their worth. The forge is lit. The frogs are free.", "The ${Quest.DENIZEN} offers the ${Quest.PLAYER1} an impossible Choice. After some deliberation, the ${Quest.PLAYER1} decides that it can't be done. The ${Quest.DENIZEN} sighs, and agrees to Light the Forge.", "The ${Quest.DENIZEN} is a dismissive asshole, but agrees to light the forge. Wow, the ${Quest.PLAYER1} almost wishes that they WERE supposed to fight. "];
        //can't be random here, this is beore a session exists :( :( :(
        //space player don't get boss fights
        addTheme(new Theme(<String>["Frogs"])
            ..addFeature(FeatureFactory.ZOOSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.CROAKINGSOUND, Feature.HIGH)
            ..addFeature(new DenizenQuestChain("Light the Forge", [
                new Quest (frog1[0]),
                new Quest(frog2[0]),
                new Quest("${frog3[0]} ${frog4[0]}" ),
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_HIGH)

            ..addFeature(new DenizenQuestChain("Light the Forge", [
                new Quest (frog1[1]),
                new Quest(frog2[1]),
                new Quest("${frog3[1]} ${frog4[1]}"),
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_HIGH)

            ..addFeature(new DenizenQuestChain("Light the Forge", [
                new Quest (frog1[2]),
                new Quest(frog2[2]),
                new Quest("${frog3[2]} ${frog4[2]}"),
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_HIGH)

            ..addFeature(new DenizenQuestChain("Light the Forge", [
                new Quest (frog1[2]),
                new Quest(frog2[0]),
                new Quest("${frog3[1]} ${frog4[0]}"),
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_HIGH)

            ..addFeature(new DenizenQuestChain("Light the Forge", [
                new Quest (frog1[2]),
                new Quest(frog2[1]),
                new Quest("${frog3[1]} ${frog4[2]}"),
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_HIGH)


            ..addFeature(new DenizenQuestChain("Light the Forge", [
                new Quest (frog1[0]),
                new Quest(frog2[1]),
                new Quest("${frog3[2]} ${frog4[0]}"),
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_HIGH)


            //ALL classes should have their own frog 3rd tier quest, this one is just the default one.
            ..addFeature(new PostDenizenFrogChain("Breed the Frogs, But Be Boring About It", [
                new Quest("The ${Quest.PLAYER1} collects all sorts of frogs. Various ${Quest.CONSORT}s 'help' by ${Quest.CONSORTSOUND}ing up a storm. "),
                new Quest("The ${Quest.PLAYER1} begins combining frogs into ever cooler frogs. They begin to realize that an important feature is somehow missing from all frogs. Where could the frog with this trait be?  "),
                new Quest("The ${Quest.PLAYER1} has found the final frog.   Universe Tadpole all ready.   "),
            ], new FrogReward(), QuestChainFeature.defaultOption), Feature.HIGH)
            ,  Theme.SUPERHIGH);

    }

}
