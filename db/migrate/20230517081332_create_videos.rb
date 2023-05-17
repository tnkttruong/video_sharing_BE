class CreateVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :videos do |t|
      t.references :users, null: false
      t.string :video_id
      t.string :title
      t.text :detail
      t.timestamps
    end
  end
end
