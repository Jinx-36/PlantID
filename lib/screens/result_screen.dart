import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantid/core/theme.dart';
import 'package:plantid/models/scan_record.dart';
import 'package:plantid/providers/history_provider.dart';
import 'package:plantid/providers/scan_provider.dart';
import 'package:plantid/services/image_service.dart';
import 'package:plantid/widgets/care_tile.dart';
import 'package:plantid/widgets/confidence_badge.dart';

class ResultScreen extends ConsumerStatefulWidget {
  final String imagePath;
  final ScanRecord? existingRecord;

  const ResultScreen({
    super.key,
    required this.imagePath,
    this.existingRecord,
  });

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.existingRecord == null) {
      Future.microtask(() => ref.read(scanProvider.notifier).identifyPlant(widget.imagePath));
    }
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(scanProvider);

    if (widget.existingRecord != null) {
      return _buildContent(
        context,
        imagePath: widget.existingRecord!.imagePath,
        commonName: widget.existingRecord!.commonName,
        scientificName: widget.existingRecord!.scientificName,
        confidence: widget.existingRecord!.confidence,
        watering: widget.existingRecord!.careAdvice.watering,
        sunlight: widget.existingRecord!.careAdvice.sunlight,
        soil: widget.existingRecord!.careAdvice.soil,
        description: widget.existingRecord!.careAdvice.description,
        isFromApi: false,
      );
    }

    if (scanState.isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: AppTheme.primaryGreen),
              const SizedBox(height: 20),
              Text(
                'Identifying plant...',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      );
    }

    if (scanState.error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: AppTheme.error),
                const SizedBox(height: 16),
                Text(
                  scanState.error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => ref.read(scanProvider.notifier).identifyPlant(widget.imagePath),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (scanState.result != null && scanState.careAdvice != null) {
      return _buildContent(
        context,
        imagePath: scanState.result!.imageUrl ?? widget.imagePath,
        commonName: scanState.result!.commonName,
        scientificName: scanState.result!.scientificName,
        confidence: scanState.result!.confidence,
        watering: scanState.careAdvice!.watering,
        sunlight: scanState.careAdvice!.sunlight,
        soil: scanState.careAdvice!.soil,
        description: scanState.careAdvice!.description,
        isFromApi: scanState.result!.imageUrl != null,
      );
    }

    return const Scaffold();
  }

  Widget _buildContent(
    BuildContext context, {
    required String imagePath,
    required String commonName,
    required String scientificName,
    required double confidence,
    required String watering,
    required String sunlight,
    required String soil,
    required String description,
    required bool isFromApi,
  }) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
                  child: isFromApi
                      ? CachedNetworkImage(
                          imageUrl: imagePath,
                          height: 260,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 260,
                            color: AppTheme.surface,
                            child: const Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => Image.file(
                            File(widget.imagePath),
                            height: 260,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.file(
                          File(imagePath),
                          height: 260,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              commonName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              scientificName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ConfidenceBadge(confidence: confidence),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Care Guide',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      CareTile(title: 'Watering', value: watering, icon: Icons.water_drop_outlined),
                      CareTile(title: 'Sunlight', value: sunlight, icon: Icons.wb_sunny_outlined),
                      CareTile(title: 'Soil', value: soil, icon: Icons.terrain_outlined),
                      CareTile(title: 'Description', value: description, icon: Icons.info_outline),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Center(
                    child: Text(
                      'Saved to History',
                      style: TextStyle(color: AppTheme.success, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
