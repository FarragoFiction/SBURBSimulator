import "dart:collection";
import "../../SBURBSim.dart";

/// Interface for objects with stats when you don't care about anything else.
/// Mostly for when you want to support [StatHolder] AND [StatOwner] in a method.
abstract class StatObject {
    StatHolder getStatHolder();
}

class StatHolder extends Object with IterableMixin<Stat> implements StatObject {
    final Map<Stat, double> _base = <Stat, double>{};

    List<Buff> _buffs = <Buff>[];

    StatHolder();

    Iterable<Buff> get buffs => this._buffs;

    @override
    StatHolder getStatHolder() => this;

    void copyFrom(StatHolder other) {
        for (Stat s in other._base.keys) {
            this._base[s] = other._base[s];
        }
        for (Buff b in other._buffs) {
            this._buffs.add(b.copy());
        }
    }

    double operator [](Stat key) => derive(key);

    double getBase(Stat key) => _base.containsKey(key) ? _base[key] : 0.0;
    void setBase(Stat key, num val) => _base[key] = val.toDouble();
    void addBase(Stat key, num val) => _base[key] = getBase(key) + val.toDouble();

    void setMap(Map<Stat,num> map) {
        for (Stat stat in map.keys) {
            this.setBase(stat, map[stat]);
        }
    }

    Iterable<Buff> getBuffsForStat(Stat stat) {
        return this._buffs.where((Buff b) => b.stats.contains(stat));
    }

    double applyBaseAdditive(Stat stat, double val, Iterable<Buff> relevantBuffs) {
        for (Buff b in relevantBuffs) {
            val = b.baseAdditive(this, stat, val);
        }
        return val;
    }

    double applyAdditional(Stat stat, double val, Iterable<Buff> relevantBuffs) {
        double additive = 0.0;
        for (Buff b in relevantBuffs) {
            additive += b.additional(this, stat, val) - val;
        }
        return val + additive;
    }

    double applyMore(Stat stat, double val, Iterable<Buff> relevantBuffs) {
        for (Buff b in relevantBuffs) {
            val = b.more(this, stat, val);
        }
        return val;
    }

    double applyFinalAdditive(Stat stat, double val, Iterable<Buff> relevantBuffs) {
        for (Buff b in relevantBuffs) {
            val = b.flatAdditive(this, stat, val);
        }
        return val;
    }

    double derive(Stat stat, [Predicate<Buff> filter = null]) {
        // get the actual base value
        double val = this.getBase(stat).clamp(stat.minBase, stat.maxBase);

        Iterable<Buff> relevantBuffs = this.getBuffsForStat(stat);
        if (filter != null) {
            relevantBuffs = relevantBuffs.where(filter);
        }

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

        val = val.clamp(stat.minDerived, stat.maxDerived);
        return val;
    }

    void buffTick() {
        for (Buff b in _buffs) {
            b.tick();
        }
        this.checkBuffRemovals();
    }

    void buffCombatTick() {
        for (Buff b in _buffs) {
            b.combatTick();
        }
        this.checkBuffRemovals();
    }

    void checkBuffRemovals() {
        for (int i=this._buffs.length-1; i>=0; i--) {
            Buff b = this._buffs[i];
            if (b.shouldRemove()) {
                this._buffs.removeAt(i);
            }
        }
    }

    void onDeath() {
        this._buffs.retainWhere((Buff buff) => buff.persistsThroughDeath);
    }

    void onCombatEnd() {
        this._buffs.retainWhere((Buff buff) => buff.combat == false);
    }

    @override
    Iterator<Stat> get iterator => this._base.keys.iterator;
    @override
    int get length => this._base.length;

    void addBuff(Buff buff, {String name, Object source}) {
        buff..nametag=name..source=source;

        if(buff.allowStacking) {
            if (buff.timed && buff.stackDuration) {
                Iterable<Buff> matching = this.findBuffs(name, source);
                if (matching.isEmpty) {
                    this._buffs.add(buff);
                } else {
                    matching.first.maxAge += buff.maxAge - buff.age;
                }
            } else {
                this._buffs.add(buff);
            }
        } else {
            this.removeBuff(name, source);
            this._buffs.add(buff);
        }
    }

