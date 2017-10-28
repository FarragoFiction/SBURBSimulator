import "dart:html";
import "../SBURBSim.dart";


class FreeWillStuff extends Scene {
    //
    var decision = null;
    List<Player> availablePlayers;
    Player player = null;
    Player renderPlayer1 = null;
    Player renderPlayer2 = null;
    Player playerGodTiered = null; //luck can be good or it can be bad.
    //should something special happen if you have a lot of negative free will? like...
    //maybe exile shenanigans?


    FreeWillStuff(Session session) : super(session);

    @override
    bool trigger(List<Player> playerList) {
        this.availablePlayers = session.getReadOnlyAvailablePlayers();
        this.decision = null; //reset
        this.player = null;
        this.renderPlayer1 = null;
        this.renderPlayer2 = null;
        this.playerGodTiered = null;
        //sort players by free will. highest goes first. as soon as someone makes a decision, return. decision happens during trigger, not content. (might be a mistake)
        //way i was doing it before means that MULTIPLE decisions happen, but only one of them render.
        List<Player> players = Stats.FREE_WILL.sortedList(availablePlayers);
        for (num i = 0; i < players.length; i++) {
            Player player = players[i];
            String breakFree = this.considerBreakFreeControl(player);
            if (breakFree != null) { //somebody breaking free of mind control ALWAYS has priority (otherwise, likely will never happen since they have so little free will to begin with.)
                this.player = player;
                this.decision = breakFree;
                return true;
            }
            if (player.getStat(Stats.FREE_WILL) > 30 || player.canMindControl() != null) { //don't even get to consider a decision if you don't have  more than default free will.//TODO raise to over 60 'cause that is highest default free will possible. want free will to be rarer.
                String decision = this.getPlayerDecision(player);
                if (decision != null) {
                    this.player = player;
                    this.decision = decision;
                    return true;
                }
            }
        }
        if(this.player != null && !this.player.canHelp()) {
            player = null; //can't do freewill if you haven't played legit for at least a while.
            decision  = null;
        }

        return this.decision != null;
    }

