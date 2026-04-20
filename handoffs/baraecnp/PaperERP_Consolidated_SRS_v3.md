# PaperERP — Corrugated Box ERP/MES System
## Consolidated SRS for Estimation

**Version:** 3.0 (Consolidated)  
**Date:** 2026-03-24  
**Base document:** Code SRS v2.0 Final (2026-03-16)  
**Purpose:** Estimation reference for sales/dev team — incorporates all confirmed client feedback gaps  
**Client:** BaraeCNP

**Legend:**
- ⚠️ NEW — Confirmed new requirement from client feedback (not in Code SRS)
- ⚠️ SCOPE TBD — Listed as "future development" in Code SRS but client wants it in this build; scope to be confirmed

---

## 1. Project Overview

### 1.1 System Purpose

Integrated ERP/MES system for corrugated cardboard box manufacturers.  
Manages the full business process from sales orders through delivery and invoice issuance, with real-time production tracking via shop-floor MES.

### 1.2 Core Objectives

- Implement full flow: Sales Order → Purchase Order → Receiving → Production Plan → MES → Shipment Plan → Delivery → Invoice
- Match MyPack ERP/MES feature parity and UI/UX level
- Role-based access separation: Sales rep / Office / Shop floor
- Establish transaction ledger and management reporting framework

### 1.3 Tech Stack

- **Frontend:** React + Tailwind CSS + shadcn/ui
- **Data layer:** Base44 Entity (NoSQL-based backend service)
- **Routing:** React Router DOM
- **State management:** TanStack React Query
- **Other:** Framer Motion (animation), html2canvas (image capture), jsPDF (PDF generation), Recharts (charts)

---

## 2. Scope Definition

### 2.1 Build Scope (MVP)

| Area | Features | Notes |
|------|----------|-------|
| Box Business | Sales Order Ledger, Sales Order Entry, Purchase Order, Receiving, Production, Production Plan, Shipment Plan, Delivery, Inventory Mgmt, Quotation, Price Change Notice, Pallet | |
| Box Master Data | Box Products by Customer, Wooden Mold Mgmt, Printing Plate Mgmt, Vendor/Customer Mgmt, Manila Code, Paper Code, Unit Code | |
| Transaction Ledger | Invoice, Collection/Payment, AR Ledger, AP Ledger, Cash Book, Bank Ledger, Notes Ledger, Expense Ledger, Opening Balance | |
| Management Info | Daily Report, Monthly Summary, Cash Flow, Inventory Ledger, P&L Analysis, Sales Trend Analysis | |
| Settings | Company Settings, User Settings, General Settings (6 tabs), Email Settings, Fax (Send/Inbox/Sent) | |
| MES | MES Main, Production Start, Production Complete, Barcode Scan, Product Info, Print Info, Label Output | |
| Print Outputs | Purchase Order Form, Delivery Statement, Product Label, Work Order, Quotation, Code Table Print | |
| Common | Excel/Image/Fax/Email export UI, per-menu printer settings, send log | |

### 2.2 Future Development (Not in this build unless marked)

| ID | Item | Description | Current State |
|----|------|-------------|---------------|
| F-01 | Outsource PO form variants | Separate forms for finished product vs. per-process | ⚠️ SCOPE TBD — client wants this now; common form only in Code SRS |
| F-02 | Digital certificate e-signature | e-Tax invoice integration with NTS | UI/registration only |
| F-03 | Fax actual API integration | External fax service API | Log only (pending) |
| F-04 | Email actual API integration | External email sending API | Log only (pending) |
| F-05 | Paper receiving Excel reconciliation | Upload supplier Excel → compare with receiving data | ⚠️ SCOPE TBD — client wants this now; not implemented in Code SRS |
| F-06 | MES direct printing plate registration | Register plate info directly from MES screen | ⚠️ SCOPE TBD — client wants this now; not implemented in Code SRS |
| F-07 | e-Tax invoice issuance | NTS HomeTax integration | Not implemented |
| F-08 | Mobile-optimized UX | Dedicated mobile UX for MES and sales reps | Basic responsive only |
| F-09 | Multi-language | EN/CN UI support | KR only |
| F-10 | Auto journal entries | Auto accounting entries on invoice issuance | Not implemented |
| F-11 | ERP-Accounting integration | External accounting system sync | Not implemented |
| F-12 | Inventory count barcode | Barcode-based physical inventory | Not implemented |

### 2.3 Out of Scope / Placeholder

| Item | Description |
|------|-------------|
| Auto journal entries | No auto debit/credit on invoice issuance (manual) |
| ERP-Accounting integration | No external accounting system integration |
| Inventory count barcode | No barcode scanning for physical inventory |
| Payroll/HR module | Out of scope |
| CRM module | Out of scope |

---

## 3. User Roles & Permissions

### 3.1 Office (admin)

- `role: "admin"`, `system_type: "erp"`
- Full menu access
- All data CRUD
- User management, settings, permission management
- Can configure other users' menu permissions (MenuPermission)

### 3.2 Sales Rep (sales/user)

- `role: "user"`, `system_type: "erp"`
- View only own assigned customers' SO/PO/Receiving/Box Products
- Can view Delivery, Invoice (own customers only)
- No access to Settings, User Management
- Fine-grained per-menu control via MenuPermission (can_view, can_edit, can_delete, can_export)

### 3.3 Shop Floor / MES (mes)

- `role: "user"`, `system_type: "mes"`
- MES screens only
- Redirected to /MESMain on login
- Production start/complete entry, barcode scan
- No ERP menu access
- `mes_equipment` field designates assigned equipment

---

## 4. Permission Matrix

### 4.1 Menu-Level Access

| Menu/Function | Office (admin) | Sales Rep (user) | MES |
|---------------|:-:|:-:|:-:|
| **Box Business** | | | |
| SO Ledger view | O | Own customers only | X |
| SO create/edit | O | O (own customers) | X |
| SO delete | O | X | X |
| PO view | O | Own customers only | X |
| PO create/edit | O | Limited | X |
| Receiving view | O | Own customers only | X |
| Receiving create/edit | O | Limited | X |
| Production view | O | O (read-only) | X |
| Production Plan | O | O (read-only) | X |
| Shipment Plan | O | O (own customers) | X |
| Delivery view/create | O | Own customers only | X |
| Inventory Mgmt | O | O (read-only) | X |
| Quotation | O | O (own customers) | X |
| Price Change | O | O (own customers) | X |
| Pallet | O | O (read-only) | X |
| **Box Master Data** | | | |
| Box Products by Customer | O | Own customers only | X |
| Product create/edit | O | Limited | X |
| Wooden Mold Mgmt | O | O (read-only) | X |
| Printing Plate Mgmt | O | O (read-only) | X |
| Vendor/Customer Mgmt | O | X | X |
| Manila Code | O | X | X |
| Paper Code | O | X | X |
| Unit Code | O | X | X |
| **Transaction Ledger** | | | |
| Invoice | O | Own customers only | X |
| Collection/Payment | O | X | X |
| AR/AP/Cash/Bank/Notes/Expense/Opening | O | X | X |
| **Management Info** | | | |
| Daily Report | O | O (own customers) | X |
| Monthly Summary | O | X | X |
| Cash Flow | O | X | X |
| Inventory Ledger | O | X | X |
| P&L Analysis | O | X | X |
| Sales Trend | O | O (own customers) | X |
| **Settings** | | | |
| All settings menus | O | X | X |
| **MES** | | | |
| MES Main / Production / Barcode / Product Info | X | X | O |

### 4.2 Fine-Grained Permissions (MenuPermission Entity)

Per user, per menu:

| Permission | Description |
|------------|-------------|
| `can_view` | View access |
| `can_edit` | Create/edit access |
| `can_delete` | Delete access |
| `can_export` | Export (Excel/Image/Fax/Email) access |

---

## 5. Menu Structure (IA)

### 5.1 Box Business

| Menu | Route | Description | menu_key |
|------|-------|-------------|----------|
| Sales Order Ledger | /SalesOrderList | SO status overview (by customer/due date/sales rep) | sales_order_list |
| Sales Order | /SalesOrderEntry | SO create/edit (popup) | sales_order |
| Purchase Order | /PurchaseOrderList | PO status and entry | purchase_order |
| Receiving | /ReceivingList | Receiving status and entry | receiving |
| Production | /ProductionList | Production results view | production |
| Production Plan | /ProductionPlanPage | Production plan management | production_plan |
| Shipment Plan | /ShipmentPlan | Shipment schedule | shipment_plan |
| Delivery | /DeliveryList | Delivery status and entry | delivery |
| Inventory Mgmt | /InventoryManagement | Box inventory status and adjustment | inventory |
| Quotation | /BoxQuotation | Quotation creation and management | quotation |
| Price Change | /PriceChange | Price change history | price_change |
| Pallet | /PalletManagement | Pallet in/out management, balance check | pallet |

### 5.2 Box Master Data

| Menu | Route | Description | menu_key |
|------|-------|-------------|----------|
| Box Products by Customer | /BoxProductList | Per-customer product management | box_product |
| Wooden Mold Mgmt | /WoodenMoldList | Mold registration/management/linked products | wooden_mold |
| Printing Plate Mgmt | /PrintingPlateList | Plate registration/management/linked products | printing_plate |
| Vendor/Customer Mgmt | /PartnerList | Partner registration/management | partner |
| Manila Code | /ManilaList | Manila code management | manila_code |
| Paper Code | /PaperCodeList | Paper code management | paper_code |
| Unit Code | /UnitCodePage | Base code management | unit_code |

### 5.3 Transaction Ledger

