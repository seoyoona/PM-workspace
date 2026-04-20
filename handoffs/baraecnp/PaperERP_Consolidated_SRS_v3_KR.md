# PaperERP — 골판지 박스 ERP/MES 시스템
## 견적 산출을 위한 통합 SRS

**버전:** 3.0 (통합본)
**일자:** 2026-03-24
**기반 문서:** Code SRS v2.0 Final (2026-03-16)
**목적:** 영업/개발팀 견적 산출 기준 — 확인된 고객 피드백 반영
**클라이언트:** BaraeCNP

**범례:**
- ⚠️ NEW — 고객 피드백으로 확인된 신규 요구사항 (Code SRS에 없음)
- ⚠️ SCOPE TBD — Code SRS에서 "향후 개발"로 분류되었으나, 고객이 이번 빌드에 포함 요청; 범위 확인 필요

---

## 1. 프로젝트 개요

### 1.1 시스템 목적

골판지 박스 제조업체를 위한 통합 ERP/MES 시스템.
수주부터 납품 및 세금계산서 발행까지의 전체 업무 프로세스를 관리하며, 현장 MES를 통한 실시간 생산 추적 기능을 제공합니다.

### 1.2 핵심 목표

- 전체 흐름 구현: 수주 → 발주 → 입고 → 생산계획 → MES → 출하계획 → 납품 → 세금계산서
- MyPack(마이팩) ERP/MES 기능 동등성 및 UI/UX 수준 충족
- 역할 기반 접근 분리: 영업사원 / 사무실 / 현장
- 거래 원장 및 경영 보고 프레임워크 구축

### 1.3 기술 스택

- **프론트엔드:** React + Tailwind CSS + shadcn/ui
- **데이터 레이어:** Base44 Entity (NoSQL 기반 백엔드 서비스)
- **라우팅:** React Router DOM
- **상태 관리:** TanStack React Query
- **기타:** Framer Motion (애니메이션), html2canvas (이미지 캡처), jsPDF (PDF 생성), Recharts (차트)

---

## 2. 범위 정의

### 2.1 구축 범위 (MVP)

| 영역 | 기능 | 비고 |
|------|------|------|
| 박스 업무 | 수주대장, 수주 입력, 발주, 입고, 생산, 생산계획, 출하계획, 납품, 재고 관리, 견적, 단가변경서, 파렛트 | |
| 박스 기준 정보 | 거래처별 박스 품목, 목형 관리, 조판 관리, 거래처 관리, 마닐라 코드, 원단 코드, 단위 코드 | |
| 거래 원장 | 세금계산서, 수금/지급, 외상매출 원장, 외상매입 원장, 현금 출납, 은행 원장, 어음 원장, 경비 원장, 기초 잔액 | |
| 경영 정보 | 일일 보고, 월간 현황, 자금 현황, 수불장, 손익 분석, 매출 추이 분석 | |
| 설정 | 회사 설정, 사용자 설정, 일반 설정 (6개 탭), 이메일 설정, 팩스 (발송/수신/발송 이력) | |
| MES | MES 메인, 생산 시작, 생산 완료, 바코드 스캔, 제품 정보, 인쇄 정보, 라벨 출력 | |
| 인쇄 출력물 | 발주서, 납품서, 현품표, 작업지시서, 견적서, 코드 테이블 인쇄 | |
| 공통 | Excel/이미지/팩스/이메일 내보내기 UI, 메뉴별 프린터 설정, 전송 로그 | |

### 2.2 향후 개발 (별도 표기 없으면 이번 빌드 미포함)

| ID | 항목 | 설명 | 현재 상태 |
|----|------|------|-----------|
| F-01 | 외주 발주서 양식 세분화 | 완제품 vs. 공정별 분리 양식 | ⚠️ SCOPE TBD — 고객이 이번 빌드에 원함; Code SRS에는 공통 양식만 존재 |
| F-02 | 공인인증서 전자서명 | 국세청 전자세금계산서 연동 | UI/등록만 |
| F-03 | 팩스 실제 API 연동 | 외부 팩스 서비스 API | 로그만 (보류) |
| F-04 | 이메일 실제 API 연동 | 외부 이메일 발송 API | 로그만 (보류) |
| F-05 | 원단 입고 엑셀 대사 | 공급업체 엑셀 업로드 → 입고 데이터 비교 | ⚠️ SCOPE TBD — 고객이 이번 빌드에 원함; Code SRS에 미구현 |
| F-06 | MES 조판번호 직접 등록 | MES 화면에서 조판 정보 직접 등록 | ⚠️ SCOPE TBD — 고객이 이번 빌드에 원함; Code SRS에 미구현 |
| F-07 | 전자세금계산서 발행 | 국세청 HomeTax 연동 | 미구현 |
| F-08 | 모바일 최적화 UX | MES 및 영업사원용 전용 모바일 UX | 기본 반응형만 |
| F-09 | 다국어 지원 | 영어/중국어 UI 지원 | 한국어만 |
| F-10 | 자동 분개 | 세금계산서 발행 시 자동 회계 분개 | 미구현 |
| F-11 | ERP-회계 연동 | 외부 회계 시스템 동기화 | 미구현 |
| F-12 | 재고 실사 바코드 | 바코드 기반 실물 재고 조사 | 미구현 |

### 2.3 범위 외 / 플레이스홀더

| 항목 | 설명 |
|------|------|
| 자동 분개 | 세금계산서 발행 시 자동 차변/대변 처리 없음 (수동) |
| ERP-회계 연동 | 외부 회계 시스템 연동 없음 |
| 재고 실사 바코드 | 바코드 기반 실물 재고 조사 없음 |
| 급여/HR 모듈 | 범위 외 |
| CRM 모듈 | 범위 외 |

---

## 3. 사용자 역할 및 권한

### 3.1 사무실 (admin)

- `role: "admin"`, `system_type: "erp"`
- 전체 메뉴 접근 가능
- 모든 데이터 CRUD
- 사용자 관리, 설정, 권한 관리
- 다른 사용자의 메뉴 권한(MenuPermission) 설정 가능

### 3.2 영업사원 (sales/user)

- `role: "user"`, `system_type: "erp"`
- 본인 담당 거래처의 수주/발주/입고/박스 품목만 조회 가능
- 납품, 세금계산서 조회 가능 (본인 거래처만)
- 설정, 사용자 관리 접근 불가
- MenuPermission을 통한 메뉴별 세부 권한 제어 (can_view, can_edit, can_delete, can_export)

### 3.3 현장 / MES (mes)

- `role: "user"`, `system_type: "mes"`
- MES 화면만 접근 가능
- 로그인 시 /MESMain으로 리다이렉트
- 생산 시작/완료 입력, 바코드 스캔
- ERP 메뉴 접근 불가
- `mes_equipment` 필드로 담당 설비 지정

---

## 4. 권한 매트릭스

### 4.1 메뉴 레벨 접근 권한

| 메뉴/기능 | 사무실 (admin) | 영업사원 (user) | MES |
|-----------|:-:|:-:|:-:|
| **박스 업무** | | | |
| 수주대장 조회 | O | 본인 거래처만 | X |
| 수주 생성/수정 | O | O (본인 거래처) | X |
| 수주 삭제 | O | X | X |
| 발주 조회 | O | 본인 거래처만 | X |
| 발주 생성/수정 | O | 제한적 | X |
| 입고 조회 | O | 본인 거래처만 | X |
| 입고 생성/수정 | O | 제한적 | X |
| 생산 조회 | O | O (읽기 전용) | X |
| 생산계획 | O | O (읽기 전용) | X |
| 출하계획 | O | O (본인 거래처) | X |
| 납품 조회/생성 | O | 본인 거래처만 | X |
| 재고 관리 | O | O (읽기 전용) | X |
| 견적 | O | O (본인 거래처) | X |
| 단가변경 | O | O (본인 거래처) | X |
| 파렛트 | O | O (읽기 전용) | X |
| **박스 기준 정보** | | | |
| 거래처별 박스 품목 | O | 본인 거래처만 | X |
| 품목 생성/수정 | O | 제한적 | X |
| 목형 관리 | O | O (읽기 전용) | X |
| 조판 관리 | O | O (읽기 전용) | X |
| 거래처 관리 | O | X | X |
| 마닐라 코드 | O | X | X |
| 원단 코드 | O | X | X |
| 단위 코드 | O | X | X |
| **거래 원장** | | | |
| 세금계산서 | O | 본인 거래처만 | X |
| 수금/지급 | O | X | X |
| 외상매출/외상매입/현금/은행/어음/경비/기초잔액 | O | X | X |
| **경영 정보** | | | |
| 일일 보고 | O | O (본인 거래처) | X |
| 월간 현황 | O | X | X |
| 자금 현황 | O | X | X |
| 수불장 | O | X | X |
| 손익 분석 | O | X | X |
| 매출 추이 | O | O (본인 거래처) | X |
| **설정** | | | |
| 모든 설정 메뉴 | O | X | X |
| **MES** | | | |
| MES 메인 / 생산 / 바코드 / 제품 정보 | X | X | O |

### 4.2 세부 권한 (MenuPermission 엔티티)

사용자별, 메뉴별:

| 권한 | 설명 |
|------|------|
| `can_view` | 조회 권한 |
| `can_edit` | 생성/수정 권한 |
| `can_delete` | 삭제 권한 |
| `can_export` | 내보내기 (Excel/이미지/팩스/이메일) 권한 |

---

## 5. 메뉴 구조 (IA)

### 5.1 박스 업무

| 메뉴 | 경로 | 설명 | menu_key |
|------|------|------|----------|
| 수주대장 | /SalesOrderList | 수주 현황 조회 (거래처/납기/영업담당별) | sales_order_list |
| 수주 입력 | /SalesOrderEntry | 수주 생성/수정 (팝업) | sales_order |
| 발주 | /PurchaseOrderList | 발주 현황 및 입력 | purchase_order |
| 입고 | /ReceivingList | 입고 현황 및 입력 | receiving |
| 생산 | /ProductionList | 생산 실적 조회 | production |
| 생산계획 | /ProductionPlanPage | 생산계획 관리 | production_plan |
| 출하계획 | /ShipmentPlan | 출하 일정 | shipment_plan |
| 납품 | /DeliveryList | 납품 현황 및 입력 | delivery |
| 재고 관리 | /InventoryManagement | 박스 재고 현황 및 조정 | inventory |
| 견적 | /BoxQuotation | 견적서 작성 및 관리 | quotation |
| 단가변경 | /PriceChange | 단가 변경 이력 | price_change |
| 파렛트 | /PalletManagement | 파렛트 입출고 관리, 잔량 확인 | pallet |

### 5.2 박스 기준 정보

| 메뉴 | 경로 | 설명 | menu_key |
|------|------|------|----------|
| 거래처별 박스 품목 | /BoxProductList | 거래처별 품목 관리 | box_product |
| 목형 관리 | /WoodenMoldList | 목형 등록/관리/연결 품목 | wooden_mold |
| 조판 관리 | /PrintingPlateList | 조판 등록/관리/연결 품목 | printing_plate |
| 거래처 관리 | /PartnerList | 거래처 등록/관리 | partner |
| 마닐라 코드 | /ManilaList | 마닐라 코드 관리 | manila_code |
| 원단 코드 | /PaperCodeList | 원단 코드 관리 | paper_code |
| 단위 코드 | /UnitCodePage | 기본 코드 관리 | unit_code |

### 5.3 거래 원장

