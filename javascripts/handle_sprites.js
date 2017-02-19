function trollify(canvas,player){
   //red_array = red_context.getImageData(0, 0, red_canvas.width, red_canvas.height).data;
   //alert("I should trollify");
  //wings first, replace black and red with blood color with two opacities
   greySkin(canvas,player);
   horns(canvas,player);
}

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


//swaps one hex color with another.
function swapColors(canvas, color1, color2){
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
      img_data.data[i+3] = 255;
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

function greySkin(canvas){
  swapColors(canvas, "#ffffff", "#b4b4b4")
}

function horns(canvas, player){
    var num = leftHorn(canvas,player);
    rightHorn(num, canvas,player);
  /*  ctx = canvas.getContext('2d');
    var horns = document.getElementById("test_horn");
    var width = horns.width;//replace these with sprite sheet
  	var height = horns.height;
    ctx.drawImage(horns,0,0,width,height);
    */
}
//horns are no longer a sprite sheet. tracy and kristi and brandon gave me advice.
//position horns on an image as big as the canvas. put the horns directly on the
//place where the head of every sprite would be.
//same for wings eventually.
function leftHorn(canvas, player){
    ctx = canvas.getContext('2d');
    var randNum = getRandomInt(1,9);
    var imageString = "left"+randNum + ".png";
    addImageTag(imageString)
    var img=document.getElementById(imageString);
    var width = img.width;
  	var height = img.height;
  	ctx.drawImage(img,0,0,width,height);
    //console.log("Random number is: " + randNum)
    return randNum; //right horn has high chance of matching left horn
}
//parse horns sprite sheet. render a random right horn.
//right horn should be at: 120,40
function rightHorn(randNum, canvas, player){
  console.log("doing right horn");
  ctx = canvas.getContext('2d');
  if(Math.random() > .2){ //preference for symmetry
    randNum = getRandomInt(1,9);
  }
  var imageString = "right"+randNum + ".png";
  addImageTag(imageString)
  var img=document.getElementById(imageString);
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);
}

function addImageTag(url){
  console.log(url);
	//only do it if image hasn't already been added.
	if(document.getElementById(url) == null) {
		var tag = '<img id ="' + url + '" src = "images/' + url + '" style="display:none">';
		$("#image_staging").append(tag);
	}
}


function drawSprite(canvas, player){
  //console.log("looking for canvas: " + canvas);
  canvas = $("#"+canvas)[0]; //don't want jquery object, want contents
  ctx = canvas.getContext('2d');
  //sprite = new Image();
  //sprite.src = 'test.png';
  var sprites = document.getElementById("godtiers");
  //need to get sprite from sprite sheet
  //then if trolls, do post proccesing.
  //grey skin, horns, wings in blood color
	//var width = img.width;
	//var height = img.height;
	//ctx.drawImage(sprites,0,0,width,height);
  playerToSprite(canvas,player);
  //then troll proccess???
  //this was for sprite sheet
  //ctx.drawImage(sprites,position[0],position[1],position[2],position[3],canvas.width/2,canvas.height/2,position[6],position[7]);
  //ctx.drawImage(img,canvas.width/2,canvas.height/2,width,height);
  if(player.isTroll){
    trollify(canvas,player);
  }

  //ctx.drawImage(sprite, 100, 100);
}

function playerToSprite(canvas, player){
  //draw class, then color like aspect, then draw chest icon
  //ctx.drawImage(img,canvas.width/2,canvas.height/2,width,height);
  var imageString = "";
  if(player.class_name == "Page"){
    imageString = "001.png"
  }else if(player.class_name == "Knight" ){
    imageString = "002.png"
  }else if(player.class_name == "Witch" ){
    imageString = "003.png"
  }else if(player.class_name == "Sylph" ){
    imageString = "004.png"
  }else if(player.class_name == "Thief" ){
    imageString = "005.png"
  }else if(player.class_name == "Rogue" ){
    imageString = "006.png"
  }else if(player.class_name == "Seer" ){
    imageString = "007.png"
  }else if(player.class_name == "Mage" ){
    imageString = "008.png"
  }else if(player.class_name == "Heir" ){
    imageString = "009.png"
  }else if(player.class_name == "Maid" ){
    imageString = "010.png"
  }else if(player.class_name == "Prince" ){
    imageString = "011.png"
  }else if(player.class_name == "Bard" ){
    imageString = "012.png"
  }

  addImageTag(imageString)
  var img=document.getElementById(imageString);
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,width/6,height/4,width,height);
  aspectPalletSwap(canvas, player);

}

