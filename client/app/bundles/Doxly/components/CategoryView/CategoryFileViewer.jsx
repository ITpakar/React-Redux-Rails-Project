import React, { PropTypes } from 'react';

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
	return (
		<div className="deal-section" id="deal-sections">
			<div className="deal-section-item">
				<div className="deal-section__header">
                    <a role="button" data-toggle="collapse" data-parent="#deal-sections" href="#section-id-1-body" aria-expanded="true" aria-controls="section-id-1-body">CORPORATE STRUCTURE, EQUITY CAPITAL &amp; RECORDS</a>
                </div>
                <div className="deal-section__panel collapse in">
                </div>
			</div>
		</div>
	);
  }
}