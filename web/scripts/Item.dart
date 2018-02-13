import "Actions/Action.dart";
import "Actions/Look.dart";
import "Actions/Destroy.dart";
import "Actions/Vore.dart";
import "Actions/Take.dart";



class Item {
    String name;
    List<String> alts;
    String description;
    List<Action> validActions = new List<Action>();

    Item(String this.name, List<String> this.alts, String this.description, {bool destroyable: false, bool consumable: false, bool portable: false}) {
        validActions.add(new Look()); //all things can be looked at.
        if(destroyable) validActions.add(new Destroy()); //all things can be looked at.
        if(consumable) validActions.add(new Vore()); //all things can be looked at.
        if(portable) validActions.add(new Take()); //all things can be looked at.


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