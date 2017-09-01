@JS()
library tracer;

import 'dart:collection';
import 'dart:html';
import 'dart:js' as JavaScript;
import 'dart:math';

import 'package:js/js.dart';
import 'package:source_span/source_span.dart';
import "package:stack_trace/stack_trace.dart";
import "package:source_map_stack_trace/source_map_stack_trace.dart";
import "package:source_maps/source_maps.dart" as SourceMaps;
import "package:package_resolver/package_resolver.dart";

@JS("Tracer")
class JSTracer {
    external static void writeTrace(String error, TracerCallback callback);
}

@JS("Tracer.Container")
class JSContainer {
    external List<JSFrame> get payload;
}

@JS("StackTrace.StackFrame")
class JSFrame {
    external int get columnNumber;
    external int get lineNumber;
    external String get fileName;
    external String get functionName;
    external String get source;
}

typedef void TracerCallback(JSContainer frames);

class Tracer {
    static Map<String, SourceMaps.Mapping> _mappings = new HashMap<String, SourceMaps.Mapping>();
    static SourceMaps.Mapping _MISSING = new NullMapping();

    static void writeTrace(String error, Element outputContainer) {
        // tests if we're in js or not... try not to use this, it's really very bad...
        if (0.0 is int) {
            JSTracer.writeTrace(error, JavaScript.allowInterop((JSContainer frames) {
                _processJsTrace(frames, outputContainer);
            }));
        } else {
            _processDartTrace(error, outputContainer);
        }
    }

    static void _processJsTrace(JSContainer framecontainer, Element container) {
        List<JSFrame> jsframes = framecontainer.payload;

        List<Frame> frames = <Frame>[];

        String packageRoot = null;
        String framePath = null;

        for (JSFrame jsframe in jsframes) {
            frames.add(new Frame(Uri.parse(jsframe.fileName), jsframe.lineNumber, jsframe.columnNumber, jsframe.functionName));

            framePath = jsframe.fileName;
        }

        String pagePath = window.location.href;

        int similar = -1;
        for (int i=0; i<min(framePath.length, pagePath.length); i++) {
            if (framePath[i] == pagePath[i]) {
                similar = i;
            } else {
                break;
            }
        }

        if (similar >= 0) {
            String scriptPath = framePath.substring(similar+1);
            int subdirs = max(0,scriptPath.split("/").length-1);
            StringBuffer sb = new StringBuffer();
            for (int i=0; i<subdirs; i++) {
                sb.write("../");
            }
            sb.write("packages");
            packageRoot = sb.toString();
        }

        StackTrace trace = new Trace(frames);

        getMappingForCurrentScript((SourceMaps.Mapping mapping) {
            if (mapping != null) {
                if (packageRoot == null) {
                    trace = mapStackTrace(mapping, trace);
                } else {
                    trace = mapStackTrace(mapping, trace, packageResolver: new SyncPackageResolver.root(packageRoot));
                }
            }
            writeTraceToPage(trace, container);
        });
    }

    static void _processDartTrace(String error, Element container) {
        Trace trace = new Trace.parse(error.split("\n").skip(2).join("\n"));

        writeTraceToPage(trace, container);
    }

    static void writeTraceToPage(Trace trace, Element container) {
        _append(container, Trace.format(trace, terse: true));
    }

    static void _append(Element e, String text) {
        e.appendHtml(text, treeSanitizer: NodeTreeSanitizer.trusted);
    }

    static ScriptElement getTheScript() {
        Iterable<ScriptElement> tags = querySelectorAll("script").where((Element e) {
            if (e is ScriptElement) {
                if (e.src.contains(".dart")) {
                    return true;
                }
            }
            return false;
        });
        if (tags.isEmpty) {
            return null;
        }
        return tags.first;
    }

    static void getMappingForCurrentScript(void callback(SourceMaps.Mapping mapping)) {
        ScriptElement current = getTheScript();
        if (current == null) { return null; }

        String path = current.src;
        ////print("path: $path");

        if (!path.endsWith(".js")) { return null; }

        if (!_mappings.containsKey(path)) {
            String mapFile = "$path.map";

            HttpRequest.getString(mapFile)..then((String content) {
                SourceMaps.Mapping mapping = SourceMaps.parse(content);
                if (mapping == null) {
                    ////print("null mapping");
                    _mappings[path] = _MISSING;
                } else {
                    ////print("ok mapping");
                    _mappings[path] = mapping;
                }

                SourceMaps.Mapping out = null;

                if (_mappings[path] != _MISSING) {
                    out = _mappings[path];
                }

                callback(out);
            })..catchError(() {
                ////print("error");
                _mappings[path] = _MISSING;

                callback(null);
            });
        }
    }
}

// not for instantiation normally, but is a value to compare to
class NullMapping implements SourceMaps.Mapping {

    @override
    SourceMaps.SourceMapSpan spanFor(int line, int column, {Map<String, SourceFile> files, String uri}) {
        return null;
    }
    @override
    SourceMaps.SourceMapSpan spanForLocation(SourceLocation location, {Map<String, SourceFile> files}) {
        return null;
    }
}