import 'package:parents/library/librarys.dart';

class ProfileDrawer extends StatefulWidget {
  const ProfileDrawer({super.key});

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  Parents? parents;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadParentsData();
    Future.microtask(() {
      Provider.of<PaymentsProvider>(context, listen: false).fetchPayments();
    });
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
    final provider = context.watch<PaymentsProvider>();

    return Drawer(
      child: Container(
        color: const Color(0xFFF0F2F5),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerHeader(provider.totalBalance.toString()),

            const SizedBox(height: 20),
            _buildMenuGroup(
              context,
              children: [
                const SizedBox(height: 10),

                _buildMenuGroup(
                  context,
                  children: [
                    _buildMenuItem(
                      icon: Icons.home,
                      title: 'Asosiy',
                      onTap: () {
                        Navigator.pushNamed(context, '/home');
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.menu_book,
                      title: 'Jurnal',
                      onTap: () {
                        Navigator.pushNamed(context, '/grades');
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.payment,
                      title: "To'lov",
                      onTap: () {
                        Navigator.pushNamed(context, '/payments');
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.logout,
                      title: "Chiqish",
                      onTap: () async {
                        LoginService.logout();
                        SystemNavigator.pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(String sum) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar - real ma'lumot asosida
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.blue,
                child:
                    isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : Text(
                          parents?.guardian.name.isNotEmpty == true
                              ? parents!.guardian.name[0].toUpperCase()
                              : "?",
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
              const SizedBox(width: 12),

              // Ism va telefon - real ma'lumotlar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isLoading)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 16,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 16,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      )
                    else if (parents != null) ...[
                      ...parents!.guardian.name
                          .split(' ')
                          .take(2)
                          .map(
                            (name) => Text(
                              name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.phone,
                            size: 16,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "+${parents!.guardian.phoneNumber}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      const Text(
                        'Ma\'lumot',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Text(
                        'topilmadi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Row(
                        children: [
                          Icon(Icons.phone, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            'Telefon yo\'q',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Balans (static - API dan kelmayotgani uchun)
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Balans: ${sum.toString()}",
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGroup(
    BuildContext context, {
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  // 🔹 Har bir menyu elementi
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: title == "Chiqish" ? Colors.red : Colors.blue,
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: title == "Chiqish" ? Colors.red : null,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}
