

/*
A scene rendering engine is part of a simulation and different for each simulation.

The SceneRenderingEngine uses the spriteRenderingEngine to render specific sprites.
(especially since their renderingType might be different from the sim's default.)

SBURB Sim has posing as a team, leveling up, pesterchum logs (along with topic, etc)


*/
/*  TODO abandoned.

class SceneRenderingEngine {
	var dontRender;	var spriteRenderingEngine = new SpriteRenderingEngine(this.dontRender, 1); //default is homestuck

	


	SceneRenderingEngine(this.dontRender) {}


	dynamic getBufferCanvas(canvas){
		return this.spriteRenderingEngine.getBufferCanvas(canvas);
	}
	dynamic copyTmpCanvasToRealCanvasAtPos(canvas, tmp_canvas, x, y){
		return this.spriteRenderingEngine.copyTmpCanvasToRealCanvasAtPos(canvas, tmp_canvas, x, y);
	}
	dynamic loadAllImagesForPlayers(players){
		//print(players);
		List<dynamic> ret = [];
		if(!players) return ret;
		for(num i = 0; i<players.length; i++){
			var p = players[i];
			if(p){
				ret = ret.concat(this.spriteRenderingEngine.getAllImagesNeededForPlayer(p.toOCDataString(), p));
			}
		}
		return ret;
	}
	dynamic getAllImagesNeededForScenesBesidesPlayers(){
		List<dynamic> ret = [];
		String imageLocation = "images/";
		ret.add(imageLocation+"/Bodies/coolk1dlogo.png");
		ret.add(imageLocation+"/Bodies/coolk1dsword.png");
		ret.add(imageLocation+"/Bodies/coolk1dshades.png");
		ret.add(imageLocation+"jr.png");
		ret.add(imageLocation+"kr_chat.png");
		ret.add(imageLocation+"drain_lightning.png");
		ret.add(imageLocation+"drain_lightning_long.png");
		ret.add(imageLocation+"drain_halo.png");
		ret.add(imageLocation+"afterlife_life.png");
		ret.add(imageLocation+"afterlife_doom.png");
		ret.add(imageLocation+"doom_res.png");
		ret.add(imageLocation+"life_res.png");
		ret.add(imageLocation+"stab.png");
		ret.add(imageLocation+"denizoned.png");
		ret.add(imageLocation+"sceptre.png");
		ret.add(imageLocation+"rainbow.png");
		ret.add(imageLocation+"ghostGradient.png");
		ret.add(imageLocation+"halo.png");
		ret.add(imageLocation+"gears.png");
		ret.add(imageLocation+"mind_forehead.png");
		ret.add(imageLocation+"blood_forehead.png");
		ret.add(imageLocation+"rage_forehead.png");
		ret.add(imageLocation+"heart_forehead.png");
		ret.add(imageLocation+"ab.png");
		ret.add(imageLocation+"echeladder.png");
		ret.add(imageLocation+"godtierlevelup.png");
		ret.add(imageLocation+"pesterchum.png");
		ret.add(imageLocation+ "Prospit.png");
		ret.add(imageLocation+"Derse.png");
		ret.add(imageLocation+"bloody_face.png")  ///Rendering engine will load
		ret.add(imageLocation+"Moirail.png");
		ret.add(imageLocation+"Matesprit.png");
		ret.add(imageLocation+"horrorterror.png");
		ret.add(imageLocation+"dreambubbles.png");
		ret.add(imageLocation+"Auspisticism.png");
		ret.add(imageLocation+"Kismesis.png");
		ret.add(imageLocation+"discuss_romance.png");
		ret.add(imageLocation+"discuss_ashenmance.png");
		ret.add(imageLocation+"discuss_palemance.png");
		ret.add(imageLocation+"discuss_hatemance.png");
		ret.add(imageLocation+"discuss_breakup.png");
		ret.add(imageLocation+"discuss_sburb.png");
		ret.add(imageLocation+"discuss_jack.png");
		ret.add(imageLocation+"discuss_murder.png");
		ret.add(imageLocation+"discuss_raps.png");
		return ret;
	}
	void drawSpriteFromScratch(canvas, player){
		this.spriteRenderingEngine.renderPlayer(canvas, player.toOCDataString(), player); //does not attempt to use cache
	}
	void drawChat(canvas, player1, player2, chat, repeatTime, topicImage){
	  if(this.dontRender == true){
	    return;
	  }
		//debug("drawing chat");
		//draw sprites to buffer (don't want them pallete swapping each other)
		//then to main canvas
		var canvasSpriteBuffer = this.spriteRenderingEngine.getBufferCanvas(querySelector("#canvas_template"));
		var ctx = canvasSpriteBuffer.getContext('2d');
		String imageString = "pesterchum.png";
		this.spriteRenderingEngine.addImageTag(imageString);
		var img=querySelector("#${imageString}");
		var width = img.width;
		var height = img.height;
		ctx.drawImage(img,0,0,width,height);

		var p1SpriteBuffer = this.spriteRenderingEngine.getBufferCanvas(querySelector("#sprite_template"));
		this.drawSprite(p1SpriteBuffer,player1);

		var p2SpriteBuffer = this.spriteRenderingEngine.getBufferCanvas(querySelector("#sprite_template"));
		this.drawSpriteTurnways(p2SpriteBuffer,player2);

		//don't need buffer for text?
		var textSpriteBuffer = this.spriteRenderingEngine.getBufferCanvas(querySelector("#chat_text_template"));
		String introText = "-- " +player1.chatHandle + " [" + player1.chatHandleShort()+ "] began pestering ";
		introText += player2.chatHandle + " [" + player2.chatHandleShort()+ "] --";
		this.drawChatText(textSpriteBuffer,player1, player2, introText, chat);
		//drawBG(textSpriteBuffer, "#ff9999", "#ff00ff") //test that it's actually being rendered.
		//p1 on left, chat in middle, p2 on right and flipped turnways.
		this.spriteRenderingEngine.copyTmpCanvasToRealCanvasAtPos(canvas, p1SpriteBuffer,-100,0);
		this.spriteRenderingEngine.copyTmpCanvasToRealCanvasAtPos(canvas, p2SpriteBuffer,650,0)//where should i put this?
		this.spriteRenderingEngine.copyTmpCanvasToRealCanvasAtPos(canvas, canvasSpriteBuffer,230,0);
		this.spriteRenderingEngine.copyTmpCanvasToRealCanvasAtPos(canvas, textSpriteBuffer,244,51);

	  if(topicImage){
	    var topicBuffer = this.getBufferCanvas(querySelector("#canvas_template"));
	    this.spriteRenderingEngine.drawWhatever(topicBuffer, topicImage);
	    this.spriteRenderingEngine.copyTmpCanvasToRealCanvasAtPos(canvas, topicBuffer,0,0);
	  }
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
		this.fillChatTextMultiLine(canvas, chat, player1, player2, left_margin, current+line_height*2);

	}
	void fillChatTextMultiLine(canvas, chat, player1, player2, x, y){
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
			var lines_wrapped = this.spriteRenderingEngine.wrap_text(ctx, ct, x, y, lineHeight, canvas.width-50, "left");
	  		y += lineHeight * lines_wrapped;
	  	}
		//word wrap these
		ctx.fillStyle = "#000000";
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
	void drawSprite(canvas, player){
		this.spriteRenderingEngine.renderPlayerForScene(canvas, player.toOCDataString(), player);
	}
	void drawSpriteTurnways(canvas, player){
		var ctx = canvas.getContext('2d');
	  ctx.translate(canvas.width, 0);
	  ctx.scale(-1, 1);
		this.drawSprite(canvas,player);
	}
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
  			img_data.data[i] =img_data_rainbow.data[4 *Math.floor(i/(4000))];
  			img_data.data[i+1] = img_data_rainbow.data[4 *Math.floor(i/(4000))+1];
  			img_data.data[i+2] =img_data_rainbow.data[4 *Math.floor(i/(4000))+2];
  			img_data.data[i+3] = getRandomIntNoSeed(100,255); //make it look speckled.

  		}
  	}
  	ctx.putImageData(img_data, 0, 0);
  	//ctx.putImageData(img_data_rainbow, 0, 0);
  }
	void swapColors(canvas, color1, color2, opacity){ //for wings, opacity = 0.5;
    if(checkSimMode() == true){
      return;
    }
    var oldc = hexToRgbA(color1);
    var newc= hexToRgbA(color2);
    // //print("replacing: " + oldc  + " with " + newc);
    var ctx = canvas.getContext('2d');
    var img_data =ctx.getImageData(0, 0, canvas.width, canvas.height);
    //4 byte color array
    for(num i = 0; i<img_data.data.length; i += 4){;
      if(img_data.data[i] == oldc[0] && img_data.data[i+1] == oldc[1] &&img_data.data[i+2] == oldc[2]&&img_data.data[i+3] == 255){
        img_data.data[i] = newc[0];
        img_data.data[i+1] = newc[1];
        img_data.data[i+2] = newc[2];
        img_data.data[i+3] = Math.Round(opacity * 255);
      }
    }
    ctx.putImageData(img_data, 0, 0);

  }
	dynamic drawReviveDead(div, player, ghost, enablingAspect){
	  var canvasId = div.id + "commune_" +player.chatHandle + ghost.chatHandle+player.getStat(Stats.POWER)+ghost.getStat(Stats.POWER);
	  String canvasHTML = "<br><canvas id='" + canvasId +"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
	  div.append(canvasHTML);
	  var canvas = querySelector("#${canvasId}");
	  var pSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
	  this.drawSprite(pSpriteBuffer,player);
	  var gSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
	  this.drawSpriteTurnways(gSpriteBuffer,ghost);

	  var canvasBuffer = getBufferCanvas(querySelector("#canvas_template"));



	  //leave room on left for possible 'guide' player.
	  if(enablingAspect == "Life"){
		this.drawWhatever(canvas, "afterlife_life.png");
	  }else if(enablingAspect == "Doom"){
		this.drawWhatever(canvas, "afterlife_doom.png");
	  }
	  this.copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,200,0);
	  this.copyTmpCanvasToRealCanvasAtPos(canvas, gSpriteBuffer,500,0);
	  if(enablingAspect == "Life"){
		this.drawWhatever(canvas, "life_res.png");
	  }else if(enablingAspect == "Doom"){
		this.drawWhatever(canvas, "doom_res.png");
	  }
	  return canvas; //so enabling player can draw themselves on top
	}


}

*/
