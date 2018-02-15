import '../Item.dart';
import "Action.dart";
import "../random.dart";
import "../weighted_lists.dart";
class Fuck extends Action {

    static List<String> ALTS = <String>["FUCK","DO","COPULATE","SEX","RAVISH","SEDUCE","FLIRT"];

    static bool isCommand(String word) {
        //print("is $word another word for LOOK?");
        return ALTS.contains(word.toUpperCase().trim());
    }

    Fuck():super("Fuck",ALTS,pointValue: 10);



    static String performAction(String itemName) {
        return new Fuck().apply(null);
    }

    @override
    String apply(Item item, [String itemName]) {
        applyPoints();
        Random rand = new Random();
        //turtle because of the meme of 'do the turtles ever stop fucking' from a sburbsim either glitch or hack
        return "You can't do that! ${rand.pickFrom(Action.cantFidnItemSnark("Turtle"))}";
    }
}