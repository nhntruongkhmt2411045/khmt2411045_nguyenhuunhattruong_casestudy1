import 'package:flutter/material.dart';
import 'database/database_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quản lý thu chi',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F8FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2878E8),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

String formatMoney(num amount) {
  final value = amount.round().toString();
  final buffer = StringBuffer();
  for (int i = 0; i < value.length; i++) {
    if (i > 0 && (value.length - i) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(value[i]);
  }
  return '${buffer.toString()} đ';
}

String formatAmountInput(String value) {
  final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) return '';

  final buffer = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

int parseAmount(String value) {
  return int.tryParse(value.replaceAll('.', '').replaceAll(',', '')) ?? 0;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> transactions = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final data = await DatabaseHelper.instance.getTransactions();
    if (!mounted) return;
    setState(() {
      transactions = data;
      loading = false;
    });
  }

  Future<void> _openAdd() async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddTransactionScreen(),
      ),
    );
    if (saved == true) {
      await _loadTransactions();
    }
  }

  Future<void> _openEdit(Map<String, dynamic> transaction) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditTransactionScreen(transaction: transaction),
      ),
    );
    if (updated == true) {
      await _loadTransactions();
    }
  }

  double get totalIncome {
    return transactions
        .where((e) => e['isExpense'] == 0)
        .fold<double>(0, (sum, e) => sum + (e['amount'] as num).toDouble());
  }

  double get totalExpense {
    return transactions
        .where((e) => e['isExpense'] == 1)
        .fold<double>(0, (sum, e) => sum + (e['amount'] as num).toDouble());
  }

  @override
  Widget build(BuildContext context) {
    final balance = totalIncome - totalExpense;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FC),
        elevation: 0,
        leading: const Icon(Icons.menu, color: Color(0xFF172033)),
        title: const Text(
          'Quản lý thu chi',
          style: TextStyle(
            color: Color(0xFF172033),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_none,
                  color: Color(0xFF172033),
                ),
              ),
              Positioned(
                right: 7,
                top: 5,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadTransactions,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4B86F7), Color(0xFF1461E8)],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    const Text(
                      'SỐ DƯ HIỆN TẠI',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          formatMoney(balance),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.visibility_outlined,
                          color: Colors.white,
                          size: 19,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _dot(true),
                        _dot(false),
                        _dot(false),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _summaryCard(
                      title: 'TỔNG THU NHẬP',
                      amount: formatMoney(totalIncome),
                      icon: Icons.arrow_downward,
                      color: const Color(0xFF39A94B),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _summaryCard(
                      title: 'TỔNG CHI TIÊU',
                      amount: formatMoney(totalExpense),
                      icon: Icons.arrow_upward,
                      color: const Color(0xFFFF6268),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Giao dịch gần đây',
                    style: TextStyle(
                      color: Color(0xFF172033),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Xem tất cả',
                      style: TextStyle(
                        color: Color(0xFF2878E8),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              if (transactions.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  alignment: Alignment.center,
                  child: const Text(
                    'Chưa có giao dịch\nNhấn nút + để thêm giao dịch',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF7A8190)),
                  ),
                )
              else
                ...transactions.take(10).map(
                      (transaction) => _transaction(
                    context: context,
                    transaction: transaction,
                    onTap: () => _openEdit(transaction),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2878E8),
        foregroundColor: Colors.white,
        onPressed: _openAdd,
        child: const Icon(Icons.add, size: 30),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xFF2878E8),
        unselectedItemColor: const Color(0xFF7A8190),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 1) {
            _openAdd();
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Giao dịch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            activeIcon: Icon(Icons.pie_chart),
            label: 'Thống kê',
          ),
        ],
      ),
    );
  }
}

