import "../SBURBSim.dart";

//most of these are just so I can say "is this a type of npc" and not any real functionality
//might be the wrong way to do this. can refactor later. they will have more functionality as time goes on, tho.

class NPC extends GameEntity {
    NPC(String name, Session session) : super(name, session);

}

//carapaces are the only things that can be crowned and have it give anything but fraymotifs.
class Carapace extends NPC {

    int royaltyOpinion = 1;
    int sideLoyalty = 1;
    
    double activationChance = 0.01;
    double companionChance = 0.01;

    //what is their normal goal
    List<String> goalFlavors = new List<String>();
    //what do they do with the ring?
    List<String> crownFlavors = new List<String>();

    static String PROSPIT = "prospit";
    static String DERSE = "derse";

    bool royalty = false;

    List<String> firstNames;
    List<String> lastNames;
    List<String> ringFirstNames;
    List<String> ringLastNames;
    String type;


    //TYPE IS REQUIRED. don't try to make it a moon ref, because if moon blows up or combo session, i am still dersite.
    Carapace(String name, Session session, String this.type, {this.firstNames: null, this.lastNames: null, this.ringFirstNames: null, this.ringLastNames: null}) : super(name, session) {
        if(firstNames == null) firstNames = <String>[];
        if(lastNames == null) lastNames = <String>[];
        if(ringFirstNames == null) ringFirstNames = new List<String>.from(firstNames);
        if(ringLastNames == null) ringLastNames = new List<String>.from(lastNames);
        if(name == null) pickName(); //if you already have a name, don't pick one.
    }

    @override
    String title() {
        return "$name ($initials)";
    }


