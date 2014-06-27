window.AjaxForm = (name) ->
  this.name = "#{name}-form"
  
AjaxForm.prototype.formElement = ->
  $("##{this.name}")
  
AjaxForm.prototype.submitElement = ->
  this.formElement().children("#submit")
  
AjaxForm.prototype.val = (selector) ->
  this.formElement().children(selector).val()

AjaxForm.prototype.check = ->
  this.uncheck()
  submit = this.submitElement()
  submit.val("#{submit.val()} ✓")

AjaxForm.prototype.uncheck = ->
  submit = this.submitElement()
  submit.val(submit.val().replace(" ✓", ""))
  
AjaxForm.prototype.ajax = (urlFunc) ->
  form = this
  form.formElement().submit ->
    form.uncheck()
    $.ajax("#{urlFunc()}&token=#{token}").done ->
      form.check()
    false
  
AjaxForm.subscribe = new AjaxForm("subscribe")
AjaxForm.hiding_rule = new AjaxForm("hiding-rule")
AjaxForm.share = new AjaxForm("share")