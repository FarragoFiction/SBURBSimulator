import "dart:html";
import "../SBURBSim.dart";


class PowerDemocracy extends Scene{




	PowerDemocracy(Session session): super(session);

	@override
	bool trigger(playerList){
		this.playerList = playerList;
		return (this.session.democraticArmy.getStat("power") != GameEntity.minPower);
	}

	@override
	void renderContent(Element div){
    appendHtml(div,"<br><img src = 'images/sceneIcons/wv_icon.png'>"+this.content());
	}
	dynamic content(){
		String ret = "";
		double r = rand.nextDouble();
		if(r < .25){
			ret += rand.pickFrom(democracyTasks);
			this.session.democraticArmy.addStat("power", 10);
			this.session.democraticArmy.addStat("mobility", 10);
			this.session.democraticArmy.addStat("currentHP", 10);
		}else if(r < .5){
			ret += rand.pickFrom(democracyTasks);
      this.session.democraticArmy.addStat("power", 20);
      this.session.democraticArmy.addStat("mobility", 20);
      this.session.democraticArmy.addStat("currentHP", 20);
		}else if(r < .75){
			ret += rand.pickFrom(democracySuperTasks);
      this.session.democraticArmy.addStat("power", 50);
      this.session.democraticArmy.addStat("mobility", 50);
      this.session.democraticArmy.addStat("currentHP", 50);
		}else{
			//do nothing.
			ret += rand.pickFrom(mayorDistractionTasks);
		}
		return ret;
	}

}