    @override
    void processCardFor() {
        // if(initials == "DP") storeCard("");
        //  //HI!!!  You're following along at home, right?   Let's not spoil the surprise ;) ;) ;)
        //(Not that you, if this is still before 4/1, know just what the surpise is ;) ;) ;) )
        if(initials == "AD") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAm2DmABAIIAiIANCFgIYC2SqA4hIQOoJgAuFhAQlC78EhGlhJgwACwgAbJFS4IAHlxQhCEAO5YEMBLQYxCXGDQBuCWWEJbOQrRi5STUhBmMAzehlkBPADpCQgAVNz9CAAdBQgRLGD8IXU1xbhoYcxouDCTCM2ykmzEcPIRPKDARLlYAIygIsT9nAkI6oTrZeS4wILCECLh0hJT-QgBGAAYJqOhcGwhPQgYs1po4AGtbJxdnBDpRTyVjKSgsbKwiTwhj6Bgi3CWIblGuwidRTryILiDQ8NF9KJCCd8CIaJIZPIApQQDU1ut8DBZjgAHL0RggACSYDCGDAAGUpE4uH4AKJYaD4KQAKQASgFIhcYaYMPhQTAAMJSMSIdQTAIAVhhYEQuhxEAAqlhZBANuoANoAXRh+jAUFk3XxXCyYAVwAAOtR0YbkIbiPj8QAJADyABlSbSAJqGiiGzKyKAIE2GyaGgC+ysUMFZ7K1OttnEqMD1hsMXpQho51oAssmHRzSS63TQPfHTSAAGz+wMgFlsvRh7pMfRZPQKktl0Pa7qkgCOUBz9ZAfqAA");
        if(initials == "HP") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAm2DmABABIAKIANCFgIYC2SqAcgKIDiAggCouFfEB5LpRAAXBAA9RKEIQgB3LAhgJaDGIRU0ANhgBeCMIVEALBAE9CNFYQBGCAoXk1LoiBEJ0ocE3IBmVsYmEKIAdIQAMt4A1hjarmaW0VgKhMHyxh6snDyEGGEitjRw0fgw0LhM9Iwg2dws-EKhAA5Y+CKiMBj4+MoAwiY0WIgyAAyhAKwiYIhKYFwQAKpY2hAlMgDaALoiKmBQ2qJgAMqiNEebwAA61NU3yDeNXDcUNwBuOlAI9zcAtAAcNwAvjsqJ1ur0YKdzmAIoYwMpNqCxF0espoUc2FpxDBLjc1N8UI9BM9KO9PoSHiAAIzA5HgtFQs5HFgARygOiRICBQA");
        if(initials == "CD") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAm2DmABAMIAiIANCFgIYC2SqA4ggC6EDKdEANpSKwQAPVihABJQjghYA5OwDWWCAHdCAC1WFW6hIUKqsCGAloMYGMIXxtWBQpE7ceAOkIBZGgE8ARnoysslY6CBgwnADqAKJRACqEpACCAHLEUR4A8gBqURwA-AX8PjRwCvgw0LjJ9IwgHOoBrF44NFiIAA40ME0u7Vj4-KwW+DYwxOqtiGIADC4ArPxgiEZgsRAAqlg8EKViANrAADrg0PAIx8jHLtfHFMdm5yjHAEJ6ANL2z1BYt8eCIhdjgYVEYTA9wpZCMo1DwEGBghMsIQAIwuaaEABSACUrD4MPgKIRWjhtOooAj3p9vm5YrovESTNYMAA3UxEwgAM0m9M05L0rAghEQsJ8MBoglJoXCRjUYFY4vJLl+IGKpXKlRw1QYgJATAgEBwniwYAwMl6-WVQ3xo3Gk0elxAszmyqWpjha0221KOr2AF1lSYwFAeKwwBx5aGfUdDvcajHATGQLlYjF3PHKOnmTQeFBzonLomAMzpgC+-ozAmGo3D4rAABk4WBjD7y3dK9bjDXQ0wTOLm08QAd0w90wXjhx3Bk68lchxCABFdYZWLiKLJWLpu6JrM5vMJ44AFlLrb+Vc7EbAUQAjlBsy3jmX+IHg6Gu2B9kdqHGBxOpzOOHOi7Lqu67KjuuY6siD6+oMZ4wG+DbwsY+wwVQVojOetY9ggfYwChsEdvBF7XrefCoH6IAlkAA");
        if(initials == "BE") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAm2DmABAEICiIANCFgIYC2SqxChAygtgGYIA2OAnpRAAXBAA9hKEIQgB3LAhgJaDGIVkIaMMIQAOPGhhwA6QgEFchANYALGlYxhTFnITgQw+mvx01CAIxo+NxpdUwBJYQByJ0IAJV4MfAxoMAB+QgBNaEJhG2wrDLYIBmEMBh1+HNkIXEV1O2idfAgCGSxCbFybDjUemhMhQLgrfBhoXAA5ekYQAGEMYX5jXSx8IWEYJPxFObssRCkABmMAViEwRAUwABUIAFUsHggRqQBtAF0hJTAoHmEwKxhDQAe9gAAdagzSHISGsUjhSZocKkAAyABE2HMzKizABxUiQiiQgBuQSgCBhkIAjJCAL5fKibbaKIEgsCohBgMCKd6MkRbfA7GBsgF4pQg3moT4bQXC0VgUgARygQT5IDpQA");
        if(initials == "MD") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAmACAWQBEQAaELAQwFslUBRADwAcEYNasAXPAQQHNK2MDwDiEfJVyEpZEFwSMuKEHggB3LGwRVaMPNUoBrBGDyUARhGrZKXDBCxnKg4TytcAFnjBwMOxHNpQywAOjwATWhQmMoYBDx4ygAbZIBPPCwIHjBYBOSOC2d4nyhmZggwBHwuCDwcOq8MMFC5C0o4I34YaFwAORo6EAAJSuYMLhSLatDmLH45LnZ+fjYAYU8pRBUABlCAVjlfHVMAFQgAVSxkiE6VAG0AXTl43OSuMABlSY+H4AAdCiDQHIQFrADyACVIRcAAqnACS4L6eAh9DQaARawR9D6p0BpEBADcUlAECDAQBGQEAX2e5CWGBWbG+djAABlTFUYA96fJlqsYKyPqIkgoeah7gCgbQKSAAEKQ3gIvoI04XIj0AnE0nklCAgDMtL5jOZQp+YHoAEcoCleSAaUA");
        if(initials == "PS") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAmACABQGUQAaELAQwFslUjKww9JaIsE8AXCPHBSlwAWAOjIguCAB5cUIPBADuHGAiq0YLRmATNWCdp0h4hlGPmEIAnngA2GSTEq3bNnBgQi8AdSVfxAEaUcADWAOYw0LgAcjR0IEQQbBxoUKHYACIeOCIADlhh4lwwGGFhCDAAwqZYiHIADCIArOJgiBxgACoQAKpYthChcgDaALriqmBQtlxgRFyCYCPAADoUcWvIa0QAggBKlTtEnQCSnT0ZAKJrpGsAbs5QCJtrAGxrAL7j5MWl5TDzRYAGV0OhgI2+EhKZQqgNmAHFVIIKhCitD-nCwJcAI5QZyoj5AA");
        if(initials == "AC") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAmACAQQGEQAaELAQwFslUAZDAFwRkoBt2BPPBSpvDAhwA1mDIgWADyYoQeCAHcsrBFVow8GMHnbNWHbr37YA5oOFiAdHgAqEPKYQCARhlNOYNgJJMfAmD5OHhwIBDAsAHIBakoRBDxKLB4wNVSrCRdKUVMhKFwAORo6EAAFVhErAAcsUwkmGHdPIgALJMQ5AAYrAFYJMEQVMHsAVSx2SzkAbQBdCUCwKHYmMABlJn5xVCngAB0KYv3kfYBxbwAlWwAJfdJ9gDcOKAQj-YBGfYBfOfIGptZ1pt6OFUjBpj9JI0PACNisToF+KxwfUoZ5ASsAKIARygHGRnyAA");
        if(initials == "AR") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAm2DmABAIIBKIANCFgIYC2SqA4hIQC6tsAWChAygBt6DGJRBsEADzYoQhCAHcsCGAlojCYAA5qcYQjU1sYNLPgQCAnoShYGdCCYBGA3lgz4ubeVG8Qs7DzsigGmOIQKNADWCPpQWoTYgbx8ADLEALIZAKKkAHSEAJJsAOT6Clw03gq8cDQCAonVPAE1BqqEUsaGpvgw1lWEcDAYDGB5Yk40cFF90LgAcvSMIIL0AFL0a3QAIrZRBAAqPNsieVpmYsYe5jAAwpVYiLIADHkArGJgiMpghxAAVSwAggM1kAG0ALpiVRgKACNhgPhsKpgCHAAA61GWWOQWLQALuAGlCocATtcncAPIA0h8bJYihYgBu9SgCFxWIAbABOLEAX2hVGu+FuyNRqViYBUEKF4hGopU4sRTFUVRlqChVwVYpRiOyAEcoPVZSB+UA");
        if(initials == "NB") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAmACAOQCEQAaELAQwFslUARGbAazwGUI8BZKOACzwBhCADMRCJOQAuCAB5SUIPBADuWBDARVaMPBjB4cTLM2wBzPJTwAZAPIAVZSLxxR4hADo8ATWh5TuE54KhC4GnrOUnwIAJ7BGAA2CXgIAG7hYFIQAA54qRgARjCUUuYeZCAFlHDMZjDQuAQ0dCCCGFIxHtlYZhVSTGZmGoJ8lFiIigAMHgCsFWCI6mD2EACqWAkQNYoA2gC6FZpgUAlSYGxSJWC7wAA6FM33yPeCAIJoaACSBK-2n7YEe6ke6pSgJKAIJ73ACM9wAvgdpAMhjALldrAgwGANLtESB+hhBho0WcAOKaEo41D7PrI4mXM4AUQAjlAwbiQHCgA");
        if(initials == "PI") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAmACABQEkQAaELAQwFslUAhBPAQQBsEYAXMkThAD26o8EAO5YOCKrRh4MYPAAsAngAcOeSuy6bceBADcNBjAHMMrSlk4A6PHgByETouym8phJwWrKYTnguCBiy-pQwCHYAKooIypoR+kZYeOzhWG6BEHgARqzYANZ4YFDqsgBmfgGc2dTYGHUAXkxBgQ1MYOrWeKKUnHCuWO6tohAwrPiiGC6BsSF4OPJwEFiIXJkQpuw2PDmUcAWmMNC4DjR0IADC08o2qkM8nDBmnjCXilaIKCAADDYArDwwIgJGAohAAKpYVgQA7fADaAF0eBESqxvABlTh9MAI4AAHQo50JyEJ9AAMkQHABpPAYggAUQZABFCaRCQYtFAECTCQBGQkAX2R5CeLw4WJx5IQYDAHARIt4z1Mr0l3gA4hE+vLUEjHsrVdjvAyAI5QLQKkCCoA");
        if(initials =="DD") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAm2DmABACLEgA0IWAhgLZKoAS1ALgoQKIBuCMAniwAWBCiDYAPFihCEIAdyy8ENejADkYQoNbttmsHGgwEOQnAA2CaotNCM+hHBYYIWWQDNCQ9h2owhAHSiAEbUcADW+DDQuABydAwgAIKhuK5J5uaMEAAOCACyAJIBOVj4oiwwGPj4vADC2liI0gAMAQCsogbKCGAAKhAAqljmEBHSANoAuqLGYFDmLGAAyiysYJPAADpUCTvIOwDy+bGFADKHSX2MhbEA4jvkO1zU5lAI+zsAjDsAvjOUSrVWowVbrM69MC8SYAsRVGq8MFLO7GHQwGEVeEgpFgDgARygrwxvyAA");
        if(initials == "HD") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAm2DmABABIAiIANCFgIYC2SqAQgoQMIAWNALtwJ6UQ3BAA9uKEIQgB3LAhgJaDGITAAHRTjCEahADYRuUgGaFuGBoThdeBQtIzcOq7jBpZ887Tx2E1NGH4AOkEAIxo4AGt8GGhcADl6RhAAZQ5Hfhx3RH9AviC1D0FXDHxPGE5s5IAGIIBWQTBEOTAAFQgAVSwDKIkAbQBdQQUwKD1uMBTuHjB+4AAdaiTF5EWUgFEUgEUOgEkABXXSAEEAGV3j+MJTgHkd47Zdm46U+M2UxYpFgDcaPSgECtFgBGRYAXyGVBKZXkUxmpwQYDA8n6kKEMFK5ThEwA4goeCjUINihiYTBsWB1gBHKB-VEgMFAA");
        if(initials == "RB") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAm2DmABAEoBCIANCFgIYC2SqAKgnQA4A2NALgoQMqIsSKrwAe3FCEIQA7sJgJaDGIVk1cCGGELcAFnwDqNMLzAVCGOjXzYChGhw66DhAGYQIOFwgCehOGgObzA9CAA3PmxuCBl9LXdPHDAAOkJKEAAjGjgAa3wYaFwAOXpGEABBbNwILAqnAAkINgQAWQBJFLYsfAzuGAx8fC0AYT0NRCkABhSAVgywIQQwJggAVSwOCDypAG0AXQzFMCgObjB+bh4wPeAAHWoyh+QHpjXiABE1kYBpAFFigB5EbtJgATQeFAe4UcUAQzweAEYHgBfQ6iAZDLSXa4AGWWYC0tweynhKAeI0BrVaf2IIz+kOhsLJLxAABZUeiQP1BsMYDjzgBxRQ8ImoA59TF8gVgP4ARygjj2hxRQA");
        if(initials == "YD") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAm2DmABAJoAiIANCFgIYC2SqA4ggC6EAqNANt5SKwQAPVihAA5CADpOACxrscEBGEIZWMgJIByOoTg9uBQgAkaQmR1kJChCAHcsCGAloMY+mlm3sAVlDB2fDZCVkNnOyh2CAAzQiwHaxcAQkJNRWUwb3Z7CBgAa0IjfJtWeQ1CAFkEPANuQjA4DFdENVUAIxoYmO4aqX5OuHz8GGhccXpGEBMIMAAHdR52vrmsfH5WGAx8YJgAYXksRDEABikAVn5G1xUOCABVLG4IIbEAbWAAHXBoeARv5DfKTA74Ub5uf4ob4sdikKBYEo4QgAeSwoO+ghEAO+kks5W0qnUeIwhMJWDAXgQMgcThcEI8JM4yORnAAggAZdlaXSEGgwFyBYxlBB6GJ5Nmcwh7ABKmkqAFEAMq83ChawAT08WAac1cSOFhAF0TiwowHhwNHVZLVNkV7NZlQV0sISmMdodhFI93EAGllfZ1LIbYaVMbg2FeIQ5nNuDI5AhNXgbNgbS4KIQEAA3VysKCGdVSdEgQbDUbwnATBjYkCK7j0ABS9Fr9DhCIIVgQzbo7ikq3wRc2212By8iGrZwAnEXrk4wHdHs8htW3gBdIsCqDcVhgRVhbfLr6fcGTI-Yo8gdmaNBK1n3Pby0+UR+ZnhQf7nwHngCMJ0fAF900PY8qw-R9WSYB9zzBc8X24N9H0-b4v3Of81yfAQth2ZxdwUMB2RUMBnGXNCwQwodsL3MAmBcBQiKhEAPkfCEEMfDgOXZcQlWVABFe5kQ4TR5XEDhH2g75YPg0DzxQ88-xIjFMN2HDt3lABHPNuGI745P4Dctx3Sj3i+agT3otjOU4xUeL4gShJE9CJMhQEQC-bSVw2RSKNw-CwEImB3ncqhBywmBlKomjBH81BVw88jQsotSNICkA-yAA");
        if(initials == "MP") storeCard("N4Igzg9grgTgxgUxALhAMwJYDsAm2DmABALJgB0hACgIbYAuIANCFtQLZKoAqCbADgBtqdBIQDKiLEmYiAHg1SEIAdykwErDjEIA3CAKhYRCGGELDCdABaiAEhDB8MdagMaXqAawKE41dUpohGAYcJ6EfAgQgghkTCAARtRh+DDQuABy7Jwg9o7OrgkIOGR8WPjxdDAY+PgmAMJW1FiIKCAADGQArPFgkghgXBAAqlgCEGFtANoAuvHqYFACdGBiLivTwAA6LNk7yDuUAIJcAJIAohn15zuMOzquUAj7OwCMOwC+czLVtSZrwjAABkBmATNNviAqjU6jAASsAOLqYTg1CzSq-WHwsDnACOUFcEJAHyAA");
        if(initials == "PM") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAm2DmABAAoCyIANCFgIYC2SqAKgnQA4A2NALgoQMqIsSKrwAe3FCEIQA7sJgJaDGIQxhCkQhwhhuAOkJMAFggCehGmADWmiA20Q4NDhpq5C+BN0JsI2Xhw1LEJuU0IYDHxjHzxFOG4MCCxDE3NPb0ttDG5uDj4AI29eVR5CWgA3KJ4CfUoQApo4a3wYaFwAOXpGEABhHLN9Nix8eu5I-C8YXuN3RCkABn0AVnqwIQQwJggAVSwdZqkAbQBdesUwKA5uMH5uHjBj4AAdam7X5FeAEQBJACUAKK9Jg-ADyHVeFFeFRcUAQH1eAEZXgBfM6iCZTO4PAAymzACBgT1eynhKG+-yBIPBkOhsLJnxAiIWqPRIHGUSx9xuAHFFDxCcc2RzJoTsTcAQBHKAuIUgFFAA");
        if(initials == "MK") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAm2DmABALIDSIANCFgIYC2SqAKgnQA4A2NALgoQMqIsSKrwAe3FCEIQA7sJgJaDGIQxhCAKyhhuAOhI0wYDADcEBgJLcA5Buxg2GGAQqFFNDhwCebgBZy7hhsbAg4hNx+CN6ENIoGABKBdDpwHAgARtC4VrYabDAQGTQZPoS03LCebjS45RDcsY2eHO4IXLzh3BARfuqEdN66CC7QGjA02FmyhDhQ3NzpvdGEAGbZ4T4EMljLhPiFUDmEAJrQWjqNAaHLMTgQWDaNHBgA1ghucDQ6fDSEpTQ4K9CAElhBVJAGJECHpKCBikCDhsAHL0RggJhRABKSgyUAAIvNulg9GwsPg4dwXPh8CMAMJ+WqIKQABj0AFY4WAhAgwEwIABVLAcCBAqQAbWAAB1wNB4AgZcgZXoVTKKDLlAqUDK6d8wL9CAAhLhAwhJMGqfgQKF9cl6NUy8TcRUygV+AwAdQCEDYYAMmL4MnkIyUaNU-UganYimMZnaMToRhM5l6PFuNhTXx+4T+ANNoIshAA8hDrQhoXbTtAbIp6o0PF4YmBYIWAzE4konrMEDQugEoPh3VWoPsoLy-SqVYQAPyzh3wwGvJFHHCohgukAAFhZm7YNFpGQQWf1R7g7rJ+HnVIwNPpjKwiA3bIATABGefcpS8-lCkVAjfigAuvOMZQBw3BgPw3A8GAAHSlKGpoghLoISA-AAIoCpY+L4gAMgAovw+HIkRyGUGRpieGOZFKqhz5kQAvsB5EgNet4wFBMG4eOIwAcx6qsdStIcdBEEAOIeLwMBwWRmo0WRxAAIJicilhMAKTD4vhZHqqhlEcNRqG0TKABsjH8Y6QkjJxEH4QAjlAnh8TKTFwqB4GQaJYAStK1BIdqIBKSpakaVp876dRAWviyLmAZSVkiVxPEwBKcWiAlNlgBJPZSal8U3sJmX2Y5HB5QxQA");
        if(initials == "ZC") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAm2DmABAFoDCIANCFgIYC2SqA4hAC6s2EuFo1iuUQrBAA8BqQhADuWBDAS0GMQgAcYNOKwyIwhGFCxYChbIU4AbCHBrnCABRowA1gDpChAJKsA5LqOJJKFY3ABUACzkEX0IAIwwYHDAXQRiNJ3wYaFwAOXpGEDs5VxUsfEFWGAx8fDlSMJosRBQQAAYXAFZBMERZMBCIAFUsSzgnZoBtAF1BeTAoc1YwAGUORYngAB1qPK3kLaW7AFFDgBEtii2ANxsoBF2tgEYtgF9pqgqqmpgVmkWAGQQYDAcgmbyElWqch+iyY8l+INQU3KEK+0LAhwAjlAbKCQM8gA");
        if(initials == "SU") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAm2DmABAMoCqIANCFgIYC2SqAKgnQA4A2NALgiYliRVeAD24oQhCAHdBMBLQYxCGMITrY8WItwAWCDMplZCAIyhhsCMGohYOVwtP0nIDQjRu6IHPgxs0+Hx6rBQeYADWBIQhdDEQhBwQEBGEUGwehABMAKwAbCK5eYRsGHDcsHwQAGaZTN50njH6hEw0WKkAotqOcLo0MDTlCDBq1UMIAHSEMwASULqTlCCmQxH4MNC4AHL0jCAA6t5g9aoAgl4+U2zay9wwGPhBMADC-ViIEgAMkznLYAJrEwIKR7BA4BEJABtAC6y3kYCgHG4YGI3B4YGhwAAOtQ9rjkLiioQRNl8riKLiAG40DhQBAE3EARgALCzcQBfOHCB5PEZojEAGWsYBG0O5IHuj2eApRAHF5DwxahYXdeTL0SjOgBHKC08UgDlAA");
        if(initials == "HB") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAmACACQCEQAaELAQwFslUiE8AXAC0YIhjAVLwHUElGMzZ4AShhwIYZEEwQAPJihB4IAdyzSEVWsIxg8AKyhgmeLBrwAbDPJiVr1gJ55KhTtwB0eAKosfABU2VzMMJxsICABrEUYwGgQfIihzVgRXIUZ3Fk8kvDwAKVMmHzEICPU7Fjw7HwB5aMpnAH5ZACNKOGiAcxhoXAA5RJUATUdrAGlLdT4WSiZAjFoASSYVsC8ABywe2SYYDB6e6QBheaxEFQBGLwAGWTBELTBAiF8sawhulQBtAF1ZDAEGAoNYmGAAMpMBZgP7AAA6FESSOQSII9TEkIAokjSEiAG6OKAIVFIgAcSIAvoDyAcjicYNDYQAZEHcGSoAH7Q7HaTMiEAcWBC2kf1pcl5jIFYGxAEcoI5xSAqUA");
        if(initials == "SS") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAm2DmABAMrEgA0IWAhgLZKoBCUYA1hSAC4IAenKIQhADuWBDAQ16MQgAdxAMwgxaYQmE4SEnQrWr4McQtVy6Wh6gBtjcTmHKF81bAWOduWThghYhCwpwAFgiEwiY44q56YGAIYAB0HABG1HCs+DDQuABydAwgAArirPGyWPgcmhj4+OIAwoEmiAIADPEArBxgiGJgACoQAKpYlhBpAgDaALocEmBQlnbEnNR2k8AAOlR5W8hbaACCALIAolvkWwBuVlAIu1sAjFsAvg6b2-T3IHUA8kenACU6mcKFcbncUI8XjNKFUauJlqswAAZOKxGCTGFcGDVWowRF2ADiElW4kxlRx8PxKzsJwAjlArOTnkA");
        if(initials == "GN") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAm2DmABAOIByIANCFgIYC2SqAMgjTFoQMoYA2CWiSiAAuCAB7CUIQhADuWBDH71FhPmyxhCwiIVk0eAa0IA3RQE8KhAGoBRAEoBNQgEcoGBMJ7ntumiYgMHD0aQwJCKAAHbQALBEI6GiwfJOCTNgxoLSSMRJ5s4Vj4gC0IXR4aUUJKwiwMfBjhADohACMaOEN8GGhcUhUpABU4zigsThiDHk46DFFHaAAJVmE4rCbIrHwhYRh6-EUAYUmBRhAABiaAViEwRAUwQYgAVSweCE6pAG1gAB1waDwBD-ZD-Jrg-4Uf60Bgg-4AIXimAUwQAZhAYIRSrpDnsGGBIf9RBI4dI5AolDDVBgtKjsAhgnF-LwUrhCJEoK0eBg4N5CGBJgw0Rj+QpQuFsDpCAAvMpaCpVGp1BqFKVgBA8HjVOp5LQQDireJcjrGRIwQyeJqEkDtTrdXo4fqwlD-YYIUbjSaamZzBALKDLSprDZba27fZHE6IUmXABMAGZrXd+AhHi83h9DKSvgBda1KMBQHjCMCcYSVAkukA-X616gqWtwuu2TiDWy2ACyjco3fSPCgwLroLrAFpY92AL5WP51qnd4f-Q4AeQ7HYch1s3ahdb7A-n3ZHADZJ3meyI9vgDjAyxWWGB1TBs6eoeeI9fyyXiEpKoon2GL1eN4lrYbgGH+IATjmQgFkWJZAWA3x-PWzqgiAACKzwAJK2IMzwACKbmeu7AlWACM-yQTsAGKPBd4Pt8UFUOGl40R+YBfisigMVRb7wSBUAGNxE5AA");
        if(initials == "ME") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAmACAWQFEQAaELAQwFslUBBLLCATzwBcALBPAEQLIh2CAB7sUIAKqcAdHgASUWXgDyAa0os58iAHc8ODDgD8eAOqUM7PLqucO3PABlKurHgDizWmFMA5CBkAHSwQtCg4NQcMMDkASTwYBAAzKDAedgg8ZIgAG1y9aLA8AAcC6y4kynxKLBZqCCS5PD0sBCSqWhg8ACs06zUMfIR8AHMIfEa8SFppzit4gwgsAHJrBAA3BHc1Zl05RnwrPEp8vGpqnnSsdLxsPDhOShhKOGEYUxCQuLkAKX65OFIkU8KMaAg5AAlCCRYrJU65Uh4FpudrbcHdQwIWKCABGrzUoxg0FwfnBEgAyhBaMsEEDBlheBgRjISlhRoJ2DAMKNRu0AMJPLCICQABhkAGYAEyCMCINpgAAqEEkWAKkQkAG0ALqCJJgKC5dhgCnsSjGrXAIIUcHW5DW+REPy8IiQikqPx4Cn8+hOOJ+DzW0jWjanKAIO3WgCM1oAvkirTbaJGQH60EQKfRJPyiEGQ2GIyhrQBaKOiuO68hcnl8mCm81gJzY9IwLWVoTc3ntevGjxVd5tzmd2s9sBEACOUFOg9jQA");
        if(initials == "CI") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAm2DmABAMICSIANCFgIYC2SqAQgiTAjQC4YBuSVnBAA9OKEIQgB3LAna0GMQgFkacfAE8+MAORhCnABYIMiyTXUSonTjUK2YGPHCgAbaHrAJOEgGaE4Js50YDZYiHpQYAQSWC4Wtj7QWDbYhAAOCFgUdoQARjS4NI52uPoG7KwhGHAA1noQfvhQdAB0lCD5tfgwSTgAcvSMIAAquQbDBhhgAOo0YAAKAKJz6gDKTACqAEpMLWlY+O2cDvj4ssQGBYhiAAwtAEztYIgyYMMQG7EQtWIA2gC67XYYFcnDAqxsYL+wAAOtRBnDkHCAOIbJTzYakADyfThFDhPBoLigCERcIAjHCAL7ZWHwhhkkCLVbDRaLJR4glEkmMykgKmAgQnM4wCFcMAAGQQYE8MD+gpAxwwp1kYrByPYXFk8qOwtVkLAiwAjlAiTqqUA");
        if(initials == "JS") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAm2DmABAFIDKIANCFgIYC2SqAMgjTFgYaQjlHAC4YIWSiH4IAHvxQhCEAO5YEMBLQYxCAG1bswhfgAsEhAIIx+cgGZcefQcMKWYEOoRqEA6hgBeqnnM0cQjoaMHEYADpRACMaOABrfGcoXAA5ekYQABUDDDAASTAmCAA3BHyAcSgEMDAIgAcsfFF+GAx8fGUAYQMaLEQZAAYIgFZRMEQlMCyIAFUsTQgEmQBtAF1RFTAoTX4wUn4aPdXgAB1qDPPkc6yACQB5LPOKc5KaTWqr84BGc4BfCiEM4XBhfEAAJXuAFkutCoQBRcEATWer3enxQP3+GyorXanRgByORRqYGUJ3OagQYIACiZwfDUllwfksrMACLw1EgN4famYkC-EB-HFiNodZREvYVFRHcmodYtcUEqVgeEARyg71WGz+QA");
        if(initials == "EA") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAm2DmABAKICCIANCFgIYC2SqACgjAGYQx2EAiNMAa0IAlDABcoNADZhKIMQgAeYlCEIQA7llYJaDGIQAOrDlzCEc-IaInTzNXIQDKNODAxsMic9nUwcrIRiEIT8Yh5eGNJSAJ6ESgqOYgAWCBgGmliEADIeCAB0hAAqqTAIhBjmWCEaNHEplYRwDoTJNABu5VBY2IkBOE0QWGAIAI5Qut75cgBGrgL4MNC4AHL0jCAINGAKMPkAVob4cmLu+PisAMJtWIiqAAz5AKxyYIjaYEUQAKpYUhBwASqADawAAOuBoPAEBDkBD8giIRQIXoYSgIQAJDrlX69XT9QiXIYjcaTBBgJEQhTKWEQwgAeWShHwEBwhUyOlRBjg0CkA2qYiMEDAYAwM1irWxhFMI10QVSI0GwzGE1u5MKJXKAHEyjRBfS+QyPpLOoQZgg5d0pFswKkBkMSGFkhRCAIMFIpAR4p0YDEhuUHAMED76skCPlKSA5oDFsscGsGLSQEUMQBJJzptCplbEfKGLD4SOnDDnK43RBJx4ANirkbeunJX1+-0BSeBAF1I2UwFApGIwE4xHqKeiQKCwRPqOsJ7TJ9lU2hiE5SN9LsQZ5QN+1pBMN3DJwBaACM9w3AF8XeDJ6i9xvSFr15PkZPt1Jd5P9xCj09z5eNzePw3JwmHpekAGkN2fCFX3fWcv1PScz07Td5DOC4YEHYdsnJEYYDbZDkVQkt0Mw-sdS2XY2yvFFp0AycACFslIYCMWIABZekAA0AE1IK3HcYTor9zwIqk0NYUiwGIcZpHwiEkLkbte37SSQXBKdE1HedF2XVd1xQmC0ThEAT3kv8NKMiF730wjDKTY8fxAC9CHUm9R0Y5imFYjieMjOzRxrWsnPbE5xIwod+2wkVWBBEKqGLUtwuHci9Ri1AO1C4iJIiqSZKkWKnKAA");
        if(initials == "WV") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAm2DmABAOoBqIANCFgIYC2SqA4hIQCqsDCEANjwviRUALggAewlCEIQA7lgQwEtBjEL4ICMIWGs4vfoJ2tBwwnQhLCAayxz+OQQDpKIAEY041-DGi4AcvSMIADK1lD8TgAOWPiuwjAY+IIwnAAWNFiIUgAMTgCsrmCICmAcAKpYPBBeUgDawAA64NDwCM3IzU7dzRTNKu0ozQBCCOzKsAg4vc2iEh3NMvKKykFqspbW2jTbOhNKOIQACr4AZlqQajRmNIRRSmDCSRjQ2lBYGABuimAYwgCeTkIM3cnm8vneOECDAWoXCkRi+BBCSSKXSmUQsLy+RBxWUWgqVRq1lhdQAuiCHhFhGAQsJrmBSU1Gv0giyFiyQABREJsLlcgCy7Mows+NB4UHanM6nIAzMKAL4UQjM1kw6XCzgAeQFAq5ACVOFzhX1OWKJVKOc0AEyKikikAo5KKOkMgAyF0UTOFA2FMpG+oAggBJfzBtjlAAixs5pua5slfuFAEYcnbkYlnTBXTSmEprl6hiByRnUS76TSuQBHKDi0n2hVk1xUng0nNgepNahsovDIOh8NR40OhODTogZPNJUqtVj5ra3UGo0g0ewgC0k5AjfimZS7Y9YDAik7s9hfZDYYj0ZX4sTRdTU6bIl35YZeYQBZg9Sfjpf2YrYDVrWPDfluQA");
        if(initials == "KB") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAm2DmABANIY6EBCEGIANCFgIYC2SqFCAZjBgroY0IBlAI5QMMGAgA2dEABcEAD3koQEAO5YEUpqxiE+caFkUwwAwmDESp0gLTSMAawQCnfAHSFCASXmEGoymFoI8OG7yEITyABZuAG5kCNG68ozSVlFS3oQAFABqyal86Zlg2QgWFRjSmcoYFYQARghwjFBgbhgBjTHxhACeCIwGAEwADBNjAJS5ACoD1uKSMhjBhDgQVYRYEAFBppbh3ViW7TC0hD2BwfKhhCeEEGea2rosOgDk1bHQ0hEYLkhNhEP1EsVHqUMlkIFJrtUEAkdDDmLUdowgoNwVYbKsnBt8Ah7sdks9XlodHxPjAflY-lAATprlgwGS3lS9N8LBcFrE+lsdnsAs19vEDHE3MtbGtgp45M1GHBnPgYCYcAA5T5qRZqjSLBAAYXiVQQngADlh8HJ5Dx8ESYMbgog1BNPABWORgRDaMDzCAAVSw0ggyrUAG0ALpyKRgRn3ITpe4R4AAHQYn3TyHTQgAigHfAARQsAGQAokIyxrK+naOmEhkoAgs+mAIzpgC+0fotow9p0icY9xLVS6MAj3YUdodg-uAHEpEOdBObdOB0mwGWxBkVx2gA");
        if(initials == "SI") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAm2DmABAMoCSIANCFgIYC2SqA4ggC6FM1iUisIAerFOgwAbUQUIBPaDEJwacgO4ZWAC0L4uECVgSEMYQnzzQj2TRAg5CShDXUI5NXAZgxVDyRYAOV5faOMAB0hIQQSnowCLQMcqJWANZGAGYQMEqKNqwQxmr6CKIIcKwecIQpUKyw+kr5WAbsrDSJCEaQhAlYRDmE0ZWFefoKcuoO0tCEajQAbvpYuXBqEBiIhABGVca5+LnYYBg4+jTyEHRpMKwAtHAQWKU6RTYpNHBiqlK2amL6MlC2NFUhAAzAAGK4ANlBhDo2CqbQq6SG8kU2z6CAGolChAA6oDWNiACrTdiQKC4Ix8dwYdZFbFoKBwRJ5caVarRYI8davRL4GDQXAAOXojBAAGEPsEfN0eKUMPh8E4xdMsIhhKDggBWHhgRB6MCEiAAVSwCSZwgA2gBdHjRMBQUSsMDEZpOy3AAA61BFXuQXoACgBBQmkACigrFoa9FC9MxooigCF9XquAEYvQBfCiET3ehjJkAAJVITAAEoTQwB5I3EQhoI2FgCa0dj8cTBfTIAzNqocoVThdDjAABk2mAnJae7wPP2YIOnUxog4J6hrbKZ4q566wKGAI5QeOTrtAA");
        if(initials == "PE") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAm2DmABAAoCiIANCFgIYC2SqxNAnoQMoAuUOCWnhADIQaWSiE4IAHpxQgAglgicAFghiEw3Xv0IAbEVkIAjDHr0B+QoQAqasAkKqCYTQgR0nEQnAgNCEEY0hHSBqnpsxjRgGGAAdNYQAO5Y6nz06oRJgbwwrkkqNAL4EDg49Eb4fBhQrqrQ+CoCGAJJ0YTBJaWEGLzBnN6cNADWjoEdhACsALR4+C2EvMYCBjQ4XoQAZlC4E7z4MO49QVsYCHrrqkUmNIcRhAAOrHVqhFCcZi1n8dYA8ioUQgwDCNTiAhZtF7XHDQOCvZABFJpWgMGDTTYwPzTABMAAYAIy4hKEACyHm8DARWgQND0Ew+-joNDh2EconWwwwcGGhBUsQ6YB+hEUHK5PNUbMFAU2TlecGi2G8USwnKwRGwOFqnBgbAKZkcSQQAHJDgETpjzHFxFFuQdoLgAHIZOQAdUC+D0CDdMGGcQeavE2pBVRgAGFClhEHIiZNxGBEKkwDYIABVLAGblyADaAF1xIcwFA9JwwFwimBs8AADrUDI15A10O-Ekk0gAJVDpBrFBrADdaVAEPWa9MAMw1gC+eaoQfwIbLJcECEF6mz04kwLn6gXYAA4ociqvUFnq7WGMOQLu2-IACKkUm-AAaAE1u32B0OUDXsZP17P50MJakAAjlAtJriAE5AA");
        if(initials == "DP") storeCard("N4Igzg9grgTgxgUxALhAMQJYDsAmACAEQAUQAaELAQwFslUBRADzgmuqiwwizJABcEjPihAQA7lgQwEVWjDwyWHATDB5KeMFK5QwAGwCemgBaUcRvRAgBrbAHM81CH2NSAZlDjWpeCG7faWA4aADrglHAwNDJ8Yb5ueABSlHZStBhgKuq4eABGMOKcCGAAdHh4ACrGGXg4EMV4WM6aCAjUeABuUkb0lJlSALR8fXwYcKTZ+C4QWnkFEhgN1Bh2xnyNzbkIeHoIdpR6eNjqeocArAAMmsMCpeUECHB62NsADhDPAoZleACCORgEi5KOs6g0musxBAYNYJjhHs9JHgxBgXHgmHxpLQ8ERpAArKA4MYIEq8XIRax2AocHAAOWiIgQIykJTxrzsvExK1SMAAwqYsIgRBcSgAOACcvDAiEkYAqEAAqlhLF4RABtAC6vGkYCgej4YAAyjcwOrgGFZAgwsgwgBJACyvwA4rbab8KraAPK0sKkMIdA5QK0oMIARjCAF8teQuXYecaQWAADLFLQwdXR-gwblSBMGp3SEFSDOc7Nx3Mm+gARygBzNFui1rtjpdbo93t9-sDwZtIAuka1EaAA");
    }


