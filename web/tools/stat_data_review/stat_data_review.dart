import 'dart:html';
import 'dart:math' as Math;

import '../../scripts/GameEntities/Stats/sampler/statsampler.dart';
import "../../scripts/SBURBSim.dart";
import '../../scripts/formats/StatDataFormat.dart';
import '../../scripts/includes/colour_picker.dart';

Random rand = new Random();

void main() {
    SBURBClassManager.init();
    Aspects.init();
    InterestManager.init();

    StatDataReview review = new StatDataReview();

    Element container = querySelector("#load");
    container.append(FileFormat.loadButtonVersioned(StatDataFormat.formatVersions, review.addData, multiple:true, caption:"Load statdata file"));
}

Element createOption(String value) {
    return new OptionElement(data: value,value: value)..text=value;
}

class StatDataReview {
    Logger logger = Logger.get("Stat Review");

    List<DataPoint> data = <DataPoint>[];
    List<StatDataPlot> plots = <StatDataPlot>[];

    Map<String, Stat> stats = <String, Stat>{};

    StatDataReview() {
        querySelector("#add_line").onClick.listen(this.addPlot);

        SelectElement select = querySelector("#select_class");
        List<SBURBClass> classes = SBURBClassManager.all.toList()..sort((SBURBClass c1, SBURBClass c2) => c1.name.compareTo(c2.name));
        for (SBURBClass c in classes) {
            select.append(createOption(c.name));
        }

        select = querySelector("#select_aspect");
        List<Aspect> aspects = Aspects.all.toList()..sort((Aspect c1, Aspect c2) => c1.name.compareTo(c2.name));
        for (Aspect c in aspects) {
            select.append(createOption(c.name));
        }

        select = querySelector("#select_interest1");
        SelectElement select2 = querySelector("#select_interest2");
        List<InterestCategory> interests = InterestManager.allCategories.toList()..sort((InterestCategory c1, InterestCategory c2) => c1.name.compareTo(c2.name));
        for (InterestCategory interest in interests) {
            select.append(createOption(interest.name));
            select2.append(createOption(interest.name));
        }

        querySelector("#stat_average")..onClick.listen((Event e) => redraw());
    }

    void addData(Iterable<DataPoint> points, String filename) {
        data.addAll(points);

        for (DataPoint point in points) {
            for (Stat stat in point.stats.keys) {
                if (!this.stats.containsKey(stat.name)) {
                    this.stats[stat.name] = stat;
                    this.addStatSelector(stat.name);
                }
            }

            for (String oldstat in point.statsold.keys) {
                if (!this.stats.containsKey(oldstat)) {
                    this.stats[oldstat] = new Stat(oldstat, "","");
                    this.addStatSelector(oldstat);
                }

                if (!point.stats.containsKey(this.stats[oldstat])) {
                    point.stats[this.stats[oldstat]] = 0.0;
                }
                point.stats[this.stats[oldstat]] += point.statsold[oldstat];
            }
        }

        this.update();
    }

    void update() {
        for (StatDataPlot plot in plots) {
            plot.calculateBounds();
        }

        redraw();
    }

