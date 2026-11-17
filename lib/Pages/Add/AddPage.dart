import 'package:flutter/material.dart';

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
  late final AnimationController _snapBackController;
  Animation<double>? _snapBackAnimation;

  bool get _hasUnsavedChanges =>
      _titleController.text.trim() != (widget.entry?.title ?? '') ||
      _noteController.text.trim() != (widget.entry?.note ?? '');

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.entry?.title ?? '';
    _noteController.text = widget.entry?.note ?? '';
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
    final discardChanges = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('Your changes will not be saved. Leave this page?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep editing'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Discard'),
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

  Future<void> _save() async {
    if (_titleController.text.trim().isEmpty) {
      final messenger = ScaffoldMessenger.of(context);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
            content: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Title is missing. Please enter a title before saving.',
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
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  title: Text(widget.entry == null ? 'Add' : 'Edit'),
                ),
                body: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        widget.entry == null ? 'Add' : 'Edit',
                        style: Theme.of(context).textTheme.displayLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _noteController,
                        decoration: const InputDecoration(
                          labelText: 'Note (optional)',
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 5,
                        minLines: 3,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _save,
                        child: Text(
                          widget.entry == null ? 'Save' : 'Save changes',
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
