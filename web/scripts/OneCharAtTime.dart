import 'dart:async';
import 'dart:html';

/// give it a string, a place to write it, and how fast to write it and it will take care of the rest.
 class OneCharAtTimeWrapper {

     List<Line> lines;
     Line currentLine;

    int msBetweenChars;
    int textIndex = 0;
    int lineIndex = 0;


    OneCharAtTimeWrapper(List<Line> this.lines, {this.msBetweenChars: 3});

    Future<Null> write() async {
        if(currentLine == null) currentLine = lines[0];
        //print("write");
        currentLine.div.text =  currentLine.text.substring(0, textIndex);
        textIndex ++;

        if(textIndex > currentLine.text.length) {
            nextLine();
        }

        if(currentLine != null) { //only a starting null is accepted
            new Timer(new Duration(milliseconds: msBetweenChars), () => write());
        }
    }

    void nextLine() {
        lineIndex ++;
        if(lineIndex >= lines.length) {
            currentLine = null;
            return;
        }
        textIndex = 0;
        currentLine = lines[lineIndex];
    }
 }

 class Line
{
    String text;
    Element div;
    Line(this.text, this.div);
}