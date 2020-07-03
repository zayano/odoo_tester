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
                  startDate: i["start_date"] is! bool
                      ? i["start_date"]
                      : "No Start Date",
                  durationStart: i["duration_start"] is! bool
                      ? i["duration_start"]
                      : "No Duration Start",
                  durationEnd: i["duration_end"] is! bool
                      ? i["duration_end"]
                      : "No Duration End",
                  productId: i["product_id"][1] is! bool
                      ? i["product_id"][1]
                      : "No Product",
                  description: i["description"] is! bool
                      ? i["description"]
                      : "No Description",
                  partnerId: i["partner_id"][1] is! bool
                      ? i["partner_id"][1]
                      : "No Partner",
                  meetingSubject: i["meeting_subject"] is! bool
                      ? i["meeting_subject"]
                      : "No Meeting Subject",
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

  List<FlutterWeekViewEvent> weekEvents() {
    weekEvent = <FlutterWeekViewEvent>[];
    for (var i = 0; i < _bookingMeeting.length; i++) {
      final String labelDate = _bookingMeeting[i].meetingSubject;
      final String description = _bookingMeeting[i].description;
      final dateStart = DateTime.parse(_bookingMeeting[i].durationStart);
      final dateEnd = DateTime.parse(_bookingMeeting[i].durationEnd);
      weekEvent.add(FlutterWeekViewEvent(
          title: labelDate != null ? labelDate : "No title",
          description: description != null ? description : "No Description",
          start: dateStart.add(Duration()) is! bool
              ? dateStart.add(Duration())
              : DateTime.now(),
          end: dateEnd.add(Duration()) is! bool
              ? dateEnd.add(Duration())
              : DateTime.now()));
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
  }
}
