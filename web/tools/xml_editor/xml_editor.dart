import 'dart:html';
import "package:xml/xml.dart" as Xml;
import '../../scripts/includes/logger.dart';

const String xmlHeader = '<?xml version="1.0" encoding="UTF-8"?>';

XmlProject project;
Logger logger = Logger.get("Xml Editor");

void main() {
    querySelector("#new").onClick.listen(newFile);
    querySelector("#load").onClick.listen((Event e) => querySelector("#file").click());
    querySelector("#save").onClick.listen(saveFile);

    FileReader reader = new FileReader();
    reader..onLoadEnd.listen((ProgressEvent e){
        loadFile(reader.result);
    });

    FileUploadInputElement load = querySelector("#file");
    load.onChange.listen((Event e) {
        if (load.files.isEmpty) {return;}

        File f = load.files.first;
        reader.readAsText(f);
        load.value = null;
    });
}

void makeProject(String projectType) {
    if (projectType == "faq") {
        project = new FaqProject();
    } else {
        logger.error("invalid project type");
        return;
    }
}

bool clearProject(String message) {
    if (project != null) {
        if (!window.confirm(message)) {
            return false;
        }
        project.destroy();
        project = null;
    }
    return true;
}

void newFile([Event event]) {
    if (!clearProject("Starting a new project will discard the current one. Are you sure?")) { return; }

    String projectType = (querySelector("#filetype") as SelectElement).value;

    logger.debug("Project type: $projectType");

    makeProject(projectType);
    querySelector("#editor").append(project.element);
}

void loadFile(String content) {
    if (!clearProject("Loading an existing project will discard the current one. Are you sure?")) { return; }

    logger.debug(content);

    Xml.XmlDocument doc = Xml.parse(content);
    for (Xml.XmlNode child in doc.children) {
        if (child is Xml.XmlElement) {
            String name = child.name.local;
            if (OTypes.mapping.containsKey(name)) {
                makeProject(name);
                if (project != null) {
                    project.root.load(child);
                    querySelector("#editor").append(project.element);
                }
                break;
            }
        }
    }

}

void saveFile([Event event]) {
    if (project == null) { return; }

    String content = project.root.write(0);

    logger.debug(content);

    Uri datauri = new Uri.dataFromString("$xmlHeader\n${sanitiseQuotes(content)}", mimeType: "text/xml", base64:true);

    logger.debug(datauri);

    AnchorElement link = new AnchorElement(href:datauri.toString())..download="${project.root.type.tag}.xml" ..className="hidden";
    querySelector("#menu").append(link);
    link.click();
    link.remove();
}

String ind(int count, String text) {
    return "${"    " * count}$text";
}

String trimText(String input) => input.split("\n").map((String line) => line.trimLeft()).where((String line) => !line.isEmpty).join("\n");

RegExp quoteSingle = new RegExp(r"[‘’]");
RegExp quoteDouble = new RegExp(r"[“”]");
String sanitiseQuotes(String input) => input.replaceAll(quoteSingle, "'").replaceAll(quoteDouble, '"');

// #################################################################################

abstract class OTypes {
    static XmlObjectType text = new TextObject();

    static XmlObjectType faq = new FaqObject();
    static XmlObjectType faqSection = new FaqSectionObject();
    static XmlObjectType faqHeader = new TextElementObject("header");
    static XmlObjectType faqBody = new TextElementObject("body");

    static Map<String, XmlObjectType> mapping = <String, XmlObjectType>{
        "text" : text,
        "faq" : faq,
        "section" : faqSection,
        "header" : faqHeader,
        "body" : faqBody,
    };
}


// #################################################################################

class XmlProject {
    XmlObject root;
    Element _element;

    XmlProject() {
        logger.debug("New project: ${this.runtimeType}");
    }

    Element get element {
        if (this._element == null) {
            this.createElement();
        }
        return this._element;
    }

    void destroy(){
        print("boom");
        if (this._element != null) {
            this._element.remove();
        }
    }

   void createElement() {
        Element div = new DivElement();

        div.append(this.root.element);

        this._element = div;
    }
}

class XmlObjectType {
    final String tag;
    final bool fixedChildren = false;
    final bool topLevel = false;

    final List<XmlObjectType> requiredChildren = null;
    final List<XmlObjectType> allowedChildren = <XmlObjectType>[];
    
    XmlObjectType(String this.tag);

    String write(XmlObject object, int indent) {
        StringBuffer b = new StringBuffer();
        b.writeln(ind(indent, "<$tag>"));

        for (XmlObject child in object.children) {
            b.writeln(child.write(indent + 1));
        }

        b.write(ind(indent, "</$tag>"));

        return b.toString();
    }

    bool isTypeAllowed(XmlObjectType type, int slot) {
        if (this.fixedChildren) {
            if (slot >= this.requiredChildren.length) { return false; }
            return this.requiredChildren[slot] == type;
        }
        return this.allowedChildren.contains(type);
    }

