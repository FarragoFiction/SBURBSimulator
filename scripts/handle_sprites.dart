part of SBURBSim;

num asyncNumSprites = 0;
bool cool_kid = false;
bool easter_egg = false;
bool bardQuest = false;
bool ouija = false;
bool faceOff = false;
//~~~~~~~~~~~IMPORTANT~~~~~~~~~~LET NOTHING HERE BE RANDOM
//OR PREDICTIONS AND TIME LOOPS AND AI SEARCHES WILL BE WRONG
//except nepepta, cuz that cat troll be crazy, yo

//mod from http://stackoverflow.com/questions/21646738/convert-hex-to-rgba
List<int> hexToRgbA(String hex){
    /*var c;
    if(/^#([A-Fa-f0-9]{3}){1,2}$/.test(hex)){
        c= hex.substring(1).split('');
        if(c.length== 3){
            c= [c[0], c[0], c[1], c[1], c[2], c[2]];
        }
        c= '0x'+c.join('');
        //return 'rgba('+[(c>>16)&255, (c>>8)&255, c&255].join(',')+',1)';
        return [(c>>16)&255, (c>>8)&255, c&255];
    }
    throw new Error('Bad Hex ' + hex);*/

    int col = int.parse(hex.substring(1), radix:16, onError:(String hex) => 0xFF0000);

    return [(col>>16)&255, (col>>8)&255, col&255];
}




//sharpens the image so later pixel swapping doesn't work quite right.
//https://www.html5rocks.com/en/tutorials/canvas/imagefilters/
void sbahjifier(canvas){
  bool opaque = false;
  var ctx = canvas.getContext('2d');
  ctx.rotate(getRandomIntNoSeed(0,10)*Math.PI/180);
	var pixels =ctx.getImageData(0, 0, canvas.width, canvas.height);
  //var weights = [  0, -1,  0, -1,  5, -1, 0, -1,  0 ];
  var weights = [  -1, -1,  -1, -1,  9, -1, -1, -1,  -1 ];
  //var weights = [  1, 1, 1, 1,  5, -1, -1, -1, -1 ];
  var side = (Math.sqrt(weights.length)).round();
  var halfSide = (side~/2);
  var src = pixels.data;
  var sw = pixels.width;
  var sh = pixels.height;
  // pad output by the convolution matrix
  var w = sw;
  var h = sh;
  var output = ctx.getImageData(0, 0, canvas.width, canvas.height);
  var dst = output.data;
  // go through the destination image pixels
  var alphaFac = opaque ? 1 : 0;
  for (var y=0; y<h; y++) {
    for (var x=0; x<w; x++) {
      var sy = y;
      var sx = x;
      var dstOff = (y*w+x)*4;
      // calculate the weighed sum of the source image pixels that
      // fall under the convolution matrix
      int r=0, g=0, b=0, a=0;
      for (var cy=0; cy<side; cy++) {
        for (var cx=0; cx<side; cx++) {
          var scy = sy + cy - halfSide;
          var scx = sx + cx - halfSide;
          if (scy >= 0 && scy < sh && scx >= 0 && scx < sw) {
            var srcOff = (scy*sw+scx)*4;
            var wt = weights[cy*side+cx];
            r += src[srcOff] * wt;
            g += src[srcOff+1] * wt;
            b += src[srcOff+2] * wt;
            a += src[srcOff+3] * wt;
          }
        }
      }
      dst[dstOff] = r;
      dst[dstOff+1] = g;
      dst[dstOff+2] = b;
      dst[dstOff+3] = a + alphaFac*(255-a);
    }
  }
  //sligtly offset each time
  ctx.putImageData(output, getRandomIntNoSeed(0,10), getRandomIntNoSeed(0,10));
}



//work once again gives me inspiration for this sim. thanks, bob!!!
void rainbowSwap(canvas){
	if(checkSimMode() == true){
		return;
	}
	var ctx = canvas.getContext('2d');
	var img_data =ctx.getImageData(0, 0, canvas.width, canvas.height);
	String imageString = "rainbow.png";
    var img=querySelector("#${imageString}");
    var width = img.width;
  	var height = img.height;
	var print= true;
	 var rainbow_canvas = getBufferCanvas(querySelector("#rainbow_template"));
	var rctx = rainbow_canvas.getContext('2d');
  	rctx.drawImage(img,0,0,width,height);
	var img_data_rainbow =rctx.getImageData(0, 0,width, height);
	//4 *Math.floor(i/(4000)) is because 1/(width*4) get me the row number (*4 'cause there are 4 elements per pixel). then, when i have the row number, *4 again because first row is 0,1,2,3 and second is 4,5,6,7 and third is 8,9,10,11
	for(num i = 0; i<img_data.data.length; i += 4){;
		if(img_data.data[i+3] >= 128){
			img_data.data[i] =img_data_rainbow.data[4 *(i~/(4000))];
			img_data.data[i+1] = img_data_rainbow.data[4 *(i~/(4000))+1];
			img_data.data[i+2] =img_data_rainbow.data[4 *(i~/(4000))+2];
			img_data.data[i+3] = getRandomIntNoSeed(100,255); //make it look speckled.

		}
	}
	ctx.putImageData(img_data, 0, 0);
	//ctx.putImageData(img_data_rainbow, 0, 0);
}



//how translucent are we talking, here?  number between 0 and 1
void voidSwap(canvas, alphaPercent){
  if(checkSimMode() == true){
    return;
  }
  // print("replacing: " + oldc  + " with " + newc);
  var ctx = canvas.getContext('2d');
  var img_data =ctx.getImageData(0, 0, canvas.width, canvas.height);
  //4 byte color array
  for(num i = 0; i<img_data.data.length; i += 4){;
    if(img_data.data[i+3] > 50){
      img_data.data[i+3] = (img_data.data[i+3]*alphaPercent).floor();  //keeps wings at relative transparency
    }
  }
  ctx.putImageData(img_data, 0, 0);
}



//work once again gives me inspiration for this sim. thanks, bob!!!
void drainedGhostSwap(canvas){
	if(checkSimMode() == true){
		return;
	}
	var ctx = canvas.getContext('2d');
	var img_data =ctx.getImageData(0, 0, canvas.width, canvas.height);
	String imageString = "ghostGradient.png";
    var img=querySelector("#${imageString}");
    var width = img.width;
  	var height = img.height;
	var print= true;
	 var rainbow_canvas = getBufferCanvas(querySelector("#rainbow_template"));
	var rctx = rainbow_canvas.getContext('2d');
  	rctx.drawImage(img,0,0,width,height);
	var img_data_rainbow =rctx.getImageData(0, 0,width, height);
	//4 *Math.floor(i/(4000)) is because 1/(width*4) get me the row number (*4 'cause there are 4 elements per pixel). then, when i have the row number, *4 again because first row is 0,1,2,3 and second is 4,5,6,7 and third is 8,9,10,11
	for(num i = 0; i<img_data.data.length; i += 4){;
		if(img_data.data[i+3] >= 128){
			img_data.data[i+3] = img_data_rainbow.data[4 *(i~/(4000))+3]/2 ;//only mimic transparency. even fainter.;

		}
	}
	ctx.putImageData(img_data, 0, 0);
	//ctx.putImageData(img_data_rainbow, 0, 0);
}



//work once again gives me inspiration for this sim. thanks, bob!!!
void ghostSwap(canvas){
	if(checkSimMode() == true){
		return;
	}
	var ctx = canvas.getContext('2d');
	var img_data =ctx.getImageData(0, 0, canvas.width, canvas.height);
	String imageString = "ghostGradient.png";
    var img=querySelector("#${imageString}");
    var width = img.width;
  	var height = img.height;
	var print= true;
	 var rainbow_canvas = getBufferCanvas(querySelector("#rainbow_template"));
	var rctx = rainbow_canvas.getContext('2d');
  	rctx.drawImage(img,0,0,width,height);
	var img_data_rainbow =rctx.getImageData(0, 0,width, height);
	//4 *Math.floor(i/(4000)) is because 1/(width*4) get me the row number (*4 'cause there are 4 elements per pixel). then, when i have the row number, *4 again because first row is 0,1,2,3 and second is 4,5,6,7 and third is 8,9,10,11
	for(num i = 0; i<img_data.data.length; i += 4){;
		if(img_data.data[i+3] >= 128){
			img_data.data[i+3] = img_data_rainbow.data[4 *(i~/(4000))+3]*2 ;//only mimic transparency.;

		}
	}
	ctx.putImageData(img_data, 0, 0);
	//ctx.putImageData(img_data_rainbow, 0, 0);
}






void rainbowSwapProgram(canvas){
  if(checkSimMode() == true){
    return;
  }
	var ctx = canvas.getContext('2d');
	var img_data =ctx.getImageData(0, 0, canvas.width, canvas.height);
	var colorRatio = 1/canvas.width;
	//4 byte color array
	for(num i = 0; i<img_data.data.length; i += 4){;
		if(img_data.data[i+3] >= 128){
		  //would some sort of fractal look better here?
      img_data.data[i] = getRandomIntNoSeed(0,255);
    	img_data.data[i+1] =(i/canvas.width+ getRandomIntNoSeed(0,50))%255;
    	img_data.data[i+2] = (i/canvas.height +getRandomIntNoSeed(0,50))%255;
		  img_data.data[i+3] = 255;
		}
	}
	ctx.putImageData(img_data, 0, 0);
}


//if speed becomes an issue, take in array of color pairs to swap out
//rather than call this method once for each color
//swaps one hex color with another.
//wait no, would be same amount of things. just would have nested for loops instead of
//multiple calls
void swapColors(canvas, color1, color2){
  if(checkSimMode() == true){
    return;
  }
  var oldc = hexToRgbA(color1);
  var newc= hexToRgbA(color2);
  // print("replacing: " + oldc  + " with " + newc);
  var ctx = canvas.getContext('2d');
  var img_data =ctx.getImageData(0, 0, canvas.width, canvas.height);
  //4 byte color array
  for(num i = 0; i<img_data.data.length; i += 4){;
    if(img_data.data[i] == oldc[0] && img_data.data[i+1] == oldc[1] &&img_data.data[i+2] == oldc[2]&&img_data.data[i+3] == 255){
      img_data.data[i] = newc[0];
      img_data.data[i+1] = newc[1];
      img_data.data[i+2] = newc[2];
      img_data.data[i+3] = 255;
    }
  }
  ctx.putImageData(img_data, 0, 0);

}




void swapColors50(canvas, color1, color2){
  if(checkSimMode() == true){
    return;
  }
  var oldc = hexToRgbA(color1);
  var newc= hexToRgbA(color2);
  // print("replacing: " + oldc  + " with " + newc);
  var ctx = canvas.getContext('2d');
  var img_data =ctx.getImageData(0, 0, canvas.width, canvas.height);
  //4 byte color array
  for(num i = 0; i<img_data.data.length; i += 4){;
    if(img_data.data[i] == oldc[0] && img_data.data[i+1] == oldc[1] &&img_data.data[i+2] == oldc[2]){
      img_data.data[i] = newc[0];
      img_data.data[i+1] = newc[1];
      img_data.data[i+2] = newc[2];
      img_data.data[i+3] = 128;
    }
    /*  bg to check canvas size
    img_data.data[i] = 0;
    img_data.data[i+1] = 0;
    img_data.data[i+2] = 0;
    img_data.data[i+3] = 255;
    */
  }
  ctx.putImageData(img_data, 0, 0);

}





