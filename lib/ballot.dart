import 'package:hive/hive.dart';

import 'election.dart';

class Ballot extends HiveObject {
  //@HiveField(0)
  String name;

  //@HiveField(1)
  DateTime date;

  //@HiveField(2)
  List<Election> elections;

  Ballot(this.name, this.date, this.elections);
}
