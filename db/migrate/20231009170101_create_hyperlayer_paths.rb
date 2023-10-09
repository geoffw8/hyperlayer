class CreateHyperlayerPaths < ActiveRecord::Migration[7.0]
  def change
    create_table :hyperlayer_paths do |t|
      t.string :path
      t.boolean :spec

      t.timestamps
    end
  end
end
