class Timecard.Views.WorkloadsTimerButton extends Backbone.View

  template: JST['workloads/timer_button']

  el: '.timer-button__container'

  events:
    'click .timer-button--start': 'startTimer'
    'click .timer-button--stop': 'stopTimer'
    'click .crowdworks-form__submit': 'addCrowdworksPassword'

  initialize: (@options) ->
    @issue = @options.issue

  render: ->
    @$el.html(@template(issue: @issue))
    @

  startTimer: (e) ->
    e.preventDefault()
    model = @collection.findWhere(end_at: null)
    if model?
      model.set('end_at', new Date())
      issue = @issue.collection.get(model.get('issue').id)
      if issue?
        issue.set('is_running', false)
      Workload.stop()
    @collection.create {start_at: new Date()},
      url: '/issues/'+@issue.id+'/workloads'
      success: (model) =>
        @viewWorkloadsTimer = new Timecard.Views.WorkloadsTimer(model: model, issues: @issue.collection)
        @viewWorkloadsTimer.render()
        @issue.set('is_running', true)
        $('.timer').removeClass('timer--off')
        $('.timer').addClass('timer--on')

  stopTimer: (e) ->
    e.preventDefault()
    if @issue.get('is_crowdworks') is true
      password = sessionStorage.getItem('crowdworks_password')
      if password?
        attrs = {end_at: new Date(), password: password}
        @updateWorkload(attrs)
      else
        @$('.crowdworks-form__modal').modal('show')
    else
      attrs = {end_at: new Date()}
      @updateWorkload(attrs)

  addCrowdworksPassword: ->
    password = @$('.crowdworks-form__password').val()
    remember_me = @$('.crowdworks-form__remember-me').prop('checked')
    attrs = {end_at: new Date(), password: password}
    if remember_me
      sessionStorage.setItem('crowdworks_password', password)
    @updateWorkload(attrs)

  updateWorkload: (attrs) ->
    model = @collection.findWhere(end_at: null)
    model.save attrs,
      success: (model) =>
        Workload.stop()
        @issue.set('is_running', false)
        $('.timer').removeClass('timer--on')
        $('.timer').addClass('timer--off')
