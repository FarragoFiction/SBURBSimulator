var asyncNumSprites = 0;
function trollify(canvas,player){
   //red_array = red_context.getImageData(0, 0, red_canvas.width, red_canvas.height).data;
   //alert("I should trollify");
  //wings first, replace black and red with blood color with two opacities
  // wings(canvas,player);
   greySkin(canvas,player);
   fins(canvas, player);
   horns(canvas,player);
}

function babyTrollify(canvas,player,isRepeat){
   //red_array = red_context.getImageData(0, 0, red_canvas.width, red_canvas.height).data;
   //alert("I should trollify");
  //wings first, replace black and red with blood color with two opacities
  // wings(canvas,player);
   greySkin(canvas,player);
   babyFins(canvas, player);
   babyHorns(canvas,player,isRepeat);
}

//mod from http://stackoverflow.com/questions/21646738/convert-hex-to-rgba
function hexToRgbA(hex){
    var c;
    if(/^#([A-Fa-f0-9]{3}){1,2}$/.test(hex)){
        c= hex.substring(1).split('');
        if(c.length== 3){
            c= [c[0], c[0], c[1], c[1], c[2], c[2]];
        }
        c= '0x'+c.join('');
        //return 'rgba('+[(c>>16)&255, (c>>8)&255, c&255].join(',')+',1)';
        return [(c>>16)&255, (c>>8)&255, c&255]
    }
    throw new Error('Bad Hex ' + hex);
}


