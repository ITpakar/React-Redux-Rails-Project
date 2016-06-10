import React, { PropTypes } from 'react';
import classnames from 'classnames';
import CategorySection from "./CategorySection";
import CategoryTask from "./CategoryTask";
import CategoryDocument from "./CategoryDocument";

// Props
// elements = {
// 	type: "Folder",
// 	title: "Folder Title",
// 	file_count: 42,
// 	elements: [...] // This would be a bunch of documents
// }

export default class CategoryFolder extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.state = {
      bodyClassnames: ["deal-element-folder-wrapper", "collapse"]
    }

    _.bindAll(this, ['toggleContent', "selectFolder"]);
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

  selectFolder(event) {
    if (event) {
      event.preventDefault();
    }

    this.props.selectElement(this.props.element);
  }

  render() {
    var element = this.props.element;
    var children = element.elements;
    var displayedChildren = [];
    var filesCount = 0;

    for (let i = 0; i < children.length; i++) {
      let child = children[i];
      let displayedChild;

      if (child.type == "Section") {
        displayedChild = (
          <CategorySection element={child} selectElement={this.props.selectElement} openNewFileModal={this.props.openNewFileModal} openNewFolderModal={this.props.openNewFolderModal} key={"section_" + (i + 1)} />
        );
      } else if (child.type == "Task") {
        displayedChild = (
          <CategoryTask element={child} selectElement={this.props.selectElement} openNewFileModal={this.props.openNewFileModal} openNewFolderModal={this.props.openNewFolderModal} key={"task_" + (i + 1)} />
        );
      } else if (child.type == "Folder") {
        displayedChild = (
          <CategoryFolder element={child} selectElement={this.props.selectElement} openNewFileModal={this.props.openNewFileModal} key={"folder_" + (i + 1)} />
        );
      } else if (child.type == "Document") {
        displayedChild = (
          <CategoryDocument element={child} selectElement={this.props.selectElement} key={"document_" + (i + 1)} />
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
      <div className="deal-element-item deal-element-item__folder">
        <div className="item-header">
          <a className="item-header-item" href="#" onClick={this.selectFolder}>{element.title}</a>
          <div className={classnames({"badge-chat": true, "hidden": element.comments_count == 0})}><span>{element.comments_count}</span></div>
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
