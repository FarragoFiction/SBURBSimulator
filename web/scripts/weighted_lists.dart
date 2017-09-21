import 'dart:collection';
import 'includes/predicates.dart';

typedef double WeightFunction<T>(T item, double weight);

/// Used as a basis to [WeightedList] to allow Random.pick and similar to use weights.
abstract class WeightedIterable<T> implements Iterable<T> {
    WeightFunction<T> initialWeightSetter;
    T get(double position) {
        double totalWeight = getTotalWeight();

        double weightPosition = position.clamp(0.0,1.0) * totalWeight;
        double runningTotal = 0.0;

        for (WeightPair<T> pair in pairs) {
            runningTotal += _getWeight(pair);
            if (weightPosition <= runningTotal) {
                return pair.item;
            }
        }

        return null; // shouldn't happen
    }

    Iterable<WeightPair<T>> get pairs;

    double getTotalWeight() {
        double totalWeight = 0.0;
        for (WeightPair<T> pair in pairs) {
            totalWeight += _getWeight(pair);
        }
        return totalWeight;
    }

    WeightPair<T> _createPair(T item, [double weight = 1.0]) {
        return new WeightPair<T>(item, _getInitialWeight(item, weight));
    }

    double _getInitialWeight(T item, double weight) {
        if (item is WeightedItem) {
            return item.getInitialWeight(weight);
        } else if (this.initialWeightSetter != null) {
            return initialWeightSetter(item, weight);
        }
        return weight;
    }

    double _getWeight(WeightPair<T> pair) {
        T item = pair.item;
        if (item is WeightedItem) {
            return item.getWeight(pair.weight);
        }
        return pair.weight;
    }

    @override
    Iterable<T> where(Predicate<T> test) => new WeightedWhereIterable<T>(this, test);

    @override
    Iterable<T> take(int count) => new WeightedTakeIterable<T>(this, count);

    @override
    Iterable<T> takeWhile(Predicate<T> test) => new WeightedTakeWhileIterable<T>(this, test);

    @override
    Iterable<U> map<U>(Mapping<T,U> mapping) => new WeightedMappedIterable<T,U>(this, mapping);

    @override
    List<T> toList({bool growable = true}) => new WeightedList<T>.from(this, growable: growable);
}

class WeightedList<T> extends WeightedIterable<T> with ListMixin<T> {


    List<WeightPair<T>> _list;

    WeightedList({int length, WeightFunction<T> initialWeightSetter}) {
        this.initialWeightSetter = initialWeightSetter;
        if (length == null) {
            this._list = new List<WeightPair<T>>();
        } else {
            this._list = new List<WeightPair<T>>(length);
        }
    }

    factory WeightedList.from(Iterable<dynamic> other, {bool growable = true, WeightFunction<T> initialWeightSetter, bool copyPairs = false}) {
        WeightedList<T> list;
        if (growable == true) {
            list = new WeightedList<T>(initialWeightSetter: initialWeightSetter)..length = other.length;
        } else {
            list = new WeightedList<T>(length: other.length, initialWeightSetter: initialWeightSetter);
        }
        if (other is Iterable<T>) {
            if (other is WeightedIterable<T>) {
                int i=0;
                for (WeightPair<T> pair in other.pairs) {
                    if (copyPairs) {
                        list._list[i] = new WeightPair<T>.from(pair);
                    }else{
                        list._list[i] = pair;
                    }
                    i++;
                }
            } else {
                int i=0;
                for (T item in other) {
                    list[i] = item;
                    i++;
                }
            }
        } else {
            int i=0;
            for (dynamic entry in other) {
                if (entry is T) {
                    list[i] = entry;
                } else if (entry is WeightPair<T>) {
                    if (copyPairs) {
                        list._list[i] = new WeightPair<T>.from(entry);
                    } else {
                        list._list[i] = entry;
                    }
                } else {
                    throw "Invalid entry type ${entry.runtimeType} for WeightedList<$T>. Should be $T or WeightPair<$T>.";
                }
            }
        }
        return list;
    }

    @override
    T get(double position) {
        double totalWeight = getTotalWeight();

        double weightPosition = position.clamp(0.0,1.0) * totalWeight;
        double runningTotal = 0.0;

        for (WeightPair<T> pair in _list) {
            runningTotal += _getWeight(pair);
            if (weightPosition <= runningTotal) {
                return pair.item;
            }
        }

        return null; // shouldn't happen
    }

    WeightPair<T> getPair(int index) {
        return _list[index];
    }

    void setPair(int index, WeightPair<T> pair) {
        _list[index] = pair;
    }

    @override
    Iterable<WeightPair<T>> get pairs => _list;

    // ##########################################
    // Add single

