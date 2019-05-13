
import "dart:html";
import "dart:async";
import "dart:math" as Math;

import "SBURBSim.dart";

//can't use this in the sim just yet, but at least i can use it for the creator
//TODO eventually just swap colors and shit, everything is palettes, not done one at a time
//TODO super eventually just fucking use a dollsim

class PlayerSpriteHandler {

    static bool checkSimMode() {
        //return true; // debugging, is loading the problem, or is this method?
        if (doNotRender == true) {
            //looking for rare sessions, or getting moon prophecies.
            //  //;
            return true;
        }
        return false;
    }


    static Future<Null> drawSpriteFromScratch(CanvasElement canvas, Player player, [CanvasRenderingContext2D ctx = null, bool baby = false]) async{
        print("trying to async draw a sprite from scratch");
        if (Drawing.checkSimMode() == true) {
            return;
        }
        player = Player.makeRenderingSnapshot(player,true);
        //could be turnways or baby
        if (ctx == null) {
            ctx = canvas.context2D;
        }

        ctx.imageSmoothingEnabled = false; //should get rid of orange halo in certain browsers.
        if (!baby && (player.dead)) { //only rotate once
            ctx.translate(canvas.width, 0);
            ctx.rotate(90 * Math.pi / 180);
        }

        //they are not dead, only sleeping
        if (!baby && ((player.causeOfDrain != null && !player.causeOfDrain.isEmpty))) { //only rotate once
            ctx.translate(0, 6 * canvas.height / 5);
            ctx.rotate(270 * Math.pi / 180);
        }

        if (!baby && player.grimDark > 3) {
            await grimDarkHalo(canvas, player);
        }

        //spotlight
        if (player.session.mutator.hasSpotLight(player)) {
            await drawWhateverFuture(canvas, player.aspect.bigSymbolImgLocation);
        }

        if (!baby && player.isTroll && player.godTier) { //wings before sprite
            await wings(canvas, player);
        }

        if (!baby && player.dead) {
            await bloodPuddle(canvas, player);
        }
        await hairBack(canvas, player);
        if (player.isTroll) { //wings before sprite
            await fin2(canvas, player);
        }

        if (!baby && !player.baby_stuck) {
            await playerToSprite(canvas, player);
            await bloody_face(canvas, player); //not just for murder mode, because you can kill another player if THEY are murder mode.
            if (player.murderMode == true) {
                await scratch_face(canvas, player);
            }
            if (player.leftMurderMode == true) {
                await scar_face(canvas, player);
            }
            if (player.robot == true) {
                await robo_face(canvas, player);
            }
        } else {
            await babySprite(canvas, player);
            if (player.baby_stuck && !baby) {
                await bloody_face(canvas, player); //not just for murder mode, because you can kill another player if THEY are murder mode.
                if (player.murderMode == true) {
                    await scratch_face(canvas, player);
                }
                if (player.leftMurderMode == true) {
                    await scar_face(canvas, player);
                }
                if (player.robot == true) {
                    await robo_face(canvas, player);
                }
            }
        }


        if (ouija) {
            await drawWhateverFuture(canvas, "/Bodies/pen15.png");
        }

        if (faceOff) {
            if (random() > .9) {
                await drawWhateverFuture(canvas, "/Bodies/face4.png");

                ///spooky wolf easter egg.
            } else {
                await drawWhateverFuture(canvas, "/Bodies/face${player.baby}.png");
            }
        }
        await hair(canvas, player);
        if (player.isTroll) { //wings before sprite
            await fin1(canvas, player);
        }
        if (!baby && player.godTier) {
            PaletteSwapCallback callback = Drawing.aspectPalletSwap;
            if (player.trickster) callback = Drawing.candyPalletSwap;
            if (player.robot) callback = Drawing.robotPalletSwap;
            await drawWhateverFutureWithPalleteSwapCallback(canvas, Drawing.playerToCowl(player), player, callback);
        }

        if (player.robot == true) {
            Drawing.roboSkin(canvas); //, player);
        } else if (player.trickster == true) {
            Drawing.peachSkin(canvas, player);
        } else if (!baby && player.grimDark > 3) {
            Drawing.grimDarkSkin(canvas); //, player);
        } else if (player.isTroll) {
            Drawing.greySkin(canvas); //,player);
        }
        if (player.isTroll) {
            await horns(canvas, player);
        }

        if (!baby && player.dead && player.causeOfDeath == "after being shown too many stabs from Jack") {
            await stabs(canvas, player);
        } else if (!baby && player.dead && player.causeOfDeath == "fighting the Black King") {
            await kingDeath(canvas, player);
        }


        if (!baby && player.ghost) {
            //wasteOfMindSymbol(canvas, player);
            //halo(canvas, player.influenceSymbol);
            if (player.causeOfDrain != null) {
                Drawing.drainedGhostSwap(canvas);
            } else {
                Drawing.ghostSwap(canvas);
            }
        }

        if (player.brainGhost){
            Drawing.ghostSwap(canvas);
        }

        if (!baby && player.aspect == Aspects.VOID) {
            Drawing.voidSwap(canvas, 1 - player.getStat(Stats.POWER) / (2000 * Stats.POWER.coefficient)); //a void player at 2000 power is fully invisible.
        }else if(player.session.mutator.lightField && !player.session.mutator.hasSpotLight(player)) {
            Drawing.voidSwap(canvas, 0.2); //compared to the light player, you are irrelevant.
        }
        print("done trying to async draw a sprite from scratch");

    }

