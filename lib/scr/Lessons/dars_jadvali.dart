import '../../library/librarys.dart';

class DarsJadvaliPage extends StatefulWidget {
  const DarsJadvaliPage({super.key});

  @override
  State<DarsJadvaliPage> createState() => _DarsJadvaliPageState();
}

class _DarsJadvaliPageState extends State<DarsJadvaliPage> {
  int selectedIndex = 3; // default 18.09
  final List<String> days = [
    "15.09",
    "16.09",
    "17.09",
    "18.09",
    "19.09",
    "20.09",
  ];
  final List<String> weekDays = ["Dush", "Sesh", "Chor", "Pay", "Jum", "Shan"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ProfileDrawer(),
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          "Dars jadvali",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff004da9), // asosiy ko‘k
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.accessibility_new_outlined,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () {
              _showBottomSheet(context);
            },
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),

      body: Column(
        children: [
          // ✅ Kunlar navbatlash
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
            child: Row(
              children: [
                // Chap tugma
                IconButton(
                  onPressed: () {
                    if (selectedIndex > 0) {
                      setState(() => selectedIndex--);
                    }
                  },
                  icon: const Icon(Icons.arrow_back_ios, size: 16),
                ),

                // Kunlar ro'yxati
                Expanded(
                  child: SizedBox(
                    height: 50, // ixcham qildik
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: days.length,
                      itemBuilder: (context, index) {
                        final isSelected = index == selectedIndex;
                        return GestureDetector(
                          onTap: () => setState(() => selectedIndex = index),
                          child: Container(
                            width: 65,
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
                                  days[index],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  weekDays[index],
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

                // O'ng tugma
                IconButton(
                  onPressed: () {
                    if (selectedIndex < days.length - 1) {
                      setState(() => selectedIndex++);
                    }
                  },
                  icon: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ✅ Darslar ro'yxati
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                _LessonCard(
                  lessonNumber: "1 dars, 1-xona",
                  time: "08:00-08:40",
                  subject: "Matematika",
                  teacher: "Ozodbek Qambarov",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => const LessonDetailPage(title: "Matematika"),
                      ),
                    );
                  },
                ),
                _LessonCard(
                  lessonNumber: "2 dars, 1-xona",
                  time: "08:50-09:30",
                  subject: "Algebra",
                  teacher: "Ozodbek Qambarov",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => const LessonDetailPage(title: "Algebra"),
                      ),
                    );
                  },
                ),
                _LessonCard(
                  lessonNumber: "3 dars, 1-xona",
                  time: "09:40-10:20",
                  subject: "Geometriya",
                  teacher: "Ozodbek Qambarov",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => const LessonDetailPage(title: "Geometriya"),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),

      // ✅ BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {},
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Asosiy"),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Dars jadvali",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: "Chatlar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profil",
          ),
        ],
      ),
    );
  }

  // 🔹 Modal BottomSheet
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Boradigan vaqtingizni tanlang",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...[
                "Keldim",
                "5 daqiqa",
                "10 daqiqa",
                "15 daqiqa",
                "30 daqiqa",
                "30 daqiqadan ko‘p",
              ].map(
                (e) => ListTile(
                  title: Text(e),
                  trailing:
                      e == "10 daqiqa"
                          ? const Icon(Icons.check, color: Colors.blue)
                          : null,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text("Yuborish"),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 🔹 Dars Card
class _LessonCard extends StatelessWidget {
  final String lessonNumber;
  final String time;
  final String subject;
  final String teacher;
  final VoidCallback onTap;

  const _LessonCard({
    required this.lessonNumber,
    required this.time,
    required this.subject,
    required this.teacher,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lessonNumber, style: const TextStyle(color: Colors.blue)),
              if (time.isNotEmpty)
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    time,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                subject,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(teacher, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }
}
