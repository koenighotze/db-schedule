let DepartureBoard = {
  init(socket, containerId) {
    let container = document.getElementById(containerId)

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

    channel.on("not_found", ({message}) => {
      let item = document.createElement("div")
      item.innerHTML =  `<i>${message}</i>`
      container.appendChild(item)
    })
  }
}

export default DepartureBoard
