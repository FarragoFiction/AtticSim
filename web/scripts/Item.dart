import "Actions/Action.dart";
import "Actions/Look.dart";
import "Actions/Destroy.dart";
import "Actions/Vore.dart";
import "Actions/Take.dart";
import "Controller.dart";
import "weighted_lists.dart";
import "random.dart";
import "Actions/Use.dart";
import "Player.dart";
import "Room.dart";

//returns what happened with the item (and determines what SHOULD happen)
typedef String Condition();



class Item {

    String name;
    List<String> alts;
    String _description;

    //for shitty puzzles
    List<Item> parts = new List<Item>();
    //the condition itself will handle what this means
    bool pointsApplied  = false;
    Condition useCondition;
    String useDescription;

    static String UNICORNMETHOD = "unicorn";
    static String WIGRIDER = "wigrider";
    static String ORDERSHIT = "ORDERSHIT";
    static String APPEASEKR = "appeaseKR";


    List<Action> validActions = new List<Action>();

    Item(String this.name, List<String> this.alts, String this._description, String this.useDescription, {bool destroyable: false, bool consumable: false, bool portable: false, String useConditionString: null }) {
        validActions.add(new Look()); //all things can be looked at.
        validActions.add(new Use()); //all things can be used.

        if(destroyable) validActions.add(new Destroy()); //all things can be looked at.
        if(consumable) validActions.add(new Vore()); //all things can be looked at.
        if(portable) validActions.add(new Take()); //all things can be looked at.


        if(useConditionString == null) {
            useCondition = defaultCondition;
        }else if (useConditionString == UNICORNMETHOD) {
            useCondition = addMeToUnicorn;
        }else if (useConditionString == WIGRIDER) {
            useCondition = rideMeWithWigOn;
        }else if (useConditionString == ORDERSHIT) {
            useCondition = orderShit;
        }else {
            useCondition = defaultCondition;
        }


    }

    void applyPoints(int pointValue) {
        if(!pointsApplied) {
            Controller.instance.points += pointValue;
        }
    }

    static String turnArrayIntoHumanSentence(List<dynamic> retArray) {
        return [retArray.sublist(0, retArray.length - 1).join(', '), retArray.last].join(retArray.length < 2 ? '' : ' and ');
    }

    String get description {
        String destroy = "";
        String eat = "";
        String own = "";
        if(respondsTo(new Destroy())) destroy = "You want to destroy it.";
        if(respondsTo(new Vore())) eat = "You want to eat it.";
        if(respondsTo(new Take()) && !Controller.instance.currentPlayer.inventory.contains(this)) own = "You want to own it.";

        String ret =  "$_description $destroy $eat $own";
        if(parts.isEmpty) return ret;
        return "$ret Attached are ${turnArrayIntoHumanSentence(parts)}. You cannot remove them.";

    }

    //fuck it, stop trying to be fancy, just hard code each type of use

    //does what it says on the tin.
    String addMeToUnicorn() {
        print("trying to add me to unicorn");
        Player p = Controller.instance.currentPlayer;
        Room r = p.currentRoom;
        Item unicorn = Controller.instance.unicorn;
        if(r.contents.contains(unicorn) && p.inventory.contains(this)){
            unicorn.parts.add(this);
            p.inventory.remove(this);
            applyPoints(130);
            return "You really improve the look of the Frankenfuck Unicorn by adding a stylish wig to it.";
        }else{
             return defaultCondition(false);
        }
    }

    //does what it says on the tin.
    String rideMeWithWigOn() {
        Player p = Controller.instance.currentPlayer;
        Item nepetaWig = Controller.instance.nepetaWig;
        Item guyFieriWig = Controller.instance.guyFieriWig;

        if(p.inventory.contains(nepetaWig)){
            applyPoints(130);
            return "You wear the Nepeta Wig and be the Rider.";
        }else if(p.inventory.contains(guyFieriWig)){
            applyPoints(1300);
            return "You ride the FrankenFuck Unicorn while appearing to have shocking blond hair. Everyone is suitably impressed.";
        }else{
            return defaultCondition(false);
        }
    }

