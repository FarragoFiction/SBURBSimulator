//coding start 6/21
function RenderingEngine(dontRender, defaultRendererID){
  this.dontRender = dontRender; //AB for example doesn't want you to render
  this.defaultRendererID = defaultRendererID;
  this.renderers = [null, new HomestuckRenderer(this), new HomestuckTrollRenderer(this), new HomestuckHumanRenderer(this), new EggRenderer(this)]; //if they try to render with "null", use defaultRendererID index instead.

  //for sprite customization. only get sprites needed for used rendering type
  this.getAllImagesNeeded = function(renderingType){
    if(renderingType == 0) renderingType = this.defaultRendererID;
    return this.renderers[renderingType].getAllImagesNeeded();
  }

  //when passed a "player" should be an oc data string, because each string is interpreted differently by rendering engines
  this.getAllImagesNeededForPlayer= function(ocDataString, objectData){
    var index = player.renderingType;
    if(player.renderingType == 0) index = this.defaultRendererID;
    return this.renderers[index].getAllImagesNeededForPlayer(ocDataString, objectData);
  }

  //actually renders player, not just using cached image.
  this.renderPlayer = function(canvas, ocDataString, objectData){
    var index = player.renderingType;
    if(player.renderingType == 0) index = this.defaultRendererID;
    var renderer = this.renderers[index];
    //check to see if there is a cached image.
    player = makeRenderingSnapshot(player); //we are rendering how the player was RIGHT NOW.
    renderer.drawSpriteFromScratch(canvas, player);
  }

  this.renderPlayerForScene = function(canvas, ocDataString, objectData){
    if(player.ghost || player.doomed){  //don't expect ghosts or doomed players to render more than a time or two, don't bother caching for now.
        this.renderPlayer(canvas, player);
    }else{
      var canvasDiv = document.getElementById(player.spriteCanvasID);
      this.copyTmpCanvasToRealCanvasAtPos(canvas, canvasDiv,0,0)
    }
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

  //if speed becomes an issue, take in array of color pairs to swap out
  //rather than call this method once for each color
  //swaps one hex color with another.
  //wait no, would be same amount of things. just would have nested for loops instead of
  //multiple calls
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


//calls either HomestuckHumanRenderer or HomestuckTrollRenderer depending on isTroll.
//only SBURBSim will call this function, others will Human or Troll directly, maybe.
function HomestuckRenderer(rh){
  this.rendererHelper = rh;
  this.humanRenderer = new HomestuckHumanRenderer(this.rendererHelper);
  this.trollRenderer = new HomestuckTrollRenderer(this.rendererHelper);

  this.drawSpriteFromScratch = function(canvas, ocDataString, objectData){
    if(player.isTroll){
      this.trollRenderer.drawSpriteFromScratch(canvas, ocDataString, objectData);
    }else{
      this.humanRenderer.drawSpriteFromScratch(canvas, ocDataString, objectData);
    }
  }

  this.getAllImagesNeeded = function(){
    return this.trollRenderer.getAllImagesNeeded(); //shouldn't be an images that humans have thath trolls don't.
  }

  this.getAllImagesNeededForPlayer = function(ocDataString, objectData){
    if(player.isTroll){
      this.trollRenderer.getAllImagesNeededForPlayer(canvas, ocDataString, objectData);
    }else{
      this.humanRenderer.getAllImagesNeededForPlayer(canvas, ocDataString, objectData);
    }
  }
}

//homestuck has one of 3 sprites
function HomestuckHumanRenderer(rh){
  this.baseLocation = "RenderingAssets/Homestuck/";
  this.rendererHelper = rh;

  this.drawSpriteFromScratch = function(canvas, ocDataString, objectData){

  }

  this.getAllImagesNeededForPlayer = function(ocDataString, objectData){

  }

  //probably will never be called, unless i allow humans to be a rendering category without troll.
  this.getAllImagesNeeded = function(){

  }
}

function HomestuckTrollRenderer(rh){
  this.rendererHelper = rh;
  this.baseLocation = "RenderingAssets/Homestuck/";

  this.drawSpriteFromScratch = function(canvas, ocDataString, objectData){
    //ocDataString contains all mandatory information, without any assumptions about what that data is encoding.
    //what is "horns" for a troll might be "eyes" for highschool au, 4 bools might be smooshed together to store an int value, etc.
    //objectData is the actual object in question in case the data string isn't enough.
    //it MIGHT not be the type of object i'm expecting, but I can still do things like if(objectData.doomed) and if the var exists and is true, do something different.
    //and if it doesn't exist, then it's false.
  }

  this.getAllImagesNeededForPlayer = function(ocDataString, objectData){

  }

  this.getMiscImages = function(){
    var ret = [this.baseLocation + "misc/prince_hat.png", this.baseLocation + "misc/bloody_face.png", this.baseLocation + "misc/calm_scratch_face.png", this.baseLocation + "misc/robo_face.png"];
    ret.push(this.baseLocation + "misc/scratch_face.png")
    ret.push(this.baseLocation + "misc/blood_puddle.png")
    ret.push(this.baseLocation + "misc/fin2.png")
    ret.push(this.baseLocation + "misc/fin1.png")
    ret.push(this.baseLocation + "misc/squiddles_chaos.png")
    ret.push(this.baseLocation + "misc/grimdark.png")
    ret.push(this.baseLocation + "misc/heart_forehead.png")
    ret.push(this.baseLocation + "misc/rage_forehead.png")
    ret.push(this.baseLocation + "misc/blood_forehead.png")
    ret.push(this.baseLocation + "misc/mind_forehead.png")
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

      ret.push(this.baseLocation + "Blood.png");
      ret.push(this.baseLocation + "Mind.png");
      ret.push(this.baseLocation + "Rage.png");
      ret.push(this.baseLocation + "Time.png");
      ret.push(this.baseLocation + "Void.png");
      ret.push(this.baseLocation + "Heart.png");
      ret.push(this.baseLocation + "Breath.png");
      ret.push(this.baseLocation + "Light.png");
      ret.push(this.baseLocation + "Space.png");
      ret.push(this.baseLocation + "Hope.png");
      ret.push(this.baseLocation + "Life.png");
      ret.push(this.baseLocation + "Doom.png");

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
