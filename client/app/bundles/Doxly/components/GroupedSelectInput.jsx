import React, { PropTypes } from 'react';
import _ from 'lodash';
import ReactDOM from 'react-dom';

export default class GroupedSelectInput extends React.Component {

  static propTypes = {
    options: PropTypes.arrayOf(PropTypes.shape({
      heading: PropTypes.string,
      options: PropTypes.array,
      optionsForHeading: PropTypes.array,
      initialSelected: PropTypes.number,
      onChange: PropTypes.function
    }))
  }

  constructor(props, context) {
    super(props, context);

    // This will set the initially selected element
    // Either specified in props or we pick the first element
    let selected = _.map(this.props.options, function(option, index) {
      if (option.initialSelected) {
        return option.initialSelected;
      } else {
        return 0;
      }
    });

    this.state = {
      selected: selected,
      expanded: false
    }

    _.bindAll(this, ['togglePanel', 'closePanel']);
  }

  handleChange(group, option) {
    var that = this;
    return function (e) {
      let state = that.state;
      state.selected[group] = option;
      that.setState(state);

      let selected_value = that.props.options[group].options[option];
      that.props.options[group].onChange(selected_value);

      e.preventDefault();
    }
  }

  togglePanel() {
    this.setState({expanded: !this.state.expanded});
  }

  closePanel(e) {
    // We need to make sure that we aren't actually clicking
    // on the component!
    const clickedArea = ReactDOM.findDOMNode(this.refs.dropdown)

    if (!clickedArea.contains(e.target)) {
      this.setState({expanded: false})
    }
  }

  componentWillMount() {
    document.addEventListener('click', this.closePanel, false);
  }

  componentWillUnmount() {
    document.removeEventListener('click', this.closePanel, false);
  }

  isChecked(group, option) {
    return this.state.selected[group] === option;
  }

  renderText() {
    return `${this.props.options[0].optionsForHeading[this.state.selected[0]]} by ${this.props.options[1].optionsForHeading[this.state.selected[1]]}`
  }

  renderGroup(options, index) {
    var that = this;
    return (
      <div key={index}>
        <li className="title">{options.heading}</li>
        {_.map(options.options, function(option, i) {
          return <SelectOption checked={that.isChecked(index, i)} text={option} handleClick={that.handleChange(index, i)} index={i}/>
        })}
      </div>
    );
  }

  render() {
    let that = this;
    let expanded = this.state.expanded ? 'open' : 'closed'
    return (
      <div className={`dropdown dropdown-filter ${expanded}`} ref="dropdown">
        <a href="#" className="dropdown-toggle" onClick={this.togglePanel}>{that.renderText()}</a>

        <ul className="dropdown-menu">
          {_.map(this.props.options, function(options, index) {
            return that.renderGroup(options, index);
          })}
        </ul>
      </div>
    );
  }
}


class SelectOption extends React.Component {

    render() {

      return (
        <li key={`select-input-${this.props.index}`}>
          <div className="checkbox">
            <label onClick={this.props.handleClick}>
              <i className={this.props.checked ? 'fa fa-check' : 'fa fa-fw'}></i> {this.props.text}
            </label>
          </div>
        </li>
      );
    }
  }