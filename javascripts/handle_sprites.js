function drawSprite(canvas, player){
  var width = 250;
  var height = 250;
  console.log("looking for canvas: " + canvas);
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
  var position = playerToSprite(player);
  //then troll proccess???
  ctx.drawImage(sprites,position[0],position[1],position[2],position[3],position[4],position[5],position[6],position[7]);


  //ctx.drawImage(sprite, 100, 100);
}

//return array of vales for draw image
  //ctx.drawImage(sprites,srcX,srcY,srcW,srcH,destX,destY,destW,destH);
//page knight witch sylph
// thief rogue seer  mage
// heir  maid  prince bard
function playerToSprite(player){
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
    var x = origin_x+class_mod_x;
    var y = origin_y+class_mod_y;
    //ctx.drawImage(sprites,srcX,srcY,srcW,srcH,destX,destY,destW,destH);
    alert("x: "+x+", y"+y);
    return [x,y,150,200, 0,0,150,200];
}
