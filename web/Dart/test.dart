//i guess main is like window.onload or some shit???
void main() {
  for (int i = 0; i < 5; i++) {
    //print('hello ${i + 1}');
  }
  Animal a = new Animal("Fox", "...");
  a.makeSound();
  Pet p = new Pet("Dog", "bark", "Fido");
  p.makeSound();
  //print(p.name + " has " + p.hp.toString() + " hp remaining. ");
}
//http://blog.sethladd.com/2013/03/first-look-at-dart-mixins.html

class Animal{
  String sound;
  String species;
  int hp = 100;

  Animal(this.species, this.sound);

  makeSound(){
    //print(this.species + " says: " + sound);
  }
}

class Pet extends Animal{
  String name;
  String species;
  String sound;

  Pet(this.species, this.sound, this.name) : super(species, sound);

  makeSound(){
    //print(name + ", a " + species + " says: " + sound);
  }
}