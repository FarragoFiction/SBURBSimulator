import 'dart:html';
import "package:xml/xml.dart" as Xml;
import '../../scripts/includes/logger.dart';

XmlProject project;
Logger logger = Logger.get("Xml Editor");

void main() {
    querySelector("#new").onClick.listen(newFile);
    querySelector("#load").onClick.listen(loadFile);
    querySelector("#save").onClick.listen(saveFile);
}

void newFile([Event event]) {
    if (project != null) {
        if (!window.confirm("Starting a new project will discard the current one. Are you sure?")) {
            return;
        }
        project.destroy();
        project = null;
    }


    String projectType = (querySelector("#filetype") as SelectElement).value;

    logger.debug("Project type: $projectType");

    if (projectType == "faq") {
        project = new FaqProject();
    } else {
        logger.error("invalid project type");
    }

    querySelector("#editor").append(project.element);
}

void loadFile([Event event]) {

}

void saveFile([Event event]) {
    if (project == null) { return; }

    String content = project.root.write(0);

    logger.debug(content);

    Uri datauri = new Uri.dataFromString(content, mimeType: "text/xml", base64:true);

    logger.debug(datauri);

    AnchorElement link = new AnchorElement(href:datauri.toString())..download="${project.root.type.tag}.xml" ..className="download";
    querySelector("#menu").append(link);
    link.click();
    link.remove();
}

String ind(int count, String text) {
    return "${"    " * count}$text";
}

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

    final List<XmlObjectType> requiredChildren = null;
    final List<XmlObjectType> allowedChildren = null;
    
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

    void addChild(XmlObject child) {
        if (type.fixedChildren) {
            return;
        }
        this.children.add(child);
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
            Element childwrapper = new DivElement();
            childwrapper.append(new DivElement()..className="delete"..text = "-"..onClick.listen((Event e){
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
        TextAreaElement textbox = new TextAreaElement();
        textbox.onChange.listen((Event e) {
            logger.debug("textbox onChange: ${textbox.value}");
            object.text = textbox.value;
        });
        div.append(textbox);
        return <Element>[div, textbox];
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

    FaqObject():super("faq") {}
}

class FaqSectionObject extends XmlObjectType {
    @override
    final bool fixedChildren = true;

    @override
    final List<XmlObjectType> requiredChildren = <XmlObjectType>[OTypes.faqHeader, OTypes.faqBody];

    FaqSectionObject():super("section") {}
}