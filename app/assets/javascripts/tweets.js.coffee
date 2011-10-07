# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  update_count = ->
    charCount = $("#tweet_message").val().length;
    if charCount <= 140
      $("#charcount").removeClass('charwarning').html((140 - charCount) + ' characters left');
    else
      $("#charcount").addClass('charwarning').html((charCount - 140) + ' character too long');

  $('#tweet_message').keyup(update_count)

  $(".shorten").click( ->
    $("#spinner").show()
    $.get("/tweets/shorten.json?url=" + $("#tweet_long_url").val(), (data) ->
      $("#spinner").hide()
      if data.error
        $("#shortenerr").html(data.error).show()
      else
        $("#shorten_error").hide()
        $("#tweet_message").val(data.title + ' ' + data.short_url)
        $("#tweet_long_url").val(data.long_url)
        update_count()
    )
  )

