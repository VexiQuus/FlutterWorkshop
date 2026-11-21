import 'dart:async';

import 'package:flutter/material.dart';
import 'package:itchi_flutter_duo_layout/itchi_flutter_duo_layout.dart';
import 'package:flutterworkshop/l10n/generated/app_localizations.dart';

import '../../Component/JournalDetailContent/JournalDetailContent.dart';
import '../../Component/JournalCard/JournalCard.dart';
import '../../Models/JournalEntry.dart';
import '../Add/AddPage.dart';
import 'HomePageController.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.onLocaleChanged});

  final Future<bool> Function(Locale locale) onLocaleChanged;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomePageController _controller;
  late final List<JournalEntry> _initialEntries;
  bool _isControllerInitialized = false;
  DuoFoldSnapshot? _foldSnapshot;
  JournalEntry? _selectedEntry;
  StreamSubscription<DuoFoldSnapshot>? _foldSubscription;

  bool get _useFullScreenLayout =>
      _foldSnapshot?.isAvailable == true && _foldSnapshot!.wantsTwoPanes;

  @override
  void initState() {
    super.initState();
    _foldSubscription = ItchiDuoFold.snapshots.listen((snapshot) {
      if (mounted) {
        setState(() => _foldSnapshot = snapshot);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isControllerInitialized) {
      return;
    }

    _isControllerInitialized = true;
    final strings = AppLocalizations.of(context)!;
    _initialEntries = [
      JournalEntry(
        title: strings.sampleBeginningTitle,
        note: strings.sampleBeginningNote,
        createdAt: DateTime(2026, 11, 1),
      ),
      JournalEntry(
        title: strings.sampleAfternoonTitle,
        note: strings.sampleAfternoonNote,
        createdAt: DateTime(2026, 11, 2),
      ),
      JournalEntry(
        title: strings.sampleRememberTitle,
        note: strings.sampleRememberNote,
        createdAt: DateTime(2026, 11, 3),
      ),
    ];
    _controller = HomePageController();
    unawaited(_controller.loadEntries(initialEntries: _initialEntries));
  }

  @override
  void dispose() {
    unawaited(_foldSubscription?.cancel());
    _controller.dispose();
    super.dispose();
  }

  String _errorMessage(HomePageError error, AppLocalizations strings) {
    return switch (error.code) {
      HomePageErrorCode.initialEntriesSave => strings.initialEntriesSaveError,
      HomePageErrorCode.storedEntriesNotList =>
        strings.storedEntriesNotListError,
      HomePageErrorCode.readSavedEntries => strings.readSavedEntriesError(
        error.details ?? '',
      ),
      HomePageErrorCode.invalidSavedEntries => strings.invalidSavedEntriesError(
        error.details ?? '',
      ),
      HomePageErrorCode.loadEntries => strings.loadEntriesError(
        error.details ?? '',
      ),
      HomePageErrorCode.preferencesRejectedEntries =>
        strings.preferencesRejectedEntriesError,
      HomePageErrorCode.saveEntries => strings.saveEntriesError(
        error.details ?? '',
      ),
    };
  }

  String _sortOptionLabel(HomePageSortOption option, AppLocalizations strings) {
    return switch (option) {
      HomePageSortOption.nameAscending => strings.sortNameAscending,
      HomePageSortOption.nameDescending => strings.sortNameDescending,
      HomePageSortOption.dateAscending => strings.sortDateAscending,
      HomePageSortOption.dateDescending => strings.sortDateDescending,
    };
  }

  Future<bool?> _confirmDelete(JournalEntry entry) {
    final strings = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.deleteJournalEntryTitle),
        content: Text(strings.deleteJournalEntryConfirmation(entry.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(strings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(strings.delete),
          ),
        ],
      ),
    );
  }

  JournalEntry? _selectedEntryForPane() {
    final selectedEntry = _selectedEntry;
    if (selectedEntry != null && _controller.entries.contains(selectedEntry)) {
      return selectedEntry;
    }
    return _controller.entries.isEmpty ? null : _controller.entries.first;
  }

  Future<void> _editPaneEntry(JournalEntry entry) async {
    final updatedEntry = await Navigator.of(context).push<JournalEntry>(
      MaterialPageRoute<JournalEntry>(builder: (_) => AddPage(entry: entry)),
    );
    if (updatedEntry == null || !mounted) {
      return;
    }
    await _controller.updateEntry(entry, updatedEntry);
    if (mounted) {
      setState(() => _selectedEntry = updatedEntry);
    }
  }

  Widget _buildJournalList(
    AppLocalizations strings, {
    required bool inFullScreenLayout,
    JournalEntry? selectedEntry,
  }) {
    return ListView(
      padding: EdgeInsets.all(inFullScreenLayout ? 12 : 16),
      children: [
        if (_controller.storageError != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              _errorMessage(_controller.storageError!, strings),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            ),
          ),
        if (!inFullScreenLayout) ...[
          Text(
            strings.listPageTitle,
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
        ],
        if (inFullScreenLayout)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                strings.journalEntries,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: _buildSortDropdown(strings, isExpanded: true),
              ),
            ],
          )
        else
          Row(
            children: [
              Expanded(
                child: Text(
                  strings.journalEntries,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              _buildSortDropdown(strings),
            ],
          ),
        for (final entry in _controller.entries)
          Dismissible(
            key: ObjectKey(entry),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              color: Theme.of(context).colorScheme.error,
              child: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.onError,
              ),
            ),
            confirmDismiss: (_) => _confirmDelete(entry),
            onDismissed: (_) => unawaited(_controller.removeEntry(entry)),
            child: JournalCard(
              entry: entry,
              isSelected: inFullScreenLayout && identical(entry, selectedEntry),
              onTap: inFullScreenLayout
                  ? () => setState(() => _selectedEntry = entry)
                  : () => _controller.openDetail(context, entry),
            ),
          ),
      ],
    );
  }

  Widget _buildSortDropdown(
    AppLocalizations strings, {
    bool isExpanded = false,
  }) {
    return DropdownButton<HomePageSortOption>(
      isExpanded: isExpanded,
      value: _controller.sortOption,
      onChanged: (option) {
        if (option != null) {
          _controller.setSortOption(option);
        }
      },
      items: [
        for (final option in HomePageSortOption.values)
          DropdownMenuItem(
            value: option,
            child: Text(_sortOptionLabel(option, strings)),
          ),
      ],
    );
  }

  Widget _buildSelectedEntryPane(
    AppLocalizations strings,
    JournalEntry? selectedEntry,
  ) {
    if (selectedEntry == null) {
      return Center(
        child: Text(strings.selectJournalEntry, textAlign: TextAlign.center),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              tooltip: strings.editJournalEntryTooltip,
              onPressed: () => unawaited(_editPaneEntry(selectedEntry)),
              icon: const Icon(Icons.edit),
            ),
          ),
          Expanded(
            child: Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: JournalDetailContent(
                  entry: selectedEntry,
                  photoHeight: 220,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullScreenLayout(AppLocalizations strings) {
    final selectedEntry = _selectedEntryForPane();
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: _buildJournalList(
            strings,
            inFullScreenLayout: true,
            selectedEntry: selectedEntry,
          ),
        ),
        const VerticalDivider(width: 1, thickness: 1),
        Expanded(
          flex: 7,
          child: _buildSelectedEntryPane(strings, selectedEntry),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: strings.settings,
            onPressed: _controller.isLoading
                ? null
                : () => _controller.openSettings(
                    context,
                    onLocaleChanged: widget.onLocaleChanged,
                    onClearAll: _controller.clearAllEntriesAndPhotos,
                  ),
            icon: const Icon(Icons.settings),
          ),
          title: Text(strings.listPageTitle),
          actions: [
            IconButton(
              tooltip: strings.addJournalEntryTooltip,
              onPressed: _controller.isLoading || _controller.loadError != null
                  ? null
                  : () => _controller.openAdd(context),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: _controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : _controller.loadError != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _errorMessage(_controller.loadError!, strings),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => unawaited(
                          _controller.loadEntries(
                            initialEntries: _initialEntries,
                          ),
                        ),
                        child: Text(strings.retry),
                      ),
                    ],
                  ),
                ),
              )
            : _useFullScreenLayout
            ? _buildFullScreenLayout(strings)
            : _buildJournalList(strings, inFullScreenLayout: false),
      ),
    );
  }
}
