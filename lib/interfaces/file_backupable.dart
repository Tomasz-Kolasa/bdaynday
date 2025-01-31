/// file backup interface
abstract class FileBackupable{

  String get backupFileName;

  /// save backup to destinationDir/backupFileName
  Future<bool> backup(String destinationDir);

  /// restore backup from given file
  /// this method should read file and update associated app state variable
  /// [file] fully qualified file path to restore
  /// [associatedAppState] associated AppState list variable
  Future<bool> restoreBackup<T>(String file, List<T> associatedAppState);
}