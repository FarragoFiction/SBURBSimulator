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
    void apply(Element div, Player p1, Player p2, Land land) {
        p1.increasePower();
        p1.increaseLandLevel();
        if(p2 != null) p2.increasePower(); //interaction effect will be somewhere else
        String divID = "canvas${div.id}_${p1.id}";
        String ret = "$text <canvas id='${divID}' width='${canvasWidth.toString()}' height='${canvasHeight.toString()}'>  </canvas>";
        appendHtml(div, ret);
        Element canvas = querySelector("#$divID");
        Element buffer = Drawing.getBufferCanvas(canvas);
        Drawing.drawSinglePlayer(buffer, p1);
        Drawing.drawWhatever(buffer, image);
        if(bgImage != null) Drawing.drawWhatever(canvas, bgImage);
        Drawing.copyTmpCanvasToRealCanvas(canvas, buffer);
    }
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
    void apply(Element div, Player p1, Player p2, Land land) {
        Fraymotif f1 = p1.getNewFraymotif(p2);
        Fraymotif f2;
        if(p2 != null) {
            text = "The ${Reward.PLAYER1} gains the fraymotif $FRAYMOTIF1, while the ${Reward.PLAYER2} gets the fraymotif $FRAYMOTIF2! ";
            f2 = p2.getNewFraymotif(p1);
            text = text.replaceAll("${Reward.PLAYER2}", "${p2.htmlTitleBasicNoTip()}");
            text = text.replaceAll("${FRAYMOTIF2}", "${f2.name}");
        }
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
    void apply(Element div, Player p1, Player p2, Land land) {
        p1.increaseGrist(100.0);
        DenizenFeature df = land.denizenFeature;
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


    void apply(Element div, Player p1, Player p2, Land land) {
        if(!p1.godTier) {
            text = " There remains to be a trivial act of self-suicide. And then... $text";
            p1.makeGodTier();
        }
        p1.unconditionallyImmortal = true;
        text = text.replaceAll("${Reward.PLAYER1}", "${p1.htmlTitleBasicNoTip()}");
        super.apply(div, p1, p2, land);
    }
}