    static Future<Null> grimDarkHalo(CanvasElement canvas, Player player) async {
        String imageString = "grimdark.png";
        if (player.trickster) {
            imageString = "squiddles_chaos.png";
        }
        await drawWhateverFuture(canvas, imageString);
    }

    static Future<Null> wings(CanvasElement canvas, Player player) async {
        //blood players have no wings, all other players have wings matching
        //favorite color
        if (!player.aspect.trollWings) {
            //return;  //karkat and kankri don't have wings, but is that standard? or are they just hiding them?
        }

        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        int num = player.quirk.favoriteNumber;
        //int num = 5;
        String imageString = "Wings/wing$num.png";

        await drawWhateverFuture(canvas, imageString);
        Colour blood = new Colour.fromStyleString(player.bloodColor);
        Drawing.swapColors(canvas, ReferenceColours.RED, blood);
        Drawing.swapColors(canvas, ReferenceColours.LIME_CORRECTION, blood, 128);
        Drawing.swapColors(canvas, ReferenceColours.LIME, blood, 128); //I have NO idea why some browsers render the lime parts of the wing as 00ff00 but whatever.
    }

    static Future<Null>  drawWhateverFuture(CanvasElement canvas, String imageString) async {
        ImageElement image = await Loader.getResource("images/$imageString");
        canvas.context2D.drawImage(image, 0, 0);
    }

    static Future<Null> bloodPuddle(CanvasElement canvas, Player player) async {
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString = "blood_puddle.png";
        await drawWhateverFuture(canvas, imageString);
        Drawing.swapColors(canvas, ReferenceColours.BLOOD_PUDDLE, new Colour.fromStyleString(player.bloodColor));
    }

    static Future<Null> hairBack(CanvasElement canvas, Player player) async {
        CanvasRenderingContext2D ctx = canvas.getContext('2d');
        String imageString = "Hair/hair_back${player.hair}.png";
        ////print(imageString);
        await drawWhateverFuture(canvas, imageString);
        if (player.sbahj) {
            Drawing.sbahjifier(canvas);
        }
        if (player.isTroll) {
            Drawing.swapColors(canvas, ReferenceColours.HAIR, new Colour.fromStyleString(player.hairColor));
            Drawing.swapColors(canvas, ReferenceColours.HAIR_ACCESSORY, new Colour.fromStyleString(player.bloodColor));
        } else {
            Drawing.swapColors(canvas, ReferenceColours.HAIR, new Colour.fromStyleString(player.hairColor));
            Drawing.swapColors(canvas, ReferenceColours.HAIR_ACCESSORY, player.aspect.palette.accent);
        }
    }

