import "../Item.dart";
import "../random.dart";
import "../weighted_lists.dart";

abstract class Action {


    String name;
    List<String>  alts;

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