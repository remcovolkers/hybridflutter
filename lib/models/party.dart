class Party {
  DateTime occurDate;
  String partyName;
  String partyDescription;

  Party({
    required this.occurDate,
    required this.partyName,
    required this.partyDescription,
  });

  /// preparing the party to be eligible to be inserted in localstorage
  toJsonEncodable() {
    Map<String, dynamic> jsonBuilder = {};
    jsonBuilder['partyName'] = partyName;
    jsonBuilder['partyDescription'] = partyDescription;
    jsonBuilder['occurDate'] = occurDate.toIso8601String();

    return jsonBuilder;
  }

  Party.fromJson(Map<String, dynamic> json)
      : partyName = json['partyName'],
        partyDescription = json['partyDescription'],
        occurDate = json['occurDate'];

  @override
  String toString() {
    return ' date: ' +
        occurDate.toString() +
        '\n time: ' +
        '\n partyname: ' +
        partyName +
        '\n partydescription: ' +
        partyDescription;
  }
}
