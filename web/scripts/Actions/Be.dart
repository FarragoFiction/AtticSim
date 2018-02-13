import '../Item.dart';
import "Action.dart";
import "../random.dart";
import "../weighted_lists.dart";
import "../Controller.dart";
class Be extends Action {

    static List<String> ALTS = <String>["BE","BECOME","TRANSFORM","ASCEND"];

    static bool isCommand(String word) {
        //print("is $word another word for LOOK?");
        return ALTS.contains(word.toUpperCase().trim());
    }

    Be():super("Be",ALTS);



  static String performAction(String itemName) {
      print("going to look at $itemName");
    Item item = Action.findPlayerFromString(itemName);

      if(item != null) {
          print("player found, it's $item");
          Be l = item.findActionWithSameClassAs(new Be());
          if(l != null) {
              return l.apply(item);
          }
      }

      return new Be().apply(null, itemName);
  }

  //if i am passed a player, then I become the player
    //if i am passed null, i fail to becomd x and isntead become some random player
  @override
  String apply(Item item, [String itemName]) {
      String ret = "";
      if(item != null) {
          Controller.instance.currentPlayer = item;
          ret = "You are now ${item.name}. ${item.description}";
      }else {
          Random rand = new Random();
          item = rand.pickFrom(Controller.instance.players);
          Controller.instance.currentPlayer = item;
          ret = "You fail to become ${itemName} and instead become ${item.name}. ${item.description}";
      }
      return ret;
  }
}