import 'package:shimmer/shimmer.dart';
import 'package:parents/library/librarys.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Parents? parents;
  StudentProgress? progress;
  bool isLoadingParents = true;
  bool isLoadingProgress = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadParents();
    _loadProgress();
  }

  Future<void> _loadParents() async {
    try {
      final savedParents = await LoginService.getSavedParents();
      if (savedParents == null || savedParents.children.isEmpty) {
        throw "Farzand ma'lumotlari topilmadi";
      }
      setState(() {
        parents = savedParents;
        isLoadingParents = false;
      });
      // Progressni faqat parents yuklangandan keyin yuklaymiz
      if (isLoadingProgress) _loadProgress();
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoadingParents = false;
      });
    }
  }

  Future<void> _loadProgress() async {
    if (parents == null || !mounted) return;

    setState(() => isLoadingProgress = true);

    try {
      final studentId = parents!.children[0].id;
      final fetched = await HomeService.fetchTodayLessons(studentId);
      if (!mounted) return;
      setState(() {
        progress = fetched;
        isLoadingProgress = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoadingProgress = false;
      });
    }
  }

  Future<void> _refresh() async {
    setState(() {
      isLoadingProgress = true;
      progress = null;
    });
    await _loadParents();
  }

  @override
  Widget build(BuildContext context) {
    // Xato holati
    if (error != null) {
      return _buildErrorScreen();
    }

    // Parents yuklanayotgan bo'lsa
    if (isLoadingParents || parents == null) {
      return _buildFullSkeleton();
    }

    final child = parents!.children[0];
    final student = progress?.student;
    final fullName =
        student?.fullName.isNotEmpty == true
            ? student!.fullName
            : child.fullName;
    final group =
        student?.group.isNotEmpty == true ? student!.group : 'Guruh yo\'q';

    return Scaffold(
      drawer: const ProfileDrawer(),
      backgroundColor: Colors.grey[50],
      appBar: AppBarWidget(context, title: "Asosiy sahifa"),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: Colors.blue.shade600,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. PROFIL KARTASI — darhol
              _buildProfileCard(fullName, group),
              const SizedBox(height: 20),

              // 2. UMUMIY O'ZLASHTIRISH
              isLoadingProgress
                  ? _buildSkeletonProgressCard()
                  : _buildProgressCard(progress?.overallProgress ?? 0),
              const SizedBox(height: 20),

              // 3. SO'NGGI BAHOLAR
              isLoadingProgress
                  ? _buildSkeletonMarks()
                  : _buildLastMarks(progress?.lastMarks ?? []),
              const SizedBox(height: 20),

              // 4. CHORAK BAHOLARI
              isLoadingProgress
                  ? _buildSkeletonQuarterly()
                  : _buildQuarterlyGrades(progress?.quarterMarks ?? {}),
              const SizedBox(height: 20),

              // 5. OYLIK GRAFIK
              isLoadingProgress
                  ? _buildSkeletonChart()
                  : _buildMonthlyChart(progress?.monthlyMarks ?? []),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ================== WIDGETS ==================

  Widget _buildProfileCard(String name, String group) {
    final initials =
        name
            .split(' ')
            .where((s) => s.isNotEmpty)
            .map((s) => s[0].toUpperCase())
            .take(2)
            .join();

    return Card(
      elevation: 6,
      shadowColor: Colors.blue.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade500, Colors.blue.shade700],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white,
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.school,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            group,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.white.withOpacity(0.8),
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard(int value) {
    final percent = (value / 100).clamp(0.0, 1.0);
    return Card(
      elevation: 4,
      shadowColor: Colors.green.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade400, Colors.green.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Natijalar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Umumiy o'zlashtirish",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Barcha fanlar bo'yicha",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: CircularPercentIndicator(
                radius: 50,
                lineWidth: 12,
                animation: true,
                percent: percent,
                center: Text(
                  "$value%",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                progressColor: Colors.white,
                backgroundColor: Colors.white.withOpacity(0.3),
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastMarks(List<LastMark> marks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          "So'nggi baholar",
          Icons.calendar_today,
          Colors.purple,
        ),
        const SizedBox(height: 12),
        marks.isEmpty
            ? _buildEmptyCard("Hozircha baholar yo'q", Icons.grade)
            : Column(children: marks.map(_buildMarkItem).toList()),
      ],
    );
  }

  Widget _buildMarkItem(LastMark mark) {
    final color = _getMarkColor(mark.mark);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.3), width: 2),
                ),
                child: Center(
                  child: Text(
                    '${mark.mark}',
                    style: TextStyle(
                      color: color,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mark.subjectName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          mark.date,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getMarkLabel(mark.mark),
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuarterlyGrades(Map<String, int> quarters) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          "Chorak bo'yicha baholar",
          Icons.bar_chart,
          Colors.orange,
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
                  ['1', '2', '3', '4']
                      .map(
                        (q) =>
                            _buildQuarterBadge("$q-chorak", quarters[q] ?? 0),
                      )
                      .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuarterBadge(String label, int grade) {
    final color = grade > 0 ? _getMarkColor(grade) : Colors.grey;
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.1),
            border: Border.all(color: color, width: 3),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: Text(
              grade > 0 ? '$grade' : '-',
              style: TextStyle(
                color: color,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyChart(List<MonthlyMark> marks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          "Oylik o'rtacha baholar",
          Icons.show_chart,
          Colors.blue,
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 200,
              child:
                  marks.isEmpty
                      ? _buildEmptyState(
                        "Oylik ma'lumotlar yo'q",
                        Icons.insights,
                      )
                      : _buildBarChart(marks),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart(List<MonthlyMark> marks) {
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children:
                marks.asMap().entries.map((e) {
                  final mark = e.value;
                  final avg = mark.average;
                  final color = _getMarkColor(avg.round());
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            avg.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: (avg / 5.0) * 120,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [color, color.withOpacity(0.6)],
                              ),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(8),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withOpacity(0.3),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:
              marks
                  .map(
                    (m) => Text(
                      m.monthName.substring(0, 3),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }

  // ================== SKELETON WIDGETS ==================

  Widget _buildFullSkeleton() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBarWidget(context, title: "Asosiy sahifa"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSkeletonProfile(),
            const SizedBox(height: 20),
            _buildSkeletonProgressCard(),
            const SizedBox(height: 20),
            _buildSkeletonSection("So'nggi baholar"),
            _buildSkeletonMarks(),
            const SizedBox(height: 20),
            _buildSkeletonSection("Chorak bo'yicha baholar"),
            _buildSkeletonQuarterly(),
            const SizedBox(height: 20),
            _buildSkeletonSection("Oylik o'rtacha baholar"),
            _buildSkeletonChart(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonProfile() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonProgressCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonMarks() {
    return Column(
      children: List.generate(
        3,
        (_) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonQuarterly() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonChart() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonSection(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(width: 36, height: 36, color: Colors.grey[300]),
          const SizedBox(width: 12),
          Container(width: 150, height: 20, color: Colors.grey[300]),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(String message, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(32),
        child: _buildEmptyState(message, icon),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 48, color: Colors.grey[400]),
        ),
        const SizedBox(height: 16),
        Text(
          message,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red.shade400,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Xatolik yuz berdi",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 15),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _refresh,
                icon: const Icon(Icons.refresh),
                label: const Text("Qayta yuklash"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getMarkColor(int mark) {
    if (mark >= 5) return Colors.green.shade600;
    if (mark >= 4) return Colors.blue.shade600;
    if (mark >= 3) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  String _getMarkLabel(int mark) {
    if (mark >= 5) return 'A\'lo';
    if (mark >= 4) return 'Yaxshi';
    if (mark >= 3) return 'Qoniqarli';
    return 'Qoniqarsiz';
  }
}
