import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/incident_provider.dart';
import '../../services/storage_service.dart';
import '../../utils/app_theme.dart';
import '../../utils/validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/category_selector.dart';
import '../../widgets/primary_button.dart';

class SubmitIncidentScreen extends StatefulWidget {
  const SubmitIncidentScreen({super.key});

  @override
  State<SubmitIncidentScreen> createState() => _SubmitIncidentScreenState();
}

class _SubmitIncidentScreenState extends State<SubmitIncidentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  String? _category;
  XFile? _photo;
  Uint8List? _photoBytes;
  bool _categoryError = false;
  bool _uploadingPhoto = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final formOk = _formKey.currentState!.validate();
    if (_category == null) setState(() => _categoryError = true);
    if (!formOk || _category == null) return;

    final provider = context.read<IncidentProvider>();
    final user = context.read<AuthProvider>().appUser!;
    String? imageUrl;

    try {
      if (_photo != null) {
        setState(() => _uploadingPhoto = true);
        imageUrl = await StorageService().uploadIncidentPhoto(
          bytes: _photoBytes!,
          filename: _photo!.name,
          reporterId: user.uid,
        );
      }

      final ok = await provider.submit(
        title: _titleCtrl.text,
        description: _descCtrl.text,
        category: _category!,
        location: _locationCtrl.text,
        reporter: user,
        imageUrl: imageUrl,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ok ? 'Report submitted' : (provider.error ?? 'Submission failed'),
          ),
        ),
      );
      if (ok) Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not upload the photo. Check your connection and upload configuration.',
          ),
        ),
      );
      debugPrint('Incident photo upload failed: $error');
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
    }
  }

  Future<void> _pickPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1600,
      );
      if (picked == null) return;

      final bytes = await picked.readAsBytes();
      if (mounted) {
        setState(() {
          _photo = picked;
          _photoBytes = bytes;
        });
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not read the selected photo.')),
      );
      debugPrint('Incident photo selection failed: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final submitting =
        context.watch<IncidentProvider>().submitting || _uploadingPhoto;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Center(child: Text('Report an Incident')),
        actions: const [SizedBox(width: 56)],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select a category',
                      style: TextStyle(
                        color: AppTheme.secondary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CategorySelector(
                      selected: _category,
                      errorText: _categoryError
                          ? 'Please select a category'
                          : null,
                      onSelected: (c) => setState(() {
                        _category = c;
                        _categoryError = false;
                      }),
                    ),
                    const SizedBox(height: 20),
                    AppTextField(
                      controller: _titleCtrl,
                      label: 'Title',
                      icon: Icons.edit_note_rounded,
                      hintText: 'Briefly describe the issue...',
                      fillColor: Colors.white,
                      focusedBorderColor: AppTheme.primary,
                      prefixIconColor: AppTheme.secondary,
                      borderRadius: 16,
                      validator: (v) => Validators.minLength(v, 'Title', 5),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _descCtrl,
                      label: 'Description',
                      icon: Icons.subject_rounded,
                      hintText: 'Provide more details about the issue...',
                      fillColor: Colors.white,
                      focusedBorderColor: AppTheme.primary,
                      prefixIconColor: AppTheme.secondary,
                      borderRadius: 16,
                      maxLines: 5,
                      validator: (v) =>
                          Validators.minLength(v, 'Description', 10),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _locationCtrl,
                      label: 'Location',
                      icon: Icons.location_on_outlined,
                      hintText: 'Where did this happen?',
                      fillColor: Colors.white,
                      focusedBorderColor: AppTheme.primary,
                      prefixIconColor: AppTheme.secondary,
                      borderRadius: 16,
                      validator: (v) => Validators.required(v, 'Location'),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Photo (optional)',
                      style: TextStyle(
                        color: AppTheme.secondary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_photo == null)
                      OutlinedButton.icon(
                        onPressed: submitting ? null : _pickPhoto,
                        icon: const Icon(Icons.add_photo_alternate_outlined),
                        label: const Text('Attach a photo'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(68),
                          foregroundColor: AppTheme.secondary,
                          side: const BorderSide(color: Color(0xFFD8DCEC)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      )
                    else
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Stack(
                          children: [
                            Image.memory(
                              _photoBytes!,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton.filled(
                                onPressed: submitting
                                    ? null
                                    : () => setState(() {
                                        _photo = null;
                                        _photoBytes = null;
                                      }),
                                icon: const Icon(Icons.delete_outline_rounded),
                                tooltip: 'Remove photo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: 'Submit Report',
                      onPressed: _submit,
                      loading: submitting,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