function rainbowSwap(canvas){
	ctx = canvas.getContext('2d');
	var img_data =ctx.getImageData(0, 0, canvas.width, canvas.height);
	var colorRatio = 1/canvas.width;
	//4 byte color array
	for(var i = 0; i<img_data.data.length; i += 4){
		if(img_data.data[i+3] >= 128){
		  //would some sort of fractal look better here?
		  img_data.data[i] = getRandomInt(0,255);
		  img_data.data[i+1] =(i/canvas.width+ getRandomInt(0,50))%255;
		  img_data.data[i+2] = (i/canvas.height +getRandomInt(0,50))%255;
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
function swapColors(canvas, color1, color2){
  var oldc = hexToRgbA(color1);
  var newc= hexToRgbA(color2);
  // console.log("replacing: " + oldc  + " with " + newc);
  ctx = canvas.getContext('2d');
  var img_data =ctx.getImageData(0, 0, canvas.width, canvas.height);
  //4 byte color array
  for(var i = 0; i<img_data.data.length; i += 4){
    if(img_data.data[i] == oldc[0] && img_data.data[i+1] == oldc[1] &&img_data.data[i+2] == oldc[2]&&img_data.data[i+3] == 255){
      img_data.data[i] = newc[0];
      img_data.data[i+1] = newc[1];
      img_data.data[i+2] = newc[2];
      img_data.data[i+3] = 255;
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


function swapColors50(canvas, color1, color2){
  var oldc = hexToRgbA(color1);
  var newc= hexToRgbA(color2);
  // console.log("replacing: " + oldc  + " with " + newc);
  ctx = canvas.getContext('2d');
  var img_data =ctx.getImageData(0, 0, canvas.width, canvas.height);
  //4 byte color array
  for(var i = 0; i<img_data.data.length; i += 4){
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

function grimDarkSkin(canvas){
  swapColors(canvas, "#ffffff", "#424242")
}

function greySkin(canvas){
  swapColors(canvas, "#ffffff", "#c4c4c4")
}

function wings(canvas,player){
  //blood players have no wings, all other players have wings matching
  //favorite color
  if(player.aspect == "Blood"){
    //return;  //karkat and kankri don't have wings, but is that standard? or are they just hiding them?
  }

  ctx = canvas.getContext('2d');
  var num = player.quirk.favoriteNumber;
  //var num = 5;
  var imageString = "wing"+num + ".png";
  addImageTag(imageString)
  var img=document.getElementById(imageString);
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);

  swapColors(canvas, "#ff0000",player.bloodColor);
  swapColors50(canvas, "#00ff2a",player.bloodColor);

}

function grimDarkHalo(canvas){
	ctx = canvas.getContext('2d');
    var imageString = "grimdark.png";
    addImageTag(imageString)
    var img=document.getElementById(imageString);
    var width = img.width;
    var height = img.height;
    ctx.drawImage(img,0,0,width,height);
}

function fins(canvas, player){
  if(player.bloodColor == "#610061" || player.bloodColor == "#99004d"){
    ctx = canvas.getContext('2d');
    var imageString = "fins.png";
    addImageTag(imageString)
    var img=document.getElementById(imageString);
    var width = img.width;
    var height = img.height;
    ctx.drawImage(img,0,0,width,height);
  }
}

function babyFins(canvas, player){
  if(player.bloodColor == "#610061" || player.bloodColor == "#99004d"){
    ctx = canvas.getContext('2d');
    var imageString = "fins.png";
    addImageTag(imageString)
    var img=document.getElementById(imageString);
    var width = img.width;
    var height = img.height;
    ctx.drawImage(img,-width/7,-height/5,width,height);
  }
}

function horns(canvas, player){
    leftHorn(canvas,player);
    rightHorn(canvas,player);
}

function babyHorns(canvas, player,isRepeat){
    babyLeftHorn(canvas,player,isRepeat);
    babyRightHorn(canvas,player,isRepeat);
}

//horns are no longer a sprite sheet. tracy and kristi and brandon gave me advice.
//position horns on an image as big as the canvas. put the horns directly on the
//place where the head of every sprite would be.
//same for wings eventually.
function leftHorn(canvas, player){
    ctx = canvas.getContext('2d');
    var imageString = "left"+player.leftHorn + ".png";
    addImageTag(imageString)
    var img=document.getElementById(imageString);
    var width = img.width;
  	var height = img.height;
  	ctx.drawImage(img,0,0,width,height);
    //console.log("Random number is: " + randNum)
}


//parse horns sprite sheet. render a random right horn.
//right horn should be at: 120,40
function rightHorn(canvas, player){
 // console.log("doing right horn");
  ctx = canvas.getContext('2d');

  var imageString = "right"+player.rightHorn + ".png";
  addImageTag(imageString)

  var img=document.getElementById(imageString);
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);
}

function babyLeftHorn(canvas, player){
    ctx = canvas.getContext('2d');
    //ctx.scale(.5,1);
    var imageString = "left"+player.leftHorn + ".png";
    addImageTag(imageString)
    var img=document.getElementById(imageString);
    var width = img.width;
  	var height = img.height;
  	ctx.drawImage(img,-width/6,-height/4,width,height);
}

//eventually all sprites will be standardized and won't need baby vs regular
function babyRightHorn(canvas, player){
 // console.log("doing right horn");
  ctx = canvas.getContext('2d');
//  ctx.scale(.5,1);//closer together?
  var imageString = "right"+player.rightHorn + ".png";
  addImageTag(imageString)

  var img=document.getElementById(imageString);
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,-width/7,-height/4,width,height);
}

function addImageTag(url){
  //console.log(url);
	//only do it if image hasn't already been added.
	if(document.getElementById(url) == null) {
		var tag = '<img id ="' + url + '" src = "images/' + url + '" style="display:none">';
		$("#image_staging").append(tag);
	}

}
/* code that implies a different way i could load images. with an async callback to img.onload
Hrrrm. Problem is that async would mean that things would be rendered in the wrong order.
could have something that knows when ALL things in a single sprite have been rendered?
function start_loading_images(ctx, canvas, view)
{
    var img = new Image()
    img.onload = function() {
        //console.log(this)

        x = canvas.width/2 - this.width/2
        y = canvas.height/2 - this.height/2
        ctx.drawImage(this, x,y)
        debug_image = this

        load_more_images(ctx, canvas, view, img.width, img.height)
    }
    img.src = url_for_image(view)+"&center"
}
//this one is slighlty more useful. instead of async, just asks if image is loaded or not.
http://stackoverflow.com/questions/1977871/check-if-an-image-is-loaded-no-errors-in-javascript
for now i'm okay with just waiting a half second, though.
function imgLoaded(imgElement) {
  return imgElement.complete && imgElement.naturalHeight !== 0;
}

*/

//leader is an adult, though.
function poseBabiesAsATeam(canvas, leader, players, guardians, repeatTime){
  var playerBuffers = [];
  var guardianBuffers = [];
  var leaderBuffer = getBufferCanvas(document.getElementById("sprite_template"));
  drawSprite(leaderBuffer, leader, repeatTime);
  for(var i = 0; i<players.length; i++){
		playerBuffers.push(getBufferCanvas(document.getElementById("sprite_template")));
		drawBabySprite(playerBuffers[i],players[i],repeatTime);
	}
  for(var i = 0; i<guardians.length; i++){
		guardianBuffers.push(getBufferCanvas(document.getElementById("sprite_template")));
		drawBabySprite(guardianBuffers[i],guardians[i],repeatTime);
	}
  //leader on far left, babies arranged to right.
  setTimeout(function(){
		  copyTmpCanvasToRealCanvasAtPos(canvas, leaderBuffer,-100,0)

      var x = 50;
			var y = 0;
			var total = 0;
			for(var i = 0; i<playerBuffers.length; i++){
				if(i == 6){
					x = 50; //down a row
					y = 75;
				}
				x = x +100;
				copyTmpCanvasToRealCanvasAtPos(canvas, playerBuffers[i],x,y)
			}
      //guardians down a bit
      x = 50;
      y += 100;
      for(var i = 0; i<guardianBuffers.length; i++){
				if(i == 6){
					x = 50; //down a row
					y += 75;
				}
				x = x +100;
				copyTmpCanvasToRealCanvasAtPos(canvas, guardianBuffers[i],x,y)
			}
  },repeatTime);
}

//might be repeats of players in there, cause of time clones
function poseAsATeam(canvas,players, repeatTime){
	var spriteBuffers = [];
	for(var i = 0; i<players.length; i++){
		spriteBuffers.push(getBufferCanvas(document.getElementById("sprite_template")));
		drawSprite(spriteBuffers[i],players[i],repeatTime)
	}

	setTimeout(function(){
			var x = -275;
			var y = -50;
			var total = 0;
			for(var i = 0; i<spriteBuffers.length; i++){
				if(i == 6){
					x = -300; //down a row
					y = 100;
				}else if(i==12){//could be more than 12 cause time shenanigans.
					x = -300; //down a row
					y = 250;
				}
				x = x +150;
				copyTmpCanvasToRealCanvasAtPos(canvas, spriteBuffers[i],x,y)
			}
		}, repeatTime);  //images aren't always loaded by the time i try to draw them the first time.
}

function drawGodRevival(canvas, live_players, dead_players, repeatTime){
	var live_spriteBuffers = [];
	var dead_spriteBuffers = [];
	for(var i = 0; i<live_players.length; i++){
		live_spriteBuffers.push(getBufferCanvas(document.getElementById("sprite_template")));
		drawSprite(live_spriteBuffers[i],live_players[i],repeatTime)
	}

	for(var i = 0; i<dead_players.length; i++){
		dead_spriteBuffers.push(getBufferCanvas(document.getElementById("sprite_template")));
		//drawBG(dead_spriteBuffers[i], "#00ff00", "#ff0000")
		drawSprite(dead_spriteBuffers[i],dead_players[i],repeatTime)
	}

	setTimeout(function(){
			var x = -275;
			var y = -50;
			var total = 0;
			for(var i = 0; i<live_spriteBuffers.length; i++){
				if(i == 6){
					x = -300; //down a row
					y = 100;
				}
				x = x +150;
				copyTmpCanvasToRealCanvasAtPos(canvas, live_spriteBuffers[i],x,y)
			}
			total += live_spriteBuffers.length;
			rainbowSwap(canvas);
			y += 50; //dead players need to be rendered higher.
			for(var i = 0; i<dead_spriteBuffers.length; i++){
				if(total == 6){
					x = -300; //down a row
					y += 120;
				}
				x = x +150;
				copyTmpCanvasToRealCanvasAtPos(canvas, dead_spriteBuffers[i],x,y)
				total ++;
			}
			//no rainbow for the dead.
		}, repeatTime);  //images aren't always loaded by the time i try to draw them the first time.
}


function drawGetTiger(canvas, players, repeatTime){
	var spriteBuffers = [];
	for(var i = 0; i<players.length; i++){
		spriteBuffers.push(getBufferCanvas(document.getElementById("sprite_template")));
		drawSprite(spriteBuffers[i],players[i],repeatTime)
	}

	setTimeout(function(){
			var x = -275;
			var y = -50;

			for(var i = 0; i<spriteBuffers.length; i++){
				if(i == 6){
					x = -300; //down a row
					y = 100;
				}
				x = x +150;
				copyTmpCanvasToRealCanvasAtPos(canvas, spriteBuffers[i],x,y)
			}
			rainbowSwap(canvas);
		}, repeatTime);  //images aren't always loaded by the time i try to draw them the first time.
}

//player on left, echeladder on right. text with boonies. all levels listed
//obtained levels have a colored background, others have black.
function drawLevelUp(canvas, player,repeatTime){
	if(player.godTier){
		console.log("god tier");
		return drawLevelUpGodTier(canvas, player,repeatTime);
	}
  //for echeladder
  var canvasSpriteBuffer = getBufferCanvas(document.getElementById("canvas_template"));
  ctx = canvasSpriteBuffer.getContext('2d');
  var imageString = "echeladder.png"
  addImageTag(imageString)
  var img=document.getElementById(imageString);
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);
  swapColors(canvasSpriteBuffer, "#4a92f7", getColorFromAspect(player.aspect));
  for(var i = 0; i<level_bg_colors.length; i++){
	  if(player.level_index < i){
		swapColors(canvasSpriteBuffer, level_bg_colors[i], "#000000" ); //black out levels i don't yet have
	  }
  }

  var pSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
  	if(player.dead){
		drawSprite(pSpriteBuffer,player,repeatTime)
	}else{
		drawSprite(pSpriteBuffer,player,repeatTime)
	}

  var levelsBuffer = getBufferCanvas(document.getElementById("echeladder_template"));
  writeLevels(levelsBuffer,player) //level_bg_colors,level_font_colors

  setTimeout(function(){
		copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,-100,0)
		copyTmpCanvasToRealCanvasAtPos(canvas, canvasSpriteBuffer,250,0)
		copyTmpCanvasToRealCanvasAtPos(canvas, levelsBuffer,250,0)
	}, repeatTime);  //images aren't always loaded by the time i try to draw them the first time.

}

//player in center, on platform, level name underneath them. aspect symbol behind them.
//bg color is shirt color
function drawLevelUpGodTier(canvas, player,repeatTime){
	drawBGRadialWithWidth(canvas, 650, "#000000",getShirtColorFromAspect(player.aspect))


	var symbolBuffer = getBufferCanvas(document.getElementById("sprite_template"));
	drawGodSymbolBG(symbolBuffer, player);

	var godBuffer = getBufferCanvas(document.getElementById("godtierlevelup_template"));
	ctx = godBuffer.getContext('2d');
	var imageString = "godtierlevelup.png"
	addImageTag(imageString)
	var img=document.getElementById(imageString);
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);

	var pSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
	if(player.dead){
		drawSprite(pSpriteBuffer,player,repeatTime)
	}else{
		drawSprite(pSpriteBuffer,player,repeatTime)
	}

	var levelBuffer = getBufferCanvas(document.getElementById("godtierlevelup_template"));
	//drawBG(levelBuffer, "#ff0000", "#00ff00");
	writeLevelGod(levelBuffer, player);

	setTimeout(function(){
			copyTmpCanvasToRealCanvasAtPos(canvas, symbolBuffer,150,0)
			copyTmpCanvasToRealCanvasAtPos(canvas, godBuffer,0,230)
			copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,100,-50)
			copyTmpCanvasToRealCanvasAtPos(canvas, levelBuffer,0,235)
		}, repeatTime);  //images aren't always loaded by the time i try to draw them the first time.
}

function drawGodSymbolBG(canvas, player){
	ctx = canvas.getContext('2d');
	var imageString = player.aspect + "Big.png"
	addImageTag(imageString)
	var img=document.getElementById(imageString);
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);

}