| 메뉴 | 경로 | 설명 | menu_key |
|------|------|------|----------|
| 세금계산서 | /BillingList | 매출/매입 세금계산서 | billing |
| 수금/지급 | /PaymentCollection | 수금 및 지급 관리 | payment |
| 외상매출 원장 | /AccountsReceivable | 외상매출금 | accounts_receivable |
| 외상매입 원장 | /AccountsPayable | 외상매입금 | accounts_payable |
| 현금 출납 | /CashBook | 현금 입출금 관리 | cash_book |
| 은행 원장 | /BankLedger | 은행 거래 내역 | bank_ledger |
| 어음 원장 | /NoteLedger | 어음 관리 | note_ledger |
| 경비 원장 | /ExpenseLedger | 일반 경비 관리 | expense_ledger |
| 기초 잔액 | /OpeningBalance | 기초 잔액 설정 | opening_balance |

### 5.4 경영 정보

| 메뉴 | 경로 | 설명 | menu_key |
|------|------|------|----------|
| 일일 보고 | /DailyReport | 일일 실적 보고 | daily_report |
| 월간 현황 | /MonthlySummary | 월간 요약 | monthly_summary |
| 자금 현황 | /CashFlow | 자금 흐름 현황 | cash_flow |
| 수불장 | /InventoryLedger | 재고 입출고 원장 | inventory_ledger |
| 손익 분석 | /ProfitLossAnalysis | 손익 분석 | profit_loss |
| 매출 추이 | /SalesAnalysis | 매출 추이 분석 | sales_analysis |

### 5.5 설정

| 메뉴 | 경로 | 설명 | menu_key |
|------|------|------|----------|
| 회사 설정 | /CompanySettings | 회사 기본 정보 | company_settings |
| 사용자 설정 | /UserSettings | 사용자/권한 설정 | user_settings |
| 일반 설정 | /GeneralSettingsPage | 6개 탭 설정 | general_settings |
| 이메일 발송 | /EmailSettings | 이메일 설정 | email_settings |
| 팩스 발송 | /SendFax | 팩스 발송 | send_fax |
| 팩스 수신 | /ReceivedFax | 수신 팩스 목록 | received_fax |
| 팩스 발송 이력 | /SentFax | 발송 팩스 이력 | sent_fax |

### 5.6 MES (현장 전용)

| 메뉴 | 경로 | 설명 |
|------|------|------|
| MES 메인 | /MESMain | 생산계획 보드, 공정별 현황 |

---

## 6. 상태 정의

### 6.1 SalesOrder (수주)

| 상태 | 표시 | 의미 | 전환 조건 |
|------|------|------|-----------|
| `pending` | 대기 | 수주 등록, 생산/납품 미진행 | 생성 시 기본값 |
| `in_production` | 생산 중 | 생산 기록 연결됨 | Production 기록 연결 시 자동 |
| `produced` | 생산 완료 | 주문 수량 충족 | produced_qty >= order_qty |
| `partial_delivery` | 부분 납품 | 일부 납품 완료 | 0 < delivered_qty < order_qty |
| `completed` | 납품 완료 | 전체 수량 납품 완료 | delivered_qty >= order_qty |
| `cancelled` | 취소 | 수주 취소 | 수동 (발주 없는 경우만) |

**파생 상태 (UI 배지 전용, 저장되지 않음):**

| 표시 | 조건 |
|------|------|
| 미발주 | is_ordered == false |
| 발주 진행 중 | is_ordered == true && 입고 없음 |
| 입고 완료 | 발주 수량 전량 입고 |
| 생산 중 | produced_qty > 0 && < order_qty |
| 생산 완료 | produced_qty >= order_qty |
| 납품 완료 | delivered_qty >= order_qty |

### 6.2 PurchaseOrder (발주)

| 상태 | 표시 | 의미 | 전환 조건 |
|------|------|------|-----------|
| `draft` | 작성 중 | 발주 준비 중 | 기본값 |
| `ordered` | 발주 완료 | 발주 확정 | 사용자 확정 |
| `partial_received` | 부분 입고 | 일부 품목 입고 | 일부 품목 received_qty > 0 |
| `received` | 전량 입고 | 모든 품목 입고 | 모든 품목 received_qty >= order_qty |
| `cancelled` | 취소 | 발주 취소 | 입고 전에만 가능 |

### 6.3 Receiving (입고)

별도 상태 필드 없음. 입고 입력 = 즉시 확정.
관련 PurchaseOrder.items[].received_qty를 갱신하고 발주 상태를 자동 전환합니다.

### 6.4 ProductionPlan (생산계획)

| 상태 | 표시 | 의미 | 전환 조건 |
|------|------|------|-----------|
| `draft` | 작성 중 | 계획 진행 중 | 기본값 |
| `confirmed` | 확정 | 계획 확정 | 사용자 조작 |
| `in_progress` | 진행 중 | 생산 시작됨 | 임의 process_plan이 in_progress |
| `completed` | 완료 | 모든 공정 완료 | 모든 process_plans 완료 |
| `cancelled` | 취소 | 계획 취소 | 생산 시작 전에만 가능 |

**process_plans[].status:**

| 상태 | 의미 |
|------|------|
| `pending` | 대기 |
| `in_progress` | 진행 중 |
| `completed` | 완료 |

### 6.5 Production (생산)

| 상태 | 표시 | 의미 | 전환 조건 |
|------|------|------|-----------|
| `planned` | 계획됨 | 계획에서 배정 | 기본값 |
| `in_progress` | 진행 중 | 생산 시작 | MES 시작 버튼 |
| `completed` | 완료 | 생산 완료 | MES 완료 버튼 + 수량 입력 |
| `cancelled` | 취소 | 취소 | 사용자 조작 |

### 6.6 Delivery (납품)

| 상태 | 표시 | 의미 | 전환 조건 |
|------|------|------|-----------|
| `draft` | 작성 중 | 준비 중 | 기본값 |
| `delivered` | 납품 완료 | 확정 | 사용자 조작 |
| `invoiced` | 계산서 발행 | 세금계산서 발행됨 | Invoice 연결 시 |

### 6.7 Invoice (세금계산서)

| 상태 | 표시 | 의미 | 전환 조건 |
|------|------|------|-----------|
| `draft` | 작성 중 | 준비 중 | 기본값 |
| `issued` | 발행 | 세금계산서 발행 | 사용자 조작 |
| `sent` | 발송 | 고객에게 발송 | 이메일/팩스 발송 |
| `paid` | 수금 완료 | 전액 수금 | amount_paid >= total_amount |
| `partial` | 부분 수금 | 일부 수금 | 0 < amount_paid < total_amount |
| `overdue` | 연체 | 지급 기한 초과 | today > due_date && balance > 0 |
| `cancelled` | 취소 | 취소 | 수금 내역 없는 경우만 |

### 6.8 MES 작업 상태

Production + ProductionPlan.process_plans의 복합 표시:

| 표시 | 조건 |
|------|------|
| 대기 | process_plans[].status == "pending" |
| 진행 중 | process_plans[].status == "in_progress" |
| 완료 | process_plans[].status == "completed" |
| 선공정 미완료 | 이전 순서 공정이 완료되지 않은 상태에서 시작 시도 |

---

## 7. 업무 규칙

| # | 규칙 | 설명 | 적용 대상 |
|---|------|------|-----------|
| BR-01 | 중복 품목 허용 | 동일 제품이 하나의 발주/입고/납품 내 여러 행에 등록 가능. 추가 입력 시 잔량 재표시 | PurchaseOrder, Receiving, Delivery |
| BR-02 | 조정 값 우선 적용 | stock_qty 또는 undelivered_qty 표시 시, adjusted_stock_qty / adjusted_undelivered_qty가 설정되어 있으면 우선 사용 | SalesOrder, 수주대장, 출하계획, 재고 |
| BR-03 | billing_partner 기준 세금계산서 | 납품에 billing_partner_id가 있으면 billing_partner 기준으로 세금계산서 그룹핑. partner_id (거래처)와 billing_partner_id (청구처)를 별도 관리 | Delivery, Invoice |
| BR-04 | 선공정 완료 필수 | ProductionPlan.process_plans에서 이전 순서 공정이 완료되어야 다음 공정 시작 가능. "선공정 미완료" 메시지 표시 | MES, ProductionPlan |
| BR-05 | 이력 있는 기준 정보 삭제 제한 | BoxProduct: 수주 이력 있으면 삭제 불가 (중지 가능). WoodenMold/PrintingPlate: 연결 품목 있으면 삭제 불가 (중지 가능). Partner: 거래 이력 있으면 삭제 불가 (비활성 처리 가능) | BoxProduct, WoodenMold, PrintingPlate, Partner |
| BR-06 | 영업사원 데이터 격리 | 영업사원은 SalesPerson.assigned_partners에 포함된 거래처 데이터만 조회 가능 | 모든 목록 화면 |
| BR-07 | MES 전용 사용자 | system_type == "mes" 사용자는 /MESMain으로 리다이렉트. ERP 메뉴 접근 불가 | Layout, Routing |
| BR-08 | 재고 조정 감사 로그 | adjusted_stock_qty 또는 adjusted_undelivered_qty 변경 시 StockAdjustmentLog에 기록 (변경 전/후, 사유, 작업자) | SalesOrder, StockAdjustmentLog |
| BR-09 | 부분 처리 허용 | 발주의 부분 입고, 수주의 부분 납품, 세금계산서의 부분 수금 — 각각 해당 부분 상태로 전환 | PurchaseOrder, SalesOrder, Invoice |
| BR-10 | 인쇄 출력 옵션 | 납품서: 회사명 숨김, 금액 숨김, 수량만 표시 옵션. 현품표: 간략/상세 형식 | 인쇄 출력물 |
| BR-11 | 발주 있으면 수주 삭제 불가 | SalesOrder.is_ordered == true → 삭제 차단 | SalesOrder |
| BR-12 | 입고 있으면 발주 삭제 불가 | 발주 품목 중 received_qty > 0인 항목 존재 → 삭제 차단 | PurchaseOrder |
| BR-13 | 날짜 기본값 오늘 | 수주일, 발주일, 입고일, 납품일 기본값은 오늘 날짜 | 모든 입력 화면 |
| BR-14 | 코드 테이블 팝업 검색 | 거래처 입력 필드: Enter → 코드 테이블 팝업. 텍스트 + Enter → 필터된 코드 테이블 팝업. 드롭다운 목록 없음 | 모든 거래처 검색 필드 |
| BR-15 | 수주 수량 자동 계산 | undelivered_qty = order_qty - delivered_qty. stock_qty = produced_qty - delivered_qty. 조정 값 우선 적용 | SalesOrder |
| BR-16 | 납품 시 수주 수량 갱신 | 납품 생성/수정/삭제 시 관련 SO.delivered_qty 재계산 | Delivery → SalesOrder |
| BR-17 | 생산 시 수주 수량 갱신 | 생산 입력 시 관련 SO.produced_qty 갱신 | Production → SalesOrder |
| BR-18 | 파렛트 잔량 자동 계산 | PalletTransaction 입력 시 PalletBalance 자동 갱신 (current_balance, total_in, total_out) | PalletTransaction → PalletBalance |

---

## 8. 엔티티 정의 (데이터 사전)

> **공통 기본 필드 (모든 엔티티):** `id`, `created_date`, `updated_date`, `created_by`

### 8.1 SalesOrder (수주)

