import "dart:async";

import "SBURBSim.dart";


class TextEngine {
    static const String WORDLIST_PATH = "wordlists/";

    static const String DELIMITER = "#";
    static const String SEPARATOR = "|";
    static const String SECTION_SEPARATOR = "@";
    static const String FILE_SEPARATOR = ":";

    static RegExp _MAIN_PATTERN = new RegExp("$DELIMITER(.*?)$DELIMITER");

    Set<String> _loadedFiles = new Set<String>();
    Map<String, WordList> wordLists = <String, WordList>{};

    Random rand;

    TextEngine([int seed = null]) {
        this.rand = new Random(seed);
    }

    String phrase(String rootList, [String variant = null]) {
        if (rand == null) {
            rand = new Random();
        }
        Map<String,Word> savedWords;

        Word rootWord = _getWord(rootList);

        if (rootWord == null) {
            return "[$rootList]";
        }

        return _process(rootWord.get(variant), savedWords);
    }

    Future<Null> loadList(String key) async {
        if (_loadedFiles.contains(key)) { return; }

        _loadedFiles.add(key);

        WordListFile file = await Loader.getResource("$WORDLIST_PATH$key.words");
        print(file);

        wordLists.addAll(file.lists);

        for (String include in file.includes) {
            await loadList(include);
        }
    }

    Word _getWord(String list) {
        if (!wordLists.containsKey(list)) { return null; }

        WordList words = wordLists[list];

        words.processIncludes();

        return rand.pickFrom(words);
    }

    String _process(String input, Map<String,Word> savedWords) {

        input = input.replaceAllMapped(_MAIN_PATTERN, (Match match) {
            print(match.group(0));
            return match.group(0);
        });

        return input;
    }
}

class Word {
    static const String BASE_NAME = "_";
    Map<String,String> _variants;

    Word(String word, [Map<String,String> this._variants]) {
        if (_variants == null) {
            _variants = <String,String>{};
        }
        _variants[BASE_NAME] = word;
    }

    String get([String variant]) {
        if (variant == null) {
            variant = BASE_NAME;
        }
        if (_variants.containsKey(variant)) {
            return _variants[variant];
        }
        return null;
    }

    void addVariant(String key, String variant) {
        _variants[key] = variant;
    }

    @override
    String toString() => "[Word: ${get()}]";
}

class WordList extends WeightedList<Word> {
    Map<String, double> includes = <String, double>{};
    bool _processed = false;

    final String name;

    WordList(String this.name) : super();

    void gatherIncludes(WeightedList<String> list) {}
    void processIncludes() {
        if (_processed) { return; }
        _processed = true;
    }

    @override
    String toString() => "WordList '$name': ${super.toString()}";
}

class WordListFile {
    List<String> includes = <String>[];
    Map<String,WordList> lists = <String,WordList>{};

    @override
    String toString() => "[WordListFile: $lists ]";
}