function drawMoon(canvas, player){
	ctx = canvas.getContext('2d');
	var imageString =player.moon + ".png"
	addImageTag(imageString)
	var img=document.getElementById(imageString);
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);
}

function writeLevelGod(canvas, player){
	var left_margin = 0; //center
	var ctx = canvas.getContext("2d");
	ctx.textAlign="center";
	ctx.font = "bold 32px Times New Roman"
	ctx.fillStyle = "#000000";
	ctx.fillText(player.mylevels[player.level_index],canvas.width/2,32);
	ctx.fillStyle = "#ffffff";
	ctx.fillText(player.mylevels[player.level_index],canvas.width/2+1,32); //shadow
}

//no image, so no repeat needed.
function writeLevels(canvas, player){
	var left_margin = 101; //center
	var line_height = 17.3;
	var start = 295; //start at bottom, go up
	var current = start;
	var ctx = canvas.getContext("2d");
	ctx.textAlign="center";
	ctx.font = "bold 12px Courier New"
	ctx.fillStyle = "#ffffff";

	for(var i = 0; i<player.mylevels.length; i++){
		if(player.level_index+1 > i){
			ctx.fillStyle = level_font_colors[i];
		}else{
			ctx.fillStyle = "#ffffff";
		}
		ctx.fillText(player.mylevels[i],left_margin,current);
		current = current - line_height;
	}
}

