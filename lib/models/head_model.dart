class HeadModel {
  String? id;
  String? name;
  int? age;
  String? gender;
  String? maritalStatus;
  String? occupation;
  String? samajName;
  String? qualification;
  DateTime? birthDate;
  String? bloodGroup;
  String? dutiesNature;
  String? email;
  String? phoneNumber;
  String? altPhoneNumber;
  String? landlineNumber;
  String? socialMedia;
  String? flatNumber;
  String? buildingName;
  String? streetName;
  String? landmark;
  String? city;
  String? district;
  String? state;
  String? nativeCity;
  String? nativeState;
  String? country;
  String? pincode;
  String? photoUrl;

  HeadModel({
    this.id,
    this.name,
    this.age,
    this.gender,
    this.maritalStatus,
    this.occupation,
    this.samajName,
    this.qualification,
    this.birthDate,
    this.bloodGroup,
    this.dutiesNature,
    this.email,
    this.phoneNumber,
    this.altPhoneNumber,
    this.landlineNumber,
    this.socialMedia,
    this.flatNumber,
    this.buildingName,
    this.streetName,
    this.landmark,
    this.city,
    this.district,
    this.state,
    this.nativeCity,
    this.nativeState,
    this.country,
    this.pincode,
    this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'maritalStatus': maritalStatus,
      'occupation': occupation,
      'samajName': samajName,
      'qualification': qualification,
      'birthDate': birthDate?.toIso8601String(),
      'bloodGroup': bloodGroup,
      'dutiesNature': dutiesNature,
      'email': email,
      'phoneNumber': phoneNumber,
      'altPhoneNumber': altPhoneNumber,
      'landlineNumber': landlineNumber,
      'socialMedia': socialMedia,
      'flatNumber': flatNumber,
      'buildingName': buildingName,
      'streetName': streetName,
      'landmark': landmark,
      'city': city,
      'district': district,
      'state': state,
      'nativeCity': nativeCity,
      'nativeState': nativeState,
      'country': country,
      'pincode': pincode,
      'photoUrl': photoUrl,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  static HeadModel fromMap(Map<String, dynamic> map) {
    return HeadModel(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      gender: map['gender'],
      maritalStatus: map['maritalStatus'],
      occupation: map['occupation'],
      samajName: map['samajName'],
      qualification: map['qualification'],
      birthDate: DateTime.tryParse(map['birthDate'] ?? ''),
      bloodGroup: map['bloodGroup'],
      dutiesNature: map['dutiesNature'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      altPhoneNumber: map['altPhoneNumber'],
      landlineNumber: map['landlineNumber'],
      socialMedia: map['socialMedia'],
      flatNumber: map['flatNumber'],
      buildingName: map['buildingName'],
      streetName: map['streetName'],
      landmark: map['landmark'],
      city: map['city'],
      district: map['district'],
      state: map['state'],
      nativeCity: map['nativeCity'],
      nativeState: map['nativeState'],
      country: map['country'],
      pincode: map['pincode'],
      photoUrl: map['photoUrl'],
    );
  }

  HeadModel copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    String? maritalStatus,
    String? occupation,
    String? samajName,
    String? qualification,
    DateTime? birthDate,
    String? bloodGroup,
    String? dutiesNature,
    String? email,
    String? phoneNumber,
    String? altPhoneNumber,
    String? landlineNumber,
    String? socialMedia,
    String? flatNumber,
    String? buildingName,
    String? streetName,
    String? landmark,
    String? city,
    String? district,
    String? state,
    String? nativeCity,
    String? nativeState,
    String? country,
    String? pincode,
    String? photoUrl,
  }) {
    return HeadModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      occupation: occupation ?? this.occupation,
      samajName: samajName ?? this.samajName,
      qualification: qualification ?? this.qualification,
      birthDate: birthDate ?? this.birthDate,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      dutiesNature: dutiesNature ?? this.dutiesNature,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      altPhoneNumber: altPhoneNumber ?? this.altPhoneNumber,
      landlineNumber: landlineNumber ?? this.landlineNumber,
      socialMedia: socialMedia ?? this.socialMedia,
      flatNumber: flatNumber ?? this.flatNumber,
      buildingName: buildingName ?? this.buildingName,
      streetName: streetName ?? this.streetName,
      landmark: landmark ?? this.landmark,
      city: city ?? this.city,
      district: district ?? this.district,
      state: state ?? this.state,
      nativeCity: nativeCity ?? this.nativeCity,
      nativeState: nativeState ?? this.nativeState,
      country: country ?? this.country,
      pincode: pincode ?? this.pincode,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
