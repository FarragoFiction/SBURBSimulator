import "dart:html";
import "../SBURBSim.dart";

class LifeStuffPair {
    Player player1;
    Player player2;
    bool dream;

    LifeStuffPair(Player this.player1, Player this.player2, [bool this.dream = false]);
}

class GhostPact {
    Player ghost;
    String enablingAspect;

    GhostPact(Player this.ghost, String this.enablingAspect);
}

class LifeStuff extends Scene {
    //List<Player> playerList = [];  //what players are already in the medium when i trigger?
    num combo = 0; //arrays of [life/Doom player, other player] pairs. other player can be a corpse. other player can be null;
    List<LifeStuffPair> enablingPlayerPairs = <LifeStuffPair>[]; //it's weird. even though this class treats Life and Doom players as the same, in practice they behave entirely differently.
    //life players keep people from dying in the first place with high HP, while doom players make them die a LOT and become empowered by the afterlife.

    //what kind of priority should this have. players shouldn't fuck around in ream bubbles instead of land quests. but they also shouldn't avoid reviving players.
    //maybe revive stuff always happens, but anything else has a random chance of not happening?


    LifeStuff(Session session) : super(session);


    @override
    bool trigger(List<Player> playerList) {
        this.enablingPlayerPairs = <LifeStuffPair>[]; //player1, player2, dreamShenanigns
        //not just available players. if class that could revive SELF this way, can be called on dead. otherwise requires a living life/doom player.
        if (this.session.afterLife.ghosts.isEmpty) return false; //can't exploit the afterlife if there isn't one.
        //first, check the dead.
        List<Player> dead = findDeadPlayers(this.session.players); //don't care about availability.;
        for (num i = 0; i < dead.length; i++) {
            Player d = dead[i];
            if (d.aspect == Aspects.LIFE || d.aspect == Aspects.DOOM) {
                if (d.class_name == SBURBClassManager.THIEF || d.class_name == SBURBClassManager.HEIR) {
                    this.enablingPlayerPairs.add(new LifeStuffPair(d, null)); //gonna revive myself.
                }
            }
        }
        List<List<Player>> guidesAndNon = this.findGuidesAndNonGuides(); //IS about availability.
        List<Player> guides = guidesAndNon[0];
        List<Player> nonGuides = guidesAndNon[1];
        List<Player> removeNonGuides = <Player>[]; //don't remove elements in teh array you are in.
        //IMPORTANT if the below triggers to frequently can either changes it's priority in the scenes OR make there be a random chance of it not adding an enablingPlayer.
        //for each nonGuide, see if you can do something on your own.
        for (num i = 0; i < nonGuides.length; i++) {
            Player player = nonGuides[i];
            if (player.aspect == Aspects.LIFE || player.aspect == Aspects.DOOM || player.canGhostCommune() != null) {
                if (player.class_name != SBURBClassManager.WITCH && player.class_name != SBURBClassManager.SYLPH) {
                    this.enablingPlayerPairs.add(new LifeStuffPair(player, null));
                    removeNonGuides.add(player);
                } else if (!this.session.dreamBubbleAfterlife) {
                    this.enablingPlayerPairs.add(new LifeStuffPair(player, null)); //witches and sylphs turn on the dream bubble afterlife if it's not already on.
                    removeNonGuides.add(player);
                }
            }
        }

        for (num i = 0; i < removeNonGuides.length; i++) {
            removeFromArray(removeNonGuides[i], nonGuides);
        }

        dead = findDeadPlayers(this.session.players); //dead players can always be revived;
        nonGuides.addAll(dead);
        List<Player> removeGuides = <Player>[]; //don't remove elements in teh array you are in.
        //for each guide, see if there are any non guides left to guide.
        for (num i = 0; i < guides.length; i++) {
            if (!nonGuides.isEmpty) {
                Player guide = guides[i];
                Player nonGuide = rand.pickFrom(nonGuides);
                removeFromArray(nonGuide, nonGuides);
                removeGuides.add(guide);
                this.enablingPlayerPairs.add(new LifeStuffPair(guide, nonGuide));
            }
        }

        for (num i = 0; i < removeGuides.length; i++) {
            removeFromArray(removeGuides[i], guides);
        }
        //if you don't have an official role, join the pool of dreamers.
        nonGuides.addAll(guides);
        if (this.session.dreamBubbleAfterlife) {
            for (num i = 0; i < nonGuides.length; i++) {
                double r = rand.nextDouble(); //only spend half your time dreaming right.;
                Player player = nonGuides[i];
                if (!player.dreamSelf && !player.dead && r > .5) {
                    this.enablingPlayerPairs.add(new LifeStuffPair(player, null, true));
                }
            }
        }


        return !this.enablingPlayerPairs.isEmpty;
    }

