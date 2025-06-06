class JadwalObat {
  int? id;
  String namaObat;
  int frekuensi; // 1-3 kali sehari
  String aturanMinum; // sebelum/sesudah/bersama
  DateTime jamMulai;

  JadwalObat({
    this.id,
    required this.namaObat,
    required this.frekuensi,
    required this.aturanMinum,
    required this.jamMulai,
  });

  factory JadwalObat.fromMap(Map<String, dynamic> map) {
    return JadwalObat(
      id: map['id'],
      namaObat: map['namaObat'],
      frekuensi: map['frekuensi'],
      aturanMinum: map['aturanMinum'],
      jamMulai: DateTime.parse(map['jamMulai']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'namaObat': namaObat,
      'frekuensi': frekuensi,
      'aturanMinum': aturanMinum,
      'jamMulai': jamMulai.toIso8601String(),
    };
  }
}
