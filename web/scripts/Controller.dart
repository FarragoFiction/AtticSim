import 'dart:html';
import "OneCharAtTime.dart";
import "Room.dart";
import "Player.dart";
import 'dart:async';
import "Actions/Action.dart";

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

        Room controlRoom = new Room("SBURBSim CONTROL ROOM",[],"a bizarre amagalmation of memes, coding paraphernalia and definitely no dictionaries. It fills you with an existential dread. JR is a demon.");
        Room testExit = new Room("Dennis",[],"Ye arrive at Dennis. He wears a sporty frock coat and a long jimberjam. He paces about nervously. Obvious exits are NOT DENNIS.");
        controlRoom.exits.add(testExit);
        currentPlayer = new Player(controlRoom, "Shogun", <String>[],"a towering memelord, 1.3 JRs tall.");
        init();


    }

    Future<Null> init() async {

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

}