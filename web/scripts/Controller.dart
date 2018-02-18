import 'dart:html';
import "OneCharAtTime.dart";
import "Room.dart";
import "Player.dart";
import 'dart:async';
import "Actions/Action.dart";
import "Actions/Vore.dart";

import "Item.dart";
import "random.dart";
import "weighted_lists.dart";
/*
knows about all the possible commands and the intro thingy.
 */

class Controller {
  static Controller instance;

  List<Delivery> expectedDeliveries = new List<Delivery>();
  Room controlConsole;
  Item jrComputer;

  int _totalAvailablePoints = -1300;

  int points = 0;
  DateTime currentDate = new DateTime(2018, 1, 13);
  DateTime endDate = new DateTime(2018, 2, 13);

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

  Item unicorn;
  Item nepetaWig;
  Item dartBook;
  Item guyFieriWig;
  Item passwordScrawl;
  //will never be eaten or destroyed
  Item mindHoodie;

  //special rooms
  Room voidRoom;
  Room dennis;

  Controller(Element wrapper) {
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

  List<Player> get playersNotInDennis {
    List<Player> ret = new List<Player>();
    for(Player p in players) {
      if(p.currentRoom != dennis) ret.add(p);
    }
    return ret;

  }

  //finds an item in Shogun's (not currently player's) inventory
  //dares him to eat it (diff text if it is or is not edible).
  String applyDare() {
    Random rand = new Random();
    Item chosen = rand.pickFrom(shogun.inventory);
    if(chosen == null) return "Shogun doesn't even have shit in his inventory, so lame.";
    String edible = "";
    WeightedList<String> taunts = new WeightedList<String>();
    if(chosen.respondsTo(new Vore())){
      taunts.addAll(<String>["...how can you even eat garbage like $chosen?","Bluh. That $chosen looks so gross.","Holy shit, how much $chosen do you even eat?", "Do you eat anything BUT $chosen? So gross. No wonder you can't sleep.", "You know, instead of eating all that $chosen you could just fucking sleep."]);
    }else {
      edible = "Whether or not is is, technically, edible.";
      //well NOW it's edible. and you get bonus points for it
      if(chosen != mindHoodie) {
        chosen.validActions.add(new Vore(130));
      }else {
        if(currentPlayer == shogun) {
          edible = " But you never would. JR is a fool for thinking otherwise.";
        }else {
          edible = "But it looks like he isn't tempted. Oh well.";
        }
      }
      taunts.addAll(<String>["... why the fuck do you look like you are thinking about eating $chosen?","... Are you seriously gonna eat $chosen?","Holy fuck, $chosen is not a food, why are you looking at it like that?"]);
    }
    taunts.add("... dare you to eat $chosen ;)",0.1);
    taunts.add("bet you can't eat $chosen ;)",0.1);

    if(currentPlayer == shogun) {
      return "${rand.pickFrom(taunts)} You feel a strong urge to eat the $chosen. $edible";
    }else {
      return "${rand.pickFrom(taunts)} You aren't quite sure if you hope he will or will not eat the $chosen. It's kind of fun how hard it is to predict Shogun! $edible";

    }
  }

  void calculateTotalAvailablePoints() {
    _totalAvailablePoints = 0;
    for (Action a in Action.allActions) {
      _totalAvailablePoints += a.pointValue;
    }
  }

  int get totalAvailablePoints {
    if (_totalAvailablePoints < 0) {
      calculateTotalAvailablePoints();
    }
    return _totalAvailablePoints;
  }

  String moveTime() {
    currentDate = new DateTime(currentDate.year, currentDate.month, currentDate.day + 3, currentDate.hour, currentDate.minute);
    WeightedList<String> snark = new WeightedList<String>();
    snark.add("You shitpost through the night. ", 0.5);
    snark.add("You completely fail to sleep at all. ", 0.5);
    snark.add("Wow, how did you spend THAT much time shitposting? May as well just not go to sleep. ", 0.5);
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
      if (e.keyCode == 13) processCommand(textInputElement.value); //arc number strikes again
    });
  }

  void processCommand(String command) {
    currentDate = new DateTime(currentDate.year, currentDate.month, currentDate.day, currentDate.hour + 3, currentDate.minute);

    textInputElement.value = "";
    gameText.text = "";
    roomText.text = "";
    itemsText.text = "";
    inventoryText.text = "";
    exitsText.text = "";
    displayText(Action.applyAction(command));
  }

  String checkDeliveries() {
    String ret = "";
    List<Delivery> toRemove = new List<Delivery>();
    for (Delivery d in expectedDeliveries) {
      if (d.checkDelivery()) {
        shogun.inventory.add(d.item);
        //print("Delivery $d is ready with ${d.item}");
        ret += " You got a ${d.item} delivered! ";
        toRemove.add(d);
      }
    }

    for (Delivery d in toRemove) {
      expectedDeliveries.remove(d);
    }

    if (expectedDeliveries.isNotEmpty) ret += " You are expecting ${expectedDeliveries.length} deliveries";

    return ret;
  }

  void endGame() {
      String ending =  "It has been a full month since Shogun shit post his way into the SBURBSim Control room. Can JR shitpost their way back?";
      String embed = '<iframe width="560" height="315" src="https://www.youtube.com/embed/hS5c7p8zFSY" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>';
      inventoryText.appendHtml(embed, treeSanitizer: NodeTreeSanitizer.trusted);
      String bodyPillow = "$ending <br><br> $embed <br><br>It seems to have worked! Shogun seems to have fled in confusion and terror and or boredom. But what's this he left behind amid the flood of weird useless shit he bought online? A...body pillow of JR? <br><br><img src = 'images/130333a.png'><br><br>You suddenly realize that those points didn't even matter. What the hell. JR is so shit at making games.";
      querySelector("#reward").appendHtml(bodyPillow, treeSanitizer: NodeTreeSanitizer.trusted);
      gameText.text = ending;

  }
  void displayText(String text) {
      if(checkEnd()) {
        endGame();
        return;
      }
    //print("displaying text, current player is ${currentPlayer} and they are in room ${currentPlayer.currentRoom}");
    String dateSlug = "${currentDate.year.toString()}-${currentDate.month.toString().padLeft(2,'0')}-${currentDate.day.toString().padLeft(2,'0')} ${currentDate.hour.toString().padLeft(2,'0')}:${currentDate.minute.toString().padLeft(2,'0')}";

    String newItems = checkDeliveries();
    dateText.text = "$dateSlug Points: ${points}/${totalAvailablePoints} $newItems";
    new OneCharAtTimeWrapper(<Line>[new Line(text, gameText), new Line(currentPlayer.currentRoom.fullDescription, roomText), new Line(currentPlayer.itemsDescription, inventoryText), new Line(currentPlayer.currentRoom.itemsDescription, itemsText), new Line(currentPlayer.currentRoom.exitsDescription, exitsText)]).write();
  }

  bool checkEnd() {
      Duration diff = currentDate.difference(endDate);
      int ret = diff.inMinutes;
      if (ret > 0) {
          return true;
      }
      return false;
  }

  void initRooms() {
    Room controlRoom = new Room("SBURBSim CONTROL ROOM", ["ROOM", "CONTROL ROOM", "SBURBSim CONTROL ROOM"], "a bizarre amagalmation of memes, coding paraphernalia and definitely no dictionaries. It fills you with an existential dread. JR is a demon.", "You attempt to use a room. Somehow. It probably happens.");

    Item couch = new Item("Familiar Couch", <String>["CASTING COUCH", "COUCH", "FAMILIAR COUCH"], "I want to destroy this accursed fucking piece of ikea looking trash. let me destroy it. Where's the destroy option that is all I am good for.", "Nice try, but the Shogun doesn't sleep.", destroyable: true);
    controlRoom.contents.add(couch);
    controlRoom.contents.add(new Item("Unsettling Sculpture", <String>["SCULPTURE", "UNSETTLING SCULPTURE", "PUZZLECOCK", "PUZZLE COCK"], "I have no idea what the fuck this implies, but one thing I know is that it is absol-fucking-lutely delicious looking. I want to eat it. Let me eat it. Give. (Is it made of Lucky Charms?)", "You realize you would be much more comfortable simply eating the lucky charms sculpture.", consumable: true, portable: true));
    //controlRoom.contents.add(new Item("",<String>["", "", "",""],""));

    nepetaWig = new Item("Hair7 Wig", <String>["HAIR7", "WIG", "CATTROLL WIG", "NEPETA WIG", "HAIR7 WIG"], "Heheh.", "You try the wig on. You get the eerie feeling that the Narrator hates you just a little bit more now.", portable: true, useConditionString: Item.UNICORNMETHOD);
    controlRoom.contents.add(nepetaWig);
    controlRoom.contents.add(new Item("AB's Charging Station", <String>["AB'S CHARGING STATION", "STATION", "CHARGING STATION","AB CHARGING STATION"], "Oh is this where that uncanny valley looking robot of JR sleeps or some shit? Hm. Well. Can I legally make an apple joke here?", "You attempt to use my charging station. Since you are a fleshy organic weakling, it fails to charge you."));
    dartBook = new Item("PL's Guide to Dart Book", <String>["BOOK", "DART BOOK", "PL's GUIDE TO DART", "PL'S GUIDE TO DART BOOK", "PL'S BOOK", "PL'S GUIDE BOOK"], "This would be useful probably. If I gave enough of a fuck about reading or putting effort into this.", "You flip through the book. Huh, apparently JR scrawled crude pictures of dicks and shitty comics about how learning things in a structured way is fucking stupid. ", destroyable: true, portable: true, useConditionString: Item.APPRECIATEPL);
    controlRoom.contents.add(dartBook);

    unicorn = new Item("life size unicorn plush", <String>["FRANKENFUCK UNICORN", "UNICORN", "PLUSH", "HOOF BEAST", "HOOFBEAST"], "This is like a fucking anomaly. it looks so normal from a distance but it's like, it's a fucking frankenfuck of other stuffed creatures. How many corpses has JR got in this? ", "You admire the FrankenFuck Unicorn in all it's unnatural glory. You wish you could ride it, but you aren't quite...stylish enough.", destroyable: true, useConditionString: Item.WIGRIDER);
    controlRoom.contents.add(unicorn);
    controlRoom.contents.add(new Item("Toddler!JR 'Do it For Her' board", <String>["BOARD", "TODDLER JR BOARD", "DO IT FOR HER BOARD", "TODDLER!JR 'DO IT FOR HER' BOARD"], "Pure. Blessed. Powerful. God Bless this board.", "You admire the board. Toddler JR is always full of such terrible ideas. They are your favorite JR."));
    controlRoom.contents.add(new Item("JR's 4th Wall", <String>["WALL", "4TH WALL", "JR'S 4TH WALL", "FENESTRATED WALL"], "Something something meta. If I climbed through this I could get myself some burgs.", "You attempt to crawl through JR's Fenestrated Window. Luckily, it is currently unpowered.", destroyable: true, portable: true));
    passwordScrawl = new Item("scrawled password riddle", <String>["PASSWORD","SCRAWLED PASSWORD RIDDLE", "SCRAWL", "GIGGLESNORT", "RIDDLE"], "... is JR's password REALLY 'where is everything better than expected?' What a shit riddle.", "You stare in frustration at the gigglesnort.", destroyable: true, portable: true, consumable: true, useConditionString: Item.USEPASSWORD);
    controlRoom.contents.add(passwordScrawl);

    dennis = new Room("Dennis", ["DENNIS", "DUDE", "GUY", "MEME"], "Ye arrive at Dennis. He wears a sporty frock coat and a long jimberjam. He paces about nervously. Obvious exits are NOT DENNIS.", "You use Dennis, you heartless monster.");
    // controlRoom.exits.add(testExit);
    Item flask = new Item("ye flask", <String>["YE FLASK"], "Is. Is this a refrance?","You cannot get ye flask.", destroyable: true,consumable: true);
    dennis.contents.add(flask);

    //Control Console
    controlConsole = new Room("Control Console", ["CONTROL CONSOLE", "CONSOLE"], "the control console for SBURBSim. It's actually just a regular computer, with regular shit you can do on it, like shitpost or troll jr or buy shit online. It's not really a place, but close enough.", "You fail to use the CONTROL CONSOLE as it requires a PASSWORD.");
    controlRoom.exits.add(controlConsole);
    jrComputer = new Item("Password Locked JR's Computer", <String>["COMPUTER", "UNLOCKED COMPUTER", "UNLOCKED JR'S COMPUTER", "PASSWORD LOCKED COMPUTER", "JR'S COMPUTER", "PASSWORD LOCKED JR'S COMPUTER"], "JR's computer, with a shitty password.", "You have no idea what the password is, so you can't use it.", useConditionString: Item.ORDERSHIT);
    controlConsole.contents.add(jrComputer);

    controlConsole.exits.add(controlRoom);

    shogun = new Player(controlRoom, "Shogun", <String>["MAIN CHARACTER", "PROTAGONIST", "SHOGUN", "SHOGUN OF SAUCE", "MEMELORD", "LORD OF WORDS", "FU", "FUEDALULTIMATUM", "THE ANTITHESIS", "THE VILLAIN", "VILLAIN"], "a towering memelord, 1.3 JRs tall. Who even IS he???", "You fail to use Shogun.");
    currentPlayer = shogun;
    currentPlayer.inventory.add(new Item("Katana", <String>["SWORD", "KATANA", "SHITTY SWORD", "ANIME SWORD"], "This is an unbelievably shit sword. Where is Muramasa? Where is my blade why is it shit JR how dare you nerf me.", "You contemplate using your shitty sword to DESTROY some object.", portable: true));
    mindHoodie = new Item("Mind Hoodie", <String>["MIND HOODIE", "HOODIE", "JACKET", "COAT"], "No comment.", "You feel so safe.", portable: true);
    shogun.inventory.add(mindHoodie);

    jr = new Player(controlRoom, "jadedResearcher", <String>["JADED","WASTED","JR", "JADEDRESEARCHER", "THE WASTE", "A WASTE", "WASTE OF MIND", "THE WASTE OF MIND", "THE AUTHOR"], "A waste exactly 1.0 JRs tall. You created SBURBSim and like trolling the Shogun.", "You fail to use JR.");
    jr.inventory.add(new Item("Yellow Yard", <String>["YELLOW YARD", "YARD", "YELLOW LAWNRING", "STICK", "GIMMICK"], "At least Shogun didn't break this. I hate it when I can't control all that fucking Waste shit.", "You fail to change the Decisions that lead you here. You kind of want to see how this plays out.", portable: true));
    jr.inventory.add(new Item("Unbelievably Shitty Laptop", <String>["LAPTOP", "SHITTY LAPTOP", "SHIT", "UNBELIEVABLY SHITTY LAPTOP", "COMPUTER"], "Oh god. It's so shitty. I have to close programs just to compile the Sim. At least I still CAN work on the Sim, though. Plus, I can still Troll Shogun. This isn't so bad.", "This should  troll shogun and not be seen directly.", portable: true));
    jr.inventory.add(new Item("Dr Pepper BBQ Sauce", <String>["SAUCE", "BBQ SAUCE", "DR PEPPER BBQ SAUCE"], "I am hiding this from Shogun and it's HILARIOUS.", "Use it? What would I even do with it? It's just shitty soda flavored sauce.", portable: true));
    jr.inventory.add(new Item("Meta Bullshit", <String>["META BULLSHIT", "BULLSHIT", "META","LIST OF COMMANDS","LIST","COMMANDS"], "It's a list of all the commands in this game. huh. Be. Destroy. Go. Look. Shitpost. Sleep. Take. Troll. Use. Vore. [REDACTED], Hopefully JR wasn't a lazy piece of shit and forgot to keep this updated. You're also pretty sure that all these commands have other words that mean the same thing, too. That 'vore' in particular is unsettling you.", "Use it? Why don't you just type all those commands, dunkass.", portable: true));


    voidRoom = new Room("the Void", ["VOID", "SKAIAN MAGICANT"], "mostly void, partially stars. You feel like where you are isn't particularly narratively significant to AtticStuck. ", "You decide to use the Void. Somehow.");
    voidRoom.exits.add(dennis);

    Player pl = new Player(voidRoom, "paradoxLands", <String>["PL", "PARADOXLANDS", "THE WITCH", "A WITCH", "THE WITCH OF VOID", "THE ARCHITECT"], "The Architect, exactly 1.25 JRs tall. Good at both Art and Programming. Currently watching the shenanigans the Author and the Antithesis are up to and being very amused.", "You fail to use PL.");
    Player kr = new Player(voidRoom, "karmicRetribution", <String>["KR", "KARMICRETRIBUTION", "THE SMITH", "A SMITH", "THE SMITH OF DREAM", "THE ARTIST"], "The Artist, exactly 1.05 JRs tall. Currently ignoring the shenanigans the Author and the Antithesis are up to entirely. JR knows they can just leave the attic at any time, don't they?", "You fail to use KR.");
    Player mi = new Player(voidRoom, "manicInsomniac", <String>["MI", "MANICINSOMNIAC", "THE BARD", "A BARD", "THE BARD OF DOOM", "MANIC"], "You are suddenly accosted by about 50000 notes being played all at once. There is no rhyme, no reason, no connection. There is only chaos. Again. Man you need to learn how to stop your music program crashing.", "You fail to use MI.");
    Player cd = new Player(voidRoom, "Clubs Deuce", <String>["CD", "COURTYARD DROLL", "CLUBS DEUCE"], "You are now the CRAZY DESTROYER. You are SO HAPPY that you have this shiny shiny ring!!! ", "You use Clubs Deuce for your own ends.");
    Player hussie = new Player(voidRoom, "Andrew Hussie", <String>["AH", "ANDREW HUSSIE", "HUSSIE", "WASTE OF SPACE", "HUSS OF LIPS"], "You have absolutely no idea what is going on.", "You use Andrew Hussie's IP to make shitty fan works.");
    Player smugWendy = new Player(voidRoom, "Smug Wendy", <String>["SMUG WENDY", "SMUG", "WENDY"], "You deliver fresh, never frozen sass on twitter. Trickster!JR aspires to be you.", "You use the 'smug wendy' meme.");
    Player shogunBot = new Player(voidRoom, "ShogunBot", <String>["SHOGUNBOT", "SB"], "You have an unending desire to destroy, and actually don't like Unicron as much as Shogun thinks you do.", "You perpetuate human-robot stereotypes.");
    Player authorBot = new Player(voidRoom, "AuthorBot", <String>["AUTHORBOT", "AB"], "You have no idea why your BioDoppelganger is so obsessed with annoying that Shogun. Whatever, who can understand organics?", "Fuck no. Go 'use' someone else, asshole. I'm working here.");
    Player abj = new Player(voidRoom, "AuthorBotJunior", <String>["AUTHORBOTJUNIOR", "ABJ","SOMEONE INTERESTING"], "Hrmmm... ABJ is... Yes. That IS a lighter. Interesting. I didn't know cruxite was flammable.", "Hrmmm...");
    Player somebody = new Player(voidRoom, "somebody", <String>["SOMEBODY","SB","nobody","the brope"], " Somebody would like to tell you all about the cult of Dutton.", "You fail to use them.");
    Player rs = new Player(voidRoom, "recursiveSlacker", <String>["RECURSIVESLACKER","RS"], " RS is unimpressed at what you've been doing in the void. They know.", "You fail to use them.");
    Player aw = new Player(voidRoom, "aspiringWatcher", <String>["ASPIRINGWATCHER","AW"], " AW has been watching you and writing things down.", "You fail to use them.");
    Player io = new Player(voidRoom, "insufferableOracle", <String>["INSUFFERABLEORACLE","IO"], " IO shows you their bloodswap trolls. They are amazing.", "You fail to use them.");
    Player tg = new Player(voidRoom, "tableGuardian", <String>["TABLEGUARDIAN","TG"], " TG is guarding tables from society and society from tables. Also debugging the sim.", "You fail to use them.");
    Player wm = new Player(voidRoom, "wooMod", <String>["WOOMOD","WM"], " WM is planning elaborate SBURB rpgs.", "You fail to use them.");
    Player dm = new Player(voidRoom, "dilettantMathematian", <String>["DILETTANTMATHEMATICIAN","DM"], " DM is working on incredibly impressive math. ", "You fail to use them.");
    Player fp = new Player(voidRoom, "flippetUrnways", <String>["FLIPPETURNWAYS","MISTER SIR FLIPPET MOTHERFUCKER"], " Flippet is working on the Hedron Scheme. They know who Shogun is, and have formed a support group for those who want to find out.", "You fail to use them.");
    Player pb = new Player(voidRoom, "pineappleBoi", <String>["PINEAPPLEBOI","PB"], " PineappleBOI is ... huh. Wow. You didn't know you could use lucky charms in math equations. ", "You fail to use them.");
    Player df = new Player(voidRoom, "dystopicFuturism", <String>["DYSTOPICFUTURISIM","DF","DARTH PEANUT BRITTLE","PEANUT","PEANUTBRITTLE"], " DF is making amazing panel edits. ", "You fail to use them.");
    Player fortyseven = new Player(voidRoom, "47", <String>["47"], " 47 is ... actually, you know what? No. ", "You fail to use them.");
    Player eon = new Player(voidRoom, "eon", <String>["EON"], " Eon is thinking about Transformers.  ", "You fail to use them.");
    Player cool = new Player(voidRoom, "coolthulu", <String>["COOLTHULU","COOL"], " Coolthulu isn't surprised you summoned them on accident, though usually people expect Cthulhu. ", "You fail to use them.");
    Player twentyeighteen = new Player(voidRoom, "2018 Personified", <String>["2018 PERSONIFIED","DOOP"], "2018 Personified is busy being disappointed by the ending of Homestuck. ", "You fail to use them.");
    Player cactus = new Player(voidRoom, "cactus", <String>["CACTUS", "PLANT", "SPIKES", "PLANT OF SPIKES"], " Cactus isn't going to ever back down from their spirit animal being a cactus. You just have to deal with that. You sit on the windowsill and contemplate reality. They know who Shogun is.", "You attempt to use Cactus but the spikes prevent you from touching them.");

    Player ms = new Player(voidRoom, "mysteriousSource", <String>["MYSTERIOUSSOURCE","ZAQ","MS"], " MS is busy drawing fascinating pictures. ", "You fail to use them.");
    Player goose = new Player(voidRoom, "Goose", <String>["GOOSE","RT"], " Goose is listening to their favorite pieces of music and sharing them online.", "You fail to use them.");
    Player jp = new Player(voidRoom, "jegusPersona", <String>["JEGUSPERSONA","JP"], "JP is starting shitty fanfic readings. It's so great.", "You fail to use them.");
    Player sz = new Player(voidRoom, "sniperZee", <String>["SNIPERZEE","SZ"], "SZ is getting excited about the privitization of space travel. They know who Shogun is.", "You fail to use them.");
    Player cl = new Player(voidRoom, "cartlord", <String>["CARTLORD","CL"], "CL is making sure to credit original artists.", "You fail to use them.");
    Player ath = new Player(voidRoom, "Athena", <String>["ATHENA","ATH"], "ATH is making level designs.", "You fail to use them.");
    Player star = new Player(voidRoom, "star.eyes", <String>["STAR.EYES","STAR"], "star.eyes is making amazing abj x kid boi x nepeta fanfics and comics.", "You fail to use them.");
    Player bunpt = new Player(voidRoom, "Bunpt", <String>["BUNPT","RUSTGAZE"], "Bunpt is helpfully using Dutton to protect us all.", "You fail to use them.");
    Player cmj = new Player(voidRoom, "Cotton Mouth Joe", <String>["COTTONMOUTHJOE","CMJ"], "Cotton Mouth Joe just wants to help.", "You fail to use them.");
    //main, some of you know who shogun is. some do not.
    Player orange = new Player(voidRoom, "Orange Speedo Asshole", <String>["ORANGE", "ORANGE SPEEDO ASSHOLE", "OSA", "CITRUS"], "You are sitting in the Void eating pretzels. You have no intention of getting up. You are still happy you got to be the CONTEST OFFICIAL for the JR vs Shogun competition.", "You use Orange to make some delicious juice. This is murder. Wait, except it never happens. False alarm. This game doesn't let you kill players.");
    new Player(voidRoom, "Sandwich", <String>["SANDWICH", "SATAN", "LUCIFER", "THE DEVIL", "BREAD-BASED FUCK"], "You are sitting in the Void being a sandwich. You have no intention of getting up.", "You eat Sandwich. This is hilarious. Or would be if Player murder was allowed in this game. If Shogun doesn't get to kill JR, no one gets to die.");
    Player Blabk = new Player(voidRoom, "Blabk", <String>["BLABK", "BUSHI", "BLAPCK", "BLABCK"], "You are sitting in the Void doing...something. You have no intention of getting up.", "You fail to eat Bushi. What the fuck.");
    new Player(voidRoom, "Ancient", <String>["ANCIENT"], "You are thinking about troll wrestling, or flex grappling. Also, Troll Kid Rock.", "You fail to use them.");
    Player fighterPup = new Player(voidRoom, "fighterPup", <String>["FP", "FIGHTERPUP", "PUPPER"], "You are now fighterPup. You are chasing your tail. This is so much fun.", "You use fighterPup to fetch a ball. Amazing.");
    Player fef = new Player(voidRoom, "fef", <String>["FEF", "INKAY", "CUTTLEFISH"], "You are now fef. You immediately attempt to summon an improbable number of cuttlefish.", "You feel as if you are reaching into an infinite void of tentacles and oddly-shaped eyes. Glub glub.");
    Player sage = new Player(voidRoom, "sage", <String>["SAGE"], "You are now sage. You observe the brooding caverns with a keen eye.", "Sage begins drawing trolls and never stops.");
    Player Firanka = new Player(voidRoom, "Firanka", <String>["FIRANKA", "FIRANKAMIPINSKA"], "You are now Firanka. This is absolutely ridiculous.", "You attempt to use Firanka but you cannot. Firanka controls you.");
    Player cumulusCanine = new Player(voidRoom, "cumulusCanine", <String>["CUMULUSCANINE", "CC", "DOG", "MAJIMJAM"], "You are now cumulusCanine. You are a good boy. The best. You know who Shogun is.", "You cannot use cumulusCanine, but you play for several hours. This is great fun.");
    Player yogisticDoctor = new Player(voidRoom, "Doc Mahjong", <String>["YOG", "YD", "YOGISTICDOCTOR", "DOC MAHJONG", "YOGISTIC DOCTOR"], "You are now Doc Mahjong. Everything is going according to plan. Soon, your master will arrive.", "You cannot use Doc Mahjong. He will not allow it.");
    Player shanks = new Player(voidRoom, "Seven Shanks", <String>["SS", "SEVEN SHANKS", "SHANKS"], "You are now Seven Shanks. Unsurprisingly, you are stabbing things.", "You use Shanks to stab things.");
    Player floral = new Player(voidRoom, "floralShenanigans", <String>["FLORAL", "FS", "FLORALSHENANIGANS"], "You are now floralShenanigans. You are creating more alt!Shoguns to kiss each other.", "floralShenanigans makes amazing fanart of you.");
    Player skylos = new Player(voidRoom, "chernobylsAquacade", <String>["CHERNOBYLSAQUACADE", "CA", "SKYLOSTEMPLAR","ST"], "You are busy stealing Sauce from Shogun and redestributing it to the masses.", "You fail to use them.");
    new Player(voidRoom, "catatonicKeeper", <String>["CATATONICKEEPER", "CK"], "Knows who Shogun is.", "You fail to use them.");
    new Player(voidRoom, "feverentAcolyte", <String>["FEVERENTACOLYTE", "FA"], "Knows who Shogun is.", "You fail to use them.");
    new Player(voidRoom, "gibberingPhilosopher", <String>["GIBBERINGPHILOSOPHER", "GP"], "Knows who Shogun is.", "You fail to use them.");
    new Player(voidRoom, "jovianArchiver", <String>["JOVIANARCHIVER", "JA"], "Knows who Shogun is.", "You fail to use them.");
    new Player(voidRoom, "ActuallyTerrific", <String>["ACTUALLYTERRIFIC", "AT"], "Knows who Shogun is.", "You fail to use them.");
    new Player(voidRoom, "brokenPlayer", <String>["BROKENPLAYER", "BP"], "Knows who Shogun is.", "You fail to use them.");
    new Player(voidRoom, "asinineGodsend", <String>["ASININEGODSEND", "AG"], "Is  a deputy. Knows who Shogun is.", "You fail to use them.");
    new Player(voidRoom, "asocialGoldfish", <String>["ANSTUS", "AG","ASOCIALGOLDFISH",'SA',"CI"], "You are responsible for Anstus, and the self-cest meme. You knows who Shogun is.", "You fail to use them.");
    new Player(voidRoom, "decidedlyEntropic", <String>["DECIEDLYENTROPIC", "DA"], "Knows who Shogun is. Wishes you could input 'update sim' anywhere in this game.", "You fail to use them.");
    new Player(voidRoom, "Duck King", <String>["DUCKKING", "DUCK","DK"], "Knows who Shogun is. Has the patience to smith all things. Master of the JR themed shitpost.", "You fail to use them.");
    new Player(voidRoom, "FirankaMipińska", <String>["FIRANKAMIPINSKA", "FM"], "Knows who Shogun is. Good at catching bugs.", "You fail to use them.");
    new Player(voidRoom, "flame_warp", <String>["FLAME_WARP", "FW","FLAMEWARP"], "Knows who Shogun is, and also how tiny Jack is.", "You fail to use them.");
    new Player(voidRoom, "insipidTestimony", <String>["INSIPIDTESTIMONY", "IT"], "Knows who Shogun is and inspired the good vibes channel.", "You fail to use them.");
    new Player(voidRoom, "maskedProxy", <String>["MASKEDPROXY", "MP"], "Knows who Shogun is. It's a puzzle.", "You fail to use them.");
    new Player(voidRoom, "Cat, fireRachet", <String>["CAT, FIRERACHET", "FR","CAT","FIRERACHET"], "Knows who Shogun is, and blames them for taking all their name changing scrolls.", "You fail to use them.");
    new Player(voidRoom, "creativeDungeoneer", <String>["CREATIVEDUNGEONEER", "CD"], "You are currently working on your next  meme.", "You fail to use them.");
    new Player(voidRoom, "wongle", <String>["WONGLE", "WB"], "You have dedicated your life to making sprite edits.", "You fail to use them.");

    //new Player(voidRoom, "chernobylsAquacade", <String>["CHERNOBYLSAQUACADE", "CA"], "", "You fail to use them.");







    Room attic = new Room("Attic", ["ATTIC", "ROOM"], "mostly empty. You're probably trapped in here, in fact, you're suddenly sure of it. At the very least if you left you'd have to be in the same room as that asshole and like fuck THAT's happening. ", "You decide to use this Attic as a base of operations in your campaign to annoy Shogun.");
    for (int i = 0; i < 13; i++) {
      attic.contents.add(new Item("Box of Lucky Charms", <String>["BOX","LUCKY CHARMS", "LEWD CEREAL", "BOX OF LUCKY CHARMS", "TROVE BAIT", "CEREAL", "CEREAL BOXES", "BOXES", "LUCKY CHARMS BOXES"], "Where did these even come from? Is this a trove thing? Did Shogun do this?", "You assemble the Lucky Charms boxes into passable furniture.", consumable: true, portable: true));
    }
    attic.contents.add(new Item("Unbelievably Shitty Spook Wolf Head", <String>["WOLF", "WOLF HEAD", "UNBELIEVABLY SHITTY SPOOK WOLF HEAD", "SCARY WOLF", 'NIGHTMARE'], "It doesn't even do the 'light activated' spooky howl unless you go up to it on purpose. 3/10, not spooky at all.", "You puposefully activate the motion capture Spook Wolf. It manages to scare the shit out of you despite you being literally as prepared as it is Wastely possible."));
    jr.currentRoom = attic;
  }
}

class Delivery {
  Item item;
  DateTime expectedDeliveryTime;

  Delivery(Item this.item) {
    DateTime currentDate = Controller.instance.currentDate;
    expectedDeliveryTime = new DateTime(currentDate.year, currentDate.month, currentDate.day + 4, currentDate.hour, currentDate.minute);
  }

  bool checkDelivery() {
    DateTime currentDate = Controller.instance.currentDate;
    Duration diff = currentDate.difference(expectedDeliveryTime);
    int ret = diff.inMilliseconds;
    if (ret > 0) {
      return true;
    }
    return false;
  }
}
