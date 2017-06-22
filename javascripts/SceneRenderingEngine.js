/*
A scene rendering engine is part of a simulation and different for each simulation.

The SceneRenderingEngine uses the spriteRenderingEngine to render specific sprites.
(especially since their renderingType might be different from the sim's default.)

SBURB Sim has posing as a team, leveling up, pesterchum logs (along with topic, etc)


*/

function SceneRenderingEngine(dontRender, spriteRenderingEngine){
	this.dontRender = dontRender;
	this.spriteRenderingEngine = spriteRenderingEngine;
	
	this.drawWhateverTurnways = function(){
		var ctx = canvas.getContext('2d');
		if(turnWays){
		  ctx.translate(canvas.width, 0);
		  ctx.scale(-1, 1);
		}
		this.drawWhatever(canvas,imageString);
	  }

	  //have i really been too lazy to make this until now
	   this.drawWhatever=function(canvas, imageString){
		if(checkSimMode() == true){
		  return;
		}
		var ctx = canvas.getContext('2d');
		ctx.imageSmoothingEnabled = false;  //should get rid of orange halo in certain browsers.
		addImageTag(imageString)
		var img=document.getElementById(imageString);
		var width = img.width;
		var height = img.height;
		ctx.drawImage(img,0,0,width,height);
	}
	
	this.drawSprite(canvas, player){
		
	}
	
	this.drawSpriteTurnways(canvas,player){
		var ctx = canvas.getContext('2d');
		if(turnWays){
		  ctx.translate(canvas.width, 0);
		  ctx.scale(-1, 1);
		}
		this.drawSprite(canvas,player);
	}
	
	this.getBufferCanvas = function(canvas){
		var tmp_canvas = document.createElement('canvas');
		tmp_canvas.height = canvas.height;
		tmp_canvas.width = canvas.width;
		return tmp_canvas;
	  }

	  this.copyTmpCanvasToRealCanvasAtPos = function(canvas, tmp_canvas, x, y){
		var ctx = canvas.getContext('2d');
		ctx.drawImage(tmp_canvas, x, y);
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
	  copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,200,0)
	  copyTmpCanvasToRealCanvasAtPos(canvas, gSpriteBuffer,500,0)
	  if(enablingAspect == "Life"){
		this.drawWhatever(canvas, "life_res.png");
	  }else if(enablingAspect == "Doom"){
		this.drawWhatever(canvas, "doom_res.png");
	  }
	  return canvas; //so enabling player can draw themselves on top
	}
		
}