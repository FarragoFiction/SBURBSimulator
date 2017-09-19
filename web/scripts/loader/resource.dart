import 'dart:async';

import "../SBURBSim.dart";

class Resource<T> {
    final String name;
    T object = null;
    List<Completer<T>> listeners = <Completer<T>>[];

    Resource(String this.name);

    Future<T> addListener() {
        Completer<T> listener = new Completer<T>();
        this.listeners.add(listener);
        return listener.future;
    }

    void populate(T item) {
        if (this.object != null) {
            throw "Resource ($name) already loaded";
        }
        this.object = item;
        for (Completer<T> listener in listeners) {
            listener.complete(this.object);
        }
    }
}