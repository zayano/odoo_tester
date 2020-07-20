class MNCLandBooking {
  int id;
  String seqName;
  var buildingId;
  var productId;
  String startDate;
  String endDate;
  var locationId;
  var capacityId;
  var userId;
  var businessUnitId;
  var departmentId;
  var userPhone;
  var numberOfAttendees;
  String meetingSubject;
  String description;

  MNCLandBooking({
    this.id,
    this.seqName,
    this.buildingId,
    this.productId,
    this.startDate,
    this.endDate,
    this.locationId,
    this.capacityId,
    this.userId,
    this.businessUnitId,
    this.departmentId,
    this.userPhone,
    this.numberOfAttendees,
    this.meetingSubject,
    this.description,
  });
}
