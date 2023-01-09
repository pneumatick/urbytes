import React from 'react';

export default class Bites extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            bites: []
        };

        this.getBites = this.getBites.bind(this);
        this.handleUpdate = this.handleUpdate.bind(this);

        this.getBites().then(
            (result) => {
                this.handleUpdate(result);
                this.props.subscribe();
            }
        );
    }

    async getBites() {
        const { bites } = this.state;
        const startIdx = bites.length === 0 ? 0 : bites.length - 1;
        const endIdx = startIdx + 10;
        const path = `/bites/between/${startIdx}/${endIdx}`;
        return window.urbit.scry({
            app: "urbytes",
            path: path,
        });
    }

    handleUpdate(upd) {
        this.setState({ bites: this.state.bites.concat(upd.bites) });
    }

    render() {
        let bites = [];

        this.state.bites.forEach((bite, idx) => {
            bites.push(
                <div className='Bite' key={idx}>
                    <p>Date: {bite.date}</p>
                    <p>{bite.content}</p>
                    <p>Likes: {bite.likes}</p>
                    <p>Shares: {bite.shares}</p>
                    <p>Comments: {bite.comments}</p>
                </div>
            );
        });

        return (
            <div className='Bites'>
                <h2>Bites</h2>
                {bites}
            </div>
        );
    }
}