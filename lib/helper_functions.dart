bool isToday(date){
  DateTime now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  DateTime dateConvert = DateTime.parse(date);
  final checkDate =
      DateTime(dateConvert.year, dateConvert.month, dateConvert.day);

if (checkDate == today) {
    return true;
  }

  return false;
} 

bool isTomorrow(date){
  DateTime now = DateTime.now();
  final tomorrow = DateTime(now.year, now.month, now.day + 1);

  DateTime dateConvert = DateTime.parse(date);
  final checkDate =
      DateTime(dateConvert.year, dateConvert.month, dateConvert.day);

if (checkDate == tomorrow) {
    return true;
  }

return false;

}


//Function to check if date is today or tomorrow
checkDate(date) {
  
  if (isToday(date)) {
    return "Today";
  }
  
  if (isTomorrow(date)) {
    return "Tomorrow";
  }

  return date;
}