bool isNotDateEmpty({
  required String month,
  required String day,
  required String year,
}) {
  return ((month.trim().isNotEmpty &&
          (month.trim().length == 2 || month.trim().length == 1)) &&
      (day.trim().isNotEmpty &&
          (day.trim().length == 2 || day.trim().length == 1)) &&
      (year.trim().isNotEmpty && year.trim().length == 4));
}

int calculateAge(DateTime dob) {
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - dob.year;
  if (currentDate.month < dob.month ||
      (currentDate.month == dob.month && currentDate.day < dob.day)) {
    age--;
  }
  return age;
}