    void initRelationshipsAllies(Moon us) {
       // ;
        for(GameEntity g in us.associatedEntities) {
            if(g != this && g is Carapace) {
                Carapace c = g as Carapace;
                int value = sideLoyalty;
                if(g== us.king || g == us.queen) value += royaltyOpinion;
                relationships.add(new NPCRelationship(this, value, c));
            }
        }
        int value = sideLoyalty;
        value += royaltyOpinion;
        relationships.add(new NPCRelationship(this, value, us.king));
        relationships.add(new NPCRelationship(this, value, us.queen));
    }

    void initRelationshipsEnemies(Moon them) {
       // ;

        for(GameEntity g in them.associatedEntities) {
            if(g != this && g is Carapace) {
                Carapace c = g as Carapace;
                int value = -1*sideLoyalty;
                if(g== them.king || g == them.queen) value += -1*royaltyOpinion;
                relationships.add(new NPCRelationship(this, value, c));
            }
        }
        int value = -1*sideLoyalty;
        value += -1*royaltyOpinion;
        relationships.add(new NPCRelationship(this, value, them.king));
        relationships.add(new NPCRelationship(this, value, them.queen));
    }

    //this MIGHT be called early enought that custom sessions break this
    //this amuses me, like none of the npcs know who you are because you replaced the original players.
    //depending on how bad it is i might let it stay canon
    void initRelationshipsPlayers() {
        for(GameEntity g in session.players) {
            if(g != this && g is Carapace) {
                Carapace c = g as Carapace;
                relationships.add(new NPCRelationship(this, 1, c));
            }
        }
    }


