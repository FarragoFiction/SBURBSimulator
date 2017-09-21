import 'dart:async';

class Resource<T> {
    final String path;
    T object = null;
    List<Completer<T>> listeners = <Completer<T>>[];

    Resource(String this.path);

    Future<T> addListener() {
        if (this.object != null) {
            throw "Attempting to add listener after resource population: $path";
        }
        Completer<T> listener = new Completer<T>();
        this.listeners.add(listener);
        return listener.future;
    }

    void populate(T item) {
        if (this.object != null) {
            throw "Resource ($path) already loaded";
        }
        this.object = item;
        for (Completer<T> listener in listeners) {
            listener.complete(this.object);
        }
        listeners.clear();
    }
}