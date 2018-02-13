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

    Destroy():super("Destroy",ALTS,pointValue: 10);



  static String performAction(String itemName) {
    Item item = Action.findItemFromString(itemName);
    print("found item to destroy it is $item");
      if(item != null) {
          Destroy l = item.findActionWithSameClassAs(new Destroy());
          if(l != null) {
              return l.apply(item);
          }else {
              print ("The $item is too precious to destroy");
              return new Destroy().apply(item, itemName, true);
          }
      }

      return new Destroy().apply(null, itemName);
  }

    static List<String> adorableProtest(String itemName) {
        WeightedList<String> snark = new WeightedList<String>();
        snark.add("You cannot do it. You cannot destroy that $itemName.",0.5);
        snark.add("You may be filled with an ending need for destruction, but you are not a monster. You will no destroy the $itemName.",0.5);
        snark.add("You would never destroy dear sweet precious $itemName.",0.5);
        snark.add("The $itemName is far too precious to destroy.",1.0);
        return snark;
    }

  //if i am passed a player, then I become the player
    //if i am passed null, i fail to becomd x and isntead become some random player
  @override
  String apply(Item item, [String itemName, bool precious = false]) {
      print("precious is $precious and item is $item");
      if(precious && item != null) {
          Random rand = new Random();
          return rand.pickFrom(adorableProtest(item.name));
      }

      if(item != null && Controller.instance.currentPlayer == Controller.instance.shogun) {
          Controller.instance.currentPlayer.currentRoom.contents.remove(item);
          Controller.instance.currentPlayer.inventory.remove(item);
          //give points
          applyPoints();
          return "You fucking wreck the ${item.name}.";
      }else if(item != null) {
          return "Your noodly appendages are far too shit to destroy anything, but especially a $item.";
      }else {
          Random rand = new Random();
          return rand.pickFrom(Action.cantFidnItemSnark(itemName));
      }
  }
}