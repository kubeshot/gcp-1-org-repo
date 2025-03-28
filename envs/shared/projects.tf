/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License
 
 */

locals {
  hub_and_spoke_roles = [
    "roles/compute.instanceAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/iam.serviceAccountUser",
  ]
  environments = merge ({
    "development" : "devt",
    "nonproduction" : "npt",
    "production" : "prodt"
  },
    try(local.management_enabled,false) ? { "management" : "m" } : {},
    try(local.identity_enabled, false)  ? { "identity" : "i" } : {}
  )
}

/******************************************
  Projects for log sinks
*****************************************/

module "org_audit_logs" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.0"

  random_project_id        = true
  random_project_id_length = 4
  default_service_account  = "deprivilege"
  name                     = "${local.project_prefix}-c-logging"
  org_id                   = local.org_id
  billing_account          = local.billing_account
  folder_id                = google_folder.common.id
  activate_apis            = ["logging.googleapis.com", "bigquery.googleapis.com", "billingbudgets.googleapis.com"]

  labels = {
    environment       = "common"
    application_name  = "org-logging"
    billing_code      = "1234"
    primary_contact   = "example1"
    secondary_contact = "example2"
    business_code     = "shared"
    env_code          = "c"
    vpc               = "none"
  }
  budget_alert_pubsub_topic   = var.project_budget.org_audit_logs_alert_pubsub_topic
  budget_alert_spent_percents = var.project_budget.org_audit_logs_alert_spent_percents
  budget_amount               = var.project_budget.org_audit_logs_budget_amount
  budget_alert_spend_basis    = var.project_budget.org_audit_logs_budget_alert_spend_basis
}

module "org_billing_logs" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.0"

  random_project_id        = true
  random_project_id_length = 4
  default_service_account  = "deprivilege"
  name                     = "${local.project_prefix}-c-billing-logs"
  org_id                   = local.org_id
  billing_account          = local.billing_account
  folder_id                = google_folder.common.id
  activate_apis            = ["logging.googleapis.com", "bigquery.googleapis.com", "billingbudgets.googleapis.com"]

  labels = {
    environment       = "common"
    application_name  = "org-billing-logs"
    billing_code      = "1234"
    primary_contact   = "example1"
    secondary_contact = "example2"
    business_code     = "shared"
    env_code          = "c"
    vpc               = "none"
  }
  budget_alert_pubsub_topic   = var.project_budget.org_billing_logs_alert_pubsub_topic
  budget_alert_spent_percents = var.project_budget.org_billing_logs_alert_spent_percents
  budget_amount               = var.project_budget.org_billing_logs_budget_amount
  budget_alert_spend_basis    = var.project_budget.org_billing_logs_budget_alert_spend_basis
}

/******************************************
  Project for Org-wide KMS
*****************************************/

module "org_kms" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.0"

  random_project_id        = true
  random_project_id_length = 4
  default_service_account  = "deprivilege"
  name                     = "${local.project_prefix}-c-kms"
  org_id                   = local.org_id
  billing_account          = local.billing_account
  folder_id                = google_folder.common.id
  activate_apis            = ["logging.googleapis.com", "cloudkms.googleapis.com", "billingbudgets.googleapis.com"]

  labels = {
    environment       = "common"
    application_name  = "org-kms"
    billing_code      = "1234"
    primary_contact   = "example1"
    secondary_contact = "example2"
    business_code     = "shared"
    env_code          = "c"
    vpc               = "none"
  }

  budget_alert_pubsub_topic   = var.project_budget.org_kms_alert_pubsub_topic
  budget_alert_spent_percents = var.project_budget.org_kms_alert_spent_percents
  budget_amount               = var.project_budget.org_kms_budget_amount
  budget_alert_spend_basis    = var.project_budget.org_kms_budget_alert_spend_basis
}

/******************************************
  Project for Org-wide Secrets
*****************************************/