| 필드 | 타입 | 필수 | 설명 | 비고 |
|------|------|:----:|------|------|
| order_number | string | - | 수주 번호 | 자동 생성 |
| order_date | date | Y | 수주일 | 기본값: 오늘 |
| category | enum | - | 구분 | "order" / "stock" |
| partner_id | string | Y | 거래처 ID | Partner 참조 |
| partner_name | string | - | 거래처명 | 비정규화 |
| sales_person_id | string | - | 영업담당 ID | SalesPerson 참조 |
| sales_person_name | string | - | 영업담당명 | 비정규화 |
| box_product_id | string | - | 박스 품목 ID | BoxProduct 참조 |
| box_code | string | - | 박스 코드 | |
| product_name | string | Y | 품명 | |
| box_type_name | string | - | 상자 형식 | |
| dimensions | string | - | 장폭고 | "000*000*000" 형식 |
| paper_code | string | - | 원단 코드 | |
| flute_type | string | - | 골종 | |
| po_number | string | - | P/O No. | 출하 참조 번호 |
| order_qty | number | - | 주문 수량 | 기본값: 0 |
| unit_price | number | - | 단가 | 기본값: 0 |
| total_amount | number | - | 금액 | order_qty x unit_price |
| delivery_date | date | - | 납기일 | |
| delivery_location_id | string | - | 납품처 ID | |
| delivery_location_name | string | - | 납품처명 | |
| produced_qty | number | - | 생산 수량 | Production에서 갱신 |
| delivered_qty | number | - | 납품 수량 | Delivery에서 갱신 |
| undelivered_qty | number | - | 미납품 수량 | = order_qty - delivered_qty |
| stock_qty | number | - | 재고 수량 | = produced_qty - delivered_qty |
| adjusted_stock_qty | number | - | 조정 재고 수량 | 재고 조정 시 설정 |
| adjusted_undelivered_qty | number | - | 조정 미납품 수량 | 재고 조정 시 설정 |
| manila_order_qty | number | - | 마닐라 발주 수량 | |
| manila_received_qty | number | - | 마닐라 입고 수량 | |
| paper_order_qty | number | - | 원단 발주 수량 | |
| paper_received_qty | number | - | 원단 입고 수량 | |
| is_ordered | boolean | - | 발주 여부 플래그 | 기본값: false |
| status | enum | - | 상태 | pending / in_production / produced / partial_delivery / completed / cancelled |
| invoice_status | enum | - | 세금계산서 상태 | none / issued |
| notes | string | - | 비고 | |
| work_instruction | string | - | 작업 지시 사항 | |

### 8.2 PurchaseOrder (발주)

| 필드 | 타입 | 필수 | 설명 | 비고 |
|------|------|:----:|------|------|
| po_number | string | Y | 발주 번호 | |
| po_date | date | Y | 발주일 | 기본값: 오늘 |
| partner_id | string | Y | 매입처 ID | Partner 참조 |
| partner_name | string | - | 매입처명 | |
| po_type | enum | - | 발주 유형 | manila / paper / outsource / other |
| items | array | - | 발주 품목 | PurchaseOrderItem[] |
| total_amount | number | - | 합계 금액 | 기본값: 0 |
| vat_amount | number | - | 부가세 | 기본값: 0 |
| status | enum | - | 상태 | draft / ordered / partial_received / received / cancelled |
| notes | string | - | 비고 | |

**PurchaseOrderItem:**

| 필드 | 타입 | 설명 | 비고 |
|------|------|------|------|
| item_type | string | 품목 유형 | |
| item_code | string | 품목 코드 | |
| item_name | string | 품명 | |
| spec | string | 규격 | |
| cutting_size | string | 재단 사이즈 | |
| order_qty | number | 주문 수량 | |
| received_qty | number | 입고 수량 | 기본값: 0, 입고 시 갱신 |
| unit_price | number | 단가 | |
| amount | number | 금액 | |
| delivery_date | date | 납기일 | |
| related_order_id | string | 관련 수주 ID | SalesOrder 참조 |

### 8.3 Receiving (입고)

| 필드 | 타입 | 필수 | 설명 | 비고 |
|------|------|:----:|------|------|
| receiving_number | string | Y | 입고 번호 | |
| receiving_date | date | Y | 입고일 | 기본값: 오늘 |
| partner_id | string | Y | 매입처 ID | Partner 참조 |
| partner_name | string | - | 매입처명 | |
| receiver_name | string | - | 입고 담당자 | |
| receiving_type | enum | - | 입고 유형 | paper / manila / outsource / general |
| po_id | string | - | 발주 ID | PurchaseOrder 참조 |
| po_number | string | - | 발주 번호 | |
| items | array | - | 입고 품목 | ReceivingItem[] |
| total_qty | number | - | 총 수량 | 기본값: 0 |
| total_amount | number | - | 합계 금액 | 기본값: 0 |
| vat_amount | number | - | 부가세 | 기본값: 0 |
| notes | string | - | 비고 | |

**ReceivingItem:**

| 필드 | 타입 | 설명 | 비고 |
|------|------|------|------|
| item_code | string | 품목 코드 | |
| item_name | string | 품명 | |
| spec | string | 규격 | |
| cutting_size | string | 재단 사이즈 | |
| ordered_qty | number | 발주 수량 | |
| received_qty | number | 입고 수량 | |
| unit_price | number | 단가 | |
| amount | number | 금액 | |
| warehouse | string | 창고 | |

### 8.4 ProductionPlan (생산계획)

| 필드 | 타입 | 필수 | 설명 | 비고 |
|------|------|:----:|------|------|
| plan_number | string | - | 계획 번호 | 자동 생성 |
| plan_date | date | Y | 계획일 | |
| sales_order_id | string | - | 수주 ID | SalesOrder 참조 |
| partner_id | string | - | 거래처 ID | |
| partner_name | string | - | 거래처명 | |
| product_name | string | - | 품명 | |
| dimensions | string | - | 장폭고 | |
| order_qty | number | - | 주문 수량 | 기본값: 0 |
| delivery_date | date | - | 납기일 | |
| process_plans | array | - | 공정별 계획 | ProcessPlan[] |
| status | enum | - | 상태 | draft / confirmed / in_progress / completed / cancelled |
| notes | string | - | 비고 | |

**ProcessPlan:**

| 필드 | 타입 | 설명 | 비고 |
|------|------|------|------|
| sequence | number | 생산 순서 | |
| process_code_id | string | 공정 코드 ID | ProcessCode 참조 |
| process_name | string | 공정명 | |
| equipment_id | string | 설비 ID | Equipment 참조 |
| equipment_name | string | 설비명 | |
| planned_start_time | string | 예정 시작 시간 | HH:mm |
| planned_end_time | string | 예정 종료 시간 | HH:mm |
| actual_start_time | string | 실제 시작 시간 | MES 입력 |
| actual_end_time | string | 실제 종료 시간 | MES 입력 |
| actual_duration_minutes | number | 실제 소요 시간 (분) | 자동 계산 |
| status | enum | 상태 | pending / in_progress / completed |
| notes | string | 비고 | |

### 8.5 Production (생산)

| 필드 | 타입 | 필수 | 설명 | 비고 |
|------|------|:----:|------|------|
| production_number | string | Y | 생산 번호 | |
| production_date | date | Y | 생산일자 | |
| sales_order_id | string | - | 수주 ID | SalesOrder 참조 |
| order_number | string | - | 수주 번호 | |
| partner_id | string | - | 거래처 ID | |
| partner_name | string | - | 거래처명 | |
| box_code | string | - | 박스 코드 | |
| product_name | string | - | 품명 | |
| paper_code | string | - | 원단 코드 | |
| flute_type | string | - | 골종 | |
| dimensions | string | - | 규격 | |
| cutting_size | string | - | 재단 사이즈 | |
| order_qty | number | - | 주문 수량 | 기본값: 0 |
| production_qty | number | - | 생산 수량 | 기본값: 0 |
| defect_qty | number | - | 불량 수량 | 기본값: 0 |
| good_qty | number | - | 양품 수량 | = production_qty - defect_qty |
| status | enum | - | 상태 | planned / in_progress / completed / cancelled |
| start_time | string | - | 시작 시간 | |
| end_time | string | - | 종료 시간 | |
| machine | string | - | 설비 | |
| worker | string | - | 작업자 | |
| material_used | array | - | 사용 자재 | [{material_code, material_name, used_qty}] |
| notes | string | - | 비고 | |

### 8.6 Delivery (납품)

| 필드 | 타입 | 필수 | 설명 | 비고 |
|------|------|:----:|------|------|
| delivery_number | string | - | 납품 번호 | 자동 생성 |
| delivery_date | date | Y | 납품일 | 기본값: 오늘 |
| partner_id | string | Y | 거래처 ID (청구 대상) | Partner 참조 |
| partner_name | string | - | 거래처명 | |
| billing_partner_id | string | - | 청구처 ID (수주 원천) | 세금계산서 그룹핑 기준 |
| billing_partner_name | string | - | 청구처명 | |
| delivery_location_id | string | - | 납품처 ID | |
| delivery_location_name | string | - | 납품처명 | |
| vehicle_id | string | - | 차량 ID | VehicleCode 참조 |
| vehicle_number | string | - | 차량 번호 | |
| departure_time | string | - | 출발 시간 | |
| memo | string | - | 메모 | |
| items | array | - | 납품 품목 | DeliveryItem[] |
| total_qty | number | - | 총 수량 | 기본값: 0 |
| supply_amount | number | - | 공급가액 | 기본값: 0 |
| vat_amount | number | - | 세액 | 기본값: 0 |
| total_amount | number | - | 합계 | 기본값: 0 |
| pallet_outputs | array | - | 파렛트 출고 | [{pallet_type_id, pallet_type_name, quantity}] |
| transport_cost | number | - | 운송비 | 기본값: 0 |
| status | enum | - | 상태 | draft / delivered / invoiced |
| invoice_id | string | - | 세금계산서 ID | Invoice 참조 |
| is_invoiced | boolean | - | 세금계산서 발행 여부 | 기본값: false |

**DeliveryItem:**

| 필드 | 타입 | 설명 | 비고 |
|------|------|------|------|
| sales_order_id | string | 수주 ID | SalesOrder 참조 |
| category | enum | 구분 | "order" / "stock" |
| product_name | string | 품명 | |
| dimensions | string | 장폭고 | |
| quantity | number | 수량 | |
| unit_price | number | 단가 | |
| supply_amount | number | 공급가액 | |
| vat_amount | number | 세액 | |
| vat_type | enum | 부가세 유형 | "included" / "excluded" |
| notes | string | 비고 | |

### 8.7 Invoice (세금계산서)

| 필드 | 타입 | 필수 | 설명 | 비고 |
|------|------|:----:|------|------|
| invoice_number | string | - | 세금계산서 번호 | 자동 생성 |
| invoice_date | date | Y | 발행일 | |
| invoice_type | enum | - | 발행 유형 | sales_order / delivery / manual |
| partner_id | string | Y | 거래처 ID | Partner 참조 |
| partner_name | string | - | 거래처명 | |
| due_date | date | - | 지급 기한 | |
| status | enum | - | 상태 | draft / issued / sent / paid / partial / overdue / cancelled |
| related_document_type | enum | - | 관련 문서 유형 | sales_order / delivery / none |
| related_document_ids | string[] | - | 관련 문서 ID | |
| items | array | - | 세금계산서 품목 | InvoiceItem[] |
| supply_amount | number | - | 공급가액 | 기본값: 0 |
| vat_amount | number | - | 부가세 | 기본값: 0 |
| total_amount | number | - | 합계 | 기본값: 0 |
| amount_paid | number | - | 수금액 | 기본값: 0 |
| balance_due | number | - | 잔액 | 기본값: 0 |
| currency | string | - | 통화 | 기본값: "KRW" |
| notes | string | - | 비고 | |
| ⚠️ NEW: invoice_format | enum | - | 발행 형식 | "electronic" / "paper" — 전자 세금계산서 vs. 종이 세금계산서 구분 |
| ⚠️ NEW: tax_type | enum | - | 과세 유형 | "normal" / "zero_rate" (일반과세/영세율) |
| ⚠️ NEW: document_type | enum | - | 문서 유형 | "receipt" / "claim" (영수/청구) |

