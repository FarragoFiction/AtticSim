import "Item.dart";
import "Room.dart";

//a player can do anything an item can do because i said so that's why
class Player extends Item {
    Room currentRoom;
    List<Item> inventory = new List<Item>();

    Player(this.currentRoom, String name, List<String> alts, String desc):super(name, alts, desc);

    //things in your inventory, things in the room you're in (including obvious exits)
    List<Item> allAccessibleItems() {
        List<Item> ret = new List<Item>.from(inventory);
        ret.addAll(currentRoom.exits);
        ret.addAll(currentRoom.contents);
        return ret;
    }

}