class RecipientsForMigration < ActiveRecord::Migration
  def self.up
    create_table :subjects do |t|
      t.string :subject
      t.integer :contents_count
      t.integer :reader_infos_count
      t.string :messageable_type
      t.integer :messageable_id
      t.timestamps null: false
      t.string   :attachment_file_name
      t.string   :attachment_content_type
      t.integer  :attachment_file_size
      t.datetime :attachment_updated_at
    end
    add_index :subjects, [:messageable_type, :messageable_id]

    create_table :contents do |t|
      t.text :content
      t.belongs_to :subject, index: true
      t.integer :authorable_id
      t.string :authorable_type
      t.timestamps null: false
    end
    add_index :contents, [:authorable_type, :authorable_id]

    create_table :reader_infos do |t|
      t.boolean :read
      t.string :uuid
      t.integer :subject_id
      t.integer :recipient_id
      t.string :reciveable_type
      t.integer :reciveable_id
      t.boolean :internal
      t.string :notifications
      t.string :email
      t.timestamps null: false
    end
    add_index :reader_infos, [:subject_id]
    add_index :reader_infos, [:recipient_id]
    add_index :reader_infos, [:reciveable_type, :reciveable_id]

    create_table :recipients do |t|
      t.string :messageble_type
      t.integer :messageble_id
      t.string :reciveable_type
      t.integer :reciveable_id
      t.boolean :internal
      t.string :notifications
      t.timestamps null: false
    end
    add_index :recipients, [:messageble_type, :messageble_id]
    add_index :recipients, [:reciveable_type, :reciveable_id]
  end

  def down
    drop_table :subjects
    drop_table :contents
    drop_table :reader_infos
    drop_table :recipients
  end
end