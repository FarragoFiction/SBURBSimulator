import '../PlayerSpriteHandler.dart';
import "../SBURBSim.dart";
import 'dart:async';
import 'dart:html';
import "../v2.0/char_creator_helper.dart";
import '../navbar.dart';

import "../includes/colour_picker.dart";

//need to render all players
class CharacterCreatorHelper {
    List<Player> players;
    Element div;
    num player_index = 0; //how i draw 12 players at a time.
    //have css for each sprite template.  sprite template is 400 x 300, fit 3 on a line?
    //max of 4 lines?

    CharacterCreatorHelper(this.players) {
        div = querySelector("#character_creator");
    }

    void drawAllPlayers(Session session) {
        bloodColors.add("#ff0000"); //for humans
        for (int i = 0; i < this.players.length; i++) {
            this.drawSinglePlayerForHelper(session, this.players[i]);
        }
    }

    void draw12PlayerSummaries(Session session) {
        int start = this.player_index;
        int num_at_a_time = 12;
        for (int i = start; i < start + num_at_a_time; i++) {
            if (this.players.length > i) {
                this.drawSinglePlayerSummary(session, this.players[i]);
                this.player_index++; //okay to mod this in the loop because only initial i value relies on it.
            } else {
                //no more players.
                querySelector("#draw12Button").setInnerHtml("No More Players");
                (querySelector("#draw12Button") as ButtonElement).disabled = true;
            }
        }
    }

    void drawSinglePlayerSummary(Session session, Player player) {
        ////print("drawing: " + player.title());
        String str =
            "<div class='standAloneSummary' id='createdCharacter${player.id}'>";
        String divId = player.id.toString();
        str += this.drawCanvasSummary(player);
        //this.drawDataBoxNoButtons(player);
        str += "</div><div class = 'standAloneSummary'>" +
            this.drawDataBoxNoButtons(player) +
            "</div>";
        appendHtml(div, str);
        this.createSummaryOnCanvas(player);
        show(querySelector(
            "#canvasSummary${player.id}")); //unlike char creator, always show
        this.wireUpDataBox(session,player);
    }

    //TODO why the fuck did this have the same name as a handle_sprites function?
    Future<Null> drawSinglePlayerForHelper(Session session, Player player) async {
        //print("drawing: " + player.title());
        String str = "";
        String divId = player.id.toString();
        if (session.session_id != 612 &&
            session.session_id != 613 &&
            session.session_id != 413 &&
            session.session_id != 1025 &&
            session.session_id != 111111) player.chatHandle = "";
        //divId = divId.replace(new RegExp(r"""\s+""", multiLine:true), '');
        str += "<div class='createdCharacter' id='createdCharacter${player.id}'>";
        str += "<canvas class = 'createdCharacterCanvas' id='canvas" +
            divId +
            "' width='400' height='300'>  </canvas>";
        str += "<div class = 'folderDealy'>";
        str += this.drawTabs(player);
        str += "<div class = 'charOptions'>";
        str += "<div class = 'charOptionsForms'>";
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
        appendHtml(div, str);

        //usin ColourPicker picker might slow shit down. comment out for now.
        //ColourPicker p = ColourPicker.create(querySelector("#hairColorID${player.id}"), width:94, height:18, colourInt:0xCC87E8 );
        ColourPicker p;
        if (p != null) { p..anchor.style.top = "5px"; }

        player.initSpriteCanvas();
        player.renderSelf("drawSinglePlayerFor");

        //drawSinglePlayer(canvas, player);
        //var p1SpriteBuffer =
        //Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
        //Drawing.drawSpriteFromScratch(p1SpriteBuffer, player);
        //drawBG(p1SpriteBuffer, "#ff9999", "#ff00ff");
        //Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, p1SpriteBuffer, 0, 0);

        this.wireUpTabs(session,player);
        this.wireUpPlayerDropDowns(player);
        this.wireUpTextBoxes(player);
        this.wireUpCheckBoxes(player);
        this.createSummaryOnCanvas(player);
        this.wireUpDataBox(session,player);
        this.syncPlayerToFields(player);
    }

    void syncPlayerToFields(Player player) {
        this.syncPlayerToDropDowns(player);
        this.syncPlayerToCheckBoxes(player);
        this.syncPlayerToTextBoxes(player);
    }

    void syncPlayerToDropDowns(Player player) {
        (querySelector("#classNameID${player.id}") as SelectElement).value =
        (player.class_name.name);
        (querySelector("#aspectID${player.id}") as SelectElement).value =
        (player.aspect.name);
        (querySelector("#hairTypeID${player.id}") as SelectElement).value =
        (player.hair.toString());
        (querySelector("#hairColorID${player.id}") as InputElement).value =
        (player.hairColor);
        String troll = "Human";
        if (player.isTroll) troll = "Troll";
        (querySelector("#speciesID${player.id}") as SelectElement).value = (troll);
        (querySelector("#leftHornID${player.id}") as SelectElement).value =
        (player.leftHorn.toString());
        (querySelector("#rightHornID${player.id}") as SelectElement).value =
        (player.rightHorn.toString());
        (querySelector("#bloodColorID${player.id}") as SelectElement).value =
        (player.bloodColor);
        (querySelector("#bloodColorID${player.id}") as SelectElement)
            .style
            .backgroundColor = player.bloodColor;
        (querySelector("#favoriteNumberID${player.id}") as SelectElement).value =
        (player.quirk.favoriteNumber.toString());
        (querySelector("#moonID${player.id}") as SelectElement).value =
        (player.moon.name);
        querySelector("#moonID${player.id}").style.backgroundColor =
            moonToColor(player.moon);

        ColourPicker.notifyAllPickers();
    }

    void syncPlayerToCheckBoxes(Player player) {
        //.prop('checked', true);
        (querySelector("#grimDark${player.id}") as CheckboxInputElement).checked =
        (player.grimDark > 3);
        (querySelector("#isDreamSelf${player.id}") as CheckboxInputElement)
            .checked = player.isDreamSelf;
        (querySelector("#godTier${player.id}") as CheckboxInputElement).checked =
            player.godTier;
        (querySelector("#godDestiny${player.id}") as CheckboxInputElement).checked =
            player.godDestiny;
        (querySelector("#murderMode${player.id}") as CheckboxInputElement).checked =
            player.murderMode;
        (querySelector("#leftMurderMode${player.id}") as CheckboxInputElement)
            .checked = player.leftMurderMode;
        (querySelector("#dead${player.id}") as CheckboxInputElement).checked =
            player.dead;
        (querySelector("#robot${player.id}") as CheckboxInputElement).checked =
            player.robot;
    }

