import 'dart:html';
import "OneCharAtTime.dart";

/*
knows about all the possible commands and the intro thingy.
 */

class Controller
{


    Element gameText = new DivElement();
    TextInputElement textInputElement = new TextInputElement();
    OneCharAtTimeWrapper intro;


    Controller(Element wrapper) {
        Element container = new DivElement();
        container.classes.add('game');
        gameText.classes.add('gameText');
        container.append(gameText);

        Element inputContainer = new DivElement();
        Element prompt = new SpanElement();
        inputContainer.append(prompt);
        inputContainer.append(textInputElement);
        prompt.text = ">";
        textInputElement.classes.add("gameInput");
        textInputElement.autofocus = true;

        container.append(inputContainer);
        wrapper.append(container);



        intro = new OneCharAtTimeWrapper(<Line>[new Line("A young Shogun stand in a control room. It just so happens that today, the 13th of January, 2018, is the day he finally took over SBURBSim. What will he do?",gameText)]);
        intro.write();
    }

}