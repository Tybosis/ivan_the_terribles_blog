class AddIndexToComments < ActiveRecord::Migration
  def self.up
    add_index :comments, :post_id, name: 'post_id_ix'
  end

  def self.down
    remove_index(:comments, name: 'post_id_ix')
  end
end
