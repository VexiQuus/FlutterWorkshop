import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterworkshop/l10n/generated/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Models/JournalEntry.dart';
import 'AddPageController.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key, this.entry});

  final JournalEntry? entry;

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _controller = const AddPageController();
  bool _allowPop = false;
  bool _isConfirmingExit = false;
  double _dragOffset = 0;
  String? _imagePath;
  late final AnimationController _snapBackController;
  Animation<double>? _snapBackAnimation;

  bool get _hasUnsavedChanges =>
      _titleController.text.trim() != (widget.entry?.title ?? '') ||
      _noteController.text.trim() != (widget.entry?.note ?? '') ||
      _imagePath != widget.entry?.imagePath;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.entry?.title ?? '';
    _noteController.text = widget.entry?.note ?? '';
    _imagePath = widget.entry?.imagePath;
    _snapBackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    )..addListener(_updateSnapBack);
    _titleController.addListener(_onFieldChanged);
    _noteController.addListener(_onFieldChanged);
  }

  void _updateSnapBack() {
    final animation = _snapBackAnimation;
    if (animation != null) {
      setState(() => _dragOffset = animation.value);
    }
  }

  void _onFieldChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.removeListener(_onFieldChanged);
    _noteController.removeListener(_onFieldChanged);
    _snapBackController.dispose();
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _requestExit() async {
    if (_isConfirmingExit) {
      return;
    }

    if (!_hasUnsavedChanges) {
      Navigator.of(context).pop();
      return;
    }

    _isConfirmingExit = true;
    final strings = AppLocalizations.of(context)!;
    final discardChanges = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.discardChangesTitle),
        content: Text(strings.discardChangesConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(strings.keepEditing),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(strings.discard),
          ),
        ],
      ),
    );
    _isConfirmingExit = false;

    if (discardChanges == true && mounted) {
      setState(() => _allowPop = true);
      await WidgetsBinding.instance.endOfFrame;
      if (mounted) {
        Navigator.of(context).pop();
      }
    } else if (mounted && _dragOffset > 0) {
      await _animateSwipeBack();
    }
  }

  void _handleSwipeUpdate(DragUpdateDetails details) {
    final nextOffset = _dragOffset + details.delta.dx;
    setState(() {
      _dragOffset = nextOffset.clamp(0, MediaQuery.sizeOf(context).width);
    });
  }

  void _handleSwipe(DragEndDetails details) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    if (_dragOffset > screenWidth * 0.3 ||
        (details.primaryVelocity ?? 0) > 700) {
      _requestExit();
    } else {
      _animateSwipeBack();
    }
  }

  Future<void> _animateSwipeBack() async {
    _snapBackAnimation = Tween<double>(begin: _dragOffset, end: 0).animate(
      CurvedAnimation(parent: _snapBackController, curve: Curves.easeOutCubic),
    );
    await _snapBackController.forward(from: 0);
    if (mounted) {
      setState(() => _dragOffset = 0);
    }
  }

  Future<void> _pickImage() async {
    final strings = AppLocalizations.of(context)!;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(strings.chooseFromGallery),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(strings.takePhoto),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source == null || !mounted) {
      return;
    }

    final permission = source == ImageSource.camera
        ? Permission.camera
        : Permission.photos;
    var status = await permission.status;
    if (!status.isGranted && !status.isLimited) {
      status = await permission.request();
    }

    if (!status.isGranted && !status.isLimited) {
      if (mounted) {
        await _showPermissionDialog(
          source == ImageSource.camera
              ? strings.cameraPermissionName
              : strings.photoLibraryPermissionName,
        );
      }
      return;
    }

    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image != null && mounted) {
        final directory = await getApplicationDocumentsDirectory();
        final extension = image.name.contains('.')
            ? image.name.split('.').last
            : 'jpg';
        final savedImage = await File(image.path).copy(
          '${directory.path}${Platform.pathSeparator}'
          'journal_${DateTime.now().microsecondsSinceEpoch}.$extension',
        );
        if (mounted) {
          setState(() => _imagePath = savedImage.path);
        }
      }
    } on PlatformException catch (error) {
      _showImageError(strings.selectImageError(error.message ?? error.code));
    } on FileSystemException catch (error) {
      _showImageError(strings.saveImageError(error.message));
    } on Exception catch (error) {
      _showImageError(strings.saveImageError(error.toString()));
    }
  }

  void _showImageError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
    }
  }

  Future<void> _showPermissionDialog(String permissionName) async {
    final strings = AppLocalizations.of(context)!;
    final openSettings = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.permissionRequiredTitle),
        content: Text(strings.photoPermissionExplanation(permissionName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(strings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(strings.openSettings),
          ),
        ],
      ),
    );

    if (openSettings == true) {
      final didOpenSettings = await openAppSettings();
      if (!didOpenSettings && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(strings.openAppSettingsError)));
      }
    }
  }

  Future<void> _save() async {
    final strings = AppLocalizations.of(context)!;
    if (_titleController.text.trim().isEmpty) {
      final messenger = ScaffoldMessenger.of(context);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    strings.missingTitleError,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _allowPop = true);
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) {
      return;
    }

    _controller.save(
      context,
      title: _titleController.text.trim(),
      note: _noteController.text.trim(),
      existingEntry: widget.entry,
      imagePath: _imagePath,
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return PopScope<Object?>(
      canPop: _allowPop || !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _requestExit();
        }
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: ColoredBox(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Icon(Icons.arrow_back),
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(_dragOffset, 0),
            child: GestureDetector(
              onHorizontalDragUpdate: _handleSwipeUpdate,
              onHorizontalDragEnd: _handleSwipe,
              onHorizontalDragCancel: _animateSwipeBack,
              child: Scaffold(
                appBar: AppBar(
                  leading: BackButton(onPressed: _requestExit),
                  title: Text(
                    widget.entry == null ? strings.add : strings.edit,
                  ),
                ),
                body: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        widget.entry == null ? strings.add : strings.edit,
                        style: Theme.of(context).textTheme.displayLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: strings.title,
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return strings.titleRequiredError;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _noteController,
                        decoration: InputDecoration(
                          labelText: strings.optionalNote,
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 5,
                        minLines: 3,
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.add_a_photo),
                        label: Text(strings.addPhoto),
                      ),
                      if (_imagePath != null) ...[
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_imagePath!),
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                                  child: Text(strings.selectedImageUnavailable),
                                ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _save,
                        child: Text(
                          widget.entry == null
                              ? strings.save
                              : strings.saveChanges,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
