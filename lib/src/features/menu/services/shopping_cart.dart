class ShoppingCart {
  final List<Item> items = []; // Список товаров в корзине

  void addItem(Item item) {
    items.add(item);
  }

  void removeItem(Item item) {
    items.remove(item);
  }

  double get totalCost {
    return items.fold(0, (total, item) => total + item.price);
  }

  bool get isEmpty => items.isEmpty;
}

class Item {
  final String name;
  final double price;

  Item(this.name, this.price);
}
