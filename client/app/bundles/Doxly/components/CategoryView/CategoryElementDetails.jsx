import React, { PropTypes } from 'react';
import classnames from "classnames";

export default class CategoryElementDetails extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.state = {
      showDescription: true
    };

    _.bindAll(this, ["toggleDescription", "editElement", "deleteElement"]);
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

  render() {
    var element = this.props.element;
    var description;

    if (element.description) {
      description = (
        <p>{element.description}</p>
      )
    } else if (element.type == "Document") {
      description = (
        <dl className="dl-horizontal">
          <dt>File name</dt>
          <dd>{element.file_name}</dd>
          <dt>File size</dt>
          <dd>{element.file_size}</dd>
          <dt>File type</dt>
          <dd>{element.file_type}</dd>
          <a link={element.url}>Download</a>
        </dl>
      )
    }



  	return (
      <div className="deal-task-details">
        <div className="deal-task-details__header">
          <h4>{element.title}</h4>
            <div className="dropdown">
              <a aria-expanded="false" className="dropdown-toggle" data-toggle="dropdown" href="#">...</a>
              <ul className="dropdown-menu">
                <li>
                  <a href="#" onClick={this.editElement}>Edit {element.type}</a>
                </li>
                <li>
                  <a href="#" onClick={this.deleteElement}>Delete {element.type}</a>
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
