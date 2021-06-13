class TrainingRepeatingDays {
  bool repeatsOnMonday = false;
  bool repeatsOnTuesday = false;
  bool repeatsOnWednesday = false;
  bool repeatsOnThursday = false;
  bool repeatsOnFriday = false;
  bool repeatsOnSaturday = false;
  bool repeatsOnSunday = false;

  TrainingRepeatingDays({
    this.repeatsOnMonday = false,
    this.repeatsOnTuesday = false,
    this.repeatsOnWednesday = false,
    this.repeatsOnThursday = false,
    this.repeatsOnFriday = false,
    this.repeatsOnSaturday = false,
    this.repeatsOnSunday = false,
  });

  @override
  String toString() {
    List<String> days = [];
    if(repeatsOnMonday) days.add('Mon');
    if(repeatsOnTuesday) days.add('Tue');
    if(repeatsOnWednesday) days.add('Wed');
    if(repeatsOnThursday) days.add('Thu');
    if(repeatsOnFriday) days.add('Fri');
    if(repeatsOnSaturday) days.add('Sat');
    if(repeatsOnSunday) days.add('Sun');
    String result = days.join(', ');
    return result.isEmpty ? 'Never' : result;
  }

  factory TrainingRepeatingDays.fromJson(List<dynamic> json) {
    return TrainingRepeatingDays(
      repeatsOnMonday: json.contains(0),
      repeatsOnTuesday: json.contains(1),
      repeatsOnWednesday: json.contains(2),
      repeatsOnThursday: json.contains(3),
      repeatsOnFriday: json.contains(4),
      repeatsOnSaturday: json.contains(5),
      repeatsOnSunday: json.contains(6),
    );
  }

  List<int> toJson() {
    List<int> result = [];

    if(repeatsOnMonday) result.add(0);
    if(repeatsOnTuesday) result.add(1);
    if(repeatsOnWednesday) result.add(2);
    if(repeatsOnThursday) result.add(3);
    if(repeatsOnFriday) result.add(4);
    if(repeatsOnSaturday) result.add(5);
    if(repeatsOnSunday) result.add(6);

    return result;
  }
}