import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';

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
  List<DateTime> dateDataList;
  List<FlutterWeekViewEvent> weekEvent;

  var plan = [
    {
      'label': 'test 1',
      'description': 'Just Testing 1',
      'start_date': '2020-06-03 08:00:00',
      'end_date': '2020-06-03 10:00:00'
    },
    {
      'label': 'test tambahan',
      'description': 'Just Testing 1 tambahan',
      'start_date': '2020-06-03 13:00:00',
      'end_date': '2020-06-03 15:00:00'
    },
    {
      'label': 'test 2',
      'description': 'Just Testing 2',
      'start_date': '2020-06-04 10:00:00',
      'end_date': '2020-06-04 12:00:00'
    },
    {
      'label': 'test 3',
      'description': 'Just Testing 3',
      'start_date': '2020-06-09 09:00:00',
      'end_date': '2020-06-09 11:00:00'
    },
    {
      'label': 'test copy',
      'description': 'Just Testing 3',
      'start_date': '2020-06-09 07:00:00',
      'end_date': '2020-06-09 10:00:00'
    },
    {
      'label': 'test aja',
      'description': 'Just Testing Aja',
      'start_date': '2020-06-09 15:00:00',
      'end_date': '2020-06-09 17:00:00'
    },
    {
      'label': 'test 4',
      'description': 'Just Testing 4',
      'start_date': '2020-06-15 11:00:00',
      'end_date': '2020-06-15 13:00:00'
    },
    {
      'label': 'test 5',
      'description': 'Just Testing 5',
      'start_date': '2020-06-16 13:00:00',
      'end_date': '2020-06-16 15:00:00'
    },
    {
      'label': 'test 6',
      'description': 'Just Testing 6',
      'start_date': '2020-06-13 15:00:00',
      'end_date': '2020-06-13 17:00:00'
    },
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
      final dateStart = DateTime.parse(i['start_date']);
      final dateEnd = DateTime.parse(i['end_date']);
      final DateTime startTime = dateStart.add(Duration());
      final DateTime endTime = dateEnd.add(Duration());
      meetings.add(
          Meeting(labelDate, startTime, endTime, Color(0xFF0F8644), false));
    }
    return meetings;
  }

  List<DateTime> dateData() {
    dateDataList = <DateTime>[];
    for (var i in plan) {
      final dateStart = DateTime.parse(i['start_date']);
      dateDataList.add(dateStart);
    }
    return dateDataList;
  }

  List<FlutterWeekViewEvent> weekEvents() {
    weekEvent = <FlutterWeekViewEvent>[];
    for (var i in plan) {
      final String labelDate = i['label'];
      final String description = i['description'];
      final dateStart = DateTime.parse(i['start_date']);
      final dateEnd = DateTime.parse(i['end_date']);
      weekEvent.add(FlutterWeekViewEvent(
          title: labelDate,
          description: description,
          start: dateStart.add(Duration()),
          end: dateEnd.add(Duration())));
    }
    return weekEvent;
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    return WeekView(
      dates: [
        date.subtract(const Duration(days: 3)),
        date.subtract(const Duration(days: 2)),
        date.subtract(const Duration(days: 1)),
        date,
        date.add(const Duration(days: 1)),
        date.add(const Duration(days: 2)),
        date.add(const Duration(days: 3)),
      ],
      events: weekEvents(),
      initialTime: const HourMinute(hour: 7),
      style: WeekViewStyle(dayBarBackgroundColor: Colors.amber),
    );

    // return SfCalendar(
    //   view: CalendarView.month,
    //   dataSource: MeetingDataSource(_getDataSource()),
    //   monthViewSettings: MonthViewSettings(
    //       appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
    // );
  }
}
