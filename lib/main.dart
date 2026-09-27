import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
    );
  }
}

// =====================================================
// MÀN HÌNH CHÀO
// =====================================================

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 16.0,
          ),
          child: Column(
            children: [
              const Spacer(),

              // Icon chiếc ví
              const Icon(
                Icons.account_balance_wallet_rounded,
                size: 120,
                color: Color(0xFF1E68D7),
              ),

              const SizedBox(height: 32),

              // Tiêu đề
              const Text(
                'Expense Manager',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),

              const SizedBox(height: 12),

              // Mô tả
              const Text(
                'Quản lý chi tiêu cá nhân\nđơn giản và hiệu quả',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF64748B),
                  height: 1.4,
                ),
              ),

              const Spacer(),

              // Nút Bắt đầu
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D61E7),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Bắt đầu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================
// MÀN HÌNH GIAO DỊCH
// =====================================================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Giao dịch',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Danh sách giao dịch',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),

            const SizedBox(height: 20),

            // Giao dịch mẫu
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const EditTransactionScreen(),
                  ),
                );
              },

              child: Container(
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,

                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6268),
                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: const Icon(
                        Icons.restaurant,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(width: 12),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ăn uống',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF0F172A),
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            '12/04/2025 · Ăn trưa',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Text(
                      '-100.000 đ',
                      style: TextStyle(
                        color: Color(0xFFFF6268),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Nút +
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1D61E7),

        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
              const AddTransactionScreen(),
            ),
          );
        },

        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

// =====================================================
// MÀN HÌNH THÊM GIAO DỊCH
// =====================================================

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState
    extends State<AddTransactionScreen> {

  bool isExpense = true;

  String category = 'Ăn uống';

  final TextEditingController amountController =
  TextEditingController();

  final TextEditingController dateController =
  TextEditingController(
    text: '12/04/2025',
  );

  final TextEditingController noteController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TransactionForm(
      title: 'Thêm giao dịch',
      isExpense: isExpense,
      category: category,

      amountController: amountController,
      dateController: dateController,
      noteController: noteController,

      onExpenseChanged: () {
        setState(() {
          isExpense = true;
        });
      },

      onIncomeChanged: () {
        setState(() {
          isExpense = false;
        });
      },

      onCategoryChanged: (value) {
        setState(() {
          category = value;
        });
      },
    );
  }
}

// =====================================================
// MÀN HÌNH SỬA GIAO DỊCH
// =====================================================

class EditTransactionScreen extends StatefulWidget {
  const EditTransactionScreen({super.key});

  @override
  State<EditTransactionScreen> createState() =>
      _EditTransactionScreenState();
}

class _EditTransactionScreenState
    extends State<EditTransactionScreen> {

  bool isExpense = true;

  String category = 'Ăn uống';

  final TextEditingController amountController =
  TextEditingController(
    text: '100.000',
  );

  final TextEditingController dateController =
  TextEditingController(
    text: '12/04/2025',
  );

  final TextEditingController noteController =
  TextEditingController(
    text: 'Ăn trưa',
  );

  @override
  Widget build(BuildContext context) {
    return TransactionForm(
      title: 'Sửa giao dịch',
      isExpense: isExpense,
      category: category,

      amountController: amountController,
      dateController: dateController,
      noteController: noteController,

      onExpenseChanged: () {
        setState(() {
          isExpense = true;
        });
      },

      onIncomeChanged: () {
        setState(() {
          isExpense = false;
        });
      },

      onCategoryChanged: (value) {
        setState(() {
          category = value;
        });
      },
    );
  }
}

// =====================================================
// FORM DÙNG CHUNG CHO THÊM / SỬA
// =====================================================

class TransactionForm extends StatelessWidget {
  final String title;

  final bool isExpense;

  final String category;

  final TextEditingController amountController;

  final TextEditingController dateController;

  final TextEditingController noteController;

  final VoidCallback onExpenseChanged;

  final VoidCallback onIncomeChanged;

