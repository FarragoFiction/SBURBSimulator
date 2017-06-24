//coding start 6/21
/*
	A sprite rendering engine is intended to live ABOVE all simulations, and be used by any of them to render themselves in any fashion.
	Put MLP chacters in SBURB, or SBURB characters in some other sim. Whatever.

	As such, the images used by this engine must be kept at the same level AS this engine.

	A RenderingEngine should NOT know how to render a scene (such as leveling up.). That is the job
	of the SceneRenderingEngine (kept at the sim level).  The SceneRenderingEngine will USE a RenderingEngine to
	render the sprites for the scene, sure. But they are kept separate.
*/
var cool_kid = false;
function SpriteRenderingEngine(dontRender, defaultRendererID){
  this.dontRender = dontRender; //AB for example doesn't want you to render
  this.defaultRendererID = defaultRendererID;
  this.renderers = [null, new HomestuckRenderer(this) , new EggRenderer(this)]; //if they try to render with "null", use defaultRendererID index instead.


  this.ocDataStringToBS = function(bs){
    console.log(bs)
    var b = decodeURIComponent(bs.split("=")[1].split("&s")[0])
    var s = bs.split("=")[2]
    return [b,s];
  }
  //for sprite customization. only get sprites needed for used rendering type
  this.getAllImagesNeeded = function(renderingType){
    if(renderingType == 0) renderingType = this.defaultRendererID;
    return this.renderers[renderingType].getAllImagesNeeded();
  }

  //when passed a "player" should be an oc data string, because each string is interpreted differently by rendering engines
  this.getAllImagesNeededForPlayer= function(ocDataString, objectData){
    var index = objectData.renderingType;  //later, once renderingType is a thing, parse it out of ocDataString
    if(objectData.renderingType == 0 || !objectData.renderingType) index = this.defaultRendererID;
    return this.renderers[index].getAllImagesNeededForPlayer(ocDataString, objectData);
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
		if(this.dontRender == true){
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

  //actually renders player, not just using cached image.
  this.renderPlayer = function(canvas, ocDataString, objectData){
    var index = objectData.renderingType;
    if(objectData.renderingType == 0) index = this.defaultRendererID;
    var renderer = this.renderers[index];
    renderer.drawSpriteFromScratch(canvas, objectData.toOCDataString(), objectData);
  }

  this.renderPlayerForScene = function(canvas, ocDataString, objectData){
      var canvasDiv = document.getElementById(objectData.spriteCanvasID);
      this.copyTmpCanvasToRealCanvasAtPos(canvas, canvasDiv,0,0)
      var index = objectData.renderingType;
      if(objectData.renderingType == 0) index = this.defaultRendererID;
      var renderer = this.renderers[index];
      renderer.drawExtrasOverCache(canvas, ocDataString, objectData);
  }


  //need to be kept as high up as possible so that rest of sim can access these convinience methods
  this.hexToRgbA = function(hex){
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

  //takes in url, not just x.png.
  //THIS IS A BACKUP FOR THE LOADING SCRIPT. IF ANYTHING ACTUALLY GETS ADDED TO IMAGE-STAGING I KNOW I FUCKED UP
  //this will cause a sprite to not render the first few times, but eventually render in l8r canvases.
  this.addImageTag = function(url){
    //console.log(url);
  	//only do it if image hasn't already been added.
  	if(document.getElementById(url) == null) {
  		var tag = '<img id ="' + url + '" src = "' + url + '" style="display:none">';
  		$("#image_staging").append(tag);
  	}

  }

  //all engines use this
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

  //all engines use this
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
    if(this.dontRender == true){
      return;
    }
  	var ctx = canvas.getContext('2d');
    ctx.imageSmoothingEnabled = false;  //should get rid of orange halo in certain browsers.
  	this.addImageTag(imageString)
  	var img=document.getElementById(imageString);
  	var width = img.width;
  	var height = img.height;
  	ctx.drawImage(img,0,0,width,height);
  }

  //if speed becomes an issue, take in array of color pairs to swap out
  //rather than call this method once for each color
  //swaps one hex color with another.
  //wait no, would be same amount of things. just would have nested for loops instead of
  //multiple calls
  this.swapColors = function(canvas, color1, color2,opacity){ //for wings, opacity = 0.5
    if(this.dontRender == true){
      return;
    }
    var oldc = this.hexToRgbA(color1);
    var newc= this.hexToRgbA(color2);
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


  //how translucent are we talking, here?  number between 0 and 1, not a gradient like ghostSwap
  this.voidSwap=function(canvas,alphaPercent){
    if(this.dontRender == true){
      return;
    }
    // console.log("replacing: " + oldc  + " with " + newc);
    var ctx = canvas.getContext('2d');
    var img_data =ctx.getImageData(0, 0, canvas.width, canvas.height);
    //4 byte color array
    for(var i = 0; i<img_data.data.length; i += 4){
      if(img_data.data[i+3] > 50){
        img_data.data[i+3] = Math.floor(img_data.data[i+3]*alphaPercent);  //keeps wings at relative transparency
      }
    }
    ctx.putImageData(img_data, 0, 0);
  }



  //work once again gives me inspiration for this sim. thanks, bob!!!
  //this looks idential to drained sghost swap....
  this.ghostSwap = function(canvas){
  	if(dontRender == true){
  		return;
  	}
  	var ctx = canvas.getContext('2d');
  	var img_data =ctx.getImageData(0, 0, canvas.width, canvas.height);
  	var imageString = "ghostGradient.png";
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
  			img_data.data[i+3] = img_data_rainbow.data[4 *Math.floor(i/(4000))+3]*2 //only mimic transparency.

  		}
  	}
  	ctx.putImageData(img_data, 0, 0);
  	//ctx.putImageData(img_data_rainbow, 0, 0);
  }






  //sharpens the image so later pixel swapping doesn't work quite right.
  //https://www.html5rocks.com/en/tutorials/canvas/imagefilters/
  this.sbahjifier=function(canvas){
    var opaque = false;
    var ctx = canvas.getContext('2d');
    ctx.rotate(getRandomIntNoSeed(0,10)*Math.PI/180);
  	var pixels =ctx.getImageData(0, 0, canvas.width, canvas.height);
    //var weights = [  0, -1,  0, -1,  5, -1, 0, -1,  0 ];
    var weights = [  -1, -1,  -1, -1,  9, -1, -1, -1,  -1 ];
    //var weights = [  1, 1, 1, 1,  5, -1, -1, -1, -1 ];
    var side = Math.round(Math.sqrt(weights.length));
    var halfSide = Math.floor(side/2);
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
        var r=0, g=0, b=0, a=0;
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
}

/*******************************************************************************

And now we start defining our renderers. If they get too beefy, move to new file.

All sprites are assumed to be kept ../../AllSprites/<INSERTRENDERINGENGINENAMEHERE>
(except homestuck renderer which just refers to HomestuckHumanRenderer and HomestuckTrollRenderer)

********************************************************************************/



function HomestuckRenderer(rh){
  this.rendererHelper = rh;
//  this.baseLocation = "../RenderingAssets/Homestuck/"; //will be from point of view of some SIM
    this.baseLocation = "http://farragofiction.com/RenderingAssets/Homestuck/"  //made sure CORS was on.

  //true random position
  this.drawWhateverTerezi = function(canvas, imageString){
  	var ctx = canvas.getContext('2d');
  	this.rendererHelper.addImageTag(imageString)
  	var img=document.getElementById(imageString);
  	var width = img.width;
  	var height = img.height;
    //all true random
    var x = getRandomIntNoSeed(0, 50);
    var y = getRandomIntNoSeed(0,50);
    if(Math.random() > .5) x = x * -1;
    if(Math.random() > .5) y = y * -1;
  	ctx.drawImage(img,x,y,width,height);
  }

  this.wings = function(canvas,player){
    var num = player.quirk.favoriteNumber;
    var imageString = "Wings/wing"+num + ".png";
    this.rendererHelper.drawWhatever(canvas, imageString);
    this.rendererHelper.swapColors(canvas, "#ff0000",player.bloodColor);
    this.rendererHelper.swapColors50(canvas, "#00ff2a",player.bloodColor);
    this.rendererHelper.swapColors50(canvas, "#00ff00",player.bloodColor); //I have NO idea why some browsers render the lime parts of the wing as 00ff00 but whatever.
  }

  this.drawExtrasOverCache = function(canvas, ocDataString, objectData){
    if(!objectData.baby && objectData.influenceSymbol){ //dont make sprite for this, always on top, unlike scars
      this.rendererHelper.drawWhatever(canvas, objectData.influenceSymbol);
    }

    if(cool_kid){
      this.drawWhateverTerezi(canvas,this.baseLocation+"/Bodies/coolk1dlogo.png")
      this.drawWhateverTerezi(canvas,this.baseLocation+"/Bodies/coolk1dsword.png")
      this.drawWhateverTerezi(canvas,this.baseLocation+"/Bodies/coolk1dshades.png")
    }
  }

  this.grimDarkHalo = function(canvas,player){
    var imageString = this.baseLocation+"grimdark.png";
    if(player.trickster){
      imageString =  this.baseLocation+"squiddles_chaos.png"
    }
    this.rendererHelper.drawWhatever(canvas, imageString)
  }

  this.fin2 = function(canvas, player){
    if(player.bloodColor == "#610061" || player.bloodColor == "#99004d"){
      this.rendererHelper.drawWhatever(canvas, this.baseLocation + "fin2.png");
    }
  }

  this.robotSprite = function(canvas, player){
    var ctx = canvas.getContext('2d');
  	var imageString;
  	if(!player.godTier){
  		imageString = playerToRegularBody(player);
  	}else{
  		imageString = playerToGodBody(player);
  	}
  	  this.rendererHelper.addImageTag(imageString)
  	  var img=document.getElementById(imageString);
  	  var width = img.width;
  	  var height = img.height;
  	  ctx.drawImage(img,0,0,width,height);
  	  this.robotPalletSwap(canvas, player);
  }

  this.robotPalletSwap = function(canvas, player){
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

  	var new_color1 = "#0000FF";
  	var new_color2 = "#0022cf";
  	var new_color3 ="#B6B6B6";
  	var new_color4 = "#A6A6A6";
  	var new_color5 = "#B6B6B6";
  	var new_color6 = "#595959";
  	var new_color7 = "#696969";
  	var new_color8 = "#B6B6B6";
  	var new_color9 = "#797979";
  	var new_color10 = "#494949";
  	var new_color11 = "#393939";


  	this.rendererHelper.swapColors(canvas, oldcolor1, new_color1)
  	this.rendererHelper.swapColors(canvas, oldcolor2, new_color2)
  	this.rendererHelper.swapColors(canvas, oldcolor3, new_color3)
  	this.rendererHelper.swapColors(canvas, oldcolor4, new_color4)
  	this.rendererHelper.swapColors(canvas, oldcolor5, new_color5)
  	this.rendererHelper.swapColors(canvas, oldcolor6, new_color6)
  	this.rendererHelper.swapColors(canvas, oldcolor7, new_color7)
  	this.rendererHelper.swapColors(canvas, oldcolor8, new_color8)
  	this.rendererHelper.swapColors(canvas, oldcolor9, new_color9)
  	this.rendererHelper.swapColors(canvas, oldcolor10, new_color10)
  	this.rendererHelper.swapColors(canvas, oldcolor11, new_color11)
  }


  this.dreamPalletSwap =function(canvas, player){
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

  	this.rendererHelper.swapColors(canvas, oldcolor1, new_color1)
  	this.rendererHelper.swapColors(canvas, oldcolor2, new_color2)
  	this.rendererHelper.swapColors(canvas, oldcolor3, new_color3)
  	this.rendererHelper.swapColors(canvas, oldcolor4, new_color4)
  	this.rendererHelper.swapColors(canvas, oldcolor5, new_color5)
  	this.rendererHelper.swapColors(canvas, oldcolor6, new_color6)
  	this.rendererHelper.swapColors(canvas, oldcolor7, new_color7)
  	this.rendererHelper.swapColors(canvas, oldcolor8, new_color8)
  	this.rendererHelper.swapColors(canvas, oldcolor9, new_color9)
  	this.rendererHelper.swapColors(canvas, oldcolor10, new_color10)
  	this.rendererHelper.swapColors(canvas, oldcolor11, new_color11)
  	//dreamSymbol(canvas, player);

  }

  this.candyPalletSwap =function(canvas, player){
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
    this.rendererHelper.swapColors(canvas, oldcolor1, new_color1)
    this.rendererHelper.swapColors(canvas, oldcolor2, new_color2)
    this.rendererHelper.swapColors(canvas, oldcolor3, new_color3)
    this.rendererHelper.swapColors(canvas, oldcolor4, new_color4)
    this.rendererHelper.swapColors(canvas, oldcolor5, new_color5)
    this.rendererHelper.swapColors(canvas, oldcolor6, new_color6)
    this.rendererHelper.swapColors(canvas, oldcolor7, new_color7)
    this.rendererHelper.swapColors(canvas, oldcolor8, new_color8)
    this.rendererHelper.swapColors(canvas, oldcolor9, new_color9)
    this.rendererHelper.swapColors(canvas, oldcolor10, new_color10)
    this.rendererHelper.swapColors(canvas, oldcolor11, new_color11)
  }


  this.aspectPalletSwap = function(canvas, player){
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
    }


    this.rendererHelper.swapColors(canvas, oldcolor1, new_color1)
    this.rendererHelper.swapColors(canvas, oldcolor2, new_color2)
    this.rendererHelper.swapColors(canvas, oldcolor3, new_color3)
    this.rendererHelper.swapColors(canvas, oldcolor4, new_color4)
    this.rendererHelper.swapColors(canvas, oldcolor5, new_color5)
    this.rendererHelper.swapColors(canvas, oldcolor6, new_color6)
    this.rendererHelper.swapColors(canvas, oldcolor7, new_color7)
    this.rendererHelper.swapColors(canvas, oldcolor8, new_color8)
    this.rendererHelper.swapColors(canvas, oldcolor9, new_color9)
    this.rendererHelper.swapColors(canvas, oldcolor10, new_color10)
    this.rendererHelper.swapColors(canvas, oldcolor11, new_color11)

  }


  this.tricksterSprite = function(canvas, player){
    var ctx = canvas.getContext('2d');
  	var imageString;
  	if(!player.godTier){
  		imageString = playerToRegularBody(player);
  	}else{
  		imageString = playerToGodBody(player);
  	}
  	  this.rendererHelper.addImageTag(imageString)
  	  var img=document.getElementById(imageString);
  	  var width = img.width;
  	  var height = img.height;
  	  ctx.drawImage(img,0,0,width,height);
  	  this.candyPalletSwap(canvas, player);
    //aspectSymbol(canvas, player);
  }

  this.regularSprite = function(canvas, player){
  	var imageString = playerToRegularBody(player);
    var ctx = canvas.getContext('2d');
    this.rendererHelper.addImageTag(imageString)
    var img=document.getElementById(imageString);
    var width = img.width;
    var height = img.height;
    ctx.drawImage(img,0,0,width,height);
    if(player.sbahj){
    this.rendererHelper.sbahjifier(canvas);
    }
    this.aspectPalletSwap(canvas, player);
    //aspectSymbol(canvas, player);
  }

  this.dreamSprite = function(canvas, player){
    var imageString = playerToDreamBody(player);
    this.rendererHelper.addImageTag(imageString)
    var img=document.getElementById(imageString);
    var width = img.width;
    var height = img.height;
    var ctx = canvas.getContext("2d");
    ctx.drawImage(img,0,0,width,height);
    this.dreamPalletSwap(canvas, player);
  }



  this.playerToSprite=function(canvas, player){
  	var ctx = canvas.getContext('2d');
  	if(player.robot == true){
  		this.robotSprite(canvas, player);
  	}else if(player.trickster){
  		this.tricksterSprite(canvas, player);
  	}else if(player.godTier){
  		this.godTierSprite(canvas, player);
  	}else if (player.isDreamSelf)
  	{
  		this.dreamSprite(canvas, player)
  	}else{
  		this.regularSprite(canvas, player);
  	}
  }

  //if you want to draw sprite as a baby, then pass them as a baby. be responsible for making them alive/not murderous
  this.drawSpriteFromScratch = function(canvas, ocDataString, objectData){
    var bs = this.rendererHelper.ocDataStringToBS(ocDataString);
    var player = dataBytesAndStringsToPlayer(bs[0], bs[1]);  //only use objectData when I KNOW I need to.
    if(this.dontRender == true){
      return;
    }
    var ctx = canvas.getContext('2d');
    ctx.imageSmoothingEnabled = false;  //should get rid of orange halo in certain browsers.
    if((player.dead)){//only rotate once
    	ctx.translate(canvas.width, 0);
    	ctx.rotate(90*Math.PI/180);
    }

    //they are not dead, only sleeping
    if((player.causeOfDrain)){//only rotate once
    	ctx.translate(0, 6*canvas.height/5);
    	ctx.rotate(270*Math.PI/180);
    }

    if(player.grimDark > 3){
      this.grimDarkHalo(canvas,player)
    }

    if(player.isTroll&& player.godTier){//wings before sprite
      this.wings(canvas,player);
    }

    if(player.dead){
  	   this.rendererHelper.drawWhatever(canvas, "blood_puddle.png");
       this.rendererHelper.swapColors(canvas, "#fffc00", player.bloodColor);
    }
    this.hairBack(canvas, player);
    if(player.isTroll){//wings before sprite
      this.fin2(canvas,player);
    }
    if(!player.baby_stuck){
      this.playerToSprite(canvas,player);
      this.bloody_face(canvas, player)//not just for murder mode, because you can kill another player if THEY are murder mode.
      if(player.murderMode == true){
    	  this.scratch_face(canvas, player);
      }
      if(player.leftMurderMode == true){
    	  this.scar_face(canvas, player);
      }
  	if(player.robot == true){
    	  this.robo_face(canvas, player);
      }
    }else{
       this.babySprite(canvas,player);
  	 if(player.baby_stuck && !baby){
  		 this.bloody_face(canvas, player)//not just for murder mode, because you can kill another player if THEY are murder mode.
  		if(player.murderMode == true){
  		  this.scratch_face(canvas, player);
  		}
  		if(player.leftMurderMode == true){
  		  this.scar_face(canvas, player);
  		}
  		if(player.robot == true){
  			this.robo_face(canvas, player);
  		}

  	 }
    }

    this.hair(canvas, player);
    if(player.isTroll){//wings before sprite
      this.fin1(canvas,player);
    }
    if(!baby && player.class_name == "Prince" && player.godTier){
  	  this.princeTiara(canvas, player);
    }

      if(player.robot == true){
    	  this.roboSkin(canvas, player);
      }else if(player.trickster == true){
          this.peachSkin(canvas, player);
      }else if(!baby && player.grimDark  > 3){
        this.grimDarkSkin(canvas, player)
      }else if(player.isTroll){
        this.greySkin(canvas,player);
      }
      if(player.isTroll){
        this.horns(canvas, player);
      }

      if(player.dead && player.causeOfDeath == "after being shown too many stabs from Jack"){
    	 this.stabs(canvas,player)
     }else if(!baby && player.dead && player.causeOfDeath == "fighting the Black King"){
       this.kingDeath(canvas,player)
     }

      if(player.ghost){
        if(player.causeOfDrain){
          this.rendererHelper.drainedGhostSwap(canvas);
        }else{
          this.rendererHelper.ghostSwap(canvas);
        }
      }

      if(player.aspect == "Void"){
        this.rendererHelper.voidSwap(canvas, 1-player.power/2000) //a void player at 2000 power is fully invisible.
      }
  }

  this.hairBack=function(canvas,player){
    var ctx = canvas.getContext('2d');
  	var imageString = this.baseLocation+"Hair/hair_back"+player.hair+".png"
    //console.log(imageString);
  	this.rendererHelper.addImageTag(imageString)
  	var img=document.getElementById(imageString);
  	var width = img.width;
  	var height = img.height;
  	ctx.drawImage(img,0,0,width,height);
    if(player.sbahj){
      this.rendererHelper.sbahjifier(canvas);
    }
  	if(player.isTroll){
  		this.rendererHelper.swapColors(canvas, "#313131",  player.hairColor);
  		this.rendererHelper.swapColors(canvas, "#202020", player.bloodColor);
  	}else{
  		this.rendererHelper.swapColors(canvas, "#313131", player.hairColor);
  		this.rendererHelper.swapColors(canvas, "#202020", getColorFromAspect(player.aspect));
  	}
  }
  this.hair = function(canvas, player){
  	var ctx = canvas.getContext('2d');
  	var imageString = this.baseLocation+"Hair/hair"+player.hair+".png"
  	this.rendererHelper.addImageTag(imageString)
  	var img=document.getElementById(imageString);
  	var width = img.width;
  	var height = img.height;
  	ctx.drawImage(img,0,0,width,height);
    if(player.sbahj){
      this.rendererHelper.sbahjifier(canvas);
    }
  	if(player.isTroll){
  		this.rendererHelper.swapColors(canvas, "#313131",  player.hairColor);
  		this.rendererHelper.swapColors(canvas, "#202020", player.bloodColor);
  	}else{
  		this.rendererHelper.swapColors(canvas, "#313131", player.hairColor);
  		this.rendererHelper.swapColors(canvas, "#202020", getColorFromAspect(player.aspect));
  	}
  }

  //not just murder mode, you could have killed a murder mode player.
  this.bloody_face = function(canvas, player){
  	if(player.victimBlood){
  		var ctx = canvas.getContext('2d');
  		var imageString = this.baseLocation+"bloody_face.png"
  		this.rendererHelper.addImageTag(imageString)
  		var img=document.getElementById(imageString);
  		var width = img.width;
  		var height = img.height;
  		ctx.drawImage(img,0,0,width,height);
  		this.rendererHelper.swapColors(canvas, "#440a7f", player.victimBlood); //it's not their own blood
  	}
  }

  this.playerToGodBody = function(player){
    var imageString = this.baseLocation+"Bodies/";
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


   this.playerToDreamBody= function(player){
    var imageString = this.baseLocation+"Bodies/";
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


  this.playerToRegularBody=function(player){
    var imageString = this.baseLocation + "Bodies/";
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


  this.getAllImagesNeededForPlayer = function(ocDataString, objectData){
    var bs = this.rendererHelper.ocDataStringToBS(ocDataString);
    var player = dataBytesAndStringsToPlayer(bs[0], bs[1]);  //only use objectData when I KNOW I need to.
    var ret = [];

    ret.push(this.playerToRegularBody(player));
    ret.push(this.playerToDreamBody(player));
  	ret.push(this.playerToGodBody(player));
  	ret.push(this.baseLocation +"Aspects/"+player.aspect + ".png");

  	ret.push(this.baseLocation +"Aspects/"+player.aspect + "Big.png")
  	ret.push(this.baseLocation +"Hair/hair"+player.hair+".png")
    ret.push(this.baseLocation +"Hair/hair_back"+player.hair+".png")

  	if(player.isTroll == true){
  		ret.push(this.baseLocation +"Wings/wing"+player.quirk.favoriteNumber + ".png")
  		ret.push(this.baseLocation +"Horns/left"+player.leftHorn + ".png");
  		ret.push(this.baseLocation +"Horns/right"+player.rightHorn + ".png");
      ret.push(this.baseLocation +"Bodies/grub"+objectData.baby + ".png")
  	}else{
      ret.push(this.baseLocation +"Bodies/baby"+objectData.baby + ".png")
    }
    return ret;
  }

  //see player.js toDataBytes and toDataString to see how I expect them to be formatted.
    this.dataBytesAndStringsToPlayer = function(charString, str_arr){
  	 var player = new Player();
  	 player.quirk = new Quirk();
  	 //console.log("strings is: " + str_arr)
  	 //console.log("chars is: " + charString)
  	 player.causeOfDrain = sanitizeString(decodeURI(str_arr[0]).trim());
  	 player.causeOfDeath = sanitizeString(decodeURI(str_arr[1]).trim());
  	 player.interest1 = sanitizeString(decodeURI(str_arr[2]).trim());
  	 player.interest2 = sanitizeString(decodeURI(str_arr[3]).trim());
  	 player.chatHandle = sanitizeString(decodeURI(str_arr[4]).trim());
  	 //for bytes, how to convert uri encoded string into char string into unit8 buffer?
  	 //holy shit i haven't had this much fun since i did the color replacement engine a million years ago. this is exactlyt he right flavor of challenging.
  	 //console.log("charString is: " + charString)
  	 player.hairColor = intToHexColor((charString.charCodeAt(0) << 16) + (charString.charCodeAt(1) << 8) + (charString.charCodeAt(2)) )
  	 player.class_name = intToClassName(charString.charCodeAt(3) >> 4)
  	 player.aspect = intToAspect(charString.charCodeAt(3) & 15) //get 4 bits on end
  	 player.victimBlood = intToBloodColor(charString.charCodeAt(4) >> 4);
  	 player.bloodColor = intToBloodColor(charString.charCodeAt(4) & 15);
  	 player.interest1Category = intToInterestCategory(charString.charCodeAt(5) >> 4)
  	 player.interest2Category = intToInterestCategory(charString.charCodeAt(5) & 15);
  	 player.grimDark = charString.charCodeAt(6) >> 5;
  	 player.isTroll = 0 != ((1<<4) & charString.charCodeAt(6)) //only is 1 if character at 1<<4 is 1 in charString
  	 player.isDreamSelf = 0 != ((1<<3) & charString.charCodeAt(6))
  	 player.godTier = 0 != ((1<<2) & charString.charCodeAt(6))
  	 player.murderMode = 0 != ((1<<1) & charString.charCodeAt(6))
  	 player.leftMurderMode = 0 != ((1) & charString.charCodeAt(6))
  	 player.robot = 0 != ((1<<7) & charString.charCodeAt(7))
  	 var moon = 0 != ((1<<6) & charString.charCodeAt(7))
  	 //console.log("moon binary is: " + moon)
  	 player.moon = moon ? "Prospit" : "Derse";
  	 //console.log("moon string is: "  + player.moon);
  	 player.dead = 0 != ((1<<5) & charString.charCodeAt(7))
  	 //console.log("Binary string is: " + charString[7])
  	 player.godDestiny = 0 != ((1<<4) & charString.charCodeAt(7))
  	 player.quirk.favoriteNumber = charString.charCodeAt(7) & 15
  	 player.leftHorn = charString.charCodeAt(8)
  	 player.rightHorn = charString.charCodeAt(9)
  	 player.hair = charString.charCodeAt(10)
  	 if(player.interest1Category) interestCategoryToInterestList(player.interest1Category ).push(player.interest1) //maybe don't add if already exists but whatevs for now.
  	 if(player.interest2Category )interestCategoryToInterestList(player.interest2Category ).push(player.interest2)
  	 return player;
  }

  this.getMiscImages = function(){
    var ret = [this.baseLocation + "misc/prince_hat.png", this.baseLocation + "misc/bloody_face.png", this.baseLocation + "misc/calm_scratch_face.png", this.baseLocation + "misc/robo_face.png"];
    ret.push(this.baseLocation + "misc/scratch_face.png")
    ret.push(this.baseLocation + "misc/blood_puddle.png")
    ret.push(this.baseLocation + "misc/fin2.png")
    ret.push(this.baseLocation + "misc/fin1.png")
    ret.push(this.baseLocation + "misc/squiddles_chaos.png")
    ret.push(this.baseLocation + "misc/grimdark.png")
    ret.push(this.baseLocation + "misc/ghostGradient.png")
    ret.push(this.baseLocation + "misc/rainbow.png")
    ret.push(this.baseLocation + "misc/sceptre.png")
    ret.push(this.baseLocation + "misc/denizoned.png")
    ret.push(this.baseLocation + "misc/stab.png")
    ret.push(this.baseLocation + "misc/")
    ret.push(this.baseLocation + "misc/")
    ret.push(this.baseLocation + "misc/")
    for(var i = 1; i<4; i++){
      ret.push(this.baseLocation + "Bodies/baby"+i + ".png")
    }
    return ret;
  }

  this.getPlayerImages = function(){
    var ret = [];
    numBodies = 12;
    var numHair = 61; //+1025 for rufio.  1 indexed
    var numHorns = 73; //1 indexed.
    //var numWings = 12 //0 indexed, not 1.  for now, don't bother with wings. not gonna show godtier, for now.
    for(var i = 1; i<=numBodies; i++){
      if(i<10){
        ret.push(this.baseLocation + "Bodies/reg00"+i+".png");  //as long as i i do a 'load' again when it's to to start the simulation, can get away with only loading these bodies.
        ret.push(this.baseLocation + "Bodies/00"+i+".png");
        ret.push(this.baseLocation + "Bodies/dream00"+i+".png");
      }else{
        ret.push(this.baseLocation + "Bodies/reg0"+i+".png");  //as long as i i do a 'load' again when it's to to start the simulation, can get away with only loading these bodies.
        ret.push(this.baseLocation + "Bodies/dream0"+i+".png");
        ret.push(this.baseLocation + "Bodies/0"+i+".png");
      }
    }

      for(var i = 1; i<=numHair; i++){
          ret.push(this.baseLocation + this.baseLocation + "Hair/hair_back"+i+".png");
          ret.push(this.baseLocation + "Hair/hair"+i+".png");
      }


      for(var i = 0; i<13; i++){
        ret.push(this.baseLocation + "Wings/wing"+i+".png");
      }

      ret.push(this.baseLocation + "Aspects/Blood.png");
      ret.push(this.baseLocation + "Aspects/Mind.png");
      ret.push(this.baseLocation + "Aspects/Rage.png");
      ret.push(this.baseLocation + "Aspects/Time.png");
      ret.push(this.baseLocation + "Aspects/Void.png");
      ret.push(this.baseLocation + "Aspects/Heart.png");
      ret.push(this.baseLocation + "Aspects/Breath.png");
      ret.push(this.baseLocation + "Aspects/Light.png");
      ret.push(this.baseLocation + "Aspects/Space.png");
      ret.push(this.baseLocation + "Aspects/Hope.png");
      ret.push(this.baseLocation + "Aspects/Life.png");
      ret.push(this.baseLocation + "Aspects/Doom.png");

	    ret.push(this.baseLocation + "Hair/hair_back254.png");
      ret.push(this.baseLocation + "Hair/hair254.png");

    for(var i = 1; i<=numHorns; i++){
        ret.push(this.baseLocation + "Horns/left"+i+".png");
        ret.push(this.baseLocation + "Horns/right"+i+".png");
    }
    return ret;
  }

  this.getAllImagesNeeded = function(){
      var ret = this.getMiscImages();
      return ret.concat(this.getPlayerImages());
  }
}


function EggRenderer(rh){
  this.rendererHelper = rh;
  this.drawSpriteFromScratch = function(canvas, ocDataString, objectData){

  }

  this.getAllImagesNeededForPlayer = function(ocDataString, objectData){

  }

  this.getAllImagesNeeded = function(){

  }
}
