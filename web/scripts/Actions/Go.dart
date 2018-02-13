import '../Item.dart';
import "Action.dart";
import "../random.dart";
import "../weighted_lists.dart";
import "../Controller.dart";
class Go extends Action {

    static List<String> ALTS = <String>["GO","MOVE","WALK","YOUTH ROLL", "PIROUETTE","DANCE","ABSCOND","RUN","TRAVEL"];

    static bool isCommand(String word) {
        //print("is $word another word for LOOK?");
        return ALTS.contains(word.toUpperCase().trim());
    }

    Go():super("Go",ALTS);



  static String performAction(String itemName) {
      print("going to look at $itemName");
    Item item = Action.findExitFromString(itemName);

      if(item != null) {
          print("exit found, it's $item");
          Go l = item.findActionWithSameClassAs(new Go());
          if(l != null) {
              return l.apply(item);
          }
      }

      return new Go().apply(null, itemName);
  }

  //if i am passed a player, then I become the player
    //if i am passed null, i fail to becomd x and isntead become some random player
  @override
  String apply(Item item, [String itemName]) {
      String ret = "";
      if(item != null) {
          Controller.instance.currentPlayer.currentRoom = item;
          ret = "You GO to the ${item.name}.";
      }else {
          Random rand = new Random();
          return rand.pickFrom(Action.cantFidnItemSnark(itemName));
      }
      return ret;
  }
}