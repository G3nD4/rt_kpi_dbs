import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class LogEntry {
  final DateTime timestamp;
  final String message;

  LogEntry(this.message) : timestamp = DateTime.now();

  @override
  String toString() => '$timestamp\n$message';
}

class Logger {
  Logger._internal();

  static final Logger instance = Logger._internal();

  final List<LogEntry> _logs = [];
  final StreamController<List<LogEntry>> _controller =
      StreamController<List<LogEntry>>.broadcast();

  void init() {
    log('Logger initialized');
  }

  void log(String message) {
    final entry = LogEntry(message);
    _logs.add(entry);
    _controller.add(List.unmodifiable(_logs));
    debugPrint(entry.toString());
  }

  List<LogEntry> get logs => List.unmodifiable(_logs.reversed);

  Stream<List<LogEntry>> get onLogs => _controller.stream;

  void clear() {
    _logs.clear();
    _controller.add(List.unmodifiable(_logs));
  }

  void dispose() {
    _controller.close();
  }
}

class LoggerProvider extends InheritedWidget {
  final Logger logger;

  const LoggerProvider({required this.logger, required super.child, super.key});

  static LoggerProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LoggerProvider>();
  }

  @override
  bool updateShouldNotify(covariant LoggerProvider oldWidget) =>
      logger != oldWidget.logger;
}

class GlobalLoggerButton extends StatelessWidget {
  const GlobalLoggerButton({super.key});

  void _openViewer(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const LogViewer()));
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _openViewer(context),
      child: const Icon(Icons.note),
    );
  }
}

class LogViewer extends StatefulWidget {
  const LogViewer({super.key});

  @override
  State<LogViewer> createState() => _LogViewerState();
}

class _LogViewerState extends State<LogViewer> {
  final ScrollController _scroll = ScrollController();
  final TextEditingController _search = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _search.addListener(() {
      setState(() => _query = _search.text.trim());
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    _search.dispose();
    super.dispose();
  }

  void _copyAll(List<LogEntry> logs) {
    final text = logs.join('\n');
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied all logs to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_all),
            tooltip: 'Copy all',
            onPressed: () {
              _copyAll(Logger.instance.logs.toList());
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Clear',
            onPressed: () => Logger.instance.clear(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              controller: _search,
              decoration: InputDecoration(
                hintText: 'Filter logs',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _search.clear(),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                isDense: true,
                filled: true,
                fillColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<LogEntry>>(
        stream: Logger.instance.onLogs,
        initialData: Logger.instance.logs,
        builder: (context, snapshot) {
          final List<LogEntry> logs = snapshot.data ?? [];
          final List<LogEntry> display = logs
              .toList()
              .where(
                (logEntry) =>
                    _query.isEmpty ||
                    logEntry.message.toLowerCase().contains(
                      _query.toLowerCase(),
                    ),
              )
              .toList();

          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (_scroll.hasClients) {
              _scroll.animateTo(
                0.0,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
              );
            }
          });

          if (display.isEmpty) {
            return const Center(child: Text('No logs'));
          }

          return ListView.separated(
            controller: _scroll,
            padding: const EdgeInsets.all(8),
            itemCount: display.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final entry = display[i];
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      spacing: 6.0,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry.timestamp.toString(),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(text: entry.message),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Copied log entry'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Text(
                          entry.message,
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
