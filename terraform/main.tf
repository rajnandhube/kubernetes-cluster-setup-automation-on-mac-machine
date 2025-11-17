
resource "multipass_instance" "controlplane" {
    name     = "controlplane"
    cpus     = 6
    memory   = "6G"
    disk     = "30G"
    image    = "24.04"
}

resource "multipass_instance" "workernodes" {
    name     = "workernode-1"
    cpus     = 2
    memory   = "2G"
    disk     = "20G"
    image    = "24.04"
}

resource "multipass_instance" "workernodes1" {
    name     = "workernode-2"
    cpus     = 2
    memory   = "2G"
    disk     = "10G"
    image    = "24.04"    
}


# Create 2 worker nodes using count
# resource "multipass_instance" "workernodes" {
#     count    = 2
#     name     = "workernode-${count.index + 01}"
#     cpus     = 2
#     memory   = "2G"
#     disk     = "20G"
#     image    = "24.04"
# }


# resource "multipass_instance" "worker-nodes" {
#     for_each = toset(["workernode-01", "worker-node02"])
#     name     = each.key
#     cpus     = 2
#     memory   = "2G"
#     disk     = "20G"
#     image    = "24.04"
# }
