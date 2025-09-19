import '../../library/librarys.dart';

class Grade extends StatefulWidget {
  const Grade({super.key});

  @override
  State<Grade> createState() => GgradeState();
}

class GgradeState extends State<Grade> {
  @override
  Widget build(BuildContext context) {
    final List<String> fanalar = [
      "Matematika",
      "Fizika",
      "Informatika",
      "Ona tili",
      "Adabiyot",
      "Tarix",
      "Geografiya",
      "Biologiya",
      "Kimyo",
      "Jismoniy tarbiya",
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff004da9), // asosiy ko‘k
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Baholar"),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // har qatorda 2 ta karta
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.9,
            ),
            children:
                fanalar.map((fana) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Fanlar(title: fana),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(
                              0x22000000,
                            ), // kulrang soyani o‘xshatish
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
                          // Fan nomi
                          Expanded(
                            child: Text(
                              fana,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0A4C9A), // asosiy ko‘k
                              ),
                            ),
                          ),
                          // O‘ngdagi ikonka
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
        ),
      ),
    );
  }
}

class Fanlar extends StatelessWidget {
  final String title;
  const Fanlar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A4C9A), // asosiy ko‘k
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(title),
      ),
      body: Center(
        child: Text(
          '$title : bo\'yicha baholar sahifasi',
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
