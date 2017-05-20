//need to render all players
function CharacterCreatorHelper(players){
	this.div = $("#character_creator");
	this.players = players;
	//have css for each sprite template.  sprite template is 400 x 300, fit 3 on a line?
	//max of 4 lines?

	this.drawAllPlayers = function(){
		for(var i = 0; i<this.players.length; i++){
			this.drawSinglePlayer(this.players[i]);
		}
	}
	this.drawSinglePlayer = function(player){
		var str = "";
		var divId =  player.chatHandle;
		divId = divId.replace(/\s+/g, '')
		str += "<div class='createdCharacter'>"
		var canvasHTML = "<canvas class = 'createdCharacterCanvas' id='canvas" +divId + "' width='" +400 + "' height="+300 + "'>  </canvas>";
		str += "<div class = 'stats'>"
		str += (this.drawOneClassDropDown(player));
		str += ("of");
		str+= (this.drawOneAspectDropDown(player));
		str += "<br>Hair Type:" + this.drawOneHairDropDown(player);
		str += "Hair Color:" + this.drawOneHairColorDropDown(player);
		str += "Species: " + this.drawOneSpeciesDropDown(player);
		str += "</div>"

		str += (canvasHTML);
		str += "</div>"
		this.div.append(str);

		player.spriteCanvasID = player.chatHandle+player.id+"spriteCanvas";
		var canvasHTML = "<br><canvas style='display:none' id='" + player.spriteCanvasID+"' width='" +400 + "' height="+300 + "'>  </canvas>";
		$("#playerSprites").append(canvasHTML)

		player.renderSelf();

		var canvas = document.getElementById("canvas"+ divId);
		//drawSinglePlayer(canvas, player);
		var p1SpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
		drawSpriteFromScratch(p1SpriteBuffer,player)
		//drawBG(p1SpriteBuffer, "#ff9999", "#ff00ff")
		copyTmpCanvasToRealCanvasAtPos(canvas, p1SpriteBuffer,0,0)
		this.wireUpPlayerDropDowns(player);

	}

	this.redrawSinglePlayer = function(player){
		  player.renderSelf();
			var divId = "canvas" + player.chatHandle;
			divId = divId.replace(/\s+/g, '');
			var canvas =$("#"+divId)[0]
			drawSolidBG(canvas, "#ffffff")
			drawSinglePlayer(canvas, player);
	}


	this.wireUpPlayerDropDowns = function(player){
			var c2 =  $("#classNameID" +player.chatHandle) ;
			var a2 =  $("#aspectID" +player.chatHandle) ;
			var hairDiv  =  $("#hairTypeID" +player.chatHandle) ;
			var hairColorDiv  =  $("#hairColorID" +player.chatHandle) ;
			var that = this;
			c2.change(function() {
					var classDropDown = $('[name="className' +player.chatHandle +'"] option:selected') //need to get what is selected inside the .change, otheriise is always the same
					player.class_name = classDropDown.val();
					that.redrawSinglePlayer(player);
			});


			a2.change(function() {
					var aspectDropDown = $('[name="aspect' +player.chatHandle +'"] option:selected')
					player.aspect = aspectDropDown.val();
					that.redrawSinglePlayer(player);
			});

			hairDiv.change(function() {
					var aspectDropDown = $('[name="hair' +player.chatHandle +'"] option:selected')
					player.hair = aspectDropDown.val();
					that.redrawSinglePlayer(player);
			});

			hairColorDiv.change(function() {
					var aspectDropDown = $('[name="hairColor' +player.chatHandle +'"] option:selected')
					player.hairColor = aspectDropDown.val();
					that.redrawSinglePlayer(player);
			});
	}

	//(1,60)
	this.drawOneHairDropDown = function(player){
		var html = "<select id = 'hairTypeID" + player.chatHandle + "' name='hair" +player.chatHandle +"'>";
		for(var i = 1; i<= 60; i++){
			if(player.hair == i){
				html += '<option  selected = "selected" value="' + i +'">' + i+'</option>'
			}else{
				html += '<option value="' + i +'">' + i+'</option>'
			}
		}
		html += '</select>'
		return html;
	}

	this.drawOneClassDropDown = function(player){
		available_classes = classes.slice(0); //re-init available classes. make deep copy
		var html = "<select id = 'classNameID" + player.chatHandle + "' name='className" +player.chatHandle +"'>";
		for(var i = 0; i< available_classes.length; i++){
			if(available_classes[i] == player.class_name){
				html += '<option  selected = "selected" value="' + available_classes[i] +'">' + available_classes[i]+'</option>'
			}else{
				html += '<option value="' + available_classes[i] +'">' + available_classes[i]+'</option>'
			}
		}
		html += '</select>'
		return html;
	}

	this.drawOneSpeciesDropDown = function(player){
		var species = ["Human", "Troll"]
		var html = "<select id = 'speciesID" + player.chatHandle + "' name='species" +player.chatHandle +"'>";
		for(var i = 0; i< species.length; i++){
			if((species[i] == "Troll" && player.isTroll) || (species[i] == "Human" && !player.isTroll)){
				html += '<option  selected = "species" value="' + species[i] +'">' + species[i]+'</option>'
			}else{
				html += '<option value="' + species[i] +'">' + species[i]+'</option>'
			}
		}
		html += '</select>'
		return html;

	}

	this.drawOneHairColorDropDown = function(player){
		var html = "<select id = 'hairColorID" + player.chatHandle + "' name='hairColor" +player.chatHandle +"'>";
		for(var i = 0; i< human_hair_colors.length; i++){
			if(human_hair_colors[i] == player.hairColor){
				html += '<option style="background:' + human_hair_colors[i] + '" selected = "hairColor" value="' + human_hair_colors[i] +'">' + human_hair_colors[i]+'</option>'
			}else{
				html += '<option style="background:' + human_hair_colors[i] + '"value="' + human_hair_colors[i] +'">' + human_hair_colors[i]+'</option>'
			}
		}
		html += '</select>'
		return html;
	}

	this.drawOneAspectDropDown = function(player){
		available_aspects = nonrequired_aspects.slice(0); //required_aspects
	  available_aspects = available_aspects.concat(required_aspects.slice(0));
		var html = "<select id = 'aspectID" + player.chatHandle + "'' name='aspect" +player.chatHandle +"'>";
		for(var i = 0; i< available_aspects.length; i++){
			if(available_aspects[i] == player.aspect){
				html += '<option selected = "selected" value="' + available_aspects[i] + '" >' + available_aspects[i]+'</option>'
			}else{
				html += '<option value="' + available_aspects[i] + '" >' + available_aspects[i]+'</option>'
			}

		}
		html += '</select>'
		return html;
	}

}
