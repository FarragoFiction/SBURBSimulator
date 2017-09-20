import "dart:html";
import "../SBURBSim.dart";


//there are different sub classes of reward. can get a fraymotif, can get grist, land level, items (post alchemy) minions (post npc).
class Reward {
    //children replace these two things.
    String text = " You get jack shit, asshole!";
    String image = "Rewards/no_reward.png";
    void apply(Element div, Player p1, Player p2) {
        String divID = "canvas${div.id}_${p1.id}";
        String ret = "$text <canvas id='${divID}' width='${canvasWidth.toString()}' height='${canvasHeight.toString()}'>  </canvas>";
        appendHtml(div, ret);
        Element canvas = querySelector("#$divID");
        Drawing.drawSinglePlayer(canvas, p1);
        Drawing.drawWhatever(canvas, image);
    }
}