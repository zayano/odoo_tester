import 'package:flutter/cupertino.dart';

class MNCLandBooking {
  int id;
  DateTime startDate;
  DateTime durationStart;
  DateTime durationEnd;
  Color background;
  String meetingSubject;
  String description;
  bool isAllDay;

  MNCLandBooking({
    this.id,
    this.startDate,
    this.durationStart,
    this.durationEnd,
    this.background,
    this.meetingSubject,
    this.description,
    this.isAllDay
  });
}
