import 'package:flutter/material.dart';

import '../widget/empty_list.dart';
import '../service/odoo_response.dart';
import '../utility/strings.dart';
import '../model/mncl_booking.dart';
import '../base.dart';

class BookingList extends StatefulWidget {
  @override
  _BookingListState createState() => _BookingListState();
}

class _BookingListState extends Base<BookingList> {
  List<MNCLandBooking> bookingList = [];
  DateTime dataDate;

  void _getBookingList() async {
    isConnected().then((isInternet) {
      if (isInternet) {
        showLoading();
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
                hideLoading();
                String session = getSession();
                session = session.split(",")[0].split(";")[0];
                for (var i in res.getRecords()) {
                  bookingList.add(
                    new MNCLandBooking(
                      id: i["id"],
                      meetingSubject: i["meeting_subject"] is! bool
                          ? i["meeting_subject"]
                          : "No Subject",
                      startDate: i["start_date"],
                      durationStart: i["duration_start"] is! bool
                          ? i["duration_start"]
                          : "N/A",
                      durationEnd: i["duration_end"] is! bool
                          ? i["duration_end"]
                          : "N/A",
                      description: i["description"] is! bool
                          ? i["description"]
                          : "No Description",
                    ),
                  );
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
  void initState() {
    super.initState();

    getOdooInstance().then((value) {
      _getBookingList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return bookingList.length > 0
        ? ListView.builder(
            itemCount: bookingList.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, i) => InkWell(
              onTap: () {},
              child: Column(
                children: <Widget>[
                  Divider(
                    height: 10.0,
                  ),
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          bookingList[i].meetingSubject,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    subtitle: Container(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        bookingList[i].startDate,
                        style: TextStyle(color: Colors.grey, fontSize: 15.0),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        : EmptyList(Icons.book, Strings.no_booking_rooms);
  }
}
