import "../Item.dart";
import "../random.dart";
import "../weighted_lists.dart";
import "../Controller.dart";
import "Look.dart";
import "Be.dart";
import "Go.dart";
import "Destroy.dart";
import "Vore.dart";
import "Troll.dart";
import "ShitPost.dart";
import "Sleep.dart";


import "../Player.dart";

/*

sequence of events. action parses the command into an action subtype,
then hands it over to that subtypes class (not instance).

that subclass tries to find the item, and if it can't, uses a default message about how you can't look at nothing, dunkass.
if it CAN find the item, it then asks the item if it reponds to anything of it's class.

if it does, passes it to the instance
if it doesn't, default error message.
 */

abstract class Action {

    //useful for calculating total points
    static List<Action> allActions = new List<Action>();

    String name;
    List<String>  alts;

    //only specifically created actions have point values
    int pointValue = 0;
    //only gives points the first time
    bool pointsGiven = false;


    Action(this.name, this.alts, {this.pointValue: 0}) {
        Action.allActions.add(this);
    }

    String apply(Item item, [String itemName]);

    void applyPoints() {
        if(!pointsGiven) {
            Controller.instance.points += pointValue;
        }
    }

    static Item findItemFromString(String itemString) {
        itemString.trim();
        Player p = Controller.instance.currentPlayer;
        print("player is p");

        List<Item> allItems = p.allAccessibleItems();
        print("found ${allItems.length} items");
        for(Item item in allItems) {
            if(item.isItem(itemString)) return item;
        }

        return null;
    }


    static Item findItemFromStringInRoom(String itemString) {
        itemString.trim();
        Player p = Controller.instance.currentPlayer;
        print("player is p");

        List<Item> allItems = p.currentRoom.contents;
        print("found ${allItems.length} items");
        for(Item item in allItems) {
            if(item.isItem(itemString)) return item;
        }

        return null;
    }

    static Item findExitFromString(String itemString) {
        itemString.trim();


        List<Item> allItems = new List.from(Controller.instance.currentPlayer.currentRoom.exits);
        print("found ${allItems.length} items");
        for(Item item in allItems) {
            if(item.isItem(itemString)) return item;
        }

        return null;
    }

    static Item findPlayerFromString(String itemString) {
        itemString.trim();


        List<Item> allItems = new List.from(Controller.instance.players);
        print("found ${allItems.length} items");
        for(Item item in allItems) {
            if(item.isItem(itemString)) return item;
        }

        return null;
    }

    static String foundCommand(String command) {
        //first parse into action item pairs.
        List<String> parts = command.split(" ");
        print("parts is $parts");
        if(parts.isEmpty) return null;
        //then check all known actions and ask if it's them
        if(Look.isCommand(parts[0])) {
            //print("it's a look command");
            String item = parseOutItem(parts);
            return Look.performAction(item);
        }else if(Be.isCommand(parts[0])) {
            String item = parseOutItem(parts);
            return Be.performAction(item);
        }else if(Go.isCommand(parts[0])) {
            String item = parseOutItem(parts);
            return Go.performAction(item);
        }else if(Destroy.isCommand(parts[0])) {
            String item = parseOutItem(parts);
            return Destroy.performAction(item);
        }else if(Vore.isCommand(parts[0])) {
            String item = parseOutItem(parts);
            return Vore.performAction(item);
        }else if(Troll.isCommand(parts[0])) {
            String item = parseOutItem(parts);
            return Troll.performAction(item);
        }else if(ShitPost.isCommand(parts[0])) {
            String item = parseOutItem(parts);
            return ShitPost.performAction(item);
        }else if(Sleep.isCommand(parts[0])) {
            String item = parseOutItem(parts);
            return Sleep.performAction(item);
        }
        return null;
    }

    static String parseOutItem(List<String> parts) {
        String item = null;
        parts.remove(parts[0]);
        if(parts.length > 0) item = parts.join(' ');

        print("the item is $item");
        //then, give it the rest of the command and call it a day, you lazy fuck
        return item;
    }

    //all actions apply to an item, so rooms are items too. fuck the world.
    static String applyAction(String command ) {
        //parse the command into subclass item pairs (rooms and players are items, too)
        //find the item in the current room (including in player's inventory)
        // try to do action on the item
        //if you can't, use default value.

        String ret = foundCommand(command);
        if(ret != null) {
            return ret;
        }else{
            WeightedList<String> snark = new WeightedList<String>();
            snark.add("I do not know how to '$command'. ", 1.0);
            snark.add("JR is too lazy to implement '$command' yet. ", 1.0);
            snark.add("Do you really think JR bothered to implement '$command'? ", 0.5);
            snark.add("Gonna be honest, I have NO idea what you think '$command' would even do. ", 0.3);
            snark.add("Is '$command' a meme or some shit? ", 0.2);


            Random rand = new Random();
            //guess it's ab
            snark.add("There is a ${90 + (rand.nextDouble() * 10)} % chance that JR was too much of a lazy fuck to implement '$command', yet. ", 0.5);
            return rand.pickFrom(snark);
        }
    }

    static List<String> cantFidnItemSnark(String itemName) {
        WeightedList<String> snark = new WeightedList<String>();
        snark.add("You do not see a $itemName anywhere.",1.0);
        snark.add("You briefly hallucinate that there is a '$itemName' somewhere. ",0.5);
        Random rand = new Random();
        //guess it's ab
        snark.add("There is a ${90+(rand.nextDouble()*10)} % chance that JR was too much of a lazy fuck to realize that you would try to interact with  '$itemName'. ",0.5);
        return snark;
    }

}