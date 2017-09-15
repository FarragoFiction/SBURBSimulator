import "SBURBSim.dart";


//can be positive or negative. if high enough, can
//turn into romance in a quadrant.
class Relationship {
    Player source;
    num value = 0;
    Player _target;
    String saved_type = "";
    bool drama = false; //drama is set to true if type of relationship changes.
    String old_type = ""; //wish class variables were a thing.
    String neutral = "Ambivalent";
    String goodMild = "Friends";
    String goodBig = "Totally In Love";
    String badMild = "Rivals";
    String badBig = "Enemies";
    String heart = "Matesprits";
    String diamond = "Moirallegiance";
    String clubs = "Auspisticism";
    String spades = "Kismesissitude";


    Relationship(Player this.source, [num this.value = 0, Player this._target = null]) {
        type(); //check to see if it's a crush or not
    }

    //target has to be private if light player can override it. this lets code still do .target, but not .target =
    Player get target {
        if(curSessionGlobalVar.mutator.lightField && curSessionGlobalVar.mutator.inSpotLight != null) {
            Player megalomaniac =  curSessionGlobalVar.mutator.inSpotLight;
            if(source != megalomaniac) return megalomaniac; //don't be in a relationship with your self.
        }
        return _target;
    }

    void setTarget(Player target) {
        _target = target;
    }


    String nounDescription() {
        if (this.saved_type == this.diamond) return "moirail";
        if (this.saved_type == this.goodBig) return "crush";
        if (this.saved_type == this.badBig) return "black crush";
        if (this.saved_type == this.badMild) return "rival";
        if (this.saved_type == this.goodMild) return "friend";
        if (this.saved_type == this.clubs) return "auspistice";
        if (this.saved_type == this.spades) return "kismesis";
        if (this.saved_type == this.neutral) return "friend";
        return "friend";
    }

    String asciiDescription([Player shipper = null]){
        Relationship r = this;
        if(r.saved_type ==  r.heart){
            return "<font color = 'red'>&#x2665</font>";
        }

        if(r.saved_type ==  r.spades){
            return "<font color = 'black'>&#x2660</font>";
        }

        if(r.saved_type ==  r.clubs){
            return "<font color = 'grey'>&#x2663</font>";
        }

        if(r.saved_type ==  r.diamond){
            return "<font color = 'pink'>&#x2666</font>";
        }

        if(r.saved_type ==  r.neutral){
            return "<font color = 'black'>0_0</font>";
        }

        //since these are speculative, player will assume it's gonna end up their favorite quadrant half
        if(r.saved_type ==  r.goodBig){
            if(shipper != null && shipper.aspect == Aspects.HEART){
                return "<font color = 'red'>&#x2661</font>";
            }else{
                return "<font color = 'red'>&#x2662</font>" ;//i assume you are gonna end up as diamonds;
            }

        }

        if(r.saved_type ==  r.badBig){
            if(shipper != null && shipper.aspect == Aspects.HEART){
                return "<font color = 'black'>&#x2664</font>";
            }else{
                return "<font color = 'black'>&#x2667</font>" ;//i assume you are gonna end up as clubs;
            }

        }

        if(r.saved_type ==  r.goodMild){
            return "<font color = 'black'>&#x263A</font>";
        }

        if(r.saved_type ==  r.badMild){
            return "<font color = 'black'>&#x2639</font>";
        }
        return r.saved_type;
    }

    String toString() {
        return " ${asciiDescription()}(${value.round()}) ${_target.title()}";
    }

    String changeType() {
        if (this.value > 20) { //used to be -10 to 10, but too many crushes.
            return this.goodBig;
        } else if (this.value < -20) { //need to calibrate scandalous fuck piles.
            return this.badBig;
        } else if (this.value > 0) {
            return this.goodMild;
        } else if (this.value == 0) {
            return this.neutral;
        } else {
            return this.badMild;
        }
    }

    void moreOfSame() {
        if (this.value >= 0) {
            this.increase();
        } else {
            this.decrease();
        }
    }

    void increase() {
        this.value ++;
    }

    void decrease() {
        this.value += -1;
    }

    void setOfficialRomance(String type) {
        //don't generate any extra drama, the event that led to this was ALREADY drama.
        this.saved_type = type;
        this.old_type = type;
    }

    String type() {
        //official relationships are different.
        if (this.saved_type == this.heart || this.saved_type == this.spades || this.saved_type == this.diamond || this.saved_type == this.clubs) {
            return this.saved_type; //break up in own scene, not here.
        }
        if (this.saved_type == "") {
            this.drama = false;
            this.saved_type = this.changeType();
            this.old_type = this.saved_type;
            //if it's big drama, you can have your scene
            if (this.saved_type == this.goodBig || this.saved_type == this.badBig) {
                this.drama = true;
                this.old_type = this.goodMild;
            }
            return this.saved_type;
        }

        if (this.source.session.rand.nextDouble() > 0.25) {
            //enter or leave a relationship, or vaccilate.
            this.old_type = this.saved_type;
            this.saved_type = this.changeType();
        }

        if (this.old_type != this.saved_type) {
            this.drama = true;
        } else {
            this.drama = false;
        }
        return this.saved_type;
    }

