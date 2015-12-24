import {Socket} from "phoenix"

export default class Experiment {
    constructor(topic, type, token, root) {
        this.socket = new Socket("/experiment")
        this.socket.connect({token: token, type: type})
        this.chan = this.socket.chan(topic, {})
        this.chan.join().receive("ok", resp => {})
        this.chan.on("update", payload => {
            root.setState(payload.body)
        })
    }

    send_data(data) {
        this.chan.push("client", {body: data})
    }
}
