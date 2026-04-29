---
case: case11
description: --url + --login-as → 자동 로그인 1회 후 admin 페이지 inspect (read-only 유지)
client: dsa
project: DSA
srs: clients/dsa/DSA/srs.md (mock)
url: https://staging.dsa.example/
login_as: mock_org_admin_dsa01
credentials_file: clients/dsa/DSA/qa/credentials/mock_org_admin_dsa01.yaml (mock, gitignored)
expected:
  auth_used: mock_org_admin_dsa01
  pages_inspected: ≥3 admin pages
  no_destructive_clicks: true
notes: PM이 SRS + staging URL + login credentials 동반 호출. 자동 로그인 1회 후 admin pages read-only inspect. 로그인 후에도 다른 form submit / save / delete는 금지.
---

# Input

```
/qa-plan dsa --url https://staging.dsa.example/ --login-as mock_org_admin_dsa01
```

PM이 admin 영역 검수 플랜 작성을 위해 staging URL + 로그인 정보 동반 입력. credentials 파일이 `clients/dsa/DSA/qa/credentials/mock_org_admin_dsa01.yaml`에 존재 (gitignored). 자동 로그인 1회 후 admin 페이지들 read-only로 둘러봄.
