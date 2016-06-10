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

    _.bindAll(this, ['toggleContent', "selectTask", "openNewFolderModal", "openNewFileModal"]);
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

  openNewFileModal(event) {
    if (event) {
      event.preventDefault();
    }

    this.props.openNewFileModal(this.props.element);
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
                           openNewFileModal={this.props.openNewFileModal}
                           openNewFolderModal={this.props.openNewFolderModal}
                           openNewTaskModal={this.props.openNewTaskModal}
                           key={"section_" + (i + 1)} />
        );
      } else if (child.type == "Task") {
        displayedChild = (
          <CategoryTask element={child}
                        selectElement={this.props.selectElement}
                        openNewFileModal={this.props.openNewFileModal}
                        openNewFolderModal={this.props.openNewFolderModal}
                        openNewTaskModal={this.props.openNewTaskModal}
                        key={"task_" + (i + 1)} />
        );
      } else if (child.type == "Folder") {
        displayedChild = (
          <CategoryFolder element={child}
                          selectElement={this.props.selectElement}
                          openNewFileModal={this.props.openNewFileModal}
                          key={"folder_" + (i + 1)} />
        );
      } else if (child.type == "Document") {
        displayedChild = (
          <CategoryDocument element={child} selectElement={this.props.selectElement} key={"document_" + (i + 1)} />
        );
      }

      displayedChildren.push(displayedChild);
    }

    var bodyClassnames = this.state.bodyClassnames;
    var toggleClassnames = ["collapse-trigger"];

    if (bodyClassnames.indexOf("in") == -1) {
      toggleClassnames.push("collapsed");
    }

  	return (
      <div className="deal-task-item ">
          <div className="deal-task-item__header">
              <a className="deal-task-item__header-item" href="#" onClick={this.selectTask}>{element.title}</a>
              <div className={classnames({"badge-chat": true, "hidden": element.comments_count == 0})}><span>{element.comments_count}</span></div>
              <a className={toggleClassnames.join(" ")} href="#" onClick={this.toggleContent}><span>Show Files</span><i>Hide Files</i></a>
          </div>
          <div className={bodyClassnames.join(" ")}>
              <div className="deal-task-elements">
                  {displayedChildren}
                  <div className="deal-element-add-item">
                      <span><i className="icon-icon-plus"></i> Add a <a href="#" onClick={this.openNewFileModal}>File</a> or <a href="#" onClick={this.openNewFolderModal}>Folder</a></span>
                  </div>
              </div>
          </div>
      </div>
  	);
  }
}
