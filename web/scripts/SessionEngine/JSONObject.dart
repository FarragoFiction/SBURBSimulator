/*
    should be a wrapper for a map.
    new JsonObject.fromJsonString(json); should be implemented.
 */
import 'dart:collection';
import 'dart:convert';

class JSONObject extends Object with MapMixin<String,String>{
    Map<String, String> json = new Map<String,String>();
    JSONObject();

    JSONObject.fromJSONString(String j){
        //;
        //okay. that's not working. what if i do it opposite to see what a encoded object looks like
        JSONObject test = new JSONObject();
        test["HELLO"] = "WORLD ";
        test["GOODBYE"] = "WORLD BUT A SECOND TIME ";
        //;
        //;

        json  = JSON.decode(j);
    }

    static Set<int> jsonStringToIntSet(String str) {
        if(str == null) return new Set<int>();
        //;
        str = str.replaceAll("{", "");
        str = str.replaceAll("}", "");
        str = str.replaceAll(" ", "");

        List<String> tmp = str.split(",");
        Set<int> ret = new Set<int>();
        for(String s in tmp) {
            //;
            try {
                int i = int.parse(s);
                //;
                ret.add(i);
            }catch(e) {
                //oh well. probably a bracket or a space or something
            }
        }
        return ret;
    }

    static List<int> jsonStringToIntArray(String str) {
        if(str == null) return new List<int>();
        //;
        str = str.replaceAll("[", "");
        str = str.replaceAll("]", "");
        str = str.replaceAll(" ", "");

        List<String> tmp = str.split(",");
        List<int> ret = new List<int>();
        for(String s in tmp) {
            //;
            try {
                int i = int.parse(s);
                //;
                ret.add(i);
            }catch(e) {
                //oh well. probably a bracket or a space or something
            }
        }
        return ret;
    }

    static Set<String> jsonStringToStringSet(String str) {
        if(str == null) return new Set<String>();
        //;
        str = str.replaceAll("{", "");
        str = str.replaceAll("}", "");
        str = str.replaceAll(" ", "");

        List<String> tmp = str.split(",");
        Set<String> ret = new Set<String>();
        for(String s in tmp) {
            //;
            try {
                //;
                ret.add(s);
            }catch(e) {
                //oh well. probably a bracket or a space or something
            }
        }
        return ret;
    }

    @override
    String toString() {
        return JSON.encode(json);
    }

  @override
  String operator [](Object key) {
    return json[key];
  }

  @override
  void operator []=(String key, String value) {
    json[key] = value;
  }

  @override
  void clear() {
    json.clear();
  }

  @override
  Iterable<String> get keys => json.keys;

  @override
  String remove(Object key) {
   json.remove(key);
  }
}