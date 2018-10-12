import '../SBURBSim.dart';
import 'dart:html';

class PlayerDiedForever  extends ImportantEvent {
    int importanceRating = 5;

    PlayerDiedForever(Session session, num mvp_value, Player player, Player doomedTimeClone): super(session, mvp_value, player, doomedTimeClone);

    @override
    String humanLabel(){
        String ret = "Make the " + this.player.htmlTitleBasicNoTip() + " not permanently dead.";
        if(session.mutator.mindField) ret = "Make the " + this.player.htmlTitleBasicNoTip() + " NEVER permanently dead, lol.";
        return ret;
    }
    @override
    bool alternateScene(div){
        this.timesCalled ++;
        this.doomedTimeClone.dead = false;
        this.doomedTimeClone.setStat(Stats.CURRENT_HEALTH, this.doomedTimeClone.getStat(Stats.HEALTH));
        if(secondTimeClone != null) this.secondTimeClone.dead = false;
        if(secondTimeClone != null) this.secondTimeClone.setStat(Stats.CURRENT_HEALTH, this.secondTimeClone.getStat(Stats.HEALTH));
        if(secondTimeClone != null){
            return ImportantEvent.undoTimeUndoScene(div, this.session, this, this.doomedTimeClone, this.secondTimeClone);
        }
        var player = this.session.getVersionOfPlayerFromThisSession(this.player);
        String narration = "<br>A " + this.doomedTimeClone.htmlTitleBasic() + " suddenly warps in from the future. ";
        narration +=  " They come with a dire warning of a doomed timeline. ";
        narration += " Something seems...off...about them. But they are adamant that the " +player.htmlTitleBasic() + " needs to be protected. ";
        narration += " No matter what 'fate' says. ";
        narration += " They sacrifice their life for the " + player.htmlTitleBasic() + ". ";


        appendHtml(div, narration);

        player.makeAlive();
        player.addStat(Stats.SANITY, -0.5);

        this.doomedTimeClone.makeDead("sacrificing themselves through a YellowYard", player);

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

        var alphaTimePlayer = findAspectPlayer(this.session.players, Aspects.TIME);
        removeFromArray(this.doomedTimeClone, alphaTimePlayer.doomedTimeClones);   //DEAD
        this.session.afterLife.addGhost(this.doomedTimeClone);
        return true;
    }

}
