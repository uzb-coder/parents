import 'package:parents/src/data/model/lesson/LessonsModel.dart';
import 'package:parents/src/library/librarys.dart';

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
  List<DateTime> fullDates = [];
  DateTime currentMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _generateMonthDays(currentMonth);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setTodayAsSelected();
      _scrollToSelectedDateInstant();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50) {
        _loadNextMonth();
      } else if (_scrollController.position.pixels <= 50) {
        _loadPreviousMonth();
      }
    });
  }

  void _setTodayAsSelected() {
    final today = DateTime.now();
    final todayStr =
        "${today.day.toString().padLeft(2, '0')}.${today.month.toString().padLeft(2, '0')}";
    final index = days.indexOf(todayStr);
    if (index != -1 && mounted) {
      setState(() => selectedIndex = index);
      _loadLessonsForSelectedDate();
    }
  }

  void _generateMonthDays(DateTime month, {bool prepend = false}) {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 0); // oxirgi kun
    final totalDays = end.day;

    final newDays = List.generate(totalDays, (i) {
      final d = start.add(Duration(days: i));
      return "${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}";
    });

    final newWeekDays = List.generate(totalDays, (i) {
      final d = start.add(Duration(days: i));
      const names = ["Dush", "Sesh", "Chor", "Pay", "Jum", "Shan", "Yak"];
      return names[d.weekday - 1];
    });

    final newFullDates = List.generate(
      totalDays,
      (i) => start.add(Duration(days: i)),
    );

    if (mounted) {
      setState(() {
        if (prepend) {
          days.insertAll(0, newDays);
          weekDays.insertAll(0, newWeekDays);
          fullDates.insertAll(0, newFullDates);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController.jumpTo(
              _scrollController.offset + newDays.length * 78,
            );
          });
        } else {
          days.addAll(newDays);
          weekDays.addAll(newWeekDays);
          fullDates.addAll(newFullDates);
        }
      });
    }
  }

  void _loadNextMonth() =>
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);
  void _loadPreviousMonth() =>
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1, 1);

  void _scrollToSelectedDateInstant() {
    Future.delayed(const Duration(milliseconds: 1), () {
      if (!_scrollController.hasClients || selectedIndex < 0) return;
      const itemWidth = 78.0;
      final screenWidth = MediaQuery.of(context).size.width;
      final availableWidth = screenWidth - 96;
      final target =
          selectedIndex * itemWidth - availableWidth / 2 + itemWidth / 2;
      final clamped = target.clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );
      _scrollController.jumpTo(clamped);
    });
  }

  void _scrollToSelectedDateAnimated() {
    if (!_scrollController.hasClients || selectedIndex < 0) return;
    const itemWidth = 78.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth - 96;
    final target =
        selectedIndex * itemWidth - availableWidth / 2 + itemWidth / 2;
    final clamped = target.clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.animateTo(
      clamped,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        elevation: 0,
        title: const Text(
          "Dars jadvali",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF004DA9),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildDaySelector(),
          const SizedBox(height: 16),
          _buildLessonsList(),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    final today = DateTime.now();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF004DA9).withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.calendar_month,
                color: Color(0xFF004DA9),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                _getMonthYearText(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              _arrowButton(Icons.arrow_back_ios_rounded, selectedIndex > 0, () {
                if (selectedIndex > 0) {
                  setState(() => selectedIndex--);
                  _loadLessonsForSelectedDate();
                  _scrollToSelectedDateAnimated();
                }
              }),

              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: days.length,
                    itemBuilder: (context, index) {
                      final isSelected = index == selectedIndex;
                      final isToday =
                          fullDates[index].day == today.day &&
                          fullDates[index].month == today.month &&
                          fullDates[index].year == today.year;

                      return GestureDetector(
                        onTap: () {
                          setState(() => selectedIndex = index);
                          _loadLessonsForSelectedDate();
                          _scrollToSelectedDateAnimated();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 70,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 2,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            gradient:
                                isSelected
                                    ? const LinearGradient(
                                      colors: [
                                        Color(0xFF0066CC),
                                        Color(0xFF004DA9),
                                      ],
                                    )
                                    : null,
                            color: isSelected ? null : const Color(0xFFF5F7FB),
                            borderRadius: BorderRadius.circular(16),
                            border:
                                isToday && !isSelected
                                    ? Border.all(
                                      color: const Color(0xFF0066CC),
                                      width: 2,
                                    )
                                    : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                weekDays[index],
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : isToday
                                          ? const Color(0xFF0066CC)
                                          : Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                days[index].split('.')[0],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : isToday
                                          ? const Color(0xFF0066CC)
                                          : const Color(0xFF1A1A1A),
                                ),
                              ),
                              // if (isToday && !isSelected)
                              //   Container(
                              //     margin: const EdgeInsets.only(top: 2),
                              //     width: 4,
                              //     height: 4,
                              //     decoration: const BoxDecoration(
                              //       color: Color(0xFF0066CC),
                              //       shape: BoxShape.circle,
                              //     ),
                              //   ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              _arrowButton(
                Icons.arrow_forward_ios_rounded,
                selectedIndex < days.length - 1,
                () {
                  if (selectedIndex < days.length - 1) {
                    setState(() => selectedIndex++);
                    _loadLessonsForSelectedDate();
                    _scrollToSelectedDateAnimated();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _arrowButton(IconData icon, bool enabled, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: enabled ? const Color(0xFF004DA9) : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: enabled ? onPressed : null,
        icon: Icon(
          icon,
          size: 18,
          color: enabled ? Colors.white : Colors.grey[500],
        ),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      ),
    );
  }

  String _getMonthYearText() {
    if (selectedIndex >= 0 && selectedIndex < fullDates.length) {
      final d = fullDates[selectedIndex];
      const months = [
        "Yanvar",
        "Fevral",
        "Mart",
        "Aprel",
        "May",
        "Iyun",
        "Iyul",
        "Avgust",
        "Sentabr",
        "Oktabr",
        "Noyabr",
        "Dekabr",
      ];
      return "${months[d.month - 1]} ${d.year}";
    }
    return "";
  }

  Widget _buildLessonsList() {
    return Expanded(
      child: Consumer<TodayLessonsProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            onRefresh: () async {
              // Tanlangan sanaga asoslangan darslarni qayta yuklash
              _loadLessonsForSelectedDate();
              // Shu yerda provider isLoading ni tekshirishingiz mumkin
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child:
                provider.isLoading
                    ? ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            height: 120,
                          ),
                        );
                      },
                    )
                    : _lessonsListView(provider),
          );
        },
      ),
    );
  }

  Widget _lessonsListView(TodayLessonsProvider provider) {
    final selectedDate =
        selectedIndex >= 0 && selectedIndex < fullDates.length
            ? fullDates[selectedIndex]
            : DateTime.now();
    final filtered = _filterLessonsByDate(provider, selectedDate);

    if (filtered.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 300,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy_rounded,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Bu kuni dars yo‘q",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDate(selectedDate),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF004DA9),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final h = filtered[index];
        final s = provider.todayLessons!.student;
        return LessonCard(
          student: "${s.firstName} ${s.lastName}".trim(),
          group: s.group,
          lessonNumber: "${h.lesson.lessonNumber}-dars",
          dayOfWeek: _formatDay(h.lesson.day),
          time: _formatTime(h.assignedDate),
          subject: h.subject,
          teacher: h.teacher,
          title: h.title,
          description: h.description,
          index: index,
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LessonDetailPage(homework: h),
                ),
              ),
        );
      },
    );
  }

  String _formatDay(String day) {
    const map = {
      "dushanba": "Dush",
      "seshanba": "Sesh",
      "chorshanba": "Chor",
      "payshanba": "Pay",
      "juma": "Jum",
      "shanba": "Shan",
      "yakshanba": "Yak",
    };
    return map[day.toLowerCase()] ?? day;
  }

  String _formatTime(DateTime d) =>
      "${d.day} Noyabr, ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";
  String _formatDate(DateTime d) =>
      "${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}";

  List<Homework> _filterLessonsByDate(TodayLessonsProvider p, DateTime d) {
    if (p.todayLessons == null) return [];
    return p.todayLessons!.homeworks
        .where(
          (h) =>
              h.assignedDate.year == d.year &&
              h.assignedDate.month == d.month &&
              h.assignedDate.day == d.day,
        )
        .toList();
  }

  void _loadLessonsForSelectedDate() {
    if (selectedIndex >= 0 && selectedIndex < fullDates.length) {
      Provider.of<TodayLessonsProvider>(
        context,
        listen: false,
      ).loadTodayLessons(fullDates[selectedIndex]);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class LessonCard extends StatelessWidget {
  final String lessonNumber,
      dayOfWeek,
      time,
      subject,
      teacher,
      group,
      student,
      title,
      description;
  final int index;
  final VoidCallback onTap;

  const LessonCard({
    super.key,
    required this.lessonNumber,
    required this.dayOfWeek,
    required this.time,
    required this.subject,
    required this.teacher,
    required this.group,
    required this.student,
    required this.title,
    required this.description,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
      [const Color(0xFFEC4899), const Color(0xFFF43F5E)],
      [const Color(0xFF10B981), const Color(0xFF059669)],
    ];
    final c = colors[index % colors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: c[0].withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: c),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        lessonNumber,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      dayOfWeek,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      time,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _row(Icons.book_rounded, "Fan", subject, c[0]),
                _row(Icons.person_rounded, "O‘qituvchi", teacher, c[1]),
                _row(
                  Icons.face_rounded,
                  "O‘quvchi",
                  student,
                  const Color(0xFF6366F1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
