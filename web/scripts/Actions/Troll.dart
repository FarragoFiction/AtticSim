import '../Item.dart';
import "Action.dart";
import "../random.dart";
import "../weighted_lists.dart";
import "../Controller.dart";
class Troll extends Action {

    static List<String> ALTS = <String>["TROLL","HARASS","PESTER","BOTHER", "ANNOY","RIDDLE","GIGGLESNORT","ANNOY"];

    static bool isCommand(String word) {
        return ALTS.contains(word.toUpperCase().trim());
    }

    Troll():super("Troll",ALTS);



  static String performAction(String itemName) {
    if(Controller.instance.currentPlayer.currentRoom == Controller.instance.controlConsole && Controller.instance.currentPlayer == Controller.instance.shogun) {
        //i'm somewhere i can troll jr.
        return new Troll().apply(null,null,true);
    }else if(Controller.instance.currentPlayer == Controller.instance.shogun) {
        return "You fail to be at the CONTROL CONSOLE.";
    }

    if(Controller.instance.currentPlayer == Controller.instance.jr) {
        //i can always troll shogun
        return new Troll().apply(null,null,false);

    }
    print("player was ${Controller.instance.currentPlayer} and they were in room ${Controller.instance.currentPlayer.currentRoom }. I don't think they can troll anyone.");
    return "You fail to be in a weird pitch/leprechaun trovey thing with anyone.";
  }

    static List<String> jrHarrassments() {
        WeightedList<String> snark = new WeightedList<String>();
        snark.add("You taunt Shogun about how they never sleep.",0.5);
        snark.add("You devise a fiendish puzzle for Shogun to ignore.",0.5);
        snark.add("You harass Shogun about how you can see them on all your Cameras.",0.5);
        snark.add("You send Shogun a picture of Lucky Charms.",0.6);
        snark.add("You hack Shogun's shitty ARG and fill it with Lucky Charm refrances.",0.6);

        return snark;
    }

    static List<String> shogunHarrassments() {
        WeightedList<String> snark = new WeightedList<String>();
        snark.add("You taunt JR about how they are trapped in an attic.",0.5);
        snark.add("You tell all your Tumblr followers about how JR could never beat you in a fight.",0.5);
        snark.add("You send JR a picture of some pigeons.",0.5);
        snark.add("You harrass JR. ",0.6);
        snark.add("You add more shitposts to SBURBSim.",0.6);


        return snark;
    }

  //if i am passed a player, then I become the player
    //if i am passed null, i fail to becomd x and isntead become some random player
  @override
  String apply(Item item, [String itemName, bool trollJR = true]) {
      Random rand = new Random();
      rand.nextInt();

      if(trollJR) {
          return "${Controller.instance.moveTime()} ${rand.pickFrom(shogunHarrassments())} JR messages you back: ${Controller.instance.applyDare()}";
      }else {
          if(rand.nextBool()) {
              return "${rand.pickFrom(jrHarrassments())}";
          }else {
              return "You watch Shogun on your cameras for a while, then decide to troll him. ${Controller.instance.applyDare()}";
          }
      }
  }
}