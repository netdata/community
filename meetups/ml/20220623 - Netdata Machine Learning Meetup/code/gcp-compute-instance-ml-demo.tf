########################################
## ml-demo-parent
########################################

# make a static ip to use for this vm
resource "google_compute_address" "ml_demo_parent" {
  name = "ml-demo-parent"
}

#/*
# define the instance
resource "google_compute_instance" "ml_demo_parent" {
  name                      = "ml-demo-parent"
  machine_type              = "n1-standard-1"
  zone                      = var.gcp_zone
  tags                      = ["dev"]
  allow_stopping_for_update = true
  boot_disk {
    initialize_params {
      image = data.google_compute_image.devml.self_link
      size  = 20
      type  = "pd-standard"
    }
  }
  network_interface {
    network = google_compute_network.dev.name
    access_config {
      nat_ip = google_compute_address.ml_demo_parent.address
    }
  }
  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro", "cloud-platform"]
  }
  metadata_startup_script = templatefile("scripts/startup-ml-demo.sh", {
    RUN_THIS_FIRST : "echo 'hello'..",
    NETDATA_FORK: "netdata/netdata",
    NETDATA_BRANCH: "master",
    NETDATA_PARENT_NAME : "ml-demo-parent",
    NETDATA_HOST_NAME : "ml-demo-parent",
    NETDATA_CLOUD_URL : "https://app.netdata.cloud",
    NETDATA_CLOUD_TOKEN : "XXX",
    NETDATA_CLOUD_ROOMS : "XXX",
    RUN_THIS_LAST : file("scripts/finish-ml-demo.sh"),
  })
}
#*/

########################################
## ml-demo-ml-enabled
########################################

# make a static ip to use for this vm
resource "google_compute_address" "ml_demo_ml_enabled" {
  name = "ml-demo-ml-enabled"
}

#/*
# define the instance
resource "google_compute_instance" "ml_demo_ml_enabled" {
  name                      = "ml-demo-ml-enabled"
  machine_type              = "n1-standard-1"
  zone                      = var.gcp_zone
  tags                      = ["dev"]
  allow_stopping_for_update = true
  boot_disk {
    initialize_params {
      image = data.google_compute_image.devml.self_link
      size  = 20
      type  = "pd-standard"
    }
  }
  network_interface {
    network = google_compute_network.dev.name
    access_config {
      nat_ip = google_compute_address.ml_demo_ml_enabled.address
    }
  }
  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro", "cloud-platform"]
  }
  metadata_startup_script = templatefile("scripts/startup-ml-demo.sh", {
    RUN_THIS_FIRST : "echo 'hello'..",
    NETDATA_FORK: "netdata/netdata",
    NETDATA_BRANCH: "master",
    NETDATA_PARENT_NAME : "ml-demo-parent",
    NETDATA_HOST_NAME : "ml-demo-ml-enabled",
    NETDATA_CLOUD_URL : "https://app.netdata.cloud",
    NETDATA_CLOUD_TOKEN : "XXX",
    NETDATA_CLOUD_ROOMS : "XXX",
    RUN_THIS_LAST : file("scripts/finish-ml-demo.sh"),
  })
}
#*/

########################################
## ml-demo-ml-disabled
########################################

# make a static ip to use for this vm
resource "google_compute_address" "ml_demo_ml_disabled" {
  name = "ml-demo-ml-disabled"
}

#/*
# define the instance
resource "google_compute_instance" "ml_demo_ml_disabled" {
  name                      = "ml-demo-ml-disabled"
  machine_type              = "n1-standard-1"
  zone                      = var.gcp_zone
  tags                      = ["dev"]
  allow_stopping_for_update = true
  boot_disk {
    initialize_params {
      image = data.google_compute_image.devml.self_link
      size  = 20
      type  = "pd-standard"
    }
  }
  network_interface {
    network = google_compute_network.dev.name
    access_config {
      nat_ip = google_compute_address.ml_demo_ml_disabled.address
    }
  }
  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro", "cloud-platform"]
  }
  metadata_startup_script = templatefile("scripts/startup-ml-demo.sh", {
    RUN_THIS_FIRST : "echo 'hello'..",
    NETDATA_FORK: "netdata/netdata",
    NETDATA_BRANCH: "master",
    NETDATA_PARENT_NAME : "ml-demo-parent",
    NETDATA_HOST_NAME : "ml-demo-ml-disabled",
    NETDATA_CLOUD_URL : "https://app.netdata.cloud",
    NETDATA_CLOUD_TOKEN : "XXX",
    NETDATA_CLOUD_ROOMS : "XXX",
    RUN_THIS_LAST : file("scripts/finish-ml-demo.sh"),
  })
}
#*/

########################################
## ml-demo-ml-enabled-orphan
########################################