Widget _dot(bool active) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 3),
    width: active ? 16 : 6,
    height: 5,
    decoration: BoxDecoration(
      color: active ? Colors.white : Colors.white54,
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

Widget _summaryCard({
  required String title,
  required String amount,
  required IconData icon,
  required Color color,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(11),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: color.withValues(alpha: 0.14),
          child: Icon(icon, color: color, size: 19),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF7A8190),
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                amount,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _transaction({
  required BuildContext context,
  required Map<String, dynamic> transaction,
  required VoidCallback onTap,
}) {
  final bool isExpense = transaction['isExpense'] == 1;
  final String category = transaction['category'] as String? ?? '';
  final String title = transaction['title'] as String? ?? category;
  final String date = transaction['date'] as String? ?? '';
  final double amount = (transaction['amount'] as num).toDouble();

  IconData icon;
  Color color;
  switch (category) {
    case 'Ăn uống':
      icon = Icons.restaurant;
      color = const Color(0xFFFF7A21);
      break;
    case 'Mua sắm':
      icon = Icons.shopping_cart;
      color = const Color(0xFF9B45EF);
      break;
    case 'Di chuyển':
      icon = Icons.local_gas_station;
      color = const Color(0xFF2694F2);
      break;
    case 'Giáo dục':
      icon = Icons.school;
      color = const Color(0xFF159C9A);
      break;
    default:
      icon = isExpense ? Icons.arrow_upward : Icons.attach_money;
      color = isExpense ? const Color(0xFFFF6268) : const Color(0xFF29A846);
  }

  return InkWell(
    borderRadius: BorderRadius.circular(10),
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF172033),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      category,
                      style: const TextStyle(
                        color: Color(0xFF7A8190),
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      date,
                      style: const TextStyle(
                        color: Color(0xFF9AA1AE),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '${isExpense ? '-' : '+'}${formatMoney(amount)}',
            style: TextStyle(
              color: isExpense
                  ? const Color(0xFFFF3F4B)
                  : const Color(0xFF21A63A),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  bool isExpense = true;
  String category = 'Ăn uống';

  final amountController = TextEditingController();
  final dateController = TextEditingController(
    text: '03/09/2024',
  );
  final noteController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    dateController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final amount = parseAmount(amountController.text);
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập số tiền hợp lệ')),
      );
      return;
    }

    await DatabaseHelper.instance.insertTransaction({
      'title': noteController.text.trim().isEmpty
          ? category
          : noteController.text.trim(),
      'category': category,
      'amount': amount,
      'date': dateController.text,
      'note': noteController.text.trim(),
      'isExpense': isExpense ? 1 : 0,
    });

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return TransactionForm(
      title: 'Thêm giao dịch',
      isExpense: isExpense,
      category: category,
      amountController: amountController,
      dateController: dateController,
      noteController: noteController,
      onExpenseChanged: () => setState(() => isExpense = true),
      onIncomeChanged: () => setState(() => isExpense = false),
      onCategoryChanged: (value) => setState(() => category = value),
      onSave: _save,
    );
  }
}

class EditTransactionScreen extends StatefulWidget {
  final Map<String, dynamic> transaction;

  const EditTransactionScreen({super.key, required this.transaction});

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  late bool isExpense;
  late String category;
  late TextEditingController amountController;
  late TextEditingController dateController;
  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();
    isExpense = widget.transaction['isExpense'] == 1;
    category = widget.transaction['category'] as String? ?? 'Ăn uống';
    final amount = (widget.transaction['amount'] as num?)?.toInt() ?? 0;
    amountController = TextEditingController(
      text: formatAmountInput(amount.toString()),
    );
    dateController = TextEditingController(
      text: widget.transaction['date'] as String? ?? '',
    );
    noteController = TextEditingController(
      text: widget.transaction['note'] as String? ?? '',
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    dateController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> _update() async {
    final amount = parseAmount(amountController.text);
    final id = widget.transaction['id'] as int?;

    if (id == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dữ liệu giao dịch không hợp lệ')),
      );
      return;
    }

    await DatabaseHelper.instance.updateTransaction(id, {
      'title': noteController.text.trim().isEmpty
          ? category
          : noteController.text.trim(),
      'category': category,
      'amount': amount,
      'date': dateController.text,
      'note': noteController.text.trim(),
      'isExpense': isExpense ? 1 : 0,
    });

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return TransactionForm(
      title: 'Sửa giao dịch',
      isExpense: isExpense,
      category: category,
      amountController: amountController,
      dateController: dateController,
      noteController: noteController,
      onExpenseChanged: () => setState(() => isExpense = true),
      onIncomeChanged: () => setState(() => isExpense = false),
      onCategoryChanged: (value) => setState(() => category = value),
      onSave: _update,
    );
  }
}

class TransactionForm extends StatelessWidget {
  final String title;
  final bool isExpense;
  final String category;
  final TextEditingController amountController;
  final TextEditingController dateController;
  final TextEditingController noteController;
  final VoidCallback onExpenseChanged;
  final VoidCallback onIncomeChanged;
  final ValueChanged<String> onCategoryChanged;
  final VoidCallback onSave;

  const TransactionForm({
    super.key,
    required this.title,
    required this.isExpense,
    required this.category,
    required this.amountController,
    required this.dateController,
    required this.noteController,
    required this.onExpenseChanged,
    required this.onIncomeChanged,
    required this.onCategoryChanged,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF172033),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 52,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE0E5EC)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: onExpenseChanged,
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isExpense
                                ? const Color(0xFFFF6268)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Text(
                            'Chi tiêu',
                            style: TextStyle(
                              color: isExpense
                                  ? Colors.white
                                  : const Color(0xFF344054),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: onIncomeChanged,
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: !isExpense
                                ? const Color(0xFF2878E8)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Text(
                            'Thu nhập',
                            style: TextStyle(
                              color: !isExpense
                                  ? Colors.white
                                  : const Color(0xFF344054),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Danh mục',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF344054),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD9E0E8)),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: category,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: const [
                      DropdownMenuItem(
                        value: 'Ăn uống',
                        child: Row(
                          children: [
                            Icon(Icons.restaurant, color: Color(0xFFFF6268)),
                            SizedBox(width: 10),
                            Text('Ăn uống'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Mua sắm',
                        child: Row(
                          children: [
                            Icon(Icons.shopping_cart, color: Color(0xFF2878E8)),
                            SizedBox(width: 10),
                            Text('Mua sắm'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Di chuyển',
                        child: Row(
                          children: [
                            Icon(Icons.directions_car, color: Color(0xFF2878E8)),
                            SizedBox(width: 10),
                            Text('Di chuyển'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Giáo dục',
                        child: Row(
                          children: [
                            Icon(Icons.school, color: Color(0xFF159C9A)),
                            SizedBox(width: 10),
                            Text('Giáo dục'),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) onCategoryChanged(value);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Số tiền',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF344054),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final formatted = formatAmountInput(value);
                  if (formatted != value) {
                    amountController.value = TextEditingValue(
                      text: formatted,
                      selection: TextSelection.collapsed(
                        offset: formatted.length,
                      ),
                    );
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Nhập số tiền',
                  suffixText: 'đ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Ngày giao dịch',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF344054),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: dateController,
                readOnly: true,
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.calendar_month),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2035),
                  );
                  if (date != null) {
                    dateController.text =
                    '${date.day.toString().padLeft(2, '0')}/'
                        '${date.month.toString().padLeft(2, '0')}/'
                        '${date.year}';
                  }
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Ghi chú',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF344054),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Nhập ghi chú (tùy chọn)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2878E8),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: const Text(
                    'Lưu',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