    @override
    List<Fraymotif> get fraymotifsForDisplay {
        List<Fraymotif> ret = new List.from(fraymotifs);
        //;
        for(Item item in sylladex) {
            //;

            if(item is MagicalItem) {
                MagicalItem m = item as MagicalItem;
                //don't need to include other things
                //;
                ret.addAll(m.fraymotifs);
            }
        }
        return ret;
    }

    String get aliases {
        String ret = "";
        List<String> alts = new List<String>();
        if(initials == "JN") alts.add("Jack Noir");
        int max = firstNames.length;
        if(lastNames.length < firstNames.length) max = lastNames.length;

        for(int i = 0; i< max; i++) {
            alts.add("${firstNames[i]} ${lastNames[i]}");
        }

        max = ringFirstNames.length;
        if(ringLastNames.length < ringFirstNames.length) max = ringLastNames.length;

        for(int i = 0; i< max; i++) {
            alts.add("${ringFirstNames[i]} ${ringLastNames[i]}");
        }

        if(alts.length > 0)return turnArrayIntoHumanSentence(alts);
        return "No Aliases Found. This is probably a bug.";
    }

    void pickName() {
        if(crowned != null) {
            name = "${session.rand.pickFrom(ringFirstNames)} ${session.rand.pickFrom(ringLastNames)}";
        }else {
            name = "${session.rand.pickFrom(firstNames)} ${session.rand.pickFrom(lastNames)}";
        }
    }




    @override
    StatHolder createHolder() => new CarapaceStatHolder(this);
}

class Leprechaun extends NPC {
    //all names relate at least tangentially to their number
    static List<String> oneNames  = <String>["Itchy","Partridge","Ridge","Lonely","Yuno","Ace","Jan","Yan"];
    static List<String> twoNames  = <String>["Doze","Wei","Turtle","Dove","Matrix","Bull","Hands","Tan"];
    static List<String> threeNames  = <String>["Trace","Tree","Henry","Frenchie","Link","Hattrick","Charm","Tethera"];
    static List<String> fourNames  = <String>["Clover"];
    static List<String> fiveNames  = <String>["Fin","Rings","Goldboy","Plato","Sense","Byron","Johnny","Pimp"];
    static List<String> sixNames  = <String>["Die","Sez","Goose","Buzz","Juan","Seraph","Diamond","Sethera"];
    static List<String> sevenNames  = <String>["Crowbar"];
    static List<String> eightNames  = <String>["Snowman"];
    static List<String> nineNames  = <String>["Stitch","Nein","Lady","Dancer","Dragon","Muse","Cat","Dickory"];
    static List<String> tenNames  = <String>["Sawbuck","Diaz","Hamilton","Alexander","Leaper","Fingers","Neon","Dock"];
    static List<String> elevenNames  = <String>["Matchsticks","Amp","Piper","Rep","Salt","Rocket","Duck","Yan-a-dik"];
    static List<String> twelveNames  = <String>["Eggs","Dozer","Drummer","Killer","Magnum","Nerve","Solar","Tan-a-dik"];
    static List<String> thirteenNames  = <String>["Biscuits","Bakers","Jason","Curse","Emirp","Archimedes","Luna","Tethera-dik"];
    static List<String> fourteenNames  = <String>["Quarters","Chef","Shakespear","Cyber","Babylon","Osirus","Fortress","Pethera-dik"];
    static List<String> fifteenNames  = <String>["Cans","Pho","Quiche","Bonita","Mystic","Salute","Mandarin","Bumfit"];
    static List<String> infinityNames  = <String>["Flowers","Soy","Wasabi","Spot","Fido","Slasher","Paints","Researcher","Librarian","The House","Snake Eyes","Eyepatch","Shanks","Machette","Gums","Nose","Max","Mad","Wedge","Biggs","Big Daddy","Coins","Shadow","Undertaker","Numbers","Jalapeno","Hard","Cocktail","Sriracha","Kerburn","Sour","Doc","Hirohito","Barbeque","Tojo","Szechuan","Kestik","Sweet","Ketchup","Catsup"];
    static List<String> fakeDesc = <String>["Toad Goblin","Elf","Gnome","Puppet Person","Frogman","Leprechaun"];


    Leprechaun(String name, Session session) : super(name, session);


    static GameEntity getLeprechaunForPlayer(Player player) {
        //each leprechaun's name is based on how many leprechauns the player already has
        //if it's 8, instead return a Dersite Carapace
        //stats are based on number, too.
        int leprechaunsAlreadyObtained = 0;
        for(GameEntity g in player.companionsCopy) {
            if(g is Leprechaun) {
                leprechaunsAlreadyObtained ++;
            }else if(g is Carapace && eightNames.contains(g.name)) {
                leprechaunsAlreadyObtained ++;
            }
        }

        GameEntity ret;
        if(leprechaunsAlreadyObtained == 0) {
            ret = makeOne(player);
        }else if(leprechaunsAlreadyObtained == 1) {
            ret = makeTwo(player);
        }else if(leprechaunsAlreadyObtained == 2) {
            ret = makeThree(player);
        }else if(leprechaunsAlreadyObtained == 3) {
            ret = makeFour(player);
        }else if(leprechaunsAlreadyObtained == 4) {
            ret = makeFive(player);
        }else if(leprechaunsAlreadyObtained == 5) {
            ret = makeSix(player);
        }else if(leprechaunsAlreadyObtained == 6) {
            ret = makeSeven(player);
        }else if(leprechaunsAlreadyObtained == 7) {
            ret = makeEight(player);
        }else if(leprechaunsAlreadyObtained == 8) {
            ret = makeNine(player);
        }else if(leprechaunsAlreadyObtained == 9) {
            ret = makeTen(player);
        }else if(leprechaunsAlreadyObtained == 10) {
            ret = makeEleven(player);
        }else if(leprechaunsAlreadyObtained == 11) {
            ret = makeTwelve(player);
        }else if(leprechaunsAlreadyObtained == 12) {
            ret = makeThirteen(player);
        }else if(leprechaunsAlreadyObtained == 13) {
            ret = makeFourteen(player);
        }else if(leprechaunsAlreadyObtained == 14) {
            ret = makeFifteen(player);
        }else {
            ret = makeRandom(player);
        }

        List<Specibus> possibleSpecibi = new List<Specibus>();
        possibleSpecibi.add( new Specibus("Fist", ItemTraitFactory.FIST, [ ItemTraitFactory.FLESH, ItemTraitFactory.BLUNT]));
        possibleSpecibi.add( new Specibus("Hammer", ItemTraitFactory.HAMMER, [ ItemTraitFactory.HAMMER, ItemTraitFactory.BLUNT]));
        possibleSpecibi.add( new Specibus("Spear", ItemTraitFactory.STAFF, [ ItemTraitFactory.WOOD, ItemTraitFactory.POINTY]));
        possibleSpecibi.add( new Specibus("Sword", ItemTraitFactory.SWORD, [ ItemTraitFactory.METAL, ItemTraitFactory.POINTY, ItemTraitFactory.EDGED]));
        possibleSpecibi.add( new Specibus("Rod", ItemTraitFactory.STAFF, [ ItemTraitFactory.WOOD, ItemTraitFactory.MAGICAL]));
        possibleSpecibi.add( new Specibus("Gun", ItemTraitFactory.PISTOL, [ ItemTraitFactory.METAL, ItemTraitFactory.SHOOTY]));

        //don't override anything special, but don't let it be default either.
        if(ret.specibus.name.contains("Claw")) ret.specibus = ret.session.rand.pickFrom(possibleSpecibi);

        return ret;
    }

    //SB says:  1 and 2 and 6 will do mobility, 3 and 5 do freewill, 4 increases minluck and maxluck,
    //7 does sanity, 8 does all stats, 9 does hp, 10 does sanity, 11 does alchemy, 12 and 13 do freewill,
    // 14 does sanity, and 15 does power
    static Leprechaun makeOne(Player player) {
        Leprechaun companion = new Leprechaun(player.session.rand.pickFrom(Leprechaun.oneNames), player.session);
        companion.stats.copyFrom(player.stats); //mirror image for now.
        Iterable<Stat> allStats = Stats.all;

        for (Stat stat in allStats) {
            if(stat != Stats.EXPERIENCE && stat != Stats.GRIST && stat == Stats.MOBILITY) {
                int divisor = 3;
                companion.setStat(stat, companion.stats.getBase(stat).abs() / divisor); //stronger
            }else {
                int divisor = 13;
                companion.setStat(stat, companion.stats.getBase(stat) / divisor); //basically nothing
            }
        }
        companion.setStat(Stats.CURRENT_HEALTH, companion.getStat(Stats.HEALTH));
        return companion;
    }

    static makeTwo(Player player) {
        Leprechaun companion = new Leprechaun(player.session.rand.pickFrom(Leprechaun.twoNames), player.session);
        companion.stats.copyFrom(player.stats); //mirror image for now.
        Iterable<Stat> allStats = Stats.all;

        for (Stat stat in allStats) {
            if(stat != Stats.EXPERIENCE && stat != Stats.GRIST && stat == Stats.MOBILITY) {
                int divisor = 3;
                companion.setStat(stat, companion.stats.getBase(stat).abs() / divisor); //stronger
            }else {
                int divisor = 13;
                companion.setStat(stat, companion.stats.getBase(stat) / divisor); //basically nothing
            }
        }

        //;
        companion.setStat(Stats.CURRENT_HEALTH, companion.getStat(Stats.HEALTH));
        return companion;
    }


    static Leprechaun makeThree(Player player) {
        Leprechaun companion = new Leprechaun(player.session.rand.pickFrom(Leprechaun.threeNames), player.session);
        companion.stats.copyFrom(player.stats); //mirror image for now.
        Iterable<Stat> allStats = Stats.all;

        for (Stat stat in allStats) {
            if(stat != Stats.EXPERIENCE && stat != Stats.GRIST && stat == Stats.FREE_WILL) {
                int divisor = 3;
                companion.setStat(stat, companion.stats.getBase(stat).abs() / divisor); //stronger
            }else {
                int divisor = 13;
                companion.setStat(stat, companion.stats.getBase(stat) / divisor); //basically nothing
            }
        }
        companion.setStat(Stats.CURRENT_HEALTH, companion.getStat(Stats.HEALTH));
        return companion;
    }

    static Leprechaun makeFour(Player player) {
        Leprechaun companion = new Leprechaun(player.session.rand.pickFrom(Leprechaun.fourNames), player.session);
        companion.stats.copyFrom(player.stats); //mirror image for now.
        Iterable<Stat> allStats = Stats.all;

        for (Stat stat in allStats) {
            if(stat != Stats.EXPERIENCE && stat != Stats.GRIST && stat == Stats.MIN_LUCK || stat == Stats.MAX_LUCK) {
                int divisor = 3;
                companion.setStat(stat, companion.stats.getBase(stat).abs() / divisor); //stronger
            }else {
                int divisor = 13;
                companion.setStat(stat, companion.stats.getBase(stat) / divisor); //basically nothing
            }
        }
        companion.setStat(Stats.CURRENT_HEALTH, companion.getStat(Stats.HEALTH));
        return companion;
    }

    static Leprechaun makeFive(Player player) {
        Leprechaun companion = new Leprechaun(player.session.rand.pickFrom(Leprechaun.fiveNames), player.session);
        companion.stats.copyFrom(player.stats); //mirror image for now.
        Iterable<Stat> allStats = Stats.all;

        for (Stat stat in allStats) {
            if(stat != Stats.EXPERIENCE && stat != Stats.GRIST && stat == Stats.FREE_WILL) {
                int divisor = 3;
                companion.setStat(stat, companion.stats.getBase(stat).abs() / divisor); //stronger
            }else {
                int divisor = 13;
                companion.setStat(stat, companion.stats.getBase(stat) / divisor); //basically nothing
            }
        }
        companion.setStat(Stats.CURRENT_HEALTH, companion.getStat(Stats.HEALTH));
        return companion;
    }

    static Leprechaun makeSix(Player player) {
        Leprechaun companion = new Leprechaun(player.session.rand.pickFrom(Leprechaun.sixNames), player.session);
        companion.stats.copyFrom(player.stats); //mirror image for now.
        Iterable<Stat> allStats = Stats.all;

        for (Stat stat in allStats) {
            if(stat != Stats.EXPERIENCE && stat != Stats.GRIST && stat == Stats.MOBILITY) {
                int divisor = 3;
                companion.setStat(stat, companion.stats.getBase(stat).abs() / divisor); //stronger
            }else {
                int divisor = 13;
                companion.setStat(stat, companion.stats.getBase(stat) / divisor); //basically nothing
            }
        }
        companion.setStat(Stats.CURRENT_HEALTH, companion.getStat(Stats.HEALTH));
        return companion;
    }

    static Leprechaun makeSeven(Player player) {
        Leprechaun companion = new Leprechaun(player.session.rand.pickFrom(Leprechaun.sevenNames), player.session);
        companion.stats.copyFrom(player.stats); //mirror image for now.
        Iterable<Stat> allStats = Stats.all;

        for (Stat stat in allStats) {
            if(stat != Stats.EXPERIENCE && stat != Stats.GRIST && stat == Stats.SANITY) {
                int divisor = 3;
                companion.setStat(stat, companion.stats.getBase(stat).abs() / divisor); //stronger
            }else {
                int divisor = 13;
                companion.setStat(stat, companion.stats.getBase(stat) / divisor); //basically nothing
            }
        }
        companion.setStat(Stats.CURRENT_HEALTH, companion.getStat(Stats.HEALTH));
        return companion;
    }

