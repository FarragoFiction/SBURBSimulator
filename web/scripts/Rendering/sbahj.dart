import '../handle_sprites.dart';
import 'dart:async';
import 'dart:html';

typedef CanvasGradient Gradient(CanvasRenderingContext2D ctx, num top, num bottom, num left, num right);

abstract class SBAHJGradients {
    static CanvasGradient horizon(CanvasRenderingContext2D ctx, num top, num bottom, num left, num right) {
        return ctx.createLinearGradient(left, top, left, bottom)
            ..addColorStop(0.0,  "#2989CC")
            ..addColorStop(0.5,  "#FFFFFF")
            ..addColorStop(0.52, "#906A00")
            ..addColorStop(0.64, "#D99F00")
            ..addColorStop(1.0,  "#FFFFFF");
    }
}

abstract class SBAHJ {
    static Future<CanvasElement> jpegify(CanvasElement canvas, double quality, [int times = 1]) async {
        CanvasRenderingContext2D ctx = canvas.context2D;

        ImageElement temp = new ImageElement();
        for (int i=0; i<times; i++) {
            temp.src = canvas.toDataUrl("image/jpeg", quality);
            await temp.onLoad.first;
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.drawImage(temp, 0, 0);
        }

        return canvas;
    }
    
    static Future<CanvasElement> _sbahjText(String text, int size, Gradient gradient) async {
        CanvasElement canvas = new CanvasElement();
        CanvasRenderingContext2D ctx = canvas.context2D;

        ctx..font="bold ${size}px 'Comic Sans MS'";
        TextMetrics measurements = ctx.measureText(text);

        int border = 20;

        int top = (size * .9).ceil();
        int left = 0;
        int w = measurements.width.ceil();
        int h = size;

        top += border;
        left += border;
        w += border * 2;
        h += border * 2;

        canvas..width=w..height=h;
        ctx..fillStyle="#FFFFFF"..fillRect(0,0,canvas.width,canvas.height);
        ctx..font="bold ${size}px 'Comic Sans MS'";

        double offset = 3.0;

        ctx..fillStyle="rgba(0,0,0,0.5)"..fillText(text, left+offset, top+offset);

        await jpegify(canvas, 0.25);

        ctx..fillStyle=gradient(ctx, border, h-border, border, w-border)..fillText(text, left, top);

        await jpegify(canvas, 0.25);

        Drawing.sbahjifier(canvas);

        ImageData data = ctx.getImageData(0,0,canvas.width,canvas.height);

        for (int x=0; x<canvas.width; x++) {
            for (int y=0; y<canvas.height; y++) {
                int index = (y * canvas.width + x) * 4;

                if (data.data[index] == 255 && data.data[index+1] == 255 && data.data[index+2] == 255) {
                    data.data[index+3] = 0;
                }
            }
        }

        ctx.clearRect(0, 0, canvas.width, canvas.height);
        ctx.putImageData(data, 0, 0);

        return canvas;
    }

    static Element sbahjText(String text, int size, Gradient gradient) {
        Element container = new DivElement();

        _sbahjText(text, size, gradient).then((CanvasElement canvas) {
            container.append(canvas);
        });

        return container;
    }
}