function aspectPalletSwap(canvas, player){
  //replace all outlines with black
  var oldshirt = "#ff7f00"; //shirt
  var oldpants = "#f95900"; //pants
  var oldhat = "#fd1000"; //hat
  var oldsymbol= "#fbff00"; //symbol
  var oldcolor5 = "#e56500"; //outline
  var olddarkhat = "#d41000"; //darker hat
  var oldshoes = "#00e4ff"; //shoes
  var oldcolor8 = "#00a7be"; //shoes outline
  var olddarkcape = "#ff1800"; //darker cape
  var oldcolor10 = "#aafaff"; //light shoes
  var oldcolor11 = "#da4f00"; //another outline....
  var oldcolor12 = "#f13a00"; //cape outline
  var oldcolor13 = "#fc8700"; //shirt outline
  var oldcolor14 = "#00c5de"; //shoes outline
  var oldcolor15 = "#f27200"; //shirt line
  var oldcolor16 = "#fe1400"; //more outline
  var oldcolor17 = "#f23e00"; //outline
  var oldcolor18 ="#fdbf00"; //symbol outline
  var oldcolor19 ="#ff4b00";//outline
  var oldcolor20 = "#e95400";//outline
  var oldcolor20 = "#eb2f00";//outline
  var oldcolor21 = "#55d0de"//shoes outline
  var oldcolor22 = "#e91400" //cape outline
  var oldcolor23 = "#e95400" //pants outline
  var oldcolor24 = "#00a5bd"//shoes outline
  var oldcolor25 = "#ffcb00"//socks outline
  var oldcolor26 = "#fde500"//socks outline
  var oldcolor27 = "#fe4700"// cape outline
  var oldcolor28 = "#fd8b00"// bard outline

  var newshirt = "#b4b4b4"
  var newpants = "#b4b4b4"
  var newhat = "#b4b4b4"
  var newsymbol = "#b4b4b4"
  var newcolor5 = "#b4b4b4"
  var newdarkhat = "#b4b4b4"
  var newshoes = "#b4b4b4"
  var newcolor8 = "#b4b4b4"
  var newdarkcape = "#b4b4b4"

  if(player.aspect =="Light"){
    newshirt = "#ff7f00"
    newpants = "#f95900"
    newhat = "#fd1000"
    newdarkhat = "#d41000"; //darker hat
    newdarkcape = "#ff1800";
    newsymbol="#fbff00"
    newshoes ="#00e4ff"
  }else if(player.aspect =="Breath"){
    newshirt = "#0087eb"
    newpants = "#006be1"
    newhat = "#0046d1"
    newdarkhat ="#003396"
    newdarkcape ="#0052f3"
    newsymbol="#10e0ff"
    newshoes ="#fefd49"
  }else if(player.aspect =="Time"){
    newshirt = "#b70d0e"
    newpants = "#8e1516"
    newhat = "#3c0404"
    newdarkhat ="#1f0000"
    newdarkcape ="#510606"
    newsymbol="#ff2106"
    newshoes ="#000000"
  }else if(player.aspect =="Space"){
    newshirt = "#030303"
    newpants = "#2f2f30"
    newhat = "#1d1d1d"
    newdarkhat ="#141414"
    newdarkcape ="#2f2f30"
    newsymbol="#efefef"
    newshoes ="#ff2106"
  }

  swapColors(canvas, oldshirt, newshirt);
  swapColors(canvas, oldpants, newpants)
  swapColors(canvas, oldhat, newhat)
  swapColors(canvas, oldsymbol, newsymbol)
  swapColors(canvas, oldcolor5, "#000000")
  swapColors(canvas, olddarkhat, newdarkhat)
  swapColors(canvas, oldshoes, newshoes)
  swapColors(canvas, oldcolor8, "#000000")
  swapColors(canvas, olddarkcape, newdarkcape)
  swapColors(canvas, oldcolor10, "#000000")
  swapColors(canvas, oldcolor11, "#000000")
  swapColors(canvas, oldcolor12, "#000000")
  swapColors(canvas, oldcolor13, "#000000")
  swapColors(canvas, oldcolor14, "#000000")
  swapColors(canvas, oldcolor15, "#000000")
  swapColors(canvas, oldcolor16, "#000000")
  swapColors(canvas, oldcolor17, "#000000")
  swapColors(canvas, oldcolor18, "#000000")
  swapColors(canvas, oldcolor19, "#000000")
  swapColors(canvas, oldcolor20, "#000000")
  swapColors(canvas, oldcolor21, "#000000")
  swapColors(canvas, oldcolor22, "#000000")
  swapColors(canvas, oldcolor23, "#000000")
  swapColors(canvas, oldcolor24, "#000000")
  swapColors(canvas, oldcolor25, "#000000")
  swapColors(canvas, oldcolor26, "#000000")
  swapColors(canvas, oldcolor27, "#000000")
  swapColors(canvas, oldcolor28, "#000000")
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
