{{flutter_js}}
{{flutter_build_config}}

const bootScreen = document.querySelector('#mongtory-boot');
const bootStatus = document.querySelector('#mongtory-boot-status');
const bootDetail = document.querySelector('#mongtory-boot-detail');
const bootBar = document.querySelector('#mongtory-boot-bar');

let bootCompleted = false;

function setBootProgress(percent, status, detail) {
  if (bootStatus) {
    bootStatus.textContent = status;
  }

  if (bootDetail) {
    bootDetail.textContent = detail;
  }

  if (bootBar) {
    bootBar.style.width = `${percent}%`;
  }
}

function completeBoot() {
  if (bootCompleted) {
    return;
  }

  bootCompleted = true;
  setBootProgress(100, '몽토리를 여는 중입니다.', '잠시 후 일기 화면으로 이동합니다.');
  window.setTimeout(() => bootScreen?.classList.add('is-complete'), 240);
}

setBootProgress(18, '앱 파일을 내려받는 중입니다.', '일기 화면에 필요한 구성요소를 불러오고 있습니다.');

window.addEventListener('flutter-first-frame', completeBoot, {once: true});

_flutter.loader.load({
  onEntrypointLoaded: async function(engineInitializer) {
    setBootProgress(58, '화면 엔진을 초기화하는 중입니다.', '달력, 일기, 몽토리 화면을 준비하고 있습니다.');
    const appRunner = await engineInitializer.initializeEngine();

    setBootProgress(86, '데이터 연결을 확인하는 중입니다.', '저장된 일기와 TODO를 불러올 준비를 하고 있습니다.');
    await appRunner.runApp();

    window.setTimeout(completeBoot, 600);
  },
});
