class ObatDetail {
  final String id;
  final List<String> names;
  final String formula;
  final String weight;
  final String classDrug;
  final String efficacy;

  ObatDetail({
    required this.id,
    required this.names,
    required this.formula,
    required this.weight,
    required this.classDrug,
    required this.efficacy,
  });

  factory ObatDetail.fromRawText(String raw) {
    final lines = raw.split('\n');
    final map = <String, List<String>>{};

    String? currentKey;
    for (var line in lines) {
      if (line.trim().isEmpty) continue;
      if (RegExp(r'^[A-Z_]+').hasMatch(line)) {
        final key = line.split(RegExp(r'\s+'))[0];
        final value = line.substring(key.length).trim();
        currentKey = key;
        map.putIfAbsent(key, () => []).add(value);
      } else if (currentKey != null) {
        map[currentKey]!.add(line.trim());
      }
    }

    return ObatDetail(
      id: map['ENTRY']?.first ?? 'tidak diketahui',
      names: map['NAME'] ?? [],
      formula: map['FORMULA']?.first ?? 'tidak diketahui',
      weight: map['MOL_WEIGHT']?.first ?? 'tidak diketahui',
      classDrug: map['CLASS']?.join('\n') ?? 'tidak diketahui',
      efficacy: map['EFFICACY']?.join(', ') ?? 'tidak diketahui',
    );
  }
}
