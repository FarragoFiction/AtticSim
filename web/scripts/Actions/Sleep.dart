import '../Item.dart';
import "Action.dart";
import "../random.dart";
import "../weighted_lists.dart";
import "../Controller.dart";
class Sleep extends Action {

    static List<String> ALTS = <String>["SLEEP","NAP","REST","SLUMBER", "Z","LAY"];

    static bool isCommand(String word) {
        return ALTS.contains(word.toUpperCase().trim());
    }

    Sleep():super("Troll",ALTS);



  static String performAction(String itemName) {
      if(Controller.instance.currentPlayer == Controller.instance.shogun) {
          return "Haha, no. Shogun doesn't sleep.";
      }else {
          return "You sleep, but as you fail to be the MAIN CHARACTER time does not pass. Your POWER, however, grows ever stronger. ";
      }

  }

  @override
  String apply(Item item, [String itemName, bool trollJR = true]) {
      //EMPTY ON PURPOSE
  }
}