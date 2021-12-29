class CreateProductsTagsRels < ActiveRecord::Migration[6.1]
  def change
    create_table :products_tags_rels do |t|
      t.references :product, null: false
      t.references :tag, null: false

      t.timestamps
    end
    drop_table :product_tag_rels
  end
end