    void redraw() {
        CanvasElement canvas = querySelector("#canvas");

        CanvasRenderingContext2D ctx = canvas.context2D;
        ctx.fillStyle="#FFFFFF";
        ctx.fillRect(0, 0, canvas.width, canvas.height);

        if (this.data.isEmpty || this.plots.where((StatDataPlot p) => p.enabled).isEmpty) { return; }

        int totalpoints = 0;
        int maxturns = 0;
        double minimum = 0.0;
        double maximum = 0.0;

        String statname = (querySelector("input[type=radio][name=stat]:checked") as RadioButtonInputElement).value;
        Stat stat = statname == "*" ? null : this.stats[statname];

        for (StatDataPlot plot in plots) {
            if (!plot.enabled) { continue; }

            totalpoints += plot.filtered.length;
            maxturns = Math.max(maxturns, plot.maxturn);
            minimum = Math.min(minimum, plot.getMinimum(stat));
            maximum = Math.max(maximum, plot.getMaximum(stat));
        }

        if (totalpoints == 0) { return; }

        logger.debug("stat: $stat, total points: $totalpoints, turns: $maxturns, min: $minimum, max: $maximum");

        int margin = 25;

        int width = canvas.width - margin*2;
        int height = canvas.height - margin*2;

        double xincrement = width / (maxturns-1);

        double yrange = Math.max(maximum-minimum, 5.0);
        double yincrement = height/yrange;

        int gridsize = calculateIncrement(minimum, maximum, height);

        int posgrid = maximum <= 0 ? 0 : (maximum / gridsize).ceil() + 1;
        int neggrid = minimum >= 0 ? 0 : (minimum.abs() / gridsize).ceil() + 1;
        int rangegrid = (yrange / gridsize).ceil();

        int gridrange = Math.max(rangegrid, posgrid + neggrid);


        int yrangegrid = (gridsize * gridrange);
        double ygridinc = height / (yrangegrid);
        int zero = (gridsize * neggrid * ygridinc).round();

        logger.debug("grid increment: $gridsize");

        logger.debug("w: $width, h: $height, xinc: $xincrement, yinc: $yincrement, yrange: $yrange");

        // turn text
        ctx.textAlign="center";
        for (int i=0; i<maxturns; i++) {
            ctx.fillStyle="#E5E5E5";
            int x = (xincrement * i).round();
            ctx.fillRect(x+margin, margin, 1, height);
            ctx.fillStyle="#555555";
            ctx.fillText(getIncrementText(i+1), x+margin, height+margin + 12);
        }
        // value text
        ctx.textAlign="right";
        for (int i=0; i<=gridrange; i++) {
            ctx.fillStyle="#E5E5E5";
            int y = ((height/gridrange) * i).round();
            ctx.fillRect(margin, y+margin, width, 1);
            ctx.fillStyle="#555555";
            ctx.fillText(getIncrementText((i-neggrid) * gridsize), margin-2, height +margin - y + 5);
        }
        ctx.fillStyle="#555555";
        ctx.fillRect(margin, margin + height - (height/gridrange)*neggrid, width, 1);
        ctx.fillRect(margin, margin, 1, height);

        for (StatDataPlot plot in plots) {
            if (!plot.enabled) {continue;}
            int prev = 0;
            bool connect = false;
            for (int turn = 1; turn <= maxturns; turn++) {
                Iterable<double> points = plot.filtered.where((DataPoint p) => p.time == turn).map((DataPoint p) => p.getStat(stat));
                if (points.isEmpty) { continue; }
                connect = true;
                double val = points.reduce((double a, double b) => a+b) / points.length;

                int x = (xincrement * (turn - 1)).round() + margin;
                int y = (margin + height - zero) - (val * ygridinc).round();
                
                double fraction = (points.length / plot.maxsamples) * 0.8 + 0.2;
                
                ctx
                    ..strokeStyle = "rgba(${plot.colour.red},${plot.colour.green},${plot.colour.blue},${fraction.toStringAsPrecision(2)}"
                    ..strokeRect(x - 0.5, y - 0.5, 2, 2);

                if (turn > 1 && connect) {
                    int px = (xincrement * (turn - 2)).round() + margin;
                    ctx..beginPath()..moveTo(px+0.5, prev+0.5)..lineTo(x+0.5, y+0.5)..stroke();
                }

                //logger.debug("turn $turn, val: $val, count: ${points.length}");

                prev = y;
            }
        }
    }

    void addPlot([Event event]) {
        String select_class = (querySelector("#select_class") as SelectElement).value;
        String select_aspect = (querySelector("#select_aspect") as SelectElement).value;
        String select_interest1 = (querySelector("#select_interest1") as SelectElement).value;
        String select_interest2 = (querySelector("#select_interest2") as SelectElement).value;

        SBURBClass selected_class = select_class == "*" ? null : SBURBClassManager.stringToSBURBClass(select_class);
        Aspect selected_aspect = select_aspect == "*" ? null : Aspects.getByName(select_aspect);
        InterestCategory selected_interest1 = select_interest1 == "*" ? null : InterestManager.getByName(select_interest1);
        InterestCategory selected_interest2 = select_interest2 == "*" ? null : InterestManager.getByName(select_interest2);

        StatDataPlot plot = new StatDataPlot(this, selected_class, selected_aspect, selected_interest1, selected_interest2);
        this.plots.add(plot);
        plot.createElement();
        querySelector("#line_container").append(plot.element);

        update();
    }

    void removePlot(StatDataPlot plot) {
        this.plots.remove(plot);
        plot.element.remove();

        redraw();
    }

    void addStatSelector(String name) {
        Stat stat = this.stats[name];

        querySelector("#stats_container")
            .append(new DivElement()..className="selection_block"
                ..append(new RadioButtonInputElement()..name="stat"..value=stat.name..id="stat_${stat.name}"..onClick.listen((Event e) => redraw()))
                ..append(new LabelElement()..htmlFor="stat_${stat.name}"..text=stat.name
            )
        );
    }
}

class StatDataPlot {
    StatDataReview parent;

    bool enabled = true;

    Colour colour;
    SBURBClass sburbClass;
    Aspect aspect;
    InterestCategory interest1;
    InterestCategory interest2;

    Iterable<DataPoint> filtered;

    Element element;

    int maxturn = 0;
    int maxsamples = 0;
    Map<Stat, double> minima;
    Map<Stat, double> maxima;
    double avemin;
    double avemax;