void grimDarkSkin(canvas){
  swapColors(canvas, "#ffffff", "#424242");
}



void peachSkin(canvas, player){
  var index = player.hair % tricksterColors.length;
  swapColors(canvas, "#ffffff", tricksterColors[index]);
}



void greySkin(canvas){
  swapColors(canvas, "#ffffff", "#c4c4c4");
}



void roboSkin(canvas){
  swapColors(canvas, "#ffffff", "#b6b6b6");
}



void wings(CanvasElement canvas, Player player){
  //blood players have no wings, all other players have wings matching
  //favorite color
  if(player.aspect == "Blood"){
    //return;  //karkat and kankri don't have wings, but is that standard? or are they just hiding them?
  }

  CanvasRenderingContext2D ctx = canvas.getContext('2d');
  var num = player.quirk.favoriteNumber;
  //num num = 5;
  String imageString = "Wings/wing"+num + ".png";
  addImageTag(imageString);
  ImageElement img=querySelector("#${imageString}");
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0);//,width,height);

  swapColors(canvas, "#ff0000",player.bloodColor);
  swapColors50(canvas, "#00ff2a",player.bloodColor);
  swapColors50(canvas, "#00ff00",player.bloodColor); //I have NO idea why some browsers render the lime parts of the wing as 00ff00 but whatever.

}



void grimDarkHalo(canvas, player){
	 var ctx = canvas.getContext('2d');
    String imageString = "grimdark.png";
    if(player.trickster){
      imageString = "squiddles_chaos.png";
    }
    addImageTag(imageString);
    var img=querySelector("#${imageString}");
    var width = img.width;
    var height = img.height;
    ctx.drawImage(img,0,0,width,height);
}


//TODO, eventually render fin1, then hair, then fin2
void fin1(canvas, player){
  if(player.bloodColor == "#610061" || player.bloodColor == "#99004d"){
    ctx = canvas.getContext('2d');
    String imageString = "fin1.png";
    addImageTag(imageString);
    var img=querySelector("#${imageString}");
    var width = img.width;
    var height = img.height;
    ctx.drawImage(img,0,0,width,height);
  }
}



void fin2(canvas, player){
  if(player.bloodColor == "#610061" || player.bloodColor == "#99004d"){
    var ctx = canvas.getContext('2d');
    String imageString = "fin2.png";
    addImageTag(imageString);
    var img=querySelector("#${imageString}");
    var width = img.width;
    var height = img.height;
    ctx.drawImage(img,0,0,width,height);
  }
}





void horns(canvas, player){
    leftHorn(canvas,player);
    rightHorn(canvas,player);
}





//horns are no longer a sprite sheet. tracy and kristi and brandon gave me advice.
//position horns on an image as big as the canvas. put the horns directly on the
//place where the head of every sprite would be.
//same for wings eventually.
void leftHorn(canvas, player){
    var ctx = canvas.getContext('2d');
    String imageString = "Horns/left"+player.leftHorn + ".png";
    addImageTag(imageString);
    var img=querySelector("#${imageString}");
    var width = img.width;
  	var height = img.height;
  	ctx.drawImage(img,0,0,width,height);
    //print("Random number is: " + randNum);
}




//parse horns sprite sheet. render a random right horn.
//right horn should be at: 120,40
void rightHorn(canvas, player){
 // print("doing right horn");
  var ctx = canvas.getContext('2d');

  String imageString = "Horns/right"+player.rightHorn + ".png";
  addImageTag(imageString);

  var img=querySelector("#${imageString}");
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);
}





void addImageTag(url){
  //print(url);
	//only do it if image hasn't already been added.
	if(querySelector("#${url}") == null) {
		String tag = '<img id ;="' + url + '" src = "images/' + url + '" style;="display:none">';
		querySelector("#image_staging").append(tag);
	}

}


