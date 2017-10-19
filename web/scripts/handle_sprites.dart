import "dart:async";
import "dart:html";
import "dart:math" as Math;

import "SBURBSim.dart";

int asyncNumSprites = 0;
bool cool_kid = false;
bool easter_egg = false;
bool bardQuest = false;
bool ouija = false;
bool faceOff = false;
//~~~~~~~~~~~IMPORTANT~~~~~~~~~~LET NOTHING HERE BE RANDOM
//OR PREDICTIONS AND TIME LOOPS AND AI SEARCHES WILL BE WRONG
//except nepepta, cuz that cat troll be crazy, yo

typedef void PaletteSwapCallback(CanvasElement canvas, Player player);

ImageElement imageSelector(String path) {
    return querySelector("#${escapeId(path)}");
}

abstract class ReferenceColours {
    static Colour WHITE = new Colour.fromHex(0xFFFFFF);
    static Colour BLACK = new Colour.fromHex(0x000000);
    static Colour RED = new Colour.fromHex(0xFF0000);
    static Colour LIME = new Colour.fromHex(0x00FF00);

    static Colour LIME_CORRECTION = new Colour.fromHex(0x00FF2A);

    static Colour GRIM = new Colour.fromHex(0x424242);
    static Colour GREYSKIN = new Colour.fromHex(0xC4C4C4);
    static Colour GRUB = new Colour.fromHex(0x585858);
    static Colour ROBOT = new Colour.fromHex(0xB6B6B6);
    static Colour ECHELADDER = new Colour.fromHex(0x4A92F7);
    static Colour BLOOD_PUDDLE = new Colour.fromHex(0xFFFC00);
    static Colour BLOODY_FACE = new Colour.fromHex(0x440A7F);

    static Colour HAIR = new Colour.fromHex(0x313131);
    static Colour HAIR_ACCESSORY = new Colour.fromHex(0x202020);

    static AspectPalette SPRITE_PALETTE = new AspectPalette()
        ..aspect_light = '#FEFD49'
        ..aspect_dark = '#FEC910'
        ..shoe_light = '#10E0FF'
        ..shoe_dark = '#00A4BB'
        ..cloak_light = '#FA4900'
        ..cloak_mid = '#E94200'
        ..cloak_dark = '#C33700'
        ..shirt_light = '#FF8800'
        ..shirt_dark = '#D66E04'
        ..pants_light = '#E76700'
        ..pants_dark = '#CA5B00';

    static AspectPalette PROSPIT_PALETTE = new AspectPalette()
        ..aspect_light = "#FFFF00"
        ..aspect_dark = "#FFC935"
    // no shoe colours here on purpose
        ..cloak_light = "#FFCC00"
        ..cloak_mid = "#FF9B00"
        ..cloak_dark = "#C66900"
        ..shirt_light = "#FFD91C"
        ..shirt_dark = "#FFE993"
        ..pants_light = "#FFB71C"
        ..pants_dark = "#C67D00";

    static AspectPalette DERSE_PALETTE = new AspectPalette()
        ..aspect_light = "#F092FF"
        ..aspect_dark = "#D456EA"
    // no shoe colours here on purpose
        ..cloak_light = "#C87CFF"
        ..cloak_mid = "#AA00FF"
        ..cloak_dark = "#6900AF"
        ..shirt_light = "#DE00FF"
        ..shirt_dark = "#E760FF"
        ..pants_light = "#B400CC"
        ..pants_dark = "#770E87";

    static AspectPalette ROBOT_PALETTE = new AspectPalette()
        ..aspect_light = "#0000FF"
        ..aspect_dark = "#0022cf"
        ..shoe_light = "#B6B6B6"
        ..shoe_dark = "#A6A6A6"
        ..cloak_light = "#484848"
        ..cloak_mid = "#595959"
        ..cloak_dark = "#313131"
        ..shirt_light = "#B6B6B6"
        ..shirt_dark = "#797979"
        ..pants_light = "#494949"
        ..pants_dark = "#393939";
}

abstract class Drawing {
    //sharpens the image so later pixel swapping doesn't work quite right.
    //https://www.html5rocks.com/en/tutorials/canvas/imagefilters/
    static void sbahjifier(CanvasElement canvas) {
        bool opaque = false;
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        ctx.rotate(getRandomIntNoSeed(0, 10) * Math.PI / 180);
        ImageData pixels = ctx.getImageData(0, 0, canvas.width, canvas.height);
        List<int> weights = <int>[ -1, -1, -1, -1, 9, -1, -1, -1, -1];
        int side = (Math.sqrt(weights.length)).round();
        int halfSide = (side ~/ 2);
        List<int> src = pixels.data;
        int sw = pixels.width;
        int sh = pixels.height;
        // pad output by the convolution matrix
        int w = sw;
        int h = sh;
        ImageData output = ctx.getImageData(0, 0, canvas.width, canvas.height);
        List<int> dst = output.data;
        // go through the destination image pixels
        int alphaFac = opaque ? 1 : 0;
        for (int y = 0; y < h; y++) {
            for (int x = 0; x < w; x++) {
                int sy = y;
                int sx = x;
                int dstOff = (y * w + x) * 4;
                // calculate the weighed sum of the source image pixels that
                // fall under the convolution matrix
                int r = 0,
                    g = 0,
                    b = 0,
                    a = 0;
                for (int cy = 0; cy < side; cy++) {
                    for (int cx = 0; cx < side; cx++) {
                        int scy = sy + cy - halfSide;
                        int scx = sx + cx - halfSide;
                        if (scy >= 0 && scy < sh && scx >= 0 && scx < sw) {
                            int srcOff = (scy * sw + scx) * 4;
                            int wt = weights[cy * side + cx];
                            r += src[srcOff] * wt;
                            g += src[srcOff + 1] * wt;
                            b += src[srcOff + 2] * wt;
                            a += src[srcOff + 3] * wt;
                        }
                    }
                }
                dst[dstOff] = r;
                dst[dstOff + 1] = g;
                dst[dstOff + 2] = b;
                dst[dstOff + 3] = a + alphaFac * (255 - a);
            }
        }
        //sligtly offset each time
        ctx.putImageData(output, getRandomIntNoSeed(0, 10), getRandomIntNoSeed(0, 10));
    }


    //work once again gives me inspiration for this sim. thanks, bob!!!
    static void rainbowSwap(CanvasElement canvas) {
        if (checkSimMode() == true) {
            return;
        }
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        ImageData img_data = ctx.getImageData(0, 0, canvas.width, canvas.height);
        String imageString = "rainbow.png";
        ImageElement img = imageSelector(imageString);
        int width = img.width;
        int height = img.height;

        CanvasElement rainbow_canvas = getBufferCanvas(querySelector("#rainbow_template"));
        CanvasRenderingContext2D rctx = rainbow_canvas.context2D;
        rctx.drawImage(img, 0, 0);
        ImageData img_data_rainbow = rctx.getImageData(0, 0, width, height);

        int i;
        for (int x = 0; x < img_data.width; x++) {
            for (int y = 0; y < img_data.height; y++) {
                i = (y * img_data.width + x) * 4;

                if (img_data.data[i + 3] >= 128) {
                    int rainbow = (y % img_data_rainbow.height) * 4;

                    img_data.data[i] = img_data_rainbow.data[rainbow];
                    img_data.data[i + 1] = img_data_rainbow.data[rainbow + 1];
                    img_data.data[i + 2] = img_data_rainbow.data[rainbow + 2];
                    img_data.data[i + 3] = getRandomIntNoSeed(100, 255); //make it look speckled.

                }
            }
        }
        ctx.putImageData(img_data, 0, 0);
        //ctx.putImageData(img_data_rainbow, 0, 0);
    }


    //how translucent are we talking, here?  number between 0 and 1
    static void voidSwap(CanvasElement canvas, double alphaPercent) {
        if (checkSimMode() == true) {
            return;
        }
        // //print("replacing: " + oldc  + " with " + newc);
        CanvasRenderingContext2D ctx = canvas.context2D;
        ImageData img_data = ctx.getImageData(0, 0, canvas.width, canvas.height);
        //4 byte color array
        for (int i = 0; i < img_data.data.length; i += 4) {
            if (img_data.data[i + 3] > 50) {
                img_data.data[i + 3] = (img_data.data[i + 3] * alphaPercent).floor(); //keeps wings at relative transparency
            }
        }
        ctx.putImageData(img_data, 0, 0);
    }


    //work once again gives me inspiration for this sim. thanks, bob!!!
    static void drainedGhostSwap(CanvasElement canvas) {
        if (checkSimMode() == true) {
            return;
        }
        CanvasRenderingContext2D ctx = canvas.context2D;
        ImageData img_data = ctx.getImageData(0, 0, canvas.width, canvas.height);
        String imageString = "ghostGradient.png";
        ImageElement img = imageSelector(imageString);
        int width = img.width;
        int height = img.height;

        CanvasElement rainbow_canvas = getBufferCanvas(querySelector("#rainbow_template"));
        CanvasRenderingContext2D rctx = rainbow_canvas.context2D;
        rctx.drawImage(img, 0, 0);
        ImageData img_data_rainbow = rctx.getImageData(0, 0, width, height);
        //4 *Math.floor(i/(4000)) is because 1/(width*4) get me the row number (*4 'cause there are 4 elements per pixel). then, when i have the row number, *4 again because first row is 0,1,2,3 and second is 4,5,6,7 and third is 8,9,10,11
        for (int i = 0; i < img_data.data.length; i += 4) {
            if (img_data.data[i + 3] >= 128) {
                img_data.data[i + 3] = img_data_rainbow.data[4 * (i ~/ (4000)) + 3] ~/ 2; //only mimic transparency. even fainter.;

            }
        }
        ctx.putImageData(img_data, 0, 0);
        //ctx.putImageData(img_data_rainbow, 0, 0);
    }


    //work once again gives me inspiration for this sim. thanks, bob!!!
    static void ghostSwap(CanvasElement canvas) {
        if (checkSimMode() == true) {
            return;
        }
        CanvasRenderingContext2D ctx = canvas.context2D;
        ImageData img_data = ctx.getImageData(0, 0, canvas.width, canvas.height);
        String imageString = "ghostGradient.png";
        ImageElement img = imageSelector(imageString);
        int width = img.width;
        int height = img.height;

        CanvasElement rainbow_canvas = getBufferCanvas(querySelector("#rainbow_template"));
        CanvasRenderingContext2D rctx = rainbow_canvas.context2D;
        rctx.drawImage(img, 0, 0);
        ImageData img_data_rainbow = rctx.getImageData(0, 0, width, height);
        //4 *Math.floor(i/(4000)) is because 1/(width*4) get me the row number (*4 'cause there are 4 elements per pixel). then, when i have the row number, *4 again because first row is 0,1,2,3 and second is 4,5,6,7 and third is 8,9,10,11
        for (int i = 0; i < img_data.data.length; i += 4) {
            if (img_data.data[i + 3] >= 128) {
                img_data.data[i + 3] = img_data_rainbow.data[4 * (i ~/ (4000)) + 3] * 2; //only mimic transparency.;

            }
        }
        ctx.putImageData(img_data, 0, 0);
        //ctx.putImageData(img_data_rainbow, 0, 0);
    }


