import "dart:html";
import "../SBURBSim.dart";
import "FeatureTypes/EnemyFeature.dart";


//there are different sub classes of reward. can get a fraymotif, can get grist, land level, items (post alchemy) minions (post npc).
//IMPORTANT don't keep state data here.
class Reward {
    static const String DEFAULT_TEXT = "You get jack shit, asshole!";

    static String PLAYER1 = "PLAYER1TAG";
    static String PLAYER2 = "PLAYER2TAG";
    String image = "Rewards/no_reward.png";
    String bgImage = null;
    void apply(Element div, Player p1, GameEntity p2, Land land, [String text = DEFAULT_TEXT]) {
        p1.increasePower();
        p1.increaseLandLevel();
        if(p2 != null) p2.increasePower(); //interaction effect will be somewhere else
        String divID = "canvas${div.id}_${p1.id}";
        //print ("applying base reward, text is $text ");
        String ret = "$text";
        appendHtml(div, ret);
        CanvasElement canvas = new CanvasElement(width: canvasWidth, height: canvasHeight);
        div.append(canvas);
        Element buffer = Drawing.getBufferCanvas(canvas.width, canvas.height);
        Drawing.drawSinglePlayer(buffer, p1);
        if(image != null ) Drawing.drawWhatever(buffer, image);
        if(bgImage != null) Drawing.drawWhatever(canvas, bgImage);
        //;
        Drawing.copyTmpCanvasToRealCanvas(canvas, buffer);
        if(p2 != null && (p2 is Player)){
            Element buffer2 = Drawing.getBufferCanvas(canvas.width, canvas.height);
            Drawing.drawSinglePlayer(buffer2, p2);
            Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, buffer2, 150,0);
        }
    }
}

//can get you item, fraymotif or companion, is very class/aspect specific, too.
//hope can get brain ghosts
//lords can get leprechauns
//other than that classes/aspects store their own odds for each type.
class RandomReward extends Reward {

    @override
    void apply(Element div, Player p1, GameEntity p2, Land land, [String t = Reward.DEFAULT_TEXT]) {

        WeightedList<Reward> options = new WeightedList<Reward>();
        //if it's an item reward, check land progress before deciding what sort of item to give.
        //fraymotifs will handle themselves
        //companions only care if brain ghost (50% chance )or leprechaun (100% chance lords only get leprechauns)

        //add each reward type with weight from class + aspect. item, fraymotif, companion.
        List items;
        if(land.thirdCompleted) {
            items = p1.class_name.items;
        }else if(land.secondCompleted) {
            items = p1.aspect.items;
        }else {
            if(p1.session.rand.nextBool()) {
                items = p1.interest1.category.items;
            }else {
                items = p1.interest2.category.items;
            }
            //for some reason adding this causes a concurrent modification error and i do not know why.
            //should not be concurrent
            //items.addAll(p1.interest2.category.items);
        }
        options.add(new ItemReward(items), p1.class_name.itemWeight + p1.aspect.itemWeight);
        options.add(new FraymotifReward(), p1.class_name.fraymotifWeight + p1.aspect.fraymotifWeight);

        if(p1.class_name == SBURBClassManager.LORD)
        {
            options.add(new LeprechaunReward(), p1.class_name.companionWeight + p1.aspect.companionWeight);
        }else if(p1.aspect == Aspects.HOPE){
            options.add(new BrainGhostReward(), p1.class_name.companionWeight + p1.aspect.companionWeight);
            //options.add(new ConsortReward(), p1.class_name.companionWeight + p1.aspect.companionWeight);
        }else
        {
            //p1.session.logger.info("DEBUG BRAIN: ${p1.aspect} player trying for a consort");
             options.add(new ConsortReward(), p1.class_name.companionWeight + p1.aspect.companionWeight);
        }

        Reward chosen;
        //some classes are nearly guaranteed to get certain things.
        if(p1.class_name.isProtective && p1.companionsCopy.isEmpty) {
            chosen = new ConsortReward(); //pages always get at least one companion.
        }else if(p1.class_name.isMagical && p1.fraymotifs.isEmpty) {
            chosen = new FraymotifReward();
        }else if(p1.class_name.isSneaky && p1.sylladex.isEmpty) {
            chosen = new ItemReward(items);
        }else {
            chosen = p1.session.rand.pickFrom(options);
        }
        return chosen.apply(div, p1, p2, land, t);
    }

}

