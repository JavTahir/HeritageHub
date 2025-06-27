import 'package:family_tree_app/core/constants/theme/theme.dart';
import 'package:family_tree_app/core/widgets/dialogs/success_dialog.dart';
import 'package:family_tree_app/providers/registeration_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../models/family_member_model.dart';
import '../../core/utils/loading_dialog.dart';
import '../../core/widgets/custom_text_field.dart';

class FamilyMemberRegistration extends StatefulWidget {
  const FamilyMemberRegistration({Key? key}) : super(key: key);

  @override
  _FamilyMemberRegistrationState createState() =>
      _FamilyMemberRegistrationState();
}

class _FamilyMemberRegistrationState extends State<FamilyMemberRegistration> {
  final _formKey = GlobalKey<FormState>();
  final FamilyMemberModel _memberData = FamilyMemberModel();
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  String? _birthDateText;

  final List<String> _relationshipOptions = [
    'Spouse',
    'Son',
    'Daughter',
    'Father',
    'Mother',
    'Brother',
    'Sister',
    'Grandfather',
    'Grandmother',
    'Uncle',
    'Aunt',
    'Cousin',
    'Other'
  ];

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      showLoadingDialog(context);

      try {
        final registrationProvider =
            Provider.of<RegistrationProvider>(context, listen: false);

        if (_profileImage != null) {
          final imageUrl =
              await registrationProvider.uploadProfileImage(_profileImage!);
          _memberData.photoUrl = imageUrl;
        }

        await registrationProvider.addFamilyMember(_memberData);

        Navigator.pop(context);
        _showSuccessDialog();
      } catch (e) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value != null && value.isNotEmpty) {
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        return 'Enter a valid email address';
      }
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final pattern = r'^(?:\+92\d{10}|0\d{10})$';

    if (!RegExp(pattern).hasMatch(value)) {
      return 'Enter a valid phone number (Format: +92XXXXXXXXXX or 0XXXXXXXXXX)';
    }

    return null;
  }

  String? _validateAge(String? value) {
    if (value != null && value.isNotEmpty) {
      final age = int.tryParse(value);
      if (age == null) {
        return 'Enter a valid number';
      }
      if (age < 1 || age > 120) {
        return 'Age must be between 1 and 120';
      }
    }
    return null;
  }

  String? _validatePincode(String? value) {
    if (value != null &&
        value.isNotEmpty &&
        !RegExp(r'^[0-9]{6}$').hasMatch(value)) {
      return 'Enter a valid 6-digit pincode';
    }
    return null;
  }

  String? _validateURL(String? value) {
    if (value != null && value.isNotEmpty) {
      final uri = Uri.tryParse(value);
      if (uri == null || !(uri.hasScheme && uri.hasAuthority)) {
        return 'Enter a valid URL';
      }
    }
    return null;
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _profileImage = null;
      _birthDateText = null;
      _memberData.firstName = null;
      _memberData.middleName = null;
      _memberData.lastName = null;
      _memberData.birthDate = null;
      _memberData.age = null;
      _memberData.gender = null;
      _memberData.maritalStatus = null;
      _memberData.qualification = null;
      _memberData.occupation = null;
      _memberData.dutiesNature = null;
      _memberData.bloodGroup = null;
      _memberData.relationWithHead = null;
      _memberData.phoneNumber = null;
      _memberData.altPhoneNumber = null;
      _memberData.landlineNumber = null;
      _memberData.email = null;
      _memberData.socialMedia = null;
      _memberData.country = null;
      _memberData.state = null;
      _memberData.district = null;
      _memberData.city = null;
      _memberData.streetName = null;
      _memberData.landmark = null;
      _memberData.buildingName = null;
      _memberData.doorNumber = null;
      _memberData.flatNumber = null;
      _memberData.pincode = null;
      _memberData.nativeCity = null;
      _memberData.nativeState = null;
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => SuccessDialog(
        title: 'Success!',
        message: 'Family member added successfully!',
        primaryButtonText: 'Dashboard',
        secondaryButtonText: 'Add Another',
        onPrimaryPressed: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/dashboard');
        },
        onSecondaryPressed: () {
          Navigator.pop(context);
          _resetForm();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Family Member',
          style: AppTheme.headingMedium.copyWith(color: AppTheme.white),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.primaryMagenta,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.primaryMagenta,
                            width: 3,
                          ),
                          image: _profileImage != null
                              ? DecorationImage(
                                  image: FileImage(_profileImage!),
                                  fit: BoxFit.cover,
                                )
                              : const DecorationImage(
                                  image: AssetImage('assets/profilePic.jpg'),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryMagenta,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.white,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: AppTheme.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Form Sections
                _buildSection(
                  title: 'Personal Information',
                  children: [
                    _buildNameFields(),
                    _buildDateAndAgeFields(),
                    _buildDropdownFields(),
                    _buildOccupationFields(),
                  ],
                ),

                _buildSection(
                  title: 'Contact Information',
                  children: [
                    _buildContactFields(),
                  ],
                ),

                _buildSection(
                  title: 'Current Address',
                  children: [
                    _buildAddressFields(),
                  ],
                ),

                _buildSection(
                  title: 'Native Place',
                  children: [
                    _buildNativePlaceFields(),
                  ],
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Add Family Member'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryMagenta,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
      {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: AppTheme.headingSmall.copyWith(
              color: AppTheme.primaryMagenta,
            ),
          ),
        ),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildNameFields() {
    return Column(
      children: [
        CustomTextField(
          label: 'First Name*',
          onSaved: (value) => _memberData.firstName = value,
          validator: (value) => value!.isEmpty ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'Middle Name',
          onSaved: (value) => _memberData.middleName = value,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'Last Name*',
          onSaved: (value) => _memberData.lastName = value,
          validator: (value) => value!.isEmpty ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildDateAndAgeFields() {
    return Column(
      children: [
        const SizedBox(height: 12),
        CustomTextField(
          label: 'Birth Date',
          controller: TextEditingController(text: _birthDateText),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              setState(() {
                _birthDateText = DateFormat('yyyy-MM-dd').format(date);
                _memberData.birthDate = date;
              });
            }
          },
        ),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'Age',
          keyboardType: TextInputType.number,
          onSaved: (value) => _memberData.age = int.tryParse(value ?? '0'),
          validator: _validateAge,
        ),
      ],
    );
  }

  Widget _buildDropdownFields() {
    return Column(
      children: [
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Gender',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: ['Male', 'Female', 'Other'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) => _memberData.gender = value,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Marital Status',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items:
              ['Single', 'Married', 'Divorced', 'Widowed'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) => _memberData.maritalStatus = value,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Blood Group',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
              .map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) => _memberData.bloodGroup = value,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Relation with Head*',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: _relationshipOptions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) => _memberData.relationWithHead = value,
          validator: (value) => value == null ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildOccupationFields() {
    return Column(
      children: [
        const SizedBox(height: 12),
        CustomTextField(
          label: 'Qualification',
          onSaved: (value) => _memberData.qualification = value,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'Occupation',
          onSaved: (value) => _memberData.occupation = value,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'Exact Nature of Duties',
          onSaved: (value) => _memberData.dutiesNature = value,
        ),
      ],
    );
  }

  Widget _buildContactFields() {
    return Column(
      children: [
        CustomTextField(
          label: 'Phone Number*',
          keyboardType: TextInputType.phone,
          onSaved: (value) => _memberData.phoneNumber = value,
          validator: _validatePhoneNumber,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'Alternative Number',
          keyboardType: TextInputType.phone,
          onSaved: (value) => _memberData.altPhoneNumber = value,
          validator: _validatePhoneNumber,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'Landline Number',
          keyboardType: TextInputType.phone,
          onSaved: (value) => _memberData.landlineNumber = value,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'Email ID',
          keyboardType: TextInputType.emailAddress,
          onSaved: (value) => _memberData.email = value,
          validator: _validateEmail,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'Social Media Link',
          keyboardType: TextInputType.url,
          onSaved: (value) => _memberData.socialMedia = value,
          validator: _validateURL,
        ),
      ],
    );
  }

  Widget _buildAddressFields() {
    return Column(
      children: [
        CustomTextField(
          label: 'Country',
          onSaved: (value) => _memberData.country = value,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'State',
          onSaved: (value) => _memberData.state = value,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'District',
          onSaved: (value) => _memberData.district = value,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'City',
          onSaved: (value) => _memberData.city = value,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'Street Name',
          onSaved: (value) => _memberData.streetName = value,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'Landmark',
          onSaved: (value) => _memberData.landmark = value,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'Building Name',
          onSaved: (value) => _memberData.buildingName = value,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'Door Number',
          onSaved: (value) => _memberData.doorNumber = value,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'Flat Number',
          onSaved: (value) => _memberData.flatNumber = value,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'Pincode',
          keyboardType: TextInputType.number,
          onSaved: (value) => _memberData.pincode = value,
          validator: _validatePincode,
        ),
      ],
    );
  }

  Widget _buildNativePlaceFields() {
    return Column(
      children: [
        CustomTextField(
          label: 'Native City',
          onSaved: (value) => _memberData.nativeCity = value,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'Native State',
          onSaved: (value) => _memberData.nativeState = value,
        ),
      ],
    );
  }
}