| Menu | Route | Description | menu_key |
|------|-------|-------------|----------|
| Invoice | /BillingList | Sales/purchase tax invoices | billing |
| Collection/Payment | /PaymentCollection | Collection and payment management | payment |
| AR Ledger | /AccountsReceivable | Accounts receivable | accounts_receivable |
| AP Ledger | /AccountsPayable | Accounts payable | accounts_payable |
| Cash Book | /CashBook | Cash in/out management | cash_book |
| Bank Ledger | /BankLedger | Bank transaction history | bank_ledger |
| Notes Ledger | /NoteLedger | Promissory note management | note_ledger |
| Expense Ledger | /ExpenseLedger | General expense management | expense_ledger |
| Opening Balance | /OpeningBalance | Opening balance setup | opening_balance |

### 5.4 Management Information

| Menu | Route | Description | menu_key |
|------|-------|-------------|----------|
| Daily Report | /DailyReport | Daily performance report | daily_report |
| Monthly Summary | /MonthlySummary | Monthly summary | monthly_summary |
| Cash Flow | /CashFlow | Cash flow status | cash_flow |
| Inventory Ledger | /InventoryLedger | Inventory in/out ledger | inventory_ledger |
| P&L Analysis | /ProfitLossAnalysis | Profit & loss analysis | profit_loss |
| Sales Trend | /SalesAnalysis | Sales trend analysis | sales_analysis |

### 5.5 Settings

| Menu | Route | Description | menu_key |
|------|-------|-------------|----------|
| Company Settings | /CompanySettings | Company basic info | company_settings |
| User Settings | /UserSettings | User/permission setup | user_settings |
| General Settings | /GeneralSettingsPage | 6-tab settings | general_settings |
| Email Send | /EmailSettings | Email configuration | email_settings |
| Send Fax | /SendFax | Fax sending | send_fax |
| Received Fax | /ReceivedFax | Received fax inbox | received_fax |
| Sent Fax | /SentFax | Sent fax history | sent_fax |

### 5.6 MES (Shop Floor Only)

| Menu | Route | Description |
|------|-------|-------------|
| MES Main | /MESMain | Production plan board, per-process status |

---

## 6. Status Definitions

### 6.1 SalesOrder

| Status | Display | Meaning | Transition |
|--------|---------|---------|------------|
| `pending` | Pending | SO registered, no production/delivery yet | Default on creation |
| `in_production` | In Production | Production records linked | Auto when Production record linked |
| `produced` | Produced | Order qty met | produced_qty >= order_qty |
| `partial_delivery` | Partial Delivery | Some delivered | 0 < delivered_qty < order_qty |
| `completed` | Delivered | Full qty delivered | delivered_qty >= order_qty |
| `cancelled` | Cancelled | SO cancelled | Manual (only if no PO) |

**Derived statuses (UI badge only, not stored):**

| Display | Condition |
|---------|-----------|
| Not Ordered | is_ordered == false |
| PO In Progress | is_ordered == true && no receiving |
| Received | PO qty fully received |
| In Production | produced_qty > 0 && < order_qty |
| Produced | produced_qty >= order_qty |
| Delivered | delivered_qty >= order_qty |

### 6.2 PurchaseOrder

| Status | Display | Meaning | Transition |
|--------|---------|---------|------------|
| `draft` | Draft | PO being prepared | Default |
| `ordered` | Ordered | PO confirmed | User confirms |
| `partial_received` | Partial Received | Some items received | Some items received_qty > 0 |
| `received` | Fully Received | All items received | All items received_qty >= order_qty |
| `cancelled` | Cancelled | PO cancelled | Only before any receiving |

### 6.3 Receiving

No separate status field. Receiving entry = immediate confirmation.  
Updates related PurchaseOrder.items[].received_qty and auto-transitions PO status.

### 6.4 ProductionPlan

| Status | Display | Meaning | Transition |
|--------|---------|---------|------------|
| `draft` | Draft | Plan in progress | Default |
| `confirmed` | Confirmed | Plan confirmed | User action |
| `in_progress` | In Progress | Production started | Any process_plan is in_progress |
| `completed` | Completed | All processes done | All process_plans completed |
| `cancelled` | Cancelled | Plan cancelled | Before production starts |

**process_plans[].status:**

| Status | Meaning |
|--------|---------|
| `pending` | Waiting |
| `in_progress` | In progress |
| `completed` | Completed |

### 6.5 Production

| Status | Display | Meaning | Transition |
|--------|---------|---------|------------|
| `planned` | Planned | Assigned from plan | Default |
| `in_progress` | In Progress | Production started | MES start button |
| `completed` | Completed | Production done | MES complete button + qty entry |
| `cancelled` | Cancelled | Cancelled | User action |

### 6.6 Delivery

| Status | Display | Meaning | Transition |
|--------|---------|---------|------------|
| `draft` | Draft | Being prepared | Default |
| `delivered` | Delivered | Confirmed | User action |
| `invoiced` | Invoiced | Invoice issued | When Invoice linked |

### 6.7 Invoice

| Status | Display | Meaning | Transition |
|--------|---------|---------|------------|
| `draft` | Draft | Being prepared | Default |
| `issued` | Issued | Invoice issued | User action |
| `sent` | Sent | Sent to customer | Email/fax sent |
| `paid` | Paid | Fully collected | amount_paid >= total_amount |
| `partial` | Partial | Partially collected | 0 < amount_paid < total_amount |
| `overdue` | Overdue | Past due | today > due_date && balance > 0 |
| `cancelled` | Cancelled | Cancelled | Only if no payments |

### 6.8 MES Work Status

Composite display from Production + ProductionPlan.process_plans:

| Display | Condition |
|---------|-----------|
| Waiting | process_plans[].status == "pending" |
| In Progress | process_plans[].status == "in_progress" |
| Completed | process_plans[].status == "completed" |
| Prior Process Incomplete | Previous-sequence process not completed when start attempted |

---

## 7. Business Rules

| # | Rule | Description | Applies To |
|---|------|-------------|------------|
| BR-01 | Duplicate line items allowed | Same product can appear in multiple lines within one PO/Receiving/Delivery. Remaining balance re-displayed for additional entry | PurchaseOrder, Receiving, Delivery |
| BR-02 | Adjusted values take priority | When displaying stock_qty or undelivered_qty, use adjusted_stock_qty / adjusted_undelivered_qty if set | SalesOrder, SO Ledger, Shipment Plan, Inventory |
| BR-03 | Invoice by billing_partner | If delivery has billing_partner_id, invoice groups by billing_partner. partner_id (customer) and billing_partner_id (billing entity) managed separately | Delivery, Invoice |
| BR-04 | Prior process must complete first | In ProductionPlan.process_plans, cannot start next sequence until previous is completed. Shows "Prior process not completed" message | MES, ProductionPlan |
| BR-05 | Restrict deletion of masters with history | BoxProduct: no delete if SO history (can suspend). WoodenMold/PrintingPlate: no delete if linked products (can suspend). Partner: no delete if transaction history (can mark inactive) | BoxProduct, WoodenMold, PrintingPlate, Partner |
| BR-06 | Sales rep data isolation | Sales reps see only data for customers in SalesPerson.assigned_partners | All list screens |
| BR-07 | MES-only users | system_type == "mes" users redirect to /MESMain. No ERP menu access | Layout, Routing |
| BR-08 | Stock adjustment audit log | Any change to adjusted_stock_qty or adjusted_undelivered_qty must log to StockAdjustmentLog (before/after, reason, operator) | SalesOrder, StockAdjustmentLog |
| BR-09 | Partial processing allowed | Partial receiving on PO, partial delivery on SO, partial payment on Invoice — each transitions to respective partial status | PurchaseOrder, SalesOrder, Invoice |
| BR-10 | Print output options | Delivery statement: hide company name, hide amounts, qty-only options. Product label: simple/detailed format | Print outputs |
| BR-11 | No SO delete if PO exists | SalesOrder.is_ordered == true → delete blocked | SalesOrder |
| BR-12 | No PO delete if receiving exists | If any PO item has received_qty > 0 → delete blocked | PurchaseOrder |
| BR-13 | Date defaults to today | SO date, PO date, receiving date, delivery date default to today | All entry forms |
| BR-14 | Code table popup search | Partner input field: Enter → popup code table. Text + Enter → filtered code table popup. No dropdown list | All partner search fields |
| BR-15 | SO qty auto-calculation | undelivered_qty = order_qty - delivered_qty. stock_qty = produced_qty - delivered_qty. Adjusted values take priority | SalesOrder |
| BR-16 | Delivery updates SO qty | On delivery create/edit/delete, recalculate related SO.delivered_qty | Delivery → SalesOrder |
| BR-17 | Production updates SO qty | On production entry, update related SO.produced_qty | Production → SalesOrder |
| BR-18 | Pallet auto-balance calc | On PalletTransaction entry, auto-update PalletBalance (current_balance, total_in, total_out) | PalletTransaction → PalletBalance |

---

## 8. Entity Definitions (Data Dictionary)

> **Built-in fields (all entities):** `id`, `created_date`, `updated_date`, `created_by`

### 8.1 SalesOrder

