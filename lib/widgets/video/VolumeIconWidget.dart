import 'dart:async';
import 'package:flutter/material.dart';

class VolumeIconWidget extends StatefulWidget {
  final bool soundMute;

  VolumeIconWidget({super.key, this.soundMute = false});

  @override
  State<StatefulWidget> createState() => _VolumeIconWidgetState();
}

class _VolumeIconWidgetState extends State<VolumeIconWidget> {
  bool _isVisible = false;
  late bool _soundMute;
  Timer? _timer;

  @override
  void initState() {
    _soundMute = widget.soundMute;
    super.initState();
  }

  void manageVisibleState() {
    setState(() {
      _isVisible = true;
      _soundMute = !_soundMute;
    });

    _timer?.cancel();

    _timer = Timer(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _isVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: manageVisibleState,
      child: Container(
        alignment: .center,
        child: AnimatedOpacity(
          opacity: _isVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 1000),
          child: Stack(
            alignment: .center,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              _soundMute ? Icon(Icons.volume_off) : Icon(Icons.volume_up),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
