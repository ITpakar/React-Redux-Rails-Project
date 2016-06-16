import React, { PropTypes } from 'react';

export default class FileViewer extends React.Component {
  constructor(props, context) {
    super(props, context);
  }

  render() {
    return (
      <div className="row">
        <div ref="file_container" className="content-document file-container">
          <iframe src={this.props.url}></iframe>
        </div>
      </div>
    );
  }
}
