import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:honeybadger/profile/model/portfolio_project.dart';
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
  List<PortfolioProject>? portfolioProjects;

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
    this.rating,
    this.ratingCount,
    this.reviews,
    this.phoneNumber,
    this.address,
    this.title,
    this.skills,
    this.hourlyRate,
    this.userType = UserType.freelancer,
    this.portfolioProjects,
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
    rating = json['rating'];
    ratingCount = json['ratingCount'];
    if (json['reviews'] != null) {
      reviews = [];
      json['reviews'].forEach((v) {
        reviews?.add(Review.fromJson(v));
      });
    }
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    title = json['title'];
    skills = json['skills'].cast<String>();
    hourlyRate = json['hourlyRate'];
    userType = json['userType'] == 'freelancer'
        ? UserType.freelancer
        : UserType.client;
    portfolioProjects = json['portfolioProjects'] != null
        ? (json['portfolioProjects'] as List)
            .map((e) => PortfolioProject.fromJson(e))
            .toList()
        : null;
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
      'rating': rating,
      'ratingCount': ratingCount,
      'reviews': reviews?.map((e) => e.toJson()).toList(),
      'phoneNumber': phoneNumber,
      'address': address,
      'title': title,
      'skills': skills,
      'hourlyRate': hourlyRate,
      'userType': userType == UserType.freelancer ? 'freelancer' : 'client',
      'portfolioProjects': portfolioProjects?.map((e) => e.toJson()).toList(),
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
    skills = snap['skills'].cast<String>();
    hourlyRate = snap['hourlyRate'];
    userType = snap['userType'] == 'freelancer'
        ? UserType.freelancer
        : UserType.client;
    portfolioProjects = snap['portfolioProjects'] != null
        ? (snap['portfolioProjects'] as List)
            .map((e) => PortfolioProject.fromJson(e))
            .toList()
        : null;
    city = snap['city'];
    state = snap['state'];
    zip = snap['zip'];
    country = snap['country'];
    photoUrl = snap['photoUrl'];
    bio = snap['bio'];
    stripeId = snap['stripeId'];
    createdAt = snap['createdAt']?.toDate();
    updatedAt = snap['updatedAt']?.toDate();
  }

  User toDocument() {
    return User(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      rating: rating,
      ratingCount: ratingCount,
      reviews: reviews,
      phoneNumber: phoneNumber,
      address: address,
      title: title,
      skills: skills,
      hourlyRate: hourlyRate,
      userType: userType,
      portfolioProjects: portfolioProjects,
      city: city,
      state: state,
      zip: zip,
      country: country,
      photoUrl: photoUrl,
      bio: bio,
      stripeId: stripeId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
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
    List<PortfolioProject>? portfolioProjects,
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
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      reviews: reviews ?? this.reviews,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      title: title ?? this.title,
      skills: skills ?? this.skills,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      userType: userType ?? this.userType,
      portfolioProjects: portfolioProjects ?? this.portfolioProjects,
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
