import "dart:html";
import "../navbar.dart";

import "../SBURBSim.dart";
//junior only cares about players.
class SessionSummaryJunior {
    List<Player> players = <Player>[];
    num session_id;
    List<Ship> ships = <Ship>[];
    num averageMinLuck = 0;
    num averageAlchemySkill = 0;
    num averageMaxLuck = 0;
    num averagePower = 0;
    num averageMobility = 0;
    num averageFreeWill = 0;
    num averageHP = 0;
    num averageRelationshipValue = 0;
    num averageSanity = 0;


    SessionSummaryJunior(this.players, this.session_id) {}


    String generateHTML() {
        this.getAverages();
        String params = getParamStringMinusParam("seed");
        StringBuffer html = new StringBuffer()
            ..write("<div class = 'sessionSummary' id = 'summarizeSession${this.session_id}'>")
            ..write("<Br><b> Session</b>: ${this.session_id}<br>[ <a href = 'index2.html?seed=${this.session_id}&$params' target='_blank'>Simulate</a> | <a href='observatory.html?seed=${this.session_id}&$params' target='_blank'>Observatory</a> ]")
            ..write("<Br><b>Players</b>: ${getPlayersTitlesBasic(this.players)}")
            ..write("<Br><b>Potential God Tiers</b>: ${getPlayersTitlesBasic(this.grabPotentialGodTiers())}")
            ..write("<Br><b>Initial Average Min Luck</b>: ${this.averageMinLuck}")
            ..write("<Br><b>Initial Average Max Luck</b>: ${this.averageMaxLuck}")
            ..write("<Br><b>Initial Average Power</b>: ${this.averagePower}")
            ..write("<Br><b>Initial Average Mobility</b>: ${this.averageMobility}")
            ..write("<Br><b>Initial Average Free Will</b>: ${this.averageFreeWill}")
            ..write("<Br><b>Initial Average HP</b>: ${this.averageHP}")
            ..write("<Br><b>Initial Relationship Value</b>: ${this.averageRelationshipValue}")
            ..write("<Br><b>Initial Trigger Level</b>: ${this.averageRelationshipValue}")
            ..write("<Br><b>Sprites</b>: ${this.grabAllSprites()}")
            ..write("<Br><b>Lands</b>: ${this.grabAllLands()}")
            ..write("<Br><b>Interests</b>: ${this.grabAllInterest()}")
            ..write("<Br><b>Initial Ships</b>:<Br> ${this.initialShips()}")
            ..write("</div><br>");
        return html.toString();
    }

    void getAverages() {
        this.averageMinLuck = Stats.MIN_LUCK.average(this.players);
        this.averageMaxLuck = Stats.MAX_LUCK.average(this.players);
        this.averagePower = Stats.POWER.average(this.players);
        this.averageMobility = Stats.MOBILITY.average(this.players);
        this.averageFreeWill = Stats.FREE_WILL.average(this.players);
        this.averageAlchemySkill = Stats.ALCHEMY.average(this.players);
        this.averageHP = Stats.HEALTH.average(this.players);
        this.averageRelationshipValue = Stats.RELATIONSHIPS.average(this.players);
        this.averageSanity = Stats.SANITY.average(this.players);
    }

    List<Player> grabPotentialGodTiers() {
        List<Player> ret = <Player>[];
        for (num i = 0; i < this.players.length; i++) {
            Player player = this.players[i];
            if (player.godDestiny) ret.add(player);
        }
        return ret;
    }

    List<String> grabAllInterest() {
        List<String> ret = <String>[];
        for (num i = 0; i < this.players.length; i++) {
            Player player = this.players[i];
            ret.add(player.interest1.name);
            ret.add(player.interest2.name);
        }
        return ret;
    }

    List<String> grabAllSprites() {
        List<String> ret = <String>[];
        for (num i = 0; i < this.players.length; i++) {
            Player player = this.players[i];
            ret.add(player.object_to_prototype.htmlTitle());
        }
        return ret;
    }

    List<String> grabAllLands() {
        List<String> ret = <String>[];
        for (num i = 0; i < this.players.length; i++) {
            Player player = this.players[i];
            ret.add(player.land.name);
        }
        return ret;
    }

    String initialShips() {
        UpdateShippingGrid shipper = new UpdateShippingGrid(null);
        if (this.ships == null || this.ships.isEmpty) { //thought this was haunted but turns out ABJ is explicity allowed to pass nulls here
            shipper.createShips(this.players, null);
            this.ships = shipper.getGoodShips(null);
        }
        return shipper.printShips(this.ships);
    }

}
