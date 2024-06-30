
class Dart {
  List<Users>? users;
  Settings? settings;

  Dart({this.users, this.settings});

  Dart.fromJson(Map<String, dynamic> json) {
    if(json["users"] is List) {
      users = json["users"] == null ? null : (json["users"] as List).map((e) => Users.fromJson(e)).toList();
    }
    if(json["settings"] is Map) {
      settings = json["settings"] == null ? null : Settings.fromJson(json["settings"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(users != null) {
      _data["users"] = users?.map((e) => e.toJson()).toList();
    }
    if(settings != null) {
      _data["settings"] = settings?.toJson();
    }
    return _data;
  }
}

class Settings {
  String? theme;
  Notifications? notifications;

  Settings({this.theme, this.notifications});

  Settings.fromJson(Map<String, dynamic> json) {
    if(json["theme"] is String) {
      theme = json["theme"];
    }
    if(json["notifications"] is Map) {
      notifications = json["notifications"] == null ? null : Notifications.fromJson(json["notifications"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["theme"] = theme;
    if(notifications != null) {
      _data["notifications"] = notifications?.toJson();
    }
    return _data;
  }
}

class Notifications {
  bool? email;
  bool? sms;

  Notifications({this.email, this.sms});

  Notifications.fromJson(Map<String, dynamic> json) {
    if(json["email"] is bool) {
      email = json["email"];
    }
    if(json["sms"] is bool) {
      sms = json["sms"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["email"] = email;
    _data["sms"] = sms;
    return _data;
  }
}

class Users {
  int? id;
  String? name;
  String? email;
  bool? isActive;
  List<String>? roles;
  Profile? profile;

  Users({this.id, this.name, this.email, this.isActive, this.roles, this.profile});

  Users.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["email"] is String) {
      email = json["email"];
    }
    if(json["isActive"] is bool) {
      isActive = json["isActive"];
    }
    if(json["roles"] is List) {
      roles = json["roles"] == null ? null : List<String>.from(json["roles"]);
    }
    if(json["profile"] is Map) {
      profile = json["profile"] == null ? null : Profile.fromJson(json["profile"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["email"] = email;
    _data["isActive"] = isActive;
    if(roles != null) {
      _data["roles"] = roles;
    }
    if(profile != null) {
      _data["profile"] = profile?.toJson();
    }
    return _data;
  }
}

class Profile {
  int? age;
  String? gender;
  Address? address;

  Profile({this.age, this.gender, this.address});

  Profile.fromJson(Map<String, dynamic> json) {
    if(json["age"] is int) {
      age = json["age"];
    }
    if(json["gender"] is String) {
      gender = json["gender"];
    }
    if(json["address"] is Map) {
      address = json["address"] == null ? null : Address.fromJson(json["address"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["age"] = age;
    _data["gender"] = gender;
    if(address != null) {
      _data["address"] = address?.toJson();
    }
    return _data;
  }
}

class Address {
  String? street;
  String? city;
  String? zipcode;

  Address({this.street, this.city, this.zipcode});

  Address.fromJson(Map<String, dynamic> json) {
    if(json["street"] is String) {
      street = json["street"];
    }
    if(json["city"] is String) {
      city = json["city"];
    }
    if(json["zipcode"] is String) {
      zipcode = json["zipcode"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["street"] = street;
    _data["city"] = city;
    _data["zipcode"] = zipcode;
    return _data;
  }
}