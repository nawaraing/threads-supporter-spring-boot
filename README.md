# Threads Supporter

Threads API를 활용한 소셜 미디어 자동 포스팅 서비스입니다.

## 프로젝트 소개

**Threads Supporter**는 Meta의 Threads 플랫폼에 예약 포스팅을 자동화하는 웹 애플리케이션입니다. 사용자가 설정한 요일과 시간에 맞춰 자동으로 글을 발행하여 브랜딩 및 마케팅 업무의 효율성을 높여줍니다.

### 주요 기능

- **OAuth 2.0 로그인**: Threads 계정을 통한 안전한 소셜 로그인
- **예약 포스팅**: 원하는 요일/시간에 자동 발행 (텍스트, 이미지, 캐러셀 지원)
- **반복 발행**: 매일/특정 요일 반복 또는 일회성 발행 선택
- **통계 대시보드**: Threads Insights API를 통한 조회수 분석
- **모바일 최적화**: 반응형 UI로 모바일 환경에서도 편리하게 사용

## 기술 스택

### Backend
- **Framework**: Spring Boot 4.0.1
- **Language**: Java 17
- **ORM**: Spring Data JPA (Hibernate)
- **Security**: Spring Security
- **HTTP Client**: WebFlux WebClient
- **Scheduler**: Spring @Scheduled

### Frontend
- **View**: JSP + JSTL
- **Styling**: Custom CSS (Mobile-first Design)
- **Chart**: Chart.js

### Database
- **PostgreSQL** (Supabase)

### Infrastructure
- **Cloud**: Oracle Cloud
- **Container**: Docker
- **Domain**: DuckDNS

## 시스템 아키텍처

```
┌─────────────────────────────────────────────────────────────┐
│                        Client                                │
│                    (Mobile / Web)                            │
└─────────────────────┬───────────────────────────────────────┘
                      │ HTTPS
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                   Spring Boot Application                    │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │ Controllers │  │  Services   │  │     Scheduler       │  │
│  │  (MVC/API)  │  │             │  │  (Cron: 0/5 * * *)  │  │
│  └──────┬──────┘  └──────┬──────┘  └──────────┬──────────┘  │
│         │                │                     │             │
│         └────────────────┼─────────────────────┘             │
│                          ▼                                   │
│              ┌───────────────────────┐                       │
│              │    Spring Data JPA    │                       │
│              └───────────┬───────────┘                       │
└──────────────────────────┼──────────────────────────────────┘
                           │
          ┌────────────────┼────────────────┐
          ▼                                 ▼
┌──────────────────┐              ┌──────────────────┐
│   PostgreSQL     │              │   Threads API    │
│   (Supabase)     │              │   (Meta Graph)   │
└──────────────────┘              └──────────────────┘
```

## 프로젝트 구조

```
src/main/java/com/junkang/threads_supporter/
├── config/
│   ├── SecurityConfig.java       # Spring Security 설정
│   ├── SchedulerConfig.java      # 스케줄러 활성화
│   ├── WebClientConfig.java      # WebClient 설정
│   └── WebMvcConfig.java         # JSP 뷰 리졸버
├── controller/
│   ├── AuthController.java       # OAuth 로그인/로그아웃
│   ├── ScheduledPostController.java  # 예약 포스트 페이지
│   ├── InsightsController.java   # 통계 페이지
│   ├── ProfileController.java    # 프로필 페이지
│   └── api/
│       └── ScheduledPostApiController.java  # REST API
├── entity/
│   ├── User.java                 # 사용자 엔티티
│   ├── ScheduledPost.java        # 예약 포스트 엔티티
│   └── PostLog.java              # 발행 로그 엔티티
├── repository/
│   ├── UserRepository.java
│   ├── ScheduledPostRepository.java
│   └── PostLogRepository.java
├── service/
│   ├── ThreadsOAuthService.java  # OAuth 토큰 교환
│   ├── ThreadsApiService.java    # Threads API 호출
│   ├── UserService.java
│   ├── ScheduledPostService.java
│   └── PostLogService.java
├── scheduler/
│   └── PostPublisherScheduler.java  # 자동 발행 스케줄러
└── dto/
    ├── request/
    └── response/

src/main/webapp/WEB-INF/views/
├── auth/login.jsp        # 로그인 페이지
├── posts/list.jsp        # 예약 포스트 목록
├── insights/index.jsp    # 통계 대시보드
└── profile/index.jsp     # 프로필 페이지
```

