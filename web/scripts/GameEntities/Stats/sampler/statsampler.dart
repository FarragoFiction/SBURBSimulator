import 'dart:html';

import "../../../SBURBSim.dart";
import '../../../formats/StatDataFormat.dart';

class StatSampler {
    static Logger logger = Logger.get("Stat Sampler", false);
    static StatDataFormat saveFormat = new StatDataFormatV0();

    int turn = 0;

    List<DataPoint> data = <DataPoint>[];

    void sample(Session session) {
        turn++;

        for (Player player in session.players) {
            data.add(new DataPoint.player(player, turn));
        }
    }

    void resetTurns() {
        this.turn = 0;
    }

    String save() {
        return saveFormat.objectToDataURI(data);
    }

    void createSaveButton() {
        Element container = new DivElement();

        ButtonElement savebutton = new ButtonElement()..text="Save Stat Data"..onClick.listen((Event e){
            DateTime now = new DateTime.now();

            String date = "${now.year.toString().padLeft(4,"0")}${now.month.toString().padLeft(2,"0")}${now.day.toString().padLeft(2,"0")}";
            String time = "${now.hour.toString().padLeft(2,"0")}${now.minute.toString().padLeft(2,"0")}${now.second.toString().padLeft(2,"0")}";

            AnchorElement link = new AnchorElement(href:this.save())..className="loadedimg"
                ..download="snapshot${this.data.length}_v${saveFormat.version}_${date}_$time.statdata";
            container.append(link);
            link..click()..remove();
        });

        container.append(savebutton);

        document.body.append(container);
    }
}

class DataPoint {
    int time;

    SBURBClass sburbClass;
    Aspect aspect;
    InterestCategory interest1;
    InterestCategory interest2;

    Map<Stat, double> stats = <Stat, double>{};
    Map<String, double> statsold = <String, double>{};

    DataPoint.player(Player player, int this.time) {
        this.sburbClass = player.class_name;
        this.aspect = player.aspect;
        this.interest1 = player.interest1.category;
        this.interest2 = player.interest2.category;

        for (Stat stat in player.stats) {
            stats[stat] = player.getStat(stat).toDouble();
        }

        StatSampler.logger.debug("Data point for $player at time $time");
    }

    DataPoint(SBURBClass this.sburbClass, Aspect this.aspect, InterestCategory this.interest1, InterestCategory this.interest2, int this.time, {Map<Stat, double> stats, Map<String, double> statsold}) {
        if (stats != null) {
            this.stats = stats;
        }
        if (statsold != null) {
            this.statsold = statsold;
        }
    }

    double getStat(Stat stat) {
        if (stat != null) {
            return stats[stat];
        }

        double total = 0.0;
        for (double val in this.stats.values) {
            total += val;
        }
        return this.stats.isEmpty ? 0.0 : total / this.stats.length;
    }
}