//need to parse the text to figure out who is talking to determine color for chat.
function drawChat(canvas, player1, player2, chat, repeatTime){
	//debug("drawing chat")
	//draw sprites to buffer (don't want them pallete swapping each other)
	//then to main canvas
	var canvasSpriteBuffer = getBufferCanvas(document.getElementById("canvas_template"));
	ctx = canvasSpriteBuffer.getContext('2d');
	var imageString = "pesterchum.png"
	addImageTag(imageString)
	var img=document.getElementById(imageString);
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);

	var p1SpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
	drawSprite(p1SpriteBuffer,player1,repeatTime)

	var p2SpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
	drawSpriteTurnways(p2SpriteBuffer,player2,repeatTime)

	//don't need buffer for text?
	var textSpriteBuffer = getBufferCanvas(document.getElementById("chat_text_template"));
	var introText = "-- " +player1.chatHandle + " [" + player1.chatHandleShort()+ "] began pestering ";
	introText += player2.chatHandle + " [" + player2.chatHandleShort()+ "] --";
	drawChatText(textSpriteBuffer,player1, player2, introText, chat)
	//drawBG(textSpriteBuffer, "#ff9999", "#ff00ff") //test that it's actually being rendered.
	//p1 on left, chat in middle, p2 on right and flipped turnways.
	setTimeout(function(){
			copyTmpCanvasToRealCanvasAtPos(canvas, p1SpriteBuffer,-100,0)
			copyTmpCanvasToRealCanvasAtPos(canvas, p2SpriteBuffer,650,0)//where should i put this?
			copyTmpCanvasToRealCanvasAtPos(canvas, canvasSpriteBuffer,230,0)
			copyTmpCanvasToRealCanvasAtPos(canvas, textSpriteBuffer,244,51)
		}, repeatTime);  //images aren't always loaded by the time i try to draw them the first time.
}

function drawChatText(canvas, player1, player2, introText, chat){
	var space_between_lines = 25;
	var left_margin = 8;
	var line_height = 18;
	var start = 18;
	var current = 18;
	var ctx = canvas.getContext("2d");
	ctx.font = "12px Times New Roman"
	ctx.fillStyle = "#000000";
	ctx.fillText(introText,left_margin*2,current);
	//need custom multi line method that allows for differnet color lines
	fillChatTextMultiLine(canvas, chat, player1, player2, left_margin, current+line_height*2);

}

function drawBG(canvas, color1, color2){
	//var c = document.getElementById(canvasId);
	var ctx = canvas.getContext("2d");

	var grd = ctx.createLinearGradient(0, 0, 170, 0);
	grd.addColorStop(0, color1);
	grd.addColorStop(1, color2);

	ctx.fillStyle = grd;
	ctx.fillRect(0, 0, canvas.width, canvas.height);
}

function drawBGRadialWithWidth(canvas, width, color1, color2){
	//var c = document.getElementById(canvasId);
	var ctx = canvas.getContext("2d");

	var grd = ctx.createRadialGradient(width/2,canvas.height/2,5,width,canvas.height,width);
	grd.addColorStop(0, color1);
	grd.addColorStop(1, color2);

	ctx.fillStyle = grd;
	ctx.fillRect(0, 0, width, canvas.height);
}


function bloodPuddle(canvas,player){
    ctx = canvas.getContext('2d');
	var imageString = "blood_puddle.png"
	addImageTag(imageString)
	var img=document.getElementById(imageString);
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,width/6,height/4,width,height);
	swapColors(canvas, "#fffc00", player.bloodColor);
}

function drawSpriteTurnways(canvas, player, repeatTime, isRepeat){
	player = makeRenderingSnapshot(player);
  ctx = canvas.getContext('2d');
  ctx.imageSmoothingEnabled = false;  //should get rid of orange halo in certain browsers.
  ctx.translate(canvas.width, 0);
  ctx.scale(-1, 1);

  if(player.grimDark == true){
    grimDarkHalo(canvas)
  }

  if(player.isTroll&& player.godTier){//wings before sprite
    wings(canvas,player);
  }
  playerToSprite(canvas,player);
  hair(canvas, player);
  if(player.class_name == "Prince" && player.godTier){
	  princeTiara(canvas, player);
  }

  if(player.grimDark == true){
    grimDarkSkin(canvas, player)
  }

  if(player.isTroll){
    trollify(canvas,player);
  }
  if(!isRepeat){ //first time i call it this will be null
	setTimeout(function(){
			drawSprite(canvas,player,repeatTime,true)
	}, repeatTime);  //images aren't always loaded by the time i try to draw them the first time.
  }
}

function makeRenderingSnapshot(player){
	var ret = new PlayerSnapshot();
	ret.grimDark = player.grimDark;
	ret.victimBlood = player.victimBlood;
	ret.murderMode = player.murderMode;
	ret.dead = player.dead;
	ret.isTroll = player.isTroll
	ret.godTier = player.godTier;
	ret.class_name = player.class_name;
	ret.aspect = player.aspect;
	ret.isDreamSelf = player.isDreamSelf;
	ret.hair = player.hair;
	ret.bloodColor = player.bloodColor;
	ret.hairColor = player.hairColor;
	ret.moon = player.moon;
	ret.chatHandle = player.chatHandle
	ret.leftHorn = player.leftHorn;
	ret.rightHorn = player.rightHorn;
	ret.quirk = player.quirk;
	return ret;
}

function drawBabySprite(canvas, player, repeatTime, isRepeat){
    player = makeRenderingSnapshot(player);//probably dont need to, but whatever
    ctx = canvas.getContext('2d');
    ctx.imageSmoothingEnabled = false;
    //don't forget to shrink baby
    if(!isRepeat){
      ctx.scale(0.5,0.5);
    }
    babySprite(canvas,player);
    babyHair(canvas, player);
    if(player.isTroll){
      babyTrollify(canvas,player,isRepeat); //it scales horns too
    }


    //ctx.drawImage(sprite, 100, 100);
    if(!isRepeat){ //first time i call it this will be null
     //alert("redrawing")
     //debug("Redrawing");
     asyncNumSprites +=1;
    setTimeout(function(){
      drawBabySprite(canvas,player,repeatTime,true)
    }, repeatTime,true);  //images aren't always loaded by the time i try to draw them the first time.
    }else{
      asyncNumSprites += -1
    }

}


