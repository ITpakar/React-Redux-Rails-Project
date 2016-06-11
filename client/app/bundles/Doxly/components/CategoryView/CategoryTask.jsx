import React, { PropTypes } from 'react';
import CategorySection from "./CategorySection";
import CategoryFolder from "./CategoryFolder";
import CategoryDocument from "./CategoryDocument";
import classnames from 'classnames';

// Props
// element = {
// 	type: "Task",
// 	title: "Task Title",
// 	status: "Complete",
// 	elements: [
// 		{
// 			type: "Document",
// 			title: "Document Title",
// 		},
// 		{
// 			type: "Folder",
// 			title: "Folder Title",
// 			file_count: 42,
// 			elements: [...] // This would be a bunch of documents
// 		}
// 	]
// }


export default class CategoryTask extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.state = {
      bodyClassnames: ["deal-task-item__panel", "collapse"]
    };

    _.bindAll(this, ['toggleContent', "selectTask", "openNewFolderModal", "openNewDocumentModal", "toggleStatus"]);
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

  selectTask(event) {
    if (event) {
      event.preventDefault();
    }

    this.props.selectElement(this.props.element);
  }

  openNewFolderModal(event) {
    if (event) {
      event.preventDefault();
    }

    this.props.openNewFolderModal(this.props.element);
  }

  openNewDocumentModal(event) {
    if (event) {
      event.preventDefault();
    }

    this.props.openNewDocumentModal(this.props.element);
  }

  toggleStatus() {
    var status = (this.props.element.status || "incomplete").toLowerCase();
    if (status == "complete") {
      status = "incomplete";
    } else {
      status = "complete";
    }

    this.props.updateTask(this.props.element.id, {status: status});
  }

  render() {
    var element = this.props.element;
    var children = element.elements;
    var displayedChildren = [];

    for (let i = 0; i < children.length; i++) {
      let child = children[i];
      let displayedChild;

      if (child.type == "Section") {
        displayedChild = (
          <CategorySection element={child}
                           selectElement={this.props.selectElement}
                           selectedElement={this.props.selectedElement}
                           updateTask={this.props.updateTask}
                           openNewDocumentModal={this.props.openNewDocumentModal}
                           openNewFolderModal={this.props.openNewFolderModal}
                           openNewTaskModal={this.props.openNewTaskModal}
                           key={"section_" + (i + 1)} />
        );
      } else if (child.type == "Task") {
        displayedChild = (
          <CategoryTask element={child}
                        selectElement={this.props.selectElement}
                        selectedElement={this.props.selectedElement}
                        updateTask={this.props.updateTask}
                        openNewDocumentModal={this.props.openNewDocumentModal}
                        openNewFolderModal={this.props.openNewFolderModal}
                        openNewTaskModal={this.props.openNewTaskModal}
                        openNewDocumentModal={this.props.openNewDocumentModal}
                        key={"task_" + (i + 1)} />
        );
      } else if (child.type == "Folder") {
        displayedChild = (
          <CategoryFolder element={child}
                          selectElement={this.props.selectElement}
                          selectedElement={this.props.selectedElement}
                          openNewDocumentModal={this.props.openNewDocumentModal}
                          key={"folder_" + (i + 1)} />
        );
      } else if (child.type == "Document") {
        displayedChild = (
          <CategoryDocument element={child}
                            selectElement={this.props.selectElement}
                            selectedElement={this.props.selectedElement}
                            key={"document_" + (i + 1)} />
        );
      }

      displayedChildren.push(displayedChild);
    }

    var bodyClassnames = this.state.bodyClassnames;
    var toggleClassnames = ["collapse-trigger"];

    if (bodyClassnames.indexOf("in") == -1) {
      toggleClassnames.push("collapsed");
    }

    var isSelected = this.props.selectedElement &&
                     this.props.selectedElement.id == this.props.element.id &&
                     this.props.selectedElement.type == this.props.element.type;

  	return (
      <div className={classnames(["deal-task-item", element.status || "unknown", (isSelected ? "deal-item-active" : "")])}>
          <div className="deal-task-item__header">
              <span className="checkbox-placeholder" onClick={this.toggleStatus}></span>
              <a className="deal-task-item__header-item" href="#" onClick={this.selectTask}>{element.title}</a>
              <div className={classnames({"badge-chat": true, "hidden": element.comments_count == 0})}><span>{element.comments_count}</span></div>
              <a className={toggleClassnames.join(" ")} href="#" onClick={this.toggleContent}><span>Show Files</span><i>Hide Files</i></a>
          </div>
          <div className={bodyClassnames.join(" ")}>
              <div className="deal-task-elements">
                  {displayedChildren}
                  <div className="deal-element-add-item">
                      <span><i className="icon-icon-plus"></i> Add a <a href="#" onClick={this.openNewDocumentModal}>File</a> or <a href="#" onClick={this.openNewFolderModal}>Folder</a></span>
                  </div>
              </div>
          </div>
      </div>
  	);
  }
}
