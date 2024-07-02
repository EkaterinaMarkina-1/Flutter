import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 45, 51, 73),
          flexibleSpace: Center(
            // Используем Center для центрирования
            child: Image.asset(
              'assets/icon/icon.png',
              fit: BoxFit
                  .contain, // Используем BoxFit.contain для сохранения пропорций
              // height: AppBar()
              //     .preferredSize
              //     .height, // Высота изображения - высота AppBar
            ),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String currentCategory = "Классический кофе"; // Начальная категория
  final ScrollController _scrollController = ScrollController();
  ScrollController _horizontalScrollController = ScrollController();

  List<String> categories = [
    "Классический кофе",
    "Авторский кофе",
    "Сезонное меню напитков",
    "Горячие напитки",
    "Смузи, фреши и молочные коктейли"
  ];

  @override
  void initState() {
    super.initState();
    //прокрутка
    _horizontalScrollController = ScrollController();
  }

  @override
  void dispose() {
    //прокрутка
    _scrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void _selectCategory(String category) {
    setState(() {
      currentCategory = category;
    });
  }

  Widget _buildCategoryButton(String category) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () {
          _selectCategory(category);
        },
        child: Container(
          height: 26,
          decoration: BoxDecoration(
            color: currentCategory == category
                ? const Color.fromARGB(255, 255, 174, 174)
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              category,
              style: TextStyle(
                color: currentCategory == category
                    ? const Color.fromARGB(255, 255, 158, 158)
                    : Colors.grey[500],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Горизонтальное меню категорий
          const SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _horizontalScrollController,
            child: Row(
              children: categories
                  .map((category) => _buildCategoryButton(category))
                  .toList(),
            ),
          ),
          // ...
        ],
      ),
    );
  }
}
