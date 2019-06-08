import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Void extends Aspect {

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 1.0;
    @override
    double fraymotifWeight = 1.0;
    @override
    double companionWeight = 1.00;

    @override
    List<String> associatedScenes = <String>[
        "[Discus]:___ N4IgdghgtgpiBcIDaARAlgZwMYFcMF0QAaEAMwBsIA3AewCcAVGADwBcEQAeAIwD5VMuApwD0fADpgedXpIYALGAAIAygGEAogDkNAfQDyAdR0AlXVoCCAWQ1K6MCFkUYlaMKxpLWipbTQATJQgwQIAHHHJyFxocViCAOkTVACEAVRNk1Rg6KmygkKU1cjQYdyV0bAB+SWleWuIQVgg6AHMYVn0wOERWOhw4El60Fra6NRoQtFY0CYwAGTQqNxaOJGBxEDQoUPom90N6fw34DasabjRi1gBPDaINrX0GY43SCCiYO42ANRMASRUAGkLC8yO8MJ9iBtILBQVZriomqw-hgAOL2CCsbIKYLfd79L6bba7YLI9yggCMAGYNgBfIhKdZEnZ0PasA50I4IDYABXIOCwAGslAwaILSvBdFKlFoACx-Fr+FryFqsFqhNDJLB-CzA7gWVoATQA7lpDRYdQBHCwATnIACtUWoLCgAIotZJQQEaCzcFqujQAVllxosMAscxaaH0KlRzAsxv0JoATGGGMlmBpyGo1C0UPosGooMbDck5qQaH9S-ILFALLWpjQMFSVNYaKxLYDjQBaBgtVEUloWAASJjUgJoFmSAAYIAAOY36-SWqysfwAamHpeuFh5rosLTAAC1Bd2MAApWU8yAqKz2tTyJXJa0aSeCvPArR-eRqLQAMRUDAqGHFpp2HIM-jUMAVAgBgLBocgLFSfQAC8WmuHBuCKHBUlbF0twsKgoFdWVWCoI99DmeRkhwMAWhQmBz0NYcj0NFRknXDQVGnZh1xgFRz0tI9jyocgTEDZgKNdDA1ApcgVENLQIGSP8LApbtSEMFB7SwadyAAdlbfwIzoQsMEtS1UQ7AA2dcoGSVF1wpI8qT-FA1FScgUAsRT7VbZI0EdKxQjAKwAA1k1lKgqXXFpz2SQ0eWTac0HkYc8MJR5nm5MEPkJX4AWBUFegJKFwGgSEThAYcIAwFQsFKSF7mZEl3D+ckcunOkGSZLYWTZDkuSqrQRBBMqstBN48rKgqgTGqqpohQkYUqjYUQsYpckJPrWrJVhQS6kB6UZDYdtZUlBtBEaxuaiacsWpqfn+ObJvBR7ythHKURMYJ-BoKBtuJc62o6qrA0O47eqBgbDiu0bMqeV7pua2aivut7loq0EURUGByFIQH+tJdr9s67qTpa4H2VhnLroR7KFoxmbnrRqqSvelbsbRGh-AYEo6EJ3aSYO8moaJ-Yaaq9j0kyXGcjyCosHp4q+ne1H5teJnms5nKaowP4sSgJTYC5ZqzrZYWyaOnrTuhi7JY2aWMkKYpSjiRXlZy9n8pZjXcqWsqdaqvWDZgI2KtN23xb2kWjsIQY6GGUZxkmaZZjmX7VnjkAYFIUgYCwVgMD-egFiWOjVjF3bLpyvkBWFUVxTASVpTlBUlRVNUNS1HU9QNFoTTNC0LGtO1HWdN0PS9H0-QDYNQ3DSNo1jeNExTNMMyzHM8wLIsSzLCsq2SGs6wbDxm1bM4Oy7Xt+0HEcxwnKdZwXJcVzXTdt13fdDxPM9L2vBAW895HwehfG+D8Fgvw-n-IBYCoFwKBkgtBWC8FELITQhhLC-JcL1hQARIiJEyIUSojROiDEmIsTYhxLiPE+ICSEiJMSEkpIyTkgpJSKk1IaS0jpPShkLDGTmKZNQ5lLI2Tsg5JyLk3IeS8j5LQfkpyBVRMFUKEUooxTiglJKKU0oZUDljHKJgw40FyBYQuMwwA+0Kn7b2ZVzaki0DgKA3Bsix0hlHauDsQBO1ltkXIdByiCBbroGU8pFTKlVOqTU2oUDAhrJaOKJh9xoDgn2VEsoCJoA2i0KwsoUCoh1FoZ0ah9KygYFAfQqQFQWH0FA+QTEqRzFSNZHkqIRxWENOaNQhoTBzgsAweMyRSA6kxp9KqqJFgwFDgDZmtikYBzNnbdwzjXHuKtp4ymMNOSgj8S7EoZRFahPCe3KJXdYl-HiRYRJySf5WD+MkDAZZVEWD-MmY0Kk1DJDAD5YZNATCtjAGoV005rLyB9MkKkxooCWmzKwZIVAVTJBQhoD0Dy5gWEvEOKggobrQiMZM6ZsybEvXRsjLxVM1luIFps7Oud86F2LqXX6GAs5HSAA",
        "[Sound of Silence]:___ N4IgdghgtgpiBcIDaBlA9gVzAEwARoDNcUBLAGxjAGMYBdEAGhALIgDc0AnAFRgA8ALghAAeAEYA+VJhz4ipCtToiA9JIA6YcZwmbuACxjEAwgFEAcqYD6AeQDqlgEpXzAQQCyp3FU4wIAmABnXAhcAk4IAE8oNAESIgIuXAFDXG5XRwBxU24XD2sbZzdPFGT9f1wAd3IyXABrGBgABzKYEk4QsjISINxAiDAjAbwqNDACDECjFLaOyhgoHsCAOk1tCXXGEAEITgBzGAEbQeEBTgw4JjOSPYPOYzHsEjixwIAZEjYSMD3hJGB1CASFAmlwdmABHYuNhAfBAe4IHxgRgoLg3hgqHVAQxAeYbNxYYCCBAyFNsYCAGqOACSKAA0q5CcwSWTGIDILAme5IigdgJqYFMr5-DAeOUwBSSRdyUCQWCBvyIUyAIwAZkBAF8GLgAbLQZxwZDoUyAApkDF1NJoBpgeBWe24cwAFmpe2we30ewEeyaJAAQlRqa4GWJXPsAJqVczh1xBgCOrgAnGQAFaZYyuAAiAEU9n6oHTTK4xHts6YAKxOyquGCuN57Eg2FCZPiuSo2SMAJhr3D9fFMZGMxj2mZsVGMUEq4b9b0S1On+lcUFcS+eaECqpQHlicbplQAtNw9pllXtXAAJRzGOloVx+gAMEAAHJVQzY4+4BNgANTn6eRVwTWzVw9jAAAtOp90CAApJ0TUgFB3BTYx9HdP0E1MW86hHBlzGpfRjHMAAxFBAjYc89nvc8K2pYwwBQCB0jQMhXAAVRsAAvPZIgwMRjHNVityzP9XDYKBsydAQ2DAmw3n0P0sD2DiYGg8NzzA8MUD9b9TBQe8+G-GAUGguMwPAtgyEccs+Bk7NAmMZUyBQcNzAgP0iNcZV9wIOxMxTKh7zIAB2LdsDrThx0COM40yAQ4wANm-KA-Uyb9lTA1UiMzYxWLITNXBclMtz9Eg03cJowHcAANTsnTYVVvz2aC-XDE1O3vEh9HPISZTxAkECJFkYBlKlaQZJkzmlNlwGgYaBpAc8IECFAaEGGVgX1Q1qSVeb701bVdQ2+UIShTgYXm8wVEZaa+qZYlSTmnEQFG+lrrhZkHplDk5vegVXG6NhHsBI6DQVbaBCZPaQC1HVgblUGTuNC6rt6-E7qGkaaVe9HPum76mQFRxhjQKB1vhradve8soZhw7yYVU7zvgMAMC6J7bvm+7WSel7xs5jG8dmrlIhsX0wBIMYbAIbhdgOflBWFAIxQGSVzSBvVjsVCH5vLfbYY1hGjTOplLuu9m0f53Geaxvn3sm9X8fmxb7JJpoKACMKujeYZswuQIBECMnNrBynARpg64eDxHjfm9AsDwQhiHISgaFR-q7fOdXebewarfZIWnaWoiImiWJ4jsZ59FczlppBintfemn6CuTgbjuB4cGeCWwHeYY-mbkAYAIAgYCoAOiK4D4vh+P46ajo2mcBM0LStG07QdZ1XXdT1vV9AMgxDMM9kjaNY1cBNkzTDMczzAsixLMtK2rWt60bZtW3bLsez7AchxHMcJxThnHOBcS4VyLAEOuTc244p7kPMeU8F4rw3jvI+F8b4Pxfl-P+QCwFQIQSgrBeCEBELIVQnmDCWEcKuDwgRYipFyKUWouWWi9FGKuGYmxTi3FeL8QwIJFcmYRJiQklJGSckFI-GUqpdSmltK6X0oZYyplzKWWsrZeyjlnKuXcp5byvl-KBRCq4MKbwIrGCijFOKiVkqpXSplbKuV8qFWKqVTI5VKo1Tqg1JqLU2odS6j1QWNd3qOAWGgQGrgx7d0xmNHO2xM5B01uYFEYhRSQz1nPTWjMTYo2CT9QEKEBgHFFt8buUt3BZxtvErm6s64KhSVANJnAmS62hhHA2hocmxxkAneQyclDrysI6F0boPReh9P6QMmY6R+iCmGZc0Ezz6GzO4TskQyyBGLO4gqXE-RoGAlVakizKiOFcJkcMjgxDuGnGAByewTTUj9MqC8TyzmmE4DGTMdQ+DAU4JkP03A0CJkCKYMQ546jhjqFQb85g7AFT9BAc8GASAcQpIEbgxhoIkGpNmC5rgbBiHDM0KgZA7B8HvK4IiYA3iOFVKqeKNgoD7ioC5Zy4YMyuHiqGVwFJsw2GrNmYCYEYBPOgu4FAjg9hoGpDKgcewqCuGMO4Vw3BKjDkCH6bMJBzyekiLqqsVV9BOg4hebAqowKRDeIEaqRY7COD0nUFZrFzkBxQtmSoJpMyOEiBxTMo5TB+j2E+E0OUKQUjzAIGMJjA1OnipkDiVUnSuWzNSdwxhqTxQIG8KqcZzBUE7FAGwfA9jcrEPCxw+gbDKg4pkPYtJ4ooEqJmbAmYVVqtjNwRwYEoBOgeX6MCVAmicCVd+MCZL4r3k7MqSo2YIDVnDCQUwew6jQRQMYbM542CpoDJwNAxhOw2G+CxKqKZXCqn0ImN45gnz7j2MYJ0rEN29lnX6bAgbpVm3ziEwEmRPgwGLlEGIcQCCxOxpbbmkdkmpPSbtTUA8h4jzHoECenBvY4ECP3aGQA",
        "[Empty Shield]:___ N4IgdghgtgpiBcIDaBRKAHALgTwAQGUALASxgBsATAXRABoQAzMiANwHsAnAFRgA9MEIADwAjAHyoMOAiXLUhAenEAdMKI5jVXQjAIBhFADkUAfQDyAdWMAlE4YCCAWRS4KbGAGcwAcky5CrLoQYNiYJGAA5riYbLhsDAwwHLjEYHEcFEnRsegcbJgwAMZ+Ybpc9tYA4ihcdk6mZrYOzvi0uB6xpXiZhcSZ2bi5+UUlOrjlVTV1zuZN9fi4AO7EYdE6UB7kDAB0qupi+3QgmBAcETCYZmBwiJgcAK5w9HfEEeccemxgFCvEXx4AGWILFSEUESGAyhAxAwnBOYEwFk4FCh8ChjjYImIZBW2ChtChhjMXFRUIYEDIm3xUIAatYAJL4ADS9lJjApVLoUMgsDZjmw+BOmHpHkqHBgEAK3ACYBpFMe1OhsI48OFCLZAEYAMxQgC+bUhSvQcOCiORbIACmR7oUANbjNi2mBgeAmN24QwAFnpEQoEUIEUwEXQxAAQoV6fYWSJ7GcAJqLQxx+yRgCO9gAnGQAFaVPT2AAiAEUIqGoEyUPYRBEiygAKyexb2GD2AERYhmfCVXj2RZmBMAJmbXFDvBQZD0egiBbMhT0UEWcdDAIYbHpS8I9ig9i3KzYHi1+Cc+VTTMWAFouBFKhqIvYABLWPRMtj2UMABggAA5FjGzKnHEwCgAGp7yXbB7AtIt7AiMAAC1bXPDwAClPQtSB8EcbM9EIP1Q3TFBX1tacWUMelCD0QwADF8A8Fh7wid973rek9DAfAIHKNgyHsABVMwAC8Imwe4RD0a1eKPQswPsFgoCLT1MBYOCzABQhQ3uSIBJgZC43vOC43wUNgJQfB314YCYHwZDUzg+CWDIaw614FSiw8PQNTIfA40MCBQyo+wNXPBgLALbNCnfMgAHYjwoVsODnDxU1TSpMFTAA2YCoFDSpgI1OCtSogs9F4sgC3sHzsyPUNiFzRx0DARwAA0B09FgtWAiJkNDOMLQHd9iEIe8pMVIkSQQMkORgRU6UZFk2TuBUuXAaBpomkB7wgDx8EKZ01oJI0TQRel1XW989QNKEYWNFVTSRDI2UMBRWWWsa2XJSl9tpBlmRetF2U+xUeTW-6RXsHEWC+w7buO07-vOkB9VwQ1rqOs0HvWp6XoOt71o+zkDtm373qmoHVrZEVrGCNwoEVVGYbVTA2TrBGkZR5VVXulEEDAe4yDIHHiRJwHlqJ+a8dJ5bgb5bAzBDMA-jAMwGC4U5zmFUVxUlJJtGCOVrSh+nVROpn1o1VnLuhznzUx57RqFiWRcJn7xf+xaoel9bNvctgMDIC4YAoAtnWIbSwABami0eDxMA8OmOdNE22Qt5GroThEuctNhFiSe3xrdh4obFv7Jqd7lyfW1WzguQVJRFMUJSlXXGtSQ308Z5O9RoZ4OFed5Pm+X5-gj75wW7kAYASEYPCozggRBSJwXZm7rYx-6rRte0uEdZ1XXdL0fT9AMgxDcNI2jWMIgTJMU3sdMs1zfNi1LctK2rWsGybFs2w7Lsez7Qcw5RzjknNOWc85FzLlXOuUMm5ty7hiAeI8GI0pnkvNeW8D4nwvjfJ+H8f4AJAVAuBSC0FYIISQqhdCEBMLYVwqWAiRESL2DIhRaitF6KMWYnWVi7FOL2G4nxQSwlRLiXuJJHcBYZJyQUkpFSakNJaR0npAyRkTJmQslZGydk4IOSci5MwbkPJeR8n5AKQUQphQitFWK8VErJVShlLKOU8oFSKiVMqFVDBVTfLVSo9VGotTah1LqPU+oDSGiNKWFd-rWBgFANgkN7DFEVjNF2JdjiF3jivU0hh7hQBELnM6F1U5Wzujbf6WMya8nWjhYI5w5apEVsrRwRd0nCwJmnHJCI8kFKKf9OsJTl5o0zrbbG5canr39n6GAAI2DYApDgNJc0Mn4zbt0zAvTCkcE7ojcek9EjFBnnPamHgx6IyAA",
        "[Call of the Void]:___ N4IgdghgtgpiBcIDaBhCAbdACA9gMywBcALGLANRwEsATAXRABoQ90IA3HAJwBUYAPQghAAeAEYA+VBmz4ipCtXoiA9JIA6YcVwmaeCgMooAogDljAfQDyAdXMAlC6YCCAWWNEYEAMakAzvJkPM72AOLGPE5ullaOLu4GWBBYAO4QAJ64BDRcEClUYADmWACuAA44YFgAXjBcOAC0FQWEWJy0WDBgdYWZhDhYBd5cXn5kJDBUXLgpVRUpdQB0WACShADkAQtTNIxJYDRJWOhUhIToZDkQBQXF-YFTM1V+EGCn6XtiJa2nqdwA1n5FpptBJQUwQIQIFxCjBCFZusJCFwSnBmMiqIVYVwUJUaKcqJU-AAZKjsW7CJDAdQgKhQCpcKFgQg2bg0GnwGkGV7vGmMGmmKw8Dk0vAYMZ8mnkewrAwAaWcIpY4pgkvA0FVCBprnSBihhBWflCIwghDq+le5AwqLVdIZTINzKVAEYAMw0gC+e2ptPp3AdrK47K1IAACugSt5-lgeDh-l14BYk1hTAAWFaFGiFYiFQiFMpUABC3hWzgVYmcMIAmilTFXnKWAI7OACc6AAVqEUM4ACIARUKhagcuMzjEhT7xgArKmUs4YM5iYUqFYDKF+M4UlYawAmec8Qv8YzoFAoQo9qzeFBQFJVwvEvA4FZ34jOKDON+nHB+V0GNw4QhGzlFIGh4QpQmdQpnAACXsFA5RwZxCwABggAAOFIKysRtXEIGgAGpoLvdJnFDPtnEKMAAC1-gaPwAClU1DSADFcdsUGILNC2bYxEP+c8FVMFZiBQUwADEDD8dhoMKZDoOnFYUDAblghwdBnAAVSsapehKMQUAjDS-17IjnHYKA+1TQh2CoqxiWIQsSiKWp6KraCqKrAxC3w4wDGQ-h8JgAx6MbKjqPYdB7CnfhbL7PwUGddADCrUwIELMTnGdBo8BsHt228ZD0AAdj-GhFy4K8-EbRtQkAgA2fCoELUJ8OdKjXTEnsUA09Ae2cFL2z-QsqE7VwyjAVwAA0d1TdhXXwwp6MLKtQx3ZCqGIaDjLVQVhRDMV0AlJgpRleVFRDZEbWO9VYCVaCID8AxvC6TV+V9e1XkdQglWQz1vRpO1-U+wNg05EBTBUc63t2pUDqOt7pVlBVYZVNVIFukNDWcE52FegG-UZT6VidENfpAL0sB9QHCeZEGlQhqGBSFFHDrxkBEbOln4ZpdHNTBw17FeGgcCgW0CYdYnvpDKcyYpqnxeBtkOTAEpMGh5n9tR66OeRzXWbRjUlR1KwCzeSorDwHhoVhA0jRNM1eGIS1rTZ6mJZJsGpz+yn8Y+2mlZDBmdo1sG4bZnXzrBy62d5u6HtxekLjNGgxKmPxCGJIW+1RdO-DFv2vp+735YLumQ1DHAFi4YO9qjlFw9O3XQ61t7Y5DK2YThPVTUNY0vAdi0wCtCNXYV5lJZdV1kOn4vfaB-2gyVKi6kaCuWiwYxuhhdJE2TNMMyzHM8wLYsVkLCBXELKxCyK5xCCQya+wMaokO8Zxuw0nh+2gy-Q1HUJXw9lcGObsphXTkD7IWDS9YyIiRQKmRcoRXB9h7AqKs5BSxTg0oUaCyFnBoRwRpKczh6KTX+CRLEYkkr8D7K+ZwVhnBUR3CsMSKA6rODqlYFY3g0LOGMMwwsk1jApA0lwGw-A-BxVDAYUM7BXDQFLDQaofYaHpBoHKKsGlSxWCgCsew9D6IaVCEhTsPYUg7lcPYUwyEbChBWO2GghYexaV0Q2dI3gjChColAPIhQDAwBSMQDSzhQh+BHNUUwIkeymDlDQeihQUg9nSMQKgKBQj0Tgj2Lg-wbFUBgsEGCUBiTBJ7KmKi+FHx9j7M6ewcpwj0VYf8Vh5AUDeFTIWdAO40IGDAJNIyj8FjVH4CgUMzgSjBA6chQgyFRxiBsIef4ZicChlMPYHsKwoDkCsKGFa7BSLtlLKGQWPYZZGLlMSdszh2x1VcAnUIhY+ztgQaYHgwTjwbkLGUAwxgz5iRWOgXBPY6p9lyikf4KAqz-H4BAKinFyChDwGIOq3hQx1QiGJYwKB-hIUKPhZwYk0JUBKGhUIPAWwWWcZilAXkUh4HbDgGwxIqz2B4MYbw-B-h4FYviNCPA5RUC5e4gwfYqIGB4Fwqsrh+ChGkewQocoVjGHsDYKsfYrBKJgPYFszjqjtlVcQAwxJTAwGJHVHg9EygQGJFRPAcoDBeTEmIdsaEqJcFdN4c1MAgLkAMM6VwYgiqmEWVWaoeAuBiB4PYP8KB3H-GLIUNh6R0hWHosomWJRnTOhKPWGAVYaBeqrJK4wVZ2yFgMA5YBPYxJcLQhYlsxhQhoS4OQaCy14LjmvPUbioYygrB3E1LN9EeyhDEKGGgRV0A2CKuQKiRUgyhCoOssAYlhpQHlZA4xQCxIlBWLasAxIYBiTEn-fgJQM3GCKlOcSuMXB1WgigRs-Ae3kG8DgHsVtTCuCKmAFALY+xiVcCkRsDRJpQHwmIayhAxL0TQiClYbydlNXoqYKADQqwwGQekPs5AxIaTqigS+hZ8RWBkvRTahBmEfhTXEmwhB6J2JwFRewjY+pFT7JNeiQVGz4RwHqOq9hcUiWqOwKwVA6qEmHGIYkKAbBUTEEtGwzoIDLO8IW3RNgDBUQ-DXJU0c1QRy5jHQ2IZ7qPWet0fO89C6k09AwdEXBMTYlxAcAkRJM4HEpHZkAMA8B4BgN4QgfgxLcFJOSIolIS5WbLmDcMkZoyxnjGAXeFgUzpkzNmXM+YiwljLGOSshQax1gbM4ZsbZOzdn7IOYcsyJzTlnPORcy5Vzrk3Nucx+5DzHlPOeS815bz3kfM+Qsr53yfn6D+P8rgAJARAmBCCUFYLwUQihdCmF6E4TwoRYipFyKURonRRizEICsXYpxQcPE+ICWcEJES4lJLSVkvJKcillIQFUupLSOl0h6QMiUIyH4eymXMpZaytl7KOWcjAVy7lPLeV8v5QKwVQrhUitFWK8VErJVSulTK2Vcr5UKiVZwZViQVRQFVGq9VGrNVau1Tq3Ver9VMINJCI0kHjSmjNOaC0lorTWhtLa2nrptzBvYGAUAcC42cAFwkYB9ON0jjSPT103afVMCUKAYg6hF3Jv9d6UWA5gyDsL4zYMOKvFhCbG45s8CuAbkjRXyp9Yq7HoQdXmvtfS1nvrmmLJDc0mXvUBoa9mQby3r0ZLqWD4ZePtls+F8r43zvg-J+L9izv00l-PsP9Cx-xCYA4B+lrvgMgdAnbcCEHEiQSgtBGDnBYJwXggh0EiEkLIRQwoVCDA0LoQwphLC2EcK4TwvhAihEiLERIqRMi5EKOJ8o1R6jNHaN0folNRiTGhDMRYqxNi7EOKcS40sKwhVpO8b4-xgTgmhPCZElA0TYnxMSck1J6TMnZNyfkj80EiklLKRUnAKpGpOpYwBpLFZpVpdpTpbpXpfpPsQZYZUZcZJCdAKZGZMceZDlJZFZNZDZLZHZWRfZQ5Y5U5UIc5S5a5W5EWe5R5Z5V5PhdAD5L5H5dKf5QFYFUFcFSFaFWFGgeFRFZFVFdFTFbFQsXFfFQlYlUlclFBDSKlGlOlBlJlFlNlDlLlVwHlPlAVAwIVEVMVCVKVGVAwOVBVJVFVNVDVLVHVPVWhQ1Y1U1c1S1a1W1e1dKJ1F1N1D1Tjb1X1f1QNYNUNcNSNaNWNeNRNZNVNPsdNTNbNecPNAtItEtMtCtXsatFYWtVwetRtZtVtKsdtBNKALtRsHtPtAdEoIdEdMdCdKdGdOdGgBdJdFdOkddZqXsVwbdXdOUfdQ9Y9YwU9c9S9a9GAW9e9R9Z9V9d9CAT9b9X9f9QDYDUDcDSDaDWDGweDPhRDQsZDVDdDTDbDXDfDQjYjUjcjSjAxGjOjBjJjFjZwNjDjLjHjPjATfCITETMTCTOUKTGTOTBTJTFTNTFYDTLTRmG6PmGkBdKXGXSoeXB3QzSzX3d3LXauGzcmLzHzPzALILELIWPwTzcmIAA"
];
    
    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#000066"
        ..aspect_light = '#0B1030'
        ..aspect_dark = '#04091A'
        ..shoe_light = '#CCC4B5'
        ..shoe_dark = '#A89F8D'
        ..cloak_light = '#00164F'
        ..cloak_mid = '#00103C'
        ..cloak_dark = '#00071A'
        ..shirt_light = '#033476'
        ..shirt_dark = '#02285B'
        ..pants_light = '#004CB2'
        ..pants_dark = '#003E91';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Silence", "Nothing", "Void", "Emptiness", "Tears", "Dust", "Night", "[REDACTED]", "???", "Blindness"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["KNOW-NOTHING ANKLEBITER", "INKY BLACK SORROWMASTER", "FISTICUFFSAFICTIONADO"]);

    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Vagrant", "Vegetarian", "Veterinarian", "Vigilante", "Virtuoso"]);

    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Undefined", "untitled.mp4", "Void", "Disappearification", "Pumpkin", "Nothing", "Emptiness", "Invisible", "Dark", "Hole", "Solo", "Silent", "Alone", "Night", "Null", "[Censored]", "[???]", "Vacuous", "Abyss", "Noir", "Blank", "Tenebrous", "Antithesis", "404"]);


    @override
    String denizenSongTitle = "Silence";

    @override
    String denizenSongDesc = " A yawning silence rings out. It is the NULL Reality sings to keep the worlds on their dance. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";


    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Void', 'Selene', 'Erebus', 'Nix', 'Artemis', 'Kuk', 'Kaos', 'Hypnos', 'Tartarus', 'Hnir', 'Skoll', "Czernobog", 'Vermina', 'Vidar', 'Asteria', 'Nocturne', 'Tsukuyomi', 'Leviathan', 'Hecate', 'Harpocrates', 'Diova']);


    @override
    List<String> symbolicMcguffins = ["void","obscurity", "irrelevance", "stealth", "null", "silence", "ignorance", "vacuum", "static"];
    @override
    List<String> physicalMcguffins = ["void","cloak", "disguise", "shadow", "cardboard box", "secret plan"];

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Cardboard Box",<ItemTrait>[ItemTraitFactory.PAPER, ItemTraitFactory.ASPECTAL,ItemTraitFactory.OBSCURING],shogunDesc: "Shoguns Old Home",abDesc:"It's the highest level void item. Except not. It's a box. Asshole."))
            ..add(new Item("Hole Punch",<ItemTrait>[ItemTraitFactory.METAL, ItemTraitFactory.ASPECTAL,ItemTraitFactory.OBSCURING],shogunDesc: "Paper Impaler"))
            ..add(new Item("Smoke Bombs",<ItemTrait>[ItemTraitFactory.EXPLODEY, ItemTraitFactory.ASPECTAL,ItemTraitFactory.OBSCURING,ItemTraitFactory.GRENADE],shogunDesc: "Vape Grenades"))
            ..add(new Item("Tribal Mask",<ItemTrait>[ItemTraitFactory.BONE, ItemTraitFactory.ASPECTAL,ItemTraitFactory.OBSCURING, ItemTraitFactory.SCARY, ItemTraitFactory.UGLY],shogunDesc: "Ancient Face"))
            ..add(new Item("Opera Mask",<ItemTrait>[ItemTraitFactory.PLASTIC, ItemTraitFactory.ASPECTAL,ItemTraitFactory.OBSCURING, ItemTraitFactory.CLASSY],shogunDesc: "Phantom of the Opera Mask"))
            ..add(new Item("Black Hole in a Bottle.",<ItemTrait>[ItemTraitFactory.ASPECTAL,ItemTraitFactory.LEGENDARY, ItemTraitFactory.GREENSUN,ItemTraitFactory.OBSCURING, ItemTraitFactory.GLASS],shogunDesc: "Eternal Suffering in a Jar",abDesc:"Jegus fuck, don't break this."));
    }

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStatRandom(Stats.pickable, 3.0, true), //really good at one thing
        new AssociatedStatRandom(Stats.pickable, -1.0, true), //hit to another thing.
        new AssociatedStat(Stats.MIN_LUCK, -1.0, true), //hit to another thing.
        new AssociatedStat(Stats.SBURB_LORE, 0.2, false) //yes, technically it's from an aspect, but it's not NORMAL.
    ]);

    Void(int id) :super(id, "Void", isCanon: true);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.voidStuff(s, p);
    }



    @override
    void initializeThemes() {

        /*
        new Quest(""),
                new Quest(""),
                new Quest(""),
                new DenizenFightQuest("","","")
         */
        addTheme(new Theme(<String>["Nothing","Void","Emptiness","Dust", "Shadows", "Nowhere", "Absence"])
            ..addFeature(FeatureFactory.SILENCE, Feature.HIGH)
            ..addFeature(FeatureFactory.NOTHINGFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.NOTHINGSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.ECHOSOUND, Feature.HIGH)

            ..addFeature(new PostDenizenQuestChain("Be Forgettable", [
                new Quest("A big party is being held to celebrate the defeat of ${Quest.DENIZEN} and the ${Quest.PLAYER1} is invited as the guest of honor. There are promises of god food, including a gigantic cake. At the door a burly ${Quest.CONSORT} stands with a clipboard. He eyes the ${Quest.PLAYER1} approaching and shakes his head. ‘You’re not on the list, so beat it.’ The ${Quest.PLAYER1} tries to explain that they’re the planet’s hero and the one who beat ${Quest.DENIZEN}, making them the guest of honor, but the bouncer just laughs. ‘If you’re supposed to be the hero, why haven’t I heard of you already?’"),
                new Quest("The ${Quest.PLAYER1} asks other guests to vouch for them, but all of them are having trouble recognizing the ${Quest.PLAYER1}. There’s just something about the ${Quest.PLAYER1} that makes them so forgettable. They go home and bring back photos of themself with other ${Quest.PLAYER1}s as proof that they’re also a hero, but the bouncer dismisses the photos as very realistic but clearly edited. What a pain."),
                new Quest("The ${Quest.PLAYER1} gives up trying to convince the ${Quest.CONSORT} bouncer of their existence. If they’re not going to be recognized, they might as well take it all the way. They use their void powers to become completely unnoticeable and walk past the bouncer while making a number of obscene gestures. The ${Quest.CONSORT} hosting the party approaches the ${Quest.PLAYER1} as soon they turn off their powers to join the party. ‘There you are! You know it’s very rude for the guest of honor to be so late. I’m really disappointed in you.’ Bluh.")
            ], new ItemReward(items), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new DenizenQuestChain("Go to Nowhere", [
                new Quest("The ${Quest.PLAYER1} has wandered around for hours and has found nothing new to do. There is NO way this is the end of the land. What is going on?"),
                new Quest("Huh....what....what is this area of a wall that looks....a little different? Like the shadows aren't falling right on it? The ${Quest.PLAYER1} leans against it and stumbles into a ...weirdly hard to see area. Huh. The ${Quest.PLAYER1} wonders if maybe the rest of their quests are in places like this?"),
                new Quest("Holy FUCK that was the BEST dungeon of ALL TIME!!!  The ${Quest.PLAYER1} sure feels bad for anybody who missed it.  Just, that TWIST at the end, man. So great."),
                new DenizenFightQuest("You're....really having trouble following what's going on. The ${Quest.PLAYER1} emerges from one of those glitchy areas you can't see into, obviously fighting the ${Quest.DENIZEN}. What the fuck is even happening!? ","The ${Quest.PLAYER1} won!  That's....GOOD, you think. The ${Quest.DENIZEN} was probably an asshole.","The ${Quest.PLAYER1} lost.  That's....BAD, you think. The ${Quest.DENIZEN} is probably an asshole.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.HIGH);

        addTheme(new Theme(<String>["???", "[REDACTED]","[CENSORED]", "Censorship", "Conspiracies"])
            ..addFeature(FeatureFactory.SILENCE, Feature.MEDIUM)
            ..addFeature(FeatureFactory.NOTHINGFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.NOTHINGSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.HIGH)

            ..addFeature(new PostDenizenQuestChain("Reveal the Tomes", [
                new Quest("Even with the victory of the ${Quest.PLAYER1} over the villainous ${Quest.DENIZEN}, there are still problems. Ancient libraries lie crumbling in the denizen's lair, secrets hidden in languages long forgotten by ${Quest.CONSORT} and carapace alike. Even the libraries on Prospit contain scant knowledge of this cryptic tongue, but the covers promise great power and mastery over the aspect of Void. Perhaps study of the ${Quest.PHYSICALMCGUFFIN} will provide insight."),
                new Quest("Hours of study yield little progress until the ${Quest.PLAYER1} has a breakthrough regarding symbols on the ${Quest.PHYSICALMCGUFFIN}. It seems that through analysis of the symbols on the ${Quest.PHYSICALMCGUFFIN} using Zipf's Law, you can piece together which common words in normal language match up with common words in this strange script!"),
                new Quest("The ${Quest.PLAYER1} plunders ancient tombs, searching for a rumored Rosetta Stone of sorts, one that promises to provide more insight on rather uncommon words in the books of ${Quest.DENIZEN}'s library. After countless false starts and empty tombs, not only does the ${Quest.PLAYER1}find it, a nearly complete record of the history of the land is found, and by comparing it to known records, they can translate even MORE words, not to mention new parts of history they'll uncover once they translate it all."),
                new Quest("The ${Quest.PLAYER1}, after hours of striving and looking into dark and forgotten places, poring over secret tomes, and studious work in the field of ${Quest.PHYSICALMCGUFFIN}ology, has finally translated most of the books in the library. The mystical techniques of the ancients (who probably never existed, but hey) are now open to them.")
            ], new FraymotifReward("Ancient Knowledge"), QuestChainFeature.playerIsSmartClass), Feature.HIGH)

            ..addFeature(new DenizenQuestChain("[REDACTED]", [
                new Quest("Apparently the denizen [REDACTED] has been [REDACTED]ing all the [REDACTED] and everyone is starting to get a little pissed at them. Can the ${Quest.PLAYER1} help? "),
                new Quest("The ${Quest.PLAYER1} [REDACTED]s and it actually works! Everyone ${Quest.CONSORTSOUND} in surprise. This might just be crazy enough to work."),
                new Quest("Wait, who would have thought that the [REDACTED] would be weak to [REDACTED]??? This is officially the dumbest fight in all of Paradox Space."),
                new DenizenFightQuest("It's time to fight the [REDACTED] for real this time. Their reign of [REDACTED] will finally be at an end.","The ${Quest.DENIZEN} is defeated. FINALLY they can stop censoring everything on this stupid planet, especially ${Quest.CONSORT}s.","[REDACTED]")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            , Theme.HIGH);


        addTheme(new Theme(<String>["Silence","Blindness","Deafness","Blindfolds","Earplugs","Sensory Deprivation"])
            ..addFeature(FeatureFactory.SILENCE, Feature.HIGH)
            ..addFeature(FeatureFactory.NOTHINGFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.NOTHINGSMELL, Feature.HIGH)
            //could make the default quest a knight/page quest in second pass. fighting with nothingness as an enemy and fighting with nothingness as a weapon and all
            ..addFeature(new DenizenQuestChain("Walk of Faith", [
                new Quest("Suddenly the ${Quest.PLAYER1} can't see or hear. Oh god, what is going on?  They feel around in close to a panic, until they find a button. After a moments deliberation, they press it. Suddenly they can see and hear again. Huh."),
                new Quest("The ${Quest.PLAYER1} sees a red button at the other end of a cluttered hallway, inside a dungeon. Their bad feeling is confirmed when they suddenly can't see or hear again. After many stubbed toes and bruised shins, they finally make it to the button and press it to regain their senses."),
                new Quest("The newest button is in the middle of a single large room with pitfall traps scattered throughout and underlings to boot. Are you fucking kidding me!? When the ${Quest.PLAYER1} loses their senses, they seriously consider just sitting down and seeing if it wears off, but those underlings would probably attack in the mean time. The ${Quest.PLAYER1} begins slowly making their way towards the button. Half way through, they realize with a start that the Underlings haven't tried to attack them. Huh.   When they finally press the button, the Underlings suddenly whirl to face them. Were they...INVISIBLE while they were blind? It's short work to defeat the underlings."),
                new Quest("Faced with a huge underling that is probably too high a level to fight, the ${Quest.PLAYER1} is struck with sudden inspiration. They blindfold themselves and do their best to block out their ability to hear, as well. They make their way to where the giant Underling was and begin to strife them. When they stop being aware of flailing, they remove their blindfold and find the giant Underling has become a giant pile of grist. HELL YES, VOID POWERS RULE!!!  "),
                new DenizenFightQuest("The ${Quest.PLAYER1} attempts to sneak up on the ${Quest.DENIZEN} while blindfolded. It dodges. Oh well, guess you can't out-void a Void boss.  Time for a regular strife!","The ${Quest.PLAYER1} has defeated the major challenge of their land.","The ${Quest.PLAYER1} is going to have to try again.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH); // end theme
    }
}