class BoonieFraymotifReward extends FraymotifReward {
    static String FRAYMOTIF1 = "FRAYMOTIF_NAME1";
    static String FRAYMOTIF2 = "FRAYMOTIF_NAME2";
    String bgImage = "Rewards/sweetBoonies.png";

}
//TODO have it take in a name and then the fraymotif cna have a custom name?
class FraymotifReward extends Reward
{
    static String FRAYMOTIF1 = "FRAYMOTIF_NAME1";
    static String FRAYMOTIF2 = "FRAYMOTIF_NAME2";
    String name = null;
    String desc = null;
    @override
    String image = "Rewards/sweetLoot.png";
    String bgImage = "Rewards/fraymotifBG.png";

    FraymotifReward([String this.name = null, this.desc = null]);


    @override
    void apply(Element div, Player p1, GameEntity p2, Land land, [String t = Reward.DEFAULT_TEXT]) {
        String text = t;

        Fraymotif f1;
        Fraymotif f2;
        if(p2 != null) {
            if(p2 is Player) {
                text += "The ${Reward.PLAYER1} gains the fraymotif $FRAYMOTIF1, while the ${Reward.PLAYER2} gets the fraymotif $FRAYMOTIF2! ";
                f1 = p1.getNewFraymotif(p2); //with other player
                f2 = (p2 as Player).getNewFraymotif(p1);
                if(name != null) f2.name = name;
                text = text.replaceAll("${Reward.PLAYER2}", "${(p2 as Player).htmlTitleBasicNoTip()}");
                text = text.replaceAll("${FRAYMOTIF2}", "${f2.name}");
            }else {
                text += " The ${Reward.PLAYER1} gains the fraymotif $FRAYMOTIF1! ";
            }
        }else {
            text += " The ${Reward.PLAYER1} gains the fraymotif $FRAYMOTIF1! ";
        }

        if (f1 == null) f1 = p1.getNewFraymotif(null);
        //only player 1 gets custom fraymotif
        if(name != null) f1.name = name;
        if(desc != null) f1.desc = desc;
        text = text.replaceAll("${Reward.PLAYER1}", "${p1.htmlTitleBasicNoTip()}");
        text = text.replaceAll("${FRAYMOTIF1}", "${f1.name}");
        //super increases power and renders self.
        super.apply(div, p1, p2, land,text);
    }
}

class DenizenReward extends Reward {

    static String FRAYMOTIF1 = "FRAYMOTIF_NAME1";
    static String FRAYMOTIF2 = "FRAYMOTIF_NAME2";
    @override
    String image = "Rewards/sweetLoot.png";
    String bgImage = "Rewards/sweetGrist.png";

    String carapaceHandle;

    DenizenReward([String this.carapaceHandle]);

    @override
    void apply(Element div, Player p1, GameEntity p2, Land land, [String t = Reward.DEFAULT_TEXT]) {
        Item reward = p1.session.rand.pickFrom((p1.aspect.items));
        String text = " The ${Reward.PLAYER1} gains the fraymotif $FRAYMOTIF1, as well as all that sweet sweet grist hoard. Oh, and a ${reward.fullName}, too. ${reward.randomDescription(p1.rand)} ";
        if(p1.class_name == SBURBClassManager.LORD) {
            GameEntity c = Leprechaun.getLeprechaunForPlayer(p1); //will handle picking a name out.
            text += " The ${Reward.PLAYER1} also unlocks the Leprechaun minion for this Land. They name them ${c.name}.";
            p1.addCompanion(c);
        }

        if(p1.aspect == Aspects.HOPE) {
            GameEntity c = BrainGhostReward.getGhost(p1); //will handle picking a name out.
            if(c != null) {
                text += " The ${Reward.PLAYER1} also believes hard enough to manifest ${c.title()}.";
                p1.session.logger.info("Hope player beat denizen and manifested brain ghost");
                p1.addCompanion(c);
            }
        }
        p1.increaseGrist(100.0);
        p1.sylladex.add(reward.copy());
        DenizenFeature df = land.denizenFeature;
        if(df.denizen == null) {
            df.makeDenizen(p1);
        }
        Fraymotif f1 = df.denizen.fraymotifs.first;
       // ;
        p1.fraymotifs.add(f1);

        text = text.replaceAll("${Reward.PLAYER1}", "${p1.htmlTitleBasicNoTip()}");
        text = text.replaceAll("${FRAYMOTIF1}", "${f1.name}");
        //super increases power and renders self.
        p1.setDenizenDefeated();

        super.apply(div, p1, p2, land,text);
        if(carapaceHandle != null) {
            new SpecificCarapaceReward(carapaceHandle).apply(div, p1, p2, land, text);
        }
    }
}


