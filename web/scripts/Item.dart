class Item {
    String name;
    List<String> alts;
    String description;
    //TODO have list of valid actions for this item, too.

    Item(String this.name, List<String> this.alts, String description);

    String toString() {
        return name;
    }
}