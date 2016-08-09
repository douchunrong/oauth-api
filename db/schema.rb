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

  create_table "v1_access_grant", force: :cascade do |t|
    t.integer  "created_by_id", limit: 8, null: false
    t.datetime "created_at"
    t.datetime "modified_at"
    t.datetime "deleted_at"
    t.integer  "profile_id",    limit: 8
    t.integer  "granted_by_id", limit: 8
    t.datetime "granted_at"
    t.integer  "migration_id",  limit: 8
    t.datetime "expired_at"
    t.integer  "waiver_id",     limit: 8
  end

  add_index "v1_access_grant", ["created_by_id"], name: "created_by_id", using: :btree
  add_index "v1_access_grant", ["granted_by_id"], name: "granted_by_id", using: :btree
  add_index "v1_access_grant", ["profile_id"], name: "profile_id", using: :btree
  add_index "v1_access_grant", ["waiver_id"], name: "waiver_id", using: :btree

  create_table "v1_association", force: :cascade do |t|
    t.integer  "created_by_id", limit: 8,     null: false
    t.datetime "created_at"
    t.datetime "modified_at"
    t.datetime "deleted_at"
    t.string   "name",          limit: 255
    t.text     "description",   limit: 65535
  end

  add_index "v1_association", ["created_by_id"], name: "created_by_id", using: :btree

  create_table "v1_attachment", force: :cascade do |t|
    t.integer  "created_by_id",  limit: 8,     null: false
    t.datetime "created_at"
    t.datetime "modified_at"
    t.datetime "deleted_at"
    t.string   "name",           limit: 255
    t.text     "description",    limit: 65535
    t.string   "meta",           limit: 30000
    t.string   "mime_type",      limit: 255
    t.integer  "migration_id",   limit: 8
    t.string   "migration_meta", limit: 30000
    t.string   "url",            limit: 2047
    t.text     "base64",         limit: 65535
    t.string   "type",           limit: 255
  end

  add_index "v1_attachment", ["created_by_id"], name: "created_by_id", using: :btree
  add_index "v1_attachment", ["migration_id"], name: "migration_id", using: :btree

  create_table "v1_contact", force: :cascade do |t|
    t.integer  "created_by_id",  limit: 8,   null: false
    t.datetime "created_at"
    t.datetime "modified_at"
    t.datetime "deleted_at"
    t.string   "name",           limit: 256
    t.string   "email",          limit: 256
    t.string   "phone",          limit: 256
    t.integer  "migration_id",   limit: 8,   null: false
    t.string   "migration_type", limit: 64
    t.string   "relationship",   limit: 64
    t.integer  "photo_id",       limit: 8
  end

  add_index "v1_contact", ["created_by_id"], name: "created_by_id", using: :btree
  add_index "v1_contact", ["migration_id"], name: "migration_id", using: :btree
  add_index "v1_contact", ["photo_id"], name: "photo_id", using: :btree

  create_table "v1_division", force: :cascade do |t|
    t.integer  "created_by_id",    limit: 8,     null: false
    t.datetime "created_at"
    t.datetime "modified_at"
    t.datetime "deleted_at"
    t.string   "name",             limit: 255
    t.text     "description",      limit: 65535
    t.integer  "organization_id",  limit: 8
    t.integer  "parent_id",        limit: 8
    t.integer  "division_type_id", limit: 8
    t.integer  "migration_id",     limit: 8
  end

  add_index "v1_division", ["created_by_id"], name: "created_by_id", using: :btree
  add_index "v1_division", ["division_type_id"], name: "division_type_id", using: :btree
  add_index "v1_division", ["migration_id"], name: "migration_id", using: :btree
  add_index "v1_division", ["organization_id"], name: "organization_id", using: :btree
  add_index "v1_division", ["parent_id"], name: "parent_id", using: :btree

  create_table "v1_division_type", force: :cascade do |t|
    t.integer  "created_by_id",   limit: 8,     null: false
    t.datetime "created_at"
    t.datetime "modified_at"
    t.datetime "deleted_at"
    t.string   "name",            limit: 255
    t.text     "description",     limit: 65535
    t.integer  "organization_id", limit: 8
    t.integer  "parent_id",       limit: 8
  end

  add_index "v1_division_type", ["created_by_id"], name: "created_by_id", using: :btree
  add_index "v1_division_type", ["organization_id"], name: "organization_id", using: :btree
  add_index "v1_division_type", ["parent_id"], name: "parent_id", using: :btree

  create_table "v1_event_participant", force: :cascade do |t|
    t.integer  "created_by_id", limit: 8,   null: false
    t.datetime "created_at"
    t.datetime "modified_at"
    t.datetime "deleted_at"
    t.integer  "place_id",      limit: 8
    t.string   "type",          limit: 255
    t.integer  "group_id",      limit: 8
    t.integer  "profile_id",    limit: 8
  end

  add_index "v1_event_participant", ["created_by_id"], name: "created_by_id", using: :btree
  add_index "v1_event_participant", ["group_id"], name: "FK__v1_event_participant__v1_group", using: :btree
  add_index "v1_event_participant", ["place_id"], name: "FK__v1_event_participant__v1_place", using: :btree
  add_index "v1_event_participant", ["profile_id"], name: "profile_id", using: :btree

  create_table "v1_external_source", force: :cascade do |t|
    t.integer  "created_by_id",   limit: 8,     null: false
    t.datetime "created_at"
    t.datetime "modified_at"
    t.datetime "deleted_at"
    t.string   "name",            limit: 255
    t.text     "description",     limit: 65535
    t.string   "website",         limit: 2047
    t.string   "label",           limit: 255
    t.integer  "organization_id", limit: 8
  end

  add_index "v1_external_source", ["created_by_id"], name: "created_by_id", using: :btree
  add_index "v1_external_source", ["organization_id"], name: "organization_id", using: :btree

  create_table "v1_group", force: :cascade do |t|
    t.integer  "created_by_id",   limit: 8,     null: false
    t.datetime "created_at"
    t.datetime "modified_at"
    t.datetime "deleted_at"
    t.string   "name",            limit: 255
    t.text     "description",     limit: 65535
    t.string   "website",         limit: 2047
    t.integer  "sport_id",        limit: 8
    t.integer  "organization_id", limit: 8
    t.integer  "division_id",     limit: 8
    t.integer  "association_id",  limit: 8
    t.string   "age_group",       limit: 255
    t.integer  "logo_id",         limit: 8
    t.integer  "migration_id",    limit: 8,     null: false
    t.string   "type",            limit: 255
    t.boolean  "private"
  end

  add_index "v1_group", ["association_id"], name: "association_id", using: :btree
  add_index "v1_group", ["created_by_id"], name: "created_by_id", using: :btree
  add_index "v1_group", ["division_id"], name: "division_id", using: :btree
  add_index "v1_group", ["logo_id"], name: "logo_id", using: :btree
  add_index "v1_group", ["migration_id"], name: "migration_id", using: :btree
  add_index "v1_group", ["organization_id"], name: "organization_id", using: :btree
  add_index "v1_group", ["sport_id"], name: "sport_id", using: :btree

  create_table "v1_group_membership", force: :cascade do |t|
    t.integer  "created_by_id",  limit: 8,  null: false
    t.datetime "created_at"
    t.datetime "modified_at"
    t.datetime "deleted_at"
    t.integer  "group_id",       limit: 8
    t.integer  "profile_id",     limit: 8
    t.string   "uniform_number", limit: 15
    t.string   "position",       limit: 63
    t.integer  "accepted_by_id", limit: 8
    t.datetime "accepted_at"
    t.integer  "approved_by_id", limit: 8
    t.datetime "approved_at"
    t.integer  "migration_id",   limit: 8
  end

  add_index "v1_group_membership", ["accepted_by_id"], name: "accepted_by_id", using: :btree
  add_index "v1_group_membership", ["approved_by_id"], name: "approved_by_id", using: :btree
  add_index "v1_group_membership", ["created_by_id"], name: "created_by_id", using: :btree
  add_index "v1_group_membership", ["group_id"], name: "FK__v1_team_membership__v1_group", using: :btree
  add_index "v1_group_membership", ["migration_id"], name: "migration_id", using: :btree
  add_index "v1_group_membership", ["profile_id"], name: "profile_id", using: :btree

  create_table "v1_insurance", force: :cascade do |t|
    t.integer  "created_by_id", limit: 8,   null: false
    t.datetime "created_at"
    t.datetime "modified_at"
    t.datetime "deleted_at"
    t.string   "company_name",  limit: 255
    t.string   "plan_type",     limit: 255
    t.string   "group_number",  limit: 256, null: false
    t.string   "phone",         limit: 256, null: false
    t.string   "member_number", limit: 255
    t.integer  "migration_id",  limit: 8
  end

  add_index "v1_insurance", ["created_by_id"], name: "created_by_id", using: :btree
  add_index "v1_insurance", ["migration_id"], name: "migration_id", using: :btree

  create_table "v1_invite", force: :cascade do |t|
    t.integer  "created_by_id",            limit: 8,     null: false
    t.datetime "created_at"
    t.datetime "modified_at"
    t.datetime "deleted_at"
    t.string   "user_email",               limit: 255
    t.string   "invited_by_friendly_name", limit: 255
    t.text     "message",                  limit: 65535
    t.string   "token",                    limit: 36,    null: false
    t.string   "pass_phrase",              limit: 255
    t.datetime "accepted_at"
    t.datetime "rejected_at"
    t.string   "type",                     limit: 255
    t.integer  "division_id",              limit: 8
    t.integer  "place_id",                 limit: 8
    t.integer  "organization_id",          limit: 8
    t.integer  "profile_id",               limit: 8
    t.integer  "group_id",                 limit: 8
  end

  add_index "v1_invite", ["created_by_id"], name: "created_by_id", using: :btree
  add_index "v1_invite", ["division_id"], name: "division_id", using: :btree
  add_index "v1_invite", ["group_id"], name: "FK__v1_invite__v1_group", using: :btree
  add_index "v1_invite", ["organization_id"], name: "organization_id", using: :btree
  add_index "v1_invite", ["place_id"], name: "FK__v1_invite__v1_place", using: :btree
  add_index "v1_invite", ["profile_id"], name: "profile_id", using: :btree

  create_table "v1_location", force: :cascade do |t|
    t.integer  "created_by_id",            limit: 8,     null: false
    t.datetime "created_at"
    t.datetime "modified_at"
    t.datetime "deleted_at"
    t.string   "name",                     limit: 255
    t.text     "description",              limit: 65535
    t.string   "address",                  limit: 1023
    t.float    "user_latitude",            limit: 24
    t.float    "user_longitude",           limit: 24
    t.float    "latitude",                 limit: 24
    t.float    "longitude",                limit: 24
    t.integer  "migration_id",             limit: 8,     null: false
    t.string   "migration_street_address", limit: 1024
    t.string   "migration_unit",           limit: 1024
    t.string   "migration_city",           limit: 1024
    t.string   "migration_state",          limit: 1024
    t.string   "migration_zip",            limit: 1024
  end

  add_index "v1_location", ["created_by_id"], name: "created_by_id", using: :btree
  add_index "v1_location", ["migration_id"], name: "migration_id", using: :btree

  create_table "v1_organization", force: :cascade do |t|
    t.integer  "created_by_id", limit: 8,     null: false
    t.datetime "created_at"
    t.datetime "modified_at"
    t.datetime "deleted_at"
    t.string   "name",          limit: 255
    t.text     "description",   limit: 65535
    t.integer  "migration_id",  limit: 8
  end

  add_index "v1_organization", ["created_by_id"], name: "created_by_id", using: :btree
  add_index "v1_organization", ["migration_id"], name: "migration_id", using: :btree

  create_table "v1_organization_number", force: :cascade do |t|
    t.integer  "created_by_id",   limit: 8,   null: false
    t.datetime "created_at"
    t.datetime "modified_at"
    t.datetime "deleted_at"
    t.integer  "profile_id",      limit: 8,   null: false
    t.integer  "organization_id", limit: 8,   null: false
    t.string   "number",          limit: 256, null: false
  end

  add_index "v1_organization_number", ["created_by_id"], name: "created_by_id", using: :btree
  add_index "v1_organization_number", ["organization_id"], name: "organization_id", using: :btree
  add_index "v1_organization_number", ["profile_id"], name: "profile_id", using: :btree

  create_table "v1_organizer", force: :cascade do |t|
    t.integer  "created_by_id",     limit: 8,   null: false
    t.datetime "created_at"
    t.datetime "modified_at"
    t.datetime "deleted_at"
    t.integer  "organizer_id",      limit: 8,   null: false
    t.integer  "organizer_type_id", limit: 8
    t.string   "type",              limit: 255
    t.integer  "association_id",    limit: 8
    t.integer  "division_id",       limit: 8
    t.integer  "place_id",          limit: 8
    t.integer  "organization_id",   limit: 8
    t.integer  "profile_id",        limit: 8
    t.integer  "group_id",          limit: 8
    t.boolean  "can_edit"
    t.boolean  "can_add_organizer"
  end

  add_index "v1_organizer", ["association_id"], name: "association_id", using: :btree
  add_index "v1_organizer", ["created_by_id"], name: "created_by_id", using: :btree
  add_index "v1_organizer", ["division_id"], name: "division_id", using: :btree
  add_index "v1_organizer", ["group_id"], name: "FK__v1_organizer__v1_group", using: :btree
  add_index "v1_organizer", ["organization_id"], name: "organization_id", using: :btree
  add_index "v1_organizer", ["organizer_id"], name: "organizer_id", using: :btree
  add_index "v1_organizer", ["organizer_type_id"], name: "organizer_type_id", using: :btree
  add_index "v1_organizer", ["place_id"], name: "FK__v1_organizer__v1_place", using: :btree
  add_index "v1_organizer", ["profile_id"], name: "profile_id", using: :btree

  create_table "v1_organizer_type", force: :cascade do |t|
    t.integer  "created_by_id",             limit: 8,                  null: false
    t.datetime "created_at"
    t.datetime "modified_at"
    t.datetime "deleted_at"
    t.string   "type",                      limit: 255
    t.string   "value",                     limit: 255
    t.string   "label",                     limit: 255
    t.boolean  "default_can_edit",                      default: true
    t.boolean  "default_can_add_organizer",             default: true
  end

  add_index "v1_organizer_type", ["created_by_id"], name: "created_by_id", using: :btree
  add_index "v1_organizer_type", ["value", "type"], name: "value", unique: true, using: :btree

  create_table "v1_place", force: :cascade do |t|
    t.integer  "created_by_id", limit: 8,     null: false
    t.datetime "created_at"
    t.datetime "modified_at"
    t.datetime "deleted_at"
    t.string   "name",          limit: 255
    t.text     "description",   limit: 65535
    t.string   "website",       limit: 2047
    t.datetime "begins_at"
    t.datetime "ends_at"
    t.string   "event_type",    limit: 255
    t.integer  "sport_id",      limit: 8
    t.string   "age_group",     limit: 255
    t.integer  "logo_id",       limit: 8
    t.integer  "migration_id",  limit: 8,     null: false
    t.string   "type",          limit: 255
    t.boolean  "private"
  end

  add_index "v1_place", ["created_by_id"], name: "created_by_id", using: :btree
  add_index "v1_place", ["logo_id"], name: "logo_id", using: :btree
  add_index "v1_place", ["migration_id"], name: "migration_id", using: :btree
  add_index "v1_place", ["sport_id"], name: "sport_id", using: :btree

  create_table "v1_profile", force: :cascade do |t|
    t.integer  "created_by_id", limit: 8,  null: false
    t.datetime "created_at"
    t.datetime "modified_at"
    t.datetime "deleted_at"
    t.integer  "migration_id",  limit: 8,  null: false
    t.string   "sport_id_code", limit: 32, null: false
    t.integer  "user_id",       limit: 8
    t.string   "display_name",  limit: 64, null: false
  end

  add_index "v1_profile", ["created_by_id"], name: "created_by_id", using: :btree
  add_index "v1_profile", ["migration_id"], name: "migration_id", using: :btree
  add_index "v1_profile", ["sport_id_code"], name: "sport_id_code", unique: true, using: :btree
  add_index "v1_profile", ["user_id"], name: "user_id", using: :btree

  create_table "v1_profile_data", force: :cascade do |t|
    t.integer  "created_by_id",          limit: 8,                    null: false
    t.datetime "created_at"
    t.datetime "modified_at"
    t.datetime "deleted_at"
    t.integer  "profile_id",             limit: 8
    t.integer  "profile_data_type_id",   limit: 8
    t.boolean  "applicable",                           default: true
    t.string   "type",                   limit: 255
    t.string   "value",                  limit: 60000
    t.integer  "attachment_id",          limit: 8
    t.integer  "organization_number_id", limit: 8
    t.integer  "location_id",            limit: 8
    t.integer  "contact_id",             limit: 8
    t.integer  "insurance_id",           limit: 8
    t.string   "source",                 limit: 255
    t.integer  "migration_id",           limit: 8
  end

  add_index "v1_profile_data", ["attachment_id"], name: "attachment_id", using: :btree
  add_index "v1_profile_data", ["contact_id"], name: "contact_id", using: :btree
  add_index "v1_profile_data", ["created_by_id"], name: "created_by_id", using: :btree
  add_index "v1_profile_data", ["insurance_id"], name: "insurance_id", using: :btree
  add_index "v1_profile_data", ["location_id"], name: "location_id", using: :btree
  add_index "v1_profile_data", ["organization_number_id"], name: "organization_number_id", using: :btree
  add_index "v1_profile_data", ["profile_data_type_id"], name: "profile_data_type_id", using: :btree
  add_index "v1_profile_data", ["profile_id"], name: "profile_id", using: :btree

  create_table "v1_profile_data_type", force: :cascade do |t|
    t.integer  "created_by_id", limit: 8,                    null: false
    t.datetime "created_at"
    t.datetime "modified_at"
    t.datetime "deleted_at"
    t.integer  "scope_id",      limit: 8,                    null: false
    t.string   "name",          limit: 255
    t.text     "description",   limit: 65535
    t.boolean  "singular",                    default: true
    t.string   "data_type",     limit: 255
    t.string   "label",         limit: 255
  end

  add_index "v1_profile_data_type", ["created_by_id"], name: "created_by_id", using: :btree
  add_index "v1_profile_data_type", ["name"], name: "name", unique: true, using: :btree
  add_index "v1_profile_data_type", ["scope_id"], name: "scope_id", using: :btree

  create_table "v1_resource_external_source", force: :cascade do |t|
    t.integer  "created_by_id",      limit: 8,   null: false
    t.datetime "created_at"
    t.datetime "modified_at"
    t.datetime "deleted_at"
    t.integer  "external_source_id", limit: 8,   null: false
    t.string   "identifier",         limit: 255, null: false
    t.string   "type",               limit: 255
    t.integer  "association_id",     limit: 8
    t.integer  "division_id",        limit: 8
    t.integer  "place_id",           limit: 8
    t.integer  "organization_id",    limit: 8
    t.integer  "profile_id",         limit: 8
    t.integer  "group_id",           limit: 8
  end

  add_index "v1_resource_external_source", ["association_id"], name: "association_id", using: :btree
  add_index "v1_resource_external_source", ["created_by_id"], name: "created_by_id", using: :btree
  add_index "v1_resource_external_source", ["division_id"], name: "division_id", using: :btree
  add_index "v1_resource_external_source", ["external_source_id", "identifier"], name: "external_source_id", unique: true, using: :btree
  add_index "v1_resource_external_source", ["group_id"], name: "FK__v1_resource_external_source__v1_group", using: :btree
  add_index "v1_resource_external_source", ["organization_id"], name: "organization_id", using: :btree
  add_index "v1_resource_external_source", ["place_id"], name: "FK__v1_resource_external_source__v1_place", using: :btree
  add_index "v1_resource_external_source", ["profile_id"], name: "profile_id", using: :btree

  create_table "v1_resource_location", force: :cascade do |t|
    t.integer  "created_by_id",   limit: 8,   null: false
    t.datetime "created_at"
    t.datetime "modified_at"
    t.datetime "deleted_at"
    t.integer  "location_id",     limit: 8
    t.string   "type",            limit: 255
    t.integer  "association_id",  limit: 8
    t.integer  "division_id",     limit: 8
    t.integer  "place_id",        limit: 8
    t.integer  "organization_id", limit: 8
    t.integer  "profile_id",      limit: 8
    t.integer  "group_id",        limit: 8
    t.integer  "migration_id",    limit: 8,   null: false
  end

  add_index "v1_resource_location", ["association_id"], name: "association_id", using: :btree
  add_index "v1_resource_location", ["created_by_id"], name: "created_by_id", using: :btree
  add_index "v1_resource_location", ["division_id"], name: "division_id", using: :btree
  add_index "v1_resource_location", ["group_id"], name: "FK__v1_resource_location__v1_group", using: :btree
  add_index "v1_resource_location", ["location_id"], name: "location_id", using: :btree
  add_index "v1_resource_location", ["migration_id"], name: "migration_id", using: :btree
  add_index "v1_resource_location", ["organization_id"], name: "organization_id", using: :btree
  add_index "v1_resource_location", ["place_id"], name: "FK__v1_resource_location__v1_place", using: :btree
  add_index "v1_resource_location", ["profile_id"], name: "profile_id", using: :btree

  create_table "v1_scope", force: :cascade do |t|
    t.integer  "created_by_id", limit: 8,     null: false
    t.datetime "created_at"
    t.datetime "modified_at"
    t.datetime "deleted_at"
    t.string   "name",          limit: 255
    t.text     "description",   limit: 65535
    t.string   "label",         limit: 255
  end

  add_index "v1_scope", ["created_by_id"], name: "created_by_id", using: :btree
  add_index "v1_scope", ["name"], name: "name", unique: true, using: :btree

  create_table "v1_signature", force: :cascade do |t|
    t.integer  "created_by_id", limit: 8,     null: false
    t.datetime "created_at"
    t.datetime "modified_at"
    t.datetime "deleted_at"
    t.integer  "signed_by_id",  limit: 8,     null: false
    t.binary   "sha256",        limit: 20
    t.string   "type",          limit: 255
    t.text     "base64",        limit: 65535
    t.text     "markup",        limit: 65535
    t.integer  "migration_id",  limit: 8
  end

  add_index "v1_signature", ["created_by_id"], name: "created_by_id", using: :btree
  add_index "v1_signature", ["migration_id"], name: "migration_id", unique: true, using: :btree
  add_index "v1_signature", ["signed_by_id", "type", "sha256"], name: "signed_by_id", unique: true, using: :btree

  create_table "v1_sport", force: :cascade do |t|
    t.integer  "created_by_id", limit: 8,     null: false
    t.datetime "created_at"
    t.datetime "modified_at"
    t.datetime "deleted_at"
    t.string   "slug",          limit: 255
    t.string   "name",          limit: 255
    t.text     "description",   limit: 65535
    t.integer  "migration_id",  limit: 8,     null: false
  end

  add_index "v1_sport", ["created_by_id"], name: "created_by_id", using: :btree
  add_index "v1_sport", ["migration_id"], name: "migration_id", using: :btree

  create_table "v1_waiver", force: :cascade do |t|
    t.integer  "created_by_id",       limit: 8,                    null: false
    t.datetime "created_at"
    t.datetime "modified_at"
    t.datetime "deleted_at"
    t.string   "name",                limit: 255
    t.text     "body",                limit: 65535
    t.string   "type",                limit: 255
    t.integer  "division_id",         limit: 8
    t.integer  "place_id",            limit: 8
    t.integer  "organization_id",     limit: 8
    t.integer  "profile_id",          limit: 8
    t.integer  "group_id",            limit: 8
    t.integer  "migration_id",        limit: 8
    t.boolean  "requires_signature",                default: true
    t.boolean  "requires_acceptance",               default: true
    t.integer  "waiver_id",           limit: 8
  end

  add_index "v1_waiver", ["created_by_id"], name: "created_by_id", using: :btree
  add_index "v1_waiver", ["division_id"], name: "division_id", using: :btree
  add_index "v1_waiver", ["group_id"], name: "FK__v1_waiver__v1_group", using: :btree
  add_index "v1_waiver", ["migration_id"], name: "migration_id", using: :btree
  add_index "v1_waiver", ["organization_id"], name: "organization_id", using: :btree
  add_index "v1_waiver", ["place_id"], name: "FK__v1_waiver__v1_place", using: :btree
  add_index "v1_waiver", ["profile_id"], name: "profile_id", using: :btree
  add_index "v1_waiver", ["waiver_id"], name: "waiver_id", using: :btree

  create_table "v1_waiver_field", force: :cascade do |t|
    t.integer  "created_by_id",        limit: 8,   null: false
    t.datetime "created_at"
    t.datetime "modified_at"
    t.datetime "deleted_at"
    t.integer  "wavier_id",            limit: 8
    t.integer  "profile_data_type_id", limit: 8
    t.string   "description",          limit: 255
    t.integer  "waiver_id",            limit: 8
  end

  add_index "v1_waiver_field", ["created_by_id"], name: "created_by_id", using: :btree
  add_index "v1_waiver_field", ["profile_data_type_id"], name: "profile_data_type_id", using: :btree
  add_index "v1_waiver_field", ["waiver_id"], name: "waiver_id", using: :btree
  add_index "v1_waiver_field", ["wavier_id"], name: "wavier_id", using: :btree

  create_table "v1_waiver_signing", force: :cascade do |t|
    t.integer  "created_by_id", limit: 8, null: false
    t.datetime "created_at"
    t.datetime "modified_at"
    t.datetime "deleted_at"
    t.integer  "signature_id",  limit: 8
    t.integer  "migration_id",  limit: 8
    t.integer  "waiver_id",     limit: 8
  end

  add_index "v1_waiver_signing", ["created_by_id"], name: "created_by_id", using: :btree
  add_index "v1_waiver_signing", ["signature_id"], name: "signature_id", using: :btree
  add_index "v1_waiver_signing", ["waiver_id"], name: "waiver_id", using: :btree

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

  add_foreign_key "v1_access_grant", "v1_profile", column: "profile_id", name: "v1_access_grant_ibfk_2"
  add_foreign_key "v1_access_grant", "v1_waiver", column: "waiver_id", name: "v1_access_grant_ibfk_7"
  add_foreign_key "v1_access_grant", "wp_users", column: "created_by_id", primary_key: "ID", name: "v1_access_grant_ibfk_1"
  add_foreign_key "v1_access_grant", "wp_users", column: "granted_by_id", primary_key: "ID", name: "v1_access_grant_ibfk_4"
  add_foreign_key "v1_association", "wp_users", column: "created_by_id", primary_key: "ID", name: "v1_association_ibfk_1"
  add_foreign_key "v1_attachment", "wp_users", column: "created_by_id", primary_key: "ID", name: "v1_attachment_ibfk_1"
  add_foreign_key "v1_contact", "v1_attachment", column: "photo_id", name: "v1_contact_ibfk_2"
  add_foreign_key "v1_contact", "wp_users", column: "created_by_id", primary_key: "ID", name: "v1_contact_ibfk_1"
  add_foreign_key "v1_division", "v1_division", column: "parent_id", name: "v1_division_ibfk_3"
  add_foreign_key "v1_division", "v1_division_type", column: "division_type_id", name: "v1_division_ibfk_4"
  add_foreign_key "v1_division", "v1_organization", column: "organization_id", name: "v1_division_ibfk_2"
  add_foreign_key "v1_division", "wp_users", column: "created_by_id", primary_key: "ID", name: "v1_division_ibfk_1"
  add_foreign_key "v1_division_type", "v1_division_type", column: "parent_id", name: "v1_division_type_ibfk_3"
  add_foreign_key "v1_division_type", "v1_organization", column: "organization_id", name: "v1_division_type_ibfk_2"
  add_foreign_key "v1_division_type", "wp_users", column: "created_by_id", primary_key: "ID", name: "v1_division_type_ibfk_1"
  add_foreign_key "v1_event_participant", "v1_group", column: "group_id", name: "FK__v1_event_participant__v1_group"
  add_foreign_key "v1_event_participant", "v1_place", column: "place_id", name: "FK__v1_event_participant__v1_place"
  add_foreign_key "v1_event_participant", "v1_profile", column: "profile_id", name: "v1_event_participant_ibfk_3"
  add_foreign_key "v1_event_participant", "wp_users", column: "created_by_id", primary_key: "ID", name: "v1_event_participant_ibfk_1"
  add_foreign_key "v1_external_source", "v1_organization", column: "organization_id", name: "v1_external_source_ibfk_2"
  add_foreign_key "v1_external_source", "wp_users", column: "created_by_id", primary_key: "ID", name: "v1_external_source_ibfk_1"
  add_foreign_key "v1_group", "v1_association", column: "association_id", name: "v1_group_ibfk_5"
  add_foreign_key "v1_group", "v1_attachment", column: "logo_id", name: "v1_group_ibfk_6"
  add_foreign_key "v1_group", "v1_division", column: "division_id", name: "v1_group_ibfk_4"
  add_foreign_key "v1_group", "v1_organization", column: "organization_id", name: "v1_group_ibfk_3"
  add_foreign_key "v1_group", "v1_sport", column: "sport_id", name: "v1_group_ibfk_2"
  add_foreign_key "v1_group", "wp_users", column: "created_by_id", primary_key: "ID", name: "v1_group_ibfk_1"
  add_foreign_key "v1_group_membership", "v1_group", column: "group_id", name: "FK__v1_team_membership__v1_group"
  add_foreign_key "v1_group_membership", "v1_profile", column: "profile_id", name: "v1_group_membership_ibfk_3"
  add_foreign_key "v1_group_membership", "wp_users", column: "accepted_by_id", primary_key: "ID", name: "v1_group_membership_ibfk_4"
  add_foreign_key "v1_group_membership", "wp_users", column: "approved_by_id", primary_key: "ID", name: "v1_group_membership_ibfk_5"
  add_foreign_key "v1_group_membership", "wp_users", column: "created_by_id", primary_key: "ID", name: "v1_group_membership_ibfk_1"
  add_foreign_key "v1_insurance", "wp_users", column: "created_by_id", primary_key: "ID", name: "v1_insurance_ibfk_1"
  add_foreign_key "v1_invite", "v1_division", column: "division_id", name: "v1_invite_ibfk_2"
  add_foreign_key "v1_invite", "v1_group", column: "group_id", name: "FK__v1_invite__v1_group"
  add_foreign_key "v1_invite", "v1_organization", column: "organization_id", name: "v1_invite_ibfk_4"
  add_foreign_key "v1_invite", "v1_place", column: "place_id", name: "FK__v1_invite__v1_place"
  add_foreign_key "v1_invite", "v1_profile", column: "profile_id", name: "v1_invite_ibfk_5"
  add_foreign_key "v1_invite", "wp_users", column: "created_by_id", primary_key: "ID", name: "v1_invite_ibfk_1"
  add_foreign_key "v1_location", "wp_users", column: "created_by_id", primary_key: "ID", name: "v1_location_ibfk_1"
  add_foreign_key "v1_organization", "wp_users", column: "created_by_id", primary_key: "ID", name: "v1_organization_ibfk_1"
  add_foreign_key "v1_organization_number", "v1_organization", column: "organization_id", name: "v1_organization_number_ibfk_3"
  add_foreign_key "v1_organization_number", "v1_profile", column: "profile_id", name: "v1_organization_number_ibfk_2"
  add_foreign_key "v1_organization_number", "wp_users", column: "created_by_id", primary_key: "ID", name: "v1_organization_number_ibfk_1"
  add_foreign_key "v1_organizer", "v1_association", column: "association_id", name: "v1_organizer_ibfk_4"
  add_foreign_key "v1_organizer", "v1_division", column: "division_id", name: "v1_organizer_ibfk_5"
  add_foreign_key "v1_organizer", "v1_group", column: "group_id", name: "FK__v1_organizer__v1_group"
  add_foreign_key "v1_organizer", "v1_organization", column: "organization_id", name: "v1_organizer_ibfk_7"
  add_foreign_key "v1_organizer", "v1_organizer_type", column: "organizer_type_id", name: "v1_organizer_ibfk_3"
  add_foreign_key "v1_organizer", "v1_place", column: "place_id", name: "FK__v1_organizer__v1_place"
  add_foreign_key "v1_organizer", "v1_profile", column: "profile_id", name: "v1_organizer_ibfk_8"
  add_foreign_key "v1_organizer", "wp_users", column: "created_by_id", primary_key: "ID", name: "v1_organizer_ibfk_1"
  add_foreign_key "v1_organizer", "wp_users", column: "organizer_id", primary_key: "ID", name: "v1_organizer_ibfk_2"
  add_foreign_key "v1_organizer_type", "wp_users", column: "created_by_id", primary_key: "ID", name: "v1_organizer_type_ibfk_1"
  add_foreign_key "v1_place", "v1_attachment", column: "logo_id", name: "v1_place_ibfk_3"
  add_foreign_key "v1_place", "v1_sport", column: "sport_id", name: "v1_place_ibfk_2"
  add_foreign_key "v1_place", "wp_users", column: "created_by_id", primary_key: "ID", name: "v1_place_ibfk_1"
  add_foreign_key "v1_profile", "wp_users", column: "created_by_id", primary_key: "ID", name: "v1_profile_ibfk_1"
  add_foreign_key "v1_profile", "wp_users", column: "user_id", primary_key: "ID", name: "v1_profile_ibfk_2"
  add_foreign_key "v1_profile_data", "v1_attachment", column: "attachment_id", name: "v1_profile_data_ibfk_4"
  add_foreign_key "v1_profile_data", "v1_contact", column: "contact_id", name: "v1_profile_data_ibfk_7"
  add_foreign_key "v1_profile_data", "v1_insurance", column: "insurance_id", name: "v1_profile_data_ibfk_8"
  add_foreign_key "v1_profile_data", "v1_location", column: "location_id", name: "v1_profile_data_ibfk_6"
  add_foreign_key "v1_profile_data", "v1_organization_number", column: "organization_number_id", name: "v1_profile_data_ibfk_5"
  add_foreign_key "v1_profile_data", "v1_profile", column: "profile_id", name: "v1_profile_data_ibfk_2"
  add_foreign_key "v1_profile_data", "v1_profile_data_type", column: "profile_data_type_id", name: "v1_profile_data_ibfk_3"
  add_foreign_key "v1_profile_data", "wp_users", column: "created_by_id", primary_key: "ID", name: "v1_profile_data_ibfk_1"
  add_foreign_key "v1_profile_data_type", "v1_scope", column: "scope_id", name: "v1_profile_data_type_ibfk_2"
  add_foreign_key "v1_profile_data_type", "wp_users", column: "created_by_id", primary_key: "ID", name: "v1_profile_data_type_ibfk_1"
  add_foreign_key "v1_resource_external_source", "v1_association", column: "association_id", name: "v1_resource_external_source_ibfk_3"
  add_foreign_key "v1_resource_external_source", "v1_division", column: "division_id", name: "v1_resource_external_source_ibfk_4"
  add_foreign_key "v1_resource_external_source", "v1_external_source", column: "external_source_id", name: "v1_resource_external_source_ibfk_2"
  add_foreign_key "v1_resource_external_source", "v1_group", column: "group_id", name: "FK__v1_resource_external_source__v1_group"
  add_foreign_key "v1_resource_external_source", "v1_organization", column: "organization_id", name: "v1_resource_external_source_ibfk_6"
  add_foreign_key "v1_resource_external_source", "v1_place", column: "place_id", name: "FK__v1_resource_external_source__v1_place"
  add_foreign_key "v1_resource_external_source", "v1_profile", column: "profile_id", name: "v1_resource_external_source_ibfk_7"
  add_foreign_key "v1_resource_external_source", "wp_users", column: "created_by_id", primary_key: "ID", name: "v1_resource_external_source_ibfk_1"
  add_foreign_key "v1_resource_location", "v1_association", column: "association_id", name: "v1_resource_location_ibfk_3"
  add_foreign_key "v1_resource_location", "v1_division", column: "division_id", name: "v1_resource_location_ibfk_4"
  add_foreign_key "v1_resource_location", "v1_group", column: "group_id", name: "FK__v1_resource_location__v1_group"
  add_foreign_key "v1_resource_location", "v1_location", column: "location_id", name: "v1_resource_location_ibfk_2"
  add_foreign_key "v1_resource_location", "v1_organization", column: "organization_id", name: "v1_resource_location_ibfk_6"
  add_foreign_key "v1_resource_location", "v1_place", column: "place_id", name: "FK__v1_resource_location__v1_place"
  add_foreign_key "v1_resource_location", "v1_profile", column: "profile_id", name: "v1_resource_location_ibfk_7"
  add_foreign_key "v1_resource_location", "wp_users", column: "created_by_id", primary_key: "ID", name: "v1_resource_location_ibfk_1"
  add_foreign_key "v1_scope", "wp_users", column: "created_by_id", primary_key: "ID", name: "v1_scope_ibfk_1"
  add_foreign_key "v1_signature", "wp_users", column: "created_by_id", primary_key: "ID", name: "v1_signature_ibfk_1"
  add_foreign_key "v1_signature", "wp_users", column: "signed_by_id", primary_key: "ID", name: "v1_signature_ibfk_2"
  add_foreign_key "v1_sport", "wp_users", column: "created_by_id", primary_key: "ID", name: "v1_sport_ibfk_1"
  add_foreign_key "v1_waiver", "v1_division", column: "division_id", name: "v1_waiver_ibfk_2"
  add_foreign_key "v1_waiver", "v1_group", column: "group_id", name: "FK__v1_waiver__v1_group"
  add_foreign_key "v1_waiver", "v1_organization", column: "organization_id", name: "v1_waiver_ibfk_4"
  add_foreign_key "v1_waiver", "v1_place", column: "place_id", name: "FK__v1_waiver__v1_place"
  add_foreign_key "v1_waiver", "v1_profile", column: "profile_id", name: "v1_waiver_ibfk_5"
  add_foreign_key "v1_waiver", "v1_waiver", column: "waiver_id", name: "v1_waiver_ibfk_7"
  add_foreign_key "v1_waiver", "wp_users", column: "created_by_id", primary_key: "ID", name: "v1_waiver_ibfk_1"
  add_foreign_key "v1_waiver_field", "v1_profile_data_type", column: "profile_data_type_id", name: "v1_waiver_field_ibfk_3"
  add_foreign_key "v1_waiver_field", "v1_waiver", column: "waiver_id", name: "v1_waiver_field_ibfk_4"
  add_foreign_key "v1_waiver_field", "wp_users", column: "created_by_id", primary_key: "ID", name: "v1_waiver_field_ibfk_1"
  add_foreign_key "v1_waiver_signing", "v1_signature", column: "signature_id", name: "v1_waiver_signing_ibfk_5"
  add_foreign_key "v1_waiver_signing", "v1_waiver", column: "waiver_id", name: "v1_waiver_signing_ibfk_4"
  add_foreign_key "v1_waiver_signing", "wp_users", column: "created_by_id", primary_key: "ID", name: "v1_waiver_signing_ibfk_1"
end
