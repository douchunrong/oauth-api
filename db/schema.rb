# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160529140120) do

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token", limit: 255
    t.string   "user_id",      limit: 255
    t.string   "expires_at",   limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", limit: 4,     null: false
    t.integer  "application_id",    limit: 4,     null: false
    t.string   "token",             limit: 255,   null: false
    t.integer  "expires_in",        limit: 4,     null: false
    t.text     "redirect_uri",      limit: 65535, null: false
    t.datetime "created_at",                      null: false
    t.datetime "revoked_at"
    t.string   "scopes",            limit: 255
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id", limit: 4
    t.integer  "application_id",    limit: 4
    t.string   "token",             limit: 255, null: false
    t.string   "refresh_token",     limit: 255
    t.integer  "expires_in",        limit: 4
    t.datetime "revoked_at"
    t.datetime "created_at",                    null: false
    t.string   "scopes",            limit: 255
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",         limit: 255,                null: false
    t.string   "uid",          limit: 255,                null: false
    t.string   "secret",       limit: 255,                null: false
    t.text     "redirect_uri", limit: 65535,              null: false
    t.string   "scopes",       limit: 255,   default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "wp_alm", id: false, force: :cascade do |t|
    t.integer "id",              limit: 3,          null: false
    t.text    "name",            limit: 65535,      null: false
    t.text    "repeaterDefault", limit: 4294967295, null: false
    t.text    "pluginVersion",   limit: 65535,      null: false
  end

  add_index "wp_alm", ["id"], name: "id", unique: true, using: :btree

  create_table "wp_bp_activity", force: :cascade do |t|
    t.integer  "user_id",           limit: 8,                          null: false
    t.string   "component",         limit: 75,                         null: false
    t.string   "type",              limit: 75,                         null: false
    t.text     "action",            limit: 65535,                      null: false
    t.text     "content",           limit: 4294967295,                 null: false
    t.text     "primary_link",      limit: 65535,                      null: false
    t.integer  "item_id",           limit: 8,                          null: false
    t.integer  "secondary_item_id", limit: 8
    t.datetime "date_recorded",                                        null: false
    t.boolean  "hide_sitewide",                        default: false
    t.integer  "mptt_left",         limit: 4,          default: 0,     null: false
    t.integer  "mptt_right",        limit: 4,          default: 0,     null: false
    t.boolean  "is_spam",                              default: false, null: false
  end

  add_index "wp_bp_activity", ["component"], name: "component", using: :btree
  add_index "wp_bp_activity", ["date_recorded"], name: "date_recorded", using: :btree
  add_index "wp_bp_activity", ["hide_sitewide"], name: "hide_sitewide", using: :btree
  add_index "wp_bp_activity", ["is_spam"], name: "is_spam", using: :btree
  add_index "wp_bp_activity", ["item_id"], name: "item_id", using: :btree
  add_index "wp_bp_activity", ["mptt_left"], name: "mptt_left", using: :btree
  add_index "wp_bp_activity", ["mptt_right"], name: "mptt_right", using: :btree
  add_index "wp_bp_activity", ["secondary_item_id"], name: "secondary_item_id", using: :btree
  add_index "wp_bp_activity", ["type"], name: "type", using: :btree
  add_index "wp_bp_activity", ["user_id"], name: "user_id", using: :btree

  create_table "wp_bp_activity_meta", force: :cascade do |t|
    t.integer "activity_id", limit: 8,          null: false
    t.string  "meta_key",    limit: 255
    t.text    "meta_value",  limit: 4294967295
  end

  add_index "wp_bp_activity_meta", ["activity_id"], name: "activity_id", using: :btree
  add_index "wp_bp_activity_meta", ["meta_key"], name: "meta_key", length: {"meta_key"=>191}, using: :btree

  create_table "wp_bp_groups", force: :cascade do |t|
    t.integer  "creator_id",   limit: 8,                             null: false
    t.string   "name",         limit: 100,                           null: false
    t.string   "slug",         limit: 200,                           null: false
    t.text     "description",  limit: 4294967295,                    null: false
    t.string   "status",       limit: 10,         default: "public", null: false
    t.boolean  "enable_forum",                    default: true,     null: false
    t.datetime "date_created",                                       null: false
  end

  add_index "wp_bp_groups", ["creator_id"], name: "creator_id", using: :btree
  add_index "wp_bp_groups", ["status"], name: "status", using: :btree

  create_table "wp_bp_groups_groupmeta", force: :cascade do |t|
    t.integer "group_id",   limit: 8,          null: false
    t.string  "meta_key",   limit: 255
    t.text    "meta_value", limit: 4294967295
  end

  add_index "wp_bp_groups_groupmeta", ["group_id"], name: "group_id", using: :btree
  add_index "wp_bp_groups_groupmeta", ["meta_key"], name: "meta_key", length: {"meta_key"=>191}, using: :btree

  create_table "wp_bp_groups_members", force: :cascade do |t|
    t.integer  "group_id",      limit: 8,                          null: false
    t.integer  "user_id",       limit: 8,                          null: false
    t.integer  "inviter_id",    limit: 8,                          null: false
    t.boolean  "is_admin",                         default: false, null: false
    t.boolean  "is_mod",                           default: false, null: false
    t.string   "user_title",    limit: 100,                        null: false
    t.datetime "date_modified",                                    null: false
    t.text     "comments",      limit: 4294967295,                 null: false
    t.boolean  "is_confirmed",                     default: false, null: false
    t.boolean  "is_banned",                        default: false, null: false
    t.boolean  "invite_sent",                      default: false, null: false
  end

  add_index "wp_bp_groups_members", ["group_id"], name: "group_id", using: :btree
  add_index "wp_bp_groups_members", ["inviter_id"], name: "inviter_id", using: :btree
  add_index "wp_bp_groups_members", ["is_admin"], name: "is_admin", using: :btree
  add_index "wp_bp_groups_members", ["is_confirmed"], name: "is_confirmed", using: :btree
  add_index "wp_bp_groups_members", ["is_mod"], name: "is_mod", using: :btree
  add_index "wp_bp_groups_members", ["user_id"], name: "user_id", using: :btree

  create_table "wp_bp_notifications", force: :cascade do |t|
    t.integer  "user_id",           limit: 8,                  null: false
    t.integer  "item_id",           limit: 8,                  null: false
    t.integer  "secondary_item_id", limit: 8
    t.string   "component_name",    limit: 75,                 null: false
    t.string   "component_action",  limit: 75,                 null: false
    t.datetime "date_notified",                                null: false
    t.boolean  "is_new",                       default: false, null: false
  end

  add_index "wp_bp_notifications", ["component_action"], name: "component_action", using: :btree
  add_index "wp_bp_notifications", ["component_name"], name: "component_name", using: :btree
  add_index "wp_bp_notifications", ["is_new"], name: "is_new", using: :btree
  add_index "wp_bp_notifications", ["item_id"], name: "item_id", using: :btree
  add_index "wp_bp_notifications", ["secondary_item_id"], name: "secondary_item_id", using: :btree
  add_index "wp_bp_notifications", ["user_id", "is_new"], name: "useritem", using: :btree
  add_index "wp_bp_notifications", ["user_id"], name: "user_id", using: :btree

  create_table "wp_bp_notifications_meta", force: :cascade do |t|
    t.integer "notification_id", limit: 8,          null: false
    t.string  "meta_key",        limit: 255
    t.text    "meta_value",      limit: 4294967295
  end

  add_index "wp_bp_notifications_meta", ["meta_key"], name: "meta_key", length: {"meta_key"=>191}, using: :btree
  add_index "wp_bp_notifications_meta", ["notification_id"], name: "notification_id", using: :btree

  create_table "wp_bp_xprofile_data", force: :cascade do |t|
    t.integer  "field_id",     limit: 8,          null: false
    t.integer  "user_id",      limit: 8,          null: false
    t.text     "value",        limit: 4294967295, null: false
    t.datetime "last_updated",                    null: false
  end

  add_index "wp_bp_xprofile_data", ["field_id"], name: "field_id", using: :btree
  add_index "wp_bp_xprofile_data", ["user_id"], name: "user_id", using: :btree

  create_table "wp_bp_xprofile_fields", force: :cascade do |t|
    t.integer "group_id",          limit: 8,                          null: false
    t.integer "parent_id",         limit: 8,                          null: false
    t.string  "type",              limit: 150,                        null: false
    t.string  "name",              limit: 150,                        null: false
    t.text    "description",       limit: 4294967295,                 null: false
    t.boolean "is_required",                          default: false, null: false
    t.boolean "is_default_option",                    default: false, null: false
    t.integer "field_order",       limit: 8,          default: 0,     null: false
    t.integer "option_order",      limit: 8,          default: 0,     null: false
    t.string  "order_by",          limit: 15,         default: "",    null: false
    t.boolean "can_delete",                           default: true,  null: false
  end

  add_index "wp_bp_xprofile_fields", ["can_delete"], name: "can_delete", using: :btree
  add_index "wp_bp_xprofile_fields", ["field_order"], name: "field_order", using: :btree
  add_index "wp_bp_xprofile_fields", ["group_id"], name: "group_id", using: :btree
  add_index "wp_bp_xprofile_fields", ["is_required"], name: "is_required", using: :btree
  add_index "wp_bp_xprofile_fields", ["parent_id"], name: "parent_id", using: :btree

  create_table "wp_bp_xprofile_groups", force: :cascade do |t|
    t.string  "name",        limit: 150,                  null: false
    t.text    "description", limit: 16777215,             null: false
    t.integer "group_order", limit: 8,        default: 0, null: false
    t.boolean "can_delete",                               null: false
  end

  add_index "wp_bp_xprofile_groups", ["can_delete"], name: "can_delete", using: :btree

  create_table "wp_bp_xprofile_meta", force: :cascade do |t|
    t.integer "object_id",   limit: 8,          null: false
    t.string  "object_type", limit: 150,        null: false
    t.string  "meta_key",    limit: 255
    t.text    "meta_value",  limit: 4294967295
  end

  add_index "wp_bp_xprofile_meta", ["meta_key"], name: "meta_key", length: {"meta_key"=>191}, using: :btree
  add_index "wp_bp_xprofile_meta", ["object_id"], name: "object_id", using: :btree

  create_table "wp_cf_form_entries", force: :cascade do |t|
    t.string   "form_id",   limit: 18, default: "",       null: false
    t.integer  "user_id",   limit: 4,                     null: false
    t.datetime "datestamp",                               null: false
    t.string   "status",    limit: 20, default: "active", null: false
  end

  add_index "wp_cf_form_entries", ["datestamp"], name: "date_time", using: :btree
  add_index "wp_cf_form_entries", ["form_id"], name: "form_id", using: :btree
  add_index "wp_cf_form_entries", ["status"], name: "status", using: :btree
  add_index "wp_cf_form_entries", ["user_id"], name: "user_id", using: :btree

  create_table "wp_cf_form_entry_meta", primary_key: "meta_id", force: :cascade do |t|
    t.integer "entry_id",   limit: 8,          default: 0, null: false
    t.string  "process_id", limit: 255
    t.string  "meta_key",   limit: 255
    t.text    "meta_value", limit: 4294967295
  end

  add_index "wp_cf_form_entry_meta", ["entry_id"], name: "entry_id", using: :btree
  add_index "wp_cf_form_entry_meta", ["meta_key"], name: "meta_key", using: :btree

  create_table "wp_cf_form_entry_values", force: :cascade do |t|
    t.integer "entry_id", limit: 4,                       null: false
    t.string  "field_id", limit: 20,                      null: false
    t.string  "slug",     limit: 255,        default: "", null: false
    t.text    "value",    limit: 4294967295,              null: false
  end

  add_index "wp_cf_form_entry_values", ["entry_id"], name: "form_id", using: :btree
  add_index "wp_cf_form_entry_values", ["field_id"], name: "field_id", using: :btree
  add_index "wp_cf_form_entry_values", ["slug"], name: "slug", using: :btree

  create_table "wp_commentmeta", primary_key: "meta_id", force: :cascade do |t|
    t.integer "comment_id", limit: 8,          default: 0, null: false
    t.string  "meta_key",   limit: 255
    t.text    "meta_value", limit: 4294967295
  end

  add_index "wp_commentmeta", ["comment_id"], name: "comment_id", using: :btree
  add_index "wp_commentmeta", ["meta_key"], name: "meta_key", length: {"meta_key"=>191}, using: :btree

  create_table "wp_comments", primary_key: "comment_ID", force: :cascade do |t|
    t.integer  "comment_post_ID",      limit: 8,     default: 0,   null: false
    t.text     "comment_author",       limit: 255,                 null: false
    t.string   "comment_author_email", limit: 100,   default: "",  null: false
    t.string   "comment_author_url",   limit: 200,   default: "",  null: false
    t.string   "comment_author_IP",    limit: 100,   default: "",  null: false
    t.datetime "comment_date",                                     null: false
    t.datetime "comment_date_gmt",                                 null: false
    t.text     "comment_content",      limit: 65535,               null: false
    t.integer  "comment_karma",        limit: 4,     default: 0,   null: false
    t.string   "comment_approved",     limit: 20,    default: "1", null: false
    t.string   "comment_agent",        limit: 255,   default: "",  null: false
    t.string   "comment_type",         limit: 20,    default: "",  null: false
    t.integer  "comment_parent",       limit: 8,     default: 0,   null: false
    t.integer  "user_id",              limit: 8,     default: 0,   null: false
  end

  add_index "wp_comments", ["comment_approved", "comment_date_gmt"], name: "comment_approved_date_gmt", using: :btree
  add_index "wp_comments", ["comment_author_email"], name: "comment_author_email", length: {"comment_author_email"=>10}, using: :btree
  add_index "wp_comments", ["comment_date_gmt"], name: "comment_date_gmt", using: :btree
  add_index "wp_comments", ["comment_parent"], name: "comment_parent", using: :btree
  add_index "wp_comments", ["comment_post_ID"], name: "comment_post_ID", using: :btree

  create_table "wp_geo_mashup_administrative_names", id: false, force: :cascade do |t|
    t.string  "country_code", limit: 2,   null: false
    t.string  "admin_code",   limit: 20,  null: false
    t.string  "isolanguage",  limit: 7,   null: false
    t.integer "geoname_id",   limit: 3
    t.string  "name",         limit: 200, null: false
  end

  create_table "wp_geo_mashup_location_relationships", id: false, force: :cascade do |t|
    t.string   "object_name", limit: 80, null: false
    t.integer  "object_id",   limit: 8,  null: false
    t.integer  "location_id", limit: 3,  null: false
    t.datetime "geo_date",               null: false
  end

  add_index "wp_geo_mashup_location_relationships", ["object_name", "geo_date"], name: "object_date_key", using: :btree
  add_index "wp_geo_mashup_location_relationships", ["object_name", "object_id"], name: "object_name", using: :btree

  create_table "wp_geo_mashup_locations", force: :cascade do |t|
    t.float  "lat",            limit: 24,  null: false
    t.float  "lng",            limit: 24,  null: false
    t.text   "address",        limit: 255
    t.string "saved_name",     limit: 100
    t.text   "geoname",        limit: 255
    t.text   "postal_code",    limit: 255
    t.string "country_code",   limit: 2
    t.string "admin_code",     limit: 20
    t.string "sub_admin_code", limit: 80
    t.text   "locality_name",  limit: 255
  end

  add_index "wp_geo_mashup_locations", ["lat", "lng"], name: "latlng", unique: true, using: :btree
  add_index "wp_geo_mashup_locations", ["lat"], name: "lat", using: :btree
  add_index "wp_geo_mashup_locations", ["lng"], name: "lng", using: :btree
  add_index "wp_geo_mashup_locations", ["saved_name"], name: "saved_name", unique: true, using: :btree

  create_table "wp_groups_capability", primary_key: "capability_id", force: :cascade do |t|
    t.string "capability",  limit: 255,        null: false
    t.string "class",       limit: 255
    t.string "object",      limit: 255
    t.string "name",        limit: 100
    t.text   "description", limit: 4294967295
  end

  add_index "wp_groups_capability", ["capability", "class", "object"], name: "capability_kco", length: {"capability"=>20, "class"=>20, "object"=>20}, using: :btree
  add_index "wp_groups_capability", ["capability"], name: "capability", unique: true, length: {"capability"=>100}, using: :btree

  create_table "wp_groups_group", primary_key: "group_id", force: :cascade do |t|
    t.integer  "parent_id",   limit: 8
    t.integer  "creator_id",  limit: 8
    t.datetime "datetime"
    t.string   "name",        limit: 100,        null: false
    t.text     "description", limit: 4294967295
  end

  add_index "wp_groups_group", ["name"], name: "group_n", unique: true, using: :btree

  create_table "wp_groups_group_capability", id: false, force: :cascade do |t|
    t.integer "group_id",      limit: 8, null: false
    t.integer "capability_id", limit: 8, null: false
  end

  add_index "wp_groups_group_capability", ["capability_id", "group_id"], name: "group_capability_cg", using: :btree

  create_table "wp_groups_user_capability", id: false, force: :cascade do |t|
    t.integer "user_id",       limit: 8, null: false
    t.integer "capability_id", limit: 8, null: false
  end

  add_index "wp_groups_user_capability", ["capability_id", "user_id"], name: "user_capability_cu", using: :btree

  create_table "wp_groups_user_group", id: false, force: :cascade do |t|
    t.integer "user_id",  limit: 8, null: false
    t.integer "group_id", limit: 8, null: false
  end

  add_index "wp_groups_user_group", ["group_id", "user_id"], name: "user_group_gu", using: :btree

  create_table "wp_links", primary_key: "link_id", force: :cascade do |t|
    t.string   "link_url",         limit: 255,      default: "",  null: false
    t.string   "link_name",        limit: 255,      default: "",  null: false
    t.string   "link_image",       limit: 255,      default: "",  null: false
    t.string   "link_target",      limit: 25,       default: "",  null: false
    t.string   "link_description", limit: 255,      default: "",  null: false
    t.string   "link_visible",     limit: 20,       default: "Y", null: false
    t.integer  "link_owner",       limit: 8,        default: 1,   null: false
    t.integer  "link_rating",      limit: 4,        default: 0,   null: false
    t.datetime "link_updated",                                    null: false
    t.string   "link_rel",         limit: 255,      default: "",  null: false
    t.text     "link_notes",       limit: 16777215,               null: false
    t.string   "link_rss",         limit: 255,      default: "",  null: false
  end

  add_index "wp_links", ["link_visible"], name: "link_visible", using: :btree

  create_table "wp_nf_objectmeta", force: :cascade do |t|
    t.integer "object_id",  limit: 8,          null: false
    t.string  "meta_key",   limit: 255,        null: false
    t.text    "meta_value", limit: 4294967295, null: false
  end

  create_table "wp_nf_objects", force: :cascade do |t|
    t.string "type", limit: 255, null: false
  end

  create_table "wp_nf_relationships", force: :cascade do |t|
    t.integer "child_id",    limit: 8,   null: false
    t.integer "parent_id",   limit: 8,   null: false
    t.string  "child_type",  limit: 255, null: false
    t.string  "parent_type", limit: 255, null: false
  end

  create_table "wp_ninja_forms_fav_fields", force: :cascade do |t|
    t.integer "row_type", limit: 4,          null: false
    t.string  "type",     limit: 255,        null: false
    t.integer "order",    limit: 4,          null: false
    t.text    "data",     limit: 4294967295, null: false
    t.string  "name",     limit: 255,        null: false
  end

  create_table "wp_ninja_forms_fields", force: :cascade do |t|
    t.integer "form_id", limit: 4,          null: false
    t.string  "type",    limit: 255,        null: false
    t.integer "order",   limit: 4,          null: false
    t.text    "data",    limit: 4294967295, null: false
    t.integer "fav_id",  limit: 4
    t.integer "def_id",  limit: 4
  end

  create_table "wp_oauth_access_tokens", force: :cascade do |t|
    t.string   "access_token", limit: 4000, null: false
    t.string   "client_id",    limit: 80,   null: false
    t.string   "user_id",      limit: 80
    t.datetime "expires",                   null: false
    t.string   "scope",        limit: 4000
  end

  create_table "wp_oauth_authorization_codes", primary_key: "authorization_code", force: :cascade do |t|
    t.string   "client_id",    limit: 80,   null: false
    t.string   "user_id",      limit: 80
    t.string   "redirect_uri", limit: 2000
    t.datetime "expires",                   null: false
    t.string   "scope",        limit: 4000
    t.string   "id_token",     limit: 3000
  end

  create_table "wp_oauth_clients", primary_key: "client_id", force: :cascade do |t|
    t.string "client_secret", limit: 80,         null: false
    t.string "redirect_uri",  limit: 2000
    t.string "grant_types",   limit: 80
    t.string "scope",         limit: 4000
    t.string "user_id",       limit: 80
    t.string "name",          limit: 80
    t.text   "description",   limit: 4294967295
  end

  create_table "wp_oauth_jwt", primary_key: "client_id", force: :cascade do |t|
    t.string "subject",    limit: 80
    t.string "public_key", limit: 2000, null: false
  end

  create_table "wp_oauth_public_keys", primary_key: "client_id", force: :cascade do |t|
    t.string "public_key",           limit: 2000
    t.string "private_key",          limit: 2000
    t.string "encryption_algorithm", limit: 100,  default: "RS256"
  end

  create_table "wp_oauth_refresh_tokens", primary_key: "refresh_token", force: :cascade do |t|
    t.string   "client_id", limit: 80,   null: false
    t.string   "user_id",   limit: 80
    t.datetime "expires",                null: false
    t.string   "scope",     limit: 4000
  end

  create_table "wp_oauth_scopes", primary_key: "scope", force: :cascade do |t|
    t.boolean "is_default"
  end

  create_table "wp_options", primary_key: "option_id", force: :cascade do |t|
    t.string "option_name",  limit: 191
    t.text   "option_value", limit: 4294967295,                 null: false
    t.string "autoload",     limit: 20,         default: "yes", null: false
  end

  add_index "wp_options", ["autoload"], name: "wpe_autoload_options_index", using: :btree
  add_index "wp_options", ["option_name"], name: "option_name", unique: true, using: :btree

  create_table "wp_podsrel", force: :cascade do |t|
    t.integer "pod_id",           limit: 4
    t.integer "field_id",         limit: 4
    t.integer "item_id",          limit: 8
    t.integer "related_pod_id",   limit: 4
    t.integer "related_field_id", limit: 4
    t.integer "related_item_id",  limit: 8
    t.integer "weight",           limit: 2, default: 0
  end

  add_index "wp_podsrel", ["field_id", "item_id"], name: "field_item_idx", using: :btree
  add_index "wp_podsrel", ["field_id", "related_item_id"], name: "field_rel_item_idx", using: :btree
  add_index "wp_podsrel", ["related_field_id", "item_id"], name: "rel_field_item_idx", using: :btree
  add_index "wp_podsrel", ["related_field_id", "related_item_id"], name: "rel_field_rel_item_idx", using: :btree

  create_table "wp_postmeta", primary_key: "meta_id", force: :cascade do |t|
    t.integer "post_id",    limit: 8,          default: 0, null: false
    t.string  "meta_key",   limit: 255
    t.text    "meta_value", limit: 4294967295
  end

  add_index "wp_postmeta", ["meta_key"], name: "meta_key", length: {"meta_key"=>191}, using: :btree
  add_index "wp_postmeta", ["post_id"], name: "post_id", using: :btree

  create_table "wp_posts", primary_key: "ID", force: :cascade do |t|
    t.integer  "post_author",           limit: 8,          default: 0,         null: false
    t.datetime "post_date",                                                    null: false
    t.datetime "post_date_gmt",                                                null: false
    t.text     "post_content",          limit: 4294967295,                     null: false
    t.text     "post_title",            limit: 65535,                          null: false
    t.text     "post_excerpt",          limit: 65535,                          null: false
    t.string   "post_status",           limit: 20,         default: "publish", null: false
    t.string   "comment_status",        limit: 20,         default: "open",    null: false
    t.string   "ping_status",           limit: 20,         default: "open",    null: false
    t.string   "post_password",         limit: 20,         default: "",        null: false
    t.string   "post_name",             limit: 200,        default: "",        null: false
    t.text     "to_ping",               limit: 65535,                          null: false
    t.text     "pinged",                limit: 65535,                          null: false
    t.datetime "post_modified",                                                null: false
    t.datetime "post_modified_gmt",                                            null: false
    t.text     "post_content_filtered", limit: 4294967295,                     null: false
    t.integer  "post_parent",           limit: 8,          default: 0,         null: false
    t.string   "guid",                  limit: 255,        default: "",        null: false
    t.integer  "menu_order",            limit: 4,          default: 0,         null: false
    t.string   "post_type",             limit: 20,         default: "post",    null: false
    t.string   "post_mime_type",        limit: 100,        default: "",        null: false
    t.integer  "comment_count",         limit: 8,          default: 0,         null: false
  end

  add_index "wp_posts", ["post_author"], name: "post_author", using: :btree
  add_index "wp_posts", ["post_name"], name: "post_name", length: {"post_name"=>191}, using: :btree
  add_index "wp_posts", ["post_parent"], name: "post_parent", using: :btree
  add_index "wp_posts", ["post_type", "post_status", "post_date", "ID"], name: "type_status_date", using: :btree

  create_table "wp_relevanssi", id: false, force: :cascade do |t|
    t.integer "doc",                limit: 8,          default: 0,      null: false
    t.string  "term",               limit: 50,         default: "0",    null: false
    t.string  "term_reverse",       limit: 50,         default: "0",    null: false
    t.integer "content",            limit: 3,          default: 0,      null: false
    t.integer "title",              limit: 3,          default: 0,      null: false
    t.integer "comment",            limit: 3,          default: 0,      null: false
    t.integer "tag",                limit: 3,          default: 0,      null: false
    t.integer "link",               limit: 3,          default: 0,      null: false
    t.integer "author",             limit: 3,          default: 0,      null: false
    t.integer "category",           limit: 3,          default: 0,      null: false
    t.integer "excerpt",            limit: 3,          default: 0,      null: false
    t.integer "taxonomy",           limit: 3,          default: 0,      null: false
    t.integer "customfield",        limit: 3,          default: 0,      null: false
    t.integer "mysqlcolumn",        limit: 3,          default: 0,      null: false
    t.text    "taxonomy_detail",    limit: 4294967295,                  null: false
    t.text    "customfield_detail", limit: 4294967295,                  null: false
    t.text    "mysqlcolumn_detail", limit: 4294967295,                  null: false
    t.string  "type",               limit: 210,        default: "post", null: false
    t.integer "item",               limit: 8,          default: 0,      null: false
  end

  add_index "wp_relevanssi", ["doc", "term", "item"], name: "doctermitem", unique: true, using: :btree
  add_index "wp_relevanssi", ["doc"], name: "docs", using: :btree
  add_index "wp_relevanssi", ["term"], name: "terms", length: {"term"=>20}, using: :btree
  add_index "wp_relevanssi", ["term_reverse"], name: "relevanssi_term_reverse_idx", length: {"term_reverse"=>10}, using: :btree
  add_index "wp_relevanssi", ["type", "item"], name: "typeitem", length: {"type"=>191, "item"=>nil}, using: :btree

  create_table "wp_relevanssi_log", id: false, force: :cascade do |t|
    t.integer  "id",      limit: 8,                null: false
    t.string   "query",   limit: 200,              null: false
    t.integer  "hits",    limit: 3,   default: 0,  null: false
    t.datetime "time",                             null: false
    t.integer  "user_id", limit: 8,   default: 0,  null: false
    t.string   "ip",      limit: 40,  default: "", null: false
  end

  add_index "wp_relevanssi_log", ["id"], name: "id", unique: true, using: :btree

  create_table "wp_relevanssi_stopwords", id: false, force: :cascade do |t|
    t.string "stopword", limit: 50, null: false
  end

  add_index "wp_relevanssi_stopwords", ["stopword"], name: "stopword", unique: true, using: :btree

  create_table "wp_signups", primary_key: "signup_id", force: :cascade do |t|
    t.string   "domain",         limit: 200,        default: "",    null: false
    t.string   "path",           limit: 100,        default: "",    null: false
    t.text     "title",          limit: 4294967295,                 null: false
    t.string   "user_login",     limit: 60,         default: "",    null: false
    t.string   "user_email",     limit: 100,        default: "",    null: false
    t.datetime "registered",                                        null: false
    t.datetime "activated",                                         null: false
    t.boolean  "active",                            default: false, null: false
    t.string   "activation_key", limit: 50,         default: "",    null: false
    t.text     "meta",           limit: 4294967295
  end

  add_index "wp_signups", ["activation_key"], name: "activation_key", using: :btree
  add_index "wp_signups", ["domain", "path"], name: "domain_path", length: {"domain"=>140, "path"=>51}, using: :btree
  add_index "wp_signups", ["user_email"], name: "user_email", using: :btree
  add_index "wp_signups", ["user_login", "user_email"], name: "user_login_email", using: :btree

  create_table "wp_social_users", id: false, force: :cascade do |t|
    t.integer "ID",         limit: 4,   null: false
    t.string  "type",       limit: 20,  null: false
    t.string  "identifier", limit: 100, null: false
  end

  add_index "wp_social_users", ["ID", "type"], name: "ID", using: :btree

  create_table "wp_term_relationships", id: false, force: :cascade do |t|
    t.integer "object_id",        limit: 8, default: 0, null: false
    t.integer "term_taxonomy_id", limit: 8, default: 0, null: false
    t.integer "term_order",       limit: 4, default: 0, null: false
  end

  add_index "wp_term_relationships", ["term_taxonomy_id"], name: "term_taxonomy_id", using: :btree

  create_table "wp_term_taxonomy", primary_key: "term_taxonomy_id", force: :cascade do |t|
    t.integer "term_id",     limit: 8,          default: 0,  null: false
    t.string  "taxonomy",    limit: 32,         default: "", null: false
    t.text    "description", limit: 4294967295,              null: false
    t.integer "parent",      limit: 8,          default: 0,  null: false
    t.integer "count",       limit: 8,          default: 0,  null: false
  end

  add_index "wp_term_taxonomy", ["taxonomy"], name: "taxonomy", using: :btree
  add_index "wp_term_taxonomy", ["term_id", "taxonomy"], name: "term_id_taxonomy", unique: true, using: :btree

  create_table "wp_termmeta", primary_key: "meta_id", force: :cascade do |t|
    t.integer "term_id",    limit: 8,          default: 0, null: false
    t.string  "meta_key",   limit: 255
    t.text    "meta_value", limit: 4294967295
  end

  add_index "wp_termmeta", ["meta_key"], name: "meta_key", length: {"meta_key"=>191}, using: :btree
  add_index "wp_termmeta", ["term_id"], name: "term_id", using: :btree

  create_table "wp_terms", primary_key: "term_id", force: :cascade do |t|
    t.string  "name",       limit: 200, default: "", null: false
    t.string  "slug",       limit: 200, default: "", null: false
    t.integer "term_group", limit: 8,   default: 0,  null: false
  end

  add_index "wp_terms", ["name"], name: "name", length: {"name"=>191}, using: :btree
  add_index "wp_terms", ["slug"], name: "slug", length: {"slug"=>191}, using: :btree

  create_table "wp_usermeta", primary_key: "umeta_id", force: :cascade do |t|
    t.integer "user_id",    limit: 8,          default: 0, null: false
    t.string  "meta_key",   limit: 255
    t.text    "meta_value", limit: 4294967295
  end

  add_index "wp_usermeta", ["meta_key"], name: "meta_key", length: {"meta_key"=>191}, using: :btree
  add_index "wp_usermeta", ["user_id"], name: "user_id", using: :btree

  create_table "wp_users", primary_key: "ID", force: :cascade do |t|
    t.string   "user_login",          limit: 60,  default: "", null: false
    t.string   "user_pass",           limit: 255, default: "", null: false
    t.string   "user_nicename",       limit: 50,  default: "", null: false
    t.string   "user_email",          limit: 100, default: "", null: false
    t.string   "user_url",            limit: 100, default: "", null: false
    t.datetime "user_registered",                              null: false
    t.string   "user_activation_key", limit: 255, default: "", null: false
    t.integer  "user_status",         limit: 4,   default: 0,  null: false
    t.string   "display_name",        limit: 250, default: "", null: false
  end

  add_index "wp_users", ["user_email"], name: "user_email", using: :btree
  add_index "wp_users", ["user_login"], name: "user_login_key", using: :btree
  add_index "wp_users", ["user_nicename"], name: "user_nicename", using: :btree

end
