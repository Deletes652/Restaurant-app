import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    theme: ThemeData(
      fontFamily: 'Kanit',
      primarySwatch: Colors.orange,
      scaffoldBackgroundColor: Color(0xFFFFF8F0),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF8B4513),
        elevation: 8,
        shadowColor: Colors.brown.withOpacity(0.5),
        titleTextStyle: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Kanit',
          letterSpacing: 1.2,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFD2691E),
          foregroundColor: Colors.white,
          textStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 6,
          shadowColor: Colors.orange.withOpacity(0.4),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 8,
        shadowColor: Colors.brown.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ),
    home: FoodOrderPage(),
    debugShowCheckedModeBanner: false,
  ),
);

class FoodOrderPage extends StatefulWidget {
  @override
  _FoodOrderPageState createState() => _FoodOrderPageState();
}

class _FoodOrderPageState extends State<FoodOrderPage>
    with TickerProviderStateMixin {
  final List<Map<String, dynamic>> foodMenu = [
    {
      'name': 'ข้าวผัดกุ้ง',
      'price': 85,
      'description': 'ข้าวผัดกุ้งสดใหม่ หอมกรุ่น',
      'category': 'อาหารจานเดียว',
      'img':
          'https://media.istockphoto.com/id/186826982/th/%E0%B8%A3%E0%B8%B9%E0%B8%9B%E0%B8%96%E0%B9%88%E0%B8%B2%E0%B8%A2/%E0%B8%88%E0%B8%B2%E0%B8%99%E0%B8%82%E0%B9%89%E0%B8%B2%E0%B8%A7%E0%B8%9C%E0%B8%B1%E0%B8%94%E0%B8%81%E0%B8%B8%E0%B9%89%E0%B8%87%E0%B8%9A%E0%B8%99%E0%B9%82%E0%B8%95%E0%B9%8A%E0%B8%B0%E0%B9%84%E0%B8%A1%E0%B9%89%E0%B9%81%E0%B8%A5%E0%B8%B0-placemat.jpg?s=612x612&w=0&k=20&c=2Cx62YXdcr6JYAa7s1grqDhuD2bW1_t5Hu8E_S6yZgw=',
      'rating': 4.8,
    },
    {
      'name': 'ผัดไทยกุ้งสด',
      'price': 95,
      'description': 'ผัดไทยรสชาติต้นตำรับ',
      'category': 'อาหารจานเดียว',
      'img':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR36bDRBHCQBu497RrRkC1hQif6guIOmlr9HA&s',
      'rating': 4.9,
    },
    {
      'name': 'ก๋วยเตี๋ยวต้มยำ',
      'price': 75,
      'description': 'ก๋วยเตี๋ยวต้มยำรสจัดจ้าน',
      'category': 'ก๋วยเตี๋ยว',
      'img': 'https://cheewajit.com/app/uploads/2021/04/image-130-edited.png',
      'rating': 4.7,
    },
    {
      'name': 'ส้มตำไทย',
      'price': 65,
      'description': 'ส้มตำรสชาติแซ่บ เสิร์ฟพร้อมผัก',
      'category': 'ยำ/สลัด',
      'img':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQxvQQQxQQxQQxQQxQQxQQxQQxQQxQQxQQxQQ&s',
      'rating': 4.6,
    },
  ];

  final List<Map<String, dynamic>> drinks = [
    {'name': 'ไม่รับ', 'price': 0, 'icon': Icons.close},
    {'name': 'น้ำเปล่า', 'price': 15, 'icon': Icons.water_drop},
    {'name': 'ชาเย็น', 'price': 35, 'icon': Icons.local_cafe},
    {'name': 'กาแฟเย็น', 'price': 45, 'icon': Icons.coffee},
    {'name': 'น้ำส้มคั้นสด', 'price': 55, 'icon': Icons.local_drink},
    {'name': 'น้ำมะนาวโซดา', 'price': 40, 'icon': Icons.bubble_chart},
  ];

  List<bool> selectedFoods = [false, false, false, false];
  int selectedDrinkIndex = 0;
  bool needSpoon = false;
  TimeOfDay? pickupTime;
  late AnimationController _successController;
  late AnimationController _cardController;
  late Animation<double> _successAnimation;
  late Animation<double> _cardAnimation;
  bool _showSuccess = false;

  int get totalPrice {
    int sum = 0;
    for (int i = 0; i < foodMenu.length; i++) {
      if (selectedFoods[i]) sum += foodMenu[i]['price'] as int;
    }
    sum += drinks[selectedDrinkIndex]['price'] as int;
    return sum;
  }

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    _cardController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _successAnimation = CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    );
    _cardAnimation = CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _successController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF8B4513),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        pickupTime = picked;
      });
    }
  }

  void _clearAll() {
    setState(() {
      selectedFoods = List.generate(foodMenu.length, (_) => false);
      selectedDrinkIndex = 0;
      needSpoon = false;
      pickupTime = null;
    });
  }

  void _showSuccessAnimation() async {
    setState(() {
      _showSuccess = true;
    });
    _successController.forward(from: 0);
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      _showSuccess = false;
    });
    _clearAll();
  }

  void _showSummary() {
    List<String> foods = [];
    for (int i = 0; i < foodMenu.length; i++) {
      if (selectedFoods[i])
        foods.add('${foodMenu[i]['name']} (${foodMenu[i]['price']}฿)');
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        backgroundColor: Color(0xFFFFF8F0),
        title: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8B4513), Color(0xFFD2691E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Icon(Icons.receipt_long, color: Colors.white, size: 28),
              SizedBox(width: 12),
              Text(
                'สรุปคำสั่งซื้อ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummarySection(
                '🍽️ อาหาร:',
                foods.isEmpty ? "ไม่ได้เลือก" : foods.join('\n• '),
              ),
              SizedBox(height: 12),
              _buildSummarySection(
                '🥤 เครื่องดื่ม:',
                '${drinks[selectedDrinkIndex]['name']} (${drinks[selectedDrinkIndex]['price']}฿)',
              ),
              SizedBox(height: 12),
              _buildSummarySection(
                '🥄 ช้อนส้อม:',
                needSpoon ? "รับ" : "ไม่รับ",
              ),
              SizedBox(height: 12),
              _buildSummarySection(
                '⏰ เวลารับอาหาร:',
                pickupTime != null
                    ? "${pickupTime!.hour.toString().padLeft(2, '0')}:${pickupTime!.minute.toString().padLeft(2, '0')}"
                    : "ยังไม่เลือก",
              ),
              SizedBox(height: 16),
              Divider(thickness: 2, color: Color(0xFFD2691E)),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ราคารวม:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B4513),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      '$totalPrice ฿',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B4513),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'ยกเลิก',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showSuccessAnimation();
                  },
                  icon: Icon(Icons.check_circle),
                  label: Text('ยืนยันสั่งซื้อ'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF228B22),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF8B4513),
          ),
        ),
        SizedBox(height: 4),
        Text(
          content,
          style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.3),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFF8F0), Color(0xFFFFF0E6)],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.restaurant_menu, size: 28),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ร้านอาหารดีลิเชียส'),
                      Text(
                        'Delicious Restaurant',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8B4513), Color(0xFFD2691E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              actions: [
                Container(
                  margin: EdgeInsets.only(right: 16),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shopping_cart, size: 20),
                      SizedBox(width: 4),
                      Text(
                        '$totalPrice฿',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Color(0xFFFFFAF0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.brown.withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFFD700),
                                    Color(0xFFFFA500),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ยินดีต้อนรับสู่ร้านอาหารดีลิเชียส',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF8B4513),
                                    ),
                                  ),
                                  Text(
                                    'อาหารไทยต้นตำรับ รสชาติดั้งเดิม',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.restaurant,
                          color: Color(0xFF8B4513),
                          size: 28,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'เมนูแนะนำ',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B4513),
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFD2691E).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${foodMenu.length} รายการ',
                            style: TextStyle(
                              color: Color(0xFF8B4513),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: selectedFoods[i]
                                  ? Color(0xFFD2691E).withOpacity(0.3)
                                  : Colors.grey.withOpacity(0.1),
                              blurRadius: selectedFoods[i] ? 15 : 8,
                              offset: Offset(0, selectedFoods[i] ? 8 : 4),
                            ),
                          ],
                        ),
                        child: Card(
                          elevation: 0,
                          margin: EdgeInsets.zero,
                          color: selectedFoods[i]
                              ? Color(0xFFFFF8DC)
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: BorderSide(
                              color: selectedFoods[i]
                                  ? Color(0xFFD2691E)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: () {
                              setState(() {
                                selectedFoods[i] = !selectedFoods[i];
                              });
                              _cardController.forward().then((_) {
                                _cardController.reverse();
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Hero(
                                    tag: 'food_$i',
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 10,
                                            offset: Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(
                                          foodMenu[i]['img'],
                                          width: 100,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          loadingBuilder:
                                              (context, child, progress) {
                                                if (progress == null)
                                                  return child;
                                                return Container(
                                                  width: 100,
                                                  height: 80,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  child: Center(
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                            Color
                                                          >(Color(0xFFD2691E)),
                                                    ),
                                                  ),
                                                );
                                              },
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                                    width: 100,
                                                    height: 80,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[300],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                    child: Icon(
                                                      Icons.restaurant,
                                                      color: Color(0xFFD2691E),
                                                      size: 40,
                                                    ),
                                                  ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                foodMenu[i]['name'],
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: selectedFoods[i]
                                                      ? Color(0xFF8B4513)
                                                      : Colors.black87,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Color(
                                                  0xFFFFD700,
                                                ).withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    size: 14,
                                                    color: Color(0xFFFFD700),
                                                  ),
                                                  SizedBox(width: 2),
                                                  Text(
                                                    '${foodMenu[i]['rating']}',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF8B4513),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          foodMenu[i]['description'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Color(
                                                  0xFFD2691E,
                                                ).withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                foodMenu[i]['category'],
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF8B4513),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              '${foodMenu[i]['price']} ฿',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFD2691E),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: selectedFoods[i]
                                          ? Color(0xFF228B22)
                                          : Colors.grey[300],
                                      shape: BoxShape.circle,
                                      boxShadow: selectedFoods[i]
                                          ? [
                                              BoxShadow(
                                                color: Color(
                                                  0xFF228B22,
                                                ).withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: Offset(0, 4),
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: Icon(
                                      selectedFoods[i]
                                          ? Icons.check
                                          : Icons.add,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      childCount: foodMenu.length,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Color(0xFFF0F8FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.1),
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF4169E1),
                                      Color(0xFF87CEEB),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Icon(
                                  Icons.local_drink,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 16),
                              Text(
                                'เลือกเครื่องดื่ม',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4169E1),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Color(0xFF87CEEB).withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: DropdownButton<int>(
                              value: selectedDrinkIndex,
                              isExpanded: true,
                              underline: SizedBox(),
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Color(0xFF4169E1),
                                size: 28,
                              ),
                              onChanged: (int? newIndex) {
                                setState(() {
                                  selectedDrinkIndex = newIndex!;
                                });
                              },
                              items: List.generate(
                                drinks.length,
                                (i) => DropdownMenuItem<int>(
                                  value: i,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Color(
                                              0xFF87CEEB,
                                            ).withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Icon(
                                            drinks[i]['icon'],
                                            color: Color(0xFF4169E1),
                                            size: 20,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            '${drinks[i]['name']}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xFFFFD700),
                                                Color(0xFFFFA500),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            '${drinks[i]['price']} ฿',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Color(0xFFF5F5DC)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.brown.withOpacity(0.1),
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF8B4513), Color(0xFFD2691E)],
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              Icons.restaurant,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'รับช้อนส้อม',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF8B4513),
                                  ),
                                ),
                                Text(
                                  'สำหรับรับประทานอาหาร',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            width: 60,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: needSpoon
                                    ? [Color(0xFF228B22), Color(0xFF32CD32)]
                                    : [Colors.grey[300]!, Colors.grey[400]!],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: needSpoon
                                      ? Color(0xFF228B22).withOpacity(0.3)
                                      : Colors.grey.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Switch(
                              value: needSpoon,
                              activeColor: Colors.white,
                              inactiveThumbColor: Colors.white,
                              activeTrackColor: Colors.transparent,
                              inactiveTrackColor: Colors.transparent,
                              onChanged: (value) {
                                setState(() {
                                  needSpoon = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Color(0xFFE6E6FA)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.1),
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF9370DB), Color(0xFFBA55D3)],
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              Icons.access_time,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pickupTime == null
                                      ? 'เลือกเวลารับอาหาร'
                                      : 'เวลารับอาหาร',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF9370DB),
                                  ),
                                ),
                                Text(
                                  pickupTime == null
                                      ? 'กรุณาเลือกเวลาที่ต้องการรับอาหาร'
                                      : '${pickupTime!.hour.toString().padLeft(2, '0')}:${pickupTime!.minute.toString().padLeft(2, '0')} น.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: pickupTime == null
                                        ? Colors.grey[600]
                                        : Color(0xFF9370DB),
                                    fontWeight: pickupTime == null
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _selectTime(context),
                            icon: Icon(Icons.schedule, size: 20),
                            label: Text(
                              pickupTime == null ? 'เลือก' : 'แก้ไข',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF9370DB),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFFFA500).withOpacity(0.4),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ยอดรวมทั้งหมด',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '$totalPrice ฿',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.receipt,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: totalPrice == 0 ? null : _showSummary,
                            icon: Icon(Icons.shopping_cart_checkout, size: 24),
                            label: Text(
                              'สั่งซื้อเลย',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: totalPrice == 0
                                  ? Colors.grey[400]
                                  : Color(0xFF228B22),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 8,
                              shadowColor: totalPrice == 0
                                  ? Colors.grey.withOpacity(0.3)
                                  : Color(0xFF228B22).withOpacity(0.4),
                            ),
                          ),
                        ),
                        if (totalPrice == 0)
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              'กรุณาเลือกอาหารอย่างน้อย 1 รายการ',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            ),
          ),
        ),
        if (_showSuccess)
          Container(
            color: Colors.black.withOpacity(0.7),
            child: Center(
              child: ScaleTransition(
                scale: _successAnimation,
                child: Container(
                  margin: EdgeInsets.all(32),
                  padding: EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Color(0xFFF0FFF0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 30,
                        offset: Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF228B22), Color(0xFF32CD32)],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF228B22).withOpacity(0.4),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'สั่งซื้อสำเร็จ!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF228B22),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'ขอบคุณที่ใช้บริการ',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'รอสักครู่ กำลังเตรียมอาหาร...',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.timer, color: Color(0xFF8B4513), size: 20),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'เวลาเตรียม: 15-20 นาที',
                              style: TextStyle(
                                color: Color(0xFF8B4513),
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