    static void rainbowSwapProgram(CanvasElement canvas) {
        if (checkSimMode() == true) {
            return;
        }
        CanvasRenderingContext2D ctx = canvas.context2D;
        ImageData img_data = ctx.getImageData(0, 0, canvas.width, canvas.height);
        //double colorRatio = 1/canvas.width;
        //4 byte color array
        for (int i = 0; i < img_data.data.length; i += 4) {
            if (img_data.data[i + 3] >= 128) {
                //would some sort of fractal look better here?
                img_data.data[i] = getRandomIntNoSeed(0, 255);
                img_data.data[i + 1] = (i / canvas.width + getRandomIntNoSeed(0, 50)).floor() % 255;
                img_data.data[i + 2] = (i / canvas.height + getRandomIntNoSeed(0, 50)).floor() % 255;
                img_data.data[i + 3] = 255;
            }
        }
        ctx.putImageData(img_data, 0, 0);
    }


    //if speed becomes an issue, take in array of color pairs to swap out
    //rather than call this method once for each color
    //swaps one hex color with another.
    //wait no, would be same amount of things. just would have nested for loops instead of
    //multiple calls
    static void swapColors(CanvasElement canvas, Colour oldc, Colour newc, [int alpha = 255]) {
        if (checkSimMode() == true) {
            return;
        }
        // //print("replacing: " + oldc  + " with " + newc);
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        ImageData img_data = ctx.getImageData(0, 0, canvas.width, canvas.height);
        //4 byte color array
        for (int i = 0; i < img_data.data.length; i += 4) {
            if (img_data.data[i] == oldc[0] && img_data.data[i + 1] == oldc[1] && img_data.data[i + 2] == oldc[2] && img_data.data[i + 3] == 255) {
                img_data.data[i] = newc[0];
                img_data.data[i + 1] = newc[1];
                img_data.data[i + 2] = newc[2];
                img_data.data[i + 3] = alpha;
            }
        }
        ctx.putImageData(img_data, 0, 0);
    }

    static void swapPalette(CanvasElement canvas, Palette source, Palette replacement) {
        if (checkSimMode() == true) {
            return;
        }
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        ImageData img_data = ctx.getImageData(0, 0, canvas.width, canvas.height);

        for (int i = 0; i < img_data.data.length; i += 4) {
            Colour sourceColour = new Colour(img_data.data[i], img_data.data[i + 1], img_data.data[i + 2]);
            for (String name in source.names) {
                if (source[name] == sourceColour) {
                    Colour replacementColour = replacement[name];
                    img_data.data[i] = replacementColour.red;
                    img_data.data[i + 1] = replacementColour.green;
                    img_data.data[i + 2] = replacementColour.blue;
                    break;
                }
            }
        }
        ctx.putImageData(img_data, 0, 0);
    }

    static void grimDarkSkin(CanvasElement canvas) {
        swapColors(canvas, ReferenceColours.WHITE, ReferenceColours.GRIM);
    }

    static void peachSkin(CanvasElement canvas, Player player) {
        int index = player.hair % tricksterColors.length;
        swapColors(canvas, ReferenceColours.WHITE, tricksterColors[index]);
    }

    static void greySkin(CanvasElement canvas) {
        swapColors(canvas, ReferenceColours.WHITE, ReferenceColours.GREYSKIN);
    }

    static void roboSkin(CanvasElement canvas) {
        swapColors(canvas, ReferenceColours.WHITE, ReferenceColours.ROBOT);
    }

    static void wings(CanvasElement canvas, Player player) {
        //blood players have no wings, all other players have wings matching
        //favorite color
        if (!player.aspect.trollWings) {
            //return;  //karkat and kankri don't have wings, but is that standard? or are they just hiding them?
        }

        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        int num = player.quirk.favoriteNumber;
        //int num = 5;
        String imageString = "Wings/wing$num.png";
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0); //,width,height);

