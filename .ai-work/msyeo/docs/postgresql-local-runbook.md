# PostgreSQL 로컬 운영 메모

## 목적
`REQ-20260521-05` 기준으로 백엔드 기본 DB를 SQLite 파일에서 PostgreSQL로 전환했다. SQLite는 `sqlite` 프로필로 남겨 레거시 확인에만 사용한다.

## 현재 기준
- 기본 DB: PostgreSQL
- 기본 URL: `jdbc:postgresql://localhost:5432/mongtorydiary`
- 기본 사용자명: `mongtory`
- 비밀번호: 환경 변수 `SPRING_DATASOURCE_PASSWORD`로만 주입
- 테스트 DB: H2 인메모리, `src/test/resources/application.properties`
- 레거시 SQLite: `SPRING_PROFILES_ACTIVE=sqlite`

## 서버 실행 환경 변수
실제 비밀번호는 문서에 기록하지 않는다. 현재 미니 PC에서는 런타임용 환경 파일을 `/run/mongtorydiary-db.env`에 생성해 두었다. 이 파일은 재부팅 후 사라질 수 있다.

백엔드 실행 시 필요한 값:

```bash
SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/mongtorydiary
SPRING_DATASOURCE_USERNAME=mongtory
SPRING_DATASOURCE_PASSWORD=<로컬 환경에서만 주입>
```

## 로컬 DB 준비 절차
PostgreSQL이 설치되어 있다면 아래 순서로 준비한다.

```bash
sudo systemctl enable --now postgresql.service
```

`mongtorydiary` 데이터베이스와 `mongtory` 사용자를 생성하고 비밀번호를 설정한다. 실제 비밀번호는 저장소 문서나 Git에 남기지 않는다.

현재 Rocky 10.1 미니 PC는 `pg_hba.conf`가 localhost도 ident 인증으로 설정되어 있었다. Spring JDBC의 사용자/비밀번호 접속을 위해 아래 두 줄을 기존 `host all all 127.0.0.1/32 ident`보다 앞에 추가했다.

```text
host    mongtorydiary   mongtory        127.0.0.1/32            scram-sha-256
host    mongtorydiary   mongtory        ::1/128                 scram-sha-256
```

변경 후:

```bash
sudo systemctl reload postgresql.service
```

## 검증
비밀번호를 환경에서 주입한 뒤 연결을 확인한다.

```bash
PGPASSWORD="$SPRING_DATASOURCE_PASSWORD" \
psql -h 127.0.0.1 -U mongtory -d mongtorydiary -Atc 'select current_database(), current_user;'
```

백엔드 테스트는 H2 인메모리 DB로 실행한다.

```bash
JAVA_HOME=/usr/lib/jvm/java-21-openjdk \
bash ./mvnw -Dmaven.repo.local=/home/msyeo/workspace/mongtorydiary/.m2 test
```

## 남은 운영 개선
- Hibernate `ddl-auto=update`는 개발 편의 설정이다. 실제 운영 전에는 Flyway 또는 Liquibase 마이그레이션으로 전환한다.
- SQLite 기존 데이터가 중요해지면 별도 마이그레이션 스크립트를 작성한다.
- systemd 정식 unit을 만들 때는 `/run` 대신 root 전용 env 파일 또는 systemd credential을 사용한다.
