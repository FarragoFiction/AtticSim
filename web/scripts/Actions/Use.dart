import '../Item.dart';
import "Action.dart";
import "../random.dart";
import "../weighted_lists.dart";
import "../Controller.dart";
class Use extends Action {

    static List<String> ALTS = <String>["USE","DEPLOY","ABJURE"];

    static bool isCommand(String word) {
        return ALTS.contains(word.toUpperCase().trim());
    }

    Use():super("Use",ALTS,pointValue:10);



  static String performAction(String itemName) {
    Item item = Action.findItemFromString(itemName);
      if(item != null) {
          Use l = item.findActionWithSameClassAs(new Use());
          if(l != null) {
              return l.apply(item);
          }else {
              return new Use().apply(item, itemName, true);
          }
      }

      return new Use().apply(null, itemName);
  }


  //if i am passed a player, then I become the player
    //if i am passed null, i fail to becomd x and isntead become some random player
  @override
  String apply(Item item, [String itemName, bool notFood = false]) {
      //usecondition will worry about applying points
      if(item != null) {
          return item.useCondition();
      }else {
          Random rand = new Random();
          return rand.pickFrom(Action.cantFidnItemSnark(itemName));
      }
  }
}