        Colour blood = new Colour.fromStyleString(player.bloodColor);
        swapColors(canvas, ReferenceColours.RED, blood);
        swapColors(canvas, ReferenceColours.LIME_CORRECTION, blood, 128);
        swapColors(canvas, ReferenceColours.LIME, blood, 128); //I have NO idea why some browsers render the lime parts of the wing as 00ff00 but whatever.

    }

    static void grimDarkHalo(CanvasElement canvas, Player player) {
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString = "grimdark.png";
        if (player.trickster) {
            imageString = "squiddles_chaos.png";
        }
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
    }

    //TODO, eventually render fin1, then hair, then fin2
    static void fin1(CanvasElement canvas, Player player) {
        if (player.bloodColor == "#610061" || player.bloodColor == "#99004d") {
            CanvasRenderingContext2D ctx = canvas.getContext('2d');
            String imageString = "fin1.png";
            addImageTag(imageString);
            ImageElement img = imageSelector(imageString);
            ctx.drawImage(img, 0, 0);
        }
    }

    static void fin2(CanvasElement canvas, Player player) {
        if (player.bloodColor == "#610061" || player.bloodColor == "#99004d") {
            CanvasRenderingContext2D ctx = canvas.getContext('2d');
            String imageString = "fin2.png";
            addImageTag(imageString);
            ImageElement img = imageSelector(imageString);
            ctx.drawImage(img, 0, 0);
        }
    }

    static void horns(CanvasElement canvas, Player player) {
        leftHorn(canvas, player);
        rightHorn(canvas, player);
    }


    //horns are no longer a sprite sheet. tracy and kristi and brandon gave me advice.
    //position horns on an image as big as the canvas. put the horns directly on the
    //place where the head of every sprite would be.
    //same for wings eventually.
    static void leftHorn(CanvasElement canvas, Player player) {
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString = "Horns/left${player.leftHorn}.png";
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
        ////print("Random number is: " + randNum);
    }

    //parse horns sprite sheet. render a random right horn.
    //right horn should be at: 120,40
    static void rightHorn(CanvasElement canvas, Player player) {
        // //print("doing right horn");
        CanvasRenderingContext2D ctx = canvas.getContext('2d');

        String imageString = "Horns/right${player.rightHorn}.png";
        addImageTag(imageString);

        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
    }

    static void addImageTag(String url) {
        ////print(url);
        //only do it if image hasn't already been added.
        if (imageSelector(url) == null) {
            String tag = '<img id="${escapeId(url)}" src = "images/$url" class="loadedimg">';
            querySelector("#image_staging").appendHtml(tag, treeSanitizer: NodeTreeSanitizer.trusted);
        }
    }


    /* code that implies a different way i could load images. with an async callback to img.onload
    Hrrrm. Problem is that async would mean that things would be rendered in the wrong order.
    could have something that knows when ALL things in a single sprite have been rendered?
    function start_loading_images(ctx, canvas, view);
    {
        ImageElement img = new Image();
        img.onload = () {
            ////print(this);

            x = canvas.width/2 - this.width/2;
            y = canvas.height/2 - this.height/2;
            ctx.drawImage(this, x,y);
            debug_image = this;

            load_more_images(ctx, canvas, view, img.width, img.height);
        }
        img.src = url_for_image(view)+"&center";
    }
    //this one is slighlty more useful. instead of async, just asks if image is loaded or not.
    http://stackoverflow.com/questions/1977871/check-if-an-image-is-loaded-no-errors-in-javascript
    for now i'm okay with just waiting a half second, though.
    function imgLoaded(imgElement) {
      return imgElement.complete && imgElement.naturalHeight !== 0;
    }

    */

    static CanvasElement drawReviveDead(Element div, Player player, Player ghost, Aspect enablingAspect) {
        String canvasId = "${div.id}commune_${player.chatHandle}${ghost.chatHandle}";
        String canvasHTML = "<br><canvas id='$canvasId' width='$canvasWidth' height='$canvasHeight'>  </canvas>";
        appendHtml(div, canvasHTML);
        CanvasElement canvas = querySelector("#$canvasId");
        CanvasElement pSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
        drawSprite(pSpriteBuffer, player);
        CanvasElement gSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
        drawSpriteTurnways(gSpriteBuffer, ghost);

        //CanvasElement canvasBuffer = getBufferCanvas(querySelector("#canvas_template"));

        //leave room on left for possible 'guide' player.
        if (enablingAspect == Aspects.LIFE) {
            drawWhatever(canvas, "afterlife_life.png");
        } else if (enablingAspect == "Doom") {
            drawWhatever(canvas, "afterlife_doom.png");
        }
        copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer, 200, 0);
        copyTmpCanvasToRealCanvasAtPos(canvas, gSpriteBuffer, 500, 0);
        if (enablingAspect ==  Aspects.DOOM) {
            drawWhatever(canvas, "life_res.png");
        } else if (enablingAspect == "Doom") {
            drawWhatever(canvas, "doom_res.png");
        }
        return canvas; //so enabling player can draw themselves on top
    }


    //leader is an adult, though.
    static void poseBabiesAsATeam(CanvasElement canvas, Player leader, List<Player> players, List<Player> guardians) {
        if (checkSimMode() == true) {
            return;
        }
        List<CanvasElement> playerBuffers = <CanvasElement>[];
        List<CanvasElement> guardianBuffers = <CanvasElement>[];
        CanvasElement leaderBuffer = getBufferCanvas(querySelector("#sprite_template"));
        drawSprite(leaderBuffer, leader);
        for (int i = 0; i < players.length; i++) {
            playerBuffers.add(getBufferCanvas(querySelector("#sprite_template")));
            drawBabySprite(playerBuffers[i], players[i]); //,repeatTime);
        }
        for (int i = 0; i < guardians.length; i++) {
            guardianBuffers.add(getBufferCanvas(querySelector("#sprite_template")));
            drawBabySprite(guardianBuffers[i], guardians[i]); //,repeatTime);
        }
        //leader on far left, babies arranged to right.
        copyTmpCanvasToRealCanvasAtPos(canvas, leaderBuffer, -100, 0);
        //max of 24 babies take a LOT of render time. allow just this one thing to be async.
        new Timer(new Duration(seconds: 1), () {
            int x = 50;
            int y = 0;
            //int total = 0;
            for (int i = 0; i < playerBuffers.length; i++) {
                if (i == 6) {
                    x = 50; //down a row
                    y = 75;
                }
                x = x + 100;
                copyTmpCanvasToRealCanvasAtPos(canvas, playerBuffers[i], x, y);
            }
            //guardians down a bit
            x = 50;
            y += 100;
            for (int i = 0; i < guardianBuffers.length; i++) {
                if (i == 6) {
                    x = 50; //down a row
                    y += 75;
                }
                x = x + 100;
                copyTmpCanvasToRealCanvasAtPos(canvas, guardianBuffers[i], x, y);
            }
        });
    }


    //might be repeats of players in there, cause of time clones
    static void poseAsATeam(CanvasElement canvas, List<Player> players) {
        if (checkSimMode() == true) {
            return;
        }
        List<CanvasElement> spriteBuffers = <CanvasElement>[];
        int startXpt = -235;
        for (int i = 0; i < players.length; i++) {
            spriteBuffers.add(getBufferCanvas(querySelector("#sprite_template")));
            drawSprite(spriteBuffers[i], players[i]);
        }

        int x = startXpt; //-275 cuts of left most part.
        int y = 0;
        //int total = 0;
        for (int i = 0; i < spriteBuffers.length; i++) {
            if (i == 6) {
                x = startXpt; //down a row
                y = 100;
            } else if (i == 12) { //could be more than 12 cause time shenanigans.
                x = startXpt; //down a row
                y = 300;
            }
            x = x + 150;
            copyTmpCanvasToRealCanvasAtPos(canvas, spriteBuffers[i], x, y);
        }
    }

    ///revives the player mid drawing because that is how the rendering works.
    static void drawCorpseSmooch(CanvasElement canvas, Player dead_player, Player royalty){
        var pSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
        Drawing.drawSprite(pSpriteBuffer,royalty);

        dead_player.dead = true;
        dead_player.isDreamSelf = false;  //temporarily show non dream version
        var dSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
        Drawing.drawSpriteFromScratch(dSpriteBuffer,dead_player);

        Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,0,0);
        Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, dSpriteBuffer,200,0);

        var moonBuffer = Drawing.getBufferCanvas(querySelector("#canvas_template"));
        Drawing.drawMoon(moonBuffer, dead_player);
        dead_player.dreamSelf = false; //only one self now.
        dead_player.isDreamSelf = true;
        dead_player.makeAlive();
        Drawing.drawSprite(moonBuffer,dead_player);
        Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, moonBuffer,600,0);
    }


    static void drawGodRevival(CanvasElement canvas, List<Player> live_players, List<Player> dead_players) {
        if (checkSimMode() == true) {
            return;
        }
        List<CanvasElement> live_spriteBuffers = <CanvasElement>[];
        List<CanvasElement> dead_spriteBuffers = <CanvasElement>[];
        for (int i = 0; i < live_players.length; i++) {
            live_spriteBuffers.add(getBufferCanvas(querySelector("#sprite_template")));
            drawSprite(live_spriteBuffers[i], live_players[i]);
        }

        for (int i = 0; i < dead_players.length; i++) {
            dead_spriteBuffers.add(getBufferCanvas(querySelector("#sprite_template")));
            //drawBG(dead_spriteBuffers[i], "#00ff00", "#ff0000");
            drawWhatever(dead_spriteBuffers[i], dead_players[i].aspect.bigSymbolImgLocation);
            drawSprite(dead_spriteBuffers[i], dead_players[i]);
        }

        int x = -275;
        int y = -50;
        int total = 0;
        for (int i = 0; i < live_spriteBuffers.length; i++) {
            if (i == 6) {
                x = -300; //down a row
                y = 100;
            }
            x = x + 150;
            copyTmpCanvasToRealCanvasAtPos(canvas, live_spriteBuffers[i], x, y);
        }
        total += live_spriteBuffers.length;
        rainbowSwap(canvas);
        //render again, but offset, makes rainbow an aura
        x = -260;
        y = -35;
        for (int i = 0; i < live_spriteBuffers.length; i++) {
            if (i == 6) {
                x = -285; //down a row
                y = 85;
            }
            x = x + 150;
            copyTmpCanvasToRealCanvasAtPos(canvas, live_spriteBuffers[i], x, y);
        }
        y += 50; //dead players need to be rendered higher.
        for (int i = 0; i < dead_spriteBuffers.length; i++) {
            if (total == 6) {
                x = -300; //down a row
                y += 120;
            }
            x = x + 150;
            copyTmpCanvasToRealCanvasAtPos(canvas, dead_spriteBuffers[i], x, y);
            total ++;
        }
    }


    //should only be used at the end, draws the player and their stats.
    static void drawCharSheet(CanvasElement canvas, Player player) {
        if (checkSimMode() == true) {
            return;
        }
        drawSinglePlayer(canvas, player);
        drawWhatever(canvas, "charSheet.png");
        //int space_between_lines = 25;
        int left_margin = 100;
        int right_margin = 300;
        int line_height = 24;
        //int start = 30;
        int current = 275;

        CanvasRenderingContext2D ctx = canvas.getContext("2d");
        //title
        ctx.font = "42px Times New Roman";
        ctx.fillStyle = "#000000";
        ctx.fillText(player.titleBasic(), left_margin + 1, current + 1);
        ctx.fillStyle = player.aspect.palette.text.toStyleString();
        ctx.fillText(player.titleBasic(), left_margin, current);
        ctx.font = "24px Times New Roman";
        ctx.fillText("(${player.chatHandle})", left_margin, current + 42);

        left_margin = 10;
        current = current + 42 + 42;
        ctx.fillStyle = "#000000";
        Iterable<Stat> allStats = Stats.all.where((Stat stat) => stat.summarise && !stat.transient);
        int i=0;
        for (Stat stat in allStats) {
            ctx.fillText("$stat: ", left_margin, current + line_height * i);
            ctx.fillText(player.getStat(stat).round().toString(), right_margin, current + line_height * i);
            i++;
        }

        ctx.fillText("Land Rep: ", left_margin, current + line_height * i);
        ctx.fillText(player.landLevel.toString(), right_margin, current + line_height * i);
        i++;

        ctx.fillText("Grist Collected: ", left_margin, current + line_height * i);
        ctx.fillText(player.grist.toString(), right_margin, current + line_height * i);
        i++;

        ctx.fillText("Former Friends Killed: ", left_margin, current + line_height * i);
        ctx.fillText(player.pvpKillCount.toString(), right_margin, current + line_height * i);
        i++;
        ctx.fillText("Fraymotifs Unlocked: ", left_margin, current + line_height * i);
        ctx.fillText(player.fraymotifs.length.toString(), right_margin, current + line_height * i);
        i++;
        ctx.fillText("Grim Dark Level: ", left_margin, current + line_height * i);
        ctx.fillText("${player.grimDark}/4", right_margin, current + line_height * i);

        i++;
        ctx.fillText("Gnosis Level: ", left_margin, current + line_height * i);
        ctx.fillText("${player.gnosis}/4", right_margin, current + line_height * i);


        i++;
        ctx.fillText("Doomed Clones: ", left_margin, current + line_height * i);
        ctx.fillText(player.doomedTimeClones.length.toString(), right_margin, current + line_height * i);

        i++;
        ctx.fillText("Prophecy Status: ", left_margin, current + line_height * i);
        //can't just print out the value of the enum, too dumb for that.
        ctx.fillText("${player.prophecy.toString().substring(player.prophecy.toString().indexOf('.')+1)}", right_margin-50, current + line_height * i);

        i++;
        ctx.fillText("Times Died: ", left_margin, current + line_height * i);
        ctx.fillText(player.timesDied.toString(), right_margin, current + line_height * i);

        if (player.dead) {
            i++;
            i++;
            ctx.fillText("Final Cause of Death: ", left_margin, current + line_height * i);
            i++;
            i++;
            wrap_text(ctx, player.causeOfDeath, 10, current + line_height * i, line_height, 300, "left");
        }
    }


    static void drawGetTiger(CanvasElement canvas, List<Player> players) {
        if (checkSimMode() == true) {
            return;
        }
        List<CanvasElement> spriteBuffers = <CanvasElement>[];
        for (int i = 0; i < players.length; i++) {
            spriteBuffers.add(getBufferCanvas(querySelector("#sprite_template")));
            drawSprite(spriteBuffers[i], players[i]);
        }

        int x = -275;
        int y = -50;

        for (int i = 0; i < spriteBuffers.length; i++) {
            if (i == 6) {
                x = -300; //down a row
                y = 100;
            }
            x = x + 150;
            copyTmpCanvasToRealCanvasAtPos(canvas, spriteBuffers[i], x, y);
        }
        rainbowSwap(canvas);

        //render again, but offset, makes rainbow an aura
        x = -260;
        y = -35;
        for (int i = 0; i < spriteBuffers.length; i++) {
            if (i == 6) {
                x = -285; //down a row
                y = 85;
            }
            x = x + 150;
            copyTmpCanvasToRealCanvasAtPos(canvas, spriteBuffers[i], x, y);
        }
    }


    //player on left, echeladder on right. text with boonies. all levels listed
    //obtained levels have a colored background, others have black.
    static void drawLevelUp(CanvasElement canvas, Player player) {
        if (checkSimMode() == true) {
            return;
        }
        if (player.godTier) {
            ////print("god tier");
            drawLevelUpGodTier(canvas, player);
            return;
        }
        //for echeladder
        CanvasElement canvasSpriteBuffer = getBufferCanvas(querySelector("#canvas_template"));
        CanvasRenderingContext2D ctx = canvasSpriteBuffer.getContext('2d');
        String imageString = "echeladder.png";
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0,);
        swapColors(canvasSpriteBuffer, ReferenceColours.ECHELADDER, player.aspect.palette.text);
        //set fill before you start, don't set it in the for loop, expensive
        ctx.fillStyle = "#000000";
        for (int i = 0; i < level_bg_colors.length; i++) {
            if (player.level_index < i) {
                //swapColors(canvasSpriteBuffer, level_bg_colors[i], "#000000" ); //black out levels i don't yet have
                //x,y,width,height
                ctx.fillRect(5, 300 - (21 + (17) * i), 192, 15); //2 pixels between boxes (which are 16 big), starts at 17, y 0 is bottom.
            }
        }

        CanvasElement pSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
        if (player.dead) {
            drawSprite(pSpriteBuffer, player);
        } else {
            drawSprite(pSpriteBuffer, player);
        }

        CanvasElement levelsBuffer = getBufferCanvas(querySelector("#echeladder_template"));
        writeLevels(levelsBuffer, player); //level_bg_colors,level_font_colors

        copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer, 0, 0);
        copyTmpCanvasToRealCanvasAtPos(canvas, canvasSpriteBuffer, 350, 0);
        copyTmpCanvasToRealCanvasAtPos(canvas, levelsBuffer, 350, 0);
    }


    //player in center, on platform, level name underneath them. aspect symbol behind them.
    //bg color is shirt color
    static void drawLevelUpGodTier(CanvasElement canvas, Player player) {
        if (checkSimMode() == true) {
            return;
        }

        int leftMargin = 150;
        CanvasElement levelBuffer = getBufferCanvas(querySelector("#godtierlevelup_template"));
        drawBGRadialWithWidth(canvas, leftMargin, 650, 650, ReferenceColours.BLACK, player.aspect.palette.shirt_light); //650 is iold


        CanvasElement symbolBuffer = getBufferCanvas(querySelector("#sprite_template"));
        drawGodSymbolBG(symbolBuffer, player);

        CanvasElement godBuffer = getBufferCanvas(querySelector("#godtierlevelup_template"));
        CanvasRenderingContext2D ctx = godBuffer.getContext('2d');
        String imageString = "godtierlevelup.png";
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);

        CanvasElement pSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
        if (player.dead) {
            drawSprite(pSpriteBuffer, player);
        } else {
            drawSprite(pSpriteBuffer, player);
        }


        //drawBG(levelBuffer, "#ff0000", "#00ff00");
        writeLevelGod(levelBuffer, player);


        copyTmpCanvasToRealCanvasAtPos(canvas, symbolBuffer, leftMargin + 45, 0);
        copyTmpCanvasToRealCanvasAtPos(canvas, godBuffer, leftMargin + 100, 0);
        copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer, leftMargin + 100, 0);
        copyTmpCanvasToRealCanvasAtPos(canvas, levelBuffer, leftMargin + -200, 290); //265 is perfectly lined on rainbow //300 is a little too far down.
    }

    static void drawEpicGodShit(CanvasElement canvas, Player player) {
        if (checkSimMode() == true) {
            return;
        }
        int leftMargin = 150;
        CanvasElement codeBufer = getBufferCanvas(querySelector("#godtierlevelup_template"));
        drawWhatever(codeBufer, "cataclysm.png");
        swapColors(codeBufer, ReferenceColours.BLACK, player.aspect.palette.shirt_light);


        CanvasElement colorBufferBuffer = getBufferCanvas(querySelector("#godtierlevelup_template"));
        //intent is code shows up behind them, in their shirt + aspect colors.
        drawSolidBG(colorBufferBuffer,  player.aspect.palette.aspect_light); //650 is iold
        //cataclysm

        CanvasElement rainbowSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
        drawSprite(rainbowSpriteBuffer, player);
        rainbowSwap(rainbowSpriteBuffer);
        CanvasElement pSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
        drawSprite(pSpriteBuffer,player);

        copyTmpCanvasToRealCanvasAtPos(canvas, colorBufferBuffer, 0, 0);
        copyTmpCanvasToRealCanvasAtPos(canvas, codeBufer,  0, 0); //265 is perfectly lined on rainbow //300 is a little too far down.
        copyTmpCanvasToRealCanvasAtPos(canvas, rainbowSpriteBuffer, leftMargin + 90, -10);
        copyTmpCanvasToRealCanvasAtPos(canvas, rainbowSpriteBuffer, leftMargin + 110, 10);
        copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer, leftMargin + 100, 10);

    }


    static void drawGodSymbolBG(CanvasElement canvas, Player player) {
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString = player.aspect.bigSymbolImgLocation;
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
    }


    //true random position
    static void drawWhateverTerezi(CanvasElement canvas, String imageString) {
        if (checkSimMode() == true) {
            return;
        }
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        //	//  //all true random
        int x = getRandomIntNoSeed(0, 50);
        int y = getRandomIntNoSeed(0, 50);
        if (random() > .5) x = x * -1;
        if (random() > .5) y = y * -1;
        ctx.drawImage(img, x, y);
    }


    static void drawWhateverTurnways(CanvasElement canvas, String imageString) {
        if (checkSimMode() == true) {
            return;
        }
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        ctx.imageSmoothingEnabled = false; //should get rid of orange halo in certain browsers.
        ctx.translate(canvas.width, 0);
        ctx.scale(-1, 1);
        drawWhatever(canvas, imageString);
    }


    static void drawWhateverWithPalleteSwapCallback(CanvasElement canvas, String str, Player player, PaletteSwapCallback palleteSwapCallBack) {
        CanvasElement temp = getBufferCanvas(canvas);

        drawWhatever(temp, str);
        ////print("drawing whatever with pallete swap of $palleteSwapCallBack");
        palleteSwapCallBack(temp, player); //regular, trickster, robo, whatever.
        canvas.context2D.drawImage(temp, 0,0);
    }

    //have i really been too lazy to make this until now
    static void drawWhatever(CanvasElement canvas, String imageString) {
        if (checkSimMode() == true) {
            return;
        }
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        if (img == null) {
            //print("img was null!");
            //print("was looking for ${escapeId(imageString)}");
        }
        ctx.drawImage(img, 0, 0);
    }


    static void drawDreamBubble(CanvasElement canvas) {
        if (checkSimMode() == true) {
            return;
        }
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString = "dreambubbles.png";
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
    }


    static void drawHorrorterror(CanvasElement canvas) {
        if (checkSimMode() == true) {
            return;
        }
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString = "horrorterror.png";
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
    }


    static void drawMoon(CanvasElement canvas, Player player) {
        if (checkSimMode() == true) {
            return;
        }
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString = "${player.moon}.png";
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
    }


    static void writeLevelGod(CanvasElement canvas, Player player) {
        //int left_margin = 0; //center
        CanvasRenderingContext2D ctx = canvas.getContext("2d");
        ctx.textAlign = "center";
        ctx.font = "bold 32px Times New Roman";
        ctx.fillStyle = "#000000";
        ctx.fillText(player.mylevels[player.level_index], canvas.width / 2, 32);
        ctx.fillStyle = ReferenceColours.WHITE.toStyleString();
        ctx.fillText(player.mylevels[player.level_index], canvas.width / 2 + 1, 32); //shadow
    }


    //no image, so no repeat needed.
    static void writeLevels(CanvasElement canvas, Player player) {
        int left_margin = 101; //center
        double line_height = 17.0;
        int start = 289; //start at bottom, go up
        double current = start.toDouble();
        CanvasRenderingContext2D ctx = canvas.getContext("2d");
        ctx.textAlign = "center";
        ctx.font = "bold 12px Courier New";
        ctx.fillStyle = ReferenceColours.WHITE.toStyleString();

        for (int i = 0; i < player.mylevels.length; i++) {
            if (player.level_index + 1 > i) {
                ctx.fillStyle = level_font_colors[i];
            } else {
                ctx.fillStyle = ReferenceColours.WHITE.toStyleString();
            }
            ctx.fillText(player.mylevels[i], left_margin, current);
            current = current - line_height;
        }
    }


    static void drawRelationshipChat(CanvasElement canvas, Player player1, Player player2, String chat) {
        if (checkSimMode() == true) {
            return;
        }
        CanvasElement canvasSpriteBuffer = getBufferCanvas(querySelector("#canvas_template"));
        CanvasRenderingContext2D ctx = canvasSpriteBuffer.getContext('2d');
        String imageString = "pesterchum.png";
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);

        CanvasElement p1SpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
        drawSprite(p1SpriteBuffer, player1);

        CanvasElement p2SpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
        drawSpriteTurnways(p2SpriteBuffer, player2);

        //don't need buffer for text?
        CanvasElement textSpriteBuffer = getBufferCanvas(querySelector("#chat_text_template"));
        String introText = "-- ${player1.chatHandle} [${player1.chatHandleShort()}] began pestering ";
        introText = "$introText${player2.chatHandle} [${player2.chatHandleShort()}] --";
        drawChatText(textSpriteBuffer, player1, player2, introText, chat);

        //heart or spades (moirallegence doesn't get confessed, it's more actiony)  spades is trolls only


        Relationship r1 = player1.getRelationshipWith(player2);
        Relationship r2 = player2.getRelationshipWith(player1);
        CanvasElement r1SpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
        CanvasElement r2SpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));

        if (r1.saved_type == r1.goodBig || r1.saved_type == r1.heart) {
            drawHeart(r1SpriteBuffer);
        } else if (r1.saved_type == r1.badBig || r1.saved_type == r1.spades) {
            drawSpade(r1SpriteBuffer);
        }

        if (r2.saved_type == r2.goodBig || r2.saved_type == r2.heart) {
            drawHeart(r2SpriteBuffer);
        } else if (r2.saved_type == r2.badBig || r2.saved_type == r2.spades) {
            drawSpade(r2SpriteBuffer);
        }


        //drawBG(textSpriteBuffer, "#ff9999", "#ff00ff") //test that it's actually being rendered.
        //p1 on left, chat in middle, p2 on right and flipped turnways.
        copyTmpCanvasToRealCanvasAtPos(canvas, r1SpriteBuffer, 0, 0);
        copyTmpCanvasToRealCanvasAtPos(canvas, r2SpriteBuffer, 750, 0);
        copyTmpCanvasToRealCanvasAtPos(canvas, p1SpriteBuffer, -100, 0);
        copyTmpCanvasToRealCanvasAtPos(canvas, p2SpriteBuffer, 650, 0); //where should i put this?
        copyTmpCanvasToRealCanvasAtPos(canvas, canvasSpriteBuffer, 230, 0);
        copyTmpCanvasToRealCanvasAtPos(canvas, textSpriteBuffer, 244, 51);
    }


    static bool checkSimMode() {
        //return true; // debugging, is loading the problem, or is this method?
        if (doNotRender == true) {
            //looking for rare sessions, or getting moon prophecies.
            //  //print("no canvas, are we simulatating the simulation?");
            return true;
        }
        return false;
    }


    static void drawChatJRPlayer(CanvasElement canvas, String chat, Player player) {
        if (checkSimMode() == true) {
            return;
        }

        CanvasElement canvasSpriteBuffer = getBufferCanvas(querySelector("#canvas_template"));
        CanvasRenderingContext2D ctx = canvasSpriteBuffer.getContext('2d');
        String imageString = "pesterchum.png";
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        if (img == null) {
            //print("img was null!");
            //print("was looking for ${escapeId(imageString)}");
        }
        ctx.drawImage(img, 0, 0);

        CanvasElement jrSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
        drawJR(jrSpriteBuffer);

        CanvasElement pSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
        drawSpriteTurnways(pSpriteBuffer, player);

        CanvasElement textSpriteBuffer = getBufferCanvas(querySelector("#chat_text_template"));
        String introText = "-- jadedResearcher [JR] began pestering ";
        introText = "$introText${player.chatHandle} [${player.chatHandleShort()}] --";
        drawChatTextJRPlayer(textSpriteBuffer, introText, chat, player);


        copyTmpCanvasToRealCanvasAtPos(canvas, jrSpriteBuffer, 0, 0);
        copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer, 650, 0); //where should i put this?
        copyTmpCanvasToRealCanvasAtPos(canvas, canvasSpriteBuffer, 230, 0);
        copyTmpCanvasToRealCanvasAtPos(canvas, textSpriteBuffer, 244, 51);
    }


    //she is the best <3
    static void drawChatABJR(CanvasElement canvas, String chat) {
        if (checkSimMode() == true) {
            return;
        }
        drawChatNonPlayer(canvas, chat, "-- authorBot [AB] began pestering jadedResearcher" + " [JR] --", "ab.png", "jr.png", "AB:", "JR:", "#ff0000", "#3da35a");
    }


    static void drawChatJRAB(CanvasElement canvas, String chat) {
        if (checkSimMode() == true) {
            return;
        }
        drawChatNonPlayer(canvas, chat, "-- jadedResearcher [JR] began pestering authorBot" + " [AB] --", "jr.png", "ab.png", "JR:", "AB:", "#3da35a", "#ff0000");
    }


    //drawChatTextNonPlayer canvas, introText, chat, player1Start, player2Start, player1Color, player2Color
    //could be spadeslick talking to one of his crew,  could be an easter egg recursiveSlacker
    static void drawChatNonPlayer(CanvasElement canvas, String chat, String introText, String player1PNG, String player2PNG, String player1Start, String player2Start, String player1Color, String player2Color) {
        if (checkSimMode() == true) {
            return;
        }
        CanvasElement canvasSpriteBuffer = getBufferCanvas(querySelector("#canvas_template"));
        CanvasRenderingContext2D ctx = canvasSpriteBuffer.getContext('2d');
        String imageString = "pesterchum.png";
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        if (img == null) {
            //print("img was null!");
            //print("was looking for ${escapeId(imageString)}");
        }
        ctx.drawImage(img, 0, 0);

        CanvasElement p2SpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
        drawWhateverTurnways(p2SpriteBuffer, player2PNG);

        CanvasElement p1SpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
        drawWhatever(p1SpriteBuffer, player1PNG);
        //don't need buffer for text?
        CanvasElement textSpriteBuffer = getBufferCanvas(querySelector("#chat_text_template"));
        drawChatTextNonPlayer(textSpriteBuffer, introText, chat, player1Start, player2Start, player1Color, player2Color);
        //drawBG(textSpriteBuffer, "#ff9999", "#ff00ff") //test that it's actually being rendered.
        //p1 on left, chat in middle, p2 on right and flipped turnways.
        copyTmpCanvasToRealCanvasAtPos(canvas, p1SpriteBuffer, 0, 0);
        copyTmpCanvasToRealCanvasAtPos(canvas, p2SpriteBuffer, 530, 0); //where should i put this?
        copyTmpCanvasToRealCanvasAtPos(canvas, canvasSpriteBuffer, 230, 0);
        copyTmpCanvasToRealCanvasAtPos(canvas, textSpriteBuffer, 244, 51);
    }


    //hella simple, mostly gonna be used for corpses.
    static void drawSinglePlayer(CanvasElement canvas, Player player) {
        CanvasElement p1SpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
        drawSprite(p1SpriteBuffer, player);
        //drawBG(p1SpriteBuffer, "#ff9999", "#ff00ff");
        copyTmpCanvasToRealCanvasAtPos(canvas, p1SpriteBuffer, 0, 0);
    }


    //need to parse the text to figure out who is talking to determine color for chat.
    static void drawChat(CanvasElement canvas, Player player1, Player player2, String chat, String topicImage) {
        if (checkSimMode() == true) {
            return;
        }
        //debug("drawing chat");
        //draw sprites to buffer (don't want them pallete swapping each other)
        //then to main canvas
        CanvasElement canvasSpriteBuffer = getBufferCanvas(querySelector("#canvas_template"));
        CanvasRenderingContext2D ctx = canvasSpriteBuffer.getContext('2d');
        String imageString = "pesterchum.png";
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);

        CanvasElement p1SpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
        drawSprite(p1SpriteBuffer, player1);

        CanvasElement p2SpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
        drawSpriteTurnways(p2SpriteBuffer, player2);

        //don't need buffer for text?
        CanvasElement textSpriteBuffer = getBufferCanvas(querySelector("#chat_text_template"));
        String introText = "-- ${player1.chatHandle} [${player1.chatHandleShort()}] began pestering ";
        introText = "$introText${player2.chatHandle} [${player2.chatHandleShort()}] --";
        drawChatText(textSpriteBuffer, player1, player2, introText, chat);
        //drawBG(textSpriteBuffer, "#ff9999", "#ff00ff") //test that it's actually being rendered.
        //p1 on left, chat in middle, p2 on right and flipped turnways.
        copyTmpCanvasToRealCanvasAtPos(canvas, p1SpriteBuffer, -100, 0);
        copyTmpCanvasToRealCanvasAtPos(canvas, p2SpriteBuffer, 650, 0); //where should i put this?
        copyTmpCanvasToRealCanvasAtPos(canvas, canvasSpriteBuffer, 230, 0);
        copyTmpCanvasToRealCanvasAtPos(canvas, textSpriteBuffer, 244, 51);

        if (topicImage != null) {
            CanvasElement topicBuffer = getBufferCanvas(querySelector("#canvas_template"));
            drawTopic(topicBuffer, topicImage);
            copyTmpCanvasToRealCanvasAtPos(canvas, topicBuffer, 0, 0);
        }
    }


    static void drawAb(CanvasElement canvas) {
        if (checkSimMode() == true) {
            return;
        }
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString = "ab.png";
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
    }


    static void drawJR(CanvasElement canvas, [CanvasRenderingContext2D ctx = null]) {
        if (checkSimMode() == true) {
            return;
        }
        if (ctx == null) {
            ctx = canvas.context2D;
        }
        String imageString = "jr.png";
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
    }


    static void drawJRTurnways(CanvasElement canvas) {
        if (checkSimMode() == true) {
            return;
        }
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        ctx.imageSmoothingEnabled = false; //should get rid of orange halo in certain browsers.
        ctx.translate(canvas.width, 0);
        ctx.scale(-1, 1);
        drawJR(canvas, ctx);
    }


    static void drawTopic(CanvasElement canvas, String topicImage) {
        if (checkSimMode() == true) {
            return;
        }
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString = topicImage;
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
    }


    @deprecated
    static void drawComboText(CanvasElement canvas, int comboNum) {
        //alert(comboNum + "x CORPSESMOOCH COMBO!!!");
        CanvasRenderingContext2D ctx = canvas.getContext("2d");
        ctx.font = "14px Courier New Bold";
        //i wish the below two lines would disable anti-aliasing for the font.
        //then it could be the homestuck font :/
        ctx.imageSmoothingEnabled = false;
        ctx.scale(4, 4);
        ctx.fillStyle = "#ff0000"; //bright candy red (most common blood color)
        String excite = "";
        for (int i = 0; i < comboNum; i++) {
            excite = "$excite!";
        }
        ctx.fillText("${comboNum}x CORPSESMOOCH COMBO$excite", 20, 20);
    }


    static void drawChatTextJRPlayer(CanvasElement canvas, String introText, String chat, Player player) {
        //int space_between_lines = 25;
        int left_margin = 8;
        int line_height = 18;
        //int start = 18;
        int current = 18;
        CanvasRenderingContext2D ctx = canvas.getContext("2d");
        ctx.font = "12px Times New Roman";
        if (player.sbahj) {
            ctx.font = "12px Comic Sans MS";
        }
        ctx.fillStyle = "#000000";
        ctx.fillText(introText, left_margin * 2, current);
        //need custom multi line method that allows for differnet color lines
        fillChatTextMultiLineJRPlayer(canvas, chat, player, left_margin, current + line_height * 2);
    }


    static void drawChatTextNonPlayer(CanvasElement canvas, String introText, String chat, String player1Start, String player2Start, String player1Color, String player2Color) {
        //int space_between_lines = 25;
        int left_margin = 8;
        int line_height = 18;
        //int start = 18;
        int current = 18;
        CanvasRenderingContext2D ctx = canvas.getContext("2d");
        ctx.font = "12px Times New Roman";
        ctx.fillStyle = "#000000";
        ctx.fillText(introText, left_margin * 2, current);
        //need custom multi line method that allows for differnet color lines  fillChatTextMultiLineNonPlayer(canvas, chat, x,y,player1Start, player2Start, player1Color, player2Color);
        fillChatTextMultiLineNonPlayer(canvas, chat, left_margin, current + line_height * 2, player1Start, player2Start, player1Color, player2Color);
    }


    static void drawChatText(CanvasElement canvas, Player player1, Player player2, String introText, String chat) {
        //int space_between_lines = 25;
        int left_margin = 8;
        int line_height = 18;
        //int start = 18;
        int current = 18;
        CanvasRenderingContext2D ctx = canvas.getContext("2d");
        ctx.font = "12px Times New Roman";
        if (player1.sbahj) {
            ctx.font = "12px Comic Sans MS";
        }
        ctx.fillStyle = "#000000";
        ctx.fillText(introText, left_margin * 2, current);
        //need custom multi line method that allows for differnet color lines
        fillChatTextMultiLine(canvas, chat, player1, player2, left_margin, current + line_height * 2);
    }


    static void drawSolidBG(CanvasElement canvas, Colour color) {
        CanvasRenderingContext2D ctx = canvas.getContext("2d");
        ctx.fillStyle = color.toStyleString();
        ctx.fillRect(0, 0, canvas.width, canvas.height);
    }


    static void drawBG(CanvasElement canvas, Colour color1, Colour color2) {
        CanvasRenderingContext2D ctx = canvas.getContext("2d");

        CanvasGradient grd = ctx.createLinearGradient(0, 0, 170, 0);
        grd.addColorStop(0, color1.toStyleString());
        grd.addColorStop(1, color2.toStyleString());

        ctx.fillStyle = grd;
        ctx.fillRect(0, 0, canvas.width, canvas.height);
    }


    static void drawBGRadialWithWidth(CanvasElement canvas, num startX, num endX, num width, Colour color1, Colour color2) {
        CanvasRenderingContext2D ctx = canvas.getContext("2d");

        CanvasGradient grd = ctx.createRadialGradient(width / 2, canvas.height / 2, 5, width, canvas.height, width);
        grd.addColorStop(0, color1.toStyleString());
        grd.addColorStop(1, color2.toStyleString());

        ctx.fillStyle = grd;
        ctx.fillRect(startX, 0, endX, canvas.height);
    }


    static void denizenKill(CanvasElement canvas, Player player) {
        if (checkSimMode() == true) {
            return;
        }
        CanvasElement p1SpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
        //drawBG(p1SpriteBuffer, "#ff9999", "#ff00ff");
        CanvasRenderingContext2D ctx = p1SpriteBuffer.getContext('2d');
        //  drawBG(p1SpriteBuffer, "#ff9999", "#ff00ff");
        //  ctx.translate(canvas.width, 0);
        //ctx.rotate(90*Math.PI/180);
        String imageString = "denizoned.png";
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0); //why can't i use a buffer, it's not showing up..
        copyTmpCanvasToRealCanvasAtPos(canvas, p1SpriteBuffer, 0, 0); //why is it so far right???

    }


    static void stabs(CanvasElement canvas, Player player) {
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString = "stab.png";
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
        swapColors(canvas, ReferenceColours.BLOOD_PUDDLE, new Colour.fromStyleString(player.bloodColor));
    }


    static void kingDeath(CanvasElement canvas, Player player) {
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString = "sceptre.png";
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
        swapColors(canvas, ReferenceColours.BLOOD_PUDDLE, new Colour.fromStyleString(player.bloodColor));
    }


    static void bloodPuddle(CanvasElement canvas, Player player) {
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString = "blood_puddle.png";
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
        swapColors(canvas, ReferenceColours.BLOOD_PUDDLE, new Colour.fromStyleString(player.bloodColor));
    }


    static void drawSpriteTurnways(CanvasElement canvas, Player player) {
        if (checkSimMode() == true) {
            return;
        }

        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        ctx.imageSmoothingEnabled = false; //should get rid of orange halo in certain browsers.
        ctx.translate(canvas.width, 0);
        ctx.scale(-1, 1);
        drawSprite(canvas, player, ctx);
    }


    static void drawBabySprite(CanvasElement canvas, Player player) {
        if (checkSimMode() == true) {
            return;
        }
        player = Player.makeRenderingSnapshot(player); //probably dont need to, but whatever
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        ctx.imageSmoothingEnabled = false;
        //don't forget to shrink baby
        ctx.scale(0.5, 0.5);

        drawSpriteFromScratch(canvas, player, ctx, true);
    }


    //baby and turnways call this. will it work?
    static void drawSprite(CanvasElement canvas, Player inputplayer, [CanvasRenderingContext2D ctx = null, bool baby = false]) {
        if (checkSimMode() == true) {
            return;
        }

        if (ctx == null) {
            ctx = canvas.context2D;
        }
        Player player = Player.makeRenderingSnapshot(inputplayer);
        if (player.ghost || player.doomed) { //don't expect ghosts or doomed players to render more than a time or two, don't bother caching for now.
            ////print("drawing ghost or doomed player from scratch: " + player);
            drawSpriteFromScratch(canvas, player, ctx, false);
        } else {
            CanvasElement canvasDiv = querySelector("#${player.spriteCanvasID}");
            //also take care of face scratches and mind control symbols.
            copyTmpCanvasToRealCanvasAtPos(canvas, canvasDiv, 0, 0);
        }

        if (!baby && player.influenceSymbol != null) { //dont make sprite for this, always on top, unlike scars
            //wasteOfMindSymbol(canvas, player);
            influenceSymbol(canvas, player.influenceSymbol);
        }

        if (cool_kid) {
            drawWhateverTerezi(canvas, "/Bodies/coolk1dlogo.png");
            drawWhateverTerezi(canvas, "/Bodies/coolk1dsword.png");
            drawWhateverTerezi(canvas, "/Bodies/coolk1dshades.png");
        }
    }


    static void drawSpriteFromScratch(CanvasElement canvas, Player player, [CanvasRenderingContext2D ctx = null, bool baby = false]) {
        ////print("Drawing sprite from scratch " + player.isDreamSelf);
        if (checkSimMode() == true) {
            return;
        }
        player = Player.makeRenderingSnapshot(player);
        //could be turnways or baby
        if (ctx == null) {
            ctx = canvas.context2D;
        }

        ctx.imageSmoothingEnabled = false; //should get rid of orange halo in certain browsers.
        if (!baby && (player.dead)) { //only rotate once
            ctx.translate(canvas.width, 0);
            ctx.rotate(90 * Math.PI / 180);
        }

        //they are not dead, only sleeping
        if (!baby && ((player.causeOfDrain != null && !player.causeOfDrain.isEmpty))) { //only rotate once
            ctx.translate(0, 6 * canvas.height / 5);
            ctx.rotate(270 * Math.PI / 180);
        }

        if (!baby && player.grimDark > 3) {
            grimDarkHalo(canvas, player);
        }

        //spotlight
        if(player.session.mutator.hasSpotLight(player)) drawWhatever(canvas, player.aspect.bigSymbolImgLocation);

        if (!baby && player.isTroll && player.godTier) { //wings before sprite
            wings(canvas, player);
        }

        if (!baby && player.dead) {
            bloodPuddle(canvas, player);
        }
        hairBack(canvas, player);
        if (player.isTroll) { //wings before sprite
            fin2(canvas, player);
        }

        if (!baby && !player.baby_stuck) {
            playerToSprite(canvas, player);
            bloody_face(canvas, player); //not just for murder mode, because you can kill another player if THEY are murder mode.
            if (player.murderMode == true) {
                scratch_face(canvas, player);
            }
            if (player.leftMurderMode == true) {
                scar_face(canvas, player);
            }
            if (player.robot == true) {
                robo_face(canvas, player);
            }
        } else {
            babySprite(canvas, player);
            if (player.baby_stuck && !baby) {
                bloody_face(canvas, player); //not just for murder mode, because you can kill another player if THEY are murder mode.
                if (player.murderMode == true) {
                    scratch_face(canvas, player);
                }
                if (player.leftMurderMode == true) {
                    scar_face(canvas, player);
                }
                if (player.robot == true) {
                    robo_face(canvas, player);
                }
            }
        }


        if (ouija) {
            drawWhatever(canvas, "/Bodies/pen15.png");
        }

        if (faceOff) {
            if (random() > .9) {
                drawWhatever(canvas, "/Bodies/face4.png");

                ///spooky wolf easter egg.
            } else {
                drawWhatever(canvas, "/Bodies/face${player.baby}.png");
            }
        }
        hair(canvas, player);
        if (player.isTroll) { //wings before sprite
            fin1(canvas, player);
        }
        if (!baby && player.godTier) {
            PaletteSwapCallback callback = aspectPalletSwap;
            if (player.trickster) callback = candyPalletSwap;
            if (player.robot) callback = robotPalletSwap;
            drawWhateverWithPalleteSwapCallback(canvas, playerToCowl(player), player, callback);
        }

        if (player.robot == true) {
            roboSkin(canvas); //, player);
        } else if (player.trickster == true) {
            peachSkin(canvas, player);
        } else if (!baby && player.grimDark > 3) {
            grimDarkSkin(canvas); //, player);
        } else if (player.isTroll) {
            greySkin(canvas); //,player);
        }
        if (player.isTroll) {
            horns(canvas, player);
        }

        if (!baby && player.dead && player.causeOfDeath == "after being shown too many stabs from Jack") {
            stabs(canvas, player);
        } else if (!baby && player.dead && player.causeOfDeath == "fighting the Black King") {
            kingDeath(canvas, player);
        }


        if (!baby && player.ghost) {
            //wasteOfMindSymbol(canvas, player);
            //halo(canvas, player.influenceSymbol);
            if (player.causeOfDrain != null) {
                drainedGhostSwap(canvas);
            } else {
                ghostSwap(canvas);
            }
        }

        if (!baby && player.aspect == Aspects.VOID) {
            voidSwap(canvas, 1 - player.getStat(Stats.POWER) / (2000 * Stats.POWER.coefficient)); //a void player at 2000 power is fully invisible.
        }else if(player.session.mutator.lightField && !player.session.mutator.hasSpotLight(player)) {
            voidSwap(canvas, 0.2); //compared to the light player, you are irrelevant.
        }
    }


    static void playerToSprite(CanvasElement canvas, Player player) {
        //CanvasRenderingContext2D ctx = canvas.getContext('2d');
        if (player.robot == true) {
            robotSprite(canvas, player);
        } else if (player.trickster) {
            tricksterSprite(canvas, player);
        } else if (player.godTier) {
            godTierSprite(canvas, player);
        } else if (player.isDreamSelf) {
            dreamSprite(canvas, player);
        } else {
            regularSprite(canvas, player);
        }
    }


    static void robo_face(CanvasElement canvas, Player player) {
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString = "robo_face.png";
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
    }


    static void scar_face(CanvasElement canvas, Player player) {
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString = "calm_scratch_face.png";
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
    }


    static void scratch_face(CanvasElement canvas, Player player) {
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString = "scratch_face.png";
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
        swapColors(canvas, ReferenceColours.BLOOD_PUDDLE, new Colour.fromStyleString(player.bloodColor)); //it's their own blood
    }


    //not just murder mode, you could have killed a murder mode player.
    static void bloody_face(CanvasElement canvas, Player player) {
        if (player.victimBlood != null) {
            CanvasRenderingContext2D ctx = canvas.getContext('2d');
            String imageString = "bloody_face.png";
            addImageTag(imageString);
            ImageElement img = imageSelector(imageString);
            ctx.drawImage(img, 0, 0);
            swapColors(canvas, ReferenceColours.BLOODY_FACE, new Colour.fromStyleString(player.victimBlood)); //it's not their own blood
        }
    }


    static void drawDiamond(CanvasElement canvas) {
        if (checkSimMode() == true) {
            return;
        }
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString = "Moirail.png";
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
    }


    static void drawHeart(CanvasElement canvas) {
        if (checkSimMode() == true) {
            return;
        }
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString = "Matesprit.png";
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
    }


    static void drawClub(CanvasElement canvas) {
        if (checkSimMode() == true) {
            return;
        }
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString = "Auspisticism.png";
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
    }


    static void drawSpade(CanvasElement canvas) {
        if (checkSimMode() == true) {
            return;
        }
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString = "Kismesis.png";
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
    }


    static void hairBack(CanvasElement canvas, Player player) {
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString = "Hair/hair_back${player.hair}.png";
        ////print(imageString);
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
        if (player.sbahj) {
            sbahjifier(canvas);
        }
        if (player.isTroll) {
            swapColors(canvas, ReferenceColours.HAIR, new Colour.fromStyleString(player.hairColor));
            swapColors(canvas, ReferenceColours.HAIR_ACCESSORY, new Colour.fromStyleString(player.bloodColor));
        } else {
            swapColors(canvas, ReferenceColours.HAIR, new Colour.fromStyleString(player.hairColor));
            swapColors(canvas, ReferenceColours.HAIR_ACCESSORY, player.aspect.palette.accent);
        }
    }


    static void hair(CanvasElement canvas, Player player) {
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString = "Hair/hair${player.hair}.png";
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
        if (player.sbahj) {
            sbahjifier(canvas);
        }
        if (player.isTroll) {
            swapColors(canvas, ReferenceColours.HAIR, new Colour.fromStyleString(player.hairColor));
            swapColors(canvas, ReferenceColours.HAIR_ACCESSORY, new Colour.fromStyleString(player.bloodColor));
        } else {
            swapColors(canvas, ReferenceColours.HAIR, new Colour.fromStyleString(player.hairColor));
            swapColors(canvas, ReferenceColours.HAIR_ACCESSORY, player.aspect.palette.accent);
        }
    }


    //if the Waste of Mind/Observer sends a time player back
    //the influence is visible.
    static void drawTimeGears(CanvasElement canvas) {
        if (checkSimMode() == true) {
            return;
        }
        CanvasElement p1SpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
        //drawBG(p1SpriteBuffer, "#ff9999", "#ff00ff");
        CanvasRenderingContext2D ctx = p1SpriteBuffer.getContext('2d');
        String imageString = "gears.png";
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
        copyTmpCanvasToRealCanvasAtPos(canvas, p1SpriteBuffer, 0, 0);
    }


    //more than just yellow yard can do this.
    static void influenceSymbol(CanvasElement canvas, String symbol) {
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString = symbol;
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
    }


    static void halo(CanvasElement canvas, String symbol) {
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString = "halo.png";
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
    }


    //if the Waste of Mind/Observer sends a time player back
    //the influence is visible.
    static void wasteOfMindSymbol(CanvasElement canvas, Player player) {
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString = "mind_forehead.png";
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
    }


    static String playerToRegularBody(Player player) {
        if (easter_egg) return playerToEggBody(player);
        return "Bodies/reg${(classNameToInt(player.class_name)+1)}.png";
    }

    static String playerToCowl(Player player) {
        if (easter_egg) return playerToEggBody(player); //no cowl, just double up on egg.
        return "Bodies/cowl${(classNameToInt(player.class_name)+1)}.png";
    }


    static String playerToDreamBody(Player player) {
        if (easter_egg) return playerToEggBody(player);
        return "Bodies/dream${(classNameToInt(player.class_name)+1)}.png";
    }


    static String playerToEggBody(Player player) {
        return "Bodies/egg${(classNameToInt(player.class_name)+1)}.png";
    }


    static void robotSprite(CanvasElement canvas, Player player) {
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString;
        if (!player.godTier) {
            imageString = playerToRegularBody(player);
        } else {
            imageString = playerToGodBody(player);
        }
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
        robotPalletSwap(canvas, player);
        //eeeeeh...could figure out how to color swap symbol, but lazy.
    }


    static void tricksterSprite(CanvasElement canvas, Player player) {
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString;
        if (!player.godTier) {
            imageString = playerToRegularBody(player);
        } else {
            imageString = playerToGodBody(player);
        }
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
        candyPalletSwap(canvas, player);
        //aspectSymbol(canvas, player);
    }


    static void regularSprite(CanvasElement canvas, Player player) {
        String imageString = playerToRegularBody(player);
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
        if (player.sbahj) {
            sbahjifier(canvas);
        }
        aspectPalletSwap(canvas, player);
        //aspectSymbol(canvas, player);
    }


    static void dreamSprite(CanvasElement canvas, Player player) {
        String imageString = playerToDreamBody(player);
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        CanvasRenderingContext2D ctx = canvas.getContext("2d");
        ctx.drawImage(img, 0, 0);
        dreamPalletSwap(canvas, player);
    }


    static String playerToGodBody(Player player) {
        if (easter_egg) return playerToEggBody(player);
        return "Bodies/god${(classNameToInt(player.class_name)+1)}.png";
    }


    static void godTierSprite(CanvasElement canvas, Player player) {
        //draw class, then color like aspect, then draw chest icon
        //ctx.drawImage(img,canvas.width/2,canvas.height/2,width,height);
        CanvasRenderingContext2D ctx = canvas.getContext("2d");
        String imageString = playerToGodBody(player);
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
        if (bardQuest && player.class_name == SBURBClassManager.BARD) {
            drawWhatever(canvas, "/Bodies/cod.png");
        }
        aspectPalletSwap(canvas, player);
        if (player.sbahj) {
            sbahjifier(canvas);
        }
        aspectSymbol(canvas, player);
    }


    static void babySprite(CanvasElement canvas, Player player) {
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString = "Bodies/baby${player.baby}.png";
        if (player.isTroll) {
            imageString = "Bodies/grub${player.baby}.png";
        }
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
        if (player.sbahj) {
            sbahjifier(canvas);
        }
        if (player.isTroll) {
            swapColors(canvas, ReferenceColours.GRUB, new Colour.fromStyleString(player.bloodColor));
        } else {
            swapColors(canvas, ReferenceColours.SPRITE_PALETTE.pants_light, player.aspect.palette.shirt_light);
            swapColors(canvas, ReferenceColours.SPRITE_PALETTE.pants_dark, player.aspect.palette.shirt_dark);
        }
    }


    static void aspectSymbol(CanvasElement canvas, Player player) {
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString = player.aspect.symbolImgLocation;
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
    }


    static void dreamSymbol(CanvasElement canvas, Player player) {
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString = "${player.moon}_symbol.png";
        addImageTag(imageString);
        ImageElement img = imageSelector(imageString);
        ctx.drawImage(img, 0, 0);
    }


    static void robotPalletSwap(CanvasElement canvas, Player player) {
        swapPalette(canvas, ReferenceColours.SPRITE_PALETTE, ReferenceColours.ROBOT_PALETTE);
    }


    static void dreamPalletSwap(CanvasElement canvas, Player player) {
        Palette shoes = new AspectPalette()
            ..shoe_light = player.aspect.palette.shirt_light
            ..shoe_dark = player.aspect.palette.shirt_dark;

        Palette dream = player.moon.palette;
        Palette p = new Palette.combined(<Palette>[dream, shoes]);

        swapPalette(canvas, ReferenceColours.SPRITE_PALETTE, p);
    }


    static void candyPalletSwap(CanvasElement canvas, Player player) {
        //not all browsers do png gama info correctly. Chrome does, firefox does not, mostly.
        //remove it entirely with this command
        //pngcrush -rem gAMA -rem cHRM -rem iCCP -rem sRGB infile.png outfile.png
        //pngcrush -rem gAMA -rem cHRM -rem iCCP -rem sRGB reg001.png reg001copy.png
        //./pngcrush -rem gAMA -rem cHRM -rem iCCP -rem sRGB stab.png stab_copy.png

        AspectPalette candy = new AspectPalette();

        //I am the GREETEST. Figured out how to make spreadsheet auto gen code: ="new_color"&ROW()&"='#" &B23 &"';"
        if (player.aspect == Aspects.LIGHT) {
            candy
                ..aspect_light = tricksterColors[0]
                ..aspect_dark = tricksterColors[1]
                ..shoe_light = tricksterColors[2]
                ..shoe_dark = tricksterColors[3]
                ..cloak_light = tricksterColors[4]
                ..cloak_mid = tricksterColors[5]
                ..cloak_dark = tricksterColors[6]
                ..shirt_light = tricksterColors[7]
                ..shirt_dark = tricksterColors[8]
                ..pants_light = tricksterColors[9]
                ..pants_dark = tricksterColors[10];
        } else if (player.aspect == Aspects.BREATH) {
            candy
                ..aspect_light = tricksterColors[11]
                ..aspect_dark = tricksterColors[12]
                ..shoe_light = tricksterColors[13]
                ..shoe_dark = tricksterColors[14]
                ..cloak_light = tricksterColors[15]
                ..cloak_mid = tricksterColors[16]
                ..cloak_dark = tricksterColors[17]
                ..shirt_light = tricksterColors[18]
                ..shirt_dark = tricksterColors[0]
                ..pants_light = tricksterColors[1]
                ..pants_dark = tricksterColors[2];
        } else if (player.aspect == Aspects.TIME) {
            candy
                ..aspect_light = tricksterColors[3]
                ..aspect_dark = tricksterColors[4]
                ..shoe_light = tricksterColors[5]
                ..shoe_dark = tricksterColors[6]
                ..cloak_light = tricksterColors[7]
                ..cloak_mid = tricksterColors[8]
                ..cloak_dark = tricksterColors[9]
                ..shirt_light = tricksterColors[10]
                ..shirt_dark = tricksterColors[11]
                ..pants_light = tricksterColors[12]
                ..pants_dark = tricksterColors[13];
        } else if (player.aspect == Aspects.SPACE) {
            candy
                ..aspect_light = tricksterColors[14]
                ..aspect_dark = tricksterColors[15]
                ..shoe_light = tricksterColors[16]
                ..shoe_dark = tricksterColors[17]
                ..cloak_light = tricksterColors[18]
                ..cloak_mid = tricksterColors[0]
                ..cloak_dark = tricksterColors[1]
                ..shirt_light = tricksterColors[2]
                ..shirt_dark = tricksterColors[3]
                ..pants_light = tricksterColors[4]
                ..pants_dark = tricksterColors[5];
        } else if (player.aspect == Aspects.HEART) {
            candy
                ..aspect_light = tricksterColors[6]
                ..aspect_dark = tricksterColors[7]
                ..shoe_light = tricksterColors[8]
                ..shoe_dark = tricksterColors[9]
                ..cloak_light = tricksterColors[10]
                ..cloak_mid = tricksterColors[11]
                ..cloak_dark = tricksterColors[12]
                ..shirt_light = tricksterColors[13]
                ..shirt_dark = tricksterColors[14]
                ..pants_light = tricksterColors[15]
                ..pants_dark = tricksterColors[16];
        } else if (player.aspect == Aspects.MIND) {
            candy
                ..aspect_light = tricksterColors[17]
                ..aspect_dark = tricksterColors[18]
                ..shoe_light = tricksterColors[17]
                ..shoe_dark = tricksterColors[16]
                ..cloak_light = tricksterColors[15]
                ..cloak_mid = tricksterColors[14]
                ..cloak_dark = tricksterColors[13]
                ..shirt_light = tricksterColors[12]
                ..shirt_dark = tricksterColors[11]
                ..pants_light = tricksterColors[10]
                ..pants_dark = tricksterColors[9];
        } else if (player.aspect == Aspects.LIFE) {
            candy
                ..aspect_light = tricksterColors[8]
                ..aspect_dark = tricksterColors[7]
                ..shoe_light = tricksterColors[6]
                ..shoe_dark = tricksterColors[5]
                ..cloak_light = tricksterColors[4]
                ..cloak_mid = tricksterColors[3]
                ..cloak_dark = tricksterColors[2]
                ..shirt_light = tricksterColors[1]
                ..shirt_dark = tricksterColors[0]
                ..pants_light = tricksterColors[1]
                ..pants_dark = tricksterColors[2];
        } else if (player.aspect == Aspects.VOID) {
            candy
                ..aspect_light = tricksterColors[3]
                ..aspect_dark = tricksterColors[5]
                ..shoe_light = tricksterColors[8]
                ..shoe_dark = tricksterColors[0]
                ..cloak_light = tricksterColors[10]
                ..cloak_mid = tricksterColors[11]
                ..cloak_dark = tricksterColors[3]
                ..shirt_light = tricksterColors[4]
                ..shirt_dark = tricksterColors[8]
                ..pants_light = tricksterColors[7]
                ..pants_dark = tricksterColors[6];
        } else if (player.aspect == Aspects.HOPE) {
            candy
                ..aspect_light = tricksterColors[10]
                ..aspect_dark = tricksterColors[9]
                ..shoe_light = tricksterColors[8]
                ..shoe_dark = tricksterColors[7]
                ..cloak_light = tricksterColors[6]
                ..cloak_mid = tricksterColors[5]
                ..cloak_dark = tricksterColors[4]
                ..shirt_light = tricksterColors[3]
                ..shirt_dark = tricksterColors[2]
                ..pants_light = tricksterColors[1]
                ..pants_dark = tricksterColors[0];
        }
        else if (player.aspect == Aspects.DOOM) {
            candy
                ..aspect_light = tricksterColors[18]
                ..aspect_dark = tricksterColors[17]
                ..shoe_light = tricksterColors[16]
                ..shoe_dark = tricksterColors[0]
                ..cloak_light = tricksterColors[15]
                ..cloak_mid = tricksterColors[14]
                ..cloak_dark = tricksterColors[13]
                ..shirt_light = tricksterColors[12]
                ..shirt_dark = tricksterColors[10]
                ..pants_light = tricksterColors[9]
                ..pants_dark = tricksterColors[10];
        } else if (player.aspect == Aspects.RAGE) {
            candy
                ..aspect_light = tricksterColors[4]
                ..aspect_dark = tricksterColors[1]
                ..shoe_light = tricksterColors[3]
                ..shoe_dark = tricksterColors[6]
                ..cloak_light = tricksterColors[1]
                ..cloak_mid = tricksterColors[2]
                ..cloak_dark = tricksterColors[1]
                ..shirt_light = tricksterColors[0]
                ..shirt_dark = tricksterColors[2]
                ..pants_light = tricksterColors[5]
                ..pants_dark = tricksterColors[7];
        } else if (player.aspect == Aspects.BLOOD) {
            candy
                ..aspect_light = tricksterColors[1]
                ..aspect_dark = tricksterColors[2]
                ..shoe_light = tricksterColors[3]
                ..shoe_dark = tricksterColors[4]
                ..cloak_light = tricksterColors[5]
                ..cloak_mid = tricksterColors[10]
                ..cloak_dark = tricksterColors[18]
                ..shirt_light = tricksterColors[15]
                ..shirt_dark = tricksterColors[14]
                ..pants_light = tricksterColors[13]
                ..pants_dark = tricksterColors[0];
        }


        swapPalette(canvas, ReferenceColours.SPRITE_PALETTE, candy);
    }


    static void aspectPalletSwap(CanvasElement canvas, Player player) {
        //not all browsers do png gama info correctly. Chrome does, firefox does not, mostly.
        //remove it entirely with this command
        //pngcrush -rem gAMA -rem cHRM -rem iCCP -rem sRGB infile.png outfile.png
        //pngcrush -rem gAMA -rem cHRM -rem iCCP -rem sRGB reg001.png reg001copy.png
        //./pngcrush -rem gAMA -rem cHRM -rem iCCP -rem sRGB stab.png stab_copy.png

        //I am the GREETEST. Figured out how to make spreadsheet auto gen code: ="new_color"&ROW()&"='#" &B23 &"';"
        /*if (player.aspect == "Light") {
            new_color1 = '#FEFD49';
            new_color2 = '#FEC910';
            new_color3 = '#10E0FF';
            new_color4 = '#00A4BB';
            new_color5 = '#FA4900';
            new_color6 = '#E94200';
            new_color7 = '#C33700';
            new_color8 = '#FF8800';
            new_color9 = '#D66E04';
            new_color10 = '#E76700';
            new_color11 = '#CA5B00';
        } else if (player.aspect == "Breath") {
            new_color1 = '#10E0FF';
            new_color2 = '#00A4BB';
            new_color3 = '#FEFD49';
            new_color4 = '#D6D601';
            new_color5 = '#0052F3';
            new_color6 = '#0046D1';
            new_color7 = '#003396';
            new_color8 = '#0087EB';
            new_color9 = '#0070ED';
            new_color10 = '#006BE1';
            new_color11 = '#0054B0';
        } else if (player.aspect == "Time") {
            new_color1 = '#FF2106';
            new_color2 = '#AD1604';
            new_color3 = '#030303';
            new_color4 = '#242424';
            new_color5 = '#510606';
            new_color6 = '#3C0404';
            new_color7 = '#1F0000';
            new_color8 = '#B70D0E';
            new_color9 = '#970203';
            new_color10 = '#8E1516';
            new_color11 = '#640707';
        } else if (player.aspect == "Space") {
            new_color1 = '#EFEFEF';
            new_color2 = '#DEDEDE';
            new_color3 = '#FF2106';
            new_color4 = '#B01200';
            new_color5 = '#2F2F30';
            new_color6 = '#1D1D1D';
            new_color7 = '#080808';
            new_color8 = '#030303';
            new_color9 = '#242424';
            new_color10 = '#333333';
            new_color11 = '#141414';
        } else if (player.aspect == "Heart") {
            new_color1 = '#BD1864';
            new_color2 = '#780F3F';
            new_color3 = '#1D572E';
            new_color4 = '#11371D';
            new_color5 = '#4C1026';
            new_color6 = '#3C0D1F';
            new_color7 = '#260914';
            new_color8 = '#6B0829';
            new_color9 = '#4A0818';
            new_color10 = '#55142A';
            new_color11 = '#3D0E1E';
        } else if (player.aspect == "Mind") {
            new_color1 = '#06FFC9';
            new_color2 = '#04A885';
            new_color3 = '#6E0E2E';
            new_color4 = '#4A0818';
            new_color5 = '#1D572E';
            new_color6 = '#164524';
            new_color7 = '#11371D';
            new_color8 = '#3DA35A';
            new_color9 = '#2E7A43';
            new_color10 = '#3B7E4F';
            new_color11 = '#265133';
        } else if (player.aspect == "Life") {
            new_color1 = '#76C34E';
            new_color2 = '#4F8234';
            new_color3 = '#00164F';
            new_color4 = '#00071A';
            new_color5 = '#605542';
            new_color6 = '#494132';
            new_color7 = '#2D271E';
            new_color8 = '#CCC4B5';
            new_color9 = '#A89F8D';
            new_color10 = '#A29989';
            new_color11 = '#918673';
        } else if (player.aspect == "Void") {
            new_color1 = '#0B1030';
            new_color2 = '#04091A';
            new_color3 = '#CCC4B5';
            new_color4 = '#A89F8D';
            new_color5 = '#00164F';
            new_color6 = '#00103C';
            new_color7 = '#00071A';
            new_color8 = '#033476';
            new_color9 = '#02285B';
            new_color10 = '#004CB2';
            new_color11 = '#003E91';
        } else if (player.aspect == "Hope") {
            new_color1 = '#FDF9EC';
            new_color2 = '#D6C794';
            new_color3 = '#164524';
            new_color4 = '#06280C';
            new_color5 = '#FFC331';
            new_color6 = '#F7BB2C';
            new_color7 = '#DBA523';
            new_color8 = '#FFE094';
            new_color9 = '#E8C15E';
            new_color10 = '#F6C54A';
            new_color11 = '#EDAF0C';
        }
        else if (player.aspect == "Doom") {
            new_color1 = '#0F0F0F';
            new_color2 = '#010101';
            new_color3 = '#E8C15E';
            new_color4 = '#C7A140';
            new_color5 = '#1E211E';
            new_color6 = '#141614';
            new_color7 = '#0B0D0B';
            new_color8 = '#204020';
            new_color9 = '#11200F';
            new_color10 = '#192C16';
            new_color11 = '#121F10';
        } else if (player.aspect == "Rage") {
            new_color1 = '#974AA7';
            new_color2 = '#6B347D';
            new_color3 = '#3D190A';
            new_color4 = '#2C1207';
            new_color5 = '#7C3FBA';
            new_color6 = '#6D34A6';
            new_color7 = '#592D86';
            new_color8 = '#381B76';
            new_color9 = '#1E0C47';
            new_color10 = '#281D36';
            new_color11 = '#1D1526';
        } else if (player.aspect == "Blood") {
            new_color1 = '#BA1016';
            new_color2 = '#820B0F';
            new_color3 = '#381B76';
            new_color4 = '#1E0C47';
            new_color5 = '#290704';
            new_color6 = '#230200';
            new_color7 = '#110000';
            new_color8 = '#3D190A';
            new_color9 = '#2C1207';
            new_color10 = '#5C2913';
            new_color11 = '#4C1F0D';
        } else {
            new_color1 = '#FF9B00';
            new_color2 = '#FF8700';
            new_color3 = '#7F7F7F';
            new_color4 = '#727272';
            new_color5 = '#A3A3A3';
            new_color6 = '#999999';
            new_color7 = '#898989';
            new_color8 = '#EFEFEF';
            new_color9 = '#DBDBDB';
            new_color10 = '#C6C6C6';
            new_color11 = '#ADADAD';
        }
        */

        swapPalette(canvas, ReferenceColours.SPRITE_PALETTE, player.aspect.palette);
    }


    static CanvasElement getBufferCanvas(CanvasElement canvas) {
        return new CanvasElement(width: canvas.width, height: canvas.height);
    }


    static void copyTmpCanvasToRealCanvasAtPos(CanvasElement canvas, CanvasElement tmp_canvas, int x, int y) {
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        ctx.drawImage(tmp_canvas, x, y);
    }


