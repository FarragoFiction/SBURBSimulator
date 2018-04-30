import "dart:async";

import "SBURBSim.dart";


class TextEngine {
    static const String WORDLIST_PATH = "wordlists/";

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

        return _process(rootWord.get(variant), savedWords);
    }

    Future<Null> loadList(String key) async {
        if (_loadedFiles.contains(key)) { return; }

        _loadedFiles.add(key);

        WordListFile file = await Loader.getResource("$WORDLIST_PATH$key.words");

        wordLists.addAll(file.lists);

        for (String include in file.includes) {
            await loadList(include);
        }
    }

    Word _getWord(String list) {
        if (!wordLists.containsKey(list)) { return null; }

        return rand.pickFrom(wordLists[list]);
    }

    String _process(String input, Map<String,Word> savedWords) {
        return input; // TODO: more shit
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
}

/// Convenience class, no new functionality
class WordList extends WeightedList<Word> {}

class WordListFile {
    List<String> includes = <String>[];
    Map<String,WordList> lists = <String,WordList>{};
}