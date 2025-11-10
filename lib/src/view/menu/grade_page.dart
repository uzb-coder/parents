import 'package:parents/src/library/librarys.dart';
import '../../data/Providers/GradesProvider.dart';

class GradePage extends StatelessWidget {
  const GradePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GradesProvider()..loadGrades(),
      child: Scaffold(
        drawer: const ProfileDrawer(),
        appBar: AppBar(
          backgroundColor: const Color(0xff004da9),
          foregroundColor: Colors.white,
          centerTitle: true,
          title: const Text("Jurnal", style: TextStyle(fontSize: 18)),
          actions: [
            Consumer<GradesProvider>(
              builder: (_, p, __) {
                return GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: p.selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      p.filterByDate(picked);
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Icon(Icons.calendar_month, size: 30),
                  ),
                );
              },
            ),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
        ),
        body: const SafeArea(child: GradeGrid()),
      ),
    );
  }
}

class GradeGrid extends StatelessWidget {
  const GradeGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GradesProvider>(
      builder: (context, provider, child) {
        return RefreshIndicator(
          onRefresh: provider.refresh, // Pull-to-refresh
          child: _buildBody(provider),
        );
      },
    );
  }

  Widget _buildBody(GradesProvider provider) {
    // Dastlabki yuklashda shimmer
    if (provider.isLoading && provider.grades.isEmpty) {
      return _buildShimmerGrid();
    }

    if (provider.grades.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.grade, size: 64, color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              "Baho qo‘yilmagan",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    // Asosiy grid
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(), // Refresh uchun zarur
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.9,
        ),
        itemCount: provider.grades.length,
        itemBuilder: (context, index) {
          final lesson = provider.grades[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => Fanlar(
                        title: lesson.subject,
                        grade: lesson.grade,
                        lessonNumber: lesson.lessonNumber,
                        status: lesson.status,
                        date: lesson.date,
                      ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      lesson.subject,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0A4C9A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    Icons.menu_book_rounded,
                    size: 40,
                    color: Color(0xFF0A4C9A),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Shimmer effekti
  Widget _buildShimmerGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.9,
        ),
        itemCount: 6,
        itemBuilder:
            (_, __) => Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 90, height: 16, color: Colors.white),
                    Container(width: 40, height: 40, color: Colors.white),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}

class Fanlar extends StatefulWidget {
  final String title;
  final int? lessonNumber;
  final int? grade;
  final String status;
  final String? date;
  final String? room;

  const Fanlar({
    super.key,
    required this.title,
    this.lessonNumber,
    this.grade,
    required this.status,
    this.date,
    this.room,
  });

  @override
  State<Fanlar> createState() => _FanlarState();
}

class _FanlarState extends State<Fanlar> {
  Color getGradeColor(int? grade) {
    if (grade == null) return Colors.grey;
    switch (grade) {
      case 5:
        return const Color(0xFF4CAF50);
      case 4:
        return const Color(0xFF2196F3);
      case 3:
        return const Color(0xFFFF9800);
      case 2:
        return const Color(0xFFF44336);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF004DA9),
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFFFFF8DC),
              size: 28,
            ),
          ),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Asosiy kartochka
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border(
                  left: BorderSide(
                    color:
                        widget.grade == null
                            ? Colors.grey
                            : getGradeColor(widget.grade),
                    width: 8,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12,
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(2, 6),
                  ),
                ],
              ),
              child:
                  widget.grade == null
                      ? const Center(
                        child: Text(
                          'Bu fanga baho yo‘q',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF757575),
                          ),
                        ),
                      )
                      : Row(
                        children: [
                          // Chapdagi ma'lumotlar
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (widget.date != null)
                                  _infoRow(
                                    Icons.calendar_today_rounded,
                                    'Sana',
                                    widget.date!,
                                  ),
                                const SizedBox(height: 12),
                                if (widget.lessonNumber != null)
                                  _infoRow(
                                    Icons.class_rounded,
                                    'Dars',
                                    '${widget.lessonNumber}-dars',
                                  ),
                                const SizedBox(height: 12),
                                if (widget.room != null)
                                  _infoRow(
                                    Icons.room_rounded,
                                    'Xona',
                                    '${widget.room}-xona',
                                  ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 20),

                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: getGradeColor(widget.grade),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 8,
                                  color: getGradeColor(
                                    widget.grade,
                                  ).withOpacity(0.5),
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    '${widget.grade}',
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Baho',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF8B4513).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF8B4513)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 15, color: Color(0xFF424242)),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF757575),
                  ),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF424242),
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
