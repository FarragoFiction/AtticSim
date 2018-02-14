import "Item.dart";
import "Controller.dart";
import "Actions/Go.dart";
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

    String get itemsDescription {
        String ret = "It is empty.";
        if(contents.isNotEmpty) ret = "You see: ${Item.turnArrayIntoHumanSentence(contents)}.";
        return ret;
    }
}