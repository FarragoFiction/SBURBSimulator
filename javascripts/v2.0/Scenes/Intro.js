function Intro(){
	this.canRepeat = false;	
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.player = null;
	this.trigger = function(playerList, player){
		this.playerList = playerList;
		this.player = player;
		return true; //this should never be in the main array. call manually.
	}
	
	//draw sprite in it's entirety to a virtual canvas first. 
	//then make a real canvas and render it to it. 
	this.draw  = function(div){
		var canvasHTML = "<canvas id='canvas" + (div.attr("id")) +"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		var spriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
		drawSprite(spriteBuffer,this.player)
	}
	
	//make a pesterchum skin and stick text into it. How much can I fit?
	this.chat = function(div){
		
	}
	
	//i is so you know entry order
	this.content = function(div,i){
		var narration = "The " + this.player.htmlTitle() + " enters the game " + indexToWords(i) + ". ";
		if(this.player.leader){
			narration += "They are definitely the leader.";
		}
		if(this.player.godDestiny){
			narration += " They appear to be destined for greatness. ";
		}
		narration += " They boggle vacantly at the " + this.player.land + ". ";
		
		for(var j = 0; j<this.player.relationships.length; j++){
			var r = this.player.relationships[j];
			if(r.type() != "Friends" && r.type() != "Rivals"){
				narration += "They are " + r.description() + ". ";
			}
		}
		div.append(narration);
		this.draw(div);
	}
}
