import 'package:rxdart/rxdart.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsBase{
  BehaviorSubject _storagePermissionStatus$;

  BehaviorSubject get storagePermissionStatus$ =>
      _storagePermissionStatus$;

  PermissionsBase(){
    _storagePermissionStatus$ = BehaviorSubject();
    requestStoragePermission();
  }
  Future requestStoragePermission() async{
    Map _permission =
        await PermissionHandler().requestPermissions([
          PermissionGroup.storage,
        ]);
    final PermissionStatus _state = _permission.values.toList()[0];
    _storagePermissionStatus$.add(_state);
  }

  void dispose(){
    _storagePermissionStatus$.close();
  }

}