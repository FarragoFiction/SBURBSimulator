function trollify(canvas,player){
   //red_array = red_context.getImageData(0, 0, red_canvas.width, red_canvas.height).data;
   //alert("I should trollify");
  //wings first, replace black and red with blood color with two opacities
  // wings(canvas,player);
   greySkin(canvas,player);
   fins(canvas, player);
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

function swapColors50(canvas, color1, color2){
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
      img_data.data[i+3] = 128;
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
  swapColors(canvas, "#ffffff", "#c4c4c4")
}

function wings(canvas,player){
  //blood players have no wings, all other players have wings matching
  //favorite color
  if(player.aspect == "Blood"){
    //return;  //karkat and kankri don't have wings, but is that standard? or are they just hiding them?
  }

  ctx = canvas.getContext('2d');
  //var num = player.quirk.favoriteNumber;
	var num = 10;
  var imageString = "wing"+num + ".png";
  addImageTag(imageString)
  var img=document.getElementById(imageString);
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);

  swapColors50(canvas, "#00ff2a",player.bloodColor);
  swapColors(canvas, "#ff0000",player.bloodColor);
}

function fins(canvas, player){
  if(player.bloodColor == "#610061" || player.bloodColor == "#99004d"){
    ctx = canvas.getContext('2d');
    var imageString = "fins.png";
    addImageTag(imageString)
    var img=document.getElementById(imageString);
    var width = img.width;
    var height = img.height;
    ctx.drawImage(img,0,0,width,height);
  }
}

function horns(canvas, player){
    leftHorn(canvas,player);
    rightHorn(canvas,player);
}
//horns are no longer a sprite sheet. tracy and kristi and brandon gave me advice.
//position horns on an image as big as the canvas. put the horns directly on the
//place where the head of every sprite would be.
//same for wings eventually.
function leftHorn(canvas, player){
    ctx = canvas.getContext('2d');
	if(player.leftHorn == 0){
    	player.leftHorn = getRandomInt(1,9);
	}
    var imageString = "left"+player.leftHorn + ".png";
    addImageTag(imageString)
    var img=document.getElementById(imageString);
    var width = img.width;
  	var height = img.height;
  	ctx.drawImage(img,0,0,width,height);
    //console.log("Random number is: " + randNum)
}
//parse horns sprite sheet. render a random right horn.
//right horn should be at: 120,40
function rightHorn(canvas, player){
 // console.log("doing right horn");
  ctx = canvas.getContext('2d');
  if(player.rightHorn == 0 &&Math.random() > .9 ){ //preference for symmetry
    player.rightHorn = getRandomInt(1,9);
  }else if(player.rightHorn == 0){
	player.rightHorn = player.leftHorn;
  }
  var imageString = "right"+player.rightHorn + ".png";
  addImageTag(imageString)

  var img=document.getElementById(imageString);
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);
}

function addImageTag(url){
  //console.log(url);
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
  if(player.isTroll){//wings before sprite
    wings(canvas,player);
  }
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
  aspectSymbol(canvas, player);

}

function aspectSymbol(canvas, player){
    ctx = canvas.getContext('2d');
    var imageString = player.aspect + ".png"
    addImageTag(imageString)
    var img=document.getElementById(imageString);
    var width = img.width;
    var height = img.height;
    ctx.drawImage(img,0,0,width,height);
}

