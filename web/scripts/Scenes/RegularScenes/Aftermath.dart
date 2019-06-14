import "dart:async";
import "dart:html";
import "dart:math" as Math;
import "../../SBURBSim.dart";


class Aftermath extends Scene {

    Aftermath(Session session) : super(session);
    List<Player> entered = new List<Player>();

    @override
    bool trigger(playerList) {
        entered.clear();
        this.playerList = playerList;
        return true; //this should never be in the main array. call manually.
    }


    //vriska never even bothered to go into the frog. hussie was still in the medium
    //high gnosis can mean you can't be happy in a
    //semblance of your old life.
    String whoEnters() {
        List<Player> living = findLiving(session.players);
        entered.clear();
        String ret = "";
        for (Player p in living) {
            if(p.specibus.rank>5) session.logger.info("At aftermath, ${p} specibus rank is: ${p.specibus.rank}");
            if (p.gnosis < 3) {
                entered.add(p);
                ret += "The ${p.htmlTitleBasicWithTip()} enters the door to the new Universe.<Br><Br>";
            } else {
                if (p.gnosis == 3 && rand.nextBool()) {
                    entered.add(p);
                    ret += "The ${p.htmlTitleBasicWithTip()} stands for a long time outside the door to the new Universe. Finally, they enter. <Br><br>";
                } else if (p.gnosis == 3) {
                    ret += "The ${p.htmlTitleBasicWithTip()} stands for a long time outside the door to the new Universe. Finally, they turn away. <Br><br>";
                } else {
                    ret += "The ${p.htmlTitleBasicWithTip()} never even bothers to go see the door to the new Universe. There is still so much to do.<Br><br>";
                }
            }
        }

        return ret;
    }


    // only called if full frog. care about who enters new universe, not living
    String miniEpliogueFull() {
        //window.alert("${entered.length} players entered the new universe, they are $entered");
        if (entered.isEmpty && findLiving(session.players).length != 0) return gnosisEnding();
        if (entered.length == 1) return monoTheismEnding();
        if (Stats.RELATIONSHIPS.average(entered) > 20) return loveEnding();
        if (Stats.RELATIONSHIPS.average(entered) < -20) return hateEnding();
        return "Everything seems normal.";
    }

    String loveEnding() {
        session.stats.loveEnding = true;
        List<Player> living = findLiving(session.players);
        //who has highest relationship?
        Player friendLeader = Stats.RELATIONSHIPS.max(living);
        //does anybody have an abnormally low relationships?
        Player troubleMaker = Stats.RELATIONSHIPS.min(living);
        String ret = "The ${friendLeader.htmlTitle()} organizes everyone and makes sure everybody gets along and treats the people of the new Universe right. ";
        if (troubleMaker.getStat(Stats.RELATIONSHIPS) < -10) {
            ret += "The ${troubleMaker.htmlTitle()} stirs up trouble ";
            if (friendLeader.getStat(Stats.POWER) + friendLeader.getStat(Stats.RELATIONSHIPS) > troubleMaker.getStat(Stats.POWER)) {
                ret += "but it's nothing the ${friendLeader.htmlTitle()} can't handle with their friends by their side.";
            } else {
                ret += " and it becomes a constant thorn in everyone's side.";
            }
        }
        return ret;
    }

    String hateEnding() {
        session.stats.hateEnding = true;
        List<Player> living = findLiving(session.players);
        Player shoutLeader = Stats.RELATIONSHIPS.min(living);
        Player peaceMaker = Stats.RELATIONSHIPS.max(living);
        String ret = "The ${shoutLeader.htmlTitle()}  rules with an iron fist and insists that they live as gods. ";
        if (peaceMaker.getStat(Stats.RELATIONSHIPS) > 10) {
            ret += "The ${peaceMaker.htmlTitle()} begins to rebel ";
            //not changing this from lvoe ending.  i want it to be a good ending, evil is easy to defeat (because they likely have negative relationship stats weighting them down)
            if (shoutLeader.getStat(Stats.POWER) + shoutLeader.getStat(Stats.RELATIONSHIPS) > peaceMaker.getStat(Stats.POWER)) {
                ret += "but is brutally put down.";
            } else {
                ret += ", thus ends tyrants. ";
            }
        }
        return ret;
    }