## 데이터베이스 스키마

```sql
-- 사용자 테이블
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    threads_user_id VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(255),
    access_token TEXT,
    token_expires_at TIMESTAMP,
    profile_picture_url TEXT,
    follower_count INTEGER,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- 예약 포스트 테이블
CREATE TABLE scheduled_posts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    days_of_week INTEGER[],  -- 0=일, 1=월, ..., 6=토
    hour INTEGER NOT NULL,
    minute INTEGER NOT NULL,
    content VARCHAR(500) NOT NULL,
    image_urls TEXT[],
    is_active BOOLEAN DEFAULT TRUE,
    is_recurring BOOLEAN DEFAULT TRUE,
    last_posted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- 발행 로그 테이블
CREATE TABLE post_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    scheduled_post_id UUID REFERENCES scheduled_posts(id),
    user_id UUID REFERENCES users(id),
    threads_post_id VARCHAR(255),
    status VARCHAR(20),  -- 'success' | 'failed'
    error_message TEXT,
    posted_at TIMESTAMP DEFAULT NOW()
);
```

## 실행 방법

### 환경 변수 설정

```bash
# .env 파일 생성
DB_PASSWORD=your_database_password
THREADS_CLIENT_SECRET=your_threads_client_secret
```

### 로컬 실행

```bash
# 의존성 설치 및 빌드
./gradlew build

# 애플리케이션 실행
./gradlew bootRun
```

### Docker 실행

```bash
# 이미지 빌드
docker build -t threads-supporter .

# 컨테이너 실행
docker run -d \
  -p 8080:8080 \
  -e DB_PASSWORD=your_password \
  -e THREADS_CLIENT_SECRET=your_secret \
  threads-supporter
```

## API 엔드포인트

### 인증
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/auth/login` | 로그인 페이지 |
| GET | `/auth/threads` | Threads OAuth 시작 |
| GET | `/auth/callback` | OAuth 콜백 처리 |
| GET | `/auth/logout` | 로그아웃 |

### 예약 포스트
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/posts` | 예약 포스트 목록 |
| GET | `/api/posts/{id}` | 포스트 상세 조회 |
| POST | `/api/posts` | 포스트 생성 |
| PUT | `/api/posts/{id}` | 포스트 수정 |
| DELETE | `/api/posts/{id}` | 포스트 삭제 |
| POST | `/api/posts/{id}/toggle` | 활성화 토글 |

### 통계
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/insights` | 통계 대시보드 |

## 스크린샷

### 로그인 페이지
모바일 앱 스타일의 깔끔한 로그인 화면

### 예약 포스트 목록
- 요일/시간별 필터링
- 최근 수정순/시간순 정렬
- 토글 스위치로 활성화/비활성화

### 통계 대시보드
- 기간별 총 조회수
- 일별 조회수 추이 차트

## 핵심 구현 사항

### 1. Threads API 연동
- OAuth 2.0 인증 플로우 (Short-lived → Long-lived Token)
- Media Container 생성 → 발행 2단계 프로세스
- TEXT / IMAGE / CAROUSEL 타입 지원

### 2. 스케줄링 시스템
- Spring `@Scheduled` 어노테이션 활용
- Cron 표현식으로 정확한 5분 단위 실행 (`0 0/5 * * * *`)
- Asia/Seoul 타임존 기반 요일/시간 매칭

### 3. 세션 기반 인증
- Spring Security + HttpSession 조합
- CSRF 보호 활성화
- Secure Cookie 설정 (HTTPS 환경)

## 향후 개선 계획

- [ ] 이미지 업로드 기능 (현재 URL 기반)
- [ ] 다중 계정 관리
- [ ] 포스트 미리보기
- [ ] 발행 실패 시 재시도 로직
- [ ] 토큰 자동 갱신

## 라이선스

MIT License

## 연락처

- GitHub: [@junkang](https://github.com/junkang)
- Email: nawaddaing@gmail.com
