class ContactModel {
  String displayName;
  ContactModel({required this.displayName});

  /// preparing the party to be valid to be inserted in localstorage
  toJsonEncodable() {
    Map<String, dynamic> jsonBuilder = {};
    jsonBuilder['displayName'] = displayName;
    return jsonBuilder;
  }

  ContactModel.fromJson(Map<String, dynamic> json)
      : displayName = json['displayName'];
}