function drawSprite(canvas, player, repeatTime, isRepeat){
	player = makeRenderingSnapshot(player);
  //debug("Drawing sprite for: " + player.title());
  //console.log("looking for canvas: " + canvas);
 // canvas = $("#"+canvasId)[0]; //don't want jquery object, want contents
  ctx = canvas.getContext('2d');
  ctx.imageSmoothingEnabled = false;  //should get rid of orange halo in certain browsers.
  if(player.dead && !isRepeat){//only rotate once
	ctx.translate(canvas.width, 0);
	ctx.rotate(90*Math.PI/180);
  }
  //sprite = new Image();
  //sprite.src = 'test.png';
  //need to get sprite from sprite sheet
  //then if trolls, do post proccesing.
  //grey skin, horns, wings in blood color
	//var width = img.width;
	//var height = img.height;
	//ctx.drawImage(sprites,0,0,width,height);
  if(player.grimDark == true){
    grimDarkHalo(canvas)
  }

  if(player.isTroll&& player.godTier){//wings before sprite
    wings(canvas,player);
  }

  if(player.dead){
	   bloodPuddle(canvas, player);
  }
  playerToSprite(canvas,player);
  bloody_face(canvas, player)//not just for murder mode, because you can kill another player if THEY are murder mode.
  if(player.murderMode == true){
	  scratch_face(canvas, player);
  }

  hair(canvas, player);
  if(player.class_name == "Prince" && player.godTier){
	  princeTiara(canvas, player);
  }

  if(player.grimDark == true){
    grimDarkSkin(canvas, player)
  }
  //then troll proccess???
  //this was for sprite sheet
  //ctx.drawImage(sprites,position[0],position[1],position[2],position[3],canvas.width/2,canvas.height/2,position[6],position[7]);
  //ctx.drawImage(img,canvas.width/2,canvas.height/2,width,height);
  if(player.isTroll){
    trollify(canvas,player);
  }



  //ctx.drawImage(sprite, 100, 100);
  if(!isRepeat){ //first time i call it this will be null
	 //alert("redrawing")
	 //debug("Redrawing");
	 asyncNumSprites +=1;
	setTimeout(function(){
		drawSprite(canvas,player,repeatTime,true)
	}, repeatTime,true);  //images aren't always loaded by the time i try to draw them the first time.
  }else{
	  asyncNumSprites += -1
  }
}


function playerToSprite(canvas, player){
	ctx = canvas.getContext('2d');
    if(player.godTier){
		godTierSprite(canvas, player);
	}else if (player.isDreamSelf)
	{
		dreamSprite(canvas, player)
	}else{
		regularSprite(canvas, player);
	}
	//TODO have dream sprites, too.
	//TODO check for murder mode or grim darkness.
}


function scratch_face(canvas, player){
	ctx = canvas.getContext('2d');
	var imageString = "scratch_face.png"
	addImageTag(imageString)
	var img=document.getElementById(imageString);
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,width/6,height/4,width,height);
	swapColors(canvas, "#440a7f", player.bloodColor); //it's their own blood
}

//not just murder mode, you could have killed a murder mode player.
function bloody_face(canvas, player){
	if(player.victimBlood){
		ctx = canvas.getContext('2d');
		var imageString = "bloody_face.png"
		addImageTag(imageString)
		var img=document.getElementById(imageString);
		var width = img.width;
		var height = img.height;
		ctx.drawImage(img,width/6,height/4,width,height);
		swapColors(canvas, "#440a7f", player.victimBlood); //it's not their own blood
	}
}

//i think laziness is why regular hair isn't drawn centered right
//regular adult sprite isn't the right size.
function babyHair(canvas, player){
	ctx = canvas.getContext('2d');
	var imageString = "hair"+player.hair+".png"
	addImageTag(imageString)
	var img=document.getElementById(imageString);
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);
	if(player.isTroll){
		swapColors(canvas, "#313131", "#000000");
		swapColors(canvas, "#202020", player.bloodColor);
	}else{
		swapColors(canvas, "#313131", player.hairColor);
		swapColors(canvas, "#202020", getColorFromAspect(player.aspect));
	}
}

function hair(canvas, player){
	ctx = canvas.getContext('2d');
	var imageString = "hair"+player.hair+".png"
	addImageTag(imageString)
	var img=document.getElementById(imageString);
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,width/6,height/4,width,height);
	if(player.isTroll){
		swapColors(canvas, "#313131", "#000000");
		swapColors(canvas, "#202020", player.bloodColor);
	}else{
		swapColors(canvas, "#313131", player.hairColor);
		swapColors(canvas, "#202020", getColorFromAspect(player.aspect));
	}
}

function princeTiara(canvas, player){
	var imageString = "prince_hat.png"
	addImageTag(imageString)
	var img=document.getElementById(imageString);
	var width = img.width;
	var height = img.height;
	var c2 = getBufferCanvas(canvas); //don't want to do color replacement on the existing image.
	ctx2 = c2.getContext('2d');
	ctx2.drawImage(img,width/6,height/4,width,height);
	aspectPalletSwap(c2, player);
	copyTmpCanvasToRealCanvas(canvas, c2)
}

