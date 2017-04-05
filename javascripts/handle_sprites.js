var asyncNumSprites = 0;
//~~~~~~~~~~~IMPORTANT~~~~~~~~~~LET NOTHING HERE BE RANDOM
//OR PREDICTIONS AND TIME LOOPS AND AI SEARCHES WILL BE WRONG

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
  if(checkSimMode() == true){
    return;
  }
	ctx = canvas.getContext('2d');
	var img_data =ctx.getImageData(0, 0, canvas.width, canvas.height);
	var colorRatio = 1/canvas.width;
	//4 byte color array
	for(var i = 0; i<img_data.data.length; i += 4){
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
function swapColors(canvas, color1, color2){
  if(checkSimMode() == true){
    return;
  }
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
  }
  ctx.putImageData(img_data, 0, 0);

}


function swapColors50(canvas, color1, color2){
  if(checkSimMode() == true){
    return;
  }
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

function peachSkin(canvas){
  swapColors(canvas, "#ffffff", "#ffceb1")
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
  var imageString = "Wings/wing"+num + ".png";
  addImageTag(imageString)
  var img=document.getElementById(imageString);
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);

  swapColors(canvas, "#ff0000",player.bloodColor);
  swapColors50(canvas, "#00ff2a",player.bloodColor);
  swapColors50(canvas, "#00ff00",player.bloodColor); //I have NO idea why some browsers render the lime parts of the wing as 00ff00 but whatever.

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
//TODO, eventually render fin1, then hair, then fin2
function fin1(canvas, player){
  if(player.bloodColor == "#610061" || player.bloodColor == "#99004d"){
    ctx = canvas.getContext('2d');
    var imageString = "fin1.png";
    addImageTag(imageString)
    var img=document.getElementById(imageString);
    var width = img.width;
    var height = img.height;
    ctx.drawImage(img,0,0,width,height);
  }
}

function fin2(canvas, player){
  if(player.bloodColor == "#610061" || player.bloodColor == "#99004d"){
    ctx = canvas.getContext('2d');
    var imageString = "fin2.png";
    addImageTag(imageString)
    var img=document.getElementById(imageString);
    var width = img.width;
    var height = img.height;
    ctx.drawImage(img,0,0,width,height);
  }
}



function horns(canvas, player){
    leftHorn(canvas,player);
    rightHorn(canvas,player);
}



//horns are no longer a sprite sheet. tracy and kristi and brandon gave me advice.
//position horns on an image as big as the canvas. put the horns directly on the
//place where the head of every sprite would be.
//same for wings eventually.
function leftHorn(canvas, player){
    ctx = canvas.getContext('2d');
    var imageString = "Horns/left"+player.leftHorn + ".png";
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

  var imageString = "Horns/right"+player.rightHorn + ".png";
  addImageTag(imageString)

  var img=document.getElementById(imageString);
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);
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
  if(checkSimMode() == true){
    return;
  }
  var playerBuffers = [];
  var guardianBuffers = [];
  var leaderBuffer = getBufferCanvas(document.getElementById("sprite_template"));
  drawSprite(leaderBuffer, leader);
  for(var i = 0; i<players.length; i++){
		playerBuffers.push(getBufferCanvas(document.getElementById("sprite_template")));
		drawBabySprite(playerBuffers[i],players[i],repeatTime);
	}
  for(var i = 0; i<guardians.length; i++){
		guardianBuffers.push(getBufferCanvas(document.getElementById("sprite_template")));
		drawBabySprite(guardianBuffers[i],guardians[i],repeatTime);
	}
  //leader on far left, babies arranged to right.
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
}

//might be repeats of players in there, cause of time clones
function poseAsATeam(canvas,players, repeatTime){
  if(checkSimMode() == true){
    return;
  }
	var spriteBuffers = [];
	for(var i = 0; i<players.length; i++){
		spriteBuffers.push(getBufferCanvas(document.getElementById("sprite_template")));
		drawSprite(spriteBuffers[i],players[i])
	}
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
}

