import 'dart:collection';

typedef double WeightFunction<T>(T item, double weight);

class WeightedList<T> extends Object with ListMixin<T> {
    WeightFunction<T> initialWeightSetter;

    List<WeightPair<T>> _list;

    WeightedList({int length, WeightFunction<T> this.initialWeightSetter}) {
        if (length == null) {
            this._list = new List<WeightPair<T>>();
        } else {
            this._list = new List<WeightPair<T>>(length);
        }
    }

    factory WeightedList.from(Iterable<dynamic> other, {bool growable = true, WeightFunction<T> initialWeightSetter}) {
        WeightedList<T> list;
        if (growable) {
            list = new WeightedList<T>(initialWeightSetter: initialWeightSetter)..length = other.length;
        } else {
            list = new WeightedList<T>(length: other.length, initialWeightSetter: initialWeightSetter);
        }
        if (other is Iterable<T>) {
            if (other is WeightedList<T>) {
                for (int i=0; i<other.length; i++) {
                    list._list[i] = other._list[i];
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
                    list._list[i] = entry;
                } else {
                    throw "Invalid entry type ${entry.runtimeType} for WeightedList<$T>. Should be $T or WeightPair<$T>.";
                }
            }
        }
        return list;
    }

    double getTotalWeight() {
        double totalWeight = 0.0;
        for (WeightPair<T> pair in _list) {
            totalWeight += _getWeight(pair);
        }
        return totalWeight;
    }

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
    // internals

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
}

class WeightPair<T> {
    T item;
    double weight;

    WeightPair(T this.item, double this.weight);
}

abstract class WeightedItem {
    double getInitialWeight(double weight);
    double getWeight(double weight);
}