import "dart:html";
import "../SBURBSim.dart";
import "FeatureTypes/EnemyFeature.dart";


//there are different sub classes of reward. can get a fraymotif, can get grist, land level, items (post alchemy) minions (post npc).
//IMPORTANT don't keep state data here.
class Reward {


    static String PLAYER1 = "PLAYER1TAG";
    static String PLAYER2 = "PLAYER2TAG";
    String image = "Rewards/no_reward.png";
    String bgImage = null;
    void apply(Element div, Player p1, GameEntity p2, Land land, [String text = "You get jack shit, asshole!"]) {
        p1.increasePower();
        p1.increaseLandLevel();
        if(p2 != null) p2.increasePower(); //interaction effect will be somewhere else
        String divID = "canvas${div.id}_${p1.id}";
        //print ("applying base reward, text is $text ");
        String ret = "$text <canvas id='${divID}' width='${canvasWidth.toString()}' height='${canvasHeight.toString()}'>  </canvas>";
        appendHtml(div, ret);
        Element canvas = querySelector("#$divID");
        Element buffer = Drawing.getBufferCanvas(canvas);
        Drawing.drawSinglePlayer(buffer, p1);
        if(image != null ) Drawing.drawWhatever(buffer, image);
        if(bgImage != null) Drawing.drawWhatever(canvas, bgImage);
        //print("drawing player 1 is ${p1}");
        Drawing.copyTmpCanvasToRealCanvas(canvas, buffer);
        if(p2 != null && (p2 is Player)){
            Element buffer2 = Drawing.getBufferCanvas(canvas);
            Drawing.drawSinglePlayer(buffer2, p2);
            Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, buffer2, 150,0);
        }

    }
}

class BoonieFraymotifReward extends FraymotifReward {
    static String FRAYMOTIF1 = "FRAYMOTIF_NAME1";
    static String FRAYMOTIF2 = "FRAYMOTIF_NAME2";
    String bgImage = "Rewards/sweetBoonies.png";

}
//TODO have it take in a name and then the fraymotif cna have a custom name?
class FraymotifReward extends Reward
{
    static String FRAYMOTIF1 = "FRAYMOTIF_NAME1";
    static String FRAYMOTIF2 = "FRAYMOTIF_NAME2";
    String name = null;
    String desc = null;
    @override
    String image = "Rewards/sweetLoot.png";

    FraymotifReward([String this.name = null, this.desc = null]);


    @override
    void apply(Element div, Player p1, GameEntity p2, Land land, [String t]) {
        String text = " The ${Reward.PLAYER1} gains the fraymotif $FRAYMOTIF1! ";
        Fraymotif f1;
        Fraymotif f2;
        if(p2 != null) {
            if(p2 is Player) {
                text = "The ${Reward.PLAYER1} gains the fraymotif $FRAYMOTIF1, while the ${Reward.PLAYER2} gets the fraymotif $FRAYMOTIF2! ";
                f1 = p1.getNewFraymotif(p2); //with other player
                f2 = (p2 as Player).getNewFraymotif(p1);
                if(name != null) f2.name = name;
                text = text.replaceAll("${Reward.PLAYER2}", "${(p2 as Player).htmlTitleBasicNoTip()}");
                text = text.replaceAll("${FRAYMOTIF2}", "${f2.name}");
            }
        }

        if (f1 == null) f1 = p1.getNewFraymotif(null);
        //only player 1 gets custom fraymotif
        if(name != null) f1.name = name;
        if(desc != null) f1.desc = desc;
        text = text.replaceAll("${Reward.PLAYER1}", "${p1.htmlTitleBasicNoTip()}");
        text = text.replaceAll("${FRAYMOTIF1}", "${f1.name}");
        //super increases power and renders self.
        super.apply(div, p1, p2, land,text);
    }
}

class DenizenReward extends Reward {

    static String FRAYMOTIF1 = "FRAYMOTIF_NAME1";
    static String FRAYMOTIF2 = "FRAYMOTIF_NAME2";
    @override
    String image = "Rewards/sweetLoot.png";
    String bgImage = "Rewards/sweetGrist.png";
    @override
    void apply(Element div, Player p1, GameEntity p2, Land land, [String t]) {
        String text = " The ${Reward.PLAYER1} gains the fraymotif $FRAYMOTIF1, as well as all that sweet sweet grist hoarde. ";
        p1.increaseGrist(100.0);
        DenizenFeature df = land.denizenFeature;
        if(df.denizen == null) {
            df.makeDenizen(p1);
        }
        Fraymotif f1 = df.denizen.fraymotifs.first;
       // print("narrating player 1 is ${p1}");
        p1.fraymotifs.add(f1);

        text = text.replaceAll("${Reward.PLAYER1}", "${p1.htmlTitleBasicNoTip()}");
        text = text.replaceAll("${FRAYMOTIF1}", "${f1.name}");
        //super increases power and renders self.
        p1.setDenizenDefeated();
        super.apply(div, p1, p2, land,text);
    }
}


