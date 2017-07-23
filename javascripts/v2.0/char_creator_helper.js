//need to render all players
function CharacterCreatorHelper(players){
	this.div = $("#character_creator");
	this.players = players;
	this.player_index = 0; //how i draw 12 players at a time.
	//have css for each sprite template.  sprite template is 400 x 300, fit 3 on a line?
	//max of 4 lines?

	this.drawAllPlayers = function(){
		bloodColors.push("#ff0000") //for humans
		for(var i = 0; i<this.players.length; i++){
			this.drawSinglePlayer(this.players[i]);
		}
	}

	this.draw12PlayerSummaries = function(){
		var start = this.player_index
		var num_at_a_time= 12;
		for(var i = start; i<start+num_at_a_time; i++){

			if(this.players.length > i){
				//console.log("i is: " + i)
				this.drawSinglePlayerSummary(this.players[i]);
				this.player_index ++; //okay to mod this in the loop because only initial i value relies on it.
			}else{
				//no more players.
				$("#draw12Button").html("No More Players");
				$("#draw12Button").prop('disabled', true)();
			}
		}
	}

	this.drawSinglePlayerSummary = function(player){
		//console.log("drawing: " + player.title())
		var str = "<div class='standAloneSummary' id='createdCharacter"+ player.id + "'>";
		var divId =  player.id;
		str += this.drawCanvasSummary(player);
		//this.drawDataBoxNoButtons(player)
		str += "</div><div class = 'standAloneSummary'>" + this.drawDataBoxNoButtons(player) + "</div>";
		this.div.append(str);
		this.createSummaryOnCanvas(player);
		$(".optionBox").show(); //unlike char creator, always show
		this.wireUpDataBox(player);
	}

	this.drawSinglePlayer = function(player){
		//console.log("drawing: " + player.title())
		var str = "";
		var divId =  player.id;
		if(curSessionGlobalVar.session_id != 612 && curSessionGlobalVar.session_id != 613  && curSessionGlobalVar.session_id != 413 && curSessionGlobalVar.session_id != 1025 &&  curSessionGlobalVar.session_id != 111111)player.chatHandle = "";
		//divId = divId.replace(/\s+/g, '')
		str += "<div class='createdCharacter' id='createdCharacter"+ player.id + "'>"
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
		this.createSummaryOnCanvas(player);
		this.wireUpDataBox(player);
		this.syncPlayerToFields(player);
	}

	this.syncPlayerToFields = function(player){
		this.syncPlayerToDropDowns(player);
		this.syncPlayerToCheckBoxes(player);
		this.syncPlayerToTextBoxes(player);
	}

	this.syncPlayerToDropDowns= function(player){
		//TODO is setting the val enough for a drop down???  what if it doesn't match the thing?
		$("#classNameID" +player.id).val(player.class_name);
		$("#aspectID" +player.id).val(player.aspect);
		$("#hairTypeID" +player.id).val(player.hair);
		$("#hairColorID" +player.id).val(player.hairColor);
		var troll = "Human"
		if(player.isTroll) troll = "Troll"
		$("#speciesID" +player.id).val(troll);
		$("#leftHornID" +player.id).val(player.leftHorn);
		$("#rightHornID" +player.id).val(player.rightHorn);
		$("#bloodColorID" +player.id).val(player.bloodColor);
		$("#bloodColorID" +player.id).css("background-color", player.bloodColor)
		$("#favoriteNumberID" +player.id).val(player.quirk.favoriteNumber);
		$("#moonID" +player.id).val(player.moon);
		$("#moonID" +player.id).css("background-color", moonToColor(player.moon));
	}

	this.syncPlayerToCheckBoxes= function(player){
		//.prop('checked', true);
		$("#grimDark"+player.id).prop('checked',player.grimDark);
	  $("#isDreamSelf"+player.id).prop('checked',player.isDreamSelf);
		$("#godTier"+player.id).prop('checked',player.godTier);
		$("#godDestiny"+player.id).prop('checked',player.godDestiny);
		$("#murderMode"+player.id).prop('checked',player.murderMode);
		$("#leftMurderMode"+player.id).prop('checked',player.leftMurderMode);
		$("#dead"+player.id).prop('checked',player.dead);
		$("#robot"+player.id).prop('checked',player.robot);
	}

	this.syncPlayerToTextBoxes= function(player){
		$("#interestCategory1" +player.id).val(player.interest1Category);
		$("#interestCategory2" +player.id).val(player.interest2Category);
		$("#interest1" +player.id).val(player.interest1);
		$("#interest2" +player.id).val(player.interest2);
		$("#chatHandle"+player.id).val(player.chatHandle);
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
		str += "<span id = 'deleteTab" +player.id + "'class='deleteTab'> X </span>"
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
		str += this.drawChatHandleBox(player);
		str += this.drawInterests(player);
		str += "</div>"
		return str;
	}

	//draws player a second time, along with canvas summary of player (no quirks, no derived stuff like land, but displays it all as an image.)
	//bonus if i can somehow figure out how to ALSO make it encode the save data, but baby steps.
	this.drawCanvasSummary = function(player){
		var str = "<div id = 'canvasSummary"+player.id + "' class='optionBox'>";
		var height = 300;
		var width = 600;
		str += "<canvas id='canvasSummarycanvas" + player.id +"' width='" +width + "' height="+height + "'>  </canvas>"
		str += "</div>"
		return str;
	}

	this.createSummaryOnCanvas = function(player){
		var canvas = document.getElementById("canvasSummarycanvas"+  player.id);
		var ctx = canvas.getContext("2d");
		var pSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
		ctx.clearRect(0, 0, 600, 300)
		drawSpriteFromScratch(pSpriteBuffer, player);
		copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,-30,0)
		var space_between_lines = 25;
		var left_margin = 350;
		var line_height = 350;
		var start = 30;
		var current = 30;
		//title
	    ctx.font = "30px Times New Roman"
		ctx.fillStyle = getColorFromAspect(player.aspect)
		ctx.fillText(player.titleBasic(),left_margin,current);

		//interests
		ctx.font = "18px Times New Roman"
		var i = 3;
		ctx.fillStyle = player.getChatFontColor();
		if(player.chatHandle != "") ctx.fillText("(" + player.chatHandle + ")",left_margin,current + space_between_lines);
		ctx.fillStyle = "#000000"
		ctx.fillText("Interest1: " + player.interest1,left_margin,current + space_between_lines*i++); //i++ returns the value of i before you ++ed
		ctx.fillText("Interest2: " + player.interest2,left_margin,current + space_between_lines*i++);
		ctx.fillText("BloodColor: ",left_margin,current + space_between_lines*i++);
		ctx.fillStyle =  player.bloodColor;
		ctx.fillRect(left_margin + 100, current+space_between_lines*(i-1) -18, 18,18);
		ctx.fillStyle = "#000000"
		ctx.fillText("Moon: " + player.moon,left_margin,current + space_between_lines*i++);
		var destiny = "Nothing."
		if(player.godDestiny) destiny = "God."
		ctx.fillText("Destiny: " + destiny,left_margin,current + space_between_lines*i++);

		//ctx.fillText("Guardian: " + player.lusus,left_margin,current + space_between_lines*4);

		//ctx.fillText("Land: " + player.land,left_margin,current + space_between_lines*5);



	}

	//just an empty div where, when you mouse over a form element it'll helpfully explain what that means. even classpect stuff???
	//not sure how i want to do this. needs to always be visibile. maybe tool tip instead of extra div???
	this.drawHelpText = function(player){
		var str = "<div id = 'helpText" + player.id + "' class ='helpText'>...</div>";

		return str;
	}


	this.drawDataBoxNoButtons = function(player){
		var str = "<div id = 'dataBox"+player.id + "'>";
		str += "<button class = 'charCreatorButton' id = 'copyButton" + player.id + "'> Copy To ClipBoard</button>  </div>"
		str += "<textarea class = 'dataInputSmall' id='dataBoxDiv"+player.id + "'> </textarea>";
		str += "</div>"
		return str;
	}


	//place where you can load data (with load button).
	//any changes you make to the sprite are written here too, and "copy to clipboard" button.
	//maybe also a save button (that downloads it as .txt file)
	this.drawDataBox = function(player){
		var str = "<div id = 'dataBox"+player.id + "' class='optionBox'>";
		str += "<textarea class = 'dataInput' id='dataBoxDiv"+player.id + "'> </textarea>";
		str += "<div><button class = 'charCreatorButton' id = 'loadButton" + player.id + "'>Load From Text</button>"
		str += "<button class = 'charCreatorButton' id = 'copyButton" + player.id + "'> Copy To ClipBoard</button>  </div>"
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
			this.createSummaryOnCanvas(player);
			this.writePlayerToDataBox(player);
			this.syncPlayerToFields(player);
	}

	//this game is so esey. i mean, all you do is hit the refresh button. thats it! how is this an RPG anyway? you cant contrail anything but what it says on the screen!
	this.generateHelpText = function(topic,specific){
		if(topic == "Class") return this.generateClassHelp(topic, specific);
		if(topic == "Aspect") return this.generateAspectHelp(topic, specific);
		if(topic == "BloodColor") return this.generateBloodColorHelp(topic, specific);
		if(topic == "Moon") return this.generateMoonHelp(topic, specific);
		if(topic == "FavoriteNumber") return "Favorite number can affect a Player's quirk, as well as determining a troll's god tier Wings.";
		if(topic == "Horns") return "Horns are purely cosmetic. See gallery of horns <a target = '_blank' href ='image_browser.html?horns=true'>here</a>"
		if(topic == "chatHandle") return "If left blank, chatHandle will be auto-generated by the sim based on class, aspect, and interests."
		if(topic == "Hair") return "Hair is purely cosmetic. See gallery of hair <a target = '_blank' href ='image_browser.html?hair=true'>here</a>"
		if(topic == "grimDark") return "Grim Dark players are more powerful and actively work to crash SBURB/SGRUB."
		if(topic == "murderMode") return "Has done an acrobatic flip into a pile of crazy. Will try to kill other players."
		if(topic == "leftMurderMode") return "Has recovered from an acrobatic flip into a pile of crazy. Still bears the scars."
		if(topic == "godDestiny") return "Strong chance of god tiering upon death, with shenanigans getting their corpse where it needs to go. Not applicable for deaths that happen on Skaia, as no amount of shenanigans is going to rocket their corpse off planet. "
		if(topic == "godTier") return "Starts the game already god tier. Somehow. Hey. It's YOUR decision. Don't blame me if SBURB behaves weird, you hacker."
		if(topic == "isDreamSelf") return "Starts the game as a dream self. Somehow. Hey. It's YOUR decision. Don't blame me if SBURB behaves weird, you hacker."
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
		if(specific == "#99004d") str += ". Heiress blooded trolls will hate other Heiress bloods, as well as losing making them more likely to flip out. Biological imperatives for murder suck, yo."
		return str;
	}

	this.generateAspectHelp = function(topic, specific){
		if(specific == "Space") return "Space players are in charge of breeding the frog, and are associated with the low mobility needed to focus exclusively on their own quests, good alchemy ability, and good health. ";
		if(specific == "Time") return "Time players are in charge of timeline management, creating various doomed time clones and provide the ability to 'scratch' a failed session. They are chained to inevitability and as a result are associated with low free will offset by high minLuck and mobility . They know a lot about SBURB/SGRUB, usually through time shenanigans.";
		if(specific == "Breath") return "Breath players are associted with high mobility, and tend to help other players out with their quests, even at the detriment to their own. They are very sane, but tend to have difficulty staying in one place long enough to form social connections. They are stupidly hard to catch.";
		if(specific == "Doom") return "Doom players are associated with bad luck and low hp. Each Doom player death is according to a vast prophecy and considerably strengthens them, as well as lifting the Doom on their head for a short time. They excel at alchemy, and have limited success with freeWill.  They are capable of using the dead as a resource. They know a lot about SBURB/SGRUB.";
		if(specific == "Heart") return "Heart players are associated with their INTERESTS. A Heart player interested in Romance, for example, will have a high relationship stat, while one interested in Athletics will have high MANGRIT.  They are also in charge of concupiscient shipping grids.";
		if(specific == "Mind") return "Mind players are associated with high free will. Luck DO3SN'T R34LLY M4TTER, so they have both good 'minLuck' and poor 'maxLuck'. They have difficulty forming bonds with other players. They know a lot about SBURB/SGRUB.";
		if(specific == "Light") return "Light players are associated with good luck, have a lot of willpower,  and know a lot about SBURB/SGRUB. They have less hp than other players, and tend to have more fragile psyches. They are awfully distracting and flashy in battle.";
		if(specific == "Void") return "Void players are capable of accessing the Void, which allows them narrative freedom, random stats and being difficult to find. They have a trait they are SO GOOD or SO BAD at when they enter the medium and increase it over time. They tend to have similarly random flaws, as well as bad luck.";
		if(specific == "Rage") return "Rage players are capable of accessing Madness, which allows them narrative freedom, raw MANGRIT and speed, and the destruction of positive relationships and sanity.";
		if(specific == "Hope") return "Hope players are associated with sanity and good luck. If a strong enough Hope player is alive, players will be less likely to waste time flipping their shit. Occasionally, a Hope player will flip their shit and use an insanely powerful attack rather than a regular fraymotif. Hope players have random flaws.";
		if(specific == "Life") return "Life players are associated with high HP and good MANGRIT. They are capable of using the dead as a resource, but have trouble with Alchemy.";
		if(specific == "Blood") return "Blood players are associated with high positive relationships, as well as sanity. They are not very lucky. A Blood player is very difficult to murder, being able to insta-calm rampaging players in most cases. They are also in charge of concillitory shipping grids.";
		return "Aspect help text not found for " + specific + "."
	}

	this.generateClassHelp = function(topic, specific){
		if(specific == "Maid") return "A Maid distributes their associated aspect to the entire party and starts with a lot of it. They give a boost to their Aspect, embracing even the bad parts.";
		if(specific == "Mage") return "A Mage increases their own associated aspect and starts with a lot of it. They know a lot about SBURB/SGRUB. They reduce the negative parts of their Aspect through their wisdom.";
		if(specific == "Knight") return "A Knight increases their own associated aspect and starts with a lot of it. They give a  boost to the positive parts of their Aspect, while protecting themselves from the negative parts.  Knights are charged with protecting the Space player while they breed frogs.";
		if(specific == "Rogue") return "A Rogue increases the parties associated aspect, steals it from someone to give to everyone, and starts with a lot it. They are affected by their Aspect less than normal, even the good parts.";
		if(specific == "Sylph") return "A Sylph distributes their associated aspect to the entire party and start with a lot of it. They give an extra boost to players they meet in person.  They feel less of the positive effects of their Aspect, but can twist weakness into strength.";
		if(specific == "Seer") return "A Seer distributes their associated aspect to the entire party. They start with very little of their aspect and must gain more through experience. They know a lot about SBURB/SGRUB. They get a great deal of the positive of their aspect, but even more of the negative. ";
		if(specific == "Thief") return "A Thief increases their own associated aspect, steals it from others, and starts with very little of it and must steal more.  They are affected by their Aspect less than normal, even the good parts.";
		if(specific == "Heir") return "An Heir increases their own associated aspect. They start with very little of their aspect and must inherit it. They give a 1.5 boost to their Aspect, inheriting even the bad parts.";
		if(specific == "Bard") return "A Bard distributes their inverted Aspect to the entire party and starts with very little of it. They have an increased effect in person. They invert their aspect, causing its strengths to become weaknesses while using what should be weaknesses as tools of destruction.";
		if(specific == "Prince") return "A Prince increase their inverted aspect in themselves and starts with a lot of it. They invert their aspect, causing its strengths to become weaknesses while using what should be weaknesses as tools of destruction. They destroy their Aspect faster in themselves around others.";
		if(specific == "Witch") return "A Witch increases their own associated aspect and starts with a lot of it. They are stronger around others. They feel less of the positive effects of their Aspect, but can twist weakness into strength.";
		if(specific == "Page") return "A Page distributes their associated aspect to the entire party. They start with very little of their aspect and must earn it. They can not do quests on their own, but gain power very quickly. They give a  boost to the positive parts of their Aspect, while protecting others from the negative parts";
		if(specific == "Waste") return "Wastes gain no benefits or detriments related to their Aspect. They are associated with extreme highs and lows, either entirely avoiding their aspect or causing great destruction with it. They are assholes who won't stop hacking my damn code.";
		if(specific == "Scribe") return "A Scribe distributes their associated aspect to the entire party. They start with very little of their aspect and must gain more through experience. They know a lot about SBURB/SGRUB. They get a great deal of the positive of their aspect, but even more of the negative. ";
        if(specific == "Sage") return "A Sage increases their own associated aspect and starts with a lot of it. They know a lot about SBURB/SGRUB. They reduce the negative parts of their Aspect through their wisdom.";
        if(specific == "Scout") return "A Scout increases their own associated aspect and starts with very little of it. They give a  boost to the positive parts of their Aspect, while reducing the damage from the negative parts. They know how to navigate their Aspect to avoid the pitfalls.";


		return "Class help text not found for " + specific + "."
	}

	//redo text every time I render player, so have that separate
	this.wireUpDataBox = function(player){
		this.writePlayerToDataBox(player);
		var copyButton = $("#copyButton" + player.id)
		var loadButton = $("#loadButton" + player.id)
		var that = this;
		copyButton.click(function() {
			var dataBox = document.getElementById("dataBoxDiv"+player.id);
			dataBox.select();
			document.execCommand('copy');
		});

		loadButton.click(function() {
			var dataBox = $("#dataBoxDiv"+player.id);
			var bs = "?" + dataBox.val(); //need "?" so i can parse as url
			console.log("bs is: " + bs);
			var b = (getParameterByName("b", bs)) //this will come to you already decoded, if you decode again it MOSTLY is fine, but mages of heart get corrupted because they are '%'
			var s = getParameterByName("s", bs)
			var x = (getParameterByName("x", bs))
			console.log("b: " + b);
			console.log("s: " + s);
			console.log("x: " + x);

			var players = dataBytesAndStringsToPlayers(b, s,x) //technically an array of one players.
			console.log("Player class name: " + players[0].class_name);
			player.copyFromPlayer(players[0]);
			that.redrawSinglePlayer(player);
			//should have had wireUp methods to the fields to begin with. looks like I gotta pay for pastJR's mistakes.
		});

		//and two buttons, load and copy.
	}

	this.writePlayerToDataBox = function(player){
		var dataBox = $("#dataBoxDiv"+player.id);
		dataBox.val(player.toOCDataString());

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
					player.quirk.favoriteNumber = parseInt(numberDropDown.val());
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
			var deleteTab = $("#deleteTab"+player.id);

			var dropDowns = $("#dropDowns" + player.id);
			var checkBoxes = $("#checkBoxes" + player.id);
			var textBoxes = $("#textBoxes" + player.id);
			var canvasSummary = $("#canvasSummary" + player.id);
			var dataBox = $("#dataBox" + player.id);
			var helpText = $("#helpText"+player.id);
			var that = this;

			deleteTab.click(function(){
				var monster = confirm("Delete player? (You monster)")
				if(monster){
					$("#createdCharacter"+player.id).hide();
					curSessionGlobalVar.players.removeFromArray(player);
				}

			})
			ddTab.click(function(){
				that.selectTab(ddTab, [cbTab, tbTab, csTab, dataTab]);
				that.displayDiv(dropDowns, [checkBoxes, textBoxes, canvasSummary, dataBox])
				helpText.html("...")
				helpText.show();
			});

			tbTab.click(function(){
				that.selectTab(tbTab, [ddTab,cbTab, csTab, dataTab]);
				that.displayDiv(textBoxes, [checkBoxes, dropDowns, canvasSummary, dataBox])
				helpText.html("...")
				helpText.show();
			});

			csTab.click(function(){
				that.selectTab(csTab, [ddTab,cbTab, tbTab, dataTab]);
				that.displayDiv(canvasSummary, [checkBoxes, textBoxes, dropDowns, dataBox])
				helpText.html("...")
				helpText.hide();
			});

			cbTab.click(function(){
				that.selectTab(cbTab, [ddTab, tbTab, csTab, dataTab]);
				that.displayDiv(checkBoxes, [dropDowns, textBoxes, canvasSummary, dataBox])
				helpText.html("...")
				helpText.show();
			});

			dataTab.click(function(){
				that.selectTab(dataTab, [ddTab, cbTab, tbTab, csTab]);
				that.displayDiv(dataBox, [checkBoxes, textBoxes, canvasSummary, dropDowns])
				helpText.html("You can copy your player's value from this box, or override it by pasting another players value in and clicking 'Load'.")
				helpText.show();
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

		interest1TextDom.change(function(){
			player.interest1 = interest1TextDom.val();
			that.redrawSinglePlayer(player);
		})

		interest2TextDom.change(function(){
			player.interest2 = interest2TextDom.val();
			that.redrawSinglePlayer(player);
		})

		chatHandle.click(function() {
					helpText.html(that.generateHelpText("chatHandle",player.class_name));
		});

		chatHandle.change(function(){
			player.chatHandle = chatHandle.val();
			that.redrawSinglePlayer(player);
		})


		interestCategory1Dom.change(function() {
					var icDropDown = $('[name="interestCategory1' +player.id +'"] option:selected')
					interest1DropDom.html(that.drawInterestDropDown(icDropDown.val(), 1, player))
					helpText.html(that.generateHelpText("Interests",player.class_name));
					player.interest1Category = icDropDown.val();
		});

		interestCategory2Dom.change(function() {
					var icDropDown = $('[name="interestCategory2' +player.id +'"] option:selected')
					interest2DropDom.html(that.drawInterestDropDown(icDropDown.val(), 2, player))
					helpText.html(that.generateHelpText("Interests",player.class_name));
					player.interest2Category = icDropDown.val();
		});

		interest1DropDom.change(function() {
					var icDropDown = $('[name="interestDrop1' +player.id +'"] option:selected')
					interest1TextDom.val(icDropDown.val());
					helpText.html(that.generateHelpText("Interests",player.class_name));
					player.interest1 = icDropDown.val()
					that.redrawSinglePlayer(player);
		});

		interest2DropDom.change(function() {
					var icDropDown = $('[name="interestDrop2' +player.id +'"] option:selected')
					interest2TextDom.val(icDropDown.val());
					helpText.html(that.generateHelpText("Interests",player.class_name));
					player.interest2 = icDropDown.val()
					that.redrawSinglePlayer(player);
		});

	}

	//(1,60)
	this.drawOneHairDropDown = function(player){
		var html = "<select id = 'hairTypeID" + player.id + "' name='hair" +player.id +"'>";
		for(var i = 1; i<= player.maxHairNumber; i++){
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
		str += " <div class = 'formSection'><b>Interest1</b>:</div><div class = 'formSection'>Category: " + this.drawInterestCategoryDropDown(1,player);
		str += " Existing: " +this.drawInterestDropDown(player.interest1Category, 1,player);
		str += " Write In: " + this.drawInterestTextBox(1,player) +"</div>";
		str += "<div class = 'formSection'><b>Interest2</b>:</div><div class = 'formSection'>Category: " +this.drawInterestCategoryDropDown(2,player);
		str += " Existing: " +this.drawInterestDropDown(player.interest2Category, 2,player);
		str += " Write In: " + this.drawInterestTextBox(2,player);
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
		for(var i = 1; i<= player.maxHornNumber; i++){
			if(player.leftHorn == i){
				html += '<option  selected = "selected" value="' + i +'">' + i+'</option>'
			}else{
				html += '<option value="' + i +'">' + i+'</option>'
			}
		}

		var maxCustomHorns = 0;  //kr wants no shitty horns widely available
		for(var i = 255; i> 255-maxCustomHorns; i+=-1){
            if(player.leftHorn == i){
                html += '<option  selected = "selected" value="' + i +'">' + i+'</option>'
            }else{
                html += '<option value="' + i +'">' + i+'</option>'
            }
        }

		//another for loop of "non-canon" horns you can choose but aren't part of main sim.
		html += '</select>'
		return html;
	}

	this.drawOneRightHornDropDown = function(player){
		var html = "<select id = 'rightHornID" + player.id + "' name='rightHorn" +player.id +"'>";
		for(var i = 1; i<= player.maxHornNumber; i++){
			if(player.leftHorn == i){
				html += '<option  selected = "selected" value="' + i +'">' + i+'</option>'
			}else{
				html += '<option value="' + i +'">' + i+'</option>'
			}
		}

		var maxCustomHorns = 0;
            for(var i = 255; i> 255-maxCustomHorns; i+=-1){
                if(player.rightHorn == i){
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
		available_classes = available_classes.concat(custom_only_classes);
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










/************************************************

AND NOW IT'S TIME FOR CHAR CREATOR EASTER EGGS!!!

************************************************/

//don't pollute global name space more than you already are, dunkass
//call this ONLY inside a function.
function CharacterEasterEggEngine(){
	//test with reddit first, 'cause it's small
	this.redditCharacters = [];
	this.tumblrCharacters = [];
	this.discordCharcters = [];
	this.creatorCharacters =["b=%2B*-%C3%96%C3%B4%5C%00%C3%90%2C%2C%0D&s=,,Arson,Shipping,authorBotJunior","b=%2B*-%06%C3%B4%C2%A3%00%C3%90%2C%2C%0D&s=,,Authoring,Robots,authorBot","b=%C3%A8%C3%90%C2%99E%C3%BE)%00%17%1C%1C.&s=,,100 Art Projects At Once,Memes,karmicRetribution","b=%3C%1E%07%C3%86%C3%BE%C2%A3%04%13%18%18%0D&s=,,The AuthorBot,Authoring,jadedResearcher"];
	this.creditsBuckaroos = [];
	this.ideasWranglers = [];
	this.bards = [];
	this.patrons = [];
	this.patrons2 = [];
	this.patrons3 = [];
	this.canon = [];  //
	this.otherFandoms = [];

	//takes in things like this.redditCharacters and "OCs/reddit.txt"
	//parses the text file as newline seperated and load them into the array.
	this.loadArrayFromFile = function(arr, file,processForSim, callBack,that){
		//console.log("loading" + file)
		var that = this;
		$.ajax({
		  url: file,
		  success:(function(data){
			 that.parseFileContentsToArray(arr, data.trim());
			 if(processForSim && callBack) return that.processForSim(callBack);
			 if(!processForSim && callBack) callBack(that);  //whoever calls me is responsible for knowing when all are loaded.

		  }),
		  dataType: "text"
		});
	}

	this.parseFileContentsToArray =function(arr, fileContents){
		this[arr] = fileContents.split("\n");
		//console.log(arr);
		//console.log(this[arr])
	}

	//pick 2-12 players out of pool (first space/time (and if don't exist, make placeholder)
	//then set those to CurSEssionGlobalVar.replayers  <--
	//then call callback
	this.processForSim = function(callBack){
		var pool = this.getPoolBasedOnEggs();
		var potentials = this.playerDataStringArrayToURLFormat(pool);
		var ret = [];
		var spacePlayers = findAllAspectPlayers(potentials, "Space");
		var space = getRandomElementFromArray(spacePlayers);
		potentials.removeFromArray(space);
		if(!space){
			space = randomSpacePlayer(curSessionGlobalVar);
			space.chatHandle = "randomSpace"
			//console.log("Random space player!")
			space.quirk = new Quirk();
			space.quirk.favoriteNumber = 0;
			space.deriveChatHandle = false;
		}
		var timePlayers = findAllAspectPlayers(potentials, "Time");
		var time = getRandomElementFromArray(timePlayers);
		potentials.removeFromArray(time);
		if(!time){
			time = randomTimePlayer(curSessionGlobalVar);
			time.chatHandle = "randomTime"
			time.quirk = new Quirk();
			time.quirk.favoriteNumber = 0;
			time.deriveChatHandle = false;
		}
		//console.log("space chatHandle " + space.chatHandle)
		//console.log(space);
		ret.push(space);
		ret.push(time);
		var numPlayers = getRandomInt(2,12);
		for(var i = 2; i<numPlayers; i++){
			var p = getRandomElementFromArray(potentials);
			if(p) ret.push(p);
			if(p) potentials.removeFromArray(p);  //no repeats. <-- modify all the removes l8r if i want to have a mode that enables them.
		}
		//console.log(ret);
		for(var i = 0; i<ret.length; i++){
			var p = ret[i];
			//console.log(p)
			if(p.chatHandle.trim() == "") p.chatHandle = getRandomChatHandle(p.class_name,p.aspect,p.interest1, p.interest2);
		}
		curSessionGlobalVar.replayers = ret;
		callBack();
	}



	//make sure to call this on windows.load and WAIT for it to return, dunkass.
	this.loadArraysFromFile = function(callBack, processForSim,that){
		//too confusing trying to only load the assest i'll need. wait for now.
		this.loadArrayFromFile("redditCharacters","OCs/reddit.txt", processForSim)
		this.loadArrayFromFile("tumblrCharacters","OCs/tumblr.txt", processForSim)
		this.loadArrayFromFile("discordCharcters","OCs/discord.txt", processForSim)
		this.loadArrayFromFile("creditsBuckaroos","OCs/creditsBuckaroos.txt", processForSim)
		this.loadArrayFromFile("ideasWranglers","OCs/ideasWranglers.txt", processForSim)
		this.loadArrayFromFile("patrons","OCs/patrons.txt", processForSim)
		this.loadArrayFromFile("patrons2","OCs/patrons2.txt", processForSim)
		this.loadArrayFromFile("patrons3","OCs/patrons3.txt", processForSim)
		this.loadArrayFromFile("canon","OCs/canon.txt", processForSim)
		this.loadArrayFromFile("bards","OCs/bards.txt", processForSim)
		this.loadArrayFromFile("otherFandoms","OCs/otherFandoms.txt", processForSim,callBack,that) //last one in list has callback so I know to do next thing.
	}



	this.getPoolBasedOnEggs = function(){
		var pool = [];
		//first, parse url params. for each param you find that's right, append the relevant characters into the array.
		if(getParameterByName("reddit")  == "true"){
			pool = pool.concat(this.redditCharacters)
		}

		if(getParameterByName("tumblr")  == "true"){
			pool = pool.concat(this.tumblrCharacters)
		}

		if(getParameterByName("discord")  == "true"){
			pool = pool.concat(this.discordCharcters)
		}

		if(getParameterByName("creditsBuckaroos")  == "true"){
			pool = pool.concat(this.creditsBuckaroos)
		}

		if(getParameterByName("ideasWranglers")  == "true"){
			pool = pool.concat(this.ideasWranglers)
		}

		if(getParameterByName("bards")  == "true"){
        	pool = pool.concat(this.bards)
        }

		if(getParameterByName("patrons")  == "true"){
			pool = pool.concat(this.patrons)
		}

		if(getParameterByName("patrons2")  == "true"){
			pool = pool.concat(this.patrons2)
		}

		if(getParameterByName("patrons3")  == "true"){
			pool = pool.concat(this.patrons3)
		}

		if(getParameterByName("canon")  == "true"){
			pool = pool.concat(this.canon)
		}

		if(getParameterByName("otherFandoms")  == "true"){
			pool = pool.concat(this.otherFandoms)
		}


		if(getParameterByName("creators")  == "true"){
			pool = pool.concat(this.creatorCharacters)
		}

		if(pool.length == 0){
		//	console.log("i think i should be returning all characters.")
			pool = pool.concat(this.redditCharacters)
			pool = pool.concat(this.tumblrCharacters)
			pool = pool.concat(this.discordCharcters)
			pool = pool.concat(this.creditsBuckaroos)
			pool = pool.concat(this.patrons)
			pool = pool.concat(this.ideasWranglers)
			pool = pool.concat(this.canon)
			pool = pool.concat(this.creatorCharacters)
			pool = pool.concat(this.bards)
		}

		//return pool;
		return shuffle(pool); //boring if the same peeps are always first.

	}

	this.processEasterEggsViewer = function(){
		var pool = this.getPoolBasedOnEggs();
		return this.playerDataStringArrayToURLFormat(pool);
	}

	this.playerDataStringArrayToURLFormat = function(playerDataStringArray){
		var s = "";
		var b = "";
		//first, take each element in the array and seperate it out into s and b  (getRawParameterByName(name, url))
		for(var i = 0; i<playerDataStringArray.length; i++){
			//append all b's and all s's together
			var bs = playerDataStringArray[i];
			var tmpb = decodeURIComponent(bs.split("=")[1].split("&s")[0])
			var tmps = bs.split("=")[2]
			s+= tmps+",";
			b += tmpb;
		}
		//then,
		return dataBytesAndStringsToPlayers(b,s);

	}

	//getting ALL of a cateogry is how I will handle having a gallery of said category.
	//expect to display 12 players at a time, with paginaton
	//displaying their "summary" from char helper.
	//and their data in a text area so it can be copied.
	this.getAllReddit = function(){
		return this.playerDataStringArrayToURLFormat(this.redditCharacters);
	}

}
