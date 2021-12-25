class CreateProductTagRels < ActiveRecord::Migration[6.1]
  def change
    create_table :product_tag_rels do |t|
      t.references :product, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
