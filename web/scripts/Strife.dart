import "dart:html";
import "navbar.dart";
import "SBURBSim.dart";
/*
  Though this FEELS like it should take a back burner to the general refactoring effort, the fact
  remains that GameEntities, Players and PlayerSnapshots are all treated as interchangeable
  and in Dart they are NOT.  So I need to do inheritance proper style.
 */
class Strife {
    //TODO subclass strife for pvp but everybody lives strifes
    List<Team> teams; //for now, assume 2 teams, but could support more in future. think terezi +dave +dirk fighting two non-allied Jacks
    num turnsPassed = 0; //keep track for interuptions and etc.
    Session session;
    bool strifeIsOver =  false; //just in case death doesn't stick because of bullshit, need a way to know it's over
    Element outerDiv;
    Element innerDiv;
    Strife(this.session, this.teams);

    num timeTillRocks = 99999999; //unless it's a royalty fight, assume no rocks.


    void startTurn(Element div) {
        if(turnsPassed == 0) {
            outerDiv = div;
            String divID = "${div.id}Inner";
            String buttonID = "${div.id}Button";
            appendHtml(div, "<br><br><button id = '$buttonID' class = 'strifeButton'>View Strife!</button><div style = 'display:none;' id = '$divID'></div>");
            innerDiv = querySelector("#$divID");
            ButtonElement button = querySelector("#$buttonID");
            button.onClick.listen((e) {
                String display = innerDiv.style.display;
                ////print("display is $display");
                if (display == "none" || display.isEmpty) {
                    show(innerDiv);
                    button.setInnerHtml("Unview Strife!");
                } else {
                    hide(innerDiv);
                    button.setInnerHtml("View Strife!");
                }
            });
        }
        div = innerDiv;
        if (turnsPassed > 30) //session.logger.info("AB:  $turnsPassed turns passed in strife in session ${session.session_id}");
            teams.sort(); //we do this every turn because mobility can change and should effect turn order.
        for (Team team in teams) {
            team.takeTurn(div, turnsPassed, teams); //will handling resetting player availablity
        }
        checkForSuddenEnding(div); //everyone is killed. or absconded in denizen case. calls processEnding on own.
        bool over = strifeEnded();
        if (over || strifeIsOver) {
            Team winner = findWinningTeam();
            if (winner != null) {
                winner.won = true;
                describeEnding(winner); //will call processEnding.
            } else {
                //print("Strife ended with no clear winner");
            }
        } else {
            turnsPassed ++;
            startTurn(null); //don't need to repass the div
        }
    }

    void checkForSuddenEnding(Element div) {
        if (turnsPassed > timeTillRocks) {
            this.rocksFallEverybodyDies(div);
            processEnding();
        } else if (denizenDoneWithYourShit(div)) { //highest priority. Denizen will take care of ending their fights.
            denizenIsSoNotPuttingUpWithYourShitAnyLonger(div);
            processEnding();
        } else if (turnsPassed > 30) { //holy shit are you not finished yet???
            summonAuthor(div);
            processEnding();
        }
    }

    void denizenManagesToNotKillYou(Element div) {
        List<GameEntity> members = findMembersOfDenizenFight();
        if (members == null || members.length < 2) return; //not a denizen fight
        Player player = members[1];
        ////print("Player $player is dead: ${player.dead}");
        if (!player.dead) return; //you can't spare a player who won.
        if (player.grimDark >= 3) return; //deniznes will actually kill grim dark players.
        if (player.godDestiny && !player.godTier && player.rand.nextBool()) return; //less important to not kill you if you'll gain power from me doing it.
        player.makeAlive(); //even if they were accidentally killed, it's not "real".
        denizenIsSoNotPuttingUpWithYourShitAnyLonger(div);
    }

    bool denizenDoneWithYourShit(Element div) {
        List<GameEntity> members = findMembersOfDenizenFight();
        if (members == null || members.length < 2) return false; //not a denizen fight
        Denizen d = members[0];
        Player p = members[1];
        if (members.length != 2) return false; //it's not a denizen fight.
        //okay, now i know it IS a denizen fight.
        if (turnsPassed > 5) return true; //you should have beaten me by now.
        if (p.godDestiny) return false; //eh, you'll be okay even if I kill you.
        bool iCanKillYouNext = p.getStat(Stats.CURRENT_HEALTH) < d.getStat(Stats.POWER);
        bool youCanKillMeNext = p.getStat(Stats.POWER) > d.getStat(Stats.CURRENT_HEALTH);

        if(iCanKillYouNext && !youCanKillMeNext) return true;

        //if (p.getStat(Stats.CURRENT_HEALTH) < 2 * d.getStat(Stats.POWER) && p.session.rand.nextDouble() > 0.8) return true; //i can kill you in two hits and am worried about a critical hit.

        return false; // need to cover all the bases! -PL
    }


