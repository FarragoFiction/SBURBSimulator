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
		var divId =  player.title()+player.chatHandle;
		var canvasHTML = "<canvas id='canvas" +divId + "' width='" +400 + "' height="+300 + "'>  </canvas>";
		this.div.append(canvasHTML);
		var canvas = document.getElementById("canvas"+ divId);
		drawSinglePlayer(canvas, player);
	}

}
