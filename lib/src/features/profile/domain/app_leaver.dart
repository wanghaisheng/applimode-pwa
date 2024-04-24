import 'package:applimode_app/src/constants/constants.dart';
import 'package:equatable/equatable.dart';

class AppLeaver extends Equatable {
  const AppLeaver({
    required this.id,
    required this.closedAt,
  });

  final String id;
  final DateTime closedAt;

  factory AppLeaver.fromMap(Map<String, dynamic> map) {
    final closedAtInt = map['closedAt'] as int;
    return AppLeaver(
      id: map['id'] as String? ?? unknown,
      closedAt: DateTime.fromMillisecondsSinceEpoch(closedAtInt),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'closedAt': closedAt.millisecondsSinceEpoch,
    };
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        id,
        closedAt,
      ];
}
