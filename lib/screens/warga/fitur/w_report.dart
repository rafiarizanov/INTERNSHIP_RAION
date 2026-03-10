import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb; 
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

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

  final Map<String, String> prefixDaerah = {
    "Bekasi Barat": "BB",
    "Bekasi Utara": "BU",
    "Bekasi Timur": "BT",
    "Bekasi Selatan": "BS",
    "Jatiasih": "JA",
    "Jatisampurna": "JS",
    "Medan Satria": "MS",
    "Mustika Jaya": "MJ",
    "Pondok Melati": "PM",
    "Bantar Gebang": "BG",
    "Pondok Gede": "PG",
  };

  final List<String> daftarKategori = ["Waspada", "Siaga", "Darurat"];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF004D56),
              onPrimary: Colors.white,
              onSurface: Color(0xFF003D45),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      setState(() {
        _imageFile = image; 
      });
    }
  }

  Future<void> _submitReport() async {
    if (_dateController.text.isEmpty ||
        selectedDaerah == "Pilih Daerah" ||
        selectedKategori == "Pilih Kategori" ||
        _descController.text.isEmpty ||
        _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Harap lengkapi semua data dan unggah foto."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      final userName = user?.userMetadata?['display_name'] ?? 'Warga Anonim';

      final fileExt = _imageFile!.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final imagePath = 'laporan/$fileName';

      final imageBytes = await _imageFile!.readAsBytes();
      await supabase.storage
          .from('report_image')
          .uploadBinary(
            imagePath,
            imageBytes,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final imageUrl = supabase.storage
          .from('report_image')
          .getPublicUrl(imagePath);

      final prefix = prefixDaerah[selectedDaerah]!;
      final countResponse = await supabase
          .from('reports')
          .select('id')
          .eq('lokasi', selectedDaerah);
      int urutan = (countResponse as List).length + 1;
      String reportId = "$prefix${urutan.toString().padLeft(3, '0')}";

      await supabase.from('reports').insert({
        'report_id': reportId,
        'user_id': user?.id,
        'user_name': userName,
        'tanggal': _dateController.text,
        'lokasi': selectedDaerah,
        'kategori': selectedKategori,
        'deskripsi': _descController.text,
        'image_url': imageUrl,
      });

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
                    color: const Color(0xFFB2EBF2).withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Color(0xFF007E94),
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Laporan Telah Dikirim!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003D45),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Terima kasih telah berkontribusi dalam peningkatan kualitas air di Kota Bekasi.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Color(0xFF003D45)),
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
                      backgroundColor: const Color(0xFF004D56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Selesai",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003D45),
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
                            style: const TextStyle(color: Color(0xFF003D45)),
                          ),
                          leading: Radio<String>(
                            value: items[index],
                            groupValue: tempSelection,
                            activeColor: const Color(0xFF003D45),
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
                            backgroundColor: const Color(0xFFB2EBF2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Batal",
                            style: TextStyle(
                              color: Color(0xFF003D45),
                              fontWeight: FontWeight.bold,
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
                            backgroundColor: const Color(0xFF004D56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Pilih",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Laporkan Masalah Air',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003D45),
                        ),
                      ),
                      Icon(Icons.history, color: Color(0xFF003D45), size: 28),
                    ],
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
                  _buildSubmitButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xFF004D56)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() => SizedBox(
    width: double.infinity,
    height: 55,
    child: ElevatedButton(
      onPressed: _submitReport,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF004D56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Kirim ',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Icon(Icons.arrow_forward, color: Colors.white, size: 18),
        ],
      ),
    ),
  );
  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8, top: 10),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xFF003D45),
        fontSize: 15,
      ),
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
      border: Border.all(color: const Color(0xFF709096)),
    ),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF003D45)),
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
      border: Border.all(color: const Color(0xFF709096)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
            color: text.startsWith("Pilih")
                ? const Color(0xFF709096)
                : const Color(0xFF003D45),
            fontSize: 14,
          ),
        ),
        const Icon(
          Icons.arrow_drop_down_circle_outlined,
          color: Color(0xFF80DEEA),
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
          border: Border.all(color: const Color(0xFF709096)),
        ),
        child: TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: const Padding(
              padding: EdgeInsets.only(bottom: 60),
              child: Icon(Icons.menu, color: Color(0xFF003D45)),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      );
  Widget _buildUploadField(String hint) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: hint == "Upload Gambar"
          ? Colors.transparent
          : const Color(0xFFB2EBF2).withOpacity(0.3),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFF709096)),
    ),
    child: TextField(
      enabled: false,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: hint == "Upload Gambar"
              ? const Color(0xFF709096)
              : const Color(0xFF004D56),
          fontWeight: hint == "Upload Gambar"
              ? FontWeight.normal
              : FontWeight.bold,
        ),
        prefixIcon: Icon(
          hint == "Upload Gambar" ? Icons.file_upload_outlined : Icons.image,
          color: const Color(0xFF003D45),
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
    ),
  );
}
