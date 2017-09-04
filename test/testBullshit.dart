//if the console keeps crashing on me then i'll just use the command line here

import 'dart:async';

DateTime first;
DateTime second;
main() {
    first = new DateTime.now();
    new Timer(const Duration(milliseconds: 1000), after1Second);
}

after1Second() {
    second = new DateTime.now();
    print("first is $first and second is $second and the differenece is ${msToTime(second.difference(first))} or  ${(second.difference(first))}");
}

String msToTime(Duration dur) {
    //i can't figure out a better way to use this.
    return "$dur";
}