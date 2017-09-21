class Feature {
    static double WAY_HIGH = 1300.0;
    static double HIGH = 3.0;
    static double MEDIUM = 2.0;
    static double LOW = 1.0;
    static double WAY_LOW = 0.1;
    static int GOOD = 1;
    static int NEUTRAL = 0;
    static int BAD = -1;
    int quality = 0;
    String simpleDesc = "";

    Feature([this.simpleDesc, this.quality]);

    bool goodFeature() {
        return quality >0;
    }

    bool badFeature() {
        return quality < 0;
    }

    bool neutralFeature() {
        return quality == 0;
    }

}