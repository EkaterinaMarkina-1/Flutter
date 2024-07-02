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
    _scrollController.addListener(_scrollListener);
    _horizontalScrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void _selectCategory(String category) {
    setState(() {
      currentCategory = category;
    });
  }

  int _calculateCategoryIndex(double offset) {
    return (offset / 450).floor();
  }

  void _scrollListener() {
    int index = _calculateCategoryIndex(_scrollController.offset);

    if (index >= 0 &&
        index < categories.length &&
        currentCategory != categories[index]) {
      setState(() {
        currentCategory = categories[index];

        final screenWidth = MediaQuery.of(context).size.width;
        final categoryWidth = categories.length * 200;

        double scrollTo = index * 120.0 - (screenWidth - 120.0) / 2.0;
        scrollTo = scrollTo.clamp(0, categoryWidth - screenWidth);

        _horizontalScrollController.animateTo(
          scrollTo,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
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
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ...
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
