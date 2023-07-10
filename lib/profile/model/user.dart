enum UserType { freelancer, client }

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? phoneNumber;
  String? address;
  String? title;
  List<String>? skills;
  double? hourlyRate;
  UserType? userType;
  String? city;
  String? state;
  String? zip;
  String? country;
  String? photoUrl;
  String? bio;
  String? stripeId;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.phoneNumber,
    this.address,
    this.title,
    this.skills,
    this.hourlyRate,
    this.userType = UserType.freelancer,
    this.city,
    this.state,
    this.zip,
    this.country,
    this.photoUrl,
    this.bio,
    this.stripeId,
    this.createdAt,
    this.updatedAt,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    password = json['password'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    title = json['title'];
    skills = json['skills'].cast<String>();
    hourlyRate = json['hourlyRate'];
    userType = json['userType'] == 'freelancer'
        ? UserType.freelancer
        : UserType.client;
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
    country = json['country'];
    photoUrl = json['photoUrl'];
    bio = json['bio'];
    stripeId = json['stripeId'];
    createdAt = DateTime.parse(json['createdAt']);
    updatedAt = DateTime.parse(json['updatedAt']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'address': address,
      'title': title,
      'skills': skills,
      'hourlyRate': hourlyRate,
      'userType': userType == UserType.freelancer ? 'freelancer' : 'client',
      'city': city,
      'state': state,
      'zip': zip,
      'country': country,
      'photoUrl': photoUrl,
      'bio': bio,
      'stripeId': stripeId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// CopyWith
  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? phoneNumber,
    String? address,
    String? title,
    List<String>? skills,
    double? hourlyRate,
    UserType? userType,
    String? city,
    String? state,
    String? zip,
    String? country,
    String? photoUrl,
    String? bio,
    String? stripeId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      title: title ?? this.title,
      skills: skills ?? this.skills,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      userType: userType ?? this.userType,
      city: city ?? this.city,
      state: state ?? this.state,
      zip: zip ?? this.zip,
      country: country ?? this.country,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      stripeId: stripeId ?? this.stripeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
