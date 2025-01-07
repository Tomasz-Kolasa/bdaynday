import 'package:urodziny_imieniny/services/file_managers/json_validators/json_validator.dart';

class PeopleJsonValidator extends JsonValidator{

 @override
 /// TODO implementation
  bool isJsonFormatOk(String json) {
    return json.isEmpty ? false:true;
  }
}