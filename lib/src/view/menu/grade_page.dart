import 'package:parents/src/library/librarys.dart';
import '../../data/Providers/GradesProvider.dart';

class GradePage extends StatelessWidget {
  const GradePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GradesProvider()..loadGrades(),
      child: Scaffold(
        drawer: ProfileDrawer(),
        appBar: AppBar(
          backgroundColor: const Color(0xff004da9),
          foregroundColor: Colors.white,
          centerTitle: true,
          title: const Text("Baholar"),
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
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.grades.isEmpty) {
          return const Center(child: Text("Baholar topilmadi"));
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.9,
            ),
            children:
                provider.grades.map((lesson) {
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
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
                }).toList(),
          ),
        );
      },
    );
  }
}

class Fanlar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    Color getGradeColor(int? grade) {
      if (grade == null) return Colors.grey.shade300;
      switch (grade) {
        case 5:
          return Colors.green; // A'lo baho - yashil
        case 4:
          return Colors.blue; // Yaxshi baho - ko'k
        case 3:
          return Colors.orange; // Qoniqarli - sariq/to'q sariq
        case 2:
          return Colors.red; // Qoniqarsiz - qizil
        default:
          return Colors.grey.shade300;
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff004da9),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(title),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: [
            // Baho kartasi
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 3,
              child: SizedBox(
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Baho
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: getGradeColor(grade),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${grade ?? '-'}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Sana, dars va xona
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Sana
                            Text(
                              'Sana: ${date ?? '-'}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            // Dars va Xona yonma-yon
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '${lessonNumber ?? ''} - Dars*',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(width: 20),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
