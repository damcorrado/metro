import 'package:metro/classes/constants.dart';
import 'package:metro/models/track.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {

  static final DatabaseManager _instance = DatabaseManager._internal();
  factory DatabaseManager() =>_instance;
  DatabaseManager._internal();

  Database? db;

  Future<void> init() async {
    _instance.db = await openDatabase(Constants.DATABASE_NAME,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE playlist ('
            'id INTEGER PRIMARY KEY, '
            'title STRING,'
            'tempo INTEGER,'
            'sort INTEGER,'
            'note TEXT)');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        // TODO
      },
    );
  }

  Future<void> close() async {
    _instance.db!.close();
  }

  Future<List<Track>?> playlistItems() async {
    if (_instance.db == null) await _instance.init();
    List<String> columns = ['id', 'title', 'tempo', 'note', 'sort'];
    String orderBy = "sort ASC";
    final map = await _instance.db!.query('playlist', orderBy: orderBy, columns: columns);
    return map.map((item) => Track.fromMap(item)).toList();
  }

  Future<Track> insert(Track item) async {
    if (_instance.db == null) await _instance.init();
    item.id = await _instance.db!.insert('playlist', item.toMap());
    return item;
  }

  Future<int> update(Track item) async {
    if(_instance.db == null) await _instance.init();
    print("update item");
    print(item.toMap().toString());
    return await _instance.db!.update('playlist', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
  }

  Future<int> delete({ required int id }) async {
    if(_instance.db == null) await _instance.init();
    return await _instance.db!.delete('playlist', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> resetDB() async {
    await _instance.db?.delete('playlist');
  }
}