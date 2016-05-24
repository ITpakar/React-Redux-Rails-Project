import React, { PropTypes } from 'react';
import _ from 'lodash';
import actions from '../actions/doxlyActions'

export default class LoginForm extends React.Component {
  static propTypes = {}

  constructor(props, context) {
    super(props, context);

    // Uses lodash to bind all methods to the context of the object instance, otherwise
    // the methods defined here would not refer to the component's class, not the component
    // instance itself.
    _.bindAll(this, 'handleSubmit');
  }

  handleSubmit(e) {

  }

  render() {

  }
}