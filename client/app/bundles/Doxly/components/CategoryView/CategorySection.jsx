import React, { PropTypes } from 'react';
import CategoryTask from "./CategoryTask";
import CategoryFolder from "./CategoryFolder";
import CategoryDocument from "./CategoryDocument";
import _ from 'lodash';
import classnames from 'classnames';

// Props
// element = {
// 		type: "Section",
// 		title: "Section Title",
// 		elements: [
// 			{
// 				type: "Task",
// 				title: "Task Title",
// 				status: "Complete",
// 				elements: [
// 					{
// 						type: "Document",
// 						title: "Document Title",
// 					},
// 					{
// 						type: "Folder",
// 						title: "Folder Title",
// 						file_count: 42,
// 						elements: [...] // This would be a bunch of documents
// 					}
// 				]
// 			}
// 		]
// 	}


export default class CategorySection extends React.Component {
  constructor(props, context) {
    super(props, context);

    var sectionBodyClassnames = ["deal-section__panel", "collapse"];
    if (this.props.isExpanding) {
      sectionBodyClassnames.push("in");
    }
    this.state = {
      sectionBodyClassnames: sectionBodyClassnames,
      open: false
    };

    _.bindAll(this, ['toggleContent', "openNewTaskModal"]);
  }

  toggleContent(event) {
    if (event) {
      event.preventDefault();
    }

    var sectionBodyClassnames = this.state.sectionBodyClassnames;
    if (sectionBodyClassnames.indexOf("in") >= 0) {
      sectionBodyClassnames = _.without(sectionBodyClassnames, "in");
    } else {
      sectionBodyClassnames.push("in");
    }

    this.setState({sectionBodyClassnames: sectionBodyClassnames, open: !this.state.open});
    this.props.selectElement(undefined);
  }

  openNewTaskModal(event) {
    if (event) {
      event.preventDefault();
    }

    this.props.openNewTaskModal(this.props.element);
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

    var sectionBodyClassnames = this.state.sectionBodyClassnames;
    var toggleClassnames = ["section-header-title"];

    if (sectionBodyClassnames.indexOf("in") == -1) {
      toggleClassnames.push("collapsed");
    }
      console.log(this.state.open);


    var isSelected = this.props.selectedElement &&
                     this.props.selectedElement.id == this.props.element.id &&
                     this.props.selectedElement.type == this.props.element.type;

  	return (
			<div className={classnames({"deal-section-item": true, "deal-item-active": isSelected})}>
				<div className="deal-section__header">
          <a className={toggleClassnames.join(" ")} href="#" onClick={this.toggleContent}>{element.title}</a>
          <div className={classnames({"badge-chat-container": true, "hidden": element.comments_count == 0})}>
            <div className="badge-chat"><span>{element.comments_count}</span></div>
          </div>
        </div>
          <div className={sectionBodyClassnames.join(" ")}>
            <div className="deal-tasks">
              {displayedChildren}
            </div>
            <div className="deal-element-add-item deal-element-add-new-task">
              <span><i className="icon-icon-plus"></i> Add a new <a href="#" onClick={this.openNewTaskModal}>Task</a></span>
            </div>
          </div>
			</div>
  	);
  }
}
