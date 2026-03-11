import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PDetailLaporan(),
  ));
}

class PDetailLaporan extends StatefulWidget {
  const PDetailLaporan({super.key});

  @override
  State<PDetailLaporan> createState() => _PDetailLaporanState();
}

class _PDetailLaporanState extends State<PDetailLaporan> {
  String selectedStatus = "Dibaca";
  final TextEditingController _commentController = TextEditingController();
  List<String> comments = [];

  void _showCommentSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Budi Santoso",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004D56),
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
               IconButton(
  onPressed: () => Navigator.pop(context),
  icon: Container(
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xFF004D56), width: 2),
      borderRadius: BorderRadius.circular(4),
    ),
    child: const Icon(
      Icons.close, 
      size: 18, 
      color: Color(0xFF004D56)
    ),
  ),
),
              ],
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _commentController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Berikan komentar",
                hintStyle: const TextStyle(color: Colors.blueGrey),
                filled: true,
                fillColor: const Color(0xFFE0F7FA).withOpacity(0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Color(0xFF004D56)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  if (_commentController.text.isNotEmpty) {
                    setState(() {
                      comments.add(_commentController.text);
                      _commentController.clear();
                    });
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004D56),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Post", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
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
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF004D56),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
              onPressed: () {},
            ),
          ),
        ),
        title: const Text(
          "Detail Laporan",
          style: TextStyle(
            color: Color(0xFF004D56),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF004D56)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: _buildTextField("ID Laporan", "LP005")),
                const SizedBox(width: 15),
                Expanded(child: _buildTextField("Kategori", "Waspada")),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF004D56)),
                color: Colors.grey.shade200,
              ),
              child: const Icon(Icons.image, size: 50, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            _buildTextField("Pelapor", "Siti Aisyah"),
            const SizedBox(height: 20),
            _buildTextField("Tanggal", "10/2/2026"),
            const SizedBox(height: 20),
            _buildTextField("Lokasi", "Jl. Damai 6 No.40"),
            const SizedBox(height: 20),
            const Text(
              "Deskripsi Masalah",
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF004D56), fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF004D56).withOpacity(0.5)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Air Mengandung Endapan", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF004D56))),
                  SizedBox(height: 10),
                  Text(
                    "Terdapat endapan pasir halus di dasar ember setelah air ditampung selama beberapa jam.",
                    style: TextStyle(color: Color(0xFF004D56), height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Status Laporan",
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF004D56), fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusButton("Dibaca"),
                _buildStatusButton("Diproses"),
                _buildStatusButton("Selesai"),
              ],
            ),
            const SizedBox(height: 30),
            
            // Tampilan daftar komentar/tanggapan setelah di-post
            ...comments.map((comment) => Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F7FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Budi Santoso", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF004D56))),
                              Text("11/2/2026", style: TextStyle(fontSize: 12, color: Color(0xFF004D56))),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(comment, style: const TextStyle(color: Color(0xFF004D56), height: 1.4)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),

            GestureDetector(
              onTap: _showCommentSheet,
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFF004D56),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F7FA),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: const Color(0xFF004D56).withOpacity(0.5)),
                      ),
                      child: const Text(
                        "Berikan tanggapan",
                        style: TextStyle(color: Color(0xFF004D56), fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF004D56), fontSize: 16)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF004D56).withOpacity(0.5)),
          ),
          child: Text(value, style: const TextStyle(color: Color(0xFF004D56))),
        ),
      ],
    );
  }

  Widget _buildStatusButton(String status) {
    bool isSelected = selectedStatus == status;
    return GestureDetector(
      onTap: () => setState(() => selectedStatus = status),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.28,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF004D56) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF004D56).withOpacity(0.5)),
        ),
        alignment: Alignment.center,
        child: Text(
          status,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF004D56),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}