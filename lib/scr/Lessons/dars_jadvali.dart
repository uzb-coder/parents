import '../../Providers/LessonsProvider.dart';
import 'package:parents/library/librarys.dart';

class DarsJadvaliPage extends StatefulWidget {
  const DarsJadvaliPage({super.key});

  @override
  State<DarsJadvaliPage> createState() => _DarsJadvaliPageState();
}

class _DarsJadvaliPageState extends State<DarsJadvaliPage> {
  int selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();

  List<String> days = [];
  List<String> weekDays = [];

  DateTime currentMonth = DateTime.now();

  String? selectedChildId; // tanlangan bola


  @override
  void initState() {
    super.initState();
    _generateMonthDays(currentMonth);
    _setTodayAsSelected();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDateInstant();
    });

    // scroll listener qo‘shish
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50) {
        _loadNextMonth();
      } else if (_scrollController.position.pixels <= 50) {
        _loadPreviousMonth();
      }
    });
  }

  void _generateMonthDays(DateTime month, {bool prepend = false}) {
    DateTime start = DateTime(month.year, month.month, 1);
    DateTime end = DateTime(month.year, month.month + 1, 1);

    int totalDays = end.difference(start).inDays;

    List<String> newDays = List.generate(totalDays, (index) {
      DateTime date = start.add(Duration(days: index));
      return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}";
    });

    List<String> newWeekDays = List.generate(totalDays, (index) {
      DateTime date = start.add(Duration(days: index));
      const names = ["Dush", "Sesh", "Chor", "Pay", "Jum", "Shan", "Yak"];
      return names[date.weekday - 1];
    });

    if (mounted) {
      setState(() {
        if (prepend) {
          days.insertAll(0, newDays);
          weekDays.insertAll(0, newWeekDays);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController.jumpTo(
              _scrollController.offset + (newDays.length * (65.0 + 8.0)),
            );
          });
        } else {
          days.addAll(newDays);
          weekDays.addAll(newWeekDays);
        }
      });
    }
  }

  void _loadNextMonth() {
    currentMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);
    _generateMonthDays(currentMonth);
  }

  void _loadPreviousMonth() {
    currentMonth = DateTime(currentMonth.year, currentMonth.month - 1, 1);
    _generateMonthDays(currentMonth, prepend: true);
  }

  void _setTodayAsSelected() {
    DateTime today = DateTime.now();
    String todayStr =
        "${today.day.toString().padLeft(2, '0')}.${today.month.toString().padLeft(2, '0')}";
    selectedIndex = days.indexOf(todayStr);
  }

  void _scrollToSelectedDateInstant() {
    Future.delayed(const Duration(milliseconds: 1), () {
      if (_scrollController.hasClients && selectedIndex >= 0) {
        const itemWidth = 65.0 + 8.0; // Container width + margin
        final screenWidth = MediaQuery.of(context).size.width;
        final arrowButtonWidth = 48.0;
        final availableWidth = screenWidth - (arrowButtonWidth * 2);

        final targetOffset =
            (selectedIndex * itemWidth) -
            (availableWidth / 2) +
            (itemWidth / 2);
        final maxScrollExtent = _scrollController.position.maxScrollExtent;
        final clampedOffset = targetOffset.clamp(0.0, maxScrollExtent);

        // Darhol scroll qilish (animatsiyasiz)
        _scrollController.jumpTo(clampedOffset);
      }
    });
  }

  // User action uchun animatsiyali scroll
  void _scrollToSelectedDateAnimated() {
    if (_scrollController.hasClients && selectedIndex >= 0) {
      const itemWidth = 65.0 + 8.0;
      final screenWidth = MediaQuery.of(context).size.width;
      final arrowButtonWidth = 48.0;
      final availableWidth = screenWidth - (arrowButtonWidth * 2);

      final targetOffset =
          (selectedIndex * itemWidth) - (availableWidth / 2) + (itemWidth / 2);
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final clampedOffset = targetOffset.clamp(0.0, maxScrollExtent);

      // Animatsiya bilan scroll
      _scrollController.animateTo(
        clampedOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Dars jadvali", style: TextStyle(color: Colors.white)),
      backgroundColor: const Color(0xFF004DA9),
      centerTitle: true,
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
                    ? () {
                      setState(() => selectedIndex--);
                      _loadLessonsForSelectedDate();
                      _scrollToSelectedDateAnimated(); // Animatsiya bilan
                    }
                    : null,
            icon: const Icon(Icons.arrow_back_ios, size: 16),
          ),
          Expanded(
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final isSelected = index == selectedIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedIndex = index);
                      _loadLessonsForSelectedDate();
                      _scrollToSelectedDateAnimated(); // Animatsiya bilan
                    },
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
                    ? () {
                      setState(() => selectedIndex++);
                      _loadLessonsForSelectedDate();
                      _scrollToSelectedDateAnimated(); // Animatsiya bilan
                    }
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

          final selectedDate = _parseSelectedDate(days[selectedIndex]);
          final filteredLessons = _filterLessonsByDate(provider, selectedDate);

          if (filteredLessons.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 60, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    "${_formatDate(selectedDate)} sanasida dars qo'yilmagan",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            children:
                filteredLessons.expand<Widget>((studentData) {
                  return studentData.lessons.map<Widget>((lesson) {
                    return LessonCard(
                      student: studentData.student,
                      group: studentData.group,
                      lessonNumber: "${lesson.lessonNumber}-dars",
                      time: _formatDate(selectedDate),
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
                    );
                  }).toList();
                }).toList(),
          );
        },
      ),
    );
  }

  DateTime _parseSelectedDate(String dayStr) {
    final parts = dayStr.split('.');
    final now = DateTime.now();
    return DateTime(now.year, int.parse(parts[1]), int.parse(parts[0]));
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
  }

  List<dynamic> _filterLessonsByDate(
    TodayLessonsProvider provider,
    DateTime selectedDate,
  ) {
    if (provider.todayLessons == null || provider.todayLessons!.data.isEmpty) {
      return [];
    }

    return provider.todayLessons!.data.where((studentData) {
      final lessonDate = provider.todayLessons!.date;
      return lessonDate.day == selectedDate.day &&
          lessonDate.month == selectedDate.month &&
          lessonDate.year == selectedDate.year;
    }).toList();
  }

  void _loadLessonsForSelectedDate() {
    final selectedDate = _parseSelectedDate(days[selectedIndex]);
    Provider.of<TodayLessonsProvider>(
      context,
      listen: false,
    ).loadTodayLessons(selectedDate);
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
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 0.5),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2196F3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        lessonNumber,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    if (time.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.schedule,
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              time,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  subject,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF263238),
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.person,
                  "O'quvchi",
                  student,
                  const Color(0xFF9C27B0),
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.school,
                  "O'qituvchi",
                  teacher,
                  const Color(0xFFFF9800),
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.group,
                  "Sinf",
                  group,
                  const Color(0xFF009688),
                ),
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
              style: const TextStyle(fontSize: 15, color: Color(0xFF424242)),
              children: [
                TextSpan(
                  text: "$label: ",
                  style: TextStyle(fontWeight: FontWeight.w600, color: color),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF263238),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