    String monoTheismEnding() {
        session.stats.monoTheismEnding = true;
        Player god = entered.first;
        String ret = "The ${god.htmlTitle()} rules the new Universe absolutely, with no fellow players to challenge them. ";
        if (god.getStat(Stats.RELATIONSHIPS) > 100) {
            ret += "The people flourish under their loving guidance. ";
        } else if (god.getStat(Stats.RELATIONSHIPS) < -100) {
            ret += "The people wither under their iron fist. ";
        } else {
            ret += " They do their best, but ultimately allow the people to make their own decisions.";
        }
        return ret;
    }

    String gnosisEnding() {
        session.stats.gnosisEnding = true;
        return "With none of the fledgling gods entering the new Universe, it is allowed to grow and develop entirely on it's own. It is a glorious shade of pink. The Players remain inside the Medium supporting Reality from within. You have escaped the cycle of flawed creators ruling over flawed creations, SBURB will never trouble your cosmic progeny.";
    }



    void yellowLawnRing(div) {
        var living = findLiving(this.session.players);
        var dead = findDeadPlayers(this.session.players);
        //time players doesn't HAVE to be alive, but it makes it way more likely.
        var singleUseOfSeed = rand.nextDouble();
        var timePlayer = findAspectPlayer(living, Aspects.TIME);
        if (timePlayer == null && singleUseOfSeed > .5) {
            timePlayer = findAspectPlayer(this.session.players, Aspects.TIME);
        }
        if (dead.length >= living.length && timePlayer != null || this.session.janusReward) {
            //////session.logger.info("Time Player: " + timePlayer);
            timePlayer = findAspectPlayer(this.session.players, Aspects.TIME); //NEED to have a time player here.;
            var s = new YellowYard(this.session);
            s.timePlayer = timePlayer;
            s.trigger(null);
            s.renderContent(div);
        }
    }

    String mournDead(Element div) {
        var dead = findDeadPlayers(this.session.players);
        var living = findLiving(this.session.players);
        if (dead.length == 0) {
            return "";
        }
        String ret = "<br><br>";
        if (living.length > 0) {
            ret += " Victory is not without it's price. ${dead.length} players are dead, never to revive. There is time for mourning. <br>";
        } else {
            ret += " The consorts and Carapacians both Prospitian and Dersite alike mourn their fallen heroes. ";
            ret += "<img src = 'images/abj_watermark.png' class='watermark'>";
        }

        for (num i = 0; i < dead.length; i++) {
            var p = dead[i];
            ret += "<br><br> The " + p.htmlTitleBasic() + " died " + p.causeOfDeath + ". ";
            var friend = p.getWhoLikesMeBestFromList(living);
            var enemy = p.getWhoLikesMeLeastFromList(living);
            if (friend != null) {
                ret += " They are mourned by the " + friend.htmlTitle() + ". ";
                appendHtml(div, ret);
                ret = "";
                this.drawMourning(div, p, friend);
                appendHtml(div, ret);
            } else if (enemy != null) {
                ret += " The " + enemy.htmlTitle() + " feels awkward about not missing them at all. <br><br>";
                appendHtml(div, ret);
                ret = "";
            }
        }
        appendHtml(div, ret);
        return null;
    }

