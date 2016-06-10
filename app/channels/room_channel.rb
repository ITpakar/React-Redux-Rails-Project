# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel"
  end
 
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
 
  def speak(data)
    comment = Comment.new
    comment_params = data['comment']
    comment.organization_user_id = current_user.organization_user_id
    comment.commentable_type = comment_params['commentable_type']
    comment.commentable_id = comment_params['commentable_id']
    comment.comment_type = comment_params['comment_type']
    comment.comment = comment_params['comment']

    if comment.save!
      puts comment.to_hash
      ActionCable.server.broadcast "room_channel", comment.to_hash
  	end
  end

end
