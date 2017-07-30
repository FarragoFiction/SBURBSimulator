import 'dart:html';
import 'dart:math';

class Colour {
    int _red;
    int _green;
    int _blue;
    int _alpha;

    // Constructors ###################################################################################

    Colour([int red = 0, int green = 0, int blue = 0, int alpha = 0xFF]) {
        this.red = red.clamp(0, 0xFF);
        this.green = green.clamp(0, 0xFF);
        this.blue = blue.clamp(0, 0xFF);
        this.alpha = alpha.clamp(0,0xFF);
    }

    factory Colour.from(Colour other) {
        return new Colour(other.red, other.green, other.blue, other.alpha);
    }

    factory Colour.double(double red, double green, double blue, [double alpha = 1.0]) {
        return new Colour()
            ..redDouble = red
            ..greenDouble = green
            ..blueDouble = blue
            ..alphaDouble = alpha;
    }

    factory Colour.fromHex(int hex, [bool useAlpha = false]) {
        if (useAlpha) {
            int red = (hex & 0xFF000000) >> 24;
            int green = (hex & 0x00FF0000) >> 16;
            int blue = (hex & 0x0000FF00) >> 8;
            int alpha = (hex & 0x000000FF);

            return new Colour(red, green, blue, alpha);
        } else {
            int red = (hex & 0xFF0000) >> 16;
            int green = (hex & 0x00FF00) >> 8;
            int blue = (hex & 0x0000FF);

            return new Colour(red, green, blue);
        }
    }

    factory Colour.fromHexString(String hex) {
        return new Colour.fromHex(int.parse(hex, onError: (String s) => 0), hex.length >= 8);
    }

    factory Colour.fromStyleString(String hex) {
        return new Colour.fromHexString(hex.substring(1));
    }

    // Getters/setters ###################################################################################

    int get red =>  _red;
    int get green =>_green;
    int get blue => _blue;
    int get alpha =>_alpha;

    void set red(int val)   { _red =    val.clamp(0,0xFF); }
    void set green(int val) { _green =  val.clamp(0,0xFF); }
    void set blue(int val)  { _blue =   val.clamp(0,0xFF); }
    void set alpha(int val) { _alpha =  val.clamp(0,0xFF); }

    double get redDouble =>     red /   0xFF;
    double get greenDouble =>   green / 0xFF;
    double get blueDouble =>    blue /  0xFF;
    double get alphaDouble =>   alpha / 0xFF;

    void set redDouble(double val)  { this.red =    (val*0xFF).floor(); }
    void set greenDouble(double val){ this.green =  (val*0xFF).floor(); }
    void set blueDouble(double val) { this.blue =   (val*0xFF).floor(); }
    void set alphaDouble(double val){ this.alpha =  (val*0xFF).floor(); }

    // Methods ###################################################################################

    @override
    String toString() {
        return "rgb($red, $green, $blue, $alpha)";
    }

    int toHex([bool useAlpha = false]) {
        if (useAlpha) {
            return (red << 24) | (green << 16) | (blue << 8) | alpha;
        }
        return (red << 16) | (green << 8) | blue;
    }

    String toHexString([bool useAlpha = false]) {
        return this.toHex(useAlpha).toRadixString(16).padLeft(useAlpha ? 8 : 6, "0");
    }

    String toStyleString([bool useAlpha = false]) {
        return "#${this.toHexString(useAlpha)}";
    }

    bool matchFromImageData(ImageData data, int offset) {
        return data.data[offset] == this.red && data.data[offset+1] == this.green && data.data[offset+2] == this.blue && data.data[offset+3] == this.alpha;
    }

    Colour mixRGB(Colour other, double fraction) {
        fraction = fraction.clamp(0.0, 1.0);
        return (this * (1-fraction)) + (other * fraction);
    }

