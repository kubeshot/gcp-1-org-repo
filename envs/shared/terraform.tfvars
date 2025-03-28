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
 * limitations under the License.
 */

# Must include the domain of the organization you are deploying the foundation.
domains_to_allow = ["example.com"]

essential_contacts_domains_to_allow = ["@example.com"]

scc_notification_name = "scc-notifyt"

remote_state_bucket = "REPLACE_ME"

//scc_notification_filter = "state=\\\"ACTIVE\\\""

enable_hub_and_spoke = true

create_access_context_manager_access_policy = false

// Optional - If you are deploying Foundation Example in a parent folder
// consider using below create_unique_tag_key var because as Tag Keys are
// unique organization-wide it will add a random suffix at each tag key

create_unique_tag_key = true
create_unique_scc_notification = true

//->New entries
list_allowed_policy_member_domains = ["C046rk2lj"]
log_export_storage_location = "northamerica-northeast2"
billing_export_dataset_location = "northamerica-northeast2"
list_restrict_protocol_forwarding = ["INTERNAL", "EXTERNAL"]
allowed_gcp_resource_locations = ["in:canada-locations", "global"]
// allowed_gcp_resource_locations = ["in:canada-locations", "global", "asia", "eu", "us"]
list_trusted_image_projects = ["projects/debian-cloud", "projects/cos-cloud", "projects/fortigcp-project-001"]                                                   # "project/seed-project-id" value is appended here from pipeline shell script
list_allowed_load_balancer = ["EXTERNAL_HTTP_HTTPS", "INTERNAL_TCP_UDP","EXTERNAL_NETWORK_TCP_UDP"]
