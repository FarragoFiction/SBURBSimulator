import "dart:math" as Math;

import "../web/scripts/random.dart";
import "../web/scripts/weighted_lists.dart";

void main() {
    //testBasicWeights();
    testGenerativeWeights();
}

void testBasicWeights() {
    print("Basic Weights:");

    WeightedList<String> list = new WeightedList<String>();

    Random rand = new Random();

    list
        ..add("test 1", rand.nextInt(9) + 1)
        ..add("test 2", rand.nextInt(9) + 1)
        ..add("test 3", rand.nextInt(9) + 1)
        ..add("test 4", rand.nextInt(9) + 1)
        ..add("test 5", rand.nextInt(9) + 1)
        ..add("test 6", rand.nextInt(9) + 1);

    testList(list);
}

void testGenerativeWeights() {
    print("Generative Weights:");

    WeightedList<int> list = new WeightedList<int>();

    List<int> numbers = <int>[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];

    list.addAllGenerative(numbers, (int item) => item.toDouble());

    testList(list);
}

void testList<T>(WeightedList<T> list) {
    Random rand = new Random();

    double totalWeight = list.getTotalWeight();

    Map<T, int> counts = <T, int>{};
    for (T s in list) {
        counts[s] = 0;
    }

    int testcount = 10000000;
    int matchplaces = 2;

    T picked;
    for (int i=0; i<testcount; i++) {
        picked = rand.pickFrom(list);

        counts[picked] = counts[picked] + 1;
    }

    print("Total weight $totalWeight after $testcount samples, matching to $matchplaces decimal places:");
    for (WeightPair<T> pair in list.pairs) {
        double testresult = counts[pair.item]/testcount;
        double expected = pair.weight/totalWeight;
        print("${pair.item}, weight ${pair.weight}: $testresult expected $expected, close enough: ${matchToPlaces(testresult, expected, matchplaces)}");
    }
}

bool matchToPlaces(double val, double match, int places) {
    int mult = Math.pow(10,places);

    val = (val * mult).roundToDouble() / mult;
    match = (match * mult).roundToDouble() / mult;

    return val == match;
}