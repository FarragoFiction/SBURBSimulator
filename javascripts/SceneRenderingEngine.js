/*
A scene rendering engine is part of a simulation and different for each simulation.

The SceneRenderingEngine uses the spriteRenderingEngine to render specific sprites.
(especially since their renderingType might be different from the sim's default.)

SBURB Sim has posing as a team, leveling up, pesterchum logs (along with topic, etc)


*/

function SceneRenderingEngine(dontRender){
	this.dontRender = dontRender;
	this.spriteRenderingEngine = new SpriteRenderingEngine(this.dontRender, 1); //default is homestuck

	//converts to data string, calls SpriteRenderingEngine
	this.drawSpriteFromScratch = function(canavas, player){
		this.spriteRenderingEngine.renderPlayer(canvas, player.toOCDataString(), player); //does not attempt to use cache
	}

	 this.drawChat = function(canvas, player1, player2, chat, repeatTime,topicImage){
	  if(this.dontRender == true){
	    return;
	  }
		//debug("drawing chat")
		//draw sprites to buffer (don't want them pallete swapping each other)
		//then to main canvas
		var canvasSpriteBuffer = this.spriteRenderingEngine.getBufferCanvas(document.getElementById("canvas_template"));
		var ctx = canvasSpriteBuffer.getContext('2d');
		var imageString = "pesterchum.png"
		addImageTag(imageString)
		var img=document.getElementById(imageString);
		var width = img.width;
		var height = img.height;
		ctx.drawImage(img,0,0,width,height);

		var p1SpriteBuffer = this.spriteRenderingEngine.getBufferCanvas(document.getElementById("sprite_template"));
		this.drawSprite(p1SpriteBuffer,player1)

		var p2SpriteBuffer = this.spriteRenderingEngine.getBufferCanvas(document.getElementById("sprite_template"));
		this.drawSpriteTurnways(p2SpriteBuffer,player2)

		//don't need buffer for text?
		var textSpriteBuffer = this.spriteRenderingEngine.getBufferCanvas(document.getElementById("chat_text_template"));
		var introText = "-- " +player1.chatHandle + " [" + player1.chatHandleShort()+ "] began pestering ";
		introText += player2.chatHandle + " [" + player2.chatHandleShort()+ "] --";
		this.drawChatText(textSpriteBuffer,player1, player2, introText, chat)
		//drawBG(textSpriteBuffer, "#ff9999", "#ff00ff") //test that it's actually being rendered.
		//p1 on left, chat in middle, p2 on right and flipped turnways.
		this.spriteRenderingEngine.copyTmpCanvasToRealCanvasAtPos(canvas, p1SpriteBuffer,-100,0)
		this.spriteRenderingEngine.copyTmpCanvasToRealCanvasAtPos(canvas, p2SpriteBuffer,650,0)//where should i put this?
		this.spriteRenderingEngine.copyTmpCanvasToRealCanvasAtPos(canvas, canvasSpriteBuffer,230,0)
		this.spriteRenderingEngine.copyTmpCanvasToRealCanvasAtPos(canvas, textSpriteBuffer,244,51)

	  if(topicImage){
	    var topicBuffer = getBufferCanvas(document.getElementById("canvas_template"));
	    drawWhatever(topicBuffer, topicImage);
	    this.spriteRenderingEngine.copyTmpCanvasToRealCanvasAtPos(canvas, topicBuffer,0,0)
	  }
	}


	this.drawSolidBG=function(canvas, color){
    var ctx = canvas.getContext("2d");
  	ctx.fillStyle = color;
  	ctx.fillRect(0, 0, canvas.width, canvas.height);
  }

  this.drawBG = function(canvas, color1, color2){
  	//var c = document.getElementById(canvasId);
  	var ctx = canvas.getContext("2d");

  	var grd = ctx.createLinearGradient(0, 0, 170, 0);
  	grd.addColorStop(0, color1);
  	grd.addColorStop(1, color2);

  	ctx.fillStyle = grd;
  	ctx.fillRect(0, 0, canvas.width, canvas.height);
  }

  this.drawBGRadialWithWidth = function(canvas, startX, endX, width, color1, color2){
  	//var c = document.getElementById(canvasId);
  	var ctx = canvas.getContext("2d");

  	var grd = ctx.createRadialGradient(width/2,canvas.height/2,5,width,canvas.height,width);
  	grd.addColorStop(0, color1);
  	grd.addColorStop(1, color2);

  	ctx.fillStyle = grd;
  	ctx.fillRect(startX, 0, endX, canvas.height);
  }

  this.fillTextMultiLine = function(canvas, text1, text2, color2, x, y) {
  	var ctx = canvas.getContext("2d");
  	var lineHeight = ctx.measureText("M").width * 1.2;
      var lines = text1.split("\n");
   	for (var i = 0; i < lines.length; ++i) {
     		ctx.fillText(lines[i], x, y);
    		y += lineHeight;
    	}
  	//word wrap these
  	ctx.fillStyle = color2
   	this.wrap_text(ctx, text2, x, y, lineHeight, 3*canvas.width/4, "left");
  	ctx.fillStyle = "#000000"
  }

  //http://stackoverflow.com/questions/5026961/html5-canvas-ctx-filltext-wont-do-line-breaks
  this.wrap_text = function(ctx, text, x, y, lineHeight, maxWidth, textAlign) {
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



	this.drawSprite(canvas, player){
		this.spriteRenderingEngine.renderPlayerForScene(canvas, player.toOCDataString(), player);
	}

	this.drawSpriteTurnways(canvas,player){
		var ctx = canvas.getContext('2d');
		if(turnWays){
		  ctx.translate(canvas.width, 0);
		  ctx.scale(-1, 1);
		}
		this.drawSprite(canvas,player);
	}

	//work once again gives me inspiration for this sim. thanks, bob!!!
  this.rainbowSwap = function(canvas){
  	if(checkSimMode() == true){
  		return;
  	}
  	var ctx = canvas.getContext('2d');
  	var img_data =ctx.getImageData(0, 0, canvas.width, canvas.height);
  	var imageString = "rainbow.png";
      var img=document.getElementById(imageString);
      var width = img.width;
    	var height = img.height;
  	var print= true;
  	 var rainbow_canvas = getBufferCanvas(document.getElementById("rainbow_template"));
  	var rctx = rainbow_canvas.getContext('2d');
    	rctx.drawImage(img,0,0,width,height);
  	var img_data_rainbow =rctx.getImageData(0, 0,width, height);
  	//4 *Math.floor(i/(4000)) is because 1/(width*4) get me the row number (*4 'cause there are 4 elements per pixel). then, when i have the row number, *4 again because first row is 0,1,2,3 and second is 4,5,6,7 and third is 8,9,10,11
  	for(var i = 0; i<img_data.data.length; i += 4){
  		if(img_data.data[i+3] >= 128){
  			img_data.data[i] =img_data_rainbow.data[4 *Math.floor(i/(4000))]
  			img_data.data[i+1] = img_data_rainbow.data[4 *Math.floor(i/(4000))+1]
  			img_data.data[i+2] =img_data_rainbow.data[4 *Math.floor(i/(4000))+2]
  			img_data.data[i+3] = getRandomIntNoSeed(100,255); //make it look speckled.

  		}
  	}
  	ctx.putImageData(img_data, 0, 0);
  	//ctx.putImageData(img_data_rainbow, 0, 0);
  }


	this.swapColors = function(canvas, color1, color2,opacity){ //for wings, opacity = 0.5
    if(checkSimMode() == true){
      return;
    }
    var oldc = hexToRgbA(color1);
    var newc= hexToRgbA(color2);
    // console.log("replacing: " + oldc  + " with " + newc);
    var ctx = canvas.getContext('2d');
    var img_data =ctx.getImageData(0, 0, canvas.width, canvas.height);
    //4 byte color array
    for(var i = 0; i<img_data.data.length; i += 4){
      if(img_data.data[i] == oldc[0] && img_data.data[i+1] == oldc[1] &&img_data.data[i+2] == oldc[2]&&img_data.data[i+3] == 255){
        img_data.data[i] = newc[0];
        img_data.data[i+1] = newc[1];
        img_data.data[i+2] = newc[2];
        img_data.data[i+3] = Math.Round(opacity * 255);
      }
    }
    ctx.putImageData(img_data, 0, 0);

  }


	this.drawReviveDead = function(div, player, ghost, enablingAspect){
	  var canvasId = div.attr("id") + "commune_" +player.chatHandle + ghost.chatHandle+player.power+ghost.power
	  var canvasHTML = "<br><canvas id='" + canvasId +"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
	  div.append(canvasHTML);
	  var canvas = document.getElementById(canvasId);
	  var pSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
	  this.drawSprite(pSpriteBuffer,player)
	  var gSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
	  this.drawSpriteTurnways(gSpriteBuffer,ghost)

	  var canvasBuffer = getBufferCanvas(document.getElementById("canvas_template"))



	  //leave room on left for possible 'guide' player.
	  if(enablingAspect == "Life"){
		this.drawWhatever(canvas, "afterlife_life.png");
	  }else if(enablingAspect == "Doom"){
		this.drawWhatever(canvas, "afterlife_doom.png");
	  }
	  this.copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,200,0)
	  this.copyTmpCanvasToRealCanvasAtPos(canvas, gSpriteBuffer,500,0)
	  if(enablingAspect == "Life"){
		this.drawWhatever(canvas, "life_res.png");
	  }else if(enablingAspect == "Doom"){
		this.drawWhatever(canvas, "doom_res.png");
	  }
	  return canvas; //so enabling player can draw themselves on top
	}

}
