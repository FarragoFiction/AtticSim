import '../Item.dart';
import "Action.dart";
import "../random.dart";
import "../weighted_lists.dart";
import "../Controller.dart";
import "../Player.dart";
//WHOA.
class Cheat extends Action {
    static List<String> ALTS = <String>["130333","130333A","130333B"];

    static bool isCommand(String word) {
        return ALTS.contains(word.toUpperCase().trim());
    }

    Cheat():super("Cheat",ALTS,pointValue:10);



  static String performAction(String itemName) {
      return new Cheat().apply(null, itemName);
  }


  //if i am passed a player, then I become the player
    //if i am passed null, i fail to becomd x and isntead become some random player
  @override
  String apply(Item item, [String itemName, bool nailedDown = false]) {
      String ret = "You put the clues together. What will happen? Oh. You're kind of disappointed to see that it just gives everybody to Dennis besides Shogun and JR. What's the point of that?";
      for(Player p in Controller.instance.players) {
        p.currentRoom = Controller.instance.dennis;
      }
      return ret;
  }
}