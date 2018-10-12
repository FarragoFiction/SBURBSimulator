import '../SBURBSim.dart';
import 'dart:html';

class PlayerWentMurderMode  extends ImportantEvent{
    int importanceRating = 7;

    PlayerWentMurderMode(Session session, num mvp_value, Player player, Player doomedTimeClone): super(session, mvp_value, player, doomedTimeClone);

    @override
    String humanLabel(){
        String ret = "Prevent the " + this.player.htmlTitleBasicNoTip() + " from going into Murder Mode.";
        if(session.mutator.mindField) ret = "Prevent the " + this.player.htmlTitleBasicNoTip() + " from EVER going into MurderMode.";
        return ret;
    }
    @override
    bool alternateScene(div){
        this.timesCalled ++;
        this.doomedTimeClone.dead = false;
        this.doomedTimeClone.setStat(Stats.CURRENT_HEALTH, this.doomedTimeClone.getStat(Stats.HEALTH));

        if(secondTimeClone != null){
            this.secondTimeClone.dead = false;
            this.secondTimeClone.setStat(Stats.CURRENT_HEALTH, this.secondTimeClone.getStat(Stats.HEALTH));
            return ImportantEvent.undoTimeUndoScene(div, this.session, this, this.doomedTimeClone, this.secondTimeClone);
        }
        var player = this.session.getVersionOfPlayerFromThisSession(this.player);
        String narration = "<br>A " + this.doomedTimeClone.htmlTitleBasic() + " suddenly warps in from the future. ";
        narration +=  " They come with a dire warning of a doomed timeline. ";
        narration += " Something seems...off...about them. But they are adamant that the " + player.htmlTitleBasic() + " needs to be calmed the fuck down. ";
        narration += " No matter what 'fate' says. ";
        narration += " They spend some time letting the  " + player.htmlTitleBasic() + " vent. Hug bumps are shared. ";
        if(this.doomedTimeClone.isTroll == true || player.isTroll == true){
            narration += "The fact that the " + this.doomedTimeClone.htmlTitleBasic() + " is doomed makes this especially tragic, forestalling any romance this might have otherwise had. ";
        }
        narration +=  " The doomed " + this.doomedTimeClone.htmlTitleBasic() + " vanishes in a cloud of gears to join the final battle.";
        appendHtml(div, narration);
        player.addStat(Stats.SANITY, -10);


        var divID = (div.id) + "_alt_${player.id}";
        String canvasHTML = "<br><canvas id='canvas" + divID+"' width='$canvasWidth' height='$canvasHeight'>  </canvas>";
        appendHtml(div, canvasHTML);
        var canvasDiv = querySelector("#canvas"+ divID);

        var pSpriteBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
        Drawing.drawSprite(pSpriteBuffer,this.doomedTimeClone);

        var dSpriteBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
        Drawing.drawSpriteTurnways(dSpriteBuffer,player);

        Drawing.drawTimeGears(canvasDiv);//, this.doomedTimeClone);
        Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0);
        Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, dSpriteBuffer,100,0);
        return true;
    }

}
