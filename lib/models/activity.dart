class Activity {
  final int? id;
  final String title;
  final String subtitle;
  final double amount;
  final DateTime date;
  final bool isExpense;
  final int? assetId;

  const Activity({
    this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.isExpense,
    this.assetId,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "subtitle": subtitle,
      "amount": amount,
      "date": date.toIso8601String(),
      "isExpense": isExpense ? 1 : 0,
      "assetId": assetId,
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map["id"] as int?,
      title: map["title"] as String,
      subtitle: map["subtitle"] as String,
      amount: (map["amount"] as num).toDouble(),
      date: DateTime.parse(map["date"]),
      isExpense: (map["isExpense"] as int) == 1,
      assetId: map["assetId"] as int?,
    );
  }
}