module "org_secrets" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.0"

  random_project_id        = true
  random_project_id_length = 4
  default_service_account  = "deprivilege"
  name                     = "${local.project_prefix}-c-secrets"
  org_id                   = local.org_id
  billing_account          = local.billing_account
  folder_id                = google_folder.common.id
  activate_apis            = ["logging.googleapis.com", "secretmanager.googleapis.com", "billingbudgets.googleapis.com"]

  labels = {
    environment       = "common"
    application_name  = "org-secrets"
    billing_code      = "1234"
    primary_contact   = "example1"
    secondary_contact = "example2"
    business_code     = "shared"
    env_code          = "c"
    vpc               = "none"
  }
  budget_alert_pubsub_topic   = var.project_budget.org_secrets_alert_pubsub_topic
  budget_alert_spent_percents = var.project_budget.org_secrets_alert_spent_percents
  budget_amount               = var.project_budget.org_secrets_budget_amount
  budget_alert_spend_basis    = var.project_budget.org_secrets_budget_alert_spend_basis
}

/******************************************
  Project for Interconnect
*****************************************/

module "interconnect" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.0"

  random_project_id        = true
  random_project_id_length = 4
  default_service_account  = "deprivilege"
  name                     = "${local.project_prefix}-net-interconnect"
  org_id                   = local.org_id
  billing_account          = local.billing_account
  folder_id                = google_folder.network.id
  activate_apis            = ["billingbudgets.googleapis.com", "compute.googleapis.com"]

  labels = {
    environment       = "network"
    application_name  = "org-interconnect"
    billing_code      = "1234"
    primary_contact   = "example1"
    secondary_contact = "example2"
    business_code     = "shared"
    env_code          = "net"
    vpc               = "none"
  }
  budget_alert_pubsub_topic   = var.project_budget.interconnect_alert_pubsub_topic
  budget_alert_spent_percents = var.project_budget.interconnect_alert_spent_percents
  budget_amount               = var.project_budget.interconnect_budget_amount
  budget_alert_spend_basis    = var.project_budget.interconnect_budget_alert_spend_basis
}

/******************************************
  Project for SCC Notifications
*****************************************/

module "scc_notifications" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.0"

  random_project_id        = true
  random_project_id_length = 4
  default_service_account  = "keep"
  name                     = "${local.project_prefix}-c-sccn"
  org_id                   = local.org_id
  billing_account          = local.billing_account
  folder_id                = google_folder.common.id
  activate_apis            = ["logging.googleapis.com", "pubsub.googleapis.com", "securitycenter.googleapis.com", "billingbudgets.googleapis.com", "cloudkms.googleapis.com"]

  labels = {
    environment       = "common"
    application_name  = "org-scc"
    billing_code      = "1234"
    primary_contact   = "example1"
    secondary_contact = "example2"
    business_code     = "shared"
    env_code          = "c"
    vpc               = "none"
  }
  budget_alert_pubsub_topic   = var.project_budget.scc_notifications_alert_pubsub_topic
  budget_alert_spent_percents = var.project_budget.scc_notifications_alert_spent_percents
  budget_amount               = var.project_budget.scc_notifications_budget_amount
  budget_alert_spend_basis    = var.project_budget.scc_notifications_budget_alert_spend_basis
}

/******************************************
  Project for DNS Hub
*****************************************/

module "dns_hub" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.0"

  random_project_id        = true
  random_project_id_length = 4
  default_service_account  = "deprivilege"
  name                     = "${local.project_prefix}-net-dns"
  org_id                   = local.org_id
  billing_account          = local.billing_account
  folder_id                = google_folder.network.id

  activate_apis = [
    "compute.googleapis.com",
    "dns.googleapis.com",
    "servicenetworking.googleapis.com",
    "logging.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "billingbudgets.googleapis.com"
  ]

  labels = {
    environment       = "network"
    application_name  = "org-dns-hub"
    billing_code      = "1234"
    primary_contact   = "example1"
    secondary_contact = "example2"
    business_code     = "shared"
    env_code          = "net"
    vpc               = "none"
  }
  budget_alert_pubsub_topic   = var.project_budget.dns_hub_alert_pubsub_topic
  budget_alert_spent_percents = var.project_budget.dns_hub_alert_spent_percents
  budget_amount               = var.project_budget.dns_hub_budget_amount
  budget_alert_spend_basis    = var.project_budget.dns_hub_budget_alert_spend_basis
}

/******************************************
  Project for Base Network Hub
*****************************************/

