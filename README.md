# Threads Supporter

Meta의 Threads API를 활용하여 플랫폼에 예약 포스팅을 자동화하는 웹 애플리케이션입니다. 사용자가 설정한 요일과 시간에 맞춰 자동으로 글을 발행하여 브랜딩 및 마케팅 업무의 효율성을 높여줍니다.

### 주요 기능

- **OAuth 2.0 로그인**: Threads 계정을 통한 안전한 소셜 로그인
- **예약 포스팅**: 원하는 요일/시간에 자동 발행
- **반복 발행**: 특정 요일/시간 반복 또는 일회성 발행 선택
- **통계 대시보드**: Threads Insights API를 통한 조회수 분석
- **모바일 최적화**: 반응형 UI로 모바일 환경에서도 편리하게 사용

## 서비스 URL

[https://threads-supporter.duckdns.org](https://threads-supporter.duckdns.org/posts)

- **ID**: threads_supporter_test
- **PW**: tmfpemtjvhxj
(한글로 스레드서포터)

## 스크린샷

### 로그인 페이지
- 모바일 앱 스타일의 깔끔한 로그인 화면
- Meta API를 활용한 간편한 로그인

<img height="600" alt="Image" src="https://github.com/user-attachments/assets/9c5c99c3-2859-4b32-8644-9a711433cace" />
<img height="600" alt="Image" src="https://github.com/user-attachments/assets/c26f6a7c-5a05-4479-9b9f-5d8aa2d20704" />
<img height="600" alt="Image" src="https://github.com/user-attachments/assets/2c065a58-2bc9-47b8-9b16-69b4442dff2b" />

### 예약 포스트 목록
- 최근 수정순/시간순 정렬
- 토글 스위치로 활성화/비활성화
- 요일/시간별 필터링

<img height="600" alt="Image" src="https://github.com/user-attachments/assets/496f2423-5b63-4092-ada2-ff6b8d90be92" />
<img height="600" alt="Image" src="https://github.com/user-attachments/assets/caf707bb-2980-461f-9ee3-6c8a225f0954" />
<img height="600" alt="Image" src="https://github.com/user-attachments/assets/1c77dcae-608d-41c2-a5a6-a8a808c155b1" />

### 통계 대시보드
- 기간별 총 조회수
- 일별 조회수 추이 차트

<img height="600" alt="Image" src="https://github.com/user-attachments/assets/1ce7a182-7636-41d0-bb27-5d7acff41f2a" />

### 프로필 페이지
- 이메일 연동 CS 수집
- 로그아웃 기능

<img height="600" alt="Image" src="https://github.com/user-attachments/assets/e1ad7aa7-f41e-418a-a4be-da8ce9772e9f" />

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
- **Cloud**: AWS EC2
- **Reverse Proxy**: Nginx
- **CI/CD**: GitHub Actions
- **Domain**: DuckDNS

## 시스템 아키텍처

```
┌─────────────────────────────────────────────────────────────┐
│                        Client                               │
│                    (Mobile / Web)                           │
└─────────────────────┬───────────────────────────────────────┘
                      │ HTTPS
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                     Nginx (Reverse Proxy)                   │
│                   SSL Termination / Load Balancer           │
└─────────────────────┬───────────────────────────────────────┘
                      │ HTTP (localhost:8080)
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                   Spring Boot Application                   │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │ Controllers │  │  Services   │  │     Scheduler       │  │
│  │  (MVC/API)  │  │             │  │  (Cron: 0/5 * * *)  │  │
│  └──────┬──────┘  └──────┬──────┘  └──────────┬──────────┘  │
│         │                │                     │            │
│         └────────────────┼─────────────────────┘            │
│                          ▼                                  │
│              ┌───────────────────────┐                      │
│              │    Spring Data JPA    │                      │
│              └───────────┬───────────┘                      │
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

## 데이터베이스

### ERD

<img width="1088" height="547" alt="Image" src="https://github.com/user-attachments/assets/4204a808-c913-4661-a2f0-e35e8f76a24e" />

### 스키마

```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  threads_user_id TEXT UNIQUE NOT NULL,  -- Meta Threads 유저 ID
  username TEXT NOT NULL,
  access_token TEXT NOT NULL,
  refresh_token TEXT,
  token_expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  follower_picture_url TEXT,
  follower_count INTEGER,
  name TEXT
);

CREATE TABLE scheduled_posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  
  -- 발행 스케줄
  days_of_week INTEGER[] NOT NULL,  -- [0,1,2,3,4,5,6] (일~토)
  hour INTEGER NOT NULL CHECK (hour >= 0 AND hour <= 23),
  minute INTEGER NOT NULL CHECK (minute >= 0 AND minute <= 59),
  
  -- 글 내용
  content TEXT NOT NULL,
  image_urls TEXT[],  -- 이미지 URL 배열
  
  -- 상태 관리
  is_active BOOLEAN DEFAULT true,
  last_posted_at TIMESTAMPTZ,
  
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  is_recurring BOOLEAN
);

CREATE TABLE post_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  scheduled_post_id UUID REFERENCES scheduled_posts(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  
  threads_post_id TEXT,  -- Threads API에서 받은 post ID
  status TEXT NOT NULL,  -- 'success', 'failed'
  error_message TEXT,
  
  posted_at TIMESTAMPTZ DEFAULT NOW()
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

### 프로필
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/profile` | 프로필 페이지 |

## 핵심 구현 사항

### 1. Threads API 연동
- OAuth 2.0 인증 플로우 (Short-lived → Long-lived Token)
- Media Container 생성 → 발행 2단계 프로세스

### 2. 스케줄링 시스템
- Spring `@Scheduled` 어노테이션 활용
- Cron 표현식으로 정확한 5분 단위 실행 (`0 0/5 * * * *`)
- Asia/Seoul 타임존 기반 요일/시간 매칭

### 3. 세션 기반 인증
- Spring Security + HttpSession 조합
- CSRF 보호 활성화
- Secure Cookie 설정 (HTTPS 환경)

## 향후 개선 계획

- [ ] 이미지 업로드 기능
- [ ] 다중 계정 관리
- [ ] 발행 실패 시 재시도 로직
- [ ] 토큰 자동 갱신

## 연락처

- GitHub: [@junkang](https://github.com/nawaraing)
- Email: nawaddaing@gmail.com
