import 'package:flutter/material.dart';
import 'package:tree_ar/Database/database.dart';
import 'package:tree_ar/constant_vars.dart';
import 'Database/dataModel.dart';
import 'Database/database_constant.dart';

class DataManager extends ChangeNotifier {
  ///static function to get trees or Projects items scanned byt user to be showed
  ///in listview.
  //TODO: save in user preferences user id
  int currentUserId = DEFAULT_USER_ID;
  User? userData;

  DatabaseProvider dbProvider = DatabaseProvider.dbp;

  // DataManager() {
  //   super();
  // }

  //TODO: metodo che copia gli alberi da server online a db locale

  ///get user info then when received, cache data to var then notify listeners
  getUser() async {
    var user = await dbProvider.getUserInfo(currentUserId);
    userData = user;
    notifyListeners();
  }

  void updateUserInfo(
    int userId,
    String? name,
    String? surname,
    String? dateBirth,
    String? course,
    String? registrationDate,
    String? userImageName,
  ) async {
    await dbProvider.updateUserInfo(userId, name, surname, dateBirth, course,
        registrationDate, userImageName);
  }

  Map<InfoType, List> getUserTreesProject() {
    //from id of tree get information from source
    List<Tree> trees = List.empty();
    List<Project> projc = List.empty();
    dbProvider.getUserTrees(currentUserId).then((result) => {trees = result});
    dbProvider
        .getUserProjects(currentUserId)
        .then((result) => {projc = result});

    return {
      InfoType.tree: trees,
      InfoType.project: projc,
    };
  }

  Tree? getTreeById(int id) {
    Tree? result;
    dbProvider.getTree(id).then((tree) => {result = tree});
    return result;
  }

  Project? getProjectById(int id) {
    Project? result;
    dbProvider.getProject(id).then((proj) => result = proj);
    return result;
  }

  Future<List<Badge>> getBadges() {
    return dbProvider.getUserBadges(currentUserId);
  }

  //ADDING methods
  void addUserTree(int treeId) {
    dbProvider.addUserTree(currentUserId, treeId);
    notifyListeners();
  }

  void unlockUserBadge(int idBadge) {
    dbProvider.addUserBadge(currentUserId, idBadge);
    notifyListeners();
  }

  bool isValidTreeCode(String qrData) {
    //TODO: get valid ids from online server or from cached trees donwloade form online db
    return true;
  }
}
