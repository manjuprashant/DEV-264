n8n Deployment on Nomad with External MariaDB

This repository contains the deployment configuration and documentation for running a production-ready n8n workflow automation engine inside a HashiCorp Nomad cluster, using an existing MariaDB database for state persistence and Nomad Variables for secure secrets injection.

📌 Project Overview
Feature	Description
Orchestration	HashiCorp Nomad
Database	External MariaDB (persistent state)
Secrets	Nomad Variables (zero-trust)
Monitoring	Prometheus, Loki & Grafana
Ingress	Traefik / Private Network exposure

This approach ensures:

Workflow history, credentials, & executions are not lost (stateless containers)

No clear-text passwords in the Nomad job file

Clean separation of compute vs. storage

Full observability and operational robustness

🏗 Architecture
                ┌──────────────────────────┐
                │        Nomad Cluster     │
                │  ┌────────────────────┐ │
HTTP Access --> │  │     n8n Service    │ │ --> Private DB Traffic
                │  └────────────────────┘ │
                └─────────▲──────────────┘
                          │
                  Nomad Variables
             (DB User / DB Password)
                          │
                      ┌───┴───┐
                      │ MariaDB│
                      └───────┘

Monitoring: Prometheus + Loki + Grafana
Ingress: Traefik

🔐 Secrets Injection Strategy

✔ No usernames/passwords in the job file
✔ Secrets injected at runtime
✔ Stored encrypted in Nomad

Nomad template stanza loads variables like:

N8N_DB_TYPE=mysqldb
N8N_DB_MYSQL_HOST={{ env "MYSQL_HOST" }}
N8N_DB_MYSQL_USER={{ with secret "nomad/variables/n8n/db_user" }}{{ .Data.data.username }}{{ end }}
N8N_DB_MYSQL_PASSWORD={{ with secret "nomad/variables/n8n/db_pass" }}{{ .Data.data.password }}{{ end }}

📄 Files Included in Repo
File	Purpose
nomad/n8n.nomad.hcl	Nomad job spec for n8n
nomad/variables.md	Nomad Variables setup instructions
docs/deployment-guide.md	Full deployment documentation
docs/demo-script.md	Script for 2–4 min project demo
docs/checklist.md	Validation checklist after deployment
monitoring/config/	(Optional) Dashboards + Loki pipeline
ingress/traefik-routes.hcl	Optional HTTP routing
🚀 Deployment Steps
# 1️⃣ Upload DB credentials into Nomad Variables
nomad var put nomad/variables/n8n/db_user username="n8n_user"
nomad var put nomad/variables/n8n/db_pass password="yourpassword"

# 2️⃣ Deploy the job
nomad job run nomad/n8n.nomad.hcl

# 3️⃣ Verify health
nomad status n8n

# 4️⃣ Access UI
http://<public-ip>:5678  (or via Traefik route)

🧪 Acceptance Criteria

 n8n shows Healthy in Nomad UI

 MariaDB contains workflow records (data persistence)

 No secrets visible in job file or Git

 Restart/reschedule ⇒ No data loss

 Monitoring dashboards active (if configured)

📈 Monitoring (Optional)

Includes setup for:

Prometheus → Metrics scraping

Loki → Logs collection

Grafana → Visualization

Dashboards:

Container health

Workflow execution throughput

Error rates

🛡 Security & Compliance

✔ Zero-trust secrets handling
✔ Private network DB access
✔ Git-safe deployment code
✔ Stateless scaling enabled
