class AddIndexToReplies < ActiveRecord::Migration
  def self.up
    add_index :replies, :comment_id, name: 'comment_id_ix'
  end

  def self.down
    remove_index(:replies, name: 'comment_id_ix')
  end
end
