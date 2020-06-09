import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../model/meeting_data_source.dart';
import '../base.dart';
import '../model/mncl_booking.dart';
import '../model/meeting.dart';

class MeetingPlans extends StatefulWidget {
  final dataListBook;

  MeetingPlans({this.dataListBook});

  @override
  _MeetingPlansState createState() => _MeetingPlansState();
}

class _MeetingPlansState extends Base<MeetingPlans> {
  List<MNCLandBooking> _bookingList = [];
  List<Meeting> meetings = [];
  String labelDate;
  DateTime date;

  var plan = [
    {'label': 'test 1', 'date': '2020-06-04 13:27:00'},
    {'label': 'test 2', 'date': '2020-06-12 13:27:00'},
    {'label': 'test 3', 'date': '2020-06-19 13:27:00'},
    {'label': 'test 4', 'date': '2020-06-21 13:27:00'},
    {'label': 'test 5', 'date': '2020-06-25 13:27:00'},
    {'label': 'test 6', 'date': '2020-06-28 13:27:00'},
  ];

  @override
  void initState() {
    _bookingList = widget.dataListBook;

    getOdooInstance().then((value) {});
    super.initState();
  }

  List<Meeting> _getDataSource() {
    meetings = <Meeting>[];
    for (var i in plan) {
      final String labelDate = i['label'];
      final date = DateTime.parse(i['date']);
      final DateTime startTime = DateTime(
          date.year, date.month, date.day, date.hour, date.minute, date.second);
      final DateTime endTime = startTime.add(const Duration(hours: 2));
      meetings.add(Meeting(
          labelDate, startTime, endTime, const Color(0xFF0F8644), false));
    }
    return meetings;
  }

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.month,
      dataSource: MeetingDataSource(_getDataSource()),
      monthViewSettings: MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
    );
  }
}
