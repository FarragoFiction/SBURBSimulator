import "dart:math" as Math;
import "weighted_lists.dart";

/// Wraps [Math.Random] to allow adding functionality... a bit evil but it'll do.
///
/// Can be fed to anything which wants a Math.Random without issues
class Random implements Math.Random {
	Math.Random _impl;

	Random([int seed = null]) {
		this.setSeed(seed);
	}

	@override
	int nextInt([int max = 0xFFFFFFFF]) {
		if (max == 0) {return 0;}
		if (max < 0) {
			return -this._nextInt(-max);
		}
		return this._nextInt(max);
	}

	int _nextInt(int max) {
		//if (max > 2<<31) { //JR: turns out this path makes random do things differently compiled vs dart. let's keep this off for now.
		if (max > 0xFFFFFFFF) { //PL: THIS works fine though. I blame js and its bitshifting
			return (this._impl.nextDouble() * max).floor();
		} else {
			return this._impl.nextInt(max);
		}
	}

	@override
	bool nextBool() => this._impl.nextBool();

	@override
	double nextDouble([double max = 1.0]) => this._impl.nextDouble() * max;

	// new stuff #######################################

	void setSeed(int seed) {
		this._impl = new Math.Random(seed);
	}

	int nextIntRange(int min, int max) => this.nextInt(max-min) + min;

	T pickFrom<T>(Iterable<T> list, [bool useWeights = true]) {
		if (list.isEmpty) { return null; }
		if (useWeights && list is WeightedIterable<T>) {
			return list.get(this.nextDouble());
		}
		return list.elementAt(this.nextInt(list.length));
	}
}
