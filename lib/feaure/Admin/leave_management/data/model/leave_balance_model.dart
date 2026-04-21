class LeaveBalanceModel {
  final int id;
  final String name;
  final String code;
  final int allocated;
  final int used;
  final int remaining;
  final double pct;
  final bool isPaid;
  final bool carryForward;

  LeaveBalanceModel({
    required this.id,
    required this.name,
    required this.code,
    required this.allocated,
    required this.used,
    required this.remaining,
    required this.pct,
    required this.isPaid,
    required this.carryForward,
  });

  factory LeaveBalanceModel.fromJson(Map<String, dynamic> json) {
    return LeaveBalanceModel(
      id: json['id'],
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      allocated: json['allocated'] is int ? json['allocated'] : int.tryParse(json['allocated'].toString()) ?? 0,
      used: json['used'] is int ? json['used'] : int.tryParse(json['used'].toString()) ?? 0,
      remaining: json['remaining'] is int ? json['remaining'] : int.tryParse(json['remaining'].toString()) ?? 0,
      pct: json['pct'] is num ? (json['pct'] as num).toDouble() : double.tryParse(json['pct'].toString()) ?? 0.0,
      isPaid: json['is_paid'] == true || json['is_paid'] == 1,
      carryForward: json['carry_forward'] == true || json['carry_forward'] == 1,
    );
  }
}
