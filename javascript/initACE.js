function createAceEditor(id, readonly, mode) {
  var m = require("ace/mode/" + mode) || require("ace/mode/plain_text");
  aceEditor(id, readonly, m.Mode);
}

var aceEditorInstances = [];
function aceEditor(id, readonly, mode) {
  console.log("initializing editor: " + id);
  var editor = ace.edit("aceEditor_" + id);
  aceEditorInstances.push(editor);
  editor.setTheme("ace/theme/eclipse");

  editor.getSession().setMode(new mode());

  editor.setShowPrintMargin(false);

  console.log('readonly: ' + readonly);

  if (readonly) {
    console.log('setting editor to readonly');
    editor.setReadOnly(true);
  } else {
    if(editor.getSession().getMode().$id.indexOf("python") > -1){
      editor.getSession().setTabSize(4);
    } else {
      editor.getSession().setTabSize(2);
    }

    var textarea = document.getElementById(id);
    editor.getSession().on('change', function() {
      var value = editor.getSession().getValue();
      textarea.textContent = value;
      checkForUnsupportedCharacters( value );
    });
  }


  // add command for all new editors
  var dom = require("ace/lib/dom")
  editor.commands.addCommand({
    name: "Toggle Fullscreen",
    bindKey: "Alt-Return|F11",
    exec: function(editor) {
      dom.toggleCssClass(document.body, "fullScreen")
      dom.toggleCssClass(editor.container, "fullScreen-editor")
      editor.resize()
    }
  });
    if(save){
    editor.commands.addCommand({
      name : "save",
      bindKey : {
        win : "Ctrl-S|Alt-S",
        mac : "Command-S|Alt-S|Ctrl-S",
        sender : "editor" + id
      },
      exec : save
    });
    }
    if(runUserTest){
    editor.commands.addCommand({
      name : "run user test",
      bindKey : {
        win : "Alt-R",
        mac : "Alt-R|Ctrl-R",
        sender : "editor" + id
      },
      exec : runUserTest
    });
    }
    if(runSpecTest){
    editor.commands.addCommand({
      name : "run spec test",
      bindKey : {
        win : "Alt-Shift-R",
        mac : "Alt-Shift-R|Ctrl-Shift-R",
        sender : "editor" + id
      },
      exec : runSpecTest
    });
    }


  console.log("initialized editor: " + id);
}

function resizeAceEditors(){
  aceEditorInstances.forEach(function(editor) {
      editor.resize();
  });
}

/**
 * Determines whether any Ace editor has unsaved changes.
 *
 * @returns True when there are unsaved changes; otherwise, false.
 */
function aceHasUnsavedChanges(){
  if(typeof aceEditorInstances !== 'undefined'){
      var unsavedChanges = false;
      aceEditorInstances.forEach(function(editor) {
      if(!unsavedChanges && ! editor.session.getUndoManager().isClean()){
        unsavedChanges = true;
      }
    });
    return unsavedChanges;
  } else {
    return false;
  }
}

/**
 * Sets all Ace editors to have no unsaved changes.
 */
function aceMarkClean() {
  aceEditorInstances.forEach(function(editor) {
    editor.session.getUndoManager().markClean();
  });
}

function aceOnChange(callback) {
  aceEditorInstances.forEach(function(editor) {
      editor.session.on('change', callback);
  })
}