import 'SBURBSim.dart';
import 'dart:html';

//effects are frozen at creation, basically.  if this fraymotif is created by a Bard of Breath in a session with a Prince of Time,
//who then dies, and then a combo session results in an Heir of Time being able to use it with the Bard of Breath, then it'll still have the prince effect.
class FraymotifEffect {
    static int ALLIES = 1;
    static int ENEMIES = 3;
    static int SELF = 0;
    static int ENEMY = 2;
    Stat statName; //hp heals current hp AND revives the player.
    num target; //self, allies or enemy or enemies, 0, 1, 2, 3
    bool damageInsteadOfBuff = false; // statName can either be applied towards damaging someone or buffing someone.  (damaging self or allies is "healing", buffing enemies is applied in the negative direction.)
    num s = 0; //convineience methods cause i don't think js has enums but am too lazy to confirm.
    num a = 1;
    num e = 2;
    num e2 = 3;


    Fraymotif fraymotif;
    FraymotifEffectForm form;
    /// target 0  = self, 1 = allies, 2 = enemy 3 = enemies.
    FraymotifEffect(Stat this.statName, num this.target, bool this.damageInsteadOfBuff) {}

    JSONObject toJSON() {
        JSONObject json = new JSONObject();
        json["stat"] = statName.name;
        json["target"] = "$target";
        json["damageInsteadOfBuff"] = damageInsteadOfBuff.toString();
        return json;
    }

    void renderForm(Element container) {
        print ("render form for scene");
        form = new FraymotifEffectForm(this, container);
        form.drawForm();
    }


    void copyFromJSON(JSONObject json) {
       // print("copying fraymotif effect from json $json");
        statName = Stats.byName[json["stat"]];
        target = int.parse(json["target"]);
        if(json["damageInsteadOfBuff"] == "true") {
            damageInsteadOfBuff = true;
        }else {
            damageInsteadOfBuff = false;
        }
    }


    static List<FraymotifEffect> allEffectsTargetAll() {
        List<FraymotifEffect> ret = new List<FraymotifEffect>();
        ret.add(new FraymotifEffect(Stats.POWER, ALLIES, true));
        ret.add(new FraymotifEffect(Stats.POWER, ALLIES, false));
        ret.add(new FraymotifEffect(Stats.POWER, ENEMIES, true));
        ret.add(new FraymotifEffect(Stats.POWER, ENEMIES, false));
        return ret;
    }

    static List<FraymotifEffect> allEffectsTargetOne() {
        List<FraymotifEffect> ret = new List<FraymotifEffect>();
        ret.add(new FraymotifEffect(Stats.POWER, SELF, true));
        ret.add(new FraymotifEffect(Stats.POWER, SELF, false));
        ret.add(new FraymotifEffect(Stats.POWER, ENEMY, true));
        ret.add(new FraymotifEffect(Stats.POWER, ENEMY, false));
        return ret;
    }

    void setEffectForPlayer(Player player) {
        Random rand = player.rand;
        FraymotifEffect effect = new FraymotifEffect(null, this.e, true); //default to just damaging the enemy.
        if (player.class_name == SBURBClassManager.KNIGHT) effect = rand.pickFrom(this.knightEffects());
        if (player.class_name == SBURBClassManager.SEER) effect = rand.pickFrom(this.seerEffects());
        if (player.class_name == SBURBClassManager.BARD) effect = rand.pickFrom(this.bardEffects());
        if (player.class_name == SBURBClassManager.HEIR) effect = rand.pickFrom(this.heirEffects());
        if (player.class_name == SBURBClassManager.MAID) effect = rand.pickFrom(this.maidEffects());
        if (player.class_name == SBURBClassManager.ROGUE) effect = rand.pickFrom(this.rogueEffects());
        if (player.class_name == SBURBClassManager.PAGE) effect = rand.pickFrom(this.pageEffects());
        if (player.class_name == SBURBClassManager.THIEF) effect = rand.pickFrom(this.thiefEffects());
        if (player.class_name == SBURBClassManager.SYLPH) effect = rand.pickFrom(this.sylphEffects());
        if (player.class_name == SBURBClassManager.PRINCE) effect = rand.pickFrom(this.princeEffects());
        if (player.class_name == SBURBClassManager.WITCH) effect = rand.pickFrom(this.witchEffects());
        if (player.class_name == SBURBClassManager.MAGE) effect = rand.pickFrom(this.mageEffects());
        this.target = effect.target;
        this.damageInsteadOfBuff = effect.damageInsteadOfBuff;
        if (!player.associatedStatsFromAspect.isEmpty) { //null plyaers have no associated stats
            this.statName = rand.pickFrom(player.associatedStatsFromAspect).stat;
        } else {
            this.statName = Stats.POWER;
        }
    }

