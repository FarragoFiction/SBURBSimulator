import "dart:html";
import "../SBURBSim.dart";
import "FeatureTypes/EnemyFeature.dart";


//there are different sub classes of reward. can get a fraymotif, can get grist, land level, items (post alchemy) minions (post npc).
//IMPORTANT don't keep state data here.
class Reward {
    static String PLAYER1 = "PLAYER1TAG";
    static String PLAYER2 = "PLAYER2TAG";
    //children replace these two things.
    String text = " You get jack shit, asshole!";
    String image = "Rewards/no_reward.png";
    String bgImage = null;
    void apply(Element div, Player p1, GameEntity p2, Land land) {
        p1.increasePower();
        p1.increaseLandLevel();
        if(p2 != null) p2.increasePower(); //interaction effect will be somewhere else
        String divID = "canvas${div.id}_${p1.id}";
        String ret = "$text <canvas id='${divID}' width='${canvasWidth.toString()}' height='${canvasHeight.toString()}'>  </canvas>";
        appendHtml(div, ret);
        Element canvas = querySelector("#$divID");
        Element buffer = Drawing.getBufferCanvas(canvas);
        Drawing.drawSinglePlayer(buffer, p1);
        if(image != null ) Drawing.drawWhatever(buffer, image);
        if(bgImage != null) Drawing.drawWhatever(canvas, bgImage);
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

class FraymotifReward extends Reward
{
    static String FRAYMOTIF1 = "FRAYMOTIF_NAME1";
    static String FRAYMOTIF2 = "FRAYMOTIF_NAME2";
    @override
    String text = " The ${Reward.PLAYER1} gains the fraymotif $FRAYMOTIF1! ";
    @override
    String image = "Rewards/sweetLoot.png";
    @override
    void apply(Element div, Player p1, GameEntity p2, Land land) {
        Fraymotif f1;
        Fraymotif f2;
        if(p2 != null) {
            if(p2 is Player) {
                text = "The ${Reward.PLAYER1} gains the fraymotif $FRAYMOTIF1, while the ${Reward.PLAYER2} gets the fraymotif $FRAYMOTIF2! ";
                f1 = p1.getNewFraymotif(p2); //with other player
                f2 = (p2 as Player).getNewFraymotif(p1);
                text = text.replaceAll("${Reward.PLAYER2}", "${(p2 as Player).htmlTitleBasicNoTip()}");
                text = text.replaceAll("${FRAYMOTIF2}", "${f2.name}");
            }
        }

        if (f1 == null) f1 = p1.getNewFraymotif(null);
        text = text.replaceAll("${Reward.PLAYER1}", "${p1.htmlTitleBasicNoTip()}");
        text = text.replaceAll("${FRAYMOTIF1}", "${f1.name}");
        //super increases power and renders self.
        super.apply(div, p1, p2, land);
    }
}

class DenizenReward extends Reward {

    static String FRAYMOTIF1 = "FRAYMOTIF_NAME1";
    static String FRAYMOTIF2 = "FRAYMOTIF_NAME2";
    @override
    String text = " The ${Reward.PLAYER1} gains the fraymotif $FRAYMOTIF1, as well as all that sweet sweet grist hoarde. ";
    @override
    String image = "Rewards/sweetLoot.png";
    String bgImage = "Rewards/sweetGrist.png";
    @override
    void apply(Element div, Player p1, GameEntity p2, Land land) {
        p1.increaseGrist(100.0);
        DenizenFeature df = land.denizenFeature;
        if(df.denizen == null) {
            df.makeDenizen(p1);
        }
        Fraymotif f1 = df.denizen.fraymotifs.first;
        text = text.replaceAll("${Reward.PLAYER1}", "${p1.htmlTitleBasicNoTip()}");
        text = text.replaceAll("${FRAYMOTIF1}", "${f1.name}");
        //super increases power and renders self.
        p1.setDenizenDefeated();
        super.apply(div, p1, p2, land);
    }
}

class ImmortalityReward extends Reward {

    @override
    String text = " The ${Reward.PLAYER1} finds a strange clock and destroys it utterly. Where did they even get that crowbar? It doesn't matter.   They are now unconditionally immortal. What will happen? ";
    @override
    String image = "Rewards/ohShit.png";
    String bgImage = "Rewards/sweetClock.png";


    @override
    void apply(Element div, Player p1, GameEntity p2, Land land) {
        if(!p1.godTier) {
            text = " There remains to be a trivial act of self-suicide. And then... $text";
            p1.makeGodTier();
        }
        p1.unconditionallyImmortal = true;
        text = text.replaceAll("${Reward.PLAYER1}", "${p1.htmlTitleBasicNoTip()}");
        super.apply(div, p1, p2, land);
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
    String text = " The ${Reward.PLAYER1} and the ${Reward.PLAYER2} find themselves sharing a tender moment of calmness. It is obvious to everyone that they are now moirails. They even get the fraymotifs ${FRAYMOTIF1} and ${FRAYMOTIF2} to celebrate! ";
    @override
    String image = null;
    String bgImage = "Moirail.png";


    @override
    void apply(Element div, Player p1, GameEntity p2, Land land) {
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
        super.apply(div, p1, p2, land);
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
    String text = " The ${Reward.PLAYER1} and the ${Reward.PLAYER2} find themselves sharing a passionate moment. It is obvious to everyone that they are now matesprits. They even get the fraymotifs ${FRAYMOTIF1} and ${FRAYMOTIF2} to celebrate! ";
    @override
    String image = null;
    String bgImage = "Matesprit.png";


    @override
    void apply(Element div, Player p1, GameEntity p2, Land land) {
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
        super.apply(div, p1, p2, land);
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
    String text = " The ${Reward.PLAYER1} and the ${Reward.PLAYER2} find themselves sharing a combatative moment. It is obvious to everyone that they are now Kismesises. They even get the fraymotifs ${FRAYMOTIF1} and ${FRAYMOTIF2} to celebrate! ";
    @override
    String image = null;
    String bgImage = "Kismesis.png";


    @override
    void apply(Element div, Player p1, GameEntity p2, Land land) {
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
        super.apply(div, p1, p2, land);
    }
}


///all one thing so if you lose a dream self mid whatever, you at least get the right reward.
class DreamReward extends Reward {

    @override
    String image = null;
    String bgImage = "Prospit.png";

    @override
    void apply(Element div, Player p1, GameEntity p2, Land land) {
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
        text = "The ${p1.htmlTitleBasicNoTip()} is getting pretty popular among Prospitians.";
        p1.addStat(Stats.SANITY, -1); //just a bit.
        bool savedDream = p1.isDreamSelf;
        p1.isDreamSelf = true;
        p1.renderSelf();
        super.apply(div, p1, p2, land);
        p1.isDreamSelf = savedDream;
        p1.renderSelf();

    }

    void applyDerse(Element div, Player p1, GameEntity p2, Land land) {
       // p1.session.logger.info("derse reward");
        bgImage = "Derse.png";
        text = " The ${p1.htmlTitleBasicNoTip()} is getting pretty popular among Dersites.";
        p1.corruptionLevelOther ++; //just a bit.
        bool savedDream = p1.isDreamSelf;
        p1.isDreamSelf = true;
        p1.renderSelf();
        super.apply(div, p1, p2, land);
        p1.isDreamSelf = savedDream;
        p1.renderSelf();

    }

    void applyBubbles(Element div, Player p1, GameEntity p2, Land land) {
        p1.session.logger.info("bubble reward");
        bgImage = "dreambubbles.png";
        text = " The ${p1.htmlTitleBasicNoTip()} is getting used to these Dream Bubbles.";
        p1.addStat(Stats.SANITY, 2); //just a bit better.
        super.apply(div, p1, p2, land);

    }

    void applyHorrorTerrors(Element div, Player p1, GameEntity p2, Land land) {
        p1.session.logger.info("terror reward");
        bgImage = "horrorterror.png";
        text = " The ${p1.htmlTitleBasicNoTip()} writhes in agony.";
        p1.corruptionLevelOther += 2; //just a bit.
        p1.addStat(Stats.SANITY, -2); //just a bit.
        super.apply(div, p1, p2, land);
    }
}