    static Carapace makeEight(Player player) {
        Carapace companion = new Carapace(player.session.rand.pickFrom(Leprechaun.eightNames), player.session, Carapace.DERSE);
        companion.stats.copyFrom(player.stats); //mirror image for now.
        Iterable<Stat> allStats = Stats.all;

        for (Stat stat in allStats) {
            if(stat != Stats.EXPERIENCE && stat != Stats.GRIST) { //all stats
                int divisor = 3;
                companion.setStat(stat, companion.stats.getBase(stat).abs() / divisor); //stronger
            }else {
                int divisor = 13;
                companion.setStat(stat, companion.stats.getBase(stat) / divisor); //basically nothing
            }
        }
        companion.setStat(Stats.CURRENT_HEALTH, companion.getStat(Stats.HEALTH));
        return companion;
    }

    static Leprechaun makeNine(Player player) {
        Leprechaun companion = new Leprechaun(player.session.rand.pickFrom(Leprechaun.nineNames), player.session);
        companion.stats.copyFrom(player.stats); //mirror image for now.
        Iterable<Stat> allStats = Stats.all;

        for (Stat stat in allStats) {
            if(stat != Stats.EXPERIENCE && stat != Stats.GRIST && stat == Stats.HEALTH) {
                int divisor = 3;
                companion.setStat(stat, companion.stats.getBase(stat).abs() / divisor); //stronger
            }else {
                int divisor = 13;
                companion.setStat(stat, companion.stats.getBase(stat) / divisor); //basically nothing
            }
        }
        companion.setStat(Stats.CURRENT_HEALTH, companion.getStat(Stats.HEALTH));
        return companion;
    }

    static Leprechaun makeTen(Player player) {
        Leprechaun companion = new Leprechaun(player.session.rand.pickFrom(Leprechaun.tenNames), player.session);
        companion.stats.copyFrom(player.stats); //mirror image for now.
        Iterable<Stat> allStats = Stats.all;

        for (Stat stat in allStats) {
            if(stat != Stats.EXPERIENCE && stat != Stats.GRIST && stat == Stats.SANITY) {
                int divisor = 3;
                companion.setStat(stat, companion.stats.getBase(stat).abs() / divisor); //stronger
            }else {
                int divisor = 13;
                companion.setStat(stat, companion.stats.getBase(stat) / divisor); //basically nothing
            }
        }
        companion.setStat(Stats.CURRENT_HEALTH, companion.getStat(Stats.HEALTH));
        return companion;
    }

    static Leprechaun makeEleven(Player player) {
        Leprechaun companion = new Leprechaun(player.session.rand.pickFrom(Leprechaun.elevenNames), player.session);
        companion.stats.copyFrom(player.stats); //mirror image for now.
        Iterable<Stat> allStats = Stats.all;

        for (Stat stat in allStats) {
            if(stat != Stats.EXPERIENCE && stat != Stats.GRIST && stat == Stats.ALCHEMY) {
                int divisor = 3;
                companion.setStat(stat, companion.stats.getBase(stat).abs() / divisor); //stronger
            }else {
                int divisor = 13;
                companion.setStat(stat, companion.stats.getBase(stat) / divisor); //basically nothing
            }
        }
        companion.setStat(Stats.CURRENT_HEALTH, companion.getStat(Stats.HEALTH));
        return companion;
    }

    static Leprechaun makeTwelve(Player player) {
        Leprechaun companion = new Leprechaun(player.session.rand.pickFrom(Leprechaun.twelveNames), player.session);
        companion.stats.copyFrom(player.stats); //mirror image for now.
        Iterable<Stat> allStats = Stats.all;

        for (Stat stat in allStats) {
            if(stat != Stats.EXPERIENCE && stat != Stats.GRIST && stat == Stats.FREE_WILL) {
                int divisor = 3;
                companion.setStat(stat, companion.stats.getBase(stat).abs() / divisor); //stronger
            }else {
                int divisor = 13;
                companion.setStat(stat, companion.stats.getBase(stat) / divisor); //basically nothing
            }
        }
        companion.setStat(Stats.CURRENT_HEALTH, companion.getStat(Stats.HEALTH));
        return companion;
    }

    static Leprechaun makeThirteen(Player player) {
        Leprechaun companion = new Leprechaun(player.session.rand.pickFrom(Leprechaun.thirteenNames), player.session);
        companion.stats.copyFrom(player.stats); //mirror image for now.
        Iterable<Stat> allStats = Stats.all;

        for (Stat stat in allStats) {
            if(stat != Stats.EXPERIENCE && stat != Stats.GRIST && stat == Stats.FREE_WILL) {
                int divisor = 3;
                companion.setStat(stat, companion.stats.getBase(stat).abs() / divisor); //stronger
            }else {
                int divisor = 13;
                companion.setStat(stat, companion.stats.getBase(stat) / divisor); //basically nothing
            }
        }
        companion.setStat(Stats.CURRENT_HEALTH, companion.getStat(Stats.HEALTH));
        return companion;
    }

    static Leprechaun makeFourteen(Player player) {
        Leprechaun companion = new Leprechaun(player.session.rand.pickFrom(Leprechaun.fourteenNames), player.session);
        companion.stats.copyFrom(player.stats); //mirror image for now.
        Iterable<Stat> allStats = Stats.all;

        for (Stat stat in allStats) {
            if(stat != Stats.EXPERIENCE && stat != Stats.GRIST && stat == Stats.SANITY) {
                int divisor = 3;
                companion.setStat(stat, companion.stats.getBase(stat).abs() / divisor); //stronger
            }else {
                int divisor = 13;
                companion.setStat(stat, companion.stats.getBase(stat) / divisor); //basically nothing
            }
        }
        companion.setStat(Stats.CURRENT_HEALTH, companion.getStat(Stats.HEALTH));
        return companion;
    }

    static Leprechaun makeFifteen(Player player) {
        Leprechaun companion = new Leprechaun(player.session.rand.pickFrom(Leprechaun.fifteenNames), player.session);
        companion.stats.copyFrom(player.stats); //mirror image for now.
        Iterable<Stat> allStats = Stats.all;

        for (Stat stat in allStats) {
            if(stat != Stats.EXPERIENCE && stat != Stats.GRIST && stat == Stats.POWER) {
                int divisor = 3;
                companion.setStat(stat, companion.stats.getBase(stat).abs() / divisor); //stronger
            }else {
                int divisor = 13;
                companion.setStat(stat, companion.stats.getBase(stat) / divisor); //basically nothing
            }
        }
        companion.setStat(Stats.CURRENT_HEALTH, companion.getStat(Stats.HEALTH));
        return companion;
    }

    static makeRandom(Player player) {
        Leprechaun companion = new Leprechaun(player.session.rand.pickFrom(Leprechaun.infinityNames), player.session);
        companion.stats.copyFrom(player.stats); //mirror image for now.
        Iterable<Stat> allStats = Stats.all;
        bool pickedStat = false; //pick one stat to be big.
        for (Stat stat in allStats) {
            if(stat != Stats.EXPERIENCE && stat != Stats.GRIST && !pickedStat && player.session.rand.nextDouble()>.7) {
                int divisor = 3;
                pickedStat = true;
                companion.setStat(stat, companion.stats.getBase(stat) / divisor); //stronger
            }else {
                int divisor = 13;
                companion.setStat(stat, companion.stats.getBase(stat) / divisor); //basically nothing
            }
        }
        //;
        companion.setStat(Stats.CURRENT_HEALTH, companion.getStat(Stats.HEALTH));
        return companion;
    }

}

//srites are definitely going to behave differntly soon
class Sprite extends NPC {

    //TODO make sure when prototyped all your specific shit gets added.
    Sprite(String name, Session session) : super(name, session);

    @override
    Sprite clone() {
        Sprite clone = new Sprite(name, session);
        copyStatsTo(clone);
        return clone;
    }
}

class Underling extends NPC {
    Underling(String name, Session session) : super(name, session);
}

//naknaknaknaknaknak my comments are talking to me!
class Consort extends NPC {

    ///what sound do these consorts make?
    String sound;

    //first look up highest stat, then lowest stat to find out what this consort's title is.
    static Map<Stat, Map<Stat, String>> _titles = new Map<Stat, Map<Stat, String>>();

    Consort(String name, Session session) : super(name, session);
    Consort.withSound(String name, Session session,  this.sound): super(name, session){
       // ;
    }

    //takes in a player and randomly generates a consort with a special title just for them.
    static Consort npcForPlayer(Consort template, Player p) {
        //print(template.name);
        Consort companion = new Consort.withSound(template.name, template.session, template.sound);
        companion.stats.copyFrom(p.stats); //mirror image for now.
        Iterable<Stat> allStats = Stats.all;

        for (Stat stat in allStats) {
            if(stat != Stats.EXPERIENCE && stat != Stats.GRIST) {
                int divisor = companion.session.rand.nextIntRange(2, 13); //can't be above half as strong as the player in any stat
                companion.setStat(stat, companion.stats.getBase(stat) / divisor); //weaker
            }else {
                companion.setStat(stat, 1); //basically nothing

            }
        }

        //;
        companion.setStat(Stats.CURRENT_HEALTH, companion.getStat(Stats.HEALTH));
        companion.setTitleBasedOnStats();
        List<Specibus> possibleSpecibi = new List<Specibus>();
        possibleSpecibi.add( new Specibus("Fist", ItemTraitFactory.FIST, [ ItemTraitFactory.FLESH, ItemTraitFactory.BLUNT]));
        possibleSpecibi.add( new Specibus("Hammer", ItemTraitFactory.HAMMER, [ ItemTraitFactory.HAMMER, ItemTraitFactory.BLUNT]));
        possibleSpecibi.add( new Specibus("Spear", ItemTraitFactory.STAFF, [ ItemTraitFactory.WOOD, ItemTraitFactory.POINTY]));
        possibleSpecibi.add( new Specibus("Sword", ItemTraitFactory.SWORD, [ ItemTraitFactory.METAL,ItemTraitFactory.POINTY, ItemTraitFactory.EDGED]));
        possibleSpecibi.add( new Specibus("Rod", ItemTraitFactory.STAFF, [ ItemTraitFactory.WOOD, ItemTraitFactory.MAGICAL]));
        possibleSpecibi.add( new Specibus("Gun", ItemTraitFactory.PISTOL, [ ItemTraitFactory.METAL, ItemTraitFactory.SHOOTY]));

        companion.specibus = companion.session.rand.pickFrom(possibleSpecibi);
        return companion;
    }

    static void initTitles() {
        //Map<Stat, Map<Stat, String>> first map is high stats.
        initHighPower();
        initHighAlchemy();
        initHighFreeWill();
        initHighHealth();
        initHighLore();
        initHighMaxLuck();
        initHighMinLuck();
        initHighMobility();
        initHighRelationships();
        initHighSanity();
    }

    static void initHighPower() {
        Map<Stat, String> ret = new Map<Stat, String>();
        ret[Stats.POWER] = "Anomaly";
        ret[Stats.HEALTH] = "Wizard";
        ret[Stats.CURRENT_HEALTH] = "Wizard";
        ret[Stats.MOBILITY] = "Tank";
        ret[Stats.SANITY] = "Beserker";
        ret[Stats.RELATIONSHIPS] = "Asshole";
        ret[Stats.FREE_WILL] = "Thrall";
        ret[Stats.MIN_LUCK] = "Minion";
        ret[Stats.MAX_LUCK] = "Rogue";
        ret[Stats.ALCHEMY] = "Brute";
        ret[Stats.SBURB_LORE] = "Apprentice";
        _titles[Stats.POWER] = ret;
    }

    static void initHighHealth() {
        Map<Stat, String> ret = new Map<Stat, String>();
        ret[Stats.POWER] = "Questant";
        ret[Stats.HEALTH] = "Anomoly";
        ret[Stats.CURRENT_HEALTH] = "Anomoly";
        ret[Stats.MOBILITY] = "Guardian";
        ret[Stats.SANITY] = "Black Knight";
        ret[Stats.RELATIONSHIPS] = "Warrior";
        ret[Stats.FREE_WILL] = "Hero";
        ret[Stats.MIN_LUCK] = "Soldier";
        ret[Stats.MAX_LUCK] = "Champion";
        ret[Stats.ALCHEMY] = "Swordsman";
        ret[Stats.SBURB_LORE] = "Fighter";
        _titles[Stats.HEALTH] = ret;
        _titles[Stats.CURRENT_HEALTH] = ret;
    }

    static void initHighMobility() {
        Map<Stat, String> ret = new Map<Stat, String>();
        ret[Stats.POWER] = "Scout";
        ret[Stats.HEALTH] = "Ranger";
        ret[Stats.CURRENT_HEALTH] = "Ranger";
        ret[Stats.MOBILITY] = "Anomoly";
        ret[Stats.SANITY] = "Archer";
        ret[Stats.RELATIONSHIPS] = "Sniper";
        ret[Stats.FREE_WILL] = "Ninja";
        ret[Stats.MIN_LUCK] = "Hunter";
        ret[Stats.MAX_LUCK] = "Harvester";
        ret[Stats.ALCHEMY] = "Pirate";
        ret[Stats.SBURB_LORE] = "Racer";
        _titles[Stats.MOBILITY] = ret;
    }

