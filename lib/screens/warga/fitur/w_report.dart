import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:INTERNSHIP_RAION/core/constants/app_colors.dart';
import 'package:INTERNSHIP_RAION/core/constants/app_text_styles.dart';
import 'package:INTERNSHIP_RAION/services/warga_service.dart';

class W_ReportPage extends StatefulWidget {
  const W_ReportPage({super.key});

  @override
  State<W_ReportPage> createState() => _W_ReportPageState();
}

class _W_ReportPageState extends State<W_ReportPage> {
  String selectedDaerah = "Pilih Daerah";
  String selectedKategori = "Pilih Kategori";
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  XFile? _imageFile;
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
    if (picked != null) {
      setState(
        () => _dateController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}",
      );
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null) setState(() => _imageFile = image);
  }


  Future<void> _submitReport() async {
    if (_dateController.text.isEmpty ||
        selectedDaerah == "Pilih Daerah" ||
        selectedKategori == "Pilih Kategori" ||
        _descController.text.isEmpty ||
        _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Harap lengkapi semua data dan foto."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await WargaService().submitReport(
        tanggal: _dateController.text,
        lokasi: selectedDaerah,
        kategori: selectedKategori,
        deskripsi: _descController.text,
        imageFile: _imageFile!,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSuccessDialog();
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal mengirim laporan: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppColors.blueLightActive.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: AppColors.blueDarker,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Laporan Telah Dikirim!",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h2Bold.copyWith(
                    color: AppColors.blueDarker,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Terima kasih telah berkontribusi dalam peningkatan kualitas air di Kota Bekasi.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.title1.copyWith(
                    color: AppColors.blueDarker,
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _dateController.clear();
                        _descController.clear();
                        selectedDaerah = "Pilih Daerah";
                        selectedKategori = "Pilih Kategori";
                        _imageFile = null;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blueDarker,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      "Selesai",
                      style: AppTextStyles.title2Bold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.h2Bold.copyWith(
                      color: AppColors.blueDarker,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            items[index],
                            style: AppTextStyles.title2.copyWith(
                              color: AppColors.blueDarker,
                            ),
                          ),
                          leading: Radio<String>(
                            value: items[index],
                            groupValue: tempSelection,
                            activeColor: AppColors.blueDarker,
                            onChanged: (v) =>
                                setModalState(() => tempSelection = v!),
                          ),
                          onTap: () =>
                              setModalState(() => tempSelection = items[index]),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: AppColors.blueLightActive,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Batal",
                            style: AppTextStyles.title1Bold.copyWith(
                              color: AppColors.blueDark,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            onSelect(tempSelection);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 15),
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
                      ),
                    ],
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
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Laporkan Masalah Air',
                    style: AppTextStyles.h2Bold.copyWith(
                      color: AppColors.blueDark,
                    ),
                  ),
                  const SizedBox(height: 25),
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
                    child: _buildDropdownField(
                      selectedDaerah,
                      Icons.location_on_outlined,
                    ),
                  ),
                  _buildLabel("Kategori"),
                  GestureDetector(
                    onTap: () => _showGenericModal(
                      "Pilih Kondisi",
                      daftarKategori,
                      selectedKategori,
                      (val) => setState(() => selectedKategori = val),
                    ),
                    child: _buildDropdownField(
                      selectedKategori,
                      Icons.local_offer_outlined,
                    ),
                  ),
                  _buildLabel("Deskripsi"),
                  _buildTextAreaField("Jelaskan Keluhan Anda", _descController),
                  _buildLabel("Unggah Bukti"),
                  GestureDetector(
                    onTap: _pickImage,
                    child: _buildUploadField(
                      _imageFile != null
                          ? "Gambar telah dipilih"
                          : "Upload Gambar",
                    ),
                  ),
                  if (_imageFile != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: kIsWeb
                            ? Image.network(
                                _imageFile!.path,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(_imageFile!.path),
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
                      onPressed: _submitReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blueDarker,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Kirim ',
                            style: AppTextStyles.title2Bold.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
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
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8, top: 10),
    child: Text(
      text,
      style: AppTextStyles.title1Bold.copyWith(color: AppColors.blueDarker),
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
        hintStyle: AppTextStyles.title1.copyWith(color: Colors.grey),
        prefixIcon: Icon(icon, color: AppColors.blueDarker),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
    ),
  );
  Widget _buildDropdownField(String text, IconData icon) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade400),
    ),
    child: Row(
      children: [
        Icon(icon, color: AppColors.blueDarker, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.title1.copyWith(
              color: text.startsWith("Pilih")
                  ? Colors.grey
                  : AppColors.blueDarker,
            ),
          ),
        ),
        const Icon(
          Icons.arrow_drop_down_circle_outlined,
          color: AppColors.blueDarker,
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
            hintStyle: AppTextStyles.title1.copyWith(color: Colors.grey),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 15,
            ),
          ),
        ),
      );
  Widget _buildUploadField(String hint) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: hint == "Upload Gambar"
          ? Colors.transparent
          : AppColors.blueLightActive.withOpacity(0.3),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade400),
    ),
    child: TextField(
      enabled: false,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.title1.copyWith(
          color: hint == "Upload Gambar" ? Colors.grey : AppColors.blueDarker,
          fontWeight: hint == "Upload Gambar"
              ? FontWeight.normal
              : FontWeight.bold,
        ),
        prefixIcon: Icon(
          hint == "Upload Gambar" ? Icons.file_upload_outlined : Icons.image,
          color: AppColors.blueDarker,
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
    ),
  );
}
