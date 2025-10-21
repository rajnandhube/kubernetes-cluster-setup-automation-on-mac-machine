
resource "multipass_instance" "control-plane" {
    name     = "controlplane"
    cpus     = 4
    memory   = "4G"
    disk     = "30G"
    image    = "25.04"
}

resource "multipass_instance" "workernodes" {
    count    = 2
    name     = "worker-node-${count.index + 01}"
    cpus     = 2
    memory   = "2G"
    disk     = "20G"
    image    = "25.04"
}

# resource "multipass_instance" "worker-nodes" {
#     for_each = toset(["worker-node-01", "worker-node02"])
#     name     = each.key
#     cpus     = 2
#     memory   = "2G"
#     disk     = "20G"
#     image    = "25.04"
# }
