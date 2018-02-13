import '../Item.dart';
import "Action.dart";
import "../random.dart";
import "../weighted_lists.dart";
import "../Controller.dart";
class Destroy extends Action {

    static List<String> ALTS = <String>["DESTROY","STRIFE","SLAY","ATTACK", "CUT","SLASH","STAB","RUIN","WRECK","KILL","MURDER","DOMINATE"];

    static bool isCommand(String word) {
        return ALTS.contains(word.toUpperCase().trim());
    }

    Destroy():super("Destroy",ALTS);



  static String performAction(String itemName) {
    Item item = Action.findItemFromString(itemName);

      if(item != null) {
          Destroy l = item.findActionWithSameClassAs(new Destroy());
          return l.apply(item);
      }

      return new Destroy().apply(null, itemName);
  }

  //if i am passed a player, then I become the player
    //if i am passed null, i fail to becomd x and isntead become some random player
  @override
  String apply(Item item, [String itemName]) {
      String ret = "";
      if(item != null && Controller.instance.currentPlayer == Controller.instance.shogun) {
          Controller.instance.currentPlayer.currentRoom.contents.remove(item);
          Controller.instance.currentPlayer.inventory.remove(item);
          ret = "You fucking wreck the ${item.name}.";
      }else if(item != null) {
          return "Your noodly appendages are far too shit to destroy anything, but especially a $item.";
      }else {
          Random rand = new Random();
          return rand.pickFrom(Action.cantFidnItemSnark(itemName));
      }
      return ret;
  }
}