    List<FraymotifEffect> knightEffects() {
        return <FraymotifEffect>[new FraymotifEffect(null, this.s, true), new FraymotifEffect(null, this.e, true), new FraymotifEffect(null, this.e2, true), new FraymotifEffect(null, this.s, false), new FraymotifEffect(null, this.e, false)];
    }

    List<FraymotifEffect> seerEffects() {
        return <FraymotifEffect>[new FraymotifEffect(null, this.a, true), new FraymotifEffect(null, this.s, false), new FraymotifEffect(null, this.e, false), new FraymotifEffect(null, this.e2, false), new FraymotifEffect(null, this.a, false)];
    }

    List<FraymotifEffect> bardEffects() {
        List<FraymotifEffect> ret = <FraymotifEffect>[new FraymotifEffect(null, this.s, false), new FraymotifEffect(null, this.e, false), new FraymotifEffect(null, this.e2, false), new FraymotifEffect(null, this.a, false)];
        ret.addAll(<FraymotifEffect>[new FraymotifEffect(null, this.s, true), new FraymotifEffect(null, this.e, true), new FraymotifEffect(null, this.e2, true), new FraymotifEffect(null, this.a, true)]);
        return ret;
    }

    List<FraymotifEffect> heirEffects() {
        return <FraymotifEffect>[new FraymotifEffect(null, this.s, true), new FraymotifEffect(null, this.e2, true), new FraymotifEffect(null, this.s, false)];
    }

    List<FraymotifEffect> maidEffects() {
        return <FraymotifEffect>[new FraymotifEffect(null, this.e2, true), new FraymotifEffect(null, this.e, false), new FraymotifEffect(null, this.a, false)];
    }

    List<FraymotifEffect> rogueEffects() {
        return <FraymotifEffect>[new FraymotifEffect(null, this.e, true), new FraymotifEffect(null, this.a, false), new FraymotifEffect(null, this.e, false)];
    }

    List<FraymotifEffect> pageEffects() {
        return <FraymotifEffect>[new FraymotifEffect(null, this.a, true), new FraymotifEffect(null, this.a, false)];
    }

    List<FraymotifEffect> thiefEffects() {
        return <FraymotifEffect>[new FraymotifEffect(null, this.e, true), new FraymotifEffect(null, this.s, false), new FraymotifEffect(null, this.e, false)];
    }

    List<FraymotifEffect> sylphEffects() {
        return <FraymotifEffect>[new FraymotifEffect(null, this.a, true), new FraymotifEffect(null, this.s, false), new FraymotifEffect(null, this.a, false)];
    }

    List<FraymotifEffect> princeEffects() {
        return <FraymotifEffect>[new FraymotifEffect(null, this.e, true), new FraymotifEffect(null, this.e2, true), new FraymotifEffect(null, this.e2, false)];
    }

    List<FraymotifEffect> witchEffects() {
        return <FraymotifEffect>[new FraymotifEffect(null, this.e, true), new FraymotifEffect(null, this.s, true), new FraymotifEffect(null, this.e2, false)];
    }

    List<FraymotifEffect> mageEffects() {
        return <FraymotifEffect>[new FraymotifEffect(null, this.a, true), new FraymotifEffect(null, this.s, true), new FraymotifEffect(null, this.e2, false), new FraymotifEffect(null, this.e, false)];
    }