class BattlefieldReward extends Reward {
    @override
    String image = null;
    @override
    String bgImage = "Rewards/battlefield.png";

    @override
    void apply(Element div, Player p1, GameEntity p2, Land land, [String text = Reward.DEFAULT_TEXT]) {
        text = " The ${Reward.PLAYER1} is getting pretty familiar with the battlefield. ";
        text = text.replaceAll("${Reward.PLAYER1}", "${p1.htmlTitleBasicNoTip()}");
        super.apply(div, p1, p2, land,text);
    }
}


class ConsortReward extends Reward {
    @override
    String image = "Rewards/sweetFriendship.png";
    WeightedList<Item> items;

    ConsortReward();

    @override
    void apply(Element div, Player p1, GameEntity p2, Land land, [String t = Reward.DEFAULT_TEXT]) {
        Consort template = land.consortFeature.makeConsort(p1.session);
        Consort c = Consort.npcForPlayer(template, p1); //will handle picking a title out.
        String text = " The ${Reward.PLAYER1} finds a ${c.sound}ing ${c.name}. They adopt it as their child.";
        p1.addCompanion(c);
        if(p2 != null && p2 is Player) {
            Player p2Player = p2 as Player;
            Consort c2 = Consort.npcForPlayer(template, p2);
            p2Player.addCompanion(c);
            text += "The ${Reward.PLAYER2} finds a ${c.name} as well.";
            text = text.replaceAll("${Reward.PLAYER2}", "${(p2 as Player).htmlTitleBasicNoTip()}");
        }
        text = text.replaceAll("${Reward.PLAYER1}", "${p1.htmlTitleBasicNoTip()}");
       // p1.session.logger.info("AB: Consort reward.");
        super.apply(div, p1, p2, land,text);
    }
}

class LeprechaunReward extends Reward {
    @override
    String image = "Rewards/sweetFriendship.png";
    WeightedList<Item> items;

    LeprechaunReward();

    @override
    void apply(Element div, Player p1, GameEntity p2, Land land, [String t = Reward.DEFAULT_TEXT]) {
        //snow man is a carapace.
        GameEntity c = Leprechaun.getLeprechaunForPlayer(p1); //will handle picking a name out.
        String text = " The ${Reward.PLAYER1} finds some sort of... ${p1.session.rand.pickFrom(Leprechaun.fakeDesc)}??? They decide to call them ${c.name} and vow to figure out exactly what ${c.name} is good for.";
        p1.addCompanion(c);
        //p2 gets NOTHING this is a Lord after all
        text = text.replaceAll("${Reward.PLAYER1}", "${p1.htmlTitleBasicNoTip()}");
        p1.session.logger.info("AB: fakeDesc reward.");
        super.apply(div, p1, p2, land,text);
    }
}


class BrainGhostReward extends Reward {
    @override
    String image = "Rewards/sweetFriendship.png";
    WeightedList<Item> items;

    BrainGhostReward();

