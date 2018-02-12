import "../Item.dart";
import "../random.dart";
import "../weighted_lists.dart";
import "../Controller.dart";
import "Look.dart";

/*

sequence of events. action parses the command into an action subtype,
then hands it over to that subtypes class (not instance).

that subclass tries to find the item, and if it can't, uses a default message about how you can't look at nothing, dunkass.
if it CAN find the item, it then asks the item if it reponds to anything of it's class.

if it does, passes it to the instance
if it doesn't, default error message.
 */

abstract class Action {


    String name;
    List<String>  alts;

    Action(this.name, this.alts) {

    }

    String apply(Item item);

    static Item findItemFromString(String itemString) {
        itemString.trim();
    }

    //all actions apply to an item, so rooms are items too. fuck the world.
    static String applyAction(String command ) {
        //TODO parse the command into subclass item pairs (rooms and players are items, too)
        //find the item in the current room (including in player's inventory)
        // try to do action on the item
        //if you can't, use default value.

        WeightedList<String> snark = new WeightedList<String>();
        snark.add("I do not know how to '$command'. ",1.0);
        snark.add("JR is too lazy to implement '$command' yet. ",1.0);
        snark.add("Do you really think JR bothered to implement '$command'? ",0.5);
        snark.add("Gonna be honest, I have NO idea what you think '$command' would even do. ",0.3);
        snark.add("Is '$command' a meme or some shit? ",0.2);


        Random rand = new Random();
        //guess it's ab
        snark.add("There is a ${90+(rand.nextDouble()*10)} % chance that JR was too much of a lazy fuck to implement '$command', yet. ",0.5);
        return rand.pickFrom(snark);
    }

}