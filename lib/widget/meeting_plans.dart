import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';

import '../service/odoo_response.dart';
import '../base.dart';
import '../model/booking.dart';
import '../model/meeting.dart';

class MeetingPlans extends StatefulWidget {

  @override
  _MeetingPlansState createState() => _MeetingPlansState();
}

class _MeetingPlansState extends Base<MeetingPlans> {
  List<Booking> _bookingMeeting = [];
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
    getOdooInstance().then((value) {
      getDataBooking();
    });
    super.initState();
  }

  void getDataBooking() async {
    isConnected().then((isInternet) {
      if (isInternet) {
        showLoading();
        odoo.searchRead('mncl.booking', [], [
          'id',
          'start_date',
          'duration_start',
          'duration_end',
          'product_id',
          'description',
          'meeting_subject',
          'partner_id',
        ]).then((OdooResponse response) {
          if (!response.hasError()) {
            setState(() {
              hideLoading();
              String session = getSession();
              session = session.split(",")[0].split(";")[0];
              for (var i in response.getRecords()) {
                _bookingMeeting.add(Booking(
                  startDate: i["start_date"] is! bool ? i["start_date"] : "No Start Date",
                  durationStart: i["duration_start"] is! bool ? i["duration_start"] : "No Duration Start",
                  durationEnd: i["duration_end"] is! bool ? i["duration_end"] : "No Duration End",
                  productId: i["product_id"][1] is! bool ? i["product_id"][1] : "No Product",
                  description: i["description"] is! bool ? i["description"] : "No Description",
                  partnerId: i["partner_id"][1] is! bool ? i["partner_id"][1] : "No Partner",
                  meetingSubject: i["meeting_subject"] is! bool ? i["meeting_subject"] : "No Meeting Subject",
                ));
              }
            });
          } else {
            showMessage("Warning", response.getErrorMessage());
          }
        });
      }
    });
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
        Meeting(
          labelDate,
          startTime,
          endTime,
          Color(0xFF0F8644),
          false,
        ),
      );
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
    for (var i=0;i<_bookingMeeting.length;i++) {
      final String labelDate = _bookingMeeting[i].meetingSubject;
      final String description = _bookingMeeting[i].description;
      final dateStart = DateTime.parse(_bookingMeeting[i].durationStart);
      print(dateStart);
      final dateEnd = DateTime.parse(_bookingMeeting[i].durationEnd);
      weekEvent.add(FlutterWeekViewEvent(
          title: labelDate != null ? labelDate : "No title",
          description: description != null ? description : "No Description",
          start: dateStart.add(Duration()) is! bool ? dateStart.add(Duration()) : DateTime.now(),
          end: dateEnd.add(Duration()) is! bool ? dateEnd.add(Duration()) : DateTime.now()));
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
