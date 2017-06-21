//coding start 6/21
function RenderingEngine(dontRender, defaultRendererID){
  this.dontRender = dontRender; //AB for example doesn't want you to render
  this.defaultRendererID = defaultRendererID;
  this.rendererHelper = new RendererHelper();
  this.renderers = [null, new HomestuckRenderer(this.rendererHelper), new EggRenderer(this.rendererHelper)]; //if they try to render with "null", use defaultRendererID index instead.
}

function RendererHelper(){

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
