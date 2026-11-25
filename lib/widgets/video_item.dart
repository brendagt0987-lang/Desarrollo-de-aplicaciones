import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoData {
  final String url;
  final String usuario;
  final String descripcion;
  final int likes;
  final int comentarios;

  const VideoData({
    required this.url,
    required this.usuario,
    required this.descripcion,
    required this.likes,
    required this.comentarios,
  });
}

class VideoItem extends StatefulWidget {
  final VideoData data;

  const VideoItem({
    super.key,
    required this.data,
  });

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController _controller;
  bool _inicializado = false;
  bool _errorCarga = false;
  late bool _liked;
  late int _likesCount;

  @override
  void initState() {
    super.initState();
    _liked = false;
    _likesCount = widget.data.likes;
    _iniciarVideo();
  }

  void _iniciarVideo() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.data.url))
      ..setLooping(true)
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {
          _inicializado = true;
        });
        _controller.setVolume(0.0);
        _controller.play();
      }).catchError((_) {
        if (!mounted) return;
        setState(() {
          _errorCarga = true;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (!_inicializado) return;
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 24,
                offset: Offset(0, 10),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: GestureDetector(
            onTap: _togglePlayPause,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (_errorCarga)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'No se pudo cargar ${widget.data.url}',
                        style: const TextStyle(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else if (_inicializado)
                  FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  )
                else
                  const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),

                IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.15),
                          Colors.black.withValues(alpha: 0.85),
                        ],
                        stops: const [0.55, 0.78, 1.0],
                      ),
                    ),
                  ),
                ),

                if (_inicializado && !_controller.value.isPlaying)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                  ),

                Positioned(
                  left: 16,
                  right: 76,
                  bottom: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '@${widget.data.usuario}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.data.descripcion,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  right: 12,
                  bottom: 24,
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _liked = !_liked;
                            _likesCount += _liked ? 1 : -1;
                          });
                        },
                        icon: Icon(
                          _liked ? Icons.favorite : Icons.favorite_border,
                          color: _liked ? Colors.redAccent : Colors.white,
                          size: 30,
                        ),
                      ),
                      Text(
                        '$_likesCount',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      const SizedBox(height: 14),
                      const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 28),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.data.comentarios}',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      const SizedBox(height: 14),
                      const Icon(Icons.share, color: Colors.white, size: 28),
                      const SizedBox(height: 4),
                      const Text(
                        'Compartir',
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}