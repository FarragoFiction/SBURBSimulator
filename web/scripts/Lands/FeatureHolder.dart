import "../SBURBSim.dart";
import "../includes/predicates.dart";
import "Feature.dart";
import "Theme.dart";

class FeatureHolder {
    GameEntity owner;
    Session session;
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

            if (set.adjustment != null) {
                set.adjustment(this, setList, this.owner, this.session, rand);
            }
        }

        this.features.collateWeights();

        this.cullUnusedFeatures();
    }

    void reduceSubsetToRandomEntry(WeightedIterable<Feature> subset, Random rand) {
        Set<Feature> toRemove = new Set<Feature>();
        Feature picked = rand.pickFrom(subset);
        for (Feature f in subset) {
            if (f != picked) {
                toRemove.add(f);
            }
        }
        features.removeWhere(toRemove.contains);
    }

    void cullUnusedFeatures() {
        Set<Feature> used = new Set<Feature>();
        for (Iterable<Feature> subset in this.featureSets.values) {
            used.addAll(subset);
        }
        features.retainWhere(used.contains);
    }

    WeightedIterable<T> getTypedSubList<T extends Feature>(FeatureSubset subset) {
        return new SubTypeWeightedIterable<T, Feature>(this.featureSets[subset.name].pairs);
    }
}

class FeatureTemplate {
    final Map<String, FeatureSubset> subsets = <String, FeatureSubset>{};

    FeatureTemplate();
    FeatureTemplate.from(FeatureTemplate other) {
        this.subsets.addAll(other.subsets);
    }

    void addFeatureSet(FeatureSubset subset) {
        subsets[subset.name] = subset;
    }
}

typedef void FeatureAdjustment(FeatureHolder holder, WeightedIterable<Feature> features, GameEntity owner, Session session, Random rand);

class FeatureSubset {
    final String name;
    final Predicate<Feature> filter;
    final FeatureAdjustment adjustment;

    FeatureSubset(String this.name, Predicate<Feature> this.filter, [FeatureAdjustment this.adjustment = null]);
}

class FeatureTypeSubset<T extends Feature> extends FeatureSubset {
    FeatureTypeSubset(String name, [FeatureAdjustment adjustment]) : super(name, (Feature f) => f is T, adjustment);
}