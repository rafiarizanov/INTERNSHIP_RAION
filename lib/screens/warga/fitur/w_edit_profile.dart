import 'dart:io';
import 'package:flutter/foundation.dart'
    show kIsWeb; 
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class W_EditProfil extends StatefulWidget {
  const W_EditProfil({super.key});

  @override
  State<W_EditProfil> createState() => _W_EditProfilState();
}

class _W_EditProfilState extends State<W_EditProfil> {
  final Color primaryTeal = const Color(0xFF003D4C);
  final supabase = Supabase.instance.client;

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

  void _loadCurrentData() {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final metadata = user.userMetadata;
      String fullName = metadata?['display_name'] ?? '';

      List<String> nameParts = fullName.split(' ');
      _firstNameController.text = nameParts.isNotEmpty ? nameParts.first : '';
      _lastNameController.text = nameParts.length > 1
          ? nameParts.sublist(1).join(' ')
          : '';

      _dobController.text = metadata?['dob'] ?? '';
      _phoneController.text = metadata?['phone'] ?? '';
      _emailController.text = user.email ?? '';
      _currentAvatarUrl = metadata?['avatar_url'] ?? '';
    }
    setState(() {});
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (image != null) {
      setState(() {
        _newProfileImage = image;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: primaryTeal,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  
  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);

    try {
      String avatarUrlToSave = _currentAvatarUrl;

      if (_newProfileImage != null) {
        String fileExt = _newProfileImage!.name.split('.').last;
        if (fileExt.isEmpty || fileExt.length > 4) fileExt = 'png';

        final fileName = '${supabase.auth.currentUser!.id}.$fileExt';
        final imagePath = 'profiles/$fileName';

        final imageBytes = await _newProfileImage!.readAsBytes();

        await supabase.storage
            .from('avatars')
            .uploadBinary(
              imagePath,
              imageBytes,
              fileOptions: const FileOptions(upsert: true),
            );

        
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        avatarUrlToSave =
            "${supabase.storage.from('avatars').getPublicUrl(imagePath)}?t=$timestamp";
      }

      String fullName =
          "${_firstNameController.text.trim()} ${_lastNameController.text.trim()}"
              .trim();

      
      await supabase.auth.updateUser(
        UserAttributes(
          data: {
            'display_name': fullName,
            'dob': _dobController.text,
            'phone': _phoneController.text,
            'avatar_url': avatarUrlToSave,
          },
        ),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profil berhasil diperbarui!"),
          backgroundColor: Colors.green,
        ),
      );
      await supabase.from('notifications').insert({
        'target_user': supabase.auth.currentUser!.id,
        'title': 'Profil Diperbarui',
        'message':
            'Perubahan data profil dan foto Anda telah berhasil disimpan.',
        'icon_type': 'success',
      });
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
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: primaryTeal,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Text(
              'Edit Profil',
              style: TextStyle(
                color: primaryTeal,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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
                      color: primaryTeal,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          "Ubah Foto Profil",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
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
                      color: primaryTeal,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Text(
                        "Simpan",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
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
              child: Center(
                child: CircularProgressIndicator(color: primaryTeal),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 15),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: primaryTeal,
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    String hint = "",
    required TextEditingController controller,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
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
          hintStyle: TextStyle(
            color: primaryTeal.withOpacity(0.5),
            fontSize: 14,
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
            borderSide: BorderSide(color: primaryTeal, width: 1.5),
          ),
        ),
      ),
    );
  }
}
