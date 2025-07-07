class EditAddressRequest {
  int id;
  String type;
  String city;
  String state;
  String street;
  String postalCode;
  bool useDefault;
  String mobile;
  String lat;
  String lang;

  EditAddressRequest({
    required this.id,
    required this.type,
    required this.city,
    required this.state,
    required this.street,
    required this.postalCode,
    required this.useDefault,
    required this.mobile,
    required this.lat,
    required this.lang,
  });
}
