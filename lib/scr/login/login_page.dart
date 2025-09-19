import '../../library/librarys.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _loginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBarWidget(context, title: "Kirish"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(height: 40),

                      // 🔹 Logo shu yerda dumaloq bo‘lib chiqadi
                      Center(
                        child: Image.asset(
                          "assets/icon.png",
                          width: 200,
                          height: 120,
                        ),
                      ),

                      const SizedBox(height: 60),
                      const Text(
                        'Telefon va login kiriting',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Login kiritish maydoni
                      TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          hintText: '+998 (99) 999-99-99',
                          filled: true,
                          fillColor: Colors.white,
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: const Color.fromARGB(255, 65, 60, 60),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Login kiritish maydoni
                      TextField(
                        controller: _loginController,
                        decoration: InputDecoration(
                          hintText: 'Loginingizni kiriting',
                          filled: true,
                          fillColor: Colors.white,
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: const Color.fromARGB(255, 65, 60, 60),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home'); // ✅ oddiy usul
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A4C9A), // asosiy ko‘k
                  foregroundColor: Colors.white, // matn va ikonalar oq
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Davom etish',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
