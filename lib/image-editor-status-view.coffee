{$, View} = require 'atom-space-pen-views'
{CompositeDisposable} = require 'atom'
ImageEditor = require './image-editor'

module.exports =
class ImageEditorStatusView extends View
  @content: ->
    @div class: 'status-image inline-block', =>
        @div class: 'status-image inline-block', =>
          @span class: 'image-size', outlet: 'imageSizeStatus'
        @div class: 'status-image inline-block', =>
          @button 'Center', class: 'btn btn-xs', outlet: 'scrollCenter'

  initialize: (@statusBar) ->
    @disposables = new CompositeDisposable
    @attach()

    @disposables.add atom.workspace.onDidChangeActivePaneItem =>
      @checkCurrentEditor()

    @scrollCenter.on 'click', =>
      @editorView.emitter.emit 'scroll-center'

  attach: ->
    @statusBar.addLeftTile(item: this)

  attached: ->
    @checkCurrentEditor()

  checkCurrentEditor: ->
    editor = atom.workspace.getActivePaneItem()
    if editor instanceof ImageEditor
      @updateImageSize()
      @show()
    else
      @hide()

  getImageSize: ({originalHeight, originalWidth}) ->
    @imageSizeStatus.text("#{originalWidth}x#{originalHeight}")

  updateImageSize: ->
    @imageLoadDisposable?.dispose()

    editor = atom.workspace.getActivePaneItem()
    @editorView = $(atom.views.getView(editor)).view()
    @getImageSize(@editorView) if @editorView.loaded
    @imageLoadDisposable = @editorView.onDidLoad =>
      if editor is atom.workspace.getActivePaneItem()
        @getImageSize(@editorView)
