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
        //print("trying to make a json object from $j ");
        //okay. that's not working. what if i do it opposite to see what a encoded object looks like
        JSONObject test = new JSONObject();
        test["HELLO"] = "WORLD ";
        test["GOODBYE"] = "WORLD BUT A SECOND TIME ";
        //print("Encoded: ${JSON.encode(test)}");
        //print("String: ${test}");

        json  = JSON.decode(j);
    }

    static Set<int> jsonStringToIntSet(String str) {
        if(str == null) return new Set<int>();
        //print("str is $str");
        str = str.replaceAll("{", "");
        str = str.replaceAll("}", "");
        str = str.replaceAll(" ", "");

        List<String> tmp = str.split(",");
        Set<int> ret = new Set<int>();
        for(String s in tmp) {
            //print("s is $s");
            try {
                int i = int.parse(s);
                //print("adding $i");
                ret.add(i);
            }catch(e) {
                //oh well. probably a bracket or a space or something
            }
        }
        return ret;
    }

    static Set<String> jsonStringToStringSet(String str) {
        if(str == null) return new Set<String>();
        //print("str is $str");
        str = str.replaceAll("{", "");
        str = str.replaceAll("}", "");
        str = str.replaceAll(" ", "");

        List<String> tmp = str.split(",");
        Set<String> ret = new Set<String>();
        for(String s in tmp) {
            //print("s is $s");
            try {
                //print("adding $i");
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