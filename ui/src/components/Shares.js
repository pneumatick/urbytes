import React from 'react';

export default class Shares extends React.Component {
    constructor(props) {
        super(props);
        this.state = {};

        this.getShares = this.getShares.bind(this);
    }

    componentDidMount() {
        this.getShares().then(
            (result) => {
                console.log(result.shares);
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

    render() {
        return (
            <div className='Shares'>
                <h2>Shares</h2>
            </div>
        );
    }
}