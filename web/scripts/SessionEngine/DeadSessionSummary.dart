import "DeadSession.dart";
import "../SBURBSim.dart";
import "../navbar.dart";


//has less or different fields.
class DeadSessionSummary extends SessionSummary {

    DeadSessionSummary(int session_id): super(session_id);

    @override
    String generateHTML() {
        String params = getParamStringMinusParam("seed");
        String html = "<div class = 'sessionSummary' id = 'summarizeSession${this.session_id}'>";

        html = "$html<Br><b> Session</b>: <a href = 'dead_index.html?seed=${this.session_id}&$params'>${this.session_id}</a>";
        html = "$html<Br><b>Players</b>: ${getPlayersTitlesBasic(this.players)}";
        html = "$html<Br><b>mvp</b>: ${this.mvp.htmlTitle()} With a Grist Level of: ${this.mvp.grist}";
        html = "$html${generateNumHTML()}";
        html = "$html${generateBoolHTML()}";


        html = "$html</div><br>";
        return html;
    }

    //whatever i don't care if it's a constructor or not, just following oldd style
    static makeSummaryForSession(DeadSession session)

    {
        DeadSessionSummary summary = new DeadSessionSummary(session.session_id);
        summary.setMiniPlayers(session.players);

        summary.setBoolStat("badBreakDeath", session.stats.badBreakDeath);
        summary.setBoolStat("luckyGodTier", session.stats.luckyGodTier);
        summary.setBoolStat("choseGodTier", session.stats.choseGodTier);
        summary.setBoolStat("won", session.stats.won);
        summary.ghosts = session.afterLife.ghosts;
        summary.setNumStat("sizeOfAfterLife", session.afterLife.ghosts.length);
        summary.setBoolStat("heroicDeath", session.stats.heroicDeath);
        summary.setBoolStat("justDeath", session.stats.justDeath);
        summary.setBoolStat("crashedFromSessionBug", session.stats.crashedFromSessionBug);
        summary.setBoolStat("crashedFromPlayerActions", session.stats.crashedFromPlayerActions);
        summary.setBoolStat("hasFreeWillEvents", session.stats.hasFreeWillEvents);
        summary.setBoolStat("hasGhostEvents", session.stats.hasFreeWillEvents);
        summary.setNumStat("averageMinLuck", Stats.MIN_LUCK.average(session.players));
        summary.setNumStat("averageMaxLuck", Stats.MAX_LUCK.average(session.players));
        summary.setNumStat("averagePower", Stats.POWER.average(session.players));
        summary.setNumStat("averageGrist", getAverageGrist(session.players));
        summary.setNumStat("averageMobility", Stats.MOBILITY.average(session.players));
        summary.setNumStat("averageFreeWill", Stats.FREE_WILL.average(session.players));
        summary.setNumStat("averageHP", Stats.HEALTH.average(session.players));
        summary.setNumStat("averageRelationshipValue", Stats.RELATIONSHIPS.average(session.players));
        summary.setNumStat("averageSanity", Stats.SANITY.average(session.players));
        summary.session_id = session.session_id;
        summary.setBoolStat("hasLuckyEvents", session.stats.goodLuckEvent);
        summary.setBoolStat("hasUnluckyEvents", session.stats.badLuckEvent);
        summary.setBoolStat("rapBattle", session.stats.rapBattle);
        summary.setBoolStat("sickFires", session.stats.sickFires);
        summary.setBoolStat("godTier", session.stats.godTier);
        summary.setBoolStat("questBed", session.stats.questBed);
        summary.setBoolStat("sacrificialSlab", session.stats.sacrificialSlab);
        summary.setNumStat("num_scenes", session.numScenes);
        summary.players = session.players;
        summary.mvp = findMVP(session.players);
        summary.setNumStat("numLiving", findLivingPlayers(session.players).length);
        summary.setNumStat("numDead", findDeadPlayers(session.players).length);
        summary.setBoolStat("denizenBeat", session.stats.denizenBeat);
        summary.setBoolStat("plannedToExileJack", session.stats.plannedToExileJack);
        summary.setBoolStat("exiledJack", session.npcHandler.jack.exiled);
        summary.setBoolStat("exiledQueen", session.npcHandler.queen.exiled);
        summary.setBoolStat("jackGotWeapon", session.stats.jackGotWeapon);
        summary.setBoolStat("jackRampage", session.stats.jackRampage);
        summary.setBoolStat("jackScheme", session.stats.jackScheme);
        summary.setBoolStat("queenRejectRing", session.stats.queenRejectRing);
        summary.setBoolStat("murderMode", session.stats.murdersHappened);
        summary.setBoolStat("grimDark", session.stats.grimDarkPlayers);


        return summary;

    }
}

