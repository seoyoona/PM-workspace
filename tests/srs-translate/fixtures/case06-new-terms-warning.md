---
case: case06
description: 처음 번역하는 클라이언트 → glossary 부재. 도메인 신규 용어 발견 → §6 New Terms에 다수 mapping 출력 + glossary 추가 권고.
client: koboom
project: Koboom
source_type: text
source_ref: text inline (Koboom KR SRS section)
existing_match_count: 0
gate_choice: "0"
glossary_present: false
expected_buckets:
  new_terms_count: 4
  translation_section_count: 3
notes: |
  Koboom (가상 신규 클라) 첫 번역 — glossary/koboom.md 부재. 4개 도메인 용어가 새로 발견됨. AI는 §6에 mapping 표 출력 + glossary 추가 권고. 이번 라운드는 임의 매핑으로 진행하되 PM 검토 요청.
---

# Source SRS (KR, Koboom)

```
1. 서비스 개요
Koboom은 어린이용 활동지(워크시트) AI 생성 서비스이다.

2. 핵심 흐름
2.1 컬렉션 (collection) 진입
2.2 키워드 입력 후 게이트키퍼(Gatekeeper) 검증
2.3 클래시파이어(Classifier) → 제너레이터(Generator) 파이프라인 통과 후 PDF 출력

3. 크레딧 정책
- 무료 활동지: 인덱스 페이지 고정 콘텐츠
- 유료 활동지: 1크레딧
- 프로모션 코드 만료: 발급 후 90일
```

# PM input
```
/srs-translate --client koboom "<above>"
```

`glossary/koboom.md` 부재 → AI가 신규 용어 발견 시 §6에 mapping + 추가 권고.
