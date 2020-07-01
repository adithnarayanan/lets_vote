import 'candidate.dart';

class Election {
  String name;
  int id;
  String officeLevel;
  List<Candidate> candidates;

  Election(this.name, this.id, this.officeLevel, this.candidates);
}
