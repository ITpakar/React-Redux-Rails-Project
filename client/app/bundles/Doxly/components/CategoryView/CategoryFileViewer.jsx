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
    _.bindAll(this, ["openSectionModal"]);
  }

  openSectionModal(event) {
    if (event) {
      event.preventDefault();
    }

    this.props.openSectionModal();
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
                             selectedElement={this.props.selectedElement}
                             updateTask={this.props.updateTask}
                             openDocumentModal={this.props.openDocumentModal}
                             openFolderModal={this.props.openFolderModal}
                             openTaskModal={this.props.openTaskModal}
                             isExpanding={i == 0}
                             key={"section_" + (i + 1)} />
          );
        } else if (element.type == "Task") {
          displayedElement = (
            <CategoryTask element={element}
                          selectElement={this.props.selectElement}
                          selectedElement={this.props.selectedElement}
                          updateTask={this.props.updateTask}
                          openDocumentModal={this.props.openDocumentModal}
                          openFolderModal={this.props.openFolderModal}
                          openTaskModal={this.props.openTaskModal}
                          key={"task_" + (i + 1)} />
          );
        } else if (element.type == "Folder") {
          displayedElement = (
            <CategoryFolder element={element}
                            selectElement={this.props.selectElement}
                            selectedElement={this.props.selectedElement}
                            openDocumentModal={this.props.openDocumentModal}
                            key={"folder_" + (i + 1)} />
          );
        } else if (element.type == "Document") {
          displayedElement = (
            <CategoryDocument element={element}
                              selectElement={this.props.selectElement}
                              selectedElement={this.props.selectedElement}
                              key={"document_" + (i + 1)} />
          );
        }

        displayedElements.push(displayedElement);
      }
    }

    var createSectionButton;
    if (this.props.can_update) {
      createSectionButton = (
        <div className="deal-element-add-item deal-element-add-new-section">
          <a href="#" onClick={this.openSectionModal}><i className="icon-icon-plus"></i> Add a Section</a>
        </div>
      );
    }

  	return (
      <div className="deal-section" id="deal-sections">
        {displayedElements}
        {createSectionButton}
      </div>
  	);
  }
}
