function ExileJack(session){
	this.canRepeat = false;
	this.session = session;
	this.playerList = [];  //what players are already in the medium when i trigger?

	this.trigger = function(playerList){
		this.playerList = playerList;
		return (this.session.jack.getPower() < 10) && (this.session.jack.getHP() >  0 && this.session.jack.crowned == null);
	}

	this.renderContent = function(div){
		div.append("<br>"+this.content());
	}

	this.content = function(){
		this.session.jack.hp = 0; //effectively dead.
		var ret = " The plan has been performed flawlessly.  Jack has been exiled to the post-Apocalyptic version of Earth before he can cause too much damage.";
		return ret;
	}
}
