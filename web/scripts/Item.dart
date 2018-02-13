import "Actions/Action.dart";
import "Actions/Look.dart";
import "Actions/Destroy.dart";
import "Actions/Vore.dart";
import "Actions/Take.dart";
import "Controller.dart";
import "weighted_lists.dart";
import "random.dart";
import "Actions/Use.dart";

//returns what happened with the item (and determines what SHOULD happen)
typedef String Condition(List<Item> items);



class Item {
    String name;
    List<String> alts;
    String description;
    String useDescription;
    Condition useCondition;

    //for shitty puzzles
    List<Item> parts = new List<Item>();

    bool pointsApplied  = false;

    List<Action> validActions = new List<Action>();

    Item(String this.name, List<String> this.alts, String this.description, String this.useDescription, {bool destroyable: false, bool consumable: false, bool portable: false, Condition this.useCondition: null}) {
        validActions.add(new Look()); //all things can be looked at.
        validActions.add(new Use()); //all things can be used.

        if(destroyable) validActions.add(new Destroy()); //all things can be looked at.
        if(consumable) validActions.add(new Vore()); //all things can be looked at.
        if(portable) validActions.add(new Take()); //all things can be looked at.


        if(useCondition == null) {
            useCondition = defaultCondition;
        }


    }

    void applyPoints(int pointValue) {
        if(!pointsApplied) {
            Controller.instance.points += pointValue;
        }
    }

    String hasPartCondition() {
        //how would this work
    }

    //almost no points
    String defaultCondition(List<Item> goingToIgnore) {
        //if item is in inventory, put it on the ground
        if(Controller.instance.currentPlayer.inventory.contains(this)) {
            WeightedList<String> snark = new WeightedList<String>();
            snark.add("You abjure the '$this'. It is now on the ground.", 1.0);
            snark.add("You deploy the '$this'. It is now on the ground.", 1.0);
            snark.add("Why did you ever think you wanted to own the '$this'? It's now on the floor, where it belongs.", 0.5);
            snark.add("The '$this' belongs on the floor. ", 0.5);
            snark.add("You take the '$this' and throw it to the ground. You're an adult. ", 0.2);

            snark.add("The '$this' rocket out of your inventory and onto the floor.", 0.5);
            Controller.instance.currentPlayer.inventory.remove(this);
            Controller.instance.currentPlayer.currentRoom.contents.add(this);
            Random rand = new Random();
            return rand.pickFrom(snark);
        }else { //if item is on ground, display use text
            applyPoints(1);
            return "${useDescription}";
        }

    }

     bool isItem(String word) {
        //print("is $word another word for LOOK?");
        return alts.contains(word.toUpperCase().trim());
    }

    String toString() {
        return name;
    }

    Action findActionWithSameClassAs(Action template) {
        for(Action a in validActions) {
            if(a.runtimeType == template.runtimeType) return a;
        }
        return null;
    }
}