    List<Element> createElement(XmlObject object) {
        Element div = new DivElement()..className="xmlobject";
        div.append(new HeadingElement.h1()..text = this.tag);

        Element inner = new DivElement();
        div.append(inner);

        for (XmlObject child in object.children) {
            inner.append(object.makeChildWrapperElement(child));
        }

        if (!fixedChildren) {
            SelectElement dropdown = new SelectElement();
            for (XmlObjectType type in allowedChildren) {
                dropdown.append(new OptionElement(data:type.tag, value:type.tag));
            }
            div.append(dropdown);
            ButtonElement addbutton = new ButtonElement()..text="Add"..onClick.listen((Event e){
                XmlObject o = new XmlObject(OTypes.mapping[dropdown.value]);
                object.addChild(o);
                inner.append(object.makeChildWrapperElement(o));
            });
            div.append(addbutton);
        }

        return <Element>[div, inner];
    }

    void load(XmlObject object, Xml.XmlNode node) {
        int i = 0;
        for (Xml.XmlNode child in node.children) {
            if (child is Xml.XmlElement) {
                logger.debug("xml: ${child.name.local}");
                for (XmlObjectType type in OTypes.mapping.values) {
                    if (type.tag == child.name.local) {
                        logger.debug("match: ${type.tag}");
                        if (this.isTypeAllowed(type, i)) {
                            logger.debug("allowed");
                            XmlObject o = new XmlObject(type);
                            object.setChild(i, o);
                            i++;
                            o.load(child);
                        }

                        break;
                    }
                }
            } else if (child is Xml.XmlText) {
                if (this.isTypeAllowed(OTypes.text, i)) {
                    XmlObject o = new XmlObject(OTypes.text);
                    o.text = sanitiseQuotes(trimText(child.text));
                    object.setChild(i, o);
                    i++;
                }
            }
        }
    }
}

class XmlObject {
    final XmlObjectType type;
    String text = "";
    
    Element _element;
    Element _inner;

    final List<XmlObject> children = <XmlObject>[];

    XmlObject(XmlObjectType this.type) {
        if (type.requiredChildren != null) {
            for (XmlObjectType t in type.requiredChildren) {
                this.children.add(new XmlObject(t));
            }
        }
    }

    Element get element {
        if (this._element == null) {
            this.createElement();
        }
        return this._element;
    }

    void addChild(XmlObject child, [bool append = false]) {
        if (type.fixedChildren) {
            return;
        }
        this.children.add(child);
        if (append) {
            this._inner.append(child.element);
        }
    }

    void removeChild(XmlObject child) {
        if (type.fixedChildren) {
            return;
        }
        this.children.remove(child);
    }

    Element makeChildWrapperElement(XmlObject child) {
        if (this.type.fixedChildren) {
            return child.element;
        } else {
            Element childwrapper = new DivElement()..className="elementwrapper";
            childwrapper.append(new DivElement()..className="delete"..text = "[X]"..title="Delete element below"..onClick.listen((Event e){
                if (!window.confirm("Delete element?")) { return; }
                this.removeChild(child);
                childwrapper.remove();
            }));
            childwrapper.append(child.element);
            return childwrapper;
        }
    }

    String write(int indent) {
        return this.type.write(this, indent);
    }

    void createElement() {
        List<Element> elements = this.type.createElement(this);
        this._element = elements[0];
        this._inner = elements[1];
    }

    void load(Xml.XmlNode node) {
        this.type.load(this,node);
    }

    void setChild(int i, XmlObject other) {
        if (i >= this.children.length) {
            this.children.add(other);
        } else {
            this.children[i] = other;
        }
    }
}

class TextObject extends XmlObjectType {
    @override
    final bool fixedChildren = true;

    TextObject():super("text"); // tag not actually used!

    @override
    String write(XmlObject object, int indent) {
        logger.debug("Write text element: ${object.text}");
        return object.text.split("\n").map((String line) => ind(indent, line)).join("\n");
    }

    @override
    List<Element> createElement(XmlObject object) {
        Element div = new DivElement();
        TextAreaElement textbox = new TextAreaElement()..cols=150..rows=8..value = object.text;
        textbox.onChange.listen((Event e) {
            logger.debug("textbox onChange: ${textbox.value}");
            object.text = textbox.value;
        });
        div.append(textbox);
        return <Element>[div, textbox];
    }

    @override
    void load(XmlObject object, Xml.XmlNode node) {
        for (Xml.XmlNode child in node.children) {
            logger.debug(child.runtimeType);
        }
    }
}

class TextElementObject extends XmlObjectType {

    TextElementObject(String tag):super(tag);

    @override
    final bool fixedChildren = true;

    @override
    final List<XmlObjectType> requiredChildren = <XmlObjectType>[OTypes.text];
}

// #################################################################################

// FAQ

class FaqProject extends XmlProject {
    FaqProject():super() {
        this.root = new XmlObject(OTypes.faq);
    }
}

class FaqObject extends XmlObjectType {
    @override
    final List<XmlObjectType> allowedChildren = <XmlObjectType>[OTypes.faqSection];
    @override
    final bool topLevel = true;

    FaqObject():super("faq") {}
}

class FaqSectionObject extends XmlObjectType {
    @override
    final bool fixedChildren = true;

    @override
    final List<XmlObjectType> requiredChildren = <XmlObjectType>[OTypes.faqHeader, OTypes.faqBody];

    FaqSectionObject():super("section") {}
}