class BattlefieldReward extends Reward {
    @override
    String image = null;
    @override
    String bgImage = "Rewards/battlefield.png";

    @override
    void apply(Element div, Player p1, GameEntity p2, Land land, [String text]) {
        text = " The ${Reward.PLAYER1} is getting pretty familiar with the battlefield. ";
        text = text.replaceAll("${Reward.PLAYER1}", "${p1.htmlTitleBasicNoTip()}");
        super.apply(div, p1, p2, land,text);
    }
}

class CodReward extends Reward {
    @override
    String image = "/Rewards/sweetCod.png";

    @override
    void apply(Element div, Player p1, GameEntity p2, Land land, [String t]) {
        String text = " It. It's too beautiful for words. The glory of the COD PIECE is nearly blinding. The ${Reward.PLAYER1} will cherish this forever. They alchemize plenty of backups in different colors in case anyone else wants some.";
        if(!p1.godTier) text += " Too bad they'll have to wait to be god tier to TRULY appreciate it.";
        if(bardQuest) text += " Even if someone already found this sacred treasure, the ${Reward.PLAYER1} is glad they journeyed to find it on their own as well. ";
        text = text.replaceAll("${Reward.PLAYER1}", "${p1.htmlTitleBasicNoTip()}");
        Fraymotif f1 = p1.getNewFraymotif(null);
        int num = p1.session.rand.nextInt(13);
        //cod tier gives extra benefits.
        p1.increaseLandLevel();
        p1.increasePower();
        f1.name = "The Ballad of the ZillyCodPiece (Verse ${num})";
        bardQuest = true;
        for(Player p in p1.session.players) {
            if(p.class_name == SBURBClassManager.BARD) {
                p.renderSelf();
            }
        }
        p1.renderSelf();
        super.apply(div, p1, p2, land,text);
    }
}

class FrogReward extends FraymotifReward {
    static String FRAYMOTIF1 = "FRAYMOTIF_NAME1";
    static String FRAYMOTIF2 = "FRAYMOTIF_NAME2";

    @override
    String image = "Rewards/sweetFrog.png";
    String bgImage = "Rewards/holyShitFrogs.png";
    @override
    void apply(Element div, Player p1, GameEntity p2, Land land, [String t]) {
        String text = "";
        if(p1.grimDark < 3) {
            p1.landLevel = 1.0 * p1.session.goodFrogLevel; //need to be double
            text = "The ${Reward.PLAYER1} breeds the final frog. While it is a tadpole for now, once it is placed in the fertlized SKAIA it will grow to become an entire Universe Frog.";
        }else {
            "Rewards/bitterFrog.png";
            p1.landLevel = -1.0*p1.session.goodFrogLevel;
            text = "The ${Reward.PLAYER1}. Um. You don't think they were supposed to be doing that. Why doe the frog look like that? ";
        }
        super.apply(div, p1, p2, land,text);
    }
}

class ImmortalityReward extends Reward {

    @override
    String image = "Rewards/ohShit.png";
    @override
    String bgImage = "Rewards/sweetClock.png";


    @override
    void apply(Element div, Player p1, GameEntity p2, Land land, [String t]) {
        String text = " The ${Reward.PLAYER1} finds a strange clock and destroys it utterly. Where did they even get that crowbar? It doesn't matter.   They are now unconditionally immortal. What will happen? ";

        if(!p1.godTier) {
            text = " There remains to be a trivial act of self-suicide. And then... $text";
            p1.makeGodTier();
        }
        p1.unconditionallyImmortal = true;
        text = text.replaceAll("${Reward.PLAYER1}", "${p1.htmlTitleBasicNoTip()}");
        super.apply(div, p1, p2, land,text);
    }
}

///technically you can start a two player quest chain with one player and end it with another.
///or with no players at all. what matters is who you end it with, tho.
class PaleRomanceReward extends Reward {
    //they both get same fraymotif.
    static String FRAYMOTIF1 = "FRAYMOTIF_NAME1";
    static String FRAYMOTIF2 = "FRAYMOTIF_NAME2";
    String romanticEnding = " Pale Serenade";
    @override
    String image = null;
    @override
    String bgImage = "Moirail.png";


