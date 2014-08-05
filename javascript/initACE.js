function scalaEditor(id, readonly) {
	aceEditor(id, readonly, require("ace/mode/scala").Mode);
}

function cEditor(id, readonly) {
	aceEditor(id, readonly, require("ace/mode/c_cpp").Mode);
}

function jsEditor(id, readonly) {
        aceEditor(id, readonly, require("ace/mode/javascript").Mode);
}

function javaEditor(id, readonly) {
    console.log("initACE java")
	aceEditor(id, readonly, require("ace/mode/java").Mode);
}
function sqlEditor(id, readonly) {
	aceEditor(id, readonly, require("ace/mode/sql").Mode);
}
function htmlEditor(id, readonly) {
	aceEditor(id, readonly, require("ace/mode/html").Mode);
}
function cssEditor(id, readonly) {
	aceEditor(id, readonly, require("ace/mode/css").Mode);
}

var autosaving = false;
var autosavedecided = true;
function aceEditor(id, readonly, mode) {
	console.log("initializing editor: " + id);
	var editor = ace.edit("editor" + id);
	editor.setTheme("ace/theme/eclipse");

	editor.getSession().setMode(new mode());

	editor.setShowPrintMargin(false);

	console.log('readonly: ' + readonly);

	if (readonly) {
		console.log('setting editor to readonly');
		editor.setReadOnly(true);
	} else {
		editor.getSession().setTabSize(2);
		
		//autosave is disabled
		
//		editor.getSession().on('change', function() {
//			console.log('id = ' + id);
//			var textarea = document.getElementById(id);
//			textarea.innerHTML = editor.getSession().getValue();
//			if(!autosavedecided){
//  				if(autosaving || confirm("Enable autosave?")){
//					autosaving = true;
//					setAutoSave();
//				}
//				autosavedecided = true;
//			}
//		});
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

	editor.commands.addCommand({
		name : "save",
		bindKey : {
			win : "Ctrl-S",
			mac : "Command-S",
			sender : "editor" + id
		},
		exec : save
	});

	
	console.log("initialized editor: " + id);
}

var onloadFuns = [];

window.onload = function() {
	for (f in onloadFuns) {
		onloadFuns[f]();
	}
}

function registerOnload(f) {
	onloadFuns[onloadFuns.length++] = f;
}

/* save */

function save() {
	$('#save').click();
}

/* timer for auto-save */
var autoSaveTimer;
function setAutoSave() {
	clearTimeout(autoSaveTimer);
	autoSaveTimer = setTimeout(function() {
		console.log("autosave...");
		save();
		setAutoSave();
	}, 60000);
}

///* toggle fullscreen on the ace editor that had the focus */
//function fullscreen(cmd, editor) {
//	var id = '#' + cmd.bindKey.sender
//	var fsDiv = '<div id="fsdiv" style="display:block"><div id="fsinner"></div></div>';
//	var fsMarker = '<div id="fsmarker"></div>';
//	if ($('#fsdiv').length > 0) {
//		// exit FS: move editor to marker, remove fsdiv and marker
//		$(id).insertAfter('#fsmarker');
//		$(id).toggleClass('aceEditorFull aceEditor');
//		$('#fsdiv').remove();
//		$('#fsmarker').remove();
//		$('#subcontain').show();
//		editor.resize();
//		editor.focus();
//	} else {
//		// enter FS: create marker, create fsdiv, reparent editor to fsdiv
//		$('#maincontainer').append(fsDiv);
//		$(id).parent().append(fsMarker);
//		$('#fsmarker').insertAfter($(id));
//		$('#fsinner').append($(id));
//		$(id).toggleClass('aceEditor aceEditorFull');
//		$('#subcontain').hide();
//		editor.resize();
//		editor.focus();
//	}
//}
