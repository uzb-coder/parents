import '../../Providers/LessonsProvider.dart';
import 'package:parents/library/librarys.dart';

class DarsJadvaliPage extends StatefulWidget {
  const DarsJadvaliPage({super.key});

  @override
  State<DarsJadvaliPage> createState() => _DarsJadvaliPageState();
}

class _DarsJadvaliPageState extends State<DarsJadvaliPage> {
  int selectedIndex = 3;
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TodayLessonsProvider>(
        context,
        listen: false,
      ).loadTodayLessons();
    });

    return Scaffold(
      drawer: const ProfileDrawer(),
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildDaySelector(),
          const SizedBox(height: 12),
          _buildLessonsList(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Dars jadvali", style: TextStyle(color: Colors.white)),
      backgroundColor: const Color(0xFF004DA9),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.accessibility_new_outlined,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () => _showBottomSheet(context),
        ),
      ],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
    );
  }

  Widget _buildDaySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      child: Row(
        children: [
          IconButton(
            onPressed:
                selectedIndex > 0
                    ? () => setState(() => selectedIndex--)
                    : null,
            icon: const Icon(Icons.arrow_back_ios, size: 16),
          ),
          Expanded(
            child: SizedBox(
              height: 50,
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
                            isSelected ? const Color(0xFF0A4C9A) : Colors.white,
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
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            weekDays[index],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color:
                                  isSelected ? Colors.white : Colors.grey[700],
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
          IconButton(
            onPressed:
                selectedIndex < days.length - 1
                    ? () => setState(() => selectedIndex++)
                    : null,
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonsList() {
    return Expanded(
      child: Consumer<TodayLessonsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.todayLessons == null ||
              provider.todayLessons!.data.isEmpty) {
            return const Center(child: Text('Bugungi darslar mavjud emas'));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: provider.todayLessons!.data.length,
            itemBuilder: (context, index) {
              final student = provider.todayLessons!.data[index];
              final students = provider.todayLessons;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  ...student.lessons.map(
                    (lesson) => LessonCard(
                      student: student.student,
                      group: student.group,
                      lessonNumber: "${lesson.lessonNumber}-dars",
                      time: "${students?.date.day}-${students?.date.month}-${students?.date.year}",
                      subject: lesson.subject,
                      teacher: lesson.teacher,
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) =>
                                      LessonDetailPage(title: lesson.subject),
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              );
            },
          );
        },
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
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
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (_) => Padding(
            padding: const EdgeInsets.all(16),
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
                    onTap: () => Navigator.pop(context),
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
          ),
    );
  }
}

class LessonCard extends StatelessWidget {
  final String lessonNumber;
  final String time;
  final String subject;
  final String teacher;
  final String group;
  final String student;
  final VoidCallback onTap;

  const LessonCard({
    Key? key,
    required this.lessonNumber,
    required this.time,
    required this.subject,
    required this.teacher,
    required this.group,
    required this.student,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.blue.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header qismi - Farz va vaqt
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        lessonNumber,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (time.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.schedule, size: 16, color: Colors.green),
                            const SizedBox(width: 4),
                            Text(
                              time,
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Fan nomi (asosiy ma'lumot)
                Text(
                  subject,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.person, "O'quvchi", student, Colors.purple),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.school, "O'qituvchi", teacher, Colors.orange),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.group, "Sinf", group, Colors.teal),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              children: [
                TextSpan(
                  text: "$label: ",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}