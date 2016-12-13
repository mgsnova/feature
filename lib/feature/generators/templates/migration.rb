class FeatureCreate<%= table_name.camelize %> < ActiveRecord::Migration
  def change
    create_table(:<%= table_name %>) do |t|
      t.string :name, uniq: true, index: true, null: false
      t.boolean :active, null: false, default: false
    end
  end
end
