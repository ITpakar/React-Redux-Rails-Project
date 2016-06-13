import React, { PropTypes } from 'react';

export default class Avatar extends React.Component {
  render() {
  	if (this.props.url) {
  	  return (
  	  	<div className="avatar"><img src={this.props.url} alt="" /></div>
  	  );
  	} else {
  	  return (
  	  	<div className="avatar">
  	  	  <div className="no-photo">{this.props.initials}</div>
  	  	</div>
  	  );
  	}
  }
}