import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Time extends Aspect {

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 0.51;
    @override
    double fraymotifWeight = 1.0;
    @override
    double companionWeight = 0.01;

    @override
    List<String> associatedScenes = <String>[
        "[Entropy Winds]:___ N4IgdghgtgpiBcIDaBRMAXATgewA4E8ACAdQEswATAZwF0QAaEAMwBsIA3bTAFRgA90CEAB4ARgD5UGHARLlqNYQHoJAHTBjM49dwAWMQgGUAwigByKAPoB5YhYBKlswEEAsikIQAxl5gsYmBDoMFSE6PqEVLgwMBSE2ExhpLCETFxhEdzO9gDiKNxOblbWji7uhvSEAO6k4QHkAOYZMFCEFNhVYJ6UYQCumGCNza3k6NhtvVToAHTqmuLzDCDoEJgNMOjWYHCIWL1wjFikDeuYxtiUtaQXVAAypOyNQkjAqiDJuFwrGMRcFG-wN4AMUwMTkLBYb3obzM1m4ALeTAgLCoMChbwAavYAJKGADSzgRzGRqPR4GgaIQb1c+EMK3Q2KoOVBQQCeggYAxyP2ZI+Xw5DIwRIAjABmN4AX0qr3eUE+mG+6F+mH+VJAAAUWL0vABrQjcbA6mBgeCWM2EMwAFmxDQoDV0DXQDVwpAAQl5sc4CaJnGsAJpVMx+5yegCOzgAnCwAFY5YzOAAiAEUGq6oHiUM5RA0kygAKyWqrOGDOW4NUjWQw5PjOKrWAMAJmL3FdfBQLGMxgaCesXmMUCqftdtzS2KHumcUGck9q2CoosMbmw6FDeKqAFpuA0csKGs4ABL2Yx47DOV0ABggAA4qj7rKHXOgKABqfdD-DOdVJ5wNMAALR1dcqAAKUtdVIEMVxo2MXQ7VdcMUFPHVuwJMxsV0YwzCBQwqHYfcGnPfd82xYwwEMCAsmwFhnAAVWsAAvBp8F6URjC1GjF0TN9nHYKAk0tdB2D-axbl0V1ejABp6JgYC-X3P8-UMV1nxQQxzz4Z8YEMYDQz-f92BYew8z4YSkyoYxhRYQw-TMCBXSBZxhXXJhiATaMvHPFgAHZFwoUtMD7KhQ1DHIVwANmfKBXRyZ9hT-UUgQTYwaJYBNnBs6NF1dUhY1cXAwFcAANBtLXYUVnwaYDXT9dUG3PUhdH3TiyVheE1SRFFKWhEAsVxAkiT2Lq3kgWAiX3CAqEMXxtl5OV+QwbEhTVc9JWlN4+QVAVlVVQEQDMJRCQYGE4SJDrSSOnqcXxQ7drOobyVGtVGWcFgHnujbFUW9AiRWkApUIGUPq2v4iX2w7uta06SXu3rrqhzqyRGyldsZewOXaKBZvlT6lt2vNfv+wG5s2n4QbVMGWpO9robJWH+rVQbEYpIlGRybAKG4UgAix+bBW+5bVoB9bicVbaxpgZFwkptrdsZi66ZuxEaYupGiW4VZ1nQOkglZllgh4XQOS5LV3pFgUvpFUVz2twWiex4GVSJVxsFEUhXvQfBpYGzAeXlq76du5XutVtV1bWDZtYZJk9bZQ2CvIU37YW3G3gJtbZSTpUyfgMBeghCGqdln2Yf9xXiQRlXmbVGlrBdQYLmsJgw813WJf19lOW5RPeYttV1zqyU6EOTBjlOc5LnQa4wDudHniHkAYCYJgYC8dAqCBLh7keSTnjt3mxbVTVtT1A0jRNM1LAta1bXtR1nTdD0vSzX0GgDIMQ2ccMo1jeNk1TdNMzZlzAWIsJYywVirDWOsjZmytnbJ2bsvZ+yDmHKOcck5pxQFnPORczsVxrk3NuXcB4jwnjPJeG8d4HxPlfO+T835fwASAqBcCEBILQVgqmBCSEULODQhhLCOE8IESInmEiZEKLOCorRBiTEWJsV6BxacCZuK8X4oJYSolxKSWkrJeSillKqXUppbSul9KGWMqZcyllrK2Xso5Zyrl3KeR8s4PytwArGCCiFcKkVoqxXiolZKqV0pmEymeHKOQ8oFWKqVcqlVqq1Xqo1ZqldHq7XsC0bA7ASyrynrTUu3tfbdSBhgMwvQoCiG5gLP66dSlZ0duTA6TN0lvEWlMCAeI3aQj9n1Mud0eYk3QOUyp1TdppyFhnfe2cYTNLScjN4MEOTrFruQKejdXAlz6fDc6JSzZlIqVUzARJ+4E3novZeq916b3RlQOef0gA",
        "[Haste]:___ N4IgdghgtgpiBcIDaAJCBnALjAuiANCAGYA2EAbgPYBOAKjAB6YIgA8ARgHyobY6sB6LgB0wHap1G0AFjAAEAZQDCAUQByKgPoB5AOoaASprUBBALIq5AY17o5mAJaw5EEtmoOwAczkAHSgDuMNR2lGD2snJytCYGAOIqtMbmWtpGphYK+C4kJIGePpiyUPaUctQwEFaYLmAAJnJQlOTyRLzBERDhYDRQrgB0ouKcwwQgmBDUXjCY2mBwiJjUAK5whEsOXtPUSmF1Do5h6AAyDuQFLEjAwiBO-tQTYJi6NHU38DcAYhXyug65N3wNzU2lo7xubRI6BggJuADUDABJBQAaRM4OIrmhsPA0BhCBuZgAngoJphEeg4hUIO4ZF04a5Vji7jRHuSnhiAIwAZhuAF9stdblB7myXtQ3gSQAAFEjLKwAa2ilAVMDA8E0mrkagALIivHUvNIvJgvL4HAAhKyIkxo9gmKYATQCakdJhtAEcTABOEgAKziShMABEAIpeC1QFEqEzsLyhlQAVh1ARMMBMxy8Dm0CjiDBMAW0zoATGnaBaGCoSEolF5g9orEooAFHRbjkRKIjW9ITFATL2DpR0NyFOZKJgPSiAgBaWheOKcrwmFAGJQoygmC0ABggAA4AvbtB6zJg6gBqFCtokmaWhkxeMAALQV0-QACkddLIAozH6lNJDQtL0VA3BU6zRNREWkJQ1E+BR0HIFAvC3FAk0RJQwAUCAYkoEgTAAVW0AAvLwiWWdglDlfDRxDS8THIKBQx1TByEfbRjmkC1lm8IiYDfR0UEfR0FAtM8VAULcGDPGAFDfD1HyfcgSAMRMGDY0N0CUTkSAUR01AgC1PhMTlpyIXRgz9KwtxIAB2Uc6gzahG3QD0PTiCcADYzygC04jPTlH25T5gyUfCSGDEw9L9UcLQcAMzF8MAzAADWLHVyG5M8vDfC1HWlYstwcaQUBonEQTBKVIWxAh4SRVF0SlJYmRq3FYAxNB0AUKw1XxIFhVFLp2UwDEt35QUbhZB5BvFSUPhANQBAavryoxKretq5E0VWrF1ta-E5opEwSDOXbJrZREOSlUaQAFOQhTO6bXgxBaluBUFtqhXaEU2hq5rWnFIDaqUKQMLo6koKBmRFVlBou4apUTa7bvu6GpqeGb3jAZZcmW97Kp2nFvvqj7qr6wH9sJIltHNMAHDCbQiFoSZpnJSlqVpaR6UZU7UfOy65sTMa7om3nHolZ7FrKvG-oJlqia2xqVl28n2owXYRRIGYYAc3JjjB0NViwdAoYGp44ZGoWUdN54nqlMxKHYf4DiJKWKrmpqvrqhWZc+gG8QxJmphmUkaQpKlKg5rm5R563zalHkt0T-k8HWDwtmCXZ6gOOmwBOMHLhTkAYCIIgYGqdBPhoU5zm8S4rZh9Hbbm2V5SVWgVTVDUtV1fVDWNU1zStG07QdLxnVdd0TC9X0AyDMMIyjGM4wTZNU3TTNs1zfNCxLMsKyrGs6wbJsWzbDsuwtHs+wHTAhxHMcJynWd50XZdV3XTcd33Q9j1PC8rxvHeB8z5Xwfi-BAH8f4AIRmAqBcCJhILQVgvBRCyFUKJnQphbCJhcIEWIqRcilFljUX7MGOiDEmIsTYhxLiPE+ICSEiJMSEkpIyTkgpR8SkVJqW0BpLSOk9IGSMiZMyFkrK2Xso5Zyrl3Iei8j5PyAUgohTChFKKMU4pxASklVK6VMrZVyvlQqxVSotRVlKAwMAmgtBMNUHOhMva-RuB7E2DdMBqGWFAdgwQLY3XGv1NxGMpQvT9kDOa-4ujTGpp4HODMzCex+iTGObiPFeJ8QjS2ItrZBLmvbR2x1MAuzMf7KUETvAyTJA4xJ+NfYtQek8VJ3jqBcm5EnPxwsAloxtuLKU0pAjpLJiU8JnNykh3hn1eWTjMS1L6vU9xnimktKRoXYupdy6V2oHreo6AC43SAA",
        "[Sidestep]:___ N4IgdghgtgpiBcIDaBlAlgExgZwC4wAcBdEAGhADMAbCANwHsAnAFRgA9cEQAeAIwD5UmHPmLcA9AIA6YPo34zmACxgACFAGEAogDktAfQDyAdT0AlfToCCAWS2r8EAMYrsDlauZWzAcS3NLWwNDC2s7FFUIBxgXMDQARwBXNVwVAE9VJwgwVUTsFPpVAHMYMBhGCHwHNFgnKnoytwb3GDRGVXoAdzAAOhk5fgGyEFwIRhLcQzKuXEZk4dm0IpLGDQaMNFw0BuwAGTRaNDAiriRgKRAagiZRsFxjJgwL+AuUbM20i9ILnUNmZ4uFAgVHyXwuADUzABJFAAaSsAMowNBZAukFgiJsaRQo1wUOwPkYMEq5WU2XBwOSYMuUGujFueLuiIAjABmC4AX1IqnONLpDIejCeCAuAAUqIknABrTz0KWleD6JWqHQAFihRQwRSURVwRQIaAAQk4oVZ4bwrOMAJqdHRWqym+JWACcVAAVj4NFYACIARSKhqgsK0Vl4RV9WgArKrOlYYFZdkU0IYUD42FZOoYbQAmOPMQ1sLRUDQaIrewxODRQTpWw27Cj0KG1pRWKBWVubejYVkoWz0XDxWGdAC0zCKPmZRSsAAkzBpYfQrIaAAwQAAcnQthniNlwGAA1NPa2krKLfVYimAAFpS4fYABSqtFkBQNjdGiUWsNTq0i6lZfhHQoSUDQdAAMRQbBaGnIpl2nKMoQ0MA3i8egqCsABVQwAC8ijSRJeA0CUMN7H0jysWgoF9VVcFoK9DF2JRDUSY5sJge8rWnK8rRQQ19y0FBlzYfcYBQe94iva9aCoMxIzYejfWwDRmSoFArR0CBDTAqxmWHChjG9N0nGXKgAHZewwBNGErbB4niHwBwANn3KBDR8fdmSvVkwO9DQMKob0rHUt1e0NNAPRsAgwBsAANbNVVoVl9yKe9DStUVs2XNAlGnUjqV+f4RSREEYGpSEYXhRFZipVFwGgUqiunCBsBQJxSga74+RubJGVwRFl05bleSubq7kFYUXhAHRxARWqCsRIESrK6E4VmybFpRTr0Qayb8SsKgDg6i4RvpHqoSZIqBpALkeWO2lRvuR5EWm2bOvmoqNqOkBytWhbkS+7bEXxMxsgwegoGpE6GXOvqisjK6buG+7TrGp6EDARIqCoN6-j+pbap+yqPv+6lAaKrFDANOIGkMChmDGCZ8UJYl8BYJRyUpL6obOi7JsjQbbq6lHHqFZ6Zvy3HifxzrCbWi5qoB+rESapTwYIKgYHwDBvVKNA2LAXZQd9ZI8GwSHkeh3mLgRoa7v5HrxsRIiGhgRVlTVDUtR1PUDWNKFfNDF0oEMKwIBDbCwJDXgoCKLRVSsHcZyKDR1SUKUrGMGwl1sAhELQKwXE6UV6G9E8MDMeOqBiqhOhLDPfVMrPxh8JwrQ0SNcDeJ0qEYQ1fV4GxsJijR-UNN1snvWFHKsSN4gIJQfB8K0-S0JxI12HRfEYLPTKYmKMKhJw0E6bDEmZHwEmYMCNHiKEzBtKAoV4DDdkNDRmq0Xh6BgKA0FVeh8y+nQH-Gc55DBtlPEuHw94lxrgIGYDCRQGKqilBhDAzA1xQFyqqLQH5YQ6BQN6DCkYlBXjMPeLQRR7QaCtBAZkhp6BtynGkHw9AUDGEst6CARd-zGCnJTXYkYijMihLCf8y5aCdBQMyWMzpDT3l2MYKwFA1xXmnLgXYRJlydAIMubAoc0CmilPEWMWUTTMmzMyWEzp9x+gwGkfcUIfAwCIlaGwho0gUGZMYRynQihQGzD-fCpofRaH0YIq0V40C7CvFeX0dopTeivLwI8UJ6COQoDYVURREwxUNFoVkMVVTMgrrQDAGSKBXlVNOaeUoqJKKhFKASuUtBXioLsWEPhVRYKwtODChppyNIYR6Ncplpy+mwrwXgWg0CmShJHWgkYpRpEjFYNIUo1xSkNKKcEqoKBERsLQRy2BOhaBsE0tAi9vQ6D7igCCw5qz7m0gGLOYErwYRgG6WKaQ1y8EEb6NIaQwL0EIlQZkTh4haAwMyMA05nQ6BiigDAvAnDOl9Noc895eCdG9NMzo2Arw5KnPuDCUpmTLjWBhNAzIQz70cqyX0EizBFGHKmKEy5mBSjYDoNczJsKGENEURIYFbRQHoKWIK8RfQEC+Z0Q0V5IyzMUY5PyGhaD+QoBQQ0MAbCiigCKqwGhsKig0GkQKUJjAQCKMYMCtClwaDMLAShR9ulFClDFQ1D4RX0CnLQfBpkCBWDEu2Zgvo1xLjAvuds2YHWtCkTYJwKAQi0BCFCK8plRRhVZG6N0cRMUoKsOG+cPp86GggFYfwWgrRaDdMyDQMJDRQkNDReODDKxpvbFCNgPhDSdCvO2MCFrKFZzhJ0Rgth630w0D4UM2FjgzlFBAIclYlDeiKOOw0hrIVFHzKqZgplo6+l2aRUyPgijRjlTYWEhotlQj-tOKA6ZvTGACscWMug3T3mZKqX0jbgwYW9PefV1diSGloD2rQjbDQ2AgBoXeUJwSmREWgYcPgX5mF2U4Rt043RhhrKqI0UItBKGzBQTo5aYA6DHWPKgUJEgZ3vOeb0Ng0CRhiiYocKBpz3iKBhNIxhfSRkctmJQLHVQml9GBJQBLfS4bXNCbMkZ6A2DXJpKUaZdhpB0P+JMUJaAQBsPW3gZhFPZn8tOMDuwzCBTMFeDi8cdDnis+Kw0uAe28SHCHKwYAwIwBgrQMCS9HK7HQveDQSl-T7x7ehWEgXDGpiKLCNgJpEjek6MwXYwLjCJBQBhe0zBKH0c1FCHDOgMCJCS2kRduy-K6ioGAMAhh-GmUfW6K0zo3GIOYFCGwvGl2Rmwp0GAjatBgTMCp3i1rfToWzD4X0zpVQIKtEOGwPgopgUSFaMChnlD0Da0UcEmF7RWAINatcLZmA9pgKvOj12ii8V4GBVUkEwJoA0DYLAPgdABlFN6MAMc2tOG0thNgboCDnndPQCMhpCH3kYFAetJXwy+ikd95g95JvhZw2uQy13fR5a0GwDCsJEiMFxfQRIVLdi4A6z4XYiQ1xnt9D23gnpfNtdTNyrQUodCJGjFNq0plsCihHH5KEzJowZYgE4xiFawLJ17VoWENhGVoGwDhUiVp8clAzGF1kYAQJFBsNpeha42C7kjGYAghhznTiNPLsCRIPIJb89hK0iQYGGLQGBN02YKhno0CgJQxg3SinOX-G1PgoBfYrogrO9BldOGnHEIoUP6BKEHW+IjIczDTi+1ANcyh0VGTwjAQgSh6CNo0E4RgiDpmZuWzYQwPvcPHHoFStJvoSs6DieCRyjAF68Bga5bRnRB2JDQPeAkGiIBSlLLwJIUBH1J6hBhfaWhjDGCiVQYwpoYXGHvEoHQaBsz3gT-eYwVpA2vR+JLSaCtloVTlsVTaaIlaNWaq1dq5t7Z3Bhv1TkEgcgRYZYcoNYMADYLYHYQ2CA04IAkAGATVGIXAbAYFRgfYQ4Y4U4JGX-EWCaMUCUaUWUeUMAN2fQFUdUTUbUXUfUI0E0M0QOa0W0e0R0F0d0T0H0UeIMKOcMKMGMOMBMJMFMNMDMLMToXMGAfMQsYsUscsSsasWsesRsZsVsdsX+XALsHsPsAcIcUcccScGcOcBcJcVcDcLcHcPcQ8Y8U8c8S8G8O8R8Z8CAV8d8T8AMH8P8ACKwICECcCSCaCWCeCSMRCZCCAVCdCLCXCfCUFSnUib0ciSiaiWieiRiZiVidiTibiXifiQSYSUScSSSK8aSWSeSQwRSZSVSdSTSE3PSAyIyEycyKwSyTRGyOyByeIZyVydyTybyXyfyQKYKUKcKHwSKaKOKBKJKFKNKDKLKHKPKWqMmSaMwH+egWgeMJwKAsAR-X6IqB-WqbmO4XnKAXgcoAA66W2IWAUNGSaF6Umd-SaD8bIEoSmI4bYRrTJL6WWPGV-S4nqI4k4xgREfmc4wWA4vAp2eoMoMgigz2agn2Og-2L0C0Z0YOUOcOSOUMGOOOBOLOGCFOYCdOTObOSKPOAuJQIuEuMuCufaauWuL0ATRuS0ccVuduTuCAbuXufuQeYeUeceMASeaeWeeeReZeCMNeDeLeHePeA+I+E+M+C+eIK+G+O+B+J+F+N+D+L+H+P+ABW5NAEBcZKwcBdsUUKBGBQ0OBBBJBXYFBNBDBLBFAHBPBAhIhEhMhChKhQ1WhehRhCVFhNhDhH0bhUUXhfhAgQRYRURcRSRaRWReRRRZRVRdRTRGAbRXRfRCAQxKwYxUxNAcxSxaxWxX0exRxZxVxdxTxbxXxfxQJKAYJdsb0MJBMSMSJaJWJeJK0RJZJVJdJTJbJXJfJQpYpUpcpTVKpGpbM+pB0JpLjFAVpdpTpbpPpQwPpAZIZPbHwUZcZSZaZWZeZLQRZZZVZdZTZbZXZfZKgQ5Y5U5c5GZK5G5IBe5R5Z5aDKwN5D5L5GKH5P5SMAFIFEFIicFSFaFWFeFRFZFVFdFLQTFbFXFLQfFQlRMKwElMlCldvalWlDCelRlWgZlVlHwdlTlblXlflQVYVUVcVKcK0KVGVGwOVBVJVHxVVdVKgTVbVXVfVWMI1E1M1B0S1a1W1ctN+R1O7F1GOd1T1e8b1X1f1QNYNKwUNcNLSKNKwGNZY4+V8RNZNVNdNTNNAbNXNNAfNdOIteEb0UtctStatWtetXiJtFtJcegdtftB0btXtFywdYwYdINIccdQzKEKdGdXgOdKcacRdZdD8NdDdLdShXdfdQ9Y9dsU9c9GMaDa9W9e9R9H0F9P7Iod9HQT9b9X9URLQADIDMCEDTScDfJKDGDODJQBDJDO9VDdDTDbDXDPKq0AjEbEjMjCjKjXuN0WjejA-JjFjNjDjKRbjXjfjQTYTUTP+CTKTGTOTBTJTFTNTDTLTHTQxfTfy4zUzczSzazbwOzLq7wpzMwFzNzGHQ0TzdsHzPzIoALILELKwMLCLIoKLQ0GLOLGEM9JLFLNLDLLLHLPLBSwrC8DAErN0MrCrNgKrCAGrRBXAerRrZrVrdrTrHdHrPrWEAbIbEbMbCbQVATGbObBbJbFbNbHzTbbbDQXbfbQ7cGk7M7C7K7G7ZIShB7J7F7N7D7GAL7H7P7AHK0IHKwEHMHCHN0KHSDWHeHRHGCX0FHFANHDHQVLHN0HHN0PHAnInEnMnL+SnaJGnK0OnBnJnFnNnT5HiNMPQHnPnbJATQXYXUXA+CXPdQ2GXFsUbBXU5ZXVXdXbCTXbXeMToPXA3UsY3HSC083XAS3a3W3e3IoR3GAZ3M9V3d3T3O9H3P3CAAPIPEPMPKUCPQLaPTeVUOPKwBPBNZPJYNPDPHrN0bPbwPPHQAvIvDQEvNIMveeSvRCGvOvLQBvZXZvHNXgNvDvKHbvXvfvQfYfFcToMfOjSfafQ2OfIoBfRIJfZLQZNfKgDfLfNAHfPfMAA-I-E-M-WEC-K-dsO4jEIqC+NYguTY7YomdaEmfYi2P47egEs4jkeAxAigZA1ApgGAjAbAOA66IAA",
        "[Other Me]:___ N4IgdghgtgpiBcIDaB5ALgCxgJwAQFkYBdEAGhADMAbCANwHtsAVGADzQRAB4AjAPlSYcBYlwD0-ADphe2PtKZZcAZQDCAUQBy6gPooA6toBKOzQEF863Gmx0YVAM7X6uCLgAm9erHfWAlrBUfmAwrmC+AA4ArlSOuPRRaK64AMZU9CHxFNZKTGZGAOLqTKYWuigm5pbKAHS4ijAAnrgA5n60oZh+TmgBMGkZofTZQvX5RSVV5ZVlys45oUbqZgAyY4XFpZZ6M9XzWFQRC1DxibgA7n6Yqd48EGg10rJ8z2QgaBDYLTBoKCGcNiicHINj8LW+2FUGXcVz8GQcK3awRanCQwEkIACEUYHzAaH0jHcGPgGPwEFYASiJxWURSAGsMaQMZoUExiRiKBBHDBGRiAGpGACSygA0mZ2ZQuQ4eWQMZBYBL8I1lB80IKHAVsDB7jhFBAwHyuUDeZioNjsLi1XiJQBGADMGIAvqRcOjTebLQTsESEBiAApUWl0+r0OkwMDwHRR3CaAAsgpa7haGBaaBaET8ACEUoKzGKeGYvgBNc6aItmXMARzMAE4qAArAqqMwAEQAii1M1ARcseC02+oAKyx85mGCrNooZQFVhmc4oEsAJjHTEzrHUVFUqhaLZQKVUUHORczKwo9EFx4wZigZmvV3oDjtygs9DQlZF5wAtEwWgUbS0zAACSMVQRXoMxMwABggAAOc4CxQSt8DQdwAGpAOPRozD9NszBaMAAC06U-BwAClYz9SBlHwetVAwJNM2rdRwLpHcxU0QUMFUTQADFlAcWhAJaSDAKHQVVDAZQIDyegqDMABVFAAC8WkaKIeFUQN5OfVsMLMWgoDbWM0FoAiUBWDBMyiMAWiUmBSKLQCCKLZRM1Q9RlEg1hUJgZRSMrAjCNoKgjEHVgzLbBxVBtKhlCLTQIEzHizBtT8KH0Ft6xSSCqAAdmfdxVmwfcHErSsCjfAA2VCoEzApUJtAi7R4ltVHkqgWzMeL62fTM-EbfAIjAfAAA1F1jWg7VQlpSMzIs-UXSC-AwQCdJNFk2V9SVuRNAVhTFCVARlJlwGgGUSRAQCIAcZQUnDY6MSxHF9StNAJUgp0XTdJ6LRer0fQuzQxHFWUQA2iVOR20G9tFEGLsh6UTXlc6MXVMwgg6E0fstQVrS2j6QGdV1HrNZ68X+iUgZBk7wa2hGHpAGGDrpqUGeRiV1SMfVPCgLHSd+vFcberbBwJonvv5z1CUp4H1tZCHWd2oVYcO7BjVB9mtquqLvAiKgfhgdweL8bAHDQFZubbIEzYcPmPReoX3s+4n3TJ-FpYQMAYioGn5ZZqGTqZuGOUVjWzsVRoUAzMA4TAFAKCYT5vjVDUtR1ZgMH1Q1AwZ7GHbxi7B2diX7fJj2LqYPoBhCOXNouo6lf24PtsRsOFS166oTNfVY4Snw7bdx38adEgQWwMEIShcJYXhC3wlRUeQBgCgKH6NAHB4xhEVoZFURLt2Ka2gMgxDMMIyjHQY3jRNk1TdMsxzPMzALYtS3LKtawbJtWw7Lse2f-sQ4RxjgnH4KcM45wLnOMuGAq51ybm3Lufch5jynnPJea8t4oD3kfM+fAr53xfh-H+ACwFQLgSgrBeCZhELITQhhTMWEcJ4UIsRMiFEqI0TogxJiLE2JmA4lxXi-FBLCVEoOcSklpJmFkgpZSql1KaSiNpW8LY9IGSMiZMyFkrI2Tsg5JyLk3IeS8j5PyAUgohTChFKKMU4oJSSilNKGUso5XymYQqKxiqqFKuVKqNU6oNSai1NqHUuqaB6hBfqBRBrDTGhNKaM05oLSWitNabcUYgCMDAKA9AOhmBSL0DIjcVZbQbqDPOeJNBUh4DgJ2hMvok1Lu7b0MtqZynDltOi+pvhR2CLHeOhASnM3hqHE6lS0DVKgLU7AEoi4NJdhMw+Fcq7pBCJGaMcYExJhTGmDM2Yqwnn0JmesAjvhKUAgI5sqgSy7kqmYSuAFYxmCiCKKIqhBScUquocsjRsB8jbAUAijQVgpELC0ECqhziVRGuoIwTAbQpGKKRFoqhxzKGUBgIwG99BgBFEWGCg4IjqBGpWCIjR5KrHOABesTBOq5XoEWGAKwqB5EzEpeSdJWBFgwI0dedJzgtggGYEaLA6Q2hbC2egIoCgQFUCsegpzWxfEgp1VgMEWzLHOPWDAsYjC3mWCgeg5wtDKFjPgCgLRWB2kzC2ZQEQzBcrtHSJgRZFwrEzOoWgLR5KsBarees556BMHkkKHiqh9CQUHDALcMF6zLG9eoEUMErx0ggrGVCn56BthgnaNsERKw1hbOcIUgFYxdmwMobAdo0AzgcIBSCMiIiaEzHyFYbq7W3h4GAFYqgKC4XwF+es0RBwtlyqoTVZhVBpjMLlU58keI1ncPgFY7g7R+FvIKUcBFvjiQKEwVg-QmD3MdSkCImdbwrDMOoO0MAEx+B4m2KAgE-QFBFLQFYBRSLqEzKRNsbZ5KkQiC0fQw7SI8UaNoIs9AeLqCgIKWMrBcoTQgPgNNZh9D6HOARDAT6Ch0gkhEec37SIERSCsNguZlD1kzPgTMZgCIFEzKKPwEACjyQysleS+LsD1iLG2JgsY1AoBQN5IsKxFxtkzBAQKbZ-kCXAvgKS+BVCNFoIOjA2BKqkQcBgKAaAcMrEqoBBMdIlIdjBJVAd9BSKNszNgIwkEWiDkXH4XKI0AiCjSJmFogEbSoXOPgDADg-RDkXFEBwI0HCooPIBNslYUWUp4iKSsVI-RRDpEWNAURwK-z5G1PkLQ-SVk-TxIsDh8CQVoG2T8rAWy5iRp0i6BR2gwHwP04p0NlYjJDgHJpbspkzPqY6Rey9V6FI3lvbmDgF6EyAA"
];
    
    @override
    double difficulty = 0.7;

    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#ff0000"
        ..aspect_light = '#FF2106'
        ..aspect_dark = '#AD1604'
        ..shoe_light = '#030303'
        ..shoe_dark = '#242424'
        ..cloak_light = '#510606'
        ..cloak_mid = '#3C0404'
        ..cloak_dark = '#1F0000'
        ..shirt_light = '#B70D0E'
        ..shirt_dark = '#970203'
        ..pants_light = '#8E1516'
        ..pants_dark = '#640707';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Quartz", "Clockwork", "Gears", "Melody", "Cesium", "Clocks", "Ticking", "Beats", "Mixtapes", "Songs", "Music", "Vuvuzelas", "Drums", "Pendulums"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["MARQUIS MCFLY", "JUNIOR CLOCK BLOCKER", "DEAD KID COLLECTOR"]);

    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Teetotaler", "Traveler", "Tailor", "Taster", "Target", "Teacher", "Therapist", "Testicle"]);

    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Time", "Paradox", "Chrono", "Moment", "Foregone", "Reset", "Endless", "Temporal", "Shenanigans", "Clock", "Tick-Tock", "Spinning", "Repeat", "Rhythm", "Redshift", "Epoch", "Beatdown", "Slow", "Remix", "Clockwork", "Lock", "Eternal"]);


    @override
    String denizenSongTitle = "Canon"; //a musical piece in which a section is repeated (but unchanged) at different times, layered until it's unreconizable  (stable time loops);

    @override
    String denizenSongDesc = "  A sun skips on a groove its tracing 'round the earth, the one-two beat Despair plays to turn cause and effect meaningless. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is/was/will be to say on the matter. ";


    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Time', 'Ignis', 'Saturn', 'Cronos', 'Aion', 'Hephaestus', 'Vulcan', 'Perses', 'Prometheus', 'Geras', 'Acetosh', 'Styx', 'Kairos', 'Veter', 'Gegute', 'Etu', 'Postverta and Antevorta', 'Emitus', 'Moirai']);


    @override
    List<String> symbolicMcguffins = ["time","speed", "inevitability", "paradoxes", "rhythm"];
    @override
    List<String> physicalMcguffins = ["time","clock", "metronome", "beat", "turntables", "music box", "sheet music", "drum", "sundial", "beatbox", "trousers", "river"];


    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Grandfather Clock",<ItemTrait>[ItemTraitFactory.WOOD,ItemTraitFactory.CLASSY, ItemTraitFactory.VALUABLE, ItemTraitFactory.ASPECTAL],shogunDesc: "Ticking Tower of Time"))
            ..add(new Item("Drum",<ItemTrait>[ItemTraitFactory.LEATHER, ItemTraitFactory.ASPECTAL,ItemTraitFactory.MUSICAL],shogunDesc: "Ba Dum Tss but without the Tss Part"))
            ..add(new Item("Dead Doppelganger",<ItemTrait>[ItemTraitFactory.UNCOMFORTABLE,ItemTraitFactory.FLESH, ItemTraitFactory.ASPECTAL,ItemTraitFactory.BONE, ItemTraitFactory.SCARY, ItemTraitFactory.DOOMED],shogunDesc: "The Inferior You",abDesc:"Time is truly the worst aspect."))
            ..add(new Item("Music Box",<ItemTrait>[ItemTraitFactory.METAL, ItemTraitFactory.ASPECTAL,ItemTraitFactory.MUSICAL,ItemTraitFactory.CLASSY],shogunDesc: "Cube of Noise"))
            ..add(new Item("Sick Turn Tables",<ItemTrait>[ItemTraitFactory.METAL, ItemTraitFactory.ASPECTAL,ItemTraitFactory.MUSICAL,ItemTraitFactory.LEGENDARY, ItemTraitFactory.COOLK1D],shogunDesc: "Spinning Noise Discs on a Noise Machine",abDesc:"Do they come with ironic raps?"))
            ..add(new Item("Metronome",<ItemTrait>[ItemTraitFactory.METAL, ItemTraitFactory.ASPECTAL,ItemTraitFactory.MUSICAL],shogunDesc: "Never Ending Ticking Device"));
    }

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.MIN_LUCK, 2.0, true),
        new AssociatedStat(Stats.MOBILITY, 1.0, true),
        new AssociatedStat(Stats.FREE_WILL, -2.0, true)
    ]);

    Time(int id) :super(id, "Time", isCanon: true);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.time(s, p);
    }


    @override
    void initializeThemes() {

        /*
        new Quest(""),
                new Quest(""),
                new Quest(""),
                new DenizenFightQuest("","","")
         */
        addTheme(new Theme(<String>["Ticking","Watches","Cesium","Pendulums", "Timepieces", "Clocks","Clockwork", "Gears", "Quartz"])
            ..addFeature(FeatureFactory.TICKINGSOUND, Feature.WAY_HIGH)
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CLANKINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.OILSMELL, Feature.HIGH)

            ..addFeature(new PostDenizenQuestChain("Destroy 1000 Clocks", [
                new Quest("Now that the shitty ${Quest.DENIZEN} is no longer protecting them, the ${Quest.PLAYER1} can FINALLY get down to the important stuff, namely, destorying all those ceaselessly ticking clocks. God DAMN but they are annoying. "),
                new Quest("With a satisfying BONG, another clock bites the dust. The ${Quest.PLAYER1} finds it all to be so very therapeutic. "),
                new Quest("Through shenanigans too boring to detail here, the ${Quest.PLAYER1} finds themselves back in time, before the ${Quest.DENIZEN} was even here in the first place. Before absconding from the angry snake, they manage to wreck the fuck out of a single clock they hadn't seen before. 1001/1000 clocks destroyed. Mission Complete!")
            ], new ItemReward(items), QuestChainFeature.playerIsDestructiveClass), Feature.HIGH)

            ..addFeature(new DenizenQuestChain("Fix the Clockwork", [
                new Quest("The ${Quest.PLAYER1} is getting sick and tired of the constant grinding of their planets clockwork mechanisms. After consulting some ${Quest.CONSORT}s, they set out to fix the ${Quest.PHYSICALMCGUFFIN} points that are causing the grinding."),
                new Quest("The ${Quest.PLAYER1} learns that some of the ${Quest.PHYSICALMCGUFFIN} points dont actually exist in sync with the timeline, and so they do a whole bunch of bullshit time shenanigans that you really shouldnt worry about. Trust them, its ok. Totally didnt accidentally violate causality or anything."),
                new Quest("The ${Quest.PLAYER1} has fixed all the ${Quest.PHYSICALMCGUFFIN} points! Except- Oh goddamn it.  ${Quest.DENIZEN} has started screwing up the ${Quest.PHYSICALMCGUFFIN} points all over again! They cant take this lying down. Or standing up! Or sitting down! Or... this metaphor got away from them."),
                new DenizenFightQuest("The ${Quest.PLAYER1} is ready to face the ${Quest.DENIZEN}. It will never have the chance to mess with the ${Quest.PHYSICALMCGUFFIN} points again!","Ah, the sweet sound of clockwork NOT being broken as fuck.","The ${Quest.PLAYER1} being defeated really grinds my gears.  Get it? Cuz the clockwork is gonna stay broken and annoying sounding until the ${Quest.DENIZEN} is defeated. ")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.HIGH);

        addTheme(new Theme(<String>["Drums", "Beat","Rhythm", "Percussion", "Metronomes"])
            ..addFeature(FeatureFactory.DRUMSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.SWEATSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.HIGH)

            ..addFeature(new DenizenQuestChain("Synchronize the Rhythm", [
                new Quest("The ${Quest.PLAYER1} starts messing about with the beating drums of the land. The constant cacophony is kinda getting on their nerves, so, following the advice of some friendly ${Quest.CONSORT}s they try to line the beats up to a more harmonious rhythm. "),
                new Quest("The ${Quest.PLAYER1} messes with time, placing zones of slowed or sped up time by the drums of their land so the beats start landing in something resembling a good beat."),
                new DenizenFightQuest("The ${Quest.PLAYER1} has finally gotten all the drums of their land beating in an awesome rhythm. Except for one. The lair of the ${Quest.DENIZEN} is built right into the loudest drum of all, and it keeps. Beating. Off. Rhythm. Fuck it, it's time to strife!","Theeere we go. The loudest drum is finally on beat. The cacophony is finally defeated. And, you guess, the ${Quest.DENIZEN}. Whatever. ","The beat continues to be cacophonous. "),
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            , Theme.HIGH);


        addTheme(new Theme(<String>["Progression","Age","Change","Future","Rivers","Possibility","Flow","Streams","Inevitability","Brooks"])
            ..addFeature(FeatureFactory.NATURESMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CONTEMPLATATIVEFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.NATURESOUND, Feature.HIGH)

            ..addFeature(new DenizenQuestChain("Walk Another Path", [
                new Quest("The door to the ${Quest.DENIZEN}'s  lair is barred by a door locked with three identical missing ${Quest.PHYSICALMCGUFFIN} Pieces. A fourth is already inlaid in the door. The ${Quest.PLAYER1} prepares for a bullshit item collection quest. "),
                new Quest("The ${Quest.PLAYER1} is starting to get frustrated. No matter what they do they can't seem to find any more ${Quest.PHYSICALMCGUFFIN} Pieces. A ${Quest.CONSORT} asks if they have tried...TWISTING they way they look at things. This cryptic as fuck statement does not make the ${Quest.PLAYER1} any less frustrated."),
                new Quest("In a flash of insight, the ${Quest.PLAYER1} realizes that they can just use their Time Instrument to go back before they first visited the ${Quest.DENIZEN}'s lair three times and take the pieces then, as long as they remember to return it after. There. Now there are four ${Quest.PHYSICALMCGUFFIN} Pieces and the door is open. Time to prepare for a boss fight. "),
                new DenizenFightQuest("The ${Quest.PLAYER1} is ready to fight the ${Quest.DENIZEN}. ","Whew, doomed timeline averted. The ${Quest.PLAYER1} goes back in time to restore the 3 ${Quest.PHYSICALMCGUFFIN} Pieces to their original positions, so they can be there for when they come and get them the other times. Time travel is so confusing.","Um. Is this a doomed timeline? What happens if the ${Quest.PLAYER1} never returns those ${Quest.PHYSICALMCGUFFIN} Pieces? If they didn't return them then why were they there when they first found the lair? Fuck. You HATE time travel.")
            ], new DenizenReward(), QuestChainFeature.playerIsMagicalClass), Feature.HIGH)

            ..addFeature(new DenizenQuestChain("Destroy Timelines", [
                new Quest("The door to the ${Quest.DENIZEN}'s  lair is barred by a door locked with three identical missing ${Quest.PHYSICALMCGUFFIN} Pieces. A fourth is already inlaid in the door. The ${Quest.PLAYER1} prepares for a bullshit item collection quest. "),
                new Quest("The ${Quest.PLAYER1} is starting to get frustrated. No matter what they do they can't seem to find any more ${Quest.PHYSICALMCGUFFIN} Pieces. A ${Quest.CONSORT} asks if they have tried...TWISTING the way they look at things. This cryptic as fuck statement does not make the ${Quest.PLAYER1} any less frustrated."),
                new Quest("The ${Quest.PLAYER1} is ready to fucking give up. Fuck those ${Quest.PHYSICALMCGUFFIN} Pieces. In a flash of clocks and gears, three of their own doomed time clones warp in and hand them ${Quest.PHYSICALMCGUFFIN} Pieces. Oh. Huh. Well, fuck. The clones go off to die somewhere in piece. The ${Quest.PLAYER1} can now face the ${Quest.DENIZEN}. "),
                new DenizenFightQuest("The ${Quest.PLAYER1} is ready to fight the ${Quest.DENIZEN}. ","The sacrifices of the three doomed clones has not been in vain.","Welp. The ${Quest.PLAYER1} has managed to fail even the face of their three doomed clones' nobel sacrifice. Fuck.")
            ], new DenizenReward(), QuestChainFeature.playerIsDestructiveClass), Feature.HIGH)


            ..addFeature(new PostDenizenQuestChain("Shatter the Timeline", [
                new Quest("With the defeat of the ${Quest.DENIZEN}, ${Quest.PLAYER1} uncovers historical documents in a ruined consort village. Taking them to the ${Quest.CONSORT} leader, they inquire about the mysterious documents. The leader tells ${Quest.PLAYER1} about the Wars of ${Quest.MCGUFFIN} Metropolis. The ${Quest.CONSORT}s have been quaking in fear for years, waiting for a savior to reverse the events of the Wars. ${Quest.PLAYER1} agrees to help the ${Quest.CONSORT}s re-fight the Wars to win back their ${Quest.MCGUFFIN} Metropolis."),
                new Quest("Through some hard time-travel and shattering glass windows where needed, ${Quest.PLAYER1} has successfully set up events in the ${Quest.CONSORT}s favor. They check back in with the past ${Quest.CONSORT} leader to inform them that the timeline has been revised to their advantage."),
                new Quest("The ${Quest.PLAYER1} divulges to the ${Quest.CONSORT} leader that their enemy leader has been assassinated (through their own marvelous work, of course). The ${Quest.CONSORT} leader doesnt believe them, though. Why wouldnt they believe the time-traveler?! They launch a miserable failure of a counter-attack, resulting in the ${Quest.CONSORT}s defeat. Agh!"),
                new Quest("The ${Quest.PLAYER1} is totally done with this bullshit. But they have an epiphany: what if they re-shattered the timeline, but took control of the strategy themselves? They grin to themselves as they travel back again, this time framing the enemy instead of assassinating them. This time, the leader believes the ${Quest.PLAYER1} this time, and carried through with their suggested strategy. With effort, ${Quest.MCGUFFIN} Metropolis is reclaimed, and the consorts have been given their freedom back!")
            ], new RandomReward(), QuestChainFeature.playerIsDestructiveClass), Feature.HIGH)



            ..addFeature(new DenizenQuestChain("Move Forwards, Never Stop", [
                new Quest("There is a babbling brook. A wizened ${Quest.CONSORT} is next to it. The water, he says, moves in only one direction. So, too, must we. The ${Quest.PLAYER1} contemplates this for a while. Is it really a true thing when this game has time travel in it?"),
                new Quest("Days in the past, but not many, the ${Quest.PLAYER1} is exploring. They find the babbling brook and the wizened ${Quest.CONSORT} yet again. He again says that the water flows in only one direction. Irrationally angry, the ${Quest.PLAYER1} yells that it's not true, that this is the second time he's met the wizened ${Quest.CONSORT}. The wizened ${Quest.CONSORT} simply ${Quest.CONSORTSOUND}s mysteriously.  "),
                new Quest("Days in the future, but not enough to catch up to the present, the ${Quest.PLAYER1} is exploring. When they find the babbling brook, the wizened ${Quest.CONSORT} brightens. 'Soon.' he says, 'you will understand that we move in only one direction.'  He gestures downstream 'So too, will you soon have our last conversation. Or, looking another way. Our first.'.  Huh. The ${Quest.PLAYER1} thinks they get it. Time travel or not, they do things in a linear order.  So does the wizened ${Quest.CONSORT}...even if it isn't the same order. "),
                new DenizenFightQuest("Inexorably, the ${Quest.PLAYER1} is back in the present but also far in the future. The wizened ${Quest.CONSORT} has just been slain by the ${Quest.DENIZEN}, mere minutes after their first/last conversation. The ${Quest.PLAYER1} took the consort's advice to heart.  They have been preparing for this fight for a long time, now, going ever forward, but not on the same path in time as everyone else. It is time. ","This was always going to happen.","It's a Time Paradox. Or is it? Did the ${Quest.PLAYER1} know they would be defeated? Did they fight anyways? ")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH); // end theme
    }
}