    //does what it says on the tin.
    String orderShit() {
        Player p = Controller.instance.currentPlayer;
        Item passwordScrawl = Controller.instance.passwordScrawl;

        if(p.inventory.contains(passwordScrawl)){
            applyPoints(130);
            p.inventory.remove(passwordScrawl);
            parts.add(passwordScrawl);
            name = "Unlocked JR's Computer";
            return "Huh. So that's what that shitty password hint means. You're in. You can now use JR's CONTROL CONSOLE to order all sorts of dumb shit online to pass the time.";
        }else if(parts.contains(passwordScrawl)) {
            return orderDumbShit();
        }else{
            return defaultCondition(false);
        }
    }

    //almost no points
    String defaultCondition([bool givePoints = true]) {
        //if item is in inventory, put it on the ground
        if(Controller.instance.currentPlayer.inventory.contains(this)) {
            WeightedList<String> snark = new WeightedList<String>();
            snark.add("You abjure the '$this'. It is now on the ground.", 1.0);
            snark.add("You deploy the '$this'. It is now on the ground.", 1.0);
            snark.add("Why did you ever think you wanted to own the '$this'? It's now on the floor, where it belongs.", 0.5);
            snark.add("The '$this' belongs on the floor. ", 0.5);
            snark.add("You take the '$this' and throw it to the ground. You're an adult. ", 0.2);

            snark.add("The '$this' rocket out of your inventory and onto the floor.", 0.5);
            Controller.instance.currentPlayer.inventory.remove(this);
            Controller.instance.currentPlayer.currentRoom.contents.add(this);
            Random rand = new Random();
            return rand.pickFrom(snark);
        }else { //if item is on ground, display use text
            if(givePoints)applyPoints(1);
            return "${useDescription}";
        }

    }

     bool isItem(String word) {
        //print("is $word another word for LOOK?");
        return alts.contains(word.toUpperCase().trim());
    }

    String toString() {
        return name;
    }

    bool respondsTo(Action template) {
        Action l = findActionWithSameClassAs(template);
        if(l!=null) return true;
        return false;
    }

    Action findActionWithSameClassAs(Action template) {
        for(Action a in validActions) {
            if(a.runtimeType == template.runtimeType) return a;
        }
        return null;
    }

