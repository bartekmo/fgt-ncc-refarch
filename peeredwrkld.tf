resource "google_compute_network" "wrkld" {
  count = sum([ for k,v in var.wrkld_cidrs : length(v) ]) > 0 ? 1 : 0

  name = "${var.prefix}-wrklds"
  auto_create_subnetworks = false
}

resource "google_compute_network_peering" "right_wrkld" {
  count = sum([ for k,v in var.wrkld_cidrs : length(v) ]) > 0 ? 1 : 0

  name = "${var.prefix}-peer-right-wrkld"
  network = google_compute_network.right.self_link
  peer_network = google_compute_network.wrkld[0].self_link
  export_custom_routes = true
}

resource "google_compute_network_peering" "wrkld_right" {
  count = sum([ for k,v in var.wrkld_cidrs : length(v) ]) > 0 ? 1 : 0

  name = "${var.prefix}-peer-wrkld-right"
  network = google_compute_network.wrkld[0].self_link
  peer_network = google_compute_network.right.self_link
  import_custom_routes = true
}

resource "google_compute_subnetwork" "wrklds0" {
  for_each = toset(var.wrkld_cidrs[keys(var.wrkld_cidrs)[0]])

  name = "${var.prefix}-wrkld-${replace(split("/", each.value)[0], ".", "-" )}"
  ip_cidr_range = each.value
  region = keys(var.wrkld_cidrs)[0]
  network = google_compute_network.wrkld[0].id
}

resource "google_compute_subnetwork" "wrklds1" {
  for_each = toset(var.wrkld_cidrs[keys(var.wrkld_cidrs)[1]])

  name = "${var.prefix}-wrkld-${replace(split("/", each.value)[0], ".", "-" )}"
  ip_cidr_range = each.value
  region = keys(var.wrkld_cidrs)[1]
  network = google_compute_network.wrkld[0].id
}
