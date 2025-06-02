import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_lang_app/core/utils/profile_image_service.dart';
import 'package:sign_lang_app/features/setting/presentation/manager/add_image_cubit/add_image_cubit.dart';
import 'package:sign_lang_app/features/setting/presentation/manager/add_image_cubit/add_image_state.dart';

class ProfileCircleAvatar extends StatefulWidget {
  const ProfileCircleAvatar({
    super.key,
    required this.currentUserName,
    this.onImageUpdated,
  });
  final String currentUserName;
  final VoidCallback? onImageUpdated;

  @override
  State<ProfileCircleAvatar> createState() => _ProfileCircleAvatarState();
}

class _ProfileCircleAvatarState extends State<ProfileCircleAvatar> {
  String? _localImagePath;

  Future<void> _loadImageUrl() async {
    final url = await ProfileImageService.getProfileImagePath();
    if (mounted) setState(() => _localImagePath = url);
  }

  @override
  void initState() {
    _loadImageUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddImageCubit, AddImageState>(
      listener: (context, state) {
        if (state is AddImageSuccess) {
          _loadImageUrl();
        }
      },
      child: GestureDetector(
        onTap: () {
          if (_localImagePath != null && _localImagePath!.isNotEmpty) {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => ImagePreviewScreen(
                  imageUrl: _localImagePath!,
                  tag: 'profile_image',
                ),
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            );
          }
        },
        child: Hero(
          tag: 'profile_image',
          child: CircleAvatar(
            radius: 40,
            child: _buildImageContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildImageContent() {
    if (_localImagePath != null) {
      try {
        return CachedNetworkImage(
          imageUrl: _localImagePath!,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          errorWidget: (context, url, error) => _buildInitials(),
          placeholder: (context, url) => _buildInitials(),
        );
      } catch (e) {
        log('error $e');
        return _buildInitials();
      }
    }
    return _buildInitials();
  }

  Widget _buildInitials() {
    return Text(
      widget.currentUserName.substring(0, 2).toUpperCase(),
      style: const TextStyle(color: Colors.white, fontSize: 23),
    );
  }
}

class ImagePreviewScreen extends StatelessWidget {
  final String imageUrl;
  final String tag;

  const ImagePreviewScreen({
    super.key,
    required this.imageUrl,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Hero(
            tag: tag,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
