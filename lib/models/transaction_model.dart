class TransactionModel {
  final int? id;
  final String title;
  final String category;
  final double amount;
  final String date;
  final String note;
  final bool isExpense;

  TransactionModel({
    this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.note,
    required this.isExpense,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'amount': amount,
      'date': date,
      'note': note,
      'isExpense': isExpense ? 1 : 0,
    };
  }

  factory TransactionModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return TransactionModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      category: map['category'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: map['date'] as String,
      note: map['note'] as String? ?? '',
      isExpense: map['isExpense'] == 1,
    );
  }
}