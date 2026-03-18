class TransactionModel {
  final String title;
  final String amount;
  final String category;
  final String date;

  TransactionModel(this.title, this.amount, this.category,
      [this.date = 'Today']);
}
