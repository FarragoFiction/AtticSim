import '../Item.dart';
import "Action.dart";
import "../random.dart";
import "../weighted_lists.dart";
import "../Controller.dart";
import "../Player.dart";
//WHOA.
class Secret extends Action {
    static List<String> ALTS = <String>["211212213","211212213A","211212213B"];

    static bool isCommand(String word) {
        return ALTS.contains(word.toUpperCase().trim());
    }

    Secret():super("Secret",ALTS,pointValue:10);



  static String performAction(String itemName) {
      return new Secret().apply(null, itemName);
  }


  @override
  String apply(Item item, [String itemName, bool nailedDown = false]) {
      String ret = "You are glad Shogun is your friend.";
      return ret;
  }
}