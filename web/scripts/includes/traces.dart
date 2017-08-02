import "dart:collection";
import "dart:html";

import 'package:source_span/source_span.dart';
import "package:stack_trace/stack_trace.dart";
import "package:source_map_stack_trace/source_map_stack_trace.dart";
import "package:source_maps/source_maps.dart" as SourceMaps;

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

class Traces {
    static Map<String, SourceMaps.Mapping> _mappings = new HashMap<String, SourceMaps.Mapping>();
    static SourceMaps.Mapping _MISSING = new NullMapping();

    static void test() {
        /*try {
            throw new Error();
        } catch(e, trace) {
            print(getTraceStackTrace(trace));
        }*/

        throw new Error();
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

    static SourceMaps.Mapping getMappingForCurrentScript() {
        ScriptElement current = getTheScript();
        if (current == null) { return null; }

        String path = current.src;
        
        if (!path.endsWith(".js")) { return null; }

        if (!_mappings.containsKey(path)) {
            String mapFile = "$path.map";

            HttpRequest req = new HttpRequest()
                ..open("GET", mapFile, async: false)
                ..send();

            if (req.status != 200) {
                _mappings[path] = _MISSING;
            } else {
                SourceMaps.Mapping mapping = SourceMaps.parse(req.response);
                if (mapping == null) {
                    _mappings[path] = _MISSING;
                } else {
                    _mappings[path] = mapping;
                }
            }
        }

        if (_mappings[path] == _MISSING) {
            return null;
        }

        return _mappings[path];
    }

    static String getTrace(ErrorEvent event) {
        print("##### MAPPING 1");
        print(event.error);
        print(event.message);
        StackTrace st = new Trace.parse(event.error);
        //StackTrace st = new StackTrace.fromString(event.error);
        /*StackTrace st; // unsuitable, gets trace here, not the error...
        try {
            throw "getting trace";
        } catch(error, trace) {
            st = trace;
        }*/
        print(st == null);
        print(st.runtimeType);
        print("##### MAPPING 1.1");
        print(st.toString());
        print("##### MAPPING 1.2");
        Trace trace = new Trace.from(st);
        print("##### MAPPING 1.3");
        print(trace.toString());
        print("##### MAPPING 1.4");
        return getTraceStackTrace(trace);
    }

    static String getTraceStackTrace(StackTrace trace) {

        print("##### MAPPING 2");
        SourceMaps.Mapping mapping = getMappingForCurrentScript();
        print("##### MAPPING 3");
        if (mapping != null) {
            print("##### MAPPING 4");
            trace = mapStackTrace(mapping, trace, minified: true);
            print("##### MAPPING 5");
        }
        print("##### MAPPING 6");

        //Trace fancyTrace = new Trace.from(trace);
        //return Trace.format(fancyTrace);
        return trace.toString();
    }
}