import "Item.dart";
import "Controller.dart";
class Room extends Item{


    List<Item> contents;

    //obvious exits are:
    List<Room> exits;

    Room(String name, List<String> alts, String description, {this.contents: null, this.exits: null}):super(name, alts, description) {
        if(description == null) description = "perfectly generic";
        if(contents == null) contents = new List<Item>();
        if(exits == null) exits = new List<Room>();
    }



    String turnArrayIntoHumanSentence(List<dynamic> retArray) {
        return [retArray.sublist(0, retArray.length - 1).join(', '), retArray.last].join(retArray.length < 2 ? '' : ' and ');
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
        if(exits.isNotEmpty) ret = "Obvious exits are: ${turnArrayIntoHumanSentence(exits)}.";
        return ret;
    }

    String get itemsDescription {
        String ret = "It is empty.";
        if(contents.isNotEmpty) ret = "You see: ${turnArrayIntoHumanSentence(contents)}.";
        return ret;
    }
}