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

    Iterable<Buff> getBuffsForStat(Stat stat) {
        return this.buffs.where((Buff b) => b.stats.contains(stat));
    }

    double applyBaseAdditive(Stat stat, double val, Iterable<Buff> relevantBuffs) {
        for (Buff b in relevantBuffs) {
            val = b.baseAdditive(stat, val);
        }
        return val;
    }

    double applyAdditional(Stat stat, double val, Iterable<Buff> relevantBuffs) {
        double additive = 0.0;
        for (Buff b in relevantBuffs) {
            additive += b.additional(stat, val) - val;
        }
        return val + additive;
    }

    double applyMore(Stat stat, double val, Iterable<Buff> relevantBuffs) {
        for (Buff b in relevantBuffs) {
            val = b.more(stat, val);
        }
        return val;
    }

    double applyFinalAdditive(Stat stat, double val, Iterable<Buff> relevantBuffs) {
        for (Buff b in relevantBuffs) {
            val = b.flatAdditive(stat, val);
        }
        return val;
    }

    double derive(Stat stat) {
        // get the actual base value
        double val = this.getBase(stat);

        Iterable<Buff> relevantBuffs = this.getBuffsForStat(stat);

        // add any base value from buffs
        val = this.applyBaseAdditive(stat, val, relevantBuffs);

        // let the stat do its own baseline modifications
        val = stat.derived(this, val);

        // additional - additve modifiers
        val = this.applyAdditional(stat, val, relevantBuffs);

        // more - multiplicative modifiers
        val = this.applyMore(stat, val, relevantBuffs);

        // final flat additives
        val = this.applyFinalAdditive(stat, val, relevantBuffs);

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

class PlayerStatHolder extends StatHolder {
    Player player;

    PlayerStatHolder(Player this.player);

    @override
    Iterable<Buff> getBuffsForStat(Stat stat) {
        List<Buff> b = <Buff>[];
        b.addAll(player.aspect.statModifiers.where((Buff b) => b.stats.contains(stat)));
        b.addAll(player.class_name.statModifiers.where((Buff b) => b.stats.contains(stat)));
        b.addAll(this.buffs.where((Buff b) => b.stats.contains(stat)));
        return b;
    }
}