**InvoiceItem:**

| 필드 | 타입 | 설명 |
|------|------|------|
| product_id | string | 품목 ID |
| product_name | string | 품명 |
| quantity | number | 수량 |
| unit_price | number | 단가 |
| tax_rate | number | 세율 |
| discount_type | enum | 할인 유형 (percentage / flat) |
| discount_value | number | 할인 값 |
| total | number | 합계 |

### 8.8 BoxProduct (박스 품목)

| 필드 | 타입 | 필수 | 설명 | 비고 |
|------|------|:----:|------|------|
| code | string | Y | 박스 코드 | |
| name | string | Y | 품명 | |
| customer_id | string | - | 거래처 ID | Partner 참조 |
| customer_name | string | - | 거래처명 | |
| box_type_id | string | - | 상자 형식 ID | BoxType 참조 |
| box_type_name | string | - | 상자 형식명 | |
| paper_code_id | string | - | 원단 코드 ID | PaperCode 참조 |
| paper_code | string | - | 원단 코드 | |
| flute_type | string | - | 골종 | |
| dimensions | object | - | 박스 치수 | {length, width, height, has_joint, has_flap} |
| cutting_size | object | - | 재단 사이즈 | {total_length, total_width, score} 자동 계산 |
| material_type | enum | - | 자재 유형 | jigi / carton / color |
| wooden_mold_id | string | - | 목형 ID | WoodenMold 참조 |
| wooden_mold_code | string | - | 목형 번호 | |
| composition_id | string | - | 조판 ID | PrintingPlate 참조 |
| composition_code | string | - | 조판 번호 | |
| process_flags | object | - | 공정 체크박스 | {sobu, printing, coating, gold_foil, lamination, thomson, gluing, finished} |
| print_images | array | - | 인쇄 이미지 | 최대 4개, [{url, order}] |
| cost_breakdown | object | - | 원가 정보 | {material_cost, sub_material_cost, processing_cost, additional_cost, profit_rate, unit_price} |
| quantity_tiers | array | - | 수량별 단가 | [{min_qty, max_qty, unit_price, is_base, notes}] |
| processes | array | - | 공정 정보 | [{process_code_id, process_name, production_type, equipment_id, ...}] |
| materials | array | - | 자재 정보 | [{type, item_name, paper_code_id, cutting_length, cutting_width, ...}] |
| pallet_info | object | - | 적재 정보 | {pallet_type_id, banding_qty, stack_width/length/height, qty_per_pallet} |
| outsource_type | enum | - | 외주 유형 | none / partial / complete |
| min_order_qty | number | - | 최소 주문 수량 | 기본값: 0 |
| optimal_stock_qty | number | - | 적정 재고 수량 | 기본값: 0 |
| is_active | boolean | - | 활성 여부 | 기본값: true |
| memo | string | - | 메모 | |

### 8.9 Partner (거래처)

| 필드 | 타입 | 필수 | 설명 | 비고 |
|------|------|:----:|------|------|
| code | string | - | 관리 코드 | 자동 생성 |
| name | string | Y | 업체명 | |
| management_name | string | - | 관리명 | 내부 사용 |
| partner_type | enum | - | 거래처 유형 | sales / purchase / both |
| purchase_types | string[] | - | 매입 분류 | manila / paper / general / outsource |
| sales_types | string[] | - | 매출 분류 | box / paper / general |
| business_number | string | - | 사업자등록번호 | 숫자만 |
| sub_business_number | string | - | 종사업장번호 | |
| is_zero_rate | boolean | - | 영세율 여부 | 기본값: false |
| ceo_name | string | - | 대표자명 | |
| business_type | string | - | 업태 | |
| business_category | string | - | 업종 | |
| postal_code | string | - | 우편번호 | |
| address | string | - | 주소 | |
| phone | string | - | 전화번호 | |
| fax | string | - | 팩스 | |
| email | string | - | 이메일 | |
| reference_note | string | - | 참조 사항 | 거래처 목록에 표시 |
| delivery_note | string | - | 납품 특기 사항 | 납품서 하단에 인쇄 |
| sales_person | string | - | 영업 담당 | |
| purchase_person | string | - | 구매 담당 | |
| bank_name | string | - | 은행명 | |
| account_number | string | - | 계좌번호 | |
| account_holder | string | - | 예금주 | |
| payment_terms | enum | - | 결제 조건 | cash / next_month_10/25/end / credit_15/30/45/60 |
| contacts | array | - | 담당자 | 최대 5명, [{name, email, phone, notes, invoice_type, statement_type}] |
| delivery_locations | array | - | 납품처 | 최대 5개, [{is_default, name, contact_name, contact_phone, full_address, notes}] |
| is_active | boolean | - | 활성 여부 | 기본값: true |
| is_suspended | boolean | - | 중지 여부 | 기본값: false |
| memo | string | - | 메모 | |

### 8.10 WoodenMold (목형)

| 필드 | 타입 | 필수 | 설명 | 비고 |
|------|------|:----:|------|------|
| code | string | - | 목형 코드 | 자동 생성 |
| name | string | Y | 목형 번호 | |
| box_type_id | string | - | 상자 형식 ID | |
| box_type_name | string | - | 상자 형식명 | |
| flute_type | string | - | 골종 | |
| dimensions | object | - | 목형 치수 | {length, width, height} |
| cutting_length | number | - | 재단 길이 | 목형 규격 |
| cutting_width | number | - | 재단 너비 | 목형 규격 |
| partner_id | string | - | 거래처 ID | |
| partner_name | string | - | 거래처명 | |
| manufacturer | string | - | 제작업체 | |
| manufacture_date | date | - | 제작일 | |
| location | string | - | 보관 위치 | |
| status | enum | - | 상태 | active / suspended / damaged |
| last_used_date | date | - | 최근 사용일 | |
| linked_product_count | number | - | 연결 품목 수 | 기본값: 0 |
| notes | string | - | 비고 | |
| image_url | string | - | 목형 이미지 | |
| is_active | boolean | - | 활성 여부 | 기본값: true |

### 8.11 PrintingPlate (조판)

| 필드 | 타입 | 필수 | 설명 | 비고 |
|------|------|:----:|------|------|
| code | string | - | 코드 | 자동 생성 |
| plate_number | string | Y | 조판 번호 | |
| dimensions | string | - | 장 x 폭 x 고 | |
| print_color | string | - | 인쇄 색상 | |
| plate_count | number | - | 판 수 | 기본값: 1 |
| manufacture_date | date | - | 제작일 | |
| notes | string | - | 비고 | |
| image_url | string | - | 조판 이미지 URL | |
| related_products | array | - | 연결 품목 | [{product_id, product_name, partner_name}] |
| is_active | boolean | - | 활성 여부 | 기본값: true |
| ⚠️ NEW: box_type | string | - | 상자 형식 | 조판의 상자 형식 |
| ⚠️ NEW: last_used_date | date | - | 최근 사용일 | 생산 시 자동 갱신 |
| ⚠️ NEW: linked_product_count | number | - | 연결 품목 수 | BoxProduct 참조에서 자동 집계 |

### 8.12 PaperCode (원단 코드)

| 필드 | 타입 | 필수 | 설명 | 비고 |
|------|------|:----:|------|------|
| code | string | - | 원단 코드 | 자동 생성 |
| name | string | Y | 원단명 | |
| flute_type | enum | Y | 골종 | SW / DW / TW / SF |
| composition | array | - | 원단 구성 | [{layer, raw_paper_id, raw_paper_code, raw_paper_name}] |
| composition_display | string | - | 구성 표시 | 예: "SC220 K K" |
| standard_price | number | - | 표준 단가 | 원가 계산용 |
| supplier_prices | array | - | 매입처별 단가 | [{supplier_id, supplier_name, price}] 최대 5개 |
| is_active | boolean | - | 활성 여부 | 기본값: true |
| notes | string | - | 비고 | |

### 8.13 Manila (마닐라)

| 필드 | 타입 | 필수 | 설명 | 비고 |
|------|------|:----:|------|------|
| code | string | - | 코드 | 자동 생성 |
| name | string | Y | 마닐라명 | |
| basis_weight | number | - | 평량 | 기본값: 0 |
| standard_price | number | - | 표준 단가 (kg당) | 기본값: 0 |
| supplier_prices | array | - | 매입처별 단가 | [{supplier_id, supplier_name, price}] |
| is_active | boolean | - | 활성 여부 | 기본값: true |

### 8.14 Equipment (설비)

| 필드 | 타입 | 필수 | 설명 | 비고 |
|------|------|:----:|------|------|
| code | string | Y | 설비 코드 | |
| name | string | Y | 설비명 | |
| equipment_category | enum | - | 분류 | carton / color / jigi / other |
| process_code_id | string | - | 공정 코드 ID | ProcessCode 참조 |
| process_name | string | - | 공정명 | |
| production_unit | string | - | 생산 단위 | 기본값: "매" (sheets) |
| price_unit | string | - | 단가 단위 | 기본값: "매" (sheets) |
| work_infos | array | - | 작업 정보 목록 | [{name, work_unit, unit_price}] |
| defect_reasons | array | - | 불량 사유 | [{name, fault_type(internal/external)}] |
| notes | string | - | 비고 | |
| is_active | boolean | - | 활성 여부 | 기본값: true |

### 8.15 ProcessCode (공정 코드)

| 필드 | 타입 | 필수 | 설명 | 비고 |
|------|------|:----:|------|------|
| code | string | Y | 공정 코드 | |
| name | string | Y | 공정명 | |
| process_category | enum | - | 분류 | carton / color / jigi / other |
| sequence | number | - | 공정 순서 | 기본값: 0 |
| production_unit | string | - | 생산 단위 | 기본값: "매" |
| price_unit | string | - | 단가 단위 | 기본값: "매" |
| is_active | boolean | - | 활성 여부 | 기본값: true |

### 8.16 StockAdjustmentLog (재고 조정 로그)

| 필드 | 타입 | 필수 | 설명 | 비고 |
|------|------|:----:|------|------|
| sales_order_id | string | Y | 수주 ID | SalesOrder 참조 |
| order_number | string | - | 수주 번호 | |
| partner_name | string | - | 거래처명 | |
| product_name | string | - | 품명 | |
| adjustment_date | date | Y | 조정일 | |
| before_stock_qty | number | - | 조정 전 재고 수량 | 기본값: 0 |
| after_stock_qty | number | - | 조정 후 재고 수량 | 기본값: 0 |
| before_undelivered_qty | number | - | 조정 전 미납품 수량 | 기본값: 0 |
| after_undelivered_qty | number | - | 조정 후 미납품 수량 | 기본값: 0 |
| reason | string | - | 사유 | |
| adjusted_by | string | - | 작업자 | |

### 8.17 Inventory (재고)

| 필드 | 타입 | 필수 | 설명 | 비고 |
|------|------|:----:|------|------|
| item_type | enum | Y | 품목 유형 | box / paper / manila |
| item_code | string | Y | 품목 코드 | |
| item_name | string | - | 품명 | |
| partner_id | string | - | 거래처 ID | |
| partner_name | string | - | 거래처명 | |
| spec | string | - | 규격 | |
| flute_type | string | - | 골종 | |
| cutting_size | string | - | 재단 사이즈 | |
| current_qty | number | - | 현재 재고 | 기본값: 0 |
| unit_price | number | - | 단가 | 기본값: 0 |
| total_value | number | - | 재고 금액 | 기본값: 0 |
| warehouse | string | - | 창고 | |
| location | string | - | 위치 | |
| last_in_date | date | - | 최근 입고일 | |
| last_out_date | date | - | 최근 출고일 | |