function drawGodRevival(canvas, live_players, dead_players, repeatTime){
  if(checkSimMode() == true){
    return;
  }
	var live_spriteBuffers = [];
	var dead_spriteBuffers = [];
	for(var i = 0; i<live_players.length; i++){
		live_spriteBuffers.push(getBufferCanvas(document.getElementById("sprite_template")));
		drawSprite(live_spriteBuffers[i],live_players[i])
	}

	for(var i = 0; i<dead_players.length; i++){
		dead_spriteBuffers.push(getBufferCanvas(document.getElementById("sprite_template")));
		//drawBG(dead_spriteBuffers[i], "#00ff00", "#ff0000")
		drawSprite(dead_spriteBuffers[i],dead_players[i])
	}

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
		//render again, but offset, makes rainbow an aura
		var x = -260;
		var y = -35;
		for(var i = 0; i<live_spriteBuffers.length; i++){
			if(i == 6){
				x = -285; //down a row
				y = 85;
			}
			x = x +150;
			copyTmpCanvasToRealCanvasAtPos(canvas, live_spriteBuffers[i],x,y)
		}
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
}


function drawGetTiger(canvas, players, repeatTime){
  if(checkSimMode() == true){
    return;
  }
	var spriteBuffers = [];
	for(var i = 0; i<players.length; i++){
		spriteBuffers.push(getBufferCanvas(document.getElementById("sprite_template")));
		drawSprite(spriteBuffers[i],players[i])
	}

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

		//render again, but offset, makes rainbow an aura
		var x = -260;
		var y = -35;
		for(var i = 0; i<spriteBuffers.length; i++){
			if(i == 6){
				x = -285; //down a row
				y = 85;
			}
			x = x +150;
			copyTmpCanvasToRealCanvasAtPos(canvas, spriteBuffers[i],x,y)
		}
}

//player on left, echeladder on right. text with boonies. all levels listed
//obtained levels have a colored background, others have black.
function drawLevelUp(canvas, player,repeatTime){
  if(checkSimMode() == true){
    return;
  }
	if(player.godTier){
		//console.log("god tier");
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
		drawSprite(pSpriteBuffer,player)
	}else{
		drawSprite(pSpriteBuffer,player)
	}

  var levelsBuffer = getBufferCanvas(document.getElementById("echeladder_template"));
  writeLevels(levelsBuffer,player) //level_bg_colors,level_font_colors

	copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,-100,0)
	copyTmpCanvasToRealCanvasAtPos(canvas, canvasSpriteBuffer,250,0)
	copyTmpCanvasToRealCanvasAtPos(canvas, levelsBuffer,250,0)

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
		drawSprite(pSpriteBuffer,player)
	}else{
		drawSprite(pSpriteBuffer,player)
	}

	var levelBuffer = getBufferCanvas(document.getElementById("godtierlevelup_template"));
	//drawBG(levelBuffer, "#ff0000", "#00ff00");
	writeLevelGod(levelBuffer, player);

	copyTmpCanvasToRealCanvasAtPos(canvas, symbolBuffer,150,0)
	copyTmpCanvasToRealCanvasAtPos(canvas, godBuffer,0,230)
	copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,100,-50)
	copyTmpCanvasToRealCanvasAtPos(canvas, levelBuffer,0,235)
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
  if(checkSimMode() == true){
    return;
  }
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

function drawRelationshipChat(canvas, player1, player2, chat, repeatTime){

  if(checkSimMode() == true){
    return;
  }
	var canvasSpriteBuffer = getBufferCanvas(document.getElementById("canvas_template"));
	ctx = canvasSpriteBuffer.getContext('2d');
	var imageString = "pesterchum.png"
	addImageTag(imageString)
	var img=document.getElementById(imageString);
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);

	var p1SpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
	drawSprite(p1SpriteBuffer,player1)

	var p2SpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
	drawSpriteTurnways(p2SpriteBuffer,player2)

	//don't need buffer for text?
	var textSpriteBuffer = getBufferCanvas(document.getElementById("chat_text_template"));
	var introText = "-- " +player1.chatHandle + " [" + player1.chatHandleShort()+ "] began pestering ";
	introText += player2.chatHandle + " [" + player2.chatHandleShort()+ "] --";
	drawChatText(textSpriteBuffer,player1, player2, introText, chat)

	//heart or spades (moirallegence doesn't get confessed, it's more actiony)  spades is trolls only


	var r1 = player1.getRelationshipWith(player2);
	var r2 = player2.getRelationshipWith(player1);
	var r1SpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
	var r2SpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));

	if(r1.saved_type == r1.goodBig || r1.saved_type == r1.heart){
		drawHeart(r1SpriteBuffer)
	}else if(r1.saved_type == r1.badBig || r1.saved_type == r1.spades){
		drawSpade(r1SpriteBuffer)
	}

	if(r2.saved_type == r2.goodBig || r2.saved_type == r2.heart){
		drawHeart(r2SpriteBuffer)
	}else if(r2.saved_type == r2.badBig || r2.saved_type == r2.spades){
		drawSpade(r2SpriteBuffer)
	}


	//drawBG(textSpriteBuffer, "#ff9999", "#ff00ff") //test that it's actually being rendered.
	//p1 on left, chat in middle, p2 on right and flipped turnways.
	copyTmpCanvasToRealCanvasAtPos(canvas, r1SpriteBuffer,0,0)
	copyTmpCanvasToRealCanvasAtPos(canvas, r2SpriteBuffer,750,0)
	copyTmpCanvasToRealCanvasAtPos(canvas, p1SpriteBuffer,-100,0)
	copyTmpCanvasToRealCanvasAtPos(canvas, p2SpriteBuffer,650,0)//where should i put this?
	copyTmpCanvasToRealCanvasAtPos(canvas, canvasSpriteBuffer,230,0)
	copyTmpCanvasToRealCanvasAtPos(canvas, textSpriteBuffer,244,51)
}

