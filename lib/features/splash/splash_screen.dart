import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/pill_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onExplore});

  final VoidCallback onExplore;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _kenBurnsController;
  late final Animation<double> _scale;
  late final Animation<Alignment> _pan;

  VideoPlayerController? _videoController;
  bool _videoReady = false;

  @override
  void initState() {
    super.initState();
    // Ken Burns drift on the still photo, shown until (or unless) the
    // generated motion background finishes loading.
    _kenBurnsController = AnimationController(vsync: this, duration: const Duration(seconds: 5))
      ..repeat(reverse: true);
    final curve = CurvedAnimation(parent: _kenBurnsController, curve: Curves.easeInOut);
    _scale = Tween<double>(begin: 1.0, end: 1.12).animate(curve);
    _pan = AlignmentTween(begin: const Alignment(-0.15, -0.08), end: const Alignment(0.15, 0.1)).animate(curve);

    _initVideo();
  }

  Future<void> _initVideo() async {
    final controller = VideoPlayerController.asset('assets/videos/splash_bg.mp4');
    try {
      await controller.initialize();
      await controller.setLooping(false);
      await controller.setVolume(0);
      await controller.play();
      controller.addListener(_holdLastFrame);
      if (!mounted) return;
      setState(() {
        _videoController = controller;
        _videoReady = true;
      });
    } catch (_) {
      // Bundled video failed to load — the Ken Burns photo stays as the background.
      controller.dispose();
    }
  }

  // Not looping still lets the platform player rewind to frame 0 on
  // completion; explicitly pause at the end so the last frame holds.
  void _holdLastFrame() {
    final controller = _videoController;
    if (controller == null) return;
    final value = controller.value;
    if (value.isInitialized && !value.isPlaying && value.position >= value.duration) {
      controller.seekTo(value.duration);
    }
  }

  @override
  void dispose() {
    _kenBurnsController.dispose();
    _videoController?.removeListener(_holdLastFrame);
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _kenBurnsController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scale.value,
                alignment: _pan.value,
                child: child,
              );
            },
            child: Image.asset('assets/images/homepage.jpg', fit: BoxFit.cover),
          ),
          AnimatedOpacity(
            opacity: _videoReady ? 1 : 0,
            duration: const Duration(milliseconds: 600),
            child: _videoController != null && _videoController!.value.isInitialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoController!.value.size.width,
                      height: _videoController!.value.size.height,
                      child: VideoPlayer(_videoController!),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.navyDark.withValues(alpha: 0.22),
                  AppColors.navy.withValues(alpha: 0.12),
                  AppColors.navyDark.withValues(alpha: 0.3),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),
                  SvgPicture.asset('assets/icons/logo4.svg', width: 170),
                  const SizedBox(height: 20),
                  Text(
                    'Find Your Perfect House\nJust one Click Away',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body(color: AppColors.white, size: 15),
                  ),
                  const Spacer(flex: 4),
                  PillButton(
                    label: 'EXPLORE',
                    backgroundColor: AppColors.navy,
                    textColor: AppColors.white,
                    onPressed: widget.onExplore,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
