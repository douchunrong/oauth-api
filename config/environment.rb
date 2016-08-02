# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# Sorry Rails! I created the DB first.
# Would love to switch to plural table names someday
ActiveRecord::Base.pluralize_table_names = false

ActiveRecord::SchemaDumper.ignore_tables = %w(
  error_log
  log
  team_profile_map
  test
  wp_alm
  wp_bp_activity
  wp_bp_activity_meta
  wp_bp_groups
  wp_bp_groups_groupmeta
  wp_bp_groups_members
  wp_bp_notifications
  wp_bp_notifications_meta
  wp_bp_xprofile_data
  wp_bp_xprofile_fields
  wp_bp_xprofile_groups
  wp_bp_xprofile_meta
  wp_cf_form_entries
  wp_cf_form_entry_meta
  wp_cf_form_entry_values
  wp_commentmeta
  wp_comments
  wp_geo_mashup_administrative_names
  wp_geo_mashup_location_relationships
  wp_geo_mashup_locations
  wp_groups_capability
  wp_groups_group
  wp_groups_group_capability
  wp_groups_user_capability
  wp_groups_user_group
  wp_links
  wp_nf_objectmeta
  wp_nf_objects
  wp_nf_relationships
  wp_ninja_forms_fav_fields
  wp_ninja_forms_fields
  wp_oauth_access_tokens
  wp_oauth_authorization_codes
  wp_oauth_clients
  wp_oauth_jwt
  wp_oauth_public_keys
  wp_oauth_refresh_tokens
  wp_oauth_scopes
  wp_options
  wp_pods_sprtid_invite
  wp_podsrel
  wp_postmeta
  wp_posts
  wp_signups
  wp_social_users
  wp_term_relationships
  wp_term_taxonomy
  wp_termmeta
  wp_terms
)