    static void initHighSanity() {
        Map<Stat, String> ret = new Map<Stat, String>();
        ret[Stats.POWER] = "Monk";
        ret[Stats.HEALTH] = "Nun";
        ret[Stats.CURRENT_HEALTH] = "Nun";
        ret[Stats.MOBILITY] = "Sherpa";
        ret[Stats.SANITY] = "Anomoly";
        ret[Stats.RELATIONSHIPS] = "Warrior of Justice";
        ret[Stats.FREE_WILL] = "Paladin";
        ret[Stats.MIN_LUCK] = "Realist";
        ret[Stats.MAX_LUCK] = "Pessimist";
        ret[Stats.ALCHEMY] = "Librarian";
        ret[Stats.SBURB_LORE] = "Novelist";
        _titles[Stats.SANITY] = ret;
    }

    static void initHighRelationships() {
        Map<Stat, String> ret = new Map<Stat, String>();
        ret[Stats.POWER] = "Protagonist";
        ret[Stats.HEALTH] = "Friend";
        ret[Stats.CURRENT_HEALTH] = "Friend";
        ret[Stats.MOBILITY] = "VIP";
        ret[Stats.SANITY] = "Superstar";
        ret[Stats.RELATIONSHIPS] = "Anomoly";
        ret[Stats.FREE_WILL] = "Celebrity";
        ret[Stats.MIN_LUCK] = "Leech";
        ret[Stats.MAX_LUCK] = "ingenue";
        ret[Stats.ALCHEMY] = "Ditz";
        ret[Stats.SBURB_LORE] = "Vassal";
        _titles[Stats.RELATIONSHIPS] = ret;
    }

    static void initHighFreeWill() {
        Map<Stat, String> ret = new Map<Stat, String>();
        ret[Stats.POWER] = "Acolyte";
        ret[Stats.HEALTH] = "Patient";
        ret[Stats.CURRENT_HEALTH] = "Patient";
        ret[Stats.MOBILITY] = "Brother"; //lil brudder says 'i can do it on my own'.
        ret[Stats.SANITY] = "Con Artist";
        ret[Stats.RELATIONSHIPS] = "";
        ret[Stats.FREE_WILL] = "Anomoly";
        ret[Stats.MIN_LUCK] = "Dragoon";
        ret[Stats.MAX_LUCK] = "Paladin";
        ret[Stats.ALCHEMY] = "Student";
        ret[Stats.SBURB_LORE] = "Charlatan";
        _titles[Stats.FREE_WILL] = ret;
    }

    static void initHighMinLuck() {
        Map<Stat, String> ret = new Map<Stat, String>();
        ret[Stats.POWER] = "Cursed Swordsman";
        ret[Stats.HEALTH] = "Bard";
        ret[Stats.CURRENT_HEALTH] = "Bard";
        ret[Stats.MOBILITY] = "Farmer";
        ret[Stats.SANITY] = "Atrocity";
        ret[Stats.RELATIONSHIPS] = "Jerk";
        ret[Stats.FREE_WILL] = "Fool of Fate";
        ret[Stats.MIN_LUCK] = "Anomoly";
        ret[Stats.MAX_LUCK] = "Mirror"; //they invert how it should be
        ret[Stats.ALCHEMY] = "Idiot";
        ret[Stats.SBURB_LORE] = "Villager";
        _titles[Stats.MIN_LUCK] = ret;
    }

    static void initHighMaxLuck() {
        //all the low stats
        Map<Stat, String> ret = new Map<Stat, String>();
        ret[Stats.POWER] = "Sailor";
        ret[Stats.HEALTH] = "Rogue";
        ret[Stats.CURRENT_HEALTH] = "Rogue";
        ret[Stats.MOBILITY] = "Gem";
        ret[Stats.SANITY] = "Celebrity";
        ret[Stats.RELATIONSHIPS] = "Bastard";
        ret[Stats.FREE_WILL] = "Debutante";
        ret[Stats.MIN_LUCK] = "Jester";
        ret[Stats.MAX_LUCK] = "Anomoly";
        ret[Stats.ALCHEMY] = "Clown";
        ret[Stats.SBURB_LORE] = "Fool";
        _titles[Stats.MAX_LUCK] = ret;
    }

    static void initHighAlchemy() {
        //all the low stats
        Map<Stat, String> ret = new Map<Stat, String>();
        ret[Stats.POWER] = "Prodigy";
        ret[Stats.HEALTH] = "Genius";
        ret[Stats.CURRENT_HEALTH] = "Scientist";
        ret[Stats.MOBILITY] = "Blacksmith";
        ret[Stats.SANITY] = "Spark";
        ret[Stats.RELATIONSHIPS] = "Engineer";
        ret[Stats.FREE_WILL] = "Automaton";
        ret[Stats.MIN_LUCK] = "Apprentice";
        ret[Stats.MAX_LUCK] = "Disaster";
        ret[Stats.ALCHEMY] = "Anomoly";
        ret[Stats.SBURB_LORE] = "Alchemist";
        _titles[Stats.ALCHEMY] = ret;
    }

    static void initHighLore() {
        //all the low stats
        Map<Stat, String> ret = new Map<Stat, String>();
        ret[Stats.POWER] = "Academic";
        ret[Stats.HEALTH] = "Priest";
        ret[Stats.CURRENT_HEALTH] = "Priest";
        ret[Stats.MOBILITY] = "Librarian";
        ret[Stats.SANITY] = "Sorcerer";
        ret[Stats.RELATIONSHIPS] = "Magician";
        ret[Stats.FREE_WILL] = "Druid";
        ret[Stats.MIN_LUCK] = "Warlock";
        ret[Stats.MAX_LUCK] = "Wizard";
        ret[Stats.ALCHEMY] = "Mage";
        ret[Stats.SBURB_LORE] = "Anomoly";
        _titles[Stats.SBURB_LORE] = ret;
    }


    void setTitleBasedOnStats() {
        if(_titles.isEmpty) initTitles();
        //need to have default values too, if you can't find shit (i.e. new stats)

        String title = "Minion";
        String bonus = "";
        if(_titles.containsKey(highestStat)) {
            if(_titles[highestStat].containsKey(lowestStat)) {
                title = _titles[highestStat][lowestStat];
            }
        }
        if(session.rand.nextDouble() > .9) bonus = "Secret";

        name = "$bonus $name $title";
    }


}

//denizens are spawned with innate knowledge of a personal fraymotif.
//TODO eventually put this logic here instead of in player, and have mechanism for
//creating a denizen live here in a static method.
class Denizen extends NPC {
    Denizen(String name, Session session) : super(name, session) {
        //;
    }

    @override
    Denizen clone() {
        Denizen clone = new Denizen(name, session);
        copyStatsTo(clone);
        return clone;
    }

}

//unlike a regular denizen, will fucking kill your ass.
class HardDenizen extends Denizen {
    HardDenizen(String name, Session session) : super(name, session);

    @override
    HardDenizen clone() {
        HardDenizen clone = new HardDenizen(name, session);
        copyStatsTo(clone);
        return clone;
    }

}

class DenizenMinion extends NPC {
    DenizenMinion(String name, Session session)
        : super(name, session);


    @override
    DenizenMinion clone() {
        DenizenMinion clone = new DenizenMinion(name, session);
        copyStatsTo(clone);
        return clone;
    }
}

class PotentialSprite extends NPC {
    @override
    String helpPhrase = "provides the requisite amount of gigglesnort hideytalk to be juuuust barely helpful. ";
    @override
    num helpfulness = 0;
    @override
    bool armless = false;
    @override
    bool disaster = false;
    @override
    bool lusus = false; //HAVE to be vars or can't inherit through prototyping.
    @override
    bool player = false;
    @override
    bool illegal = false; //maybe AR won't help players with ILLEGAL sprites?
    PotentialSprite(String name, Session session) : super(name, session);

    static List<GameEntity> disastor_objects;
    static List<GameEntity> fortune_objects;
    static List<GameEntity> lusus_objects;
    static List<GameEntity> sea_lusus_objects;
    static List<GameEntity> prototyping_objects;
    static Session defaultSession; //needed so we don't do infinite loop since a session tries to initialize sprites which try to maek a blank session.

    static initializeAShitTonOfPotentialSprites(Session s) {
        if(PotentialSprite.prototyping_objects != null) return; //dont' reinit.
        defaultSession = s;

        ;
        initializeAShitTonOfGenericSprites();
        initializeAShitTonOfFortuneSprites();
        initializeAShitTonOfDisastorSprites();
        initializeAShotTonOfLususSprites();
       // ;
        prototyping_objects.addAll(PotentialSprite.disastor_objects);
        prototyping_objects.addAll(PotentialSprite.fortune_objects);
        prototyping_objects.addAll(PotentialSprite.lusus_objects);
        prototyping_objects.addAll(PotentialSprite.sea_lusus_objects);
        //yes, a human absolutely could prototype some troll's lusus. that is a thing that is true.
    }

    static initializeAShitTonOfGenericSprites() {
    //regular
        PotentialSprite.prototyping_objects = <GameEntity>[
            new PotentialSprite(Zalgo.generate("Buggy As Fuck Retro Game"), null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..corrupted = true //no stats, just corrupted. maybe a fraymotif later.
                ..helpPhrase =
                    "provides painful, painful sound file malfunctions, why is this even a thing? ",

            new PotentialSprite("Robot", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 100, Stats.HEALTH: 100, Stats.CURRENT_HEALTH: 100, Stats.FREE_WILL: 100})
                ..helpfulness = 1
                ..helpPhrase =
                    "is <b>more</b> useful than another player. How could a mere human measure up to the awesome logical capabilities of a machine? "
            ,

            new PotentialSprite("Golfer", null)
                ..helpfulness = 1
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.MIN_LUCK: 20, Stats.MAX_LUCK: 20})
                ..helpPhrase =
                    "provides surprisingly helpful advice, even if they do insist on calling all enemies ‘bogeys’. ",

            new PotentialSprite("Dutton", null)
                ..helpfulness = 1
                ..helpPhrase = "provides transcendent wisdom. "
                ..stats.setMap(<Stat,num>{Stats.POWER: 10, Stats.HEALTH: 10, Stats.CURRENT_HEALTH: 10, Stats.FREE_WILL: 50, Stats.MOBILITY: 50, Stats.MIN_LUCK: 50, Stats.MAX_LUCK: 50})
                ..fraymotifs.add(new Fraymotif("Duttobliteration", 2)
                    ..effects.add(new FraymotifEffect(Stats.FREE_WILL, 2, true))
                    ..desc =
                        " The ENEMY is obliterated. Probably. A watermark of Charles Dutton appears, stage right. "),