    Colour mixGamma(Colour other, double fraction, [double gamma = 2.2]) {
        fraction = fraction.clamp(0.0, 1.0);
        double inverse = 1.0 / gamma;

        double r = pow( _lerp( pow(this.redDouble, gamma), pow(other.redDouble, gamma), fraction), inverse);
        double g = pow( _lerp( pow(this.greenDouble, gamma), pow(other.greenDouble, gamma), fraction), inverse);
        double b = pow( _lerp( pow(this.blueDouble, gamma), pow(other.blueDouble, gamma), fraction), inverse);
        double a = _lerp(this.alphaDouble, other.alphaDouble, fraction);

        return new Colour.double(r,g,b,a);
    }

    Colour mix(Colour other, double fraction, [bool useGamma = false, double gamma = 2.2]) {
        if (useGamma) {
            return this.mixGamma(other, fraction, gamma);
        }
        return this.mixRGB(other, fraction);
    }

    static double _lerp(double first, double second, double fraction) {
        return (first * (1-fraction) + second * fraction);
    }

    // Operators ###################################################################################

    @override
    bool operator ==(dynamic other) {
        if (other is Colour) {
            return this._red == other._red && this._green == other._green && this._blue == other._blue && this._alpha == other._alpha;
        }
        return false;
    }

    @override
    int get hashCode => this.toHex(true);

    Colour operator +(dynamic other) {
        if (other is Colour) {
            return new Colour(this.red + other.red, this.green + other.green, this.blue + other.blue, this.alpha + other.alpha);
        } else if (other is double) {
            return new Colour.double(this.redDouble + other, this.greenDouble + other, this.blueDouble + other, this.alphaDouble);
        } else if (other is int) {
            return new Colour(this.red + other, this.green + other, this.blue + other, this.alpha);
        }
        throw "Cannot add [${other.runtimeType} $other] to a Colour. Only Colour, double and int are valid.";
    }

    Colour operator -(dynamic other) {
        if (other is Colour) {
            return new Colour(this.red - other.red, this.green - other.green, this.blue - other.blue, this.alpha - other.alpha);
        } else if (other is double) {
            return new Colour.double(this.redDouble - other, this.greenDouble - other, this.blueDouble - other, this.alphaDouble);
        } else if (other is int) {
            return new Colour(this.red - other, this.green - other, this.blue - other, this.alpha);
        }
        throw "Cannot subtract [${other.runtimeType} $other] from a Colour. Only Colour, double and int are valid.";
    }

    Colour operator /(dynamic other) {
        if (other is Colour) {
            return new Colour.double(this.redDouble / other.redDouble, this.greenDouble / other.greenDouble, this.blueDouble / other.blueDouble, this.alphaDouble / other.alphaDouble);
        } else if (other is num) {
            return new Colour.double(this.redDouble / other, this.greenDouble / other, this.blueDouble / other, this.alphaDouble);
        }
        throw "Cannot divide a Colour by [${other.runtimeType} $other]. Only Colour, double and int are valid.";
    }

    Colour operator *(dynamic other) {
        if (other is Colour) {
            return new Colour.double(this.redDouble * other.redDouble, this.greenDouble * other.greenDouble, this.blueDouble * other.blueDouble, this.alphaDouble * other.alphaDouble);
        } else if (other is num) {
            return new Colour.double(this.redDouble * other, this.greenDouble * other, this.blueDouble * other, this.alphaDouble);
        }
        throw "Cannot multiply a Colour by [${other.runtimeType} $other]. Only Colour, double and int are valid.";
    }

    int operator [](int index) {
        if (index == 0) return red;
        if (index == 1) return green;
        if (index == 2) return blue;
        if (index == 3) return alpha;
        throw "Colour index out of range: $index";
    }

    void operator []=(int index, num value) {
        if (index < 0 || index > 3) { throw "Colour index out of range: $index"; }
        if (value is int) {
            if (index == 0) {
                this.red = value;
            } else if (index == 1) {
                this.green = value;
            } else if (index == 2) {
                this.blue = value;
            } else {
                this.alpha = value;
            }
        } else {
            if (index == 0) {
                this.redDouble = value;
            } else if (index == 1) {
                this.greenDouble = value;
            } else if (index == 2) {
                this.blueDouble = value;
            } else {
                this.alphaDouble = value;
            }
        }
    }
}