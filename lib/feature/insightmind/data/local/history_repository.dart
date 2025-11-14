import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../local/screening_record.dart';

/// Repository untuk mengelola riwayat hasil tes psikologi
/// 
/// Tanggung jawab utama kelas ini:
/// - Membuka atau membuat box Hive secara aman.
/// - Menyimpan hasil tes baru ke dalam database lokal.
/// - Mengambil, menghapus, dan mengosongkan riwayat tes pengguna.
class HistoryRepository {
  /// Nama box Hive yang digunakan untuk menyimpan data screening
  static const String boxName = 'screening_records';

  /// Membuka box [ScreeningRecord] jika belum terbuka
  /// 
  /// Hive akan otomatis menginisialisasi box saat pertama kali dipanggil.
  Future<Box<ScreeningRecord>> _openBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<ScreeningRecord>(boxName);
    }
    // Dapat ditambah fitur enkripsi (HiveAesCipher) jika dibutuhkan
    return Hive.openBox<ScreeningRecord>(boxName);
  }

  /// Menambahkan satu riwayat hasil tes mental
  /// 
  /// Biasanya dipanggil ketika hasil tes sudah muncul.
  Future<void> addRecord({
    required int score,
    required String riskLevel,
    String? note,
  }) async {
    final box = await _openBox();
    final id = const Uuid().v4(); 

    final record = ScreeningRecord(
      id: id,
      timestamp: DateTime.now(),
      score: score,
      riskLevel: riskLevel,
      note: note,
    );

    await box.put(id, record); 
  }

  Future<List<ScreeningRecord>> getAll() async {
    final box = await _openBox();
    final records = box.values.toList();
    records.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return records;
  }

  Future<void> deleteById(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  Future<void> clearAll() async {
    final box = await _openBox();
    await box.clear();
  }
}