            new PotentialSprite("Game Bro", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = 1
                ..helpPhrase =
                    "provides rad as fuck tips and tricks for beating SBURB and getting mad snacks, yo. 5 out of 5 hats. ",

//in joke, lol, google always reports that sessions are crashed. google is a horror terror (see tumblr)
            new PotentialSprite(Zalgo.generate("Google"), null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = 1
                ..corrupted = true
                ..helpPhrase =
                    "sure knows a lot about everything, but why does it only seem to return results about crashing SBURB?",

            new PotentialSprite("Game Grl", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = 1
                ..helpPhrase =
                    "provides rad as fuck tips and tricks for beating SBURB and getting mad snacks, yo, but, like, while also being a GIRL? *record scratch*  5 out of 5 lady hats. ",

            new PotentialSprite("Paperclip", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = -1
                ..helpPhrase =
                    "says: 'It looks like you're trying to play a cosmic game where you breed frogs to create a universe. Would you like me to'-No. 'Would you like me to'-No! 'It looks like you're'-shut up!!! This is not helpful.",

            new PotentialSprite("WebComicCreator", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = -1
                ..helpPhrase =
                    "refuses to explain anything about SBURB to you, prefering to let you speculate wildly while cackling to himself."
                ..fraymotifs.add(new Fraymotif("Kill ALL The Characters", 2)
                    ..effects.add(new FraymotifEffect(Stats.FREE_WILL, 3, true))
                    ..desc =
                        " All enemies are obliterated. Probably. A watermark of Andrew Hussie appears, stage right. "),

            new PotentialSprite("KidRock", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = -1
                ..helpPhrase =
                    "does absolutly nothing but sing repetitive, late 90's rock to you."
                ..fraymotifs.add(new Fraymotif("BANG DA DANG DIGGY DIGGY", 2)
                    ..effects.add(
                        new FraymotifEffect(Stats.POWER, 3, true)) //buffs party and hurts enemies
                    ..effects.add(new FraymotifEffect(Stats.POWER, 1, false))
                    ..desc =
                        " OWNER plays a 90s hit classic, and you can't help but tap your feet. Somehow, this doesn't feel like the true version of this attack."),

            new PotentialSprite("Sleuth", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.RELATIONSHIPS: 100})
                ..helpfulness = -1
                ..helpPhrase =
                    "suggests the player just input a password to skip all their land's weird puzzle shit. This is not actually a thing you can do."
                ..fraymotifs.add(new Fraymotif("Sepulchritude", 2)
                    ..effects.add(new FraymotifEffect(Stats.RELATIONSHIPS, 1, true))
                    ..desc =
                        " The OWNER decides not to bring that noise just yet. They just heal the party instead. ")
                ..fraymotifs.add(new Fraymotif("Sepulchritude", 2)
                    ..effects.add(new FraymotifEffect(Stats.RELATIONSHIPS, 1, true))
                    ..desc =
                        " THE OWNER just don't have the offensive gravitas for that attack. They just heal the party instead. ")
                ..fraymotifs.add(new Fraymotif("Sepulchritude", 2)
                    ..effects.add(new FraymotifEffect(Stats.RELATIONSHIPS, 3, true))
                    ..desc =
                        " The OWNER finally fucking unleashes their Ultimate Attack. The resplendent light of divine PULCHRITUDE consumes all enemies. ")
                ..fraymotifs.add(new Fraymotif("Sepulchritude", 2)
                    ..effects.add(new FraymotifEffect(Stats.RELATIONSHIPS, 1, true))
                    ..desc =
                        " No, not yet! The OWNER refuses to use Sepulchritude. They just heal the party instead. "),

            new PotentialSprite("Nic Cage", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = 1
                ..helpPhrase =
                    "demonstrates that when it comes to solving bullshit riddles to get National *cough* I mean SBURBian treasure, he is simply the best there is. ",

            new PotentialSprite("Praying Mantis", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.MAX_LUCK: 20})
            ,

            new PotentialSprite("Shitty Comic Character", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.MOBILITY: 50})
                ..helpfulness = -1
                ..helpPhrase =
                    " is the STAR. It is them. You don't think they have ever once attempted to even talk about the game. How HIGH did you have to BE to prototype this glitchy piece of shit? "
                ..fraymotifs.add(new Fraymotif("FUCK IM FALLING DOWN ALL THESE STAIRS", 3)
                    ..effects
                        .add(new FraymotifEffect(Stats.MOBILITY, 1, false)) //buff to mobility bro
                    ..desc = " It keeps hapening. ")
                ..fraymotifs
                    .add(new Fraymotif("FUCK IM FALLING DOWN ALL THESE STAIRS", 3)
                    ..effects.add(new FraymotifEffect(Stats.MOBILITY, 1, false))
                    ..desc = " I warned you about stairs bro!!! ")
                ..fraymotifs
                    .add(new Fraymotif("FUCK IM FALLING DOWN ALL THESE STAIRS", 3)
                    ..effects.add(new FraymotifEffect(Stats.MOBILITY, 1, false))
                    ..desc = " I told you dog! "),

            new PotentialSprite("Doctor", null) //healing fraymotif
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = 1
                ..helpPhrase =
                    "is pretty much as useful as another player. No cagey riddles, just straight answers on how to finish the quests. ",

            new PotentialSprite("Gerbil", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = 1
                ..helpPhrase =
                    "remains physically adorable and mentally idiotic. Gigglysnort hideytalk ahoy. ",

            new PotentialSprite("Chinchilla", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = 1
                ..helpPhrase =
                    "remains physically adorable and mentally idiotic. Gigglysnort hideytalk ahoy. ",

            new PotentialSprite("Rabbit", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.MAX_LUCK: 100})
                ..helpPhrase =
                    "remains physically adorable and mentally idiotic. Gigglysnort hideytalk ahoy. ",

            new PotentialSprite("Tissue", null)
                ..helpfulness = -1
                ..helpPhrase = "is useless in every possible way. ",

            new PotentialSprite("Librarian", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = 1
                ..helpPhrase =
                    "Is pretty much as useful as another player. No cagey riddles, just straight answers on where the book on how to finish the quest is, and could you please keep it down? ",

            new PotentialSprite("Pit Bull", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 50}),

            new PotentialSprite("Butler", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.SANITY: 50}) //he will serve you like a man on butler island
                ..helpfulness = 1
                ..helpPhrase =
                    "is serving their player like a dude on butlersprite island. "
            ,

            new PotentialSprite("Sloth", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.MOBILITY: -50})
                ..helpPhrase = "provides. Slow. But. Useful. Advice.",

            new PotentialSprite("Cowboy", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = 1
                ..helpPhrase =
                    "provides useful advice, even if they do insist on calling literally everyone 'pardner.' ",

            new PotentialSprite("Pomeranian", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 1}) //pomeranians aren't actually very good at fights.  (trust me, i know)
                ..helpfulness = -1
                ..helpPhrase =
                    "unhelpfully insists that every rock is probably a boss fight (it isn’t). ",

            new PotentialSprite("Chihuahua", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 1}) //i'm extrapolating here, but I imagine Chihuahua's aren't very good at fights, either.
                ..helpfulness = -1
                ..helpPhrase =
                    "unhelpfully insists that every rock is probably a boss fight (it isn’t). ",

            new PotentialSprite("Pony", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.SANITY: -1000})
                ..helpfulness = -1
            //ponyPals taught me that ponys are just flipping their shit, like, 100% of the time.
                ..helpPhrase =
                    "is constantly flipping their fucking shit instead of being useful in any way shape or form, as ponies are known for. ",

            new PotentialSprite("Horse", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.SANITY: -100})
                ..helpfulness = -1
            //probably flip out less than ponys???
                ..helpPhrase =
                    "is constantly flipping their fucking shit instead of being useful in any way shape or form, as horses are known for. ",

