import 'dart:convert';
import 'dart:developer';

import 'package:nap_app/models/database.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

//clas to create and modify file..
class DatabaseFileRoutines {
  Future<String> get _localPath async {
    //get the application directory
    final directory = await getApplicationSupportDirectory();
    //return the directory path
    return directory.path;
  }

  Future<File> get _localFile async {
    //get the directory path
    final path = await _localPath;
    //create file in path and return file
    return File("$path/local_persistence.json");
  }

  Future<String> readJournals() async {
    try {
      //get file
      final file = await _localFile;
      //if file data does not exist create file data
      if (!file.existsSync()) {
        log("file does not exist: ${file.absolute}");
        //create to file data
        await writeJournals('{"journals":[]}');
      }
      //read the file data
      String contents = await file.readAsString();
      //return file data
      return contents;
    } catch (e) {
      log("error readJournal: ${e.toString()}");
      return "";
    }
  }

  Future<File> writeJournals(String json) async {
    //get the file
    final file = await _localFile;
    //write to the file
    return file.writeAsString(json);
  }
}

Database toDatabaseStrToObjJson(String str) {
  //convert Str to Obj
  final strToJson = json.decode(str);
  //return Database in Json format
  return Database.fromJson(strToJson);
}

String fromDatabaseObjToStrJson(Database data) {
  //get database in Json format
  final dataToJson = data.toJson();
  //convert json format database to String
  return json.encode(dataToJson);
}
