import '../SBURBSim.dart';
import 'dart:html';

//TODO, maybe allow them to prevent existing god tiers?

//screw fate, we have a time player here, and obviously this fate leads to a doomed timeline anyways and thus is changeable.
//have alternate timeline change based on it being a dreamself that's dying versus an unsmooched regular self.
//if i ever implmeent moon destruction, will need to refactor this, unless want to have time shenanigans. (god tier time players can take dying player to before moon was destroyed???)
class PlayerDiedButCouldGodTier extends ImportantEvent{

    PlayerDiedButCouldGodTier(Session session, num mvp_value, Player player, [Player doomedTimeClone = null]): super(session, mvp_value, player, doomedTimeClone);

    @override
    String humanLabel(){
        String ret = "";
        ret += "Have the " + this.player.htmlTitleBasicNoTip() + " go God Tier instead of dying forever. ";
        return ret;
    }
    @override
    bool alternateScene(div){
        timesCalled ++;
        this.doomedTimeClone.dead = false;
        this.doomedTimeClone.setStat(Stats.CURRENT_HEALTH, this.doomedTimeClone.getStat(Stats.HEALTH));


        if(secondTimeClone != null){
            this.secondTimeClone.dead = false;
            this.secondTimeClone.setStat(Stats.CURRENT_HEALTH, this.secondTimeClone.getStat(Stats.HEALTH));
            return ImportantEvent.undoTimeUndoScene(div, this.session, this, this.doomedTimeClone, this.secondTimeClone);
        }
        ////print("times called : " + this.timesCalled);
        String narration = "<br>A " + this.doomedTimeClone.htmlTitleBasic() + " suddenly warps in from the future. ";
        narration +=  " They come with a dire warning of a doomed timeline. ";
        narration += " Something seems...off...about them. But they are adamant that the " + this.player.htmlTitleBasic() + " needs to go God Tier now. ";
        narration += " No matter what 'fate' says. ";
        narration += " They scoop the corpse up and vanish with it in a cloud of gears, depositing it instantly on the " + this.player.htmlTitleBasic() + "'s ";
        if(this.player.isDreamSelf == true){
            narration += "sacrificial slab, where it glows and ascends to the God Tiers with a sweet new outfit";
        }else{
            narration += " quest bed. The corpse glows and rises Skaiaward. ";
            narration +="On ${this.player.moon}, their dream self takes over and gets a sweet new outfit to boot.  ";
        }
        narration +=  " The doomed " + this.doomedTimeClone.htmlTitleBasic() + " vanishes in a cloud of gears to join the final battle.";
        appendHtml(div, narration);

        var divID = (div.id) + "_alt_${this.player.id}";
        String canvasHTML = "<br><canvas id='canvas" + divID+"' width='$canvasWidth' height='$canvasHeight'>  </canvas>";
        appendHtml(div, canvasHTML);
        var canvasDiv = querySelector("#canvas"+ divID);

        var pSpriteBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
        Drawing.drawSprite(pSpriteBuffer,this.doomedTimeClone);

        var dSpriteBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
        Drawing.drawSprite(dSpriteBuffer,this.player);
        Drawing.drawTimeGears(canvasDiv);//, this.doomedTimeClone);
        Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0);
        Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, dSpriteBuffer,100,0);

        var player = this.session.getVersionOfPlayerFromThisSession(this.player);
        player.makeGodTier();

        var divID2 = (div.id) + "_alt_god${player.id}";
        String canvasHTML2 = "<br><canvas id='canvas" + divID2+"' width='$canvasWidth' height='$canvasHeight'>  </canvas>";
        appendHtml(div, canvasHTML2);
        var canvasDiv2 = querySelector("#canvas"+ divID2);
        List<dynamic> players = [];
        players.add(player);
        Drawing.drawGetTiger(canvasDiv2, players);//,repeatTime);
        return true;
    }

}