    //allows repeats
    String orderDumbShit() {
        List<Item> dumbShit = new List<Item>();
        dumbShit.add(new Item("Doritos", <String>["DORITOS", "NACHOS", "CHIPS"], "Crunch chunch munch and cronch. All I do is doritos. It's so nice. Ahhhhhh. ", "You attempt to commune with the dorritos, instead of eating them.", destroyable: true, portable: true, consumable: true));
        dumbShit.add(new Item("BBQ Pringles", <String>["PRINGLES", "BBQ PRINGLES", "CHIPS"], "Crunch chunch munch and cronch. All I do is pringles. PL gets it. It is one reason you've spared them, so far. ", "You attempt to commune with the pringles, instead of eating them. You resent how hard the tube is to get into with your massive hands.", destroyable: true, portable: true, consumable: true));
        dumbShit.add(new Item("Inside-Out Grilled Cheese Sandwich", <String>["INSIDE-OUT GRILLED CHEESE SANDWICH", "SANDWICH", "CHEESE SANDWICH","GRILLED CHEESE SANDWICH"], "Two cheeses, one bread. An image of this burg spurned the Smith into their inevitable defeat at the hands of the rules they enforced. Rip.", "You get the feeling that KR would like this.", destroyable: true, portable: true, consumable: true));

        dumbShit.add(new Item("Monster Energy Drink", <String>["ENERGY DRINK", "MONSTER ENERGY DRINK", "MONSTER","CAN"], "I live exclusively on these fucking capsules of god elixir. They fill my saucy veins with raw god like energy. I haven't slept in so long.", "You pretend you can absorb the can's energy powers via your mind instead of by drinking it.", destroyable: true, portable: true, consumable: true));
        dumbShit.add(new Item("Poster of Unicron", <String>["POSTER", "UNICRON", "POSTER OF UNICRON"], "ShogunBot really likes this giant planet fucking lord of darkness. Respectable choice, but he's no Aku.", "You spend some time wondering why ShogunBot likes Unicron so much.", destroyable: true, portable: true));
        dumbShit.add(new Item("Gundam", <String>["GUNDAM", "MOBILE SUIT", "MECHA","ROBOT", "A GUNDAM"], "YES YES YES YES YES YES YES YES YES YES YES YES YES. I WILL BUILD MY SHOGUNDAM. IT WILL FUCKING HAPPEN. I WILL DO THIS.", "You spend some time planning out your Shogundam.", portable: true));
        dumbShit.add(new Item("Dr Pepper", <String>["DR PEPPER", "SODA", "SHITTY SODA"], "This is a terrifying elixir. Immense power. I still have yet to find that Dr Pepper BBQ sauce. I know you're hiding it from me JR. I will find it. So help me god.", "You rage at that asshole Waste for hiding the Dr Pepper BBQ Sauce from you.", destroyable: true, portable: true, consumable: true));
        dumbShit.add(new Item("Guy Fieri Wig", <String>["GUY FIERI WIG", "GUY WIG", "FIERI WIG","WIG"], "Welcome to Dungeons, Diners, Drive-ins n Dives n Dungeons. I will be your God.", "You cosplay as Guy Fieri for a while.", destroyable: true, portable: true, useConditionString: Item.UNICORNMETHOD));
        dumbShit.add(new Item("Signed and Framed Jerry Seinfeld Picture", <String>["SIGNED AND FRAMED JERRY SEINFELD PICTURE","FRAMED JERRY SEINFELD PICTURE","PICTURE", "SEINFELD PICTURE", "JERRY SEINFELD PICTURE"], "This is a true god amongst men. A cosmic being. I have memorised his entire auto-biography, self named series (including the secret 42 seasons) 13 movies and celebrity melt down.", "", destroyable: true, portable: true, consumable: true));
        dumbShit.add(new Item("Statue of a Greek God Except it has KR's Head", <String>["STATUE OF A GREEK GOD EXCEPT IT HAS KR'S HEAD", "GREEK GOD", "KR","KR STATUE","GREEK GOOD STATUE","STATUE","SWOLEPTURE"], "KR strikes fear into my soul like no other Being should. Like what does She smith? Where is the smith hammer? Is He that strong that they need only use her fists to forge the dreams? Is She that powerful he can control dreams? How buff is KR?", "You contemplate KR's theoretical buffness.", useConditionString: Item.APPEASEKR));
        dumbShit.add(new Item("Map of Continential Europe", <String>["MAP OF CONTINENTIAL EUROPE", "MAP", "MAP OF EUROPE","EUROPE"], "Legends says a huge dude worshipped by japanese gamers ruled this continent. I aspire to have that level of worship. Also...somehow it is brimming with violent sexual energy?", "You admire all of Continental Europe. Besides Portugal. ", destroyable: true, portable: true));
        dumbShit.add(new Item("Camera Footage of 2 Cowboys", <String>["CAMERA FOOTAGE","COWBOY", "MARQIS", "COWBOYS","2 COWBOYS","CAMERA FOOTAGE OF 2 COWBOYS"], "Look at these two identical cowboys. Look at them manipulating souls and turning monsters to plasma with their volley of death. Look at that. I don't know who the fuck they are but I'm fucking proud.", "You spend some time being proud of the two cowboys.", destroyable: true, portable: true));

        Random rand = new Random();

        List<Item> itemsOrdered = new List<Item>();
        int numberItems = rand.nextInt(3)+1;
        for(int i = 0; i<numberItems; i++) {
            Item item =  rand.pickFrom(dumbShit);
            Controller.instance.expectedDeliveries.add(new Delivery(item));
            itemsOrdered.add(item);
        }
        Controller.instance.moveTime();
        return "You browse Gristmart for way too long and end up ordering ${Item.turnArrayIntoHumanSentence(itemsOrdered)}";
    }
}
