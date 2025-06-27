class FamilyMemberModel {
  String? id;
  String? headId;
  String? firstName;
  String? middleName;
  String? lastName;
  DateTime? birthDate;
  int? age;
  String? gender;
  String? maritalStatus;
  String? qualification;
  String? occupation;
  String? dutiesNature;
  String? bloodGroup;
  String? photoUrl;
  String? relationWithHead;
  String? phoneNumber;
  String? altPhoneNumber;
  String? landlineNumber;
  String? email;
  String? socialMedia;
  String? country;
  String? state;
  String? district;
  String? city;
  String? streetName;
  String? landmark;
  String? buildingName;
  String? doorNumber;
  String? flatNumber;
  String? pincode;
  String? nativeCity;
  String? nativeState;

  FamilyMemberModel({
    this.id,
    this.headId,
    this.firstName,
    this.middleName,
    this.lastName,
    this.birthDate,
    this.age,
    this.gender,
    this.maritalStatus,
    this.qualification,
    this.occupation,
    this.dutiesNature,
    this.bloodGroup,
    this.photoUrl,
    this.relationWithHead,
    this.phoneNumber,
    this.altPhoneNumber,
    this.landlineNumber,
    this.email,
    this.socialMedia,
    this.country,
    this.state,
    this.district,
    this.city,
    this.streetName,
    this.landmark,
    this.buildingName,
    this.doorNumber,
    this.flatNumber,
    this.pincode,
    this.nativeCity,
    this.nativeState,
  });

  Map<String, dynamic> toMap() {
    return {
      'headId': headId,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'birthDate': birthDate?.toIso8601String(),
      'age': age,
      'gender': gender,
      'maritalStatus': maritalStatus,
      'qualification': qualification,
      'occupation': occupation,
      'dutiesNature': dutiesNature,
      'bloodGroup': bloodGroup,
      'photoUrl': photoUrl,
      'relationWithHead': relationWithHead,
      'phoneNumber': phoneNumber,
      'altPhoneNumber': altPhoneNumber,
      'landlineNumber': landlineNumber,
      'email': email,
      'socialMedia': socialMedia,
      'country': country,
      'state': state,
      'district': district,
      'city': city,
      'streetName': streetName,
      'landmark': landmark,
      'buildingName': buildingName,
      'doorNumber': doorNumber,
      'flatNumber': flatNumber,
      'pincode': pincode,
      'nativeCity': nativeCity,
      'nativeState': nativeState,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  static FamilyMemberModel fromMap(Map<String, dynamic> map) {
    return FamilyMemberModel(
      id: map['id'],
      headId: map['headId'],
      firstName: map['firstName'],
      middleName: map['middleName'],
      lastName: map['lastName'],
      birthDate: DateTime.tryParse(map['birthDate'] ?? ''),
      age: map['age'],
      gender: map['gender'],
      maritalStatus: map['maritalStatus'],
      qualification: map['qualification'],
      occupation: map['occupation'],
      dutiesNature: map['dutiesNature'],
      bloodGroup: map['bloodGroup'],
      photoUrl: map['photoUrl'],
      relationWithHead: map['relationWithHead'],
      phoneNumber: map['phoneNumber'],
      altPhoneNumber: map['altPhoneNumber'],
      landlineNumber: map['landlineNumber'],
      email: map['email'],
      socialMedia: map['socialMedia'],
      country: map['country'],
      state: map['state'],
      district: map['district'],
      city: map['city'],
      streetName: map['streetName'],
      landmark: map['landmark'],
      buildingName: map['buildingName'],
      doorNumber: map['doorNumber'],
      flatNumber: map['flatNumber'],
      pincode: map['pincode'],
      nativeCity: map['nativeCity'],
      nativeState: map['nativeState'],
    );
  }

  FamilyMemberModel copyWith({
    String? id,
    String? headId,
    String? firstName,
    String? middleName,
    String? lastName,
    DateTime? birthDate,
    int? age,
    String? gender,
    String? maritalStatus,
    String? qualification,
    String? occupation,
    String? dutiesNature,
    String? bloodGroup,
    String? photoUrl,
    String? relationWithHead,
    String? phoneNumber,
    String? altPhoneNumber,
    String? landlineNumber,
    String? email,
    String? socialMedia,
    String? country,
    String? state,
    String? district,
    String? city,
    String? streetName,
    String? landmark,
    String? buildingName,
    String? doorNumber,
    String? flatNumber,
    String? pincode,
    String? nativeCity,
    String? nativeState,
  }) {
    return FamilyMemberModel(
      id: id ?? this.id,
      headId: headId ?? this.headId,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      qualification: qualification ?? this.qualification,
      occupation: occupation ?? this.occupation,
      dutiesNature: dutiesNature ?? this.dutiesNature,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      photoUrl: photoUrl ?? this.photoUrl,
      relationWithHead: relationWithHead ?? this.relationWithHead,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      altPhoneNumber: altPhoneNumber ?? this.altPhoneNumber,
      landlineNumber: landlineNumber ?? this.landlineNumber,
      email: email ?? this.email,
      socialMedia: socialMedia ?? this.socialMedia,
      country: country ?? this.country,
      state: state ?? this.state,
      district: district ?? this.district,
      city: city ?? this.city,
      streetName: streetName ?? this.streetName,
      landmark: landmark ?? this.landmark,
      buildingName: buildingName ?? this.buildingName,
      doorNumber: doorNumber ?? this.doorNumber,
      flatNumber: flatNumber ?? this.flatNumber,
      pincode: pincode ?? this.pincode,
      nativeCity: nativeCity ?? this.nativeCity,
      nativeState: nativeState ?? this.nativeState,
    );
  }
}
