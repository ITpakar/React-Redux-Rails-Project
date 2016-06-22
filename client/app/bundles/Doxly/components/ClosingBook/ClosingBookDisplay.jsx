import React, { PropTypes } from 'react';

export default class ClosingBookDisplay extends React.Component {

  renderButtons() {
    if (this.props.closingBook) {
      return (
        <div className="buttons">
            <a href="#" className="btn btn-default" onClick={this.props.handleCreateClick}>Recreate Closing Book</a>
        </div>
      );
    }
  }

  renderInner() {
    console.log(this.props.closingBook);
    if (this.props.closingBook) {
      if (this.props.closingBook.status == "Processing") {
        return (
          <div className="deal-closing-book__inner">
              <div className="panel panel-default">
                <div className="panel-heading center">Closing Book</div>
                <div className="panel-body center">
                  Your closing book is being generated. Please refresh the page for updates.
                </div>
              </div>
          </div>
        );
      } else {
        return (
          <div className="deal-closing-book__inner">
              <div className="panel panel-default">
                <div className="panel-heading center">Closing Book</div>
                <div className="panel-body center">
                  <a href={this.props.closingBook.url} className="btn btn-default">Download Closing Book</a>
                </div>
              </div>
          </div>
        );
      }
      
    } else {
      return (
        <div className="deal-closing-book__inner">
            <div className="panel panel-default">
              <div className="panel-heading center">No Closing Book Created</div>
              <div className="panel-body center">
                <a href="#" className="btn btn-default" onClick={this.props.handleCreateClick}>Create Closing Book</a>
              </div>
            </div>
        </div>
      )
    }

    
  }
  
  render() {
    return (
      <div className="deal-closing-book">
        {this.renderButtons()}
        {this.renderInner()}
      </div>
    );
  }
}