function checkSimMode(){
  //return true; // debugging, is loading the problem, or is this method?
  if(simulationMode == true){
    //looking for rare sessions, or getting moon prophecies.
  //  console.log("no canvas, are we simulatating the simulation?")
    return true;
  }
  return false
}

function drawChatJRPlayer(canvas, chat, player){
  if(checkSimMode() == true){
    return;
  }

  var canvasSpriteBuffer = getBufferCanvas(document.getElementById("canvas_template"));
	ctx = canvasSpriteBuffer.getContext('2d');
	var imageString = "pesterchum.png"
	addImageTag(imageString)
	var img=document.getElementById(imageString);
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);

	var jrSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
	drawJR(jrSpriteBuffer)

  var pSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
	drawSpriteTurnways(pSpriteBuffer,player)

  var textSpriteBuffer = getBufferCanvas(document.getElementById("chat_text_template"));
	var introText = "-- jadedResearcher [AB] began pestering ";
	introText += player.chatHandle + " [" + player.chatHandleShort()+ "] --";
	drawChatTextJRPlayer(textSpriteBuffer, introText, chat,player)


  copyTmpCanvasToRealCanvasAtPos(canvas, jrSpriteBuffer,0,0)
	copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,650,0)//where should i put this?
	copyTmpCanvasToRealCanvasAtPos(canvas, canvasSpriteBuffer,230,0)
	copyTmpCanvasToRealCanvasAtPos(canvas, textSpriteBuffer,244,51)
}

//she is the best <3
function  drawChatABJR(canvas, chat){
  if(checkSimMode() == true){
    return;
  }

  var canvasSpriteBuffer = getBufferCanvas(document.getElementById("canvas_template"));
	ctx = canvasSpriteBuffer.getContext('2d');
	var imageString = "pesterchum.png"
	addImageTag(imageString)
	var img=document.getElementById(imageString);
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);

	var p2SpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
	drawJRTurnways(p2SpriteBuffer)

	var p1SpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
	drawAb(p1SpriteBuffer)
	//don't need buffer for text?
	var textSpriteBuffer = getBufferCanvas(document.getElementById("chat_text_template"));
	var introText = "-- authorBot [AB] began pestering ";
	introText += "jadedResearcher" + " [JR] --";
	drawChatTextAB(textSpriteBuffer, introText, chat)
	//drawBG(textSpriteBuffer, "#ff9999", "#ff00ff") //test that it's actually being rendered.
	//p1 on left, chat in middle, p2 on right and flipped turnways.
	copyTmpCanvasToRealCanvasAtPos(canvas, p1SpriteBuffer,0,0)
	copyTmpCanvasToRealCanvasAtPos(canvas, p2SpriteBuffer,530,0)//where should i put this?
	copyTmpCanvasToRealCanvasAtPos(canvas, canvasSpriteBuffer,230,0)
	copyTmpCanvasToRealCanvasAtPos(canvas, textSpriteBuffer,244,51)
}

//hella simple, mostly gonna be used for corpses.
function drawSinglePlayer(canvas, player){
  var p1SpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
	drawSprite(p1SpriteBuffer,player)
  //drawBG(p1SpriteBuffer, "#ff9999", "#ff00ff")
  copyTmpCanvasToRealCanvasAtPos(canvas, p1SpriteBuffer,-100,0)
}

