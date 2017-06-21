//coding start 6/21
function RenderingEngine(dontRender, defaultRendererID){
  this.dontRender = dontRender; //AB for example doesn't want you to render
  this.defaultRendererID = defaultRendererID;
  this.renderers = [null, new HomestuckRenderer(this), new EggRenderer(this)]; //if they try to render with "null", use defaultRendererID index instead.

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

********************************************************************************/


//calls either HomestuckHumanRenderer or HomestuckTrollRenderer depending on isTroll.
//only SBURBSim will call this function, others will Human or Troll directly, maybe.
function HomestuckRenderer(rh){
  this.rendererHelper = rh;
}

//homestuck has one of 3 sprites
function HomestuckHumanRenderer(rh){
  this.rendererHelper = rh;
}

function HomestuckTrollRenderer(rh){
  this.rendererHelper = rh;
}


function EggRenderer(rh){
  this.rendererHelper = rh;
}