### 8.18 BoxQuotation (견적)

| 필드 | 타입 | 필수 | 설명 | 비고 |
|------|------|:----:|------|------|
| quotation_number | string | - | 견적 번호 | 자동 생성 |
| quotation_date | date | Y | 견적일 | |
| valid_until | date | - | 유효 기간 | |
| partner_id | string | Y | 거래처 ID | |
| partner_name | string | - | 거래처명 | |
| items | array | - | 품목 목록 | [{sort_order, box_code, product_name, paper_code, box_type, dimensions, quantity, unit_price, amount}] |
| supply_amount | number | - | 공급가액 | 기본값: 0 |
| vat_amount | number | - | 부가세 | 기본값: 0 |
| total_amount | number | - | 합계 | 기본값: 0 |
| include_vat | boolean | - | 부가세 포함 여부 | 기본값: true |
| notes | string | - | 비고 (고객에게 표시) | |
| internal_memo | string | - | 내부 메모 | |
| status | enum | - | 상태 | draft / sent / accepted / rejected / expired |

### 8.19 파렛트 엔티티 (업데이트)

**PalletType:**
- code, name, description, is_active
- ⚠️ NEW: `spec` (규격 — 파렛트 치수/사양)

**PalletTransaction:**
- transaction_number, transaction_date, transaction_type(in/out), partner_id, pallet_type, quantity, notes
- ⚠️ NEW: `transfer_slip_amount` (이동전표금액)
- ⚠️ NEW: `storage_fee` (보관료)

**PalletBalance:**
- partner_id, pallet_type, current_balance, total_in, total_out, last_transaction_date

**⚠️ NEW: PalletSpec (규격 등록 화면)**
- 파렛트 사양을 위한 별도 등록 화면
- 필드: spec_name, length, width, height, weight, material, notes, is_active

**⚠️ NEW: 파렛트 재고 현황 뷰**
- 모든 유형 및 거래처의 현재 파렛트 재고를 보여주는 대시보드/목록 뷰

### 8.20 기타 엔티티

**BoxType:** code, name, formula_type(carton/wooden_mold/none), length_formula, width_formula, score_formula, margin_values, is_active

**RawPaperCode:** code, name, basis_weight, type(surface/flute/center/back), standard_price, supplier_price, is_active

**VehicleCode:** code, vehicle_number, tonnage, driver_name, driver_phone, is_active

**SalesPerson:** code, name, hire_date, assigned_partners, is_active

**PaymentTransaction:** transaction_number, payment_date, partner_id, type(collection/payment/expense_in/expense_out), method(cash/note/transfer), amount, balance, has_tax_invoice, memo

**PriceChangeRequest:** request_number, request_date, partner_id, box_product_id, change_type, quantity_tiers[{min_qty, max_qty, old_price, new_price}], change_reason, effective_date, status(pending/approved/rejected)

**ExportLog:** export_type(excel/image/fax/email/print), menu_key, file_name, recipient, status(pending/success/failed), sent_at

**FaxLog:** fax_number, type(sent/received), subject, message, status(pending/sent/failed/cancelled), sent_at, is_read

**CompanyProfile:** company_name, logo_url, address, phone, business_number, ceo_name, business_type, business_category, bank_name, bank_account, subscription_status

**MenuPermission:** user_id, user_email, employee_type, menu_permissions[{menu_key, can_view, can_edit, can_delete, can_export}]

**User (내장 + 사용자 정의):** 내장(id, email, full_name, role) + system_type(erp/mes), mes_equipment, employee_number

**WorkOrder:** work_order_number, order_date, sales_order_id, product_name, box_code, dimensions, order_qty, delivery_date, work_instructions, processes[], barcode

**GeneralPurchaseItem:** code, name, category(consumables/materials/equipment/services/other), unit, standard_price, supplier_prices[], current_stock

**SecurityLog:** request_type(export_excel/export_image/view_secure), menu_key, requester_id, status(pending/approved/rejected), approver_id

**BoxSettings:** sc_input_sequence, paper_cut_count, paper_min_width, paper_max_width, paper_margin_option, cutting_axis_standard, edit_recalculation, price_decimal_enabled, spec_sheet_format 등

---

## 9. 엔티티 관계

### 9.1 관계 맵

```
Partner 1:N SalesOrder            (거래처 → 수주)
Partner 1:N PurchaseOrder          (매입처 → 발주)
Partner 1:N Receiving              (매입처 → 입고)
Partner 1:N Delivery               (거래처 → 납품)
Partner 1:N Invoice                (거래처 → 세금계산서)
Partner 1:N BoxQuotation           (거래처 → 견적)
Partner 1:N PalletBalance          (거래처 → 파렛트 잔량)
Partner 1:N PaymentTransaction     (거래처 → 수금/지급)
Partner 1:N DeliveryLocation       (거래처 → 납품처)

BoxProduct 1:N SalesOrder          (박스 품목 → 수주)
BoxProduct N:1 BoxType             (박스 품목 → 상자 형식)
BoxProduct N:1 PaperCode           (박스 품목 → 원단 코드)
BoxProduct N:1 WoodenMold          (박스 품목 → 목형)
BoxProduct N:1 PrintingPlate       (박스 품목 → 조판)
BoxProduct N:1 Partner             (박스 품목 → 거래처)

SalesOrder 1:N Production          (수주 → 생산)
SalesOrder 1:N ProductionPlan      (수주 → 생산계획)
SalesOrder 1:N DeliveryItem        (수주 → 납품 품목)
SalesOrder 1:N StockAdjustmentLog  (수주 → 재고 조정 로그)

PurchaseOrder 1:N PurchaseOrderItem (발주 → 발주 품목)
PurchaseOrder 1:N Receiving        (발주 → 입고, po_id 경유)

Delivery 1:N DeliveryItem          (납품 → 납품 품목)
Delivery N:1 Invoice               (납품 → 세금계산서, invoice_id 경유)
Delivery N:1 VehicleCode           (납품 → 차량)

ProductionPlan 1:N ProcessPlan     (계획 → 공정 계획)
ProcessPlan N:1 Equipment          (공정 계획 → 설비)
ProcessPlan N:1 ProcessCode        (공정 계획 → 공정 코드)

Equipment N:1 ProcessCode          (설비 → 공정 코드)
PaperCode 1:N RawPaperCode        (원단 코드 → 원지)
PalletTransaction N:1 PalletBalance (파렛트 거래 → 파렛트 잔량)
SalesPerson 1:N Partner            (영업담당 → 담당 거래처)
MenuPermission N:1 User            (권한 → 사용자)
```

### 9.2 핵심 흐름 관계

```
[Partner] --> [SalesOrder] --> [PurchaseOrder] --> [Receiving]
                  |
                  +--> [ProductionPlan] --> [Production] (MES)
                  |
                  +--> [Delivery] --> [Invoice]
                  |
                  +--> [StockAdjustmentLog]
```

---

## 10. 화면 사양 및 인수 기준

### 10.1 수주대장 (SalesOrderList)

**목적:** 수주 현황 통합 조회 및 관리

**보기 모드:**
- 활성: undelivered_qty > 0 또는 stock_qty > 0인 항목만
- 전체: 기간 내 전체
- 합계: 날짜 무관 전체 데이터

**상태 필터:** 미발주 / 미입고 / 미생산 / 미납품

**그룹 탭:**
- 거래처별: 거래처명 기준 그룹핑
- 납기별: 납기일 기준 그룹핑 (거래처명 컬럼 추가)
- 영업담당별: 영업담당 기준 그룹핑 (거래처명 컬럼 추가)

**컬럼 (거래처별):** 구분, 품명, 장/폭/고, 주문 수량, 마닐라/발주, 마닐라/입고, 원단/발주, 원단/입고, 생산, 납품, 미납품, 재고, 수주일, 납기, 수주 비고, 납품 비고

**버튼:** 현품표, 작업지시서, 삭제, 신규 수주, 조정 (T), 처리 이력 (새 창), 내보내기 도구모음 (인쇄/Excel/이미지/팩스/이메일)

**인수 기준:**
- [ ] 3개 그룹 모드 모두 정상 작동
- [ ] 활성/전체/합계 보기 모드 정확히 필터링
- [ ] adjusted_stock_qty 및 adjusted_undelivered_qty 값이 존재 시 우선 적용
- [ ] 상태 필터 (미발주/미입고/미생산/미납품) 정상 작동
- [ ] 상태 배지 상태별 정확히 표시 (미발주 → 발주 진행 중 → 입고 완료 → 생산 중 → 생산 완료 → 납품 완료)
- [ ] 처리 이력 버튼 클릭 시 /StockAdjustmentLogPage 새 창으로 열림
- [ ] 조정 (T) 버튼 클릭 시 재고 조정 다이얼로그 열림; 조정 내역은 StockAdjustmentLog에 기록
- [ ] 선택된 행에 대한 현품표/작업지시서 출력 작동
- [ ] is_ordered == true인 수주에 삭제 차단 메시지 표시

### 10.2 수주 입력 (SalesOrderEntry / SalesOrderForm)

**목적:** 수주 생성/수정 (팝업 또는 별도 화면)

**인수 기준:**
- [ ] 수주일 기본값 오늘 날짜
- [ ] 거래처 입력 시 Enter로 코드 테이블 팝업 사용
- [ ] 박스 품목 선택 시 자동 입력: 품명, 규격, 원단 코드, 골종, 단가
- [ ] quantity_tiers 존재 시 주문 수량에 따른 단가 자동 적용
- [ ] 금액 = order_qty x unit_price 자동 계산
- [ ] 저장 시 SalesOrder 레코드 정상 생성
- [ ] 수정 모드에서 기존 데이터 정확히 로드

### 10.3 발주 (PurchaseOrderList / PurchaseOrderForm)

**그룹 탭:** 전표별, 일자별, 매입처별, 거래처별, 영업담당별
**유형 필터:** 전체 / 마닐라 / 원단 / 외주 / 일반

**버튼:** 전표 수정, 품목 수정, 작업지시서, 현품표, 발주서, 내보내기 도구모음, 삭제, 신규 발주

**⚠️ NEW: 수주 불러오기**
- 두 가지 모드:
  1. **전체 수주 불러오기:** 미발주 수주 전체를 표시하여, 사용자가 발주에 포함할 수주를 선택
  2. **발주처별 불러오기:** 선택한 매입처(발주처)로 수주를 필터한 후, 해당 수주를 발주에 로드

- 기존 수주에서 발주를 생성하는 주요 방법

**⚠️ NEW: 자재 유형별 컬럼 세트 변경**
- po_type에 따라 컬럼 레이아웃 변경:
  - **원단 (Paper):** 원단 전용 컬럼 (원단 코드, 골종, 재단 사이즈 등)
  - **마닐라 (Manila):** 마닐라 전용 컬럼 (평량 등)
  - **외주 (Outsource):** 공정 전용 컬럼 (공정명, 설비 등)
  - **일반 (General):** 일반 품목 컬럼
- 개발팀은 활성 유형 필터/po_type에 따른 동적 컬럼 렌더링 구현 필요