//need to parse the text to figure out who is talking to determine color for chat.
function drawChat(canvas, player1, player2, chat, repeatTime,topicImage){
  if(checkSimMode() == true){
    return;
  }
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
	drawSprite(p1SpriteBuffer,player1)

	var p2SpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
	drawSpriteTurnways(p2SpriteBuffer,player2)

	//don't need buffer for text?
	var textSpriteBuffer = getBufferCanvas(document.getElementById("chat_text_template"));
	var introText = "-- " +player1.chatHandle + " [" + player1.chatHandleShort()+ "] began pestering ";
	introText += player2.chatHandle + " [" + player2.chatHandleShort()+ "] --";
	drawChatText(textSpriteBuffer,player1, player2, introText, chat)
	//drawBG(textSpriteBuffer, "#ff9999", "#ff00ff") //test that it's actually being rendered.
	//p1 on left, chat in middle, p2 on right and flipped turnways.
	copyTmpCanvasToRealCanvasAtPos(canvas, p1SpriteBuffer,-100,0)
	copyTmpCanvasToRealCanvasAtPos(canvas, p2SpriteBuffer,650,0)//where should i put this?
	copyTmpCanvasToRealCanvasAtPos(canvas, canvasSpriteBuffer,230,0)
	copyTmpCanvasToRealCanvasAtPos(canvas, textSpriteBuffer,244,51)

  if(topicImage){
    var topicBuffer = getBufferCanvas(document.getElementById("canvas_template"));
    drawTopic(topicBuffer, topicImage);
    copyTmpCanvasToRealCanvasAtPos(canvas, topicBuffer,0,0)
  }
}

function drawAb(canvas){
  if(checkSimMode() == true){
    return;
  }
  ctx = canvas.getContext('2d');
  var imageString = "ab.png"
  addImageTag(imageString)
  var img=document.getElementById(imageString);
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);
}

function drawJR(canvas,ctx){
  if(checkSimMode() == true){
    return;
  }
  if(!ctx){
	ctx = canvas.getContext('2d');
  }
  var imageString = "jr.png"
  addImageTag(imageString)
  var img=document.getElementById(imageString);
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);
}

function drawJRTurnways(canvas){
  if(checkSimMode() == true){
    return;
  }
  ctx = canvas.getContext('2d');
  ctx.imageSmoothingEnabled = false;  //should get rid of orange halo in certain browsers.
  ctx.translate(canvas.width, 0);
  ctx.scale(-1, 1);
  drawJR(canvas, ctx);
}



function drawTopic(canvas, topicImage){
  if(checkSimMode() == true){
    return;
  }
  ctx = canvas.getContext('2d');
  var imageString = topicImage
  addImageTag(imageString)
  var img=document.getElementById(imageString);
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);
}

function drawComboText(canvas,comboNum){
	//alert(comboNum + "x CORPSESMOOCH COMBO!!!")
	var ctx = canvas.getContext("2d");
	ctx.font = "14px Courier New Bold"
	//i wish the below two lines would disable anti-aliasing for the font.
	//then it could be the homestuck font :/
	ctx.imageSmoothingEnabled = false;
	ctx.scale(4,4);
	ctx.fillStyle = "#ff0000";  //bright candy red (most common blood color)
	var excite = "";
	for(var i = 0; i<comboNum; i++){
		excite += "!"
	}
	ctx.fillText(comboNum + "x CORPSESMOOCH COMBO"+excite,20,20);

}

function drawChatTextJRPlayer(canvas, introText, chat, player){
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
	fillChatTextMultiLineJRPlayer(canvas, chat, player, left_margin, current+line_height*2);
}

function drawChatTextAB(canvas, introText, chat){
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
	fillChatTextMultiLineAB(canvas, chat, left_margin, current+line_height*2);

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

function stabs(canvas,player){
	ctx = canvas.getContext('2d');
	var imageString = "stab.png"
	addImageTag(imageString)
	var img=document.getElementById(imageString);
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);
	swapColors(canvas, "#fffc00", player.bloodColor);
}

function bloodPuddle(canvas,player){
    ctx = canvas.getContext('2d');
	var imageString = "blood_puddle.png"
	addImageTag(imageString)
	var img=document.getElementById(imageString);
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);
	swapColors(canvas, "#fffc00", player.bloodColor);
}