/* code that implies a different way i could load images. with an async callback to img.onload
Hrrrm. Problem is that async would mean that things would be rendered in the wrong order.
could have something that knows when ALL things in a single sprite have been rendered?
function start_loading_images(ctx, canvas, view);
{
    var img = new Image();
    img.onload = () {
        //print(this);

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

dynamic drawReviveDead(div, player, ghost, enablingAspect){
  var canvasId = div.attr("id") + "commune_" +player.chatHandle + ghost.chatHandle+player.power+ghost.power;
  String canvasHTML = "<br><canvas id;='" + canvasId +"' width='" +canvasWidth + "' height;="+canvasHeight + "'>  </canvas>";
  div.append(canvasHTML);
  var canvas = querySelector("#${canvasId}");
  var pSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
  drawSprite(pSpriteBuffer,player);
  var gSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
  drawSpriteTurnways(gSpriteBuffer,ghost);

  var canvasBuffer = getBufferCanvas(querySelector("#canvas_template"));



  //leave room on left for possible 'guide' player.
  if(enablingAspect == "Life"){
    drawWhatever(canvas, "afterlife_life.png");
  }else if(enablingAspect == "Doom"){
    drawWhatever(canvas, "afterlife_doom.png");
  }
  copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,200,0);
  copyTmpCanvasToRealCanvasAtPos(canvas, gSpriteBuffer,500,0);
  if(enablingAspect == "Life"){
    drawWhatever(canvas, "life_res.png");
  }else if(enablingAspect == "Doom"){
    drawWhatever(canvas, "doom_res.png");
  }
  return canvas; //so enabling player can draw themselves on top
}





//leader is an adult, though.
void poseBabiesAsATeam(canvas, leader, players, guardians, repeatTime){
  if(checkSimMode() == true){
    return;
  }
  List<dynamic> playerBuffers = [];
  List<dynamic> guardianBuffers = [];
  var leaderBuffer = getBufferCanvas(querySelector("#sprite_template"));
  drawSprite(leaderBuffer, leader);
  for(num i = 0; i<players.length; i++){
		playerBuffers.add(getBufferCanvas(querySelector("#sprite_template")));
		drawBabySprite(playerBuffers[i],players[i],repeatTime);
	}
  for(num i = 0; i<guardians.length; i++){
		guardianBuffers.add(getBufferCanvas(querySelector("#sprite_template")));
		drawBabySprite(guardianBuffers[i],guardians[i],repeatTime);
	}
  //leader on far left, babies arranged to right.
	  copyTmpCanvasToRealCanvasAtPos(canvas, leaderBuffer,-100,0);
	  //max of 24 babies take a LOT of render time. allow just this one thing to be async.
	setTimeout((){
		num x = 50;
		num y = 0;
		num total = 0;
		for(num i = 0; i<playerBuffers.length; i++){
				if(i == 6){
					x = 50; //down a row
					y = 75;
				}
				x = x +100;
				copyTmpCanvasToRealCanvasAtPos(canvas, playerBuffers[i],x,y);
		}
		//guardians down a bit
		x = 50;
		y += 100;
		for(num i = 0; i<guardianBuffers.length; i++){
				if(i == 6){
					x = 50; //down a row
					y += 75;
				}
				x = x +100;
				copyTmpCanvasToRealCanvasAtPos(canvas, guardianBuffers[i],x,y);
		}
		},1000);

}



//might be repeats of players in there, cause of time clones
void poseAsATeam(canvas, players, repeatTime){
  if(checkSimMode() == true){
    return;
  }
	List<dynamic> spriteBuffers = [];
	num startXpt = -235;
	for(num i = 0; i<players.length; i++){
		spriteBuffers.add(getBufferCanvas(querySelector("#sprite_template")));
		drawSprite(spriteBuffers[i],players[i]);
	}

		var x = startXpt; //-275 cuts of left most part.
		num y = 0;
		num total = 0;
		for(num i = 0; i<spriteBuffers.length; i++){
			if(i == 6){
				x = startXpt; //down a row
				y = 100;
			}else if(i==12){//could be more than 12 cause time shenanigans.
				x = startXpt; //down a row
				y = 300;
			}
			x = x +150;
			copyTmpCanvasToRealCanvasAtPos(canvas, spriteBuffers[i],x,y);
		}
}



void drawGodRevival(canvas, live_players, dead_players){
  if(checkSimMode() == true){
    return;
  }
	List<dynamic> live_spriteBuffers = [];
	List<dynamic> dead_spriteBuffers = [];
	for(num i = 0; i<live_players.length; i++){
		live_spriteBuffers.add(getBufferCanvas(querySelector("#sprite_template")));
		drawSprite(live_spriteBuffers[i],live_players[i]);
	}

	for(num i = 0; i<dead_players.length; i++){
		dead_spriteBuffers.add(getBufferCanvas(querySelector("#sprite_template")));
		//drawBG(dead_spriteBuffers[i], "#00ff00", "#ff0000");
		drawSprite(dead_spriteBuffers[i],dead_players[i]);
	}

		num x = -275;
		num y = -50;
		num total = 0;
		for(num i = 0; i<live_spriteBuffers.length; i++){
			if(i == 6){
				x = -300; //down a row
				y = 100;
			}
			x = x +150;
			copyTmpCanvasToRealCanvasAtPos(canvas, live_spriteBuffers[i],x,y);
		}
		total += live_spriteBuffers.length;
		rainbowSwap(canvas);
		//render again, but offset, makes rainbow an aura
		num x = -260;
		num y = -35;
		for(num i = 0; i<live_spriteBuffers.length; i++){
			if(i == 6){
				x = -285; //down a row
				y = 85;
			}
			x = x +150;
			copyTmpCanvasToRealCanvasAtPos(canvas, live_spriteBuffers[i],x,y);
		}
		y += 50; //dead players need to be rendered higher.
		for(num i = 0; i<dead_spriteBuffers.length; i++){
			if(total == 6){
				x = -300; //down a row
				y += 120;
			}
			x = x +150;
			copyTmpCanvasToRealCanvasAtPos(canvas, dead_spriteBuffers[i],x,y);
			total ++;
		}
}



//should only be used at the end, draws the player and their stats.
void drawCharSheet(canvas, player){
  if(checkSimMode() == true){
    return;
  }
  drawSinglePlayer(canvas, player);
  drawWhatever(canvas, "charSheet.png");
  num space_between_lines = 25;
  num left_margin = 100;
  num right_margin = 300;
  num line_height = 24;
  num start = 30;
  num current = 275;

  var ctx = canvas.getContext("2d");
  //title
  ctx.font = "42px Times New Roman";
  ctx.fillStyle = "#000000";
  ctx.fillText(player.titleBasic(),left_margin+1,current+1);
  ctx.fillStyle = getColorFromAspect(player.aspect);
  ctx.fillText(player.titleBasic(),left_margin,current);
  ctx.font = "24px Times New Roman";
  ctx.fillText("(" +player.chatHandle+")",left_margin,current+ 42);

  left_margin = "10";
  current = current + 42+42;
  ctx.fillStyle = "#000000";
  var allStats = player.allStats();
  for(num i = 0; i<allStats.length; i++){
    ctx.fillText(allStats[i] +": ",left_margin,current+line_height*i);
    ctx.fillText(player.getStat(allStats[i]),right_margin,current+line_height*i);
  }
  var i = allStats.length;

    ctx.fillText("MANGRIT: ",left_margin,current+line_height*i);
    ctx.fillText(Math.round(player.permaBuffs["MANGRIT"]),right_margin,current+line_height*i);
    i++;

  ctx.fillText("Quests Completed: ",left_margin,current+line_height*i);
  ctx.fillText(player.getStat("landLevel"),right_margin,current+line_height*i);
  i++;

  ctx.fillText("Former Friends Killed: ",left_margin,current+line_height*i);
  ctx.fillText(player.pvpKillCount,right_margin,current+line_height*i);
  i++;
  ctx.fillText("Fraymotifs Unlocked: ",left_margin,current+line_height*i);
  ctx.fillText(player.fraymotifs.length,right_margin,current+line_height*i);
  i++;
  ctx.fillText("Grim Dark Level: ",left_margin,current+line_height*i);
  ctx.fillText(player.grimDark + "/4",right_margin,current+line_height*i);


  i++;
  ctx.fillText("Doomed Clones: ",left_margin,current+line_height*i);
  ctx.fillText(player.doomedTimeClones.length ,right_margin,current+line_height*i);

  i++;
  ctx.fillText("Times Died: ",left_margin,current+line_height*i);
  ctx.fillText(player.timesDied ,right_margin,current+line_height*i);

  if(player.dead){
    i++
    i++
    ctx.fillText("Final Cause of Death: ",left_margin,current+line_height*i);
    i++
    i++
    wrap_text(ctx, player.causeOfDeath , 10, current+line_height*i, line_height, 300, "left");
  }

}



void drawGetTiger(canvas, players, repeatTime){
  if(checkSimMode() == true){
    return;
  }
	List<dynamic> spriteBuffers = [];
	for(num i = 0; i<players.length; i++){
		spriteBuffers.add(getBufferCanvas(querySelector("#sprite_template")));
		drawSprite(spriteBuffers[i],players[i]);
	}

		num x = -275;
		num y = -50;

		for(num i = 0; i<spriteBuffers.length; i++){
			if(i == 6){
				x = -300; //down a row
				y = 100;
			}
			x = x +150;
			copyTmpCanvasToRealCanvasAtPos(canvas, spriteBuffers[i],x,y);
		}
		rainbowSwap(canvas);

		//render again, but offset, makes rainbow an aura
		num x = -260;
		num y = -35;
		for(num i = 0; i<spriteBuffers.length; i++){
			if(i == 6){
				x = -285; //down a row
				y = 85;
			}
			x = x +150;
			copyTmpCanvasToRealCanvasAtPos(canvas, spriteBuffers[i],x,y);
		}
}



//player on left, echeladder on right. text with boonies. all levels listed
//obtained levels have a colored background, others have black.
dynamic drawLevelUp(canvas, player, repeatTime){
  if(checkSimMode() == true){
    return;
  }
	if(player.godTier){
		//print("god tier");
		return drawLevelUpGodTier(canvas, player,repeatTime);
	}
  //for echeladder
  var canvasSpriteBuffer = getBufferCanvas(querySelector("#canvas_template"));
  var ctx = canvasSpriteBuffer.getContext('2d');
  String imageString = "echeladder.png";
  addImageTag(imageString);
  var img=querySelector("#${imageString}");
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);
  swapColors(canvasSpriteBuffer, "#4a92f7", getColorFromAspect(player.aspect));
  //set fill before you start, don't set it in the for loop, expensive
  ctx.fillStyle="#000000";
  for(num i = 0; i<level_bg_colors.length; i++){
	  if(player.level_index < i){
		//swapColors(canvasSpriteBuffer, level_bg_colors[i], "#000000" ); //black out levels i don't yet have
    //x,y,width,height
    ctx.fillRect(5,300-(21+(17)*i),192,15); //2 pixels between boxes (which are 16 big), starts at 17, y 0 is bottom.
	  }
  }

  var pSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
  	if(player.dead){
		drawSprite(pSpriteBuffer,player);
	}else{
		drawSprite(pSpriteBuffer,player);
	}

  var levelsBuffer = getBufferCanvas(querySelector("#echeladder_template"));
  writeLevels(levelsBuffer,player) //level_bg_colors,level_font_colors

	copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,0,0);
	copyTmpCanvasToRealCanvasAtPos(canvas, canvasSpriteBuffer,350,0);
	copyTmpCanvasToRealCanvasAtPos(canvas, levelsBuffer,350,0);

}



//player in center, on platform, level name underneath them. aspect symbol behind them.
//bg color is shirt color
void drawLevelUpGodTier(canvas, player, repeatTime){
	 if(checkSimMode() == true){
		return;
	}
	num leftMargin = 150;
	var levelBuffer = getBufferCanvas(querySelector("#godtierlevelup_template"));
	drawBGRadialWithWidth(canvas, leftMargin, 650,650,"#000000",getShirtColorFromAspect(player.aspect))  //650 is iold


	var symbolBuffer = getBufferCanvas(querySelector("#sprite_template"));
	drawGodSymbolBG(symbolBuffer, player);

	var godBuffer = getBufferCanvas(querySelector("#godtierlevelup_template"));
	var ctx = godBuffer.getContext('2d');
	String imageString = "godtierlevelup.png";
	addImageTag(imageString);
	var img=querySelector("#${imageString}");
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);

	var pSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
	if(player.dead){
		drawSprite(pSpriteBuffer,player);
	}else{
		drawSprite(pSpriteBuffer,player);
	}


	//drawBG(levelBuffer, "#ff0000", "#00ff00");
	writeLevelGod(levelBuffer, player);



	copyTmpCanvasToRealCanvasAtPos(canvas, symbolBuffer,leftMargin+165,0);
	copyTmpCanvasToRealCanvasAtPos(canvas, godBuffer,leftMargin+100,0);
	copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,leftMargin+100,0);
	copyTmpCanvasToRealCanvasAtPos(canvas, levelBuffer,leftMargin+-200,290) //265 is perfectly lined on rainbow //300 is a little too far down.
}



void drawGodSymbolBG(canvas, player){
	var ctx = canvas.getContext('2d');
	var imageString = player.aspect + "Big.png";
	addImageTag(imageString);
	var img=querySelector("#${imageString}");
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);

}



//true random position
void drawWhateverTerezi(canvas, imageString){
  if(checkSimMode() == true){
    return;
  }
	var ctx = canvas.getContext('2d');
	addImageTag(imageString);
	var img=querySelector("#${imageString}");
	var width = img.width;
	var height = img.height;
  //all true random
  var x = getRandomIntNoSeed(0, 50);
  var y = getRandomIntNoSeed(0,50);
  if(Math.random() > .5) x = x * -1;
  if(Math.random() > .5) y = y * -1;
	ctx.drawImage(img,x,y,width,height);
}



void drawWhateverTurnways(canvas, imageString){
  if(checkSimMode() == true){
    return;
  }
  var ctx = canvas.getContext('2d');
  ctx.imageSmoothingEnabled = false;  //should get rid of orange halo in certain browsers.
  ctx.translate(canvas.width, 0);
  ctx.scale(-1, 1);
  drawWhatever(canvas, imageString);
}



//have i really been too lazy to make this until now
void drawWhatever(canvas, imageString){
  if(checkSimMode() == true){
    return;
  }
	var ctx = canvas.getContext('2d');
	addImageTag(imageString);
	var img=querySelector("#${imageString}");
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);
}



void drawDreamBubble(canvas){
  if(checkSimMode() == true){
    return;
  }
	var ctx = canvas.getContext('2d');
	var imageString ="dreambubbles.png";
	addImageTag(imageString);
	var img=querySelector("#${imageString}");
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);

}



void drawHorrorterror(canvas){
  if(checkSimMode() == true){
    return;
  }
	var ctx = canvas.getContext('2d');
	var imageString ="horrorterror.png";
	addImageTag(imageString);
	var img=querySelector("#${imageString}");
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);

}



void drawMoon(canvas, player){
  if(checkSimMode() == true){
    return;
  }
	var ctx = canvas.getContext('2d');
	var imageString =player.moon + ".png";
	addImageTag(imageString);
	var img=querySelector("#${imageString}");
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);
}



void writeLevelGod(canvas, player){
	num left_margin = 0; //center
	var ctx = canvas.getContext("2d");
	ctx.textAlign="center";
	ctx.font = "bold 32px Times New Roman";
	ctx.fillStyle = "#000000";
	ctx.fillText(player.mylevels[player.level_index],canvas.width/2,32);
	ctx.fillStyle = "#ffffff";
	ctx.fillText(player.mylevels[player.level_index],canvas.width/2+1,32); //shadow
}



//no image, so no repeat needed.
void writeLevels(canvas, player){
	num left_margin = 101; //center
	num line_height = 17.0;
	num start = 289; //start at bottom, go up
	var current = start;
	var ctx = canvas.getContext("2d");
	ctx.textAlign="center";
	ctx.font = "bold 12px Courier New";
	ctx.fillStyle = "#ffffff";

	for(num i = 0; i<player.mylevels.length; i++){
		if(player.level_index+1 > i){
			ctx.fillStyle = level_font_colors[i];
		}else{
			ctx.fillStyle = "#ffffff";
		}
		ctx.fillText(player.mylevels[i],left_margin,current);
		current = current - line_height;
	}
}



void drawRelationshipChat(canvas, player1, player2, chat, repeatTime){

  if(checkSimMode() == true){
    return;
  }
	var canvasSpriteBuffer = getBufferCanvas(querySelector("#canvas_template"));
	var ctx = canvasSpriteBuffer.getContext('2d');
	String imageString = "pesterchum.png";
	addImageTag(imageString);
	var img=querySelector("#${imageString}");
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);

	var p1SpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
	drawSprite(p1SpriteBuffer,player1);

	var p2SpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
	drawSpriteTurnways(p2SpriteBuffer,player2);

	//don't need buffer for text?
	var textSpriteBuffer = getBufferCanvas(querySelector("#chat_text_template"));
	String introText = "-- " +player1.chatHandle + " [" + player1.chatHandleShort()+ "] began pestering ";
	introText += player2.chatHandle + " [" + player2.chatHandleShort()+ "] --";
	drawChatText(textSpriteBuffer,player1, player2, introText, chat);

	//heart or spades (moirallegence doesn't get confessed, it's more actiony)  spades is trolls only


	var r1 = player1.getRelationshipWith(player2);
	var r2 = player2.getRelationshipWith(player1);
	var r1SpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
	var r2SpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));

	if(r1.saved_type == r1.goodBig || r1.saved_type == r1.heart){
		drawHeart(r1SpriteBuffer);
	}else if(r1.saved_type == r1.badBig || r1.saved_type == r1.spades){
		drawSpade(r1SpriteBuffer);
	}

	if(r2.saved_type == r2.goodBig || r2.saved_type == r2.heart){
		drawHeart(r2SpriteBuffer);
	}else if(r2.saved_type == r2.badBig || r2.saved_type == r2.spades){
		drawSpade(r2SpriteBuffer);
	}


	//drawBG(textSpriteBuffer, "#ff9999", "#ff00ff") //test that it's actually being rendered.
	//p1 on left, chat in middle, p2 on right and flipped turnways.
	copyTmpCanvasToRealCanvasAtPos(canvas, r1SpriteBuffer,0,0);
	copyTmpCanvasToRealCanvasAtPos(canvas, r2SpriteBuffer,750,0);
	copyTmpCanvasToRealCanvasAtPos(canvas, p1SpriteBuffer,-100,0);
	copyTmpCanvasToRealCanvasAtPos(canvas, p2SpriteBuffer,650,0)//where should i put this?
	copyTmpCanvasToRealCanvasAtPos(canvas, canvasSpriteBuffer,230,0);
	copyTmpCanvasToRealCanvasAtPos(canvas, textSpriteBuffer,244,51);
}



bool checkSimMode(){
  //return true; // debugging, is loading the problem, or is this method?
  if(simulationMode == true){
    //looking for rare sessions, or getting moon prophecies.
  //  print("no canvas, are we simulatating the simulation?");
    return true;
  }
  return false;
}



void drawChatJRPlayer(canvas, chat, player){
  if(checkSimMode() == true){
    return;
  }

  var canvasSpriteBuffer = getBufferCanvas(querySelector("#canvas_template"));
	var ctx = canvasSpriteBuffer.getContext('2d');
	String imageString = "pesterchum.png";
	addImageTag(imageString);
	var img=querySelector("#${imageString}");
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);

	var jrSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
	drawJR(jrSpriteBuffer);

  var pSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
	drawSpriteTurnways(pSpriteBuffer,player);

  var textSpriteBuffer = getBufferCanvas(querySelector("#chat_text_template"));
	String introText = "-- jadedResearcher [AB] began pestering ";
	introText += player.chatHandle + " [" + player.chatHandleShort()+ "] --";
	drawChatTextJRPlayer(textSpriteBuffer, introText, chat,player);


  copyTmpCanvasToRealCanvasAtPos(canvas, jrSpriteBuffer,0,0);
	copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,650,0)//where should i put this?
	copyTmpCanvasToRealCanvasAtPos(canvas, canvasSpriteBuffer,230,0);
	copyTmpCanvasToRealCanvasAtPos(canvas, textSpriteBuffer,244,51);
}



//she is the best <3
void drawChatABJR(canvas, chat){
  if(checkSimMode() == true){
    return;
  }
  drawChatNonPlayer(canvas, chat, "-- authorBot [AB] began pestering jadedResearcher" + " [JR] --", "ab.png", "jr.png", "AB:", "JR:", "#ff0000", "#3da35a"  );
}



void drawChatJRAB(canvas, chat){
  if(checkSimMode() == true){
    return;
  }
  drawChatNonPlayer(canvas, chat, "-- jadedResearcher [JR] began pestering authorBot" + " [AB] --", "jr.png", "ab.png", "JR:", "AB:", "#3da35a", "#ff0000"  );
}




//drawChatTextNonPlayer canvas, introText, chat, player1Start, player2Start, player1Color, player2Color
//could be spadeslick talking to one of his crew,  could be an easter egg recursiveSlacker
void drawChatNonPlayer(canvas, chat, introText, player1PNG, player2PNG, player1Start, player2Start, player1Color, player2Color ){
  if(checkSimMode() == true){
    return;
  }
  var canvasSpriteBuffer = getBufferCanvas(querySelector("#canvas_template"));
	var ctx = canvasSpriteBuffer.getContext('2d');
	String imageString = "pesterchum.png";
	addImageTag(imageString);
	var img=querySelector("#${imageString}");
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);

	var p2SpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
	drawWhateverTurnways(p2SpriteBuffer, player2PNG);

	var p1SpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
	drawWhatever(p1SpriteBuffer,player1PNG);
	//don't need buffer for text?
	var textSpriteBuffer = getBufferCanvas(querySelector("#chat_text_template"));
	drawChatTextNonPlayer(textSpriteBuffer, introText, chat,player1Start, player2Start, player1Color, player2Color);
	//drawBG(textSpriteBuffer, "#ff9999", "#ff00ff") //test that it's actually being rendered.
	//p1 on left, chat in middle, p2 on right and flipped turnways.
	copyTmpCanvasToRealCanvasAtPos(canvas, p1SpriteBuffer,0,0);
	copyTmpCanvasToRealCanvasAtPos(canvas, p2SpriteBuffer,530,0)//where should i put this?
	copyTmpCanvasToRealCanvasAtPos(canvas, canvasSpriteBuffer,230,0);
	copyTmpCanvasToRealCanvasAtPos(canvas, textSpriteBuffer,244,51);


}





//hella simple, mostly gonna be used for corpses.
void drawSinglePlayer(canvas, player){
  var p1SpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
	drawSprite(p1SpriteBuffer,player);
  //drawBG(p1SpriteBuffer, "#ff9999", "#ff00ff");
  copyTmpCanvasToRealCanvasAtPos(canvas, p1SpriteBuffer,0,0);
}



//need to parse the text to figure out who is talking to determine color for chat.
void drawChat(canvas, player1, player2, chat, repeatTime, topicImage){
  if(checkSimMode() == true){
    return;
  }
	//debug("drawing chat");
	//draw sprites to buffer (don't want them pallete swapping each other)
	//then to main canvas
	var canvasSpriteBuffer = getBufferCanvas(querySelector("#canvas_template"));
	var ctx = canvasSpriteBuffer.getContext('2d');
	String imageString = "pesterchum.png";
	addImageTag(imageString);
	var img=querySelector("#${imageString}");
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);

	var p1SpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
	drawSprite(p1SpriteBuffer,player1);

	var p2SpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
	drawSpriteTurnways(p2SpriteBuffer,player2);

	//don't need buffer for text?
	var textSpriteBuffer = getBufferCanvas(querySelector("#chat_text_template"));
	String introText = "-- " +player1.chatHandle + " [" + player1.chatHandleShort()+ "] began pestering ";
	introText += player2.chatHandle + " [" + player2.chatHandleShort()+ "] --";
	drawChatText(textSpriteBuffer,player1, player2, introText, chat);
	//drawBG(textSpriteBuffer, "#ff9999", "#ff00ff") //test that it's actually being rendered.
	//p1 on left, chat in middle, p2 on right and flipped turnways.
	copyTmpCanvasToRealCanvasAtPos(canvas, p1SpriteBuffer,-100,0);
	copyTmpCanvasToRealCanvasAtPos(canvas, p2SpriteBuffer,650,0)//where should i put this?
	copyTmpCanvasToRealCanvasAtPos(canvas, canvasSpriteBuffer,230,0);
	copyTmpCanvasToRealCanvasAtPos(canvas, textSpriteBuffer,244,51);

  if(topicImage){
    var topicBuffer = getBufferCanvas(querySelector("#canvas_template"));
    drawTopic(topicBuffer, topicImage);
    copyTmpCanvasToRealCanvasAtPos(canvas, topicBuffer,0,0);
  }
}



void drawAb(canvas){
  if(checkSimMode() == true){
    return;
  }
  var ctx = canvas.getContext('2d');
  String imageString = "ab.png";
  addImageTag(imageString);
  var img=querySelector("#${imageString}");
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);
}



void drawJR(canvas, ctx){
  if(checkSimMode() == true){
    return;
  }
  if(!ctx){
	 ctx = canvas.getContext('2d');
  }
  String imageString = "jr.png";
  addImageTag(imageString);
  var img=querySelector("#${imageString}");
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);
}



void drawJRTurnways(canvas){
  if(checkSimMode() == true){
    return;
  }
  var ctx = canvas.getContext('2d');
  ctx.imageSmoothingEnabled = false;  //should get rid of orange halo in certain browsers.
  ctx.translate(canvas.width, 0);
  ctx.scale(-1, 1);
  drawJR(canvas, ctx);
}





void drawTopic(canvas, topicImage){
  if(checkSimMode() == true){
    return;
  }
  var ctx = canvas.getContext('2d');
  var imageString = topicImage;
  addImageTag(imageString);
  var img=querySelector("#${imageString}");
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);
}



void drawComboText(canvas, comboNum){
	//alert(comboNum + "x CORPSESMOOCH COMBO!!!");
	var ctx = canvas.getContext("2d");
	ctx.font = "14px Courier New Bold";
	//i wish the below two lines would disable anti-aliasing for the font.
	//then it could be the homestuck font :/
	ctx.imageSmoothingEnabled = false;
	ctx.scale(4,4);
	ctx.fillStyle = "#ff0000";  //bright candy red (most common blood color)
	String excite = "";
	for(int i = 0; i<comboNum; i++){
		excite += "!";
	}
	ctx.fillText(comboNum + "x CORPSESMOOCH COMBO"+excite,20,20);

}



void drawChatTextJRPlayer(canvas, introText, chat, player){
  num space_between_lines = 25;
	num left_margin = 8;
	num line_height = 18;
	num start = 18;
	num current = 18;
	var ctx = canvas.getContext("2d");
	ctx.font = "12px Times New Roman";
  if(player.sbahj){
    ctx.font = "12px Comic Sans MS";
  }
	ctx.fillStyle = "#000000";
	ctx.fillText(introText,left_margin*2,current);
	//need custom multi line method that allows for differnet color lines
	fillChatTextMultiLineJRPlayer(canvas, chat, player, left_margin, current+line_height*2);
}



void drawChatTextNonPlayer(canvas, introText, chat, player1Start, player2Start, player1Color, player2Color){
  num space_between_lines = 25;
	num left_margin = 8;
	num line_height = 18;
	num start = 18;
	num current = 18;
	var ctx = canvas.getContext("2d");
	ctx.font = "12px Times New Roman";
	ctx.fillStyle = "#000000";
	ctx.fillText(introText,left_margin*2,current);
	//need custom multi line method that allows for differnet color lines  fillChatTextMultiLineNonPlayer(canvas, chat, x,y,player1Start, player2Start, player1Color, player2Color);
	fillChatTextMultiLineNonPlayer(canvas, chat, left_margin, current+line_height*2,player1Start, player2Start, player1Color, player2Color);

}



void drawChatText(canvas, player1, player2, introText, chat){
	num space_between_lines = 25;
	num left_margin = 8;
	num line_height = 18;
	num start = 18;
	num current = 18;
	var ctx = canvas.getContext("2d");
	ctx.font = "12px Times New Roman";
  if(player1.sbahj){
    ctx.font = "12px Comic Sans MS";
  }
	ctx.fillStyle = "#000000";
	ctx.fillText(introText,left_margin*2,current);
	//need custom multi line method that allows for differnet color lines
	fillChatTextMultiLine(canvas, chat, player1, player2, left_margin, current+line_height*2);

}



void drawSolidBG(canvas, color){
  var ctx = canvas.getContext("2d");
	ctx.fillStyle = color;
	ctx.fillRect(0, 0, canvas.width, canvas.height);
}



void drawBG(canvas, color1, color2){
	//var c = querySelector("#${canvasId}");
	var ctx = canvas.getContext("2d");

	var grd = ctx.createLinearGradient(0, 0, 170, 0);
	grd.addColorStop(0, color1);
	grd.addColorStop(1, color2);

	ctx.fillStyle = grd;
	ctx.fillRect(0, 0, canvas.width, canvas.height);
}



void drawBGRadialWithWidth(canvas, startX, endX, width, color1, color2){
	//var c = querySelector("#${canvasId}");
	var ctx = canvas.getContext("2d");

	var grd = ctx.createRadialGradient(width/2,canvas.height/2,5,width,canvas.height,width);
	grd.addColorStop(0, color1);
	grd.addColorStop(1, color2);

	ctx.fillStyle = grd;
	ctx.fillRect(startX, 0, endX, canvas.height);
}



void denizenKill(canvas, player){
  if(checkSimMode() == true){
    return;
  }
  var p1SpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
  //drawBG(p1SpriteBuffer, "#ff9999", "#ff00ff");
	var ctx = p1SpriteBuffer.getContext('2d');
//  drawBG(p1SpriteBuffer, "#ff9999", "#ff00ff");
//  ctx.translate(canvas.width, 0);
  //ctx.rotate(90*Math.PI/180);
	String imageString = "denizoned.png";
	addImageTag(imageString);
	var img=querySelector("#${imageString}");
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height); //why can't i use a buffer, it's not showing up..
  copyTmpCanvasToRealCanvasAtPos(canvas, p1SpriteBuffer,0,0)//why is it so far right???

}



void stabs(canvas, player){
	var ctx = canvas.getContext('2d');
	String imageString = "stab.png";
	addImageTag(imageString);
	var img=querySelector("#${imageString}");
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);
	swapColors(canvas, "#fffc00", player.bloodColor);
}



void kingDeath(canvas, player){
	var ctx = canvas.getContext('2d');
	String imageString = "sceptre.png";
	addImageTag(imageString);
	var img=querySelector("#${imageString}");
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);
	swapColors(canvas, "#fffc00", player.bloodColor);
}



void bloodPuddle(canvas, player){
    var ctx = canvas.getContext('2d');
	String imageString = "blood_puddle.png";
	addImageTag(imageString);
	var img=querySelector("#${imageString}");
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);
	swapColors(canvas, "#fffc00", player.bloodColor);
}



void drawSpriteTurnways(canvas, player){
  if(checkSimMode() == true){
    return;
  }

  var ctx = canvas.getContext('2d');
  ctx.imageSmoothingEnabled = false;  //should get rid of orange halo in certain browsers.
  ctx.translate(canvas.width, 0);
  ctx.scale(-1, 1);
  drawSprite(canvas, player, ctx);

}




void drawBabySprite(canvas, player){
  if(checkSimMode() == true){
    return;
  }
    player = makeRenderingSnapshot(player);//probably dont need to, but whatever
    var ctx = canvas.getContext('2d');
    ctx.imageSmoothingEnabled = false;
    //don't forget to shrink baby
    ctx.scale(0.5,0.5);

    drawSpriteFromScratch(canvas, player, ctx, true);


}



//baby and turnways call this. will it work?
void drawSprite(canvas, player, ctx, baby){
    if(checkSimMode() == true){
      return;
    }
	var player = makeRenderingSnapshot(player);
    if(player.ghost || player.doomed){  //don't expect ghosts or doomed players to render more than a time or two, don't bother caching for now.
        //print("drawing ghost or doomed player from scratch: " + player);
        drawSpriteFromScratch(canvas, player, ctx, false);
    }else{
      var canvasDiv = querySelector("#${player.spriteCanvasID}");
      //also take care of face scratches and mind control symbols.
      copyTmpCanvasToRealCanvasAtPos(canvas, canvasDiv,0,0);
    }

    if(!baby && player.influenceSymbol){ //dont make sprite for this, always on top, unlike scars
      //wasteOfMindSymbol(canvas, player);
      influenceSymbol(canvas, player.influenceSymbol);
    }

    if(cool_kid){
      drawWhateverTerezi(canvas,"/Bodies/coolk1dlogo.png");
      drawWhateverTerezi(canvas,"/Bodies/coolk1dsword.png");
      drawWhateverTerezi(canvas,"/Bodies/coolk1dshades.png");
    }

}




void drawSpriteFromScratch(canvas, player, ctx, baby){
  //print("Drawing sprite from scratch " + player.isDreamSelf);
  if(checkSimMode() == true){
    return;
  }
	player = makeRenderingSnapshot(player);
  //could be turnways or baby
 if(!ctx){
   ctx = canvas.getContext('2d');
 }

  ctx.imageSmoothingEnabled = false;  //should get rid of orange halo in certain browsers.
  if(!baby &&(player.dead)){//only rotate once
  	ctx.translate(canvas.width, 0);
  	ctx.rotate(90*Math.PI/180);
  }

  //they are not dead, only sleeping
  if(!baby &&(player.causeOfDrain)){//only rotate once
  	ctx.translate(0, 6*canvas.height/5);
  	ctx.rotate(270*Math.PI/180);
  }

  if(!baby && player.grimDark > 3){
    grimDarkHalo(canvas,player);
  }

  if(!baby && player.isTroll&& player.godTier){//wings before sprite
    wings(canvas,player);
  }

  if(!baby && player.dead){
	   bloodPuddle(canvas, player);
  }
  hairBack(canvas, player);
  if(player.isTroll){//wings before sprite
    fin2(canvas,player);
  }

  if(!baby && !player.baby_stuck){
    playerToSprite(canvas,player);
    bloody_face(canvas, player)//not just for murder mode, because you can kill another player if THEY are murder mode.
    if(player.murderMode == true){
  	  scratch_face(canvas, player);
    }
    if(player.leftMurderMode == true){
  	  scar_face(canvas, player);
    }
	if(player.robot == true){
  	  robo_face(canvas, player);
    }
  }else{
     babySprite(canvas,player);
	 if(player.baby_stuck && !baby){
		 bloody_face(canvas, player)//not just for murder mode, because you can kill another player if THEY are murder mode.
		if(player.murderMode == true){
		  scratch_face(canvas, player);
		}
		if(player.leftMurderMode == true){
		  scar_face(canvas, player);
		}
		if(player.robot == true){
			robo_face(canvas, player);
		}

	 }
  }


  if(ouija){
    drawWhatever(canvas, "/Bodies/pen15.png");
  }

  if(faceOff){
    if(Math.random() > .9){
      drawWhatever(canvas, "/Bodies/face4.png"); ///spooky wolf easter egg.
    }else{
      drawWhatever(canvas, "/Bodies/face"+ player.baby + ".png");
    }

  }
  hair(canvas, player);
  if(player.isTroll){//wings before sprite
    fin1(canvas,player);
  }
  if(!baby && player.class_name == "Prince" && player.godTier){
	  princeTiara(canvas, player);
  }

  if(player.robot == true){
	  roboSkin(canvas, player);
  }else if(player.trickster == true){
      peachSkin(canvas, player);
  }else if(!baby && player.grimDark  > 3){
    grimDarkSkin(canvas, player);
  }else if(player.isTroll){
    greySkin(canvas,player);
  }
  if(player.isTroll){
    horns(canvas, player);
  }

  if(!baby && player.dead && player.causeOfDeath == "after being shown too many stabs from Jack"){
	 stabs(canvas,player);
 }else if(!baby && player.dead && player.causeOfDeath == "fighting the Black King"){
   kingDeath(canvas,player);
 }



  if(!baby && player.ghost){
    //wasteOfMindSymbol(canvas, player);
    //halo(canvas, player.influenceSymbol);
    if(player.causeOfDrain){
      drainedGhostSwap(canvas);
    }else{
      ghostSwap(canvas);
    }
  }

  if(!baby && player.aspect == "Void"){
    voidSwap(canvas, 1-player.power/2000) //a void player at 2000 power is fully invisible.
  }




}




void playerToSprite(canvas, player){
	var ctx = canvas.getContext('2d');
	if(player.robot == true){
		robotSprite(canvas, player);
	}else if(player.trickster){
		tricksterSprite(canvas, player);
	}else if(player.godTier){
		godTierSprite(canvas, player);
	}else if (player.isDreamSelf)
	{
		dreamSprite(canvas, player);
	}else{
		regularSprite(canvas, player);
	}
}



void robo_face(canvas, player){
	var ctx = canvas.getContext('2d');
	String imageString = "robo_face.png";
	addImageTag(imageString);
	var img=querySelector("#${imageString}");
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);
}



void scar_face(canvas, player){
	var ctx = canvas.getContext('2d');
	String imageString = "calm_scratch_face.png";
	addImageTag(imageString);
	var img=querySelector("#${imageString}");
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);
}



void scratch_face(canvas, player){
	var ctx = canvas.getContext('2d');
	String imageString = "scratch_face.png";
	addImageTag(imageString);
	var img=querySelector("#${imageString}");
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);
	swapColors(canvas, "#fffc00", player.bloodColor); //it's their own blood
}



//not just murder mode, you could have killed a murder mode player.
void bloody_face(canvas, player){
	if(player.victimBlood){
		var ctx = canvas.getContext('2d');
		String imageString = "bloody_face.png";
		addImageTag(imageString);
		var img=querySelector("#${imageString}");
		var width = img.width;
		var height = img.height;
		ctx.drawImage(img,0,0,width,height);
		swapColors(canvas, "#440a7f", player.victimBlood); //it's not their own blood
	}
}



void drawDiamond(canvas){
  if(checkSimMode() == true){
    return;
  }
	var ctx = canvas.getContext('2d');
	String imageString = "Moirail.png";
	addImageTag(imageString);
	var img=querySelector("#${imageString}");
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);
}



void drawHeart(canvas){
  if(checkSimMode() == true){
    return;
  }
	var ctx = canvas.getContext('2d');
	String imageString = "Matesprit.png";
	addImageTag(imageString);
	var img=querySelector("#${imageString}");
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);
}



void drawClub(canvas){
  if(checkSimMode() == true){
    return;
  }
	var ctx = canvas.getContext('2d');
	String imageString = "Auspisticism.png";
	addImageTag(imageString);
	var img=querySelector("#${imageString}");
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);
}



void drawSpade(canvas){
  if(checkSimMode() == true){
    return;
  }
	var ctx = canvas.getContext('2d');
	String imageString = "Kismesis.png";
	addImageTag(imageString);
	var img=querySelector("#${imageString}");
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);
}



void hairBack(canvas, player){
  var ctx = canvas.getContext('2d');
	String imageString = "Hair/hair_back"+player.hair+".png";
  //print(imageString);
	addImageTag(imageString);
	var img=querySelector("#${imageString}");
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);
  if(player.sbahj){
    sbahjifier(canvas);
  }
	if(player.isTroll){
		swapColors(canvas, "#313131",  player.hairColor);
		swapColors(canvas, "#202020", player.bloodColor);
	}else{
		swapColors(canvas, "#313131", player.hairColor);
		swapColors(canvas, "#202020", getColorFromAspect(player.aspect));
	}
}


void hair(canvas, player){
	var ctx = canvas.getContext('2d');
	String imageString = "Hair/hair"+player.hair+".png";
	addImageTag(imageString);
	var img=querySelector("#${imageString}");
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);
  if(player.sbahj){
    sbahjifier(canvas);
  }
	if(player.isTroll){
		swapColors(canvas, "#313131",  player.hairColor);
		swapColors(canvas, "#202020", player.bloodColor);
	}else{
		swapColors(canvas, "#313131", player.hairColor);
		swapColors(canvas, "#202020", getColorFromAspect(player.aspect));
	}
}



//if the Waste of Mind/Observer sends a time player back
//the influence is visible.
void drawTimeGears(canvas){
	if(checkSimMode() == true){
    return;
  }
  var p1SpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
  //drawBG(p1SpriteBuffer, "#ff9999", "#ff00ff");
  var ctx = p1SpriteBuffer.getContext('2d');
  String imageString = "gears.png";
  addImageTag(imageString);
  var img=querySelector("#${imageString}");
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);
  copyTmpCanvasToRealCanvasAtPos(canvas, p1SpriteBuffer,0,0);

}



//more than just yellow yard can do this.
void influenceSymbol(canvas, symbol){
  var ctx = canvas.getContext('2d');
  var imageString = symbol;
  addImageTag(imageString);
  var img=querySelector("#${imageString}");
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);
}



void halo(canvas, symbol){
  var ctx = canvas.getContext('2d');
  String imageString = "halo.png";
  addImageTag(imageString);
  var img=querySelector("#${imageString}");
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);
}





//if the Waste of Mind/Observer sends a time player back
//the influence is visible.
void wasteOfMindSymbol(canvas, player){
  var ctx = canvas.getContext('2d');
  String imageString = "mind_forehead.png";
  addImageTag(imageString);
  var img=querySelector("#${imageString}");
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);
}



void princeTiara(canvas, player){
	String imageString = "prince_hat.png";
	addImageTag(imageString);
	var img=querySelector("#${imageString}");
	var width = img.width;
	var height = img.height;
	var c2 = getBufferCanvas(canvas); //don't want to do color replacement on the existing image.
	ctx2 = c2.getContext('2d');
	ctx2.drawImage(img,0,0,width,height);
	aspectPalletSwap(c2, player);
	copyTmpCanvasToRealCanvas(canvas, c2);
}



//TODO put classes in THIS order and just have a single line that is all_classes.index_of(player.class_name);
String playerToRegularBody(player){
  if(easter_egg) return playerToEggBody(player);
  return "Bodies/" + "reg"+(classNameToInt(player.class_name)+1)+".png";
}



String playerToDreamBody(player){
  if(easter_egg) return playerToEggBody(player);
  return "Bodies/" + "dream"+(classNameToInt(player.class_name)+1)+".png";
}



String playerToEggBody(player){
  return "Bodies/" + "egg"+(classNameToInt(player.class_name)+1)+".png";
}



void robotSprite(canvas, player){
  var ctx = canvas.getContext('2d');
	var imageString;
	if(!player.godTier){
		imageString = playerToRegularBody(player);
	}else{
		imageString = playerToGodBody(player);
	}
	  addImageTag(imageString);
	  var img=querySelector("#${imageString}");
	  var width = img.width;
	  var height = img.height;
	  ctx.drawImage(img,0,0,width,height);
	  robotPalletSwap(canvas, player);
	  //eeeeeh...could figure out how to color swap symbol, but lazy.
}



void tricksterSprite(canvas, player){
  var ctx = canvas.getContext('2d');
	var imageString;
	if(!player.godTier){
		imageString = playerToRegularBody(player);
	}else{
		imageString = playerToGodBody(player);
	}
	  addImageTag(imageString);
	  var img=querySelector("#${imageString}");
	  var width = img.width;
	  var height = img.height;
	  ctx.drawImage(img,0,0,width,height);
	  candyPalletSwap(canvas, player);
  //aspectSymbol(canvas, player);
}



void regularSprite(canvas, player){
	var imageString = playerToRegularBody(player);
  var ctx = canvas.getContext('2d');
  addImageTag(imageString);
  var img=querySelector("#${imageString}");
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);
  if(player.sbahj){
    sbahjifier(canvas);
  }
  aspectPalletSwap(canvas, player);
  //aspectSymbol(canvas, player);
}



void dreamSprite(canvas, player){
  var imageString = playerToDreamBody(player);
  addImageTag(imageString);
  var img=querySelector("#${imageString}");
  var width = img.width;
  var height = img.height;
  var ctx = canvas.getContext("2d");
  ctx.drawImage(img,0,0,width,height);
  dreamPalletSwap(canvas, player);
}



String playerToGodBody(player){
  if(easter_egg) return playerToEggBody(player);
  return "Bodies/" + "god"+(classNameToInt(player.class_name)+1)+".png";
}



void godTierSprite(canvas, player){
	//draw class, then color like aspect, then draw chest icon
  //ctx.drawImage(img,canvas.width/2,canvas.height/2,width,height);
  var ctx = canvas.getContext("2d");
	var imageString = playerToGodBody(player);
  addImageTag(imageString);
  var img=querySelector("#${imageString}");
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);
  if(bardQuest && player.class_name == "Bard"){
    drawWhatever(canvas, "/Bodies/cod.png");
  }
  aspectPalletSwap(canvas, player);
  if(player.sbahj){
    sbahjifier(canvas);
  }
  aspectSymbol(canvas, player);
}



void babySprite(canvas, player){
  var ctx = canvas.getContext('2d');
  String imageString = "Bodies/baby"+player.baby + ".png";
  if(player.isTroll){
    imageString = "Bodies/grub"+player.baby + ".png";
  }
  addImageTag(imageString);
  var img=querySelector("#${imageString}");
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);
  if(player.sbahj){
    sbahjifier(canvas);
  }
  if(player.isTroll){
    swapColors(canvas, "#585858",player.bloodColor);
  }else{
    swapColors(canvas, "#e76700",getShirtColorFromAspect(player.aspect));
	swapColors(canvas, "#ca5b00",getDarkShirtColorFromAspect(player.aspect));
  }
}



void aspectSymbol(canvas, player){
    var ctx = canvas.getContext('2d');
    var imageString = player.aspect + ".png";
    addImageTag(imageString);
    var img=querySelector("#${imageString}");
    var width = img.width;
    var height = img.height;
    ctx.drawImage(img,0,0,width,height);
}



void dreamSymbol(canvas, player){
    var ctx = canvas.getContext('2d');
    var imageString = player.moon + "_symbol.png";
    addImageTag(imageString);
    var img=querySelector("#${imageString}");
    var width = img.width;
    var height = img.height;
    ctx.drawImage(img,0,0,width,height);
}



void robotPalletSwap(canvas, player){
	String oldcolor1 = "#FEFD49";
	String oldcolor2 = "#FEC910";
	String oldcolor3 = "#10E0FF";
	String oldcolor4 = "#00A4BB";
	String oldcolor5 = "#FA4900";
	String oldcolor6 = "#E94200";

	String oldcolor7 = "#C33700";
	String oldcolor8 = "#FF8800";
	String oldcolor9 = "#D66E04";
	String oldcolor10 = "#E76700";
	String oldcolor11 = "#CA5B00";

	String new_color1 = "#0000FF";
	String new_color2 = "#0022cf";
	var new_color3 ="#B6B6B6";
	String new_color4 = "#A6A6A6";
	String new_color5 = "#484848";
	String new_color6 = "#595959";
	String new_color7 = "#313131";
	String new_color8 = "#B6B6B6";
	String new_color9 = "#797979";
	String new_color10 = "#494949";
	String new_color11 = "#393939";


	swapColors(canvas, oldcolor1, new_color1);
	swapColors(canvas, oldcolor2, new_color2);
	swapColors(canvas, oldcolor3, new_color3);
	swapColors(canvas, oldcolor4, new_color4);
	swapColors(canvas, oldcolor5, new_color5);
	swapColors(canvas, oldcolor6, new_color6);
	swapColors(canvas, oldcolor7, new_color7);
	swapColors(canvas, oldcolor8, new_color8);
	swapColors(canvas, oldcolor9, new_color9);
	swapColors(canvas, oldcolor10, new_color10);
	swapColors(canvas, oldcolor11, new_color11);
}




void dreamPalletSwap(canvas, player){
	String oldcolor1 = "#FEFD49";
	String oldcolor2 = "#FEC910";
	String oldcolor3 = "#10E0FF";
	String oldcolor4 = "#00A4BB";
	String oldcolor5 = "#FA4900";
	String oldcolor6 = "#E94200";

	String oldcolor7 = "#C33700";
	String oldcolor8 = "#FF8800";
	String oldcolor9 = "#D66E04";
	String oldcolor10 = "#E76700";
	String oldcolor11 = "#CA5B00";

	String new_color1 = "#FFFF00";
	String new_color2 = "#FFC935";
	var new_color3 = getShirtColorFromAspect(player.aspect);
	var new_color4 = getDarkShirtColorFromAspect(player.aspect);
	String new_color5 = "#FFCC00";
	String new_color6 = "#FF9B00";
	String new_color7 = "#C66900";
	String new_color8 = "#FFD91C";
	String new_color9 = "#FFE993";
	String new_color10 = "#FFB71C";
	String new_color11 = "#C67D00";

	if(player.moon =="Derse"){
		new_color1 = "#F092FF";
		new_color2 = "#D456EA";
		new_color5 = "#C87CFF";
		new_color6 = "#AA00FF";
		new_color7 = "#6900AF";
		new_color8 = "#DE00FF";
		new_color9 = "#E760FF";
		new_color10 = "#B400CC";
		new_color11 = "#770E87";
	}

	swapColors(canvas, oldcolor1, new_color1);
	swapColors(canvas, oldcolor2, new_color2);
	swapColors(canvas, oldcolor3, new_color3);
	swapColors(canvas, oldcolor4, new_color4);
	swapColors(canvas, oldcolor5, new_color5);
	swapColors(canvas, oldcolor6, new_color6);
	swapColors(canvas, oldcolor7, new_color7);
	swapColors(canvas, oldcolor8, new_color8);
	swapColors(canvas, oldcolor9, new_color9);
	swapColors(canvas, oldcolor10, new_color10);
	swapColors(canvas, oldcolor11, new_color11);
	//dreamSymbol(canvas, player);

}



void candyPalletSwap(canvas, player){
  //not all browsers do png gama info correctly. Chrome does, firefox does not, mostly.
  //remove it entirely with this command
  //pngcrush -rem gAMA -rem cHRM -rem iCCP -rem sRGB infile.png outfile.png
  //pngcrush -rem gAMA -rem cHRM -rem iCCP -rem sRGB reg001.png reg001copy.png
  //./pngcrush -rem gAMA -rem cHRM -rem iCCP -rem sRGB stab.png stab_copy.png
	String oldcolor1 = "#FEFD49";
	String oldcolor2 = "#FEC910";
	String oldcolor3 = "#10E0FF";
	String oldcolor4 = "#00A4BB";
	String oldcolor5 = "#FA4900";
	String oldcolor6 = "#E94200";

	String oldcolor7 = "#C33700";
	String oldcolor8 = "#FF8800";
	String oldcolor9 = "#D66E04";
	String oldcolor10 = "#E76700";
	String oldcolor11 = "#CA5B00";

	String new_color1 = "#b4b4b4";
	String new_color2 = "#b4b4b4";
	String new_color3 = "#b4b4b4";
	String new_color4 = "#b4b4b4";
	String new_color5 = "#b4b4b4";
	String new_color6 = "#b4b4b4";
	String new_color7 = "#b4b4b4";
	String new_color8 = "#b4b4b4";
	String new_color9 = "#b4b4b4";
	String new_color10 = "#b4b4b4";
	String new_color11 = "#b4b4b4";


  //I am the GREETEST. Figured out how to make spreadsheet auto gen code: ="new_color"&ROW()&"='#" &B23 &"';"
  if(player.aspect =="Light"){
    new_color1= tricksterColors[0];
    new_color2= tricksterColors[1];
    new_color3= tricksterColors[2];
    new_color4=tricksterColors[3];
    new_color5= tricksterColors[4];
    new_color6= tricksterColors[5];
    new_color7= tricksterColors[6];
    new_color8= tricksterColors[7];
    new_color9= tricksterColors[8];
    new_color10= tricksterColors[9];
    new_color11= tricksterColors[10];
  }else if(player.aspect =="Breath"){
    new_color1= tricksterColors[11];
    new_color2= tricksterColors[12];
    new_color3= tricksterColors[13];
    new_color4=tricksterColors[14];
    new_color5= tricksterColors[15];
    new_color6= tricksterColors[16];
    new_color7= tricksterColors[17];
    new_color8= tricksterColors[18];
    new_color9= tricksterColors[0];
    new_color10= tricksterColors[1];
    new_color11= tricksterColors[2];
  }else if(player.aspect =="Time"){
    new_color1= tricksterColors[3];
    new_color2= tricksterColors[4];
    new_color3= tricksterColors[5];
    new_color4=tricksterColors[6];
    new_color5= tricksterColors[7];
    new_color6= tricksterColors[8];
    new_color7= tricksterColors[9];
    new_color8= tricksterColors[10];
    new_color9= tricksterColors[11];
    new_color10= tricksterColors[12];
    new_color11= tricksterColors[13];
  }else if(player.aspect =="Space"){
    new_color1= tricksterColors[14];
    new_color2= tricksterColors[15];
    new_color3= tricksterColors[16];
    new_color4=tricksterColors[17];
    new_color5= tricksterColors[18];
    new_color6= tricksterColors[0];
    new_color7= tricksterColors[1];
    new_color8= tricksterColors[2];
    new_color9= tricksterColors[3];
    new_color10= tricksterColors[4];
    new_color11= tricksterColors[5];
  }else if(player.aspect =="Heart"){
    new_color1= tricksterColors[6];
    new_color2= tricksterColors[7];
    new_color3= tricksterColors[8];
    new_color4=tricksterColors[9];
    new_color5= tricksterColors[10];
    new_color6= tricksterColors[11];
    new_color7= tricksterColors[12];
    new_color8= tricksterColors[13];
    new_color9= tricksterColors[14];
    new_color10= tricksterColors[15];
    new_color11= tricksterColors[16];
  }else if(player.aspect =="Mind"){
    new_color1= tricksterColors[17];
    new_color2= tricksterColors[18];
    new_color3= tricksterColors[17];
    new_color4=tricksterColors[16];
    new_color5= tricksterColors[15];
    new_color6= tricksterColors[14];
    new_color7= tricksterColors[13];
    new_color8= tricksterColors[12];
    new_color9= tricksterColors[11];
    new_color10= tricksterColors[10];
    new_color11= tricksterColors[9];
  }else if(player.aspect =="Life"){
    new_color1= tricksterColors[8];
    new_color2= tricksterColors[7];
    new_color3= tricksterColors[6];
    new_color4=tricksterColors[5];
    new_color5= tricksterColors[4];
    new_color6= tricksterColors[3];
    new_color7= tricksterColors[2];
    new_color8= tricksterColors[1];
    new_color9= tricksterColors[0];
    new_color10= tricksterColors[1];
    new_color11= tricksterColors[2];
  }else if(player.aspect =="Void"){
    new_color1= tricksterColors[3];
    new_color2= tricksterColors[5];
    new_color3= tricksterColors[8];
    new_color4=tricksterColors[0];
    new_color5= tricksterColors[10];
    new_color6= tricksterColors[11];
    new_color7= tricksterColors[3];
    new_color8= tricksterColors[4];
    new_color9= tricksterColors[8];
    new_color10= tricksterColors[7];
    new_color11= tricksterColors[6];
  }else if(player.aspect =="Hope"){
    new_color1= tricksterColors[10];
    new_color2= tricksterColors[9];
    new_color3= tricksterColors[8];
    new_color4=tricksterColors[7];
    new_color5= tricksterColors[6];
    new_color6= tricksterColors[5];
    new_color7= tricksterColors[4];
    new_color8= tricksterColors[3];
    new_color9= tricksterColors[2];
    new_color10= tricksterColors[1];
    new_color11= tricksterColors[0];
  }
  else if(player.aspect =="Doom"){
    new_color1= tricksterColors[18];
    new_color2= tricksterColors[17];
    new_color3= tricksterColors[16];
    new_color4=tricksterColors[0];
    new_color5= tricksterColors[15];
    new_color6= tricksterColors[14];
    new_color7= tricksterColors[13];
    new_color8= tricksterColors[12];
    new_color9= tricksterColors[10];
    new_color10= tricksterColors[9];
    new_color11= tricksterColors[10];
  }else if(player.aspect =="Rage"){
    new_color1= tricksterColors[4];
    new_color2= tricksterColors[1];
    new_color3= tricksterColors[3];
    new_color4=tricksterColors[6];
    new_color5= tricksterColors[1];
    new_color6= tricksterColors[2];
    new_color7= tricksterColors[1];
    new_color8= tricksterColors[0];
    new_color9= tricksterColors[2];
    new_color10= tricksterColors[5];
    new_color11= tricksterColors[7];
  }else if(player.aspect =="Blood"){
    new_color1= tricksterColors[1];
    new_color2= tricksterColors[2];
    new_color3= tricksterColors[3];
    new_color4=tricksterColors[4];
    new_color5= tricksterColors[5];
    new_color6= tricksterColors[10];
    new_color7= tricksterColors[18];
    new_color8= tricksterColors[15];
    new_color9= tricksterColors[14];
    new_color10= tricksterColors[13];
    new_color11= tricksterColors[0];
  }


  swapColors(canvas, oldcolor1, new_color1);
  swapColors(canvas, oldcolor2, new_color2);
  swapColors(canvas, oldcolor3, new_color3);
  swapColors(canvas, oldcolor4, new_color4);
  swapColors(canvas, oldcolor5, new_color5);
  swapColors(canvas, oldcolor6, new_color6);
  swapColors(canvas, oldcolor7, new_color7);
  swapColors(canvas, oldcolor8, new_color8);
  swapColors(canvas, oldcolor9, new_color9);
  swapColors(canvas, oldcolor10, new_color10);
  swapColors(canvas, oldcolor11, new_color11);
}




void aspectPalletSwap(canvas, player){
  //not all browsers do png gama info correctly. Chrome does, firefox does not, mostly.
  //remove it entirely with this command
  //pngcrush -rem gAMA -rem cHRM -rem iCCP -rem sRGB infile.png outfile.png
  //pngcrush -rem gAMA -rem cHRM -rem iCCP -rem sRGB reg001.png reg001copy.png
  //./pngcrush -rem gAMA -rem cHRM -rem iCCP -rem sRGB stab.png stab_copy.png
	String oldcolor1 = "#FEFD49";
	String oldcolor2 = "#FEC910";
	String oldcolor3 = "#10E0FF";
	String oldcolor4 = "#00A4BB";
	String oldcolor5 = "#FA4900";
	String oldcolor6 = "#E94200";

	String oldcolor7 = "#C33700";
	String oldcolor8 = "#FF8800";
	String oldcolor9 = "#D66E04";
	String oldcolor10 = "#E76700";
	String oldcolor11 = "#CA5B00";

	String new_color1 = "#b4b4b4";
	String new_color2 = "#b4b4b4";
	String new_color3 = "#b4b4b4";
	String new_color4 = "#b4b4b4";
	String new_color5 = "#b4b4b4";
	String new_color6 = "#b4b4b4";
	String new_color7 = "#b4b4b4";
	String new_color8 = "#b4b4b4";
	String new_color9 = "#b4b4b4";
	String new_color10 = "#b4b4b4";
	String new_color11 = "#b4b4b4";


  //I am the GREETEST. Figured out how to make spreadsheet auto gen code: ="new_color"&ROW()&"='#" &B23 &"';"
  if(player.aspect =="Light"){
    new_color1='#FEFD49';
	new_color2='#FEC910';
	new_color3='#10E0FF';
	new_color4='#00A4BB';
	new_color5='#FA4900';
	new_color6='#E94200';
	new_color7='#C33700';
	new_color8='#FF8800';
	new_color9='#D66E04';
	new_color10='#E76700';
	new_color11='#CA5B00';
  }else if(player.aspect =="Breath"){
    new_color1='#10E0FF';
	new_color2='#00A4BB';
	new_color3='#FEFD49';
	new_color4='#D6D601';
	new_color5='#0052F3';
	new_color6='#0046D1';
	new_color7='#003396';
	new_color8='#0087EB';
	new_color9='#0070ED';
	new_color10='#006BE1';
	new_color11='#0054B0';
  }else if(player.aspect =="Time"){
    new_color1='#FF2106';
	new_color2='#AD1604';
	new_color3='#030303';
	new_color4='#242424';
	new_color5='#510606';
	new_color6='#3C0404';
	new_color7='#1F0000';
	new_color8='#B70D0E';
	new_color9='#970203';
	new_color10='#8E1516';
	new_color11='#640707';
  }else if(player.aspect =="Space"){
    new_color1='#EFEFEF';
	new_color2='#DEDEDE';
	new_color3='#FF2106';
	new_color4='#B01200';
	new_color5='#2F2F30';
	new_color6='#1D1D1D';
	new_color7='#080808';
	new_color8='#030303';
	new_color9='#242424';
	new_color10='#333333';
	new_color11='#141414';
  }else if(player.aspect =="Heart"){
    new_color1='#BD1864';
	new_color2='#780F3F';
	new_color3='#1D572E';
	new_color4='#11371D';
	new_color5='#4C1026';
	new_color6='#3C0D1F';
	new_color7='#260914';
	new_color8='#6B0829';
	new_color9='#4A0818';
	new_color10='#55142A';
	new_color11='#3D0E1E';
  }else if(player.aspect =="Mind"){
    new_color1='#06FFC9';
	new_color2='#04A885';
	new_color3='#6E0E2E';
	new_color4='#4A0818';
	new_color5='#1D572E';
	new_color6='#164524';
	new_color7='#11371D';
	new_color8='#3DA35A';
	new_color9='#2E7A43';
	new_color10='#3B7E4F';
	new_color11='#265133';
  }else if(player.aspect =="Life"){
    new_color1='#76C34E';
	new_color2='#4F8234';
	new_color3='#00164F';
	new_color4='#00071A';
	new_color5='#605542';
	new_color6='#494132';
	new_color7='#2D271E';
	new_color8='#CCC4B5';
	new_color9='#A89F8D';
	new_color10='#A29989';
	new_color11='#918673';
  }else if(player.aspect =="Void"){
    new_color1='#0B1030';
	new_color2='#04091A';
	new_color3='#CCC4B5';
	new_color4='#A89F8D';
	new_color5='#00164F';
	new_color6='#00103C';
	new_color7='#00071A';
	new_color8='#033476';
	new_color9='#02285B';
	new_color10='#004CB2';
	new_color11='#003E91';
  }else if(player.aspect =="Hope"){
    new_color1='#FDF9EC';
	new_color2='#D6C794';
	new_color3='#164524';
	new_color4='#06280C';
	new_color5='#FFC331';
	new_color6='#F7BB2C';
	new_color7='#DBA523';
	new_color8='#FFE094';
	new_color9='#E8C15E';
	new_color10='#F6C54A';
	new_color11='#EDAF0C';
  }
  else if(player.aspect =="Doom"){
    new_color1='#0F0F0F';
	new_color2='#010101';
	new_color3='#E8C15E';
	new_color4='#C7A140';
	new_color5='#1E211E';
	new_color6='#141614';
	new_color7='#0B0D0B';
	new_color8='#204020';
	new_color9='#11200F';
	new_color10='#192C16';
	new_color11='#121F10';
  }else if(player.aspect =="Rage"){
    new_color1='#974AA7';
	new_color2='#6B347D';
	new_color3='#3D190A';
	new_color4='#2C1207';
	new_color5='#7C3FBA';
	new_color6='#6D34A6';
	new_color7='#592D86';
	new_color8='#381B76';
	new_color9='#1E0C47';
	new_color10='#281D36';
	new_color11='#1D1526';
  }else if(player.aspect =="Blood"){
    new_color1='#BA1016';
	new_color2='#820B0F';
	new_color3='#381B76';
	new_color4='#1E0C47';
	new_color5='#290704';
	new_color6='#230200';
	new_color7='#110000';
	new_color8='#3D190A';
	new_color9='#2C1207';
	new_color10='#5C2913';
	new_color11='#4C1F0D';
  }else{
    new_color1='#FF9B00';
  	new_color2='#FF8700';
  	new_color3='#7F7F7F';
  	new_color4='#727272';
  	new_color5='#A3A3A3';
  	new_color6='#999999';
  	new_color7='#898989';
  	new_color8='#EFEFEF';
  	new_color9='#DBDBDB';
  	new_color10='#C6C6C6';
  	new_color11='#ADADAD';
  }


  swapColors(canvas, oldcolor1, new_color1);
  swapColors(canvas, oldcolor2, new_color2);
  swapColors(canvas, oldcolor3, new_color3);
  swapColors(canvas, oldcolor4, new_color4);
  swapColors(canvas, oldcolor5, new_color5);
  swapColors(canvas, oldcolor6, new_color6);
  swapColors(canvas, oldcolor7, new_color7);
  swapColors(canvas, oldcolor8, new_color8);
  swapColors(canvas, oldcolor9, new_color9);
  swapColors(canvas, oldcolor10, new_color10);
  swapColors(canvas, oldcolor11, new_color11);

}






dynamic getBufferCanvas(canvas){
	var tmp_canvas = document.createElement('canvas');
	tmp_canvas.height = canvas.height;
	tmp_canvas.width = canvas.width;
	return tmp_canvas;
}



void copyTmpCanvasToRealCanvasAtPos(canvas, tmp_canvas, x, y){
  var ctx = canvas.getContext('2d');
	ctx.drawImage(tmp_canvas, x, y);
}



//does not work how i hoped. does not render a canvas with alpha
void copyTmpCanvasToRealCanvas50(canvas, tmp_canvas){
	var ctx = canvas.getContext('2d');
  ctx.globalAlpha = 0.5;
	ctx.drawImage(tmp_canvas, 0, 0);
}




void copyTmpCanvasToRealCanvas(canvas, tmp_canvas){
	var ctx = canvas.getContext('2d');
	ctx.drawImage(tmp_canvas, 0, 0);
}



//http://stackoverflow.com/questions/5026961/html5-canvas-ctx-filltext-wont-do-line-breaks/21574562#21574562
function fillTextMultiLine(canvas, text1, text2, color2, x, y) {
	var ctx = canvas.getContext("2d");
	var lineHeight = ctx.measureText("M").width * 1.2;
    var lines = text1.split("\n");
 	for (num i = 0; i < lines.length; ++i) {
   		ctx.fillText(lines[i], x, y);
  		y += lineHeight;
  	}
	//word wrap these
	ctx.fillStyle = color2;
 	wrap_text(ctx, text2, x, y, lineHeight, 3*canvas.width/4, "left");
	ctx.fillStyle = "#000000";
}

void fillChatTextMultiLineJRPlayer(canvas, chat, player, x, y){
  var ctx = canvas.getContext("2d");
	var lineHeight = ctx.measureText("M").width * 1.2;
    var lines = chat.split("\n");
	var playerStart = player.chatHandleShort();
	String jrStart = "JR: ";
 	for (num i = 0; i < lines.length; ++i) {
		//does the text begin with player 1's chat handle short? if so: getChatFontColor
		var ct = lines[i].trim();

		//check player 2 first 'cause they'll be more specific if they have same initials
		if(ct.startsWith(playerStart)){
			ctx.fillStyle = player.getChatFontColor();
      if(player.sbahj){
         ctx.font = "12px Comic Sans";
      }else{
        	ctx.font = "12px Times New Roman";
      }
		}else if(ct.startsWith(jrStart)){
      ctx.fillStyle = "#3da35a";
      ctx.font = "12px Times New Roman";
		}else{
			ctx.fillStyle = "#000000";
		}
		var lines_wrapped = wrap_text(ctx, ct, x, y, lineHeight, canvas.width-50, "left");
  		y += lineHeight * lines_wrapped;
  	}
	//word wrap these
	ctx.fillStyle = "#000000";
}



void fillChatTextMultiLineNonPlayer(canvas, chat, x, y, player1Start, player2Start, player1Color, player2Color){
  var ctx = canvas.getContext("2d");
	var lineHeight = ctx.measureText("M").width * 1.2;
  var lines = chat.split("\n");
 	for (num i = 0; i < lines.length; ++i) {
		//does the text begin with player 1's chat handle short? if so: getChatFontColor
		var ct = lines[i].trim();
		//check player 2 first 'cause they'll be more specific if they have same initials
		if(ct.startsWith(player2Start)){
			ctx.fillStyle = player2Color;
      ctx.font = "12px Times New Roman";
		}else if(ct.startsWith(player1Start)){
			ctx.fillStyle = player1Color;
      ctx.font = "12px Times New Roman";
		}else{
			ctx.fillStyle = "#000000";
		}
		var lines_wrapped = wrap_text(ctx, ct, x, y, lineHeight, canvas.width-50, "left");
  	y += lineHeight * lines_wrapped;
  	}
	//word wrap these
	ctx.fillStyle = "#000000";
}



//matches line color to player font color
function fillChatTextMultiLine(canvas, chat, player1, player2, x, y) {
	var ctx = canvas.getContext("2d");
	var lineHeight = ctx.measureText("M").width * 1.2;
    var lines = chat.split("\n");
	var player1Start = player1.chatHandleShort();
	var player2Start = player2.chatHandleShortCheckDup(player1Start);
 	for (num i = 0; i < lines.length; ++i) {
		//does the text begin with player 1's chat handle short? if so: getChatFontColor
		var ct = lines[i].trim();

		//check player 2 first 'cause they'll be more specific if they have same initials
		if(ct.startsWith(player2Start)){
			ctx.fillStyle = player2.getChatFontColor();
      if(player2.sbahj){
         ctx.font = "12px Comic Sans MS";
      }else{
        	ctx.font = "12px Times New Roman";
      }
		}else if(ct.startsWith(player1Start)){
			ctx.fillStyle = player1.getChatFontColor();
      if(player1.sbahj){
         ctx.font = "12px Comic Sans MS";
      }else{
        	ctx.font = "12px Times New Roman";
      }
		}else{
			ctx.fillStyle = "#000000";
		}
		var lines_wrapped = wrap_text(ctx, ct, x, y, lineHeight, canvas.width-50, "left");
  		y += lineHeight * lines_wrapped;
  	}
	//word wrap these
	ctx.fillStyle = "#000000";
}

//http://stackoverflow.com/questions/5026961/html5-canvas-ctx-filltext-wont-do-line-breaks
function wrap_text(ctx, text, x, y, lineHeight, maxWidth, textAlign) {
  if(!textAlign) textAlign = 'center';
  ctx.textAlign = textAlign;
  var words = text.split(' ');
  List<dynamic> lines = [];
  num sliceFrom = 0;
  for(num i = 0; i < words.length; i++) {
    var chunk = words.slice(sliceFrom, i).join(' ');
    var last = i ;=== words.length - 1;
    var bigger = ctx.measureText(chunk).width > maxWidth;
    if(bigger) {
      lines.add(words.slice(sliceFrom, i).join(' '))
      sliceFrom = i;
    }
    if(last) {
      lines.add(words.slice(sliceFrom, words.length).join(' '))
      sliceFrom = i;
    }
  }
  num offsetY = 0;
  num offsetX = 0;
  if(textAlign === 'center') offsetX = maxWidth / 2;
  for(num i = 0; i < lines.length; i++) {
    ctx.fillText(lines[i], x + offsetX, y + offsetY);
    offsetY = offsetY + lineHeight;
  }
  //need to return how many lines i created so that whatever called me knows where to put ITS next line.;
  return lines.length;
}
