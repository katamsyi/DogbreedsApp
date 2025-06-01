import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/profile_model.dart';

class ProfileDatabaseHelper {
  static final _databaseName = "woofyeApp.db";
  static final _databaseVersion =
      2; // Increment version untuk trigger onCreate ulang

  // Table names
  static final _userTable = 'User';
  static final _profileTable = 'Profile';

  // User table columns
  static final _userColumnId = 'id';
  static final _userColumnName = 'name';
  static final _userColumnNim = 'nim';
  static final _userColumnEmail = 'email';
  static final _userColumnUsername = 'username';
  static final _userColumnPassword = 'password';

  // Profile table columns
  static final _profileColumnId = 'id';
  static final _profileColumnUsername = 'username';
  static final _profileColumnName = 'name';
  static final _profileColumnNim = 'nim';
  static final _profileColumnEmail = 'email';
  static final _profileColumnBirthDate = 'birthDate';
  static final _profileColumnMotto = 'motto';
  static final _profileColumnImagePath = 'profileImagePath';

  // Singleton pattern
  ProfileDatabaseHelper._internal();
  static final ProfileDatabaseHelper _databaseHelper =
      ProfileDatabaseHelper._internal();
  static ProfileDatabaseHelper get instance => _databaseHelper;

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, _databaseName);

    // Debug: Print database path
    print('Database path: $path');

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    print('Creating database tables...');

    // Create User table
    await db.execute('''
      CREATE TABLE $_userTable(
        $_userColumnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $_userColumnName TEXT,
        $_userColumnNim TEXT,
        $_userColumnEmail TEXT,
        $_userColumnUsername TEXT UNIQUE,
        $_userColumnPassword TEXT
      )
    ''');
    print('User table created');

    // Create Profile table
    await db.execute('''
      CREATE TABLE $_profileTable(
        $_profileColumnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $_profileColumnUsername TEXT UNIQUE,
        $_profileColumnName TEXT,
        $_profileColumnNim TEXT,
        $_profileColumnEmail TEXT,
        $_profileColumnBirthDate TEXT,
        $_profileColumnMotto TEXT,
        $_profileColumnImagePath TEXT,
        FOREIGN KEY($_profileColumnUsername) REFERENCES $_userTable($_userColumnUsername)
      )
    ''');
    print('Profile table created');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('Upgrading database from version $oldVersion to $newVersion');

    if (oldVersion < 2) {
      try {
        // Check which tables exist before dropping
        var userExists = await db.rawQuery(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='$_userTable'");
        var profileExists = await db.rawQuery(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='$_profileTable'");

        // Drop existing tables if they exist
        if (profileExists.isNotEmpty) {
          await db.execute('DROP TABLE IF EXISTS $_profileTable');
          print('Dropped existing Profile table');
        }
        if (userExists.isNotEmpty) {
          await db.execute('DROP TABLE IF EXISTS $_userTable');
          print('Dropped existing User table');
        }

        // Recreate tables
        await _onCreate(db, newVersion);
      } catch (e) {
        print('Error during database upgrade: $e');
        rethrow;
      }
    }
  }

  // Method untuk memaksa recreate database (untuk testing)
  static Future<void> resetDatabase() async {
    try {
      await closeDatabase();
      await deleteDatabase();
      print('Database reset successfully');
      // Database akan dibuat ulang saat diakses berikutnya
    } catch (e) {
      print('Error resetting database: $e');
    }
  }

  // Method untuk memperbaiki database yang korup
  static Future<void> fixDatabase() async {
    try {
      Database? db = await instance.database;
      if (db == null) throw Exception('Database not initialized');

      // Check current tables
      var tables = await db
          .rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
      print('Current tables: ${tables.map((t) => t['name']).toList()}');

      // Ensure required tables exist
      await _ensureTablesExist(db);

      print('Database fix completed');
    } catch (e) {
      print('Error fixing database: $e');
      // If fix fails, reset database
      await resetDatabase();
    }
  }

  // Profile CRUD Operations

  /// Create a new profile
  static Future<int> createProfile(ProfileModel profile) async {
    Database? db = await instance.database;
    if (db == null) throw Exception('Database not initialized');

    try {
      // Pastikan tabel ada sebelum insert
      await _ensureTablesExist(db);

      return await db.insert(
        _profileTable,
        profile.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error creating profile: $e');
      throw Exception('Error creating profile: $e');
    }
  }

  /// Get profile by username
  static Future<ProfileModel?> getProfileByUsername(String username) async {
    Database? db = await instance.database;
    if (db == null) throw Exception('Database not initialized');

    try {
      // Pastikan tabel ada sebelum query
      await _ensureTablesExist(db);

      final List<Map<String, dynamic>> maps = await db.query(
        _profileTable,
        where: '$_profileColumnUsername = ?',
        whereArgs: [username],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return ProfileModel.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      print('Error getting profile: $e');
      throw Exception('Error getting profile: $e');
    }
  }

  /// Get profile by ID
  static Future<ProfileModel?> getProfileById(int id) async {
    Database? db = await instance.database;
    if (db == null) throw Exception('Database not initialized');

    try {
      await _ensureTablesExist(db);

      final List<Map<String, dynamic>> maps = await db.query(
        _profileTable,
        where: '$_profileColumnId = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return ProfileModel.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      print('Error getting profile by ID: $e');
      throw Exception('Error getting profile by ID: $e');
    }
  }

  /// Get all profiles
  static Future<List<ProfileModel>> getAllProfiles() async {
    Database? db = await instance.database;
    if (db == null) throw Exception('Database not initialized');

    try {
      await _ensureTablesExist(db);

      final List<Map<String, dynamic>> maps = await db.query(_profileTable);
      return List.generate(maps.length, (i) {
        return ProfileModel.fromMap(maps[i]);
      });
    } catch (e) {
      print('Error getting all profiles: $e');
      throw Exception('Error getting all profiles: $e');
    }
  }

  /// Update an existing profile
  static Future<int> updateProfile(ProfileModel profile) async {
    Database? db = await instance.database;
    if (db == null) throw Exception('Database not initialized');

    if (profile.id == null) {
      throw Exception('Profile ID cannot be null for update operation');
    }

    try {
      await _ensureTablesExist(db);

      return await db.update(
        _profileTable,
        profile.toMap(),
        where: '$_profileColumnId = ?',
        whereArgs: [profile.id],
      );
    } catch (e) {
      print('Error updating profile: $e');
      throw Exception('Error updating profile: $e');
    }
  }

  /// Delete a profile by ID
  static Future<int> deleteProfile(int id) async {
    Database? db = await instance.database;
    if (db == null) throw Exception('Database not initialized');

    try {
      await _ensureTablesExist(db);

      return await db.delete(
        _profileTable,
        where: '$_profileColumnId = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error deleting profile: $e');
      throw Exception('Error deleting profile: $e');
    }
  }

  /// Delete profile by username
  static Future<int> deleteProfileByUsername(String username) async {
    Database? db = await instance.database;
    if (db == null) throw Exception('Database not initialized');

    try {
      await _ensureTablesExist(db);

      return await db.delete(
        _profileTable,
        where: '$_profileColumnUsername = ?',
        whereArgs: [username],
      );
    } catch (e) {
      print('Error deleting profile by username: $e');
      throw Exception('Error deleting profile by username: $e');
    }
  }

  /// Check if profile exists for username
  static Future<bool> profileExists(String username) async {
    Database? db = await instance.database;
    if (db == null) throw Exception('Database not initialized');

    try {
      await _ensureTablesExist(db);

      final List<Map<String, dynamic>> maps = await db.query(
        _profileTable,
        where: '$_profileColumnUsername = ?',
        whereArgs: [username],
        limit: 1,
      );

      return maps.isNotEmpty;
    } catch (e) {
      print('Error checking profile existence: $e');
      throw Exception('Error checking profile existence: $e');
    }
  }

  // Helper method untuk memastikan tabel ada
  static Future<void> _ensureTablesExist(Database db) async {
    try {
      // Check if both tables exist
      var userTableResult = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='$_userTable'");

      var profileTableResult = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='$_profileTable'");

      // Create User table if it doesn't exist
      if (userTableResult.isEmpty) {
        print('User table not found, creating...');
        await db.execute('''
          CREATE TABLE $_userTable(
            $_userColumnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $_userColumnName TEXT,
            $_userColumnNim TEXT,
            $_userColumnEmail TEXT,
            $_userColumnUsername TEXT UNIQUE,
            $_userColumnPassword TEXT
          )
        ''');
        print('User table created successfully');
      }

      // Create Profile table if it doesn't exist
      if (profileTableResult.isEmpty) {
        print('Profile table not found, creating...');
        await db.execute('''
          CREATE TABLE $_profileTable(
            $_profileColumnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $_profileColumnUsername TEXT UNIQUE,
            $_profileColumnName TEXT,
            $_profileColumnNim TEXT,
            $_profileColumnEmail TEXT,
            $_profileColumnBirthDate TEXT,
            $_profileColumnMotto TEXT,
            $_profileColumnImagePath TEXT,
            FOREIGN KEY($_profileColumnUsername) REFERENCES $_userTable($_userColumnUsername)
          )
        ''');
        print('Profile table created successfully');
      }
    } catch (e) {
      print('Error in _ensureTablesExist: $e');
      // Don't call _onCreate here as it might cause conflicts
      rethrow;
    }
  }

  // User CRUD Operations (if needed)

  /// Create a new user
  static Future<int> createUser(Map<String, dynamic> user) async {
    Database? db = await instance.database;
    if (db == null) throw Exception('Database not initialized');

    try {
      await _ensureTablesExist(db);

      return await db.insert(
        _userTable,
        user,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error creating user: $e');
      throw Exception('Error creating user: $e');
    }
  }

  /// Get user by username
  static Future<Map<String, dynamic>?> getUserByUsername(
      String username) async {
    Database? db = await instance.database;
    if (db == null) throw Exception('Database not initialized');

    try {
      await _ensureTablesExist(db);

      final List<Map<String, dynamic>> maps = await db.query(
        _userTable,
        where: '$_userColumnUsername = ?',
        whereArgs: [username],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return maps.first;
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      throw Exception('Error getting user: $e');
    }
  }

  /// Verify user credentials
  static Future<bool> verifyUser(String username, String password) async {
    Database? db = await instance.database;
    if (db == null) throw Exception('Database not initialized');

    try {
      await _ensureTablesExist(db);

      final List<Map<String, dynamic>> maps = await db.query(
        _userTable,
        where: '$_userColumnUsername = ? AND $_userColumnPassword = ?',
        whereArgs: [username, password],
        limit: 1,
      );

      return maps.isNotEmpty;
    } catch (e) {
      print('Error verifying user: $e');
      throw Exception('Error verifying user: $e');
    }
  }

  // Utility Methods

  /// Close the database
  static Future<void> closeDatabase() async {
    Database? db = await instance.database;
    await db?.close();
    _database = null;
  }

  /// Delete the database (for testing purposes)
  static Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, _databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }

  /// Get database path
  static Future<String> getDatabasePath() async {
    final dbPath = await getDatabasesPath();
    return join(dbPath, _databaseName);
  }

  /// Debug method untuk melihat semua tabel yang ada
  static Future<List<String>> getTableNames() async {
    Database? db = await instance.database;
    if (db == null) throw Exception('Database not initialized');

    try {
      var result = await db
          .rawQuery("SELECT name FROM sqlite_master WHERE type='table'");

      List<String> tableNames =
          result.map((row) => row['name'] as String).toList();
      print('Existing tables: $tableNames');
      return tableNames;
    } catch (e) {
      print('Error getting table names: $e');
      return [];
    }
  }
}
