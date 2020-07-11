import 'package:hive/hive.dart';

import 'candidate.dart';

part 'election.g.dart';

@HiveType(typeId: 0)
class Election extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int id;

  @HiveField(2)
  String officeLevel;

  @HiveField(3)
  List<Candidate> candidates;

  @HiveField(4)
  int chosenIndex;

  Election(
    this.name,
    this.id,
    this.officeLevel,
    this.candidates,
    this.chosenIndex,
  );
}