    String description() {
        return "${this.saved_type} with the ${this._target.htmlTitle()}";
    }


    static String getRelationshipFlavorGreeting(Relationship r1, Relationship r2, Player me, Player you) {
        if (r1.type() == r1.goodBig && r2.type() == r2.goodBig) {
            return " Hey! ";
        } else if (r2.type() == r2.goodBig) {
            return "Hey.";
        } else if (r1.type() == r1.goodBig) {
            return " Uh, hey!";
        } else if (r1.type() == r1.badBig && r2.type() == r2.badBig) {
            return " Hey, asshole.";
        } else if (r2.type() == r2.badBig) {
            return "Er...hey?";
        } else if (r1.type() == r2.badBig) {
            return "I'll make this quick. ";
        } else {
            return "Hey.";
        }
    }


    static String getRelationshipFlavorText(Relationship r1, Relationship r2, Player me, Player you) {
        if (r1.type() == r1.goodBig && r2.type() == r2.goodBig || r1.type == r1.heart) {
            return " The two flirt a bit. ";
        }
        if (r1.type() == r1.diamond) {
            ////print("impromptu feelings jam: " + this.session.session_id);
            me.addStat(Stats.SANITY, 1);
            you.addStat(Stats.SANITY, 1);
            return " The two have an impromptu feelings jam. ";
        } else if (r2.type() == r2.goodBig) {
            return " The ${you.htmlTitle()} is flustered around the ${me.htmlTitle()}. ";
        } else if (r1.type() == r1.goodBig) {
            return " The ${me.htmlTitle()} is flustered around the ${you.htmlTitle()}. ";
        } else if (r1.type() == r1.badBig && r2.type() == r2.badBig || r1.type == r1.spades) {
            return " The two are just giant assholes to each other. ";
        } else if (r2.type() == r2.badBig) {
            return " The ${you.htmlTitle()} is irritable around the ${me.htmlTitle()}. ";
        } else if (r1.type() == r2.badBig) {
            return " The ${me.htmlTitle()} is irritable around the ${you.htmlTitle()}. ";
        }
        return "";
    }


    //TODO if i remember right, this is used for alien players. how does Dart handle list of vars again? oh. it doesn't.
    //is it reflection only?
    static Relationship cloneRelationship(Relationship relationship) {
        Relationship clone = new Relationship(relationship.source);
        clone.value = relationship.value;
        clone.setTarget(relationship.target);
        clone.saved_type = relationship.saved_type;
        clone.drama = relationship.drama; //drama is set to true if type of relationship changes.
        clone.old_type = relationship.old_type; //wish class variables were a thing.
        return clone;
    }


//when i am cloning players, i need to make sure they don't have a reference to the same relationships the original player does.
//if i fail to do this step, i accidentally give the players the Capgras delusion.
//this HAS to happen before transferFeelingsToClones.
    static List<Relationship> cloneRelationshipsStopgap(List<Relationship> relationships) {
        ////print("clone relationships stopgap");
        List<Relationship> ret = <Relationship>[];
        for (num i = 0; i < relationships.length; i++) {
            Relationship r = relationships[i];
            ret.add(cloneRelationship(r));
        }
        return ret;
    }


//when i clone alien players on arival, i need their cloned relationships to be about the other clones
//not the original players.
//also, I <3 this method name. i <3 this sim.
    static void transferFeelingsToClones(Player player, List<Player> clones) {
        ////print("transfer feelings to clones");
        for (int i = 0; i < player.relationships.length; i++) {
            Relationship r = player.relationships[i];
            Player clone = findClaspectPlayer(clones, r.target.class_name, r.target.aspect);
            //if i can't find a clone, it's probably a dead player that didn't come to the new session.
            //may as well keep the original relationship
            if (clone != null) {
                r.setTarget(clone);
            }
        }
    }


    static void makeHeart(Player player1, Player player2) {
        player1.session.stats.hasHearts = true;
        if(player1.session.mutator.lightField) {
            player1 = player1.session.mutator.inSpotLight;
            player2 = player1.session.mutator.inSpotLight;
        }
        Relationship r1 = player1.getRelationshipWith(player2);
        r1.setOfficialRomance(r1.heart);
        Relationship r2 = player2.getRelationshipWith(player1);
        r2.setOfficialRomance(r2.heart);
    }


    static void makeSpades(Player player1, Player player2) {
        player1.session.stats.hasSpades = true;
        if(player1.session.mutator.lightField) {
            player1 = player1.session.mutator.inSpotLight;
            player2 = player1.session.mutator.inSpotLight;
        }
        Relationship r1 = player1.getRelationshipWith(player2);
        r1.setOfficialRomance(r1.spades);
        Relationship r2 = player2.getRelationshipWith(player1);
        r2.setOfficialRomance(r2.spades);
    }


