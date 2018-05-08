import "dart:async";

import "SBURBSim.dart";

/*
    TODO:
    - switching from recursive to iterative, with iteration limit
 */

String _escapedMapping(Match m) => m.group(0);
List<String> escapedSplit(String input, RegExp pattern) => pattern.allMatches(input).map(_escapedMapping).toList();

class TextEngine {
    static const String WORDLIST_PATH = "wordlists/";

    static const String DELIMITER = "#";
    static const String SEPARATOR = "|";
    static const String SECTION_SEPARATOR = "@";
    static const String INCLUDE_SYMBOL = "@";
    static const String FILE_SEPARATOR = ":";
    static const String DEFAULT_SYMBOL = "?";

    static final RegExp DELIMITER_PATTERN = new RegExp("([^\\\\$DELIMITER]|\\\\$DELIMITER)+");
    static final RegExp SEPARATOR_PATTERN = new RegExp("([^\\\\$SEPARATOR]|\\\\$SEPARATOR)+");
    static final RegExp SECTION_SEPARATOR_PATTERN = new RegExp("([^\\\\$SECTION_SEPARATOR]|\\\\$SECTION_SEPARATOR)+");
    static final RegExp FILE_SEPARATOR_PATTERN = new RegExp("([^\\\\$FILE_SEPARATOR]|\\\\$FILE_SEPARATOR)+");

    static Logger _LOGGER = new Logger("TextEngine");//, true);

    static RegExp MAIN_PATTERN = new RegExp("$DELIMITER(.*?)$DELIMITER");
    static RegExp REFERENCE_PATTERN = new RegExp("\\?(.*?)\\?");
    static RegExp ESCAPE_PATTERN = new RegExp("\\\\(?!\\\\)");

    Set<String> _loadedFiles = new Set<String>();
    Map<String, WordList> sourceWordLists = <String, WordList>{};
    Map<String, WordList> wordLists = <String, WordList>{};

    bool _processed = false;
    Random rand;

    TextEngine([int seed = null]) {
        this.rand = new Random(seed);
    }

    void setSeed(int seed) {
        this.rand = new Random(seed);
    }

    String phrase(String rootList, [String variant = null]) {
        if (!_processed) {
            this.processLists();
        }

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

        sourceWordLists.addAll(file.lists);

        for (String include in file.includes) {
            await loadList(include);
        }

        _processed = false;
    }

    void processLists() {
        _LOGGER.debug("Processing word lists");
        this._processed = true;
        this.wordLists.clear();

        for (String key in this.sourceWordLists.keys) {
            WordList list = new WordList.copy(this.sourceWordLists[key]);
            this.wordLists[key] = list;

            for (String dkey in list.defaults.keys) {
                for (Word w in list) {
                    if (!w._variants.containsKey(dkey)) {
                        w.addVariant(dkey, list.defaults[dkey]);
                    }
                }
            }
        }

        for (String key in this.wordLists.keys) {
            WordList list = this.wordLists[key];

            list.processIncludes(this.wordLists);

            for (Word word in list) {

                // add default variants
                for (String dkey in list.defaults.keys) {
                    if (!word._variants.containsKey(dkey)) {
                        word._variants[dkey] = list.defaults[dkey];
                    }
                }

                // resolve references
                for (String vkey in word._variants.keys) {
                    word._variants[vkey] = word._variants[vkey].replaceAllMapped(REFERENCE_PATTERN, (Match match) {
                        String variant = match.group(1);
                        if (!word._variants.containsKey(variant)) {
                            return "[$variant]";
                        }
                        return word._variants[variant];
                    });
                }
            }
        }
    }

    Word _getWord(String list) {
        if (!wordLists.containsKey(list)) {
            _LOGGER.debug("List '$list' not found");
            return null;
        }

        WordList words = wordLists[list];

        return rand.pickFrom(words);
    }

    String _process(String input, Map<String,Word> savedWords) {

        input = input.replaceAllMapped(MAIN_PATTERN, (Match match) {
            String raw = match.group(1);
            List<String> sections = escapedSplit(raw, SEPARATOR_PATTERN);//raw.split(SEPARATOR);

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
    static const String BASE_NAME = "MAIN";
    Map<String,String> _variants;

    Word(String word, [Map<String,String> this._variants]) {
        if (_variants == null) {
            _variants = <String,String>{};
        }
        _variants[BASE_NAME] = word;
    }

    factory Word.copy(Word other) => new Word(other.get(), other._variants);

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
    Map<String, String> defaults = <String, String>{};

    final String name;
    bool _processed = false;

    WordList(String this.name) : super();

    factory WordList.copy(WordList other) {
        WordList copy = new WordList(other.name);

        for (String key in other.includes.keys) {
            copy.includes[key] = other.includes[key];
        }

        for (String key in other.defaults.keys) {
            copy.defaults[key] = other.defaults[key];
        }

        for (WeightPair<Word> pair in other.pairs) {
            copy.addPair(new WeightPair<Word>(new Word.copy(pair.item), pair.weight));
        }

        return copy;
    }

    @override
    String toString() => "WordList '$name': ${super.toString()}";

    void processIncludes(Map<String, WordList> wordlists, [Set<WordList> visited = null]) {
        if (_processed) { return; }
        _processed = true;

        Set<WordList> visited = new Set<WordList>();
        visited.add(this);

        for (String key in this.includes.keys) {
            if (wordlists.containsKey(key)) {
                WordList list = wordlists[key];

                if (visited.contains(list)) {
                    TextEngine._LOGGER.warn("Include loop detected in list '$name', already visited '${list.name}', ignoring");
                    continue;
                }

                list.processIncludes(wordlists, visited);
            }
        }

        for (String key in includes.keys) {
            if (!wordlists.containsKey(key)) { continue; }
            WordList list = wordlists[key];
            for (WeightPair<Word> pair in list.pairs) {
                this.add(pair.item, pair.weight * includes[key]);
            }
        }
    }
}

class WordListFile {
    List<String> includes = <String>[];
    Map<String,WordList> lists = <String,WordList>{};

    WordListFile();

    @override
    String toString() => "[WordListFile: $lists ]";
}