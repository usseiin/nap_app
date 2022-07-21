//create Journal
class Journal {
  String id;
  String date;
  String mood;
  String note;
  Journal({
    required this.id,
    required this.date,
    required this.mood,
    required this.note,
  });
  //return map json to database format
  factory Journal.fromJson(Map<String, dynamic> json) => Journal(
        id: json["id"],
        date: json["date"],
        mood: json["mood"],
        note: json["note"],
      );

  //function to convert journal to Json format
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "date": date,
      "mood": mood,
      "note": note,
    };
  }
}
