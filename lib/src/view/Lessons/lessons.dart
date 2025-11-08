import 'package:parents/src/library/librarys.dart';
import 'package:parents/src/data/model/LessonsModel.dart';

class LessonDetailPage extends StatelessWidget {
  final Homework homework;
  const LessonDetailPage({super.key, required this.homework});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0E6D8),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
        backgroundColor: const Color(0xFF004DA9),
        centerTitle: true,

        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.school_rounded, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Text(
              homework.subject,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: 'Comic Sans MS',
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daftar shaklidagi karta
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border(
                  left: BorderSide(color: const Color(0xFFE91E63), width: 8),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12,
                    color: Colors.black.withOpacity(0.15),
                    offset: const Offset(3, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Daftar sarlavhasi
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFFEB3B).withOpacity(0.3),
                          const Color(0xFFFFC107).withOpacity(0.2),
                        ],
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: const Color(0xFF757575).withOpacity(0.3),
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4,
                                color: const Color(0xFF4CAF50).withOpacity(0.4),
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.edit_note_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          '📚 Uy Vazifa',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF5D4037),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Daftar mazmuni
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sarlavha qismi
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF2196F3),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Text('✏️', style: TextStyle(fontSize: 24)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Sarlavha :',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF1976D2),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      homework.title,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF1565C0),
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Vazifa matni - daftar chiziqlari bilan
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFDE7),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFFFB300),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Text('📝', style: TextStyle(fontSize: 20)),
                                  SizedBox(width: 8),
                                  Text(
                                    'Izoh :',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFF57C00),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4,
                                      color: Colors.black.withOpacity(0.05),
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  homework.description,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF424242),
                                    height: 1.8,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
}
