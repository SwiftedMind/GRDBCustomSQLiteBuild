import Foundation
import GRDB
import SQLiteExtensions

extension AppDatabase {
  /// The database for the application
  static let shared = makeShared()

  private static func makeShared() -> AppDatabase {
    do {
      
      // Initialize all SQLite extensions
      SQLiteExtensions.initialize_sqlite3_extensions()
      
      let fileManager = FileManager.default
      let appSupportURL = try fileManager.url(
        for: .applicationSupportDirectory, in: .userDomainMask,
        appropriateFor: nil, create: true
      )
      let directoryURL = appSupportURL.appendingPathComponent("Database", isDirectory: true)

      // Create the database folder if needed
      try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)

      // Open or create the database
      let databaseURL = directoryURL.appendingPathComponent("db.sqlite")
      let dbPool = try DatabasePool(
        path: databaseURL.path,
        // Use default AppDatabase configuration
        configuration: AppDatabase.makeConfiguration()
      )

      // Create the AppDatabase
      let appDatabase = try AppDatabase(dbPool)

      return appDatabase
    } catch {
      fatalError("Critical error: \(error)")
    }
  }
}
