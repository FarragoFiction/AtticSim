import "Item.dart";
import "Room.dart";
import "Controller.dart";
import "Actions/Be.dart";

//a player can do anything an item can do because i said so that's why
class Player extends Item {
    Room currentRoom;
    List<Item> inventory = new List<Item>();

    Player(this.currentRoom, String name, List<String> alts, String desc):super(name, alts, desc) {
        Controller.instance.players.add(this);
        validActions.add(new Be()); //all things can be looked at.

    }

    //things in your inventory, things in the room you're in (including obvious exits)
    List<Item> allAccessibleItems() {
        List<Item> ret = new List<Item>.from(inventory);
        ret.addAll(currentRoom.exits);
        ret.addAll(currentRoom.contents);
        ret.add(this);
        return ret;
    }

    String turnArrayIntoHumanSentence(List<dynamic> retArray) {
        return [retArray.sublist(0, retArray.length - 1).join(', '), retArray.last].join(retArray.length < 2 ? '' : ' and ');
    }

    String get itemsDescription {
        String ret = "It is empty.";
        if(inventory.isNotEmpty) ret = "You have: ${turnArrayIntoHumanSentence(inventory)}.";
        return ret;
    }

}