| Field | Type | Req | Description | Notes |
|-------|------|:---:|-------------|-------|
| order_number | string | - | SO number | Auto-generated |
| order_date | date | Y | Order date | Default: today |
| category | enum | - | Category | "order" / "stock" |
| partner_id | string | Y | Customer ID | Partner ref |
| partner_name | string | - | Customer name | Denormalized |
| sales_person_id | string | - | Sales rep ID | SalesPerson ref |
| sales_person_name | string | - | Sales rep name | Denormalized |
| box_product_id | string | - | Box product ID | BoxProduct ref |
| box_code | string | - | Box code | |
| product_name | string | Y | Product name | |
| box_type_name | string | - | Box type | |
| dimensions | string | - | L*W*H | "000*000*000" format |
| paper_code | string | - | Paper code | |
| flute_type | string | - | Flute type | |
| po_number | string | - | P/O No. | Shipment reference |
| order_qty | number | - | Order qty | Default: 0 |
| unit_price | number | - | Unit price | Default: 0 |
| total_amount | number | - | Amount | order_qty x unit_price |
| delivery_date | date | - | Due date | |
| delivery_location_id | string | - | Delivery location ID | |
| delivery_location_name | string | - | Delivery location name | |
| produced_qty | number | - | Produced qty | Updated from Production |
| delivered_qty | number | - | Delivered qty | Updated from Delivery |
| undelivered_qty | number | - | Undelivered qty | = order_qty - delivered_qty |
| stock_qty | number | - | Stock qty | = produced_qty - delivered_qty |
| adjusted_stock_qty | number | - | Adjusted stock qty | Set on stock adjustment |
| adjusted_undelivered_qty | number | - | Adjusted undelivered qty | Set on stock adjustment |
| manila_order_qty | number | - | Manila PO qty | |
| manila_received_qty | number | - | Manila received qty | |
| paper_order_qty | number | - | Paper PO qty | |
| paper_received_qty | number | - | Paper received qty | |
| is_ordered | boolean | - | PO placed flag | Default: false |
| status | enum | - | Status | pending / in_production / produced / partial_delivery / completed / cancelled |
| invoice_status | enum | - | Invoice status | none / issued |
| notes | string | - | Notes | |
| work_instruction | string | - | Work instruction | |

### 8.2 PurchaseOrder

| Field | Type | Req | Description | Notes |
|-------|------|:---:|-------------|-------|
| po_number | string | Y | PO number | |
| po_date | date | Y | PO date | Default: today |
| partner_id | string | Y | Supplier ID | Partner ref |
| partner_name | string | - | Supplier name | |
| po_type | enum | - | PO type | manila / paper / outsource / other |
| items | array | - | PO items | PurchaseOrderItem[] |
| total_amount | number | - | Total amount | Default: 0 |
| vat_amount | number | - | VAT | Default: 0 |
| status | enum | - | Status | draft / ordered / partial_received / received / cancelled |
| notes | string | - | Notes | |

**PurchaseOrderItem:**

| Field | Type | Description | Notes |
|-------|------|-------------|-------|
| item_type | string | Item type | |
| item_code | string | Item code | |
| item_name | string | Product name | |
| spec | string | Specification | |
| cutting_size | string | Cutting size | |
| order_qty | number | Order qty | |
| received_qty | number | Received qty | Default: 0, updated on receiving |
| unit_price | number | Unit price | |
| amount | number | Amount | |
| delivery_date | date | Due date | |
| related_order_id | string | Related SO ID | SalesOrder ref |

### 8.3 Receiving

| Field | Type | Req | Description | Notes |
|-------|------|:---:|-------------|-------|
| receiving_number | string | Y | Receiving number | |
| receiving_date | date | Y | Receiving date | Default: today |
| partner_id | string | Y | Supplier ID | Partner ref |
| partner_name | string | - | Supplier name | |
| receiver_name | string | - | Receiver name | |
| receiving_type | enum | - | Receiving type | paper / manila / outsource / general |
| po_id | string | - | PO ID | PurchaseOrder ref |
| po_number | string | - | PO number | |
| items | array | - | Receiving items | ReceivingItem[] |
| total_qty | number | - | Total qty | Default: 0 |
| total_amount | number | - | Total amount | Default: 0 |
| vat_amount | number | - | VAT | Default: 0 |
| notes | string | - | Notes | |

**ReceivingItem:**

| Field | Type | Description | Notes |
|-------|------|-------------|-------|
| item_code | string | Item code | |
| item_name | string | Product name | |
| spec | string | Specification | |
| cutting_size | string | Cutting size | |
| ordered_qty | number | Ordered qty | |
| received_qty | number | Received qty | |
| unit_price | number | Unit price | |
| amount | number | Amount | |
| warehouse | string | Warehouse | |

### 8.4 ProductionPlan

| Field | Type | Req | Description | Notes |
|-------|------|:---:|-------------|-------|
| plan_number | string | - | Plan number | Auto-generated |
| plan_date | date | Y | Plan date | |
| sales_order_id | string | - | SO ID | SalesOrder ref |
| partner_id | string | - | Customer ID | |
| partner_name | string | - | Customer name | |
| product_name | string | - | Product name | |
| dimensions | string | - | L*W*H | |
| order_qty | number | - | Order qty | Default: 0 |
| delivery_date | date | - | Due date | |
| process_plans | array | - | Per-process plans | ProcessPlan[] |
| status | enum | - | Status | draft / confirmed / in_progress / completed / cancelled |
| notes | string | - | Notes | |

**ProcessPlan:**

| Field | Type | Description | Notes |
|-------|------|-------------|-------|
| sequence | number | Production order | |
| process_code_id | string | Process code ID | ProcessCode ref |
| process_name | string | Process name | |
| equipment_id | string | Equipment ID | Equipment ref |
| equipment_name | string | Equipment name | |
| planned_start_time | string | Planned start | HH:mm |
| planned_end_time | string | Planned end | HH:mm |
| actual_start_time | string | Actual start | MES input |
| actual_end_time | string | Actual end | MES input |
| actual_duration_minutes | number | Actual duration (min) | Auto-calculated |
| status | enum | Status | pending / in_progress / completed |
| notes | string | Notes | |

### 8.5 Production

| Field | Type | Req | Description | Notes |
|-------|------|:---:|-------------|-------|
| production_number | string | Y | Production number | |
| production_date | date | Y | Production date | |
| sales_order_id | string | - | SO ID | SalesOrder ref |
| order_number | string | - | SO number | |
| partner_id | string | - | Customer ID | |
| partner_name | string | - | Customer name | |
| box_code | string | - | Box code | |
| product_name | string | - | Product name | |
| paper_code | string | - | Paper code | |
| flute_type | string | - | Flute type | |
| dimensions | string | - | Dimensions | |
| cutting_size | string | - | Cutting size | |
| order_qty | number | - | Order qty | Default: 0 |
| production_qty | number | - | Production qty | Default: 0 |
| defect_qty | number | - | Defect qty | Default: 0 |
| good_qty | number | - | Good qty | = production_qty - defect_qty |
| status | enum | - | Status | planned / in_progress / completed / cancelled |
| start_time | string | - | Start time | |
| end_time | string | - | End time | |
| machine | string | - | Equipment | |
| worker | string | - | Worker | |
| material_used | array | - | Materials consumed | [{material_code, material_name, used_qty}] |
| notes | string | - | Notes | |

### 8.6 Delivery

| Field | Type | Req | Description | Notes |
|-------|------|:---:|-------------|-------|
| delivery_number | string | - | Delivery number | Auto-generated |
| delivery_date | date | Y | Delivery date | Default: today |
| partner_id | string | Y | Customer ID (billing entity) | Partner ref |
| partner_name | string | - | Customer name | |
| billing_partner_id | string | - | Billing partner ID (SO originator) | Invoice grouping basis |
| billing_partner_name | string | - | Billing partner name | |
| delivery_location_id | string | - | Delivery location ID | |
| delivery_location_name | string | - | Delivery location name | |
| vehicle_id | string | - | Vehicle ID | VehicleCode ref |
| vehicle_number | string | - | Vehicle number | |
| departure_time | string | - | Departure time | |
| memo | string | - | Memo | |
| items | array | - | Delivery items | DeliveryItem[] |
| total_qty | number | - | Total qty | Default: 0 |
| supply_amount | number | - | Supply amount | Default: 0 |
| vat_amount | number | - | Tax amount | Default: 0 |
| total_amount | number | - | Total | Default: 0 |
| pallet_outputs | array | - | Pallet outbound | [{pallet_type_id, pallet_type_name, quantity}] |
| transport_cost | number | - | Transport cost | Default: 0 |
| status | enum | - | Status | draft / delivered / invoiced |
| invoice_id | string | - | Invoice ID | Invoice ref |
| is_invoiced | boolean | - | Invoice issued flag | Default: false |

**DeliveryItem:**

| Field | Type | Description | Notes |
|-------|------|-------------|-------|
| sales_order_id | string | SO ID | SalesOrder ref |
| category | enum | Category | "order" / "stock" |
| product_name | string | Product name | |
| dimensions | string | L*W*H | |
| quantity | number | Quantity | |
| unit_price | number | Unit price | |
| supply_amount | number | Supply amount | |
| vat_amount | number | Tax amount | |
| vat_type | enum | VAT type | "included" / "excluded" |
| notes | string | Notes | |

### 8.7 Invoice

