import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:testing_flutter/base.dart';
import 'package:testing_flutter/model/mncl_booking.dart';
import 'package:testing_flutter/service/odoo_response.dart';

class SyncCalendar extends StatefulWidget {
  SyncCalendar({Key key}) : super(key: key);

  @override
  _SyncCalendarState createState() => _SyncCalendarState();
}

class _SyncCalendarState extends Base<SyncCalendar>
    with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  List<MNCLandBooking> _meetingPlans = [];
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  final _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    getOdooInstance().then((value) {
      getDataBookingMeeting();
    });

    // _events = {
    //   _selectedDay.subtract(Duration(days: 30)): [
    //     'Event A0',
    //     'Event B0',
    //     'Event C0'
    //   ],
    //   _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
    //   _selectedDay.subtract(Duration(days: 20)): [
    //     'Event A2',
    //     'Event B2',
    //     'Event C2',
    //     'Event D2'
    //   ],
    //   _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
    //   _selectedDay.subtract(Duration(days: 10)): [
    //     'Event A4',
    //     'Event B4',
    //     'Event C4'
    //   ],
    //   _selectedDay.subtract(Duration(days: 4)): [
    //     'Event A5',
    //     'Event B5',
    //     'Event C5'
    //   ],
    //   _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
    //   _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
    //   _selectedDay.add(Duration(days: 1)): [
    //     'Event A8',
    //     'Event B8',
    //     'Event C8',
    //     'Event D8'
    //   ],
    //   _selectedDay.add(Duration(days: 3)):
    //       Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
    //   _selectedDay.add(Duration(days: 7)): [
    //     'Event A10',
    //     'Event B10',
    //     'Event C10'
    //   ],
    //   _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
    //   _selectedDay.add(Duration(days: 17)): [
    //     'Event A12',
    //     'Event B12',
    //     'Event C12',
    //     'Event D12'
    //   ],
    //   _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
    //   _selectedDay.add(Duration(days: 26)): [
    //     'Event A14',
    //     'Event B14',
    //     'Event C14'
    //   ],
    // };

    // _selectedEvents = _events[_selectedDay] ?? [];

    _selectedEvents = events(_selectedDay)[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  Map<DateTime, List> events(DateTime selectedDay) {
    _events = <DateTime, List>{};
    setState(() {
      if (_meetingPlans.isNotEmpty) {
        for (var i in _meetingPlans) {
          selectedDay = DateTime.parse(i.startDate);
          _events.addAll({
            selectedDay: [i.productId]
          });
        }
        print(_events);
      }
    });
    return _events;
  }

  void getDataBookingMeeting() async {
    isConnected().then((isInternet) {
      if (isInternet) {
        showLoading();
        odoo.searchRead('mncl.booking', [], [
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
                _meetingPlans.add(
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        // Switch out 2 lines below to play with TableCalendar's settings
        //-----------------------
        _buildTableCalendar(),
        const SizedBox(height: 8.0),
        Expanded(child: _buildEventList()),
      ],
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: events(_selectedDay),
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

  Widget _buildButtons() {
    final dateTime = _events.keys.elementAt(_events.length - 2);

    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text('Month'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.month);
                });
              },
            ),
            RaisedButton(
              child: Text('2 weeks'),
              onPressed: () {
                setState(() {
                  _calendarController
                      .setCalendarFormat(CalendarFormat.twoWeeks);
                });
              },
            ),
            RaisedButton(
              child: Text('Week'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.week);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        RaisedButton(
          child: Text(
              'Set day ${dateTime.day}-${dateTime.month}-${dateTime.year}'),
          onPressed: () {
            _calendarController.setSelectedDay(
              DateTime(dateTime.year, dateTime.month, dateTime.day),
              runCallback: true,
            );
          },
        ),
      ],
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(event.toString()),
                  onTap: () => print('$event tapped!'),
                ),
              ))
          .toList(),
    );
  }
}
