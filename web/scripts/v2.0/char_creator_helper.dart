import "../SBURBSim.dart";
import 'dart:html';
//need to render all players
class CharacterCreatorHelper {
	List<Player> players;
	num player_index = 0; //how i draw 12 players at a time.
	//have css for each sprite template.  sprite template is 400 x 300, fit 3 on a line?
	//max of 4 lines?

	CharacterCreatorHelper(this.players) {}

	void drawAllPlayers(){
		bloodColors.add("#ff0000"); //for humans
		for(num i = 0; i<this.players.length; i++){
			this.drawSinglePlayer(this.players[i]);
		}
	}
	void draw12PlayerSummaries(){
		var start = this.player_index;
		var num_at_a_time= 12;
		for(var i = start; i<start+num_at_a_time; i++){

			if(this.players.length > i){
				//print("i is: " + i);
				this.drawSinglePlayerSummary(this.players[i]);
				this.player_index ++; //okay to mod this in the loop because only initial i value relies on it.
			}else{
				//no more players.
				querySelector("#draw12Button").setInnerHtml("No More Players");
        (querySelector("#draw12Button")as ButtonElement).disabled =true;
			}
		}
	}
	void drawSinglePlayerSummary(player){
		//print("drawing: " + player.title())
		String str = "<div class='standAloneSummary' id='createdCharacter"+ player.id + "'>";
		var divId = player.id;
		str += this.drawCanvasSummary(player);
		//this.drawDataBoxNoButtons(player);
		str += "</div><div class = 'standAloneSummary'>" + this.drawDataBoxNoButtons(player) + "</div>";
		this.div.append(str);
		this.createSummaryOnCanvas(player);
		querySelector(".optionBox").show(); //unlike char creator, always show
		this.wireUpDataBox(player);
	}
	void drawSinglePlayer(player){
		//print("drawing: " + player.title())
		String str = "";
		var divId = player.id;
		if(curSessionGlobalVar.session_id != 612 && curSessionGlobalVar.session_id != 613  && curSessionGlobalVar.session_id != 413 && curSessionGlobalVar.session_id != 1025 &&  curSessionGlobalVar.session_id != 111111)player.chatHandle = "";
		//divId = divId.replace(new RegExp(r"""\s+""", multiLine:true), '');
		str += "<div class='createdCharacter' id='createdCharacter"+ player.id + "'>";
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
		str += "</div>";
		str += "</div>";

		str += "</div>";


		str += "</div>";
		this.div.append(str);

		player.spriteCanvasID = player.id+player.id+"spriteCanvas";
		String canvasHTML = "<br><canvas style='display:none' id='" + player.spriteCanvasID+"' width='" +400 + "' height="+300 + "'>  </canvas>";
		querySelector("#playerSprites").append(canvasHTML);

		player.renderSelf();

		var canvas = querySelector("#canvas"+ divId);
		//drawSinglePlayer(canvas, player);
		var p1SpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
		drawSpriteFromScratch(p1SpriteBuffer,player);
		//drawBG(p1SpriteBuffer, "#ff9999", "#ff00ff");
		copyTmpCanvasToRealCanvasAtPos(canvas, p1SpriteBuffer,0,0);
		this.wireUpTabs(player);
		this.wireUpPlayerDropDowns(player);
		this.wireUpTextBoxes(player);
		this.wireUpCheckBoxes(player);
		this.createSummaryOnCanvas(player);
		this.wireUpDataBox(player);
		this.syncPlayerToFields(player);
	}
	void syncPlayerToFields(player){
		this.syncPlayerToDropDowns(player);
		this.syncPlayerToCheckBoxes(player);
		this.syncPlayerToTextBoxes(player);
	}
	void syncPlayerToDropDowns(player){
		//TODO is setting the val enough for a drop down???  what if it doesn't match the thing?
		querySelector("#classNameID" +player.id).val(player.class_name);
		querySelector("#aspectID" +player.id).val(player.aspect);
		querySelector("#hairTypeID" +player.id).val(player.hair);
		querySelector("#hairColorID" +player.id).val(player.hairColor);
		String troll = "Human";
		if(player.isTroll) troll = "Troll";
		querySelector("#speciesID" +player.id).val(troll);
		querySelector("#leftHornID" +player.id).val(player.leftHorn);
		querySelector("#rightHornID" +player.id).val(player.rightHorn);
		querySelector("#bloodColorID" +player.id).val(player.bloodColor);
		querySelector("#bloodColorID" +player.id).css("background-color", player.bloodColor);
		querySelector("#favoriteNumberID" +player.id).val(player.quirk.favoriteNumber);
		querySelector("#moonID" +player.id).val(player.moon);
		querySelector("#moonID" +player.id).css("background-color", moonToColor(player.moon));
	}
	void syncPlayerToCheckBoxes(player){
		//.prop('checked', true);
		querySelector("#grimDark"+player.id).prop('checked',player.grimDark);
	  querySelector("#isDreamSelf"+player.id).prop('checked',player.isDreamSelf);
		querySelector("#godTier"+player.id).prop('checked',player.godTier);
		querySelector("#godDestiny"+player.id).prop('checked',player.godDestiny);
		querySelector("#murderMode"+player.id).prop('checked',player.murderMode);
		querySelector("#leftMurderMode"+player.id).prop('checked',player.leftMurderMode);
		querySelector("#dead"+player.id).prop('checked',player.dead);
		querySelector("#robot"+player.id).prop('checked',player.robot);
	}
	void syncPlayerToTextBoxes(player){
		querySelector("#interestCategory1" +player.id).val(player.interest1Category);
		querySelector("#interestCategory2" +player.id).val(player.interest2Category);
		querySelector("#interest1" +player.id).val(player.interest1);
		querySelector("#interest2" +player.id).val(player.interest2);
		querySelector("#chatHandle"+player.id).val(player.chatHandle);
	}
	dynamic drawDropDowns(player){
		String str = "<div id = 'dropDowns" + player.id + "' class='optionBox'>";
		str += "<div>" + (this.drawOneClassDropDown(player));
		str += (" of ");
		str+= (this.drawOneAspectDropDown(player)) + "</div>";
		str += "<hr>";
		str += "<span class='formElementLeft'>Hair Type:</span>" + this.drawOneHairDropDown(player);
		str += "<span class='formElementRight'>Hair Color:</span>" + this.drawOneHairColorPicker(player);
		str += "<span class='formElementLeft'>Species:</span>" + this.drawOneSpeciesDropDown(player);
		str += "<span class='formElementRight'>Moon:</span>" + this.drawOneMoonDropDown(player);
		str += "<span class='formElementLeft'>L. Horn:</span>" + this.drawOneLeftHornDropDown(player);
		str += "<span class='formElementRight'>R. Horn:</span>" + this.drawOneRightHornDropDown(player);
		str += "<span class='formElementLeft'>BloodColor:</span>" + this.drawOneBloodColorDropDown(player);
		str += "<span class='formElementRight'>Fav. Num:</span>" + this.drawOneFavoriteNumberDropDown(player);
		str += "</div>";
		return str;
	}
	dynamic drawTabs(player){
		String str = "<div id = 'tabs'"+player.id + " class='optionTabs'>";
		str += "<span id = 'ddTab" +player.id + "'class='optionTab optionTabSelected'> DropDowns</span>";
		str += "<span id = 'cbTab" +player.id + "'class='optionTab'> CheckBoxes</span>";
		str += "<span id = 'tbTab" +player.id + "'class='optionTab'> TextBoxes</span>";
		str += "<span id = 'csTab" +player.id + "'class='optionTab'> Summary</span>";
		str += "<span id = 'dataTab" +player.id + "'class='optionTab'> Data</span>";
		str += "<span id = 'deleteTab" +player.id + "'class='deleteTab'> X </span>";
		str += "</div>";
		return str;
	}
	dynamic drawCheckBoxes(player){
		String str = "<div id = 'checkBoxes"+player.id + "' class='optionBox'>";
		str += '<span class="formElementLeft">GrimDark:</span> <input id="grimDark' + player.id + '" type="checkbox">'
		str += '<span class="formElementRight">IsDreamSelf:</span> <input id="isDreamSelf' + player.id + '" type="checkbox">'
		str += '<span class="formElementLeft">GodDestiny:</span> <input id="godDestiny' + player.id + '" type="checkbox">'
		str += '<span class="formElementRight">GodTier:</span> <input id="godTier' + player.id + '" type="checkbox">'
		str += '<span class="formElementLeft">MurderMode:</span> <input id="murderMode' + player.id + '" type="checkbox">'
		str += '<span class="formElementRight">LeftMurderMode:</span> <input id="leftMurderMode' + player.id + '" type="checkbox">'
		str += '<span class="formElementLeft">Dead:</span> <input id="dead' + player.id + '" type="checkbox">'
		str += '<span class="formElementRight">Robot:</span> <input id="robot' + player.id + '" type="checkbox">'

		str += "</div>";
		return str;
	}
	dynamic drawTextBoxes(player){
		String str = "<div id = 'textBoxes"+player.id + "'' class='optionBox'>";
		str += this.drawChatHandleBox(player);
		str += this.drawInterests(player);
		str += "</div>";
		return str;
	}
	dynamic drawCanvasSummary(player){
		String str = "<div id = 'canvasSummary"+player.id + "' class='optionBox'>";
		num height = 300;
		num width = 600;
		str += "<canvas id='canvasSummarycanvas" + player.id +"' width='" +width + "' height="+height + "'>  </canvas>"
		str += "</div>";
		return str;
	}
	void createSummaryOnCanvas(player){
		var canvas = querySelector("#canvasSummarycanvas"+  player.id);
		var ctx = canvas.getContext("2d");
		var pSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
		ctx.clearRect(0, 0, 600, 300);
		drawSpriteFromScratch(pSpriteBuffer, player);
		copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,-30,0);
		num space_between_lines = 25;
		num left_margin = 350;
		num line_height = 350;
		num start = 30;
		num current = 30;
		//title
	    ctx.font = "30px Times New Roman";
		ctx.fillStyle = getColorFromAspect(player.aspect);
		ctx.fillText(player.titleBasic(),left_margin,current);

