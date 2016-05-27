import React, { PropTypes } from "react";
import _ from 'lodash';
import classnames from 'classnames'
import ReactOnRails from 'react-on-rails';

import actions from '../actions/doxlyActions'

export default class DealStar extends React.Component {
  constructor(props, context) {
    super(props, context);
    
    this.state = {
      starred: this.props.initiallyStarred
    }

    this.store = ReactOnRails.getStore('doxlyStore');

    _.bindAll(this, 'handleClick');
  }

  onChange() {
    console.log(this.store.getState());
  }

  handleClick(event) {
    let that = this;

    if (this.state.starred) {

    } else {
      this.store.dispatch(actions.starDeal(this.props.deal_id, this.props.user_id, this.props.url))
    }

    // let data = {
    //   starred_deal: {
    //     user_id: this.props.user_id,
    //     deal_id: this.props.deal_id
    //   }
    // }

    // let method = this.state.starred ? "DELETE" : "POST"
    
    // $.ajax({
    //   url: this.props.url,
    //   method: method,
    //   data: data
    // }).done(function() {
    //   that.setState({starred: !that.state.starred})
    // }).fail(function(resp) {
    //   console.log(`Something went wrong when trying to ${that.props.starred ? 'unstar' : 'star'} the deal`);
    //   console.log(resp);
    // })

  }

  render() {
    return (
      <a href="#" onClick={this.handleClick} className={classnames('deal-star', {favorite: this.state.starred})}>
        <i></i>
      </a>
    );

  }

}