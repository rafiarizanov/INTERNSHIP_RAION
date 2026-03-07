import 'package:flutter/material.dart';

class W_ReportPage extends StatefulWidget {
  const W_ReportPage({super.key});

  @override
  State<W_ReportPage> createState() => _W_ReportPageState();
}

class _W_ReportPageState extends State<W_ReportPage> {
  String selectedDaerah = "Pilih Daerah";
  String selectedKategori = "Pilih Kategori";

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Laporkan Masalah Air',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003D45),
                    ),
                  ),
                  const Icon(Icons.history, color: Color(0xFF003D45), size: 28),
                ],
              ),
              const SizedBox(height: 25),
              _buildLabel("Tanggal"),
              _buildInputField(
                "Masukkan Tanggal",
                Icons.calendar_today_outlined,
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
              _buildTextAreaField("Jelaskan Keluhan Anda"),
              _buildLabel("Unggah Bukti"),
              _buildUploadField("Upload Gambar"),
              const SizedBox(height: 30),
              _buildSubmitButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

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

  Widget _buildInputField(String hint, IconData icon) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFF709096)),
    ),
    child: TextField(
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
          style: const TextStyle(color: Color(0xFF709096), fontSize: 14),
        ),
        const Icon(
          Icons.arrow_drop_down_circle_outlined,
          color: Color(0xFF80DEEA),
          size: 22,
        ),
      ],
    ),
  );

  Widget _buildTextAreaField(String hint) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFF709096)),
    ),
    child: TextField(
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
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFF709096)),
    ),
    child: TextField(
      readOnly: true,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(
          Icons.file_upload_outlined,
          color: Color(0xFF003D45),
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
    ),
  );

  Widget _buildSubmitButton() => SizedBox(
    width: double.infinity,
    height: 55,
    child: ElevatedButton(
      onPressed: _showSuccessDialog,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF004D56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Kirim ',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Icon(Icons.arrow_forward, color: Colors.white, size: 18),
        ],
      ),
    ),
  );
}
