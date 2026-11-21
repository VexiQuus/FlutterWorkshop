import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterworkshop/l10n/generated/app_localizations.dart';

import '../../Component/DuoSideBackScope/DuoSideBackScope.dart';
import '../../Models/JournalEntry.dart';
import '../Add/AddPage.dart';
import 'DetailPageController.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.entry});

  final JournalEntry entry;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late JournalEntry _entry;

  @override
  void initState() {
    super.initState();
    _entry = widget.entry;
  }

  Future<void> _editEntry() async {
    final updatedEntry = await Navigator.of(context).push<JournalEntry>(
      MaterialPageRoute<JournalEntry>(builder: (_) => AddPage(entry: _entry)),
    );

    if (updatedEntry != null && mounted) {
      setState(() => _entry = updatedEntry);
    }
  }

  @override
  Widget build(BuildContext context) {
    const controller = DetailPageController();
    final date = MaterialLocalizations.of(context)
        .formatShortDate(_entry.createdAt);
    final strings = AppLocalizations.of(context)!;
    final createdOn = strings.createdOnDate(date);

    return PopScope<JournalEntry>(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          controller.goBack(context, _entry);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: !DuoSideBackScope.isEnabled(context),
          leading: DuoSideBackScope.isEnabled(context)
              ? null
              : BackButton(onPressed: () => controller.goBack(context, _entry)),
          title: Text(_entry.title),
          actions: [
            IconButton(
              tooltip: strings.editJournalEntryTooltip,
              onPressed: _editEntry,
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: AspectRatio(
              aspectRatio: 0.7,
              child: Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          createdOn,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _entry.title,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _photo(context),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            child: Text(
                              _entry.note,
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _photo(BuildContext context) {
    final path = _entry.imagePath;
    if (path == null || path.isEmpty) {
      return _photoPlaceholder(context);
    }

    return Image.file(
      File(path),
      height: 140,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _photoPlaceholder(context),
    );
  }

  Widget _photoPlaceholder(BuildContext context) {
    return Container(
      height: 140,
      width: double.infinity,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        Icons.image_outlined,
        size: 36,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
