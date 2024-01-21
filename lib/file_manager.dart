import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

const appStateSaveFilename = "appstate.txt";
const appDataSaveFilename = "shiftdata.txt";

Future<File> getFile(String filename) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File("${directory.path}/$filename");

  bool fileExists = await file.exists();
  if (!fileExists) {
    return await file.create();
  } else {
    return file;
  }
}

Future<File> saveAppState(DateTime latestClockInTime) async {
  final file = await getFile(appStateSaveFilename);
  return await file.writeAsString("$latestClockInTime", mode: FileMode.write);
}

Future<File> saveShiftData(List<DateTime> clockInTimes, List<DateTime> clockOutTimes) async {
  final file = await getFile(appDataSaveFilename);

  var listLength = clockInTimes.length;

  await file.writeAsString("$listLength\n", mode: FileMode.write);

  for (int i = 0; i < listLength; i++) {
    await file.writeAsString("${clockInTimes[i]}\n${clockOutTimes[i]}\n", mode: FileMode.append);
  }

  return file;
}

Future<int> loadAppStateElapsedTime() async {
  final appStateSave = await getFile(appStateSaveFilename);
  final lines = await appStateSave.readAsLines();

  var timeElapsedInSeconds = 0;

  if (lines.isNotEmpty) {
    var lastStartTime = DateTime.parse(lines[0]);
    timeElapsedInSeconds = DateTime.now().difference(lastStartTime).inSeconds;
  }

  return timeElapsedInSeconds;
}

Future<DateTime?> loadAppStateLastClockIn() async {
  final appStateSave = await getFile(appStateSaveFilename);
  final lines = await appStateSave.readAsLines();

  if (lines.isNotEmpty) {
    return DateTime.parse(lines[0]);
  }

  return null;
}

Future<List<DateTime>> loadClockInTimes() async {
  final appDataSave = await getFile(appDataSaveFilename);
  final lines = await appDataSave.readAsLines(); // or this doesn't work?

  if (lines.isEmpty) {
    return <DateTime>[];
  }

  var listSize = int.parse(lines[0]);
  List<DateTime> clockTimeList = <DateTime>[];

  for (int i = 0; i < listSize; i++) {
    var parsedTime = DateTime.parse(lines[2 * i + 1]);
    clockTimeList.add(parsedTime);
  }

  return clockTimeList;
}

Future<List<DateTime>> loadClockOutTimes() async {
  final appDataSave = await getFile(appDataSaveFilename);
  final lines = await appDataSave.readAsLines(); // or this doesn't work?

  if (lines.isEmpty) {
    return <DateTime>[];
  }

  var listSize = int.parse(lines[0]);
  List<DateTime> clockTimeList = <DateTime>[];

  for (int i = 1; i <= listSize; i++) {
    var parsedTime = DateTime.parse(lines[2 * i]);
    clockTimeList.add(parsedTime);
  }

  return clockTimeList;
}
