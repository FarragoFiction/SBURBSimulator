import "dart:html";
import "../SBURBSim.dart";


class GoGrimDark extends Scene {
		List<Player> playerList = [];  //what players are already in the medium when i trigger?
	Player player = null;


	GoGrimDark(Session session): super(session);

	@override
	bool trigger(playerList){
		this.playerList = playerList;
		this.player = null;
		//select a random player. if they've been triggered, random chance of going grim dark (based on how triggered.)
		for(num i = 0; i< this.playerList.length; i++){//never, EVER fix this to be available players.  corpses shouldu ALWAYS be able to go grim dark, this is HILARIOUS
			var p = this.playerList[i];
			if(this.corruptionReachedTippingPoint(p)){
				this.player = p;
				return true;
			}
		}
		return false;
	}

	bool corruptionReachedTippingPoint(Player p){
		int x = -10; //change this to calibrate things. negative means less chance of grim dark
		return p.corruptionLevelOther >= 50-(p.grimDark*11)*x; //at level 4, only need 10*x more points. at level 1, need 40*x;
	}

	dynamic addImportantEvent(){
		var current_mvp = findStrongestPlayer(this.session.players);
		return this.session.addImportantEvent(new PlayerWentGrimDark(this.session, current_mvp.getStat(Stats.POWER),this.player,null) );
	}

	@override
	void renderContent(Element div){
		var alt = this.addImportantEvent();
		if(alt != null && alt.alternateScene(div)){
			return;
		}
    appendHtml(div,"<br><img src = 'images/sceneIcons/grimdark_black_icon.png'>"+this.content());
		if(this.player.grimDark ==4){
			var divID = div.id + "grimdark";
			String canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth.toString() + "' height="+canvasHeight.toString() + "'>  </canvas>";
      appendHtml(div,canvasHTML);
			var canvasDiv = querySelector("#canvas"+ divID);
			Drawing.drawSinglePlayer(canvasDiv, this.player);
		}
	}
	dynamic raiseGrimDarkLevel(){
			this.player.changeGrimDark(1);  //this SHOULD be the only way to modify grim dark level upwards
			this.player.corruptionLevelOther = 0; //reset corruption level
			String ret = "";
			if(this.player.grimDark == 1){
				ret += " The " + this.player.htmlTitle() + " is starting to seem a little strange. They sure do like talking about Horrorterrors!";
			}else if(this.player.grimDark == 2){
				this.session.stats.grimDarkPlayers = true;
				this.player.nullAllRelationships();
				ret += " The " + this.player.htmlTitleBasic() + " isn't responding to chat messages much anymore. ";
			}else if(this.player.grimDark == 3){
				this.player.increasePower(3);
				ret += " The " + this.player.htmlTitleBasic() + " will tell anyone who will listen that the game needs to be broken. ";
			}else if(this.player.grimDark == 4){
				//session.logger.info("full grim dark: " + this.session.session_id.toString());
				//alert("full grim dark: " + this.session.session_id);
				this.player.increasePower(6);
				ret +=  "The " + this.player.htmlTitleBasic() + " slips into the fabled blackdeath trance of the woegothics, quaking all the while in the bloodeldritch throes of the broodfester tongues.";
				ret += " It is now painfully obvious to anyone with a brain, they have basically gone completely off the deep end in every way. The ";
				ret += this.player.htmlTitle() + " has officially gone grimdark. <span class = 'void'>They are not from here</span> ";
				var f = new Fraymotif(Zalgo.generate("The Broodfester Tongues"), 3);
				f.effects.add(new FraymotifEffect(Stats.POWER,3,true));
				f.effects.add(new FraymotifEffect(Stats.POWER,0,false));
				f.desc = " They are stubborn throes. ";
				this.player.fraymotifs.add(f);
				ret +=" They learn " + f.name + ". " ;
			}
			return ret;
	}
	dynamic content(){

		this.player.increasePower();
		//removeFromArray(this.player, this.session.availablePlayers); going grimDark is a free action.
		var ret = this.raiseGrimDarkLevel();
		return ret;
	}

}
