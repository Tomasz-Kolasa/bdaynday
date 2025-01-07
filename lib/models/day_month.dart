/// Data Model class
class DayMonth {
  final int day;
  final int month;
  
  DayMonth(this.day, this.month)
  {
    validateDate();
  }

  Map<String, dynamic> toJson() => {
        'day': day,
        'month': month,
      };

  factory DayMonth.fromJson(Map<String, dynamic> json) => DayMonth(
        json['day'],
        json['month']
      );

  void validateDate()
  {
    var leapYear = 2024; // so that 29 Feb is possible to use
    var mm = (month<10) ? '0$month' : month;
    var dd = (day<10) ? '0$day' : day;

    try{
      DateTime.parse('$leapYear-$mm-$dd');
    } catch(e)
    {
      throw ArgumentError('Couldn\'t create DateMonth: $leapYear-$mm-$dd');
    }
    
  }
}