module "base_network_hub" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.0"
  count   = var.enable_hub_and_spoke ? 1 : 0

  random_project_id        = true
  random_project_id_length = 4
  default_service_account  = "deprivilege"
  name                     = "${local.project_prefix}-net-hub-base"
  org_id                   = local.org_id
  billing_account          = local.billing_account
  folder_id                = google_folder.network.id

  activate_apis = [
    "compute.googleapis.com",
    "dns.googleapis.com",
    "servicenetworking.googleapis.com",
    "logging.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "billingbudgets.googleapis.com"
  ]

  labels = {
    environment       = "network"
    application_name  = "org-net-hub-base"
    billing_code      = "1234"
    primary_contact   = "example1"
    secondary_contact = "example2"
    business_code     = "shared"
    env_code          = "net"
    vpc               = "base"
  }
  budget_alert_pubsub_topic   = var.project_budget.base_net_hub_alert_pubsub_topic
  budget_alert_spent_percents = var.project_budget.base_net_hub_alert_spent_percents
  budget_amount               = var.project_budget.base_net_hub_budget_amount
  budget_alert_spend_basis    = var.project_budget.base_net_hub_budget_alert_spend_basis
}

resource "google_project_iam_member" "network_sa_base" {
  for_each = toset(var.enable_hub_and_spoke ? local.hub_and_spoke_roles : [])

  project = module.base_network_hub[0].project_id
  role    = each.key
  member  = "serviceAccount:${local.networks_step_terraform_service_account_email}"
}

/******************************************
  Project for Restricted Network Hub
*****************************************/

module "restricted_network_hub" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.0"
  count   = (var.enable_hub_and_spoke && local.restricted_enabled) ? 1 : 0

  random_project_id        = true
  random_project_id_length = 4
  default_service_account  = "deprivilege"
  name                     = "${local.project_prefix}-net-hub-restricted"
  org_id                   = local.org_id
  billing_account          = local.billing_account
  folder_id                = google_folder.network.id

  activate_apis = [
    "compute.googleapis.com",
    "dns.googleapis.com",
    "servicenetworking.googleapis.com",
    "logging.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "billingbudgets.googleapis.com"
  ]

  labels = {
    environment       = "network"
    application_name  = "org-net-hub-restricted"
    billing_code      = "1234"
    primary_contact   = "example1"
    secondary_contact = "example2"
    business_code     = "shared"
    env_code          = "net"
    vpc               = "restricted"
  }
  budget_alert_pubsub_topic   = var.project_budget.restricted_net_hub_alert_pubsub_topic
  budget_alert_spent_percents = var.project_budget.restricted_net_hub_alert_spent_percents
  budget_amount               = var.project_budget.restricted_net_hub_budget_amount
  budget_alert_spend_basis    = var.project_budget.restricted_net_hub_budget_alert_spend_basis
}

/************************************************************
  Base and Restricted Network Projects for each Environment
************************************************************/

module "base_restricted_environment_network" {
  source   = "../../modules/network"
  for_each = local.environments

  org_id          = local.org_id
  billing_account = local.billing_account
  project_prefix  = local.project_prefix
  folder_id       = google_folder.network.id
  restricted_enabled = local.restricted_enabled

  env      = each.key
  env_code = each.value

  project_budget = {
    base_network_budget_amount                  = var.project_budget.base_network_budget_amount
    base_network_alert_spent_percents           = var.project_budget.base_network_alert_spent_percents
    base_network_alert_pubsub_topic             = var.project_budget.base_network_alert_pubsub_topic
    base_network_budget_alert_spend_basis       = var.project_budget.base_network_budget_alert_spend_basis
    restricted_network_budget_amount            = var.project_budget.restricted_network_budget_amount
    restricted_network_alert_spent_percents     = var.project_budget.restricted_network_alert_spent_percents
    restricted_network_alert_pubsub_topic       = var.project_budget.restricted_network_alert_pubsub_topic
    restricted_network_budget_alert_spend_basis = var.project_budget.restricted_network_budget_alert_spend_basis
  }
}

/*********************************************************************
  Roles granted to the networks SA for Hub and Spoke network topology
*********************************************************************/

resource "google_project_iam_member" "network_sa_restricted" {
  for_each = toset(var.enable_hub_and_spoke && local.restricted_enabled ? local.hub_and_spoke_roles : [])

  project = module.restricted_network_hub[0].project_id
  role    = each.key
  member  = "serviceAccount:${local.networks_step_terraform_service_account_email}"
}
