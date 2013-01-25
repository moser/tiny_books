# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $(".datepicker").datepicker({ dateFormat: "yy-mm-dd" })
  $(".increase_voucher_number").click (e) ->
    target = $(e.target).siblings('input.voucher_number')
    target.val(parseInt(target.val()) + 1)
  $(".template").click (e) ->
    target = $(e.target)
    data = JSON.parse(target.attr("data-json"))
    _.each _.keys(data), (key) ->
      $("#booking_#{key}").val(data[key])
