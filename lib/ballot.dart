import 'package:hive/hive.dart';

part 'ballot.g.dart';

@HiveType(typeId: 2)
class Ballot extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int googleBallotId;

  @HiveField(2)
  DateTime date;

  Ballot(this.name, this.googleBallotId, this.date);
}