    List<List<Player>> findGuidesAndNonGuides() {
        //List<dynamic> ret = [];
        List<Player> chosenGuides = <Player>[];
        List<Player> chosenSuplicants = <Player>[];
        for (num i = 0; i < this.session.availablePlayers.length; i++) {
            Player possibleGuide = this.session.availablePlayers[i];
            if (possibleGuide.aspect == Aspects.DOOM || possibleGuide.aspect == Aspects.LIFE || possibleGuide.canGhostCommune() != null) {
                if (possibleGuide.class_name == SBURBClassManager.SEER || possibleGuide.class_name == SBURBClassManager.SCRIBE || possibleGuide.class_name == SBURBClassManager.PAGE || possibleGuide.class_name == SBURBClassManager.BARD || possibleGuide.class_name == SBURBClassManager.ROGUE || possibleGuide.class_name == SBURBClassManager.MAID) {
                    chosenGuides.add(possibleGuide);
                }
            }
        }

        //either an active life/doom player, or any non life/doom player.
        for (num i = 0; i < this.session.availablePlayers.length; i++) {
            Player possibleGuide = this.session.availablePlayers[i];
            if (possibleGuide.class_name == SBURBClassManager.HEIR || possibleGuide.class_name == SBURBClassManager.THIEF || possibleGuide.class_name == SBURBClassManager.PRINCE || possibleGuide.class_name == SBURBClassManager.WITCH || possibleGuide.class_name == SBURBClassManager.SYLPH || possibleGuide.class_name == SBURBClassManager.KNIGHT || possibleGuide.class_name == SBURBClassManager.MAGE) {
                chosenSuplicants.add(possibleGuide);
            } else if (possibleGuide.aspect != Aspects.DOOM && possibleGuide.aspect != Aspects.LIFE || possibleGuide.canGhostCommune() == null) {
                if (!chosenGuides.contains(possibleGuide)) { //can't be both guide and non guide.
                    ////print("supplicant is: " + possibleGuide.title());
                    chosenSuplicants.add(possibleGuide);
                }
            }
        }
        return <List<Player>>[chosenGuides, chosenSuplicants];
    }

    @override
    void renderContent(Element div) {
        //print("rendering content for life stuff (won't necessarily be on screen): ${this.enablingPlayerPairs.length} " + this.session.session_id)
        //appendHtml(div, "<br>"+this.content());
        for (num i = 0; i < this.enablingPlayerPairs.length; i++) {
            Player player = this.enablingPlayerPairs[i].player1;

            Player other_player = this.enablingPlayerPairs[i].player2; //could be null or a corpse.
            bool dreaming = this.enablingPlayerPairs[i].dream;
            if (player.dead && !dreaming) { //if you'e dreaming, you're not a dead life/doom heir/thief
                if (player.class_name == SBURBClassManager.HEIR || player.class_name == SBURBClassManager.THIEF) {
                    this.drainDeadForReviveSelf(div, "", player, player.class_name, player.aspect);
                }
            } else if (dreaming == null) {
                if (player.class_name == SBURBClassManager.MAGE || player.class_name == SBURBClassManager.KNIGHT || player.class_name == SBURBClassManager.SAGE || player.class_name == SBURBClassManager.SCOUT) {
                    this.communeDead(div, "", player, player.class_name, player.aspect);
                } else if ((player.class_name == SBURBClassManager.SEER || player.class_name == SBURBClassManager.SCRIBE|| player.class_name == SBURBClassManager.PAGE) && other_player != null && !other_player.dead) {
                    this.helpPlayerCommuneDead(div, player, other_player);
                } else if (player.class_name == SBURBClassManager.PRINCE) {
                    this.drainDeadForPower(div, "", player, false);
                } else if (player.class_name == SBURBClassManager.BARD && other_player != null && !other_player.dead) {
                    this.helpPlayerDrainDeadForPower(div, player, other_player);
                } else if ((player.class_name == SBURBClassManager.ROGUE || player.class_name == SBURBClassManager.MAID) && other_player != null && other_player.dead) {
                    this.helpDrainDeadForReviveSelf(div, player, other_player);
                } else if ((player.class_name == SBURBClassManager.WITCH || player.class_name == SBURBClassManager.SYLPH) && !this.session.dreamBubbleAfterlife) {
                    this.enableDreamBubbles(div, player);
                }
            } else if (this.session.dreamBubbleAfterlife) {
                this.dreamBubbleAfterlifeAction(div, player);
            }
        }
    }

