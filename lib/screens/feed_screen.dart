import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/video_item.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  static const _videos = <VideoData>[
    VideoData(
      url: 'videos/video1.mp4',
      usuario: 'paisajes_col',
      descripcion: 'Vista de la playa y el mar #paisajes #playa',
      likes: 1280,
      comentarios: 94,
    ),
    VideoData(
      url: 'videos/video2.mp4',
      usuario: 'naturaleza_viva',
      descripcion: 'Flores silvestres bajo el cielo #naturaleza #paz',
      likes: 864,
      comentarios: 41,
    ),
    VideoData(
      url: 'videos/video3.mp4',
      usuario: 'rutas_del_mar',
      descripcion: 'Muelle frente al horizonte #viajes #mar',
      likes: 2310,
      comentarios: 157,
    ),
    VideoData(
      url: 'videos/video4.mp4',
      usuario: 'atardecer_caribe',
      descripcion: 'Palmera al atardecer #atardecer #caribe',
      likes: 1945,
      comentarios: 112,
    ),
  ];

  int _actual = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          // Botón de logout con el nombre o correo del usuario autenticado.
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.userChanges(),
            builder: (context, snap) {
              final u = snap.data ?? FirebaseAuth.instance.currentUser;
              final etiqueta = (u?.displayName?.isNotEmpty ?? false)
                  ? u!.displayName!
                  : (u?.email ?? 'Usuario');
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black38,
                  ),
                  onPressed: () => AuthService().logout(),
                  icon: const Icon(Icons.logout, size: 18),
                  label: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 160),
                    child: Text(etiqueta, overflow: TextOverflow.ellipsis),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _videos.length,
        onPageChanged: (i) => setState(() => _actual = i),
        itemBuilder: (context, i) => VideoItem(data: _videos[i]),
      ),
    );
  }
}