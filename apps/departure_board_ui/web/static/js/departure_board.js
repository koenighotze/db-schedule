let DepartureBoard = {
  init(socket) {
    let container = document.getElementById("board-container")

    socket.connect()

    let channel = socket.channel("departureboards:ready")
    channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) })
    channel.on("departureboard_ready", ({url, station_name}) => {
      console.log("Received " + url)
      let item = document.createElement("div")
      item.innerHTML =  `<a href='${url}' target="_parent">${station_name}</a>`
      container.appendChild(item)
    })

  }
}

export default DepartureBoard