    @override
    void apply(Element div, Player p1, GameEntity p2, Land land, [String t]) {
        String text = " The ${Reward.PLAYER1} and the ${Reward.PLAYER2} find themselves sharing a tender moment of calmness. It is obvious to everyone that they are now moirails. They even get the fraymotifs ${FRAYMOTIF1} and ${FRAYMOTIF2} to celebrate! ";

        Fraymotif f1;
        Fraymotif f2;

        if(p2 == null || !(p2 is Player)) {
            p1.session.logger.info("got stood up from a pale ship");
            f1 = p1.getNewFraymotif(null); //with other player
            bgImage = null;
            text = " Huh. Well. I had this whole thing planned, but that second asshole flaked off and got replaced with that random consort. Only ${Reward.PLAYER1} is still here.  I guess they can still have the fraymotif ${FRAYMOTIF1}, though.";
        }else {
            if(p2 is Player) {
                p1.session.logger.info("Pale shipping reward");
                f1 = p1.getNewFraymotif(p2); //with other player
                f1.name += romanticEnding;
                f2 = (p2 as Player).getNewFraymotif(p1);
                f2.name += romanticEnding;
                text = text.replaceAll("${Reward.PLAYER2}", "${(p2 as Player).htmlTitleBasicNoTip()}");
                text = text.replaceAll("${FRAYMOTIF2}", "${f2.name}");
                if(p1 == p2) {
                    text += " We are all a little uncomfortable about the whole self-cest thing. This is probably why you're supposed to be playing with other Players, dunkass, not making this an awkward one man ballet.";
                }else {
                    Relationship.makeDiamonds(p1, p2);
                }
            }
        }

        text = text.replaceAll("${Reward.PLAYER1}", "${p1.htmlTitleBasicNoTip()}");
        text = text.replaceAll("${FRAYMOTIF1}", "${f1.name}");
        //super increases power and renders self.
        super.apply(div, p1, p2, land,text);
    }
}


///technically you can start a two player quest chain with one player and end it with another.
///or with no players at all. what matters is who you end it with, tho.
class FlushedRomanceReward extends Reward {
    //they both get same fraymotif.
    static String FRAYMOTIF1 = "FRAYMOTIF_NAME1";
    static String FRAYMOTIF2 = "FRAYMOTIF_NAME2";
    String romanticEnding = " Flushed Serenade";
    @override
    String image = null;
    @override
    String bgImage = "Matesprit.png";


    @override
    void apply(Element div, Player p1, GameEntity p2, Land land, [String t]) {
        String text = " The ${Reward.PLAYER1} and the ${Reward.PLAYER2} find themselves sharing a passionate moment. It is obvious to everyone that they are now matesprits. They even get the fraymotifs ${FRAYMOTIF1} and ${FRAYMOTIF2} to celebrate! ";

        Fraymotif f1;
        Fraymotif f2;

        if(p2 == null || !(p2 is Player)) {
            p1.session.logger.info("got stood up from a flushed ship");
            f1 = p1.getNewFraymotif(null); //with other player
            bgImage = null;
            text = " Huh. Well. I had this whole thing planned, but that second asshole flaked off  and got replaced with that random consort. Only ${Reward.PLAYER1} is still here.  I guess they can still have the fraymotif ${FRAYMOTIF1}, though.";
        }else{
            if(p2 is Player) {
                p1.session.logger.info("Flushed shipping reward");
                f1 = p1.getNewFraymotif(p2); //with other player
                f1.name += romanticEnding;
                f2 = (p2 as Player).getNewFraymotif(p1);
                f2.name += romanticEnding;
                text = text.replaceAll("${Reward.PLAYER2}", "${(p2 as Player).htmlTitleBasicNoTip()}");
                text = text.replaceAll("${FRAYMOTIF2}", "${f2.name}");
                if(p1 == p2) {
                    text += " We are all a little uncomfortable about the whole self-cest thing. This is probably why you're supposed to be playing with other Players, dunkass, not making this an awkward one man ballet.";
                }else {
                    Relationship.makeHeart(p1, p2);
                }
            }
        }

        text = text.replaceAll("${Reward.PLAYER1}", "${p1.htmlTitleBasicNoTip()}");
        text = text.replaceAll("${FRAYMOTIF1}", "${f1.name}");
        //super increases power and renders self.
        super.apply(div, p1, p2, land,text);
    }
}



///technically you can start a two player quest chain with one player and end it with another.
///or with no players at all. what matters is who you end it with, tho.
class PitchRomanceReward extends Reward {
    //they both get same fraymotif.
    static String FRAYMOTIF1 = "FRAYMOTIF_NAME1";
    static String FRAYMOTIF2 = "FRAYMOTIF_NAME2";
    String romanticEnding = " Pitch Insult";
    @override
    String image = null;
    @override
    String bgImage = "Kismesis.png";


