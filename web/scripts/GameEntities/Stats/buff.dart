import "../../SBURBSim.dart";

abstract class Buff {
    Object source;
    String nametag;

    final bool combat;
    final bool timed;
    bool persistsThroughDeath = false;
    final Set<Stat> stats = new Set<Stat>();
    int age = 0;
    int maxAge = 0;

    /// If false, when this buff is applied it will check for a buff with the same name and source and remove it if found.
    bool allowStacking = true;
    /// If true, when stacking will add its remaining duration to the duration of a matching buff instead of adding to the buff list.
    bool stackDuration = false;

    Buff(Stat stat, bool this.combat, bool this.timed, [int this.maxAge= 0]) {
        this.stats.add(stat);
    }

    Buff.multiple(Iterable<Stat> stats, bool this.combat, bool this.timed, [int this.maxAge= 0]) {
        this.stats.addAll(stats);
    }

    double ageMultiplier(int age) => 1.0;

    double baseAdditive(StatHolder holder, Stat stat, double val) => val;
    double additional(StatHolder holder, Stat stat, double val) => val;
    double more(StatHolder holder, Stat stat, double val) => val;
    double flatAdditive(StatHolder holder, Stat stat, double val) => val;

    Buff copy();

    void tick() {
        if (this.timed && !this.combat) {
            this.age++;
        }
    }
    void combatTick() {
        if (this.timed && this.combat) {
            this.age++;
        }
    }

    bool shouldRemove() {
         if(this.timed) {
             if (this.age >= this.maxAge) {
                 return true;
             }
         }
         return false;
    }

    @override
    String toString() => "$runtimeType: ${combat?"(combat) ":""}$stats";
}

class BuffAdditional extends Buff {
    double multiplier;
    BuffAdditional(Stat stat, double this.multiplier, {bool combat = false, bool timed = false, int maxAge = 0}):super(stat, combat, timed, maxAge);
    BuffAdditional.multiple(Iterable<Stat> stats, double this.multiplier, {bool combat = false, bool timed = false, int maxAge = 0}):super.multiple(stats, combat, timed, maxAge);

    @override
    double additional(StatHolder holder, Stat stat, double val) => val * multiplier;
    
    @override
    BuffAdditional copy() {
        return new BuffAdditional.multiple(this.stats, this.multiplier, combat:this.combat, timed:this.timed, maxAge:this.maxAge)
            ..age = this.maxAge
            ..persistsThroughDeath = this.persistsThroughDeath;
    }

    @override
    String toString() => "${super.toString()}, mult: $multiplier";
}

class BuffMore extends Buff {
    double multiplier;
    BuffMore(Stat stat, double this.multiplier, {bool combat = false, bool timed = false, int maxAge = 0}):super(stat, combat, timed, maxAge);
    BuffMore.multiple(Iterable<Stat> stats, double this.multiplier, {bool combat = false, bool timed = false, int maxAge = 0}):super.multiple(stats, combat, timed, maxAge);

    @override
    double more(StatHolder holder, Stat stat, double val) => val * multiplier;

    @override
    BuffMore copy() {
        return new BuffMore.multiple(this.stats, this.multiplier, combat:this.combat, timed:this.timed, maxAge:this.maxAge)
            ..age = this.maxAge
            ..persistsThroughDeath = this.persistsThroughDeath;
    }

    @override
    String toString() => "${super.toString()}, mult: $multiplier";
}

class BuffFlat extends Buff {
    double value;
    BuffFlat(Stat stat, double this.value, {bool combat = false, bool timed = false, int maxAge = 0}):super(stat, combat, timed, maxAge);
    BuffFlat.multiple(Iterable<Stat> stats, double this.value, {bool combat = false, bool timed = false, int maxAge = 0}):super.multiple(stats, combat, timed, maxAge);

    @override
    double flatAdditive(StatHolder holder, Stat stat, double val) => val + this.value;

    @override
    BuffFlat copy() {
        return new BuffFlat.multiple(this.stats, this.value, combat:this.combat, timed:this.timed, maxAge:this.maxAge)
            ..age = this.maxAge
            ..persistsThroughDeath = this.persistsThroughDeath;
    }

    @override
    String toString() => "${super.toString()}, val: $value";
}

class BuffBase extends Buff {
    double value;
    BuffBase(Stat stat, double this.value, {bool combat = false, bool timed = false, int maxAge = 0}):super(stat, combat, timed, maxAge);
    BuffBase.multiple(Iterable<Stat> stats, double this.value, {bool combat = false, bool timed = false, int maxAge = 0}):super.multiple(stats, combat, timed, maxAge);

    @override
    double baseAdditive(StatHolder holder, Stat stat, double val) => val + this.value;

