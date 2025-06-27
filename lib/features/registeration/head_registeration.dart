import 'package:family_tree_app/core/constants/samaj_options.dart';
import 'package:family_tree_app/core/constants/theme/theme.dart';
import 'package:family_tree_app/providers/registeration_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../models/head_model.dart';
import '../../core/utils/loading_dialog.dart';
import '../../core/widgets/custom_text_field.dart';

class HeadRegistrationForm extends StatefulWidget {
  const HeadRegistrationForm({Key? key}) : super(key: key);

  @override
  _HeadRegistrationFormState createState() => _HeadRegistrationFormState();
}

class _HeadRegistrationFormState extends State<HeadRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final HeadModel _headData = HeadModel();
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  String? _birthDateText;
  bool _isImageSelected = false;

  List<String> _filteredSamajOptions = SamajOptions.options;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        _isImageSelected = true;
      });
    }
  }

  void _submitForm() async {
    if (!_isImageSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a profile image')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      showLoadingDialog(context);

      try {
        final registrationProvider =
            Provider.of<RegistrationProvider>(context, listen: false);

        final imageUrl =
            await registrationProvider.uploadProfileImage(_profileImage!);
        _headData.photoUrl = imageUrl;

        await registrationProvider.saveHeadData(_headData);

        Navigator.pop(context);
        Navigator.pushNamed(context, '/familyMemberRegistration');
      } catch (e) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final pattern = r'^(?:\+92|0)3[0-9]{9}$';

    if (!RegExp(pattern).hasMatch(value)) {
      return 'Enter a valid phone number';
    }

    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }
    final age = int.tryParse(value);
    if (age == null) {
      return 'Enter a valid number';
    }
    if (age < 18 || age > 120) {
      return 'Age must be between 18 and 120';
    }
    return null;
  }

  String? _validatePincode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pincode is required';
    }
    if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) {
      return 'Enter a valid 6-digit pincode';
    }
    return null;
  }

  String? _validateBirthDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Birth date is required';
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
            child: Column(children: children),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Head Registration',
          style: AppTheme.headingMedium.copyWith(color: AppTheme.white),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.primaryMagenta,
        elevation: 0,
      ),
      body: SingleChildScrollView(
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
                          color: _isImageSelected
                              ? AppTheme.primaryMagenta
                              : Colors.red,
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
              if (!_isImageSelected)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Profile image is required',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              _buildSection(
                title: 'Profile Summary',
                children: [
                  CustomTextField(
                    label: 'Name*',
                    onSaved: (value) => _headData.name = value,
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: 'Age*',
                    keyboardType: TextInputType.number,
                    onSaved: (value) =>
                        _headData.age = int.tryParse(value ?? '0'),
                    validator: _validateAge,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Gender*',
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
                    onChanged: (value) => _headData.gender = value,
                    validator: (value) => value == null ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Marital Status*',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: ['Single', 'Married', 'Divorced', 'Widowed']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) => _headData.maritalStatus = value,
                    validator: (value) => value == null ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: 'Occupation*',
                    onSaved: (value) => _headData.occupation = value,
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return _filteredSamajOptions;
                      }
                      return _filteredSamajOptions.where((String option) {
                        return option
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (String selection) {
                      _headData.samajName = selection;
                    },
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController textEditingController,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted) {
                      return TextFormField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: 'Samaj Name*',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon: const Icon(Icons.search),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Required' : null,
                        onChanged: (value) {
                          setState(() {
                            _filteredSamajOptions = SamajOptions.options
                                .where((option) => option
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          });
                        },
                      );
                    },
                    optionsViewBuilder: (BuildContext context,
                        AutocompleteOnSelected<String> onSelected,
                        Iterable<String> options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4.0,
                          child: SizedBox(
                            height: 200,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: options.length,
                              itemBuilder: (BuildContext context, int index) {
                                final String option = options.elementAt(index);
                                return GestureDetector(
                                  onTap: () {
                                    onSelected(option);
                                  },
                                  child: ListTile(
                                    title: Text(option),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: 'Qualification*',
                    onSaved: (value) => _headData.qualification = value,
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                ],
              ),
              _buildSection(
                title: 'Personal Information',
                children: [
                  CustomTextField(
                    label: 'Birth Date*',
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
                          _birthDateText =
                              DateFormat('yyyy-MM-dd').format(date);
                          _headData.birthDate = date;
                        });
                      }
                    },
                    validator: _validateBirthDate,
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
                    onChanged: (value) => _headData.bloodGroup = value,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: 'Exact Nature of Duties',
                    onSaved: (value) => _headData.dutiesNature = value,
                  ),
                ],
              ),
              _buildSection(
                title: 'Contact Information',
                children: [
                  CustomTextField(
                    label: 'Email ID*',
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) => _headData.email = value,
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: 'Phone Number*',
                    keyboardType: TextInputType.phone,
                    onSaved: (value) => _headData.phoneNumber = value,
                    validator: _validatePhoneNumber,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: 'Alternative Number',
                    keyboardType: TextInputType.phone,
                    onSaved: (value) => _headData.altPhoneNumber = value,
                    validator: _validatePhoneNumber,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: 'Landline Number',
                    keyboardType: TextInputType.phone,
                    onSaved: (value) => _headData.landlineNumber = value,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: 'Social Media Link',
                    keyboardType: TextInputType.url,
                    onSaved: (value) => _headData.socialMedia = value,
                    validator: _validateURL,
                  ),
                ],
              ),
              _buildSection(
                title: 'Address',
                children: [
                  CustomTextField(
                    label: 'Flat Number',
                    onSaved: (value) => _headData.flatNumber = value,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: 'Building Name',
                    onSaved: (value) => _headData.buildingName = value,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: 'Street Name',
                    onSaved: (value) => _headData.streetName = value,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: 'Landmark',
                    onSaved: (value) => _headData.landmark = value,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: 'City*',
                    onSaved: (value) => _headData.city = value,
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: 'District',
                    onSaved: (value) => _headData.district = value,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: 'State*',
                    onSaved: (value) => _headData.state = value,
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: 'Native City',
                    onSaved: (value) => _headData.nativeCity = value,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: 'Native State',
                    onSaved: (value) => _headData.nativeState = value,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: 'Country*',
                    onSaved: (value) => _headData.country = value,
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: 'Pincode*',
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _headData.pincode = value,
                    validator: _validatePincode,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Register Head'),
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
    );
  }
}
