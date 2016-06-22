import React, { PropTypes } from 'react';
import ClosingBookDisplay from './ClosingBookDisplay';
import ClosingBookForm from './ClosingBookForm';

export default class ClosingBookView extends React.Component {
  constructor(props, context) {
    super(props, context);

    // display
    // create
    this.state = {
      page: 'display',
      closingBook: this.props.closingBook
    }

    _.bindAll(this, ['handleCreateClick', 'handleDownloadClick', 'generateClosingBook']);
  }

  handleCreateClick() {
    this.setState({page: 'create'});
  }

  generateClosingBook(state) {
    let _this = this;
    // Make AJAX request to create the Closing Book
    $.post(this.props.url, state)
     .done(function(resp) {
        _this.setState({closingBook: resp.closing_book});
     });
  }

  renderPage() {
    if (this.state.page == "display") {
      return (
        <ClosingBookDisplay closingBook={this.state.closingBook}
                            handleCreateClick={this.handleCreateClick}
                            handleDownloadClick={this.handleDownloadClick} />
      );
    } else if (this.state.page == "create") {
      return (
        <ClosingBookForm elements={this.props.elements}
                         generateClosingBook={this.generateClosingBook} />
      );
    }
  }

  render() {
    return (
      <div className="row">
        {this.renderPage()}
      </div>
    )
  }
}