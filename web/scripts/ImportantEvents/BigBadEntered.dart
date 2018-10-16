import '../SBURBSim.dart';
import 'dart:html';


class BigBadEntered extends ImportantEvent {
    @override
    int importanceRating = 13; //not even kidding this probably fucked your session over
    BigBad bigBad;

    BigBadEntered(BigBad this.bigBad, Session session, num mvp_value, Player player) : super(session, mvp_value, player);

    @override
    bool alternateScene(Element div) {

        if(bigBad.name.contains("Shogun")){
            DivElement narration = new DivElement()..setInnerHtml("You find that the Shogun was here the whole time, and no matter what you do you can't stop from making him be here the whole time. The Doomed ${doomedTimeClone.htmlTitleBasic()} eventually gives up and leaves. ");
            div.append(narration);
            CanvasElement canvasDiv = new CanvasElement(width: canvasWidth, height: canvasHeight);
            div.append(canvasDiv);

            var pSpriteBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
            Drawing.drawSprite(pSpriteBuffer,this.doomedTimeClone);


            Drawing.drawTimeGears(canvasDiv);//, this.doomedTimeClone);
            Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0);
            return false;
        }
        this.timesCalled ++;
        this.doomedTimeClone.dead = false;
        this.doomedTimeClone.setStat(Stats.CURRENT_HEALTH, this.doomedTimeClone.getStat(Stats.HEALTH));

        if(secondTimeClone != null){
            this.secondTimeClone.dead = false;
            this.secondTimeClone.setStat(Stats.CURRENT_HEALTH, this.secondTimeClone.getStat(Stats.HEALTH));
            return ImportantEvent.undoTimeUndoScene(div, this.session, this, this.doomedTimeClone, this.secondTimeClone);
        }

        DivElement narration = new DivElement();
        narration.setInnerHtml("A ${doomedTimeClone.htmlTitleBasic()} suddenly warps in from the future. They come with a dire warning of a doomed timeline. Something seems...off...about them. But they are adamant that the ${bigBad.htmlTitle()} needs to be defeated, and right the fuck now.   They use all sorts of tips and tricks they have from the future to completely destroy the ${bigBad.htmlTitle()} influence on the session so thoroughly no one even knows if they are dead, trapped in time or merely driven off before they even arrived.  The Doomed ${doomedTimeClone.htmlTitleBasic()} smugly vanishes with a cloud of gears to join the final battle.");
        div.append(narration);
        //seriously, they do NOT exist anymore, not even ab thinks they were here
        session.makeBigBadIneligible(bigBad);

        CanvasElement canvasDiv = new CanvasElement(width: canvasWidth, height: canvasHeight);
        div.append(canvasDiv);

        var pSpriteBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
        Drawing.drawSprite(pSpriteBuffer,this.doomedTimeClone);


        Drawing.drawTimeGears(canvasDiv);//, this.doomedTimeClone);
        Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0);
        return true;
    }

    @override
    String humanLabel() {
        if(bigBad.name.contains("Shogun")) {
            return "Stop Shogun's Shenanigans, Seriously.";
        }
        return "Stop the ${bigBad.htmlTitleBasic()} permanently.";
    }
}
