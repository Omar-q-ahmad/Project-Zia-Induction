// Generated by CoffeeScript 1.6.2
$(document).ready(function() {
  var history, _ffd, _index;

  _index = window.location.href.indexOf('#!');
  if (_index > -1) {
    _ffd = window.location.href.slice(45);
    console.log(_ffd);
    history = history || window.history;
    history.pushState("Page-" + _ffd, null, window.location.href.slice(0, 43));
    console.log("Shifting to forwarding page");
    T.navigate(_ffd.toString());
  }
  T.handleLoading();
  T.init();
  $(document).on('click', '.runAction', function(e) {
    var _action, _target;

    _action = $(this).attr('data-action');
    _target = $(this).attr('data-target');
    T.actions(_action, _target);
    return null;
  });
  $(document).on('click', '.btn-hex', function(e) {
    var _target;

    e.preventDefault();
    _target = $(this).attr('href');
    console.log(_target);
    T.navigate(_target.toString());
    $(".overlay").hide();
    return null;
  });
  $(document).on('click', '.tagBinMain', function(e) {
    return $(".overlay").fadeIn();
  });
  $(document).on('click', '.song', function(e) {
    T.Music.onSongClick($(this).attr('data-id'), $(this));
    return console.log("MUSIC: Song Clicked");
  });
  return null;
});
