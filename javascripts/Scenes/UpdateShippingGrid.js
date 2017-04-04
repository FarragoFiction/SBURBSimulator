function UpdateShippingGrid(session){
	this.canRepeat = true;
	this.session = session;
	this.heartPlayer = null;
	this.ships = [];
	this.savedShipText = "";

	//is there relationship drama!?
	this.trigger = function(){
		if(this.ships.length == 0){
			this.createShips();
		}
		this.heartPlayer = findAspectPlayer(this.session.availablePlayers, "Heart");
		if(!this.heartPlayer || this.heartPlayer.dead){
			return false;
		}
		var newShips = this.printShips(this.getGoodShips())
		if(newShips != this.savedShipText){
			this.savedShipText = newShips;
			return true;
		}
		return false;
	}


	this.renderContent = function(div){
		div.append("<br>");
		div.append(this.content());
	}

	//for all players, look at all relationships. if goodBig or badBig, return.
	//also grab clubs and diamonds. later.
	this.createShips = function(){
		//console.log("creating ships")
			for(var i = 0; i<this.session.players.length; i++){

				var player = this.session.players[i];
				//console.log("making ships for: " + player.title())

				for(var j = 0; j<player.relationships.length; j++){
					var r1 = player.relationships[j];
					var r2 = r1.target.getRelationshipWith(player);
					//console.log("made new ship")
					this.ships.push(new Ship(r1, r2))
				}
			}
				var toRemove = [];
				//get rid of equal ships
				for(var i = 0; i<this.ships.length-1; i++){
					var firstShip = this.ships[i];
					//second loop starts at i because i know i checked first ship no ships already, and second ship agains 1 ship
					for(var j= (i+1); j<this.ships.length; j++){
						var secondShip = this.ships[j];
							if(firstShip.isEqualToShip(secondShip)){
								//console.log("pushing to remove")
								toRemove.push(secondShip);
							}
					}
				}
				//console.log("this many to remove: " + toRemove.length)
				for(var i = 0; i<toRemove.length; i++){
						removeFromArray(toRemove[i], this.ships)
				}

	}

	this.getGoodShips = function(){
		var ret = [];
		for(var i = 0; i<this.ships.length; i++){
			var ship = this.ships[i];
			if(ship.isGoodShip()){
				ret.push(ship);
			}
		}
		return ret;
	}

	this.printShips = function(ships){
		return(ships.map(function(e){
			return e.toString();
		}).join("\n<br>"));
	}

	this.printAllShips = function(){
		return this.printShips(this.ships);
	}
	
	this.RelationshipTypeToText = function(r){
		if(r.saved_type =  r.heart){
			return "<font color = 'red'>&#x2665</font>"
		}
		
		if(r.saved_type =  r.spade){
			return "<font color = 'black'>&#x2660</font>"
		}
		
		if(r.saved_type =  r.clubs){
			return "<font color = 'grey'>&#x2663</font>"
		}
		
		if(r.saved_type =  r.diamonds){
			return "<font color = 'pink'>&#x2666</font>"
		}
		return r.saved_type;
	}
	


	this.content = function(){
		//console.log("Updating shipping grid in: " + this.session.session_id);
		removeFromArray(this.heartPlayer, this.session.availablePlayers);
		this.heartPlayer.increasePower();
		return "The " + this.heartPlayer.htmlTitleBasic() + " updates their shipping grid. <Br>" + this.savedShipText;
		//return "todo: update shipping grid for heart player.  updating it lowers the trigger level of all involved.  also, save clubs and diamonds to session. extract ships from it. if a player is in more than one diamonds, erase previous one.";

	}
}



//contains both relationship and it's inverse, knows how to render itself. dead players have a hussie style x over their faces.
//ships can also refuse to render themselves.  return false if that happens.
// render if: r2.saved_type == r2.goodBig || r2.saved_type == r2.badBig
function Ship(r1, r2){
		this.r1 = r1;
		this.r2 = r2;
		
		this.relationshipTypeToText = function(r){
		if(r.saved_type ==  r.heart){
			return "<font color = 'red'>&#x2665</font>"
		}
		
		if(r.saved_type ==  r.spade){
			return "<font color = 'black'>&#x2660</font>"
		}
		
		if(r.saved_type ==  r.clubs){
			return "<font color = 'grey'>&#x2663</font>"
		}
		
		if(r.saved_type ==  r.diamonds){
			return "<font color = 'pink'>&#x2666</font>"
		}
		return r.saved_type;
	}

		//a relationship doesn't know who owns it, just what hte target is,so printing is funny
		this.toString = function(){
			return r2.target.htmlTitleBasic() + " " + this.relationshipTypeToText(r1) + "---" + this.relationshipTypeToText(r2) + " " + r1.target.htmlTitleBasic();
		}
		//order doesn't matter.
		this.isEqualToShip = function(ship){
			//console.log("comparing: " + this.toString() + " to "  + ship.toString())
			if(ship.r1 == this.r1 && ship.r2 == this.r2){
				//console.log("they are the same1")
				return true;
			}else if(ship.r2 == this.r1 && ship.r1 == this.r2){
				//console.log("they are the same2")
				return true;
			}
		//	console.log("they are not the same")
			return false;
		}

		this.isGoodShip = function(){
			if(r2.saved_type == "" || r1.saved_type == "" ){
				return false;
			}
			
			if(r1.saved_type == r1.goodBig || r1.saved_type == r1.badBig || r1.saved_type == r1.heart || r1.saved_type == r1.diamonds || r1.saved_type == r1.spades || r1.saved_type == r1.clubs){
				return true;
			}
			
			if(r2.saved_type == r2.goodBig || r2.saved_type == r1.badBig || r2.saved_type == r1.heart || r2.saved_type == r2.diamonds || r2.saved_type == r2.spades || r2.saved_type == r2.clubs){
				return true;
			}
			return false;
		}

}
