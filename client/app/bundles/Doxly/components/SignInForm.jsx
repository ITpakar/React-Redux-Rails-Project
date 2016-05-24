import React, { PropTypes } from 'react';
import _ from 'lodash';
import actions from '../actions/doxlyActions'

export default class SignInForm extends React.Component {
  static propTypes = {}

  constructor(props, context) {
    super(props, context);

    // Uses lodash to bind all methods to the context of the object instance, otherwise
    // the methods defined here would not refer to the component's class, not the component
    // instance itself.
    _.bindAll(this, 'handleSubmit');
  }

  handleSubmit(e) {
    console.log(e);
    e.preventDefault();
  }

  render() {
    return (
      <div className="panel panel-window">
        <form role="form" onSubmit={this.handleSubmit}>
          <div className="form-group">
            <label htmlFor="input-email">Email Address</label>
            <input type="email" name="email" id="input-email" className="form-control" placeholder="example@doxly.com" required />
          </div>
          <div className="form-group">
            <label htmlFor="input-password">Password</label>
            <input type="password" name="password" id="input-password" className="form-control" placeholder="Required" required />
          </div>
          <div className="container-fluid">
            <div className="row">
              <div className="col-xs-6">
                <div className="form-group">
                  <div className="checkbox i-checks-box"><label> <input type="checkbox" /><i /> Remember Me </label></div>
                </div>
              </div>
              <div className="col-xs-6 text-right">
                <input type="submit" className="btn btn-primary" value="Sign In"></input>
              </div>
            </div>
          </div>
        </form>
      </div>
    );
  }
}