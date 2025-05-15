resource "yandex_vpc_network" "k8s_network" {
  name = "k8s-network"
}

resource "yandex_vpc_subnet" "subnet_a" {
  name           = "subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.k8s_network.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}

resource "yandex_vpc_subnet" "subnet_b" {
  name           = "subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.k8s_network.id
  v4_cidr_blocks = ["10.0.2.0/24"]
}

resource "yandex_vpc_subnet" "subnet_d" {
  name           = "subnet-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.k8s_network.id
  v4_cidr_blocks = ["10.0.3.0/24"]
}

resource "yandex_compute_instance" "k8s_master" {
  name        = "k8s-master"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"
  resources {
    cores         = 2
    memory        = 4
    core_fraction = 20 # Минимизация CPU
  }
  boot_disk {
    initialize_params {
      image_id = "fd85b6k7esmsatsjb6fr" # Ubuntu 20.04
      size     = 20
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_a.id
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "k8s_worker" {
  count       = 2
  name        = "k8s-worker-${count.index + 1}"
  platform_id = "standard-v3"
  zone        = count.index == 0 ? "ru-central1-b" : "ru-central1-d"
  resources {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }
  boot_disk {
    initialize_params {
      image_id = "fd85b6k7esmsatsjb6fr"
      size     = 20
    }
  }
  network_interface {
    subnet_id = count.index == 0 ? yandex_vpc_subnet.subnet_b.id : yandex_vpc_subnet.subnet_d.id
    nat       = true
  }
  scheduling_policy {
    preemptible = true # Прерываемые ВМ
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

# Генерация hosts.yml
resource "local_file" "ansible_inventory" {
  content = <<-EOT
all:
  hosts:
    master-1:
      ansible_host: ${yandex_compute_instance.k8s_master.network_interface.0.nat_ip_address}
      access_ip: ${yandex_compute_instance.k8s_master.network_interface.0.nat_ip_address}
      ip: ${yandex_compute_instance.k8s_master.network_interface.0.ip_address}
      ansible_user: ubuntu
    worker-1:
      ansible_host: ${yandex_compute_instance.k8s_worker[0].network_interface.0.nat_ip_address}
      access_ip: ${yandex_compute_instance.k8s_worker[0].network_interface.0.nat_ip_address}
      ip: ${yandex_compute_instance.k8s_worker[0].network_interface.0.ip_address}
      ansible_user: ubuntu
    worker-2:
      ansible_host: ${yandex_compute_instance.k8s_worker[1].network_interface.0.nat_ip_address}
      access_ip: ${yandex_compute_instance.k8s_worker[1].network_interface.0.nat_ip_address}
      ip: ${yandex_compute_instance.k8s_worker[1].network_interface.0.ip_address}
      ansible_user: ubuntu
  children:
    kube_control_plane:
      hosts:
        master-1:
    kube_node:
      hosts:
        master-1:
        worker-1:
        worker-2:
    etcd:
      hosts:
        master-1:
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
  EOT
  filename = "hosts.yml"
}