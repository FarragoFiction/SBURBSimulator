import "dart:math" as Math;
import "dart:typed_data";

import "../3d/three.dart" as THREE;

typedef void SpriteDataRegionCallback(PSprite sprite, int dataindex, int regionindex);

class PSprite {
    int width;
    int height;

    int _offsetX;
    int _offsetY;
    int _boundsX;
    int _boundsY;

    THREE.DataTexture _texture;

    Uint8List data;
    Map<int, String> paletteNames = <int, String>{};
    Map<String, int> paletteIds = <String, int>{};

    PSprite(int this.width, int this.height) {
        this.data = new Uint8List(width * height);
    }

    int getOrAddPaletteId(String name) {
        if (this.paletteIds.containsKey(name)) {
            return this.paletteIds[name];
        } else {
            int id = this.paletteIds.length+1;

            this.paletteIds[name] = id;
            this.paletteNames[id] = name;

            return id;
        }
    }

    //#########################################################
    // Texture
    //#########################################################

    THREE.TextureBase get texture {
        if (_texture == null) {
            _texture = new THREE.DataTexture(this.data, width, height, THREE.AlphaFormat, THREE.UnsignedByteType)..flipY=true..needsUpdate=true;
        }

        return this._texture;
    }

    //#########################################################
    // Bounding methods
    //#########################################################

    void recalculateBounds() {
        int minx = this.width;
        int miny = this.height;
        int maxx = -1;
        int maxy = -1;

        int index;
        for (int x = 0; x<this.width; x++) {
            for (int y = 0; y<this.height; y++) {
                index = y * this.width + x;
                if (data[index] != 0) {
                    if (x < minx) {
                        minx = x;
                    } else if (x > maxx) {
                        maxx = x;
                    }
                    if (y < miny) {
                        miny = y;
                    } else if (y > maxy) {
                        maxy = y;
                    }
                }
            }
        }

        int zonewidth = Math.max(0, maxx - minx + 1);
        int zoneheight = Math.max(0, maxy - miny + 1);

        this.setBounds(minx, miny, zonewidth, zoneheight);
    }

    void setBounds(int x, int y, int width, int height) {
        this
            .._offsetX = x
            .._offsetY = y
            .._boundsX = width
            .._boundsY = height;
    }

    //#########################################################
    // super handy stuff for saving and loading
    //#########################################################

    void forDataRegion(int x, int y, int width, int height, SpriteDataRegionCallback function) {
        x = Math.min(x, this.width - 1);
        y = Math.min(y, this.height - 1);
        width = Math.min(width, this.width-x);
        height = Math.min(height, this.height-y);

        int index = 0;
        for (int iy=y; iy<y+height; iy++) {
            for (int ix=x; ix<x+width; ix++) {
                int id = iy * this.width + ix;
                function(this, id, index);
                index++;
            }
        }
    }

    void writeDataRegion(int x, int y, int width, Uint8List data) {
        int ix,iy,index;
        for (int i=0; i<data.lengthInBytes; i++) {
            ix = (i % width) + x;
            iy = (i ~/ width) + y;
            index = iy * this.width + ix;
            this.data[index] = data[i];
        }
    }
}