class AddCommentLengthToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :comment_length, :integer
  end
end
