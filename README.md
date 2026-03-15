# TASK 01 Nginx Setup

## Project Overview

### Dockerfile content
 
- The application is containerized using Docker with a Ruby 3.4.1 slim image.
- The Dockerfile installs MySQL client dependencies
- Then copies your Gemfile, runs `bundle install`.
- Finally exposes port 3000 for the Rails server.

## Issues and fixes

- **Database migrations when scaling:**
	- Problem: When running 3 replicas, login failed due to CSRF errors. This happened because session cookies and tokens were not shared across the replicas.

    - Fix: Implemented sticky sessions, so each client IP is consistently routed to the same server. If that server goes down, the requests from that IP are automatically redirected to another available server.

## Network structure

![Network struture](screenshots/network.png)
- `public` : This networks allows the nginx to compunicate with the outside.
- `monitoring`: This network has cadvisor, node-exporter, mysqld-exporter, prometheus and grfana. Which are used for monitoring.
- `application`: This network is for application for `app` and `migrator` which cannot directly be acessed it has to go through nginx only.As it has to go through nginx we can implement ratelimit and other central policies
- `storage`: This is for mysql storage this would be help full for prevent the direct access from nginx to database. It can only be access by `app` and `migrator`

## create a user for exporter
```
CREATE USER 'exporter'@'%' IDENTIFIED BY 'exporter-password';
GRANT PROCESS, REPLICATION CLIENT ON *.* TO 'exporter'@'%';
FLUSH PRIVILEGES;
```
- Screenshot of creating user:

![privilage fix](screenshots/createexporteruser.png)

-`mysld_exporter.cnf.example` as the config file example for mysqld-exporter

## Screenshots

- Below are screenshots from the project:

`Nginx and prometheus and other screenshots`
---

### 1. Creating admin password for Prometheus/Grafana

![htpasswd command](screenshots/basicAuthpwd.png)

---

### 2. MySQL Exporter User Setup

![MySQL exporter user creation](screenshots/createexporteruser.png)

---

### 3. Docker Compose Up

![docker compose up](screenshots/dockerup.png)

---

### 4. Docker Containers Running

![docker ps](screenshots/dockerps.png)

---

### 5. Rate Limit Tester

![rate limit tester](screenshots/ratelimttester.png)

---

### 6. Prometheus Login

![prometheus login](screenshots/promlogin.png)

---

### 7. Prometheus Targets

![prometheus targets](screenshots/prom-targets.png)

---

### 8. Grafana Login

![grafana login](screenshots/grafanalogin.png)

---

### 9. Grafana Metrics Drilldown

![grafana metrics drilldown](screenshots/grafana-1.png)

---

### 10. Grafana Dashboards

![grafana dashboards](screenshots/grafana-2.png)

---

### 11. IRIS Share App - 1

![iris share no posts](screenshots/apphome.png)

---

### 12. IRIS Share App - 2

![iris share signed in](screenshots/postpage2.png)



## Notes
- Each screenshot is referenced by its filename in the `screenshots` directory.


