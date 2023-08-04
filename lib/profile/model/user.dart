import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:honeybadger/profile/review.dart';

enum UserType { freelancer, client }

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  double? rating;
  int? ratingCount;
  List<Review>? reviews;
  String? phoneNumber;
  String? address;
  String? title;
  List<String>? skills;
  double? hourlyRate;
  UserType userType = UserType.freelancer;
  String? city;
  String? state;
  String? zip;
  String? country;
  String? photoUrl;
  String? bio;
  String? stripeAccountId;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<dynamic>? projectIds;
  List<dynamic>? proposalIds;
  List<String>? categoryIds;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.rating,
    this.ratingCount,
    this.reviews,
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
    this.stripeAccountId,
    this.createdAt,
    this.updatedAt,
    this.projectIds,
    this.proposalIds,
    this.categoryIds,
  });

  User.fromDocument(DocumentSnapshot snap) {
    id = snap.id;
    firstName = snap['firstName'];
    lastName = snap['lastName'];
    email = snap['email'];
    password = snap['password'];
    rating = snap['rating'];
    ratingCount = snap['ratingCount'];
    if (snap['reviews'] != null) {
      reviews = [];
      snap['reviews'].forEach((v) {
        reviews?.add(Review.fromJson(v));
      });
    }
    phoneNumber = snap['phoneNumber'];
    address = snap['address'];
    title = snap['title'];
    skills = snap['skills'] != null ? List<String>.from(snap['skills']) : null;
    hourlyRate = snap['hourlyRate'];
    userType = snap['userType'] == 'freelancer'
        ? UserType.freelancer
        : UserType.client;
    city = snap['city'];
    state = snap['state'];
    zip = snap['zip'];
    country = snap['country'];
    photoUrl = snap['photoUrl'];
    bio = snap['bio'];
    stripeAccountId = snap['stripeAccountId'];
    createdAt = snap['createdAt']?.toDate();
    updatedAt = snap['updatedAt']?.toDate();
    projectIds = snap['projectIds'];
    proposalIds = snap['proposalIds'];
    categoryIds = snap['categoryIds'];
  }

  // To Document
  Map<String, dynamic> toDocument() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'rating': rating,
      'ratingCount': ratingCount,
      'reviews': reviews?.map((v) => v.toJson()).toList(),
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
      'stripeAccountId': stripeAccountId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'projectIds': projectIds,
      'proposalIds': proposalIds,
      'categoryIds': categoryIds,
    };
  }

  /// CopyWith
  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    double? rating,
    int? ratingCount,
    List<Review>? reviews,
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
    String? stripeAccountId,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? projectIds,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      reviews: reviews ?? this.reviews,
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
      stripeAccountId: stripeAccountId ?? this.stripeAccountId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      projectIds: projectIds ?? this.projectIds,
    );
  }
}