    void applyEffect(GameEntity owner, List<GameEntity> allies, List<GameEntity> casters, GameEntity enemy, List<GameEntity> enemies, double baseValue) {
        double strifeValue = this.processEffectValue(casters, enemies);
        double baseDouble = baseValue.toDouble();
        double effectValue = baseDouble;
        if (strifeValue < baseDouble) effectValue = baseDouble;
        if (strifeValue > baseDouble && strifeValue < (2 * baseDouble)) effectValue = 2 * baseDouble;
        if (strifeValue > (2 * baseDouble)) effectValue = 3 * baseDouble;

        //now, i need to USE this effect value.  is it doing "damage" or "buffing"?
        if (this.target == this.e || this.target == this.e2) effectValue = effectValue * -1; //do negative things to the enemy.
        List<GameEntity> targetArr = this.chooseTargetArr(owner, allies, casters, enemy, enemies);
        ////print(["target chosen: ", targetArr]);
        if (this.damageInsteadOfBuff) {
            ////print("applying damage: " + targetArr.length);
            //;
            this.applyDamage(targetArr, effectValue);
        } else {
            ////;
            //;
            this.applyBuff(targetArr, effectValue);
        }
    }

    List<GameEntity> chooseTargetArr(GameEntity owner, List<GameEntity> allies, List<GameEntity> casters, GameEntity enemy, List<GameEntity> enemies) {
        ////print(["potential targets: ",owner, allies, casters, enemies]);
        if (this.target == this.s) return <GameEntity>[owner];
        if (this.target == this.a) return allies;
        if (this.target == this.e) return <GameEntity>[enemy]; //all effects target same enemy.
        if (this.target == this.e2) return enemies;
        return null;
    }

    void applyDamage(List<GameEntity> targetArr, double effectValue) {
        double e = effectValue / targetArr.length; //more potent when a single target.
        ////print(["applying damage", effectValue, targetArr.length, e]);
        for (num i = 0; i < targetArr.length; i++) {
            GameEntity t = targetArr[i];

            t.addBuff(new BuffFlat(Stats.CURRENT_HEALTH, e, combat:true)); //don't mod directly anymore

            if (t.stats[Stats.CURRENT_HEALTH] > 0) {
                t.dead = false;
            }
        }
    }

    void applyBuff(List<GameEntity> targetArr, double effectValue) {
        double e = effectValue / targetArr.length; //more potent when a single target.
        for (num i = 0; i < targetArr.length; i++) {
            GameEntity t = targetArr[i];
            if (this.statName != Stats.RELATIONSHIPS) {
                //t[this.statName] += e;
                t.addBuff(new BuffFlat(this.statName, e, combat:true)); //don't mod directly anymore
            } else {
                for (num j = 0; j < t.relationships.length; j++) {
                    //t.relationships[j].value += e;
                    t.addBuff(new BuffFlat(this.statName, e, combat:true));
                }
            }
            //;
        }
    }

    double processEffectValue(List<GameEntity> casters, List<GameEntity> enemies) {
        double ret = 0.0;
        for (num i = 0; i < casters.length; i++) {
            GameEntity tmp = casters[i];
            ret += tmp.getStat(this.statName);
        }

        for (num i = 0; i < enemies.length; i++) {
            GameEntity tmp = enemies[i];
            ret += tmp.getStat(this.statName);
        }
        return ret;
    }

    String toStringSimple() {
        String ret = "";
        if (this.damageInsteadOfBuff && this.target < 2) {
            ret += "a heals";
        } else if (this.damageInsteadOfBuff && this.target >= 2) {
            ret += "a damages";
        } else if (!this.damageInsteadOfBuff && this.target < 2) {
            ret += "a buffs";
        } else if (!this.damageInsteadOfBuff && this.target >= 2) {
            ret += "a debuffs";
        }

        if (this.target == 0) {
            ret += " SELF";
        } else if (this.target == 1) {
            ret += " FRIENDSBLUH";
        } else if (this.target == 2) {
            ret += " EBLUH";
        } else if (this.target == 3) {
            ret += " ESBLUHS";
        }

        ret += " of STAT ";

        if (this.target == 0) {
            ret += " envelopes the OWNER";
        } else if (this.target == 1) {
            ret += " surrounds the allies";
        } else if (this.target == 2) {
            ret += " pierces the ENEMY";
        } else if (this.target == 3) {
            ret += " surrounds all enemies";
        }
        return ret;
    }

