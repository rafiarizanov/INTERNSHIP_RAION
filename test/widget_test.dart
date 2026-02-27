import 'package:flutter_test/flutter_test.dart';
import 'package:INTERNSHIP_RAION/main.dart';

void main() {
  testWidgets('bersihintest', (WidgetTester tester) async {
    // 1. Jalankan aplikasi
    await tester.pumpWidget(const MyApp());

    // 2. Karena aplikasi dimulai dengan Splash Screen atau Onboarding,
    // kita cari teks yang ada di sana. Contoh: 'Logo Apps' atau 'Next'
    // Kita gunakan findsAnywhere karena mungkin tertutup loading
    expect(find.textContaining('Apps'), findsWidgets);
    
    // Tes selesai. Kita tidak lagi mencari angka '0' karena sudah dihapus di main.dart
  });
}