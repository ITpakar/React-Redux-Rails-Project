import React, { propTypes } from 'react';

export default class ArchiveDealButton extends React.Component {

  constructor(props, context) {
    super(props, context);

    this.state = {
      archived: this.props.initiallyArchived
    }

    _.bindAll(this, 'handleClick');
  }

  handleClick() {

    let that = this;

    let data = {
      deal: {
        status: "Archived"
      }
    }

    $.ajax({
      url: this.props.url,
      method: "PUT",
      data: data
    }).done(function(response) {
      that.setState({archived: true});
    }).fail(function(response) {
      console.log("Something went wrong when trying to archive the deal");
      console.log(response);
    });
  }

  render() {
    if (this.state.archived) {
      return (
        <li className="deal-edit" style={{position: 'relative', top: '5px'}}><span>Archived</span></li>
      );
    } else {
      return (
        <li className="deal-edit" onClick={this.handleClick}>

          <a href="#">
            <i className="icon-icon-box"></i> Archive Deal
          </a>
        </li>
      );
    }
  }
}
