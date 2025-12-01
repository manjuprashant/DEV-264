# Verification / Acceptance Checklist


- [ ] Nomad UI shows Job `n8n` and Allocations with status `running` and Service health `passing`.
- [ ] n8n web UI reachable and responsive.
- [ ] Application connected to MariaDB (check logs + DB tables exist).
- [ ] Data persists across a task restart (create flow -> restart -> confirm).
- [ ] No credentials are visible in the raw jobspec (`nomad job inspect n8n` shows no secrets).
- [ ] Monitoring: Grafana shows metrics for n8n and alerts configured.