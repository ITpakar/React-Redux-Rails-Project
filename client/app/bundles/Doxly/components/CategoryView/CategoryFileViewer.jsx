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
  render() {
    var elements = this.props.elements;
    var displayedElements = [];

    if (elements) {
      for (let i = 0; i < elements.length; i++) {
        let element = elements[i];
        let displayedElement;

        if (element.type == "Section") {
          displayedElement = (
            <CategorySection element={element} />
          );
        } else if (element.type == "Folder") {
          displayedElement = (
            <CategoryFolder element={element} />
          );
        } else if (element.type == "Document") {
          displayedElement = (
            <CategoryDocument element={element} />
          );
        }

        displayedElements.push(displayedElement);
      }
    }

  	return (
  		<div className="deal-section" id="deal-sections">
        {displayedElements}
  		</div>
  	);
  }
}
