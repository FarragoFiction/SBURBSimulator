//...huh...how did I not notice this typo soner.
//TODO when refactor is done and everything is hooked up, test out intellij-s auto refactor rename variable thing

import '../SBURBSim.dart';
import 'dart:html';

class TimePlayerEnteredSessionWihtoutFrog  extends ImportantEvent {
    int importanceRating = 10;
    //this is so illegal.
    TimePlayerEnteredSessionWihtoutFrog(Session session, num mvp_value, Player player, Player doomedTimeClone): super(session, mvp_value, player, doomedTimeClone);

    @override
    String humanLabel(){
        String ret = "Make the " + this.player.htmlTitleBasicNoTip() + " prototype a frog before entering the session. ";
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
        narration += " Something seems...off...about them. But they are adamant that their past-selves kernel sprite needs to be prototyped with this FROG. You do not even want to know how long it took them to get back to earth, and then time-travel to before the" +  player.htmlTitleBasic() + " entered the session. They are commited to this. ";
        narration += " No matter what 'fate' says.  They don't even care how illegal this is. ";
        narration +=  "The doomed " + this.doomedTimeClone.htmlTitleBasic() + " vanishes with in a cloud of gears to join the final battle.";
        appendHtml(div, narration);

        player.object_to_prototype = new GameEntity("Frog", doomedTimeClone.session); //new GameEntity("Frog",0,null);
        player.object_to_prototype.setStat(Stats.POWER,20);
        player.object_to_prototype.illegal = true;
        player.object_to_prototype.setStat(Stats.MOBILITY, 100);
        var divID = (div.id) + "_alt_jack_promotion";
        String canvasHTML = "<br><canvas id='canvas" + divID+"' width='$canvasWidth' height='$canvasHeight'>  </canvas>";
        appendHtml(div, canvasHTML);
        var canvasDiv = querySelector("#canvas"+ divID);

        var pSpriteBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
        Drawing.drawSprite(pSpriteBuffer,this.doomedTimeClone);
        Drawing.drawTimeGears(canvasDiv);
        Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0);
        return false;  //let original scene happen as well.
    }

}