    CanvasElement dreamBubbleAfterlifeAction(Element div, Player player) {
        //if you meet guardian in dream bubble, bond over shared interests. small power boost.
        Player ghost = this.session.afterLife.findGuardianSpirit(player);
        String ghostName = "";
        if (ghost != null && !player.ghostPacts.contains(ghost) && !player.ghostWisdom.contains(ghost) && ghost.causeOfDrain == null) {
            //print("ghost of guardian: "+ player.titleBasic() + this.session.session_id);
            //talk about getting wisdom/ forging a pact with your dead guardian. different if i am mage or knight (because i am alone)
            ghostName = "teen ghost version of their ancestor";
        }


        if (ghost == null || player.ghostPacts.contains(ghost) || player.ghostWisdom.contains(ghost) || ghost.causeOfDrain == null) {
            ghost = this.session.afterLife.findAnyGhost(player);
            ghostName = "dead player";
        }

        if (ghost != null && player.id == ghost.id) {
            ghostName = "less fortunate alternate self";
        }

        if (ghost != null && ghost.causeOfDeath.contains(player.titleBasic())) {
            ghostName = "murder victim";
            print("The ${player.title()} did cause: ${ghost.causeOfDeath} ${this.session.session_id}");
        }

        if (ghost != null && !player.ghostPacts.contains(ghost) && !player.ghostWisdom.contains(ghost) && ghost.causeOfDrain == null) {
            //print("dream bubble onion" +this.session.session_id);
            String str = "The ${player.htmlTitle()} wanders a shifting and confusing landscape. They think they see a $ghostName? They must be dreaming.";
            String trait = Interest.getSharedCategoryWordForPlayers(player, ghost,true);
            if (ghostName == "murder victim") { //
                print("dead murder victims freakouts ${this.session.session_id}");
                str = "$str It's kind of freaking the ${player.htmlTitleBasic()} out a little. ";
                player.addStat("sanity", -10);
                player.flipOutReason = "being haunted by the ghost of the Player they killed";
            } else if (ghostName == "less fortunate alternate self") {
                print("dead alt selves freakouts ${this.session.session_id}");
                str = "$str It's kind of freaking the ${player.htmlTitleBasic()} out a little. ";
                player.addStat("sanity", -10);
                player.flipOutReason = "being haunted by their own ghost";
            } else if (trait != 'nice' && ghost.id != player.id) {
                str = "$str They bond over how $trait they both are. The ${player.htmlTitle()} feels their determination to beat the game grow. ";
                player.increasePower(ghost.getStat("power") / 2);
            } else {
                str = "$str It's a little awkward. ";
                player.increasePower(ghost.getStat("power") / 10);
            }
            appendHtml(div, "<br><br>$str");
            CanvasElement canvas = drawDreamBubbleH(div, player, ghost);
            removeFromArray(player, this.session.availablePlayers);
            return canvas;
        } else {
            //print("no ghosts in dream bubble: "+ player.titleBasic() + this.session.session_id);
            appendHtml(div, "<br><br>The ${player.htmlTitle()} wanders a shifting and confusing landscape. They must be dreaming. They never meet anyone before they wake up, though. ");
            //CanvasElement canvas =
            drawDreamBubbleH(div, player, null);
        }

        return null;
    }

