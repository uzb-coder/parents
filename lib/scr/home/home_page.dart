import 'package:parents/library/librarys.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Parents? parents;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadParentsData();
  }

  Future<void> _loadParentsData() async {
    try {
      final savedParents = await LoginService.getSavedParents();
      setState(() {
        parents = savedParents;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Ma'lumot yuklashda xato: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (parents == null) {
      return const Center(child: Text("Ma'lumot topilmadi"));
    }

    final guardian = parents!.guardian;
    final firstChild =
        parents!.children.isNotEmpty ? parents!.children[0] : null;

    return Scaffold(
      drawer: ProfileDrawer(),
      backgroundColor: Colors.grey[200],
      appBar: AppBarWidget(context, title: "Asosiy"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(firstChild?.fullName ?? ''),
            const SizedBox(height: 20),
            _buildProgressCard(),
            const SizedBox(height: 20),
            _buildSectionTitle("So'nggi baholar", "Barchasi"),
            const SizedBox(height: 10),
            _buildLatestGradeCard(),
            //   _buildComingSoonBanner(),
            const SizedBox(height: 20),
            _buildQuarterlyGrades(),
            const SizedBox(height: 20),
            _buildMonthlyGradesChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String fullName) {
    // fullName bosh harflarini olish
    String initials = '';
    if (fullName.isNotEmpty) {
      final parts = fullName.split(' ');
      if (parts.isNotEmpty) {
        initials =
            parts.map((p) => p.isNotEmpty ? p[0].toUpperCase() : '').join();
      }
    }

    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.deepPurpleAccent,
          child: Text(
            initials,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fullName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'Uyga vazifa',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Umumiy o'zlashtirish kartasi
  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Farzandingiz natijasi',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                "Umumiy o'zlashtirish",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          CircularPercentIndicator(
            radius: 40.0,
            lineWidth: 8.0,
            animation: true,
            percent: 0.18,
            center: const Text(
              "18.0%",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: Colors.lightGreenAccent,
            backgroundColor: Colors.blue.shade700,
          ),
        ],
      ),
    );
  }

  // Bo'lim sarlavhasi
  Widget _buildSectionTitle(String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          actionText,
          style: const TextStyle(fontSize: 14, color: Colors.blue),
        ),
      ],
    );
  }

  // So'nggi baho kartasi
  Widget _buildLatestGradeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red.withOpacity(0.1),
            ),
            child: const Text(
              '3',
              style: TextStyle(
                color: Colors.red,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 15),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '26-08-2025',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              SizedBox(height: 4),
              Text(
                'Matematika',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Haver ekan', // Bu joyni o'zingiz o'zgartirishingiz mumkin
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // "Tez kunda" banneri
  // Widget _buildComingSoonBanner() {
  //   return Container(
  //     width: 500,
  //     height: 80,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(15),
  //       gradient: const LinearGradient(
  //         colors: [Colors.orangeAccent, Colors.deepOrangeAccent],
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //       ),
  //     ),
  //     child: Stack(
  //       alignment: Alignment.center,
  //       children: [
  //         // Orqa fondagi raqamlar va matnlar (effekt uchun)
  //         const Positioned(
  //           left: 20,
  //           child: Text(
  //             '123000',
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontSize: 28,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ),
  //         // Container(
  //         //   margin: EdgeInsets.only(left: 250),
  //         //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //         //   decoration: BoxDecoration(
  //         //     color: Colors.amber,
  //         //     borderRadius: BorderRadius.circular(20),
  //         //   ),
  //         //   child: const Text(
  //         //     'Tez kunda',
  //         //     style: TextStyle(
  //         //       color: Colors.white,
  //         //       fontWeight: FontWeight.bold,
  //         //     ),
  //         //   ),
  //         // ),
  //       ],
  //     ),
  //   );
  // }

  // Chorak baholari uchun widget
  Widget _buildQuarterlyGrades() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Chorak bo'yicha baholar",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildGradeItem("1-chorak", "0.0"),
              _buildGradeItem("2-chorak", "0.0"),
              _buildGradeItem("3-chorak", "0.0"),
              _buildGradeItem("4-chorak", "0.0"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGradeItem(String title, String grade) {
    return Column(
      children: [
        Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        const SizedBox(height: 8),
        Text(
          grade,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Oylar bo'yicha baholar grafigi
  Widget _buildMonthlyGradesChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Oy bo'yicha baholar",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('5', style: TextStyle(color: Colors.grey[600])),
                    Text('4', style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(height: 20), // Bo'sh joy
                  ],
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.grey.shade300),
                        bottom: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Grafik ma\'lumotlari shu yerda bo\'ladi',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
