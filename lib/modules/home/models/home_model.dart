class AttendanceModel {
  dynamic date;
  dynamic time;
  dynamic meter;

  AttendanceModel({this.date, this.time, this.meter});

  AttendanceModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    time = json['time'];
    meter = json['meter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['time'] = this.time;
    data['meter'] = this.meter;
    return data;
  }
}
