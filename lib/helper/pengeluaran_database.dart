import 'package:fms/model/pengeluaran.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class PengeluaranDB {
  static Database? databasePengeluaran;

  static Future<void> initializeDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'fms_pengeluaran.db');
    databasePengeluaran = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            "CREATE TABLE pengeluaran(id INTEGER PRIMARY KEY AUTOINCREMENT, nominal INTEGER, keterangan TEXT, waktu TEXT)");
      },
    );

    // asd

    // sqfliteFfiInit();

    // var databaseFactory = databaseFactoryFfi;
    // databasePengeluaran = await databaseFactory.openDatabase('fms.db');
    // await databasePengeluaran?.execute(
    //     "CREATE TABLE IF NOT EXISTS pengeluaran(id INTEGER PRIMARY KEY AUTOINCREMENT, nominal INTEGER, keterangan TEXT, waktu TEXT)");
  }

  static Future<int> addNewPengluaran(Pengeluaran pengeluaran) async {
    if (databasePengeluaran == null) {
      await PengeluaranDB.initializeDatabase();
    }
    int result = await databasePengeluaran!.insert(
      'pengeluaran',
      pengeluaran.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
    return result;
  }

  static Future<List<Pengeluaran>> getPengeluaranList() async {
    if (databasePengeluaran == null) {
      await PengeluaranDB.initializeDatabase();
    }
    final List<Map<String, dynamic>> maps =
        await databasePengeluaran!.query("pengeluaran", orderBy: "id DESC");

    // [
    //   {
    //     "name":"AAA",
    //     "phone":"123"
    //   },
    //   {
    //     "name":"BBB",
    //     "phone":456
    //   }
    // ]

    List<Pengeluaran> pengeluaranList = [];

    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        Pengeluaran pengeluaran = Pengeluaran(
          id: maps[i]["id"],
          nominal: maps[i]["nominal"],
          keterangan: maps[i]["keterangan"],
          waktu: maps[i]['waktu'],
          createDate: maps[i]['createDate'],
        );

        pengeluaranList.add(pengeluaran);
      }
    }

    return pengeluaranList;
  }

  static Future<int> updatePengeluaran(int id, Pengeluaran pengeluaran) async {
    // result melambangkan jumlah data yang berhasil diupdate jika result = 0 maka proses update gagal
    if (databasePengeluaran == null) {
      await PengeluaranDB.initializeDatabase();
    }
    int result = await databasePengeluaran!.update(
      "pengeluaran",
      pengeluaran.toMap(),
      where:
          "id = ?", //tanda tanya otomatis diganti dengan nilai yang ada di whereArgs
      whereArgs: [id],
    );

    return result;
  }

  static Future<int> deletePegeluaran(int id) async {
    if (databasePengeluaran == null) {
      await PengeluaranDB.initializeDatabase();
    }
    // result melambangkan jumlah data yang berhasil didelete
    int result = await databasePengeluaran!.delete(
      "pengeluaran",
      where:
          "id = ?", //tanda tanya otomatis diganti dengan nilai yang ada di whereArgs
      whereArgs: [id],
    );

    return result;
  }
}
