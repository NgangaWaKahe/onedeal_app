class Category {
  final String name;
  final String id;

  Category(this.name, this.id);

  static Category retrieveCategory(dynamic x) {
    return Category(x["name"], x["id"]);
  }
}
