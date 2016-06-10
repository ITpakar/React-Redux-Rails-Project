import React, { PropTypes } from 'react';
import CategorySection from "./CategorySection";
import CategoryTask from "./CategoryTask";
import CategoryFolder from "./CategoryFolder";
import CategoryDocument from "./CategoryDocument";
import CategoryElementDetails from "./CategoryElementDetails";

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

    this.state = {
      selectedElement: undefined
    }

    _.bindAll(this, ['selectElement']);
  }

  selectElement(element) {
    this.setState({selectedElement: element});
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
            <CategorySection element={element} selectElement={this.selectElement} isExpanding={i == 0} key={"section_" + (i + 1)} />
          );
        } else if (element.type == "Task") {
          displayedElement = (
            <CategoryTask element={element} selectElement={this.selectElement} key={"task_" + (i + 1)} />
          );
        } else if (element.type == "Folder") {
          displayedElement = (
            <CategoryFolder element={element} selectElement={this.selectElement} key={"folder_" + (i + 1)} />
          );
        } else if (element.type == "Document") {
          displayedElement = (
            <CategoryDocument element={element} selectElement={this.selectElement} key={"document_" + (i + 1)} />
          );
        }

        displayedElements.push(displayedElement);
      }
    }

    var selectedElementDetails;
    if (this.state.selectedElement) {
      selectedElementDetails = (
        <CategoryElementDetails element={this.state.selectedElement} />
      );
    }

  	return (
      <div className="content-deal-wrapper">
        <div className="content-deal-left">
      		<div className="deal-section" id="deal-sections">
            {displayedElements}
      		</div>
        </div>
        <div className="content-deal-right">
          {selectedElementDetails}
        </div>
      </div>
  	);
  }
}
