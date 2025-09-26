import 'package:parents/library/librarys.dart';

class Payments extends StatelessWidget {
  const Payments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ProfileDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A4C9A),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text("To'lovlar"),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: Colors.white24,
              child: Text(
                "KS",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            // 🔵 Balans kartasi
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        color: Color(0xFF0A4C9A),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Ummumiy balans",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0A4C9A),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),
                  Text(
                    "800 000 So'm",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            SizedBox(height: 18),

            Text(
              "Miqdori",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            _Card(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Miqdor­ni kiriting",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 16),

            // 🛈 Eslatma
            Text(
              "To'lov balansingizda markaz xodimi tranzaksiyani ma'qullagandan so'ng ko'rinadi.",
              style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
            SizedBox(height: 20),

            // 🧾 Tranzaksiyalar
            Text(
              "Tranzaksiyalar",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 12),

            _DateHeader("26.08.2025"),
            _TransactionTile(
              name: "Kamola Sobirova",
              amount: "300 000 So'm",
              amountColor: Color(0xFF10B981),
              time: "12:16",
              leftMeta: "500K So'm",
              rightMeta: "800K So'm",
            ),
            SizedBox(height: 12),

            _DateHeader("21.08.2025"),
            _TransactionTile(
              name: "Kamola Sobirova",
              amount: "500 000 So'm",
              amountColor: Color(0xFF10B981),
              time: "16:15",
              leftMeta: "0K So'm",
              rightMeta: "500K So'm",
            ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}

// Sana sarlavhasi
class _DateHeader extends StatelessWidget {
  final String date;
  const _DateHeader(this.date);

  @override
  Widget build(BuildContext context) => Text(
    date,
    style: const TextStyle(
      fontSize: 13,
      color: Color(0xFF6B7280),
      fontWeight: FontWeight.w600,
    ),
  );
}

// Bitta tranzaksiya
class _TransactionTile extends StatelessWidget {
  final String name, amount, time, leftMeta, rightMeta;
  final Color amountColor;

  const _TransactionTile({
    required this.name,
    required this.amount,
    required this.amountColor,
    required this.time,
    required this.leftMeta,
    required this.rightMeta,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Yuqori qator
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amount,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: amountColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Pastki meta
          Row(
            children: [
              Text(
                leftMeta,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.trending_up, size: 16, color: Color(0xFF6B7280)),
              const SizedBox(width: 8),
              Text(
                rightMeta,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
