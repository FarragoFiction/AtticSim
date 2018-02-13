import '../Item.dart';
import "Action.dart";
import "../random.dart";
import "../weighted_lists.dart";
import "../Controller.dart";
class ShitPost extends Action {

    static List<String> ALTS = <String>["SHITPOST","MEME"];

    static bool isCommand(String word) {
        return ALTS.contains(word.toUpperCase().trim());
    }

    ShitPost():super("ShitPost",ALTS);



  static String performAction(String itemName) {
    if(Controller.instance.currentPlayer.currentRoom == Controller.instance.controlConsole && Controller.instance.currentPlayer == Controller.instance.shogun) {
        //i'm somewhere i can troll jr.
        return new ShitPost().apply(null,null);
    }else if(Controller.instance.currentPlayer == Controller.instance.shogun) {
        return "You fail to be at the CONTROL CONSOLE.";
    }
    return "You fail to be a meme lord.";
  }

    static List<String> shitposts() {
        WeightedList<String> snark = new WeightedList<String>();
        snark.add("You answer Tumblr asks in the least helpful way possible.",0.5);
        snark.add("You photoshop your head into hundreds of flattering pictures.",0.5);
        snark.add("You photoshop JR's head into hundreds of unflattering pictures.",0.5);
        snark.add("You try to figure out where all these 'nyas' on Tumblr are coming from",0.6);
        snark.add("You encourage people to make Shogun fanart",0.6);
        snark.add("You send anonymous asks to JR's tumblr.",0.3);
        snark.add("You follow the Wendy's twitter.",0.3);



        return snark;
    }

  //if i am passed a player, then I become the player
    //if i am passed null, i fail to becomd x and isntead become some random player
  @override
  String apply(Item item, [String itemName]) {
      Random rand = new Random();
      return rand.pickFrom(shitposts());
  }
}