| Field | Type | Req | Description | Notes |
|-------|------|:---:|-------------|-------|
| invoice_number | string | - | Invoice number | Auto-generated |
| invoice_date | date | Y | Issue date | |
| invoice_type | enum | - | Issue type | sales_order / delivery / manual |
| partner_id | string | Y | Customer ID | Partner ref |
| partner_name | string | - | Customer name | |
| due_date | date | - | Payment due date | |
| status | enum | - | Status | draft / issued / sent / paid / partial / overdue / cancelled |
| related_document_type | enum | - | Related doc type | sales_order / delivery / none |
| related_document_ids | string[] | - | Related doc IDs | |
| items | array | - | Invoice items | InvoiceItem[] |
| supply_amount | number | - | Supply amount | Default: 0 |
| vat_amount | number | - | VAT | Default: 0 |
| total_amount | number | - | Total | Default: 0 |
| amount_paid | number | - | Amount paid | Default: 0 |
| balance_due | number | - | Balance | Default: 0 |
| currency | string | - | Currency | Default: "KRW" |
| notes | string | - | Notes | |
| ⚠️ NEW: invoice_format | enum | - | Format | "electronic" / "paper" — distinguishes e-invoice vs. paper invoice |
| ⚠️ NEW: tax_type | enum | - | Tax type | "normal" / "zero_rate" (일반과세/영세율) |
| ⚠️ NEW: document_type | enum | - | Document type | "receipt" / "claim" (영수/청구) |

**InvoiceItem:**

| Field | Type | Description |
|-------|------|-------------|
| product_id | string | Product ID |
| product_name | string | Product name |
| quantity | number | Quantity |
| unit_price | number | Unit price |
| tax_rate | number | Tax rate |
| discount_type | enum | Discount type (percentage / flat) |
| discount_value | number | Discount value |
| total | number | Total |

### 8.8 BoxProduct

| Field | Type | Req | Description | Notes |
|-------|------|:---:|-------------|-------|
| code | string | Y | Box code | |
| name | string | Y | Product name | |
| customer_id | string | - | Customer ID | Partner ref |
| customer_name | string | - | Customer name | |
| box_type_id | string | - | Box type ID | BoxType ref |
| box_type_name | string | - | Box type name | |
| paper_code_id | string | - | Paper code ID | PaperCode ref |
| paper_code | string | - | Paper code | |
| flute_type | string | - | Flute type | |
| dimensions | object | - | Box dimensions | {length, width, height, has_joint, has_flap} |
| cutting_size | object | - | Cutting size | {total_length, total_width, score} auto-calculated |
| material_type | enum | - | Material type | jigi / carton / color |
| wooden_mold_id | string | - | Mold ID | WoodenMold ref |
| wooden_mold_code | string | - | Mold number | |
| composition_id | string | - | Plate ID | PrintingPlate ref |
| composition_code | string | - | Plate number | |
| process_flags | object | - | Process checkboxes | {sobu, printing, coating, gold_foil, lamination, thomson, gluing, finished} |
| print_images | array | - | Print images | Max 4, [{url, order}] |
| cost_breakdown | object | - | Cost info | {material_cost, sub_material_cost, processing_cost, additional_cost, profit_rate, unit_price} |
| quantity_tiers | array | - | Qty-based pricing | [{min_qty, max_qty, unit_price, is_base, notes}] |
| processes | array | - | Process info | [{process_code_id, process_name, production_type, equipment_id, ...}] |
| materials | array | - | Material info | [{type, item_name, paper_code_id, cutting_length, cutting_width, ...}] |
| pallet_info | object | - | Stacking info | {pallet_type_id, banding_qty, stack_width/length/height, qty_per_pallet} |
| outsource_type | enum | - | Outsource type | none / partial / complete |
| min_order_qty | number | - | Minimum order qty | Default: 0 |
| optimal_stock_qty | number | - | Optimal stock qty | Default: 0 |
| is_active | boolean | - | Active flag | Default: true |
| memo | string | - | Memo | |

### 8.9 Partner

| Field | Type | Req | Description | Notes |
|-------|------|:---:|-------------|-------|
| code | string | - | Management code | Auto-generated |
| name | string | Y | Company name | |
| management_name | string | - | Management name | Internal use |
| partner_type | enum | - | Partner type | sales / purchase / both |
| purchase_types | string[] | - | Purchase categories | manila / paper / general / outsource |
| sales_types | string[] | - | Sales categories | box / paper / general |
| business_number | string | - | Business reg number | Digits only |
| sub_business_number | string | - | Sub-business number | |
| is_zero_rate | boolean | - | Zero-rate flag | Default: false |
| ceo_name | string | - | CEO name | |
| business_type | string | - | Business type | |
| business_category | string | - | Business category | |
| postal_code | string | - | Postal code | |
| address | string | - | Address | |
| phone | string | - | Phone | |
| fax | string | - | Fax | |
| email | string | - | Email | |
| reference_note | string | - | Reference note | Shown in partner list |
| delivery_note | string | - | Delivery note | Printed on delivery statement footer |
| sales_person | string | - | Sales rep | |
| purchase_person | string | - | Purchase rep | |
| bank_name | string | - | Bank name | |
| account_number | string | - | Account number | |
| account_holder | string | - | Account holder | |
| payment_terms | enum | - | Payment terms | cash / next_month_10/25/end / credit_15/30/45/60 |
| contacts | array | - | Contacts | Max 5, [{name, email, phone, notes, invoice_type, statement_type}] |
| delivery_locations | array | - | Delivery locations | Max 5, [{is_default, name, contact_name, contact_phone, full_address, notes}] |
| is_active | boolean | - | Active flag | Default: true |
| is_suspended | boolean | - | Suspended flag | Default: false |
| memo | string | - | Memo | |

### 8.10 WoodenMold

| Field | Type | Req | Description | Notes |
|-------|------|:---:|-------------|-------|
| code | string | - | Mold code | Auto-generated |
| name | string | Y | Mold number | |
| box_type_id | string | - | Box type ID | |
| box_type_name | string | - | Box type name | |
| flute_type | string | - | Flute type | |
| dimensions | object | - | Mold dimensions | {length, width, height} |
| cutting_length | number | - | Cutting length | Mold spec |
| cutting_width | number | - | Cutting width | Mold spec |
| partner_id | string | - | Customer ID | |
| partner_name | string | - | Customer name | |
| manufacturer | string | - | Manufacturer | |
| manufacture_date | date | - | Manufacture date | |
| location | string | - | Storage location | |
| status | enum | - | Status | active / suspended / damaged |
| last_used_date | date | - | Last used date | |
| linked_product_count | number | - | Linked product count | Default: 0 |
| notes | string | - | Notes | |
| image_url | string | - | Mold image | |
| is_active | boolean | - | Active flag | Default: true |

### 8.11 PrintingPlate

| Field | Type | Req | Description | Notes |
|-------|------|:---:|-------------|-------|
| code | string | - | Code | Auto-generated |
| plate_number | string | Y | Plate number | |
| dimensions | string | - | L x W x H | |
| print_color | string | - | Print color | |
| plate_count | number | - | Number of plates | Default: 1 |
| manufacture_date | date | - | Manufacture date | |
| notes | string | - | Notes | |
| image_url | string | - | Plate image URL | |
| related_products | array | - | Linked products | [{product_id, product_name, partner_name}] |
| is_active | boolean | - | Active flag | Default: true |
| ⚠️ NEW: box_type | string | - | Box type | Box type of the plate |
| ⚠️ NEW: last_used_date | date | - | Last used date | Auto-updated on production |
| ⚠️ NEW: linked_product_count | number | - | Linked product count | Auto-counted from BoxProduct refs |

### 8.12 PaperCode

| Field | Type | Req | Description | Notes |
|-------|------|:---:|-------------|-------|
| code | string | - | Paper code | Auto-generated |
| name | string | Y | Paper name | |
| flute_type | enum | Y | Flute type | SW / DW / TW / SF |
| composition | array | - | Paper composition | [{layer, raw_paper_id, raw_paper_code, raw_paper_name}] |
| composition_display | string | - | Composition display | e.g., "SC220 K K" |
| standard_price | number | - | Standard price | For cost calculation |
| supplier_prices | array | - | Per-supplier prices | [{supplier_id, supplier_name, price}] max 5 |
| is_active | boolean | - | Active flag | Default: true |
| notes | string | - | Notes | |

### 8.13 Manila

| Field | Type | Req | Description | Notes |
|-------|------|:---:|-------------|-------|
| code | string | - | Code | Auto-generated |
| name | string | Y | Manila name | |
| basis_weight | number | - | Basis weight | Default: 0 |
| standard_price | number | - | Standard price (per kg) | Default: 0 |
| supplier_prices | array | - | Per-supplier prices | [{supplier_id, supplier_name, price}] |
| is_active | boolean | - | Active flag | Default: true |

### 8.14 Equipment

| Field | Type | Req | Description | Notes |
|-------|------|:---:|-------------|-------|
| code | string | Y | Equipment code | |
| name | string | Y | Equipment name | |
| equipment_category | enum | - | Category | carton / color / jigi / other |
| process_code_id | string | - | Process code ID | ProcessCode ref |
| process_name | string | - | Process name | |
| production_unit | string | - | Production unit | Default: "매" (sheets) |
| price_unit | string | - | Price unit | Default: "매" (sheets) |
| work_infos | array | - | Work info list | [{name, work_unit, unit_price}] |
| defect_reasons | array | - | Defect reasons | [{name, fault_type(internal/external)}] |
| notes | string | - | Notes | |
| is_active | boolean | - | Active flag | Default: true |

### 8.15 ProcessCode

| Field | Type | Req | Description | Notes |
|-------|------|:---:|-------------|-------|
| code | string | Y | Process code | |
| name | string | Y | Process name | |
| process_category | enum | - | Category | carton / color / jigi / other |
| sequence | number | - | Process sequence | Default: 0 |
| production_unit | string | - | Production unit | Default: "매" |
| price_unit | string | - | Price unit | Default: "매" |
| is_active | boolean | - | Active flag | Default: true |

### 8.16 StockAdjustmentLog

