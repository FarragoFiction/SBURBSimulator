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
		//console.log("drawing: " + player.title())
		var str = "";
		var divId =  player.id;
		player.chatHandle = "";
		//divId = divId.replace(/\s+/g, '')
		str += "<div class='createdCharacter'>"
		str += "<canvas class = 'createdCharacterCanvas' id='canvas" +divId + "' width='" +400 + "' height="+300 + "'>  </canvas>";
		str += "<div class = 'folderDealy'>"
		str += this.drawTabs(player);
		str += "<div class = 'charOptions'>"
		str += "<div class = 'charOptionsForms'>"
		str += this.drawDropDowns(player);
		str += this.drawCheckBoxes(player);
		str += this.drawTextBoxes(player);
		str += this.drawCanvasSummary(player);
		str += this.drawDataBox(player);
		str += this.drawDeleteButton(player);
		str += this.drawHelpText(player);
		str += "</div>"
		str += "</div>"

		str += "</div>"


		str += "</div>"
		this.div.append(str);

		player.spriteCanvasID = player.id+player.id+"spriteCanvas";
		var canvasHTML = "<br><canvas style='display:none' id='" + player.spriteCanvasID+"' width='" +400 + "' height="+300 + "'>  </canvas>";
		$("#playerSprites").append(canvasHTML)

		player.renderSelf();

		var canvas = document.getElementById("canvas"+ divId);
		//drawSinglePlayer(canvas, player);
		var p1SpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
		drawSpriteFromScratch(p1SpriteBuffer,player)
		//drawBG(p1SpriteBuffer, "#ff9999", "#ff00ff")
		copyTmpCanvasToRealCanvasAtPos(canvas, p1SpriteBuffer,0,0)
		this.wireUpTabs(player);
		this.wireUpPlayerDropDowns(player);
		this.wireUpTextBoxes(player);
		this.wireUpCheckBoxes(player);

	}

	this.drawDropDowns = function(player){
		var str = "<div id = 'dropDowns" + player.id + "' class='optionBox'>";
		str += "<div>" + (this.drawOneClassDropDown(player));
		str += (" of ");
		str+= (this.drawOneAspectDropDown(player)) + "</div>";
		str += "<hr>"
		str += "<span class='formElementLeft'>Hair Type:</span>" + this.drawOneHairDropDown(player);
		str += "<span class='formElementRight'>Hair Color:</span>" + this.drawOneHairColorPicker(player);
		str += "<span class='formElementLeft'>Species:</span>" + this.drawOneSpeciesDropDown(player);
		str += "<span class='formElementRight'>Moon:</span>" + this.drawOneMoonDropDown(player);
		str += "<span class='formElementLeft'>L. Horn:</span>" + this.drawOneLeftHornDropDown(player);
		str += "<span class='formElementRight'>R. Horn:</span>" + this.drawOneRightHornDropDown(player);
		str += "<span class='formElementLeft'>BloodColor:</span>" + this.drawOneBloodColorDropDown(player);
		str += "<span class='formElementRight'>Fav. Num:</span>" + this.drawOneFavoriteNumberDropDown(player);
		str += "</div>"
		return str;
	}

	this.drawTabs = function(player){
		var str = "<div id = 'tabs'"+player.id + " class='optionTabs'>";
		str += "<span id = 'ddTab" +player.id + "'class='optionTab optionTabSelected'> DropDowns</span>"
		str += "<span id = 'cbTab" +player.id + "'class='optionTab'> CheckBoxes</span>"
		str += "<span id = 'tbTab" +player.id + "'class='optionTab'> TextBoxes</span>"
		str += "<span id = 'csTab" +player.id + "'class='optionTab'> Summary</span>"
		str += "<span id = 'dataTab" +player.id + "'class='optionTab'> Data</span>"
		str += "<span id = 'emptyTab" +player.id + "'class='emptyTab'> </span>"
		str += "</div>"
		return str;
	}

	//grim dark, godTier, murderMode, leftMurderMode, dreamSelf, dead, moon, godDestiny
	this.drawCheckBoxes = function(player){
		var str = "<div id = 'checkBoxes"+player.id + "' class='optionBox'>";
		str += '<span class="formElementLeft">GrimDark:</span> <input id="grimDark' + player.id + '" type="checkbox">'
		str += '<span class="formElementRight">IsDreamSelf:</span> <input id="isDreamSelf' + player.id + '" type="checkbox">'
		str += '<span class="formElementLeft">GodDestiny:</span> <input id="godDestiny' + player.id + '" type="checkbox">'
		str += '<span class="formElementRight">GodTier:</span> <input id="godTier' + player.id + '" type="checkbox">'
		str += '<span class="formElementLeft">MurderMode:</span> <input id="murderMode' + player.id + '" type="checkbox">'
		str += '<span class="formElementRight">LeftMurderMode:</span> <input id="leftMurderMode' + player.id + '" type="checkbox">'
		str += '<span class="formElementLeft">Dead:</span> <input id="dead' + player.id + '" type="checkbox">'
		str += '<span class="formElementRight">Robot:</span> <input id="robot' + player.id + '" type="checkbox">'

		str += "</div>"
		return str;
	}

	//includes interest drop downs.
	this.drawTextBoxes = function(player){
		var str = "<div id = 'textBoxes"+player.id + "'' class='optionBox'>";
		str += "<div><span class='formElementLeft'>" + this.drawChatHandleBox(player) + "</span></div>";
		str += this.drawInterests(player);
		str += "</div>"
		return str;
	}

	//draws player a second time, along with canvas summary of player (no quirks, no derived stuff like land, but displays it all as an image.)
	//bonus if i can somehow figure out how to ALSO make it encode the save data, but baby steps.
	this.drawCanvasSummary = function(player){
		var str = "<div id = 'canvasSummary"+player.id + "' class='optionBox'>";
		str += "TODO"
		str += "</div>"
		return str;
	}

	//just an empty div where, when you mouse over a form element it'll helpfully explain what that means. even classpect stuff???
	//not sure how i want to do this. needs to always be visibile. maybe tool tip instead of extra div???
	this.drawHelpText = function(player){
		var str = "<div id = 'helpText" + player.id + "' class ='helpText'>...</div>";

		return str;
	}

	//you monster.  create player button will be not on the player level. upper right corner
	this.drawDeleteButton = function(player){
		var str = "";
		return str;
	}

	//place where you can load data (with load button).
	//any changes you make to the sprite are written here too, and "copy to clipboard" button.
	//maybe also a save button (that downloads it as .txt file)
	this.drawDataBox = function(player){
		var str = "<div id = 'dataBox"+player.id + "' class='optionBox'>";
		str += "TODO"
		str += "</div>"
		return str;
	}

	this.redrawSinglePlayer = function(player){
		  player.renderSelf();
			var divId = "canvas" + player.id;
			divId = divId.replace(/\s+/g, '');
			var canvas =$("#"+divId)[0]
			drawSolidBG(canvas, "#ffffff")
			drawSinglePlayer(canvas, player);
	}

	this.generateHelpText = function(topic,specific){
		if(topic == "Class") return this.generateClassHelp(topic, specific);
		if(topic == "Aspect") return this.generateAspectHelp(topic, specific);
		if(topic == "BloodColor") return this.generateBloodColorHelp(topic, specific);
		if(topic == "Moon") return this.generateMoonHelp(topic, specific);
		if(topic == "FavoriteNumber") return "Favorite number can affect a Player's quirk, as well as determining a troll's god tier Wings.";
		if(topic == "Horns") return "Horns are purely cosmetic."
		if(topic == "chatHandle") return "If left blank, chatHandle will be auto-generated by the sim based on class, aspect, and interests."
		if(topic == "Hair") return "Hair is purely cosmetic."
		if(topic == "grimDark") return "Grim Dark players are more powerful and actively work to crash SBURB/SGRUB."
		if(topic == "murderMode") return "Has done an acrobatic flip into a pile of crazy. Will try to kill other players."
		if(topic == "leftMurderMode") return "Has recovered from an acrobatic flip into a pile of crazy. Still bears the scars."
		if(topic == "godDestiny") return "Strong chance of god tiering upon death, with shenanigans getting their corpse where it needs to go. Not applicable for deaths that happen on Skaia, as no amount of shenanigans is going to rocket their corpse off planet. "
		if(topic == "godTier") return "Starts the game already god tier. Somehow. Hey. It's YOUR decision."
		if(topic == "isDreamSelf") return "Starts the game as a dream self. Somehow. Hey. It's YOUR decision."
		if(topic == "dead") return "You monster. Whatever. The player died before entering the Medium due to suitably dramatic shenanigans. Hopefully someone will be available to corpse smooch them back to life once they get into the Medium."
		if(topic == "robot") return "Robots are obviously superior to fleshy players. "
		if(topic == "Species") return "Trolls are ever so slightly less mentally stable than humans and tend towards FAR more annoying quirks."
		if(topic == "HairColor") return "Hair color is purely cosmetic. Certain hairstyles will have highlights which are mandated to be the Player's favorite color (which is aspect color for humans and blood color for trolls). "
		if(topic == "Interests") return "Interests alter how a player speaks (including their skill at finding topics to rap about), some of the rungs on their echeladder, and their derived ChatHandle."
		return "Help text not found for " + topic + "."
	}

	this.generateMoonHelp = function(topic, specific){
		if(specific == "Prospit") return "Dreamers of Prospit see visions of the inevitable future in the clouds of Skaia. This is not a good thing."
		if(specific == "Derse") return "Dreamers of Derse are constantly bombarded by the whispers of the Horror Terrors. This is not a good thing."
		return "Moon help text not found for " + specific + "."
	}

	//don't forget red = basically human, and heiress = hates other heiresses and triggered.
	this.generateBloodColorHelp = function(topic, specific){
		if(specific == "#ff0000") return "Candy red blood has no specific boost.";
		var str = "The cooler blooded a troll is, the greater their HP and power on entering the medium. Game powers have a way of equalizing things, though. ";
		str += specific + " is associated with a power and hp increase of: " +bloodColorToBoost(specific);
		if(specific == "#99004d") str += ". Heiress blooded trolls will hate other Heiress bloods, as well as being triggered by their presence."
		return str;
	}

	this.generateAspectHelp = function(topic, specific){
		if(specific == "Space") return "Space players are in charge of breeding the frog, and are associated with the low mobility needed to focus exclusively on their own quests. ";
		if(specific == "Time") return "Time players are in charge of timeline management, creating various doomed time clones and provide the ability to 'scratch' a failed session. They are chained to inevitability and as a result are associated with low free will. They know a lot about SBURB/SGRUB, usually through time shenanigans.";
		if(specific == "Breath") return "Breath players are associted with high mobility, and tend to help other players out with their quests, even at the detriment to their own. They are stupidly hard to catch.";
		if(specific == "Doom") return "Doom players are associated with bad luck and low hp. Each Doom player death is according to a vast prophecy and considerably strengthens them, as well as lifting the Doom on their head for a short time.  They are capable of using the dead as a resource. They know a lot about SBURB/SGRUB.";
		if(specific == "Heart") return "Heart players are associated with how a target relates to other players.  They are also in charge of shipping grids.";
		if(specific == "Mind") return "Mind players are associated with high free will. They know a lot about SBURB/SGRUB.";
		if(specific == "Light") return "Light players are associated with good luck, and know a lot about SBURB/SGRUB. They are awfully distracting and flashy in battle.";
		if(specific == "Void") return "Void players are capable of accessing the Void, which allows them narrative freedom, random stats and being difficult to find.";
		if(specific == "Rage") return "Rage players are capable of accessing Madness, which allows them narrative freedom, random stats and the destruction of positive relationships and sanity.";
		if(specific == "Hope") return "Hope players are associated with raw power. If a strong enough Hope player is alive, players will be less likely to waste time flipping their shit.";
		if(specific == "Life") return "Life players are associated with high HP. They are capable of using the dead as a resource.";
		if(specific == "Blood") return "Blood players are associated with how other players relate to a target, in a positive direction as well as sanity. A Blood player is very difficult to murder, being able to insta-calm rampaging players in most cases.";
		return "Aspect help text not found for " + specific + "."
	}

	this.generateClassHelp = function(topic, specific){
		if(specific == "Maid") return "A Maid distributes their associated aspect to the entire party and starts with a lot of it.";
		if(specific == "Mage") return "A Mage increases their own associated aspect and starts with a lot of it. They know a lot about SBURB/SGRUB.";
		if(specific == "Knight") return "A Knight increases their own associated aspect and starts with a lot of it.";
		if(specific == "Rogue") return "A Rogue increases the parties associated aspect, steals it from someone to give to everyone, and starts with a lot it.";
		if(specific == "Sylph") return "A Sylph distributes their associated aspect to the entire party and start with a lot of it. They give an extra boost to players they meet in person.";
		if(specific == "Seer") return "A Seer distributes their associated aspect to the entire party. They start with very little of their aspect and must gain more through experience. They know a lot about SBURB/SGRUB. ";
		if(specific == "Thief") return "A Thief increases their own associated aspect, steals it from others, and starts with very little of it and must steal more.";
		if(specific == "Heir") return "An Heir increases their own associated aspect. They start with very little of their aspect and must inherit it.";
		if(specific == "Bard") return "A Bard distributes the opposite of their associated aspect to the entire party and starts with very little of it. They have an increased effect in person.";
		if(specific == "Prince") return "A Prince increases the opposite of their own associated aspect and starts with a lot of it.";
		if(specific == "Witch") return "A Witch increases their own associated aspect and starts with a lot of it.";
		if(specific == "Page") return "A Page distributes their associated aspect to the entire party. They start with very little of their aspect and must earn it. They can not do quests on their own, but gain power very quickly.";
		return "Class help text not found for " + specific + "."
	}

	this.wireUpCheckBoxes = function(player){
		var grimDark = $("#grimDark"+player.id);
		var isDreamSelf = $("#isDreamSelf"+player.id);
		var godTier = $("#godTier"+player.id);
		var godDestiny = $("#godDestiny"+player.id);
		var murderMode = $("#murderMode"+player.id);
		var leftMurderMode = $("#leftMurderMode"+player.id);
		var dead = $("#dead"+player.id);
		var robot = $("#robot"+player.id);
		grimDark.prop('checked', player.grimDark == 4);
		godTier.prop('checked', player.godTier);
		isDreamSelf.prop('checked', player.isDreamSelf);
		godDestiny.prop('checked', player.godDestiny);
		murderMode.prop('checked', player.murderMode);
		leftMurderMode.prop('checked', player.leftMurderMode);
		dead.prop('checked', player.dead);
		robot.prop('checked', player.robot);

		var helpText = $("#helpText"+player.id);
		var that = this;

		grimDark.change(function() {
			if(grimDark.prop('checked')){
				player.grimDark = 4;
			}else{
				player.grimDark = 0;
			}
			that.redrawSinglePlayer(player);
			helpText.html(that.generateHelpText("grimDark",player.class_name));
		});

		isDreamSelf.change(function() {
			player.isDreamSelf = isDreamSelf.prop('checked')
			that.redrawSinglePlayer(player);
			helpText.html(that.generateHelpText("isDreamSelf",player.class_name));
		});

		godTier.change(function() {
			player.godTier = godTier.prop('checked')
			that.redrawSinglePlayer(player);
			helpText.html(that.generateHelpText("godTier",player.class_name));
		});

		godDestiny.change(function() {
			player.godDestiny = godDestiny.prop('checked')
			that.redrawSinglePlayer(player);
			helpText.html(that.generateHelpText("godDestiny",player.class_name));
		});

		murderMode.change(function() {
			player.murderMode = murderMode.prop('checked')
			that.redrawSinglePlayer(player);
			helpText.html(that.generateHelpText("murderMode",player.class_name));
		});

		leftMurderMode.change(function() {
			player.leftMurderMode = leftMurderMode.prop('checked')
			that.redrawSinglePlayer(player);
			helpText.html(that.generateHelpText("leftMurderMode",player.class_name));
		});

		dead.change(function() {
			player.dead = dead.prop('checked')
			that.redrawSinglePlayer(player);
			helpText.html(that.generateHelpText("dead",player.class_name));
		});

		robot.change(function() {
			player.robot = robot.prop('checked')
			that.redrawSinglePlayer(player);
			helpText.html(that.generateHelpText("robot",player.class_name));
		});

	}

	this.wireUpPlayerDropDowns = function(player){
			var c2 =  $("#classNameID" +player.id) ;
			var a2 =  $("#aspectID" +player.id) ;
			var hairDiv  =  $("#hairTypeID" +player.id) ;
			var hairColorDiv  =  $("#hairColorID" +player.id) ;
			var speciesDiv  =  $("#speciesID" +player.id) ;
			var leftHornDiv  =  $("#leftHornID" +player.id) ;
			var rightHornDiv  =  $("#rightHornID" +player.id) ;
			var bloodDiv  =  $("#bloodColorID" +player.id) ;
			var favoriteNumberDiv  =  $("#favoriteNumberID" +player.id) ;
			var moonDiv = $("#moonID" +player.id);
			var helpText = $("#helpText"+player.id);


			var that = this;
			c2.change(function() {
					var classDropDown = $('[name="className' +player.id +'"] option:selected') //need to get what is selected inside the .change, otheriise is always the same
					player.class_name = classDropDown.val();
					that.redrawSinglePlayer(player);
					helpText.html(that.generateHelpText("Class",player.class_name));

			});

			moonDiv.change(function() {
					var moonDropDown = $('[name="moon' +player.id +'"] option:selected')
					player.moon = moonDropDown.val();
					that.redrawSinglePlayer(player);
					moonDiv.css("background-color", moonToColor(player.moon));
					helpText.html(that.generateHelpText("Moon",player.moon));

			});

			favoriteNumberDiv.change(function() {
					var numberDropDown = $('[name="favoriteNumber' +player.id +'"] option:selected')
					player.quirk.favoriteNumber = numberDropDown.val();
					that.redrawSinglePlayer(player);
					helpText.html(that.generateHelpText("FavoriteNumber",player.quirk.favoriteNumber));
			});


			a2.change(function() {
					var aspectDropDown = $('[name="aspect' +player.id +'"] option:selected')
					player.aspect = aspectDropDown.val();
					that.redrawSinglePlayer(player);
					helpText.html(that.generateHelpText("Aspect",player.aspect));
			});

			hairDiv.change(function() {
				  var aspectDropDown = $('[name="hair' +player.id +'"] option:selected')
					player.hair = aspectDropDown.val();
					that.redrawSinglePlayer(player);
					helpText.html(that.generateHelpText("Hair",player.class_name));
			});

			hairColorDiv.change(function() {
					//var aspectDropDown = $('[name="hairColor' +player.id +'"] option:selected')
					player.hairColor = hairColorDiv.val();
					that.redrawSinglePlayer(player);
					helpText.html(that.generateHelpText("HairColor",player.class_name));
			});

			leftHornDiv.change(function() {
					var aspectDropDown = $('[name="leftHorn' +player.id +'"] option:selected')
					player.leftHorn = aspectDropDown.val();
					that.redrawSinglePlayer(player);
					helpText.html(that.generateHelpText("Horns",player.class_name));
			});

			rightHornDiv.change(function() {
					var aspectDropDown = $('[name="rightHorn' +player.id +'"] option:selected')
					player.rightHorn = aspectDropDown.val();
					that.redrawSinglePlayer(player);
					helpText.html(that.generateHelpText("Horns",player.class_name));
			});

			bloodDiv.change(function() {
					var aspectDropDown = $('[name="bloodColor' +player.id +'"] option:selected')
					player.bloodColor = aspectDropDown.val();
					bloodDiv.css("background-color", player.bloodColor);
					bloodDiv.css("color", "black");
					that.redrawSinglePlayer(player);
					helpText.html(that.generateHelpText("BloodColor",player.bloodColor));
			});

			speciesDiv.change(function() {
					var aspectDropDown = $('[name="species' +player.id +'"] option:selected')
					var str = aspectDropDown.val();
					if(str == "Troll"){
						player.isTroll = true;
					}else{
						player.isTroll = false;
					}
					that.redrawSinglePlayer(player);
					helpText.html(that.generateHelpText("Species",player.isTroll));
			});
	}

	//each tab on click changes it's class to selected, and all the other tabs to unselected
		//and similar changes the display value of the form contents.
		this.wireUpTabs = function(player){
			var ddTab = $("#ddTab" +player.id );
			var cbTab =$ ("#cbTab" +player.id );
			var tbTab =$ ("#tbTab" +player.id );
			var csTab =$ ("#csTab" +player.id );
			var dataTab =$ ("#dataTab" +player.id );

			var dropDowns = $("#dropDowns" + player.id);
			var checkBoxes = $("#checkBoxes" + player.id);
			var textBoxes = $("#textBoxes" + player.id);
			var canvasSummary = $("#canvasSummary" + player.id);
			var dataBox = $("#dataBox" + player.id);
			var helpText = $("#helpText"+player.id);
			var that = this;
			ddTab.click(function(){
				that.selectTab(ddTab, [cbTab, tbTab, csTab, dataTab]);
				that.displayDiv(dropDowns, [checkBoxes, textBoxes, canvasSummary, dataBox])
				helpText.html("...")
			});

			tbTab.click(function(){
				that.selectTab(tbTab, [ddTab,cbTab, csTab, dataTab]);
				that.displayDiv(textBoxes, [checkBoxes, dropDowns, canvasSummary, dataBox])
				helpText.html("...")
			});

			csTab.click(function(){
				that.selectTab(csTab, [ddTab,cbTab, tbTab, dataTab]);
				that.displayDiv(canvasSummary, [checkBoxes, textBoxes, dropDowns, dataBox])
				helpText.html("...")
			});

			cbTab.click(function(){
				that.selectTab(cbTab, [ddTab, tbTab, csTab, dataTab]);
				that.displayDiv(checkBoxes, [dropDowns, textBoxes, canvasSummary, dataBox])
				helpText.html("...")
			});

			dataTab.click(function(){
				that.selectTab(dataTab, [ddTab, cbTab, tbTab, csTab]);
				that.displayDiv(dataBox, [checkBoxes, textBoxes, canvasSummary, dropDowns])
				helpText.html("...")
			});

			this.selectTab(ddTab, [cbTab, tbTab, csTab, dataTab])
			that.displayDiv(dropDowns, [checkBoxes, textBoxes, canvasSummary, dataBox])
		}

		this.displayDiv = function(displayed, undisplayed){
			displayed.show();
			for(var i = 0; i<undisplayed.length; i++){
				undisplayed[i].hide();
			}
		}

		this.selectTab = function(selected, unselected){
			selected.addClass("optionTabSelected")
			for(var i = 0; i<unselected.length; i++){
				unselected[i].removeClass("optionTabSelected");
			}
		}



	this.wireUpTextBoxes = function(player){
		//first, choosing interest category should change the contents of interestDrop1 or 2 (but NOT any value in the player or the text box.)
		var interestCategory1Dom =  $("#interestCategory1" +player.id);
		var interestCategory2Dom =  $("#interestCategory2" +player.id);
		var interest1DropDom =  $("#interestDrop1" +player.id);
		var interest2DropDom =  $("#interestDrop2" +player.id);
		var interest1TextDom =  $("#interest1" +player.id); //don't wire these up. instead, get value on url creation.
		var interest2TextDom =  $("#interest2" +player.id);
		var chatHandle = $("#chatHandle"+player.id);

		var that = this;
		var helpText = $("#helpText"+player.id);

		chatHandle.click(function() {
					helpText.html(that.generateHelpText("chatHandle",player.class_name));
		});

		interestCategory1Dom.change(function() {
					var icDropDown = $('[name="interestCategory1' +player.id +'"] option:selected')
					interest1DropDom.html(that.drawInterestDropDown(icDropDown.val(), 1, player))
					helpText.html(that.generateHelpText("Interests",player.class_name));

		});

		interestCategory2Dom.change(function() {
					var icDropDown = $('[name="interestCategory2' +player.id +'"] option:selected')
					interest2DropDom.html(that.drawInterestDropDown(icDropDown.val(), 2, player))
					helpText.html(that.generateHelpText("Interests",player.class_name));
		});

		interest1DropDom.change(function() {
					var icDropDown = $('[name="interestDrop1' +player.id +'"] option:selected')
					interest1TextDom.val(icDropDown.val());
					helpText.html(that.generateHelpText("Interests",player.class_name));
		});

		interest2DropDom.change(function() {
					var icDropDown = $('[name="interestDrop2' +player.id +'"] option:selected')
					interest2TextDom.val(icDropDown.val());
					helpText.html(that.generateHelpText("Interests",player.class_name));
		});

	}

	//(1,60)
	this.drawOneHairDropDown = function(player){
		var html = "<select id = 'hairTypeID" + player.id + "' name='hair" +player.id +"'>";
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
		str += " <div class = 'formElementLeft'>Interest1:</div>"
		str += "<span class='formElementLeft'>Category:</span>" + this.drawInterestCategoryDropDown(1,player);
		str += "<span class='formElementLeft'>Existing:</span>" +this.drawInterestDropDown(player.interest1Category, 1,player);
		str += "<span class='formElementRight'>Write In:</span>" + this.drawInterestTextBox(1,player);
		str += "<div class = 'formElementLeft'>Interest2:</div>"
		str += "<span class='formElementLeft'>Category:</span>" +this.drawInterestCategoryDropDown(2,player);
		str += "<span class='formElementLeft'>Existing:</span>" +this.drawInterestDropDown(player.interest2Category, 2,player);
		str += "<span class='formElementRight'>Write In:</span>" + this.drawInterestTextBox(2,player);
		str += "</div>"
		return str;
	}

	this.drawChatHandleBox = function(player){
		var html = "Chat Handle: <input type='text' id = 'chatHandle" + player.id + "' name='interest" + player.id +"' + value=''> </input>"
		return html;
	}

	this.drawInterestTextBox = function(num,player){
		var interestToCheck = player.interest1;
		if(num == 2) interestToCheck = player.interest2;
		var html = "<input type='text' id = 'interest" + num+ player.id + "' name='interest" +num+player.id +"' + value='" + interestToCheck +"'> </input>"
		return html;
	}

	this.drawInterestDropDown = function(category, num, player){
		var html = "<select id = 'interestDrop" + num+ player.id + "' name='interestDrop" +num+player.id +"'>";
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
		var html = "<select id = 'interestCategory" + num+ player.id + "' name='interestCategory" +num+player.id +"'>";
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
		var html = "<select id = 'favoriteNumberID" + player.id + "' name='favoriteNumber" +player.id +"'>";
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
		var html = "<select id = 'leftHornID" + player.id + "' name='leftHorn" +player.id +"'>";
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
		var html = "<select id = 'rightHornID" + player.id + "' name='rightHorn" +player.id +"'>";
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
		var html = "<select id = 'classNameID" + player.id + "' name='className" +player.id +"'>";
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

	this.drawOneMoonDropDown = function(player){
		var html = "<select style = 'background: " + moonToColor(player.moon) + "' id = 'moonID" + player.id + "' name='moon" +player.id +"'>";
		for(var i = 0; i< moons.length; i++){
			if(moons[i] == player.moon){
				html += '<option style="background:' + moonToColor(moons[i]) + '" selected = "moon" value="' + moons[i] +'">' + moons[i]+'</option>'
			}else{
				html += '<option style="background:' + moonToColor(moons[i]) + '" value="' + moons[i] +'">' + moons[i]+'</option>'
			}
		}
		html += '</select> '
		return html;

	}

	this.drawOneSpeciesDropDown = function(player){
		var species = ["Human", "Troll"]
		var html = "<select id = 'speciesID" + player.id + "' name='species" +player.id +"'>";
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
		var id = "hairColorID" + player.id
		var html = "<input id = '" + id + "' type='color' name='favcolor' value='" + player.hairColor + "'>"
		return html;
	}
	this.drawOneHairColorDropDownOLD = function(player){
		var html = "<select id = 'hairColorID" + player.id + "' name='hairColor" +player.id +"'>";
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
		var html = "<select style='color: black; background:" + player.bloodColor + "' id = 'bloodColorID" + player.id + "' name='bloodColor" +player.id +"'>"
		for(var i = 0; i< bloodColors.length; i++){
			if(bloodColors[i] == player.bloodColor){
				html += '<option style="color: black; background:' + bloodColors[i] + '" selected = "bloodColor" value="' + bloodColors[i] +'">' + bloodColors[i]+'</option>'
			}else{
				html += '<option style="color: black; background:' + bloodColors[i] + '"value="' + bloodColors[i] +'">' + bloodColors[i]+'</option>'
			}
		}
		html += '</select>'
		return html;
	}





	this.drawOneAspectDropDown = function(player){
		available_aspects = nonrequired_aspects.slice(0); //required_aspects
		available_aspects = available_aspects.concat(required_aspects.slice(0));
		var html = "<select class = 'selectDiv' id = 'aspectID" + player.id + "' name='aspect" +player.id +"'>";
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