class DeadMultiSessionSummary extends MultiSessionSummary {



    @override
    void initStats()

    {
    //can switch order to change order AB displays in
    //if i don't initialize stats here, then AB won't bothe rlisting stats this.are zero.
    setStat("total", 0);
    setStat("totalDeadPlayers", 0);
    setStat("won", 0);
    setStat("crashedFromPlayerActions", 0);
    setStat("timesAllDied", 0);
    setStat("luckyGodTier", 0);
    setStat("choseGodTier", 0);
    setStat("timesAllLived", 0);
    setStat("denizenBeat", 0);
    setStat("plannedToExileJack", 0);
    setStat("exiledJack", 0);
    setStat("exiledQueen", 0);
    setStat("jackGotWeapon", 0);
    setStat("jackRampage", 0);
    setStat("jackScheme", 0);
    setStat("queenRejectRing", 0);
    setStat("democracyStarted", 0);
    setStat("murderMode", 0);
    setStat("grimDark", 0);

    setStat("godTier", 0);
    setStat("questBed", 0);
    setStat("sacrificialSlab", 0);
    setStat("justDeath", 0);
    setStat("heroicDeath", 0);
    setStat("rapBattle", 0);
    setStat("sickFires", 0);
    setStat("hasLuckyEvents", 0);
    setStat("hasUnluckyEvents", 0);
    setStat("hasFreeWillEvents", 0);
    setStat("hasGhostEvents", 0);

    setStat("crashedFromSessionBug", 0);
    setStat("averageGrist", 0);
    }