| Field | Type | Req | Description | Notes |
|-------|------|:---:|-------------|-------|
| sales_order_id | string | Y | SO ID | SalesOrder ref |
| order_number | string | - | SO number | |
| partner_name | string | - | Customer name | |
| product_name | string | - | Product name | |
| adjustment_date | date | Y | Adjustment date | |
| before_stock_qty | number | - | Before stock qty | Default: 0 |
| after_stock_qty | number | - | After stock qty | Default: 0 |
| before_undelivered_qty | number | - | Before undelivered qty | Default: 0 |
| after_undelivered_qty | number | - | After undelivered qty | Default: 0 |
| reason | string | - | Reason | |
| adjusted_by | string | - | Operator | |

### 8.17 Inventory

| Field | Type | Req | Description | Notes |
|-------|------|:---:|-------------|-------|
| item_type | enum | Y | Item type | box / paper / manila |
| item_code | string | Y | Item code | |
| item_name | string | - | Product name | |
| partner_id | string | - | Customer ID | |
| partner_name | string | - | Customer name | |
| spec | string | - | Specification | |
| flute_type | string | - | Flute type | |
| cutting_size | string | - | Cutting size | |
| current_qty | number | - | Current stock | Default: 0 |
| unit_price | number | - | Unit price | Default: 0 |
| total_value | number | - | Stock value | Default: 0 |
| warehouse | string | - | Warehouse | |
| location | string | - | Location | |
| last_in_date | date | - | Last receiving date | |
| last_out_date | date | - | Last out date | |

### 8.18 BoxQuotation

| Field | Type | Req | Description | Notes |
|-------|------|:---:|-------------|-------|
| quotation_number | string | - | Quotation number | Auto-generated |
| quotation_date | date | Y | Quotation date | |
| valid_until | date | - | Validity period | |
| partner_id | string | Y | Customer ID | |
| partner_name | string | - | Customer name | |
| items | array | - | Item list | [{sort_order, box_code, product_name, paper_code, box_type, dimensions, quantity, unit_price, amount}] |
| supply_amount | number | - | Supply amount | Default: 0 |
| vat_amount | number | - | VAT | Default: 0 |
| total_amount | number | - | Total | Default: 0 |
| include_vat | boolean | - | VAT included flag | Default: true |
| notes | string | - | Notes (shown to customer) | |
| internal_memo | string | - | Internal memo | |
| status | enum | - | Status | draft / sent / accepted / rejected / expired |

### 8.19 Pallet Entities (Updated)

**PalletType:**
- code, name, description, is_active
- ⚠️ NEW: `spec` (규격 — pallet dimensions/specification)

**PalletTransaction:**
- transaction_number, transaction_date, transaction_type(in/out), partner_id, pallet_type, quantity, notes
- ⚠️ NEW: `transfer_slip_amount` (이동전표금액 — transfer document amount)
- ⚠️ NEW: `storage_fee` (보관료 — storage fee)

**PalletBalance:**
- partner_id, pallet_type, current_balance, total_in, total_out, last_transaction_date

**⚠️ NEW: PalletSpec (규격 등록 화면)**
- Separate registration screen for pallet specifications
- Fields: spec_name, length, width, height, weight, material, notes, is_active

**⚠️ NEW: Pallet Inventory View**
- Dashboard/list view showing current pallet inventory across all types and customers

### 8.20 Other Entities

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

**User (built-in + custom):** Built-in(id, email, full_name, role) + system_type(erp/mes), mes_equipment, employee_number

**WorkOrder:** work_order_number, order_date, sales_order_id, product_name, box_code, dimensions, order_qty, delivery_date, work_instructions, processes[], barcode

**GeneralPurchaseItem:** code, name, category(consumables/materials/equipment/services/other), unit, standard_price, supplier_prices[], current_stock

**SecurityLog:** request_type(export_excel/export_image/view_secure), menu_key, requester_id, status(pending/approved/rejected), approver_id

**BoxSettings:** sc_input_sequence, paper_cut_count, paper_min_width, paper_max_width, paper_margin_option, cutting_axis_standard, edit_recalculation, price_decimal_enabled, spec_sheet_format, etc.

---

## 9. Entity Relationships

### 9.1 Relationship Map

```
Partner 1:N SalesOrder            (Customer → SO)
Partner 1:N PurchaseOrder          (Supplier → PO)
Partner 1:N Receiving              (Supplier → Receiving)
Partner 1:N Delivery               (Customer → Delivery)
Partner 1:N Invoice                (Customer → Invoice)
Partner 1:N BoxQuotation           (Customer → Quotation)
Partner 1:N PalletBalance          (Customer → Pallet Balance)
Partner 1:N PaymentTransaction     (Customer → Payment)
Partner 1:N DeliveryLocation       (Customer → Delivery Location)

BoxProduct 1:N SalesOrder          (Box Product → SO)
BoxProduct N:1 BoxType             (Box Product → Box Type)
BoxProduct N:1 PaperCode           (Box Product → Paper Code)
BoxProduct N:1 WoodenMold          (Box Product → Mold)
BoxProduct N:1 PrintingPlate       (Box Product → Plate)
BoxProduct N:1 Partner             (Box Product → Customer)

SalesOrder 1:N Production          (SO → Production)
SalesOrder 1:N ProductionPlan      (SO → Production Plan)
SalesOrder 1:N DeliveryItem        (SO → Delivery Item)
SalesOrder 1:N StockAdjustmentLog  (SO → Stock Adjustment Log)

PurchaseOrder 1:N PurchaseOrderItem (PO → PO Item)
PurchaseOrder 1:N Receiving        (PO → Receiving, via po_id)

Delivery 1:N DeliveryItem          (Delivery → Delivery Item)
Delivery N:1 Invoice               (Delivery → Invoice, via invoice_id)
Delivery N:1 VehicleCode           (Delivery → Vehicle)

ProductionPlan 1:N ProcessPlan     (Plan → Process Plan)
ProcessPlan N:1 Equipment          (Process Plan → Equipment)
ProcessPlan N:1 ProcessCode        (Process Plan → Process Code)

Equipment N:1 ProcessCode          (Equipment → Process Code)
PaperCode 1:N RawPaperCode        (Paper Code → Raw Paper)
PalletTransaction N:1 PalletBalance (Pallet Txn → Pallet Balance)
SalesPerson 1:N Partner            (Sales Rep → Assigned Partners)
MenuPermission N:1 User            (Permission → User)
```

### 9.2 Core Flow Relationships

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

## 10. Screen Specifications & Acceptance Criteria

### 10.1 Sales Order Ledger (SalesOrderList)

**Purpose:** Comprehensive SO status view and management

**View modes:**
- Active: Only items with undelivered_qty > 0 or stock_qty > 0
- All: All within date range
- Total: All data regardless of date

**Status filters:** Not Ordered / Not Received / Not Produced / Not Delivered

**Grouping tabs:**
- By Customer: Grouped by customer name
- By Due Date: Grouped by due date (customer name column added)
- By Sales Rep: Grouped by sales rep (customer name column added)

**Columns (By Customer):** Category, Product Name, L/W/H, Order Qty, Manila/Ordered, Manila/Received, Paper/Ordered, Paper/Received, Produced, Delivered, Undelivered, Stock, Order Date, Due Date, SO Notes, Delivery Notes

**Buttons:** Product Label, Work Order, Delete, New SO, Adjust (T), Processing History (new window), Export Toolbar (Print/Excel/Image/Fax/Email)

**Acceptance Criteria:**
- [ ] All 3 grouping modes work correctly
- [ ] Active/All/Total view modes filter accurately
- [ ] adjusted_stock_qty and adjusted_undelivered_qty values take priority when present
- [ ] Status filters (Not Ordered/Received/Produced/Delivered) work correctly
- [ ] Status badge displays correctly per state (Not Ordered → PO In Progress → Received → In Production → Produced → Delivered)
- [ ] Processing History button opens /StockAdjustmentLogPage in new window
- [ ] Adjust (T) button opens stock adjustment dialog; adjustment logs to StockAdjustmentLog
- [ ] Product Label/Work Order output works for selected rows
- [ ] SO with is_ordered == true shows delete-blocked message

### 10.2 Sales Order Entry (SalesOrderEntry / SalesOrderForm)

**Purpose:** SO create/edit (popup or separate form)

**Acceptance Criteria:**
- [ ] Order date defaults to today
- [ ] Customer input uses code table popup on Enter
- [ ] Selecting box product auto-fills: product name, dimensions, paper code, flute type, unit price
- [ ] If quantity_tiers exist, unit price auto-applies based on order qty
- [ ] Amount = order_qty x unit_price auto-calculated
- [ ] Save creates SalesOrder record correctly
- [ ] Edit mode loads existing data accurately

### 10.3 Purchase Order (PurchaseOrderList / PurchaseOrderForm)

**Grouping tabs:** By Invoice, By Date, By Supplier, By Customer, By Sales Rep  
**Type filter:** All / Manila / Paper / Outsource / General

**Buttons:** Edit Invoice, Edit Item, Work Order, Product Label, PO Form, Export Toolbar, Delete, New PO

**⚠️ NEW: Load SO into PO (수주불러오기)**
- Two modes:
  1. **Load All SOs:** Shows all unordered SOs, user selects which to include in PO
  2. **Load by Supplier:** Filter SOs by selected supplier (발주처별), then load matching SOs into PO
- This is the primary way to create POs from existing SOs