function aspectPalletSwap(canvas, player){
  //not all browsers do png gama info correctly. Chrome does, firefox does not, mostly.
  //remove it entirely with this command
  //pngcrush -rem gAMA -rem cHRM -rem iCCP -rem sRGB infile.png outfile.png
  var oldcolor1 = "#ff8800"; //shirt
  var oldcolor2 = "#e76700"; //pants
  var oldcolor3 = "#fa4900"; //hat
  var oldcolor4 = "#fefd49"; //symbol fefd49
  var oldcolor5 = "#c33700"; //darker hat
  var oldcolor6 = "#10e0ff"; //shoes

  var newcolor1 = "#b4b4b4";
  var newcolor2 = "#b4b4b4";
  var newcolor3 = "#b4b4b4";
  var newcolor4 = "#b4b4b4";
  var newcolor5 = "#b4b4b4";
  var newcolor6 = "#b4b4b4";

  //why does this bug out color replacement???
  if(player.aspect =="Light"){
    newcolor1 = "#ff7f00"
    newcolor2 = "#f95900"
    newcolor3 = "#fd1000"
    newcolor4 ="#fbff00"
    newcolor5 = "#d41000"; //darker hat
    oldcolor6 ="#00e4ff"
  }else if(player.aspect =="Breath"){
    newcolor1 = "#0087eb"
    newcolor2 = "#006be1"
    newcolor3 = "#0046d1"
    newcolor4 = "#10e0ff"
    newcolor5 = "#003396"
    newcolor6 = "#fefd49"
  }else if(player.aspect =="Time"){
    newcolor1 = "#b70d0e"
    newcolor2 = "#8e1516"
    newcolor3 = "#3c0404"
    newcolor4 ="#ff2106"
    newcolor5 ="#1f0000"
    newcolor6 ="#000000"
  }else if(player.aspect =="Space"){
    newcolor1 = "#030303"
    newcolor2 = "#2f2f30"
    newcolor3 = "#1d1d1d"
    newcolor4 ="#efefef"
    newcolor5 ="#141414"
    newcolor6 ="#ff2106"
  }else if(player.aspect =="Heart"){
    newcolor1 = "#6b0829" //shirt
    newcolor2 = "#55142a" //pants
    newcolor3 = "#3c0d1f"  //hat
    newcolor4 ="#bd1864"  //symbol
    newcolor5 ="#260914"  //dark hat
    newcolor6 ="#1d572e"  //shoes
  }else if(player.aspect =="Mind"){
    newcolor1 = "#3da35a" //shirt
    newcolor2 = "#3b7e4f" //pants
    newcolor3 = "#164524"  //hat
    newcolor4 ="#06ffc9"  //symbol
    newcolor5 ="#11371d"  //dark hat
    newcolor6 ="#11371d"  //shoes
  }else if(player.aspect =="Life"){
    newcolor1 = "#ccc4b5" //shirt
    newcolor2 = "#a29989" //pants
    newcolor3 = "#494132"  //hat
    newcolor4 ="#76c34e"  //symbol
    newcolor5 ="#2d271e"  //dark hat
    newcolor6 ="#00164f"  //shoes
  }else if(player.aspect =="Void"){
    newcolor1 = "#033476" //shirt
    newcolor2 = "#004cb2" //pants
    newcolor3 = "#00103c"  //hat
    newcolor4 ="#0b1741"  //symbol
    newcolor5 ="#00071a"  //dark hat
    newcolor6 ="#ccc4b5"  //shoes
  }else if(player.aspect =="Hope"){
    newcolor1 = "#ffe094" //shirt
    newcolor2 = "#f6c54a" //pants
    newcolor3 = "#f7bb2c"  //hat
    newcolor4 ="#fcf0c7"  //symbol
    newcolor5 ="#dba523"  //dark hat
    newcolor6 ="#164524"  //shoes
  }
  else if(player.aspect =="Doom"){
    newcolor1 = "#204020" //shirt
    newcolor2 = "#192c16" //pants
    newcolor3 = "#141614"  //hat
    newcolor4 ="#0f0f0f"  //symbol
    newcolor5 ="#0b0d0b"  //dark hat
    newcolor6 ="#ffe094"  //shoes
  }else if(player.aspect =="Rage"){
    newcolor1 = "#381b76" //shirt
    newcolor2 = "#281d36" //pants
    newcolor3 = "#6d34a6"  //hat
    newcolor4 ="#994bb3"  //symbol
    newcolor5 ="#592d86"  //dark hat
    newcolor6 ="#3d190a"  //shoes
  }else if(player.aspect =="Blood"){
    newcolor1 = "#3d190a" //shirt
    newcolor2 = "#5c2913" //pants
    newcolor3 = "#230200"  //hat
    newcolor4 ="#ba1016"  //symbol
    newcolor5 ="#110000"  //dark hat
    newcolor6 ="#381b76"  //shoes
  }


  swapColors(canvas, oldcolor1, newcolor1)
  swapColors(canvas, oldcolor2, newcolor2)
  swapColors(canvas, oldcolor3, newcolor3)
  swapColors(canvas, oldcolor4, newcolor4)
  swapColors(canvas, oldcolor5, newcolor5)
  swapColors(canvas, oldcolor6, newcolor6)
  /*
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
  */
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