    void syncPlayerToTextBoxes(Player player) {
        (querySelector("#interestCategory1${player.id}") as SelectElement).value = (player.interest1.category.name);
        (querySelector("#interestCategory2${player.id}") as SelectElement).value = (player.interest2.category.name);
        (querySelector("#interest1${player.id}") as InputElement).value = (player.interest1.name);
        (querySelector("#interest2${player.id}") as InputElement).value = (player.interest2.name);
        (querySelector("#chatHandle${player.id}") as InputElement).value = (player.chatHandle);

        OptionElement icDropDown = (querySelector("#interestCategory1${player.id}") as SelectElement).selectedOptions[0];
        InterestCategory ic1 = InterestManager.getCategoryFromString(icDropDown.value);
        querySelector("#interestDrop1${player.id}").setInnerHtml(drawInterestDropDown(ic1, 1, player));

        OptionElement icDropDown2 = (querySelector("#interestCategory2${player.id}") as SelectElement).selectedOptions[0];
        InterestCategory ic2 = InterestManager.getCategoryFromString(icDropDown2.value);
        querySelector("#interestDrop2${player.id}").setInnerHtml(drawInterestDropDown(ic2, 2, player));

        (querySelector("#interestDrop1${player.id}") as SelectElement).value = (player.interest1.name);
        (querySelector("#interestDrop2${player.id}") as SelectElement).value = (player.interest2.name);
    }

    dynamic drawDropDowns(Player player) {
        String str = "<div id = 'dropDowns${player.id}' class='optionBox'>";
        str += "<div>" + (this.drawOneClassDropDown(player));
        str += (" of ");
        str += (this.drawOneAspectDropDown(player)) + "</div>";
        str += "<hr>";
        str += "<span class='formElementLeft'>Hair Type:</span>" +
            this.drawOneHairDropDown(player);
        str += "<span class='formElementRight'>Hair Color:</span>" +
            this.drawOneHairColorPicker(player);
        str += "<span class='formElementLeft'>Species:</span>" +
            this.drawOneSpeciesDropDown(player);
        str += "<span class='formElementRight'>Moon:</span>" +
            this.drawOneMoonDropDown(player);
        str += "<span class='formElementLeft'>L. Horn:</span>" +
            this.drawOneHornDropDown(player, true);
        str += "<span class='formElementRight'>R. Horn:</span>" +
            this.drawOneHornDropDown(player, false);
        str += "<span class='formElementLeft'>BloodColor:</span>" +
            this.drawOneBloodColorDropDown(player);
        str += "<span class='formElementRight'>Fav. Num:</span>" +
            this.drawOneFavoriteNumberDropDown(player);
        str += "</div>";
        return str;
    }

    dynamic drawTabs(Player player) {
        String str = "<div id = 'tabs'${player.id}' class='optionTabs'>";
        str +=
        "<span id = 'ddTab${player.id}'class='optionTab optionTabSelected'> DropDowns</span>";
        str += "<span id = 'cbTab${player.id}'class='optionTab'> CheckBoxes</span>";
        str += "<span id = 'tbTab${player.id}'class='optionTab'> TextBoxes</span>";
        str += "<span id = 'csTab${player.id}'class='optionTab'> Summary</span>";
        str += "<span id = 'dataTab${player.id}'class='optionTab'> Data</span>";
        str += "<span id = 'deleteTab${player.id}'class='deleteTab'> X </span>";
        str += "</div>";
        return str;
    }

    dynamic drawCheckBoxes(Player player) {
        String str = "<div id = 'checkBoxes${player.id}' class='optionBox'>";
        str +=
        '<span class="formElementLeft">GrimDark:</span> <input id="grimDark${player.id}" type="checkbox">';
        str +=
        '<span class="formElementRight">IsDreamSelf:</span> <input id="isDreamSelf${player.id}" type="checkbox">';
        str +=
        '<span class="formElementLeft">GodDestiny:</span> <input id="godDestiny${player.id}" type="checkbox">';
        str +=
        '<span class="formElementRight">GodTier:</span> <input id="godTier${player.id}" type="checkbox">';
        str +=
        '<span class="formElementLeft">MurderMode:</span> <input id="murderMode${player.id}" type="checkbox">';
        str +=
        '<span class="formElementRight">LeftMurderMode:</span> <input id="leftMurderMode${player.id}" type="checkbox">';
        str +=
        '<span class="formElementLeft">Dead:</span> <input id="dead${player.id}" type="checkbox">';
        str +=
        '<span class="formElementRight">Robot:</span> <input id="robot${player.id}" type="checkbox">';

        str += "</div>";
        return str;
    }

    dynamic drawTextBoxes(Player player) {
        String str = "<div id = 'textBoxes${player.id}'' class='optionBox'>";
        str += this.drawChatHandleBox(player);
        str += this.drawInterests(player);
        str += "</div>";
        return str;
    }

    dynamic drawCanvasSummary(Player player) {
        String str = "<div id = 'canvasSummary${player.id}' class='optionBox'>";
        num height = 300;
        num width = 600;
        str += "<canvas id='canvasSummarycanvas${player.id}' width='" +
            width.toString() +
            "' height='" +
            height.toString() +
            "'>  </canvas>";
        str += "</div>";
        return str;
    }

    void createSummaryOnCanvas(Player player) {
        CanvasElement canvas = querySelector("#canvasSummarycanvas${player.id}");
        CanvasRenderingContext2D ctx = canvas.getContext("2d");
        CanvasElement pSpriteBuffer =
        Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
        ctx.clearRect(0, 0, 600, 300);
        Drawing.drawSpriteFromScratch(pSpriteBuffer, player);
        Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer, -30, 0);
        num space_between_lines = 25;
        num left_margin = 350;
        num line_height = 350;
        num start = 30;
        num current = 30;
        //title
        ctx.font = "30px Times New Roman";
        ctx.fillStyle = player.aspect.palette.text.toStyleString();
        ctx.fillText(player.titleBasic(), left_margin, current);

        //interests
        ctx.font = "18px Times New Roman";
        num i = 3;
        ctx.fillStyle = player.getChatFontColor();
        if (player.chatHandle != "")
            ctx.fillText("(" + player.chatHandle + ")", left_margin,
                current + space_between_lines);
        ctx.fillStyle = "#000000";
        ctx.fillText(
            "Interest1: " + player.interest1.name,
            left_margin,
            current +
                space_between_lines *
                    i++); //i++ returns the value of i before you ++ed
        ctx.fillText("Interest2: " + player.interest2.name, left_margin,
            current + space_between_lines * i++);
        ctx.fillText(
            "BloodColor: ", left_margin, current + space_between_lines * i++);
        ctx.fillStyle = player.bloodColor;
        ctx.fillRect(left_margin + 100,
            current + space_between_lines * (i - 1) - 18, 18, 18);
        ctx.fillStyle = "#000000";
        ctx.fillText("Moon: ${player.moon}", left_margin,
            current + space_between_lines * i++);
        String destiny = "Nothing.";
        if (player.godDestiny) destiny = "God.";
        ctx.fillText("Destiny: " + destiny, left_margin,
            current + space_between_lines * i++);

