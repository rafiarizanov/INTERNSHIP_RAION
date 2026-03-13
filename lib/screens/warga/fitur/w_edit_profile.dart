import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:INTERNSHIP_RAION/core/constants/app_colors.dart';
import 'package:INTERNSHIP_RAION/core/constants/app_text_styles.dart';
import 'package:INTERNSHIP_RAION/services/warga_service.dart';

class W_EditProfil extends StatefulWidget {
  const W_EditProfil({super.key});

  @override
  State<W_EditProfil> createState() => _W_EditProfilState();
}

class _W_EditProfilState extends State<W_EditProfil> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  XFile? _newProfileImage;
  String _currentAvatarUrl = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentData();
  }

  Future<void> _loadCurrentData() async {
    final userData = await WargaService().getUserProfile();
    if (userData.isNotEmpty) {
      String fullName = userData['name'];
      List<String> nameParts = fullName.split(' ');
      _firstNameController.text = nameParts.isNotEmpty ? nameParts.first : '';
      _lastNameController.text = nameParts.length > 1
          ? nameParts.sublist(1).join(' ')
          : '';
      _dobController.text = userData['dob'];
      _phoneController.text = userData['phone'];
      _emailController.text = userData['email'];
      _currentAvatarUrl = userData['avatar_url'];
      setState(() {});
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) setState(() => _newProfileImage = image);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.blueDarker,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(
        () => _dobController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}",
      );
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    try {
      await WargaService().updateProfile(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        dob: _dobController.text,
        phone: _phoneController.text,
        currentAvatarUrl: _currentAvatarUrl,
        newProfileImage: _newProfileImage,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profil berhasil diperbarui!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal memperbarui: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.blueDarker,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
        title: Text(
          'Edit Profil',
          style: AppTextStyles.h2Bold.copyWith(color: AppColors.blueDarker),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: _newProfileImage != null
                        ? (kIsWeb
                              ? NetworkImage(_newProfileImage!.path)
                              : FileImage(File(_newProfileImage!.path))
                                    as ImageProvider)
                        : (_currentAvatarUrl.isNotEmpty
                              ? NetworkImage(_currentAvatarUrl)
                              : null),
                    child:
                        (_newProfileImage == null && _currentAvatarUrl.isEmpty)
                        ? Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey.shade600,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.blueDarker,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.edit, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          "Ubah Foto Profil",
                          style: AppTextStyles.title1Bold.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                _buildInputLabel("Nama"),
                Row(
                  children: [
                    Expanded(
                      child: _buildInputField(
                        hint: "Nama Depan",
                        controller: _firstNameController,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInputField(
                        hint: "Nama Belakang",
                        controller: _lastNameController,
                      ),
                    ),
                  ],
                ),
                _buildInputLabel("Tanggal Lahir"),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: _buildInputField(
                      hint: "DD/MM/YYYY",
                      controller: _dobController,
                    ),
                  ),
                ),
                _buildInputLabel("Nomor Telepon"),
                _buildInputField(
                  hint: "08XXXXXXX",
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
                _buildInputLabel("Email"),
                _buildInputField(
                  hint: "example@email.com",
                  controller: _emailController,
                  readOnly: true,
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: _saveProfile,
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      color: AppColors.blueDarker,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        "Simpan",
                        style: AppTextStyles.title2Bold.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.blueDarker),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) => Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 15),
      child: Text(
        label,
        style: AppTextStyles.title2Bold.copyWith(color: AppColors.blueDarker),
      ),
    ),
  );
  Widget _buildInputField({
    String hint = "",
    required TextEditingController controller,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
  }) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    child: TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.title1.copyWith(
          color: AppColors.blueDarker.withOpacity(0.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.blueDarker, width: 1.5),
        ),
      ),
    ),
  );
}
