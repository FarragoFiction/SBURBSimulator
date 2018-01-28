import "dart:async";
import "dart:html";

import 'includes/predicates.dart';
import 'includes/text_search.dart';
import 'navbar.dart';

//############################################################################################
// DATA! Mmmmm data.
//############################################################################################

List<ArtCategory> categores = <ArtCategory>[
    new ArtCategory("Hair",                     "Hair Gallery", "hair",     action: drawHair),
    new ArtCategory("Horns",                    "Horn Gallery", "horns",    action: drawHorns),
    new ArtCategory("All Fanart",               "All Fanart",   "fanArt",   action: drawAllFanArt),
    new ArtCategory("First Player",             "First Player Post Great Refactoring",  "firstPlayer",      url: "images/misc/fanArt/FirstPlayer/"),
    new ArtCategory("GrimDark AB FanArt",       "GrimDark AB Gallery",                  "grimAB",           url: "images/misc/fanArt/ABFanArt/"),
    new ArtCategory("star.eyes' Memes FanArt",  "star.eyes' memes",                     "stareyes",         url: "images/misc/fanArt/star.eyes/"),
    new ArtCategory("Wranglers",              "Wranglers",                    "Wranglers",             url: "images/misc/fanArt/Wranglers/"),
    new ArtCategory("Misc FanArt",              "Miscellaneous Art",                    "misc",             url: "images/misc/fanArt/miscFanArt/"),
    new ArtCategory("Gif FanArt",               "Gif Gallery",                          "gifs",             url: "images/misc/fanArt/gifs/"),
    new ArtCategory("Octobermas FanArt",        "Octobermas!",                          "octobermas",       url: "images/misc/fanArt/OctoberMas/"),
    new ArtCategory("ShogunSim FanArt",         "ShogunSim Gallery",                    "shogunsim",        url: "images/misc/fanArt/ShogunSim/"),
    new ArtCategory("Shogun vs JR",             "Shogun vs JR: <a href = 'https://drive.google.com/drive/folders/1dUSRkaW4zZD6r21gywPvR_YHcL7gvzUn?usp=sharing'>https://drive.google.com/drive/folders/1dUSRkaW4zZD6r21gywPvR_YHcL7gvzUn?usp=sharing PUT YOUR NAME IN THE FILE NAME SO WE KNOW WHO MADE IT</a>", "mascotCompetition",    url: "images/misc/fanArt/MascotCompetition/"),
    new ArtCategory("oblivionSurfer's FanArt",  "oblivionSurfer's FanArt Gallery",      "oblivionSurfer",   url: "images/misc/fanArt/oblivionSurfer/"),
];

List<String> extensions = <String>[
    "png",
    "gif",
    "jpg",
    "jpeg",
];

//############################################################################################

RegExp filePattern = new RegExp('<a href="([^?]*?)">');
RegExp extensionPattern = new RegExp("\\\.(${extensions.join("|")})\$");
RegExp numberedFilePattern = new RegExp("([a-zA-Z_]+?)(\\d+?)\\.");
Element imageContainer = querySelector("#images");

List<Element> imageTiles = <Element>[];

class ArtCategory {
    static const String testPath = "http://farragofiction.com/SBURBSimE/";
    static const bool testMode = true;

    String name;
    String title;
    String tag;
    String url;
    Action action;

    ArtCategory(String this.name, String this.title, String this.tag, {String this.url = null, Action this.action = null});
}

void main() {
    loadNavbar();

    List<String> title = <String>[];

    for (ArtCategory cat in categores) {
        if (Uri.base.queryParameters.containsKey(cat.tag) && Uri.base.queryParameters[cat.tag].toLowerCase() == "true") {
            if (cat.action != null) {
                cat.action();
            } else {
                drawImageCategory(cat);
            }
            title.add(cat.title);
        }
    }

    setTitle(title.isEmpty ? "Select a category:" : title.join(" +<br/>"));
    
    Element links = querySelector("#links");
    for (ArtCategory cat in categores) {
        links.append(new AnchorElement(href:"?${cat.tag}=true")..setInnerHtml(cat.name));
    }

    links.append(Search.createListSearchBox(() => imageTiles, (Set<Element> s) {
        for(Element tile in imageTiles) {
            if (s.contains(tile)) {
                tile.style.display = "inline-block";
            } else {
                tile.style.display = "none";
            }
        }
    }, mapping: (Element e) => e.dataset["name"],
        emptyCaption: "Filter..."
    )..className="filter");
}