function drawSpriteTurnways(canvas, player){
  if(checkSimMode() == true){
    return;
  }

  ctx = canvas.getContext('2d');
  ctx.imageSmoothingEnabled = false;  //should get rid of orange halo in certain browsers.
  ctx.translate(canvas.width, 0);
  ctx.scale(-1, 1);
  drawSprite(canvas, player, ctx);
}

function makeRenderingSnapshot(player){
	var ret = new PlayerSnapshot();
  ret.trickster = player.trickster;
  ret.sbahj = player.sbahj;
  ret.wasteInfluenced = player.wasteInfluenced;
	ret.grimDark = player.grimDark;
	ret.victimBlood = player.victimBlood;
	ret.murderMode = player.murderMode;
  ret.leftMurderMode = player.leftMurderMode; //scars
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
	ret.baby = player.baby;
	ret.causeOfDeath = player.causeOfDeath;
	return ret;
}

function drawBabySprite(canvas, player){
  if(checkSimMode() == true){
    return;
  }
    player = makeRenderingSnapshot(player);//probably dont need to, but whatever
    ctx = canvas.getContext('2d');
    ctx.imageSmoothingEnabled = false;
    //don't forget to shrink baby
    ctx.scale(0.5,0.5);

    drawSprite(canvas, player, ctx, true)


}


function drawSprite(canvas, player,ctx,baby){
  if(checkSimMode() == true){
    return;
  }
	player = makeRenderingSnapshot(player);
  //could be turnways or baby
 if(!ctx){
   ctx = canvas.getContext('2d');
 }

  ctx.imageSmoothingEnabled = false;  //should get rid of orange halo in certain browsers.
  if(!baby &&player.dead){//only rotate once
  	ctx.translate(canvas.width, 0);
  	ctx.rotate(90*Math.PI/180);
  }

  if(!baby && player.grimDark == true){
    grimDarkHalo(canvas)
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
  if(!baby){
    playerToSprite(canvas,player);
    bloody_face(canvas, player)//not just for murder mode, because you can kill another player if THEY are murder mode.
    if(player.murderMode == true){
  	  scratch_face(canvas, player);
    }
    if(player.leftMurderMode == true){
  	  scar_face(canvas, player);
    }
  }else{
     babySprite(canvas,player);
  }

  hair(canvas, player);
  if(player.isTroll){//wings before sprite
    fin1(canvas,player);
  }
  if(!baby && player.class_name == "Prince" && player.godTier){
	  princeTiara(canvas, player);
  }
  if(player.trickster == true){
      peachSkin(canvas, player);
  }else if(!baby && player.grimDark == true){
    grimDarkSkin(canvas, player)
  }else if(player.isTroll){
    greySkin(canvas,player);
  }
  if(player.isTroll){
    horns(canvas, player);
  }

  if(!baby && player.dead && player.causeOfDeath == "after being shown too many stabs from Jack"){
	 stabs(canvas,player)
  }

  if(player.wasteInfluenced == true){
    wasteOfMindSymbol(canvas, player);
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


function scar_face(canvas, player){
	ctx = canvas.getContext('2d');
	var imageString = "calm_scratch_face.png"
	addImageTag(imageString)
	var img=document.getElementById(imageString);
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);
}

function scratch_face(canvas, player){
	ctx = canvas.getContext('2d');
	var imageString = "scratch_face.png"
	addImageTag(imageString)
	var img=document.getElementById(imageString);
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);
	swapColors(canvas, "#fffc00", player.bloodColor); //it's their own blood
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
		ctx.drawImage(img,0,0,width,height);
		swapColors(canvas, "#440a7f", player.victimBlood); //it's not their own blood
	}
}

function drawDiamond(canvas){
  if(checkSimMode() == true){
    return;
  }
	ctx = canvas.getContext('2d');
	var imageString = "Moirail.png"
	addImageTag(imageString)
	var img=document.getElementById(imageString);
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);
}

function drawHeart(canvas){
  if(checkSimMode() == true){
    return;
  }
	ctx = canvas.getContext('2d');
	var imageString = "Matesprit.png"
	addImageTag(imageString)
	var img=document.getElementById(imageString);
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);
}

function drawClub(canvas){
  if(checkSimMode() == true){
    return;
  }
	ctx = canvas.getContext('2d');
	var imageString = "Auspisticism.png"
	addImageTag(imageString)
	var img=document.getElementById(imageString);
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);
}

