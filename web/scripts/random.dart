part of SBURBSim;

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
			return -this._impl.nextInt(-max);
		}
		return this._impl.nextInt(max);
	}

	@override
	bool nextBool() => this._impl.nextBool();

	@override
	double nextDouble() => this._impl.nextDouble();

	// new stuff #######################################

	void setSeed(int seed) {
		this._impl = new Math.Random(seed);
	}

	int nextIntRange(int min, int max) => this.nextInt(max-min) + min;

	T pickFrom<T>(List<T> list) {
		if (list.isEmpty) { return null; }
		return list[this.nextInt(list.length)];
	}
}
