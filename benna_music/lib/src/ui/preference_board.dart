import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:benna_music/src/base/global.dart';
import 'package:benna_music/src/controls/playback.dart';
import 'package:benna_music/src/controls/playerstate.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class PreferenceBoard extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final GlobalBase _globalbase = Provider.of<GlobalBase>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        StreamBuilder<MapEntry<MapEntry<PlayerState,Song>,List<Song>>>(
          stream: Observable.combineLatest2(
            _globalbase.musicPlayerBase.playerState$,
            _globalbase.musicPlayerBase.favorites$,
              (a,b) => MapEntry(a,b),
          ),
          builder: (BuildContext context,
              AsyncSnapshot<MapEntry<MapEntry<PlayerState,Song>,List<Song>>>
                snapshot){
            if(!snapshot.hasData){
              return Icon(
                Icons.favorite,
                size: 35,
                  color: Color(0xFFC7D2E3),
              );
            }
            final PlayerState _state = snapshot.data.key.key;
            if(_state == PlayerState.stopped){
              return Icon(
                  Icons.favorite,
                  size: 35,
                  color: Color(0xFFC7D2E3),
              );
            }
            final Song _currentSong = snapshot.data.key.value;
            final List<Song> _favorites = snapshot.data.value;
            final bool _isFavorited = _favorites.contains(_currentSong);
            return IconButton(
              onPressed: (){
                if(_isFavorited){
                  _globalbase.musicPlayerBase.removeFromFavorites(_currentSong);
                }else{
                  _globalbase.musicPlayerBase.addToFavorites(_currentSong);
                }
              },
              icon: Icon(
                Icons.favorite,
                size: 35,
                color: !_isFavorited ? Color(0xFFC7D2E3) : Color(0xFF7B92CA),
              ),
            );
          },
        ),
        StreamBuilder<List<Playback>>(
          stream:  _globalbase.musicPlayerBase.playback$,
          builder:
              (BuildContext context,AsyncSnapshot<List<Playback>> snapshot){
            if(!snapshot.hasData){
              return Icon(
                Icons.loop,
                size: 35,
                color: Color(0xFFC7D2E3),
              );
            }
            final List<Playback> _playbackList = snapshot.data;
            final bool _isSelected =
                _playbackList.contains(Playback.repeatSong);
            return IconButton(
              onPressed: (){
                if(!_isSelected){
                  _globalbase.musicPlayerBase.updatePlayback(Playback.repeatSong);
                } else {
                  _globalbase.musicPlayerBase.removePlayback(Playback.repeatSong);
                }
              },
              icon: Icon(
                Icons.loop,
                size: 35,
                color: !_isSelected ? Color(0xFFC7D2E3) : Color(0xFF7B92CA),
              ),
            );
          },
        ),
        StreamBuilder<List<Playback>>(
          stream: _globalbase.musicPlayerBase.playback$,
          builder:
              (BuildContext context, AsyncSnapshot<List<Playback>> snapshot){
            if(!snapshot.hasData){
              return Icon(
                Icons.loop,
                size: 35,
                color: Color(0xFFC7D2E3),
              );
            }
            final List<Playback> _playbackList = snapshot.data;
            final bool _isSelected = _playbackList.contains(Playback.shuffle);
            return IconButton(
              onPressed: (){
                if(!_isSelected){
                  _globalbase.musicPlayerBase.updatePlayback(Playback.shuffle);
                }else {
                  _globalbase.musicPlayerBase.removePlayback(Playback.shuffle);
                }
              },
              icon: Icon(
                Icons.shuffle,
                size: 35,
                color: !_isSelected ? Color(0xFFC7D2E3) : Color(0xFF7B92CA),
              ),
            );
          },
        )
      ],
    );
  }
}