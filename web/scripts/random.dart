import "dart:math" as Math;
import "weighted_lists.dart";

/// Wraps [Math.Random] to allow adding functionality... a bit evil but it'll do.
///
/// Can be fed to anything which wants a Math.Random without issues
class Random implements Math.Random {
	Math.Random _impl;
	/// used for spawning a new random from this one without new stuff
	int _echo;

	Random([int seed = null]) {
		this.setSeed(seed);
	}

	Random spawn() => new Random(this._echo +1);

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
			double val = this._impl.nextDouble();
			_echo = (val * 0xFFFFFFFF).round();

			return (val * max).floor();
		} else {
			int val = this._impl.nextInt(max);
			_echo = val;
			return val;
		}
	}

	@override
	bool nextBool() {
		_echo = _echo + 1;
		return this._impl.nextBool();
	}

	@override
	double nextDouble([double max = 1.0]) => this._impl.nextDouble() * max;

	// new stuff #######################################

	void setSeed(int seed) {
		this._impl = new Math.Random(seed);
		if(seed != null)_echo = seed + 1;
	}

	int nextIntRange(int min, int max) => this.nextInt(1+max-min) + min;

	T pickFrom<T>(Iterable<T> list, [bool useWeights = true]) {
		if (list.isEmpty) { return null; }
		if (useWeights && list is WeightedIterable<T>) {
			return list.get(this.nextDouble());
		}
		return list.elementAt(this.nextInt(list.length));
	}

	double nextDoubleRange(double min, double max) => this.nextDouble(max-min) + min;
}
