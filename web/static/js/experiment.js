import {Socket} from "phoenix"

let socket = new Socket("/experiment")
socket.connect()
let chan = socket.chan(_channel_topic, {}) // _channel_topic is provided by ExperimentController
chan.join().receive("ok", resp => {
  console.log("Joined succesffuly!", resp)
})

chann.on("update", payload => {
    _root.setState(payload.body)
})

function _send_data(data) {
    chan.push("update", data)
}
