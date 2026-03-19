import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongtory_diary/application/providers/app_providers.dart';
import 'package:mongtory_diary/application/session/session_state.dart';
import 'package:mongtory_diary/domain/models/emotion_type.dart';
import 'package:mongtory_diary/presentation/widgets/section_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionControllerProvider);
    final emotions = ref.watch(emotionListProvider);
    final dataSourceModeLabel = ref.watch(dataSourceModeLabelProvider);
    final userName = session.status == SessionStatus.signedIn
        ? session.session?.user.nickname ?? '몽토리 사용자'
        : '게스트';
    final userEmail = session.status == SessionStatus.signedIn
        ? session.session?.user.email ?? 'unknown'
        : 'guest';

    return Scaffold(
      appBar: AppBar(title: const Text('몽토리')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          SectionCard(
            title: '현재 사용자',
            description: '$userName 상태로 앱을 탐색 중입니다.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('이메일: $userEmail'),
                const SizedBox(height: 4),
                Text('데이터 소스: $dataSourceModeLabel'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const SectionCard(
            title: '연속 작성 일수',
            description: '스트릭과 보상 현황을 보여주는 영역',
          ),
          const SizedBox(height: 16),
          emotions.when(
            data: (items) => SectionCard(
              title: '감정 통계',
              description: '감정 타입 ${items.length}건을 기준으로 통계 화면을 구성할 수 있습니다.',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: items
                    .map((item) => _EmotionChip(item: item))
                    .toList(),
              ),
            ),
            loading: () => const SectionCard(
              title: '감정 통계',
              description: '감정 타입을 불러오는 중입니다.',
            ),
            error: (error, _) => SectionCard(
              title: '감정 통계',
              description: '감정 타입을 불러오지 못했습니다. $error',
            ),
          ),
          const SizedBox(height: 16),
          const SectionCard(
            title: '위젯 설정',
            description: '홈 위젯에 노출할 요약 정보와 진입 동작을 정하는 영역',
          ),
        ],
      ),
    );
  }
}

class _EmotionChip extends StatelessWidget {
  const _EmotionChip({required this.item});

  final EmotionType item;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('${item.label} (${item.code})'),
    );
  }
}
