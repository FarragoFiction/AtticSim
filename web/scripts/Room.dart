import "Item.dart";
class Room {

    String name;
    String baseDescription;
    List<Item> contents;

    //obvious exits are:
    List<Room> exits;

    Room(this.name, this.baseDescription, {this.contents: null, this.exits: null}) {
        if(contents == null) contents = new List<Item>();
        if(exits == null) exits = new List<Room>();

    }

    String turnArrayIntoHumanSentence(List<dynamic> retArray) {
        return [retArray.sublist(0, retArray.length - 1).join(', '), retArray.last].join(retArray.length < 2 ? '' : ' and ');
    }

    String toString() {
        return name;
    }

    String get description {
        String ret = "You are in $name. It is $baseDescription";

        if(contents.isNotEmpty) ret = "$ret You see: ${turnArrayIntoHumanSentence(contents)}.";
        if(exits.isNotEmpty) ret = "$ret Obvious exits are: ${turnArrayIntoHumanSentence(exits)}.";


        return ret;
    }
}