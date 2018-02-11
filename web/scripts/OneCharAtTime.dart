import 'dart:async';
import 'dart:html';

/// give it a string, a place to write it, and how fast to write it and it will take care of the rest.
 class OneCharAtTimeWrapper {

    String text;
    Element div;
    int msBetweenChars;
    int textIndex = 0;

    OneCharAtTimeWrapper(String this.text, Element this.div, {this.msBetweenChars: 10});

    Future<Null> write() async {
        print("write");
        div.text =  text.substring(0, textIndex);
        textIndex ++;
        if(textIndex <= text.length) {
            new Timer(new Duration(milliseconds: msBetweenChars), () => write());
        }

    }

}