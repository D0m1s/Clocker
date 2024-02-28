import 'dart:io';
import 'package:excel/excel.dart';

Future<void> exportDateTimesToExcel(List<DateTime> clockInTimes, List<DateTime> clockOutTimes, int totalTimeWorkedInSeconds) async {
  var excel = Excel.createExcel();
  Sheet sheetObject = excel["Shift summary"];

  // the excel package is broken, unable to delete Sheet1, so gotta use this workaround
  excel.setDefaultSheet("Shift summary");

  CellStyle columnTitleStyle = CellStyle(
    backgroundColorHex: "#a3a3a3", 
    bold: true, 
    horizontalAlign: HorizontalAlign.Center, 
    verticalAlign: VerticalAlign.Center,
    leftBorder: Border(borderStyle: BorderStyle.Thin),
    rightBorder: Border(borderStyle: BorderStyle.Thin),
    topBorder: Border(borderStyle: BorderStyle.Thin),
    bottomBorder: Border(borderStyle: BorderStyle.Thin),
    );

  CellStyle topBorderStyle = CellStyle(
    topBorder: Border(borderStyle: BorderStyle.Thin),
    );

  // the excel package is broken, these 3 are required to write date and time cells
  CellStyle dateStyle = CellStyle(
    numberFormat: NumFormat.defaultDate,
    horizontalAlign: HorizontalAlign.Center, 
    verticalAlign: VerticalAlign.Center,
    leftBorder: Border(borderStyle: BorderStyle.Thin),
    rightBorder: Border(borderStyle: BorderStyle.Thin),
  );
  CellStyle timeWorkedStyle = CellStyle(
    numberFormat: NumFormat.standard_46,
    horizontalAlign: HorizontalAlign.Center, 
    verticalAlign: VerticalAlign.Center,
    leftBorder: Border(borderStyle: BorderStyle.Thin),
    rightBorder: Border(borderStyle: BorderStyle.Thin),
  );
  CellStyle timeStyle = CellStyle(
    numberFormat: NumFormat.defaultTime,
    horizontalAlign: HorizontalAlign.Center, 
    verticalAlign: VerticalAlign.Center,
    leftBorder: Border(borderStyle: BorderStyle.Thin),
    rightBorder: Border(borderStyle: BorderStyle.Thin),
  );

  var cell = sheetObject.cell(CellIndex.indexByString("A1"));
  cell.value = TextCellValue("Date");
  cell.cellStyle = columnTitleStyle;

  cell = sheetObject.cell(CellIndex.indexByString("B1"));
  cell.value = TextCellValue("Start time");
  cell.cellStyle = columnTitleStyle;

  cell = sheetObject.cell(CellIndex.indexByString("C1"));
  cell.value = TextCellValue("End time");
  cell.cellStyle = columnTitleStyle;

  cell = sheetObject.cell(CellIndex.indexByString("D1"));
  cell.value = TextCellValue("Work time");
  cell.cellStyle = columnTitleStyle;

  // set all columns to auto fit
  for (int i = 0; i < 4; i++) {
    sheetObject.setColumnAutoFit(i); // would like to set a custom width, but the excel package is broken, so only AutoFit (sort of) works
  }

  int i = 0;
  for (; i < clockOutTimes.length; i++) {
    // Date
    cell = sheetObject.cell(CellIndex.indexByString("A${i + 2}"));
    cell.cellStyle = dateStyle.copyWith(backgroundColorHexVal: getRowHexColorByIndex(i));
    cell.value = DateCellValue(year: clockInTimes[i].year, month: clockInTimes[i].month, day: clockInTimes[i].day);

    // Clock in time
    cell = sheetObject.cell(CellIndex.indexByString("B${i + 2}"));
    cell.cellStyle = timeStyle.copyWith(backgroundColorHexVal: getRowHexColorByIndex(i));
    cell.value = TimeCellValue(hour: clockInTimes[i].hour, minute: clockInTimes[i].minute);

    // Clock out time
    cell = sheetObject.cell(CellIndex.indexByString("C${i + 2}"));
    cell.cellStyle = timeStyle.copyWith(backgroundColorHexVal: getRowHexColorByIndex(i));
    cell.value = TimeCellValue(hour: clockOutTimes[i].hour, minute: clockOutTimes[i].minute);

    // Time worked
    cell = sheetObject.cell(CellIndex.indexByString("D${i + 2}"));
    cell.cellStyle = timeWorkedStyle.copyWith(backgroundColorHexVal: getRowHexColorByIndex(i));
    Duration timeWorked = clockOutTimes[i].difference(clockInTimes[i]);
    cell.value = TimeCellValue(hour: timeWorked.inHours, minute: timeWorked.inMinutes.remainder(60), second: timeWorked.inSeconds.remainder(60));
  }

  // add bottom border to data table
  cell = sheetObject.cell(CellIndex.indexByString("A${i + 2}"));
  cell.cellStyle = topBorderStyle;
  cell = sheetObject.cell(CellIndex.indexByString("B${i + 2}"));
  cell.cellStyle = topBorderStyle;
  cell = sheetObject.cell(CellIndex.indexByString("C${i + 2}"));
  cell.cellStyle = topBorderStyle;

  cell = sheetObject.cell(CellIndex.indexByString("D${i + 2}"));
  cell.cellStyle = timeWorkedStyle.copyWith(
      leftBorderVal: Border(borderStyle: BorderStyle.Thin),
      rightBorderVal: Border(borderStyle: BorderStyle.Thin),
      topBorderVal: Border(borderStyle: BorderStyle.Thin),
      bottomBorderVal: Border(borderStyle: BorderStyle.Thin),
    );
  Duration totalTimeWorked = Duration(seconds: totalTimeWorkedInSeconds);
  cell.value = TimeCellValue(hour: totalTimeWorked.inHours, minute: totalTimeWorked.inMinutes.remainder(60), second: totalTimeWorkedInSeconds.remainder(60));

  // at least it can save without issues (mostly)
  var fileBytes = excel.save();

  var yearMonthDay = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
  var hourMinuteSecond = "${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}";
  var fileName = "ClockerSummary date $yearMonthDay time $hourMinuteSecond.xlsx";

  var file = File("/storage/emulated/0/Download/$fileName");
  await file.writeAsBytes(fileBytes!, mode: FileMode.writeOnly);
}

String getRowHexColorByIndex(int index) {
  // rows should be colored differently if they are even or odd, this returns the hex of the color based on the index
  if (index.isEven) {
    return "#d1d1d1";
  }
  return "#ededed";
}