import 'package:flutter/material.dart';

const kSecondaryColor = Color(0xFFF5F5F5);
const kTextColor = Color(0xFF222222);
const kTextLightColor = Color(0xFF9A9A9A);
const kGrey = Colors.grey;
const kWhite = Colors.white;
const kAppBarColor = Color.fromARGB(255, 53, 65, 92);
const kRedColor = Color.fromARGB(255, 254, 178, 157);

const double kDefaultPadding = 20.0;
const double kCategoryCardWidth = 220.0;
const double kCategoryHeight = 80.0;
const double kCategoryHeight2 = 900.0;
const double kCategoryCoffeeHeight = 1070.0;
const double kCategoryDrinksHeight = 810.0;
const double kCategoryHotDrinksHeight = 850.0;
const double kCategoryFreshHeight = 200.0;

const List<String> categories = [
  "Классический кофе",
  "Авторский кофе",
  "Сезонное меню напитков",
  "Горячие напитки",
  "Фреши"
];

const Map<String, Map<String, dynamic>> coffeeInfo = {
  "Классический кофе": {
    "products": [
      "Американо",
      "Мокачино на альт.молоке",
      "Капучино",
      "Капучино на альт. молоке",
      "Латте",
      "Латте на альт. молоке",
      "Мокачино",
      "Раф"
    ],
    "images": [
      "assets/images/classic_1.jpg",
      "assets/images/classic_2.jpg",
      "assets/images/classic_3.jpg",
      "assets/images/classic_4.jpg",
      "assets/images/classic_5.jpg",
      "assets/images/classic_6.jpg",
      "assets/images/classic_7.jpg",
      "assets/images/classic_8.jpg"
    ],
    "prices": {
      "Американо": "160 ₽",
      "Мокачино на альт.молоке": "230 ₽",
      "Капучино": "200 ₽",
      "Капучино на альт. молоке": "230 ₽",
      "Латте": "200 ₽",
      "Латте на альт. молоке": "260 ₽",
      "Мокачино": "170 ₽",
      "Раф": "250 ₽"
    }
  },
  "Авторский кофе": {
    "products": [
      "Вьетнамская классика",
      "Кофе Бичерин",
      "Кофе Бон Бон",
      "Кофе по-генуэзски на латте",
      "Кофе по-ливийски с куркумой",
      "Мачу-Пикчу",
      "Сайгон",
      "Сицилийский апельсин на латте"
    ],
    "images": [
      "assets/images/autor_1.jpg",
      "assets/images/autor_2.jpg",
      "assets/images/autor_3.jpg",
      "assets/images/autor_4.jpg",
      "assets/images/autor_5.jpg",
      "assets/images/autor_6.jpg",
      "assets/images/autor_7.jpg",
      "assets/images/autor_8.jpg"
    ],
    "prices": {
      "Вьетнамская классика": "190 ₽",
      "Кофе Бичерин": "210 ₽",
      "Кофе Бон Бон": "220 ₽",
      "Кофе по-генуэзски на латте": "250 ₽",
      "Кофе по-ливийски с куркумой": "220 ₽",
      "Мачу-Пикчу": "190 ₽",
      "Сайгон": "250 ₽",
      "Сицилийский апельсин на латте": "260 ₽"
    }
  },
  "Сезонное меню напитков": {
    "products": [
      "Взрыв малины",
      "Ирландский кофе",
      "Раф цикорий",
      "Малина-мята",
      "Раф апельсиновый",
      "Штрудель"
    ],
    "images": [
      "assets/images/season_1.jpg",
      "assets/images/season_2.jpg",
      "assets/images/season_3.jpg",
      "assets/images/season_4.jpg",
      "assets/images/season_5.jpg",
      "assets/images/season_6.jpg"
    ],
    "prices": {
      "Взрыв малины": "250 ₽",
      "Ирландский кофе": "190 ₽",
      "Раф цикорий": "220 ₽",
      "Малина-мята": "250 ₽",
      "Раф апельсиновый": "220 ₽",
      "Штрудель": "280 ₽"
    }
  },
  "Горячие напитки": {
    "products": [
      "Горячий шоколад",
      "Горячий шоколад на альт. молоке",
      "Матча латте",
      "Матча латте на альт. молоке",
      "Натуральный какао",
      "Натуральный какао на альт. молоке",
      "Чай имбирный с лимоном и медом",
      "Чай клюквенный с можжевел"
    ],
    "images": [
      "assets/images/hot_1.jpg",
      "assets/images/hot_2.jpg",
      "assets/images/hot_3.jpg",
      "assets/images/hot_4.jpg",
      "assets/images/hot_5.jpg",
      "assets/images/hot_6.jpg",
      "assets/images/hot_7.jpg",
      "assets/images/hot_8.jpg"
    ],
    "prices": {
      "Горячий шоколад": "250 ₽",
      "Горячий шоколад на альт. молоке": "310 ₽",
      "Матча латте": "230 ₽",
      "Матча латте на альт. молоке": "290 ₽",
      "Натуральный какао": "200 ₽",
      "Натуральный какао на альт. молоке": "290 ₽",
      "Чай имбирный с лимоном и медом": "220 ₽",
      "Чай клюквенный с можжевел": "220 ₽"
    }
  },
  "Фреши": {
    "products": ["Фреш Апельсиновый", "Фреш Морковный", "Фреш Яблоко"],
    "images": [
      "assets/images/fresh_1.jpg",
      "assets/images/fresh_2.jpg",
      "assets/images/fresh_3.jpg"
    ],
    "prices": {
      "Фреш Апельсиновый": "320 ₽",
      "Фреш Морковный": "300 ₽",
      "Фреш Яблоко": "300 ₽"
    }
  },
};
