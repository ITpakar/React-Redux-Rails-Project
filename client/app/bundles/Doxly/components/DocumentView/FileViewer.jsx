import React, { PropTypes } from 'react';
import Crocodoc from "viewer";

export default class FileViewer extends React.Component {
  constructor(props, context) {
    super(props, context);
  }

  createViewer() {
    // this.viewer
    this.viewer = this.crocodocInstance.createViewer($(this.refs.file_container), {
      url: "https://view-api.box.com/1/sessions/3c6abc0dcf35422e8353cf9c27578d5c/assets/"
    });
    this.viewer.load();
  }

  componentDidMount() {
    this.crocodocInstance = new Crocodoc($);
    this.createViewer();
  }

  componentWillReceiveProps(newProps) {
    this.viewer.destroy();
    this.createViewer();
  }

  render() {
    return (
      <div className="row">
        <div ref="file_container" className="content-document file-container">
        </div>
      </div>
    );
  }
}