String adjustURL(String url) {
    if (ArtCategory.testMode) {
        return "${ArtCategory.testPath}$url";
    }
    return url;
}

void setTitle(String title) {
    querySelector("#header")..setInnerHtml(title);
}

void addImageToPage(Element image, String title, bool alwaysShowTitle, {String imageClass = "image", String tileClass = "imageTile"}) {
    image.className = imageClass;

    Element tile = new DivElement()
        ..className = tileClass
        ..dataset["name"] = title;

    if (image is ImageElement) {
        tile
            ..append(new AnchorElement(href:image.src)
                ..target="_blank"
                ..append(image)
            );
    } else {
        tile..append(image);
    }

    if (alwaysShowTitle) {
        tile..append(new DivElement()..className="imagename_always"..text = title);
    } else {
        tile..append(new DivElement()..className="imagename"..text = title);
    }

    imageContainer.append(tile);
    imageTiles.add(tile);
}


Future<List<String>> getDirectoryListing(String url) async {
    url = adjustURL(url);
    List<String> files = <String>[];
    String content = await HttpRequest.getString(url);
    Iterable<Match> matches = filePattern.allMatches(content); // find all link targets
    for (Match m in matches) {
        String filename = m.group(1);
        if (!extensionPattern.hasMatch(filename)) { continue; } // extension rejection

        //print(filename);

        files.add(filename);
    }

    return files;
}

Future<Null> drawImageCategory(ArtCategory category) async {
    List<String> files = await getDirectoryListing(category.url);

    for (String filename in files) {
        addImageToPage(new ImageElement(src:"${adjustURL(category.url)}$filename"), filename, false);
    }
}

void drawAllFanArt() {
    drawImageCategory(categores[4]); // grim AB
    drawImageCategory(categores[5]); // star.eyes
    drawImageCategory(categores[7]); // gifs
    drawImageCategory(categores[6]); // misc
}

int getHighestSequentialFile(List<String> files, String filename) {
    List<int> numbers = <int>[];

    for (String file in files) {
        Match m = numberedFilePattern.firstMatch(file);
        if (m == null) { continue; }

        if (m.group(1) == filename) {
            numbers.add(int.parse(m.group(2)));
        }
    }

    numbers.sort();

    int current = 0;
    int expected = 1;

    for (int n in numbers) {
        if (n == expected) {
            expected++;
            current = n;
        } else {
            break;
        }
    }

    return current;
}

Future<Null> drawHair() async {
    List<String> files = await getDirectoryListing("images/Hair/");

    int count = getHighestSequentialFile(files, "hair");

    for (int i=1; i<=count; i++) {
        addImageToPage(makeSpriteStack(<String>["images/Hair/hair_back$i.png","images/Hair/head.png","images/Hair/hair$i.png"]), i.toString(), true, imageClass: "head", tileClass: "headTile");
    }
}

Future<Null> drawHorns() async {
    List<String> files = await getDirectoryListing("images/Horns/");

    int count = getHighestSequentialFile(files, "left");

    for (int i=1; i<=count; i++) {
        addImageToPage(makeSpriteStack(<String>["images/Horns/right$i.png","images/Hair/head.png","images/Horns/left$i.png"]), i.toString(), true, imageClass: "head", tileClass: "headTile");
    }
}

Element makeSpriteStack(List<String> urls) {
    Element tile = new DivElement()..className="spriteStack";

    for (String url in urls) {
        tile..append(new ImageElement(src: adjustURL(url)));
    }

    return tile;
}