    dynamic communeDead(Element div, String str, Player player, SBURBClass playerClass, Aspect enablingAspect) {
        //takes in player class because if there is a helper, what happens is based on who THEY are not who the player is.
        Player ghost = this.session.afterLife.findGuardianSpirit(player);
        String ghostName = "";
        if (ghost != null && player.getPactWithGhost(ghost) == null && !player.ghostWisdom.contains(ghost) && ghost.causeOfDrain == null) {
            //print("ghost of guardian: "+ player.titleBasic() + this.session.session_id);
            //talk about getting wisdom/ forging a pact with your dead guardian. different if i am mage or knight (because i am alone)
            ghostName = "teen ghost version of their ancestor";
        }
        if (ghost == null || player.getPactWithGhost(ghost) == null || player.ghostWisdom.contains(ghost) || ghost.causeOfDrain != null) {
            ghost = this.session.afterLife.findLovedOneSpirit(player);
            //print("ghost of loved one: "+ player.titleBasic() + this.session.session_id);
            ghostName = "ghost of a loved one";
        }

        if (ghost == null || player.getPactWithGhost(ghost) == null || player.ghostWisdom.contains(ghost) || ghost.causeOfDrain != null) {
            ghost = this.session.afterLife.findAnyAlternateSelf(player);
            //print("ghost of self: "+ player.titleBasic() + this.session.session_id);
            ghostName = "less fortunate alternate self";
        }

        if (ghost == null || player.getPactWithGhost(ghost) == null || player.ghostWisdom.contains(ghost) || ghost.causeOfDrain != null) {
            ghost = this.session.afterLife.findFriendlySpirit(player);
            //print("ghost of friend: "+ player.titleBasic() + this.session.session_id);
            ghostName = "dead friend";
        }

        if (ghost == null || player.getPactWithGhost(ghost) == null || player.ghostWisdom.contains(ghost) || ghost.causeOfDrain != null) {
            ghost = this.session.afterLife.findAnyGhost(player);
            ghostName = "dead player";
        }

        if (ghost != null && player.getPactWithGhost(ghost) == null && !player.ghostWisdom.contains(ghost) && ghost.causeOfDrain == null) {
            //print("commune potato" +this.session.session_id);
            appendHtml(div, "<br><br>${this.ghostPsionics(player)}$str${this.communeDeadResult(playerClass, player, ghost, ghostName, enablingAspect)}");
            CanvasElement canvas = this.drawCommuneDead(div, player, ghost);
            removeFromArray(player, this.session.availablePlayers);
            return canvas;
        } else {
            //print("no ghosts to commune dead for: "+ player.titleBasic() + this.session.session_id);
            return null;
        }
    }

    String ghostPsionics(Player player) {
        String psychicPowers = player.canGhostCommune();
        if (psychicPowers != null) {
            print("use psychic powers to commune with ghosts in session: ${this.session.session_id}");
            return " The ${player.htmlTitleBasic()} uses their $psychicPowers. ";
        } else {
            return "";
        }
    }