function drawSpade(canvas){
  if(checkSimMode() == true){
    return;
  }
	ctx = canvas.getContext('2d');
	var imageString = "Kismesis.png"
	addImageTag(imageString)
	var img=document.getElementById(imageString);
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);
}

function hairBack(canvas,player){
  ctx = canvas.getContext('2d');
	var imageString = "Hair/hair_back"+player.hair+".png"
  //console.log(imageString);
	addImageTag(imageString)
	var img=document.getElementById(imageString);
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);
	if(player.isTroll){
		swapColors(canvas, "#313131",  player.hairColor);
		swapColors(canvas, "#202020", player.bloodColor);
	}else{
		swapColors(canvas, "#313131", player.hairColor);
		swapColors(canvas, "#202020", getColorFromAspect(player.aspect));
	}
}
function hair(canvas, player){
	ctx = canvas.getContext('2d');
	var imageString = "Hair/hair"+player.hair+".png"
	addImageTag(imageString)
	var img=document.getElementById(imageString);
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);
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
function drawTimeGears(canvas){
	if(checkSimMode() == true){
    return;
  }
  var p1SpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
  //drawBG(p1SpriteBuffer, "#ff9999", "#ff00ff")
  ctx = p1SpriteBuffer.getContext('2d');
  var imageString = "gears.png"
  addImageTag(imageString)
  var img=document.getElementById(imageString);
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);
  copyTmpCanvasToRealCanvasAtPos(canvas, p1SpriteBuffer,0,0)

}

//if the Waste of Mind/Observer sends a time player back
//the influence is visible.
function wasteOfMindSymbol(canvas, player){
  ctx = canvas.getContext('2d');
  var imageString = "mind_forehead.png"
  addImageTag(imageString)
  var img=document.getElementById(imageString);
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);
}

function princeTiara(canvas, player){
	var imageString = "prince_hat.png"
	addImageTag(imageString)
	var img=document.getElementById(imageString);
	var width = img.width;
	var height = img.height;
	var c2 = getBufferCanvas(canvas); //don't want to do color replacement on the existing image.
	ctx2 = c2.getContext('2d');
	ctx2.drawImage(img,0,0,width,height);
	aspectPalletSwap(c2, player);
	copyTmpCanvasToRealCanvas(canvas, c2)
}

function playerToRegularBody(player){
  var imageString = "Bodies/";
  if(player.class_name == "Page"){
    imageString += "reg001.png"
  }else if(player.class_name == "Knight" ){
    imageString += "reg002.png"
  }else if(player.class_name == "Witch" ){
    imageString += "reg003.png"
  }else if(player.class_name == "Sylph" ){
    imageString += "reg004.png"
  }else if(player.class_name == "Thief" ){
    imageString += "reg005.png"
  }else if(player.class_name == "Rogue" ){
    imageString += "reg006.png"
  }else if(player.class_name == "Seer" ){
    imageString += "reg007.png"
  }else if(player.class_name == "Mage" ){
    imageString += "reg008.png"
  }else if(player.class_name == "Heir" ){
    imageString += "reg009.png"
  }else if(player.class_name == "Maid" ){
    imageString += "reg010.png"
  }else if(player.class_name == "Prince" ){
    imageString += "reg011.png"
  }else if(player.class_name == "Bard" ){
    imageString += "reg012.png"
  }
  return imageString;
}

function playerToDreamBody(player){
  var imageString = "Bodies/";
  var tmp = "dream"
  if(player.class_name == "Page"){
    imageString += tmp +"001.png"
  }else if(player.class_name == "Knight" ){
    imageString += tmp +"002.png"
  }else if(player.class_name == "Witch" ){
    imageString += tmp +"003.png"
  }else if(player.class_name == "Sylph" ){
    imageString += tmp +"004.png"
  }else if(player.class_name == "Thief" ){
    imageString += tmp +"005.png"
  }else if(player.class_name == "Rogue" ){
    imageString += tmp +"006.png"
  }else if(player.class_name == "Seer" ){
    imageString += tmp +"007.png"
  }else if(player.class_name == "Mage" ){
    imageString += tmp +"008.png"
  }else if(player.class_name == "Heir" ){
    imageString += tmp +"009.png"
  }else if(player.class_name == "Maid" ){
    imageString += tmp +"010.png"
  }else if(player.class_name == "Prince" ){
    imageString += tmp +"011.png"
  }else if(player.class_name == "Bard" ){
    imageString += tmp +"012.png"
  }
  return imageString;
}


