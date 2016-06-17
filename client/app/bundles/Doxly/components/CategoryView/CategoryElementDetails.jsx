import React, { PropTypes } from 'react';
import classnames from "classnames";

export default class CategoryElementDetails extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.state = {
      showDescription: true
    };

    _.bindAll(this, ["toggleDescription", "editElement", "deleteElement", "createVersion", 'sendToDocusign']);
  }

  toggleDescription(event) {
    if (event) {
      event.preventDefault();
    }

    this.setState({showDescription: !this.state.showDescription});
  }

  editElement(event) {
    event.preventDefault();
    this.props.editElement(this.props.element);
  }

  deleteElement(event) {
    event.preventDefault();
    this.props.deleteElement(this.props.element);
  }

  createVersion(event) {
    if (event) {
      event.preventDefault();
    }

    this.props.openVersionModal();
  }

  sendToDocusign(event) {
    event.preventDefault();
    console.log('yo');
    $.post(`/api/documents/${this.props.element.id}/send_to_docusign`, function(resp) {
      console.log(resp);
    })
  }

  render() {
    var element = this.props.element;
    var description;
    var uploadNewVersion;

    if (element.description) {
      description = (
        <p>{element.description}</p>
      )
    } else if (element.type == "Document") {
      description = (
        <div>
          <div className="ico-document">
              <div className={classnames({'badge-signed': true, "signed": element.signers_count == element.signed_count, "hidden": element.signers_count == 0})}>
                {element.signed_count}/{element.signers_count} signed
              </div>
          </div>

          <div className="buttons">
            <a href={"/app/documents/" + element.id} className="btn btn-link">View</a>
            <a href={element.download_url} className="btn btn-link">Download</a>
          </div>
        </div>
      )
      uploadNewVersion = (
        <li>
          <a href="#" onClick={this.createVersion}>Upload New Version</a>
        </li>
      );
    }

  	return (
      <div className="deal-task-details">
        <div className="deal-task-details__header">
          <h4>{element.title}</h4>
            <div className="dropdown">
              <a aria-expanded="false" className="dropdown-toggle" data-toggle="dropdown" href="#">...</a>
              <ul className="dropdown-menu">
                {uploadNewVersion}
                <li>
                  <a href="#" onClick={this.editElement}>Edit {element.type}</a>
                </li>
                <li>
                  <a href="#" onClick={this.deleteElement}>Delete {element.type}</a>
                </li>
                <li>
                  <a href="#" className={classnames({'hidden': element.type != "Document" || element.signers_count == 0})} onClick={this.sendToDocusign}>Send To Docusign</a>
                </li>
              </ul>
          </div>
        </div>
        <div className={classnames({"deal-task-details__body": true, "collapse": true, "in": this.state.showDescription})} id="deal-task-details__body" style={{height: (this.state.showDescription ? "" : 10)}}>
          {description}
        </div>
        <a className={classnames({"collapse-trigger": true, "collapsed": !this.state.showDescription, "hide": !description})} href="#deal-task-details__body" onClick={this.toggleDescription}>
          <span>Show Description</span>
          <i>Hide Description</i>
        </a>
      </div>
  	);
  }
}
