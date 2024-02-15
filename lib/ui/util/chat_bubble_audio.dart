import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

import 'global_colors.dart';

class WaveBubble extends StatefulWidget {
  final bool isSender;
  final int? index;
  final String? path;
  final double? width;

  const WaveBubble({
    Key? key,
    this.width,
    this.index,
    this.isSender = false,
    this.path,
  }) : super(key: key);

  @override
  State<WaveBubble> createState() => _WaveBubbleState();
}

class _WaveBubbleState extends State<WaveBubble>
    with AutomaticKeepAliveClientMixin {
  PlayerController? controller;
  bool? _isPlaying = false;
  StreamSubscription<PlayerState>? playerStateSubscription;

  final playerWaveStyle = const PlayerWaveStyle(
    fixedWaveColor: GlobalColors.colorBackgroundView,
    liveWaveColor: GlobalColors.colorBackgroundView,
    spacing: 6,
  );

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    controller ??= PlayerController();
    _preparePlayer();
    playerStateSubscription ??= controller!.onPlayerStateChanged.listen((_) {
      setState(() {
        _isPlaying = controller!.playerState.isPlaying;
      });
    });
  }

  @override
  void didUpdateWidget(WaveBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.path == null) return;
    if (widget.path != oldWidget.path) {
      _preparePlayer();
    }
  }

  void _preparePlayer() async {
    if (widget.index == null && widget.path == null) {
      return;
    }

    controller!.preparePlayer(
      path: widget.path!,
      shouldExtractWaveform: true,
      noOfSamples: 200,
      volume: 1.0,
    );

  }

  @override
  void dispose() {
    playerStateSubscription!.cancel();
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.path != null
        ? Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!controller!.playerState.isStopped)
          IconButton(
            onPressed: () async {
              _isPlaying!
                  ? await controller!.pausePlayer()
                  : await controller!.startPlayer(
                finishMode: FinishMode.pause,
              );
            },
            icon: Icon(
              _isPlaying! ? Icons.stop_rounded : Icons.play_arrow_rounded,
            ),
            color: GlobalColors.colorBackgroundView,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
        AudioFileWaveforms(
          size: Size(MediaQuery.of(context).size.width / 2, 70),
          playerController: controller!,
          enableSeekGesture: true,
          waveformType: WaveformType.long,
          playerWaveStyle: playerWaveStyle,
        ),
        if (widget.isSender) const SizedBox(width: 10),
      ],
    )
        : const SizedBox.shrink();
  }
}
