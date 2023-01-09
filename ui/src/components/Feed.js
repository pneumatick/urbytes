import React from 'react';

export default class Feed extends React.Component {
    constructor(props) {
        super(props);
        this.state = { 
            entries: []
        };

        this.getFeed = this.getFeed.bind(this);
        this.handleUpdate = this.handleUpdate.bind(this);

        this.getFeed().then(
            (result) => {
                this.handleUpdate(result);
                this.props.subscribe();
            }
        );
    }

    async getFeed() {
        const { entries } = this.state;
        const startIdx = entries.length === 0 ? 0 : entries.length - 1;
        const endIdx = startIdx + 10;
        const path = `/feed/between/${startIdx}/${endIdx}`;
        return window.urbit.scry({
            app: "urbytes",
            path: path,
        });
    }

    handleUpdate(upd) {
        this.setState({ entries: this.state.entries.concat(upd.entries) });
    }

    render() {
        let bites = [];
        let entries = this.state.entries;

        for (let i = 0; i < entries.length; i++) {
            let source = entries[i].source;
            let bite = entries[i].bite;
            bites.push(<div className='Feed-bite' key={i}>
                <p>Source: {source}</p>
                <p>Date: {bite.date}</p>
                <p>{bite.content}</p>
                <p>Likes: {bite.likes}</p>
                <p>Shares: {bite.shares}</p>
                <p>Comments: {bite.comments}</p>
            </div>);
        }

        return (
            <div className='Feed'>
                <h2>Feed</h2>
                {bites}
            </div>
        );
    }
}