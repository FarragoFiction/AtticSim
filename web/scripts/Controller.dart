import 'dart:html';
import "OneCharAtTime.dart";
import "Room.dart";
import "Player.dart";
import 'dart:async';
import "Actions/Action.dart";
import "Item.dart";
/*
knows about all the possible commands and the intro thingy.
 */

class Controller
{

    static Controller instance;

    Element gameText = new DivElement();
    Element roomText = new DivElement();
    TextInputElement textInputElement = new TextInputElement();
    OneCharAtTimeWrapper intro;

    List<Player> players;
    Player currentPlayer;


    Controller(Element wrapper) {
        instance = this;
        Element container = new DivElement();
        container.classes.add('game');
        gameText.classes.add('gameText');
        container.append(gameText);
        roomText.classes.add('gameText');
        container.append(roomText);

        Element inputContainer = new DivElement();
        Element prompt = new SpanElement();
        inputContainer.append(prompt);
        inputContainer.append(textInputElement);
        prompt.text = ">";
        textInputElement.classes.add("gameInput");
        textInputElement.autofocus = true;


        container.append(inputContainer);
        wrapper.append(container);


        init();


    }

    Future<Null> init() async {
        initRooms();
        intro = new OneCharAtTimeWrapper(<Line>[new Line("A young Shogun stands in a SBURBSim CONTROL ROOM. It just so happens that today, the 13th of January, 2018, is the day he finally took over SBURBSim. What will he do? Probably type commands in a 'look room' sort of way. That does seem to be the type of game this is.",gameText),new Line(currentPlayer.currentRoom.fullDescription,roomText)]);
        await intro.write();
        //don't have commands be enabled till intro is finished
        initTextListener();
    }

    void initTextListener() {
        window.onKeyDown.listen((KeyboardEvent e) {
            if(e.keyCode == 13) processCommand(textInputElement.value); //arc number strikes again
        });


    }

    void processCommand(String command) {
        textInputElement.value = "";
        gameText.text = "";
        roomText.text = "";
        displayText(Action.applyAction(command));
    }

    void displayText(String text) {
        new OneCharAtTimeWrapper(<Line>[new Line(text,gameText),new Line(currentPlayer.currentRoom.fullDescription,roomText)]).write();
    }

    void initRooms() {
        Room controlRoom = new Room("SBURBSim CONTROL ROOM",[],"a bizarre amagalmation of memes, coding paraphernalia and definitely no dictionaries. It fills you with an existential dread. JR is a demon.");

        Item couch = new Item("Familiar Couch",<String>["CASTING COUCH", "COUCH", "FAMILIAR COUCH"],"I want to destroy this accursed fucking piece of ikea looking trash. let me destroy it. Where's the destroy option that is all I am good for.");
        controlRoom.contents.add(couch);
        controlRoom.contents.add(new Item("Unsettling Sculpture",<String>["SCULPTURE", "UNSETTLING SCULPTURE", "PUZZLECOCK","PUZZLE COCK"],"I have no idea what the fuck this implies, but one thing I know is that it is absol-fucking-lutely delicious looking. I want to eat it. Let me eat it. Give."));
        //controlRoom.contents.add(new Item("",<String>["", "", "",""],""));

        controlRoom.contents.add(new Item("CatTroll Wigs",<String>["HAIR7", "WIG", "CATTROLL WIG","NEPETA WIG"],"Heheh."));
        controlRoom.contents.add(new Item("AB Charging Station",<String>["AB'S CHARGING STATION", "STATION", "CHARGING STATION"],"Oh is this where that uncanny valley looking robot of JR sleeps or some shit? Hm. Well. Can I legally make an apple joke here?"));
        controlRoom.contents.add(new Item("PL's Guide to Dart Book",<String>["BOOK", "DART BOOK","PL's GUIDE TO DART","PL'S GUIDE TO DART BOOK","PL'S BOOK","PL'S GUIDE BOOK"],"This would be useful probably. If I gave enough of a fuck about reading or putting effort into this."));
        controlRoom.contents.add(new Item("life size unicorn plush",<String>["UNICORN", "PLUSH", "HOOF BEAST","HOOFBEAST"],"This is like a fucking anomaly. it looks so normal from a distance but it's like, it's a fucking frankenfuck of other stuff creatured. How many corpses has JR got in this? "));
        controlRoom.contents.add(new Item("Toddler!JR 'Do it For Her' board",<String>["BOARD", "TODDLER JR BOARD", "DO IT FOR HER BOARD","TODDLER!JR 'DO IT FOR HER' BOARD"],"Pure. Blessed. Powerful. God Bless this board."));
        controlRoom.contents.add(new Item("JR's 4th Wall",<String>["WALL", "4TH WALL", "JR'S 4TH WALL","FENESTRATED WALL"],"Something something meta. If I climbed through this I could get myself some burgs."));



        Room testExit = new Room("Dennis",["DENNIS","DUDE","GUY","MEME"],"Ye arrive at Dennis. He wears a sporty frock coat and a long jimberjam. He paces about nervously. Obvious exits are NOT DENNIS.");
        controlRoom.exits.add(testExit);

        currentPlayer = new Player(controlRoom, "Shogun", <String>[],"a towering memelord, 1.3 JRs tall.");
    }

}