            new PotentialSprite("Internet Troll", null) //needs to have a fraymotif called "u mad, bro" and "butt hurt"
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.SANITY: 1000})
                ..helpfulness = -1
                ..helpPhrase = "actively does its best to hinder their efforts. ",

            new PotentialSprite("Mosquito", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = -1
                ..helpPhrase =
                    "is a complete dick, buzzing and fussing and biting. What's its deal? ",

            new PotentialSprite("Fly", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = -1
                ..helpPhrase =
                    "is a complete dick, buzzing and fussing and biting. What's its deal? ",

            new PotentialSprite(Zalgo.generate("GitHub"), null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = 1
                ..corrupted = true
                ..helpPhrase =
                    "Githubsprite tells all about the latest changes to sburbs code. ",

            new PotentialSprite("Cow", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 30}), //cows kill more people a year than sharks.

            new PotentialSprite("Bird", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.MOBILITY: 50})
                ..helpPhrase =
                    "provides sort of helpful advice when not grabbing random objects to make nests. ",

            new PotentialSprite("Bug", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpPhrase =
                    "provides the requisite amount of buzzybuz zuzytalk to be juuuust barely helpful. ",

            new PotentialSprite("Llama", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20}),

            new PotentialSprite("Penguin", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20}),

            new PotentialSprite("Husky", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
                ..helpPhrase =
                    "alternates between loud, insistent barks and long, eloquent monologues on the deeper meaning behind each and every fragment of the game. ",

            new PotentialSprite("Cat", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.MIN_LUCK: -20, Stats.MAX_LUCK: 20})
                ..helpPhrase =
                    "Is kind of helpful? Maybe? You can't tell if it loves their player or hates them. ",

            new PotentialSprite("Dog", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
                ..helpPhrase =
                    "alternates between loud, insistent barks and long, eloquent monologues on the deeper meaning behind each and every fragment of the game. ",

            new PotentialSprite("Pigeon", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 0.5, Stats.FREE_WILL: -40}) //pigeons are not famous for their combat prowess. I bet even a pomeranian could beat one up.
            ,

            new PotentialSprite("Octopus", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.MOBILITY: 80})
            , //so many legs! more legs is more faster!!!

            new PotentialSprite("Fish", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..armless = true,

            new PotentialSprite("Kitten", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpPhrase =
                    "is kind of helpful? Maybe? You can't tell if it loves their player or hates them. ",

            new PotentialSprite("Worm", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..armless = true,

            new PotentialSprite("Bear", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 50}),

            new PotentialSprite("Goat", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20}),

            new PotentialSprite("Rat", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20}),

            new PotentialSprite("Raccoon", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = 1
                ..helpPhrase =
                    "demonstrates that SBURB basically hides quest items in the same places humans would throw away their garbage. ",

            new PotentialSprite("Crow", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.FREE_WILL: 50}) //have you ever tried to convince a crow not to do something? not gonna happen.
                ..helpPhrase =
                    "provides sort of helpful advice when not grabbing random objects to make nests. ",

            new PotentialSprite("Chicken", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.FREE_WILL: -50}), //mike the headless chicken has convinced me that chickens don't really need brains. god that takes me back.

            new PotentialSprite("Duck", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20}),

            new PotentialSprite("Sparrow", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20}),

            new PotentialSprite("Fancy Santa", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = -1
                ..helpPhrase = "goes hohohohohohohohoho. ",

            new PotentialSprite("Politician", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = -1
                ..helpPhrase =
                    "offers a blueprint for an ECONONY that works for everyone. That would've been more useful before the earth was destroyed.... ",

            new PotentialSprite("Tiger", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 50})
                ..helpPhrase =
                    "Provides just enough pants-shitingly terrifying growly-roar meow talk to be useful. ",

            new PotentialSprite("Sugar Glider", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpPhrase =
                    "remains physically adorable and mentally idiotic. Gigglysnort hideytalk ahoy. ",

            new PotentialSprite("Rapper", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = 1
                ..helpPhrase =
                    "provides surprisingly helpful advice, even if it does insist on some frankly antiquated slang and rhymes. I mean, civilization is dead, there isn’t exactly a police left to fuck. ",

            new PotentialSprite("Kangaroo", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 30, Stats.MOBILITY: 30}),

            new PotentialSprite("Stoner", null)
            //blaze it
                ..stats.setMap(<Stat,num>{Stats.POWER: 42.0, Stats.MIN_LUCK: -42.0, Stats.MAX_LUCK: 42.0})
                ..helpfulness = 1
                ..helpPhrase =
                    "is pretty much as useful as another player, assuming that player was higher then a fucking kite. ",
        ];


    }

    static initializeAShitTonOfFortuneSprites() {
//fortune
        PotentialSprite.fortune_objects = <GameEntity>[

            new PotentialSprite("Frog", null)
                ..illegal = true
                ..stats.setMap(<Stat,num>{Stats.MOBILITY: 100, Stats.POWER: 10})
                ..helpPhrase =
                    "provides the requisite amount of gigglesnort  hideytalk to be fairly useful, AND the underlings seem to go after it first! Bonus! ",
            new PotentialSprite("Lizard", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..illegal = true
                ..helpPhrase =
                    "provides the requisite amount of gigglesnort  hideytalk to be fairly useful, AND the underlings seem to go after it first! Bonus! ",
            new PotentialSprite("Salamander", null)
                ..illegal = true
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.POWER: 20})
                ..helpPhrase =
                    "provides the requisite amount of gigglesnort  hideytalk to be fairly useful, AND the underlings seem to go after it first! Bonus! ",
            new PotentialSprite("Iguana", null)
                ..illegal = true
                ..helpPhrase =
                    "provides the requisite amount of gigglesnort  hideytalk to be fairly useful, AND the underlings seem to go after it first! Bonus! ",
            new PotentialSprite("Crocodile", null)
                ..illegal = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 50})
                ..helpPhrase =
                    "provides the requisite amount of gigglesnort  hideytalk to be fairly useful, AND the underlings seem to go after it first! Bonus! ",
            new PotentialSprite("Turtle", null)
                ..illegal = true
                ..stats.setMap(<Stat,num>{Stats.MOBILITY: -100, Stats.POWER: 20})
                ..helpPhrase =
                    "provides the requisite amount of gigglesnort  hideytalk to be fairly useful, AND the underlings seem to go after it first! Bonus! ",
            new PotentialSprite("Alligator", null)
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.MOBILITY: 100, Stats.POWER: 50})
                ..illegal = true
                ..helpPhrase =
                    "provides the requisite amount of gigglesnort  hideytalk to be fairly useful, AND the underlings seem to go after it first! Bonus! ",
            new PotentialSprite("Snake", null) //poison fraymotif
                ..armless = true
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.MOBILITY: 100, Stats.POWER: 10})
                ..illegal = true
                ..helpPhrase =
                    "providessss the requisssssite amount of gigglessssssnort hideytalk to be jusssssst barely helpful. AND the underlings seem to go after it first! Bonus! ",
            new PotentialSprite("Axolotl", null) //apparently real ones are good at regeneration?
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.HEALTH: 50, Stats.CURRENT_HEALTH: 50})
                ..illegal = true
                ..helpPhrase =
                    "provides the requisite amount of gigglesnort  hideytalk to be fairly useful, AND the underlings seem to go after it first! Bonus! ",
            new PotentialSprite("Newt", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..illegal = true
                ..helpPhrase =
                    "provides the requisite amount of gigglesnort  hideytalk to be fairly useful, AND the underlings seem to go after it first! Bonus! ",
        ];



    }

    static initializeAShitTonOfDisastorSprites() {
        PotentialSprite.disastor_objects = <GameEntity>[
            new PotentialSprite(
                "First Guardian", null) //also a custom fraymotif.
                ..disaster = true
                ..stats.setMap(<Stat,num>{
                    Stats.HEALTH: 1000,
                    Stats.CURRENT_HEALTH: 1000,
                    Stats.MOBILITY: 500,
                    Stats.POWER: 250
                })
                ..helpPhrase =
                    "is fairly helpful with the teleporting and all, but when it speaks- Wow. No. That is not ok. "
                ..fraymotifs.add(new Fraymotif("Atomic Teleport Spam", 3)
                    ..effects.add(new FraymotifEffect(Stats.MOBILITY, 0, false))
                    ..effects.add(new FraymotifEffect(Stats.MOBILITY, 2, true))
                    ..desc =
                        " The OWNER shimers with radioactive stars, and then teleports behind the ENEMY, sneak-attacking them. "),
            new PotentialSprite(Zalgo.generate("Horror Terror"), null) //vast glub
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.FREE_WILL: 250, Stats.POWER: 150})
                ..disaster = true
                ..corrupted = true
                ..helpPhrase =
                    "... Oh god. What is going on. Why does just listening to it make your ears bleed!? "
                ..fraymotifs.add(new Fraymotif("Vast Glub", 3)
                    ..effects.add(new FraymotifEffect(Stats.FREE_WILL, 3, true))
                    ..desc =
                        " A galaxy spanning glub damages everyone. The only hope of survival is to spread the damage across so many enemies that everyone only takes a manageable amount. "),
            new PotentialSprite(
                Zalgo.generate("Speaker of the Furthest Ring"), null) //vast glub
                ..disaster = true
                ..corrupted = true
                ..stats.setMap(<Stat,num>{
                    Stats.HEALTH: 1000,
                    Stats.CURRENT_HEALTH: 1000,
                    Stats.FREE_WILL: 250,
                    Stats.POWER: 250
                })
                ..helpPhrase =
                    "whispers madness humankind was not meant to know. Its words are painful, hateful, yet… tempting. It speaks of flames and void, screams and gods. "
                ..fraymotifs.add(new Fraymotif("Vast Glub", 3)
                    ..effects.add(new FraymotifEffect(Stats.FREE_WILL, 3, true))
                    ..desc =
                        " A galaxy spanning glub damages everyone. The only hope of survival is to spread the damage across so many enemies that everyone only takes a manageable amount. "),
            new PotentialSprite(
                "Clown", null) //custom fraymotif: can' keep down the clown (heal).
                ..disaster = true
                ..stats.setMap(<Stat,num>{
                    Stats.HEALTH: 1000,
                    Stats.CURRENT_HEALTH: 1000,
                    Stats.MIN_LUCK: -250,
                    Stats.MAX_LUCK: 250,
                    Stats.POWER: 100
                })
                ..helpfulness = -1
                ..helpPhrase = "goes hehehehehehehehehehehehehehehehehehehehehehehehehehe. "
                ..fraymotifs.add(new Fraymotif("Can't Keep Down The Clown", 3)
                    ..effects.add(new FraymotifEffect(Stats.SANITY, 0, false))
                    ..effects.add(new FraymotifEffect(Stats.SANITY, 0, true))
                    ..desc =
                        " You are pretty sure it is impossible for Clowns to die. "),
            new PotentialSprite("Echidna", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..illegal = true
                ..disaster = true
                ..corrupted = true
                ..helpfulness = -1
                ..fraymotifs.add(new Fraymotif("Odin's Wrath", 3)
                ..effects.add(new FraymotifEffect(Stats.SANITY, 3, false))
                ..effects.add(new FraymotifEffect(Stats.SANITY, 3, true))
                ..desc = "God no.")
                ..helpPhrase =
                    "God. No.",
            new PotentialSprite("Puppet", null)
                ..disaster = true
                ..stats.setMap(<Stat,num>{
                    Stats.HEALTH: 500,
                    Stats.CURRENT_HEALTH: 500,
                    Stats.FREE_WILL: 250,
                    Stats.MOBILITY: 250,
                    Stats.MIN_LUCK: -250,
                    Stats.MAX_LUCK: 250,
                    Stats.SANITY: 250,
                    Stats.POWER: 100
                })
                ..helpPhrase =
                    "is the most unhelpful piece of shit in the world. Oh my god, just once. Please, just shut up. "
                ..helpfulness = -1
                ..fraymotifs.add(new Fraymotif("Hee Hee Hee Hoo!", 3)
                    ..effects.add(new FraymotifEffect(Stats.SANITY, 3, false))
                    ..effects.add(new FraymotifEffect(Stats.SANITY, 3, true))
                    ..desc = " Oh god! Shut up! Just once! Please shut up! "),
            new PotentialSprite("Xenomorph", null) //custom fraymotif: acid blood
                ..disaster = true
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.MOBILITY: 250, Stats.POWER: 100})
                ..fraymotifs.add(new Fraymotif("Spawning", 3)
                    ..effects.add(new FraymotifEffect(Stats.ALCHEMY, 3, true))
                    ..desc =
                        " Oh god. Where are all those baby monsters coming from. They are everywhere! Fuck! How are they so good at biting??? "),
            new PotentialSprite(
                "Deadpool", null) //TODO: eventually dead pool gives you one gnosis rank
                ..disaster = true
                ..stats.setMap(<Stat,num>{
                    Stats.HEALTH: 500,
                    Stats.CURRENT_HEALTH: 500,
                    Stats.MOBILITY: 250,
                    Stats.MIN_LUCK: -250,
                    Stats.MAX_LUCK: 250,
                    Stats.POWER: 100
                })
                ..helpfulness = 1
                ..helpPhrase =
                    "demonstrates that when it comes to providing fourth wall breaking advice to getting through quests and killing baddies, he is pretty much the best there is. "
                ..fraymotifs.add(new Fraymotif("Degenerate Regeneration", 3)
                    ..effects.add(new FraymotifEffect(Stats.HEALTH, 0, true))
                    ..desc =
                        " Hey there, Observer! Want to see a neat trick? POW! Grew my own head back. Pretty cool, huh? (Now if only JR would let me spam this or make it be castable even while dead, THEN we'd be cooking with petrol) "),
            new PotentialSprite(
                "Dragon", null) //custom fraymotif: mighty breath.
                ..disaster = true
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.POWER: 100})
                ..helpPhrase = "breathes fire and offers condescending, yet useful advice. "
                ..fraymotifs.add(new Fraymotif("Mighty Fire Breath", 3)
                    ..effects.add(new FraymotifEffect(Stats.POWER, 3, true))
                    ..desc =
                        " With a mighty breath, OWNER spits all the fires, sick and otherwise."),
            new PotentialSprite("Teacher", null)
                ..disaster = true
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.POWER: 100})
                ..helpfulness = -1
                ..helpPhrase =
                    "dials the sprites natural tendency towards witholding information to have you 'figure it out yourself' up to eleven. "
                ..fraymotifs.add(new Fraymotif("Lecture", 3)
                    ..effects.add(new FraymotifEffect(Stats.FREE_WILL, 3, false))
                    ..effects.add(new FraymotifEffect(Stats.SANITY, 3, false))
                    ..desc =
                        " OWNER begins a 3 part lecture on why you should probably just give up. It is hypnotic in it's ceaselessness."),
            new PotentialSprite("Fiduspawn", null)
                ..disaster = true
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.POWER: 100})
                ..fraymotifs.add(new Fraymotif("Spawning", 3)
                    ..effects.add(new FraymotifEffect(Stats.ALCHEMY, 3, true))
                    ..desc =
                        " Oh god. Where are all those baby monsters coming from. They are everywhere! Fuck! How are they so good at biting??? "),
            new PotentialSprite("Doll", null)
                ..disaster = true
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.POWER: 100})
                ..helpfulness = -1
                ..helpPhrase =
                    "stares creepily. It never moves when you're watching it. It's basically the worst, and that's all there is to say on that topic. "
                ..fraymotifs.add(new Fraymotif("Disconcerting Ogle", 3)
                    ..effects.add(new FraymotifEffect(Stats.SANITY, 3, false))
                    ..effects.add(new FraymotifEffect(Stats.SANITY, 0, true))
                    ..desc =
                        " OWNER is staring at ENEMY. It makes you uncomfortable, the way they are just standing there. And watching.  "),
            new PotentialSprite("Zombie", null)
                ..disaster = true
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.POWER: 100})
                ..fraymotifs.add(new Fraymotif("Rise From The Grave", 3)
                    ..effects.add(new FraymotifEffect(Stats.HEALTH, 0, true))
                    ..desc =
                        " You thought the OWNER was pretty hurt, but instead they are just getting going. "),
            new PotentialSprite("Demon", null)
                ..disaster = true
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.FREE_WILL: 250, Stats.POWER: 250})
                ..fraymotifs.add(new Fraymotif("Claw Claw MotherFuckers", 3)
                    ..effects.add(new FraymotifEffect(Stats.POWER, 2, true))
                    ..effects.add(new FraymotifEffect(Stats.POWER, 2, true))
                    ..desc = " The OWNER slashes at the ENEMY twice. "),
            new PotentialSprite("Monster", null)
                ..disaster = true
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.SANITY: -250, Stats.MAX_LUCK: 250, Stats.POWER: 100})
                ..fraymotifs.add(new Fraymotif("Claw Claw MotherFuckers", 3)
                    ..effects.add(new FraymotifEffect(Stats.POWER, 2, true))
                    ..effects.add(new FraymotifEffect(Stats.POWER, 2, true))
                    ..desc = " The OWNER slashes at the ENEMY twice. "),
            new PotentialSprite("Vampire", null)
                ..disaster = true
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.MOBILITY: 250, Stats.POWER: 100})
                ..fraymotifs.add(new Fraymotif("I Vant to Drink Your Blood", 3)
                    ..effects.add(new FraymotifEffect(Stats.HEALTH, 2, true))
                    ..effects.add(new FraymotifEffect(Stats.HEALTH, 0, true)) //damage you, heal self.
                    ..desc = " The OWNER drains HP from the ENEMY. "),
            new PotentialSprite("Pumpkin", null)
                ..disaster = true
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.MOBILITY: 5000, Stats.MIN_LUCK: -250, Stats.MAX_LUCK: 5000, Stats.POWER: 100})
                ..helpPhrase =
                    "was kind of helpful, and then kind of didn’t exist. Please don’t think too hard about it, the simulation is barely handling a pumpkin sprite as is. "
                ..fraymotifs.add(new Fraymotif("What Pumpkin???", 3)
                    ..effects.add(new FraymotifEffect(Stats.MOBILITY, 2, false))
                    ..effects.add(new FraymotifEffect(Stats.MOBILITY, 3, true))
                    ..desc =
                        " Everyone tries to hit the OWNER until suddenly they have never been there at all, causing attacks to miss so catastrophically they backfire. "),
            new PotentialSprite("Werewolf", null)
                ..disaster = true
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.SANITY: -250, Stats.POWER: 100})
                ..fraymotifs.add(new Fraymotif("Grim Bark Slash Attack", 3)
                    ..effects.add(new FraymotifEffect(Stats.POWER, 2, true))
                    ..effects.add(new FraymotifEffect(Stats.POWER, 2, true))
                    ..desc =
                        " The OWNER slashes at the ENEMY twice. While being a werewolf. "),
            new PotentialSprite("Jet Engine", null)
                ..disaster = true
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.MOBILITY: 500, Stats.POWER: 100})
                ..fraymotifs.add(new Fraymotif("NO  CAPES", 3)
                    ..effects.add(new FraymotifEffect(Stats.POWER, 2, true))
                    ..effects.add(new FraymotifEffect(Stats.POWER, 2, true))
                    ..desc =
                        " The OWNER sucks the ENEMY in towards their spinning blades of death. "),
            new PotentialSprite("Monkey", null) //just, fuck monkeys in general.
                ..disaster = true
                ..helpfulness = -1
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 5, Stats.CURRENT_HEALTH: 5, Stats.MOBILITY: 5000, Stats.MIN_LUCK: -5000, Stats.MAX_LUCK: -5000, Stats.POWER: 100})
                ..helpPhrase = "actively interferes with quests. Just. Fuck monkeys. "
                ..fraymotifs.add(new Fraymotif("Monkey Business", 3)
                    ..effects.add(new FraymotifEffect(Stats.MOBILITY, 0, false))
                    ..effects.add(new FraymotifEffect(Stats.MOBILITY, 2, true))
                    ..desc =
                        " The OWNER uses their monkey like fastness to attack the ENEMY just way too fucking many times. "),
        ];


    }

    static initializeAShotTonOfLususSprites() {
//////////////////////lusii are a little stronger in general
        PotentialSprite.lusus_objects = <GameEntity>[
            new PotentialSprite("Hoofbeast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30}),
            new PotentialSprite("Meow Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30, Stats.MIN_LUCK: 20, Stats.MAX_LUCK: 20})
                ..helpPhrase =
                    "is kind of helpful? Maybe? You can't tell if it loves their player or hates them. ",
            new PotentialSprite("Bark Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 40})

                ..helpPhrase =
                    "alternates between loud, insistent barks and long, eloquent monologues on the deeper meaning behind each and every fragment of the game. ",
            new PotentialSprite("Nut Creature", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30, Stats.MOBILITY: 30})
            ,
            new PotentialSprite("Gobblefiend", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 50}) //turkeys are honestly terrifying.

                ..helpfulness = -1
                ..helpPhrase =
                    "is the most unhelpful piece of shit in the world. Oh my god, just once. Please, just shut up. ",
            new PotentialSprite("Bicyclops", null) //laser fraymotif?
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Centaur", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 50, Stats.SANITY: 50}) //lusii in the butler genus simply are unflappable.
            ,
            new PotentialSprite("Fairy Bull", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 1}) //kinda useless. like a small dog or something.
            ,
            new PotentialSprite("Slither Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})

                ..armless = true,
            new PotentialSprite("Wiggle Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Honkbird", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Dig Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Cholerbear", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 50})
            ,
            new PotentialSprite("Antler Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30, Stats.MOBILITY: 30})
            ,
            new PotentialSprite("Ram Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Crab", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Spider", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Thief Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("March Bug", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Nibble Vermin", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Woolbeast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Hop Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30, Stats.MAX_LUCK: 30})
            ,
            new PotentialSprite("Stink Creature", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Speed Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30, Stats.MOBILITY: 50})
            ,
            new PotentialSprite("Jump Creature", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Fight Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 50})
            ,
            new PotentialSprite("Claw Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 50})
            ,
            new PotentialSprite("Tooth Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 50})
            ,
            new PotentialSprite("Armor Beast", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 30, Stats.CURRENT_HEALTH: 100, Stats.HEALTH: 100})
                ..lusus = true
            ,
            new PotentialSprite("Trap Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})

        ];

////////////////////////sea lusii

        PotentialSprite.sea_lusus_objects = <PotentialSprite>[
            new PotentialSprite("Zap Beast", null) //zap fraymotif
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 50})
            ,
            new PotentialSprite("Sea Slither Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})

                ..armless = true,
            new PotentialSprite("Electric Beast", null) //zap fraymotif
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 50})
                ..armless = true,
            new PotentialSprite("Whale", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 30, Stats.CURRENT_HEALTH: 50, Stats.HEALTH: 50})
                ..lusus = true
                ..armless = true,
            new PotentialSprite("Sky Horse", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30, Stats.MOBILITY: 20})
            ,
            new PotentialSprite("Sea Meow Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30, Stats.MIN_LUCK: 20, Stats.MAX_LUCK: 20})
            ,
            new PotentialSprite("Sea Hoofbeast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Cuttlefish", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Swim Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Sea Goat", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30, Stats.MIN_LUCK: -30, Stats.MAX_LUCK: 30})

            ,
            new PotentialSprite("Light Beast", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Dive Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Honkbird", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Sea Bear", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Sea Armorbeast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30, Stats.CURRENT_HEALTH: 50, Stats.HEALTH: 50})

        ];

    }
}



