import 'package:flutter/material.dart';
import 'package:flutterworkshop/l10n/generated/app_localizations.dart';

import '../../Component/DuoSideBackScope/DuoSideBackScope.dart';
import '../../Component/JournalDetailContent/JournalDetailContent.dart';
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
    final strings = AppLocalizations.of(context)!;

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
                  child: JournalDetailContent(entry: _entry),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
