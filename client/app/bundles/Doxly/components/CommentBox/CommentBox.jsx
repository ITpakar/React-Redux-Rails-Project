import React, { Component, PropTypes } from 'react';
import {bindActionCreators} from 'redux';
import {connect} from 'react-redux';
import _ from 'lodash';
import request from 'axios';
import CommentList from './CommentList/CommentList'
import CommentForm from './CommentForm/CommentForm'
import {setComments, addComment} from '../../reducers/commentReducer';

class CommentBox extends Component {
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
    _.bindAll(this, '_handleSubmit');
  }

  _handleSubmit(e) {
    console.log(e);
    e.preventDefault();
  }

  componentDidMount() {

    // Fetch all comments from the backend
    this._fetchComments();

    // Subscribe to Channel
    this._subscribeToChannel();
  }

  _receivedMessage = (data) => {
    this.props.addComment(data);
    this.forceUpdate();
  }

  _sendMessage = (comment) => {
    App.room.speak({comment: comment});
  }

  _sendInternalMessage = (e) => {
    e.preventDefault();
    const msg = this.refs.chatMessageInternal.value;
    const comment = {
      user_id: 1,
      task_id: 2,
      comment_type: 'Internal',
      comment: msg
    }
    this._sendMessage(comment);
  }

  _sendExternalMessage = (e) => {
    e.preventDefault();
    const msg = this.refs.chatMessageExternal.value;
    const comment = {
      user_id: 1,
      task_id: 2,
      comment_type: 'External',
      comment: msg
    }
    this._sendMessage(comment);
  }

  _fetchComments = () => {
    request
      .get('/api/comments')
      .then((res) => {
        this.props.setComments(res.data.data.comments);
        this.forceUpdate();
      });
  }

  _subscribeToChannel() {
    App.room = App.cable.subscriptions.create("RoomChannel", {
      connected: () => {},  
      disconnected: () => {},
      received: (data) => {
        this._receivedMessage(data);
      },
      speak: function(data) {
        this.perform('speak', data);
      }
    });
  }

  _internalTypeCommentsFilter(commentObject) {
    return commentObject.comment_type == 'Internal';
  }
  _externalTypeCommentsFilter(commentObject) {
    return commentObject.comment_type == 'External';
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
            <CommentList
              comments={comments.filter(this._internalTypeCommentsFilter)}
            />
            <CommentForm 
              commentType="Internal"
            />
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
            <CommentList
              comments={comments.filter(this._externalTypeCommentsFilter)}
            />
            
            <CommentForm 
              commentType="External"
            />
          </div>
        </div>
      </div>
    );
  }
}
export default connect(
  ({commentStore}) => ({ comments: commentStore.comments }),
  dispatch => bindActionCreators({setComments, addComment}, dispatch)
)(CommentBox);
