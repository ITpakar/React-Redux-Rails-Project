import React, { Component, PropTypes } from 'react';

export default class CommentForm extends Component {
  static propTypes = {
    commentType: PropTypes.string
  }

  _sendMessage = (e) => {
    e.preventDefault();

    // 
    const msg = this.refs.commentText.value;
    const comment = {
      organization_user_id: 1,
      commentable_id: 2,
      commentable_type: 'Task',
      comment_type: this.props.commentType,
      comment: msg
    }

    // Send comment to channel
    App.room.speak({comment: comment});
  }

  render() {
    return (
      <div className="chat-box__send">
        <form>
          <input className="chat-box__message form-control"ref="commentText"/>
          <a className="btn btn-primary" onClick={this._sendMessage}>Send</a>
        </form>
      </div>
    );
  }
}