**인수 기준:**
- [ ] 5개 그룹 탭 모두 정상 작동
- [ ] 유형 필터 (manila/paper/outsource/other) 정확히 필터링
- [ ] 발주 생성 시 관련 SalesOrder.is_ordered = true로 설정
- [ ] 발주 생성 시 SalesOrder.manila_order_qty 또는 paper_order_qty 갱신
- [ ] 발주서 인쇄 작동 (마닐라/원단/외주/일반 형식)
- [ ] 동일 제품 중복 품목 허용
- [ ] 입고 진행 중인 발주에 삭제 차단 메시지 표시
- [ ] ⚠️ NEW: "전체 수주 불러오기" 버튼이 미발주 수주 전체를 로드하여 선택 가능
- [ ] ⚠️ NEW: "발주처별 불러오기" 모드가 매입처로 수주를 필터 후 로드
- [ ] ⚠️ NEW: 자재 유형에 따라 컬럼 세트 동적 변경

### 10.4 입고 (ReceivingList / ReceivingForm)

**그룹 탭:** 전표별, 일자별, 매입처별, 거래처별, 품목별, 항목별, 영업담당별
**유형 필터:** 전체 / 원단 / 마닐라 / 외주 / 일반

**⚠️ NEW: 자재 유형별 컬럼 세트 변경**
- 발주(10.3절)와 동일한 동적 컬럼 동작 — receiving_type (paper/manila/outsource/general)에 따라 컬럼 변경

**⚠️ NEW: "전체 미입고 내역" 버튼**
- 모든 발주에서 전량 입고되지 않은 품목을 통합 조회하는 버튼
- 구매 담당자가 미처리 입고 건을 빠르게 파악하는 데 활용

**인수 기준:**
- [ ] 7개 그룹 탭 모두 정상 작동
- [ ] 입고 등록 시 PurchaseOrder.items[].received_qty 갱신
- [ ] 입고 등록 시 PurchaseOrder.status 자동 전환 (partial_received / received)
- [ ] 입고 등록 시 SalesOrder.manila_received_qty 또는 paper_received_qty 갱신
- [ ] 발주 대비 입고 수량 비교 가능
- [ ] 동일 제품 중복 품목 허용
- [ ] ⚠️ NEW: 자재 유형에 따라 컬럼 동적 변경
- [ ] ⚠️ NEW: "전체 미입고 내역" 버튼으로 미입고 발주 품목 통합 표시

### 10.5 생산 (ProductionList)

**그룹:** 공정별 → 기계별 하위 그룹

**컬럼:** 거래처, 품명, 상자 형식, 장/폭/고, 주문 수량, 생산 수량, 단가, 금액, 불량, 불량 사유, 박스 수, 예상 시간, 실제 시간

**⚠️ NEW: 추가 보기 모드**
- **일자별:** 생산일자 기준 생산 기록 그룹핑
- **거래처별:** 거래처 기준 생산 기록 그룹핑

**인수 기준:**
- [ ] 공정별 / 기계별 그룹핑 작동
- [ ] 생산 데이터 정확히 표시
- [ ] 생산계획 연결 작동
- [ ] 생산 입력 시 SalesOrder.produced_qty 갱신
- [ ] ⚠️ NEW: 일자별 보기가 날짜 기준으로 생산 기록 그룹핑
- [ ] ⚠️ NEW: 거래처별 보기가 거래처 기준으로 생산 기록 그룹핑

### 10.6 생산계획 (ProductionPlanPage)

**흐름:** 공정 선택 → 기계 선택 → 미생산 목록 표시 → 제품 선택 → 순서 설정

**그룹:** 공정별, 기계별, 거래처별, 납기별

**⚠️ NEW: 보기별 컬럼 세트**
- **공정별:** 작업지시서, 거래처, 납기, 품명, 장/폭/고, 상자 형식, 조판 번호, 목형 번호, 주문 수량, 원단 매입처, 원단 입고, 납품 수량, 기계
- **기계별:** 작업지시서, 거래처, 납기, 품명, 장/폭/고, 주문 수량, 조판 번호, 생산 수량, 상태
- **거래처별:** 거래처, 품명, 납기, 공정, 기계, 주문 수량, 생산 수량, 잔량
- **납기별:** 납기, 거래처, 품명, 공정, 기계, 주문 수량, 생산 수량, 상태, 우선순위

**인수 기준:**
- [ ] 공정/기계 선택 후 미생산 품목 목록 표시
- [ ] 드래그 & 드롭 생산 순서 설정 작동
- [ ] 저장 시 ProductionPlan 레코드 생성
- [ ] 생산계획 인쇄 출력 작동
- [ ] 설비 변경 (동일 공정의 다른 설비로 일괄 이동) 작동
- [ ] ⚠️ NEW: 각 그룹 보기별 해당 컬럼 세트 표시

### 10.7 출하계획 (ShipmentPlan)

**컬럼:** 납기, 거래처, 품명, 규격, 주문 수량, 매입처, 입고 수량, 생산 수량, 출하 수량, 납품 비고, 수주 비고, 구분

**인수 기준:**
- [ ] 미납품 수주 출하 일정 정확히 표시
- [ ] 생산/입고/납품 수량 실시간 반영
- [ ] 출하계획에서 납품 입력으로 이동 가능
- [ ] 재고 조정 기능 작동

### 10.8 납품 (DeliveryList / DeliveryForm)

**그룹:** 전표별, 일자별, 거래처별, 품목별, 납품처별, 차량별, 영업담당별

**⚠️ NEW: 자재 유형별 컬럼 세트 변경**
- 발주와 동일한 동적 컬럼 동작 — 납품 자재 유형에 따라 컬럼 변경

**인수 기준:**
- [ ] 7개 그룹 탭 모두 정상 작동
- [ ] 납품 등록 시 관련 SalesOrder.delivered_qty 갱신
- [ ] 납품 등록 시 SalesOrder.status 자동 전환 (partial_delivery / completed)
- [ ] partner_id (거래처)와 billing_partner_id (청구처) 별도 설정 가능
- [ ] 파렛트 출고 입력 작동 및 PalletTransaction 생성
- [ ] 납품서 / 납품 확인서 인쇄 작동
- [ ] 동일 제품 중복 품목 허용
- [ ] 차량/납품처/출발 시간 입력 작동
- [ ] ⚠️ NEW: 자재 유형에 따라 컬럼 동적 변경

### 10.9 견적 (BoxQuotation / BoxQuotationForm)

**⚠️ NEW: 마이팩 스타일 일괄 입력 UX**
- 스프레드시트 형태의 그리드 기반 입력으로 여러 품목을 빠르게 입력 가능
- Tab/Enter 키로 셀 간 이동하여 빠른 데이터 입력
- 마이팩의 견적 입력 UX와 유사 (항목별 모달 방식 아님)

**⚠️ NEW: 원가분석 패널**
- 선택된 견적 품목의 실시간 원가 분석을 보여주는 하단 또는 측면 패널
- 표시 항목: 자재비, 가공비, 추가 비용, 이익률, 권장 가격
- 영업팀이 견적 작성 시 합리적인 가격 결정에 활용

**인수 기준:**
- [ ] 여러 품목을 목록 형태로 입력 가능
- [ ] 품목별 임의 수량/단가 직접 입력 작동
- [ ] 품목별 내부 메모/비고 입력 작동
- [ ] 하단 메모 필드 존재
- [ ] 공급가액 / 부가세 / 합계 자동 계산
- [ ] 견적서 인쇄 출력 작동
- [ ] 상태 관리 (draft/sent/accepted/rejected/expired) 작동
- [ ] ⚠️ NEW: 스프레드시트 스타일 그리드 입력의 일괄 입력 UX
- [ ] ⚠️ NEW: 원가분석 패널이 선택 품목의 원가 분석 표시

### 10.10 세금계산서 (BillingList)

**기본 화면:** 발행된 세금계산서 목록

**기능:** 납품 기반 / 수주 기반 매출 세금계산서 발행, 매입 세금계산서 수동 입력

**⚠️ NEW: 추가 필드**
- `invoice_format`: 전자 vs. 종이 구분 필드
- `tax_type`: 일반과세 vs. 영세율
- `document_type`: 영수 vs. 청구
- 세금계산서 생성 시 선택 가능하고, 세금계산서 목록에 표시되어야 함

**인수 기준:**
- [ ] 발행 탭에 기존 세금계산서 목록 표시
- [ ] 미발행 탭에 납품 완료되었으나 미발행 항목 표시
- [ ] 납품 기반 세금계산서는 billing_partner_id 기준 그룹핑
- [ ] 세금계산서 발행 시 Delivery.status를 "invoiced"로, is_invoiced를 true로 갱신
- [ ] 수주 기반 세금계산서 발행 작동
- [ ] 매입 세금계산서 수동 입력 작동
- [ ] 요약 보기 제공
- [ ] ⚠️ NEW: invoice_format (전자/종이) 선택기 및 표시
- [ ] ⚠️ NEW: tax_type (일반과세/영세율) 선택기 및 표시
- [ ] ⚠️ NEW: document_type (영수/청구) 선택기 및 표시

### 10.11 거래처별 박스 품목 (BoxProductList / BoxProductForm)

**⚠️ NEW: 하단 패널 — 원자재/공정정보 + 납품이력**
- 품목 상세 보기에 다음 내용이 포함된 하단 패널:
  1. **원자재/공정정보:** 선택된 품목의 자재 목록 및 공정 목록 표시
  2. **납품이력:** 납품일, 수량, 지대가(원단 가격), 박스 단가를 표시하는 테이블

**⚠️ NEW: 공정/납품이력 탭을 인쇄사양 패널로 대체**
- 공정 정보와 납품 이력의 별도 탭 대신, 전용 인쇄사양 패널 추가
- 표시 항목: 인쇄 색상, 조판 정보, 인쇄 이미지, 인쇄 비고
- UI 구조 변경 — 데이터는 BoxProduct.print_images와 PrintingPlate에 이미 존재

**⚠️ NEW: 품목복사 (옵션 포함)**
- 설정 가능한 옵션으로 박스 품목 복사:
  1. **복사 후 원본 삭제:** 복사 후 원본 품목 삭제 옵션
  2. **인쇄사양 복사:** 복사 시 인쇄사양 데이터 포함/제외 옵션
  3. **타 거래처 복사:** 한 거래처의 품목을 다른 거래처로 복사
  4. **제품변경:** 제품 변형을 변경하면서 복사 (예: 동일 디자인의 다른 사이즈)

**⚠️ NEW: 품목등록 기능 강화**
- **자재 유형별 매입처 필터:** 품목 등록 화면에서 매입처(발주처) 선택 시, 사용 중인 자재 유형에 따라 매입처 드롭다운 필터링 (원단 필드에는 원단 매입처, 마닐라 필드에는 마닐라 매입처 등)
- **소부 클릭 시 공정 자동 추가:** process_flags에서 소부 체크박스 클릭 시, 해당 공정 항목이 processes 배열에 자동 추가
- **공정 순서 변경:** 공정 목록에서 드래그 & 드롭으로 공정 순서 변경 가능