function regularSprite(canvas, player){
	var imageString = "";
  if(player.class_name == "Page"){
    imageString = "reg001.png"
  }else if(player.class_name == "Knight" ){
    imageString = "reg002.png"
  }else if(player.class_name == "Witch" ){
    imageString = "reg003.png"
  }else if(player.class_name == "Sylph" ){
    imageString = "reg004.png"
  }else if(player.class_name == "Thief" ){
    imageString = "reg005.png"
  }else if(player.class_name == "Rogue" ){
    imageString = "reg006.png"
  }else if(player.class_name == "Seer" ){
    imageString = "reg007.png"
  }else if(player.class_name == "Mage" ){
    imageString = "reg008.png"
  }else if(player.class_name == "Heir" ){
    imageString = "reg009.png"
  }else if(player.class_name == "Maid" ){
    imageString = "reg010.png"
  }else if(player.class_name == "Prince" ){
    imageString = "reg011.png"
  }else if(player.class_name == "Bard" ){
    imageString = "reg012.png"
  }
  addImageTag(imageString)
  var img=document.getElementById(imageString);
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,width/6,height/4,width,height);
  aspectPalletSwap(canvas, player);
  //aspectSymbol(canvas, player);
}

function dreamSprite(canvas, player){
	var imageString = "";
  if(player.class_name == "Page"){
    imageString = "reg001.png"
  }else if(player.class_name == "Knight" ){
    imageString = "reg002.png"
  }else if(player.class_name == "Witch" ){
    imageString = "reg003.png"
  }else if(player.class_name == "Sylph" ){
    imageString = "reg004.png"
  }else if(player.class_name == "Thief" ){
    imageString = "reg005.png"
  }else if(player.class_name == "Rogue" ){
    imageString = "reg006.png"
  }else if(player.class_name == "Seer" ){
    imageString = "reg007.png"
  }else if(player.class_name == "Mage" ){
    imageString = "reg008.png"
  }else if(player.class_name == "Heir" ){
    imageString = "reg009.png"
  }else if(player.class_name == "Maid" ){
    imageString = "reg010.png"
  }else if(player.class_name == "Prince" ){
    imageString = "reg011.png"
  }else if(player.class_name == "Bard" ){
    imageString = "reg012.png"
  }
  addImageTag(imageString)
  var img=document.getElementById(imageString);
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,width/6,height/4,width,height);
  dreamPalletSwap(canvas, player);
}

function godTierSprite(canvas, player){
	//draw class, then color like aspect, then draw chest icon
  //ctx.drawImage(img,canvas.width/2,canvas.height/2,width,height);
  var imageString = "";
  if(player.class_name == "Page"){
    imageString = "001.png"
  }else if(player.class_name == "Knight" ){
    imageString = "002.png"
  }else if(player.class_name == "Witch" ){
    imageString = "003.png"
  }else if(player.class_name == "Sylph" ){
    imageString = "004.png"
  }else if(player.class_name == "Thief" ){
    imageString = "005.png"
  }else if(player.class_name == "Rogue" ){
    imageString = "006.png"
  }else if(player.class_name == "Seer" ){
    imageString = "007.png"
  }else if(player.class_name == "Mage" ){
    imageString = "008.png"
  }else if(player.class_name == "Heir" ){
    imageString = "009.png"
  }else if(player.class_name == "Maid" ){
    imageString = "010.png"
  }else if(player.class_name == "Prince" ){
    imageString = "011.png"
  }else if(player.class_name == "Bard" ){
    imageString = "012.png"
  }
  addImageTag(imageString)
  var img=document.getElementById(imageString);
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,width/6,height/4,width,height);
  aspectPalletSwap(canvas, player);
  aspectSymbol(canvas, player);
}

function babySprite(canvas,player){
  ctx = canvas.getContext('2d');
  var imageString = "baby.png"
  if(player.isTroll){
    imageString = "grub.png";
  }
  addImageTag(imageString)
  var img=document.getElementById(imageString);
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);
  if(player.isTroll){
    swapColors(canvas, "#585858",player.bloodColor);
  }else{
    swapColors(canvas, "#e76700",getShirtColorFromAspect(player.aspect));
  }
}

function aspectSymbol(canvas, player){
    ctx = canvas.getContext('2d');
    var imageString = player.aspect + ".png"
    addImageTag(imageString)
    var img=document.getElementById(imageString);
    var width = img.width;
    var height = img.height;
    ctx.drawImage(img,0,0,width,height);
}

function dreamSymbol(canvas, player){
    ctx = canvas.getContext('2d');
    var imageString = player.moon + "_symbol.png"
    addImageTag(imageString)
    var img=document.getElementById(imageString);
    var width = img.width;
    var height = img.height;
    ctx.drawImage(img,0,0,width,height);
}


function dreamPalletSwap(canvas, player){
	var oldcolor1 = "#ff8800"; //shirt
	var oldcolor2 = "#e76700"; //pants
	var oldcolor3 = "#fa4900"; //hat
	var oldcolor4 = "#fefd49"; //symbol fefd49
	var oldcolor5 = "#c33700"; //darker hat
	var oldcolor6 = "#10e0ff"; //shoes

	var newcolor1 = "#de00ff";
	var newcolor2 = "#de00ff";
	var newcolor3 = "#de00ff";
	var newcolor4 = "#f092ff";
	var newcolor5 = "#a200b7";
	var newcolor6 = player.bloodColor;

	if(player.moon =="Prospit"){
		newcolor1 = "#ffe034"
		newcolor2 = "#ffff00"
		newcolor3 = "#ffe034"
		newcolor4 ="#ffff00"
		newcolor5 = "#ffe034"; //darker hat
	}

	swapColors(canvas, oldcolor1, newcolor1)
	swapColors(canvas, oldcolor2, newcolor2)
	swapColors(canvas, oldcolor3, newcolor3)
	swapColors(canvas, oldcolor4, newcolor4)
	swapColors(canvas, oldcolor5, newcolor5)
	swapColors(canvas, oldcolor6, newcolor6)
	dreamSymbol(canvas, player);

}

