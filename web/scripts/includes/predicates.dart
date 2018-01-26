
typedef bool Predicate<T>(T object);
typedef void Lambda<T>(T object);
typedef U Mapping<T,U>(T object);
typedef T Generator<T>();
typedef void Action();

class Tuple<T,U> {
    T first;
    U second;
    Tuple(T this.first, U this.second);

    @override
    String toString() => "[$first, $second]";
}