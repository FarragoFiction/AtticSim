import '../Item.dart';
import "Action.dart";
import "../random.dart";
import "../weighted_lists.dart";
class Look extends Action {

    static List<String> ALTS = <String>["LOOK","OBSERVE","EXAMINE","SEE","EYEBALL","OOGLE","OGLE","LEER","PONDER","CONTEMPLATE","REGARD"];

    static bool isCommand(String word) {
        //print("is $word another word for LOOK?");
        return ALTS.contains(word.toUpperCase().trim());
    }

    Look():super("Look",ALTS);



  static String performAction(String itemName) {
      print("going to look at $itemName");
    Item item = Action.findItemFromString(itemName);
    if(item != null) {
        print("item found, it's $item");
        Look l = item.findActionWithSameClassAs(new Look());
        if(l != null) return l.apply(item);
        return "...This is probably a bug but you find yourself unable to even LOOK at the ${item.name}";
    }else {
        print("i couldn't find the item");
        WeightedList<String> snark = new WeightedList<String>();
        snark.add("You do not see a $itemName anywhere.",1.0);
        snark.add("You briefly hallucinate that there is a '$itemName' somewhere. ",0.5);
        Random rand = new Random();
        //guess it's ab
        snark.add("There is a ${90+(rand.nextDouble()*10)} % chance that JR was too much of a lazy fuck to realize that you would try to interact with  '$itemName'. ",0.5);
        return rand.pickFrom(snark);
    }
  }
  @override
  String apply(Item item) {
      return "You LOOK at the ${item.name}. It is ${item.description}";
  }
}