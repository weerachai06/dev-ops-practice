# ชุดคำสั่ง Kubernetes ที่ใช้บ่อย

## 1. การสร้าง Deployment และ Service

### สร้าง Deployment
```bash
# สร้าง deployment แบบเร็ว
kubectl create deployment nginx-app --image=nginx:1.20 --replicas=3

# หรือจาก YAML file
kubectl apply -f nginx-deployment.yaml
```

### สร้าง Service
```bash
# สร้าง service แบบเร็ว
kubectl expose deployment nginx-app --port=80 --target-port=80 --type=ClusterIP

# หรือจาก YAML file
kubectl apply -f nginx-service.yaml
```

## 2. การตรวจสอบสถานะ

### ตรวจสอบทุกอย่างแบบรวด
```bash
# ดูทุก resource ในครั้งเดียว
kubectl get all

# ดูเฉพาะที่เราสร้าง
kubectl get deployments,services,pods -l app=nginx-app

# ดูแบบละเอียด
kubectl get all -o wide
```

### ตรวจสอบแยกตาม resource
```bash
# ดู deployments
kubectl get deployments

# ดู services
kubectl get services

# ดู pods
kubectl get pods

# ดู endpoints
kubectl get endpoints

# ดู pods พร้อม labels
kubectl get pods --show-labels

# ดู pods ที่มี label เฉพาะ
kubectl get pods -l app=nginx-app
```

## 3. การทดสอบและเข้าถึง

### Port Forward
```bash
# Forward port เพื่อเข้าถึงจากภายนอก
kubectl port-forward service/nginx-app 8080:80

# หรือ forward จาก pod โดยตรง
kubectl port-forward pod/nginx-app-xxx 8080:80

# หยุด port forwarding
pkill -f "kubectl port-forward"
```

### ทดสอบใน cluster
```bash
# ทดสอบด้วย temporary pod (busybox)
kubectl run test --image=busybox -it --rm -- wget -qO- nginx-app

# ทดสอบด้วย curl
kubectl run test --image=curlimages/curl -it --rm -- curl nginx-app

# ทดสอบ DNS resolution
kubectl run test --image=busybox -it --rm -- nslookup nginx-app
```

## 4. การ Scale

```bash
# Scale up
kubectl scale deployment nginx-app --replicas=5

# Scale down
kubectl scale deployment nginx-app --replicas=1

# ตรวจสอบการ scale
kubectl get pods -l app=nginx-app
```

## 5. การลบ

### ลบทีละอย่าง
```bash
# ลบ service
kubectl delete service nginx-app

# ลบ deployment (จะลบ pods ด้วย)
kubectl delete deployment nginx-app

# ลบ pod เฉพาะตัว
kubectl delete pod nginx-app-xxx
```

### ลบแบบรวด
```bash
# ลบทุกอย่างที่มี label app=nginx-app
kubectl delete all -l app=nginx-app

# ลบจาก YAML files
kubectl delete -f nginx-deployment.yaml -f nginx-service.yaml

# ลบ pods ทั้งหมดที่มี label
kubectl delete pods -l app=nginx-app
```

## 6. ชุดคำสั่งแบบ One-liner

### สร้างทุกอย่างในครั้งเดียว
```bash
kubectl create deployment nginx-app --image=nginx:1.20 --replicas=3 && kubectl expose deployment nginx-app --port=80 --target-port=80 && kubectl get all -l app=nginx-app
```

### ทดสอบการเชื่อมต่อ
```bash
kubectl get endpoints nginx-app && kubectl run test --image=busybox -it --rm -- wget -qO- nginx-app
```

### ลบทุกอย่างที่เกี่ยวข้อง
```bash
kubectl delete all -l app=nginx-app && kubectl get all
```

### รอให้ deployment พร้อม
```bash
kubectl wait --for=condition=available --timeout=300s deployment/nginx-app
```

## 7. คำสั่งสำหรับ Debug

### ดูข้อมูลละเอียด
```bash
# ดู deployment details
kubectl describe deployment nginx-app

# ดู service details
kubectl describe service nginx-app

# ดู pod details
kubectl describe pods -l app=nginx-app

# ดู node details
kubectl describe nodes
```

### ดู logs
```bash
# ดู logs จาก deployment
kubectl logs -l app=nginx-app

# ดู logs แบบ real-time
kubectl logs -l app=nginx-app -f

# ดู logs จาก pod เฉพาะ
kubectl logs nginx-app-xxx

# ดู logs ก่อนหน้าที่ restart
kubectl logs nginx-app-xxx --previous
```

### เข้าไปใน pod
```bash
# เข้าไปใน pod แบบ interactive
kubectl exec -it deployment/nginx-app -- bash

# รัน command ใน pod
kubectl exec deployment/nginx-app -- nginx -v

# รัน command ใน pod เฉพาะ
kubectl exec nginx-app-xxx -- ls -la
```

## 8. การจัดการ Labels

```bash
# เพิ่ม label
kubectl label deployment nginx-app version=v1

# อัพเดท label (ต้องใช้ --overwrite)
kubectl label deployment nginx-app version=v2 --overwrite

# ลบ label
kubectl label deployment nginx-app version-

# ดู labels ทั้งหมด
kubectl get deployment nginx-app --show-labels
```

## 9. ตรวจสอบ Resource Usage

```bash
# ดู resource usage ของ nodes
kubectl top nodes

# ดู resource usage ของ pods
kubectl top pods

# ดู resource usage ของ pods ที่มี label
kubectl top pods -l app=nginx-app
```

## 10. คำสั่งที่ควรจำ (Must Remember)

```bash
# ดูทุกอย่าง
kubectl get all

# สร้าง deployment + service
kubectl create deployment APP_NAME --image=IMAGE_NAME --replicas=N
kubectl expose deployment APP_NAME --port=PORT

# Port forward
kubectl port-forward service/SERVICE_NAME LOCAL_PORT:REMOTE_PORT

# ลบทุกอย่าง
kubectl delete all -l app=APP_NAME

# Debug พื้นฐาน
kubectl describe pods -l app=APP_NAME
kubectl logs -l app=APP_NAME

# Scale
kubectl scale deployment APP_NAME --replicas=N

# เข้าไปใน pod
kubectl exec -it deployment/APP_NAME -- bash
```

## 11. เทคนิคเพิ่มเติม

### ใช้ alias เพื่อความเร็ว
```bash
alias k=kubectl
alias kgp="kubectl get pods"
alias kgs="kubectl get services"
alias kgd="kubectl get deployments"
alias kdp="kubectl describe pod"
alias kl="kubectl logs"
```

### การใช้ output formats
```bash
# แสดงผลแบบ YAML
kubectl get deployment nginx-app -o yaml

# แสดงผลแบบ JSON
kubectl get pods -o json

# แสดงผลแบบ wide (มีข้อมูลเพิ่ม)
kubectl get pods -o wide

# แสดงเฉพาะข้อมูลที่ต้องการ
kubectl get pods -o custom-columns=NAME:.metadata.name,STATUS:.status.phase
```

### การใช้ watch
```bash
# ดู pods แบบ real-time
kubectl get pods -w

# ดู pods ที่มี label แบบ real-time
kubectl get pods -l app=nginx-app -w
```

ชุดคำสั่งเหล่านี้จะช่วยให้คุณทำงานกับ Kubernetes ได้อย่างรวดเร็วและมีประสิทธิภาพครับ! 🚀