    static Player getGhost(Player p1) {
        List<Player> possibleBrainGhosts = findAllAspectPlayers(p1.session.players, Aspects.HEART);


        Player bestFriend = p1.getBestFriend();
        possibleBrainGhosts.add(bestFriend);

        Player worstEnemy = p1.getWorstEnemy();
        possibleBrainGhosts.add(worstEnemy);


       // p1.session.logger.info("DEBUG BRAIN:  before removing duplicates, brain ghosts are: $possibleBrainGhosts");


        //don't have two copies of the same brain ghost
        List<Player> toRemove = new List<Player>();
        for(Player pbg in possibleBrainGhosts) {
            for(GameEntity g in p1.companionsCopy) {
                if(g is Player) {
                    Player gP = g as Player;
                    if(gP.chatHandle == pbg.chatHandle && gP.brainGhost) {
                       // ;
                        toRemove.add(pbg);
                    }else {
                       // ;
                    }
                }
            }
        }

        for(Player tr in toRemove) {
            //;
            possibleBrainGhosts.remove(tr);
        }
        //p1.session.logger.info("DEBUG BRAIN:  Hope player trying for a brain ghost");

       // p1.session.logger.info("DEBUG BRAIN: after removing duplicates, brain ghosts are: $possibleBrainGhosts");

        Player p = p1.session.rand.pickFrom(possibleBrainGhosts);
        //p1.session.logger.info("DEBUG BRAIN:  p is:  $p");

        if(p != null) {
            p = Player.makeRenderingSnapshot(p,false);
            p.brainGhost = true; //so spooky and transparent
            p.doomed = true;
        }
        return p;
    }

    @override
    void apply(Element div, Player p1, GameEntity p2, Land land, [String t = Reward.DEFAULT_TEXT]) {
        //p1.session.logger.info("DEBUG BRAIN:  brain ghost reward applying");
        Player p ;
        String relationship = "friend";
        p  = BrainGhostReward.getGhost(p1);


        String text;
        if(p == null) {
            ConsortReward c = new ConsortReward(); //just a normal consort
            c.apply(div,p1, p2, land, t);
            return;
        }else {
            relationship = p1.getRelationshipWith(p).saved_type;
            text = " The ${Reward.PLAYER1} believes really hard in their $relationship, the ${p.htmlTitle()} they are surprised, but happy, when it turns out that the version of them in their head can help them out in strifes! ";
        }
        p1.addCompanion(p);
        p2 = p; //so they get rendered.

        text = text.replaceAll("${Reward.PLAYER1}", "${p1.htmlTitleBasicNoTip()}");
        p1.session.logger.info("AB: brain ghost reward.");
        super.apply(div, p1, p2, land,text);
    }


}




class ItemReward extends Reward {
    @override
    String image = "Rewards/sweetTreasure.png";
    WeightedList<Item> items;

    //TODO there is a better way to architect this.
    ItemReward(WeightedList<Item> this.items);

    @override
    void apply(Element div, Player p1, GameEntity p2, Land land, [String t = Reward.DEFAULT_TEXT]) {
        Item item = p1.session.rand.pickFrom(items);
        String text = " The ${Reward.PLAYER1} finds a ${item.fullName}. ${item.randomDescription(p1.rand)}";

        if(p2 != null) {
            if(p2 is Player) {
                text = "The ${Reward.PLAYER1} and the ${Reward.PLAYER2} each get a ${item.fullName}. ${item.randomDescription(p1.rand)}" ;
                p2.sylladex.add(item.copy());
                text = text.replaceAll("${Reward.PLAYER2}", "${(p2 as Player).htmlTitleBasicNoTip()}");
            }
        }
        text = text.replaceAll("${Reward.PLAYER1}", "${p1.htmlTitleBasicNoTip()}");
        p1.sylladex.add(item.copy());
        super.apply(div, p1, p2, land,text);
    }
}


class SpecificCarapaceReward extends Reward {
    @override
    String image = "Rewards/sweetFriendship.png";
    Carapace carapace;
    String carapaceHandle;

    SpecificCarapaceReward(String this.carapaceHandle);

    @override
    void apply(Element div, Player p1, GameEntity p2, Land land, [String t = Reward.DEFAULT_TEXT]) {
        String text = "";
        carapace = p1.session.npcHandler.getCarapaceWithHandle(carapaceHandle);
        if(carapace == null || carapace.dead) {
            p1.session.logger.info("AB: The Carapace ($carapace that should have been triggered by this is dead.");
            text = "The ${p1.htmlTitle()} gets the strangest feeling that something more should be happening now.";
        }else {
            //p1.session.logger.info("AB: A Carapace ($carapace) joins in response to a quest.");

            text = " The ${p1.htmlTitle()} attracts the attention of a ${carapace.htmlTitle()}. They decide they like the cut of the ${p1.htmlTitle()}'s jib and agree to tag along.";
            if(carapace.partyLeader != null){
                text = "$text They ditch the ${carapace.partyLeader.htmlTitle()} entirely.";
            }
            carapace.active = true;
            p1.addCompanion(carapace);
        }
        super.apply(div, p1, p2, land,text);
    }
}


