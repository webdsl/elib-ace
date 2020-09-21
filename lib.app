module elib/elib-ace/lib

section ace editor

  // https://github.com/ajaxorg/ace/wiki/Embedding---API

  // usage:
  // form{
  //   codeEditor(foo.code, "foo", false) // to edit text value of foo.code, use "foo" once per page
  // }

  // make sure to add the following to css
  //   #editor<foo> {
  //     position: relative;
  //     width: 100%;
  //     height: 300px;
  //     border: 1px solid black;
  //   }

  define requireACE(lang : String){
    includeJS( IncludePaths.jQueryJS() )
    includeJS("src/ace.js?1")
    includeJS("src/mode-plain_text.js?1")
    includeJS("src/mode-" + lang + ".js?1")
    includeJS("src/theme-eclipse.js?1")
    includeJS("initACE.js?4")
  }

  define ace(code: Ref<Text>, lang : String){
    ace(code, lang, id, false)
  }

  define ace(code: Ref<Text>, lang : String, readonly: Bool){
    ace(code, lang, id, readonly)
  }

  define ace(code: Ref<Text>, lang : String, idAttr: String){
    ace(code, lang, idAttr, false)
  }

  define aceView(code: Ref<Text>, lang : String){
    ace(code, lang, id, true)
  }

  define aceView(code: Ref<Text>, lang : String, idAttr: String){
    ace(code, lang, idAttr, true)
  }


  // 619px; height: 500px
  // todo: adapt size to window document.documentElement.clientWidth
  define ace(code: Ref<Text>, lang : String, idAttr: String, readonly: Bool){
    var normalizedLang := getAceLanguageId(lang)
    requireACE(normalizedLang)
    div[class="editorContainer"]{
      div[class="aceEditor", id="aceEditor_" + idAttr,
      style="border: 1px solid #999;"
      ]{
        output(code)
      }
    }
    input(code)[style="display:none",id=idAttr]
    <script>
      $(document).ready( function(){
        createAceEditor('~idAttr', ~readonly, '~normalizedLang')
      } );
    </script>
  }

  template inputAce(code : Ref<String>, aceLang: String){

    requireACE(aceLang)
    div[class="ace-single-line", id="aceEditor_"+id, style="border: 1px solid #999;"]{
      output(code)
    }
    span[style="display:none", id=id]{
      input(code)
    }

    <script>
      var el = document.getElementById("aceEditor_~id")
      var editor = ace.edit(el);
      editor.setOptions({
        maxLines: 1, // make it 1 line
        autoScrollEditorIntoView: true,
        highlightActiveLine: false,
        printMargin: false,
        showGutter: false,
        mode: "ace/mode/~aceLang",
        theme: "ace/theme/tomorrow"
      });
      // remove newlines in pasted text
      editor.on("paste", function(e){
        e.text = e.text.replace(/[\r\n]+/g, " ");
      });
      var textinput = document.getElementById("~id").childNodes[0];
      editor.getSession().on('change', function(){
        textinput.value = editor.getSession().getValue();
      });
      // make mouse position clipping nicer
      editor.renderer.screenToTextCoordinates = function(x, y){
        var pos = this.pixelToScreenCoordinates(x, y);
        return this.session.screenToDocumentPosition(
        Math.min(this.session.getScreenLength() - 1, Math.max(pos.row, 0)),
        Math.max(pos.column, 0)
        );
      };
      // disable Enter Shift-Enter keys
      editor.commands.bindKey("Enter|Shift-Enter", "null")

    </script>

  }

function getAceLanguageId( language: String ): String {
  case( language.toLowerCase() ){
    "scala"    { return "scala"; }
    "scala212" { return "scala"; }
    "java"     { return "java"; }
    "java8"    { return "java"; }
    "c"        { return "c_cpp"; }
    "js"       { return "javascript"; }
    "sql"      { return "sql"; }
    "css"      { return "css"; }
    "html"     { return "html"; }
    "python"   { return "python"; }
    "python2"  { return "python"; }
    "python3"  { return "python"; }
    default    { return language.toLowerCase(); }
  }
}