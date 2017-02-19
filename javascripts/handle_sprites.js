function trollify(canvas,player){
   //red_array = red_context.getImageData(0, 0, red_canvas.width, red_canvas.height).data;
   //alert("I should trollify");
  //wings first, replace black and red with blood color with two opacities
   greySkin(canvas,player);
   horns(canvas,player);
}

function greySkin(canvas, player){
  ctx = canvas.getContext('2d');
  var img_data =ctx.getImageData(0, 0, canvas.width, canvas.height);
  //4 byte color array
  for(var i = 0; i<img_data.data.length; i += 4){
    if(img_data.data[i] == 255 && img_data.data[i+1] == 255 &&img_data.data[i+2] == 255){
      img_data.data[i] = 180;
      img_data.data[i+1] = 180;
      img_data.data[i+2] = 180;
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
