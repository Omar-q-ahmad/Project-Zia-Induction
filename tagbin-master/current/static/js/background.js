// Generated by CoffeeScript 1.6.2
chrome.app.runtime.onLaunched.addListener(function() {
  return chrome.app.window.create('index.html', {
    "bounds": {
      "width": 800,
      "height": 450
    }
  }, function(win) {
    return win.maximize();
  });
});

chrome.app.window.current().onClosed = function(e) {
  console.log("Destroying socket: " + T.activeSocketID.toString());
  chrome.socket.destroy(T.activeSocketID);
  return chrome.serial.close(T.serial.connId, function(result) {
    return console.log("Closing Serial Port: " + T.serial.DEVICE_PORT);
  });
};
