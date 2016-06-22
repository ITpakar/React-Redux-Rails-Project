import React from 'react';
import _ from 'lodash';

import ClosingBookSection from './ClosingBookSection';
import ClosingBookTask from './ClosingBookTask';
import ClosingBookFolder from './ClosingBookFolder';
import ClosingBookDocument from './ClosingBookDocument';

export default class ClosingBookFileViewer extends React.Component {
  constructor(props, context) {
    super(props, context);

    let _state = {}
    let _selectedDocuments = []

    let queue = this.props.elements.slice(0);
    while (queue.length > 0) {
      let element = queue.shift();

      _state[element.type + '_' + element.id] = true;

      if (element.type == "Document") {
        _selectedDocuments.push(element.id)
      }

      if (element.elements) {
        queue = queue.concat(element.elements);
      }
    }

    this.state = {
      selected: _state,
      selectedDocuments: _selectedDocuments
    }

    _.bindAll(this, 'selectItem');
  }

  componentWillUnmount() {
    this.props.pushSelectedDocuments(this.state.selectedDocuments);
  }

  selectItem(type, id) {
    let _this = this;

    return function(event) {
      event.preventDefault();

      // Run BFS to find the element we want
      let queue = _.cloneDeep(_this.props.elements);
      let element = null;
      while (queue.length > 0 && element === null) {
        let _element = queue.shift()

        if (_element.type == type && _element.id == id) {
          element = _element;
        } else {
          if (_element.elements) {
            queue = queue.concat(_element.elements)
          }
        }
      }

      if (element === null) {
        return;
      }

      let currentlySelected = _this.state.selected[element.type + "_" + element.id];
      let selectedDocuments = _this.state.selectedDocuments.slice(0);
      let state = _.clone(_this.state.selected);
      
        // Run a breadth-first traversal and change all children
        state[element.type + '_' + element.id] = !currentlySelected;
        
        if (element.elements) {
          queue = element.elements

          while (queue.length > 0) {
            let element = queue.shift();

            state[element.type + '_' + element.id] = !currentlySelected;

            if (element.elements) {
              queue = queue.concat(element.elements);
            }

            if (element.type == "Document") {
              if (currentlySelected) {
                // Remove from selected children array 
                selectedDocuments = _.without(selectedDocuments, element.id);
              } else {
                selectedDocuments.push(element.id);
              }
            }
          }
        }

      _this.setState({selected: state, selectedDocuments: selectedDocuments});
    }
  }

  render() {
    let elements = this.props.elements;
    let displayedElements = [];

    if (elements) {
      for (let i = 0; i < elements.length; i++) {
        let element = elements[i];
        let displayedElement;

        if (element.type == "Section") {
          displayedElement = (
            <ClosingBookSection element={element}
                               isExpanding={true}
                               selectItem={this.selectItem}
                               selected={this.state.selected}
                               key={"section_" + (i + 1)} />
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