    StatDataPlot(StatDataReview this.parent, SBURBClass this.sburbClass, Aspect this.aspect, InterestCategory this.interest1, InterestCategory this.interest2) {
        this.filtered = parent.data;

        if (this.sburbClass != null) {
            this.filtered = this.filtered.where((DataPoint p) => p.sburbClass == this.sburbClass);
        }

        if (this.aspect != null) {
            this.filtered = this.filtered.where((DataPoint p) => p.aspect == this.aspect);
        }

        if (this.interest1 != null || this.interest2 != null) {
            if (this.interest1 != null && this.interest2 != null) {
                this.filtered = this.filtered.where((DataPoint p) {
                    return (p.interest1 == this.interest1 && p.interest2 == this.interest2) || (p.interest1 == this.interest2 && p.interest2 == this.interest1);
                });
            } else if (this.interest1 != null) {
                this.filtered = this.filtered.where((DataPoint p) => p.interest1 == this.interest1 || p.interest2 == this.interest1);
            } else if (this.interest2 != null) {
                this.filtered = this.filtered.where((DataPoint p) => p.interest1 == this.interest2 || p.interest2 == this.interest2);
            }
        }

        if (this.aspect != null) {
            this.colour = new Colour.from(this.aspect.palette.shirt_light);
        } else {
            this.colour = new Colour.hsv(rand.nextDouble(), rand.nextDouble() * 0.3 + 0.7, rand.nextDouble() * 0.3 + 0.7);
        }
    }

    void createElement() {
        Element element = new DivElement()..className="selection_block";

        CheckboxInputElement check = new CheckboxInputElement();
        check..checked=true..onChange.listen((Event e){
            this.enabled = check.checked;
            parent.logger.info("Enabled: $enabled");
            parent.redraw();
        });
        element.append(check);

        InputElement colinput = new InputElement(type:"color")..value=this.colour.toStyleString();
        colinput..onChange.listen((Event e){
            this.colour = new Colour.fromStyleString(colinput.value);
            this.parent.redraw();
        });
        element.append(colinput);

        ColourPicker.create(colinput);

        element.append(new SpanElement()..text = "${this.sburbClass == null ? "[Any class]" : this.sburbClass} of ${this.aspect == null ? "[Any aspect]" : this.aspect} [${this.interest1 == null ? "Any interest" : this.interest1.name}, ${this.interest2 == null ? "Any interest" : this.interest2.name}]");

        element.append(new ButtonElement()..text="Remove"..onClick.listen((Event e){
            parent.removePlot(this);
        }));

        this.element = element;
    }

    void calculateBounds() {
        this.minima = <Stat, double>{};
        this.maxima = <Stat, double>{};
        this.avemin = 0.0;
        this.avemax = 0.0;

        for (Stat stat in parent.stats.values) {
            this.minima[stat] = 0.0;
            this.maxima[stat] = 0.0;
        }

        for (DataPoint point in this.filtered) {
            this.maxturn = Math.max(this.maxturn, point.time);
        }
        for (int turn=1; turn<=maxturn; turn++) {
            Iterable<DataPoint> thisturn = this.filtered.where((DataPoint p) => p.time == turn);

            this.maxsamples = Math.max(this.maxsamples, thisturn.length);
            
            double total = 0.0;
            for (Stat stat in parent.stats.values) {
                double stattotal = 0.0;
                for (DataPoint point in thisturn) {
                    stattotal += point.stats[stat];
                    total += point.stats[stat];
                }
                stattotal /= thisturn.length;
                this.minima[stat] = Math.min(this.minima[stat], stattotal);
                this.maxima[stat] = Math.max(this.maxima[stat], stattotal);
            }
            total /= (parent.stats.length * thisturn.length);
            avemin = Math.min(avemin, total);
            avemax = Math.max(avemax, total);
        }

        parent.logger.debug("$sburbClass of $aspect, $interest1 + $interest2: maxturn: $maxturn, minima: $minima, maxima: $maxima");
    }

    double getMinimum(Stat stat) {
        if (stat != null) {
            return this.minima[stat];
        }
        return avemin;
    }

    double getMaximum(Stat stat) {
        if (stat != null) {
            return this.maxima[stat];
        }
        return avemax;
    }
}

int calculateIncrement(double min, double max, int height) {
    int gridsize = 25;
    double range = max-min;

    List<int> steps = <int>[1,2,5];

    int power = 0;

    double one = height/range;
    while(true) {
        for (int i=0; i<steps.length; i++) {
            int stepsize = steps[i] * Math.pow(10, power);

            double inc = one * stepsize;

            if (inc >= gridsize) {
                return stepsize;
            }
        }
        power++;
    }
}

String getIncrementText(int value) {
    bool neg = value < 0;
    value = value.abs();
    List<String> affix = <String>["", "K", "M", "B", "T", "Q", "Qi", "Sx"];

    for (int i=0; i<affix.length; i++) {
        if (value < Math.pow(1000, i+1)) {
            double val = value / Math.pow(1000, i);
            String valstring = val.toStringAsFixed(1);
            if (valstring.endsWith(".0")) {
                valstring = val.floor().toString();
            }
            return "${neg?"-":""}$valstring${affix[i]}";
        }
    }
    return "!!!";
}