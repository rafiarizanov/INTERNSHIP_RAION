import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:INTERNSHIP_RAION/core/constants/app_colors.dart';
import 'package:INTERNSHIP_RAION/core/constants/app_text_styles.dart';
import 'package:INTERNSHIP_RAION/services/warga_service.dart';

class W_EditLaporan extends StatefulWidget {
  final Map<String, dynamic> report;
  const W_EditLaporan({super.key, required this.report});

  @override
  State<W_EditLaporan> createState() => _W_EditLaporanState();
}

class _W_EditLaporanState extends State<W_EditLaporan> {
  late String selectedDaerah;
  late String selectedKategori;
  late TextEditingController _dateController;
  late TextEditingController _descController;
  XFile? _newImageFile;
  bool _isLoading = false;

  final List<String> daftarDaerah = [
    "Bekasi Barat",
    "Bekasi Utara",
    "Bekasi Timur",
    "Bekasi Selatan",
    "Jatiasih",
    "Jatisampurna",
    "Medan Satria",
    "Mustika Jaya",
    "Pondok Melati",
    "Bantar Gebang",
    "Pondok Gede",
  ];
  final List<String> daftarKategori = ["Waspada", "Siaga", "Darurat"];

  @override
  void initState() {
    super.initState();
    selectedDaerah = widget.report['lokasi'] ?? "Pilih Daerah";
    selectedKategori = widget.report['kategori'] ?? "Pilih Kategori";
    _dateController = TextEditingController(text: widget.report['tanggal']);
    _descController = TextEditingController(text: widget.report['deskripsi']);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.blueDarker,
            onPrimary: Colors.white,
            onSurface: AppColors.blueDark,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null)
      setState(
        () => _dateController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}",
      );
  }

  Future<void> _pickImage() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null) setState(() => _newImageFile = image);
  }

  
  Future<void> _updateReport() async {
    if (_dateController.text.isEmpty || _descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Harap lengkapi data."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await WargaService().updateReport(
        reportDbId: widget.report['id'],
        currentReportStringId: widget.report['report_id'],
        currentLokasi: widget.report['lokasi'],
        currentImageUrl: widget.report['image_url'],
        tanggal: _dateController.text,
        lokasi: selectedDaerah,
        kategori: selectedKategori,
        deskripsi: _descController.text,
        newImageFile: _newImageFile,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Laporan berhasil diperbarui!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
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

  void _showGenericModal(
    String title,
    List<String> items,
    String currentVal,
    Function(String) onSelect,
  ) {
    String tempSelection = currentVal;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.h2Bold.copyWith(
                      color: AppColors.blueDark,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          items[index],
                          style: AppTextStyles.title2.copyWith(
                            color: AppColors.blueDark,
                          ),
                        ),
                        leading: Radio<String>(
                          value: items[index],
                          groupValue: tempSelection,
                          activeColor: AppColors.blueDark,
                          onChanged: (v) =>
                              setModalState(() => tempSelection = v!),
                        ),
                        onTap: () =>
                            setModalState(() => tempSelection = items[index]),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      onSelect(tempSelection);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: AppColors.blueDarker,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Pilih",
                      style: AppTextStyles.title1Bold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.blueDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Laporan',
          style: AppTextStyles.h1Bold.copyWith(color: AppColors.blueDark),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildLabel("Tanggal"),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: _buildInputField(
                      "Masukkan Tanggal",
                      Icons.calendar_today_outlined,
                      controller: _dateController,
                    ),
                  ),
                ),
                _buildLabel("Lokasi"),
                GestureDetector(
                  onTap: () => _showGenericModal(
                    "Pilih Daerah",
                    daftarDaerah,
                    selectedDaerah,
                    (val) => setState(() => selectedDaerah = val),
                  ),
                  child: _buildDropdownField(selectedDaerah),
                ),
                _buildLabel("Kategori"),
                GestureDetector(
                  onTap: () => _showGenericModal(
                    "Pilih Kondisi",
                    daftarKategori,
                    selectedKategori,
                    (val) => setState(() => selectedKategori = val),
                  ),
                  child: _buildDropdownField(selectedKategori),
                ),
                _buildLabel("Deskripsi"),
                _buildTextAreaField("Jelaskan Keluhan Anda", _descController),
                _buildLabel("Unggah Bukti Baru (Opsional)"),
                GestureDetector(
                  onTap: _pickImage,
                  child: _buildUploadField(
                    _newImageFile != null
                        ? "Gambar baru dipilih"
                        : "Pertahankan gambar lama",
                  ),
                ),
                if (_newImageFile != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: kIsWeb
                          ? Image.network(
                              _newImageFile!.path,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(_newImageFile!.path),
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _updateReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blueDarker,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Simpan Perubahan',
                      style: AppTextStyles.title1Bold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8, top: 10),
    child: Text(
      text,
      style: AppTextStyles.title1Bold.copyWith(color: AppColors.blueDark),
    ),
  );
  Widget _buildInputField(
    String hint,
    IconData icon, {
    TextEditingController? controller,
  }) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade400),
    ),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.blueDark),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
    ),
  );
  Widget _buildDropdownField(String text) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade400),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: AppTextStyles.title1.copyWith(color: AppColors.blueDark),
        ),
        const Icon(
          Icons.arrow_drop_down_circle_outlined,
          color: AppColors.blueLightActive,
          size: 22,
        ),
      ],
    ),
  );
  Widget _buildTextAreaField(String hint, TextEditingController controller) =>
      Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: const Padding(
              padding: EdgeInsets.only(bottom: 60),
              child: Icon(Icons.menu, color: AppColors.blueDark),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      );
  Widget _buildUploadField(String hint) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: AppColors.blueLightActive.withOpacity(0.3),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade400),
    ),
    child: TextField(
      enabled: false,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.title1Bold.copyWith(
          color: AppColors.blueDarker,
        ),
        prefixIcon: const Icon(Icons.image, color: AppColors.blueDark),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
    ),
  );
}