  final Function(String) onCategoryChanged;

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
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            18,
            10,
            18,
            20,
          ),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              // ================= HEADER =================

              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF344054),
                    ),
                  ),

                  Expanded(
                    child: Center(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF172033),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 48),
                ],
              ),

              const SizedBox(height: 15),

              // ================= CHI TIÊU / THU NHẬP =================

              Container(
                height: 52,

                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFE0E5EC),
                  ),

                  borderRadius:
                  BorderRadius.circular(10),
                ),

                child: Row(
                  children: [

                    // CHI TIÊU

                    Expanded(
                      child: GestureDetector(
                        onTap: onExpenseChanged,

                        child: Container(
                          margin:
                          const EdgeInsets.all(2),

                          decoration: BoxDecoration(
                            color: isExpense
                                ? const Color(0xFFFF6268)
                                : Colors.white,

                            borderRadius:
                            BorderRadius.circular(9),
                          ),

                          alignment:
                          Alignment.center,

                          child: Text(
                            'Chi tiêu',

                            style: TextStyle(
                              color: isExpense
                                  ? Colors.white
                                  : const Color(
                                0xFF344054,
                              ),

                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // THU NHẬP

                    Expanded(
                      child: GestureDetector(
                        onTap: onIncomeChanged,

                        child: Container(
                          margin:
                          const EdgeInsets.all(2),

                          decoration: BoxDecoration(
                            color: !isExpense
                                ? const Color(0xFF2878E8)
                                : Colors.white,

                            borderRadius:
                            BorderRadius.circular(9),
                          ),

                          alignment:
                          Alignment.center,

                          child: Text(
                            'Thu nhập',

                            style: TextStyle(
                              color: !isExpense
                                  ? Colors.white
                                  : const Color(
                                0xFF344054,
                              ),

                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ================= DANH MỤC =================

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

                padding:
                const EdgeInsets.symmetric(
                  horizontal: 12,
                ),

                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFD9E0E8),
                  ),

                  borderRadius:
                  BorderRadius.circular(9),
                ),

                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: category,

                    isExpanded: true,

                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                    ),

                    items: const [
                      DropdownMenuItem(
                        value: 'Ăn uống',

                        child: Row(
                          children: [
                            Icon(
                              Icons.restaurant,
                              color:
                              Color(0xFFFF6268),
                            ),

                            SizedBox(width: 10),

                            Text('Ăn uống'),
                          ],
                        ),
                      ),

                      DropdownMenuItem(
                        value: 'Mua sắm',

                        child: Row(
                          children: [
                            Icon(
                              Icons.shopping_cart,
                              color:
                              Color(0xFF2878E8),
                            ),

                            SizedBox(width: 10),

                            Text('Mua sắm'),
                          ],
                        ),
                      ),

                      DropdownMenuItem(
                        value: 'Di chuyển',

                        child: Row(
                          children: [
                            Icon(
                              Icons.directions_car,
                              color:
                              Color(0xFF2878E8),
                            ),

                            SizedBox(width: 10),

                            Text('Di chuyển'),
                          ],
                        ),
                      ),
                    ],

                    onChanged: (value) {
                      if (value != null) {
                        onCategoryChanged(value);
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ================= SỐ TIỀN =================

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

                keyboardType:
                TextInputType.number,

                decoration: InputDecoration(
                  hintText: 'Nhập số tiền',

                  suffixText: 'đ',

                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(9),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ================= NGÀY =================

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
                  suffixIcon: const Icon(
                    Icons.calendar_month,
                  ),

                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(9),
                  ),
                ),

                onTap: () async {
                  DateTime? date =
                  await showDatePicker(
                    context: context,

                    initialDate:
                    DateTime(2025, 4, 12),

                    firstDate:
                    DateTime(2020),

                    lastDate:
                    DateTime(2030),
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

              // ================= GHI CHÚ =================

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
                  hintText:
                  'Nhập ghi chú (tùy chọn)',

                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(9),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ================= LƯU =================

              SizedBox(
                width: double.infinity,

                height: 52,

                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content:
                        Text(
                          'Đã lưu giao dịch',
                        ),
                      ),
                    );
                  },

                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFF2878E8),

                    elevation: 0,

                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(9),
                    ),
                  ),

                  child: const Text(
                    'Lưu',

                    style: TextStyle(
                      color: Colors.white,
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