    @override
    void add(T item, [num weight = 1.0]) {
        _list.add(_createPair(item, weight.toDouble()));
    }

    void addPair(WeightPair<T> pair) {
        _list.add(pair);
    }

    // ##########################################
    // Add multiple

    @override
    void addAll(Iterable<T> items) {
        if (items is WeightedList<T>) {
            _list.addAll(items.pairs);
        } else {
            _list.addAll(items.map(_createPair));
        }
    }

    void addAllIterables(Iterable<T> items, Iterable<double> weights) {
        int index = _list.length;
        _list.length += items.length;

        Iterator<T> item_iter = items.iterator;
        Iterator<double> weight_iter = weights.iterator;

        while(item_iter.moveNext()) {
            double weight = weight_iter.moveNext() ? weight_iter.current : 1.0;
            _list[index] = _createPair(item_iter.current, weight);
            index++;
        }
    }

    void addAllGenerative(Iterable<T> items, double generator(T input)) {
        _list.addAll(items.map((T item) => _createPair(item, generator(item))));
    }

    // ##########################################
    // overrides

    @override
    T operator [](int index) => _list[index].item;

    @override
    void operator []=(int index, T value){
        _list[index] = _createPair(value);
    }

    @override
    int get length => _list.length;

    @override
    void set length(int val) => _list.length = val;

    // it's bullshit that I have to re-override these but hey it's the simplest way...

    @override
    Iterable<T> where(Predicate<T> test) => new WeightedWhereIterable<T>(this, test);

    @override
    Iterable<T> take(int count) => new WeightedTakeIterable<T>(this, count);

    @override
    Iterable<T> takeWhile(Predicate<T> test) => new WeightedTakeWhileIterable<T>(this, test);

    @override
    Iterable<U> map<U>(Mapping<T,U> mapping) => new WeightedMappedIterable<T,U>(this, mapping);

    @override
    List<T> toList({bool growable = true}) => new WeightedList<T>.from(this, growable: growable);
}

class WeightPair<T> {
    T item;
    double weight;

    WeightPair(T this.item, double this.weight);

    factory WeightPair.from(WeightPair<T> other) {
        return new WeightPair<T>(other.item, other.weight);
    }
}

abstract class WeightedItem {
    double getInitialWeight(double weight);
    double getWeight(double weight);
}

abstract class WrappedWeightedIterable<T> extends WeightedIterable<T> with IterableMixin<T> {
    final Iterable<WeightPair<T>> source;

    WrappedWeightedIterable(Iterable<WeightPair<T>> this.source);

    @override
    Iterable<WeightPair<T>> get pairs => source;

    @override
    Iterator<T> get iterator => new WeightPairIterator<T>(this);

    @override
    int get length => source.length;

    // it's bullshit that I have to re-override these but hey it's the simplest way...

    @override
    Iterable<T> where(Predicate<T> test) => new WeightedWhereIterable<T>(this, test);

    @override
    Iterable<T> take(int count) => new WeightedTakeIterable<T>(this, count);

    @override
    Iterable<T> takeWhile(Predicate<T> test) => new WeightedTakeWhileIterable<T>(this, test);

    @override
    Iterable<U> map<U>(Mapping<T,U> mapping) => new WeightedMappedIterable<T,U>(this, mapping);

    @override
    List<T> toList({bool growable = true}) => new WeightedList<T>.from(this, growable: growable);
}

class WeightPairIterator<T> extends Iterator<T> {
    Iterator<WeightPair<T>> _iter;

    WeightPairIterator(WeightedIterable<T> iterable) {
        this._iter = iterable.pairs.iterator;
    }

    @override
    T get current => _iter.current.item;

    @override
    bool moveNext() => _iter.moveNext();
}

class WeightedWhereIterable<T> extends WrappedWeightedIterable<T> {
    WeightedWhereIterable(WeightedIterable<T> source, Predicate<T> predicate):super(source.pairs.where((WeightPair<T> pair) => predicate(pair.item)));
}

class WeightedTakeIterable<T> extends WrappedWeightedIterable<T> {
    WeightedTakeIterable(WeightedIterable<T> source, int count):super(source.pairs.take(count));
}

class WeightedTakeWhileIterable<T> extends WrappedWeightedIterable<T> {
    WeightedTakeWhileIterable(WeightedIterable<T> source, Predicate<T> predicate):super(source.pairs.takeWhile((WeightPair<T> pair) => predicate(pair.item)));
}

class WeightedMappedIterable<T, U> extends WrappedWeightedIterable<U> {
    WeightedMappedIterable(WeightedIterable<T> source, Mapping<T, U> mapping) :super(source.pairs.map((WeightPair<T> pair) => new WeightPair<U>(mapping(pair.item), pair.weight)));
}


