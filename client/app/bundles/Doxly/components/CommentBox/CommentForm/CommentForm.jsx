import React, { Component, PropTypes } from 'react';

export default class CommentForm extends Component {
  static propTypes = {
    commentType: PropTypes.string
  }

  _handleKeyDown = (e) => {
    if (e.keyCode == 13) {
      this._sendMessage(e);
    }
  }

  _sendMessage = (e) => {
    e.preventDefault();

    // 
    const msg = this.refs.commentText.value;
    var element = this.props.element;
    const comment = {
      user_id: this.props.user_id,
      commentable_id: element.id,
      commentable_type: element.type,
      comment_type: this.props.commentType,
      comment: msg
    }

    // Send comment to channel
    App.room.speak({comment: comment});
    this.refs.commentText.value = '';
  }

  render() {
    return (
      <div className="chat-box__send">
        <form>
          <input className="chat-box__message form-control" ref="commentText" onKeyDown={this._handleKeyDown} />
          <a className="btn btn-primary" onClick={this._sendMessage}>Send</a>
        </form>
      </div>
    );
  }
}