resource "google_network_connectivity_hub" "hub" {
  name          = "${var.prefix}-hub"
}


module "ncc_region" {
  source = "./ncc-region"
  for_each = toset( var.regions )

  region        = each.key
  prefix        = var.prefix
  hub           = google_network_connectivity_hub.hub
  indx          = index(var.regions, each.key)
  net_left      = google_compute_network.left
  net_right     = google_compute_network.right
  net_fgsp      = google_compute_network.fgsp

  ## TODO: parametrize it
  asn_left_ncc  = "65${index(var.regions, each.key)}10"
  asn_right_ncc = "65${index(var.regions, each.key)}20"
  asn_fgt       = "65${index(var.regions, each.key)}01"
}
