import "Item.dart";
import "Room.dart";

//a player can do anything an item can do because i said so that's why
class Player extends Item {
    Room currentRoom;

    Player(this.currentRoom, String name, List<String> alts, String desc):super(name, alts, desc);

}