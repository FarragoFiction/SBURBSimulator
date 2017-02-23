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
		var repeatTime = 1000;
		var canvasHTML = "<br><canvas id='canvas" + (div.attr("id")) +"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		var spriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
		debug(" Need to render different non-godtier outfits. Use favorite number, just like wings. Will never see that wings and outfits pair, cause wings are only with godtier");
		drawSprite(spriteBuffer,this.player,repeatTime)
		//give sprite time to draw, don't try to grab it right away.
		setTimeout(function(){
			copyTmpCanvasToRealCanvasAtPos(document.getElementById("canvas"+ (div.attr("id"))), spriteBuffer,-100,0)
		}, repeatTime);  //images aren't always loaded by the time i try to draw them the first time.
	}
	
	//make a pesterchum skin and stick text into it. How much can I fit?
	this.chat = function(div){
		
	}
	
	//i is so you know entry order
	this.content = function(div,i){
		var narration = "<br>The " + this.player.htmlTitle() + " enters the game " + indexToWords(i) + ". ";
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
