import '../Item.dart';
import "Action.dart";
import "../random.dart";
import "../weighted_lists.dart";
class Look extends Action {

    static List<String> ALTS = <String>["LOOK","OBSERVE","EXAMINE","SEE","EYEBALL","OOGLE","OGLE","LEER","PONDER","CONTEMPLATE","REGARD"];

    static bool isCommand(String word) {
        return ALTS.contains(word.toUpperCase().trim());
    }

    Look():super("Look",ALTS);



  static String performAction(String itemName) {
    Item item = Action.findItemFromString(itemName);
    if(item != null) {
        Look l = item.findActionWithSameClassAs(new Look());
        if(l != null) return l.apply(item);
        return "...This is probably a bug but you find yourself unable to even LOOK at the ${item.name}";
    }else {
        WeightedList<String> snark = new WeightedList<String>();
        snark.add("You do not see a $item anywhere.",1.0);
        snark.add("You briefly hallucinate that there is a '$item' somewhere. ",0.5);
        Random rand = new Random();
        //guess it's ab
        snark.add("There is a ${90+(rand.nextDouble()*10)} % chance that JR was too much of a lazy fuck to realize that you would try to interact with  '$item'. ",0.5);
        return rand.pickFrom(snark);
    }
  }
  @override
  String apply(Item item) {
      return "You LOOK at the ${item.name}. It is ${item.description}";
  }
}