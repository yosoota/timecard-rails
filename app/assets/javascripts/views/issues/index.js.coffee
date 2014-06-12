class Timecard.Views.IssuesIndex extends Backbone.View

  template: JST['issues/index']

  el: '.issues-index'

  initialize: (@options) ->
    @collection = new Timecard.Collections.Issues

  render: ->
    @$el.html(@template(project_id: @options?.project_id))
    if @options?.project_id?
      @viewIssuesStatusButton = new Timecard.Views.IssuesStatusButton(project_id: @options.project_id, collection: @collection)
      @collection.url = '/projects/'+@options.project_id+'/issues'
    else
      @viewIssuesStatusButton = new Timecard.Views.IssuesStatusButton(collection: @collection)
      @collection.url = '/api/my/issues'

    @viewIssuesStatusButton.render()
    @collection.fetch
      success: (collection) =>
        @viewIssuesList = new Timecard.Views.IssuesList(collection: collection, workloads: @options.workloads)
        @viewIssuesList.render()
    @
