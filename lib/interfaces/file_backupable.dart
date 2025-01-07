/// file backup interface
abstract class FileBackupable{

  String get backupFileName;

  /// save backup to destinationDir/backupFileName
  Future<bool> backup(String destinationDir);

  /// restore backup from given file
  Future<bool> restoreBackup(String file);
}