    void drawMourning(div, dead_player, friend) {
        if (doNotRender) return;
        var divID = (div.id) + "_${dead_player.id}";

        CanvasElement canvasDiv = new CanvasElement(width: canvasWidth, height: canvasHeight);
        div.append(canvasDiv);

        var pSpriteBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
        Drawing.drawSprite(pSpriteBuffer, friend);

        var dSpriteBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
        Drawing.drawSprite(dSpriteBuffer, dead_player);

        Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer, -100, 0);
        Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, dSpriteBuffer, 100, 0);
    }

    bool checkRocksFell(Element div, String end, bool yellowYard) {
        if (this.session.stats.rocksFell) {
            this.session.stats.makeCombinedSession = false;
            end += "<br>With Skaia's destruction, there is nowhere to deploy the frog to. It doesn't matter how much frog breeding the Space Player did.";
            end += " If it's any consolation, it really does suck to fight so hard only to fail at the last minute. <Br><Br>Game Over.";
            end += " Or is it? ";
            this.session.stats.scratchAvailable = true;
            SimController.instance.renderScratchButton(this.session);
            yellowYard = true;
            doAtEndOfAfterMath(div, end, yellowYard);
            return true;
        }
        return false;
    }

    String ringText() {
        String ret = "";
        GameEntity bqowner = session.derseRing == null  ?  null:session.derseRing.owner;
        GameEntity wqowner =  session.prospitRing == null  ?  null:session.prospitRing.owner;

        if(session.playersHaveRings()) {
            print("I think the players have the rings");
            if(bqowner != null) {
                ret = "$ret The  ${session.derseRing.owner.htmlTitle()} helpfully hands over the  ${session.derseRing}.";
            }else {
                ret = "$ret The BLACK RING has already been destroyed in the Forge, ";
            }

            if(wqowner != null) {
                ret = "$ret and the ${session.prospitRing.owner.htmlTitle()} helpfully hands over the ${session.prospitRing}.";
            }else {
                ret = "$ret and the WHITE RING has already been destroyed in the Forge. ";
            }
            ret = "$ret The Players chuck the two RINGS into the Forge in a dramatic moment, stoking it and preparing it for the Ultimate Frog. <br><br>";
        }else {
            ret = "The players stare at the Forge in dismay. Although it has been lit, the two RINGS are not available to fully prepare it for the Ultimate Frog. Shit.";

            if(bqowner != null) {
                ret = "$ret The ${session.derseRing.owner.htmlTitleWithTip()} has their grubby mits on the ${session.derseRing}.";
            }else {
                ret = "$ret The BLACK RING has already been destroyed in the Forge, ";
            }

            if(wqowner != null) {
                ret = "$ret and the ${session.prospitRing.owner.htmlTitleWithTip()} has their grubby mits on the ${session.prospitRing}.";
            }else {
                ret = "$ret and the WHITE RING has already been destroyed in the Forge. ";
            }
        }
        return "$ret <br><br>";
    }

    bool checkThereIsAFrog(Element div, String end, bool yellowYard, Player spacePlayer) {
        if (!session.noFrogCheck(spacePlayer)) {
            end += "<br><img src = 'images/sceneIcons/frogger_animated.gif'> Luckily, the " + spacePlayer.htmlTitle() + " was diligent in frog breeding duties. ";

            end = "$end ${ringText()}";

            if (session.enoughGristForFull()) {
                end += "The entire party showers the battlefield with hard earned grist. ";
            } else {
                session.logger.info("AB:  Not enough grist for full frog in session ${session.session_id}");
                end += "Huh. There doesn't seem to be much grist to deploy to the battlefied.  ";
            }
            if (session.sickFrogCheck(spacePlayer)) {
                end += " The frog looks... a little sick or something, though... That probably won't matter. You're sure of it. ";
            }
            end += " The frog is deployed, and grows to massive proportions, and lets out a breath taking Vast Croak.  ";
            if (session.sickFrogCheck(spacePlayer)) {
                end += " The door to the new universe is revealed.  As the leader reaches for it, a disaster strikes.   ";
                end += " Apparently the new universe's sickness manifested as its version of SBURB interfering with yours. ";
                end += " Your way into the new universe is barred, and you remain trapped in the medium.  <Br><br>Game Over.";
                end += " Or is it?";
                if (this.session.stats.ectoBiologyStarted == true) {
                    session.logger.info("AB: this session might be able to combo. MVP is ${findStrongestPlayer(session.players).grist} amount of grist");
                    //spacePlayer.landLevel = -1025; //can't use the frog for anything else, it's officially a universe. wait don't do this, breaks abs frog reporting
                    this.session.stats.makeCombinedSession = true; //triggers opportunity for mixed session
                }
                //if skaia is a frog, it can't take in the scratch command.
                this.session.stats.scratchAvailable = false;
                //renderScratchButton(this.session);
            } else {
                end += " <Br><br> The door to the new universe is revealed. <br><Br>";
                end += whoEnters();
                end += "<Br><Br>";
                //spacePlayer.landLevel = -1025; //can't use the frog for anything else, it's officially a universe. wait don't do this, breaks abs frog reporting
                this.session.stats.won = true;
                end += "You get a brief glance of the future of the new Universe. ${miniEpliogueFull()}<br><br>";
            }
            doAtEndOfAfterMath(div, end, yellowYard);
            return true;
        }
        return false;
    }

    bool assumeNoFrog(Element div, String end, bool yellowYard, Player spacePlayer) {
        if (this.session.stats.rocksFell) {
            end += "<br>With Skaia's destruction, there is nowhere to deploy the frog to. It doesn't matter how much frog breeding the Space Player did.";
        } else {
            end = "$end ${ringText()}";
            if (session.noFrogCheck(spacePlayer) && session.enoughGristForAny() && session.playersHaveRings() && spacePlayer.land !=null && !spacePlayer.land.dead) {
                end += "<br>Unfortunately, the " + spacePlayer.htmlTitle() + " was unable to complete frog breeding duties. ";
                end += " They only got ${(spacePlayer.landLevel / this.session.minFrogLevel * 100).floor()}% of the way through. ";
                ////session.logger.info("${(spacePlayer.landLevel / this.session.minFrogLevel * 100).round()} % frog in session: ${this.session.session_id}");
                if (spacePlayer.landLevel < 0) {
                    end += " Stupid lousy goddamned GrimDark players fucking with the frog breeding. Somehow you ended up with less of a frog than when you got into the medium. ";
                }
                end += " Who knew that such a pointless mini-game was actually crucial to the ending? ";
                end += " No universe frog, no new universe to live in. Thems the breaks. ";
            }else if(spacePlayer.land == null || spacePlayer.land.dead) {
                end += " The Players realize, far too late, that with the destruction of the ${spacePlayer.htmlTitle()}'s land, there is no more Forge in which to deploy the Ultimate Frog. ";
                session.stats.brokenForge = true;
            }else if (!session.enoughGristForAny()) {
                ////session.logger.info("AB:  Not enough grist for any frog in session ${session.session_id}");

                end += "<br>Unfortunately, the players did not collect enough grist to even BEGIN to nurture the battlefield. They only got ${session.gristPercent()}% of the needed amount. ";
                end += "Apparently it wasn't enough to focus on beating the game, you had to actually PLAY it, too.";
            }else if(!session.playersHaveRings()) {
                end += "Without the Forge Stoked, the Universe Frog has nowhere to gestate. All of their hard work was for nothing...";

            }else {
                ////session.logger.info("AB:  Frog glitched out, should exist but doesn't in session ${session.session_id}");
                end += "<br> Whoa.  Tell JR that this shouldn't happen. There's apparently no Universe Frog, but there IS a frog and also enough grist.";
            }
        }

        end += " If it's any consolation, it really does suck to fight so hard only to fail at the last minute. <Br><Br>Game Over.";
        end += " Or is it? ";
        this.session.stats.scratchAvailable = true;
        SimController.instance.renderScratchButton(this.session);
        yellowYard = true;
        doAtEndOfAfterMath(div, end, yellowYard);
    }

    void doAtEndOfAfterMath(Element div, String end, bool yellowYard) {
        //used to be power based, anywhere else doing mvp (like yellow yard shit) still is. need to update tournament, too
        Player strongest = findMVP(this.session.players);
        end += "<br> The MVP of the session was: " + strongest.htmlTitleWithTip() + " with a grist level  of: ${strongest.grist}";
        end += "<br>Thanks for Playing!<br>";
        //ternary always confuses me. if the ring is null, the ring owner is null
        GameEntity bqowner = session.derseRing == null  ?  null:session.derseRing.owner;
        GameEntity bkowner = session.derseScepter == null  ?  null:session.derseScepter.owner;
        GameEntity wqowner =  session.prospitRing == null  ?  null:session.prospitRing.owner;
        GameEntity wkowner = session.prospitScepter == null  ?  null:session.prospitScepter.owner;

        String bqname = bqowner == null  ?  "No one":"${bqowner.htmlTitleWithTip()}";
        String bqallied =bqowner == null  ?  "N/A":"${bqowner.alliedToPlayers}";

        String wqname = wqowner == null  ?  "No one":"${wqowner.htmlTitleWithTip()}";
        String wqallied =wqowner == null  ?  "N/A":"${wqowner.alliedToPlayers}";

        String bkname = bkowner == null  ?  "No one":"${bkowner.htmlTitleWithTip()}";
        String bkallied =bkowner == null  ?  "N/A":"${bkowner.alliedToPlayers}";

        String wkname = wkowner == null  ?  "No one":"${wkowner.htmlTitleWithTip()}";
        String wkallied =wkowner == null  ?  "N/A":"${wkowner.alliedToPlayers}";

       // end += "<br>JR is going to nuke the fuck out of the current Aftermath. In the meantime: <br><Br>${bqname} has the Black Queens Ring Their ally status is ${bqallied}. <br> ${bkname} has the Black Kings Scepter. Their ally status is ${bkallied}.  <br> ${wqname} has the White Queens Ring. Their ally status is ${wqallied}. <br> ${wkname} has the White Kings Scepter. Their ally status is ${wkallied}. <br>";

        appendHtml(div, end);
        //String divID = (div.id) + "_aftermath" ;
        processBigBadEndings();


        //poseAsATeam(canvasDiv, this.session.players, 2000); //everybody, even corpses, pose as a team.
        this.lastRender(div);
        if (yellowYard == true || this.session.janusReward) {
            this.yellowLawnRing(div); //can still scratch, even if yellow lawn ring is available
        }
        session.mutator.renderEndButtons(div, session);
        //i'll do a different end point check in that case
        if(!session.stats.makeCombinedSession) {
            session.simulationComplete("Aftermath, not eligible for a combo.");
        }
        return null;
    }

    void processBigBadEndings() {
        List<GameEntity> possibleTargets = new List<GameEntity>.from(session.activatedNPCS);
        //if you are not a big bad, dead or inactive, remove.
        possibleTargets.removeWhere((GameEntity item) => !(item is BigBad) || item.dead || !item.active);
        bool frogIsIn = session.stats.won;
        String status = session.frogStatus();
        if(status == "Full Frog" || status == "Purple Frog") {
            for (BigBad bb in possibleTargets) {
                String text = "";
                if (!frogIsIn) {
                    frogIsIn = true;
                    text = "${bb
                        .htmlTitle()} pops the fully bred, but Playerless Frog into the Skaia hole.";
                }
                if (session.stats.gnosisEnding) {
                    text = "$text ${bb.pinkFrogText}";
                } else if (session.frogStatus().contains("Purple")) {
                    text = "$text ${bb.purpleFrogText}";
                } else {
                    text = "$text ${bb.regularFrogText}";
                }
                if (text != null && text.isNotEmpty) {
                    DivElement div = new DivElement()
                        ..text = text;
                    SimController.instance.storyElement.append(div);
                }
            }
        }
    }

    void processLivingEnding(Element div, String end, bool yellowYard) {
        Player spacePlayer = this.session.findBestSpace();
        Player corruptedSpacePlayer = this.session.findMostCorruptedSpace();
        if (checkRocksFell(div, end, yellowYard)) {
            return; //nothing more i can do.
        }else if (session.purpleFrogCheck(corruptedSpacePlayer)) {
            this.purpleFrogEnding(div, end);
            return;
        }else if (checkThereIsAFrog(div, end, yellowYard, spacePlayer)){
            return;
        }else{
            assumeNoFrog(div, end, yellowYard, spacePlayer);
        return;
        }
    }

    @override
    void renderContent(Element div) {
        //session.logger.info("AB: Aftermath. MVP is ${findStrongestPlayer(session.players).grist} amount of grist");
        bool yellowYard = false;
        String end = "<Br>";
        List<Player> living = findLiving(this.session.players);
        bool queenDefeated = false;
        if(this.session.derse == null) {
            queenDefeated = true;
        }else if(this.session.derse.queen.dead || this.session.derse.queen.getStat(Stats.CURRENT_HEALTH) <= 0)  {
            queenDefeated = true;
        }
        //var spacePlayer = findAspectPlayer(this.session.players, Aspects.SPACE);
        //...hrrrm...better debug this. looks like this can be triggered when players AREN"T being revived???
        if (living.length > 0 && (!this.session.battlefield.blackKing.dead || !queenDefeated)) {
            end += " While various bullshit means of revival were being processed, the Black Royalty have fled Skaia to try to survive the Meteor storm. There is no more time, if the frog isn't deployed now, it never will be. There is no time for mourning. ";
            this.session.stats.opossumVictory = true; //still laughing about this. it's when the players don't kill the queen/king because they don't have to fight them because they are al lint he process of god tier reviving. so the royalty fucks off. and when the players wake up, there's no bosses, so they just pop the frog in the skia hole.
            appendHtml(div, end);
            end = "<br><br>";
        } else if (living.length > 0) {
            if (living.length == this.session.players.length) {
                end += " All ";
            }
            end += "${living.length} players are alive.<BR>";
            appendHtml(div, end); //write text, render mourning
            end = "<Br>";
            this.mournDead(div);
        }

        if (living.length > 0) {
            processLivingEnding(div, end, yellowYard);
        } else{
            appendHtml(div, end);
            end = "<Br>";
            this.mournDead(div);
            end += " <br>The players have failed. No new universe is created. Their home universe is left unfertilized. <Br><Br>Game Over. ";
            doAtEndOfAfterMath(div, end, yellowYard);
        }
     }

    Player trollKidRock() {
        String trollKidRockString = "b=%00%00%00%C2%91%C3%B0%15%10VDD%20&s=,,Rap-Rock,Riches,bawitdaBastard"; //Ancient, thank you for best meme. ;
        Player trollKidRock = new CharacterEasterEggEngine().playerDataStringArrayToURLFormat(session,[trollKidRockString])[0];
        trollKidRock.session = this.session;
        Fraymotif f = new Fraymotif("BANG DA DANG DIGGY DIGGY", 3); //most repetitive song, ACTIVATE!!!;
        f.effects.add(new FraymotifEffect(Stats.POWER, 3, true)); //buffs party and hurts enemies
        f.effects.add(new FraymotifEffect(Stats.POWER, 1, false));
        f.desc = " OWNER plays a 90s hit classic, and you can't help but tap your feet. ENEMY seems to not be able to stand it at all.  A weakness? ";
        trollKidRock.fraymotifs.add(f);

        f = new Fraymotif("BANG DA DANG DIGGY DIGGY", 3); //most repetitive song, ACTIVATE!!!;
        f.effects.add(new FraymotifEffect(Stats.POWER, 3, true)); //buffs party and hurts enemies
        f.effects.add(new FraymotifEffect(Stats.POWER, 1, false));
        f.desc = " OWNER plays a 90s hit classic, and you can't help but tap your feet. ENEMY seems to not be able to stand it at all.  A weakness? ";
        trollKidRock.fraymotifs.add(f);

        f = new Fraymotif("BANG DA DANG DIGGY DIGGY", 3); //most repetitive song, ACTIVATE!!!;
        f.effects.add(new FraymotifEffect(Stats.POWER, 3, true)); //buffs party and hurts enemies
        f.effects.add(new FraymotifEffect(Stats.POWER, 1, false));
        f.desc = " OWNER plays a 90s hit classic, and you can't help but tap your feet. ENEMY seems to not be able to stand it at all.  A weakness? ";
        trollKidRock.fraymotifs.add(f);

        f = new Fraymotif("BANG DA DANG DIGGY DIGGY", 3); //most repetitive song, ACTIVATE!!!;
        f.effects.add(new FraymotifEffect(Stats.POWER, 3, true)); //buffs party and hurts enemies
        f.effects.add(new FraymotifEffect(Stats.POWER, 1, false));
        f.desc = " OWNER plays a 90s hit classic, and you can't help but tap your feet. ENEMY seems to not be able to stand it at all.  A weakness? ";
        trollKidRock.fraymotifs.add(f);
        initializePlayersNoReplayers([trollKidRock], null); //don't let troll kid rock get replaced.
        trollKidRock.setStat(Stats.CURRENT_HEALTH, 1000);
        return trollKidRock;
    }

    GameEntity purpleFrog() {
        Player mvp = findStrongestPlayer(this.session.players);
        Map<Stat, num> tmpStatHolder = {};
        tmpStatHolder[Stats.MIN_LUCK] = -100;
        tmpStatHolder[Stats.MAX_LUCK] = 100;
        tmpStatHolder[Stats.CURRENT_HEALTH] = 30000 + mvp.getStat(Stats.POWER) * this.session.players.length; //this will be a challenge. good thing you have troll kid rock to lay down some sick beats.

        tmpStatHolder[Stats.HEALTH] = 30000 + mvp.getStat(Stats.POWER) * this.session.players.length; //this will be a challenge. good thing you have troll kid rock to lay down some sick beats.
        tmpStatHolder[Stats.MOBILITY] = -100;
        tmpStatHolder[Stats.SANITY] = 0;
        tmpStatHolder[Stats.FREE_WILL] = 200;
        tmpStatHolder[Stats.POWER] = 20000 + mvp.getStat(Stats.POWER) * this.session.players.length; //this will be a challenge.
        tmpStatHolder[Stats.GRIST] = 100000000;
        tmpStatHolder[Stats.RELATIONSHIPS] = -100; //not REAL relationships, but real enough for our purposes.
        //////session.logger.info(purpleFrog);
        GameEntity purpleFrog = new GameEntity(" <font color='purple'>" + Zalgo.generate("Purple Frog") + "</font>", this.session);
        purpleFrog.stats.setMap(tmpStatHolder);
        ////session.logger.info(purpleFrog);
        //what kind of attacks does a grim dark purple frog have???  Croak Blast is from rp, but what else?

        Fraymotif f = new Fraymotif(Zalgo.generate("CROAK BLAST"), 3); //freeMiliu_2K01 [F☆] came up with this one in the RP :)  :) :);
        f.effects.add(new FraymotifEffect(Stats.MOBILITY, 3, true));
        f.desc = " OWNER uses a weaponized croak. You would be in awe if it weren't so painful. ";
        purpleFrog.fraymotifs.add(f);

        f = new Fraymotif(Zalgo.generate("HYPERBOLIC GEOMETRY"), 3); //DM, the owner of the purple frog website came up with this one.;
        f.effects.add(new FraymotifEffect(Stats.MOBILITY, 3, false));
        f.desc = " OWNER somehow corrupts the very fabric of space. Everyone begins to have trouble navigating the corrupted and broken rules of three dimensional space. ";
        purpleFrog.fraymotifs.add(f);

        f = new Fraymotif(Zalgo.generate("ANURA JARATE"), 3); //DM, the owner of the purple frog website came up with this one. team fortress + texts from super heroes ftw.;
        f.effects.add(new FraymotifEffect(Stats.SANITY, 3, false));
        f.desc = " Did you know that some species of frogs weaponize their own urine? Now you do. You can never unknow this. The entire party is disgusted. ";
        purpleFrog.fraymotifs.add(f);

        f = new Fraymotif(Zalgo.generate("LITERAL TONGUE LASHING"), 3); //DM, the owner of the purple frog website came up with this one.;
        f.effects.add(new FraymotifEffect(Stats.MOBILITY, 2, false));
        f.effects.add(new FraymotifEffect(Stats.MOBILITY, 2, true));
        f.desc = " OWNER uses an incredibly long, sticky tongue to attack the ENEMY, hurting and immobilizing them. ";
        purpleFrog.fraymotifs.add(f);

        return purpleFrog;
    }

    List<GameEntity> getGoodGuys(Player trollKidRock) {
        List<GameEntity> ret = <GameEntity>[];
        List<GameEntity> living = this.session.players;
        List<Player> allPlayers = this.session.players; //anybody can have doomedclones now, not just time players.

        for (int i = 0; i < allPlayers.length; i++) {
            living.addAll(allPlayers[i].doomedTimeClones);
            for(GameEntity g in allPlayers[i].companionsCopy) {
                if(g is Player && !g.dead) ret.add(g);
            }
        }

        ret.addAll(living);
        return ret;
    }

    void purpleFrogEnding(Element div, String precedingText) {
        //alert("purple frog incoming!!!" + this.session.session_id);
        //maybe load kid rock first and have callback for when he's done.
        //maybe kid rock only shows up for half purple frogs??? need plausible deniability? "Troll Kid Rock??? Never heard of him. Sounds like a cool dude, though."
        Player trollKidRock = this.trollKidRock();
        ////session.logger.info(trollKidRock);
        GameEntity purpleFrog = this.purpleFrog();
        precedingText += "<img src = 'images/sceneicons/Purple_Frog_ANGERY.png'> What...what is going on? How...how can you have NEGATIVE 100% of a frog??? This...this doesn't look right.   The vast frog lets out a CROAK, but it HURTS.  It seems...hostile.  Oh fuck. <Br><br> The " + purpleFrog.htmlTitleHP() + " initiates a strife with the Players! Troll Kid Rock appears out of nowhere to help them. (What the hell???)<br><br>";

        appendHtml(div, precedingText);
        CanvasElement tkrCanvas = new CanvasElement(width: canvasWidth, height: canvasHeight);
        div.append(tkrCanvas);
        List<GameEntity> purpleFighters = this.getGoodGuys(trollKidRock);
        //var callBack = this.finishPurpleStrife.bind(this, div, purpleFrog, purpleFighters, trollKidRock);
        //loadAllImagesForPlayerWithCallback(trollKidRock, callBack);
        if (doNotRender) {
            this.finishPurpleStrife(div,tkrCanvas, purpleFrog, purpleFighters, trollKidRock);
        } else {
            loadAllImagesForPlayerWithCallback(session,trollKidRock, () {
                this.finishPurpleStrife(div,tkrCanvas, purpleFrog, purpleFighters, trollKidRock);
            });
        }
    }

    void finishPurpleStrife(Element div, CanvasElement tkrCanvas, GameEntity purpleFrog, List<GameEntity> fighters, Player trollKidRock) {
        Drawing.drawTimeGears(tkrCanvas); //, trollKidRock);
        Drawing.drawSinglePlayer(tkrCanvas, trollKidRock);
        fighters.add(Player.makeRenderingSnapshot(trollKidRock)); //sorry trollKidRock you are not REALLY a player.
        Team pTeam = new Team.withName("The Players", this.session, fighters);
        Team dTeam = new Team(this.session, [purpleFrog]);
        pTeam.canAbscond = false;
        dTeam.canAbscond = false;
        Strife strife = new Strife(this.session, [pTeam, dTeam]);
        strife.startTurn(div);
        String ret = "";
        if (purpleFrog.getStat(Stats.CURRENT_HEALTH) <= 0 || purpleFrog.dead) {
            this.session.stats.won = true;
            ret += "With a final, deafening 'CROAK', the " + purpleFrog.name + " slumps over. While it appears dead, it is merely unconscious. Entire universes swirl within it now that it has settled down, including the Players' original Universe. You guess it would make sense that your Multiverse would be such an aggressive, glitchy asshole, if it generated such a shitty, antagonistic game as SBURB.  You still don't know what happened with Troll Kid Rock. You...guess that while regular Universes start with a 'bang', Skaia has decreed that Multiverses have to start with a 'BANG DA DANG DIGGY DIGGY'.  <Br><br> The door to the new multiverse is revealed. Everyone files in. <Br><Br> Thanks for Playing. <span class = 'void'>Though, of course, the Horror Terrors slither in right after the Players. It's probably nothing. Don't worry about it.  THE END</span>";
        } else {
            ret += "With a final, deafening 'CROAK', the " + purpleFrog.name + " floats victorious over the remains of the Players.   The Horror Terrors happily colonize the new Universe, though, so I guess the GrimDark players would be happy with this ending?  <Br><Br> Thanks for Playing. ";
        }
        appendHtml(div, ret);
        session.simulationComplete("Purple Frog");
        this.lastRender(div);
    }

    void lastRender(Element div) {
        div = querySelector("#charSheets");
        //div.setInnerHtml(""); //clear yellow yards and scratches and combos and all TODO figure out why this breaks everything
        if (div == null || div.text.length == 0) return; //don't try to render if there's no where to render to
        for (int i = 0; i < this.session.players.length; i++) {
            Player p = this.session.players[i];
            CanvasElement last_canvas = new CanvasElement(width: 800, height: 1000);
            div.append(last_canvas);

            CanvasElement tmp_canvas = Drawing.getBufferCanvas(last_canvas.width, last_canvas.height);
            Drawing.drawCharSheet(tmp_canvas, this.session.players[i]);
            //will be null for new players.
            if (p.firstStatsCanvas != null) Drawing.copyTmpCanvasToRealCanvasAtPos(last_canvas, p.firstStatsCanvas, 0, 0);
            Drawing.copyTmpCanvasToRealCanvasAtPos(last_canvas, tmp_canvas, 400, 0);
        }
    }

    void content(Element div, i) {
        String ret = " TODO: Figure out what a non 2.0 version of the Intro scene would look like. ";
        appendHtml(div, ret);
    }

}
