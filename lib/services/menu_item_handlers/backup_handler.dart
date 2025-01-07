import 'package:urodziny_imieniny/services/menu_item_handlers/menu_item_handler.dart';
import 'package:file_picker/file_picker.dart';

class BackupHandler extends MenuItemHandler{ 

  late final String fileOperation;

  BackupHandler.write(super.context){
    fileOperation = 'write';
  }

    BackupHandler.read(super.context){
    fileOperation = 'read';
  }

  @override
  void handleMenuItem(){
    switch(fileOperation){
      case 'write':saveBackup();
      case 'read':readBackup();
      case _: throw ArgumentError();
    }
  }

  /// reads user selected Json backup file
  Future<void> readBackup() async {

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null) {
      String? filePath = result.files.single.path;
      
      if (filePath != null) {

        var isReadOk = await appState.restoreBackup(filePath);

        var msg = isReadOk?'wczytano kopię zapasową':'błąd odczytu kopii zapasowej';
        appState.addUserMessage(msg);

      } else {
        appState.addUserMessage('nieprawidłowa ścieżka');
      }
    } else {
      appState.addUserMessage('nie wybrano pliku');
    }
  }

  /// saves Json backup file with given name into user selected location
  Future<void> saveBackup() async {

    final String? selectedDir = await FilePicker.platform.getDirectoryPath();
     
    if (selectedDir != null) {

      // Write content to the file
      var isSaved = await appState.saveBackup(selectedDir);

      var message = isSaved?'zapisano':'niepowodzenie';
      appState.addUserMessage(message);

    } else {
      appState.addUserMessage('nie wybrano folderu');
    }
  }
}