    void removeSpecificBuff(Buff buff) {
        this._buffs.remove(buff);
    }

    void removeBuff(String name, Object source) {
        this._buffs.removeWhere((Buff b) => b.nametag == name && b.source == source);
    }

    Iterable<Buff> findBuffs(String name, Object source) => _buffs.where((Buff b) => b.nametag == name && b.source == source);
}

abstract class StatOwner implements StatObject {
    StatHolder _stats;

    @override
    StatHolder getStatHolder() => this.stats;

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
            return;
        }
        throw "Invalid type for StatOwner.stats in $this: $other (${other.runtimeType})";
    }

    StatHolder createHolder();

    void buffTick() => stats.buffTick();
    void buffCombatTick() => stats.buffCombatTick();

    Iterable<Buff> get buffs => _stats.buffs;

    void addBuff(Buff buff, {String name, Object source}) => _stats.addBuff(buff, name:name, source:source);
    void removeBuff(String name, Object source) => _stats.removeBuff(name, source);

    double getStat(Stat stat, [bool raw = false]) => raw ? this.stats[stat] / stat.coefficient : this.stats[stat];
    void addStat(Stat stat, num val) => this.stats.addBase(stat, val.toDouble());
    void setStat(Stat stat, num val) => this.stats.setBase(stat, val.toDouble());
}

abstract class OwnedStatHolder<T extends StatOwner> extends StatHolder {
    T owner;

    OwnedStatHolder(T this.owner);
}

class ProphecyStatHolder<T extends GameEntity> extends OwnedStatHolder<T> {

    ProphecyStatHolder(T owner):super(owner);

    @override
    double applyMore(Stat stat, double val, Iterable<Buff> relevantBuffs) {
        val = super.applyMore(stat, val, relevantBuffs);

        if (stat.pickable) {
            if (owner.prophecy == ProphecyState.ACTIVE) {
                return val * 0.667;
            } else if (owner.prophecy == ProphecyState.FULLFILLED) {
                return val * 1.5;
            }
        }
        return val;
    }

    @override
    void setBase(Stat key, num val) {
        /*if (owner.session != null) {
            owner.session.logger.error("SET $owner: $key = $val");
        }*/
        super.setBase(key, val);
    }
    @override
    void addBase(Stat key, num val) {
        /*if (owner.session != null) {
            owner.session.logger.error("ADD $owner: $key += $val");
        }*/
        super.addBase(key, val);
    }
}

class PlayerStatHolder extends ProphecyStatHolder<Player> {

    static List<Stat> playerStats = <Stat>[Stats.POWER, Stats.HEALTH, Stats.SBURB_LORE, Stats.SANITY, Stats.FREE_WILL, Stats.MAX_LUCK, Stats.MIN_LUCK, Stats.MOBILITY, Stats.ALCHEMY, Stats.RELATIONSHIPS];

    PlayerStatHolder(Player owner):super(owner);

    @override
    Iterable<Buff> getBuffsForStat(Stat stat) {
        List<Buff> b = super.getBuffsForStat(stat).toList();
        b.addAll(owner.aspect.statModifiers.where((Buff b) => b.stats.contains(stat)));
        b.addAll(owner.class_name.statModifiers.where((Buff b) => b.stats.contains(stat)));
        return b;
    }
}

class CarapaceStatHolder extends ProphecyStatHolder<Carapace> {

    CarapaceStatHolder(Carapace owner):super(owner);

    @override
    double applyFinalAdditive(Stat stat, double val, Iterable<Buff> relevantBuffs) {
        val = super.applyFinalAdditive(stat, val, relevantBuffs);
        if (owner.crowned != null) {
            if (!stat.transient) {
                val += owner.crowned.getStat(stat);
            }
        }
        return val;
    }
}