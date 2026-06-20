import 'package:flutter/material.dart';
import '../../../shared/widgets/placeholder_screen.dart';

/// Quiz ekranı.
/// TODO: Backend entegrasyonu — soru setleri ve puan sistemi API'den gelecek.
class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: Column(
        children: [
          // Puan / streak banner
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_fire_department_rounded, size: 28),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('3 Günlük Seri!', style: theme.textTheme.titleMedium),
                    Text(
                      'Bugün de bir quiz çöz',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // TODO: Backend entegrasyonu — toplam puan
                Text(
                  '240 puan',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.tertiary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const Expanded(
            child: PlaceholderScreen(
              title: 'Öğrenirken Eğlen',
              description:
                  'Bedenin ve sağlığın hakkında eğlenceli quizler çöz, rozetler kazan.',
              icon: Icons.emoji_events_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