# make a static ip to use for this vm
resource "google_compute_address" "ml_demo_ml_enabled_orphan" {
  name = "ml-demo-ml-enabled-orphan"
}

#/*
# define the instance
resource "google_compute_instance" "ml_demo_ml_enabled_orphan" {
  name                      = "ml-demo-ml-enabled-orphan"
  machine_type              = "n1-standard-1"
  zone                      = var.gcp_zone
  tags                      = ["dev"]
  allow_stopping_for_update = true
  boot_disk {
    initialize_params {
      image = data.google_compute_image.devml.self_link
      size  = 20
      type  = "pd-standard"
    }
  }
  network_interface {
    network = google_compute_network.dev.name
    access_config {
      nat_ip = google_compute_address.ml_demo_ml_enabled_orphan.address
    }
  }
  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro", "cloud-platform"]
  }
  metadata_startup_script = templatefile("scripts/startup-ml-demo.sh", {
    RUN_THIS_FIRST : "echo 'hello'..",
    NETDATA_FORK: "netdata/netdata",
    NETDATA_BRANCH: "master",
    NETDATA_PARENT_NAME : "",
    NETDATA_HOST_NAME : "ml-demo-ml-enabled-orphan",
    NETDATA_CLOUD_URL : "https://app.netdata.cloud",
    NETDATA_CLOUD_TOKEN : "XXX",
    NETDATA_CLOUD_ROOMS : "XXX",
    RUN_THIS_LAST : file("scripts/finish-ml-demo.sh"),
  })
}
#*/

########################################
## ml-demo-ml-disabled-orphan
########################################

# make a static ip to use for this vm
resource "google_compute_address" "ml_demo_ml_disabled_orphan" {
  name = "ml-demo-ml-disabled-orphan"
}

#/*
# define the instance
resource "google_compute_instance" "ml_demo_ml_disabled_orphan" {
  name                      = "ml-demo-ml-disabled-orphan"
  machine_type              = "n1-standard-1"
  zone                      = var.gcp_zone
  tags                      = ["dev"]
  allow_stopping_for_update = true
  boot_disk {
    initialize_params {
      image = data.google_compute_image.devml.self_link
      size  = 20
      type  = "pd-standard"
    }
  }
  network_interface {
    network = google_compute_network.dev.name
    access_config {
      nat_ip = google_compute_address.ml_demo_ml_disabled_orphan.address
    }
  }
  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro", "cloud-platform"]
  }
  metadata_startup_script = templatefile("scripts/startup-ml-demo.sh", {
    RUN_THIS_FIRST : "echo 'hello'..",
    NETDATA_FORK: "netdata/netdata",
    NETDATA_BRANCH: "master",
    NETDATA_PARENT_NAME : "",
    NETDATA_HOST_NAME : "ml-demo-ml-disabled-orphan",
    NETDATA_CLOUD_URL : "https://app.netdata.cloud",
    NETDATA_CLOUD_TOKEN : "XXX",
    NETDATA_CLOUD_ROOMS : "XXX",
    RUN_THIS_LAST : file("scripts/finish-ml-demo.sh"),
  })
}
#*/

########################################
## ml-demo-ml-enabled-meetup
########################################

# make a static ip to use for this vm
resource "google_compute_address" "ml_demo_ml_enabled_meetup" {
  name = "ml-demo-ml-enabled-meetup"
}

#/*
# define the instance
resource "google_compute_instance" "ml_demo_ml_enabled_meetup" {
  name                      = "ml-demo-ml-enabled-meetup"
  machine_type              = "n1-standard-1"
  zone                      = var.gcp_zone
  tags                      = ["dev"]
  allow_stopping_for_update = true
  boot_disk {
    initialize_params {
      image = data.google_compute_image.devml.self_link
      size  = 20
      type  = "pd-standard"
    }
  }
  network_interface {
    network = google_compute_network.dev.name
    access_config {
      nat_ip = google_compute_address.ml_demo_ml_enabled_meetup.address
    }
  }
  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro", "cloud-platform"]
  }
  metadata_startup_script = templatefile("scripts/startup-ml-demo.sh", {
    RUN_THIS_FIRST : "echo 'hello'..",
    NETDATA_FORK: "netdata/netdata",
    NETDATA_BRANCH: "master",
    NETDATA_PARENT_NAME : "ml-demo-parent",
    NETDATA_HOST_NAME : "ml-demo-ml-enabled-meetup",
    NETDATA_CLOUD_URL : "https://app.netdata.cloud",
    NETDATA_CLOUD_TOKEN : "XXX",
    NETDATA_CLOUD_ROOMS : "XXX",
    RUN_THIS_LAST : file("scripts/finish-ml-demo.sh"),
  })
}
#*/