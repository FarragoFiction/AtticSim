import '../Item.dart';
import "Action.dart";
import "../random.dart";
import "../weighted_lists.dart";
import "../Controller.dart";
class Take extends Action {
    static List<String> ALTS = <String>["TAKE","STEAL","YOINK","ACQUIRE", "PILFER","PICK","APPROPRIATE","POCKET","GET"];

    static bool isCommand(String word) {
        return ALTS.contains(word.toUpperCase().trim());
    }

    Take():super("Take",ALTS,pointValue:10);



  static String performAction(String itemName) {
    Item item = Action.findItemFromStringInRoom(itemName);
      if(item != null) {
          Take l = item.findActionWithSameClassAs(new Take());
          if(l != null) {
              return l.apply(item);
          }else {
              return new Take().apply(item, itemName, true);
          }
      }

      return new Take().apply(null, itemName);
  }

    static List<String> adorableProtest(String itemName) {
        WeightedList<String> snark = new WeightedList<String>();
        snark.add("JR's words are echoed: You can't fucking take that dunkass, that's too big.",0.5);
        snark.add("Not even your SHITTY MOVIE sylladex could hold that.",0.5);
        snark.add("The $itemName appears to be nailed down. Somehow.",1.0);
        return snark;
    }

  //if i am passed a player, then I become the player
    //if i am passed null, i fail to becomd x and isntead become some random player
  @override
  String apply(Item item, [String itemName, bool nailedDown = false]) {
      if(nailedDown && item != null) {
          Random rand = new Random();
          return rand.pickFrom(adorableProtest(item.name));
      }

      if(item != null) {
          Controller.instance.currentPlayer.currentRoom.contents.remove(item);
          Controller.instance.currentPlayer.inventory.add(item);
          applyPoints();
          return "You now own the the ${item.name}.";
      }else {
          Random rand = new Random();
          return rand.pickFrom(Action.cantFidnItemSnark(itemName));
      }
  }
}