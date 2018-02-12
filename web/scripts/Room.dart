import "Item.dart";
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

        if(contents.isNotEmpty) ret = "$ret You see: ${turnArrayIntoHumanSentence(contents)}.";
        if(exits.isNotEmpty) ret = "$ret Obvious exits are: ${turnArrayIntoHumanSentence(exits)}.";


        return ret;
    }
}