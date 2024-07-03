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
    double maxScroll = _scrollController.position.maxScrollExtent;
    return maxScroll == 0 ? 0 : (offset / maxScroll).floor();
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

  Widget _buildItem(String itemName, String imageUrl, String cost) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 150,
        height: 210,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(imageUrl),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
                width: 160,
                height: 75,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        itemName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ])),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 45, vertical: 4),
                    backgroundColor: const Color.fromRGBO(133, 195, 222, 1),
                    textStyle: const TextStyle(color: Colors.white),
                  ),
                  child: Text(
                    cost,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategorySection("Классический кофе", [
                    Row(
                      children: [
                        _buildItem("Американо", "assets/imeges/1.jpg", "160 ₽"),
                        _buildItem("Мокачино на альт.молоке",
                            "assets/imeges/2.jpg", "230 ₽"),
                      ],
                    ),
                    Row(
                      children: [
                        _buildItem("Капучино", "assets/imeges/3.jpg", "200 ₽"),
                        _buildItem("Капучино на альт. молоке", "assets/4.jpg",
                            "260 ₽"),
                      ],
                    ),
                  ])
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String title, List<Widget> items) {
    const EdgeInsets padding =
        EdgeInsets.symmetric(vertical: 3, horizontal: 4.0);
    const EdgeInsets textPadding = EdgeInsets.only(left: 8);
    const TextStyle titleStyle =
        TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: textPadding,
            child: Text(
              title,
              style: titleStyle,
            ),
          ),
          const SizedBox(height: 5),
          Wrap(
            spacing: 4.0,
            runSpacing: 2.0,
            children: items,
          ),
        ],
      ),
    );
  }
}
