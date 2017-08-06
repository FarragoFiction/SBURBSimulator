import "SBURBSim.dart";


//can be positive or negative. if high enough, can
//turn into romance in a quadrant.
class Relationship {
    Player source;
    num value;
    Player target;
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


    Relationship(Player this.source, [num this.value = 0, Player this.target = null]) {
        type(); //check to see if it's a crush or not
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
        return "${this.saved_type} with the ${this.target.htmlTitle()}";
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
            //print("impromptu feelings jam: " + this.session.session_id);
            me.addStat("sanity", 1);
            you.addStat("sanity", 1);
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
        clone.target = relationship.target;
        clone.saved_type = relationship.saved_type;
        clone.drama = relationship.drama; //drama is set to true if type of relationship changes.
        clone.old_type = relationship.old_type; //wish class variables were a thing.
        return clone;
    }


//when i am cloning players, i need to make sure they don't have a reference to the same relationships the original player does.
//if i fail to do this step, i accidentally give the players the Capgras delusion.
//this HAS to happen before transferFeelingsToClones.
    static List<Relationship> cloneRelationshipsStopgap(List<Relationship> relationships) {
        //print("clone relationships stopgap");
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
        //print("transfer feelings to clones");
        for (int i = 0; i < player.relationships.length; i++) {
            Relationship r = player.relationships[i];
            Player clone = findClaspectPlayer(clones, r.target.class_name, r.target.aspect);
            //if i can't find a clone, it's probably a dead player that didn't come to the new session.
            //may as well keep the original relationship
            if (clone != null) {
                r.target = clone;
            }
        }
    }


    static void makeHeart(Player player1, Player player2) {
        player1.session.hasHearts = true;
        Relationship r1 = player1.getRelationshipWith(player2);
        r1.setOfficialRomance(r1.heart);
        Relationship r2 = player2.getRelationshipWith(player1);
        r2.setOfficialRomance(r2.heart);
    }


    static void makeSpades(Player player1, Player player2) {
        player1.session.hasSpades = true;
        Relationship r1 = player1.getRelationshipWith(player2);
        r1.setOfficialRomance(r1.spades);
        Relationship r2 = player2.getRelationshipWith(player1);
        r2.setOfficialRomance(r2.spades);
    }


    static void makeDiamonds(Player player1, Player player2) {
        player1.session.hasDiamonds = true;
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
        asshole1.session.hasClubs = true;
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
        Relationship r = new Relationship(source, source.session.rand.nextIntRange(-21, 21), targetPlayer);

        return r;
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
                        print("initial diamond/heart");
                        num difference = (player.getStat("sanity") - r.target.getStat("sanity")).abs();
                        if (difference > 2 || roll < rollNeeded + 5) { //pale
                            makeDiamonds(player, r.target);
                        } else {
                            makeHeart(player, r.target);
                        }
                    } else if (r.type() == r.badBig) {
                        print("initial club/spades");
                        if (player.getStat("sanity") > 0 || r.target.getStat("sanity") > 0 || roll < rollNeeded + 5) { //likely to murder each other
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


