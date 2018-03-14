import "dart:html";
import "../navbar.dart";

import "../SBURBSim.dart";
import "SessionSummaryLib.dart";


class MultiSessionSummaryJunior {
    //small enough i'm not gonna bother hashing it out
    num numSessions = 0;
    num numPlayers = 0;
    num numShips = 0;
    num averageMinLuck = 0;
    num averageMaxLuck = 0;
    num averagePower = 0;
    num averageMobility = 0;
    num averageFreeWill = 0;
    num averageAlchemySkill = 0;
    num averageHP = 0;
    num averageRelationshipValue = 0;
    num averageSanity = 0;


    MultiSessionSummaryJunior();

    static MultiSessionSummaryJunior collateMultipleSessionSummariesJunior(List<SessionSummaryJunior>sessionSummaryJuniors) {
        MultiSessionSummaryJunior mss = new MultiSessionSummaryJunior();
        if (sessionSummaryJuniors.isEmpty) return mss; //don't bother, and definitely don't try to average on zero things.
        mss.numSessions = sessionSummaryJuniors.length;
        for (num i = 0; i < sessionSummaryJuniors.length; i++) {
            SessionSummaryJunior ssj = sessionSummaryJuniors[i];
            mss.numPlayers += ssj.players.length;
            mss.numShips += ssj.ships.length;
            mss.averageMinLuck += ssj.averageMinLuck;
            mss.averageMaxLuck += ssj.averageMaxLuck;
            mss.averagePower += ssj.averagePower;
            mss.averageMobility += ssj.averageMobility;
            mss.averageFreeWill += ssj.averageFreeWill;
            mss.averageHP += ssj.averageHP;
            mss.averageAlchemySkill += ssj.averageAlchemySkill;
            mss.averageSanity += ssj.averageSanity;
            mss.averageRelationshipValue += ssj.averageRelationshipValue;
        }

        mss.averageMinLuck = (mss.averageMinLuck / sessionSummaryJuniors.length).round();
        mss.averageMaxLuck = (mss.averageMaxLuck / sessionSummaryJuniors.length).round();
        mss.averagePower = (mss.averagePower / sessionSummaryJuniors.length).round();
        mss.averageMobility = (mss.averageMobility / sessionSummaryJuniors.length).round();
        mss.averageFreeWill = (mss.averageFreeWill / sessionSummaryJuniors.length).round();
        mss.averageHP = (mss.averageHP / sessionSummaryJuniors.length).round();
        mss.averageAlchemySkill = (mss.averageAlchemySkill / sessionSummaryJuniors.length).round();

        mss.averageSanity = (mss.averageSanity / sessionSummaryJuniors.length).round();
        mss.averageRelationshipValue = (mss.averageRelationshipValue / sessionSummaryJuniors.length).round();
        return mss;
    }


    String generateHTML() {
        StringBuffer html = new StringBuffer()
            ..write("<div class = 'multiSessionSummary' id = 'multiSessionSummary'>")..write("<h2>Stats for All Displayed Sessions: </h2><br>")..write("<Br><b>Number of Sessions:</b> $numSessions ")..write("<Br><b>Average Players Per Session: ${this.numPlayers / this.numSessions}</b> ")..write("<Br><b>averageMinLuck:</b> $averageMinLuck")..write("<Br><b>averageMaxLuck:</b> $averageMaxLuck")..write("<Br><b>averagePower:</b>$averagePower ")..write("<Br><b>averageAlchemySkill:</b>$averageAlchemySkill ")..write("<Br><b>averageMobility:</b>$averageMobility ")..write("<Br><b>averageFreeWill: $averageFreeWill</b> ")..write("<Br><b>averageHP:</b> $averageHP")..write("<Br><b>averageRelationshipValue:</b> $averageRelationshipValue")..write("<Br><b>averageSanity:</b> $averageSanity")..write("<Br><b>Average Initial Ships Per Session:</b> ${this.numShips / this
                .numSessions} ")..write("<Br><br><b>Filter Sessions By Number of Players:</b><Br>2 <input id='num_players' type='range' min='2' max='12' value='2'> 12")..write("<br><input type='text' id='num_players_text' value='2' size='2' disabled>")
        //on click will be job of code this.appends this. cuz can't do inline anymore

            ..write("<br><br><button id = 'buttonFilter'>Filter Sessions</button>")..write("</div><Br>");
        return html.toString();
    }

}