import "../includes/predicates.dart";
import "../random.dart";
import "../weighted_lists.dart";
import "Feature.dart";
import "Theme.dart";

class FeatureHolder {
    FeatureTemplate featureTemplate;

    WeightedList<Theme> themes = new WeightedList<Theme>();
    WeightedList<Feature> features = new WeightedList<Feature>();

    Map<String, WeightedIterable<Feature>> featureSets = <String,WeightedIterable<Feature>>{};

    void setThemes(Map<Theme, double> mapping) {
        this.themes = new WeightedList<Theme>.fromMap(mapping);
    }

    void processThemes(Random rand) {
        Theme theme;
        for (WeightPair<Theme> themePair in themes.pairs) {
            theme = themePair.item;
            for (Feature feature in theme.features.keys) {
                double weight = theme.features[feature] * themePair.weight;

                this.features.add(feature, weight);
            }
        }

        this.features.collateWeights();

        if (featureTemplate == null) { return; }

        FeatureSubset set;
        for (String featureType in featureTemplate.subsets.keys) {
            set = featureTemplate.subsets[featureType];

            WeightedIterable<Feature> setList = features.where(set.filter);
            this.featureSets[featureType] = setList;

            set.adjustment(setList, rand);
        }

        this.features.collateWeights();
    }
}

class FeatureTemplate {
    final Map<String, FeatureSubset> subsets = <String, FeatureSubset>{};

    void addFeatureSet(String name, FeatureSubset subset) {
        subsets[name] = subset;
    }
}

typedef void FeatureAdjustment(WeightedIterable<Feature> features, Random rand);

class FeatureSubset {
    final Predicate<Feature> filter;
    final FeatureAdjustment adjustment;

    FeatureSubset(Predicate<Feature> this.filter, [FeatureAdjustment this.adjustment = null]);
}

class FeatureTypeSubset<T extends Feature> extends FeatureSubset {
    FeatureTypeSubset([FeatureAdjustment adjustment]) : super((Feature f) => f is T, adjustment);
}