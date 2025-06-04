
# Stack Monitoring: Prometheus, Grafana, Loki, Tempo & Exporters

Ce dépôt propose une stack de monitoring complète pour observer des métriques avec **Prometheus**, **Grafana**, **Loki**, **Tempo** et plusieurs exporters.

---

## 01-stackMonitoring : stack monitoring

### Prometheus
- **Image**: `prom/prometheus:latest`
- **Port**: `9090`
- **Fonction**: Scrape les métriques via les exporters.
- **Volumes** :
  - `prometheus.yml`: Configuration des scrape jobs.
  - `alerts.yml`: Règles d’alerte Prometheus.

### Alertmanager
- **Image**: `prom/alertmanager:latest`
- **Port**: `9093`
- **Fonction**: Gestion des alertes envoyées par Prometheus.

### Grafana
- **Image**: `grafana/grafana:latest`
- **Port**: `3000`
- **Accès par défaut**:
  - **Utilisateur**: `admin`
  - **Mot de passe**: `admin`
- **Fonction**: Visualisation des métriques, logs, traces.

### Loki
- **Image**: `grafana/loki:latest`
- **Port**: `3100`
- **Fonction**: Stockage et requêtage des logs.

### Promtail
- **Image**: `grafana/promtail:latest`
- **Fonction**: Collecte des logs du host (`/var/log`) vers Loki.
- **Config**: `promtail-config.yaml`

### Tempo
- **Image**: `grafana/tempo:latest`
- **Port**: `3200`
- **Fonction**: Traces distribuées (jaeger, tempo, zipkin).

---

## Job observées
La liste des jobs prometheus est présent dans le fichier **prometheus.yml**
- **prometheus** :
  - Scrape l'état de prometheus lui même
  - Port 9090 
- **Serveurpython** :
  - Scrape les métriques du serveur IoT maison en python
  - Port 8800  
- **serveurNginx**
  - SCrape les métriques (simple) de Nginx 
  - Port 9113 
- **Mysql**
  - Scrape les métriques de MySql 
  - Port 9104 
---

## 02-exporterNginx : Exporters

### NGINX Exporter
- **Image**: `nginx/nginx-prometheus-exporter:0.11.0`
- **Port exposé**: `9113`
- **Scrape URI**: `http://nginxPV:9114/nginx_status`
- **Réseau**: `mynet`

### MySQL Exporter
- **Image**: `prom/mysqld-exporter:latest`
- **Port exposé**: `9104`
- **Connexion**: via `--mysqld.username=root:root` (à adapter)
- **Réseau**: `00-serveurlemp_mynet`

## 03-Reverse : reverseproxy 
Reverse Proxy basé sur un NGinx pour passer les communications de monitoring en HTTPS. 
Uniquement présent sur la branche **secureMonitoring**

### Reverse proxy
- **Serveur Nginx** : reverse proxy via docker-compose.yml
  - **Image** : nginx : latest
  - **Port exposé** : - '8008 4433'
  - **Réseau** : 00-serveurlemp_mynet
- **nginx.conf/nginx.conf** : fichier de configuration reverseProxy
- 
### generation certificat
- **cert/SgeneCertClef.sh** : generation de clef et certifcat basé sur openSSL.



---