class CodReward extends Reward {
    @override
    String image = "/Rewards/sweetCod.png";

    @override
    void apply(Element div, Player p1, GameEntity p2, Land land, [String t = Reward.DEFAULT_TEXT]) {
        String text = " It. It's too beautiful for words. The glory of the COD PIECE is nearly blinding. The ${Reward.PLAYER1} will cherish this forever. They alchemize plenty of backups in different colors in case anyone else wants some.";
        if(!p1.godTier) text += " Too bad they'll have to wait to be god tier to TRULY appreciate it.";
        if(bardQuest) text += " Even if someone already found this sacred treasure, the ${Reward.PLAYER1} is glad they journeyed to find it on their own as well. ";
        text = text.replaceAll("${Reward.PLAYER1}", "${p1.htmlTitleBasicNoTip()}");
        Fraymotif f1 = p1.getNewFraymotif(null);
        int num = p1.session.rand.nextInt(13);
        //cod tier gives extra benefits.
        p1.increaseLandLevel();
        p1.increasePower();
        p1.sylladex.add(new Item("Cod Piece",<ItemTrait>[ItemTraitFactory.CLOTH,ItemTraitFactory.LEGENDARY,ItemTraitFactory.FAKE, ItemTraitFactory.CLASSRELATED],abDesc:"God damn it, MI. "));

        f1.name = "The Ballad of the ZillyCodPiece (Verse ${num})";
        bardQuest = true;
        for(Player p in p1.session.players) {
            if(p.class_name == SBURBClassManager.BARD) {
                p.renderSelf("codTier");
            }
        }
        //p1.renderSelf();
        super.apply(div, p1, p2, land,text);
    }
}



class FrogReward extends FraymotifReward {
    static String FRAYMOTIF1 = "FRAYMOTIF_NAME1";
    static String FRAYMOTIF2 = "FRAYMOTIF_NAME2";

    @override
    String image = "Rewards/sweetFrog.png";
    String bgImage = "Rewards/holyShitFrogs.png";
    @override
    void apply(Element div, Player p1, GameEntity p2, Land land, [String t = Reward.DEFAULT_TEXT]) {
        String text = "";
        if(p1.grimDark < 3) {
            p1.landLevel = 1.0 * p1.session.goodFrogLevel; //need to be double
            text = "The ${Reward.PLAYER1} breeds the final tadpole. While it is a tadpole for now, once it is placed in the fertlized SKAIA it will grow to become an entire Universe Frog.";
        }else {
            "Rewards/bitterFrog.png";
            p1.landLevel = -1.0*p1.session.goodFrogLevel;
            text = "The ${Reward.PLAYER1}. Um. You don't think they were supposed to be doing that. Why does the frog look like that? ";
        }
        super.apply(div, p1, p2, land,text);
    }
}

class ImmortalityReward extends Reward {

    @override
    String image = "Rewards/ohShit.png";
    @override
    String bgImage = "Rewards/sweetClock.png";


    @override
    void apply(Element div, Player p1, GameEntity p2, Land land, [String t = Reward.DEFAULT_TEXT]) {
        String text = " The ${Reward.PLAYER1} finds a strange clock and destroys it utterly. Where did they even get that crowbar? It doesn't matter.   They are now unconditionally immortal. What will happen? ";

        if(!p1.godTier) {
            text = " There remains to be a trivial act of self-suicide. And then... $text";
            p1.makeGodTier();
        }
        p1.unconditionallyImmortal = true;
        text = text.replaceAll("${Reward.PLAYER1}", "${p1.htmlTitleBasicNoTip()}");
        super.apply(div, p1, p2, land,text);
    }
}

