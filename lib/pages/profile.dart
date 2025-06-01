import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../model/profile_model.dart';
import '../service/profile_database_helper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _mottoController = TextEditingController();

  late SharedPreferences prefs;
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

  bool _isEditing = false;
  bool _isLoading = false;
  ProfileModel? currentProfile;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    initial();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    _mottoController.dispose();
    super.dispose();
  }

  void initial() async {
    prefs = await SharedPreferences.getInstance();
    await _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String? username = prefs.getString('username');
      if (username != null && username.isNotEmpty) {
        ProfileModel? profile =
            await ProfileDatabaseHelper.getProfileByUsername(username);

        if (profile != null) {
          currentProfile = profile;
          setState(() {
            _nameController.text = profile.name ?? 'Kaifa Ahlal Katamsyi';
            _nimController.text = profile.nim ?? '123220006';
            _emailController.text =
                profile.email ?? 'kaifaahlalkatamsyi@gmail.com';
            _birthDateController.text = profile.birthDate ?? '23 April 2004';
            _mottoController.text = profile.motto ?? 'Man Jadda Wa jada';

            if (profile.profileImagePath != null &&
                profile.profileImagePath!.isNotEmpty) {
              _selectedImage = File(profile.profileImagePath!);
            }
          });
        } else {
          // Set default data if no profile exists
          _setDefaultData();
        }
      } else {
        _setDefaultData();
      }
    } catch (e) {
      _showSnackBar('Error loading profile: $e', Colors.red);
      _setDefaultData();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _setDefaultData() {
    setState(() {
      _nameController.text = 'Kaifa Ahlal Katamsyi';
      _nimController.text = '123220006';
      _emailController.text = 'kaifaahlalkatamsyi@gmail.com';
      _birthDateController.text = '23 April 2004';
      _mottoController.text = 'Man Jadda Wa jada';
      _selectedImage = null;
    });
  }

  Future<void> _saveProfileData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      String? username = prefs.getString('username') ?? 'default_user';

      ProfileModel profile = ProfileModel(
        username: username,
        name: _nameController.text,
        nim: _nimController.text,
        email: _emailController.text,
        birthDate: _birthDateController.text,
        motto: _mottoController.text,
        profileImagePath: _selectedImage?.path,
      );

      if (currentProfile != null) {
        // Update existing profile
        profile.id = currentProfile!.id;
        await ProfileDatabaseHelper.updateProfile(profile);
      } else {
        // Create new profile
        await ProfileDatabaseHelper.createProfile(profile);
      }

      currentProfile = profile;

      setState(() {
        _isEditing = false;
        _isLoading = false;
      });

      _showSnackBar('Profile saved successfully!', Colors.green);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Error saving profile: $e', Colors.red);
    }
  }

  Future<void> _resetProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (currentProfile != null) {
        await ProfileDatabaseHelper.deleteProfile(currentProfile!.id!);
      }

      _setDefaultData();
      currentProfile = null;

      setState(() {
        _isEditing = false;
        _isLoading = false;
      });

      _showSnackBar('Profile reset successfully!', Colors.orange);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Error resetting profile: $e', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Select Profile Picture',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffAD8B73),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageOption(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () => _pickImage(ImageSource.camera),
                  ),
                  _buildImageOption(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: () => _pickImage(ImageSource.gallery),
                  ),
                  if (_selectedImage != null)
                    _buildImageOption(
                      icon: Icons.delete,
                      label: 'Remove',
                      onTap: _removeImage,
                      color: Colors.red,
                    ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: (color ?? const Color(0xffCEAB93)).withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: color ?? const Color(0xffAD8B73),
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: color ?? const Color(0xffAD8B73),
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: color ?? const Color(0xffAD8B73),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);

    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });

        _showSnackBar('Profile picture updated!', Colors.green);
      }
    } catch (e) {
      _showSnackBar('Error picking image: $e', Colors.red);
    }
  }

  void _removeImage() {
    Navigator.pop(context);
    setState(() {
      _selectedImage = null;
    });
    _showSnackBar('Profile picture removed!', Colors.orange);
  }

  Future<void> _selectDate() async {
    if (!_isEditing) return;

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xffAD8B73),
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _birthDateController.text =
            "${picked.day} ${_getMonthName(picked.month)} ${picked.year}";
      });
    }
  }

  String _getMonthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month];
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          'Reset Profile',
          style:
              TextStyle(color: Color(0xffAD8B73), fontWeight: FontWeight.bold),
        ),
        content: const Text(
            'Are you sure you want to reset your profile? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetProfile();
            },
            child: const Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xffCEAB93),
              ),
            )
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 3 + 50,
                          decoration: BoxDecoration(color: Colors.white),
                        ),
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 3,
                            decoration: BoxDecoration(
                              color: Color(0xffCEAB93),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(36),
                                bottomRight: Radius.circular(36),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            top: 50,
                            left: 20,
                            right: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Profile",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                                Row(
                                  children: [
                                    if (_isEditing)
                                      IconButton(
                                        onPressed: _showResetDialog,
                                        icon: Icon(Icons.refresh),
                                        tooltip: 'Reset Profile',
                                      ),
                                    IconButton(
                                      onPressed: () async {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            content: const Text(
                                                'Are you sure want to log out?'),
                                            actions: <TextButton>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'No',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  await prefs
                                                      .remove('username');
                                                  if (mounted) {
                                                    Navigator.of(context)
                                                        .pushNamedAndRemoveUntil(
                                                            '/login',
                                                            (Route<dynamic>
                                                                    route) =>
                                                                false);
                                                  }
                                                },
                                                child: const Text('Yes',
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.logout_outlined),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Positioned(
                          left: 100,
                          top: 100,
                          child: GestureDetector(
                            onTap: _isEditing ? _showImagePickerOptions : null,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 100,
                                  backgroundColor: const Color(0xffCEAB93),
                                  backgroundImage: _selectedImage != null
                                      ? FileImage(_selectedImage!)
                                      : const AssetImage('assets/image/kai.jpg')
                                          as ImageProvider,
                                ),
                                if (_isEditing)
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xffAD8B73),
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          _nameField(),
                          SizedBox(height: 20),
                          _nimField(),
                          SizedBox(height: 20),
                          _emailField(),
                          SizedBox(height: 20),
                          _birthDateField(),
                          SizedBox(height: 20),
                          _mottoField(),
                          SizedBox(height: 30),

                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_isEditing) {
                                      _saveProfileData();
                                    } else {
                                      setState(() {
                                        _isEditing = true;
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffAD8B73),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    _isEditing ? 'Save' : 'Edit Profile',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              if (_isEditing) ...[
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _isEditing = false;
                                      });
                                      _loadProfileData(); // Reset form to original data
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget _nameField() {
    return TextFormField(
      enabled: _isEditing,
      controller: _nameController,
      validator: (value) =>
          (value == null || value.isEmpty) ? 'Name cannot be empty' : null,
      decoration: InputDecoration(
        labelText: 'Name',
        labelStyle: TextStyle(
          color: Color(0xffAD8B73),
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(
          Icons.account_circle,
          color: Color(0xffAD8B73),
          size: 25,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        floatingLabelStyle: TextStyle(
          color: Color(0xffAD8B73),
          fontSize: 18.0,
        ),
      ),
    );
  }

  Widget _nimField() {
    return TextFormField(
      enabled: _isEditing,
      controller: _nimController,
      validator: (value) =>
          (value == null || value.isEmpty) ? 'NIM cannot be empty' : null,
      decoration: InputDecoration(
        labelText: 'NIM',
        labelStyle: TextStyle(
          color: Color(0xffAD8B73),
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(
          Icons.contacts_outlined,
          color: Color(0xffAD8B73),
          size: 25,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        floatingLabelStyle: TextStyle(
          color: Color(0xffAD8B73),
          fontSize: 18.0,
        ),
      ),
    );
  }

  Widget _emailField() {
    return TextFormField(
      enabled: _isEditing,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email cannot be empty';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(
          color: Color(0xffAD8B73),
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(
          Icons.email_rounded,
          color: Color(0xffAD8B73),
          size: 25,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        floatingLabelStyle: TextStyle(
          color: Color(0xffAD8B73),
          fontSize: 18.0,
        ),
      ),
    );
  }

  Widget _birthDateField() {
    return TextFormField(
      enabled: _isEditing,
      controller: _birthDateController,
      readOnly: true,
      onTap: _selectDate,
      validator: (value) => (value == null || value.isEmpty)
          ? 'Birth date cannot be empty'
          : null,
      decoration: InputDecoration(
        labelText: 'Birth Date',
        labelStyle: TextStyle(
          color: Color(0xffAD8B73),
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(
          Icons.cake,
          color: Color(0xffAD8B73),
          size: 25,
        ),
        suffixIcon: _isEditing
            ? const Icon(Icons.calendar_today,
                color: Color(0xffAD8B73), size: 20)
            : null,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        floatingLabelStyle: TextStyle(
          color: Color(0xffAD8B73),
          fontSize: 18.0,
        ),
      ),
    );
  }

  Widget _mottoField() {
    return TextFormField(
      enabled: _isEditing,
      controller: _mottoController,
      validator: (value) =>
          (value == null || value.isEmpty) ? 'Motto cannot be empty' : null,
      decoration: InputDecoration(
        labelText: 'Motto',
        labelStyle: TextStyle(
          color: Color(0xffAD8B73),
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(
          Icons.note,
          color: Color(0xffAD8B73),
          size: 25,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        floatingLabelStyle: TextStyle(
          color: Color(0xffAD8B73),
          fontSize: 18.0,
        ),
      ),
    );
  }
}