    static DeadMultiSessionSummary collateMultipleSessionSummaries(List<DeadSessionSummary> sessionSummaries) {
        print("making dead mss");
        DeadMultiSessionSummary mss = new DeadMultiSessionSummary();
        mss.setClasses();
        mss.setAspects();
        if (sessionSummaries.isEmpty) return mss; //nothing to do here.
        for (SessionSummary ss in sessionSummaries) {
            mss.incNumStat("total");
            mss.integrateAspects(ss.miniPlayers);
            mss.integrateClasses(ss.miniPlayers);

            if (ss.getBoolStat("badBreakDeath")) mss.incNumStat("badBreakDeath");

            if (ss.getBoolStat("choseGodTier")) mss.incNumStat("choseGodTier");
            if (ss.getBoolStat("luckyGodTier")) mss.incNumStat("luckyGodTier");
            if (ss.getBoolStat("crashedFromSessionBug")) mss.incNumStat("crashedFromSessionBug");

            if (ss.getBoolStat("crashedFromPlayerActions")) mss.incNumStat("crashedFromPlayerActions");
                if (ss.getNumStat("numLiving") == 0) mss.incNumStat("timesAllDied");
            if (ss.getNumStat("numDead") == 0) mss.incNumStat("timesAllLived");
            if (ss.getBoolStat("denizenBeat")) mss.incNumStat("denizenBeat");
            if (ss.getBoolStat("plannedToExileJack")) mss.incNumStat("plannedToExileJack");
            if (ss.getBoolStat("exiledJack")) mss.incNumStat("exiledJack");
            if (ss.getBoolStat("exiledQueen")) mss.incNumStat("exiledQueen");
            if (ss.getBoolStat("jackGotWeapon")) mss.incNumStat("jackGotWeapon");
            if (ss.getBoolStat("jackRampage")) mss.incNumStat("jackRampage");
            if (ss.getBoolStat("jackScheme")) mss.incNumStat("jackScheme");
            if (ss.getBoolStat("queenRejectRing")) mss.incNumStat("queenRejectRing");
            if (ss.getBoolStat("murderMode")) mss.incNumStat("murderMode");
            if (ss.getBoolStat("grimDark")) mss.incNumStat("grimDark");

            if (ss.getBoolStat("godTier")) mss.incNumStat("godTier");
            if (ss.getBoolStat("questBed")) mss.incNumStat("questBed");
            if (ss.getBoolStat("sacrificialSlab")) mss.incNumStat("sacrificialSlab");
            if (ss.getBoolStat("justDeath")) mss.incNumStat("justDeath");
            if (ss.getBoolStat("heroicDeath")) mss.incNumStat("heroicDeath");
            if (ss.getBoolStat("rapBattle")) mss.incNumStat("rapBattle");
            if (ss.getBoolStat("sickFires")) mss.incNumStat("sickFires");
            if (ss.getBoolStat("hasLuckyEvents")) mss.incNumStat("hasLuckyEvents");
            if (ss.getBoolStat("hasUnluckyEvents")) mss.incNumStat("hasUnluckyEvents");
            if (ss.getBoolStat("hasFreeWillEvents")) mss.incNumStat("hasFreeWillEvents");
            if (ss.getBoolStat("hasGhostEvents")) mss.incNumStat("hasGhostEvents");

            if (ss.scratched) mss.incNumStat("scratched");

            if (ss.getBoolStat("won")) mss.incNumStat("won");

            mss.addNumStat("sizeOfAfterLife", ss.getNumStat("sizeOfAfterLife"));
            mss.ghosts.addAll(ss.ghosts);
            mss.addNumStat("sizeOfAfterLife", ss.getNumStat("sizeOfAfterLife"));
            mss.addNumStat("averageMinLuck", ss.getNumStat("averageMinLuck"));
            mss.addNumStat("averageGrist", ss.getNumStat("averageGrist"));
            mss.addNumStat("averageMaxLuck", ss.getNumStat("averageMaxLuck"));
            mss.addNumStat("averagePower", ss.getNumStat("averagePower"));
            mss.addNumStat("averageMobility", ss.getNumStat("averageMobility"));
            mss.addNumStat("averageFreeWill", ss.getNumStat("averageFreeWill"));
            mss.addNumStat("averageHP", ss.getNumStat("averageHP"));
            mss.addNumStat("averageSanity", ss.getNumStat("averageSanity"));
            mss.addNumStat("averageRelationshipValue", ss.getNumStat("averageRelationshipValue"));
            mss.addNumStat("averageNumScenes", ss.getNumStat("num_scenes"));

            mss.addNumStat("totalDeadPlayers", ss.getNumStat("numDead"));
            mss.addNumStat("totalLivingPlayers", ss.getNumStat("numLiving"));
        }
        mss.setStat("averageAfterLifeSize", (mss.getNumStat("sizeOfAfterLife") / sessionSummaries.length).round());
        mss.setStat("averageMinLuck", (mss.getNumStat("averageMinLuck") / sessionSummaries.length).round());
        mss.setStat("averageMaxLuck", (mss.getNumStat("averageMaxLuck") / sessionSummaries.length).round());
        mss.setStat("averagePower", (mss.getNumStat("averagePower") / sessionSummaries.length).round());
        mss.setStat("averageMobility", (mss.getNumStat("averageMobility") / sessionSummaries.length).round());
        mss.setStat("averageFreeWill", (mss.getNumStat("averageFreeWill") / sessionSummaries.length).round());
        mss.setStat("averageHP", (mss.getNumStat("averageHP") / sessionSummaries.length).round());
        mss.setStat("averageGrist", (mss.getNumStat("averageGrist") / sessionSummaries.length).round());
        mss.setStat("averageSanity", (mss.getNumStat("averageSanity") / sessionSummaries.length).round());
        mss.setStat("averageRelationshipValue", (mss.getNumStat("averageRelationshipValue") / sessionSummaries.length).round());
        mss.setStat("averageNumScenes", (mss.getNumStat("averageNumScenes") / sessionSummaries.length).round());
        mss.setStat("survivalRate", (100 * (mss.getNumStat("totalLivingPlayers") / (mss.getNumStat("totalLivingPlayers") + mss.getNumStat("totalDeadPlayers")))).round());
        print("after creation $mss is: ${mss.num_stats}");
        return mss;
    }

}