///technically you can start a two player quest chain with one player and end it with another.
///or with no players at all. what matters is who you end it with, tho.
class PaleRomanceReward extends Reward {
    //they both get same fraymotif.
    static String FRAYMOTIF1 = "FRAYMOTIF_NAME1";
    static String FRAYMOTIF2 = "FRAYMOTIF_NAME2";
    String romanticEnding = " Pale Serenade";
    @override
    String image = null;
    @override
    String bgImage = "Moirail.png";


    @override
    void apply(Element div, Player p1, GameEntity p2, Land land, [String t = Reward.DEFAULT_TEXT]) {
        String text = " The ${Reward.PLAYER1} and the ${Reward.PLAYER2} find themselves sharing a tender moment of calmness. It is obvious to everyone that they are now moirails. They even get the fraymotifs ${FRAYMOTIF1} and ${FRAYMOTIF2} to celebrate! ";

        Fraymotif f1;
        Fraymotif f2;

        if(p2 == null || !(p2 is Player)) {
            p1.session.logger.info("got stood up from a pale ship");
            f1 = p1.getNewFraymotif(null); //with other player
            bgImage = null;
            text = " Huh. Well. I had this whole thing planned, but that second asshole flaked off and got replaced with that random consort. Only ${Reward.PLAYER1} is still here.  I guess they can still have the fraymotif ${FRAYMOTIF1}, though.";
        }else {
            if(p2 is Player) {
                p1.session.logger.info("Pale shipping reward");
                f1 = p1.getNewFraymotif(p2); //with other player
                f1.name += romanticEnding;
                f2 = (p2 as Player).getNewFraymotif(p1);
                f2.name += romanticEnding;
                text = text.replaceAll("${Reward.PLAYER2}", "${(p2 as Player).htmlTitleBasicNoTip()}");
                text = text.replaceAll("${FRAYMOTIF2}", "${f2.name}");
                if(p1 == p2) {
                    text += " We are all a little uncomfortable about the whole self-cest thing. This is probably why you're supposed to be playing with other Players, dunkass, not making this an awkward one man ballet.";
                }else {
                    Relationship.makeDiamonds(p1, p2);
                }
            }
        }

        text = text.replaceAll("${Reward.PLAYER1}", "${p1.htmlTitleBasicNoTip()}");
        text = text.replaceAll("${FRAYMOTIF1}", "${f1.name}");
        //super increases power and renders self.
        super.apply(div, p1, p2, land,text);
    }
}


///technically you can start a two player quest chain with one player and end it with another.
///or with no players at all. what matters is who you end it with, tho.
class FlushedRomanceReward extends Reward {
    //they both get same fraymotif.
    static String FRAYMOTIF1 = "FRAYMOTIF_NAME1";
    static String FRAYMOTIF2 = "FRAYMOTIF_NAME2";
    String romanticEnding = " Flushed Serenade";
    @override
    String image = null;
    @override
    String bgImage = "Matesprit.png";


    @override
    void apply(Element div, Player p1, GameEntity p2, Land land, [String t = Reward.DEFAULT_TEXT]) {
        String text = " The ${Reward.PLAYER1} and the ${Reward.PLAYER2} find themselves sharing a passionate moment. It is obvious to everyone that they are now matesprits. They even get the fraymotifs ${FRAYMOTIF1} and ${FRAYMOTIF2} to celebrate! ";

        Fraymotif f1;
        Fraymotif f2;

        if(p2 == null || !(p2 is Player)) {
            p1.session.logger.info("got stood up from a flushed ship");
            f1 = p1.getNewFraymotif(null); //with other player
            bgImage = null;
            text = " Huh. Well. I had this whole thing planned, but that second asshole flaked off  and got replaced with that random consort. Only ${Reward.PLAYER1} is still here.  I guess they can still have the fraymotif ${FRAYMOTIF1}, though.";
        }else{
            if(p2 is Player) {
                p1.session.logger.info("Flushed shipping reward");
                f1 = p1.getNewFraymotif(p2); //with other player
                f1.name += romanticEnding;
                f2 = (p2 as Player).getNewFraymotif(p1);
                f2.name += romanticEnding;
                text = text.replaceAll("${Reward.PLAYER2}", "${(p2 as Player).htmlTitleBasicNoTip()}");
                text = text.replaceAll("${FRAYMOTIF2}", "${f2.name}");
                if(p1 == p2) {
                    text += " We are all a little uncomfortable about the whole self-cest thing. This is probably why you're supposed to be playing with other Players, dunkass, not making this an awkward one man ballet.";
                }else {
                    Relationship.makeHeart(p1, p2);
                }
            }
        }

        text = text.replaceAll("${Reward.PLAYER1}", "${p1.htmlTitleBasicNoTip()}");
        text = text.replaceAll("${FRAYMOTIF1}", "${f1.name}");
        //super increases power and renders self.
        super.apply(div, p1, p2, land,text);
    }
}



