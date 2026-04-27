# 윈도우에서 Flutter 앱으로 확인하는 방법

이 문서는 `mobile-flutter/` 프로젝트를 윈도우에서 앱 형태로 실행해 확인하는 절차를 정리한다. 리눅스에서 실행한 Flutter 웹 서버를 윈도우 브라우저로 보는 방식과 다르게, 윈도우 로컬에 Flutter 개발 환경을 설치한 뒤 데스크톱 앱 또는 Android 에뮬레이터로 실행한다.

## 선택지

윈도우에서 앱처럼 확인하는 방법은 크게 두 가지다.

- 윈도우 데스크톱 앱으로 실행
- Android 에뮬레이터에서 모바일 앱으로 실행

모바일 앱 기준의 화면과 동작을 확인하려면 Android 에뮬레이터 실행을 우선 권장한다. 윈도우 데스크톱 앱 실행은 PC 환경에서 빠르게 화면을 확인하거나 데스크톱 타깃 지원 여부를 점검할 때 사용한다.

## 공통 준비

윈도우 PC에 아래 도구를 설치한다.

- Flutter SDK
- Git
- Android Studio 또는 Visual Studio

설치 후 PowerShell에서 Flutter 상태를 확인한다.

```powershell
flutter doctor
```

`flutter doctor`에서 표시되는 누락 항목을 먼저 해결한다.

## 방법 1: 윈도우 데스크톱 앱으로 실행

윈도우 네이티브 데스크톱 앱 형태로 실행하는 방법이다.

### 추가 준비물

- Visual Studio 2022 Community 또는 Build Tools
- Visual Studio 설치 시 `Desktop development with C++` 워크로드

### 실행 절차

PowerShell에서 프로젝트로 이동한다.

```powershell
cd mongtorydiary\mobile-flutter
```

윈도우 데스크톱 타깃을 활성화한다.

```powershell
flutter config --enable-windows-desktop
```

현재 프로젝트에 `windows/` 타깃이 없다면 한 번 생성한다.

```powershell
flutter create --platforms windows .
```

윈도우 앱으로 실행한다.

```powershell
flutter run -d windows
```

## 방법 2: Android 에뮬레이터에서 실행

모바일 앱 형태에 가장 가깝게 확인하는 방법이다.

### 추가 준비물

- Android Studio
- Android SDK
- Android Emulator
- Android Virtual Device

Android Studio에서 AVD를 생성하고 실행한 뒤 PowerShell에서 장치를 확인한다.

```powershell
flutter devices
```

프로젝트로 이동한다.

```powershell
cd mongtorydiary\mobile-flutter
```

에뮬레이터 장치 ID를 지정해 실행한다.

```powershell
flutter run -d <android-emulator-id>
```

장치가 하나만 잡혀 있다면 아래처럼 실행해도 된다.

```powershell
flutter run
```

## 리눅스 웹 서버로 보는 방식과의 차이

현재 리눅스에서 Flutter 웹 서버를 실행하면 윈도우에서는 브라우저로 접속한다.

```text
http://192.168.75.194:8080/
```

이 방식은 웹 빌드 결과를 보는 것이며, Android나 Windows 앱으로 실행하는 것과 완전히 같지는 않다. 실제 앱 형태로 확인하려면 윈도우에서 Flutter SDK를 설치하고 `windows` 또는 Android 에뮬레이터 타깃으로 실행해야 한다.

## 문제 해결 체크리스트

- `flutter` 명령이 인식되지 않으면 Flutter SDK의 `bin` 경로가 `PATH`에 등록되어 있는지 확인한다.
- `flutter doctor`에서 Visual Studio 항목이 실패하면 `Desktop development with C++` 워크로드 설치 여부를 확인한다.
- Android 에뮬레이터가 보이지 않으면 Android Studio에서 AVD가 실행 중인지 확인한다.
- Android 라이선스 오류가 나오면 아래 명령을 실행한다.

```powershell
flutter doctor --android-licenses
```

- 백엔드 API까지 함께 확인할 경우, 앱이 접근할 수 있는 `API_BASE_URL`을 윈도우 또는 에뮬레이터 기준 주소로 설정해야 한다.
