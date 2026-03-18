# Caso Práctico 2

## Nota

Este proyecto ha sido probado desde cero siguiendo exactamente los pasos descritos en este README.

## Objetivo

El objetivo de este proyecto es desplegar una solución completa en Azure utilizando herramientas DevOps como Terraform, Ansible y Kubernetes.

Se busca automatizar la creación de la infraestructura y el despliegue de aplicaciones en contenedores tanto en una máquina virtual como en un clúster AKS.

Desplegar:

- Azure Container Registry
- una aplicación en contenedor con Podman sobre una máquina virtual en Azure
- un clúster AKS
- una aplicación en AKS con almacenamiento persistente

## Licencia

Este proyecto se distribuye bajo licencia MIT-0.

Esto permite el uso, copia y modificación del código sin necesidad de atribución.

El software se proporciona "tal cual", sin garantías, y el autor no se hace responsable del uso que terceros puedan hacer del mismo.

Este proyecto tiene fines educativos.

## Estructura del proyecto

- `terraform/` → infraestructura en Azure
- `ansible/` → configuración de la VM y despliegue de la app con Podman
- `k8s/` → manifiestos de Kubernetes para AKS

## Requisitos previos

Instalar localmente:

- Azure CLI
- Terraform
- Ansible
- kubectl
- Podman

Además, es necesario disponer de una clave SSH local para la VM:

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/azure_vm_key
```

### Nota sobre el inventario de Ansible

Este fichero se genera automáticamente con la IP de la VM, por lo que no es necesario modificarlo manualmente.

# Pasos para probar la solución:

# 1. Login en Azure

```bash
   az login
```

# 2. Despliegue de infraestructura

```bash
   cd terraform
   terraform init
   terraform apply
```

## Subida de imagen a ACR

Es necesario subir la imagen al Azure Container Registry para que AKS pueda descargarla.

Este paso es importante ya que, al recrear la infraestructura, el registro estará vacío.

```
cd ../scripts
chmod +x push-aks-image.sh
./push-aks-image.sh
```

# 3. Configuración de la VM

```bash
   cd ../ansible
```

```bash
   ansible-playbook -i inventory.ini install_podman.yml
```

```bash
   ansible-playbook -i inventory.ini deploy_vote_app.yml
```

# 4. Verificación de la app en la VM

Obtener la IP pública de la VM:

```bash
cd ../terraform
terraform output -raw vm_public_ip
```

Abrir en el navegador:

http://IP_VM:8080

# 5. Configuración de AKS

```bash
az aks get-credentials --resource-group rg-casopractico2 --name aks-casopractico2 --overwrite-existing
kubectl get nodes
```

# 6. Despliegue en AKS

```bash
cd ../k8s
kubectl apply -f .
```

# 7. Verificación de la app en AKS

Comprobar recursos:

```bash
kubectl get pvc
kubectl get pods
kubectl get svc
```

Obtener la IP externa del servicio:

```bash
kubectl get svc nginx-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
echo
```

Abrir en el navegador:

http://IP_AKS
Nota sobre las IPs públicas

Este proyecto expone dos aplicaciones distintas:

VM + Podman → usa la IP pública de la máquina virtual y el puerto 8080

AKS + Kubernetes → usa la IP externa del servicio LoadBalancer y el puerto 80

Por eso ambas IPs son diferentes.

Verificación del almacenamiento persistente en AKS

Esto permite comprobar que los datos no se pierden aunque el pod sea eliminado.

Crear un fichero de prueba dentro del volumen persistente:

```bash
kubectl exec -it deploy/nginx-app -- sh -c "echo 'persistent-test-123' > /usr/share/nginx/html/persistence-check.txt && cat /usr/share/nginx/html/persistence-check.txt"
```

Eliminar el pod para forzar su recreación:

```bash
kubectl delete pod -l app=nginx-app
kubectl get pods -w
```

Verificar que el fichero sigue existiendo:

```bash
kubectl exec -it deploy/nginx-app -- sh -c "cat /usr/share/nginx/html/persistence-check.txt"
```

# 8. Destrucción de recursos

Primero eliminar los recursos de Kubernetes:

```bash
cd ../k8s
kubectl delete -f .
```

Después destruir la infraestructura en Azure:

```bash
cd ../terraform
terraform destroy
```
