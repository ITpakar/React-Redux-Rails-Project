import React, { PropTypes } from 'react';
import CategorySection from "./CategorySection";
import CategoryTask from "./CategoryTask";
import CategoryFolder from "./CategoryFolder";
import CategoryDocument from "./CategoryDocument";

// Props
// elements = [
// 	{
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
// ]

export default class CategoryFileViewer extends React.Component {
  constructor(props, context) {
    super(props, context);
    _.bindAll(this, ["openNewSectionModal"]);
  }

  openNewSectionModal(event) {
    if (event) {
      event.preventDefault();
    }

    this.props.openNewSectionModal();
  }

  render() {
    var elements = this.props.elements;
    var displayedElements = [];

    if (elements) {
      for (let i = 0; i < elements.length; i++) {
        let element = elements[i];
        let displayedElement;

        if (element.type == "Section") {
          displayedElement = (
            <CategorySection element={element}
                             selectElement={this.props.selectElement}
                             updateTask={this.props.updateTask}
                             openNewDocumentModal={this.props.openNewDocumentModal}
                             openNewFolderModal={this.props.openNewFolderModal}
                             openNewTaskModal={this.props.openNewTaskModal}
                             isExpanding={i == 0}
                             key={"section_" + (i + 1)} />
          );
        } else if (element.type == "Task") {
          displayedElement = (
            <CategoryTask element={element}
                          selectElement={this.props.selectElement}
                          updateTask={this.props.updateTask}
                          openNewDocumentModal={this.props.openNewDocumentModal}
                          openNewFolderModal={this.props.openNewFolderModal}
                          openNewTaskModal={this.props.openNewTaskModal}
                          key={"task_" + (i + 1)} />
          );
        } else if (element.type == "Folder") {
          displayedElement = (
            <CategoryFolder element={element}
                            selectElement={this.props.selectElement}
                            openNewDocumentModal={this.props.openNewDocumentModal}
                            key={"folder_" + (i + 1)} />
          );
        } else if (element.type == "Document") {
          displayedElement = (
            <CategoryDocument element={element} selectElement={this.props.selectElement} key={"document_" + (i + 1)} />
          );
        }

        displayedElements.push(displayedElement);
      }
    }

  	return (
      <div className="deal-section" id="deal-sections">
        {displayedElements}
        <div className="deal-element-add-item deal-element-add-new-section">
          <span><i className="icon-icon-plus"></i> Add a new <a href="#" onClick={this.openNewSectionModal}>Section</a></span>
        </div>
      </div>
  	);
  }
}