        //ctx.fillText("Guardian: " + player.lusus,left_margin,current + space_between_lines*4);

        //ctx.fillText("Land: " + player.land,left_margin,current + space_between_lines*5);
    }

    dynamic drawHelpText(Player player) {
        String str = "<div id = 'helpText${player.id}' class ='helpText'>...</div>";

        return str;
    }

    dynamic drawDataBoxNoButtons(Player player) {
        String str = "<div id = 'dataBox${player.id}'>";
        str +=
        "<button class = 'charCreatorButton' id = 'copyButton${player.id}'> Copy To ClipBoard</button>  </div>";
        str +=
        "<textarea class = 'dataInputSmall' id='dataBoxDiv${player.id}'> </textarea>";
        str += "</div>";
        return str;
    }

    dynamic drawDataBox(Player player) {
        String str = "<div id = 'dataBox${player.id}' class='optionBox'>";
        str +=
        "<textarea class = 'dataInput' id='dataBoxDiv${player.id}'> </textarea>";
        str +=
        "<div><button class = 'charCreatorButton' id = 'loadButton${player.id}'>Load From Text</button>";
        str +=
        "<button class = 'charCreatorButton' id = 'copyButton${player.id}'> Copy To ClipBoard</button>  </div>";
        str += "</div>";
        return str;
    }

    Future<Null> redrawSinglePlayer(Player player) async{
        player.renderSelf("redrawSinglePlayer");
        String divId = "canvas${player.id}";
        //divId = divId.replaceAll(new RegExp(r"""\s+""", multiLine:true), ''); //TODO what is going on here?
        var canvas = querySelector("#" + divId);
        Drawing.drawSolidBG(canvas, new Colour.fromStyleString("#fefefe"));
        await PlayerSpriteHandler.drawSpriteFromScratch(canvas, player);

        //Drawing.drawSinglePlayer(canvas, player);
        this.createSummaryOnCanvas(player);
        this.writePlayerToDataBox(player);
        this.syncPlayerToFields(player);
    }

    String generateHelpText(String topic, String specific) {
        if (topic == "Class") return this.generateClassHelp(topic, specific) + "";
        if (topic == "Aspect") return this.generateAspectHelp(topic, specific) + " <a target = '_blank' href =' tools/stat_summary/index.html'>Aspect Explanations</a>";

        if (topic == "BloodColor")
            return this.generateBloodColorHelp(topic, specific);
        if (topic == "Moon") return this.generateMoonHelp(topic, specific);
        if (topic == "FavoriteNumber")
            return "Favorite number can affect a Player's quirk, as well as determining a troll's god tier Wings.";
        if (topic == "Horns")
            return "Horns are purely cosmetic. See gallery of horns <a target = '_blank' href ='image_browser.html?horns=true'>here</a>";
        if (topic == "chatHandle")
            return "If left blank, chatHandle will be auto-generated by the sim based on class, aspect, and interests.";
        if (topic == "Hair")
            return "Hair is purely cosmetic. See gallery of hair <a target = '_blank' href ='image_browser.html?hair=true'>here</a>";
        if (topic == "grimDark")
            return "Grim Dark players are more powerful and actively work to crash SBURB/SGRUB.";
        if (topic == "murderMode")
            return "Has done an acrobatic flip into a pile of crazy. Will try to kill other players.";
        if (topic == "leftMurderMode")
            return "Has recovered from an acrobatic flip into a pile of crazy. Still bears the scars.";
        if (topic == "godDestiny")
            return "Strong chance of god tiering upon death, with shenanigans getting their corpse where it needs to go. Not applicable for deaths that happen on Skaia, as no amount of shenanigans is going to rocket their corpse off planet. ";
        if (topic == "godTier")
            return "Starts the game already god tier. Somehow. Hey. It's YOUR decision. Don't blame me if SBURB behaves weird, you hacker.";
        if (topic == "isDreamSelf")
            return "Starts the game as a dream self. Somehow. Hey. It's YOUR decision. Don't blame me if SBURB behaves weird, you hacker.";
        if (topic == "dead")
            return "You monster. Whatever. The player died before entering the Medium due to suitably dramatic shenanigans. Hopefully someone will be available to corpse smooch them back to life once they get into the Medium.";
        if (topic == "robot")
            return "Robots are obviously superior to fleshy players. ";
        if (topic == "Species")
            return "Trolls are ever so slightly less mentally stable than humans and tend towards FAR more annoying quirks.";
        if (topic == "HairColor")
            return "Hair color is purely cosmetic. Certain hairstyles will have highlights which are mandated to be the Player's favorite color (which is aspect color for humans and blood color for trolls). ";
        if (topic == "Interests")
            return "Interests alter the topics a player knows about (including their skill at finding topics to rap about), some of the rungs on their echeladder, their land,  and their derived ChatHandle.";
        return "Help text not found for " + topic + ".";
    }

    String generateMoonHelp(topic, specific) {
        if (specific == "Prospit")
            return "Dreamers of Prospit see visions of the inevitable future in the clouds of Skaia. This is not a good thing.";
        if (specific == "Derse")
            return "Dreamers of Derse are constantly bombarded by the whispers of the Horror Terrors. This is not a good thing.";
        return "Moon help text not found for " + specific + ".";
    }

    String generateBloodColorHelp(topic, specific) {
        if (specific == "#ff0000") return "Candy red blood has no specific boost.";
        String str =
            "The cooler blooded a troll is, the greater their HP and power on entering the medium. Game powers have a way of equalizing things, though. ";
        str += specific +
            " is associated with a power and hp increase of: " +
            bloodColorToBoost(specific).toString();
        if (specific == "#99004d")
            str +=
            ". Heiress blooded trolls will hate other Heiress bloods, as well as losing making them more likely to flip out. Biological imperatives for murder suck, yo.";
        return str;
    }

    String generateAspectHelp(String topic, String specific) {
        if (specific == "Law")
            return "Law players are associated with free will, sanity and inflexible movements. Law Players are capapble of banning OR requiring action in those around them, or themselves.";
        if (specific == "Space")
            return "Space players are in charge of breeding the frog, and are associated with the low mobility needed to focus exclusively on their own quests, good alchemy ability, and good health. ";
        if (specific == "Time")
            return "Time players are in charge of timeline management, creating various doomed time clones and provide the ability to 'scratch' a failed session. They are chained to inevitability and as a result are associated with low free will offset by high minLuck and mobility . They know a lot about SBURB/SGRUB, usually through time shenanigans.";
        if (specific == "Breath")
            return "Breath players are associated with high mobility, and tend to help other players out with their quests, even at the detriment to their own. They are very sane, but tend to have difficulty staying in one place long enough to form social connections. They are stupidly hard to catch.";
        if (specific == "Doom")
            return "Doom players are associated with bad luck and low hp. Each Doom player death is according to a vast prophecy and considerably strengthens them, as well as lifting the Doom on their head for a short time. They excel at alchemy, and have limited success with freeWill.  They are capable of using the dead as a resource. They know a lot about SBURB/SGRUB.";
        if (specific == "Heart")
            return "Heart players are associated with their INTERESTS. A Heart player interested in Romance, for example, will have a high relationship stat, while one interested in Athletics will have high MANGRIT.  They are also in charge of concupiscient shipping grids.";
        if (specific == "Mind")
            return "Mind players are associated with high free will. Luck DO3SN'T R34LLY M4TTER, so they have both good 'minLuck' and poor 'maxLuck'. They have difficulty forming bonds with other players. They know a lot about SBURB/SGRUB.";
        if (specific == "Light")
            return "Light players are associated with good luck, have a lot of willpower,  and know a lot about SBURB/SGRUB. They have less hp than other players, and tend to have more fragile psyches. They are awfully distracting and flashy in battle.";
        if (specific == "Void")
            return "Void players are capable of accessing the Void, which allows them narrative freedom, random stats and being difficult to find. They have a trait they are SO GOOD or SO BAD at when they enter the medium and increase it over time. They tend to have similarly random flaws, as well as bad luck.";
        if (specific == "Rage")
            return "Rage players are capable of accessing Madness, which allows them narrative freedom, raw MANGRIT and speed, and the destruction of positive relationships and sanity.";
        if (specific == "Hope")
            return "Hope players are associated with sanity and good luck. If a strong enough Hope player is alive, players will be less likely to waste time flipping their shit. Occasionally, a Hope player will flip their shit and use an insanely powerful attack rather than a regular fraymotif. Hope players have random flaws.";
        if (specific == "Life")
            return "Life players are associated with high HP and good MANGRIT. They are capable of using the dead as a resource, but have trouble with Alchemy.";
        if (specific == "Blood")
            return "Blood players are associated with high positive relationships, as well as sanity. They are not very lucky. A Blood player is very difficult to murder, being able to insta-calm rampaging players in most cases. They are also in charge of concillitory shipping grids.";
        return "Aspect help text not found for " + specific + ".";
    }

    String generateClassHelp(String topic, String specific) {
        if (specific == "Maid")
            return "A Maid distributes their associated aspect to the entire party and starts with a lot of it. They give a boost to their Aspect, embracing even the bad parts.";
        if (specific == "Mage")
            return "A Mage increases their own associated aspect and starts with a lot of it. They know a lot about SBURB/SGRUB. They suffer from the negative parts of their Aspect more than other classes.";
        if (specific == "Knight")
            return "A Knight increases their own associated aspect and starts with a lot of it. They give a  boost to the positive parts of their Aspect, while protecting themselves from the negative parts.  Knights are charged with protecting the Space player while they breed frogs.";
        if (specific == "Rogue")
            return "A Rogue increases the parties associated aspect, steals it from someone to give to everyone, and starts with a lot it. They are affected by their Aspect less than normal, even the good parts.";
        if (specific == "Sylph")
            return "A Sylph distributes their associated aspect to the entire party and start with a lot of it. They give an extra boost to players they meet in person.  They feel less of the positive effects of their Aspect, but can twist weakness into strength.";
        if (specific == "Seer")
            return "A Seer distributes their associated aspect to the entire party. They start with very little of their aspect and must gain more through experience. They know a lot about SBURB/SGRUB. They get a great deal of the positive of their aspect, but even more of the negative. ";
        if (specific == "Thief")
            return "A Thief increases their own associated aspect, steals it from others, and starts with very little of it and must steal more.  They are affected by their Aspect less than normal, even the good parts.";
        if (specific == "Heir")
            return "An Heir increases their own associated aspect. They start with very little of their aspect and must inherit it. They give a 1.5 boost to their Aspect, inheriting even the bad parts.";
        if (specific == "Bard")
            return "A Bard distributes their inverted Aspect to the entire party and starts with very little of it. They have an increased effect in person. They invert their aspect, causing its strengths to become weaknesses while using what should be weaknesses as tools of destruction.";
        if (specific == "Prince")
            return "A Prince increase their inverted aspect in themselves and starts with a lot of it. They invert their aspect, causing its strengths to become weaknesses while using what should be weaknesses as tools of destruction. They destroy their Aspect faster in themselves around others.";
        if (specific == "Witch")
            return "A Witch increases their own associated aspect and starts with a lot of it. They are stronger around others. They feel less of the positive effects of their Aspect, but can twist weakness into strength.";
        if (specific == "Page")
            return "A Page distributes their associated aspect to the entire party. They start with very little of their aspect and must earn it. They can not do quests on their own, but gain power very quickly. They give a  boost to the positive parts of their Aspect, while protecting others from the negative parts.";
        if (specific == "Smith")
            return "A Smith forges their associated aspect for their own benefit. They start with very little of their aspect and must create it.";


        if (specific == "Waste")
            return "Wastes gain no benefits or detriments related to their Aspect. They are associated with extreme highs and lows, either entirely avoiding their aspect or causing great destruction with it. They are assholes who won't stop hacking my damn code.";
        if (specific == "Scribe")
            return "A Scribe distributes their associated aspect to the entire party. They start with very little of their aspect and must gain more through experience. They know a lot about SBURB/SGRUB. They get a great deal of the positive of their aspect, but even more of the negative.  They have a boost to SBURB Lore.";
        if (specific == "Sage")
            return "A Sage increases their own associated aspect and starts with a lot of it. They know a lot about SBURB/SGRUB. They reduce the negative parts of their Aspect through their wisdom. They have a boost to SBURB Lore.";
        if (specific == "Scout")
            return "A Scout increases their own associated aspect and starts with very little of it. They give a  boost to the positive parts of their Aspect, while reducing the damage from the negative parts. They know how to navigate their Aspect to avoid the pitfalls.";
        if (specific == "Grace")
            return "Graces gain no benefits or detriments related to their Aspect. They are associated with extreme highs and lows, either entirely avoiding their aspect or causing great destruction with it. They are assholes who won't stop teaching people to hack my damn code.";
        if (specific == "Guide")
            return "A Guide increases associated aspect in others and starts a lot of it to guide others to. They give a  boost to the positive parts of their Aspect, while reducing the damage from the negative parts. They know how to navigate their Aspect to avoid the pitfalls.";
        if (specific == "Muse")
            return "A Muse is the most passive possible class. They take on all the negatives of their Aspect and give the positives to others. They do not start with a lot of their Aspect.";
        if (specific == "Lord")
            return "A Lord is the most active possible class. They hoard on all the postives of their Aspect and delegate the negatives to others. They start with a lot of their Aspect. They have special minions called Leprechauns.";

        return "Class help text not found for " + specific + ".";
    }

    void wireUpDataBox(Session session, Player player) {
        this.writePlayerToDataBox(player);
        ButtonElement copyButton = querySelector("#copyButton${player.id}");
        ButtonElement loadButton = querySelector("#loadButton${player.id}");
        var that = this;
        copyButton.onClick.listen((Event e) {
            TextAreaElement dataBox = querySelector("#dataBoxDiv${player.id}");
            dataBox.select();
            document.execCommand('copy');
        });

        if (loadButton != null) {
            //will be null for char viewer.
            loadButton.onClick.listen((Event e) {
                TextAreaElement dataBox = querySelector("#dataBoxDiv${player.id}");
                String bs = "${window.location}?" + dataBox.value; //need "?" so i can parse as url
                if(window.location.toString().contains("?")) bs = "${window.location}&" + dataBox.value;
                //print("bs is: " + bs);
                String b = (getParameterByName("b", bs)); //this is pre-decoded, if you try to decode again breaks mages of heart which are "%"
                String s = getParameterByName("s", bs);
                String x = (getParameterByName("x", bs));
                //TODO oh god why ar eall these null???
                //;
                //;
                //;

                List<Player> players = dataBytesAndStringsToPlayers(session,b, s, x); //technically an array of one players.;
                //print("Player class name: " + players[0].class_name.name);

                player.copyFromPlayer(players[0]);
                player.session = session;
                player.syncToSessionMoon();
                that.redrawSinglePlayer(player);
                //should have had wireUp methods to the fields to begin with. looks like I gotta pay for pastJR's mistakes.
            });
        }

        //and two buttons, load and copy.
    }

    void writePlayerToDataBox(Player player) {
        TextAreaElement dataBox = querySelector("#dataBoxDiv${player.id}");
        dataBox.value = (player.toOCDataString());
    }

    void wireUpCheckBoxes(Player player) {
        CheckboxInputElement grimDark = querySelector("#grimDark${player.id}");
        CheckboxInputElement isDreamSelf =
        querySelector("#isDreamSelf${player.id}");
        CheckboxInputElement godTier = querySelector("#godTier${player.id}");
        CheckboxInputElement godDestiny = querySelector("#godDestiny${player.id}");
        CheckboxInputElement murderMode = querySelector("#murderMode${player.id}");
        CheckboxInputElement leftMurderMode =
        querySelector("#leftMurderMode${player.id}");
        CheckboxInputElement dead = querySelector("#dead${player.id}");
        CheckboxInputElement robot = querySelector("#robot${player.id}");
        grimDark.checked = player.grimDark == 4;
        godTier.checked = player.godTier;
        isDreamSelf.checked = player.isDreamSelf;
        godDestiny.checked = player.godDestiny;
        murderMode.checked = player.murderMode;
        leftMurderMode.checked = player.leftMurderMode;
        dead.checked = player.dead;
        robot.checked = player.robot;

        Element helpText = querySelector("#helpText${player.id}");
        var that = this;

        grimDark.onChange.listen((Event e) {
            if (grimDark.checked) {
                player.grimDark = 4;
            } else {
                player.grimDark = 0;
            }
            that.redrawSinglePlayer(player);
            helpText
                .setInnerHtml(that.generateHelpText("grimDark", player.class_name.name));
        });

        isDreamSelf.onChange.listen((Event e) {
            player.isDreamSelf = isDreamSelf.checked;
            that.redrawSinglePlayer(player);
            helpText.setInnerHtml(
                that.generateHelpText("isDreamSelf", player.class_name.name));
        });

        godTier.onChange.listen((Event e) {
            player.godTier = godTier.checked;
            that.redrawSinglePlayer(player);
            helpText
                .setInnerHtml(that.generateHelpText("godTier", player.class_name.name));
        });

        godDestiny.onChange.listen((Event e) {
            player.godDestiny = godDestiny.checked;
            that.redrawSinglePlayer(player);
            helpText
                .setInnerHtml(that.generateHelpText("godDestiny", player.class_name.name));
        });

        murderMode.onChange.listen((Event e) {
            player.murderMode = murderMode.checked;
            that.redrawSinglePlayer(player);
            helpText
                .setInnerHtml(that.generateHelpText("murderMode", player.class_name.name));
        });

        leftMurderMode.onChange.listen((Event e) {
            player.leftMurderMode = leftMurderMode.checked;
            that.redrawSinglePlayer(player);
            helpText.setInnerHtml(
                that.generateHelpText("leftMurderMode", player.class_name.name));
        });

        dead.onChange.listen((Event e) {
            if(!player.dead) {
                player.makeDead("The Whims of the Observer", player);
            }else {
                player.makeAlive();
            }
            that.redrawSinglePlayer(player);
            helpText.setInnerHtml(that.generateHelpText("dead", player.class_name.name));
        });

        robot.onChange.listen((Event e) {
            player.robot = robot.checked;
            that.redrawSinglePlayer(player);
            helpText.setInnerHtml(that.generateHelpText("robot", player.class_name.name));
        });
    }

    void wireUpPlayerDropDowns(Player player) {
        SelectElement c2 = querySelector("#classNameID${player.id}");
        SelectElement a2 = querySelector("#aspectID${player.id}");
        SelectElement hairDiv = querySelector("#hairTypeID${player.id}");
        Element hairColorDiv = querySelector("#hairColorID${player.id}");
        SelectElement speciesDiv = querySelector("#speciesID${player.id}");
        SelectElement leftHornDiv = querySelector("#leftHornID${player.id}");
        SelectElement rightHornDiv = querySelector("#rightHornID${player.id}");
        SelectElement bloodDiv = querySelector("#bloodColorID${player.id}");
        SelectElement favoriteNumberDiv =
        querySelector("#favoriteNumberID${player.id}");
        SelectElement moonDiv = querySelector("#moonID${player.id}");
        Element helpText = querySelector("#helpText${player.id}");

        var that = this;
        c2.onChange.listen((Event e) {
            //InputElement classDropDown = querySelector('[name="className${player.id}""] option:selected'); //need to get what is selected inside the .change, otheriise is always the same;
            OptionElement classDropDown = c2.selectedOptions[0];
            player.class_name =
                SBURBClassManager.stringToSBURBClass(classDropDown.value);
            that.redrawSinglePlayer(player);
            helpText.setInnerHtml(that.generateHelpText("Class", player.class_name.name));
        });

        moonDiv.onChange.listen((Event e) {
            OptionElement moonDropDown = moonDiv.selectedOptions[0];
            player.moon = player.session.stringToMoon(moonDropDown.value);
            that.redrawSinglePlayer(player);
            moonDiv.style.backgroundColor = moonToColor(player.moon);
            helpText.setInnerHtml(that.generateHelpText("Moon", player.moon.toString()));
        });

        favoriteNumberDiv.onChange.listen((Event e) {
            OptionElement numberDropDown = favoriteNumberDiv.selectedOptions[0];
            player.quirk.favoriteNumber = int.parse((numberDropDown.value));
            that.redrawSinglePlayer(player);
            helpText.setInnerHtml(
                that.generateHelpText("FavoriteNumber", player.quirk.favoriteNumber.toString()));
        });

        a2.onChange.listen((Event e) {
            OptionElement aspectDropDown = a2.selectedOptions[0];
            player.aspect = Aspects.stringToAspect(aspectDropDown.value);
            that.redrawSinglePlayer(player);
            helpText.setInnerHtml(that.generateHelpText("Aspect", player.aspect.name));
        });

        hairDiv.onChange.listen((Event e) {
            OptionElement aspectDropDown = hairDiv.selectedOptions[0];
            player.hair = int.parse(aspectDropDown.value);
            that.redrawSinglePlayer(player);
            helpText.setInnerHtml(that.generateHelpText("Hair", player.class_name.name));
        });

        hairColorDiv.onChange.listen((Event e) {
            //var aspectDropDown = querySelector('[name="hairColor' +player.id +'"] option:selected');
            player.hairColor = (hairColorDiv as InputElement).value;
            that.redrawSinglePlayer(player);
            helpText
                .setInnerHtml(that.generateHelpText("HairColor", player.class_name.name));
        });

        leftHornDiv.onChange.listen((Event e) {
            OptionElement aspectDropDown = leftHornDiv.selectedOptions[0];
            player.leftHorn = int.parse(aspectDropDown.value);
            that.redrawSinglePlayer(player);
            helpText.setInnerHtml(that.generateHelpText("Horns", player.class_name.name));
        });

        rightHornDiv.onChange.listen((Event e) {
            OptionElement aspectDropDown = rightHornDiv.selectedOptions[0];
            player.rightHorn = int.parse(aspectDropDown.value);
            that.redrawSinglePlayer(player);
            helpText.setInnerHtml(that.generateHelpText("Horns", player.class_name.name));
        });

        bloodDiv.onChange.listen((Event e) {
            OptionElement aspectDropDown = bloodDiv.selectedOptions[0];
            player.bloodColor = aspectDropDown.value;
            bloodDiv.style.backgroundColor = player.bloodColor;
            bloodDiv.style.color = "black";
            that.redrawSinglePlayer(player);
            helpText
                .setInnerHtml(that.generateHelpText("BloodColor", player.bloodColor));
        });

        speciesDiv.onChange.listen((Event e) {
            OptionElement aspectDropDown = speciesDiv.selectedOptions[0];
            String str = aspectDropDown.value;
            if (str == "Troll") {
                player.isTroll = true;
            } else {
                player.isTroll = false;
            }
            that.redrawSinglePlayer(player);
            helpText.setInnerHtml(that.generateHelpText("Species", player.isTroll ? "Troll" : "Human"));
        });
    }

    void wireUpTabs(Session session, Player player) {
        Element ddTab = querySelector("#ddTab${player.id}");
        Element cbTab = querySelector("#cbTab${player.id}");
        Element tbTab = querySelector("#tbTab${player.id}");
        Element csTab = querySelector("#csTab${player.id}");
        Element dataTab = querySelector("#dataTab${player.id}");
        Element deleteTab = querySelector("#deleteTab${player.id}");

        Element dropDowns = querySelector("#dropDowns${player.id}");
        Element checkBoxes = querySelector("#checkBoxes${player.id}");
        Element textBoxes = querySelector("#textBoxes${player.id}");
        Element canvasSummary = querySelector("#canvasSummary${player.id}");
        Element dataBox = querySelector("#dataBox${player.id}");
        Element helpText = querySelector("#helpText${player.id}");
        CharacterCreatorHelper that = this;

        deleteTab.onClick.listen((Event e) {
            var monster = window.confirm("Delete player? (You monster)");
            if (monster) {
                hide(querySelector("#createdCharacter${player.id}"));
                removeFromArray(player, session.players);
            }
        });
        ddTab.onClick.listen((Event e) {
            that.selectTab(ddTab, [cbTab, tbTab, csTab, dataTab]);
            that.displayDiv(
                dropDowns, [checkBoxes, textBoxes, canvasSummary, dataBox]);
            helpText.setInnerHtml("...");
            show(helpText);
        });

        tbTab.onClick.listen((Event e) {
            that.selectTab(tbTab, [ddTab, cbTab, csTab, dataTab]);
            that.displayDiv(
                textBoxes, [checkBoxes, dropDowns, canvasSummary, dataBox]);
            helpText.setInnerHtml("...");
            show(helpText);
        });

        csTab.onClick.listen((Event e) {
            that.selectTab(csTab, [ddTab, cbTab, tbTab, dataTab]);
            that.displayDiv(
                canvasSummary, [checkBoxes, textBoxes, dropDowns, dataBox]);
            helpText.setInnerHtml("...");
            hide(helpText);
        });

        cbTab.onClick.listen((Event e) {
            that.selectTab(cbTab, [ddTab, tbTab, csTab, dataTab]);
            that.displayDiv(
                checkBoxes, [dropDowns, textBoxes, canvasSummary, dataBox]);
            helpText.setInnerHtml("...");
            show(helpText);
        });

        dataTab.onClick.listen((Event e) {
            that.selectTab(dataTab, [ddTab, cbTab, tbTab, csTab]);
            that.displayDiv(
                dataBox, [checkBoxes, textBoxes, canvasSummary, dropDowns]);
            helpText.setInnerHtml(
                "You can copy your player's value from this box, or override it by pasting another players value in and clicking 'Load'.");
            show(helpText);
        });

        this.selectTab(ddTab, [cbTab, tbTab, csTab, dataTab]);
        that.displayDiv(dropDowns, [checkBoxes, textBoxes, canvasSummary, dataBox]);
    }

    void displayDiv(Element displayed, List<Element> undisplayed) {
        show(displayed);
        for (int i = 0; i < undisplayed.length; i++) {
            hide(undisplayed[i]);
        }
    }

    void selectTab(Element selected, List<Element> unselected) {
        selected.classes.add("optionTabSelected");
        for (int i = 0; i < unselected.length; i++) {
            unselected[i].classes.remove("optionTabSelected");
        }
    }

    void wireUpTextBoxes(Player player) {
        //first, choosing interest category should change the contents of interestDrop1 or 2 (but NOT any value in the player or the text box.)
        SelectElement interestCategory1Dom = querySelector("#interestCategory1${player.id}");
        SelectElement interestCategory2Dom = querySelector("#interestCategory2${player.id}");
        SelectElement interest1DropDom = querySelector("#interestDrop1${player.id}");
        SelectElement interest2DropDom = querySelector("#interestDrop2${player.id}");
        InputElement interest1TextDom = querySelector("#interest1${player.id}"); //don't wire these up. instead, get value on url creation.
        InputElement interest2TextDom = querySelector("#interest2${player.id}");
        InputElement chatHandle = querySelector("#chatHandle${player.id}");
        CharacterCreatorHelper that = this;
        var helpText = querySelector("#helpText${player.id}");

        interest1TextDom.onChange.listen((Event e) {
            String ic1 = interestCategory1Dom.value;
            String i1 = interest1TextDom.value;
            player.interest1 =
            new Interest(i1, InterestManager.getCategoryFromString(ic1));
            that.redrawSinglePlayer(player);
        });

        interest2TextDom.onChange.listen((Event e) {
            String ic2 = interestCategory2Dom.value;
            String i2 = interest2TextDom.value;
            player.interest2 = new Interest(i2, InterestManager.getCategoryFromString(ic2));
            that.redrawSinglePlayer(player);
        });

        chatHandle.onClick.listen((Event e) {
            helpText.setInnerHtml(that.generateHelpText("chatHandle", player.class_name.name));
        });

        chatHandle.onChange.listen((Event e) {
            player.chatHandle = chatHandle.value;
            that.redrawSinglePlayer(player);
        });

        interestCategory1Dom.onChange.listen((Event e) {
            OptionElement icDropDown = interestCategory1Dom.selectedOptions[0];
            InterestCategory ic1 = InterestManager.getCategoryFromString(icDropDown.value);
            interest1DropDom.setInnerHtml(that.drawInterestDropDown(ic1, 1, player));
            helpText
                .setInnerHtml(that.generateHelpText("Interests", player.class_name.name));
            player.interest1.category.removeInterest(player.interest1.name);
            player.interest1.category = ic1;
            player.interest1.category.addInterest(player.interest1.name);
        });

        interestCategory2Dom.onChange.listen((Event e) {
            OptionElement icDropDown = interestCategory2Dom.selectedOptions[0];
            InterestCategory ic2 = InterestManager.getCategoryFromString(icDropDown.value);
            interest2DropDom.setInnerHtml(that.drawInterestDropDown(ic2, 2, player));
            helpText.setInnerHtml(that.generateHelpText("Interests", player.class_name.name));
            player.interest2.category.removeInterest(player.interest2.name);
            player.interest2.category = ic2;
            player.interest2.category.addInterest(player.interest2.name);
        });

        interest1DropDom.onChange.listen((Event e) {
            OptionElement icDropDown = interest1DropDom.selectedOptions[0];
            interest1TextDom.value = (icDropDown.value);
            helpText
                .setInnerHtml(that.generateHelpText("Interests", player.class_name.name));
            String ic1 = interestCategory1Dom.value;
            String i1 = icDropDown.value;
            player.interest1 =
            new Interest(i1, InterestManager.getCategoryFromString(ic1));
            that.redrawSinglePlayer(player);
        });

        interest2DropDom.onChange.listen((Event e) {
            OptionElement icDropDown = interest2DropDom.selectedOptions[0];
            interest2TextDom.value = (icDropDown.value);
            helpText.setInnerHtml(that.generateHelpText("Interests", player.class_name.name));
            String ic2 = interestCategory2Dom.value;
            String i2 = icDropDown.value;
            player.interest2 = new Interest(i2, InterestManager.getCategoryFromString(ic2));
            that.redrawSinglePlayer(player);
        });
    }

    String drawOneHairDropDown(Player player) {
        String html =
            "<select id = 'hairTypeID${player.id}' name='hair${player.id}'>";
        for (int i = 1; i <= Player.maxHairNumber; i++) {
            if (player.hair == i) {
                html += '<option  selected = "selected" value="$i">$i</option>';
            } else {
                html += '<option value="$i">$i</option>';
            }
        }
        html += '</select>';
        return html;
    }

    String drawInterests(Player player) {
        String str = "";
        str +=
            " <div class = 'formSection'><b>Interest1</b>:</div><div class = 'formSection'>Category: " +
                this.drawInterestCategoryDropDown(1, player);
        str += " Existing: " +
            this.drawInterestDropDown(player.interest1.category, 1, player);
        str += " Write In: " + this.drawInterestTextBox(1, player) + "</div>";
        str +=
            "<div class = 'formSection'><b>Interest2</b>:</div><div class = 'formSection'>Category: " +
                this.drawInterestCategoryDropDown(2, player);
        str += " Existing: " +
            this.drawInterestDropDown(player.interest2.category, 2, player);
        str += " Write In: " + this.drawInterestTextBox(2, player);
        str += "</div>";
        return str;
    }

    String drawChatHandleBox(Player player) {
        String html =
            "Chat Handle: <input type='text' id = 'chatHandle${player.id}' name='interest${player.id}' + value=''> </input>";
        return html;
    }

    String drawInterestTextBox(int num, Player player) {
        String interestToCheck = player.interest1.name;
        if (num == 2) interestToCheck = player.interest2.name;
        String html =
            "<input type='text' id = 'interest$num${player.id}' name='interest$num${player.id}' + value='" +
                interestToCheck +
                "'> </input>";
        return html;
    }

    String drawInterestDropDown(InterestCategory category, int num, Player player) {
        String html = "<select id = 'interestDrop$num${player.id}' name='interestDrop$num${player.id}'>";
        List<String> interestsInCategory = category.copyOfInterestStrings;
        ////;
        String interestToCheck = player.interest1.name;
        if (num == 2) interestToCheck = player.interest2.name;
        for (int i = 0; i < interestsInCategory.length; i++) {
            var pi = interestsInCategory[i];
            if (interestToCheck == pi) {
                html += '<option  selected = "selected" value="' +
                    pi +
                    '">' +
                    pi +
                    '</option>';
            } else {
                html += '<option value="' + pi + '">' + pi + '</option>';
            }
        }
        html += '</select>';
        return html;
    }

    String drawInterestCategoryDropDown(int n, Player player) {
        String html =
            "<select id = 'interestCategory$n${player.id}' name='interestCategory$n${player.id}'>";
        for (InterestCategory ic in InterestManager.allCategories) {
            if (player.interestedInCategory(ic)) {
                html += '<option  selected = "selected" value="' +
                    ic.name +
                    '">' +
                    ic.name +
                    '</option>';
            } else {
                html += '<option value="' + ic.name + '">' + ic.name + '</option>';
            }
        }
        html += '</select>';
        return html;
    }

    dynamic drawOneFavoriteNumberDropDown(Player player) {
        String html =
            "<select id = 'favoriteNumberID${player.id}' name='favoriteNumber${player.id}'>";
        for (int i = 0; i <= 12; i++) {
            if (player.quirk.favoriteNumber == i) {
                html += '<option  selected = "selected" value="$i">$i</option>';
            } else {
                html += '<option value="$i">$i</option>';
            }
        }
        html += '</select>';
        return html;
    }

    dynamic drawOneHornDropDown(Player player, bool left) {
        String side = "right";
        if (left) side = "left";
        num horn = player.rightHorn;
        if (left) horn = player.rightHorn;
        String html =
            "<select id = '${side}HornID${player.id}' name='${side}Horn${player.id}'>";
        for (int i = 1; i <= Player.maxHornNumber; i++) {
            if (horn == i) {
                html += '<option  selected = "selected" value="$i">$i</option>';
            } else {
                html += '<option value="$i">$i</option>';
            }
        }

        int maxCustomHorns = 0; //kr wants no shitty horns widely available
        for (int i = 255; i > 255 - maxCustomHorns; i += -1) {
            ;
            if (horn == i) {
                html += '<option  selected = "selected" value=""$i">$i</option>';
            } else {
                html += '<option value="$i">$i</option>';
            }
        }

        //another for loop of "non-canon" horns you can choose but aren't part of main sim.
        html += '</select>';
        return html;
    }

    dynamic drawOneClassDropDown(Player player) {
        List<SBURBClass> available_classes = SBURBClassManager.all.toList();
        String html =
            "<select id = 'classNameID${player.id}' name='className${player.id}'>";
        for (int i = 0; i < available_classes.length; i++) {
            if (available_classes[i] == player.class_name) {
                html +=
                '<option  selected = "selected" value="${available_classes[i].name}">${available_classes[i].name}</option>';
            } else {
                html +=
                '<option value="${available_classes[i].name}">${available_classes[i]}</option>';
            }
        }
        html += '</select>';
        return html;
    }

    dynamic drawOneMoonDropDown(Player player) {
        String html = "<select style = 'background: " +
            moonToColor(player.moon) +
            "' id = 'moonID${player.id}' name='moon${player.id}'>";
        for (int i = 0; i < moons.length; i++) {
            if (moons[i] == player.moon) {
                html += '<option style="background:' +
                    moonToColor(moons[i]) +
                    '" selected = "moon" value="' +
                    moons[i] +
                    '">' +
                    moons[i] +
                    '</option>';
            } else {
                html += '<option style="background:' +
                    moonToColor(moons[i]) +
                    '" value="' +
                    moons[i] +
                    '">' +
                    moons[i] +
                    '</option>';
            }
        }
        html += '</select> ';
        return html;
    }

    dynamic drawOneSpeciesDropDown(Player player) {
        var species = ["Human", "Troll"];
        String html =
            "<select id = 'speciesID${player.id}' name='species${player.id}'>";
        for (int i = 0; i < species.length; i++) {
            if ((species[i] == "Troll" && player.isTroll) ||
                (species[i] == "Human" && !player.isTroll)) {
                html += '<option  selected = "species" value="' +
                    species[i] +
                    '">' +
                    species[i] +
                    '</option>';
            } else {
                html +=
                    '<option value="' + species[i] + '">' + species[i] + '</option>';
            }
        }
        html += '</select>';
        return html;
    }

    dynamic drawOneHairColorPicker(Player player) {
        String id = "hairColorID${player.id}";
        String html = "<input id = '" +
            id +
            "' type='color' name='favcolor' value='" +
            player.hairColor +
            "'>";
        return html;
    }

    dynamic drawOneHairColorDropDownOLD(Player player) {
        String html =
            "<select id = 'hairColorID${player.id}' name='hairColor${player.id}'>";
        for (int i = 0; i < human_hair_colors.length; i++) {
            if (human_hair_colors[i] == player.hairColor) {
                html += '<option style="background:' +
                    human_hair_colors[i] +
                    '" selected = "hairColor" value="' +
                    human_hair_colors[i] +
                    '">' +
                    human_hair_colors[i] +
                    '</option>';
            } else {
                html += '<option style="background:' +
                    human_hair_colors[i] +
                    '"value="' +
                    human_hair_colors[i] +
                    '">' +
                    human_hair_colors[i] +
                    '</option>';
            }
        }
        html += '</select>';
        return html;
    }

    dynamic drawOneBloodColorDropDown(Player player) {
        String html = "<select style='color: black; background:" +
            player.bloodColor +
            "' id = 'bloodColorID${player.id}' name='bloodColor${player.id}'>";
        for (int i = 0; i < bloodColors.length; i++) {
            if (bloodColors[i] == player.bloodColor) {
                html += '<option style="color: black; background:' +
                    bloodColors[i] +
                    '" selected = "bloodColor" value="' +
                    bloodColors[i] +
                    '">' +
                    bloodColors[i] +
                    '</option>';
            } else {
                html += '<option style="color: black; background:' +
                    bloodColors[i] +
                    '"value="' +
                    bloodColors[i] +
                    '">' +
                    bloodColors[i] +
                    '</option>';
            }
        }
        html += '</select>';
        return html;
    }

    dynamic drawOneAspectDropDown(Player player) {
        List<Aspect> available_aspects = Aspects.all.toList();
        String html =
            "<select class = 'selectDiv' id = 'aspectID${player.id}' name='aspect${player.id}'>";
        for (int i = 0; i < available_aspects.length; i++) {
            if (available_aspects[i] == player.aspect) {
                html += '<option selected = "selected" value="' +
                    available_aspects[i].name +
                    '" >' +
                    available_aspects[i].name +
                    '</option>';
            } else {
                html += '<option value="${available_aspects[i].name}" >' +
                    available_aspects[i].name +
                    '</option>';
            }
        }
        html += '</select>';
        return html;
    }
}
