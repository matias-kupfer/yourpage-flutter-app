import 'dart:ffi';

class User {
  PersonalInfo personalInfo;
  AccountInfo accountInfo;
  List followers;
  List following;
  int posts;
}

class PersonalInfo {
  PersonalInfo();

  String userId;
  String email;
  String name;
  String lastName;
  String gender;
  DateTime birthday;
}

class AccountInfo {
  AccountInfo();

  String userName;
  DateTime registrationDate;
  String imageUrl;
  String country;
  String bio;
  SocialLinks socialLinks;
  List<MapPointers> mapPointers;
}

class SocialLinks {
  SocialLinks();

  String youtube;
  String facebook;
  String instagram;
  String github;
  String linkedin;
  String twitter;
}

class MapPointers {
  MapPointers();

  Double lat;
  Double lng;
  String title;
  String description;
}
