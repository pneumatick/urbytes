import './App.css';
import Urbit from "@urbit/http-api";

import React from 'react';
import "bootstrap/dist/css/bootstrap.min.css";
//import "react-day-picker/lib/style.css";
import TextareaAutosize from "react-textarea-autosize";
import Button from "react-bootstrap/Button";
import Card from "react-bootstrap/Card";
import Stack from "react-bootstrap/Stack";
import Tab from "react-bootstrap/Tab";
import Tabs from "react-bootstrap/Tabs";
import ToastContainer from "react-bootstrap/ToastContainer";
import Toast from "react-bootstrap/Toast";
import Spinner from "react-bootstrap/Spinner";
import CloseButton from "react-bootstrap/CloseButton";
import Modal from "react-bootstrap/Modal";
//import DayPickerInput from "react-day-picker/DayPickerInput";
import endOfDay from "date-fns/endOfDay";
import startOfDay from "date-fns/startOfDay";
import { BottomScrollListener } from "react-bottom-scroll-listener";

import Feed from './components/Feed';
import Bites from './components/Bites';
import Likes from './components/Likes';
import Shares from './components/Shares';
import Following from './components/Following';
import Followers from './components/Followers';

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      status: null
    };

    window.urbit = new Urbit("");
    window.urbit.ship = window.ship;
    window.urbit.onOpen = () => this.setState({status: "con"});
    window.urbit.onRetry = () => this.setState({status: "try"});
    window.urbit.onError = (err) => this.setState({status: "err"});
    //this.init();

    this.subscribe = this.subscribe.bind(this);
  }

  subscribe() {
    try {
      window.urbit.subscribe({
        app: "urbytes",
        path: "/ui",
        event: this.handleUpdate,
        err: () => this.setErrorMsg("Subscription rejected"),
        quit: () => this.setErrorMsg("Kicked from subscription"),
      });
    } catch {
      this.setErrorMsg("Subscription failed");
    }
  }

  render() {
    return (
      <div className="App">
        <header className="App-header">
          <h1>%urbytes</h1>
        </header>
        <Feed subscribe={this.subscribe} />
        <Bites subscribe={this.subscribe} />
        <Likes subscribe={this.subscribe} />
        <Shares subscribe={this.subscribe} />
        <Following subscribe={this.subscribe} />
        <Followers subscribe={this.subscribe} />
      </div>
    );
  }
}

export default App;
