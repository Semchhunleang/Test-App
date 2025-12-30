import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'local_storage_helper.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._();

  factory LocalStorageService() => _instance;

  LocalStorageService._();

  late Database _db;

  Future<void> init() async {
    if (kDebugMode) {
    }

    try {
      // Get the documents directory
      String databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'nenam.db');

      // Open the database with versioning
      _db = await openDatabase(
        path,
        version: 4, // Increment the version number
        onCreate: (db, version) => onCreate(db, version),
        onUpgrade: (db, oldVersion, newVersion) =>
            onUpgrade(db, oldVersion, newVersion),
      );

      // update exist table ==> for load menu without uninstall app
      if (db.isOpen) {
        await createTableMenuUiTypeIfNotExist();
        await updateColumnIfNotExist();
      }

        debugPrint('Database initialized successfully.');
      

      // Check if the tables were created
      // await _checkTables();
    } catch (e) {
        debugPrint('Error initializing database: $e');
      
    }
  }

  Future<void> createTableMenuUiTypeIfNotExist() async {
    await db.execute('''
          CREATE TABLE IF NOT EXISTS menu_ui_type (
            id INTEGER PRIMARY KEY,
            type TEXT
          )
        ''');
  }

  Future<void> updateColumnIfNotExist() async {
    final table = await db.rawQuery("PRAGMA table_info(menu_items);");
    final isDescExist = table.any((column) => column['name'] == 'description');
    if (!isDescExist) {
      await db.execute('ALTER TABLE menu_items ADD COLUMN description TEXT');
    }
    final tableAL = await db.rawQuery("PRAGMA table_info(access_levels);");
    final isIASGMExist = tableAL.any((column) => column['name'] == 'is_after_sales_general_manager');
    final isIFSGMExist = tableAL.any((column) => column['name'] == 'is_field_service_general_manager');
    final isAHExist = tableAL.any((column) => column['name'] == 'is_service_admin_head');
    final isA4exist = tableAL.any((column) => column['name'] == 'a4');
    final isTSBexist = tableAL.any((column) => column['name'] == 'tsb');
    final isReadRequestOT = tableAL.any((column) => column['name'] == 'is_read_request_ot');
    final isReadOT = tableAL.any((column) => column['name'] == 'is_read_ot');
    final isSubmitRequestOT = tableAL.any((column) => column['name'] == 'is_submit_request_ot');
    final isSubmitOT = tableAL.any((column) => column['name'] == 'is_submit_ot');
    final isApproveOT = tableAL.any((column) => column['name'] == 'is_approve_ot');

    if (!isIASGMExist) {
      await db.execute('ALTER TABLE access_levels ADD COLUMN is_after_sales_general_manager INTEGER');
    }
    if (!isIFSGMExist) {
      await db.execute('ALTER TABLE access_levels ADD COLUMN is_field_service_general_manager INTEGER');
    }
    if (!isAHExist) {
      await db.execute('ALTER TABLE access_levels ADD COLUMN is_service_admin_head INTEGER');
    }
    if (!isA4exist) {
      await db.execute('ALTER TABLE access_levels ADD COLUMN a4 INTEGER');
    }
    if (!isTSBexist) {
      await db.execute('ALTER TABLE access_levels ADD COLUMN tsb INTEGER');
    }
    if (!isReadRequestOT) {
      await db.execute('ALTER TABLE access_levels ADD COLUMN is_read_request_ot INTEGER');
    }
    if (!isReadOT) {
      await db.execute('ALTER TABLE access_levels ADD COLUMN is_read_ot INTEGER');
    }
    if (!isSubmitRequestOT) {
      await db.execute('ALTER TABLE access_levels ADD COLUMN is_submit_request_ot INTEGER');
    }
    if (!isSubmitOT) {
      await db.execute('ALTER TABLE access_levels ADD COLUMN is_submit_ot INTEGER');
    }
    if (!isApproveOT) {
      await db.execute('ALTER TABLE access_levels ADD COLUMN is_approve_ot INTEGER');
    }
  }

  Database get db => _db;
}
