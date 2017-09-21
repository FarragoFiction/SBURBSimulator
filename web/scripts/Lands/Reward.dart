import "dart:html";
import "../SBURBSim.dart";


//there are different sub classes of reward. can get a fraymotif, can get grist, land level, items (post alchemy) minions (post npc).
class Reward {
    static String PLAYER1 = "PLAYER1TAG";
    static String PLAYER2 = "PLAYER2TAG";
    //children replace these two things.
    String text = " You get jack shit, asshole!";
    String image = "Rewards/no_reward.png";
    void apply(Element div, Player p1, Player p2) {
        p1.increasePower();
        if(p2 != null) p2.increasePower(); //interaction effect will be somewhere else
        String divID = "canvas${div.id}_${p1.id}";
        String ret = "$text <canvas id='${divID}' width='${canvasWidth.toString()}' height='${canvasHeight.toString()}'>  </canvas>";
        appendHtml(div, ret);
        Element canvas = querySelector("#$divID");
        Drawing.drawSinglePlayer(canvas, p1);
        Drawing.drawWhatever(canvas, image);
    }
}

class FraymotifReward extends Reward
{
    static String FRAYMOTIF1 = "FRAYMOTIF_NAME1";
    static String FRAYMOTIF2 = "FRAYMOTIF_NAME2";
    @override
    String text = "The ${Reward.PLAYER1} gains the fraymotif $FRAYMOTIF1! ";
    @override
    String image = "Rewards/sweetLoot.png";
    @override
    void apply(Element div, Player p1, Player p2) {
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
        super.apply(div, p1, p2);
    }
}