# 캘린더 TODO와 몽토리 메뉴 사용가이드

## 접속 주소
현재 미니 PC에서 확인할 때는 아래 주소를 사용한다.

- Flutter web: `http://192.168.75.194:30081/`
- 백엔드 API: `http://192.168.75.194:30080`

## 로그인
개발 시드 계정으로 로그인한다.

- 이메일: `user@example.com`
- 비밀번호: `password123!`

## 캘린더에서 TODO 남기기
1. 하단 메뉴에서 `캘린더`를 선택한다.
2. 월간 달력에서 원하는 날짜를 누른다.
3. 아래 날짜 상세 패널의 `TODO` 입력칸에 할 일을 입력한다.
4. `추가` 버튼을 누른다.
5. 완료한 TODO는 체크박스를 눌러 완료 처리한다.
6. 필요 없는 TODO는 삭제 아이콘으로 제거한다.

## 캘린더에서 일기 작성하기
1. 캘린더에서 원하는 날짜를 누른다.
2. 날짜 상세 패널의 `일기` 영역에서 `작성`을 누른다.
3. 열린 일기 작성 화면에서 제목, 내용, 감정, 사진 URL을 입력한다.
4. 저장하면 캘린더의 해당 날짜 요약이 갱신된다.

## 몽토리 메뉴 확인하기
1. 하단 메뉴에서 `몽토리`를 선택한다.
2. `몽토리 컨디션`에서 로그인 사용자와 오늘 기록 상태를 확인한다.
3. `성장 기록`에서 연속 기록, 누적 일기, TODO 완료 현황을 확인한다.
4. `감정 팔레트`에서 현재 사용 가능한 감정 종류를 확인한다.
5. `홈 위젯 미리보기`에서 위젯에 노출할 요약 상태를 확인한다.

## 로컬 실행 명령
백엔드:

```bash
JAVA_HOME=/usr/lib/jvm/java-21-openjdk bash ./mvnw -Dmaven.repo.local=/home/msyeo/workspace/mongtorydiary/.m2 spring-boot:run
```

Flutter web:

```bash
cd mobile-flutter
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 30081 --dart-define=DATA_SOURCE_MODE=remote --dart-define=API_BASE_URL=http://192.168.75.194:30080
```

## 검증 명령
백엔드:

```bash
JAVA_HOME=/usr/lib/jvm/java-21-openjdk bash ./mvnw -Dmaven.repo.local=/home/msyeo/workspace/mongtorydiary/.m2 test
```

Flutter:

```bash
cd mobile-flutter
flutter analyze
flutter test
```

## 현재 제한
- 현재 웹 실행은 Flutter 개발 서버 방식이다.
- 30080/30081 서비스는 systemd 임시 서비스로 띄우며, 재부팅 후 자동 복구되지는 않는다.
- Android/iOS 실제 앱 빌드와 네이티브 위젯은 후속 작업 범위다.
