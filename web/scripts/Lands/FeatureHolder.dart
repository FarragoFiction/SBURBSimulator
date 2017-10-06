import "../includes/predicates.dart";
import "../weighted_lists.dart";
import "Feature.dart";
import "Theme.dart";

class FeatureHolder {
    FeatureTemplate featureTemplate;

    WeightedList<Theme> themes = new WeightedList<Theme>();
    WeightedList<Feature> features = new WeightedList<Feature>();

    Map<String, WeightedIterable<Feature>> featureSets = <String,WeightedIterable<Feature>>{};

    void processThemes() {
        for (Theme theme in themes) {
            for (Feature feature in theme.features.keys) {
                //double weight = theme.features[feature] *
            }
        }
    }
}

class FeatureTemplate {
    final Map<String, FeatureSubset> subsets = <String, FeatureSubset>{};

    void addFeatureSet(String name, FeatureSubset subset) {
        subsets[name] = subset;
    }
}

class FeatureSubset {
    final Predicate<Feature> filter;
    final Lambda<WeightedIterable<Feature>> adjustment;

    FeatureSubset(Predicate<Feature> this.filter, [Lambda<WeightedIterable<Feature>> this.adjustment = null]);
}