//does not work how i hoped. does not render a canvas with alpha
    static void copyTmpCanvasToRealCanvas50(CanvasElement canvas, CanvasElement tmp_canvas) {
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        ctx.globalAlpha = 0.5;
        ctx.drawImage(tmp_canvas, 0, 0);
    }


    static void copyTmpCanvasToRealCanvas(CanvasElement canvas, CanvasElement tmp_canvas) {
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        ctx.drawImage(tmp_canvas, 0, 0);
    }


//http://stackoverflow.com/questions/5026961/html5-canvas-ctx-filltext-wont-do-line-breaks/21574562#21574562
    static void fillTextMultiLine(CanvasElement canvas, String text1, String text2, String color2, int x, int y) {
        CanvasRenderingContext2D ctx = canvas.getContext("2d");
        double lineHeight = ctx
            .measureText("M")
            .width * 1.2;
        List<String> lines = text1.split("\n");
        double ypos = y.toDouble();
        for (int i = 0; i < lines.length; ++i) {
            ctx.fillText(lines[i], x, ypos);
            ypos += lineHeight;
        }
        //word wrap these
        ctx.fillStyle = color2;
        wrap_text(ctx, text2, x, ypos, lineHeight, 3 * canvas.width ~/ 4, "left");
        ctx.fillStyle = "#000000";
    }

    static void fillChatTextMultiLineJRPlayer(CanvasElement canvas, String chat, Player player, int x, int y) {
        CanvasRenderingContext2D ctx = canvas.getContext("2d");
        double lineHeight = ctx
            .measureText("M")
            .width * 1.2;
        List<String> lines = chat.split("\n");
        String playerStart = player.chatHandleShort();
        String jrStart = "JR: ";
        double ypos = y.toDouble();
        for (int i = 0; i < lines.length; ++i) {
            //does the text begin with player 1's chat handle short? if so: getChatFontColor
            String ct = lines[i].trim();

            //check player 2 first 'cause they'll be more specific if they have same initials
            if (ct.startsWith(playerStart)) {
                ctx.fillStyle = player.getChatFontColor();
                if (player.sbahj) {
                    ctx.font = "12px Comic Sans";
                } else {
                    ctx.font = "12px Times New Roman";
                }
            } else if (ct.startsWith(jrStart)) {
                ctx.fillStyle = "#3da35a";
                ctx.font = "12px Times New Roman";
            } else {
                ctx.fillStyle = "#000000";
            }
            int lines_wrapped = wrap_text(ctx, ct, x, ypos, lineHeight, canvas.width - 50, "left");
            ypos += lineHeight * lines_wrapped;
        }
        //word wrap these
        ctx.fillStyle = "#000000";
    }


    static void fillChatTextMultiLineNonPlayer(CanvasElement canvas, String chat, int x, int y, String player1Start, String player2Start, String player1Color, String player2Color) {
        CanvasRenderingContext2D ctx = canvas.getContext("2d");
        double lineHeight = ctx
            .measureText("M")
            .width * 1.2;
        List<String> lines = chat.split("\n");
        double ypos = y.toDouble();
        for (int i = 0; i < lines.length; ++i) {
            //does the text begin with player 1's chat handle short? if so: getChatFontColor
            String ct = lines[i].trim();
            //check player 2 first 'cause they'll be more specific if they have same initials
            if (ct.startsWith(player2Start)) {
                ctx.fillStyle = player2Color;
                ctx.font = "12px Times New Roman";
            } else if (ct.startsWith(player1Start)) {
                ctx.fillStyle = player1Color;
                ctx.font = "12px Times New Roman";
            } else {
                ctx.fillStyle = "#000000";
            }
            int lines_wrapped = wrap_text(ctx, ct, x, ypos, lineHeight, canvas.width - 50, "left");
            ypos += lineHeight * lines_wrapped;
        }
        //word wrap these
        ctx.fillStyle = "#000000";
    }


    //matches line color to player font color
    static void fillChatTextMultiLine(CanvasElement canvas, String chat, Player player1, Player player2, int x, num y) {
        CanvasRenderingContext2D ctx = canvas.getContext("2d");
        double lineHeight = ctx
            .measureText("M")
            .width * 1.2;
        List<String> lines = chat.split("\n");
        String player1Start = player1.chatHandleShort();
        String player2Start = player2.chatHandleShortCheckDup(player1Start);
        for (int i = 0; i < lines.length; ++i) {
            //does the text begin with player 1's chat handle short? if so: getChatFontColor
            String ct = lines[i].trim();

            //check player 2 first 'cause they'll be more specific if they have same initials
            if (ct.startsWith(player2Start)) {
                ctx.fillStyle = player2.getChatFontColor();
                if (player2.sbahj) {
                    ctx.font = "12px Comic Sans MS";
                } else {
                    ctx.font = "12px Times New Roman";
                }
            } else if (ct.startsWith(player1Start)) {
                ctx.fillStyle = player1.getChatFontColor();
                if (player1.sbahj) {
                    ctx.font = "12px Comic Sans MS";
                } else {
                    ctx.font = "12px Times New Roman";
                }
            } else {
                ctx.fillStyle = "#000000";
            }
            int lines_wrapped = wrap_text(ctx, ct, x, y, lineHeight, canvas.width - 50, "left");
            y += lineHeight * lines_wrapped;
        }
        //word wrap these
        ctx.fillStyle = "#000000";
    }

    //http://stackoverflow.com/questions/5026961/html5-canvas-ctx-filltext-wont-do-line-breaks
    static int wrap_text(CanvasRenderingContext2D ctx, String text, num x, num y, num lineHeight, int maxWidth, String textAlign) {
        if (textAlign == null) textAlign = 'center';
        ctx.textAlign = textAlign;
        List<String> words = text.split(' ');
        List<String> lines = <String>[];
        int sliceFrom = 0;
        for (int i = 0; i < words.length; i++) {
            String chunk = words.sublist(sliceFrom, i).join(' ');
            bool last = i == words.length - 1;
            bool bigger = ctx
                .measureText(chunk)
                .width > maxWidth;
            if (bigger) {
                lines.add(words.sublist(sliceFrom, i).join(' '));
                sliceFrom = i;
            }
            if (last) {
                lines.add(words.sublist(sliceFrom, words.length).join(' '));
                sliceFrom = i;
            }
        }
        num offsetY = 0.0;
        num offsetX = 0;
        if (textAlign == 'center') offsetX = maxWidth ~/ 2;
        for (int i = 0; i < lines.length; i++) {
            ctx.fillText(lines[i], x + offsetX, y + offsetY);
            offsetY = offsetY + lineHeight;
        }
        //need to return how many lines i created so that whatever called me knows where to put ITS next line.;
        return lines.length;
    }
}