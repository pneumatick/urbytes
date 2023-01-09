import React from 'react';

export default class Shares extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            shares: []
        };

        this.getShares = this.getShares.bind(this);
        this.handleUpdate = this.handleUpdate.bind(this);

        this.getShares().then(
            (result) => {
                this.handleUpdate(result);
                this.props.subscribe();
            }
        );
    }

    async getShares() {
        const startIdx = 0;
        const endIdx = 0;
        const path = `/shares/between/${startIdx}/${endIdx}`;
        return window.urbit.scry({
            app: "urbytes",
            path: path,
        });
    }

    handleUpdate(upd) {
        this.setState({ shares: this.state.shares.concat(upd.shares) });
    }

    render() {
        let shares = [];

        this.state.shares.forEach((share, idx) => {
            shares.push(
                <div className='share' key={idx}>
                    <p>Source: {share[0]}</p>
                    <p>ID: {share[1]}</p>
                </div>
            );
        });

        return (
            <div className='Shares'>
                <h2>Shares</h2>
                {shares}
            </div>
        );
    }
}