**인수 기준:**
- [ ] 거래처 선택 시 해당 거래처의 박스 품목 표시
- [ ] 품목 등록: 상자 형식 선택 → 치수 입력 → 재단 사이즈 자동 계산
- [ ] 원단 코드, 목형, 조판 연결 작동
- [ ] 공정 정보 (processes) 입력 작동
- [ ] 자재 정보 (materials) 입력 작동
- [ ] 수량별 단가 (quantity_tiers) 설정 작동
- [ ] 인쇄 이미지 업로드 (최대 4개) 작동
- [ ] 적재 정보 (pallet_info) 입력 작동
- [ ] 수주 이력 있는 품목 삭제 불가, 중지 (is_active=false)만 가능
- [ ] ⚠️ NEW: 하단 패널에 원자재/공정정보 및 납품이력 표시
- [ ] ⚠️ NEW: 납품이력에 날짜, 수량, 지대가, 박스 단가 항목별 표시
- [ ] ⚠️ NEW: 인쇄사양 패널에 인쇄 색상, 조판 정보, 이미지, 비고 표시
- [ ] ⚠️ NEW: 원본 삭제 옵션 포함 품목복사 작동
- [ ] ⚠️ NEW: 인쇄사양 복사 옵션 포함 품목복사 작동
- [ ] ⚠️ NEW: 타 거래처 품목복사 작동
- [ ] ⚠️ NEW: 제품변경 (변형 복사) 작동
- [ ] ⚠️ NEW: 매입처 드롭다운 자재 유형별 필터링
- [ ] ⚠️ NEW: 소부 체크박스 클릭 시 공정 항목 자동 추가
- [ ] ⚠️ NEW: 공정 목록 드래그 & 드롭 순서 변경 지원

### 10.12 목형 관리 (WoodenMoldList / WoodenMoldForm)

**인수 기준:**
- [ ] 목형 CRUD 작동
- [ ] 연결 품목 (해당 목형을 참조하는 BoxProduct) 목록 표시
- [ ] 연결 품목 있는 목형은 삭제 불가, 중지만 가능
- [ ] 목형 이미지 업로드 작동
- [ ] 상태 (active/suspended/damaged) 관리 작동

### 10.13 조판 관리 (PrintingPlateList / PrintingPlateForm)

**⚠️ NEW: 목록 뷰 추가 필드**
- **상자 형식:** 조판에 연결된 상자 형식 표시
- **최근 사용일:** 해당 조판을 사용한 가장 최근 생산에서 자동 입력
- **연결 품목 수:** 해당 조판을 참조하는 BoxProduct 수

**인수 기준:**
- [ ] 조판 CRUD 작동
- [ ] 연결 품목 (해당 조판을 참조하는 BoxProduct) 목록 표시
- [ ] 연결 품목 있는 조판은 삭제 불가, 중지만 가능
- [ ] 조판 이미지 업로드 작동
- [ ] 인쇄 색상 및 판 수 입력 작동
- [ ] ⚠️ NEW: 목록에 상자 형식 컬럼 표시
- [ ] ⚠️ NEW: 최근 사용일 자동 입력 및 표시
- [ ] ⚠️ NEW: 연결 품목 수 표시

### 10.14 원단 코드 (PaperCodeList / PaperCodeForm)

**인수 기준:**
- [ ] 원단 코드 CRUD 작동
- [ ] 골종 (SW/DW/TW/SF) 선택 작동
- [ ] 원단 구성 설정 작동 (레이어별 원지 코드 선택)
- [ ] 매입처별 단가 (최대 5개) 입력 작동
- [ ] 표준 단가 설정 작동

### 10.15 MES (MESMain)

**⚠️ NEW: 레이아웃 재설계**
- **바코드/검색 위치 변경:** 바코드 스캔 입력 및 검색 기능을 더 눈에 잘 띄고 접근하기 쉬운 위치로 이동 (구체적 레이아웃은 디자인팀과 협의 예정)
- **클릭 시 공정별 생산 수량 표시:** MES 보드에서 제품/수주 클릭 시, 공정 단계별 생산 수량 분석 표시 (Code SRS에 부분적으로 기술되어 있었으나, 이번에 확정 요구사항으로 확인)

**인수 기준:**
- [ ] system_type == "mes" 사용자만 접근 가능
- [ ] 당일 생산계획이 공정/기계별로 표시
- [ ] 제품 선택 → 시작 버튼 작동 (Production.status → in_progress)
- [ ] 완료 시 수량/불량 입력 다이얼로그 표시
- [ ] 선공정 미완료 시 다음 공정 시작 차단
- [ ] 바코드 스캔 제품 조회 작동
- [ ] ⚠️ NEW: 제품 클릭 시 공정별 생산 수량 분석 표시
- [ ] 원단 매입처 및 원단 입고 수량 표시
- [ ] 당일 동일 제품 재입력 허용
- [ ] 현품표/라벨 출력 작동
- [ ] ⚠️ NEW: 업데이트된 레이아웃에 따라 바코드/검색 필드 위치 변경

### 10.16 일반 설정 (GeneralSettingsPage)

**탭:** 박스 설정, 자재 설정, 수주 설정, 생산/재고 설정, 납품 설정, 견적/세금계산서 설정

**인수 기준:**
- [ ] 6개 탭 모두 표시 및 전환 정상 작동
- [ ] 각 탭의 설정 저장/불러오기 정상 작동
- [ ] 박스 설정: 상자 형식 마진 기본값, 재단 관련 설정 저장
- [ ] 자재 설정: 원단 매입처 표시 수, 기본 골종 설정 가능
- [ ] 수주 설정: 수주/발주 번호 형식, 자동 생성 설정 가능
- [ ] 생산/재고: 미생산 처리, 공정 순서 제약 켜기/끄기, 마이너스 재고 토글
- [ ] 납품: 납품 번호 형식, 기본 납품서 형식, 기본 파렛트 유형
- [ ] 견적/세금계산서: 견적 번호 형식, 기본 유효 기간, 기본 세율

### 10.17 회사 설정 (CompanySettings)

**인수 기준:**
- [ ] 회사명, 대표자, 사업자등록번호, 업태/업종, 주소, 전화, 팩스 입력 작동
- [ ] 회사 로고 이미지 업로드 작동
- [ ] 회사 직인 이미지 업로드 작동
- [ ] 은행 정보 (은행명, 계좌번호, 예금주) 입력 작동
- [ ] 저장 시 CompanyProfile 엔티티에 반영

### 10.18 파렛트 관리 (PalletManagement) — ⚠️ NEW: 확장

**⚠️ NEW: 엔티티 및 기능 확장**
파렛트 모듈은 Code SRS 대비 대폭 확장됨:

- **보관료:** 파렛트 거래별 보관료 추적
- **이동전표금액:** 파렛트 이동 전표의 금액 기록
- **규격:** 각 파렛트 유형에 상세 사양 정보 포함 가능

**⚠️ NEW: 규격 등록 화면**
- 파렛트 사양을 등록/관리하기 위한 전용 화면/모달
- 필드: 명칭, 치수 (장/폭/고), 중량, 자재, 비고

**⚠️ NEW: 파렛트 재고 현황**
- 현재 파렛트 재고를 보여주는 대시보드 뷰
- 거래처별, 파렛트 유형별 분류
- 표시: 현재 잔량, 총 입고, 총 출고, 발생 보관료

**인수 기준:**
- [ ] 파렛트 입출고 거래 입력 작동
- [ ] 거래 시 잔량 자동 계산 작동
- [ ] ⚠️ NEW: 보관료 필드 입력 및 추적 작동
- [ ] ⚠️ NEW: 이동전표금액 필드 입력 작동
- [ ] ⚠️ NEW: 규격 등록 화면 작동
- [ ] ⚠️ NEW: 파렛트 재고 현황 뷰에 거래처별, 유형별 분류 표시

---

## 11. 핵심 흐름

### 11.1 수주 → 납품 → 세금계산서 메인 흐름

```
1. 수주 입력 (SalesOrder 생성, status=pending)
   |
2. 발주 입력 (PurchaseOrder 생성)
   -> SalesOrder.is_ordered = true
   -> SalesOrder.manila_order_qty / paper_order_qty 갱신
   |
3. 입고 입력 (Receiving 생성)
   -> PurchaseOrder.items[].received_qty 갱신
   -> PurchaseOrder.status 전환 (partial_received / received)
   -> SalesOrder.manila_received_qty / paper_received_qty 갱신
   |
4. 생산계획 (ProductionPlan 생성)
   -> 공정/기계 배정
   -> 생산 순서 설정
   |
5. MES 생산 (Production 생성/갱신)
   -> 시작: Production.status = in_progress
   -> 완료: Production.status = completed, 수량/불량 기록
   -> SalesOrder.produced_qty 갱신
   -> SalesOrder.status = in_production / produced
   |
6. 출하계획 확인
   -> 미납품 현황 확인
   |
7. 납품 입력 (Delivery 생성)
   -> SalesOrder.delivered_qty 갱신
   -> SalesOrder.status = partial_delivery / completed
   -> PalletTransaction 생성 (파렛트 출고 시)
   |
8. 세금계산서 발행 (Invoice 생성)
   -> Delivery.status = invoiced, is_invoiced = true
   -> 또는 SalesOrder.invoice_status = issued
```

### 11.2 수금/지급 흐름

```
1. 세금계산서 발행 (Invoice, status=issued)
   |
2. 수금 입력 (PaymentTransaction, type=collection)
   -> Invoice.amount_paid 갱신
   -> Invoice.status = partial / paid
   |
3. 잔액 관리
   -> Invoice.balance_due = total_amount - amount_paid
```

---

## 12. MES 흐름

### 12.1 기본 흐름

1. 생산계획에서 당일 생산 품목 확인
2. 제품 선택 → 생산 시작 (Production.status → in_progress, start_time 기록)
3. 생산 완료 → 수량/불량 입력 (Production.status → completed, end_time 기록)
4. 다음 공정으로 이동

### 12.2 공정 순서 제약 (BR-04)

- ProductionPlan.process_plans에서 이전 순서 공정이 `completed`가 아닌 경우
- 다음 공정 시작 차단
- "선공정 미완료" 메시지 표시
- 이 제약은 일반 설정에서 켜기/끄기 전환 가능

### 12.3 설비 변경

- 설비 보기에서 제품 다중 선택
- 동일 공정의 다른 설비로 일괄 이동
- ProductionPlan.process_plans[].equipment_id 갱신

### 12.4 미생산 처리

- 일반 설정에서 설정 가능:
  - 다음 날로 자동 이월
  - 삭제
  - 수동 처리

### 12.5 MES 표시 정보

- 원단 매입처 및 원단 입고 수량 표시
- 제품 클릭 → 공정별 생산 수량 표시
- 당일 동일 제품 재입력 허용

---

## 13. 인쇄 출력물 사양

### 13.1 발주서

| 항목 | 상세 |
|------|------|
| 출력 화면 | PurchaseOrderList |
| 데이터 | 매입처, 발주일, 품목, 규격, 재단 사이즈, 수량, 단가, 금액, 납기, 비고 |
| 옵션 | 마닐라/원단/외주/일반 공통 형식 |
| 형식 | A4 세로, 회사 로고/직인 |
| 예외 | ⚠️ SCOPE TBD: 외주 발주서 양식 세분화 (완제품 / 공정별) — 고객이 이번 빌드에 요청 |

### 13.2 납품서

| 항목 | 상세 |
|------|------|
| 출력 화면 | DeliveryList, DeliveryForm |
| 데이터 | 거래처, 납품일, 품목, 규격, 수량, 단가, 공급가액, 세액, 합계, 비고 |
| 옵션 | 회사명 숨김, 금액 숨김, 수량만, 수령인 정보 표시/숨김 |
| 형식 | A4 세로, 다양한 형식 |
| 예외 | 고정 행 수 미만 시 빈 행 채움 |

### 13.3 납품 확인서

| 항목 | 상세 |
|------|------|
| 출력 화면 | DeliveryList, DeliveryForm |
| 데이터 | 거래처, 납품일, 품목, 수량, 서명란 |
| 형식 | A4 세로 |
| 예외 | quantity 필드 우선, delivery_qty를 대체 사용 |

### 13.4 현품표

