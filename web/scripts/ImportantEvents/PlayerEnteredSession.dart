import '../SBURBSim.dart';
import 'dart:html';

class PlayerEnteredSession  extends ImportantEvent {
    int importanceRating = 5;
    PlayerEnteredSession(Session session, num mvp_value, Player player, Player doomedTimeClone): super(session, mvp_value, player, doomedTimeClone);

    @override
    String humanLabel(){
        String ret = "Kill the " + this.player.htmlTitleBasicNoTip() + " before they enter the session.";
        if(session.mutator.mindField) ret = "Kill the " + this.player.htmlTitleBasicNoTip() + " as much as you can. Fuck that guy!";
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
        narration += " Something seems...off...about them. But they are adamant that the " + player.htmlTitleBasic() + " needs to die.  You do not even want to know how long it took them to get back to earth, and then time-travel to before the" +  player.htmlTitleBasic() + " entered the session. They are commited to this. ";
        narration += " No matter what 'fate' says. ";

        narration +=  "After a brief struggle, the doomed " + this.doomedTimeClone.htmlTitleBasic() + " vanishes in a cloud of gears to join the final battle.";
        player.dead = true;
        narration += player.makeDead("apparantly displeasing the Observer.",player);
        appendHtml(div, narration);

        this.doomedTimeClone.victimBlood = player.bloodColor;


        var divID = (div.id) + "_alt_${player.id}";
        String canvasHTML = "<br><canvas id='canvas" + divID+"' width='$canvasWidth' height='$canvasHeight'>  </canvas>";
        appendHtml(div, canvasHTML);
        var canvasDiv = querySelector("#canvas"+ divID);

        var pSpriteBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
        Drawing.drawSprite(pSpriteBuffer,this.doomedTimeClone);

        var dSpriteBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
        Drawing.drawSprite(dSpriteBuffer,player);

        Drawing.drawTimeGears(canvasDiv);//, this.doomedTimeClone);
        Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0);
        Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, dSpriteBuffer,100,0);
        return false; //let the original scene happen as well.
    }



}

