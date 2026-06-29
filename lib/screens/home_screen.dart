import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plantid/core/theme.dart';
import 'package:plantid/providers/connectivity_provider.dart';
import 'package:plantid/providers/scan_provider.dart';
import 'package:plantid/screens/camera_screen.dart';
import 'package:plantid/screens/result_screen.dart';
import 'package:plantid/widgets/offline_banner.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;

  Future<void> _navigateToResult(String imagePath) async {
    setState(() => _isProcessing = true);

    // Reset scan provider state before starting new identification
    ref.read(scanProvider.notifier).reset();

    if (mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(imagePath: imagePath),
        ),
      );
    }

    if (mounted) {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _handleScan(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take Photo'),
              onTap: () async {
                Navigator.pop(context);
                final status = await Permission.camera.request();
                if (status.isGranted) {
                  if (mounted) {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CameraScreen()),
                    );
                    if (result != null && mounted) {
                      _navigateToResult(result as String);
                    }
                  }
                } else if (status.isPermanentlyDenied) {
                  _showPermissionDialog();
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);

                PermissionStatus status;
                if (Platform.isAndroid) {
                  // For Android 13+ we should check READ_MEDIA_IMAGES
                  status = await Permission.photos.request();
                  if (status.isDenied) {
                    // Fallback for older Android
                    status = await Permission.storage.request();
                  }
                } else {
                  status = await Permission.photos.request();
                }

                if (status.isGranted || status.isLimited) {
                  try {
                    final XFile? image = await _picker.pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 1800,
                      maxHeight: 1800,
                      imageQuality: 85,
                    );
                    if (image != null && mounted) {
                      _navigateToResult(image.path);
                    }
                  } catch (e) {
                    debugPrint('Error picking image: $e');
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error picking image: $e')),
                      );
                    }
                  }
                } else if (status.isPermanentlyDenied) {
                  _showPermissionDialog();
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gallery permission denied')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text('This app needs camera and gallery permissions to identify plants. Please enable them in settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final connectivity = ref.watch(connectivityProvider);
    final isOffline = connectivity.value == ConnectivityStatus.isDisconnected;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              if (isOffline) const OfflineBanner(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(
                          Icons.eco,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'PlantID',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Point. Identify. Grow.',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 60),
                      Tooltip(
                        message: isOffline ? 'Internet connection required to scan' : '',
                        child: ElevatedButton(
                          onPressed: isOffline ? null : () => _handleScan(context),
                          child: const Text('Scan a Plant'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Processing image...',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
