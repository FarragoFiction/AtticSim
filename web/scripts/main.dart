import 'dart:html';
import "OneCharAtTime.dart";
void main() {
  //querySelector('#output').text = 'Your Dart app is running.';
  Element div = new DivElement();
  querySelector('#output').append(div);
  new OneCharAtTimeWrapper("Hello World", div).write();

}
