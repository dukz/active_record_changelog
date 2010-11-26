ActiveRecord::Schema.define(:version => 0) do
  create_table "movies", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "changelogs", :force => true do |t|
    t.string   "item_type"
    t.integer  "item_id"
    t.text     "fields_changed"
    t.text     "summary"
    t.string   "changer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
end