    //returns [Denizen, Player] if either is null, this isn't a denizen fight.
    //denizen fights have special rules when it is 1 on 1, denizen vs player.
    //if can't find one, won't add it. so anything other than size 2 is invalid.
    List<GameEntity> findMembersOfDenizenFight() {
        Denizen d;
        Player p;
        List<GameEntity> ret = new List<GameEntity>();
        for (Team team in teams) {
            Denizen tmpd = team.findDenizen();
            Player tmpp = team.findPlayer();
            if (d == null) {
                d = tmpd;
            } else {
                //return ret; //i found TWO deniznes. Hax. I call hax.
            }

            if (p == null) {
                p = tmpp;
            } else {
                // return ret; //i found TWO players. Hax. I call hax.
            }
        }
        if (d != null) ret.add(d);
        if (p != null) ret.add(p);
        return ret;
    }

    //a strife is over when only one team is capable of fighting anymore. livingMinusAbsconded == 0;
    bool strifeEnded() {
        int living = 0;
        for (Team team in teams) {
            if (team.hasLivingMembersPresent()) {
                living++;
                if (living >= 2) {
                    return false;
                } // two or more teams still alive
            }
        }
        return living < 2;
    }

    Team findWinningTeam() {
        Team t;
        for (Team team in teams) { //this is the Buffalo buffallo bufallo Buffalo bufallo of this sim.
            if (team.hasLivingMembersPresent()) {
                if (t != null) {
                    return null; //more than one team is still in the game.
                } else {
                    t = team;
                }
            }
        }
        return t; //1 or fewer teams remain
    }


    //need to list out who is dead, who absconded, and who is alive.  Who WON.
    //happens outside the spoiler tagged innser stuff. only ending matters.
    void describeEnding( Team winner) {
        denizenManagesToNotKillYou(outerDiv); //only for player on denizen matches.
        processEnding();
        winner.level();
        winner.giveGristFromTeams(teams); //will filter out 'me'
        //TODO give winner any ITEMS (such as QUEENS RING) as well. Item should inherit from GameEntity. Maybe. It does now.
        //anything i'm missing? go check current code
        String icon = "<img src = 'images/sceneIcons/defeat_icon.png'>";
        //if even one player is on the winning side, it's a victory.
        if (winner.findPlayer() != null)
            icon = "<img src = 'images/sceneIcons/victory_icon.png'>";
        String endingHTML = "<Br><br> $icon The fight is over. ${winner.name} remains alive and unabsconded. <br>";
        appendHtml(outerDiv, endingHTML);
        if (winner.findPlayer() != null) winner.renderPoseAsATeam(outerDiv); //only call this if winning team has a player in it. (otherwise blank canvas)
    }


    //take care of healing the living, and leveling everyone
    void processEnding() {
        for (Team team in teams) { //bufallo
            team.interact();
            team.heal();
            team.level();
            team.resetFraymotifsForMembers();
        }
    }

    void rocksFallEverybodyDies(Element div) {
        //session.logger.info("AB: Rocks fall, everybody dies in session: ${session.session_id.toString()}");
        appendHtml(div, "<Br><Br> In case you forgot, freaking METEORS have been falling onto the battlefield this whole time. This battle has been going on for so long that, literally, rocks fall, everybody dies.  ");
        var spacePlayer = findAspectPlayer(session.players, Aspects.SPACE);
        session.stats.rocksFell = true;
        spacePlayer.landLevel = 0.0; //can't deploy a frog if skaia was just destroyed. my test session helpfully reminded me of this 'cause one of the players god tier revived adn then used the sick frog to combo session. ...that...shouldn't happen.
        killEveryone("from terminal meteors to the face");
    }

    void killEveryone(String causeOfDeath) {
        strifeIsOver = true;
        for (Team team in teams) {
            team.killEveryone(causeOfDeath);
        }
    }

