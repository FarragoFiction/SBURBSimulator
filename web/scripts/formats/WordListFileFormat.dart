import "dart:async";

import '../includes/logger.dart';
import '../text_engine.dart';
import "Formats.dart";

class WordListFileFormat extends StringFileFormat<WordListFile> {
    static const String _HEADER = "TextEngine Word List";
    static RegExp _NEWLINE = new RegExp("[\n\r]+");
    static RegExp _SPACES = new RegExp("( *)(.*)");
    static RegExp _COMMENT_START = new RegExp("^\s*\/\/");
    static RegExp _COMMENT_SPLIT = new RegExp("\/\/");
    static Logger _LOGGER = new Logger("WordListFileFormat");//, true);
    static int _TAB = 4;
    
    @override
    String mimeType() => "text/plain";

    @override
    Future<WordListFile> read(String input) async {
        List<String> lines = input.split(_NEWLINE);
        if (lines[0].trimRight() != header()) { throw "Invalid WordList file header: '${lines[0]}'"; }

        WordListFile file = new WordListFile();

        int lineNumber = 0;

        WordList currentList = null;
        Word currentWord = null;

        Map<String,String> globalDefaults = <String,String>{};

        while (lineNumber+1 < lines.length) {
            lineNumber++;
            String line = lines[lineNumber];
            _LOGGER.debug("Reading line $lineNumber, raw: $line");
            line = line.split(_COMMENT_SPLIT)[0];

            if (line.isEmpty) {
                _LOGGER.debug("Empty line");
                continue;
            }
            if (line.startsWith(_COMMENT_START)) {
                _LOGGER.debug("Comment: $line");
                continue;
            }

            if (line.startsWith(TextEngine.INCLUDE_SYMBOL)) {
                String include = line.substring(1);
                _LOGGER.debug("new file include: $include");
                file.includes.add(include);
            } else if (line.startsWith(TextEngine.DEFAULT_SYMBOL)) {
                List<String> parts = escapedSplit(line.substring(1), TextEngine.FILE_SEPARATOR_PATTERN);
                if (parts.length < 2) {
                    _LOGGER.error("Invalid global default '$line'");
                } else {
                    String def = parts[0];
                    String val = parts[1];
                    _LOGGER.debug("new global default '$def': '$val'");
                    globalDefaults[def] = val;
                }
            } else {
                Match m = _SPACES.matchAsPrefix(line);
                if (m != null) {
                    int spaces = m.group(1).length;
                    String content = line.substring(spaces);
                    if (content.isEmpty) { continue; }

                    if (spaces == 0) { // new wordlist

                        content = content.trimRight();
                        _LOGGER.debug("new WordList: $content");
                        currentList = new WordList(content);
                        currentList.defaults.addAll(globalDefaults);
                        file.lists[content] = currentList;

                    } else if (spaces == _TAB) { // a default or include or word

                        if (content.startsWith(TextEngine.DEFAULT_SYMBOL)) { // default

                            content = content.substring(1);
                            List<String> parts = escapedSplit(content, TextEngine.FILE_SEPARATOR_PATTERN);

                            _LOGGER.debug("list default: $content");
                            if (parts.length < 2) {
                                _LOGGER.error("Invalid list default '$line'");
                            } else if (currentList != null) {
                                String def = _removeEscapes(parts[0]);
                                String val = _removeEscapes(parts[1]);
                                _LOGGER.debug("new list default for '${currentList.name}': '$def' -> '$val'");
                                currentList.defaults[def] = val;
                            }

                        } else if (content.startsWith(TextEngine.INCLUDE_SYMBOL)) { // include

                            String include = content.substring(1);
                            _LOGGER.debug("list include: $include");
                            List<String> parts = escapedSplit(content, TextEngine.FILE_SEPARATOR_PATTERN);
                            double weight = 1.0;
                            if (parts.length > 1) {
                                weight = double.parse(parts[1], (String part) {
                                    _LOGGER.warn("Invalid include weight '${parts[1]}' for word '${parts[0]}' in list '${currentList.name}', using 1.0");
                                    return 1.0;
                                });
                            }
                            currentList.includes[_removeEscapes(include)] = weight;

                        } else { // word

                            _LOGGER.debug("new Word: $content");
                            List<String> parts = escapedSplit(line, TextEngine.FILE_SEPARATOR_PATTERN);
                            double weight = 1.0;
                            if (parts.length > 1) {
                                weight = double.parse(parts[1], (String part) {
                                    _LOGGER.warn("Invalid weight '${parts[1]}' for word '${parts[0]}' in list '${currentList.name}', using 1.0");
                                    return 1.0;
                                });
                            }
                            currentWord = new Word(_removeEscapes(parts[0]).trim());
                            currentList.add(currentWord, weight);

                        }

                    } else if (spaces == _TAB*2) { // a variant

                        _LOGGER.debug("new Variant: $content");
                        List<String> parts = escapedSplit(line, TextEngine.FILE_SEPARATOR_PATTERN);
                        if (parts.length != 2) {
                            _LOGGER.error("Invalid variant for ${currentWord.get()} in ${currentList.name}");
                        } else {
                            currentWord.addVariant(_removeEscapes(parts[0]).trim(), _removeEscapes(_trimFirstSpace(parts[1])));
                        }

                    }
                }
            }
        }

        return file;
    }

    @override
    Future<String> write(WordListFile data) => throw "WordListFile write NYI";

    @override
    String header() => _HEADER;

    static String _trimFirstSpace(String input) {
        if (input.startsWith(" ")) {
            return input.substring(1);
        }
        return input;
    }

    static String _removeEscapes(String input) => input.replaceAll(TextEngine.ESCAPE_PATTERN, "");
}