    static Future<Null> fin1(CanvasElement canvas, Player player) async {
        if (player.bloodColor == "#610061" || player.bloodColor == "#99004d") {
            String imageString = "fin1.png";
            await drawWhateverFuture(canvas, imageString);
        }
    }

    static Future<Null> fin2(CanvasElement canvas, Player player) async {
        if (player.bloodColor == "#610061" || player.bloodColor == "#99004d") {
            CanvasRenderingContext2D ctx = canvas.getContext('2d');
            String imageString = "fin2.png";
            await drawWhateverFuture(canvas, imageString);
        }
    }

    static Future<Null> horns(CanvasElement canvas, Player player) async {
        await leftHorn(canvas, player);
        await rightHorn(canvas, player);
    }


    //horns are no longer a sprite sheet. tracy and kristi and brandon gave me advice.
    //position horns on an image as big as the canvas. put the horns directly on the
    //place where the head of every sprite would be.
    //same for wings eventually.
    static Future<Null> leftHorn(CanvasElement canvas, Player player) async {
        String imageString = "Horns/left${player.leftHorn}.png";
        await drawWhateverFuture(canvas, imageString);
    }

    //parse horns sprite sheet. render a random right horn.
    //right horn should be at: 120,40
    static Future<Null> rightHorn(CanvasElement canvas, Player player) async {
        String imageString = "Horns/right${player.rightHorn}.png";
        await drawWhateverFuture(canvas, imageString);
    }

    static Future<Null> bloody_face(CanvasElement canvas, Player player) async {
        if (player.victimBlood != null) {
            String imageString = "bloody_face.png";
            await drawWhateverFuture(canvas, imageString);
        }
    }

    static Future<Null> robo_face(CanvasElement canvas, Player player) async {
        String imageString = "robo_face.png";
        await drawWhateverFuture(canvas, imageString);
    }


    static Future<Null> scar_face(CanvasElement canvas, Player player) async {
        String imageString = "calm_scratch_face.png";
       await drawWhateverFuture(canvas, imageString);
    }


    static Future<Null> scratch_face(CanvasElement canvas, Player player) async {
        String imageString = "scratch_face.png";
        await drawWhateverFuture(canvas, imageString);
        Drawing.swapColors(canvas, ReferenceColours.BLOOD_PUDDLE, new Colour.fromStyleString(player.bloodColor)); //it's their own blood
    }

    static Future<Null> hair(CanvasElement canvas, Player player) async {
        String imageString = "Hair/hair${player.hair}.png";
        await drawWhateverFuture(canvas, imageString);
        if (player.sbahj) {
            Drawing.sbahjifier(canvas);
        }
        if (player.isTroll) {
            Drawing.swapColors(canvas, ReferenceColours.HAIR, new Colour.fromStyleString(player.hairColor));
            Drawing.swapColors(canvas, ReferenceColours.HAIR_ACCESSORY, new Colour.fromStyleString(player.bloodColor));
        } else {
            Drawing.swapColors(canvas, ReferenceColours.HAIR, new Colour.fromStyleString(player.hairColor));
            Drawing.swapColors(canvas, ReferenceColours.HAIR_ACCESSORY, player.aspect.palette.accent);
        }
    }

    static Future<Null> drawWhateverFutureWithPalleteSwapCallback(CanvasElement canvas, String str, Player player, PaletteSwapCallback palleteSwapCallBack) async {
        CanvasElement temp = new CanvasElement(width:canvas.width, height:canvas.height);
        await drawWhateverFuture(temp, str);
        ////;
        palleteSwapCallBack(temp, player); //regular, trickster, robo, whatever.
        canvas.context2D.drawImage(temp, 0,0);
    }

