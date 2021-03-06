import React, { Component, PropTypes } from 'react';
import Time from 'react-time';

export default class CommentList extends Component {
  static propTypes = {
    comments: PropTypes.array
  }

  render() {
    const {comments, user_id} = this.props;
    return (
      <div ref="chatbox_messages" className="chat-box__messages">
        {comments.map(comment => (
          <div key={comment.comment_id} className={"comment-item " + (user_id == comment.user.id ? "comment-from" : "comment-to")}>
              <div className="comment-avatar"><img src={comment.user.avatar} /></div>
              <div className="comment-message"><span>{comment.comment}</span></div>
              <div className="timestamp"><Time value={comment.created_at} format="MMMM D [at] h:mm A" /></div>
          </div>)
        )}
      </div>
    );
  }

  componentDidUpdate(prevProps, prevState) {
    this.refs.chatbox_messages.scrollTop = this.refs.chatbox_messages.scrollHeight;
  }
}