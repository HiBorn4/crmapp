class UnitModel {
  final String unitNo;
  final String name;
  final String user;
  final String due;
  final String? amount;
  final String? daysLeft;

  UnitModel({
    required this.unitNo,
    required this.name,
    required this.user,
    required this.due,
    this.amount,
    this.daysLeft,
  });
}