**⚠️ NEW: Different column sets per material type**
- Column layout changes depending on po_type:
  - **Paper (원단):** Paper-specific columns (paper code, flute, cutting size, etc.)
  - **Manila (마니라):** Manila-specific columns (basis weight, etc.)
  - **Outsource (외주):** Process-specific columns (process name, equipment, etc.)
  - **General (일반):** Generic item columns
- Dev team needs to implement dynamic column rendering based on active type filter/po_type

**Acceptance Criteria:**
- [ ] All 5 grouping tabs work correctly
- [ ] Type filter (manila/paper/outsource/other) filters accurately
- [ ] PO creation sets related SalesOrder.is_ordered = true
- [ ] PO creation updates SalesOrder.manila_order_qty or paper_order_qty
- [ ] PO form print works (manila/paper/outsource/general formats)
- [ ] Duplicate line items for same product allowed
- [ ] PO with receiving progress shows delete-blocked message
- [ ] ⚠️ NEW: "Load All SOs" button loads all unordered SOs for selection
- [ ] ⚠️ NEW: "Load by Supplier" mode filters SOs by supplier before loading
- [ ] ⚠️ NEW: Column sets change dynamically based on material type

### 10.4 Receiving (ReceivingList / ReceivingForm)

**Grouping tabs:** By Invoice, By Date, By Supplier, By Customer, By Product, By Item, By Sales Rep  
**Type filter:** All / Paper / Manila / Outsource / General

**⚠️ NEW: Different column sets per material type**
- Same dynamic column behavior as PO (Section 10.3) — columns vary by receiving_type (paper/manila/outsource/general)

**⚠️ NEW: "All Unreceived" button (전체 미입고 내역)**
- Button that shows a consolidated view of all PO items that have not been fully received across all POs
- Helps procurement staff quickly identify outstanding receivables

**Acceptance Criteria:**
- [ ] All 7 grouping tabs work correctly
- [ ] Receiving entry updates PurchaseOrder.items[].received_qty
- [ ] Receiving entry auto-transitions PurchaseOrder.status (partial_received / received)
- [ ] Receiving entry updates SalesOrder.manila_received_qty or paper_received_qty
- [ ] PO vs. receiving qty comparison available
- [ ] Duplicate line items for same product allowed
- [ ] ⚠️ NEW: Columns change dynamically based on material type
- [ ] ⚠️ NEW: "All Unreceived" button shows consolidated unreceived PO items

### 10.5 Production (ProductionList)

**Grouping:** By Process → By Machine sub-grouping

**Columns:** Customer, Product Name, Box Type, L/W/H, Order Qty, Production Qty, Unit Price, Amount, Defects, Defect Reason, Box Count, Estimated Time, Actual Time

**⚠️ NEW: Additional view modes**
- **By Date (일자별):** Group production records by production date
- **By Customer (거래처별):** Group production records by customer

**Acceptance Criteria:**
- [ ] By Process / By Machine grouping works
- [ ] Production data displays accurately
- [ ] Link to Production Plan works
- [ ] Production entry updates SalesOrder.produced_qty
- [ ] ⚠️ NEW: By Date view groups production records by date
- [ ] ⚠️ NEW: By Customer view groups production records by customer

### 10.6 Production Plan (ProductionPlanPage)

**Flow:** Select Process → Select Machine → Show unproduced list → Select products → Set sequence

**Grouping:** By Process, By Machine, By Customer, By Due Date

**⚠️ NEW: Specific column sets per view**
- **By Process (공정별):** Work Order, Customer, Due Date, Product, L/W/H, Box Type, Plate No., Mold No., Order Qty, Paper Supplier, Paper Received, Delivered Qty, Machine
- **By Machine (기계별):** Work Order, Customer, Due Date, Product, L/W/H, Order Qty, Plate No., Produced Qty, Status
- **By Customer (거래처별):** Customer, Product, Due Date, Process, Machine, Order Qty, Produced Qty, Remaining
- **By Due Date (납기별):** Due Date, Customer, Product, Process, Machine, Order Qty, Produced Qty, Status, Priority

**Acceptance Criteria:**
- [ ] After process/machine selection, unproduced items list appears
- [ ] Drag & drop production sequence setting works
- [ ] Save creates ProductionPlan record
- [ ] Production plan print output works
- [ ] Equipment change (bulk move to different equipment of same process) works
- [ ] ⚠️ NEW: Each grouping view shows its specific column set

### 10.7 Shipment Plan (ShipmentPlan)

**Columns:** Due Date, Customer, Product Name, Spec, Order Qty, Supplier, Received Qty, Produced Qty, Shipped Qty, Delivery Notes, SO Notes, Category

**Acceptance Criteria:**
- [ ] Undelivered SO shipment schedule displays correctly
- [ ] Production/receiving/delivery quantities reflect in real-time
- [ ] Navigate to delivery entry from shipment plan
- [ ] Stock adjustment function works

### 10.8 Delivery (DeliveryList / DeliveryForm)

**Grouping:** By Invoice, By Date, By Customer, By Product, By Location, By Vehicle, By Sales Rep

**⚠️ NEW: Different column sets per material type**
- Same dynamic column behavior as PO — columns vary based on the type of material being delivered

**Acceptance Criteria:**
- [ ] All 7 grouping tabs work correctly
- [ ] Delivery entry updates related SalesOrder.delivered_qty
- [ ] Delivery entry auto-transitions SalesOrder.status (partial_delivery / completed)
- [ ] partner_id (customer) and billing_partner_id (billing entity) can be set separately
- [ ] Pallet outbound entry works and creates PalletTransaction
- [ ] Delivery statement / delivery confirmation print works
- [ ] Duplicate line items for same product allowed
- [ ] Vehicle/location/departure time entry works
- [ ] ⚠️ NEW: Columns change dynamically based on material type

### 10.9 Quotation (BoxQuotation / BoxQuotationForm)

**⚠️ NEW: MyPack-style batch entry UX**
- Grid-based entry where user can enter multiple product lines rapidly in a spreadsheet-like interface
- Tab/Enter navigation between cells for fast data entry
- Similar to MyPack's quotation entry UX (not modal-per-item)

**⚠️ NEW: Cost Analysis Panel (원가분석)**
- Bottom panel or side panel showing real-time cost breakdown for selected quotation item
- Shows: material cost, processing cost, additional cost, profit rate, suggested price
- Helps sales team make informed pricing decisions during quotation

**Acceptance Criteria:**
- [ ] Multiple items can be entered in list format
- [ ] Per-item arbitrary qty/price direct input works
- [ ] Per-item internal notes/remarks input works
- [ ] Footer memo field exists
- [ ] Supply amount / VAT / total auto-calculated
- [ ] Quotation print output works
- [ ] Status management (draft/sent/accepted/rejected/expired) works
- [ ] ⚠️ NEW: Batch entry UX with spreadsheet-style grid input
- [ ] ⚠️ NEW: Cost analysis panel shows cost breakdown for selected item

### 10.10 Invoice (BillingList)

**Default screen:** Issued invoices list

**Functions:** Delivery-based / SO-based sales invoice issuance, purchase invoice manual entry

**⚠️ NEW: Additional fields**
- `invoice_format`: Electronic (전자) vs. Paper (종이) distinction field
- `tax_type`: Normal tax (일반과세) vs. Zero-rate (영세율)
- `document_type`: Receipt (영수) vs. Claim (청구)
- These fields must be selectable during invoice creation and displayed in the invoice list

**Acceptance Criteria:**
- [ ] Issued invoices tab shows existing invoice list
- [ ] Unissued tab shows delivered-but-not-invoiced items
- [ ] Delivery-based invoice groups by billing_partner_id
- [ ] Invoice issuance updates Delivery.status to "invoiced" and is_invoiced to true
- [ ] SO-based invoice issuance works
- [ ] Purchase invoice manual entry works
- [ ] Summary view is available
- [ ] ⚠️ NEW: invoice_format (electronic/paper) selector and display
- [ ] ⚠️ NEW: tax_type (normal/zero-rate) selector and display
- [ ] ⚠️ NEW: document_type (receipt/claim) selector and display

### 10.11 Box Products by Customer (BoxProductList / BoxProductForm)

**⚠️ NEW: Bottom panel with Raw Materials/Process Info + Delivery History**
- The product detail view should include a bottom panel with:
  1. **Raw Materials & Process Info (원자재/공정정보):** Shows materials list and process list for the selected product
  2. **Delivery History (납품이력):** Table showing delivery date, quantity, paper value (지대가), box price for each delivery

**⚠️ NEW: Replace Process/Delivery History tabs with Print Spec (인쇄사양) panel**
- Instead of separate tabs for process info and delivery history, add a dedicated Print Specification panel
- Shows: print colors, plate info, print images, print notes
- This is a UI restructuring — the data already exists in BoxProduct.print_images and PrintingPlate

**⚠️ NEW: Product Copy (품목복사) with options**
- Copy a box product with configurable options:
  1. **Delete original after copy:** Option to remove the source product after copying
  2. **Copy print spec:** Option to include/exclude print specification data in the copy
  3. **Cross-customer copy:** Copy a product from one customer to another customer
  4. **Change product (제품변경):** Copy while changing the product variant (e.g., different size of same base design)

**⚠️ NEW: Product Registration (품목등록) enhancements**
- **Supplier filtered by material type:** When selecting a supplier (발주처) in the product form, the supplier dropdown should filter based on the material type being used (paper suppliers for paper fields, manila suppliers for manila fields, etc.)
- **Sobu click auto-adds process:** When the 소부 (sub-process) checkbox is clicked in process_flags, the system should automatically add the corresponding process entry to the processes array
- **Process reorder:** Users should be able to drag-and-drop to reorder processes in the process list

