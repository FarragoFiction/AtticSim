import 'dart:html';
import "Controller.dart";
Controller controller;
void main() {
  //querySelector('#output').text = 'Your Dart app is running.';
  controller = new Controller(querySelector('#output'));
}
