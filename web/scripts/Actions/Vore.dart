import '../Item.dart';
import "Action.dart";
import "../random.dart";
import "../weighted_lists.dart";
import "../Controller.dart";
class Vore extends Action {

    static List<String> ALTS = <String>["VORE","EAT","CONSUME","DEVOUR", "SWALLOW","SLURP"];

    static bool isCommand(String word) {
        return ALTS.contains(word.toUpperCase().trim());
    }

    Vore():super("Eat",ALTS);



  static String performAction(String itemName) {
    Item item = Action.findItemFromString(itemName);
    print("found item to destroy it is $item");
      if(item != null) {
          Vore l = item.findActionWithSameClassAs(new Vore());
          if(l != null) {
              return l.apply(item);
          }else {
              return new Vore().apply(item, itemName, true);
          }
      }

      return new Vore().apply(null, itemName);
  }

    static List<String> adorableProtest(String itemName) {
        WeightedList<String> snark = new WeightedList<String>();
        snark.add("JR's words are echoed: You can't fucking eat that dunkass, that's not food.",0.5);
        snark.add("You are PRETTY sure that you'd only eat this on a dare.",0.5);
        snark.add("The $itemName doesn't look very tasty.",1.0);
        return snark;
    }

  //if i am passed a player, then I become the player
    //if i am passed null, i fail to becomd x and isntead become some random player
  @override
  String apply(Item item, [String itemName, bool notFood = false]) {
      print("precious is $notFood and item is $item");
      if(notFood && item != null) {
          Random rand = new Random();
          return rand.pickFrom(adorableProtest(item.name));
      }

      if(item != null) {
          Controller.instance.currentPlayer.currentRoom.contents.remove(item);
          Controller.instance.currentPlayer.inventory.remove(item);
          return "You fucking CONSUME the ${item.name}.";
      }else {
          Random rand = new Random();
          return rand.pickFrom(Action.cantFidnItemSnark(itemName));
      }
  }
}