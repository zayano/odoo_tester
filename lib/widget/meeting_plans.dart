import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:testing_flutter/model/mncl_booking.dart';

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
  List<MNCLandBooking> _meetingMNC = [];
  List<Meeting> meetings = [];
  String labelDate;
  DateTime date;
  List<DateTime> dateDataList;
  List<FlutterWeekViewEvent> weekEvent;
  bool valueConfirmed = true;
  bool valueReconfirmed = true;

  @override
  void initState() {
    getOdooInstance().then((value) {
      if (getURL() == 'http://10.1.218.108:8069') {
        getDataBooking();
      } else {
        getDataBookingMeetingConfirmed();
        getDataBookingMeetingReconfirmed();
      }
    });
    super.initState();
  }

  void getDataBookingMeetingConfirmed() async {
    isConnected().then((isInternet) {
      if (isInternet) {
        showLoading();
        odoo.searchRead('mncl.booking', [
          ['state', '=', 'confirmed']
        ], [
          'id',
          'seq_name',
          'building_id',
          'product_id',
          'start_date',
          'end_date',
          'location_id',
          'capacity_id',
          'user_id',
          'business_unit_id',
          'department_id',
          'user_phone',
          'number_of_attendees',
          'description',
          'meeting_subject',
          'state'
        ]).then((OdooResponse response) {
          if (!response.hasError()) {
            setState(() {
              hideLoading();
              String session = getSession();
              session = session.split(",")[0].split(";")[0];
              for (var i in response.getRecords()) {
                _meetingMNC.add(
                  MNCLandBooking(
                      id: i["id"] is! bool ? i["id"] : 0,
                      seqName:
                          i["seq_name"] is! bool ? i["seq_name"] : 'No Name',
                      startDate: i['start_date'] is! bool
                          ? i['start_date']
                          : 'no date',
                      endDate:
                          i['end_date'] is! bool ? i['end_date'] : 'no date',
                      meetingSubject: i['meeting_subject'] is! bool
                          ? i['meeting_subject']
                          : 'No Subject',
                      description: i['description'] is! bool
                          ? i['description']
                          : 'No Description',
                      userId: i['user_id'][1] is! bool
                          ? i['user_id'][1]
                          : 'No User Name',
                      buildingId: i['building_id'] is! bool
                          ? i['building_id'][1]
                          : 'No Building',
                      productId: i['product_id'] is! bool
                          ? i['product_id'][1]
                          : 'No Product'),
                );
              }
            });
          } else {
            showMessage("Warning", response.getErrorMessage());
          }
        });
      }
    });
  }

  void getDataBookingMeetingReconfirmed() async {
    isConnected().then((isInternet) {
      if (isInternet) {
        showLoading();
        odoo.searchRead('mncl.booking', [
          ['state', '=', 'reconfirmed']
        ], [
          'id',
          'seq_name',
          'building_id',
          'product_id',
          'start_date',
          'end_date',
          'location_id',
          'capacity_id',
          'user_id',
          'business_unit_id',
          'department_id',
          'user_phone',
          'number_of_attendees',
          'description',
          'meeting_subject',
          'state'
        ]).then((OdooResponse response) {
          if (!response.hasError()) {
            setState(() {
              hideLoading();
              String session = getSession();
              session = session.split(",")[0].split(";")[0];
              for (var i in response.getRecords()) {
                _meetingMNC.add(
                  MNCLandBooking(
                      id: i["id"] is! bool ? i["id"] : 0,
                      seqName:
                          i["seq_name"] is! bool ? i["seq_name"] : 'No Name',
                      startDate: i['start_date'] is! bool
                          ? i['start_date']
                          : 'no date',
                      endDate:
                          i['end_date'] is! bool ? i['end_date'] : 'no date',
                      meetingSubject: i['meeting_subject'] is! bool
                          ? i['meeting_subject']
                          : 'No Subject',
                      description: i['description'] is! bool
                          ? i['description']
                          : 'No Description',
                      userId: i['user_id'][1] is! bool
                          ? i['user_id'][1]
                          : 'No User Name',
                      buildingId: i['building_id'] is! bool
                          ? i['building_id'][1]
                          : 'No Building',
                      productId: i['product_id'] is! bool
                          ? i['product_id'][1]
                          : 'No Product'),
                );
              }
            });
          } else {
            showMessage("Warning", response.getErrorMessage());
          }
        });
      }
    });
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
    if (_bookingMeeting.isNotEmpty) {
      for (var i in _bookingMeeting) {
        final String labelDate = i.productId;
        final String description = i.description;
        final dateStart = DateTime.parse(i.durationStart);
        final dateEnd = DateTime.parse(i.durationEnd);
        weekEvent.add(FlutterWeekViewEvent(
            title: labelDate != null ? labelDate : "No Product",
            description: description != null ? description : "No Description",
            start: dateStart.add(Duration()) is! bool
                ? dateStart.add(Duration(hours: 7))
                : DateTime.now(),
            end: dateEnd.add(Duration()) is! bool
                ? dateEnd.add(Duration(hours: 7))
                : DateTime.now()));

        print("booking meeting jalan");
      }
    } else {
      for (var i in _meetingMNC) {
        final String labelDate = i.productId;
        final String description = i.userId;
        final dateStart = DateTime.parse(i.startDate);
        final dateEnd = DateTime.parse(i.endDate);
        weekEvent.add(FlutterWeekViewEvent(
            title: labelDate != null ? labelDate : "No Product",
            description: description != null ? description : "No User",
            start: dateStart.add(Duration()) is! bool
                ? dateStart.add(Duration(hours: 7))
                : DateTime.now(),
            end: dateEnd.add(Duration()) is! bool
                ? dateEnd.add(Duration(hours: 7))
                : DateTime.now()));

        print("meeting mnc jalan");
      }
    }

    return weekEvent;
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    return Column(
      children: <Widget>[
        Visibility(
          visible: _bookingMeeting.isNotEmpty ? false : true,
          child: Expanded(
            flex: 0,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: CheckboxListTile(
                    title: Text('Confirmed'),
                    value: valueConfirmed,
                    activeColor: valueConfirmed ? Colors.blue : Colors.grey,
                    onChanged: (newValue) {
                      setState(() {
                        valueConfirmed = newValue;
                        if (valueConfirmed) {
                          _meetingMNC.clear();
                          getDataBookingMeetingConfirmed();
                        } else {
                          _meetingMNC.clear();
                        }
                      });
                    },
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    title: Text('Reconfirmed'),
                    value: valueReconfirmed,
                    onChanged: null,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: WeekView(
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
          ),
        ),
      ],
    );
  }
}
