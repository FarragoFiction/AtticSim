import "Item.dart";
import "Controller.dart";
import "Actions/Go.dart";
import "Player.dart";
class Room extends Item{


    List<Item> contents;

    //obvious exits are:
    List<Room> exits;

    Room(String name, List<String> alts, String description,String useDescription, {this.contents: null, this.exits: null}):super(name, alts, description, useDescription) {
        if(description == null) description = "perfectly generic";
        if(contents == null) contents = new List<Item>();
        if(exits == null) exits = new List<Room>();
        validActions.add(new Go()); //all rooms can be entered.
    }


    String toString() {
        return name;
    }

    String get fullDescription {
        String ret = "You are in $name. It is $description";
        return ret;
    }

    String get exitsDescription {
        print ("exits");
        String ret = "You are trapped here. It's no good, can't find the exit.";
        if(exits.isNotEmpty) ret = "Obvious exits are: ${Item.turnArrayIntoHumanSentence(exits)}.";
        return ret;
    }

    List<Player> get people {
        List<Player> ret = new List<Player>();
        List<Player> players = Controller.instance.players;
        for(Player p in players) {
            print("is $p in room $this ? I think they are in ${p.currentRoom}");
            if(p.currentRoom == this && p != Controller.instance.currentPlayer) ret.add(p);
        }
        return ret;
    }

    String get itemsDescription {
        print("getting items description");
        String ret = "It is empty.";
        if(contents.isNotEmpty) ret = "You see: ${Item.turnArrayIntoHumanSentence(contents)}.";
        List<Player> peeps = people;
        if(peeps.isNotEmpty && this != Controller.instance.voidRoom) ret += " You wave to: ${Item.turnArrayIntoHumanSentence(peeps)}.";
        //if everybody but shogun and jr are in dennis....then what?
        if(this == Controller.instance.dennis && peeps.length == (Controller.instance.players.length -2)) ret += " It is done. But for what purpose???";
        return ret;
    }
}