    void renderPlayers(Element div) {
        ////session.logger.info("rendering free will player(s): " + this.session.session_id)

        String divID = (div.id) + "_freeWillBulshit${this.renderPlayer1.id}";
        String canvasHTML = "<br><canvas id='canvas" + divID + "' width='" + canvasWidth.toString() + "' height='" + canvasHeight.toString() + "'>  </canvas>";
        appendHtml(div, canvasHTML);
        CanvasElement canvas = querySelector("#canvas" + divID);

        CanvasElement pSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
        Drawing.drawSprite(pSpriteBuffer, this.renderPlayer1);

        Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer, 0, 0);
        if (this.renderPlayer2 != null) {
            CanvasElement dSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
            Drawing.drawSprite(dSpriteBuffer, this.renderPlayer2);
            Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, dSpriteBuffer, 200, 0);
        }
    }

    void renderGodTier(Element div) {
        ////session.logger.info(this.playerGodTiered.title() + " rendering free will god tier: " + this.session.session_id)
        var divID = (div.id) + "_freeWillBulshit${this.playerGodTiered.id}";
        String canvasHTML = "<br><canvas id='canvas" + divID + "' width='" + canvasWidth.toString() + "' height=" + canvasHeight.toString() + "'>  </canvas>";
        var f = this.session.fraymotifCreator.makeFraymotif(rand, [this.playerGodTiered], 3); //first god tier fraymotif
        this.playerGodTiered.fraymotifs.add(f);
        appendHtml(div, " They learn " + f.name + ". ");
        appendHtml(div, canvasHTML);
        var canvas = querySelector("#canvas" + divID);


        Drawing.drawGetTiger(canvas, [this.playerGodTiered]); //only draw revivial if it actually happened.
    }

    @override
    void renderContent(Element div) {
        String psionic = "";
        String pname = this.player.canMindControl();
        if (pname != null) {
            //session.logger.info("psychic powers used to mind control in session: " + this.session.session_id.toString());
            psionic = " The " + this.player.htmlTitleBasic() + " uses their $pname. ";
        }
        appendHtml(div, "<br><img src = 'images/sceneIcons/freewill_icon.png'> " + psionic + this.content());
        if (this.playerGodTiered != null) {
            this.renderGodTier(div);
        } else if (this.renderPlayer1 != null) {
            this.renderPlayers(div);
        }
    }

    dynamic considerDisEngagingMurderMode(Player player) {
        if (player.murderMode) {
            ////session.logger.info("disengage murde mode");
            String ret = "";
            var enemies = player.getEnemiesFromList(findLivingPlayers(this.session.players));
            var spacePlayerEnemy = findAspectPlayer(enemies, Aspects.SPACE);
            var ectobiologistEnemy = getLeader(enemies);
            //not everybody knows about ectobiology.
            if (!this.session.stats.ectoBiologyStarted && ectobiologistEnemy != null && (player.gnosis >= 2 && player.grimDark < 2)) {
                ////session.logger.info("Free will stop from killing ectobiologist: " + this.session.session_id);
                ret += "With a conscious act of will, the " + player.htmlTitle() + " settles their shit. If this keeps up, they are going to end up killing the " + ectobiologistEnemy.htmlTitle();
                ret += " and then they will NEVER do ectobiology.  No matter HOW much of an asshole they are, it's not worth dooming the timeline. ";
                player.unmakeMurderMode();
                player.setStat(Stats.SANITY, 10); //
                session.removeAvailablePlayer(player);

                return ret;
            }
            //not everybody knows why frog breeding is important.
            if (spacePlayerEnemy != null && spacePlayerEnemy.landLevel < this.session.goodFrogLevel && (player.gnosis >= 2 && player.grimDark < 2)) {
                ////session.logger.info("Free will stop from killing space player: " + this.session.session_id);
                ret += "With a conscious act of will, the " + player.htmlTitle() + " settles their shit. If this keeps up, they are going to end up killing the " + spacePlayerEnemy.htmlTitle();
                ret += " and then they will NEVER have frog breeding done. They can always kill them AFTER they've escaped to the new Universe, right? ";
                player.unmakeMurderMode();
                player.setStat(Stats.SANITY, 10); //
                session.removeAvailablePlayer(player);
                return ret;
            }
            //NOT luck. just obfuscated reasons.
            if (rand.nextDouble() > 0.5) {
                ////session.logger.info("Free will stop from killing everybody: " + this.session.session_id);
                ret += "With a conscious act of will, the " + player.htmlTitle() + " settles their shit. No matter HOW much of an asshole people are, SBURB is the true enemy, and they are not going to let themselves forget that. ";
                player.unmakeMurderMode();
                player.setStat(Stats.SANITY, 10); //
                session.removeAvailablePlayer(player);
                return ret;
            }
        }
        return null;
    }

    bool isValidTargets(List<Player> enemies, Player player) {
        Player spacePlayerEnemy = findAspectPlayer(enemies, Aspects.SPACE);
        Player ectobiologistEnemy = getLeader(enemies);
        if (spacePlayerEnemy != null && spacePlayerEnemy.landLevel < this.session.goodFrogLevel && (player.gnosis >= 2 && player.grimDark < 2)) { //grim dark players don't care if it dooms things.
            return false;
        }
        if (!this.session.stats.ectoBiologyStarted && ectobiologistEnemy != null && (player.gnosis >= 2 && player.grimDark < 2)) {
            return false;
        }

        return true;
    }

    String considerEngagingMurderMode(Player player) {
        List<Player> enemies = player.getEnemiesFromList(findLivingPlayers(this.session.players));
        if (player.isActive() && enemies.length > 2 && player.getStat(Stats.SANITY) < 0 && !player.murderMode && rand.nextDouble() > 0.98) {
            return this.becomeMurderMode(player);
        } else if (enemies.length > 0 && player.getStat(Stats.SANITY) < 0 && rand.nextDouble() > 0.98) {
            return this.forceSomeOneElseMurderMode(player);
        }
        return null;
    }

    String becomeMurderMode(Player player) {
        if (!player.murderMode) {
            List<Player> enemies = player.getEnemiesFromList(findLivingPlayers(this.session.players));
            if (this.isValidTargets(enemies, player)) {
                //session.logger.info("chosing to go into murdermode " + this.session.session_id.toString());
                player.makeMurderMode();
                player.setStat(Stats.SANITY, -10);
                session.removeAvailablePlayer(player);
                this.renderPlayer1 = player;
                //session.logger.info('deciding to be flipping shit');
                //harry potter and the methods of rationality to the rescue
                return "The " + player.htmlTitleBasic() + " has thought things through. They are not crazy. To the contrary, they feel so sane it burns like ice. It's SBURB that's crazy.  Surely anyone can see this? The only logical thing left to do is kill everyone to save them from their terrible fates. And if they happen to start with the assholes...well, baby steps. It's not every day they extinguish an entire species. ";
            }
        }
        return null;
    }

    int howManyEnemiesInCommon(List<Player> enemies, Player patsy) {
        var myEnemies = patsy.getEnemiesFromList(findLivingPlayers(this.session.players));
        int numb = 0;
        for (int i = 0; i < enemies.length; i++) {
            Player e = enemies[i];
            if (myEnemies.indexOf(e) != -1) numb ++;
        }
        return numb;
    }

    int howManyFriendsYouHate(List<Player> friends, Player patsy) {
        List<Player> myEnemies = patsy.getEnemiesFromList(findLivingPlayers(this.session.players));
        int numb = 0;
        for (int i = 0; i < friends.length; i++) {
            Player e = friends[i];
            if (myEnemies.indexOf(e) != -1) numb ++;
        }
        return numb;
    }

    Player findMurderModePlayerBesides(Player player) {
        Player ret = null;
        for (Player m in availablePlayers) {
            if (ret == null || (m.getStat(Stats.SANITY) < ret.getStat(Stats.SANITY) && !m.dead && m.murderMode)) {
                ret = m;
            }
        }
        if (!ret.murderMode) ret = null;
        if (ret == player && player.aspect != Aspects.TIME) ret = null; //you should TOTALLY be able to calm your past selves shit.
        return ret;
    }

    Player findNonGodTierBesidesMe(Player player) {
        ////session.logger.info(player.title() + " is looking for a god tier besides themselves: " + this.session.session_id)
        Relationship ret = null;
        num ret_abs_value = 0; //apparently HAS to be  a num cause both double and int crash
        if (player.aspect == Aspects.TIME && !player.godTier) return player; //god tier yourself first.
        //ideally somebody i wouldn't miss too much if they were gone, and wouldn't fear too much if they had phenomenal cosmic power. so. lowest abs value.
        for (int i = 0; i < player.relationships.length; i++) {
            Relationship r = player.relationships[i];
            num v = (r.value).abs();
            if (ret == null || (v < ret_abs_value && !r.target.dead && !r.target.godTier)) {
                ret = r;
                ret_abs_value = v;
            }
        }

        if (ret.target == player && player.aspect != Aspects.TIME) ret = null;
        return ret.target;
    }

    List<dynamic> findBestPatsy(Player player, List<Player> enemies) {
        List<dynamic> bestPatsy = null; //array with [patsy, numEnemiesInCommon]
        List<Player> living = findLivingPlayers(this.session.players);
        List<Player> friends = player.getFriendsFromList(living);
        for (num i = 0; i < living.length; i++) {
            var p = living[i];
            if (p != player || player.aspect == Aspects.TIME) { //can't be own patsy
                if (bestPatsy == null) {
                    bestPatsy = [p, this.howManyEnemiesInCommon(enemies, p)];
                } else if (!p.murderMode) { //not already in murder mode
                    int numEnemiesInCommon = this.howManyEnemiesInCommon(enemies, p);
                    int patsyHatesMyFriend = this.howManyFriendsYouHate(friends, p); //you aren't a good patsy if you are going to kill the people i care about along with my enemies.;
                    int val = numEnemiesInCommon - patsyHatesMyFriend;
                    if (val > bestPatsy[1]) {
                        bestPatsy = [p, val];
                    }
                }
            }
        }
        if (bestPatsy[0].murderMode && rand.nextDouble() > .75) bestPatsy = null; //mostly don't bother already murder mode players.
        return bestPatsy;
    }

    bool canInfluenceEnemies(Player player) {
        if (player.aspect == Aspects.BLOOD || player.aspect == Aspects.HEART || player.aspect == Aspects.MIND) {
            if (player.class_name == SBURBClassManager.MAID || player.class_name == SBURBClassManager.SEER || player.class_name == SBURBClassManager.BARD || player.class_name == SBURBClassManager.ROGUE) {
                return true;
            }
        }

        if (player.aspect == Aspects.RAGE) {
            if (player.class_name == SBURBClassManager.SEER || player.class_name == SBURBClassManager.MAID) {
                return true;
            }
        }
        return false;
    }

    bool canAlterNegativeFate(Player player) {
        if (player.aspect == Aspects.LIGHT || player.aspect == Aspects.LIFE || player.aspect == Aspects.HEART || player.aspect == Aspects.MIND) {
            if (player.class_name == SBURBClassManager.MAID || player.class_name == SBURBClassManager.SEER) {
                return true;
            }
        }

        if (player.aspect == Aspects.DOOM) {
            if (player.class_name == SBURBClassManager.BARD || player.class_name == SBURBClassManager.ROGUE || player.class_name == SBURBClassManager.MAID || player.class_name == SBURBClassManager.SEER) {
                return true;
            }
        }
        return false;
    }

    String getManipulatableTrait(Player player) {
        String ret = "";
        if (player.aspect == Aspects.HEART) ret = "identity";
        if (player.aspect == Aspects.BLOOD) ret = "relationships";
        if (player.aspect == Aspects.MIND) ret = "mind";
        if (player.aspect == Aspects.RAGE) ret = "sanity";
        if (player.aspect == Aspects.HOPE) ret = "beliefs";
        if (player.aspect == Aspects.DOOM) ret = "fear";
        if (player.aspect == Aspects.BREATH) ret = "motivation";
        if (player.aspect == Aspects.SPACE) ret = "commitment";
        if (player.aspect == Aspects.TIME) ret = "fate";
        if (player.aspect == Aspects.LIGHT) ret = "luck";
        if (player.aspect == Aspects.VOID) ret = "nothing";
        if (player.aspect == Aspects.LIFE) ret = "purpose";
        return ret;
    }

    String getInfluenceSymbol(player) {
        if (player.aspect == Aspects.MIND) return "mind_forehead.png";
        if (player.aspect == Aspects.RAGE) return "rage_forehead.png";
        if (player.aspect == Aspects.BLOOD) return "blood_forehead.png";
        if (player.aspect == Aspects.HEART) return "heart_forehead.png";
        return null;
    }

    dynamic forceSomeOneElseMurderMode(Player player) {
        List<Player> enemies = player.getEnemiesFromList(findLivingPlayers(this.session.players));
        List<dynamic> patsyArr = this.findBestPatsy(player, enemies);

        Player patsy = null;
        num patsyVal = 0;
        if (patsyArr == null) {
            patsy = null;
        } else {
            patsy = patsyArr[0];
            patsyVal = patsyArr[1];
        }

        if (this.isValidTargets(enemies, player) && patsy != null) {
            if (patsyVal > enemies.length / 2 && patsy.getStat(Stats.SANITY) < 1) {
                //session.logger.info("manipulating someone to go into murdermode " + this.session.session_id.toString() + " patsyVal = $patsyVal");
                patsy.makeMurderMode();
                patsy.setStat(Stats.SANITY, -10);
                session.removeAvailablePlayer(player);
                session.removeAvailablePlayer(patsy);
                this.renderPlayer1 = player;
                this.renderPlayer2 = patsy;
                String loop = "";
                String timeIntro = "";
                if (player == patsy) {
                    loop = "You get dizzy trying to follow the time logic that must have caused this to happen. Did they only go crazy because their future self went crazy because THEIR future self went crazy....? Or wait, is this a doomed time clone...? Fuck. Time is the shittiest aspect.";
                    ////session.logger.info(player.title() +" convincing past/future self to go murder mode " + this.session.session_id);
                } else if (player.aspect == Aspects.TIME && rand.nextDouble() > .25) { //most manipulative time bastards are from teh future
                    timeIntro = " from the future";
                }
                ////session.logger.info("forcing someone else to be flipping shit");
                return "The " + player.htmlTitleBasic() + timeIntro + " has thought things through. They are not crazy. To the contrary, they feel so sane it burns like ice. It's SBURB that's crazy.  Surely anyone can see this? The only logical thing left to do is kill everyone to save them from their terrible fates. They use clever words to convince the " + patsy.htmlTitleBasic() + " of the righteousness of their plan. They agree to carry out the bloody work. " + loop;
            } else {
                patsy = rand.pickFrom(enemies); //no longer care about "best"
                if (patsy == null) return null;
                if (this.canInfluenceEnemies(player) && patsy.getStat(Stats.FREE_WILL) < player.getStat(Stats.FREE_WILL) && patsy.influencePlayer != player) {
                    //session.logger.info(player.title() + " controling into murdermode and altering their enemies with game powers. ${this.session.session_id}");
                    patsy.makeMurderMode();
                    patsy.setStat(Stats.SANITY, -10);
                    patsy.flipOut(" about how they are being forced into MurderMode");
                    patsy.influenceSymbol = this.getInfluenceSymbol(player);
                    patsy.influencePlayer = player;
                    var rage = this.alterEnemies(patsy, enemies, player);
                    var modifiedTrait = this.getManipulatableTrait(player);
                    session.removeAvailablePlayer(player);
                    session.removeAvailablePlayer(patsy);
                    this.renderPlayer1 = player;
                    this.renderPlayer2 = patsy;
                    //session.logger.info("forcing someone else to be flipping shit");
                    return "The " + player.htmlTitleBasic() + " has thought things through. They are not crazy. To the contrary, they feel so sane it burns like ice. It's SBURB that's crazy.  Surely anyone can see this? The only logical thing left to do is kill everyone to save them from their terrible fates. They use game powers to manipulate the " + patsy.htmlTitleBasic() + "'s " + modifiedTrait + " until they are willing to carry out their plan. This is completely terrifying. " + rage;
                } else {
                    //////session.logger.info("can't manipulate someone into murdermode and can't use game powers. I am: " + player.title() + " " +this.session.session_id)
                }
            }
        }
        return null;
    }

    String alterEnemies(Player patsy, List<Player> enemies, Player player) {
        //hate you for doing this to me.
        Relationship r = patsy.getRelationshipWith(player);
        num rage = 0;
        if (patsy.getStat(Stats.FREE_WILL) > 0) rage = -3;
        if (patsy.getStat(Stats.FREE_WILL) > 50) rage = -9;
        r.value += rage;
        String ret = "";
        if (rage < -3) ret = "The " + patsy.htmlTitle() + " seems to be upset about this, underneath the control.";
        if (rage < -9) ret = "The " + patsy.htmlTitle() + " is barely under control. They seem furious. ";
        //make snapshot of state so they can maybe break free later.
        if (patsy.stateBackup == null) patsy.stateBackup = new MiniSnapShot(patsy); //but don't save state if ALREADY controlled.
        for (num i = 0; i < enemies.length; i++) {
            Player enemy = enemies[i];
            if (enemy != patsy) { //maybe i SHOULD reneable self-relationships. maybe you hate yourself? try to kill yourself?
                Relationship r1 = player.getRelationshipWith(enemies[i]);
                Relationship r2 = patsy.getRelationshipWith(enemies[i]);
                r2.saved_type = r2.badBig;
                r2.old_type = r2.saved_type; //no drama on my end.
                r2.value = r1.value;
            }
        }
        return ret;
    }

    String considerForceGodTier(Player player) {
        if (player.getStat(Stats.FREE_WILL) < 0) return null; //requires great will power to commit suicide or murder for the greater good.
        if (player.gnosis < 2) return null; //regular players will never do this
        //session.logger.info("Debugging Gnosis: I have enough gnosis to consider god tiering in session ${session.session_id}");
        if (player.isActive() && (player.getStat(Stats.SANITY) > 0 || player.murderMode)) {
            return this.becomeGod(player);
        } else if (player.getStat(Stats.SANITY) > 0 || player.murderMode) { //don't risk killing a friend unless you're already crazy or the idea of failure hasn't even occured to you.
            return this.forceSomeOneElseBecomeGod(player);
        }
        return null;
        return null;
    }

    String forceSomeOneElseBecomeGod(Player player) {
        session.logger.debug(" Debugging gnosis: trying to force someone else to be a god. in session: ${this.session.session_id}");
        var sacrifice = this.findNonGodTierBesidesMe(player);
        if (sacrifice != null && !sacrifice.dead && !sacrifice.godTier) {
            session.logger.debug("Debugging gnosis: sacrifice might work ${this.session.session_id}");

            String bed = "bed";
            String loop = "";
            String timeIntro = "";
            if (player == sacrifice) {
                loop = "You get dizzy trying to follow the time logic that must have caused this to happen. Did they try to god tier because their future self told them to? But the future self only told them to because THEIR future self told them... Or wait, is this a doomed time clone...? Fuck. Time is the shittiest aspect.";
                //session.logger.info(player.title() + " convincing past/future self to go god tier ${this.session.session_id}");
            } else if (player.aspect == Aspects.TIME && rand.nextDouble() > .25) {
                timeIntro = " from the future";
            }
            String intro = "The " + player.htmlTitleBasic() + timeIntro + " knows how the god tiering mechanic works";
            if (sacrifice.sprite.name == "sprite") { //isn't gonna happen to yourself, 'cause you have to be 'available'.
                intro += ", to the point of abusing glitches and technicalities the game itself to exploit it before the " + sacrifice.htmlTitle() + " is even in the Medium";
                //session.logger.info("HAX! I call HAX!  Godtiering before entering the game " + this.session.session_id.toString());
            }
            if (player.murderMode) {
                intro += " and they are too far gone to care about casualties if it fails";
            }

            if (sacrifice.isDreamSelf) bed = "slab";
            if (sacrifice.getStat(Stats.FREE_WILL) <= player.getStat(Stats.FREE_WILL) && player.getStat(Stats.POWER) < 200) { //can just talk them into this terrible idea.   not a good chance of working.
                if (sacrifice.godDestiny) { //if my dream self is dead and i am my real self....
                    var ret = this.godTierHappens(sacrifice);
                    session.removeAvailablePlayer(player);
                    session.removeAvailablePlayer(sacrifice);
                    //session.logger.info(player.title() + " commits murder and someone else gets tiger ");
                    return intro + ". They conjole and wheedle and bug and fuss and meddle until the " + sacrifice.htmlTitleBasic() + " agrees to go along with the plan and be killed on their " + bed + ". " + ret + " It is not a very big deal at all. " + loop; //caliborn
                } else if (sacrifice.rollForLuck() + player.rollForLuck() > 200) { //BOTH have to be lucky.
                    //session.logger.info(player.title() + " commits murder and someone else gets tiger and it is all very lucky. ");
                    var ret = this.godTierHappens(sacrifice);
                    return intro + ". They conjole and wheedle and bug and fuss and meddle until the " + sacrifice.htmlTitleBasic() + " agrees to go along with the plan and be killed on their " + bed + ". " + ret + " It is a stupidly huge deal, since the " + sacrifice.htmlTitleBasic() + " was never destined to God Tier at all. But I guess the luck of both players was enough to make things work out, in the end." + loop;
                } else {
                    session.removeAvailablePlayer(player);
                    session.removeAvailablePlayer(sacrifice);

                    player.addStat(Stats.SANITY, -1000);
                    player.flipOut(" how stupid they could have been to force the " + sacrifice.htmlTitleBasic() + " to commit suicide");
                    this.renderPlayer1 = player;
                    this.renderPlayer2 = sacrifice;
                    //session.logger.info(player.title() + " commits murder for god tier but doesn't get tiger ");
                    var ret = intro + ". They conjole and wheedle and bug and fuss and meddle until the " + sacrifice.htmlTitleBasic() + " agrees to go along with the plan and be killed on their " + bed;
                    if (!sacrifice.godDestiny) {
                        ret += sacrifice.makeDead("trying to go God Tier against destiny.");
                        ret += ". A frankly ridiculous series of events causes the " + sacrifice.htmlTitleBasic() + "'s dying body to fall off their " + bed + ". They were never destined to GodTier, and SBURB neurotically enforces such things. The " + player.htmlTitleBasic() + timeIntro + " tries desparately to get them to their " + bed + " in time, but in vain. They are massively triggered by their own astonishing amount of hubris. ";
                    }
                    return ret + loop;
                }
            } else if (player.getStat(Stats.POWER) > 200 && this.canAlterNegativeFate(player) ) { //straight up ignores godDestiny  no chance of failure.
                var ret = this.godTierHappens(sacrifice);
                session.removeAvailablePlayer(player);
                session.removeAvailablePlayer(sacrifice);
                var trait = this.getManipulatableTrait(player);
                ////session.logger.info(player.title() + " controls someone into getting tiger " + this.session.session_id);
                return "The " + player.htmlTitleBasic() + timeIntro + " knows how the god tiering mechanic works. They don't leave anything to chance and use their game powers to influence the  " + sacrifice.htmlTitleBasic() + "'s " + trait + " until they are killed on their " + bed + ". " + ret;
            }
        }
        return null;
    }

    String becomeGod(Player player) {
        //session.logger.info("Debugging Gnosis: trying to become god in session ${session.session_id}");

        if (!player.godTier) {
            //session.logger.info("Debugging Gnosis: not god tier in session ${session.session_id}");

            String intro = "The " + player.htmlTitleBasic() + " knows how the god tiering mechanic works";
            if (player.murderMode) {
                intro += " and they are too far gone to care about the consequences of failure";
            }
            if (player.godDestiny) {
                //session.logger.info("Debugging Gnosis: god destiny in session ${session.session_id}");

                session.removeAvailablePlayer(player);
                var ret = this.godTierHappens(player);
                return intro + ". They steel their will and prepare to commit a trivial act of self suicide. " + ret + " It is not a very big deal at all. "; //caliborn
                ////session.logger.info(player.title() + " commits suicide and gets tiger " + this.session.session_id);
            } else {
                if (player.rollForLuck() > 100) {
                    //session.logger.info("Debugging Gnosis: lucky in session ${session.session_id}");

                    session.removeAvailablePlayer(player);
                    var ret = this.godTierHappens(player);
                    return intro + ". They steel their will and prepare to commit a trivial act of self suicide. " + ret + " It is probably for the best that they don't know how huge a deal this is. If they hadn't caught a LUCKY BREAK, they would have died here forever. They were never destined to go God Tier, even if they commited suicide.  ";
                } else {
                    //session.logger.info("Debugging Gnosis: died god tiering ${session.session_id}");

                    player.dead = true;
                    String bed = "bed";
                    if (player.isDreamSelf) bed = "slab";
                    session.removeAvailablePlayer(player);
                    intro += player.makeDead("trying to go God Tier against destiny."); //if slab, no corpse produced.
                    this.renderPlayer1 = player;
                    ////session.logger.info(player.title() + " commits suicide but doesn't get tiger " + this.session.session_id);

                    return intro + ". They steel their will and prepare to commit a trivial act of self suicide. A frankly ridiculous series of events causes their dying body to fall off the " + bed + ". They may have known enough to exploit the God Tiering mechanic, but apparently hadn't taken into account how neurotically SBURB enforces destiny.  They are DEAD.";
                }
            }
        }
        return null;
    }

    String godTierHappens(Player player) {
        String ret = "";
        if (!player.isDreamSelf) {
            ret += "The " + player.htmlTitleBasic() + "'s body glows, and rises Skaiaward. " + "On ${player.moon}, their dream self takes over and gets a sweet new outfit to boot.  ";
            this.session.stats.questBed = true;
            ret += player.makeDead("on their quest bed");
        } else {
            ret += "The " + player.htmlTitleBasic() + " glows and ascends to the God Tiers with a sweet new outfit.";
            this.session.stats.sacrificialSlab = true;
            //player.makeDead("on their sacrificialSlab") //no corpse with slab, instead corpse BECOMES god tier.
        }
        player.makeGodTier();
        this.session.stats.choseGodTier = true;
        this.playerGodTiered = player;
        return ret;
    }

    String considerCalmMurderModePlayer(Player player) {
        Player murderer = this.findMurderModePlayerBesides(player);
        if (murderer != null && !murderer.dead && this.canInfluenceEnemies(player) && player.getStat(Stats.POWER) > 25 && player
            .getFriends()
            .length > player
            .getEnemies()
            .length) { //if I am not a violent person, and I CAN force you to calm down. I will.
            //String loop = "";

            //session.logger.info(player.title() + " controlling murderer to make them placid ${this.session.session_id}");
            session.removeAvailablePlayer(player);
            session.removeAvailablePlayer(murderer);
            if (murderer.stateBackup == null) murderer.stateBackup = new MiniSnapShot(murderer);
            murderer.nullAllRelationships();
            murderer.unmakeMurderMode();
            murderer.setStat(Stats.SANITY, 100);
            murderer.influenceSymbol = this.getInfluenceSymbol(player);
            murderer.influencePlayer = player;
            murderer
                .getRelationshipWith(player)
                .value += (player.getStat(Stats.FREE_WILL) - murderer.getStat(Stats.FREE_WILL) * 2); //might love or hate you during this.
            String trait = this.getManipulatableTrait(player);
            this.renderPlayer1 = player;
            this.renderPlayer2 = murderer;
            //session.logger.info(trait + " control calming a player: ${this.session.session_id}");
            return "The " + player.htmlTitle() + " has had enough of the " + murderer.htmlTitle() + "'s murderous ways.  They manipulate their " + trait + " until they are basically little more than an empty shell. They are such an asshole before they are finally controlled. Oh, wow. No. They are never going to be allowed to be free again. Never, never, never again. Never. Wow.  ";
        }
        return null;
    }

    dynamic considerMakeSomeoneLove(Player player) {
        return null;
    }

    String considerKillMurderModePlayer(Player player) {
        Player murderer = this.findMurderModePlayerBesides(player);
        if (murderer != null && !player.isActive() && !murderer.dead && this.isValidTargets([murderer], player) && player.getStat(Stats.POWER) > 25 && this.canInfluenceEnemies(player)) {
            return this.sendPatsyAfterMurderer(player, murderer);
        } else if (murderer != null && !murderer.dead && (player.causeOfDeath.indexOf(murderer.class_name.name) == -1)) { //you haven't killed me recently.
            ////session.logger.info(player.title() + " want to kill murdermode player and my causeOfeath is" + player.causeOfDeath +  " and session is: " + this.session.session_id)
            return this.killMurderer(player, murderer);
        }
        return null;
    }

    String killMurderer(Player player, Player murderer) {
        if (player.getStat(Stats.POWER) > murderer.getStat(Stats.POWER)) {
            if (player.getStat(Stats.POWER) * player.getPVPModifier("Attacker") > murderer.getStat(Stats.POWER) * murderer.getPVPModifier("Defender")) { //power is generic. generally scales with any aplicable stats. lets me compare two different aspect players.
                ////session.logger.info(player.title() + " choosing to kill murderer. " + this.session.session_id)
                player.victimBlood = murderer.bloodColor;
                session.removeAvailablePlayer(player);
                session.removeAvailablePlayer(murderer);

                this.renderPlayer1 = player;
                this.renderPlayer2 = murderer;
                String ret = murderer.makeDead("being put down like a rabid dog by the " + player.titleBasic());
                player.pvpKillCount ++;
                this.session.stats.murdersHappened = true;
                return ret + "The " + player.htmlTitleBasic() + " cannot let this continue any further. The " + murderer.htmlTitleBasic() + " is a threat to everyone. They corner them, and have a brief, bloody duel that ends in the death of the " + murderer.htmlTitleBasic() + ". " + getPVPQuip(murderer, player, "Defender", "Attacker") + " Everyone is a little bit safer.";
            } else {
                ////session.logger.info(player.title() + " choosing to kill murderer but instead killed. " + this.session.session_id)
                murderer.victimBlood = player.bloodColor;
                session.removeAvailablePlayer(murderer);
                session.removeAvailablePlayer(player);
                String ret = player.makeDead("fighting against the crazy " + murderer.titleBasic());
                murderer.pvpKillCount ++;
                this.session.stats.murdersHappened = true;
                this.renderPlayer1 = player;
                this.renderPlayer2 = murderer;
                return ret + "The " + player.htmlTitleBasic() + " cannot let this continue any further. The " + murderer.htmlTitleBasic() + " is a threat to everyone. They corner them, and have a brief, bloody duel that ends in the death of the " + player.htmlTitleBasic() + ".  " + getPVPQuip(player, murderer, "Attacker", "Defender") + " Everyone is a little bit less safe.";
            }
        }
        return null;
    }

    String sendPatsyAfterMurderer(Player player, Player murderer) {
        Player patsy = player.getWorstEnemyFromList(availablePlayers);
        if (patsy != null && !patsy.dead && patsy != murderer && patsy.getStat(Stats.FREE_WILL) < player.getStat(Stats.FREE_WILL)) { //they exist and I don't already control them.
            if (patsy.stateBackup == null) patsy.stateBackup = new MiniSnapShot(patsy);
            ////session.logger.info(player.title() + " controlling player to kill murderer. " + this.session.session_id)
            patsy.nullAllRelationships();
            Relationship r = patsy.getRelationshipWith(murderer);
            r.value = -100;
            r.saved_type = r.badBig;
            r.old_type = r.saved_type; //no drama on my end.
            patsy.makeMurderMode();
            session.removeAvailablePlayer(player);
            session.removeAvailablePlayer(patsy);
            patsy.setStat(Stats.SANITY, -100);
            patsy.flipOut(" how they are being forced to try to kill the ${murderer.htmlTitleBasic()}");
            patsy.influenceSymbol = this.getInfluenceSymbol(player);
            patsy.influencePlayer = player;
            patsy
                .getRelationshipWith(player)
                .value += (player.getStat(Stats.FREE_WILL) - patsy.getStat(Stats.FREE_WILL) * 2); //might love or hate you during this.
            this.renderPlayer1 = player;
            this.renderPlayer2 = patsy;
            String trait = this.getManipulatableTrait(player);
            return "The " + murderer.htmlTitle() + " needs to die. They are a threat to everyone. The " + player.htmlTitleBasic() + " manipulates the " + patsy.htmlTitleBasic() + "'s " + trait + " until they focus only on their hate for the " + murderer.htmlTitle() + " and how they need to die.";
        }
        return null;
    }

    String considerMakingEctobiologistDoJob(Player player) {
        if (!this.session.stats.ectoBiologyStarted && player.gnosis > 0 && player.grimDark < 2) {
            String timeIntro = "";
            if (player.aspect == Aspects.TIME && rand.nextDouble() > .25) {
                timeIntro = " from the future";
            }
            if (player.leader) {
                ////session.logger.info(player.title() +" did their damn job. " +this.session.session_id);
                session.removeAvailablePlayer(player);
                player.performEctobiology(this.session);
                return "The " + player.htmlTitle() + timeIntro + " is not going to play by SBURB's rules. Yes, they could wait to do Ectobiology until they are 'supposed' to. But. Just. Fuck that shit. That's how doomed timelines get made. They create baby versions of everybody. Don't worry about it.";
            } else {
                Player leader = getLeader(availablePlayers);
                if (leader != null && !leader.dead && leader.grimDark < 2) { //you are NOT gonna be able to convince a grim dark player to do their SBURB duties.
                    if (leader.getStat(Stats.FREE_WILL) < player.getStat(Stats.FREE_WILL)) {
                        session.removeAvailablePlayer(player);
                        session.removeAvailablePlayer(leader);
                        ////session.logger.info(player.title() +" convinced ectobiologist to do their damn job. " +this.session.session_id);
                        player.performEctobiology(this.session);
                        return "The " + player.htmlTitle() + timeIntro + " is not going to play by SBURB's rules. They pester the " + leader.htmlTitle() + " to do Ectobiology. That's why they're the leader. They bug and fuss and meddle and finally the " + leader.htmlTitle() + " agrees to ...just FUCKING DO IT.  Baby versions of everybody are created. Don't worry about it.";
                    } else if (player.getStat(Stats.POWER) > 50) {
                        ////session.logger.info(player.title() +" mind controlled ectobiologist to do their damn job. " +this.session.session_id);
                        player.performEctobiology(this.session);
                        session.removeAvailablePlayer(player);
                        session.removeAvailablePlayer(leader);
                        String trait = this.getManipulatableTrait(player);
                        return "The " + player.htmlTitle() + timeIntro + " is not going to play by SBURB's rules.  When bugging and fussing and meddling doesn't work, they decide to rely on game powers. They straight up manipulate the recalcitrant " + leader.htmlTitle() + "'s " + trait + " until they just FUCKING DO ectobiology.  Baby versions of everybody are created. The " + player.htmlTitle() + timeIntro + " immediatley drops the effect. It's like it never happened. Other than one major source of failure being removed from the game. ";
                    }
                }
            }
        }
        return null;
    }

    String considerMakingSpacePlayerDoJob(Player player) {
        Player space = findAspectPlayer(availablePlayers, Aspects.SPACE);
        if (space != null && space.landLevel < this.session.goodFrogLevel && player.gnosis > 0 && player.grimDark < 2) { //grim dark players don't care about sburb
            if (player == space) {
                ////session.logger.info(player.title() +" did their damn job breeding frogs. " +this.session.session_id);
                space.increaseLandLevel(10.0);
                session.removeAvailablePlayer(player);
                return "The " + player.htmlTitle() + " is not going to fall into SBURB's trap. They know why frog breeding is important, and they are going to fucking DO it. ";
            } else {
                String timeIntro = "";
                if (player.aspect == Aspects.TIME && rand.nextDouble() > .25) {
                    timeIntro = " from the future";
                }
                if (!space.dead) {
                    if (space.getStat(Stats.FREE_WILL) < player.getStat(Stats.FREE_WILL) && space.grimDark < 2) { //grim dark players just don't do their SBURB duties unless forced.
                        session.removeAvailablePlayer(player);
                        session.removeAvailablePlayer(space);
                        ////session.logger.info(player.title() +" convinced space player to do their damn job. " +this.session.session_id);
                        space.increaseLandLevel(10.0);
                        return "The " + player.htmlTitle() + timeIntro + " is not going to to fall into SBURB's trap. They pester the " + space.htmlTitle() + " to do frog breeding, even if it seems useless. They bug and fuss and meddle and finally the " + space.htmlTitle() + " agrees to ...just FUCKING DO IT.";
                    } else if (player.getStat(Stats.POWER) > 50) {
                        ////session.logger.info(player.title() +" mind controlled space player to do their damn job. " +this.session.session_id);
                        space.increaseLandLevel(10.0);
                        session.removeAvailablePlayer(player);
                        session.removeAvailablePlayer(space);
                        String trait = this.getManipulatableTrait(player);
                        return "The " + player.htmlTitle() + " is not going to to fall into SBURB's trap. When bugging and fussing and meddling doesn't work, they decide to rely on game powers. They straight up manipulate the recalcitrant " + space.htmlTitle() + "'s " + trait + " until they just FUCKING DO frog breeding for awhile. The " + player.htmlTitle() + " drops the effect before it can change something permanent. ";
                    }
                }
            }
        }
        return null;
    }

    String considerBreakFreeControl(Player player) {
        Player ip = player.influencePlayer;
        if (ip != null) {
            //////session.logger.info("I definitely am mind controlled. " + player.title() + " by " + ip.title() + " " + this.session.session_id);
            if (ip.dead) {
                session.removeAvailablePlayer(player);
                player.influencePlayer = null;
                player.influenceSymbol = null;
                player.stateBackup.restoreState(player);
                this.renderPlayer1 = player;
                ////session.logger.info("freed from control  with influencer death" +this.session.session_id);
                return "With the death of the " + ip.htmlTitleBasic() + ", the " + player.htmlTitle() + " is finally free of their control. ";
            } else if (player.dead) {
                session.removeAvailablePlayer(player);
                player.influencePlayer = null;
                player.influenceSymbol = null;
                player.stateBackup.restoreState(player);
                this.renderPlayer1 = player;
                ////session.logger.info("death freed player from control" +this.session.session_id);
                return "In death, the " + player.htmlTitle() + " is finally free of the " + ip.htmlTitle() + "'s control.";
            } else if (player.getStat(Stats.FREE_WILL) > ip.getStat(Stats.FREE_WILL)) {
                session.removeAvailablePlayer(player);
                player.influencePlayer = null;
                player.influenceSymbol = null;
                player.stateBackup.restoreState(player);
                this.renderPlayer1 = player;
                ////session.logger.info("freed from control with player will" +this.session.session_id);
                return "The " + player.htmlTitle() + " manages to wrench themselves free of the " + ip.htmlTitle() + "'s control.";
            } else {
                //////session.logger.info("The " + player.title() + "cannot break free of the " + ip.title() + "'s control. IP Dead: " + ip.dead + " ME Dead: " + player.dead + " My FW: " + player.getStat(Stats.FREE_WILL) + " IPFW:" + ip.getStat(Stats.FREE_WILL))
                return null;
            }
        }
        //////session.logger.info("returning null");
        return null;
    }

    String getPlayerDecision(Player player) {
        //reorder things to change prevelance.
        String ret = null; //breaking free of mind control doesn't happen here.
        //consider trying to force someone to love you.either through wordss (like horrus/rufioh (not that horrus knew that's what was happening) or through creepy game powers.
        if (ret == null) ret = this.considerForceGodTier(player); //fuck all ya'll this is now top fucking priority cuz that gnosis update nerfed it.
        if (ret == null) ret = this.considerCalmMurderModePlayer(player);
        if (ret == null) ret = this.considerKillMurderModePlayer(player);
        //let them decide to enter or leave grim dark, and kill or calm grim dark player
        if (ret == null) ret = this.considerDisEngagingMurderMode(player); //done
        if (ret == null) ret = this.considerMakingEctobiologistDoJob(player); //done
        if (ret == null) ret = this.considerMakingSpacePlayerDoJob(player); //done
        if (ret == null) ret = this.considerMakeSomeoneLove(player);
        if (ret == null) ret = this.considerEngagingMurderMode(player); //done

        return ret;
    }

    String content() {
        this.session.stats.hasFreeWillEvents = true;
        //String ret = "<img src = 'images/free_will_event.png'/><Br>"; //get rid of prefix soon.
        String ret = "";
        session.removeAvailablePlayer(player);
        ret += this.decision; //it already happened, it's a string. ineligible for being an important event influencable by yellow yard. (john's retcon time powers can confound a decision like this tho)

        return ret;
    }

}