		//interests
		ctx.font = "18px Times New Roman";
		num i = 3;
		ctx.fillStyle = player.getChatFontColor();
		if(player.chatHandle != "") ctx.fillText("(" + player.chatHandle + ")",left_margin,current + space_between_lines);
		ctx.fillStyle = "#000000";
		ctx.fillText("Interest1: " + player.interest1,left_margin,current + space_between_lines*i++); //i++ returns the value of i before you ++ed
		ctx.fillText("Interest2: " + player.interest2,left_margin,current + space_between_lines*i++);
		ctx.fillText("BloodColor: ",left_margin,current + space_between_lines*i++);
		ctx.fillStyle =  player.bloodColor;
		ctx.fillRect(left_margin + 100, current+space_between_lines*(i-1) -18, 18,18);
		ctx.fillStyle = "#000000";
		ctx.fillText("Moon: " + player.moon,left_margin,current + space_between_lines*i++);
		String destiny = "Nothing.";
		if(player.godDestiny) destiny = "God.";
		ctx.fillText("Destiny: " + destiny,left_margin,current + space_between_lines*i++);

		//ctx.fillText("Guardian: " + player.lusus,left_margin,current + space_between_lines*4);

		//ctx.fillText("Land: " + player.land,left_margin,current + space_between_lines*5);



	}
	dynamic drawHelpText(player){
		String str = "<div id = 'helpText" + player.id + "' class ='helpText'>...</div>";

		return str;
	}
	dynamic drawDataBoxNoButtons(player){
		String str = "<div id = 'dataBox"+player.id + "'>";
		str += "<button class = 'charCreatorButton' id = 'copyButton" + player.id + "'> Copy To ClipBoard</button>  </div>";
		str += "<textarea class = 'dataInputSmall' id='dataBoxDiv"+player.id + "'> </textarea>";
		str += "</div>";
		return str;
	}
	dynamic drawDataBox(player){
		String str = "<div id = 'dataBox"+player.id + "' class='optionBox'>";
		str += "<textarea class = 'dataInput' id='dataBoxDiv"+player.id + "'> </textarea>";
		str += "<div><button class = 'charCreatorButton' id = 'loadButton" + player.id + "'>Load From Text</button>";
		str += "<button class = 'charCreatorButton' id = 'copyButton" + player.id + "'> Copy To ClipBoard</button>  </div>";
		str += "</div>";
		return str;
	}
	void redrawSinglePlayer(player){
		  player.renderSelf();
			String divId = "canvas" + player.id;
			divId = divId.replace(new RegExp(r"""\s+""", multiLine:true), '');
			var canvas =querySelector("#"+divId)[0];
			drawSolidBG(canvas, "#ffffff");
			drawSinglePlayer(canvas, player);
			this.createSummaryOnCanvas(player);
			this.writePlayerToDataBox(player);
			this.syncPlayerToFields(player);
	}
	String generateHelpText(topic, specific){
		if(topic == "Class") return this.generateClassHelp(topic, specific);
		if(topic == "Aspect") return this.generateAspectHelp(topic, specific);
		if(topic == "BloodColor") return this.generateBloodColorHelp(topic, specific);
		if(topic == "Moon") return this.generateMoonHelp(topic, specific);
		if(topic == "FavoriteNumber") return "Favorite number can affect a Player's quirk, as well as determining a troll's god tier Wings.";
		if(topic == "Horns") return "Horns are purely cosmetic. See gallery of horns <a target = '_blank' href ='image_browser.html?horns=true'>here</a>";
		if(topic == "chatHandle") return "If left blank, chatHandle will be auto-generated by the sim based on class, aspect, and interests.";
		if(topic == "Hair") return "Hair is purely cosmetic. See gallery of hair <a target = '_blank' href ='image_browser.html?hair=true'>here</a>";
		if(topic == "grimDark") return "Grim Dark players are more powerful and actively work to crash SBURB/SGRUB.";
		if(topic == "murderMode") return "Has done an acrobatic flip into a pile of crazy. Will try to kill other players.";
		if(topic == "leftMurderMode") return "Has recovered from an acrobatic flip into a pile of crazy. Still bears the scars.";
		if(topic == "godDestiny") return "Strong chance of god tiering upon death, with shenanigans getting their corpse where it needs to go. Not applicable for deaths that happen on Skaia, as no amount of shenanigans is going to rocket their corpse off planet. ";
		if(topic == "godTier") return "Starts the game already god tier. Somehow. Hey. It's YOUR decision. Don't blame me if SBURB behaves weird, you hacker.";
		if(topic == "isDreamSelf") return "Starts the game as a dream self. Somehow. Hey. It's YOUR decision. Don't blame me if SBURB behaves weird, you hacker.";
		if(topic == "dead") return "You monster. Whatever. The player died before entering the Medium due to suitably dramatic shenanigans. Hopefully someone will be available to corpse smooch them back to life once they get into the Medium.";
		if(topic == "robot") return "Robots are obviously superior to fleshy players. ";
		if(topic == "Species") return "Trolls are ever so slightly less mentally stable than humans and tend towards FAR more annoying quirks.";
		if(topic == "HairColor") return "Hair color is purely cosmetic. Certain hairstyles will have highlights which are mandated to be the Player's favorite color (which is aspect color for humans and blood color for trolls). ";
		if(topic == "Interests") return "Interests alter how a player speaks (including their skill at finding topics to rap about), some of the rungs on their echeladder, and their derived ChatHandle.";
		return "Help text not found for " + topic + ".";
	}
	void generateMoonHelp(topic, specific){
		if(specific == "Prospit") return "Dreamers of Prospit see visions of the inevitable future in the clouds of Skaia. This is not a good thing.";
		if(specific == "Derse") return "Dreamers of Derse are constantly bombarded by the whispers of the Horror Terrors. This is not a good thing.";
		return "Moon help text not found for " + specific + ".";
	}
	dynamic generateBloodColorHelp(topic, specific){
		if(specific == "#ff0000") return "Candy red blood has no specific boost.";
		String str = "The cooler blooded a troll is, the greater their HP and power on entering the medium. Game powers have a way of equalizing things, though. ";
		str += specific + " is associated with a power and hp increase of: " +bloodColorToBoost(specific);
		if(specific == "#99004d") str += ". Heiress blooded trolls will hate other Heiress bloods, as well as losing making them more likely to flip out. Biological imperatives for murder suck, yo.";
		return str;
	}
	String generateAspectHelp(topic, specific){
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
		return "Aspect help text not found for " + specific + ".";
	}
	String generateClassHelp(topic, specific){
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


		return "Class help text not found for " + specific + ".";
	}
	void wireUpDataBox(player){
		this.writePlayerToDataBox(player);
		var copyButton = querySelector("#copyButton" + player.id);
		var loadButton = querySelector("#loadButton" + player.id);
		var that = this;
		copyButton.click(() {
			var dataBox = querySelector("#dataBoxDiv"+player.id);
			dataBox.select();
			document.execCommand('copy');
		});

		loadButton.click(() {
			var dataBox = querySelector("#dataBoxDiv"+player.id);
			String bs = "?" + dataBox.val(); //need "?" so i can parse as url
			print("bs is: " + bs);
			var b = (getParameterByName("b", bs)); //this is pre-decoded, if you try to decode again breaks mages of heart which are "%"
			var s = getParameterByName("s", bs);
			var x = (getParameterByName("x", bs));
			print("b: " + b);
			print("s: " + s);
			print("x: " + x);

			var players = dataBytesAndStringsToPlayers(b, s,x) ;//technically an array of one players.;
			print("Player class name: " + players[0].class_name);
			player.copyFromPlayer(players[0]);
			that.redrawSinglePlayer(player);
			//should have had wireUp methods to the fields to begin with. looks like I gotta pay for pastJR's mistakes.
		});

		//and two buttons, load and copy.
	}
	void writePlayerToDataBox(player){
		var dataBox = querySelector("#dataBoxDiv"+player.id);
		dataBox.val(player.toOCDataString());

	}
	void wireUpCheckBoxes(player){
		var grimDark = querySelector("#grimDark"+player.id);
		var isDreamSelf = querySelector("#isDreamSelf"+player.id);
		var godTier = querySelector("#godTier"+player.id);
		var godDestiny = querySelector("#godDestiny"+player.id);
		var murderMode = querySelector("#murderMode"+player.id);
		var leftMurderMode = querySelector("#leftMurderMode"+player.id);
		var dead = querySelector("#dead"+player.id);
		var robot = querySelector("#robot"+player.id);
		grimDark.prop('checked', player.grimDark == 4);
		godTier.prop('checked', player.godTier);
		isDreamSelf.prop('checked', player.isDreamSelf);
		godDestiny.prop('checked', player.godDestiny);
		murderMode.prop('checked', player.murderMode);
		leftMurderMode.prop('checked', player.leftMurderMode);
		dead.prop('checked', player.dead);
		robot.prop('checked', player.robot);

		var helpText = querySelector("#helpText"+player.id);
		var that = this;

		grimDark.change(() {
			if(grimDark.prop('checked')){
				player.grimDark = 4;
			}else{
				player.grimDark = 0;
			}
			that.redrawSinglePlayer(player);
			helpText.html(that.generateHelpText("grimDark",player.class_name));
		});

		isDreamSelf.change(() {
			player.isDreamSelf = isDreamSelf.prop('checked');
			that.redrawSinglePlayer(player);
			helpText.html(that.generateHelpText("isDreamSelf",player.class_name));
		});

		godTier.change(() {
			player.godTier = godTier.prop('checked');
			that.redrawSinglePlayer(player);
			helpText.html(that.generateHelpText("godTier",player.class_name));
		});

		godDestiny.change(() {
			player.godDestiny = godDestiny.prop('checked');
			that.redrawSinglePlayer(player);
			helpText.html(that.generateHelpText("godDestiny",player.class_name));
		});

		murderMode.change(() {
			player.murderMode = murderMode.prop('checked');
			that.redrawSinglePlayer(player);
			helpText.html(that.generateHelpText("murderMode",player.class_name));
		});

		leftMurderMode.change(() {
			player.leftMurderMode = leftMurderMode.prop('checked');
			that.redrawSinglePlayer(player);
			helpText.html(that.generateHelpText("leftMurderMode",player.class_name));
		});

		dead.change(() {
			player.dead = dead.prop('checked');
			that.redrawSinglePlayer(player);
			helpText.html(that.generateHelpText("dead",player.class_name));
		});

		robot.change(() {
			player.robot = robot.prop('checked');
			that.redrawSinglePlayer(player);
			helpText.html(that.generateHelpText("robot",player.class_name));
		});

	}
	void wireUpPlayerDropDowns(player){
			var c2 = querySelector("#classNameID" +player.id) ;
			var a2 = querySelector("#aspectID" +player.id) ;
			var hairDiv = querySelector("#hairTypeID" +player.id) ;
			var hairColorDiv = querySelector("#hairColorID" +player.id) ;
			var speciesDiv = querySelector("#speciesID" +player.id) ;
			var leftHornDiv = querySelector("#leftHornID" +player.id) ;
			var rightHornDiv = querySelector("#rightHornID" +player.id) ;
			var bloodDiv = querySelector("#bloodColorID" +player.id) ;
			var favoriteNumberDiv = querySelector("#favoriteNumberID" +player.id) ;
			var moonDiv = querySelector("#moonID" +player.id);
			var helpText = querySelector("#helpText"+player.id);


			var that = this;
			c2.change(() {
					var classDropDown = querySelector('[name="className' +player.id +'"] option:selected') //need to get what is selected inside the .change, otheriise is always the same;
					player.class_name = classDropDown.val();
					that.redrawSinglePlayer(player);
					helpText.html(that.generateHelpText("Class",player.class_name));

			});

			moonDiv.change(() {
					var moonDropDown = querySelector('[name="moon' +player.id +'"] option:selected');
					player.moon = moonDropDown.val();
					that.redrawSinglePlayer(player);
					moonDiv.css("background-color", moonToColor(player.moon));
					helpText.html(that.generateHelpText("Moon",player.moon));

			});

			favoriteNumberDiv.change(() {
					var numberDropDown = querySelector('[name="favoriteNumber' +player.id +'"] option:selected');
					player.quirk.favoriteNumber = parseInt(numberDropDown.val());
					that.redrawSinglePlayer(player);
					helpText.html(that.generateHelpText("FavoriteNumber",player.quirk.favoriteNumber));
			});


			a2.change(() {
					var aspectDropDown = querySelector('[name="aspect' +player.id +'"] option:selected');
					player.aspect = aspectDropDown.val();
					that.redrawSinglePlayer(player);
					helpText.html(that.generateHelpText("Aspect",player.aspect));
			});

			hairDiv.change(() {
				  var aspectDropDown = querySelector('[name="hair' +player.id +'"] option:selected');
					player.hair = aspectDropDown.val();
					that.redrawSinglePlayer(player);
					helpText.html(that.generateHelpText("Hair",player.class_name));
			});

			hairColorDiv.change(() {
					//var aspectDropDown = querySelector('[name="hairColor' +player.id +'"] option:selected');
					player.hairColor = hairColorDiv.val();
					that.redrawSinglePlayer(player);
					helpText.html(that.generateHelpText("HairColor",player.class_name));
			});

			leftHornDiv.change(() {
					var aspectDropDown = querySelector('[name="leftHorn' +player.id +'"] option:selected');
					player.leftHorn = aspectDropDown.val();
					that.redrawSinglePlayer(player);
					helpText.html(that.generateHelpText("Horns",player.class_name));
			});

			rightHornDiv.change(() {
					var aspectDropDown = querySelector('[name="rightHorn' +player.id +'"] option:selected');
					player.rightHorn = aspectDropDown.val();
					that.redrawSinglePlayer(player);
					helpText.html(that.generateHelpText("Horns",player.class_name));
			});

			bloodDiv.change(() {
					var aspectDropDown = querySelector('[name="bloodColor' +player.id +'"] option:selected');
					player.bloodColor = aspectDropDown.val();
					bloodDiv.css("background-color", player.bloodColor);
					bloodDiv.css("color", "black");
					that.redrawSinglePlayer(player);
					helpText.html(that.generateHelpText("BloodColor",player.bloodColor));
			});

			speciesDiv.change(() {
					var aspectDropDown = querySelector('[name="species' +player.id +'"] option:selected');
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
	void wireUpTabs(player){
			var ddTab = querySelector("#ddTab" +player.id );
			var cbTab =$ ("#cbTab" +player.id );
			var tbTab =$ ("#tbTab" +player.id );
			var csTab =$ ("#csTab" +player.id );
			var dataTab =$ ("#dataTab" +player.id );
			var deleteTab = querySelector("#deleteTab"+player.id);

			var dropDowns = querySelector("#dropDowns" + player.id);
			var checkBoxes = querySelector("#checkBoxes" + player.id);
			var textBoxes = querySelector("#textBoxes" + player.id);
			var canvasSummary = querySelector("#canvasSummary" + player.id);
			var dataBox = querySelector("#dataBox" + player.id);
			var helpText = querySelector("#helpText"+player.id);
			var that = this;

			deleteTab.click((){
				var monster = confirm("Delete player? (You monster)");
				if(monster){
					querySelector("#createdCharacter"+player.id).hide();
					curSessionGlobalVar.players.removeFromArray(player);
				}

			})
			ddTab.click((){
				that.selectTab(ddTab, [cbTab, tbTab, csTab, dataTab]);
				that.displayDiv(dropDowns, [checkBoxes, textBoxes, canvasSummary, dataBox]);
				helpText.html("...");
				helpText.show();
			});

			tbTab.click((){
				that.selectTab(tbTab, [ddTab,cbTab, csTab, dataTab]);
				that.displayDiv(textBoxes, [checkBoxes, dropDowns, canvasSummary, dataBox]);
				helpText.html("...");
				helpText.show();
			});

			csTab.click((){
				that.selectTab(csTab, [ddTab,cbTab, tbTab, dataTab]);
				that.displayDiv(canvasSummary, [checkBoxes, textBoxes, dropDowns, dataBox]);
				helpText.html("...");
				helpText.hide();
			});

			cbTab.click((){
				that.selectTab(cbTab, [ddTab, tbTab, csTab, dataTab]);
				that.displayDiv(checkBoxes, [dropDowns, textBoxes, canvasSummary, dataBox]);
				helpText.html("...");
				helpText.show();
			});

			dataTab.click((){
				that.selectTab(dataTab, [ddTab, cbTab, tbTab, csTab]);
				that.displayDiv(dataBox, [checkBoxes, textBoxes, canvasSummary, dropDowns]);
				helpText.html("You can copy your player's value from this box, or override it by pasting another players value in and clicking 'Load'.");
				helpText.show();
			});

			this.selectTab(ddTab, [cbTab, tbTab, csTab, dataTab]);
			that.displayDiv(dropDowns, [checkBoxes, textBoxes, canvasSummary, dataBox]);
		}
	void displayDiv(displayed, undisplayed){
			displayed.show();
			for(num i = 0; i<undisplayed.length; i++){
				undisplayed[i].hide();
			}
		}
	void selectTab(selected, unselected){
			selected.addClass("optionTabSelected");
			for(num i = 0; i<unselected.length; i++){
				unselected[i].removeClass("optionTabSelected");
			}
		}
	void wireUpTextBoxes(player){
		//first, choosing interest category should change the contents of interestDrop1 or 2 (but NOT any value in the player or the text box.)
		var interestCategory1Dom = querySelector("#interestCategory1" +player.id);
		var interestCategory2Dom = querySelector("#interestCategory2" +player.id);
		var interest1DropDom = querySelector("#interestDrop1" +player.id);
		var interest2DropDom = querySelector("#interestDrop2" +player.id);
		var interest1TextDom = querySelector("#interest1" +player.id); //don't wire these up. instead, get value on url creation.
		var interest2TextDom = querySelector("#interest2" +player.id);
		var chatHandle = querySelector("#chatHandle"+player.id);

		var that = this;
		var helpText = querySelector("#helpText"+player.id);

		interest1TextDom.change((){
			player.interest1 = interest1TextDom.val();
			that.redrawSinglePlayer(player);
		})

		interest2TextDom.change((){
			player.interest2 = interest2TextDom.val();
			that.redrawSinglePlayer(player);
		})

		chatHandle.click(() {
					helpText.html(that.generateHelpText("chatHandle",player.class_name));
		});

		chatHandle.change((){
			player.chatHandle = chatHandle.val();
			that.redrawSinglePlayer(player);
		})


		interestCategory1Dom.change(() {
					var icDropDown = querySelector('[name="interestCategory1' +player.id +'"] option:selected');
					interest1DropDom.html(that.drawInterestDropDown(icDropDown.val(), 1, player))
					helpText.html(that.generateHelpText("Interests",player.class_name));
					player.interest1Category = icDropDown.val();
		});

		interestCategory2Dom.change(() {
					var icDropDown = querySelector('[name="interestCategory2' +player.id +'"] option:selected');
					interest2DropDom.html(that.drawInterestDropDown(icDropDown.val(), 2, player))
					helpText.html(that.generateHelpText("Interests",player.class_name));
					player.interest2Category = icDropDown.val();
		});

		interest1DropDom.change(() {
					var icDropDown = querySelector('[name="interestDrop1' +player.id +'"] option:selected');
					interest1TextDom.val(icDropDown.val());
					helpText.html(that.generateHelpText("Interests",player.class_name));
					player.interest1 = icDropDown.val();
					that.redrawSinglePlayer(player);
		});

		interest2DropDom.change(() {
					var icDropDown = querySelector('[name="interestDrop2' +player.id +'"] option:selected');
					interest2TextDom.val(icDropDown.val());
					helpText.html(that.generateHelpText("Interests",player.class_name));
					player.interest2 = icDropDown.val();
					that.redrawSinglePlayer(player);
		});

	}
	dynamic drawOneHairDropDown(player){
		String html = "<select id = 'hairTypeID" + player.id + "' name='hair" +player.id +"'>";
		for(num i = 1; i<= player.maxHairNumber; i++){
			if(player.hair == i){
				html += '<option  selected = "selected" value="' + i +'">' + i+'</option>';
			}else{
				html += '<option value="' + i +'">' + i+'</option>'
			}
		}
		html += '</select>';
		return html;
	}
	dynamic drawInterests(player){
		String str = "";
		str += " <div class = 'formSection'><b>Interest1</b>:</div><div class = 'formSection'>Category: " + this.drawInterestCategoryDropDown(1,player);
		str += " Existing: " +this.drawInterestDropDown(player.interest1Category, 1,player);
		str += " Write In: " + this.drawInterestTextBox(1,player) +"</div>";
		str += "<div class = 'formSection'><b>Interest2</b>:</div><div class = 'formSection'>Category: " +this.drawInterestCategoryDropDown(2,player);
		str += " Existing: " +this.drawInterestDropDown(player.interest2Category, 2,player);
		str += " Write In: " + this.drawInterestTextBox(2,player);
		str += "</div>";
		return str;
	}
	dynamic drawChatHandleBox(player){
		String html = "Chat Handle: <input type='text' id = 'chatHandle" + player.id + "' name='interest" + player.id +"' + value=''> </input>";
		return html;
	}
	dynamic drawInterestTextBox(num, player){
		var interestToCheck = player.interest1;
		if(num == 2) interestToCheck = player.interest2;
		String html = "<input type='text' id = 'interest" + num+ player.id + "' name='interest" +num+player.id +"' + value='" + interestToCheck +"'> </input>";
		return html;
	}
	dynamic drawInterestDropDown(category, num, player){
		String html = "<select id = 'interestDrop" + num+ player.id + "' name='interestDrop" +num+player.id +"'>";
		var interestsInCategory = interestCategoryToInterestList(category);
		var interestToCheck = player.interest1;
		if(num == 2) interestToCheck = player.interest2;
		for(num i = 0; i< interestsInCategory.length; i++){
			var pi = interestsInCategory[i];
			if(interestToCheck == pi){
				html += '<option  selected = "selected" value="' + pi +'">' + pi+'</option>';
			}else{
				html += '<option value="' + pi +'">' + pi+'</option>'
			}
		}
		html += '</select>';
		return html;
	}
	dynamic drawInterestCategoryDropDown(num, player){
		String html = "<select id = 'interestCategory" + num+ player.id + "' name='interestCategory" +num+player.id +"'>";
		for(num i = 0; i< interestCategories.length; i++){
			var ic = interestCategories[i];
			if(player.interestedIn(ic, num)){
				if(num ==1){
					player.interest1Category = ic;
				}else if(num == 2){
					player.interest2Category = ic;
				}
				html += '<option  selected = "selected" value="' + ic +'">' + ic+'</option>';
			}else{
				html += '<option value="' + ic +'">' + ic+'</option>'
			}
		}
		html += '</select>';
		return html;
	}
	dynamic drawOneFavoriteNumberDropDown(player){
		String html = "<select id = 'favoriteNumberID" + player.id + "' name='favoriteNumber" +player.id +"'>";
		for(int i = 0; i<=12; i++){
			if(player.quirk.favoriteNumber == i){
				html += '<option  selected = "selected" value="' + i +'">' + i+'</option>';
			}else{
				html += '<option value="' + i +'">' + i+'</option>'
			}
		}
		html += '</select>';
		return html;
	}
	dynamic drawOneLeftHornDropDown(player){
		String html = "<select id = 'leftHornID" + player.id + "' name='leftHorn" +player.id +"'>";
		for(num i = 1; i<= player.maxHornNumber; i++){
			if(player.leftHorn == i){
				html += '<option  selected = "selected" value="' + i +'">' + i+'</option>';
			}else{
				html += '<option value="' + i +'">' + i+'</option>'
			}
		}

		num maxCustomHorns = 0;  //kr wants no shitty horns widely available
		for(num i = 255; i> 255-maxCustomHorns; i+=-1){;
            if(player.leftHorn == i){
                html += '<option  selected = "selected" value="' + i +'">' + i+'</option>';
            }else{
                html += '<option value="' + i +'">' + i+'</option>'
            }
        }

		//another for loop of "non-canon" horns you can choose but aren't part of main sim.
		html += '</select>';
		return html;
	}
	dynamic drawOneRightHornDropDown(player){
		String html = "<select id = 'rightHornID" + player.id + "' name='rightHorn" +player.id +"'>";
		for(num i = 1; i<= player.maxHornNumber; i++){
			if(player.leftHorn == i){
				html += '<option  selected = "selected" value="' + i +'">' + i+'</option>';
			}else{
				html += '<option value="' + i +'">' + i+'</option>'
			}
		}

		num maxCustomHorns = 0;
            for(num i = 255; i> 255-maxCustomHorns; i+=-1){;
                if(player.rightHorn == i){
                    html += '<option  selected = "selected" value="' + i +'">' + i+'</option>';
                }else{
                    html += '<option value="' + i +'">' + i+'</option>'
                }
            }


		html += '</select>';
		return html;
	}
	dynamic drawOneClassDropDown(player){
		available_classes = classes.slice(0); //re-init available classes. make deep copy
	  available_classes.addAll(custom_only_classes);
		String html = "<select id = 'classNameID" + player.id + "' name='className" +player.id +"'>";
		for(num i = 0; i< available_classes.length; i++){
			if(available_classes[i] == player.class_name){
				html += '<option  selected = "selected" value="' + available_classes[i] +'">' + available_classes[i]+'</option>';
			}else{
				html += '<option value="' + available_classes[i] +'">' + available_classes[i]+'</option>'
			}
		}
		html += '</select>';
		return html;
	}
	dynamic drawOneMoonDropDown(player){
		String html = "<select style = 'background: " + moonToColor(player.moon) + "' id = 'moonID" + player.id + "' name='moon" +player.id +"'>";
		for(num i = 0; i< moons.length; i++){
			if(moons[i] == player.moon){
				html += '<option style="background:' + moonToColor(moons[i]) + '" selected = "moon" value="' + moons[i] +'">' + moons[i]+'</option>'
			}else{
				html += '<option style="background:' + moonToColor(moons[i]) + '" value="' + moons[i] +'">' + moons[i]+'</option>';
			}
		}
		html += '</select> ';
		return html;

	}
	dynamic drawOneSpeciesDropDown(player){
		var species = ["Human", "Troll"];
		String html = "<select id = 'speciesID" + player.id + "' name='species" +player.id +"'>";
		for(num i = 0; i< species.length; i++){
			if((species[i] == "Troll" && player.isTroll) || (species[i] == "Human" && !player.isTroll)){
				html += '<option  selected = "species" value="' + species[i] +'">' + species[i]+'</option>';
			}else{
				html += '<option value="' + species[i] +'">' + species[i]+'</option>'
			}
		}
		html += '</select>';
		return html;

	}
	dynamic drawOneHairColorPicker(player){
		String id = "hairColorID" + player.id;
		String html = "<input id = '" + id + "' type='color' name='favcolor' value='" + player.hairColor + "'>";
		return html;
	}
	dynamic drawOneHairColorDropDownOLD(player){
		String html = "<select id = 'hairColorID" + player.id + "' name='hairColor" +player.id +"'>";
		for(num i = 0; i< human_hair_colors.length; i++){
			if(human_hair_colors[i] == player.hairColor){
				html += '<option style="background:' + human_hair_colors[i] + '" selected = "hairColor" value="' + human_hair_colors[i] +'">' + human_hair_colors[i]+'</option>'
			}else{
				html += '<option style="background:' + human_hair_colors[i] + '"value="' + human_hair_colors[i] +'">' + human_hair_colors[i]+'</option>';
			}
		}
		html += '</select>';
		return html;
	}
	dynamic drawOneBloodColorDropDown(player){
		String html = "<select style='color: black; background:" + player.bloodColor + "' id = 'bloodColorID" + player.id + "' name='bloodColor" +player.id +"'>"
		for(num i = 0; i< bloodColors.length; i++){
			if(bloodColors[i] == player.bloodColor){
				html += '<option style="color: black; background:' + bloodColors[i] + '" selected = "bloodColor" value="' + bloodColors[i] +'">' + bloodColors[i]+'</option>'
			}else{
				html += '<option style="color: black; background:' + bloodColors[i] + '"value="' + bloodColors[i] +'">' + bloodColors[i]+'</option>';
			}
		}
		html += '</select>';
		return html;
	}
	dynamic drawOneAspectDropDown(player){
		available_aspects = nonrequired_aspects.slice(0); //required_aspects
		available_aspects.addAll(required_aspects.slice(0));
		String html = "<select class = 'selectDiv' id = 'aspectID" + player.id + "' name='aspect" +player.id +"'>";
		for(num i = 0; i< available_aspects.length; i++){
			if(available_aspects[i] == player.aspect){
				html += '<option selected = "selected" value="' + available_aspects[i] + '" >' + available_aspects[i]+'</option>';
			}else{
				html += '<option value="' + available_aspects[i] + '" >' + available_aspects[i]+'</option>'
			}

		}
		html += '</select>';
		return html;
	}


}
