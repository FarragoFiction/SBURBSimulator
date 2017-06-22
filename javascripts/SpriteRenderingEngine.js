//coding start 6/21
/*
	A sprite rendering engine is intended to live ABOVE all simulations, and be used by any of them to render themselves in any fashion.
	Put MLP chacters in SBURB, or SBURB characters in some other sim. Whatever.

	As such, the images used by this engine must be kept at the same level AS this engine.

	A RenderingEngine should NOT know how to render a scene (such as leveling up.). That is the job
	of the SceneRenderingEngine (kept at the sim level).  The SceneRenderingEngine will USE a RenderingEngine to
	render the sprites for the scene, sure. But they are kept separate.
*/
function SpriteRenderingEngine(dontRender, defaultRendererID){
  this.dontRender = dontRender; //AB for example doesn't want you to render
  this.defaultRendererID = defaultRendererID;
  this.renderers = [null, new HomestuckRenderer(this) , new EggRenderer(this)]; //if they try to render with "null", use defaultRendererID index instead.


  this.ocDataStringToBS = function(bs){
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

  //actually renders player, not just using cached image.
  this.renderPlayer = function(canvas, ocDataString, objectData){
    var index = player.renderingType;
    if(player.renderingType == 0) index = this.defaultRendererID;
    var renderer = this.renderers[index];
    renderer.drawSpriteFromScratch(canvas, player);
  }

  this.renderPlayerForScene = function(canvas, ocDataString, objectData){
      var canvasDiv = document.getElementById(player.spriteCanvasID);
      this.copyTmpCanvasToRealCanvasAtPos(canvas, canvasDiv,0,0)
      var index = player.renderingType;
      if(player.renderingType == 0) index = this.defaultRendererID;
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
  this.baseLocation = "RenderingAssets/Homestuck/";

  //true random position
  this.drawWhateverTerezi(canvas, imageString){
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

  this.drawSpriteFromScratch = function(canvas, ocDataString, objectData){
    //ocDataString contains all mandatory information, without any assumptions about what that data is encoding.
    //what is "horns" for a troll might be "eyes" for highschool au, 4 bools might be smooshed together to store an int value, etc.
    //objectData is the actual object in question in case the data string isn't enough.
    //it MIGHT not be the type of object i'm expecting, but I can still do things like if(objectData.doomed) and if the var exists and is true, do something different.
    //and if it doesn't exist, then it's false.
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
  	ret.push(this.baseLocation +this.baseLocation +"Aspects/"+"Hair/hair"+player.hair+".png")
    ret.push(this.baseLocation +"Hair/hair_back"+player.hair+".png")

  	if(player.isTroll == true){
  		ret.push(this.baseLocation +"Wings/wing"+player.quirk.favoriteNumber + ".png")
  		ret.push(this.baseLocation +"Horns/left"+player.leftHorn + ".png");
  		ret.push(this.baseLocation +"Horns/right"+player.rightHorn + ".png");
      ret.push(this.baseLocation +"Bodies/grub"+player.baby + ".png")
  	}else{
      ret.push(this.baseLocation +"Bodies/baby"+player.baby + ".png")
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
