# TASK 02 NFS-server setup/ data persistence

## Project Overview

### Dockerfile content
 
- The application is containerized using Docker with a Ruby 3.4.1 slim image.
- The Dockerfile installs MySQL client dependencies
- Then copies your Gemfile, runs `bundle install`.
- Finally exposes port 3000 for the Rails server.

## Issues and fixes

- **Authentication error:**
	- Problem: When running 3 replicas, login failed due to CSRF errors. This happened because session cookies and tokens were not shared across the replicas. And sometimes the request was going to only one conatiner.

    - (New) Fix: I added a secrect_key_base to the environments to fix this issue(without this 3 replicas that we create we having different keys) for that reason I was getting this error as by default rails uses this key to encrypt session data in cookies on the users broswer.

    - Fix 2: i changed the load balancing method from default round robin to least count which makes more sense then round robin for load balancing. Now requests we going properly

    
- **NFS-SERVER ERROR**
    - Issue: There was some kind of mounting error because first volumes are created but driver-opts was needing nfs-server but that would be created after volumes are created so this error was result of this conflict.
    ![nfs-error](screenshots/nfs-error.png)
    - Fix: I created a normal voulme without the driver-opts and tested the connections it was working correctly and also later i commented out this driver-opts.
    ![create-volume](screenshots/create-docker-volume.png)
    ![docker-ps](screenshots/docker-ps.png)

## create a user for exporter
```
CREATE USER 'exporter'@'%' IDENTIFIED BY 'exporter-password';
GRANT PROCESS, REPLICATION CLIENT ON *.* TO 'exporter'@'%';
FLUSH PRIVILEGES;
```
- Screenshot of creating user:

![privilage fix](screenshots/mysql-conifg.png)

-`mysld_exporter.cnf.example` as the config file example for mysqld-exporter

## Screenshots

- Below are screenshots from the project:

**Persistence proof**
---
### 1. Connection test and persistence test

![connection test](screenshots/connection-test.png)
---
- create a file in one container it should replicat in all three
![create tmp file in one container and test](screenshots\create-one-tmp.png)
- Proof that it does in all the 3
![proof](screenshots/persistence%20proof.png)
---

### 1. Docker Containers Running

![docker ps](screenshots/docker-ps.png)

---

### 2. Rate Limit Tester

![rate limit tester](screenshots/ratelimittester.png)

---


### 3. Prometheus Targets

![prometheus targets](screenshots/prom-targets.png)

---


### 4. Grafana Metrics Drilldown

![grafana metrics drilldown](screenshots/grafana-metrics.png)

---



### 5. IRIS Share App - 1

![iris share no posts](screenshots/app-1.png)

---

### 6. IRIS Share App - 2

![iris share signed in](screenshots/app2.png)


## Notes
- Each screenshot is referenced by its filename in the `screenshots` directory.


