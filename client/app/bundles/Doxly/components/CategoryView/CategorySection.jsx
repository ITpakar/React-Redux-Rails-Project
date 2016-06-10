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
      sectionBodyClassnames: sectionBodyClassnames
    };

    _.bindAll(this, ['toggleContent']);
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

    this.setState({sectionBodyClassnames: sectionBodyClassnames});
    this.props.selectElement(undefined);
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
      }

      displayedChildren.push(displayedChild);
    }

    var sectionBodyClassnames = this.state.sectionBodyClassnames;
    var toggleClassnames = ["section-header-title"];

    if (sectionBodyClassnames.indexOf("in") == -1) {
      toggleClassnames.push("collapsed");
    }

  	return (
			<div className="deal-section-item">
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
        </div>
			</div>
  	);
  }
}
