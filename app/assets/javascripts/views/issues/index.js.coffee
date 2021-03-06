class Timecard.Views.IssuesIndex extends Backbone.View

  template: JST['issues/index']

  el: '.issues-index'

  initialize: (@options) ->
    @issues = @options.issues

  render: ->
    @$el.html(@template(project_id: @options?.project_id))
    if @options?.project_id?
      @viewIssuesStatusButton = new Timecard.Views.IssuesStatusButton(project_id: @options.project_id, collection: @issues)
      @issues.url = '/api/my/projects/'+@options.project_id+'/issues'
    else
      @viewIssuesStatusButton = new Timecard.Views.IssuesStatusButton(collection: @issues)
      @issues.url = '/api/my/issues'

    @viewIssuesStatusButton.render()
    new Timecard.Views.IssuesLoading
    @issues.fetch
      success: (collection) =>
        @viewIssuesList = new Timecard.Views.IssuesList(collection: collection, workloads: @options.workloads)
        @viewIssuesList.render()
    @