///technically you can start a two player quest chain with one player and end it with another.
///or with no players at all. what matters is who you end it with, tho.
class PitchRomanceReward extends Reward {
    //they both get same fraymotif.
    static String FRAYMOTIF1 = "FRAYMOTIF_NAME1";
    static String FRAYMOTIF2 = "FRAYMOTIF_NAME2";
    String romanticEnding = " Pitch Insult";
    @override
    String image = null;
    @override
    String bgImage = "Kismesis.png";


    @override
    void apply(Element div, Player p1, GameEntity p2, Land land, [String t = Reward.DEFAULT_TEXT]) {
        String text = " The ${Reward.PLAYER1} and the ${Reward.PLAYER2} find themselves sharing a combatative moment. It is obvious to everyone that they are now Kismesises. They even get the fraymotifs ${FRAYMOTIF1} and ${FRAYMOTIF2} to celebrate! ";

        Fraymotif f1;
        Fraymotif f2;
        if(p2 == null || !(p2 is Player)) {
            p1.session.logger.info("got stood up from a pitch ship");
            f1 = p1.getNewFraymotif(null); //with other player
            bgImage = null;
            text = " Huh. Well. I had this whole thing planned, but that second asshole flaked off  and got replaced with that random consort. Only ${Reward.PLAYER1} is still here.  I guess they can still have the fraymotif ${FRAYMOTIF1}, though.";
        }else {
            if(p2 is Player) {
                p1.session.logger.info("Pitch shipping reward");
                f1 = p1.getNewFraymotif(p2); //with other player
                f1.name += romanticEnding;
                f2 = (p2 as Player).getNewFraymotif(p1);
                f2.name += romanticEnding;
                text = text.replaceAll("${Reward.PLAYER2}", "${(p2 as Player).htmlTitleBasicNoTip()}");
                text = text.replaceAll("${FRAYMOTIF2}", "${f2.name}");
                if(p1 == p2) {
                    text += " We are all a little uncomfortable about the whole self-cest thing. This is probably why you're supposed to be playing with other Players, dunkass, not making this an awkward one man ballet.";
                }else {
                    Relationship.makeSpades(p1, p2);
                }
            }
        }

        text = text.replaceAll("${Reward.PLAYER1}", "${p1.htmlTitleBasicNoTip()}");
        text = text.replaceAll("${FRAYMOTIF1}", "${f1.name}");
        //super increases power and renders self.
        super.apply(div, p1, p2, land,text);
    }
}


///all one thing so if you lose a dream self mid whatever, you at least get the right reward.
class DreamReward extends Reward {

    @override
    String image = null;
    String bgImage = "Prospit.png";

    @override
    void apply(Element div, Player p1, GameEntity p2, Land land, [String t = Reward.DEFAULT_TEXT]) {
        if(p1.dreamSelf) {
            if(p1.moon == p1.session.prospit) {
                applyProspit(div, p1, p2, land);
            }else {
                applyDerse(div, p1, p2, land);
            }
        }else if(!p1.dreamSelf && p1.session.stats.dreamBubbleAfterlife) {
            applyBubbles(div, p1, p2, land);
        }else {
            applyHorrorTerrors(div, p1, p2, land);
        }
    }

