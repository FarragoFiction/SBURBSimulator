import 'dart:html';

/*
JR from 10/16/18 says that none of the crowned scenes are architected in a way that lets me easily
prevent them. so.....just....don't allow this i guess??? (basically just because the scene triggers doesn't mean that the
carapace ends up with a crown, and the scenes aren't even theonly way to get crowned)

class CrownedCarapaceHappened extends ImportantEvent {
    //i literally don't remember if this fucking does anything, oh yeah its for sort
    @override
    int importanceRating = 12; //not great, but could be worse
    Carapace carapace;

    CrownedCarapaceHappened(Carapace carapace,Session session, num mvp_value, Player player) : super(session, mvp_value, player);

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
        Player leader = session.getLeader(session.players);
        narration.setInnerHtml("A ${doomedTimeClone.htmlTitleBasic()} suddenly warps in from the future. They come with a dire warning of a doomed timeline. Something seems...off...about them. But they are adamant that the ${carapace.htmlTitle()} needs to not fucking have that Crown, and right the fuck now.   They get the drop on them and manage to steal the ${carapace.crowned.fullName} from them. They make sure to chuck it at the ${leader.htmlTitle()} before vanishing in a cloud of gears to join the final battle.");
        MagicalItem crown = carapace.crowned;
        //this is probably fine, any type of companion, including a doomed time clone can do shit, right?....oh, actually maybe not?
        //they aren't a companion, they are their own thing.
        //hrrm...eh, give it to the leader.
        leader.sylladex.add(crown);
        carapace.sylladex.remove(crown);
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
        return "Stop the ${carapace.htmlTitleBasic()} from gaining a Crown.";
    }
}
*/