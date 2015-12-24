import {Socket} from "phoenix"

export default class Experiment {
    constructor(topic, token, root) {
        this.socket = new Socket("/experiment")
        this.socket.connect(token)
        this.chan = this.socket.chan(topic, {})
        this.chan.join().receive("ok", resp => {})
        this.chan.on("update", payload => {
            root.setState(payload.body)
        })
    }

    send_data(data) {
        this.chan.push("update", data)
    }
}
