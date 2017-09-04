import 'dart:html';
import 'dart:math' as Math;

import '../../scripts/GameEntities/Stats/sampler/statsampler.dart';
import "../../scripts/SBURBSim.dart";
import '../../scripts/formats/StatDataFormat.dart';

void main() {
    SBURBClassManager.init();
    Aspects.init();
    InterestManager.init();

    StatDataReview review = new StatDataReview();

    Element container = querySelector("#container");
    container.append(FileFormat.loadButtonVersioned(StatDataFormat.formatVersions, review.addData, multiple:true, caption:"Load statdata file"));
    container.append(review.createElement());
}

class StatDataReview {
    Logger logger = Logger.get("Stat Review");

    List<DataPoint> data = <DataPoint>[];
    bool dirty = false;
    Element element;
    Element readout;

    StatDataReview() {
    }

    void addData(Iterable<DataPoint> points) {
        data.addAll(points);
        this.dirty = true;
        this.updateRefreshButton();
    }

    void updateRefreshButton() {
        if (this.element == null) { return; }
        if (this.dirty) {
            this.readout.text = "Refresh needed";
        } else {
            this.readout.text = "";
        }
    }

    void update() {
        this.dirty = false;
        int maxturn = 0;
        double maxpower = 0.0;
        double minpower = 0.0;

        for (DataPoint point in data) {
            maxturn = Math.max(maxturn, point.time);
            for (double val in point.statsold.values) {
                maxpower = Math.max(maxpower, val);
                minpower = Math.min(minpower, val);
            }
            for (double val in point.stats.values) {
                maxpower = Math.max(maxpower, val);
                minpower = Math.min(minpower, val);
            }
        }

        logger.debug("Highest turn: $maxturn, Highest stat value: $maxpower, Lowest stat value: $minpower");

    }

    Element createElement() {
        Element element = new DivElement();

        Element buttoncontainer = new DivElement();

        ButtonElement button = new ButtonElement()..text="Refresh display"..onClick.listen((Event e){
            this.update();
            this.updateRefreshButton();
        });

        SpanElement readout = new SpanElement();
        this.readout = readout;

        buttoncontainer..append(button)..append(readout);

        element.append(buttoncontainer);

        this.element = element;
        return element;
    }
}