| 항목 | 상세 |
|------|------|
| 출력 화면 | SalesOrderList, MES |
| 데이터 | 거래처, 품명, 규격 (장x폭x고), 수량, 바코드 |
| 옵션 | 간략 / 상세 형식 선택 |
| 형식 | 사용자 정의 라벨 사이즈 |

### 13.5 작업지시서

| 항목 | 상세 |
|------|------|
| 출력 화면 | SalesOrderList, PurchaseOrderList |
| 데이터 | 거래처, 품명, 박스 코드, 상자 형식, 규격, 재단 사이즈, 주문 수량, 납기, 원단 정보, 공정 정보, 작업 지시 사항, 바코드 |
| 형식 | A4 세로 |
| 예외 | 입고 작업지시서 (ReceivingWorkOrder)는 별도 형식 |

### 13.6 견적서

| 항목 | 상세 |
|------|------|
| 출력 화면 | BoxQuotation |
| 데이터 | 거래처, 일자, 유효 기간, 품목 (품명, 자재, 상자 형식, 규격, 수량, 단가, 금액), 공급가액, 부가세, 합계, 비고 |
| 옵션 | 부가세 포함/미포함 표시 |
| 형식 | A4 세로, 회사 로고/직인 |

### 13.7 코드 테이블 인쇄

| 항목 | 상세 |
|------|------|
| 출력 화면 | BoxProductList, PartnerList, ManilaList, PaperCodeList, PalletManagement |
| 데이터 | 코드 테이블별 전체 목록 (필터 적용 가능) |
| 형식 | A4 세로/가로 |

### 13.8 생산계획표

| 항목 | 상세 |
|------|------|
| 출력 화면 | ProductionPlanPage |
| 데이터 | 계획일, 공정/기계별 품목 목록, 작업지시서, 주문 수량, 납기 |
| 옵션 | 공정별 / 기계별 |
| 형식 | A4 가로 |

---

## 14. 공통 규칙

### 14.1 날짜 기본값

- 수주일, 발주일, 입고일, 납품일: **오늘** 날짜 자동 입력

### 14.2 코드 테이블 / Enter 검색

- 모든 거래처 입력 필드에서:
  - 텍스트 없이 Enter → 전체 코드 테이블 팝업
  - 텍스트 입력 후 Enter → 필터된 코드 테이블 팝업
  - 드롭다운 목록 없음 (팝업 방식 사용 필수)

### 14.3 내보내기/전송 (모든 인쇄 출력물)

모든 인쇄 출력물에 DocumentExportToolbar 컴포넌트:

| 기능 | 설명 |
|------|------|
| 인쇄 | 메뉴별 프린터 설정 (localStorage) |
| Excel | CSV 다운로드 (UTF-8 BOM) |
| 이미지 | html2canvas를 통한 PNG 캡처 |
| 팩스 | 팩스 번호 입력 → ExportLog에 pending 상태로 기록 |
| 이메일 | 이메일/제목/본문 입력 → ExportLog에 pending 상태로 기록 |

### 14.4 중복 품목

- 발주/입고/납품에서 동일 제품 여러 행 허용
- 하나의 전표 내에서 동일 제품이 여러 번 등록 가능
- 추가 입력 시 잔량 재표시

### 14.5 조정 (재고/미납품) 처리

- `adjusted_stock_qty`: 조정 재고 (우선 적용)
- `adjusted_undelivered_qty`: 조정 미납품 (우선 적용)
- 조정 내역은 StockAdjustmentLog에 기록
- 이력은 별도 페이지 (/StockAdjustmentLogPage, 새 창)에서 확인 가능

### 14.6 카테고리 탐색 유지

- 상위 카테고리 (예: 박스 업무) 클릭 후, 하위 페이지 이동 시 하위 메뉴 목록 유지 표시
- 현재 페이지의 상위 카테고리 하위 메뉴 항상 표시

### 14.7 삭제 제한 / 데이터 무결성

| 대상 | 제한 조건 | 대안 |
|------|-----------|------|
| SalesOrder | is_ordered == true (발주 존재) | - |
| PurchaseOrder | 품목 중 received_qty > 0 존재 | - |
| BoxProduct | 수주 이력 존재 | 중지 (is_active=false) |
| WoodenMold | linked_product_count > 0 | 중지 (status=suspended) |
| PrintingPlate | related_products 존재 | 중지 (is_active=false) |
| Partner | 거래 이력 존재 | 비활성 (is_suspended=true) |

### 14.8 ⚠️ NEW: 월별 불량/부족 보고서 (공용)

- **월별 불량 보고서:** 해당 월의 제품/공정/기계별 불량 수량 및 불량률 집계
- **월별 부족 보고서:** 미납품 잔량 및 미충족 주문 수량
- 경영 정보 섹션에서 접근하거나 모듈 전반에서 사용 가능한 공용 보고서
- 인수 기준:
  - [ ] 월별 불량 보고서가 제품/공정/기계별 불량 집계 표시
  - [ ] 월별 부족 보고서가 미납품 잔량 표시
  - [ ] 기간 (월) 선택기 작동
  - [ ] Excel 내보내기 작동

---

## 15. 설정

### 15.1 회사 설정 (CompanySettings → CompanyProfile)

- 회사명, 대표자, 사업자등록번호, 업태/업종
- 주소, 전화, 팩스, 이메일, 웹사이트
- 회사 로고 이미지 업로드
- 회사 직인 이미지 업로드
- 은행 정보 (은행명, 계좌번호, 예금주)
- 공인인증서 등록 (UI만, 실제 연동은 향후)

### 15.2 사용자 설정 (UserSettings → MenuPermission + User)

- 사용자 구분: 사무실 (admin) / 영업 (user) / 현장/MES (mes)
- 메뉴별 권한: can_view, can_edit, can_delete, can_export
- MES 사용자: 담당 설비 지정 (mes_equipment)
- 사번, 부서, 직위 관리

### 15.3 일반 설정 탭 (GeneralSettingsPage → BoxSettings 등)

| 탭 | 내용 | 엔티티 |
|----|------|--------|
| 박스 설정 | 상자 형식 마진 기본값, 원단 폭 범위 (1050~2200mm), 재단 기준 (마루가/베리가), 양축 전개, 단가 소수점 토글, 사양서 형식 | BoxSettings |
| 자재 설정 | 원단 매입처 표시 수 (기본 5), 기본 골종, 가공 비율 | BoxSettings |
| 수주 설정 | 수주/발주 번호 형식, 자동 생성 토글, 채번 체계 | BoxSettings |
| 생산/재고 | 미생산 처리 (이월/삭제/수동), 공정 순서 제약 켜기/끄기, 마이너스 재고 토글 | BoxSettings |
| 납품 | 납품 번호 형식, 기본 납품서 형식, 기본 파렛트 유형 | BoxSettings |
| 견적/세금계산서 | 견적 번호 형식, 기본 유효 기간, 기본 세율 (10%), 기본 일반과세/영세율 | BoxSettings |

---

## 16. 향후 개발 항목

| # | 항목 | 설명 | 우선순위 | 이번 빌드 상태 |
|---|------|------|----------|----------------|
| F-01 | 외주 발주서 양식 세분화 | 완제품 / 공정별 분리 양식 | 중 | ⚠️ SCOPE TBD |
| F-02 | 공인인증서 전자서명 | 국세청 전자세금계산서 연동 | 높음 | 향후 |
| F-03 | 팩스 API 연동 | 외부 팩스 서비스 API | 중 | 향후 |
| F-04 | 이메일 API 연동 | 외부 이메일 발송 API | 중 | 향후 |
| F-05 | 원단 입고 엑셀 대사 | 공급업체 엑셀 업로드 → 입고 데이터 비교 | 중 | ⚠️ SCOPE TBD |
| F-06 | MES 조판 직접 등록 | MES 화면에서 조판 정보 등록 | 낮음 | ⚠️ SCOPE TBD |
| F-07 | 전자세금계산서 발행 | 국세청 HomeTax 자동 발행 | 높음 | 향후 |
| F-08 | 모바일 최적화 UX | MES/영업용 전용 모바일 UX | 중 | 향후 |
| F-09 | 다국어 지원 | 영어/중국어 UI 지원 | 낮음 | 향후 |
| F-10 | 자동 분개 | 세금계산서 발행 시 자동 회계 분개 | 중 | 향후 |
| F-11 | ERP-회계 연동 | 외부 회계 시스템 동기화 | 낮음 | 향후 |
| F-12 | 재고 바코드 스캔 | 바코드 기반 실물 재고 조사 | 낮음 | 향후 |

---

## 부록: ⚠️ NEW 항목 전체 요약 (고객 피드백 반영)

견적 산출 편의를 위해, 고객 피드백에서 확인된 모든 신규 요구사항을 통합 정리:

| # | 영역 | 요구사항 | 섹션 |
|---|------|----------|------|
| G-01 | 발주 | 수주 불러오기 — 두 가지 모드 (전체 수주 / 발주처별) | 10.3 |
| G-02 | 발주/입고/납품 | 자재 유형별 동적 컬럼 세트 (원단/마닐라/외주/일반) | 10.3, 10.4, 10.8 |
| G-03 | 박스 품목 | 하단 패널: 원자재/공정정보 + 납품이력 (날짜/수량/지대가/박스 단가) | 10.11 |
| G-04 | 박스 품목 | 공정/납품이력 탭을 인쇄사양 패널로 대체 | 10.11 |
| G-05 | 박스 품목 | 품목복사 옵션 (원본 삭제, 인쇄사양 복사, 타 거래처, 제품변경) | 10.11 |
| G-06 | 박스 품목 | 자재 유형별 매입처 필터, 소부 자동 공정 추가, 공정 순서 변경 | 10.11 |
| G-07 | 세금계산서 | 전자/종이 형식 필드, 과세 유형 (일반과세/영세율), 문서 유형 (영수/청구) | 10.10, 8.7 |
| G-08 | 파렛트 | 엔티티 확장 (보관료, 이동전표금액, 규격) + 규격 등록 + 재고 현황 | 10.18, 8.19 |
| G-09 | 조판 | 상자 형식, 최근 사용일, 연결 품목 수 필드 추가 | 10.13, 8.11 |
| G-10 | 생산 | 일자별 및 거래처별 보기 추가 | 10.5 |
| G-11 | 생산계획 | 보기별 컬럼 세트 (공정별/기계별/거래처별/납기별) | 10.6 |
| G-12 | 견적 | 마이팩 스타일 일괄 입력 UX, 원가분석 패널 | 10.9 |
| G-13 | MES | 레이아웃 재설계 (바코드/검색 위치 변경), 클릭 시 공정별 생산 수량 표시 | 10.15 |
| G-14 | 공통 | 월별 불량/부족 보고서 | 14.8 |
| G-15 | 입고 | "전체 미입고 내역" 통합 조회 버튼 | 10.4 |

## 부록: ⚠️ SCOPE TBD 항목 전체 요약

Code SRS에서 향후 개발로 분류되었으나, 고객이 이번 빌드에 포함을 요청한 항목:

| # | Code SRS ID | 항목 | 섹션 |
|---|-------------|------|------|
| S-01 | F-05 | 원단 입고 엑셀 대사 (매입 엑셀 대사) | 2.2 |
| S-02 | F-06 | MES 조판번호 직접 등록 | 2.2 |
| S-03 | F-01 | 외주 발주서 양식 세분화 | 2.2, 13.1 |

---

*이 문서는 Code SRS v2.0 Final (2026-03-16)과 2026-03-24 기준 확인된 고객 피드백 반영 사항을 통합한 것입니다.*
*견적 산출 및 개발 계획 수립 시 단일 참조 문서로 활용하십시오.*