# 🚀 Kubernetes Development Environment

สภาพแวดล้อมการพัฒนาสำหรับเรียนรู้ DevOps และ Kubernetes โดยใช้ k3d

## 🛠️ การใช้งาน

### เริ่มต้น Kubernetes Cluster
```bash
./start-cluster.sh
```

### หยุด Kubernetes Cluster
```bash
./stop-cluster.sh
```

### ทำความสะอาดระบบ
```bash
./cleanup.sh
```

## 📋 คำสั่งพื้นฐาน

### ตรวจสอบสถานะ Cluster
```bash
kubectl cluster-info
kubectl get nodes
kubectl get pods -A
```

### Deploy Applications
```bash
kubectl apply -f day1-kube/
kubectl get all
```

### ดู Logs
```bash
kubectl logs -f deployment/nginx-deployment
```

### เข้าถึง Services
```bash
kubectl port-forward svc/nginx-service 8080:80
```

## 🔧 Configuration

- **k3d Configuration**: `.devcontainer/k3d.yml`
- **Exposed Ports**: 30000 (Prometheus), 30080 (IMDb App), 31080 (Heartbeat), 32000 (Grafana)
- **API Server**: `https://0.0.0.0:6443`

## 📚 Learning Resources

- `day1-kube/` - พื้นฐาน Kubernetes
- `day2-advanced/` - เทคนิคขั้นสูง
- `day3-networking/` - การจัดการเครือข่าย

## 🚨 Troubleshooting

### หาก kubectl cluster-info ไม่ทำงาน
```bash
kubectl config get-contexts
kubectl config use-context k3d-k3s-default
```

### หาก cluster ไม่ตอบสนอง
```bash
./cleanup.sh
./start-cluster.sh
```

### ดู Docker containers
```bash
docker ps
k3d cluster list
```

## 📝 Notes

- Cluster จะถูกสร้างด้วย k3d configuration file
- kubectl context จะถูกตั้งค่าอัตโนมัติ
- Ports จะถูก forward ตาม configuration
- ระบบจะใช้ Docker-in-Docker สำหรับ containers
