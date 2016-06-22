import React, { PropTypes } from 'react';
import RadioGroup from 'react-radio-group';

import ClosingBookFileViewer from './ClosingBookFileViewer';

export default class ClosingBookForm extends React.Component {
  
  constructor(props, context) {
    super(props, context);

    this.state = {
      page: 0,
      selectedDocuments: [],
      format: 'HTML INDEX'
    }

    _.bindAll(this, ['handleNextClick', 'getSelectedDocuments', 'handleFinish']);
  }

  getSelectedDocuments(documents) {
    this.setState({selectedDocuments: documents});
  }

  handleNextClick(e) {
    this.setState({page: this.state.page + 1})
  }

  handleFinish(e) { 
    this.props.generateClosingBook(this.state);
  }

  handleFormatChange(val) {
    this.setState({format: val});
  }

  renderPage() {
    switch (this.state.page) {
      case 0:
        return (
            <div>
              <div className="panel panel-default">
                <div className="panel-heading center">Select Documents</div>
                <div className="panel-body center">
                  Select the documents you would like in your closing book.
                </div>
              </div>
              <ClosingBookFileViewer elements={this.props.elements} pushSelectedDocuments={this.getSelectedDocuments} />
            </div>
          );
      case 1:
        return (
          <div>
            <div className="panel panel-default">
              <div className="panel-heading center">Format</div>
              <div className="panel-body center">
                Now, choose the format you would like to use.
              </div>
            </div>
            <RadioGroup name="format" selectedValue={this.state.format} onChange={this.handleFormatChange}>
              {Radio => (
                <div>
                  <div className="radio">
                    <label>
                      <Radio value="HTML INDEX"/>Collection of documents with HTML index
                    </label>
                  </div>
                  <div className="radio">
                    <label>
                      <Radio value="PDF INDEX"/>Collection of documents with PDF index
                    </label>
                  </div>
                  <div className="radio">
                    <label>
                      <Radio value="SINGLE PDF"/>Single continuous PDF document
                    </label>
                  </div>
                </div>
              )}
            </RadioGroup>
          </div>);
    }
  }

  renderButton() {
    if (this.state.page == 0) {
      return (
        <a href="#" className="btn btn-default closing-book-form-next" onClick={this.handleNextClick}>Next</a>
      );  
    } else {
      return (
        <a href="#" className="btn btn-default closing-book-form-next" onClick={this.handleFinish}>Finish</a>
      );
    }
    
  }

  render() {

    return (
      <div className="deal-closing-book__inner">
        {this.renderPage()}
        {this.renderButton()}
      </div>
    );
  }
}