    static Future<Null> stabs(CanvasElement canvas, Player player) async {
        String imageString = "stab.png";
        await drawWhateverFuture(canvas, imageString);
        Drawing.swapColors(canvas, ReferenceColours.BLOOD_PUDDLE, new Colour.fromStyleString(player.bloodColor));
    }


    static Future<Null> kingDeath(CanvasElement canvas, Player player) async {
        String imageString = "sceptre.png";
        await drawWhateverFuture(canvas, imageString);
        Drawing.swapColors(canvas, ReferenceColours.BLOOD_PUDDLE, new Colour.fromStyleString(player.bloodColor));
    }

    static Future<Null> playerToSprite(CanvasElement canvas, Player player) async {
        //CanvasRenderingContext2D ctx = canvas.getContext('2d');
        if (player.robot == true) {
            await robotSprite(canvas, player);
        } else if (player.trickster) {
            await tricksterSprite(canvas, player);
        } else if (player.godTier) {
            await godTierSprite(canvas, player);
        } else if (player.isDreamSelf) {
            await dreamSprite(canvas, player);
        } else {
            await regularSprite(canvas, player);
        }
    }

    static Future<Null> babySprite(CanvasElement canvas, Player player) async {
        String imageString = "Bodies/baby${player.baby}.png";
        if (player.isTroll) {
            imageString = "Bodies/grub${player.baby}.png";
        }
        await drawWhateverFuture(canvas, imageString);
        if (player.sbahj) {
            Drawing.sbahjifier(canvas);
        }
        if (player.isTroll) {
            Drawing.swapColors(canvas, ReferenceColours.GRUB, new Colour.fromStyleString(player.bloodColor));
        } else {
            Drawing.swapColors(canvas, ReferenceColours.SPRITE_PALETTE.pants_light, player.aspect.palette.shirt_light);
            Drawing.swapColors(canvas, ReferenceColours.SPRITE_PALETTE.pants_dark, player.aspect.palette.shirt_dark);
        }
    }

    static Future<Null> robotSprite(CanvasElement canvas, Player player) async{
        String imageString;
        if (!player.godTier) {
            imageString = Drawing.playerToRegularBody(player);
        } else {
            imageString = Drawing.playerToGodBody(player);
        }
        await drawWhateverFuture(canvas, imageString);
        Drawing.robotPalletSwap(canvas, player);
        //eeeeeh...could figure out how to color swap symbol, but lazy.
    }


    static Future<Null> tricksterSprite(CanvasElement canvas, Player player) async {
        String imageString;
        if (!player.godTier) {
            imageString = Drawing.playerToRegularBody(player);
        } else {
            imageString = Drawing.playerToGodBody(player);
        }
        await drawWhateverFuture(canvas, imageString);
        Drawing.candyPalletSwap(canvas, player);
    }


    static Future<Null> regularSprite(CanvasElement canvas, Player player) async {
        String imageString = Drawing.playerToRegularBody(player);
        await drawWhateverFuture(canvas, imageString);
        if (player.sbahj) {
            Drawing.sbahjifier(canvas);
        }
        Drawing.aspectPalletSwap(canvas, player);
        //aspectSymbol(canvas, player);
    }


    static Future<Null> dreamSprite(CanvasElement canvas, Player player) async {
        String imageString = Drawing.playerToDreamBody(player);
        await drawWhateverFuture(canvas, imageString);
        Drawing.dreamPalletSwap(canvas, player);
    }


    static Future<Null> godTierSprite(CanvasElement canvas, Player player) async {
        String imageString = Drawing.playerToGodBody(player);
        await drawWhateverFuture(canvas, imageString);

        if (bardQuest && player.class_name == SBURBClassManager.BARD) {
           await drawWhateverFuture(canvas, "/Bodies/cod.png");
        }
        Drawing.aspectPalletSwap(canvas, player);
        if (player.sbahj) {
            Drawing.sbahjifier(canvas);
        }
        await Drawing.aspectSymbol(canvas, player);
    }


}