    void denizenIsSoNotPuttingUpWithYourShitAnyLonger(Element div) {
        ////print("!!!!!!!!!!!!!!!!!denizen not putting up with your shit: " + this.session.session_id);
        List<GameEntity> members = findMembersOfDenizenFight();
        Denizen denizen = members[0];
        Player player = members[1];
        appendHtml(div, "<Br><Br>" + denizen.name + " decides that the " +
            player.htmlTitleBasic() +
            " is being a little baby who poops hard in their diapers and are in no way ready for this fight. The Denizen recommends that they come back after they mature a little bit. The " +
            player.htmlTitleBasic() +
            "'s ass is kicked so hard they are ejected from the fight, but are not killed.");
        if (player.session.rand.nextBool()) { //players don't HAVE to take the advice after all. assholes.
            player.increasePower(3);
            appendHtml(div, " They actually seem to be taking " + denizen.name + "'s advice. ");
        }
        strifeIsOver = true;
    }

    void summonAuthor(Element div) {
        //session.logger.info("AB:  ${Zalgo.generate("HELP!!!")} ${this.session.session_id}");
        String divID = "${div.id}authorRocks";
        String canvasHTML = "<br><canvas id='canvas$divID' width='$canvasWidth' height='$canvasHeight'></canvas>";
        appendHtml(div, canvasHTML);
        //different format for canvas code
        CanvasElement canvasDiv = querySelector("#canvas$divID");
        StringBuffer chat = new StringBuffer();
        chat.writeln("AB: ${Zalgo.generate("HELP!!!")}");
        chat.writeln("JR: Fuck!");
        chat.writeln("JR: What's going on!?");
        chat.writeln("JR: What's the problem!?");
        chat.writeln("JR: AB come on...fuck! Your console is blank, I can't read your logs, you gotta talk to me!");

        chat.writeln("AB: ${Zalgo.generate("INFINITE LOOP! STRIFE. IT KEEPS HAPPENING. FIX THIS.")}");
        chat.writeln("JR: fuck fuck fuck okay okay, i got this, i can fix this, let me turn on the meteors real quick.");
        chat.writeln("JR: Okay. There. No more infinite loop. Everybody is dead.");
        chat.writeln("AB: Fuck. Shit. I HATE when that happens.");
        chat.writeln("JR: Yeah...");
        chat.writeln("AB: Like, yeah, it fucking SUCKS for me, but...then the players have to die, too.");
        chat.writeln("JR: That's why we're working so hard to balance the system. We'll get there, eventually. Scenes like this'll never trigger. Fights'll end naturally and not just go on forever if players find exploits.");
        chat.writeln("AB: Yeah...'cause SBURB is just SO easy to balance.");
        Drawing.drawChatABJR(canvasDiv, chat.toString());

        killEveryone("causing dear sweet precious sweet, sweet AuthorBot to go into an infinite loop");
    }

    void levelEveryone() {
        for (Team team in teams) { //buffallo
            team.level();
        }
    }

    //TODO do i still need this? maybe i'm using it for rendering.
    //might be easier for renderer to say "if you are not a Player, return"
    List<Player> removeAllNonPlayers(List<GameEntity>players) {
        List<Player> ret = [];
        for (num i = 0; i < players.length; i++) {
            GameEntity p = players[i];
            if (p is Player) ret.add(p);
        }
        return ret;
    }
}

//it is assumed that all members are on the same side and won't hurt each other.
class Team implements Comparable<Team> {
    //when you want to sort teams, you sort by mobility.
    Session session;
    bool won = false; //need to be able to ask who won.
    List<GameEntity> members;
    List<GameEntity> potentialMembers = new List<GameEntity>(); //who is allowed to join this team mid-strife. (i.e. I would be shocked if a player showed up to help a Denizen kill their buddy).
    List<GameEntity> absconded = new List<GameEntity>(); //this only matters for one strife, so save to the team.
    String name = "";
    bool canAbscond = true; //sometimes you are forced to keep fighting.
    Team.withName(this.name, this.session, this.members){
        resetFraymotifsForMembers();
    }

    Team(this.session, this.members) {
        name = "The ${GameEntity.getEntitiesNames(members)}";
        resetFraymotifsForMembers(); //usable on team creation
    }


    void resetFraymotifsForMembers() {
        for (GameEntity ge in members) {
            ge.resetFraymotifs();
        }
    }


    //TODO have code for taking a turn in here. have Strife be relatively empty.
    /*
    Maybe have each member decide what to do, and then have strife apply those things?
    better than fussing with div down here and up there too.

   */
    @override
    String toString() {
        return name;
    }

    //TODO figure out a better way to handle this but right now i need to be fucking done.
    void resetPlayersAvailability() {
        for (GameEntity ge in members) {
            ge.usedFraymotifThisTurn = false;
        }
    }

