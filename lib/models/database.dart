import 'package:nap_app/models/journal.dart';

//create a database that accept the journals
class Database {
  List<Journal> journals;
  Database({required this.journals});
  //adding to database file format
  factory Database.fromJson(Map<String, dynamic> json) => Database(
        journals: List<Journal>.from(
          json["journals"].map(
            //map to adding database file format i.e. id: json[id]
            (x) => Journal.fromJson(x),
          ),
        ),
      );

  //convert to Json format
  Map<String, dynamic> toJson() => {
        "journals": List<dynamic>.from(
          journals.map(
            (x) => x.toJson(),
          ),
        ),
      };
}