**Acceptance Criteria:**
- [ ] Customer selection shows that customer's box products
- [ ] Product entry: box type selection → dimension input → cutting size auto-calculated
- [ ] Paper code, mold, plate linking works
- [ ] Process info (processes) entry works
- [ ] Material info (materials) entry works
- [ ] Quantity-based pricing (quantity_tiers) setup works
- [ ] Print image upload (max 4) works
- [ ] Stacking info (pallet_info) entry works
- [ ] Products with SO history cannot be deleted, only suspended (is_active=false)
- [ ] ⚠️ NEW: Bottom panel shows raw materials/process info and delivery history
- [ ] ⚠️ NEW: Delivery history shows date, qty, paper value, box price per record
- [ ] ⚠️ NEW: Print spec panel displays print colors, plate info, images, notes
- [ ] ⚠️ NEW: Product copy with delete-original option works
- [ ] ⚠️ NEW: Product copy with copy-print-spec option works
- [ ] ⚠️ NEW: Cross-customer product copy works
- [ ] ⚠️ NEW: Product change (copy with variant) works
- [ ] ⚠️ NEW: Supplier dropdown filters by material type
- [ ] ⚠️ NEW: Sobu checkbox auto-adds process entry
- [ ] ⚠️ NEW: Process list supports drag-and-drop reorder

### 10.12 Wooden Mold Management (WoodenMoldList / WoodenMoldForm)

**Acceptance Criteria:**
- [ ] Mold CRUD works
- [ ] Linked products (BoxProduct referencing this mold) list displays
- [ ] Molds with linked products cannot be deleted, only suspended
- [ ] Mold image upload works
- [ ] Status (active/suspended/damaged) management works

### 10.13 Printing Plate Management (PrintingPlateList / PrintingPlateForm)

**⚠️ NEW: Additional fields in list view**
- **Box type (상자형식):** Show the box type associated with the plate
- **Last used date (최근사용일자):** Auto-populated from most recent production using this plate
- **Linked product count (연동품목수):** Count of BoxProducts referencing this plate

**Acceptance Criteria:**
- [ ] Plate CRUD works
- [ ] Linked products (BoxProduct referencing this plate) list displays
- [ ] Plates with linked products cannot be deleted, only suspended
- [ ] Plate image upload works
- [ ] Print color and plate count entry works
- [ ] ⚠️ NEW: Box type column displays in list
- [ ] ⚠️ NEW: Last used date auto-populated and displayed
- [ ] ⚠️ NEW: Linked product count displayed

### 10.14 Paper Code (PaperCodeList / PaperCodeForm)

**Acceptance Criteria:**
- [ ] Paper code CRUD works
- [ ] Flute type (SW/DW/TW/SF) selection works
- [ ] Paper composition setup works (layer-by-layer raw paper code selection)
- [ ] Per-supplier prices (max 5) entry works
- [ ] Standard price setting works

### 10.15 MES (MESMain)

**⚠️ NEW: Layout redesign**
- **Barcode/search relocated:** Move barcode scan input and search functionality to a more prominent/accessible location (specific layout TBD with design team)
- **Click shows per-process production qty:** When clicking a product/order on MES board, display a breakdown of production quantities per process step (already partially described in Code SRS but now confirmed as a firm requirement)

**Acceptance Criteria:**
- [ ] Only system_type == "mes" users can access
- [ ] Today's production plan shows by process/machine
- [ ] Product select → Start button works (Production.status → in_progress)
- [ ] On completion, qty/defect entry dialog shows
- [ ] Prior incomplete process blocks next process start
- [ ] Barcode scan product lookup works
- [ ] ⚠️ NEW: Clicking a product shows per-process production quantity breakdown
- [ ] Paper supplier and paper received qty displayed
- [ ] Same-day same-product re-entry allowed
- [ ] Product label/label output works
- [ ] ⚠️ NEW: Barcode/search field relocated per updated layout

### 10.16 General Settings (GeneralSettingsPage)

**Tabs:** Box Settings, Material Settings, SO Settings, Production/Inventory Settings, Delivery Settings, Quotation/Invoice Settings

**Acceptance Criteria:**
- [ ] All 6 tabs display and switch correctly
- [ ] Each tab's settings save/load correctly
- [ ] Box Settings: box type margin defaults, cutting-related settings save
- [ ] Material Settings: paper supplier display count, default flute type configurable
- [ ] SO Settings: SO/PO number format, auto-generation configurable
- [ ] Production/Inventory: unproduced handling, process order constraint on/off, negative inventory toggle
- [ ] Delivery: delivery number format, default statement format, default pallet type
- [ ] Quotation/Invoice: quotation number format, default validity period, default tax rate

### 10.17 Company Settings (CompanySettings)

**Acceptance Criteria:**
- [ ] Company name, CEO, business number, type/category, address, phone, fax entry works
- [ ] Company logo image upload works
- [ ] Company seal image upload works
- [ ] Bank info (bank name, account number, holder) entry works
- [ ] Save persists to CompanyProfile entity

### 10.18 Pallet Management (PalletManagement) — ⚠️ NEW: Expanded

**⚠️ NEW: Expanded entity and features**
The pallet module is significantly expanded from the Code SRS:

- **Storage fee (보관료):** Track storage fees per pallet transaction
- **Transfer slip amount (이동전표금액):** Record financial amount for pallet transfer documents
- **Specification (규격):** Each pallet type can have detailed spec info

**⚠️ NEW: Pallet Spec Registration Screen (규격 등록)**
- Dedicated screen/modal to register and manage pallet specifications
- Fields: name, dimensions (L/W/H), weight, material, notes

**⚠️ NEW: Pallet Inventory View (재고 현황)**
- Dashboard view showing current pallet inventory
- Per customer, per pallet type breakdown
- Shows: current balance, total in, total out, storage fees accrued

**Acceptance Criteria:**
- [ ] Pallet in/out transaction entry works
- [ ] Auto-balance calculation on transaction works
- [ ] ⚠️ NEW: Storage fee field entry and tracking works
- [ ] ⚠️ NEW: Transfer slip amount field entry works
- [ ] ⚠️ NEW: Pallet spec registration screen works
- [ ] ⚠️ NEW: Pallet inventory view shows per-customer, per-type breakdown

---

## 11. Core Flows

### 11.1 SO → Delivery → Invoice Main Flow

```
1. SO Entry (SalesOrder created, status=pending)
   |
2. PO Entry (PurchaseOrder created)
   -> SalesOrder.is_ordered = true
   -> SalesOrder.manila_order_qty / paper_order_qty updated
   |
3. Receiving Entry (Receiving created)
   -> PurchaseOrder.items[].received_qty updated
   -> PurchaseOrder.status transitions (partial_received / received)
   -> SalesOrder.manila_received_qty / paper_received_qty updated
   |
4. Production Plan (ProductionPlan created)
   -> Process/machine assignment
   -> Production sequence set
   |
5. MES Production (Production created/updated)
   -> Start: Production.status = in_progress
   -> Complete: Production.status = completed, qty/defect recorded
   -> SalesOrder.produced_qty updated
   -> SalesOrder.status = in_production / produced
   |
6. Shipment Plan Review
   -> Check undelivered status
   |
7. Delivery Entry (Delivery created)
   -> SalesOrder.delivered_qty updated
   -> SalesOrder.status = partial_delivery / completed
   -> PalletTransaction created (if pallet outbound)
   |
8. Invoice Issuance (Invoice created)
   -> Delivery.status = invoiced, is_invoiced = true
   -> Or SalesOrder.invoice_status = issued
```

### 11.2 Collection/Payment Flow

```
1. Invoice Issued (Invoice, status=issued)
   |
2. Collection Entry (PaymentTransaction, type=collection)
   -> Invoice.amount_paid updated
   -> Invoice.status = partial / paid
   |
3. Balance Management
   -> Invoice.balance_due = total_amount - amount_paid
```

---

## 12. MES Flow

### 12.1 Basic Flow

1. Check today's production items from production plan
2. Select product → Start Production (Production.status → in_progress, start_time recorded)
3. Complete Production → Enter qty/defects (Production.status → completed, end_time recorded)
4. Move to next process

### 12.2 Process Order Constraint (BR-04)

- If previous sequence process in ProductionPlan.process_plans is not `completed`
- Block next process start
- Show "Prior process not completed" message
- This constraint can be toggled on/off in General Settings

### 12.3 Equipment Change

- In equipment view, multi-select products
- Bulk move to different equipment of the same process
- Updates ProductionPlan.process_plans[].equipment_id

### 12.4 Unproduced Handling

- Configurable in General Settings:
  - Auto carry-over to next day
  - Delete
  - Manual handling

### 12.5 MES Display Info

- Show paper supplier and paper received qty
- Click product → show per-process production quantities
- Same-day same-product re-entry allowed

---

## 13. Print Output Specifications

### 13.1 Purchase Order Form

| Item | Detail |
|------|--------|
| Source screen | PurchaseOrderList |
| Data | Supplier, PO date, items, spec, cutting size, qty, unit price, amount, due date, notes |
| Options | Common format for manila/paper/outsource/general |
| Format | A4 portrait, company logo/seal |
| Exception | ⚠️ SCOPE TBD: Outsource PO form variants (finished product / per-process) — client wants now |

### 13.2 Delivery Statement

| Item | Detail |
|------|--------|
| Source screen | DeliveryList, DeliveryForm |
| Data | Customer, delivery date, items, spec, qty, unit price, supply amount, tax, total, notes |
| Options | Hide company name, hide amounts, qty-only, show/hide recipient info |
| Format | A4 portrait, multiple formats |
| Exception | Fill blank rows if below fixed row count |

