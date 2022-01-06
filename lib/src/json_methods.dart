import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class JsonUtils {
  // #region private methods
  static Future<File> get _localFile async {
    final path = await _getPath;
    return File('$path/shoppinglist.json');
  }

  static Future<String> get _getPath async {
    Directory dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }
  //#endregion

  //#region public methods
  static writeJson(List list) async {
    String jsonList = jsonEncode(list);
    final file = await _localFile;
    file.writeAsString(jsonList);
  }

  static Future<List> readJson() async {
    final file = await _localFile;
    if (await file.exists()) {
      String fileText = await file.readAsString();
      List fileValue = jsonDecode(fileText);
      return fileValue;
    } else {
      file.create();
      JsonUtils.writeJson(List.empty());
    }
    return List.empty();
  }

  static Future<List> getListfromJson() async {
    Iterable temp = await JsonUtils.readJson();
    List returnList = List.empty();
    returnList = List.from(temp.map((model) => model));
    return returnList;
  }

  static void appendToList(List list) async {
    List fileList = await JsonUtils.getListfromJson();
    fileList.addAll(list);
    JsonUtils.writeJson(fileList);
  }

  static void removeElement(var elementToRemove) async {
    List fileList = await JsonUtils.getListfromJson();
    fileList.removeWhere(
        (element) => element.ingredient.name == elementToRemove.name);
    JsonUtils.writeJson(fileList);
  }

  static void changeValuefromListAt(var element) async {
    List fileList = await JsonUtils.getListfromJson();
    int searchedIndex = fileList.indexWhere(
        (element) => element.ingredient.name == element.ingredient.name);
    fileList[searchedIndex] = element;
    JsonUtils.writeJson(fileList);
  }

  static Future<bool> listContainsElement(var elementToCheck) async {
    List fileList = List.empty();
    bool returnValue = await JsonUtils.getListfromJson().then((value) {
      fileList = value;
      if (fileList.any((element) =>
          element.ingredient.name == elementToCheck.ingredient.name)) {
        return true;
      } else {
        return false;
      }
    });
    return returnValue;
  }

  static Future<dynamic> getElementAtIngredient(var elementToCheck) async {
    List fileList = await JsonUtils.getListfromJson();
    return fileList[fileList.indexWhere(
        (element) => element.ingredient.name == elementToCheck.name)];
  }

  static Future<dynamic> getElementAtIndex(int i) async {
    List fileList = await JsonUtils.getListfromJson();
    return fileList[i];
  }
  //#endregion
}
