function UpdateShippingGrid(session){
	this.canRepeat = true;
	this.session = session;

	this.trigger = function(){
		return false;
	}


	this.renderContent = function(div){
		div.append("<br>");
		div.append(this.content());
	}







	this.content = function(){
		return "todo: update shipping grid for heart player.  updating it lowers the trigger level of al involved.";

	}
}