    void applyProspit(Element div, Player p1, GameEntity p2, Land land) {
       // p1.session.logger.info("getting random carapace for prospit reward");
        bgImage = "Prospit.png";
        if(p1.session.prospit.name.toLowerCase().contains("sauce")){
            bgImage = "saucemoon.png";
        }else if(p1.session.prospit.name.toLowerCase() != "prospit") {
            bgImage = "unknownmoon.png";
        }
        //but if they start up a SHENANIGAN we'll want custom text here.
        Carapace companion;
        Carapace activated;

        //both of these can return null.
        companion = p1.session.prospit.partyRandomCarapace;
        activated = p1.session.prospit.activateRandomCaparapce;


        String text = " The ${p1.htmlTitleBasicNoTip()} is getting pretty popular among Prospitians. ";
        if(companion != null && p1.session.rand.nextDouble() < p1.class_name.companionWeight + p1.aspect.companionWeight) {
            companion.active = true;
            String a  = "A";
            if(companion.name.startsWith(new RegExp("[aeiouAEIOU]"))) a = "An";
            text += "$a ${companion..htmlTitleWithTip()} takes a liking to them and agrees to find them back on their Land.";
            p1.addCompanion(companion);
        }else if (activated != null) {
            activated.active = true;
            String a  = "A";
            if(activated.name.startsWith(new RegExp("[aeiouAEIOU]"))) a = "An";
            text += "$a ${activated.htmlTitleWithTip()} bumps into them and they chat a bit.";
        }


        p1.addStat(Stats.SANITY, -1); //just a bit.
        bool savedDream = p1.isDreamSelf;
        p1.isDreamSelf = true;
        p1.renderSelf("dreamSelfProspit");
        super.apply(div, p1, p2, land,text);
        p1.isDreamSelf = savedDream;
        p1.renderSelf("recoveredFromDreamSelfProspit");

    }

    void applyDerse(Element div, Player p1, GameEntity p2, Land land) {
        //p1.session.logger.info("getting random carapace for derse reward");
        bgImage = "Derse.png";
        if(p1.session.derse.name.toLowerCase().contains("sauce")){
            bgImage = "saucemoon.png";
        }else if(p1.session.derse.name.toLowerCase() != "derse") {
            bgImage = "unknownmoon.png";
        }
        Carapace companion;
        Carapace activated;
        companion = p1.session.derse.partyRandomCarapace;
        activated = p1.session.derse.activateRandomCaparapce;

        String text = " The ${p1.htmlTitleBasicNoTip()} is getting pretty popular among Dersites. ";
        if(companion != null && p1.session.rand.nextDouble()<  p1.class_name.companionWeight + p1.aspect.companionWeight) {
            companion.active = true;

            String a  = "A";
            if(companion.name.startsWith(new RegExp("[aeiouAEIOU]"))) a = "An"; //look at me, doing grammar
            text += "$a ${companion.htmlTitleWithTip()} takes a liking to them and agrees to find them back on their Land.";
            p1.addCompanion(companion);
        }else if (activated != null) {
            activated.active  = true;
            p1.session.logger.info("AB: A dersite was activated.");
            String a  = "A";
            if(activated.name.startsWith(new RegExp("[aeiouAEIOU]"))) a = "An";
            text += "$a ${activated.htmlTitleWithTip()} bumps into them and they chat a bit.";
        }
        p1.corruptionLevelOther ++; //just a bit.
        bool savedDream = p1.isDreamSelf;
        p1.isDreamSelf = true;
        p1.renderSelf("dream self derse");
        super.apply(div, p1, p2, land,text);
        p1.isDreamSelf = savedDream;
        p1.renderSelf("recover from dream self derse");

    }

    void applyBubbles(Element div, Player p1, GameEntity p2, Land land) {
        //p1.session.logger.info("bubble reward");
        bgImage = "dreambubbles.png";
        String text = " The ${p1.htmlTitleBasicNoTip()} is getting used to these Dream Bubbles.";
        p1.addStat(Stats.SANITY, 2); //just a bit better.
        super.apply(div, p1, p2, land,text);

    }

    void applyHorrorTerrors(Element div, Player p1, GameEntity p2, Land land) {
        //p1.session.logger.info("terror reward");
        bgImage = "horrorterror.png";
        String text = " The ${p1.htmlTitleBasicNoTip()} writhes in agony.";
        p1.corruptionLevelOther += 2; //just a bit.
        p1.addStat(Stats.SANITY, -2); //just a bit.
        super.apply(div, p1, p2, land,text);
    }
}