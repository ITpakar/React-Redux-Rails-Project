import React, { Component, PropTypes } from 'react';
import {bindActionCreators} from 'redux';
import {connect} from 'react-redux';
import _ from 'lodash';
import axios from 'axios';
import {setComments, addComment} from '../reducers/commentReducer';

class ChatBox extends Component {
  static propTypes = {
    comments: PropTypes.array,
    setComments: PropTypes.func,
    addComment: PropTypes.func
  }

  constructor(props, context) {
    super(props, context);

    // Uses lodash to bind all methods to the context of the object instance, otherwise
    // the methods defined here would not refer to the component's class, not the component
    // instance itself.
    _.bindAll(this, 'handleSubmit');
  }

  handleSubmit(e) {
    console.log(e);
    e.preventDefault();
  }

  componentDidMount() {
    axios.get('/api/comments')
    .then((res) => {
      this.props.setComments(res.data.data.comments);
      this.forceUpdate();
    });
    var pusher = new Pusher('4107f6c14aa53b02f9ab', {
      encrypted: true
    });
    var channel = pusher.subscribe('test_channel');
    channel.bind('my_event', (data) => {
      this.receivedMessage(data);
    });
  }

  receivedMessage = (data) => {
    this.props.addComment(data);
    this.forceUpdate();
  }

  sendMessage = (comment) => {
    axios.post('/api/comments', { comment: comment })
    .then(this.resetAndFocus);
  }

  sendInternalMessage = (e) => {
    e.preventDefault();
    const msg = this.refs.chatMessageInternal.value;
    const comment = {
      user_id: 1,
      task_id: 2,
      comment_type: 'Internal',
      comment: msg
    }
    this.sendMessage(comment);
  }

  sendExternalMessage = (e) => {
    e.preventDefault();
    const msg = this.refs.chatMessageExternal.value;
    const comment = {
      user_id: 1,
      task_id: 2,
      comment_type: 'External',
      comment: msg
    }
    this.sendMessage(comment);
  }

  resetAndFocus = () => {
    
  }

  render() {
    const {comments} = this.props;
    return (
      <div className="chat-box chat-box-small">
        <div className="chat-box-toggle">
            <div className="btn-group">
                <a className="btn toggle-active" href="#deal-chat-1-internal">Internal Chat</a>
                <a className="btn" href="#deal-chat-1-external">External Chat</a>
            </div>
        </div>
        <div className="chat-box-details">
          <div className="chat-box-details__instance internal toggle-active" id="deal-chat-1-internal">
            <div className="chat-box__recipients">
                <div className="chat-box__recipients-wrapper">
                    <div className="recipients-items">
                        <a href="#" className="avatar"><img src="/assets/img-avatar-2.png"/></a>
                        <a href="#" className="avatar"><img src="/assets/img-avatar-3.png"/></a>
                    </div>
                    <a href="#" className="recipient-add"><i className="icon-icon-plus-circle"></i></a>
                </div>
            </div>
            <div className="chat-box__messages">
              {comments.map(comment => (
                comment.comment_type == 'Internal' ? (
                <div key={comment.comment_id} className="comment-item comment-to">
                    <div className="comment-avatar"><img src="/assets/img-avatar-2.png"/></div>
                    <div className="comment-message"><span>{comment.comment}</span></div>
                    <div className="timestamp">March 23 at 1:21 PM</div>
                </div>)
                : ''
              ))}
            </div>
            <div className="chat-box__send">
                <form>
                    <input className="chat-box__message form-control" name="send_message_internal" ref="chatMessageInternal"/>
                    <a className="btn btn-primary" onClick={this.sendInternalMessage}>Send</a>
                </form>
            </div>
          </div>

          <div className="chat-box-details__instance external" id="deal-chat-1-external">
            <div className="chat-box__recipients">
                <div className="chat-box__recipients-wrapper">
                    <div className="recipients-items">
                        <a href="#" className="avatar"><img src="/assets/img-avatar-2.png"/></a>
                        <a href="#" className="avatar"><img src="/assets/img-avatar-3.png"/></a>
                    </div>
                    <a href="#" className="recipient-add"><i className="icon-icon-plus-circle"></i></a>
                </div>
            </div>
            <div className="chat-box__messages">
                {comments.map(comment => (
                  comment.comment_type == 'External' ? (
                  <div key={comment.comment_id} className="comment-item comment-to">
                      <div className="comment-avatar"><img src="/assets/img-avatar-2.png"/></div>
                      <div className="comment-message"><span>{comment.comment}</span></div>
                      <div className="timestamp">March 23 at 1:21 PM</div>
                  </div>)
                  : ''
                ))}
            </div>
            <div className="chat-box__send">
                <form>
                    <input className="chat-box__message form-control" name="send_message_internal" ref="chatMessageExternal"/>
                    <a className="btn btn-primary" onClick={this.sendExternalMessage}>Send</a>
                </form>
            </div>
          </div>
        </div>
      </div>
    );
  }
}
export default connect(
  ({commentStore}) => ({ comments: commentStore.comments }),
  dispatch => bindActionCreators({setComments, addComment}, dispatch)
)(ChatBox);
