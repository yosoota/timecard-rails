class Timecard.Views.HomeMain extends Backbone.View

  template: JST['home/main']

  el: '.contents'

  initialize: (@options) ->
    @projects = new Timecard.Collections.Projects

  render: ->
    @$el.html(@template())
    if @options?.project_id?
      @viewIssuesIndex = new Timecard.Views.IssuesIndex(project_id: @options.project_id, workloads: @options.workloads)
    else
      @viewIssuesIndex = new Timecard.Views.IssuesIndex(workloads: @options.workloads)
    @viewIssuesIndex.render()
    @