function regularSprite(canvas, player){
	var imageString = playerToRegularBody(player);
  addImageTag(imageString)
  var img=document.getElementById(imageString);
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);
  aspectPalletSwap(canvas, player);
  //aspectSymbol(canvas, player);
}

function dreamSprite(canvas, player){
  var imageString = playerToDreamBody(player);
  addImageTag(imageString)
  var img=document.getElementById(imageString);
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);
  dreamPalletSwap(canvas, player);
}

function playerToGodBody(player){
  var imageString = "Bodies/";
  if(player.class_name == "Page"){
    imageString += "001.png"
  }else if(player.class_name == "Knight" ){
    imageString += "002.png"
  }else if(player.class_name == "Witch" ){
    imageString += "003.png"
  }else if(player.class_name == "Sylph" ){
    imageString += "004.png"
  }else if(player.class_name == "Thief" ){
    imageString += "005.png"
  }else if(player.class_name == "Rogue" ){
    imageString += "006.png"
  }else if(player.class_name == "Seer" ){
    imageString += "007.png"
  }else if(player.class_name == "Mage" ){
    imageString += "008.png"
  }else if(player.class_name == "Heir" ){
    imageString += "009.png"
  }else if(player.class_name == "Maid" ){
    imageString += "010.png"
  }else if(player.class_name == "Prince" ){
    imageString += "011.png"
  }else if(player.class_name == "Bard" ){
    imageString += "012.png"
  }
  return imageString;
}

function godTierSprite(canvas, player){
	//draw class, then color like aspect, then draw chest icon
  //ctx.drawImage(img,canvas.width/2,canvas.height/2,width,height);
	var imageString = playerToGodBody(player);
  addImageTag(imageString)
  var img=document.getElementById(imageString);
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);
  aspectPalletSwap(canvas, player);
  aspectSymbol(canvas, player);
}