    @override
    BuffBase copy() {
        return new BuffBase.multiple(this.stats, this.value, combat:this.combat, timed:this.timed, maxAge:this.maxAge)
            ..age = this.maxAge
            ..persistsThroughDeath = this.persistsThroughDeath;
    }

    @override
    String toString() => "${super.toString()}, val: $value";
}

//JR here, derping around in teh code. Sorry PL.
class BuffSpecibus extends Buff {
    //need to have or can't know what specibus they have right now. don't assume it stays constant.
    GameEntity gameEntity;


    BuffSpecibus(this.gameEntity):super.multiple(Stats.all, false, false){
        this.persistsThroughDeath = true;
    }

    @override
    Buff copy() {
      return new BuffSpecibus(gameEntity);
    }

    @override
    double additional(StatHolder holder, Stat stat, double val) {
        //return val;
        if (stat == Stats.SBURB_LORE ) {
            return val;
        }
        if (stat.pickable) {
            if(stat == Stats.HEALTH || stat == Stats.CURRENT_HEALTH || stat == Stats.POWER) {
                double ret = val * (1.0 + gameEntity.specibus.rank);
                //print("buff health stat ret is $ret");
                if(ret <1) {
                    //print("NEGATIVE buff health stat ret is $ret  for $gameEntity so am returning 1.0 instead.");
                    return 1.0;
                }
                return ret;
            } else {
                return val * (1.0 + gameEntity.specibus.rank);
            }
        }
        return val;
    }
}


//JR here, derping around in teh code. Sorry PL.
class BuffLord extends Buff {
    //lords get buffs based on their living minions
    GameEntity gameEntity;


    BuffLord(this.gameEntity):super.multiple(Stats.all, false, false){
        this.persistsThroughDeath = true;
    }

    @override
    Buff copy() {
        return new BuffSpecibus(gameEntity);
    }

    @override
    double additional(StatHolder holder, Stat stat, double val) {
        //in theory other things but lords could get this buff, too, eventually
        //and if you change into a Lord suddenly you still get your buff.
        if(!(gameEntity is Player)) {
            return val;
        }else {
            Player p = gameEntity as Player;
            if(p.class_name != SBURBClassManager.LORD) return val;
        }

        if (stat == Stats.SBURB_LORE ) {
            return val;
        }
        if (stat.pickable) {
            if(stat == Stats.HEALTH || stat == Stats.CURRENT_HEALTH || stat == Stats.POWER) {
                //print("buff health stat");
                if(val + sumMinionStats(holder, stat, val)<1) {
                    print ("$gameEntity would have gotten negative hp from this shitty minion. ${val + sumMinionStats(holder, stat, val)}. They have ${gameEntity.companionsCopy.length} minions. And their natural hp would have been ${val}");
                    return 1.0;
                }
                return val + sumMinionStats(holder, stat, val);
            }else {
                return val + sumMinionStats(holder, stat, val);
            }
        }
        return val;
    }

    double sumMinionStats(StatHolder holder, Stat stat, double val) {
        double ret = 0.0;
        for(GameEntity g in gameEntity.companionsCopy) {
            if(!g.dead) {
                ret += g.getStat(stat);
            }
        }
        return ret;
    }
}

class BuffGodTier extends Buff {
    BuffGodTier():super.multiple(Stats.all, false, false){
        this.persistsThroughDeath = true;
    }

    @override
    BuffGodTier copy() {
        return new BuffGodTier();
    }

    @override
    double baseAdditive(StatHolder holder, Stat stat, double val) {
        if (stat == Stats.HEALTH || stat == Stats.POWER) {
            return val + 100;
        }
        return val;
    }

    @override
    double additional(StatHolder holder, Stat stat, double val) {
        if (stat == Stats.SBURB_LORE) {
            return val * 15.0;
        }
        if (stat.pickable) {
            return val * 2.5;
        }
        return val;
    }

    @override
    String toString() => "God Tier";
}

class BuffDenizenBeaten extends BuffAdditional {
    BuffDenizenBeaten():super.multiple(PlayerStatHolder.playerStats, 2.0) {
        this.persistsThroughDeath = true;
    }
}

class BuffTricksterMode extends Buff {
    BuffTricksterMode():super.multiple(Stats.pickable, false, false){
        this.persistsThroughDeath = true;
    }

    @override
    BuffTricksterMode copy() => new BuffTricksterMode();

    @override
    double flatAdditive(StatHolder holder, Stat stat, double val) {
        if (holder is PlayerStatHolder) {
            if (holder.owner.trickster && !holder.owner.aspect.ultimateDeadpan) {
                return 11111111111.0;
            }
        }
        return val;
    }
}