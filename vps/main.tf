# doesn't work yet 
# resource "cloudflare_record" "default" {
#   domain = "tuannvm.com"
#   name   = ""
#   value  = "${digitalocean_droplet.default.ipv4_address}"
#   type   = "A"
#   ttl    = 60
# }

resource "digitalocean_droplet" "default" {
  image    = "ubuntu-18-04-x64"
  name     = "tommy"
  region   = "sgp1"
  size     = "s-1vcpu-1gb"
  ssh_keys = ["${digitalocean_ssh_key.default.id}"]
}

# Create a new SSH key
resource "digitalocean_ssh_key" "default" {
  name       = "tommy"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

output "ip" {
  value = "${digitalocean_droplet.default.ipv4_address}"
}