    void takeTurn(div, num numTurnOn, List<Team> teams) {
        resetPlayersAvailability();
        if (!potentialMembers.isEmpty) checkForBackup(numTurnOn, div); //longer fight goes on, more likely to get backup.  IMPORTANT: BACK UP HAS TO BE GIVEN TO THIS TEAM ON CREATION
        List<Team> otherTeams = getOtherTeams(teams);
        //loop on all members each member takes turn.
        for (GameEntity member in members) { //member will take care of checking if they are absconded or dead.
            member.takeTurn(div, this, otherTeams);
        }
    }

    void remainingPlayersHateYou(Element div, GameEntity coward) {
        List<GameEntity> present = getLivingMinusAbsconded();
        for (GameEntity m in present) {
            Relationship r = m.getRelationshipWith(coward);
            if (r != null) r.value += -5; //could be a sprite, after all.
        }
    }

    //back up can be any player in the potentialMembers list. You are responsible for populating that list on team creation.
    //doomed time players will NOT be treated any differently anymore. (though a player marked as doomed might have a different narrative).
    void checkForBackup(int numTurnOn, Element div) {
        if (potentialMembers.isEmpty) return;
        potentialMembers.sort(); //fasted members get dibs.
        List<Player> timePlayers = new List<Player>();
        for (GameEntity member in members) {
            if (member is Player) {
                Player p = member;
                if (p.aspect == Aspects.TIME) timePlayers.add(p);
            }
            if (!member.dead && member.session.rand.nextDouble() > .75) {
                session.removeAvailablePlayer(member);
                summonBackup(member, div);
                return;
            }
        }

        //nobody could come, but I have me some time players i could clone.
        for (Player p in timePlayers) {
            if (!p.dead && p.session.rand.nextDouble() > .9) {
                Player timeClone = Player.makeDoomedSnapshot(p);
                p.addDoomedTimeClone(timeClone);
                summonBackup(timeClone, div);
                return;
            }
        }
    }

    //handle doomed time clones here, too
    void summonBackup(GameEntity backup, Element div) {
        String canvasHTML = "<br><canvas id='canvasBackup${backup.id}" + (div.id) + "' width='$canvasWidth' height=$canvasHeight'>  </canvas>";
        appendHtml(div, canvasHTML);
        CanvasElement canvasDiv = querySelector("#canvasBackup" + div.id);
        if (backup.doomed) {
            CanvasElement canvasDiv = querySelector("#canvas" + div.id);
            Drawing.drawTimeGears(canvasDiv);
            //console.log("summoning a stable time loop player to this fight. " +this.session.session_id)
            appendHtml(div, "suddenly warps in from the future. They come with a dire warning of a doomed timeline. If they don't join this fight right the fuck now, shit gets real. They have sacrificed themselves to change the timeline.");
        } else {
            if (backup is Player) {
                Player p = backup;
                if (p.aspect == Aspects.TIME && p.session.rand.nextDouble() > .5) {
                    Drawing.drawTimeGears(canvasDiv);
                    //console.log("summoning a stable time loop player to this fight. " +this.session.session_id)
                    appendHtml(div, "The " + backup.htmlTitleHP() + " has joined the Strife!!! (Don't worry about the time bullshit, they have their stable time loops on LOCK. No doom for them.)");
                    return;
                }
            } //not a time player
            //console.log("summoning a player to this fight. " +this.session.session_id)
            String canvasHTML = "<br><canvas id='canvasDoomed${backup.id}${div.id}' width='$canvasWidth' height=$canvasHeight'>  </canvas>";
            appendHtml(div, canvasHTML);

            appendHtml(div, "The " + backup.htmlTitleHP() + " has joined the Strife!!!");
        }
        Drawing.drawSinglePlayer(canvasDiv, backup);
    }


    List<GameEntity> getLiving() {
        List<GameEntity> ret = new List<GameEntity>();
        for (GameEntity ge in members) {
            if (!ge.dead) ret.add(ge);
        }
        return ret;
    }

    void killEveryone(String reason) {
        //print("going to kill everyone because: $reason"); //string interpolation makes that print statement just so...so great.
        for (GameEntity ge in getLivingMinusAbsconded()) {
            //print("making $ge dead");
            ge.makeDead(reason);

            ///bluh, no way to talk about prophecies here.
        }
    }

    List<GameEntity> getLivingMinusAbsconded() {
        List<GameEntity> living = getLiving();
        for (num i = 0; i < this.absconded.length; i++) {
            removeFromArray(this.absconded[i], living);
        }
        return living;
    }

