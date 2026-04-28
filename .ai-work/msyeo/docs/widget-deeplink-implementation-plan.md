# 위젯/딥링크 구현 요청 분해

## 목적
`REQ-20260428-36` 기준으로 기존 위젯/딥링크 1차 설계와 BE `REQ-20260428-34` 오늘/위젯 요약 API 구현 결과를 바탕으로 다음 실행 요청을 분리한다.

## 현재 확정된 선행 조건
- BE는 `GET /api/v1/widgets/today-summary?date=YYYY-MM-DD`를 구현했다.
- 오늘/위젯 요약 API는 인증 사용자 소유 일기만 집계한다.
- 동일 날짜 다건은 `updatedAt` 최신 일기를 대표 일기로 선택한다.
- 응답 필드는 `date`, `hasTodayEntry`, `todayEntryCount`, `latestDiaryId`, `latestDiaryTitle`, `latestEmotionCode`, `streakDays`, `lastEntryDate`, `message`, `updatedAt`이다.
- Flutter 앱은 일기 목록/상세/작성/수정/삭제와 캘린더 날짜 탭 진입 플로우를 갖고 있다.

## MVP 포함 범위
1. Flutter 딥링크 라우터 1차 구현
   - 홈, 일기 작성 날짜, 일기 상세, 캘린더 날짜 진입을 처리한다.
   - 세션이 없으면 로그인 후 원래 진입 의도를 이어갈 수 있는 최소 구조를 둔다.
   - 네이티브 platform link 설정은 이 단계에서 직접 수정하지 않고 Flutter 내부 라우팅과 테스트를 먼저 고정한다.

2. 앱 내부 위젯 요약 모델과 갱신 책임 정리
   - BE today-summary 응답을 Flutter DTO/model로 받을 수 있게 한다.
   - 홈 진입, 일기 CRUD 성공, 캘린더 새로고침 이후 요약 갱신 진입점을 정한다.
   - Android/iOS 공유 저장소 쓰기는 네이티브 shell 결정 전까지 interface 또는 adapter 경계로 둔다.

3. QA 검증 계획
   - BE today-summary 실제 서버 검증을 포함한다.
   - Flutter 딥링크 라우팅은 widget test 또는 수동 시나리오로 검증한다.
   - 네이티브 위젯은 shell 결정 후 별도 검증 요청으로 분리한다.

## 후속 버전 또는 별도 결정 범위
- Android App Widget 또는 Glance 선택과 `mobile-flutter/android` 변경
- iOS WidgetKit, App Group, 공유 저장소 설정과 `mobile-flutter/ios` 변경
- 위젯 이미지, 캐릭터 애니메이션, background refresh 최적화
- 월간 캘린더 위젯과 감정 통계 위젯

## 신규 요청 분해
| 요청 ID | 대상 | 우선순위 | 제목 | 핵심 범위 |
| --- | --- | --- | --- | --- |
| REQ-20260428-37 | QA | P1 | 오늘/위젯 요약 API 실제 서버 회귀 검증 | 실제 서버 today-summary 검증 |
| REQ-20260428-38 | FE | P1 | Flutter 딥링크 라우터 1차 구현 | 홈, 작성, 상세, 캘린더 날짜 route 처리와 widget test |
| REQ-20260428-39 | FE | P1 | 위젯 요약 데이터 앱 연동 경계 구현 | today-summary DTO/model, repository, 갱신 트리거, 저장 adapter 경계 |
| REQ-20260428-40 | PM | P2 | 네이티브 위젯 shell 범위 결정 | Android/iOS 플랫폼 변경 범위와 구현 요청 분리 |

## 실행 순서
1. QA `REQ-20260428-37`이 BE today-summary API를 실제 서버 기준으로 검증한다.
2. FE `REQ-20260428-38`이 Flutter 내부 딥링크 route를 먼저 고정한다.
3. FE `REQ-20260428-39`가 today-summary 연동 경계와 앱 내부 요약 갱신 책임을 구현한다.
4. PM `REQ-20260428-40`은 FE/QA 결과를 확인한 뒤 Android/iOS 네이티브 shell 구현 요청을 별도 ID로 분리한다.

## 리스크
- 현재 FE 공식 요청 `REQ-20260428-33`이 작성 화면 잔여 UX를 다루고 있어 `diary_edit_screen.dart` 변경 충돌 가능성이 있다.
- 네이티브 위젯 shell은 FE 담당 기본 경로를 넘어 `mobile-flutter/android`, `mobile-flutter/ios`를 건드릴 수 있으므로 PM 승인 요청으로 분리한다.
- iOS WidgetKit 공유 저장소와 Android App Widget/Glance 선택은 로컬 빌드 환경과 플랫폼 설정 확인이 필요하다.
