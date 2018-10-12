import '../SBURBSim.dart';
import 'ImportantEvents.dart';
import 'dart:html';

class DeadSessionPlayerEntered  extends ImportantEvent {
    int importanceRating = 10;

    //this is so illegal.
    DeadSessionPlayerEntered(Session session, num mvp_value, Player player, Player doomedTimeClone) : super(session, mvp_value, player, doomedTimeClone);

    @override
    String humanLabel() {
        String ret = "Just go....hang out with " + this.player.htmlTitleBasicNoTip() + " when the session starts. Maybe it will help. ";
        return ret;
    }

    @override
    bool alternateScene(div) {
        this.timesCalled ++;
        this.doomedTimeClone.dead = false;
        this.doomedTimeClone.setStat(Stats.CURRENT_HEALTH, this.doomedTimeClone.getStat(Stats.HEALTH));

        if (secondTimeClone != null) {
            this.secondTimeClone.dead = false;
            this.secondTimeClone.setStat(Stats.CURRENT_HEALTH, this.secondTimeClone.getStat(Stats.HEALTH));
            return ImportantEvent.undoTimeUndoScene(div, this.session, this, this.doomedTimeClone, this.secondTimeClone);
        }
        var player = this.session.getVersionOfPlayerFromThisSession(this.player);
        String narration = "<br>A " + this.doomedTimeClone.htmlTitleBasic() + " suddenly warps in from the future. ";
        narration += " They seem really apologetic towards the ${this.player.htmlTitleBasic()}. ";
        narration += " No one deserves what comes next. ";
        narration += "The now doomed " + this.doomedTimeClone.htmlTitleBasic() + " fails to vanishes  in a cloud of gears and instead joins the dead players party as long as they can.";
        appendHtml(div, narration);

        player.addCompanion(this.doomedTimeClone);
        var divID = (div.id) + "_alt_jack_promotion";
        String canvasHTML = "<br><canvas id='canvas" + divID + "' width='$canvasWidth' height='$canvasHeight'>  </canvas>";
        appendHtml(div, canvasHTML);
        var canvasDiv = querySelector("#canvas" + divID);

        var pSpriteBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
        Drawing.drawSprite(pSpriteBuffer, this.doomedTimeClone);
        Drawing.drawTimeGears(canvasDiv);
        Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer, -100, 0);
        return false; //let original scene happen as well.
    }
}