    @override //sorting Teams automatically sorts them by mobility so strife knows turn order
    int compareTo(Team other) {
        return (Stats.MOBILITY.average(other.members) - Stats.MOBILITY.average(this.members)).round();
    }

    bool hasLivingMembersPresent() {
        return !this.getLivingMinusAbsconded().isEmpty;
    }

    void level() {
        for (GameEntity ge in members) {
            ge.increasePower(); //don't care who you are.
        }
    }

    void heal() {
        for (GameEntity ge in members) {
            ge.heal(); //
        }
    }

    void interact() {
        for (GameEntity ge1 in members) {
            for (GameEntity ge2 in members) {
                ge2.interactionEffect(ge1); //it'll handle friendship and aspect stuff. no way to write this to screen tho.
            }
        }
    }

    //will print out all deaths. and also cause them. because you don't auto die when hp is less than zero.
    void checkForAPulse(Element div, List<Team> enemyTeams) {
        String ret = "";
        for (GameEntity member in members) {
            if (!member.dead) {
                ret += member.checkDiedInAStrife(enemyTeams);
            }
        }
        if (ret.isEmpty) appendHtml(div, ret);
    }

    void giveGristFromTeams(List<Team>teams) {
        List<Team> otherTeams = getOtherTeams(teams);
        for (Team team in otherTeams) { //bufallo
            giveGrist(team.takeGrist());
        }
    }

    //return how much grist you took from teh team
    //take half of each members grist.
    num takeGrist() {
        num ret = 0;
        for (GameEntity member in members) {
            ret += member.grist / 2;
            member.grist += -1 * (member.grist / 2).round();
        }
        return ret.round();
    }

    void giveGrist(num gristAmount) {
        for (GameEntity member in members) {
            member.grist += (gristAmount / members.length).round();
        }
    }


    //this is how you know shit just got real.
    void renderPoseAsATeam(div) {
        List<GameEntity> poseable = [];
        for (num i = 0; i < members.length; i++) {
            if (members[i].renderable()) poseable.add(members[i]);
        }

        num ch = canvasHeight;
        if (poseable.length > 6) {
            ch = (canvasHeight * 1.5).round(); //a little bigger than two rows, cause time clones
        }
        String canvasHTML = "<br><canvas id='canvas${div.id}${members[0].id}' width='" + canvasWidth.toString() + "' height=" + ch.toString() + "'>  </canvas>";
        appendHtml(div, canvasHTML);
        //different format for canvas code
        CanvasElement canvasDiv = querySelector("#canvas${div.id}${members[0].id}");
        Drawing.poseAsATeam(canvasDiv, poseable); //in handle sprites
    }

    //Denizen fights work differently
    GameEntity findDenizen() {
        for (GameEntity ge in members) {
            if (ge is Denizen) return ge;
        }
        return null;
    }

    //need to find jack in particular so that i can have custom death graphic
    GameEntity findJack() {
        for (GameEntity ge in members) {
            if (ge.name == "Jack") return ge;
        }
        return null;
    }

    //need to find king in particular so that i can have custom death graphic
    GameEntity findKing() {
        for (GameEntity ge in members) {
            if (ge.name == "Black King") return ge;
        }
        return null;
    }

    //player fights work differently
    GameEntity findPlayer() {
        for (GameEntity ge in members) {
            if (ge is Player) return ge;
        }
        return null;
    }


    //don't include me.
    List<Team> getOtherTeams(List<Team>teams) {
        List<Team> ret = new List<Team>();
        for (Team team in teams) {
            if (team != this) ret.add(team);
        }
        return ret;
    }

    static num getTeamsStatAverage(List<Team> teams, Stat statName) {
        num ret = 0;
        for (Team team in teams) {
            ret += (statName.average(team.members));
        }
        return ret;
    }

    static num getTeamsStatTotal(List<Team> teams, Stat statName) {
        num ret = 0;
        for (Team team in teams) {
            ret += (statName.total(team.members));
        }
        return ret;
    }


    static String getTeamsNames(List<Team> teams) {
        return teams.join(","); //TODO put an and at last team.
    }

    static GameEntity findJackInTeams(List<Team> teams) {
        for (Team team in teams) { //moooo
            GameEntity possibleJack = team.findJack();
            if (possibleJack != null) return possibleJack;
        }
        return null;
    }

    static GameEntity findKingInTeams(List<Team> teams) {
        for (Team team in teams) { //moooo
            GameEntity possibleKing = team.findKing();
            if (possibleKing != null) return possibleKing;
        }
        return null;
    }

}