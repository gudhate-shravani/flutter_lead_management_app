
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/lead_model.dart';

class DatabaseService {

  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;
  DatabaseService._init();

 
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('leads.db');
    return _database!;
  }

 
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const statusType = 'INTEGER NOT NULL';
    const dateType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE leads ( 
        id $idType, 
        name $textType,
        phone $textType,
        email $textType,
        notes $textType,
        status $statusType,
        createdAt $dateType,
        updatedAt $dateType
      )
    ''');
  }

  
  Future<Lead> create(Lead lead) async {
    final db = await instance.database;
    final id = await db.insert('leads', lead.toMap());
    return lead.copyWith(id: id);
  }

  
  Future<List<Lead>> readAllLeads() async {
    final db = await instance.database;
  
    const orderBy = 'updatedAt DESC'; 
    final result = await db.query('leads', orderBy: orderBy);

    return result.map((json) => Lead.fromMap(json)).toList();
  }

  
  Future<int> update(Lead lead) async {
    final db = await instance.database;

    return db.update(
      'leads',
      lead.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [lead.id],
    );
  }

  
  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      'leads',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}