function aspectPalletSwap(canvas, player){
  //not all browsers do png gama info correctly. Chrome does, firefox does not, mostly.
  //remove it entirely with this command
  //pngcrush -rem gAMA -rem cHRM -rem iCCP -rem sRGB infile.png outfile.png
  var oldcolor1 = "#ff8800"; //shirt
  var oldcolor2 = "#e76700"; //pants
  var oldcolor3 = "#fa4900"; //hat
  var oldcolor4 = "#fefd49"; //symbol fefd49
  var oldcolor5 = "#c33700"; //darker hat
  var oldcolor6 = "#10e0ff"; //shoes

  var newcolor1 = "#b4b4b4";
  var newcolor2 = "#b4b4b4";
  var newcolor3 = "#b4b4b4";
  var newcolor4 = "#b4b4b4";
  var newcolor5 = "#b4b4b4";
  var newcolor6 = "#b4b4b4";

  //why does this bug out color replacement???
  if(player.aspect =="Light"){
    newcolor1 = "#ff7f00"
    newcolor2 = "#f95900"
    newcolor3 = "#fd1000"
    newcolor4 ="#fbff00"
    newcolor5 = "#d41000"; //darker hat
    newcolor6 ="#00e4ff"
  }else if(player.aspect =="Breath"){
    newcolor1 = "#0087eb"
    newcolor2 = "#006be1"
    newcolor3 = "#0046d1"
    newcolor4 = "#10e0ff"
    newcolor5 = "#003396"
    newcolor6 = "#fefd49"
  }else if(player.aspect =="Time"){
    newcolor1 = "#b70d0e"
    newcolor2 = "#8e1516"
    newcolor3 = "#3c0404"
    newcolor4 ="#ff2106"
    newcolor5 ="#1f0000"
    newcolor6 ="#000000"
  }else if(player.aspect =="Space"){
    newcolor1 = "#030303"
    newcolor2 = "#2f2f30"
    newcolor3 = "#1d1d1d"
    newcolor4 ="#efefef"
    newcolor5 ="#141414"
    newcolor6 ="#ff2106"
  }else if(player.aspect =="Heart"){
    newcolor1 = "#6b0829" //shirt
    newcolor2 = "#55142a" //pants
    newcolor3 = "#3c0d1f"  //hat
    newcolor4 ="#bd1864"  //symbol
    newcolor5 ="#260914"  //dark hat
    newcolor6 ="#1d572e"  //shoes
  }else if(player.aspect =="Mind"){
    newcolor1 = "#3da35a" //shirt
    newcolor2 = "#3b7e4f" //pants
    newcolor3 = "#164524"  //hat
    newcolor4 ="#06ffc9"  //symbol
    newcolor5 ="#11371d"  //dark hat
    newcolor6 ="#11371d"  //shoes
  }else if(player.aspect =="Life"){
    newcolor1 = "#ccc4b5" //shirt
    newcolor2 = "#a29989" //pants
    newcolor3 = "#494132"  //hat
    newcolor4 ="#76c34e"  //symbol
    newcolor5 ="#2d271e"  //dark hat
    newcolor6 ="#00164f"  //shoes
  }else if(player.aspect =="Void"){
    newcolor1 = "#033476" //shirt
    newcolor2 = "#004cb2" //pants
    newcolor3 = "#00103c"  //hat
    newcolor4 ="#0b1741"  //symbol
    newcolor5 ="#00071a"  //dark hat
    newcolor6 ="#ccc4b5"  //shoes
  }else if(player.aspect =="Hope"){
    newcolor1 = "#ffe094" //shirt
    newcolor2 = "#f6c54a" //pants
    newcolor3 = "#f7bb2c"  //hat
    newcolor4 ="#fcf0c7"  //symbol
    newcolor5 ="#dba523"  //dark hat
    newcolor6 ="#164524"  //shoes
  }
  else if(player.aspect =="Doom"){
    newcolor1 = "#204020" //shirt
    newcolor2 = "#192c16" //pants
    newcolor3 = "#141614"  //hat
    newcolor4 ="#0f0f0f"  //symbol
    newcolor5 ="#0b0d0b"  //dark hat
    newcolor6 ="#ffe094"  //shoes
  }else if(player.aspect =="Rage"){
    newcolor1 = "#381b76" //shirt
    newcolor2 = "#281d36" //pants
    newcolor3 = "#6d34a6"  //hat
    newcolor4 ="#994bb3"  //symbol
    newcolor5 ="#592d86"  //dark hat
    newcolor6 ="#3d190a"  //shoes
  }else if(player.aspect =="Blood"){
    newcolor1 = "#3d190a" //shirt
    newcolor2 = "#5c2913" //pants
    newcolor3 = "#230200"  //hat
    newcolor4 ="#ba1016"  //symbol
    newcolor5 ="#110000"  //dark hat
    newcolor6 ="#381b76"  //shoes
  }


  swapColors(canvas, oldcolor1, newcolor1)
  swapColors(canvas, oldcolor2, newcolor2)
  swapColors(canvas, oldcolor3, newcolor3)
  swapColors(canvas, oldcolor4, newcolor4)
  swapColors(canvas, oldcolor5, newcolor5)
  swapColors(canvas, oldcolor6, newcolor6)

}


//return array of vales for draw image
  //ctx.drawImage(sprites,srcX,srcY,srcW,srcH,destX,destY,destW,destH);
