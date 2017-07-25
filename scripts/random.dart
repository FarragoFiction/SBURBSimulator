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
	int nextInt([int max = 0xFFFFFFFF]) => this._impl.nextInt(max);

	@override
	bool nextBool() => this._impl.nextBool();

	@override
	double nextDouble() => this._impl.nextDouble();

	// new stuff #######################################

	void setSeed(int seed) {
		this._impl = new Math.Random(seed);
	}

	int nextIntRange(int min, int max) => this._impl.nextInt(max-min) + min;

	T pickFrom<T>(List<T> list) {
		return list[this.nextInt(list.length)];
	}
}