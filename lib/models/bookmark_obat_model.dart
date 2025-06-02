class BookmarkObat {
  final String id;
  final String nama;

  BookmarkObat({required this.id, required this.nama});

  factory BookmarkObat.fromJson(Map<String, dynamic> json) {
    return BookmarkObat(
      id: json['id'],
      nama: json['nama'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
    };
  }
}