//page knight witch sylph
// thief rogue seer  mage
// heir  maid  prince bard
//Tracy is going to get me individual sprites rather than this mess.
//will help with horns.
function playerToSpriteOld(player){
    //aspect determines origin
    //class determines position relative to that origin.
    var origin_x = 0;
    var origin_y = 0;
    if(player.aspect == "Light"){
        origin_x = 75;
        origin_y = 0;
    }else if(player.aspect == "Breath"){
      origin_x = 800;
      origin_y = 0;
    }else if(player.aspect == "Time"){
      origin_x = 1520;
      origin_y = 0;
    }else if(player.aspect == "Space"){
      origin_x = 2235;
      origin_y = 0;
    }else if(player.aspect == "Heart"){
      origin_x = 75;
      origin_y = 707;
    }else if(player.aspect == "Mind"){
      origin_x = 800;
      origin_y = 707;
    }else if(player.aspect == "Life"){
      origin_x = 1520;
      origin_y = 707;
    }else if(player.aspect == "Void"){
      origin_x = 2235;
      origin_y = 707;
    }else if(player.aspect == "Hope"){
      origin_x = 75;
      origin_y = 1410;
    }else if(player.aspect == "Doom"){
      origin_x = 800;
      origin_y = 1410;
    }else if(player.aspect == "Rage"){
      origin_x = 1520;
      origin_y = 1410;
    }else if(player.aspect == "Blood"){
      origin_x = 2235;
      origin_y = 1410;
    }
    var class_mod_x=0;
    var class_mod_y=0;
    if(player.class_name == "Page"){
      class_mod_x = -10;
      class_mod_y = 0;
    }else if(player.class_name == "Knight" ){
      class_mod_x = 155;
      class_mod_y = 0;
    }else if(player.class_name == "Witch" ){
      class_mod_x = 320;
      class_mod_y = 0;
    }else if(player.class_name == "Sylph" ){
      class_mod_x = 490;
      class_mod_y = 0;
    }else if(player.class_name == "Thief" ){
      class_mod_x = 0;
      class_mod_y = 230;
    }else if(player.class_name == "Rogue" ){
      class_mod_x = 155;
      class_mod_y = 230;
    }else if(player.class_name == "Seer" ){
      class_mod_x = 330;
      class_mod_y = 230;
    }else if(player.class_name == "Mage" ){
      class_mod_x = 490;
      class_mod_y = 230;
    }else if(player.class_name == "Heir" ){
      class_mod_x = 5;//windsock too big
      class_mod_y = 480;
    }else if(player.class_name == "Maid" ){
      class_mod_x = 165;
      class_mod_y = 480;
    }else if(player.class_name == "Prince" ){
      class_mod_x = 322;
      class_mod_y = 480;
    }else if(player.class_name == "Bard" ){
      class_mod_x = 480;
      class_mod_y = 480;
    }

    var x = origin_x+class_mod_x;
    var y = origin_y+class_mod_y;
    //ctx.drawImage(sprites,srcX,srcY,srcW,srcH,destX,destY,destW,destH);
    //alert("x: "+x+", y"+y);
    return [x,y,160,200, 0,0,160,200];
}

function getBufferCanvas(canvas){
	var tmp_canvas = document.createElement('canvas');
	tmp_canvas.height = canvas.height;
	tmp_canvas.width = canvas.width;
	return tmp_canvas;
}

function copyTmpCanvasToRealCanvasAtPos(canvas, tmp_canvas, x, y){
	ctx = canvas.getContext('2d');
	ctx.drawImage(tmp_canvas, x, y);
}


function copyTmpCanvasToRealCanvas(canvas, tmp_canvas){
	ctx = canvas.getContext('2d');
	ctx.drawImage(tmp_canvas, 0, 0);
}

//http://stackoverflow.com/questions/5026961/html5-canvas-ctx-filltext-wont-do-line-breaks/21574562#21574562
function fillTextMultiLine(canvas, text1, text2, color2, x, y) {
	var ctx = canvas.getContext("2d");
	var lineHeight = ctx.measureText("M").width * 1.2;
    var lines = text1.split("\n");
 	for (var i = 0; i < lines.length; ++i) {
   		ctx.fillText(lines[i], x, y);
  		y += lineHeight;
  	}
	//word wrap these
	ctx.fillStyle = color2
 	wrap_text(ctx, text2, x, y, lineHeight, 3*canvas.width/4, "left");
	ctx.fillStyle = "#000000"
}

//matches line color to player font color
function fillChatTextMultiLine(canvas, chat, player1, player2, x, y) {
	var ctx = canvas.getContext("2d");
	var lineHeight = ctx.measureText("M").width * 1.2;
    var lines = chat.split("\n");
	var player1Start = player1.chatHandleShort()
	var player2Start = player2.chatHandleShortCheckDup(player1Start);
 	for (var i = 0; i < lines.length; ++i) {
		//does the text begin with player 1's chat handle short? if so: getChatFontColor
		var ct = lines[i].trim();

		//check player 2 first 'cause they'll be more specific if they have same initials
		if(ct.startsWith(player2Start)){
			ctx.fillStyle = player2.getChatFontColor();
      if(player2.grimDark == true) {
        	ctx.font = "12px horrorterror"
      }else{
        	ctx.font = "12px Times New Roman"
      }
		}else if(ct.startsWith(player1Start)){
			ctx.fillStyle = player1.getChatFontColor();
      if(player1.grimDark == true){
        	ctx.font = "12px horrorterror"
      }else{
        	ctx.font = "12px Times New Roman"
      }
		}else{
			ctx.fillStyle = "#000000"
		}
		var lines_wrapped = wrap_text(ctx, ct, x, y, lineHeight, canvas.width-50, "left")
  		y += lineHeight * lines_wrapped;
  	}
	//word wrap these
	ctx.fillStyle = "#000000"
}

//http://stackoverflow.com/questions/5026961/html5-canvas-ctx-filltext-wont-do-line-breaks
function wrap_text(ctx, text, x, y, lineHeight, maxWidth, textAlign) {
  if(!textAlign) textAlign = 'center'
  ctx.textAlign = textAlign
  var words = text.split(' ')
  var lines = []
  var sliceFrom = 0
  for(var i = 0; i < words.length; i++) {
    var chunk = words.slice(sliceFrom, i).join(' ')
    var last = i === words.length - 1
    var bigger = ctx.measureText(chunk).width > maxWidth
    if(bigger) {
      lines.push(words.slice(sliceFrom, i).join(' '))
      sliceFrom = i
    }
    if(last) {
      lines.push(words.slice(sliceFrom, words.length).join(' '))
      sliceFrom = i
    }
  }
  var offsetY = 0
  var offsetX = 0
  if(textAlign === 'center') offsetX = maxWidth / 2
  for(var i = 0; i < lines.length; i++) {
    ctx.fillText(lines[i], x + offsetX, y + offsetY)
    offsetY = offsetY + lineHeight
  }
  //need to return how many lines i created so that whatever called me knows where to put ITS next line.
  return lines.length;
}