    @override
    void apply(Element div, Player p1, GameEntity p2, Land land, [String t]) {
        String text = " The ${Reward.PLAYER1} and the ${Reward.PLAYER2} find themselves sharing a combatative moment. It is obvious to everyone that they are now Kismesises. They even get the fraymotifs ${FRAYMOTIF1} and ${FRAYMOTIF2} to celebrate! ";

        Fraymotif f1;
        Fraymotif f2;
        if(p2 == null || !(p2 is Player)) {
            p1.session.logger.info("got stood up from a pitch ship");
            f1 = p1.getNewFraymotif(null); //with other player
            bgImage = null;
            text = " Huh. Well. I had this whole thing planned, but that second asshole flaked off  and got replaced with that random consort. Only ${Reward.PLAYER1} is still here.  I guess they can still have the fraymotif ${FRAYMOTIF1}, though.";
        }else {
            if(p2 is Player) {
                p1.session.logger.info("Pitch shipping reward");
                f1 = p1.getNewFraymotif(p2); //with other player
                f1.name += romanticEnding;
                f2 = (p2 as Player).getNewFraymotif(p1);
                f2.name += romanticEnding;
                text = text.replaceAll("${Reward.PLAYER2}", "${(p2 as Player).htmlTitleBasicNoTip()}");
                text = text.replaceAll("${FRAYMOTIF2}", "${f2.name}");
                if(p1 == p2) {
                    text += " We are all a little uncomfortable about the whole self-cest thing. This is probably why you're supposed to be playing with other Players, dunkass, not making this an awkward one man ballet.";
                }else {
                    Relationship.makeDiamonds(p1, p2);
                }
            }
        }

        text = text.replaceAll("${Reward.PLAYER1}", "${p1.htmlTitleBasicNoTip()}");
        text = text.replaceAll("${FRAYMOTIF1}", "${f1.name}");
        //super increases power and renders self.
        super.apply(div, p1, p2, land,text);
    }
}


///all one thing so if you lose a dream self mid whatever, you at least get the right reward.
class DreamReward extends Reward {

    @override
    String image = null;
    String bgImage = "Prospit.png";

    @override
    void apply(Element div, Player p1, GameEntity p2, Land land, [String t]) {
        if(p1.dreamSelf) {
            if(p1.moon == p1.session.prospit) {
                applyProspit(div, p1, p2, land);
            }else {
                applyDerse(div, p1, p2, land);
            }
        }else if(!p1.dreamSelf && p1.session.stats.dreamBubbleAfterlife) {
            applyBubbles(div, p1, p2, land);
        }else {
            applyHorrorTerrors(div, p1, p2, land);
        }
    }

    void applyProspit(Element div, Player p1, GameEntity p2, Land land) {
        //p1.session.logger.info("prospit reward");
        bgImage = "Prospit.png";
        String text = "The ${p1.htmlTitleBasicNoTip()} is getting pretty popular among Prospitians.";
        p1.addStat(Stats.SANITY, -1); //just a bit.
        bool savedDream = p1.isDreamSelf;
        p1.isDreamSelf = true;
        p1.renderSelf();
        super.apply(div, p1, p2, land,text);
        p1.isDreamSelf = savedDream;
        p1.renderSelf();

    }

    void applyDerse(Element div, Player p1, GameEntity p2, Land land) {
       // p1.session.logger.info("derse reward");
        bgImage = "Derse.png";
        String text = " The ${p1.htmlTitleBasicNoTip()} is getting pretty popular among Dersites.";
        p1.corruptionLevelOther ++; //just a bit.
        bool savedDream = p1.isDreamSelf;
        p1.isDreamSelf = true;
        p1.renderSelf();
        super.apply(div, p1, p2, land,text);
        p1.isDreamSelf = savedDream;
        p1.renderSelf();

    }

    void applyBubbles(Element div, Player p1, GameEntity p2, Land land) {
        p1.session.logger.info("bubble reward");
        bgImage = "dreambubbles.png";
        String text = " The ${p1.htmlTitleBasicNoTip()} is getting used to these Dream Bubbles.";
        p1.addStat(Stats.SANITY, 2); //just a bit better.
        super.apply(div, p1, p2, land,text);

    }

    void applyHorrorTerrors(Element div, Player p1, GameEntity p2, Land land) {
        p1.session.logger.info("terror reward");
        bgImage = "horrorterror.png";
        String text = " The ${p1.htmlTitleBasicNoTip()} writhes in agony.";
        p1.corruptionLevelOther += 2; //just a bit.
        p1.addStat(Stats.SANITY, -2); //just a bit.
        super.apply(div, p1, p2, land,text);
    }
}