    @override
    String toString() {
        String ret = "";
        if (this.damageInsteadOfBuff && this.target < 2) {
            ret += " heals";
        } else if (this.damageInsteadOfBuff && this.target >= 2) {
            ret += " damages";
        } else if (!this.damageInsteadOfBuff && this.target < 2) {
            ret += " buffs";
        } else if (!this.damageInsteadOfBuff && this.target >= 2) {
            ret += " debuffs";
        }

        if (this.target == 0) {
            ret += " self";
        } else if (this.target == 1) {
            ret += " allies";
        } else if (this.target == 2) {
            ret += " an enemy";
        } else if (this.target == 3) {
            ret += " all enemies";
        }
        String stat = "STAT";
        ret += " based on how " + stat + " the casters are compared to their enemy";
        return ret;
    }

}



class FraymotifEffectForm {
    Element container;
    //Stat this.statName, num this.target, bool this.damageInsteadOfBuff
    SelectElement statElement;
    SelectElement targetElement;
    SelectElement damageElement;


    TextAreaElement dataBox;
    FraymotifEffect owner;

    FraymotifEffectForm(FraymotifEffect this.owner, Element parentContainer) {
        container = new DivElement();
        container.classes.add("SceneDiv");

        parentContainer.append(container);
    }

    void drawForm() {
        print("drawing new fraymotif form");
        DivElement help = new DivElement()..text = "Targeting allies helps them, Targeting enemies hurts them. If you damage with a stat, you use your copy of the stat to determine how much damage you do. If you buff with a stat, you raise/lower that stat directly.  If you 'damage' hp for allies you both heal and revive them.";
        container.append(help);
        drawDeleteButton();
        drawDamage();
        drawTarget();
        drawStat();
    }

    void syncDataBoxToScene() {
        print("trying to sync data box, owner is ${owner}");
        owner.fraymotif.form.dataBox.value = owner.fraymotif.toDataString();
    }


    void syncFormToOwner() {
        print("syncing form to scene");
        owner.damageInsteadOfBuff = damageElement.value == "true";
        owner.statName = Stats.byName[statElement.value];
        owner.target = int.parse(targetElement.value);

        syncDataBoxToScene();
    }

    void drawStat() {
        print("trying to draw stats");
        statElement = new SelectElement();
        List<String> allStatsKnown = new List<String>.from(Stats.byName.keys);
        for(String key in allStatsKnown) {
            print("key is $key");
            OptionElement statOption = new OptionElement()..value = key..text = key;
            if(owner.statName.name == key) statOption.selected = true;
            statElement.append(statOption);
        }
        container.append(statElement);

        statElement.onChange.listen((e) {
            owner.statName = Stats.byName[statElement.value];
            syncDataBoxToScene();
        });

    }

    void drawTarget() {
        /*    static int ALLIES = 1;
    static int ENEMIES = 3;
    static int SELF = 1;
    static int ENEMY = 2;
    */
        print("trying to draw stats");
        targetElement = new SelectElement();
        Map<String,int> map = <String,int>{"SELF":FraymotifEffect.SELF, "SINGLE ENEMY":FraymotifEffect.ENEMY,"ALL ALLIES":FraymotifEffect.ALLIES, "ALL ENEMIES": FraymotifEffect.ENEMIES, };
        for(String key in map.keys) {
            print("key is $key");
            OptionElement statOption = new OptionElement()..value = "${map[key]}"..text = key;
            if(owner.target == map[key]) statOption.selected = true;
            targetElement.append(statOption);
        }
        container.append(targetElement);

        targetElement.onChange.listen((e) {
            owner.target = int.parse(targetElement.value);
            syncDataBoxToScene();
        });
    }

    void drawDeleteButton() {
            ButtonElement delete = new ButtonElement();
            delete.text = "Remove Effect";
            delete.onClick.listen((e) {
                //don't bother knowing where i am, just remove from all
                owner.fraymotif.effects.remove(owner);
                container.remove();
                owner.fraymotif.form.syncDataBoxToOwner();
            });
            container.append(delete);

    }

    void drawDamage() {
        damageElement = new SelectElement();
        OptionElement damage = new OptionElement()..value = 'true'..text = 'Damage/Heal';
        OptionElement buff = new OptionElement()..value='false'..text='Debuff/Buff';
        if(owner.damageInsteadOfBuff) {
            damage.selected = true;
        }else {
            buff.selected = true;
        }
        damageElement.append(damage);
        damageElement.append(buff);
        container.append(damageElement);

        damageElement.onChange.listen((e) {
            owner.damageInsteadOfBuff = damageElement.value == "true";
            syncDataBoxToScene();
        });
    }

}