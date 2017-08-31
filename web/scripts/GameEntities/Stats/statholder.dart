import "../../SBURBSim.dart";

class StatHolder {
    final Map<Stat, double> _base = <Stat, double>{};

    List<Buff> buffs = <Buff>[];

    StatHolder();

    void copyFrom(StatHolder other) {
        for (Stat s in other._base.keys) {
            this._base[s] = other._base[s];
        }
        for (Buff b in other.buffs) {
            this.buffs.add(b.copy());
        }
    }

    double operator [](Stat key) => derive(key);

    double getBase(Stat key) => _base.containsKey(key) ? _base[key] : 0.0;
    void setBase(Stat key, double val) => _base[key] = val;
    void addBase(Stat key, double val) => _base[key] = getBase(key) + val;

    double derive(Stat key) {
        // get the actual base value
        double val = this.getBase(key);

        // add any base value from buffs
        for (Buff b in buffs) {
            val = b.baseAdditive(val);
        }

        // let the stat do its own baseline modifications
        val = key.derived(this, val);

        // additional - additve modifiers
        double additive = 0.0;
        for (Buff b in buffs) {
            additive += b.additional(val) - val;
        }
        val += additive;

        // more - multiplicative modifiers
        for (Buff b in buffs) {
            val = b.more(val);
        }

        // final flat additives
        for (Buff b in buffs) {
            val = b.flatAdditive(val);
        }

        return val;
    }

    void buffTick() {
        for (Buff b in buffs) {
            b.tick();
        }
        this.checkBuffRemovals();
    }

    void buffCombatTick() {
        for (Buff b in buffs) {
            b.combatTick();
        }
        this.checkBuffRemovals();
    }

    void checkBuffRemovals() {
        for (int i=this.buffs.length-1; i>=0; i--) {
            Buff b = this.buffs[i];
            if (b.shouldRemove()) {
                this.buffs.removeAt(i);
            }
        }
    }
}

abstract class StatOwner {
    StatHolder _stats;

    void initStatHolder() {
        this._stats = this.createHolder();
    }

    StatHolder get stats => _stats;
    void set stats(Object other) {
        if (other is StatOwner) {
            this.stats = other.stats;
            return;
        } else if (other is StatHolder) {
            this._stats = createHolder()..copyFrom(other);
        }
        throw "Invalid type for StatOwner.stats in $this: $other (${other.runtimeType})";
    }

    StatHolder createHolder();

    void buffTick() => stats.buffTick();
    void buffCombatTick() => stats.buffCombatTick();
}