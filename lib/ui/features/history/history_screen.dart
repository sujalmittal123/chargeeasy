import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../providers/session_provider.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  int _selectedFilterIndex = 0; // 0: All, 1: Charging, 2: AC, 3: USB

  @override
  Widget build(BuildContext context) {
    final sessionsAsync = ref.watch(sessionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Charging History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(sessionsProvider),
          ),
        ],
      ),
      body: sessionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading sessions: $err')),
        data: (sessions) {
          // Compute summary metrics
          final count = sessions.length;
          final avgW = count > 0
              ? (sessions.map((s) => s.avgW ?? 0).reduce((a, b) => a + b) / count)
              : 18.5;
          final totalDurMinutes = count > 0
              ? sessions.fold<int>(
                  0,
                  (sum, s) =>
                      sum +
                      (((s.endTs ?? s.startTs) - s.startTs) ~/ 60000),
                )
              : 75;
          final avgDurMins = count > 0 ? (totalDurMinutes ~/ count) : 48;

          return Column(
            children: [
              // Filter chips row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ChoiceChip(
                        label: const Text('All Sessions'),
                        selected: _selectedFilterIndex == 0,
                        onSelected: (_) => setState(() => _selectedFilterIndex = 0),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Fast Charge'),
                        selected: _selectedFilterIndex == 1,
                        onSelected: (_) => setState(() => _selectedFilterIndex = 1),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Wired AC'),
                        selected: _selectedFilterIndex == 2,
                        onSelected: (_) => setState(() => _selectedFilterIndex = 2),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Wireless Pad'),
                        selected: _selectedFilterIndex == 3,
                        onSelected: (_) => setState(() => _selectedFilterIndex = 3),
                      ),
                    ],
                  ),
                ),
              ),

              // Summary Stats Card
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _SummaryItem(title: 'Sessions', value: '$count'),
                    _SummaryItem(title: 'Avg Speed', value: '${avgW.toStringAsFixed(1)} W'),
                    _SummaryItem(title: 'Avg Time', value: '${avgDurMins}m'),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Sessions List or Empty State
              Expanded(
                child: sessions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.battery_charging_full, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              'No charging sessions recorded yet',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Plug in your charger to start automatic session tracking.',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: sessions.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final session = sessions[index];
                          final startDate = DateTime.fromMillisecondsSinceEpoch(session.startTs);
                          final dateStr = DateFormat('MMM d, h:mm a').format(startDate);
                          final durMs = (session.endTs ?? session.startTs) - session.startTs;
                          final durMinutes = durMs ~/ 60000;
                          final endPct = session.endPct ?? session.startPct;

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: (session.peakW ?? 0) >= 15
                                  ? Colors.orange.shade700
                                  : Colors.blueAccent,
                              child: const Icon(Icons.bolt, color: Colors.white, size: 20),
                            ),
                            title: Text(
                              '${session.startPct}% → $endPct%',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('$dateStr · ${durMinutes}m duration'),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${(session.avgW ?? 0).toStringAsFixed(1)} W',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF00E5FF),
                                  ),
                                ),
                                Text(
                                  session.chargerType,
                                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                              ],
                            ),
                            onTap: () => context.push('/session/${session.id}'),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF00E5FF),
              ),
        ),
        const SizedBox(height: 2),
        Text(title, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
