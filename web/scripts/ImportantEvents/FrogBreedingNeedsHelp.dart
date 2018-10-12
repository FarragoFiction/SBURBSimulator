//if knight, directly help, if not but knight alive, force them to help. else, indirect help
//if knight of space (most common reason this is called, indirect help)
//TODO important, time player isn't being passed in this contstructor for some reason.
//was i derping?

import '../SBURBSim.dart';
import 'dart:html';

class FrogBreedingNeedsHelp extends ImportantEvent {
    int importanceRating = 2;  //really, this is probably the least useful thing you could do. If this is the ONLY thing that went wrong, your session is going great.
    FrogBreedingNeedsHelp(Session session, num mvp_value, Player player, Player doomedTimeClone): super(session, mvp_value, player, doomedTimeClone);

    @override
    String humanLabel(){
        var spacePlayer = findAspectPlayer(this.session.players, Aspects.SPACE);
        String ret = "Help the " + spacePlayer.htmlTitleBasicNoTip() + " complete frog breeding duties.";
        return ret;
    }
    @override
    bool alternateScene(div){
        var spacePlayer = findAspectPlayer(this.session.players, Aspects.SPACE);
        this.timesCalled ++;
        this.doomedTimeClone.dead = false;
        this.doomedTimeClone.setStat(Stats.CURRENT_HEALTH, this.doomedTimeClone.getStat(Stats.HEALTH));

        if(secondTimeClone != null){
            this.secondTimeClone.dead = false;
            this.secondTimeClone.setStat(Stats.CURRENT_HEALTH, this.secondTimeClone.getStat(Stats.HEALTH));
            return ImportantEvent.undoTimeUndoScene(div, this.session, this, this.doomedTimeClone, this.secondTimeClone);
        }
        String narration = "<br>A " + this.doomedTimeClone.htmlTitleBasic() + " suddenly warps in from the future. ";
        narration +=  " They come with a dire warning of a doomed timeline. ";
        narration += " Something seems...off...about them. But they are adamant that the " + spacePlayer.htmlTitleBasic() + " needs to be helped with their Frog Breeding duties. ";
        narration += " No matter what anybody says about time travel frog breeding being an overly elaborate and dangerous undertaking.  Desperate times, Desperate measures. ";
        if(this.doomedTimeClone.class_name == SBURBClassManager.KNIGHT){
            narration += " Luckily they were SUPPOSED to be helping breed the frog in the first place, so it's just a matter of making enough stable time loops to make a huge dent in the process. ";
            spacePlayer.increaseLandLevel(10.0);
        }else{
            narration += " Unfortunately they are not a Knight, and thus are banned from helping breed frogs directly.  But with a little creativity and a LOT of stable time loops they manage to indirectly help a huge amount. ";
            spacePlayer.increaseLandLevel(8.0);
        }
        narration +=  " The doomed " + this.doomedTimeClone.htmlTitleBasic() + " vanishes in a cloud of gears to join the final battle.";
        appendHtml(div, narration);

        var divID = (div.id) + "_alt_${spacePlayer.id}";
        String canvasHTML = "<br><canvas id='canvas" + divID+"' width='$canvasWidth' height='$canvasHeight'>  </canvas>";
        appendHtml(div, canvasHTML);
        var canvasDiv = querySelector("#canvas"+ divID);

        var pSpriteBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
        Drawing.drawSprite(pSpriteBuffer,this.doomedTimeClone);

        var dSpriteBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
        Drawing.drawSpriteTurnways(dSpriteBuffer,spacePlayer);

        Drawing.drawTimeGears(canvasDiv);//, this.doomedTimeClone);
        Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0);
        Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, dSpriteBuffer,100,0);
        ////print("done helping frog a scene, seed is at: " + Math.seed);
        return true;
    }


}
