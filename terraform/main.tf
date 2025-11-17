
resource "multipass_instance" "controlplane" {
    name     = "controlplane"
    cpus     = 6
    memory   = "6G"
    disk     = "30G"
    image    = "24.04"
}

