//need to render all players
function CharacterCreatorHelper(players){
	this.div = $("#character_creator");
	this.players = players;
	//have css for each sprite template.  sprite template is 400 x 300, fit 3 on a line?
	//max of 4 lines?

	this.drawAllPlayers = function(){
		bloodColors.push("#ff0000") //for humans
		for(var i = 0; i<this.players.length; i++){
			this.drawSinglePlayer(this.players[i]);
		}
	}
	this.drawSinglePlayer = function(player){
		//debug code, remove later
		/*
		player.interest1 = "Custom Interest"
		player.interest1Category = "Music"
		player.interest2 = "Rap" //not a custom interest, make sure sim doesn't try to add it twice.
		player.interest2Category = "Music"*/
		//console.log("drawing: " + player.title())
		var str = "";
		var divId =  player.chatHandle;
		divId = divId.replace(/\s+/g, '')
		str += "<div class='createdCharacter'>"
		var canvasHTML = "<canvas class = 'createdCharacterCanvas' id='canvas" +divId + "' width='" +400 + "' height="+300 + "'>  </canvas>";
		str += "<div class = 'charOptions'>"
		str += (this.drawOneClassDropDown(player));
		str += ("of");
		str+= (this.drawOneAspectDropDown(player));
		str += "Hair Type:" + this.drawOneHairDropDown(player);
		str += "Hair Color:" + this.drawOneHairColorPicker(player);
		str += "Species: " + this.drawOneSpeciesDropDown(player);
		str += "Left Horn: " + this.drawOneLeftHornDropDown(player);
		str += "Right Horn: " + this.drawOneRightHornDropDown(player);
		str += "BloodColor: " + this.drawOneBloodColorDropDown(player);
		str += "Favorite Number: " + this.drawOneFavoriteNumberDropDown(player);
		str += this.drawInterests(player);
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
		this.wireUpInterests(player);

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
			var speciesDiv  =  $("#speciesID" +player.chatHandle) ;
			var leftHornDiv  =  $("#leftHornID" +player.chatHandle) ;
			var rightHornDiv  =  $("#rightHornID" +player.chatHandle) ;
			var bloodDiv  =  $("#bloodColorID" +player.chatHandle) ;
			var favoriteNumberDiv  =  $("#favoriteNumberID" +player.chatHandle) ;


			var that = this;
			c2.change(function() {
					var classDropDown = $('[name="className' +player.chatHandle +'"] option:selected') //need to get what is selected inside the .change, otheriise is always the same
					player.class_name = classDropDown.val();
					that.redrawSinglePlayer(player);
			});

			favoriteNumberDiv.change(function() {
					var numberDropDown = $('[name="favoriteNumber' +player.chatHandle +'"] option:selected') //need to get what is selected inside the .change, otheriise is always the same
					player.quirk.favoriteNumber = numberDropDown.val();
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
					//var aspectDropDown = $('[name="hairColor' +player.chatHandle +'"] option:selected')
					player.hairColor = hairColorDiv.val();
					that.redrawSinglePlayer(player);
			});

			leftHornDiv.change(function() {
					var aspectDropDown = $('[name="leftHorn' +player.chatHandle +'"] option:selected')
					player.leftHorn = aspectDropDown.val();
					that.redrawSinglePlayer(player);
			});

			rightHornDiv.change(function() {
					var aspectDropDown = $('[name="rightHorn' +player.chatHandle +'"] option:selected')
					player.rightHorn = aspectDropDown.val();
					that.redrawSinglePlayer(player);
			});

			bloodDiv.change(function() {
					var aspectDropDown = $('[name="bloodColor' +player.chatHandle +'"] option:selected')
					player.bloodColor = aspectDropDown.val();
					that.redrawSinglePlayer(player);
			});

			speciesDiv.change(function() {
					var aspectDropDown = $('[name="species' +player.chatHandle +'"] option:selected')
					var str = aspectDropDown.val();
					if(str == "Troll"){
						player.isTroll = true;
					}else{
						player.isTroll = false;
					}
					that.redrawSinglePlayer(player);
			});
	}
	
	this.wireUpInterests = function(player){
		//first, choosing interest category should change the contents of interestDrop1 or 2 (but NOT any value in the player or the text box.)
		var interestCategory1Dom =  $("#interestCategory1" +player.chatHandle);
		var interestCategory2Dom =  $("#interestCategory2" +player.chatHandle);
		var interest1DropDom =  $("#interestDrop1" +player.chatHandle);
		var interest2DropDom =  $("#interestDrop2" +player.chatHandle);
		var that = this;
		interestCategory1Dom.change(function() {
					var icDropDown = $('[name="interestCategory1' +player.chatHandle +'"] option:selected')
					interest1DropDom.html(that.drawInterestDropDown(icDropDown.val(), 1, player))
		});
		
		interestCategory2Dom.change(function() {
					var icDropDown = $('[name="interestCategory2' +player.chatHandle +'"] option:selected')
					interest2DropDom.html(that.drawInterestDropDown(icDropDown.val(), 2, player))
		});
		
		interest1DropDom.change(function() {
					var icDropDown = $('[name="interestDrop1' +player.chatHandle +'"] option:selected')
					//TODO repopulate interest1 
					alert(icDropDown.val())
		});
		
		interest2DropDom.change(function() {
					var icDropDown = $('[name="interestDrop2' +player.chatHandle +'"] option:selected')
					//TODO repopulate interest1 
					alert(icDropDown.val())
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
	
	this.drawInterests = function(player){
		var str = "";
		str += " CategoryInterest1 " + this.drawInterestCategoryDropDown(1,player);
		str += " PreDefinedInterest1 " +this.drawInterestDropDown(player.interest1Category, 1,player);
		str += " Interest1 " + this.drawInterestTextBox(1,player);
		str += " CategoryInterest2 " +this.drawInterestCategoryDropDown(2,player);
		str += " PreDefinedInterest2 " +this.drawInterestDropDown(player.interest2Category, 2,player);
		str += " Interest2 " + this.drawInterestTextBox(2,player);
		return str;
	}
	
	this.drawInterestTextBox = function(num,player){
		var interestToCheck = player.interest1;
		if(num == 2) interestToCheck = player.interest2;
		var html = "<input type='text' id = 'interest" + num+ player.chatHandle + "' name='interest" +num+player.chatHandle +"' + value='" + interestToCheck +"'> </input>"
		return html;
	}
	
	this.drawInterestDropDown = function(category, num, player){
		var html = "<select id = 'interestDrop" + num+ player.chatHandle + "' name='interestDrop" +num+player.chatHandle +"'>";
		var interestsInCategory = interestCategoryToInterestList(category);
		var interestToCheck = player.interest1;
		if(num == 2) interestToCheck = player.interest2;
		for(var i = 0; i< interestsInCategory.length; i++){
			var pi = interestsInCategory[i];
			if(interestToCheck == pi){
				html += '<option  selected = "selected" value="' + pi +'">' + pi+'</option>'
			}else{
				html += '<option value="' + pi +'">' + pi+'</option>'
			}
		}
		html += '</select>'
		return html;
	}
	
	this.drawInterestCategoryDropDown = function(num,player){
		var html = "<select id = 'interestCategory" + num+ player.chatHandle + "' name='interestCategory" +num+player.chatHandle +"'>";
		for(var i = 0; i< interestCategories.length; i++){
			var ic = interestCategories[i];
			if(player.interestedIn(ic, num)){
				if(num ==1){
					player.interest1Category = ic
				}else if(num == 2){
					player.interest2Category = ic
				}
				html += '<option  selected = "selected" value="' + ic +'">' + ic+'</option>'
			}else{
				html += '<option value="' + ic +'">' + ic+'</option>'
			}
		}
		html += '</select>'
		return html;
	}

	//0,12
	this.drawOneFavoriteNumberDropDown = function(player){
		var html = "<select id = 'favoriteNumberID" + player.chatHandle + "' name='favoriteNumber" +player.chatHandle +"'>";
		for(var i = 0; i<= 12; i++){
			if(player.quirk.favoriteNumber == i){
				html += '<option  selected = "selected" value="' + i +'">' + i+'</option>'
			}else{
				html += '<option value="' + i +'">' + i+'</option>'
			}
		}
		html += '</select>'
		return html;
	}

	this.drawOneLeftHornDropDown = function(player){
		var html = "<select id = 'leftHornID" + player.chatHandle + "' name='leftHorn" +player.chatHandle +"'>";
		for(var i = 1; i<= 46; i++){
			if(player.leftHorn == i){
				html += '<option  selected = "selected" value="' + i +'">' + i+'</option>'
			}else{
				html += '<option value="' + i +'">' + i+'</option>'
			}
		}
		html += '</select>'
		return html;
	}

	this.drawOneRightHornDropDown = function(player){
		var html = "<select id = 'rightHornID" + player.chatHandle + "' name='rightHorn" +player.chatHandle +"'>";
		for(var i = 1; i<= 46; i++){
			if(player.leftHorn == i){
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

	this.drawOneHairColorPicker = function(player){
		var id = "hairColorID" + player.chatHandle
		var html = "<input id = '" + id + "' type='color' name='favcolor' value='" + player.hairColor + "'>"
		return html;
	}
	this.drawOneHairColorDropDownOLD = function(player){
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

	this.drawOneBloodColorDropDown = function(player){
		var html = "<select id = 'bloodColorID" + player.chatHandle + "' name='bloodColor" +player.chatHandle +"'>"
		for(var i = 0; i< bloodColors.length; i++){
			if(bloodColors[i] == player.bloodColor){
				html += '<option style="background:' + bloodColors[i] + '" selected = "bloodColor" value="' + bloodColors[i] +'">' + bloodColors[i]+'</option>'
			}else{
				html += '<option style="background:' + bloodColors[i] + '"value="' + bloodColors[i] +'">' + bloodColors[i]+'</option>'
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
