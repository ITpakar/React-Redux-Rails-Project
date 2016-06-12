import React, { Component, PropTypes } from 'react';
import Time from 'react-time';

export default class CommentList extends Component {
  static propTypes = {
    comments: PropTypes.array
  }

  render() {
    const {comments} = this.props;
    return (
      <div className="chat-box__messages">
        {comments.map(comment => (
          <div key={comment.comment_id} className="comment-item comment-to">
              <div className="comment-avatar"><img src={comment.user.avatar_name} /></div>
              <div className="comment-message"><span>{comment.comment}</span></div>
              <div className="timestamp"><Time value={comment.created_at} format="MMMM D [at] h:mm A" /></div>
          </div>)
        )}
      </div>
    );
  }
}