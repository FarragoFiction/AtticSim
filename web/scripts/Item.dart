import "Actions/Action.dart";
import "Actions/Look.dart";

class Item {
    String name;
    List<String> alts;
    String description;
    List<Action> validActions = new List<Action>();

    Item(String this.name, List<String> this.alts, String this.description) {
        validActions.add(new Look()); //all things can be looked at.
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