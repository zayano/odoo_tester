import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:table_calendar/table_calendar.dart';

import '../service/odoo_response.dart';
import '../utility/strings.dart';
import '../model/mncl_booking.dart';
import '../base.dart';

class EventsBooking extends StatefulWidget {
  @override
  _EventsBookingState createState() => _EventsBookingState();
}

class _EventsBookingState extends Base<EventsBooking>
    with SingleTickerProviderStateMixin {
  // Example holidays
  final Map<DateTime, List> _holidays = {
    DateTime(2019, 1, 1): ['New Year\'s Day'],
    DateTime(2019, 1, 6): ['Epiphany'],
    DateTime(2019, 2, 14): ['Valentine\'s Day'],
    DateTime(2019, 4, 21): ['Easter Sunday'],
    DateTime(2019, 4, 22): ['Easter Monday'],
  };

  List<MNCLandBooking> bookingData = [];
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  _getBookingList() async {
    final _selectedDay = DateTime.now();
    isConnected().then((isInternet) {
      if (isInternet) {
        // showLoading();
        odoo.searchRead(Strings.mncl_booking, [], [
          'id',
          'start_date',
          'duration_start',
          'duration_end',
          'meeting_subject'
        ]).then(
          (OdooResponse res) {
            if (!res.hasError()) {
              setState(() {
                // hideLoading();
                String session = getSession();
                session = session.split(",")[0].split(";")[0];
                for (var i in res.getRecords()) {
                  bookingData.add(
                    new MNCLandBooking(
                      id: i["id"],
                      meetingSubject: i["meeting_subject"] is! bool
                          ? i["meeting_subject"]
                          : "No Subject",
                      startDate: convertDateFromString(i["start_date"]),
                      durationStart: i["duration_start"] is! bool
                          ? convertDateFromString(i["duration_start" + '.000'])
                          : DateTime.now(),
                      durationEnd: i["duration_end"] is! bool
                          ? convertDateFromString(i["duration_end"] + '.000')
                          : DateTime.now(),
                      description: i["description"] is! bool
                          ? i["description"]
                          : "No Description",
                      background: Color(0xFF0F8644),
                      isAllDay: false,
                    ),
                  );

                  _events = {
                    _selectedDay.subtract(Duration(days: 30)): [
                      'Event A0',
                      'Event B0',
                      'Event C0'
                    ],
                    _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
                    _selectedDay.subtract(Duration(days: 20)): [
                      'Event A2',
                      'Event B2',
                      'Event C2',
                      'Event D2'
                    ],
                    _selectedDay.subtract(Duration(days: 16)): [
                      'Event A3',
                      'Event B3'
                    ],
                    _selectedDay.subtract(Duration(days: 10)): [
                      'Event A4',
                      'Event B4',
                      'Event C4'
                    ],
                    _selectedDay.subtract(Duration(days: 4)): [
                      'Event A5',
                      'Event B5',
                      'Event C5'
                    ],
                    _selectedDay.subtract(Duration(days: 2)): [
                      'Event A6',
                      'Event B6'
                    ],
                    _selectedDay: [
                      'Event A7',
                      'Event B7',
                      'Event C7',
                      'Event D7'
                    ],
                    _selectedDay.add(Duration(days: 1)): [
                      'Event A8',
                      'Event B8',
                      'Event C8',
                      'Event D8'
                    ],
                    _selectedDay.add(Duration(days: 3)):
                        Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
                    _selectedDay.add(Duration(days: 7)): [
                      'Event A10',
                      'Event B10',
                      'Event C10'
                    ],
                    _selectedDay.add(Duration(days: 11)): [
                      'Event A11',
                      'Event B11'
                    ],
                    _selectedDay.add(Duration(days: 17)): [
                      'Event A12',
                      'Event B12',
                      'Event C12',
                      'Event D12'
                    ],
                    _selectedDay.add(Duration(days: 22)): [
                      'Event A13',
                      'Event B13'
                    ],
                    _selectedDay.add(Duration(days: 26)): [
                      'Event A14',
                      'Event B14',
                      'Event C14'
                    ],
                  };
                  _selectedEvents = _events[_selectedDay] ?? [];
                  _calendarController = CalendarController();

                  _animationController = AnimationController(
                    vsync: this,
                    duration: const Duration(milliseconds: 400),
                  );
                  _animationController.forward();
                }
              });
            } else {
              print(res.getError());
              showMessage("Warning", res.getErrorMessage());
            }
          },
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  DateTime convertDateFromString(String strDate) {
    DateTime todayDate = DateTime.parse(strDate);
    print(todayDate);
    print(formatDate(todayDate,
        [yyyy, '/', mm, '/', dd, ' ', hh, ':', nn, ':', ss, ' ', am]));
  }

  @override
  void initState() {
    super.initState();

    getOdooInstance().then((value) {
      _getBookingList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }
}
