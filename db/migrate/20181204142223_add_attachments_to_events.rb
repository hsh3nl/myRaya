class AddAttachmentsToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :attachments, :json
  end
end