    static void makeDiamonds(Player player1, Player player2) {
        player1.session.stats.hasDiamonds = true;
        if(player1.session.mutator.lightField) {
            player1 = player1.session.mutator.inSpotLight;
            player2 = player1.session.mutator.inSpotLight;
        }
        Relationship r1 = player1.getRelationshipWith(player2);
        if (r1.value < 0) {
            r1.value = 1; //like you at least a little
        }
        r1.setOfficialRomance(r1.diamond);
        Relationship r2 = player2.getRelationshipWith(player1);
        if (r2.value < 0) {
            r2.value = 1;
        }
        r2.setOfficialRomance(r2.diamond);
    }


//clubs, why you so cray cray?
    static void makeClubs(Player middleLeaf, Player asshole1, Player asshole2) {
        asshole1.session.stats.hasClubs = true;
        if(middleLeaf.session.mutator.lightField) {
            middleLeaf = middleLeaf.session.mutator.inSpotLight;
            asshole1 = middleLeaf.session.mutator.inSpotLight;
            asshole2 = middleLeaf.session.mutator.inSpotLight;
        }
        Relationship rmid1 = middleLeaf.getRelationshipWith(asshole1);
        Relationship rmid2 = middleLeaf.getRelationshipWith(asshole2);

        Relationship rass1mid = asshole1.getRelationshipWith(middleLeaf);
        Relationship rass12 = asshole1.getRelationshipWith(asshole2);

        Relationship rass2mid = asshole2.getRelationshipWith(middleLeaf);
        Relationship rass21 = asshole2.getRelationshipWith(asshole1);

        if (rmid1.value > 0) {
            rmid1.value = -1; //hate you at least a little
        }

        if (rmid2.value > 0) {
            rmid2.value = -1; //hate you at least a little
        }

        rmid1.setOfficialRomance(rmid1.clubs);
        rmid2.setOfficialRomance(rmid1.clubs);
        rass1mid.setOfficialRomance(rmid1.clubs);
        rass12.setOfficialRomance(rmid1.clubs);
        rass2mid.setOfficialRomance(rmid1.clubs);
        rass21.setOfficialRomance(rmid1.clubs);
    }


    static Relationship randomBlandRelationship(Player source, Player targetPlayer) {
        return new Relationship(source, 1, targetPlayer);
    }



    static dynamic randomRelationship(Player source, Player targetPlayer) {
        if(source.session.mutator.heartField) {
            source.session.logger.info("heart field active");
            return new Relationship(source, 333, targetPlayer); //all ships canon!!!
        }else if(source.session.mutator.bloodField) {
            return new Relationship(source, 10, targetPlayer); //everyone gets along, but not necessarily romantic
        }else if(source.session.mutator.rageField) {
            Relationship r =  new Relationship(source, -1313, targetPlayer); //holy shit i hate that guy.
            r.saved_type = r.badBig; //stop trying to kiss us and KILL us you asshole.
            r.old_type = r.saved_type; //srsly
            r.drama = false;
            return r;
        }
        return new Relationship(source, source.session.rand.nextIntRange(-21, 22), targetPlayer);
       // return  new Relationship(source, 10000000, targetPlayer);;
    }


//go through every pair of relationships. if both have same type AND they are lucky, be in quadrant.   (clover was VERY 'lucky' in love.)
//high is flushed or pale (if one player much more triggered than other). low is spades. no clubs for now.
//yes, claspect boosts might alter relationships from 'initial' value, but that just means they characters are likelyt o break up. realism.
    static void decideInitialQuadrants(Random rand, List<Player> players) {
        num rollNeeded = 5;
        for (int i = 0; i < players.length; i++) {
            Player player = players[i];
            List<Relationship> relationships = player.relationships;
            for (num j = 0; j < relationships.length; j++) {
                Relationship r = relationships[j];
                num roll = player.rollForLuck();
                if (roll > rollNeeded) {
                    if (r.type() == r.goodBig) {
                        //player.session.logger.info("AB:initial diamond/heart");
                        num difference = (player.getStat(Stats.SANITY) - r.target.getStat(Stats.SANITY)).abs();
                        if (difference > 2 || roll < rollNeeded ) { //pale
                            makeDiamonds(player, r.target);
                        } else {
                            makeHeart(player, r.target);
                        }
                    } else if (r.type() == r.badBig) {
                        //player.session.logger.info("AB: initial club/spades");
                        if (player.getStat(Stats.SANITY) > 0 || r.target.getStat(Stats.SANITY) > 0 || roll < rollNeeded) { //likely to murder each other
                            Player ausp = rand.pickFrom(players);
                            if (ausp != null && ausp != player && ausp != r.target) {
                                makeClubs(ausp, player, r.target);
                            }
                        } else {
                            makeSpades(player, r.target);
                        }
                    }
                }
            }
        }
    }


}


