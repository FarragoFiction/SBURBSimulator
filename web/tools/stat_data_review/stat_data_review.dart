import 'dart:html';

import '../../scripts/GameEntities/Stats/sampler/statsampler.dart';
import "../../scripts/SBURBSim.dart";
import '../../scripts/formats/StatDataFormat.dart';

void main() {
    StatDataReview review = new StatDataReview();

    querySelector("#container").append(FileFormat.loadButtonVersioned(StatDataFormat.formatVersions, review.addData, multiple:true, caption:"Load statdata file"));
}

class StatDataReview {
    List<DataPoint> data = <DataPoint>[];
    bool dirty = false;

    void addData(Iterable<DataPoint> points) {
        data.addAll(points);
        this.dirty = true;
        // do more stuff!
    }
}