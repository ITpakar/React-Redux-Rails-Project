import React, { Component, PropTypes } from 'react';

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
              <div className="comment-avatar"><img src="/assets/img-avatar-2.png"/></div>
              <div className="comment-message"><span>{comment.comment}</span></div>
              <div className="timestamp">March 23 at 1:21 PM</div>
          </div>)
        )}
      </div>
    );
  }
}