    CanvasElement drawDreamBubbleH(Element div, Player player, Player ghost) {
        String canvasId = "${div.id}commune_${player.chatHandle}";
        String canvasHTML = "<br><canvas id='$canvasId' width='${canvasWidth}' height='${canvasHeight}'>  </canvas>";
        appendHtml(div, canvasHTML);
        CanvasElement canvas = querySelector("#$canvasId");
        CanvasElement pSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
        Drawing.drawSprite(pSpriteBuffer, player);
        CanvasElement bubbleSpriteBuffer = Drawing.getBufferCanvas(querySelector("#canvas_template"));
        Drawing.drawDreamBubble(bubbleSpriteBuffer);

        //leave room on left for possible 'guide' player.
        Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, bubbleSpriteBuffer, 0, 0);
        Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer, 0, 0);
        if (ghost != null) {
            CanvasElement gSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
            Drawing.drawSpriteTurnways(gSpriteBuffer, ghost);
            //copyTmpCanvasToRealCanvasAtPos(canvas, bubbleSpriteBuffer,400,0);
            Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, gSpriteBuffer, 400, 0);
        }

        return canvas;
    }

    CanvasElement drawCommuneDead(Element div, Player player, Player ghost) {
        String canvasId = "${div.id}commune_${player.chatHandle}";
        String canvasHTML = "<br><canvas id='$canvasId' width='${canvasWidth}' height='${canvasHeight}'>  </canvas>";
        appendHtml(div, canvasHTML);
        CanvasElement canvas = querySelector("#$canvasId");
        CanvasElement pSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
        Drawing.drawSprite(pSpriteBuffer, player);
        CanvasElement gSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
        Drawing.drawSpriteTurnways(gSpriteBuffer, ghost);
        //leave room on left for possible 'guide' player.
        Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer, 200, 0);
        Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, gSpriteBuffer, 500, 0);
        return canvas;
    }

    CanvasElement drawDrainDead(Element div, Player player, Player ghost, bool long) {
        print("drain dead in: ${this.session.session_id}");
        String canvasId = "${div.id}commune_${player.chatHandle}";
        String canvasHTML = "<br><canvas id='$canvasId' width='${canvasWidth}' height='${canvasHeight}'>  </canvas>";
        appendHtml(div, canvasHTML);
        CanvasElement canvas = querySelector("#$canvasId");
        CanvasElement pSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
        Drawing.drawSprite(pSpriteBuffer, player);
        CanvasElement gSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
        Drawing.drawSpriteTurnways(gSpriteBuffer, ghost);


        //leave room on left for possible 'guide' player.
        if (long) {
            Drawing.drawWhatever(canvas, "drain_lightning_long.png");
        } else {
            Drawing.drawWhatever(canvas, "drain_lightning.png");
        }
        Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer, 200, 0);
        Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, gSpriteBuffer, 500, 0);
        //CanvasElement canvasBuffer = getBufferCanvas(querySelector("#canvas_template"));

        Drawing.drawWhatever(canvas, "drain_halo.png");

        return canvas;
    }

    String communeDeadResult(SBURBClass playerClass, Player player, Player ghost, String ghostName, Aspect enablingAspect) {
        if (playerClass == SBURBClassManager.KNIGHT || playerClass == SBURBClassManager.PAGE) {
            player.ghostPacts.add(new GhostPact(ghost, enablingAspect.name)); //help with a later fight.
            //print("Knight or Page promise of ghost attack: " + this.session.session_id);
            return " The ${player.htmlTitleBasic()} gains a promise of aid from the $ghostName. ";
        } else if (playerClass == SBURBClassManager.SEER || playerClass == SBURBClassManager.MAGE) {
            player.ghostWisdom.add(ghost); //don't do anything, but keeps repeats from happening.
            String effect = "";
            if (player.aspect == ghost.aspect && !ghost.fraymotifs.isEmpty && player.id != ghost.id) { //don't just relearn your own fraymotifs.
                print("player learning fraymotifs from a ghost ${this.session.session_id}");
                player.fraymotifs.addAll(ghost.fraymotifs); //copy not reference
                effect = "They learn ${turnArrayIntoHumanSentence(ghost.fraymotifs)} from the $ghostName. ";
            } else {
                player.increasePower(ghost.getStat("power") / 2); //want to increase aspect stats, too.
                effect = " The ${player.htmlTitleBasic()} gains valuable wisdom from the $ghostName. Their power grows much more quickly than merely doing quests. ";
            }


            player.leveledTheHellUp = true;
            player.level_index += 1;
            return effect;
        }
        return null;
    }

    void helpPlayerCommuneDead(Element div, Player player1, Player player2) {
        String divID = "${div.id}_communeDeadWithGuide${player1.chatHandle}";
        appendHtml(div, "<div id =$divID></div>");
        Element childDiv = querySelector("#$divID");
        String text = "";
        if (player1.class_name == SBURBClassManager.SEER) {
            text = "$text${this.ghostPsionics(player1)} The ${player1.htmlTitleBasic()} guides the ${player2.htmlTitleBasic()} to seek knowledge from the dead. ";
        } else if (player1.class_name == SBURBClassManager.PAGE) {
            text = "$text${this.ghostPsionics(player1)} The ${player1.htmlTitleBasic()} guides the ${player2.htmlTitleBasic()} to seek aid from the dead. ";
        }
        CanvasElement canvas = this.communeDead(childDiv, text, player2, player1.class_name, player1.aspect);
        if (canvas != null) {
            removeFromArray(player1, this.session.availablePlayers);
            //print("Help communing with the dead: " + this.session.session_id);
            CanvasElement pSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
            Drawing.drawSprite(pSpriteBuffer, player1);
            Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer, 0, 0);
            player1.interactionEffect(player2);
            player2.interactionEffect(player1);
        }
    }

    CanvasElement drainDeadForPower(Element div, String str, Player player, bool long) {
        Player ghost = this.session.afterLife.findHatedOneSpirit(player);
        String ghostName = "";
        if (ghost != null) {
            //print("ghost of enemy: "+ player.titleBasic() + this.session.session_id);
            //talk about getting wisdom/ forging a pact with your dead guardian. different if i am mage or knight (because i am alone)
            ghostName = "ghost of a hated enemy";
        }
        if (ghost == null || ghost.causeOfDrain == null) {
            ghost = this.session.afterLife.findAssholeSpirit(player);
            //print("ghost of an asshole: "+ player.titleBasic() + this.session.session_id);
            ghostName = "ghost of an asshole";
        }

        if (ghost == null || ghost.causeOfDrain == null) {
            ghost = this.session.afterLife.findAnyAlternateSelf(player);
            //print("ghost of self: "+ player.titleBasic() + this.session.session_id);
            ghostName = "less fortunate alternate self";
        }

        if (ghost == null || ghost.causeOfDrain == null) {
            ghost = this.session.afterLife.findAnyGhost(player);
            ghostName = "dead player";
        }

        if (ghost != null && ghost.causeOfDrain == null) {
            //print("ghost drain dead for power: "+ player.titleBasic()  + this.session.session_id);
            str = "$str${this.ghostPsionics(player)} The ${player.htmlTitleBasic()} destroys the essence of the $ghostName for greater destructive power, it will be a while before the ghost recovers.";
            ghost.causeOfDrain = player.title();
            player.increasePower(ghost.getStat("power"));
            player.leveledTheHellUp = true;
            player.level_index += 1;
            appendHtml(div, "<br><br>$str");
            CanvasElement canvas = this.drawDrainDead(div, player, ghost, long);
            removeFromArray(player, this.session.availablePlayers);
            return canvas;
        } else {
            //print("no ghosts to commune dead for: "+ player.titleBasic() + this.session.session_id);
            return null;
        }
    }

    void helpPlayerDrainDeadForPower(Element div, Player player1, Player player2) {
        //print("help drain dead for power: "+ player1.titleBasic() + this.session.session_id);
        String divID = "${div.id}_communeDeadWithGuide${player1.chatHandle}";
        appendHtml(div, "<div id =$divID></div>");
        Element childDiv = querySelector("#$divID");
        String text = "${this.ghostPsionics(player1)} The ${player1.htmlTitleBasic()} allows the ${player2.htmlTitleBasic()} to take power from the dead. ";

        CanvasElement canvas = this.drainDeadForPower(childDiv, text, player2, true);
        if (canvas != null) {
            removeFromArray(player1, this.session.availablePlayers);
            //print("Help draining power with the dead: " + this.session.session_id);
            CanvasElement pSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
            Drawing.drawSprite(pSpriteBuffer, player1);

            Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer, 0, 0);
            player1.interactionEffect(player2);
            player2.interactionEffect(player1);
        }
    }

    CanvasElement drainDeadForReviveSelf(Element div, String str, Player player, SBURBClass className, Aspect enablingAspect) {
        Player ghost = this.session.afterLife.findAnyUndrainedGhost(player.rand); //not picky in a crisis.
        String ghostName = "dead player";
        //need to find my own ghost and remove it from the afterlife.
        Player myGhost = this.session.afterLife.findClosesToRealSelf(player);
        //you can not use your own fresh ghost as fuel to revive. doens't work like that. even if it's kinda thematically appropriate for some clapsects.
        //if i let them do that, can INFINITELY respawn, because will ALWAYS have a non drained ghost to use.
        if (ghost != null && ghost.causeOfDrain != "" && myGhost != ghost) {
            print("ghost drain dead for revive: ${player.titleBasic()} ${this.session.session_id}");
            if (className == SBURBClassManager.THIEF || className == SBURBClassManager.ROGUE) {
                str = "$str${this.ghostPsionics(player)} The ${player.htmlTitleBasic()} steals the essence of the $ghostName in order to revive. It will be a while before the ghost recovers.";
            } else if (className == SBURBClassManager.HEIR || className == SBURBClassManager.MAID) {
                str = "$str${this.ghostPsionics(player)} The ${player.htmlTitleBasic()} inherits the essence and duties of the $ghostName in order to revive and continue their work. It will be a while before the ghost recovers.";
            }


            appendHtml(div, "<br><br>$str");
            ghost.causeOfDrain = player.title();
            CanvasElement canvas = Drawing.drawReviveDead(div, player, ghost, enablingAspect.name);
            player.makeAlive();
            if (enablingAspect == Aspects.LIFE) {
                player.addStat("currentHP", 100); //i won't let you die again.
                player.addStat("hp", 100); //i won't let you die again.
            } else if (enablingAspect == Aspects.DOOM) {
                player.addStat("minLuck", 100); //you've fulfilled the prophecy. you are no longer doomed.
                str = "${str}The prophecy is fulfilled. ";
            }


            removeFromArray(myGhost, this.session.afterLife.ghosts);
            removeFromArray(player, this.session.availablePlayers);
            return canvas;
        } else {
            //print("no ghosts to revive dead for: "+ player.titleBasic() + this.session.session_id);
            return null;
        }
    }

    void helpDrainDeadForReviveSelf(Element div, Player player1, Player player2) {
        String divID = "${div.id}_communeDeadWithGuide${player1.chatHandle}";
        appendHtml(div, "<div id =$divID></div>");
        Element childDiv = querySelector("#$divID");
        String text = "${this.ghostPsionics(player1)} The ${player1.htmlTitleBasic()} assists the ${player2.htmlTitleBasic()}. ";

        CanvasElement canvas = this.drainDeadForReviveSelf(childDiv, text, player2, player1.class_name, player1.aspect);
        if (canvas != null) {
            removeFromArray(player1, this.session.availablePlayers);
            //print("Help revive with the dead: " + this.session.session_id);
            CanvasElement pSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
            Drawing.drawSprite(pSpriteBuffer, player1);
            Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer, 0, 0);
            player1.interactionEffect(player2);
            player2.interactionEffect(player1);
        }
    }

    void enableDreamBubbles(Element div, Player player) {
        //print("Turning on dream bubble afterlife: " + this.session.session_id);
        this.session.dreamBubbleAfterlife = true;
        String canvasId = "${div.id}horror_terrors_${player.chatHandle}";
        String canvasHTML = "<br><canvas id='$canvasId' width='${canvasWidth}' height='${canvasHeight}'>  </canvas>";
        appendHtml(div, canvasHTML);
        CanvasElement canvas = querySelector("#$canvasId");
        CanvasElement pSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
        Drawing.drawSprite(pSpriteBuffer, player);
        CanvasElement horrorSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
        Drawing.drawHorrorterror(canvas);
        //leave room on left for possible 'guide' player.
        Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, horrorSpriteBuffer, 0, 0);
        Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer, 0, 0);
        String str = "${this.ghostPsionics(player)} What is the ${player.htmlTitleBasic()} doing out near the furthest ring? Oh GOD, what are they DOING!?  Oh, wait, never mind. False alarm. Looks like they're just negotiating with the horrorterrors to give players without dreamselves access to the afterlife in Dream Bubbles. Carry on.";
        appendHtml(div, str);
    }

    void makeDead(Player d) {
        ////print("make dead " + d.title())
        d.dead = true;
    }

    String content() {
        String ret = "TODO: LIfe stuff. for 1.0";

        return ret;
    }


}
