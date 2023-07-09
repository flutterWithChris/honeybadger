enum UserType { freelancer, client }

class User {
  String? id;
  String? name;
  String? email;
  String? password;
  UserType? userType;
  String? phone;
  String? address;
  String? city;
  String? state;
  String? zip;
  String? country;
  String? photoUrl;
  String? createdAt;
  String? updatedAt;

  User({
    this.id,
    this.name,
    this.email,
    this.password,
    this.userType,
    this.phone,
    this.address,
    this.city,
    this.state,
    this.zip,
    this.country,
    this.photoUrl,
    this.createdAt,
    this.updatedAt,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    userType = json['userType'] == 'freelancer'
        ? UserType.freelancer
        : UserType.client;
    phone = json['phone'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
    country = json['country'];
    photoUrl = json['photoUrl'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'userType': userType.toString(),
      'phone': phone,
      'address': address,
      'city': city,
      'state': state,
      'zip': zip,
      'country': country,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
