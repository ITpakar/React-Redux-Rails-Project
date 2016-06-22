import React, { PropTypes } from 'react';
import classnames from 'classnames';
import ClosingBookDocument from "./ClosingBookDocument";

// Props
// elements = {
//  type: "Folder",
//  title: "Folder Title",
//  file_count: 42,
//  elements: [...] // This would be a bunch of documents
// }

export default class ClosingBookFolder extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.state = {
      bodyClassnames: ["deal-element-folder-wrapper", "collapse"]
    }

    _.bindAll(this, ['toggleContent']);
  }

  toggleContent(event) {
    if (event) {
      event.preventDefault();
    }

    var bodyClassnames = this.state.bodyClassnames;
    if (bodyClassnames.indexOf("in") >= 0) {
      bodyClassnames = _.without(bodyClassnames, "in");
    } else {
      bodyClassnames.push("in");
    }

    this.setState({bodyClassnames: bodyClassnames});
  }

  render() {
    var element = this.props.element;
    var children = element.elements;
    var displayedChildren = [];
    var filesCount = 0;

    for (let i = 0; i < children.length; i++) {
      let child = children[i];
      let displayedChild;

      if (child.type == "Document") {
        displayedChild = (
          <ClosingBookDocument element={child}
                               selected={this.props.selected}
                             selectItem={this.props.selectItem}
                            key={"document_" + (i + 1)} />
        );
        filesCount++;
      }

      displayedChildren.push(displayedChild);
    }

    var bodyClassnames = this.state.bodyClassnames;
    var toggleClassnames = ["collapse-trigger"];

    if (bodyClassnames.indexOf("in") == -1) {
      toggleClassnames.push("collapsed");
    }

    return (
      <div className={classnames({"deal-element-item": true, "deal-element-item__folder": true, 'complete': this.props.selected[this.props.element.type + '_' + this.props.element.id]})}>
        <div className="item-header">
          <a className="item-header-item" href="#" onClick={this.props.selectItem(this.props.element.type, this.props.element.id)}>{element.title}</a>
          <a className={toggleClassnames.join(" ")} href="#" onClick={this.toggleContent}>
            <span className={classnames({"hidden": filesCount == 0})}>Show {filesCount} {filesCount == 1 ? "File" : "Files"}</span>
            <span className={classnames("no-files", {"hidden": filesCount != 0})}>0 Files</span>
            <i>Hide Files</i>
          </a>
        </div>
        <div className={bodyClassnames.join(" ")}>
          <div className="deal-element-folder-elements">
            {displayedChildren}
          </div>
        </div>
      </div>
    );
  }
}
