import './App.css';
import Urbit from "@urbit/http-api";
import React from 'react';


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
