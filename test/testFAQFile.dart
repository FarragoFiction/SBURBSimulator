import "JRTestSuite.dart";
import "../web/scripts/FAQEngine/FAQFile.dart";

//this will not run as long as I reference quirk. stupid html package

main() {
    print("Hello World");
    basicTests();
}

FAQFile setupFF() {
    return new FAQFile("Rage.txt");
}

void basicTests() {
    FAQFile f = setupFF();
    jRAssert("faqFIle object existing", f != null, true);
}