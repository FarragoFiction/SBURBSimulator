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
}




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
