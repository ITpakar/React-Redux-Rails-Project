import React, { PropTypes } from 'react';

// Pages
// No Closing Book
//  Default Page which shows that there is no closing book + option to generate closing book
//  FormPages
//  ClosingBook being created
// Complete Closing Book

export default class ClosingBookView extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.state = {
      page: ''
    }
  }

  renderPage(page) {

  }

  render() {
    return (
      <div className="row">
          <div className="deal-closing-book">
              {this.renderPage(this.state.page)}
          </div>
      </div>
    )
  }
}