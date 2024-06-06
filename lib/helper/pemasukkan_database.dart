import 'package:fms/model/pemasukkan.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class PemasukkanDB {
  static Database? database;

  static Future<void> initializeDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'fms.db');
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            "CREATE TABLE pemasukkan(id INTEGER PRIMARY KEY AUTOINCREMENT, nominal INTEGER, keterangan TEXT, waktu TEXT)");
      },
    );

    // sqfliteFfiInit();

    // var databaseFactory = databaseFactoryFfi;
    // database = await databaseFactory.openDatabase('fms.db');
    // await database?.execute(
    //     "CREATE TABLE IF NOT EXISTS pemasukkan(id INTEGER PRIMARY KEY AUTOINCREMENT, nominal INTEGER, keterangan TEXT, waktu TEXT, createDate Text,updateDate Text)");
  }

  static Future<int> addNewPemasukkan(Pemasukkan pemasukkan) async {
    if (database == null) {
      await PemasukkanDB.initializeDatabase();
    }
    int result = await database!.insert(
      'pemasukkan',
      pemasukkan.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
    return result;
  }

  static Future<List<Pemasukkan>> getPemasukkanList() async {
    if (database == null) {
      await PemasukkanDB.initializeDatabase();
    }
    final List<Map<String, dynamic>> maps =
        await database!.query("pemasukkan", orderBy: "id DESC");

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

    List<Pemasukkan> pemasukkanList = [];

    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        Pemasukkan pemasukkan = Pemasukkan(
          id: maps[i]["id"],
          nominal: maps[i]["nominal"],
          keterangan: maps[i]["keterangan"],
          waktu: maps[i]['waktu'],
          createDate: maps[i]['createDate'],
        );

        pemasukkanList.add(pemasukkan);
      }
    }

    return pemasukkanList;
  }

  static Future<int> updatePemasukkan(int id, Pemasukkan pemasukkan) async {
    // result melambangkan jumlah data yang berhasil diupdate jika result = 0 maka proses update gagal
    if (database == null) {
      await PemasukkanDB.initializeDatabase();
    }
    int result = await database!.update(
      "pemasukkan",
      pemasukkan.toMap(),
      where:
          "id = ?", //tanda tanya otomatis diganti dengan nilai yang ada di whereArgs
      whereArgs: [id],
    );

    return result;
  }

  static Future<int> deletePemasukkan(int id) async {
    if (database == null) {
      await PemasukkanDB.initializeDatabase();
    }
    // result melambangkan jumlah data yang berhasil didelete
    int result = await database!.delete(
      "pemasukkan",
      where:
          "id = ?", //tanda tanya otomatis diganti dengan nilai yang ada di whereArgs
      whereArgs: [id],
    );

    return result;
  }
}
