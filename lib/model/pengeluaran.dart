class Pengeluaran {
  int? id;
  int nominal;
  String keterangan;
  String waktu;
  String? createDate;
  String? updateDate;

  Pengeluaran({
    this.id,
    required this.nominal,
    required this.keterangan,
    required this.waktu,
    this.createDate,
    this.updateDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nominal': nominal,
      'keterangan': keterangan,
      'waktu': waktu,
    };
  }
}
