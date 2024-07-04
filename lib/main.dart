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
      theme: ThemeData(),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 50, 57, 82),
          flexibleSpace: Center(
            child: Image.asset(
              'assets/icon/icon.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        body: const MyHomePage(),
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
  Map<String, int> shoppingcart = {};
  void addtoshoppingcart(String key) {
    if (shoppingcart.containsKey(key)) {
      if (shoppingcart[key] != 10) {
        setState(() {
          shoppingcart[key] = (shoppingcart[key] ?? 0) + 1;
        });
      }
    } else {
      setState(() {
        shoppingcart[key] = 1;
      });
    }
  }

  void removefromshoppingcart(String key) {
    setState(() {
      shoppingcart[key] = (shoppingcart[key] ?? 0) - 1;
    });
  }

  String currentCategory = "Классический кофе"; // Начальная категория
  final ScrollController _scrollController = ScrollController();
  ScrollController _horizontalScrollController = ScrollController();

  List<String> categories = [
    "Классический кофе",
    "Авторский кофе",
    "Сезонное меню напитков",
    "Горячие напитки",
    "Фреши"
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

    int index = categories.indexOf(category);
    if (index != -1) {
      double totalOffset = 0;
      for (int i = 0; i < index; i++) {
        totalOffset +=
            _getCategoryHeight(categories[i]); 
      }

      _scrollController.jumpTo(totalOffset);
    }
  }

  double _getCategoryHeight(String category) {
    switch (category) {
      case "Классический кофе":
        return 1000;
      case "Авторский кофе":
        return 1100;
      case "Сезонное меню напитков":
        return 800;
      case "Горячие напитки":
        return 900;
      case "Фреши":
        return 400;
      default:
        return 0;
    }
  }


  void _scrollListener() {
    setState(() {
         int index = (_scrollController.offset / 900)
          .floor(); 

      // Ensure the index is within bounds
      if (index >= 0 && index < categories.length) {
        currentCategory = categories[index];

        // Calculate horizontal scroll position for the category
        double screenWidth = MediaQuery.of(context).size.width;
        double categoryWidth = categories.length * 220.0;
        double scrollTo = index * 2220.0 - (screenWidth - 220.0) / 2.0;

        // Clamp the horizontal scroll position
        scrollTo = scrollTo.clamp(0, categoryWidth - screenWidth);

        // Update the horizontal scroll controller
        _horizontalScrollController.animateTo(
          scrollTo,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

// ignore: unused_element
  String _determineCategoryInView() {
    double position = 0.0;
    String categoryInView;

    for (int i = 0; i < categories.length; i++) {
      RenderBox renderBox = context.findRenderObject() as RenderBox;
      double itemPosition = renderBox.localToGlobal(Offset.zero).dy;

      if (itemPosition >= 0 &&
          itemPosition < MediaQuery.of(context).size.height) {
        position = i.toDouble();
        break;
      }
    }

    categoryInView = categories[position.toInt()];

    return categoryInView;
  }

  bool showCartWidget = false;
  int quantity = 1;
  Widget _buildItem(String itemName, String imageUrl, String cost) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 164,
        height: 240,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
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
                  fit: BoxFit.fill,
                ),
              ),
            ),
            // const SizedBox(height: 5),
            SizedBox(
                width: 160,
                height: 60,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        itemName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 50, 57, 82),
                        ),
                      ),
                    ])),
            //const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ElevatedButton(
                //   onPressed: () {
                //     setState(() {
                //       showCartWidget = true;
                //     });
                //   },
                //   style: ElevatedButton.styleFrom(
                //     padding:
                //         const EdgeInsets.symmetric(horizontal: 45, vertical: 4),
                //     backgroundColor: const Color.fromARGB(255, 254, 178, 157),
                //     textStyle: const TextStyle(color: Colors.white),
                //   ),
                //   child: Text(
                //     cost,
                //     style: const TextStyle(
                //         fontSize: 16,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.white),
                //   ),
                // ),
                // if (showCartWidget) buildCartWidget(cost, quantity),
                Visibility(
                  visible: shoppingcart[itemName] == null ||
                      shoppingcart[itemName] == 0,
                  replacement: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            removefromshoppingcart(itemName);
                          });
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 254, 178, 157),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('-',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(shoppingcart[itemName].toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            addtoshoppingcart(itemName);
                          });
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 254, 178, 157),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('+',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        addtoshoppingcart(itemName);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 45, vertical: 4),
                      backgroundColor: const Color.fromARGB(255, 254, 178, 157),
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
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCartWidget(String cost, int quantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              quantity--;
            });
          },
          child: Container(
            //padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 254, 178, 157),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text('-'),
          ),
        ),
        const SizedBox(width: 8),
        Text('$quantity'),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            setState(() {
              quantity++;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 254, 178, 157),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text('+'),
          ),
        ),
      ],
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
          height: 36,
          decoration: BoxDecoration(
            color: currentCategory == category
                ? const Color.fromARGB(255, 254, 178, 157)
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              category,
              style: TextStyle(
                color: currentCategory == category
                    ? Colors.white
                    : const Color.fromARGB(255, 45, 51, 73),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildItem("Американо", "assets/imeges/classic_1.jpg",
                            "160 ₽"),
                        _buildItem("Мокачино на альт.молоке",
                            "assets/imeges/classic_2.jpg", "230 ₽"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildItem(
                            "Капучино", "assets/imeges/classic_3.jpg", "200 ₽"),
                        _buildItem("Капучино на альт. молоке",
                            "assets/imeges/classic_4.jpg", "260 ₽"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildItem(
                            "Латте", "assets/imeges/classic_5.jpg", "200 ₽"),
                        _buildItem("Латте на альт. молоке",
                            "assets/imeges/classic_6.jpg", "260 ₽"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildItem(
                            "Мокачино", "assets/imeges/classic_7.jpg", "170 ₽"),
                        _buildItem(
                            "Раф", "assets/imeges/classic_8.jpg", "250 ₽"),
                      ],
                    ),
                  ]),
                  _buildCategorySection("Авторский кофе", [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildItem("Вьетнамская классика",
                            "assets/imeges/autor_1.jpg", "190 ₽"),
                        _buildItem("Кофе Бичерин", "assets/imeges/autor_2.jpg",
                            "210 ₽"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildItem("Кофе Бон Бон", "assets/imeges/autor_3.jpg",
                            "220 ₽"),
                        _buildItem("Кофе по-генуэзски на латте",
                            "assets/imeges/autor_4.jpg", "250 ₽"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildItem("Кофе по-ливийски с куркумой",
                            "assets/imeges/autor_5.jpg", "220 ₽"),
                        _buildItem(
                            "Мачу-Пикчу", "assets/imeges/autor_6.jpg", "190 ₽"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildItem(
                            "Сайгон", "assets/imeges/autor_7.jpg", "250 ₽"),
                        _buildItem("Сицилийский апельсин на латте",
                            "assets/imeges/autor_8.jpg", "250 ₽"),
                      ],
                    ),
                  ]),
                  _buildCategorySection("Сезонное меню напитков", [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildItem("Взрыв малины", "assets/imeges/season_1.jpg",
                            "250 ₽"),
                        _buildItem("Ирландский кофе",
                            "assets/imeges/season_2.jpg", "190 ₽"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildItem("Раф цикорий", "assets/imeges/season_3.jpg",
                            "220 ₽"),
                        _buildItem("Малина-мята", "assets/imeges/season_4.jpg",
                            "250 ₽"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildItem("Раф апельсиновый",
                            "assets/imeges/season_5.jpg", "220 ₽"),
                        _buildItem(
                            "Штрудель", "assets/imeges/season_6.jpg", "280 ₽"),
                      ],
                    ),
                  ]),
                  _buildCategorySection("Горячие напитки", [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildItem("Горячий шоколад", "assets/imeges/hot_1.jpg",
                            "250 ₽"),
                        _buildItem("Горячий шоколад на альт. молоке",
                            "assets/imeges/hot_2.jpg", "310 ₽"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildItem(
                            "Матча латте", "assets/imeges/hot_3.jpg", "230 ₽"),
                        _buildItem("Матча латте на альт. молоке",
                            "assets/imeges/hot_4.jpg", "290 ₽"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildItem("Натуральный какао",
                            "assets/imeges/hot_5.jpg", "200 ₽"),
                        _buildItem("Натуральный какао на альт. молоке",
                            "assets/imeges/hot_6.jpg", "260 ₽"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildItem("Чай имбирный с лимоном и медом",
                            "assets/imeges/hot_7.jpg", "220 ₽"),
                        _buildItem("Чай Клюквенный с можжевел.",
                            "assets/imeges/hot_8.jpg", "220 ₽"),
                      ],
                    ),
                  ]),
                  _buildCategorySection("Фреши", [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildItem("Фреш Апельсиновый",
                            "assets/imeges/fresh_1.jpg", "320 ₽"),
                        _buildItem("Фреш Морковный",
                            "assets/imeges/fresh_2.jpg", "300 ₽"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildItem("Фреш Яблоко", "assets/imeges/fresh_3.jpg",
                            "300 ₽"),
                      ],
                    ),
                  ]),
                  const SizedBox(
                    height: 20,
                  )
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
            spacing: 6.0,
            runSpacing: 2.0,
            children: items,
          ),
        ],
      ),
    );
  }
}