### 13.3 Delivery Confirmation

| Item | Detail |
|------|--------|
| Source screen | DeliveryList, DeliveryForm |
| Data | Customer, delivery date, items, qty, signature field |
| Format | A4 portrait |
| Exception | Use quantity field first, delivery_qty as fallback |

### 13.4 Product Label

| Item | Detail |
|------|--------|
| Source screen | SalesOrderList, MES |
| Data | Customer, product name, dimensions (LxWxH), qty, barcode |
| Options | Simple / detailed format selection |
| Format | Custom label size |

### 13.5 Work Order

| Item | Detail |
|------|--------|
| Source screen | SalesOrderList, PurchaseOrderList |
| Data | Customer, product name, box code, box type, spec, cutting size, order qty, due date, paper info, process info, work instructions, barcode |
| Format | A4 portrait |
| Exception | Receiving work order (ReceivingWorkOrder) has separate format |

### 13.6 Quotation

| Item | Detail |
|------|--------|
| Source screen | BoxQuotation |
| Data | Customer, date, validity, items (name, material, box type, spec, qty, unit price, amount), supply amount, VAT, total, notes |
| Options | VAT included/excluded display |
| Format | A4 portrait, company logo/seal |

### 13.7 Code Table Print

| Item | Detail |
|------|--------|
| Source screen | BoxProductList, PartnerList, ManilaList, PaperCodeList, PalletManagement |
| Data | Full list per code table (filter-applicable) |
| Format | A4 portrait/landscape |

### 13.8 Production Plan Sheet

| Item | Detail |
|------|--------|
| Source screen | ProductionPlanPage |
| Data | Plan date, per-process/machine item list, work order, order qty, due date |
| Options | By process / by machine |
| Format | A4 landscape |

---

## 14. Common Rules

### 14.1 Date Defaults

- SO date, PO date, receiving date, delivery date: auto-fill with **today**

### 14.2 Code Table / Enter Search

- In any partner input field:
  - Enter with no text → full code table popup
  - Text then Enter → filtered code table popup
  - NO dropdown list (must use popup approach)

### 14.3 Export/Send (All Print Outputs)

DocumentExportToolbar component on all print outputs:

| Function | Description |
|----------|-------------|
| Print | Per-menu printer settings (localStorage) |
| Excel | CSV download (UTF-8 BOM) |
| Image | PNG capture via html2canvas |
| Fax | Fax number input → ExportLog with pending status |
| Email | Email/subject/body input → ExportLog with pending status |

### 14.4 Duplicate Line Items

- PO/Receiving/Delivery allow same product on multiple lines
- Within one document, same product can appear multiple times
- Remaining balance re-displayed for additional input

### 14.5 Adjusted (Stock/Undelivered) Handling

- `adjusted_stock_qty`: Adjusted stock (takes priority)
- `adjusted_undelivered_qty`: Adjusted undelivered (takes priority)
- Adjustment logs to StockAdjustmentLog
- History viewable in separate page (/StockAdjustmentLogPage, new window)

### 14.6 Category Navigation Persistence

- After clicking a top-level category (e.g., Box Business), sub-menu list remains visible when navigating to child pages
- Current page's parent category sub-menu always displayed

### 14.7 Delete Restrictions / Data Integrity

| Target | Restriction | Alternative |
|--------|-------------|-------------|
| SalesOrder | is_ordered == true (PO exists) | - |
| PurchaseOrder | Any item received_qty > 0 | - |
| BoxProduct | SO history exists | Suspend (is_active=false) |
| WoodenMold | linked_product_count > 0 | Suspend (status=suspended) |
| PrintingPlate | related_products exist | Suspend (is_active=false) |
| Partner | Transaction history exists | Mark inactive (is_suspended=true) |

### 14.8 ⚠️ NEW: Monthly Defect/Shortage Report (공용)

- **Monthly defect report:** Aggregated defect quantities and rates per product/process/machine for a given month
- **Monthly shortage report:** Outstanding delivery shortages and unfulfilled order quantities
- Accessible from Management Information section or as a common report available across modules
- Acceptance Criteria:
  - [ ] Monthly defect report shows defects aggregated by product/process/machine
  - [ ] Monthly shortage report shows outstanding undelivered quantities
  - [ ] Date range (month) selector works
  - [ ] Export to Excel works

---

## 15. Settings

### 15.1 Company Settings (CompanySettings → CompanyProfile)

- Company name, CEO, business registration number, type/category
- Address, phone, fax, email, website
- Company logo image upload
- Company seal image upload
- Bank info (bank name, account number, holder)
- Digital certificate registration (UI only, actual integration future)

### 15.2 User Settings (UserSettings → MenuPermission + User)

- User classification: Office (admin) / User (user) / Field/MES (mes)
- Per-menu permissions: can_view, can_edit, can_delete, can_export
- MES users: assigned equipment (mes_equipment)
- Employee number, department, position management

### 15.3 General Settings Tabs (GeneralSettingsPage → BoxSettings etc.)

| Tab | Content | Entity |
|-----|---------|--------|
| Box Settings | Box type margin defaults, paper width range (1050~2200mm), cutting standard (maroon-ga/berry-ga), biaxial expansion, price decimal toggle, spec sheet format | BoxSettings |
| Material Settings | Paper supplier display count (default 5), default flute type, processing ratio | BoxSettings |
| SO Settings | SO/PO number format, auto-generation toggle, numbering scheme | BoxSettings |
| Production/Inventory | Unproduced handling (carry-over/delete/manual), process order constraint on/off, negative inventory toggle | BoxSettings |
| Delivery | Delivery number format, default statement format, default pallet type | BoxSettings |
| Quotation/Invoice | Quotation number format, default validity period, default tax rate (10%), default tax/zero-rate | BoxSettings |

---

## 16. Future Development Items

| # | Item | Description | Priority | Status in This Build |
|---|------|-------------|----------|---------------------|
| F-01 | Outsource PO form variants | Finished product / per-process separate forms | Medium | ⚠️ SCOPE TBD |
| F-02 | Digital certificate e-signature | NTS e-tax invoice integration | High | Future |
| F-03 | Fax API integration | External fax service API | Medium | Future |
| F-04 | Email API integration | External email sending API | Medium | Future |
| F-05 | Paper receiving Excel reconciliation | Upload supplier Excel → compare with receiving data | Medium | ⚠️ SCOPE TBD |
| F-06 | MES direct plate registration | Register plate info from MES screen | Low | ⚠️ SCOPE TBD |
| F-07 | e-Tax invoice issuance | NTS HomeTax auto-issuance | High | Future |
| F-08 | Mobile-optimized UX | Dedicated mobile UX for MES/sales | Medium | Future |
| F-09 | Multi-language | EN/CN UI support | Low | Future |
| F-10 | Auto journal entries | Auto accounting entries on invoice | Medium | Future |
| F-11 | ERP-Accounting integration | External accounting sync | Low | Future |
| F-12 | Inventory barcode scan | Barcode-based physical inventory | Low | Future |

---

## Appendix: Summary of All ⚠️ NEW Items (Client Feedback Gaps)

For estimation convenience, all confirmed new requirements from client feedback consolidated:

| # | Area | Requirement | Section |
|---|------|-------------|---------|
| G-01 | Purchase Order | Load SO into PO — two modes (all SOs / by supplier) | 10.3 |
| G-02 | PO/Receiving/Delivery | Dynamic column sets per material type (paper/manila/outsource/general) | 10.3, 10.4, 10.8 |
| G-03 | Box Product | Bottom panel: raw materials/process info + delivery history (date/qty/paper value/box price) | 10.11 |
| G-04 | Box Product | Replace process/delivery tabs with print spec panel | 10.11 |
| G-05 | Box Product | Product copy with options (delete original, copy print spec, cross-customer, product change) | 10.11 |
| G-06 | Box Product | Supplier filtered by material type, sobu auto-add process, process reorder | 10.11 |
| G-07 | Invoice | Electronic/paper format field, tax type (normal/zero-rate), document type (receipt/claim) | 10.10, 8.7 |
| G-08 | Pallet | Expanded entity (storage fee, transfer slip amount, spec) + spec registration + inventory view | 10.18, 8.19 |
| G-09 | Printing Plate | Add box type, last used date, linked product count fields | 10.13, 8.11 |
| G-10 | Production | Add by-date and by-customer views | 10.5 |
| G-11 | Production Plan | Specific column sets per view (process/machine/customer/due date) | 10.6 |
| G-12 | Quotation | MyPack-style batch entry UX, cost analysis panel | 10.9 |
| G-13 | MES | Layout redesign (barcode/search relocated), click shows per-process production qty | 10.15 |
| G-14 | Common | Monthly defect/shortage report | 14.8 |
| G-15 | Receiving | "All Unreceived" consolidated view button | 10.4 |

## Appendix: Summary of All ⚠️ SCOPE TBD Items

Items originally designated as future development but client has requested for this build:

| # | Code SRS ID | Item | Section |
|---|-------------|------|---------|
| S-01 | F-05 | Paper receiving Excel reconciliation (매입 엑셀 대사) | 2.2 |
| S-02 | F-06 | MES direct plate registration (MES 조판번호 직접 등록) | 2.2 |
| S-03 | F-01 | Outsource PO form variants (외주발주서 양식 세분화) | 2.2, 13.1 |

---

*This document consolidates Code SRS v2.0 Final (2026-03-16) with confirmed client feedback gaps as of 2026-03-24.*  
*Use this as the single reference for estimation and development planning.*