function babySprite(canvas,player){
  ctx = canvas.getContext('2d');
  var imageString = "Bodies/baby"+player.baby + ".png"
  if(player.isTroll){
    imageString = "Bodies/grub"+player.baby + ".png"
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
	swapColors(canvas, "#ca5b00",getDarkShirtColorFromAspect(player.aspect));
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
	var oldcolor1 = "#FEFD49";
	var oldcolor2 = "#FEC910";
	var oldcolor3 = "#10E0FF";
	var oldcolor4 = "#00A4BB";
	var oldcolor5 = "#FA4900";
	var oldcolor6 = "#E94200";

	var oldcolor7 = "#C33700";
	var oldcolor8 = "#FF8800";
	var oldcolor9 = "#D66E04";
	var oldcolor10 = "#E76700";
	var oldcolor11 = "#CA5B00";

	var new_color1 = "#FFFF00";
	var new_color2 = "#FFC935";
	var new_color3 = getShirtColorFromAspect(player.aspect);
	var new_color4 = getDarkShirtColorFromAspect(player.aspect);
	var new_color5 = "#FFCC00";
	var new_color6 = "#FF9B00";
	var new_color7 = "#C66900";
	var new_color8 = "#FFD91C";
	var new_color9 = "#FFE993";
	var new_color10 = "#FFB71C";
	var new_color11 = "#C67D00";

	if(player.moon =="Derse"){
		new_color1 = "#F092FF"
		new_color2 = "#D456EA"
		new_color5 = "#C87CFF";
		new_color6 = "#AA00FF";
		new_color7 = "#6900AF";
		new_color8 = "#DE00FF";
		new_color9 = "#E760FF";
		new_color10 = "#B400CC";
		new_color11 = "#770E87";
	}

	swapColors(canvas, oldcolor1, new_color1)
	swapColors(canvas, oldcolor2, new_color2)
	swapColors(canvas, oldcolor3, new_color3)
	swapColors(canvas, oldcolor4, new_color4)
	swapColors(canvas, oldcolor5, new_color5)
	swapColors(canvas, oldcolor6, new_color6)
	swapColors(canvas, oldcolor7, new_color7)
	swapColors(canvas, oldcolor8, new_color8)
	swapColors(canvas, oldcolor9, new_color9)
	swapColors(canvas, oldcolor10, new_color10)
	swapColors(canvas, oldcolor11, new_color11)
	//dreamSymbol(canvas, player);

}

function aspectPalletSwap(canvas, player){
  //not all browsers do png gama info correctly. Chrome does, firefox does not, mostly.
  //remove it entirely with this command
  //pngcrush -rem gAMA -rem cHRM -rem iCCP -rem sRGB infile.png outfile.png
  //pngcrush -rem gAMA -rem cHRM -rem iCCP -rem sRGB reg001.png reg001copy.png
  //./pngcrush -rem gAMA -rem cHRM -rem iCCP -rem sRGB stab.png stab_copy.png
	var oldcolor1 = "#FEFD49";
	var oldcolor2 = "#FEC910";
	var oldcolor3 = "#10E0FF";
	var oldcolor4 = "#00A4BB";
	var oldcolor5 = "#FA4900";
	var oldcolor6 = "#E94200";

	var oldcolor7 = "#C33700";
	var oldcolor8 = "#FF8800";
	var oldcolor9 = "#D66E04";
	var oldcolor10 = "#E76700";
	var oldcolor11 = "#CA5B00";

	var new_color1 = "#b4b4b4";
	var new_color2 = "#b4b4b4";
	var new_color3 = "#b4b4b4";
	var new_color4 = "#b4b4b4";
	var new_color5 = "#b4b4b4";
	var new_color6 = "#b4b4b4";
	var new_color7 = "#b4b4b4";
	var new_color8 = "#b4b4b4";
	var new_color9 = "#b4b4b4";
	var new_color10 = "#b4b4b4";
	var new_color11 = "#b4b4b4";


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
	new_color4='#000766';
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
  }


  swapColors(canvas, oldcolor1, new_color1)
  swapColors(canvas, oldcolor2, new_color2)
  swapColors(canvas, oldcolor3, new_color3)
  swapColors(canvas, oldcolor4, new_color4)
  swapColors(canvas, oldcolor5, new_color5)
  swapColors(canvas, oldcolor6, new_color6)
  swapColors(canvas, oldcolor7, new_color7)
  swapColors(canvas, oldcolor8, new_color8)
  swapColors(canvas, oldcolor9, new_color9)
  swapColors(canvas, oldcolor10, new_color10)
  swapColors(canvas, oldcolor11, new_color11)

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

function fillChatTextMultiLineJRPlayer(canvas, chat, player, x, y){
  var ctx = canvas.getContext("2d");
	var lineHeight = ctx.measureText("M").width * 1.2;
    var lines = chat.split("\n");
	var playerStart = player.chatHandleShort()
	var jrStart = "JR: "
 	for (var i = 0; i < lines.length; ++i) {
		//does the text begin with player 1's chat handle short? if so: getChatFontColor
		var ct = lines[i].trim();

		//check player 2 first 'cause they'll be more specific if they have same initials
		if(ct.startsWith(playerStart)){
			ctx.fillStyle = player.getChatFontColor();
      if(player.grimDark == true) {
        	ctx.font = "12px horrorterror"
      }else{
        	ctx.font = "12px Times New Roman"
      }
		}else if(ct.startsWith(jrStart)){
      ctx.fillStyle = "#3da35a";
      ctx.font = "12px Times New Roman"
		}else{
			ctx.fillStyle = "#000000"
		}
		var lines_wrapped = wrap_text(ctx, ct, x, y, lineHeight, canvas.width-50, "left")
  		y += lineHeight * lines_wrapped;
  	}
	//word wrap these
	ctx.fillStyle = "#000000"
}

function fillChatTextMultiLineAB(canvas, chat, x, y){
  var ctx = canvas.getContext("2d");
	var lineHeight = ctx.measureText("M").width * 1.2;
  var lines = chat.split("\n");
	var player1Start = "AB:";
	var player2Start = "JR:"
 	for (var i = 0; i < lines.length; ++i) {
		//does the text begin with player 1's chat handle short? if so: getChatFontColor
		var ct = lines[i].trim();
		//check player 2 first 'cause they'll be more specific if they have same initials
		if(ct.startsWith(player2Start)){
			ctx.fillStyle = "#3da35a";
      ctx.font = "12px Times New Roman"
		}else if(ct.startsWith(player1Start)){
			ctx.fillStyle = "#ff0000"
      ctx.font = "12px Times New Roman"
		}else{
			ctx.fillStyle = "#000000"
		}
		var lines_wrapped = wrap_text(ctx, ct, x, y, lineHeight, canvas.width-50, "left")
  	y += lineHeight * lines_wrapped;
  	}
	//word wrap these
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
