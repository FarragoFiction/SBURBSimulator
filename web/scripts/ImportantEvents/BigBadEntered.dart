import '../SBURBSim.dart';
import 'dart:html';


class BigBadEntered extends ImportantEvent {
    int importanceRating = 10;
    BigBad bigBad;

    BigBadEntered(BigBad this.bigBad, Session session, num mvp_value, Player player) : super(session, mvp_value, player);
    @override
    bool alternateScene(Element div) {
        this.timesCalled ++;
        this.doomedTimeClone.dead = false;
        this.doomedTimeClone.setStat(Stats.CURRENT_HEALTH, this.doomedTimeClone.getStat(Stats.HEALTH));

        if(secondTimeClone != null){
            this.secondTimeClone.dead = false;
            this.secondTimeClone.setStat(Stats.CURRENT_HEALTH, this.secondTimeClone.getStat(Stats.HEALTH));
            return ImportantEvent.undoTimeUndoScene(div, this.session, this, this.doomedTimeClone, this.secondTimeClone);
        }

        DivElement narration = new DivElement();
        narration.setInnerHtml("A ${doomedTimeClone.htmlTitleBasic()} suddenly warps in from the future. They come with a dire warning of a doomed timeline. Something seems...off...about them. But they are adamant that the ${bigBad.htmlTitle()}");
        div.append(narration);


        CanvasElement canvasDiv = new CanvasElement(width: canvasWidth, height: canvasHeight);
        div.append(canvasDiv);

        var pSpriteBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
        Drawing.drawSprite(pSpriteBuffer,this.doomedTimeClone);

        var dSpriteBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
        Drawing.drawSpriteTurnways(dSpriteBuffer,player);

        Drawing.drawTimeGears(canvasDiv);//, this.doomedTimeClone);
        Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0);
        Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, dSpriteBuffer,100,0);
        return true;
    }

    @override
    String humanLabel() {
        return "Stop the ${bigBad.htmlTitle()} permanently.";
    }
}
