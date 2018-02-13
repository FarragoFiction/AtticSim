import 'dart:html';
import "OneCharAtTime.dart";
import "Room.dart";
import "Player.dart";
import 'dart:async';
import "Actions/Action.dart";
import "Item.dart";
import "random.dart";
import "weighted_lists.dart";
/*
knows about all the possible commands and the intro thingy.
 */

class Controller
{

    static Controller instance;
    Room controlConsole;

    int _totalAvailablePoints = -1300;

    int points = 0;
    DateTime currentDate;
    Element dateText = new DivElement();
    Element gameText = new DivElement();
    Element roomText = new DivElement();
    Element inventoryText = new DivElement();
    Element itemsText = new DivElement();
    Element exitsText = new DivElement();
    TextInputElement textInputElement = new TextInputElement();

    List<Player> players = new List<Player>();
    Player currentPlayer;
    Player shogun;
    Player jr;


    Controller(Element wrapper) {
        currentDate = new DateTime(2018, 1, 13);
        instance = this;
        Element container = new DivElement();
        container.classes.add('game');

        dateText.classes.add('date');
        container.append(dateText);

        gameText.classes.add('gameText');
        container.append(gameText);
        roomText.classes.add('gameText');
        container.append(roomText);

        container.append(inventoryText);
        inventoryText.classes.add('optionalText');

        container.append(itemsText);
        itemsText.classes.add('optionalText');

        container.append(exitsText);
        exitsText.classes.add('optionalText');



        Element inputContainer = new DivElement();
        inputContainer.classes.add("gameInputContainer");
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

    void calculateTotalAvailablePoints() {
        _totalAvailablePoints  = 0;
        for(Action a in Action.allActions) {
            _totalAvailablePoints += a.pointValue;
        }
    }

    int get totalAvailablePoints {
        if(_totalAvailablePoints < 0) {
            calculateTotalAvailablePoints();
        }
        return _totalAvailablePoints;
    }

    String moveTime() {
        currentDate = new DateTime(currentDate.year, currentDate.month, currentDate.day+7, currentDate.hour, currentDate.minute);
        WeightedList<String> snark = new WeightedList<String>();
        snark.add("You shitpost through the night. ",0.5);
        snark.add("You completely fail to sleep at all. ",0.5);
        snark.add("Wow, how did you spend THAT much time shitposting? May as well just not go to sleep. ",0.5);
        Random rand = new Random();
        return rand.pickFrom(snark);
    }

    Future<Null> init() async {
        initRooms();
        displayText("A young Shogun stands in a SBURBSim CONTROL ROOM. It just so happens that today, the 13th of January, 2018, is the day he finally took over SBURBSim. What will he do? Probably type commands in a 'look katana' sort of way. That does seem to be the type of game this is.");
        //don't have commands be enabled till intro is finished
        initTextListener();
    }

    void initTextListener() {
        window.onKeyDown.listen((KeyboardEvent e) {
            if(e.keyCode == 13) processCommand(textInputElement.value); //arc number strikes again
        });


    }

    void processCommand(String command) {
        currentDate = new DateTime(currentDate.year, currentDate.month, currentDate.day, currentDate.hour+3, currentDate.minute);

        textInputElement.value = "";
        gameText.text = "";
        roomText.text = "";
        itemsText.text = "";
        inventoryText.text = "";
        exitsText.text = "";
        displayText(Action.applyAction(command));
    }

    void displayText(String text) {
        print("displaying text, current player is ${currentPlayer} and they are in room ${currentPlayer.currentRoom}");
        String dateSlug ="${currentDate.year.toString()}-${currentDate.month.toString().padLeft(2,'0')}-${currentDate.day.toString().padLeft(2,'0')} ${currentDate.hour.toString().padLeft(2,'0')}:${currentDate.minute.toString().padLeft(2,'0')}";

        dateText.text = "$dateSlug Points: ${points}/${totalAvailablePoints}";
        new OneCharAtTimeWrapper(<Line>[new Line(text,gameText),new Line(currentPlayer.currentRoom.fullDescription,roomText),new Line(currentPlayer.itemsDescription,inventoryText),new Line(currentPlayer.currentRoom.itemsDescription,itemsText),new Line(currentPlayer.currentRoom.exitsDescription,exitsText)]).write();
    }

    void initRooms() {
        Room controlRoom = new Room("SBURBSim CONTROL ROOM",["ROOM","CONTROL ROOM","SBURBSim CONTROL ROOM"],"a bizarre amagalmation of memes, coding paraphernalia and definitely no dictionaries. It fills you with an existential dread. JR is a demon.","You attempt to use a room. Somehow. It probably happens.");

        Item couch = new Item("Familiar Couch",<String>["CASTING COUCH", "COUCH", "FAMILIAR COUCH"],"I want to destroy this accursed fucking piece of ikea looking trash. let me destroy it. Where's the destroy option that is all I am good for.","Nice try, but the Shogun doesn't sleep.",destroyable: true);
        controlRoom.contents.add(couch);
        controlRoom.contents.add(new Item("Unsettling Sculpture",<String>["SCULPTURE", "UNSETTLING SCULPTURE", "PUZZLECOCK","PUZZLE COCK"],"I have no idea what the fuck this implies, but one thing I know is that it is absol-fucking-lutely delicious looking. I want to eat it. Let me eat it. Give. (Is it made of Lucky Charms?)","You realize you would be much more comfortable simply eating the lucky charms sculpture.",consumable: true,portable: true));
        //controlRoom.contents.add(new Item("",<String>["", "", "",""],""));

        controlRoom.contents.add(new Item("CatTroll Wigs",<String>["HAIR7", "WIG", "CATTROLL WIG","NEPETA WIG"],"Heheh.","You try the wig on. You get the eerie feeling that the Narrator hates you just a little bit more now.",portable: true));
        controlRoom.contents.add(new Item("AB Charging Station",<String>["AB'S CHARGING STATION", "STATION", "CHARGING STATION"],"Oh is this where that uncanny valley looking robot of JR sleeps or some shit? Hm. Well. Can I legally make an apple joke here?","You attempt to use my charging station. Since you are a fleshy organic weakling, it fails to charge you."));
        controlRoom.contents.add(new Item("PL's Guide to Dart Book",<String>["BOOK", "DART BOOK","PL's GUIDE TO DART","PL'S GUIDE TO DART BOOK","PL'S BOOK","PL'S GUIDE BOOK"],"This would be useful probably. If I gave enough of a fuck about reading or putting effort into this.","You flip through the book. Huh, apparently JR scrawled crude pictures of dicks and shitty comics about how learning things in a structured way is fucking stupid. ",destroyable: true,portable: true));
        controlRoom.contents.add(new Item("life size unicorn plush",<String>["UNICORN", "PLUSH", "HOOF BEAST","HOOFBEAST"],"This is like a fucking anomaly. it looks so normal from a distance but it's like, it's a fucking frankenfuck of other stuff creatured. How many corpses has JR got in this? ","You admire the Unicorn in all it's unnatural glory.",destroyable: true));
        controlRoom.contents.add(new Item("Toddler!JR 'Do it For Her' board",<String>["BOARD", "TODDLER JR BOARD", "DO IT FOR HER BOARD","TODDLER!JR 'DO IT FOR HER' BOARD"],"Pure. Blessed. Powerful. God Bless this board.","You admire the board. Toddler JR is always full of such terrible ideas. They are your favorite JR."));
        controlRoom.contents.add(new Item("JR's 4th Wall",<String>["WALL", "4TH WALL", "JR'S 4TH WALL","FENESTRATED WALL"],"Something something meta. If I climbed through this I could get myself some burgs.","You attempt to crawl through JR's Fenestrated Window. Luckily, it is currently unpowered.",destroyable: true,portable: true));




        Room testExit = new Room("Dennis",["DENNIS","DUDE","GUY","MEME"],"Ye arrive at Dennis. He wears a sporty frock coat and a long jimberjam. He paces about nervously. Obvious exits are NOT DENNIS.","You use Dennis, you heartless monster.");
       // controlRoom.exits.add(testExit);

        //Control Console
        controlConsole = new Room("Control Console",["CONTROL CONSOLE","CONSOLE"],"the control console for SBURBSim. It's actually just a regular computer, with regular shit you can do on it, like shitpost or troll jr or buy shit online. It's not really a place, but close enough.","You fail to use the CONTROL CONSOLE as it requires a PASSWORD.");
        controlRoom.exits.add(controlConsole);
        controlConsole.exits.add(controlRoom);

        shogun = new Player(controlRoom, "Shogun", <String>["MAIN CHARACTER","PROTAGONIST","SHOGUN","SHOGUN OF SAUCE","MEMELORD","LORD OF WORDS", "FU","FUEDALULTIMATUM","THE ANTITHESIS","THE VILLAIN","VILLAIN"],"a towering memelord, 1.3 JRs tall. Who even IS he???", "You fail to use Shogun.");
        currentPlayer = shogun;
        currentPlayer.inventory.add(new Item("Katana",<String>["SWORD", "KATANA", "SHITTY SWORD","ANIME SWORD"],"This is an unbelievably shit sword. Where is Muramasa? Where is my blade why is it shit JR how dare you nerf me.","You contemplate using your shitty sword to DESTROY some object.", portable: true));
        currentPlayer.inventory.add(new Item("Mind Hoodie",<String>["MIND HOODIE", "HOODIE", "JACKET","COAT"],"No comment.","You feel so safe.", portable: true));

        jr  = new Player(controlRoom, "jadedResearcher", <String>["JR","JADEDRESEARCHER","THE WASTE","A WASTE","WASTE OF MIND","THE WASTE OF MIND","THE AUTHOR"],"A waste exactly 1.0 JRs tall. You created SBURBSim and like trolling the Shogun.","You fail to use JR.");
        jr.inventory.add(new Item("Yellow Yard",<String>["YELLOW YARD", "YARD", "YELLOW LAWNRING","STICK","GIMMICK"],"At least Shogun didn't break this. I hate it when I can't control all that fucking Waste shit.","You fail to change the Decisions that lead you here. You kind of want to see how this plays out.", portable: true));
        jr.inventory.add(new Item("Unbelievably Shitty Laptop",<String>["LAPTOP", "SHITTY LAPTOP", "SHIT","UNBELIEVABLY SHITTY LAPTOP","COMPUTER"],"Oh god. It's so shitty. I have to close programs just to compile the Sim. At least I still CAN work on the Sim, though. Plus, I can still Troll Shogun. This isn't so bad.","This should  troll shogun and not be seen directly.", portable: true));


        Room voidRoom = new Room("the Void",["VOID","SKAIAN MAGICANT"],"mostly void, partially stars. You feel like where you are isn't particularly narratively significant to AtticStuck. ","You decide to use the Void. Somehow.");
        Player pl  = new Player(voidRoom, "paradoxLands", <String>["PL","PARADOXLANDS","THE WITCH","A WITCH","THE WITCH OF VOID","THE ARCHITECT"],"The Architect, exactly 1.25 JRs tall. Good at both Art and Programming. Currently watching the shenanigans the Author and the Antithesis are up to and being very amused.","You fail to use PL.");
        Player kr  = new Player(voidRoom, "karmicRetribution", <String>["KR","KARMICRETRIBUTION","THE SMITH","A SMITH","THE SMITH OF DREAM","THE ARTIST"],"The Artist, exactly 1.05 JRs tall. Currently ignoring the shenanigans the Author and the Antithesis are up to entirely. JR knows they can just leave the attic at any time, don't they?","You fail to use KR.");
        Player mi  = new Player(voidRoom, "manicInsomniac", <String>["MI","MANICINSOMNIAC","THE BARD","A BARD","THE BARD OF DOOM","MANIC"],"You are suddenly accosted by about 50000 notes being played all at once. There is no rhyme, no reason, no connection. There is only chaos. Again. Man you need to learn how to stop your music program crashing.","You fail to use MI.");
        Player cd  = new Player(voidRoom, "Clubs Deuce", <String>["CD","COURTYARD DROLL","CLUBS DEUCE"],"You are now the CRAZY DESTROYER. You are SO HAPPY that you have this shiny shiny ring!!! ", "You use Clubs Deuce for your own ends.");
        Player hussie  = new Player(voidRoom, "Andrew Hussie", <String>["AH","ANDREW HUSSIE","HUSSIE","WASTE OF SPACE","HUSS OF LIPS"],"You have absolutely no idea what is going on.", "You use Andrew Hussie's IP to make shitty fan works.");
        Player smugWendy  = new Player(voidRoom, "Smug Wendy", <String>["SMUG WENDY","SMUG","WENDY"],"You deliver fresh, never frozen sass on twitter. Trickster!JR aspires to be you.", "You use the 'smug wendy' meme.");


        Room attic = new Room("Attic",["ATTIC","ROOM"],"mostly empty. You're probably trapped in here, in fact, you're suddenly sure of it. At the very least if you left you'd have to be in the same room as that asshole and like fuck THAT's happening. ","You decide to use this Attic as a base of operations in your campaign to annoy Shogun.");
        for(int i = 0; i <13; i++) {
            attic.contents.add(new Item("Box of Lucky Charms",<String>["LUCKY CHARMS", "LEWD CEREAL", "BOX OF LUCKY CHARMS","TROVE BAIT","CEREAL","CEREAL BOXES","BOXES","LUCKY CHARMS BOXES"],"Where did these even come from? Is this a trove thing? Did Shogun do this?","You assemble the Lucky Charms boxes into passable furniture.",consumable: true, portable: true));
        }
        attic.contents.add(new Item("Unbelievably Shitty Spook Wolf Head",<String>["WOLF", "WOLF HEAD", "UNBELIEVABLY SHITTY SPOOK WOLF HEAD","SCARY WOLF",'NIGHTMARE'],"It doesn't even do the 'light activated' spooky howl unless you go up to it on purpose. 3/10, not spooky at all.", "You puposefully activate the motion capture Spook Wolf. It manages to scare the shit out of you despite you being literally as prepared as it is Wastely possible."));
        jr.currentRoom = attic;
    }

}