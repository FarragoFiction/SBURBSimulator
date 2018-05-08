import "dart:html";
import "dart:math" as Math;
import "dart:typed_data";

import "../../scripts/SBURBSim.dart";
import '../../scripts/formats/Formats.dart';
import "../../scripts/includes/bytebuilder.dart";

ByteBuffer buffer1 = null;
ByteBuffer buffer2 = null;

void main() {
    Formats.init();
    Element stuff = querySelector("#stuff");

    Element load1 = FileFormat.loadButton(Formats.binary, (ByteBuffer data, String filename){
        buffer1 = data;
        updateViewer();
    });

    stuff..append(load1);

    Element load2 = FileFormat.loadButton(Formats.binary, (ByteBuffer data, String filename){
        buffer2 = data;
        updateViewer();
    });

    stuff..append(load2);
}

void updateViewer() {
    int rowsize = 16;

    bool has1 = buffer1 != null;
    bool has2 = buffer2 != null;

    int length1 = has1 ? buffer1.lengthInBytes : 0;
    int length2 = has2 ? buffer2.lengthInBytes : 0;

    Uint8List list1 = has1 ? buffer1.asUint8List() : null;
    Uint8List list2 = has2 ? buffer2.asUint8List() : null;

    int maxlength = Math.max(length1, length2);

    int rows = (maxlength / rowsize).ceil();

    Element table = querySelector("#table");
    table.setInnerHtml("");
    print(table);

    // ############### title row

    TableRowElement row = new TableRowElement()..className="title";
    
    if (has1) {
        row.append(new TableCellElement()..text = "file1"..colSpan=rowsize);
    }

    if (has1 && has2) {
        row.append(new TableCellElement()..className="divide");
    }

    if (has2) {
        row.append(new TableCellElement()..text = "file2"..colSpan=rowsize);
    }

    table.append(row);

    // ############### data rows
    
    for (int i=0; i<rows; i++) {
        TableRowElement row = new TableRowElement();

        int start = i * rowsize;

        if (has1) {
            for (int j=0; j<rowsize; j++) {
                TableCellElement cell = new TableCellElement();

                if (start + j < list1.length) {
                    cell.text = list1[start + j].toRadixString(16).padLeft(2, "0").toUpperCase();

                    if (has2 && start+j < list2.length && list2[start+j] == list1[start+j]) {
                        cell.className = "match";
                    }
                } else {
                    cell.className = "empty";
                }

                row.append(cell);
            }
        }

        if (has1 && has2) {
            row.append(new TableCellElement()..className="divide");
        }

        if (has2) {
            for (int j=0; j<rowsize; j++) {
                TableCellElement cell = new TableCellElement();

                if (start + j < list2.length) {
                    cell.text = list2[start + j].toRadixString(16).padLeft(2, "0").toUpperCase();

                    if (has1 && start+j < list1.length && list1[start+j] == list2[start+j]) {
                        cell.className = "match";
                    }
                } else {
                    cell.className = "empty";
                }

                row.append(cell);
            }
        }

        table.append(row);
    }


}