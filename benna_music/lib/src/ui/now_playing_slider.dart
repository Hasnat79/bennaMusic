import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:benna_music/src/base/global.dart';
import 'package:benna_music/src/controls/playerstate.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class NowPlayingSlider extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final GlobalBase _globalbase = Provider.of<GlobalBase>(context);

    return StreamBuilder<MapEntry<Duration,MapEntry<PlayerState,Song>>>(
      stream: Observable.combineLatest2(_globalbase.musicPlayerBase.position$,
        _globalbase.musicPlayerBase.playerState$,(a,b)=> MapEntry(a,b)),
      builder: (BuildContext context,
          AsyncSnapshot<MapEntry<Duration,MapEntry<PlayerState,Song>>>
              snapshot){
        if(!snapshot.hasData){
          return Slider(
            value: 0,
            onChanged: (double value)=> null,
            activeColor: Colors.blue,
            inactiveColor: Color(0xFFCEE3EE),
          );
        }
        if(snapshot.data.value.key == PlayerState.stopped) {
          return Slider(
            value: 0,
            onChanged: (double value)=> null,
            activeColor: Colors.blue,
            inactiveColor: Color(0xFFCEE3EE),
          );
        }
        final Duration _currentDuration = snapshot.data.key;
        final Song _currentSong = snapshot.data.value.value;
        final int _millseconds = _currentDuration.inMilliseconds;
        final int _songDurationInMilliseconds = _currentSong.duration;
        return Slider(
          min: 0,
          max: _songDurationInMilliseconds.toDouble(),
          value: _songDurationInMilliseconds > _millseconds
          ? _millseconds.toDouble()
          : _songDurationInMilliseconds.toDouble(),
          onChangeStart: (double value)=>
          _globalbase.musicPlayerBase.invertSeekingState(),
          onChanged: (double value){
            final Duration _duration =Duration(
              milliseconds: value.toInt(),
            );
            _globalbase.musicPlayerBase.updatePosition(_duration);
          },
          onChangeEnd: (double value){
            _globalbase.musicPlayerBase.invertSeekingState();
            _globalbase.musicPlayerBase.audioSeek(value/1000);
          },
          activeColor: Colors.blue,
          inactiveColor:Color(0xFFCEE3EE),
        );
      },
    );
  }
}