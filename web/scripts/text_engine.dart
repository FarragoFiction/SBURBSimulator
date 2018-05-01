import "dart:async";

import "SBURBSim.dart";

/*
    TODO:
    - list processing
    - handling #DEFAULT variants
    - switching from recursive to iterative, with iteration limit
 */

class TextEngine {
    static const String WORDLIST_PATH = "wordlists/";

    static const String DELIMITER = "#";
    static const String SEPARATOR = "|";
    static const String SECTION_SEPARATOR = "@";
    static const String FILE_SEPARATOR = ":";

    static Logger _LOGGER = new Logger("TextEngine", true);

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
        Map<String,Word> savedWords = <String,Word>{};

        Word rootWord = _getWord(rootList);

        if (rootWord == null) {
            _LOGGER.debug("Root list '$rootList' not found");
            return "[$rootList]";
        }

        return _process(rootWord.get(variant), savedWords);
    }

    Future<Null> loadList(String key) async {
        if (_loadedFiles.contains(key)) {
            _LOGGER.debug("World list '$key' already loaded, skipping");
            return;
        }

        _loadedFiles.add(key);

        WordListFile file = await Loader.getResource("$WORDLIST_PATH$key.words");

        wordLists.addAll(file.lists);

        for (String include in file.includes) {
            await loadList(include);
        }
    }

    Word _getWord(String list) {
        if (!wordLists.containsKey(list)) {
            _LOGGER.debug("List '$list' not found");
            return null;
        }

        WordList words = wordLists[list];

        words.processIncludes();

        return rand.pickFrom(words);
    }

    String _process(String input, Map<String,Word> savedWords) {

        input = input.replaceAllMapped(_MAIN_PATTERN, (Match match) {
            String raw = match.group(1);
            List<String> sections = raw.split(SEPARATOR);

            Word outword = null;
            String variant = null;

            // main section
            {
                List<String> parts = sections[0].split(SECTION_SEPARATOR);

                if (parts.length > 1) {
                    variant = parts[1];
                }

                Word w = _getWord(parts[0]);

                outword = w;
            }

            if (sections.length > 1) {
                for (int i=1; i<sections.length; i++) {
                    String section = sections[i];

                    List<String> parts = section.split(SECTION_SEPARATOR);

                    String tag = parts[0];

                    if(tag == "var") { // read or write a variable

                        if (parts.length < 2) { continue; }
                        String variable = parts[1];

                        if (savedWords.containsKey(variable)) {
                            outword = savedWords[variable];
                        } else {
                            savedWords[variable] = outword;
                        }

                    }
                }
            }

            if (outword == null) {
                return "[${sections[0]}]";
            }
            String output = outword.get(variant);

            if (output == null) {
                _LOGGER.debug("Missing variant '$variant' for word '$outword', falling back to base");
                output = outword.get();
            }

            return _process(output, savedWords);
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