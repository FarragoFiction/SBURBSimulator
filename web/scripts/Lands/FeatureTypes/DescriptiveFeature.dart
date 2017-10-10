import "../Feature.dart";

///Feature class which represents stuff which exists in the world, rather than abstract ones like quests
abstract class DescriptiveFeature extends Feature {
    DescriptiveFeature([String simpleDesc, int quality]):super(simpleDesc, quality);
}