import 'package:benna_music/src/base/music_player.dart';
import 'package:benna_music/src/base/permissions.dart';

class GlobalBase{
  PermissionsBase _permissionsBase;
  MusicPlayerBase _musicPlayerBase;
  MusicPlayerBase get musicPlayerBase => _musicPlayerBase;
  PermissionsBase get permissionBase => _permissionsBase;


  GlobalBase(){
    _musicPlayerBase = MusicPlayerBase();
    _permissionsBase = PermissionsBase();

  }
  void dispose(){
    _musicPlayerBase.dispose();
    _permissionsBase.dispose();

  }
}