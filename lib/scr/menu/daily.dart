import '../../library/librarys.dart';
import 'package:intl/intl.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({super.key});

  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  int selectedIndex = 0;
  late DateTime currentMonday; // ko‘rsatilayotgan haftaning dushanbasi

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    // Bugungi haftaning dushanbasini topamiz
    currentMonday = now.subtract(Duration(days: now.weekday - 1));

    // Bugungi kun indexi (0 = Dushanba, 6 = Yakshanba)
    selectedIndex = now.weekday - 1;
  }

  /// Haftaning kunlari ro‘yxati
  List<DateTime> getCurrentWeekDays() {
    return List.generate(7, (i) => currentMonday.add(Duration(days: i)));
  }

  /// O‘zbekcha hafta kunlari
  String getWeekdayName(DateTime date) {
    const uzWeekdays = ['Dush', 'Sesh', 'Chor', 'Pay', 'Jum', 'Shan', 'Yak'];
    return uzWeekdays[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final days = getCurrentWeekDays();

    return Scaffold(
      drawer: ProfileDrawer(),
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A4C9A),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Kunlik menyular"),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          children: [
            // 🔙 Oldingi hafta
            IconButton(
              onPressed: () {
                setState(() {
                  currentMonday = currentMonday.subtract(
                    const Duration(days: 7),
                  );
                });
              },
              icon: const Icon(Icons.arrow_back_ios, size: 16),
            ),

            // Haftaning kunlari
            Expanded(
              child: SizedBox(
                height: 55,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: days.length,
                  itemBuilder: (context, index) {
                    final date = days[index];
                    final isSelected = index == selectedIndex;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                        print(
                          "Tanlangan kun: ${DateFormat('yyyy-MM-dd').format(date)}",
                        );
                      },
                      child: Container(
                        width: 70,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? const Color(0xFF0A4C9A)
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x22000000),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('dd.MM').format(date),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              getWeekdayName(date),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color:
                                    isSelected
                                        ? Colors.white
                                        : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // 🔜 Keyingi hafta
            IconButton(
              onPressed: () {
                setState(() {
                  currentMonday = currentMonday.add(const Duration(days: 7));
                });
              },
              icon: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}
