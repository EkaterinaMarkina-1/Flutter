// class ShoppingCart {
//   final List<Item> items = []; // Список товаров в корзине

//   // Добавление товара в корзину
//   void addItem(Item item) {
//     items.add(item);
//   }

//   // Удаление товара из корзины
//   void removeItem(Item item) {
//     items.remove(item);
//   }

//   // Получение общей стоимости корзины
//   double get totalCost {
//     return items.fold(0, (total, item) => total + item.price);
//   }

//   // Проверка, пуста ли корзина
//   bool get isEmpty => items.isEmpty;
// }

// class Item {
//   final String name; // Название товара
//   final double price; // Цена товара

//   Item(this.name, this.price);
// }
