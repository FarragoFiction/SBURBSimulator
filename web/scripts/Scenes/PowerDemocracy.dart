import "dart:html";
import "../SBURBSim.dart";


class PowerDemocracy extends Scene{




	PowerDemocracy(Session session): super(session);

	@override
	bool trigger(playerList){
		this.playerList = playerList;
		return (this.session.npcHandler.democraticArmy.stats.getBase(Stats.POWER) > 0);
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
			this.session.npcHandler.democraticArmy.addStat(Stats.POWER, 10);
			this.session.npcHandler.democraticArmy.addStat(Stats.MOBILITY, 10);
			this.session.npcHandler.democraticArmy.addStat(Stats.CURRENT_HEALTH, 10);
		}else if(r < .5){
			ret += rand.pickFrom(democracyTasks);
      this.session.npcHandler.democraticArmy.addStat(Stats.POWER, 20);
      this.session.npcHandler.democraticArmy.addStat(Stats.MOBILITY, 20);
      this.session.npcHandler.democraticArmy.addStat(Stats.CURRENT_HEALTH, 20);
		}else if(r < .75){
			ret += rand.pickFrom(democracySuperTasks);
      this.session.npcHandler.democraticArmy.addStat(Stats.POWER, 50);
      this.session.npcHandler.democraticArmy.addStat(Stats.MOBILITY, 50);
      this.session.npcHandler.democraticArmy.addStat(Stats.CURRENT_HEALTH, 50);
		}else{
			//do nothing.
			ret += rand.pickFrom(mayorDistractionTasks);
		}
		return ret;
	}

}
