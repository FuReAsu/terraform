resource "docker_image" "nginx_web_blue" {
  name = "fureasu346/nginx:web_blue"
}

resource "docker_image" "nginx_web_green" {
  name = "fureasu346/nginx:web_green"
}

resource "docker_container" "nginx_web_blue" {
  count = 5
  image = docker_image.nginx_web_blue.image_id
  name = "nginx_web_blue-${count.index}"
  hostname = "nginx_web_blue-${count.index}"
  ports {
    internal = 80
    external = 8080 + count.index
  }
}

resource "docker_container" "nginx_web_green" {
  count = 5
  image = docker_image.nginx_web_green.image_id
  name = "nginx_web_green-${count.index}"
  hostname = "nginx_web_green-${count.index}"
  ports {
    internal = 80
    external = 9080 + count.index
  }
}
